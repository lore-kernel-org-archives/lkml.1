Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbYDXPQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbYDXPQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbYDXPOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:42 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56012 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759297AbYDXPOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:39 -0400
Message-Id: <20080424151406.629522363@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 32/37] Port ftrace to markers
Content-Disposition: inline; filename=port-ftrace-to-markers.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:14:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Porting ftrace to the marker infrastructure.

Don't need to chain to the wakeup tracer from the sched tracer, because markers
support multiple probes connected.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/sched.h             |   32 -------
 kernel/sched.c                    |   14 ++-
 kernel/trace/trace.h              |   20 ----
 kernel/trace/trace_sched_switch.c |  173 +++++++++++++++++++++++++++++++-------
 kernel/trace/trace_sched_wakeup.c |  108 ++++++++++++++++++++++-
 5 files changed, 257 insertions(+), 90 deletions(-)

Index: linux-2.6-sched-devel/include/linux/sched.h
===================================================================
--- linux-2.6-sched-devel.orig/include/linux/sched.h	2008-04-24 11:00:30.000000000 -0400
+++ linux-2.6-sched-devel/include/linux/sched.h	2008-04-24 11:00:41.000000000 -0400
@@ -2080,38 +2080,6 @@ __trace_special(void *__tr, void *__data
 }
 #endif
 
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
-extern void
-ftrace_ctx_switch(void *rq, struct task_struct *prev, struct task_struct *next);
-extern void
-ftrace_wake_up_task(void *rq, struct task_struct *wakee,
-		    struct task_struct *curr);
-extern void ftrace_all_fair_tasks(void *__rq, void *__tr, void *__data);
-extern void
-ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
-#else
-static inline void
-ftrace_ctx_switch(void *rq, struct task_struct *prev, struct task_struct *next)
-{
-}
-static inline void
-sched_trace_special(unsigned long p1, unsigned long p2, unsigned long p3)
-{
-}
-static inline void
-ftrace_wake_up_task(void *rq, struct task_struct *wakee,
-		    struct task_struct *curr)
-{
-}
-static inline void ftrace_all_fair_tasks(void *__rq, void *__tr, void *__data)
-{
-}
-static inline void
-ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
-{
-}
-#endif
-
 extern long sched_setaffinity(pid_t pid, const cpumask_t *new_mask);
 extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
 
Index: linux-2.6-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched.c	2008-04-24 11:00:30.000000000 -0400
+++ linux-2.6-sched-devel/kernel/sched.c	2008-04-24 11:01:35.000000000 -0400
@@ -2618,7 +2618,9 @@ out_activate:
 	success = 1;
 
 out_running:
-	ftrace_wake_up_task(rq, p, rq->curr);
+	trace_mark(kernel_sched_wakeup,
+		"pid %d state %ld ## rq %p task %p rq->curr %p",
+		p->pid, p->state, rq, p, rq->curr);
 	check_preempt_curr(rq, p);
 
 	p->state = TASK_RUNNING;
@@ -2749,7 +2751,9 @@ void wake_up_new_task(struct task_struct
 		p->sched_class->task_new(rq, p);
 		inc_nr_running(rq);
 	}
