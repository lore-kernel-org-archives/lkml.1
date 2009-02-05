Return-Path: <linux-kernel-owner+w=401wt.eu-S1762708AbZBEC1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762708AbZBEC1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762379AbZBEC1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:27:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56058 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762333AbZBEC1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:27:15 -0500
Date: Thu, 5 Feb 2009 00:27:05 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 2/2] trace: Remove unused trace_array_cpu parameter
Message-ID: <20090205022705.GS3440@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 block/blktrace.c                  |    2 +-
 kernel/trace/trace.c              |   47 ++++++++++++++----------------------
 kernel/trace/trace.h              |    4 ---
 kernel/trace/trace_functions.c    |    8 +++---
 kernel/trace/trace_irqsoff.c      |   10 ++++----
 kernel/trace/trace_sched_switch.c |    4 +-
 kernel/trace/trace_sched_wakeup.c |   12 ++++-----
 7 files changed, 35 insertions(+), 52 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 1ebd068..d9d7146 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -245,7 +245,7 @@ record_it:
 			if (pid != 0 &&
 			    !(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC) &&
 			    (trace_flags & TRACE_ITER_STACKTRACE) != 0)
-				__trace_stack(blk_tr, NULL, flags, 5, pc);
+				__trace_stack(blk_tr, flags, 5, pc);
 			trace_wake_up();
 			return;
 		}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a5e4c0a..1d4ff56 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -776,7 +776,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags,
 }
 
 void
-trace_function(struct trace_array *tr, struct trace_array_cpu *data,
+trace_function(struct trace_array *tr,
 	       unsigned long ip, unsigned long parent_ip, unsigned long flags,
 	       int pc)
 {
@@ -802,7 +802,6 @@ trace_function(struct trace_array *tr, struct trace_array_cpu *data,
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static void __trace_graph_entry(struct trace_array *tr,
-				struct trace_array_cpu *data,
 				struct ftrace_graph_ent *trace,
 				unsigned long flags,
 				int pc)
@@ -826,7 +825,6 @@ static void __trace_graph_entry(struct trace_array *tr,
 }
 
 static void __trace_graph_return(struct trace_array *tr,
-				struct trace_array_cpu *data,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
 				int pc)
@@ -856,11 +854,10 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
        int pc)
 {
 	if (likely(!atomic_read(&data->disabled)))
-		trace_function(tr, data, ip, parent_ip, flags, pc);
+		trace_function(tr, ip, parent_ip, flags, pc);
 }
 
 static void __ftrace_trace_stack(struct trace_array *tr,
-				 struct trace_array_cpu *data,
 				 unsigned long flags,
 				 int skip, int pc)
 {
@@ -891,27 +888,24 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 }
 
 static void ftrace_trace_stack(struct trace_array *tr,
-			       struct trace_array_cpu *data,
 			       unsigned long flags,
 			       int skip, int pc)
 {
 	if (!(trace_flags & TRACE_ITER_STACKTRACE))
 		return;
 
-	__ftrace_trace_stack(tr, data, flags, skip, pc);
+	__ftrace_trace_stack(tr, flags, skip, pc);
 }
 
 void __trace_stack(struct trace_array *tr,
-		   struct trace_array_cpu *data,
 		   unsigned long flags,
 		   int skip, int pc)
 {
-	__ftrace_trace_stack(tr, data, flags, skip, pc);
+	__ftrace_trace_stack(tr, flags, skip, pc);
 }
 
 static void ftrace_trace_userstack(struct trace_array *tr,
-		   struct trace_array_cpu *data,
-		   unsigned long flags, int pc)
+				   unsigned long flags, int pc)
 {
 #ifdef CONFIG_STACKTRACE
 	struct ring_buffer_event *event;
@@ -942,20 +936,17 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 #endif
 }
 
-void __trace_userstack(struct trace_array *tr,
-		   struct trace_array_cpu *data,
-		   unsigned long flags)
+void __trace_userstack(struct trace_array *tr, unsigned long flags)
 {
-	ftrace_trace_userstack(tr, data, flags, preempt_count());
+	ftrace_trace_userstack(tr, flags, preempt_count());
 }
 
 static void
-ftrace_trace_special(void *__tr, void *__data,
+ftrace_trace_special(void *__tr,
 		     unsigned long arg1, unsigned long arg2, unsigned long arg3,
 		     int pc)
 {
 	struct ring_buffer_event *event;
-	struct trace_array_cpu *data = __data;
 	struct trace_array *tr = __tr;
 	struct special_entry *entry;
 	unsigned long irq_flags;
@@ -971,8 +962,8 @@ ftrace_trace_special(void *__tr, void *__data,
 	entry->arg2			= arg2;
 	entry->arg3			= arg3;
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
-	ftrace_trace_stack(tr, data, irq_flags, 4, pc);
-	ftrace_trace_userstack(tr, data, irq_flags, pc);
+	ftrace_trace_stack(tr, irq_flags, 4, pc);
+	ftrace_trace_userstack(tr, irq_flags, pc);
 
 	trace_wake_up();
 }
@@ -981,12 +972,11 @@ void
 __trace_special(void *__tr, void *__data,
 		unsigned long arg1, unsigned long arg2, unsigned long arg3)
 {
-	ftrace_trace_special(__tr, __data, arg1, arg2, arg3, preempt_count());
+	ftrace_trace_special(__tr, arg1, arg2, arg3, preempt_count());
 }
 
 void
 tracing_sched_switch_trace(struct trace_array *tr,
-			   struct trace_array_cpu *data,
 			   struct task_struct *prev,
 			   struct task_struct *next,
 			   unsigned long flags, int pc)
@@ -1010,13 +1000,12 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
-	ftrace_trace_stack(tr, data, flags, 5, pc);
-	ftrace_trace_userstack(tr, data, flags, pc);
+	ftrace_trace_stack(tr, flags, 5, pc);
+	ftrace_trace_userstack(tr, flags, pc);
 }
 
 void
 tracing_sched_wakeup_trace(struct trace_array *tr,
-			   struct trace_array_cpu *data,
 			   struct task_struct *wakee,
 			   struct task_struct *curr,
 			   unsigned long flags, int pc)
@@ -1040,8 +1029,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
-	ftrace_trace_stack(tr, data, flags, 6, pc);
-	ftrace_trace_userstack(tr, data, flags, pc);
+	ftrace_trace_stack(tr, flags, 6, pc);
+	ftrace_trace_userstack(tr, flags, pc);
 
 	trace_wake_up();
 }
@@ -1064,7 +1053,7 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 	data = tr->data[cpu];
 
 	if (likely(atomic_inc_return(&data->disabled) == 1))
-		ftrace_trace_special(tr, data, arg1, arg2, arg3, pc);
+		ftrace_trace_special(tr, arg1, arg2, arg3, pc);
 
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
@@ -1092,7 +1081,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
-		__trace_graph_entry(tr, data, trace, flags, pc);
+		__trace_graph_entry(tr, trace, flags, pc);
 	}
 	/* Only do the atomic if it is not already set */
 	if (!test_tsk_trace_graph(current))
