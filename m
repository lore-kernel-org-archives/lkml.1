Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZDYE1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZDYE1x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 00:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZDYE0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 00:26:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZDYE0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 00:26:34 -0400
Message-Id: <20090425042632.320062940@goodmis.org>
References: <20090425042030.431477667@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 25 Apr 2009 00:20:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 4/5] tracing/events: reuse trace event ids after overflow
Content-Disposition: inline; filename=0004-tracing-events-reuse-trace-event-ids-after-overflow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With modules being able to add trace events, and the max trace event
counter is 16 bits (65536) we can overflow the counter easily
with a simple while loop adding and removing modules that contain
trace events.

This patch links together the registered trace events and on overflow
searches for available trace event ids. It will still fail if
over 65536 events are registered, but considering that a typical
kernel only has 22000 functions, 65000 events should be sufficient.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 +
 kernel/trace/trace_output.c  |   71 +++++++++++++++++++++++++++++++++++------
 2 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 07e0a6d..78a9ba2 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -56,6 +56,7 @@ typedef enum print_line_t (*trace_print_func)(struct trace_iterator *iter,
 					      int flags);
 struct trace_event {
 	struct hlist_node	node;
+	struct list_head	list;
 	int			type;
 	trace_print_func	trace;
 	trace_print_func	raw;
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 06997e7..5fc51f0 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -483,6 +483,36 @@ struct trace_event *ftrace_find_event(int type)
 	return NULL;
 }
 
+static LIST_HEAD(ftrace_event_list);
+
+static int trace_search_list(struct list_head **list)
+{
+	struct trace_event *e;
+	int last = __TRACE_LAST_TYPE;
+
+	if (list_empty(&ftrace_event_list)) {
+		*list = &ftrace_event_list;
+		return last + 1;
+	}
+
+	/*
+	 * We used up all possible max events,
+	 * lets see if somebody freed one.
+	 */
+	list_for_each_entry(e, &ftrace_event_list, list) {
+		if (e->type != last + 1)
+			break;
+		last++;
+	}
+
+	/* Did we used up all 65 thousand events??? */
+	if ((last + 1) > FTRACE_MAX_EVENT)
+		return 0;
+
+	*list = &e->list;
+	return last + 1;
+}
+
 /**
  * register_ftrace_event - register output for an event type
  * @event: the event type to register
@@ -505,20 +535,40 @@ int register_ftrace_event(struct trace_event *event)
 
 	mutex_lock(&trace_event_mutex);
 
-	if (!event) {
-		ret = next_event_type++;
+	if (WARN_ON(!event))
 		goto out;
-	}
 
-	if (!event->type)
-		event->type = next_event_type++;
-	else if (event->type > __TRACE_LAST_TYPE) {
+	INIT_LIST_HEAD(&event->list);
+
+	if (!event->type) {
+		struct list_head *list;
+
+		if (next_event_type > FTRACE_MAX_EVENT) {
+
+			event->type = trace_search_list(&list);
+			if (!event->type)
+				goto out;
+
+		} else {
+			
+			event->type = next_event_type++;
+			list = &ftrace_event_list;
+		}
+
+		if (WARN_ON(ftrace_find_event(event->type)))
+			goto out;
+
+		list_add_tail(&event->list, list);
+
+	} else if (event->type > __TRACE_LAST_TYPE) {
 		printk(KERN_WARNING "Need to add type to trace.h\n");
 		WARN_ON(1);
-	}
-
-	if (ftrace_find_event(event->type))
 		goto out;
+	} else {
+		/* Is this event already used */
+		if (ftrace_find_event(event->type))
+			goto out;
+	}
 
 	if (event->trace == NULL)
 		event->trace = trace_nop_print;
@@ -537,8 +587,6 @@ int register_ftrace_event(struct trace_event *event)
  out:
 	mutex_unlock(&trace_event_mutex);
 
-	WARN_ON_ONCE(next_event_type > FTRACE_MAX_EVENT);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_event);
@@ -551,6 +599,7 @@ int unregister_ftrace_event(struct trace_event *event)
 {
 	mutex_lock(&trace_event_mutex);
 	hlist_del(&event->node);
+	list_del(&event->list);
 	mutex_unlock(&trace_event_mutex);
 
 	return 0;
-- 
1.6.2.1

-- 
