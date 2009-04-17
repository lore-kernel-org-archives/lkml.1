Return-Path: <linux-kernel-owner+w=401wt.eu-S1761566AbZDQQM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566AbZDQQM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760303AbZDQQLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:11:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:55367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761269AbZDQQLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:11:42 -0400
Date: Fri, 17 Apr 2009 16:10:26 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       akpm@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090416161746.604786131@goodmis.org>
References: <20090416161746.604786131@goodmis.org>
Subject: [tip:tracing/core] tracing/events: perform function tracing in event selftests
Message-ID: <tip-9ea21c1ecdb35ecdcac5fd9d95f62a1f6a7ffec0@git.kernel.org>
Git-Commit-ID: 9ea21c1ecdb35ecdcac5fd9d95f62a1f6a7ffec0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 16:10:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ea21c1ecdb35ecdcac5fd9d95f62a1f6a7ffec0
Gitweb:     http://git.kernel.org/tip/9ea21c1ecdb35ecdcac5fd9d95f62a1f6a7ffec0
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 16 Apr 2009 12:15:44 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 17:10:35 +0200

tracing/events: perform function tracing in event selftests

We can find some bugs in the trace events if we stress the writes as well.
The function tracer is a good way to stress the events.

[ Impact: extend scope of event tracer self-tests ]

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
