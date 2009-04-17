Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZDQOou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZDQOou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761476AbZDQOnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:43:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48405 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761063AbZDQOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:43:34 -0400
Message-Id: <20090417144332.464531663@goodmis.org>
References: <20090417144055.857407604@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 10:41:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2 5/5] tracing/events: perform function tracing in event selftests
Content-Disposition: inline; filename=0005-tracing-events-perform-function-tracing-in-event-se.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

We can find some bugs in the trace events if we stress the writes as well.
The function tracer is a good way to stress the events.

Impact: extend scope of event tracer self-tests
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20090416161746.604786131@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_events.c |   78 +++++++++++++++++++++++++++++++++++++++---
 1 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7163a2b..1137f95 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1017,7 +1017,7 @@ static __init void event_test_stuff(void)
  * For every trace event defined, we will test each trace point separately,
  * and then by groups, and finally all trace points.
  */
-static __init int event_trace_self_tests(void)
+static __init void event_trace_self_tests(void)
 {
 	struct ftrace_event_call *call;
 	struct event_subsystem *system;
@@ -1071,7 +1071,7 @@ static __init int event_trace_self_tests(void)
 		sysname = kstrdup(system->name, GFP_KERNEL);
 		if (WARN_ON(!sysname)) {
 			pr_warning("Can't allocate memory, giving up!\n");
-			return 0;
+			return;
 		}
 		ret = ftrace_set_clr_event(sysname, 1);
 		kfree(sysname);
@@ -1086,7 +1086,7 @@ static __init int event_trace_self_tests(void)
 		sysname = kstrdup(system->name, GFP_KERNEL);
 		if (WARN_ON(!sysname)) {
 			pr_warning("Can't allocate memory, giving up!\n");
-			return 0;
+			return;
 		}
 		ret = ftrace_set_clr_event(sysname, 0);
 		kfree(sysname);
@@ -1106,14 +1106,14 @@ static __init int event_trace_self_tests(void)
 	sysname = kmalloc(4, GFP_KERNEL);
 	if (WARN_ON(!sysname)) {
 		pr_warning("Can't allocate memory, giving up!\n");
-		return 0;
+		return;
 	}
 	memcpy(sysname, "*:*", 4);
 	ret = ftrace_set_clr_event(sysname, 1);
 	if (WARN_ON_ONCE(ret)) {
 		kfree(sysname);
 		pr_warning("error enabling all events\n");
-		return 0;
+		return;
 	}
 
 	event_test_stuff();
@@ -1125,10 +1125,76 @@ static __init int event_trace_self_tests(void)
 
 	if (WARN_ON_ONCE(ret)) {
 		pr_warning("error disabling all events\n");
-		return 0;
+		return;
 	}
 
 	pr_cont("OK\n");
+}
+
+#ifdef CONFIG_FUNCTION_TRACER
+
+static DEFINE_PER_CPU(atomic_t, test_event_disable);
+
+static void
+function_test_events_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct ring_buffer_event *event;
+	struct ftrace_entry *entry;
+	unsigned long flags;
+	long disabled;
+	int resched;
+	int cpu;
+	int pc;
+
+	pc = preempt_count();
+	resched = ftrace_preempt_disable();
+	cpu = raw_smp_processor_id();
+	disabled = atomic_inc_return(&per_cpu(test_event_disable, cpu));
+
+	if (disabled != 1)
+		goto out;
+
+	local_save_flags(flags);
+
+	event = trace_current_buffer_lock_reserve(TRACE_FN, sizeof(*entry),
+						  flags, pc);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	entry->ip			= ip;
+	entry->parent_ip		= parent_ip;
+
+	trace_current_buffer_unlock_commit(event, flags, pc);
+
+ out:
+	atomic_dec(&per_cpu(test_event_disable, cpu));
+	ftrace_preempt_enable(resched);
+}
+
+static struct ftrace_ops trace_ops __initdata  =
+{
+	.func = function_test_events_call,
+};
+
+static __init void event_trace_self_test_with_function(void)
+{
+	register_ftrace_function(&trace_ops);
+	pr_info("Running tests again, along with the function tracer\n");
+	event_trace_self_tests();
+	unregister_ftrace_function(&trace_ops);
+}
+#else
+static __init void event_trace_self_test_with_function(void)
+{
+}
+#endif
+
+static __init int event_trace_self_tests_init(void)
+{
+
+	event_trace_self_tests();
+
+	event_trace_self_test_with_function();
 
 	return 0;
 }
-- 
1.6.2.1

-- 
