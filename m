Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZG2ROD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZG2ROD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZG2ROA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:14:00 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:31454 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZG2RNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p0Fwmsy8/YnYmufQjJ6biMGOQre7uPIItimJ79WaX3781+RBzVXdWzr57CloxT+gpw
         okMNU2Jmg/Phs2dzGOFoqpg5dXqpMxwTI2mRtynX2G4gPwPYxuqhkFSgNaupRrgpoCS2
         qZq6NaSniCw6Y5SuX+YxDZWBi/1X9oz8H1gWM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6/6] tracing/function-graph-tracer: Move graph event insertion helpers in the graph tracer file
Date: Wed, 29 Jul 2009 19:13:29 +0200
Message-Id: <1248887609-5147-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function graph events helpers which insert the function entry and
return events into the ring buffer currently reside in trace.c
But this file is quite overloaded and the right place for these helpers
is in the function graph tracer file.

Then move them to trace_functions_graph.c

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c                 |  110 ------------------------------
 kernel/trace/trace.h                 |    1 +
 kernel/trace/trace_functions_graph.c |  122 +++++++++++++++++++++++++++++++++-
 kernel/trace/trace_selftest.c        |    1 +
 4 files changed, 121 insertions(+), 113 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fa13f44..da64f8e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -917,54 +917,6 @@ void trace_current_buffer_discard_commit(struct ring_buffer_event *event)
 }
 EXPORT_SYMBOL_GPL(trace_current_buffer_discard_commit);
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static int __trace_graph_entry(struct trace_array *tr,
-				struct ftrace_graph_ent *trace,
-				unsigned long flags,
-				int pc)
-{
-	struct ftrace_event_call *call = &event_funcgraph_entry;
-	struct ring_buffer_event *event;
-	struct ftrace_graph_ent_entry *entry;
-
-	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
-		return 0;
-
-	event = trace_buffer_lock_reserve(&global_trace, TRACE_GRAPH_ENT,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return 0;
-	entry	= ring_buffer_event_data(event);
-	entry->graph_ent			= *trace;
-	if (!filter_current_check_discard(call, entry, event))
-		ring_buffer_unlock_commit(global_trace.buffer, event);
-
-	return 1;
-}
-
-static void __trace_graph_return(struct trace_array *tr,
-				struct ftrace_graph_ret *trace,
-				unsigned long flags,
-				int pc)
-{
-	struct ftrace_event_call *call = &event_funcgraph_exit;
-	struct ring_buffer_event *event;
-	struct ftrace_graph_ret_entry *entry;
-
-	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
-		return;
-
-	event = trace_buffer_lock_reserve(&global_trace, TRACE_GRAPH_RET,
-					  sizeof(*entry), flags, pc);
-	if (!event)
-		return;
-	entry	= ring_buffer_event_data(event);
-	entry->ret				= *trace;
-	if (!filter_current_check_discard(call, entry, event))
-		ring_buffer_unlock_commit(global_trace.buffer, event);
-}
-#endif
-
 void
 ftrace(struct trace_array *tr, struct trace_array_cpu *data,
        unsigned long ip, unsigned long parent_ip, unsigned long flags,
@@ -1104,68 +1056,6 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-int trace_graph_entry(struct ftrace_graph_ent *trace)
-{
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int ret;
-	int cpu;
-	int pc;
-
-	if (!ftrace_trace_task(current))
-		return 0;
-
-	if (!ftrace_graph_addr(trace->func))
-		return 0;
-
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
-		ret = __trace_graph_entry(tr, trace, flags, pc);
-	} else {
-		ret = 0;
-	}
-	/* Only do the atomic if it is not already set */
-	if (!test_tsk_trace_graph(current))
-		set_tsk_trace_graph(current);
-
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
-
-	return ret;
-}
-
-void trace_graph_return(struct ftrace_graph_ret *trace)
-{
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int cpu;
-	int pc;
-
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
-		__trace_graph_return(tr, trace, flags, pc);
-	}
-	if (!trace->depth)
-		clear_tsk_trace_graph(current);
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
-}
-#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-
-
 /**
  * trace_vbprintk - write binary msg to tracing buffer
  *
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e5802a2..8601a4c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -471,6 +471,7 @@ void trace_function(struct trace_array *tr,
 
 void trace_graph_return(struct ftrace_graph_ret *trace);
 int trace_graph_entry(struct ftrace_graph_ent *trace);
+void set_graph_array(struct trace_array *tr);
 
 void tracing_start_cmdline_record(void);
 void tracing_stop_cmdline_record(void);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e30472d..f97244a 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -52,7 +52,7 @@ static struct tracer_flags tracer_flags = {
 	.opts = trace_opts
 };
 
-/* pid on the last trace processed */
+static struct trace_array *graph_array;
 
 
 /* Add a function return address to the trace stack on thread info.*/