@@ -1118,7 +1107,7 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
-		__trace_graph_return(tr, data, trace, flags, pc);
+		__trace_graph_return(tr, trace, flags, pc);
 	}
 	if (!trace->depth)
 		clear_tsk_trace_graph(current);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f0c7a0f..df627a9 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -419,14 +419,12 @@ void ftrace(struct trace_array *tr,
 			    unsigned long parent_ip,
 			    unsigned long flags, int pc);
 void tracing_sched_switch_trace(struct trace_array *tr,
-				struct trace_array_cpu *data,
 				struct task_struct *prev,
 				struct task_struct *next,
 				unsigned long flags, int pc);
 void tracing_record_cmdline(struct task_struct *tsk);
 
 void tracing_sched_wakeup_trace(struct trace_array *tr,
-				struct trace_array_cpu *data,
 				struct task_struct *wakee,
 				struct task_struct *cur,
 				unsigned long flags, int pc);
@@ -436,7 +434,6 @@ void trace_special(struct trace_array *tr,
 		   unsigned long arg2,
 		   unsigned long arg3, int pc);
 void trace_function(struct trace_array *tr,
-		    struct trace_array_cpu *data,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
@@ -462,7 +459,6 @@ void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
 
 void __trace_stack(struct trace_array *tr,
-		   struct trace_array_cpu *data,
 		   unsigned long flags,
 		   int skip, int pc);
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index b3a320f..d067cea 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -78,7 +78,7 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		trace_function(tr, data, ip, parent_ip, flags, pc);
+		trace_function(tr, ip, parent_ip, flags, pc);
 
 	atomic_dec(&data->disabled);
 	ftrace_preempt_enable(resched);
@@ -108,7 +108,7 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
-		trace_function(tr, data, ip, parent_ip, flags, pc);
+		trace_function(tr, ip, parent_ip, flags, pc);
 	}
 
 	atomic_dec(&data->disabled);