-	ftrace_wake_up_task(rq, p, rq->curr);
+	trace_mark(kernel_sched_wakeup_new,
+		"pid %d state %ld ## rq %p task %p rq->curr %p",
+		p->pid, p->state, rq, p, rq->curr);
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
@@ -2922,7 +2926,11 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	ftrace_ctx_switch(rq, prev, next);
+	trace_mark(kernel_sched_schedule,
+		"prev_pid %d next_pid %d prev_state %ld "
+		"## rq %p prev %p next %p",
+		prev->pid, next->pid, prev->state,
+		rq, prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
Index: linux-2.6-sched-devel/kernel/trace/trace.h
===================================================================
--- linux-2.6-sched-devel.orig/kernel/trace/trace.h	2008-04-24 11:00:30.000000000 -0400
+++ linux-2.6-sched-devel/kernel/trace/trace.h	2008-04-24 11:00:41.000000000 -0400
@@ -240,25 +240,10 @@ void update_max_tr_single(struct trace_a
 
 extern cycle_t ftrace_now(int cpu);
 
-#ifdef CONFIG_SCHED_TRACER
-extern void
-wakeup_sched_switch(struct task_struct *prev, struct task_struct *next);
-extern void
-wakeup_sched_wakeup(struct task_struct *wakee, struct task_struct *curr);
-#else
-static inline void
-wakeup_sched_switch(struct task_struct *prev, struct task_struct *next)
-{
-}
-static inline void
-wakeup_sched_wakeup(struct task_struct *wakee, struct task_struct *curr)
-{
-}
-#endif
-
 #ifdef CONFIG_CONTEXT_SWITCH_TRACER
 typedef void
 (*tracer_switch_func_t)(void *private,
+			void *__rq,
 			struct task_struct *prev,
 			struct task_struct *next);
 
@@ -268,9 +253,6 @@ struct tracer_switch_ops {
 	struct tracer_switch_ops	*next;
 };
 
-extern int register_tracer_switch(struct tracer_switch_ops *ops);
-extern int unregister_tracer_switch(struct tracer_switch_ops *ops);
-
 #endif /* CONFIG_CONTEXT_SWITCH_TRACER */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
Index: linux-2.6-sched-devel/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/trace/trace_sched_switch.c	2008-04-24 11:00:30.000000000 -0400
+++ linux-2.6-sched-devel/kernel/trace/trace_sched_switch.c	2008-04-24 11:00:41.000000000 -0400
@@ -16,11 +16,14 @@
 
 static struct trace_array	*ctx_trace;
 static int __read_mostly	tracer_enabled;
+static atomic_t			sched_ref;
 
 static void
-ctx_switch_func(void *__rq, struct task_struct *prev, struct task_struct *next)
+sched_switch_func(void *private, void *__rq, struct task_struct *prev,
+			struct task_struct *next)
 {
-	struct trace_array *tr = ctx_trace;
+	struct trace_array **ptr = private;
+	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
@@ -41,10 +44,40 @@ ctx_switch_func(void *__rq, struct task_
 	local_irq_restore(flags);
 }
 
+static notrace void
+sched_switch_callback(void *probe_data, void *call_data,
+		      const char *format, va_list *args)
+{
+	struct task_struct *prev;
+	struct task_struct *next;
+	struct rq *__rq;
+
+	if (!atomic_read(&sched_ref))
+		return;
+
+	/* skip prev_pid %d next_pid %d prev_state %ld */
+	(void)va_arg(*args, int);
+	(void)va_arg(*args, int);
+	(void)va_arg(*args, long);
+	__rq = va_arg(*args, typeof(__rq));
+	prev = va_arg(*args, typeof(prev));
+	next = va_arg(*args, typeof(next));
+
+	tracing_record_cmdline(prev);
+
+	/*
+	 * If tracer_switch_func only points to the local
+	 * switch func, it still needs the ptr passed to it.
+	 */
+	sched_switch_func(probe_data, __rq, prev, next);
+}
+
 static void
-wakeup_func(void *__rq, struct task_struct *wakee, struct task_struct *curr)
+wakeup_func(void *private, void *__rq, struct task_struct *wakee, struct
+			task_struct *curr)
 {
-	struct trace_array *tr = ctx_trace;
+	struct trace_array **ptr = private;
+	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
@@ -67,35 +100,29 @@ wakeup_func(void *__rq, struct task_stru
 	local_irq_restore(flags);
 }
 
-void
-ftrace_ctx_switch(void *__rq, struct task_struct *prev,
-		  struct task_struct *next)
-{
-	if (unlikely(atomic_read(&trace_record_cmdline_enabled)))
-		tracing_record_cmdline(prev);
+static notrace void
+wake_up_callback(void *probe_data, void *call_data,
+		 const char *format, va_list *args)
+{
+	struct task_struct *curr;
+	struct task_struct *task;
+	struct rq *__rq;
 
-	/*
-	 * If tracer_switch_func only points to the local
-	 * switch func, it still needs the ptr passed to it.
-	 */
-	ctx_switch_func(__rq, prev, next);
+	if (likely(!tracer_enabled))
+		return;
 
-	/*
-	 * Chain to the wakeup tracer (this is a NOP if disabled):
-	 */
-	wakeup_sched_switch(prev, next);
-}
+	/* Skip pid %d state %ld */
+	(void)va_arg(*args, int);
+	(void)va_arg(*args, long);
+	/* now get the meat: "rq %p task %p rq->curr %p" */
+	__rq = va_arg(*args, typeof(__rq));
+	task = va_arg(*args, typeof(task));
+	curr = va_arg(*args, typeof(curr));
 
-void
-ftrace_wake_up_task(void *__rq, struct task_struct *wakee,
-		    struct task_struct *curr)
-{
-	wakeup_func(__rq, wakee, curr);
+	tracing_record_cmdline(task);
+	tracing_record_cmdline(curr);
 
-	/*
-	 * Chain to the wakeup tracer (this is a NOP if disabled):
-	 */
-	wakeup_sched_wakeup(wakee, curr);
+	wakeup_func(probe_data, __rq, task, curr);
 }
 
 void
@@ -132,15 +159,95 @@ static void sched_switch_reset(struct tr
 		tracing_reset(tr->data[cpu]);
 }
 
+static int tracing_sched_register(void)
+{
+	int ret;
+
+	ret = marker_probe_register("kernel_sched_wakeup",
+			"pid %d state %ld ## rq %p task %p rq->curr %p",
+			wake_up_callback,
+			&ctx_trace);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't add marker"
+			" probe to kernel_sched_wakeup\n");
+		return ret;
+	}
+
+	ret = marker_probe_register("kernel_sched_wakeup_new",
+			"pid %d state %ld ## rq %p task %p rq->curr %p",
+			wake_up_callback,
+			&ctx_trace);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't add marker"
+			" probe to kernel_sched_wakeup_new\n");
+		goto fail_deprobe;
+	}
+
+	ret = marker_probe_register("kernel_sched_schedule",
+		"prev_pid %d next_pid %d prev_state %ld "
+		"## rq %p prev %p next %p",
+		sched_switch_callback,
+		&ctx_trace);
+	if (ret) {
+		pr_info("sched trace: Couldn't add marker"
+			" probe to kernel_sched_schedule\n");
+		goto fail_deprobe_wake_new;
+	}
+
+	return ret;
+fail_deprobe_wake_new:
+	marker_probe_unregister("kernel_sched_wakeup_new",
+				wake_up_callback,
+				&ctx_trace);
+fail_deprobe:
+	marker_probe_unregister("kernel_sched_wakeup",
+				wake_up_callback,
+				&ctx_trace);
+	return ret;
+}
+
+static void tracing_sched_unregister(void)
+{
+	marker_probe_unregister("kernel_sched_schedule",
+				sched_switch_callback,
+				&ctx_trace);
+	marker_probe_unregister("kernel_sched_wakeup_new",
+				wake_up_callback,
+				&ctx_trace);
+	marker_probe_unregister("kernel_sched_wakeup",
+				wake_up_callback,
+				&ctx_trace);
+}
+
+void tracing_start_sched_switch(void)
+{
+	long ref;
+
+	ref = atomic_inc_return(&sched_ref);
+	if (ref == 1)
+		tracing_sched_register();
+}
+
+void tracing_stop_sched_switch(void)
+{
+	long ref;
+
+	ref = atomic_dec_and_test(&sched_ref);
+	if (ref)
+		tracing_sched_unregister();
+}
+
 static void start_sched_trace(struct trace_array *tr)
 {
 	sched_switch_reset(tr);
 	atomic_inc(&trace_record_cmdline_enabled);
 	tracer_enabled = 1;
+	tracing_start_sched_switch();
 }
 
 static void stop_sched_trace(struct trace_array *tr)
 {
+	tracing_stop_sched_switch();
 	atomic_dec(&trace_record_cmdline_enabled);
 	tracer_enabled = 0;
 }
@@ -181,6 +288,14 @@ static struct tracer sched_switch_trace 
 
 __init static int init_sched_switch_trace(void)
 {
+	int ret = 0;
+
+	if (atomic_read(&sched_ref))
+		ret = tracing_sched_register();
+	if (ret) {
+		pr_info("error registering scheduler trace\n");
+		return ret;
+	}
 	return register_tracer(&sched_switch_trace);
 }
 device_initcall(init_sched_switch_trace);
Index: linux-2.6-sched-devel/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/trace/trace_sched_wakeup.c	2008-04-24 11:00:30.000000000 -0400
+++ linux-2.6-sched-devel/kernel/trace/trace_sched_wakeup.c	2008-04-24 11:00:41.000000000 -0400
@@ -15,6 +15,7 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
+#include <linux/marker.h>
 
 #include "trace.h"
 
@@ -44,11 +45,13 @@ static int report_latency(cycle_t delta)
 	return 1;
 }
 
