Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZFIVxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZFIVxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZFIVxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:53:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbZFIVxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:53:38 -0400
Message-Id: <20090609215338.966490493@goodmis.org>
References: <20090609215211.307980196@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 09 Jun 2009 17:52:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/8] tracing: add protection around module events unload
Content-Disposition: inline; filename=0002-tracing-add-protection-around-module-events-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When reading the trace buffer, there is a race that when a module
is unloaded it removes events that is stilled referenced in the buffers.
This patch adds the protection around the unloading of the events
from modules and the reading of the trace buffers.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    4 +++-
 kernel/trace/trace_output.c |   15 ++++++++++++---
 kernel/trace/trace_output.h |    4 ++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6c81f9c..aa08be6 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1050,12 +1050,13 @@ static void trace_module_remove_events(struct module *mod)
 	struct ftrace_event_call *call, *p;
 	bool found = false;
 
+	down_write(&trace_event_mutex);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod == mod) {
 			found = true;
 			ftrace_event_enable_disable(call, 0);
 			if (call->event)
-				unregister_ftrace_event(call->event);
+				__unregister_ftrace_event(call->event);
 			debugfs_remove_recursive(call->dir);
 			list_del(&call->list);
 			trace_destroy_fields(call);
@@ -1079,6 +1080,7 @@ static void trace_module_remove_events(struct module *mod)
 	 */
 	if (found)
 		tracing_reset_current_online_cpus();
+	up_write(&trace_event_mutex);
 }
 
 static int trace_module_notify(struct notifier_block *self,
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c05aff4..7938f3a 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -14,7 +14,7 @@
 /* must be a power of 2 */
 #define EVENT_HASHSIZE	128
 
-static DECLARE_RWSEM(trace_event_mutex);
+DECLARE_RWSEM(trace_event_mutex);
 
 DEFINE_PER_CPU(struct trace_seq, ftrace_event_seq);
 EXPORT_PER_CPU_SYMBOL(ftrace_event_seq);
@@ -702,6 +702,16 @@ int register_ftrace_event(struct trace_event *event)
 }
 EXPORT_SYMBOL_GPL(register_ftrace_event);
 
+/*
+ * Used by module code with the trace_event_mutex held for write.
+ */
+int __unregister_ftrace_event(struct trace_event *event)
+{
+	hlist_del(&event->node);
+	list_del(&event->list);
+	return 0;
+}
+
 /**
  * unregister_ftrace_event - remove a no longer used event
  * @event: the event to remove
@@ -709,8 +719,7 @@ EXPORT_SYMBOL_GPL(register_ftrace_event);
 int unregister_ftrace_event(struct trace_event *event)
 {
 	down_write(&trace_event_mutex);
-	hlist_del(&event->node);
-	list_del(&event->list);
+	__unregister_ftrace_event(event);
 	up_write(&trace_event_mutex);
 
 	return 0;
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index ac240e7..d38bec4 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -27,6 +27,10 @@ extern struct trace_event *ftrace_find_event(int type);
 extern enum print_line_t trace_nop_print(struct trace_iterator *iter,
 					 int flags);
 
+/* used by module unregistering */
+extern int __unregister_ftrace_event(struct trace_event *event);
+extern struct rw_semaphore trace_event_mutex;
+
 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
 
-- 
1.6.3.1

-- 