@@ -139,7 +139,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
-		trace_function(tr, data, ip, parent_ip, flags, pc);
+		trace_function(tr, ip, parent_ip, flags, pc);
 		/*
 		 * skip over 5 funcs:
 		 *    __ftrace_trace_stack,
@@ -148,7 +148,7 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 		 *    ftrace_list_func
 		 *    ftrace_call
 		 */
-		__trace_stack(tr, data, flags, 5, pc);
+		__trace_stack(tr, flags, 5, pc);
 	}
 
 	atomic_dec(&data->disabled);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index ed344b0..c6b442d 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -95,7 +95,7 @@ irqsoff_tracer_call(unsigned long ip, unsigned long parent_ip)
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		trace_function(tr, data, ip, parent_ip, flags, preempt_count());
+		trace_function(tr, ip, parent_ip, flags, preempt_count());
 
 	atomic_dec(&data->disabled);
 }
@@ -153,7 +153,7 @@ check_critical_timing(struct trace_array *tr,
 	if (!report_latency(delta))
 		goto out_unlock;
 
-	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags, pc);
+	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 
 	latency = nsecs_to_usecs(delta);
 
@@ -177,7 +177,7 @@ out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
 	tracing_reset(tr, cpu);
-	trace_function(tr, data, CALLER_ADDR0, parent_ip, flags, pc);
+	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 }
 
 static inline void
@@ -210,7 +210,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 
 	local_save_flags(flags);
 
-	trace_function(tr, data, ip, parent_ip, flags, preempt_count());
+	trace_function(tr, ip, parent_ip, flags, preempt_count());
 
 	per_cpu(tracing_cpu, cpu) = 1;
 
@@ -244,7 +244,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	atomic_inc(&data->disabled);
 
 	local_save_flags(flags);
-	trace_function(tr, data, ip, parent_ip, flags, preempt_count());
+	trace_function(tr, ip, parent_ip, flags, preempt_count());
 	check_critical_timing(tr, data, parent_ip ? : ip, cpu);
 	data->critical_start = 0;
 	atomic_dec(&data->disabled);
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index df175cb..c4f9add 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -43,7 +43,7 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 	data = ctx_trace->data[cpu];
 
 	if (likely(!atomic_read(&data->disabled)))
-		tracing_sched_switch_trace(ctx_trace, data, prev, next, flags, pc);
+		tracing_sched_switch_trace(ctx_trace, prev, next, flags, pc);
 
 	local_irq_restore(flags);
 }
@@ -66,7 +66,7 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
 	data = ctx_trace->data[cpu];
 
 	if (likely(!atomic_read(&data->disabled)))
-		tracing_sched_wakeup_trace(ctx_trace, data, wakee, current,
+		tracing_sched_wakeup_trace(ctx_trace, wakee, current,
 					   flags, pc);
 
 	local_irq_restore(flags);
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index a48c9b4..96d7164 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -72,7 +72,7 @@ wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 	if (task_cpu(wakeup_task) != cpu)
 		goto unlock;
 
-	trace_function(tr, data, ip, parent_ip, flags, pc);
+	trace_function(tr, ip, parent_ip, flags, pc);
 
  unlock:
 	__raw_spin_unlock(&wakeup_lock);
@@ -152,8 +152,8 @@ probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
-	trace_function(wakeup_trace, data, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
-	tracing_sched_switch_trace(wakeup_trace, data, prev, next, flags, pc);
+	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
+	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
 	/*
 	 * usecs conversion is slow so we try to delay the conversion
@@ -254,10 +254,8 @@ probe_wakeup(struct rq *rq, struct task_struct *p, int success)
 
 	data = wakeup_trace->data[wakeup_cpu];
 	data->preempt_timestamp = ftrace_now(cpu);
-	tracing_sched_wakeup_trace(wakeup_trace, data, p, current,
-				   flags, pc);
-	trace_function(wakeup_trace, data, CALLER_ADDR1, CALLER_ADDR2,
-		       flags, pc);
+	tracing_sched_wakeup_trace(wakeup_trace, p, current, flags, pc);
+	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 out_locked:
 	__raw_spin_unlock(&wakeup_lock);
-- 
1.6.0.6

