//
//  budgetWidget.swift
//  budgetWidget
//
//  Created by Zach Stucky on 8/2/23.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "", textSecondary: "", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text: "", textSecondary: "", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
        let text = userDefaultsShared?.value(forKey: "TEXT") ?? "No Text"
        let textSecondary = userDefaultsShared?.value(forKey: "SECONDARY") ?? "No Text"

        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: text as! String, textSecondary: textSecondary as! String, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
/*
struct Provider2: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text: "", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaultsShared = UserDefaults(suiteName: "group.thereisnowaythisistaken4532")
        let text = userDefaultsShared?.value(forKey: "SECONDARY") ?? "No Text"

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: text as! String, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
 */


struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let textSecondary: String
    let configuration: ConfigurationIntent
}

struct budgetWidgetEntryView : View {
    var entry: Provider.Entry
    //var entry2: Provider2.Entry

    var body: some View {
        ZStack {
            Color.black
            VStack {
                let oldString = entry.text.split(separator: "$").last
                let textNum = Double(oldString ?? "error") ?? 0
                if textNum > 0
                {
                    Text(entry.text)
                        .foregroundColor(Color.green)
                        .font(.system(size: 36))
                }
                else if textNum < 0
                {
                    Text(entry.text)
                        .foregroundColor(Color.red)
                        .font(.system(size: 36))
                }
                else
                {
                    Text(entry.text)
                        .foregroundColor(Color.white)
                        .font(.system(size: 36))
                }
                
                let oldStringSecondary = entry.textSecondary.split(separator: "$").last
                let textNumSecondary = Double(oldStringSecondary ?? "error") ?? 0
                if textNumSecondary > 0
                {
                    Text(entry.textSecondary)
                        .foregroundColor(Color.green)
                        .font(.system(size: 20))
                }
                else if textNumSecondary < 0
                {
                    Text(entry.textSecondary)
                        .foregroundColor(Color.red)
                        .font(.system(size: 20))
                }
                else
                {
                    Text(entry.textSecondary)
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                }
                 
                
            }
        }
    }
}

struct budgetWidget: Widget {
    let kind: String = "budgetWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            budgetWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
        }
    
    
    struct budgetWidget_Previews: PreviewProvider {
        static var previews: some View {
            budgetWidgetEntryView(entry: SimpleEntry(date: Date(), text: "Test", textSecondary: "test", configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