-void
-wakeup_sched_switch(struct task_struct *prev, struct task_struct *next)
+static void notrace
+wakeup_sched_switch(void *private, void *rq, struct task_struct *prev,
+	struct task_struct *next)
 {
 	unsigned long latency = 0, t0 = 0, t1 = 0;
-	struct trace_array *tr = wakeup_trace;
+	struct trace_array **ptr = private;
+	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
@@ -113,6 +116,31 @@ out:
 	atomic_dec(&tr->data[cpu]->disabled);
 }
 
+static notrace void
+sched_switch_callback(void *probe_data, void *call_data,
+		      const char *format, va_list *args)
+{
+	struct task_struct *prev;
+	struct task_struct *next;
+	struct rq *__rq;
+
+	/* skip prev_pid %d next_pid %d prev_state %ld */
+	(void)va_arg(*args, int);
+	(void)va_arg(*args, int);
+	(void)va_arg(*args, long);
+	__rq = va_arg(*args, typeof(__rq));
+	prev = va_arg(*args, typeof(prev));
+	next = va_arg(*args, typeof(next));
+
+	tracing_record_cmdline(prev);
+
+	/*
+	 * If tracer_switch_func only points to the local
+	 * switch func, it still needs the ptr passed to it.
+	 */
+	wakeup_sched_switch(probe_data, __rq, prev, next);
+}
+
 static void __wakeup_reset(struct trace_array *tr)
 {
 	struct trace_array_cpu *data;
@@ -188,19 +216,68 @@ out:
 	atomic_dec(&tr->data[cpu]->disabled);
 }
 