@@ -166,10 +166,121 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
 	return ret;
 }
 
+static int __trace_graph_entry(struct trace_array *tr,
+				struct ftrace_graph_ent *trace,
+				unsigned long flags,
+				int pc)
+{
+	struct ftrace_event_call *call = &event_funcgraph_entry;
+	struct ring_buffer_event *event;
+	struct ftrace_graph_ent_entry *entry;
+
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return 0;
+
+	event = trace_buffer_lock_reserve(tr, TRACE_GRAPH_ENT,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return 0;
+	entry	= ring_buffer_event_data(event);
+	entry->graph_ent			= *trace;
+	if (!filter_current_check_discard(call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
+
+	return 1;
+}
+
+int trace_graph_entry(struct ftrace_graph_ent *trace)
+{
+	struct trace_array *tr = graph_array;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int ret;
+	int cpu;
+	int pc;
+
+	if (unlikely(!tr))
+		return 0;
+
+	if (!ftrace_trace_task(current))
+		return 0;
+
+	if (!ftrace_graph_addr(trace->func))
+		return 0;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		ret = __trace_graph_entry(tr, trace, flags, pc);
+	} else {
+		ret = 0;
+	}
+	/* Only do the atomic if it is not already set */
+	if (!test_tsk_trace_graph(current))
+		set_tsk_trace_graph(current);
+
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static void __trace_graph_return(struct trace_array *tr,
+				struct ftrace_graph_ret *trace,
+				unsigned long flags,
+				int pc)
+{
+	struct ftrace_event_call *call = &event_funcgraph_exit;
+	struct ring_buffer_event *event;
+	struct ftrace_graph_ret_entry *entry;
+
+	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
+		return;
+
+	event = trace_buffer_lock_reserve(tr, TRACE_GRAPH_RET,
+					  sizeof(*entry), flags, pc);
+	if (!event)
+		return;
+	entry	= ring_buffer_event_data(event);
+	entry->ret				= *trace;
+	if (!filter_current_check_discard(call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
+}
+
+void trace_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct trace_array *tr = graph_array;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		__trace_graph_return(tr, trace, flags, pc);
+	}
+	if (!trace->depth)
+		clear_tsk_trace_graph(current);
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
 static int graph_trace_init(struct trace_array *tr)
 {
-	int ret = register_ftrace_graph(&trace_graph_return,
-					&trace_graph_entry);
+	int ret;
+
+	graph_array = tr;
+	ret = register_ftrace_graph(&trace_graph_return,
+				    &trace_graph_entry);
 	if (ret)
 		return ret;
 	tracing_start_cmdline_record();
@@ -177,6 +288,11 @@ static int graph_trace_init(struct trace_array *tr)
 	return 0;
 }
 
+void set_graph_array(struct trace_array *tr)
+{
+	graph_array = tr;
+}
+
 static void graph_trace_reset(struct trace_array *tr)
 {
 	tracing_stop_cmdline_record();
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 00dd648..d2cdbab 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -288,6 +288,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 	 * to detect and recover from possible hangs
 	 */
 	tracing_reset_online_cpus(tr);
+	set_graph_array(tr);
 	ret = register_ftrace_graph(&trace_graph_return,
 				    &trace_graph_entry_watchdog);
 	if (ret) {
-- 
1.6.2.3