-void wakeup_sched_wakeup(struct task_struct *wakee, struct task_struct *curr)
-{
+static notrace void
+wake_up_callback(void *probe_data, void *call_data,
+		 const char *format, va_list *args)
+{
+	struct trace_array **ptr = probe_data;
+	struct trace_array *tr = *ptr;
+	struct task_struct *curr;
+	struct task_struct *task;
+	struct rq *__rq;
+
 	if (likely(!tracer_enabled))
 		return;
 
+	/* Skip pid %d state %ld */
+	(void)va_arg(*args, int);
+	(void)va_arg(*args, long);
+	/* now get the meat: "rq %p task %p rq->curr %p" */
+	__rq = va_arg(*args, typeof(__rq));
+	task = va_arg(*args, typeof(task));
+	curr = va_arg(*args, typeof(curr));
+
+	tracing_record_cmdline(task);
 	tracing_record_cmdline(curr);
-	tracing_record_cmdline(wakee);
 
-	wakeup_check_start(wakeup_trace, wakee, curr);
+	wakeup_check_start(tr, task, curr);
 }
 
 static void start_wakeup_tracer(struct trace_array *tr)
 {
+	int ret;
+
+	ret = marker_probe_register("kernel_sched_wakeup",
+			"pid %d state %ld ## rq %p task %p rq->curr %p",
+			wake_up_callback,
+			&wakeup_trace);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't add marker"
+			" probe to kernel_sched_wakeup\n");
+		return;
+	}
+
+	ret = marker_probe_register("kernel_sched_wakeup_new",
+			"pid %d state %ld ## rq %p task %p rq->curr %p",
+			wake_up_callback,
+			&wakeup_trace);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't add marker"
+			" probe to kernel_sched_wakeup_new\n");
+		goto fail_deprobe;
+	}
+
+	ret = marker_probe_register("kernel_sched_schedule",
+		"prev_pid %d next_pid %d prev_state %ld "
+		"## rq %p prev %p next %p",
+		sched_switch_callback,
+		&wakeup_trace);
+	if (ret) {
+		pr_info("sched trace: Couldn't add marker"
+			" probe to kernel_sched_schedule\n");
+		goto fail_deprobe_wake_new;
+	}
+
 	wakeup_reset(tr);
 
 	/*
@@ -215,11 +292,28 @@ static void start_wakeup_tracer(struct t
 	tracer_enabled = 1;
 
 	return;
+fail_deprobe_wake_new:
+	marker_probe_unregister("kernel_sched_wakeup_new",
+				wake_up_callback,
+				&wakeup_trace);
+fail_deprobe:
+	marker_probe_unregister("kernel_sched_wakeup",
+				wake_up_callback,
+				&wakeup_trace);
 }
 
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
+	marker_probe_unregister("kernel_sched_schedule",
+				sched_switch_callback,
+				&wakeup_trace);
+	marker_probe_unregister("kernel_sched_wakeup_new",
+				wake_up_callback,
+				&wakeup_trace);
+	marker_probe_unregister("kernel_sched_wakeup",
+				wake_up_callback,
+				&wakeup_trace);
 }
 
 static void wakeup_tracer_init(struct trace_array *tr)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
