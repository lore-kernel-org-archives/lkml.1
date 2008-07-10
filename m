Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYGJD5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYGJD5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 23:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYGJD5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 23:57:30 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:43812 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753590AbYGJD53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 23:57:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AikFAPQkdUhMQWVt/2dsb2JhbACBW65q
Date: Wed, 9 Jul 2008 23:57:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Cc: akpm@linux-foundation.org, "'Ingo Molnar'" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Thomas Gleixner'" <tglx@linutronix.de>,
       "'Masami Hiramatsu'" <mhiramat@redhat.com>,
       "'Frank Ch. Eigler'" <fche@redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>,
       "'Eduard - Gabriel Munteanu'" <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] ftrace port to tracepoints (linux-next) (nitpick
	update)
Message-ID: <20080710035722.GA19625@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150045.025136754@polymtl.ca> <20080709153434.GA9186@Krystal> <20080709162158.GB10601@Krystal> <20080709190957.GA16779@Krystal> <010401c8e23b$020b6c30$06224490$@css.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <010401c8e23b$020b6c30$06224490$@css.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:54:31 up 35 days,  8:35,  4 users,  load average: 1.87, 1.85,
	2.22
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Takashi Nishiie (t-nishiie@np.css.fujitsu.com) wrote:
> Hi,Mathieu
> 
> I think that it is wonderful that the source code becomes simple by 
> changing kernel markers to tracepoints. 
> 
> However, it seems to forget to correct the error message.
> 

:)

Good catch. Here is the revised version. Thanks!

Mathieu


ftrace port to tracepoints

Porting the trace_mark() used by ftrace to tracepoints. (cleanup)

Changelog :
- Change error messages : marker -> tracepoint

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/trace/trace_sched_switch.c |  120 ++++++---------------------------
 kernel/trace/trace_sched_wakeup.c |  135 +++++++++-----------------------------
 2 files changed, 58 insertions(+), 197 deletions(-)

Index: linux-2.6-lttng/kernel/trace/trace_sched_switch.c
===================================================================
--- linux-2.6-lttng.orig/kernel/trace/trace_sched_switch.c	2008-07-09 23:50:26.000000000 -0400
+++ linux-2.6-lttng/kernel/trace/trace_sched_switch.c	2008-07-09 23:53:06.000000000 -0400
@@ -9,9 +9,9 @@
 #include <linux/debugfs.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
-#include <linux/marker.h>
 #include <linux/ftrace.h>
 
+#include "../sched-trace.h"
 #include "trace.h"
 
 static struct trace_array	*ctx_trace;
@@ -19,16 +19,17 @@ static int __read_mostly	tracer_enabled;
 static atomic_t			sched_ref;
 
 static void
-sched_switch_func(void *private, void *__rq, struct task_struct *prev,
+probe_sched_switch(struct rq *__rq, struct task_struct *prev,
 			struct task_struct *next)
 {
-	struct trace_array **ptr = private;
-	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
 	int cpu;
 
+	if (!atomic_read(&sched_ref))
+		return;
+
 	tracing_record_cmdline(prev);
 	tracing_record_cmdline(next);
 
@@ -37,95 +38,42 @@ sched_switch_func(void *private, void *_
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
+	data = ctx_trace->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		tracing_sched_switch_trace(tr, data, prev, next, flags);
+		tracing_sched_switch_trace(ctx_trace, data, prev, next, flags);
 
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 
-static notrace void
-sched_switch_callback(void *probe_data, void *call_data,
-		      const char *format, va_list *args)
-{
-	struct task_struct *prev;
-	struct task_struct *next;
-	struct rq *__rq;
-
-	if (!atomic_read(&sched_ref))
-		return;
-
-	/* skip prev_pid %d next_pid %d prev_state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	__rq = va_arg(*args, typeof(__rq));
-	prev = va_arg(*args, typeof(prev));
-	next = va_arg(*args, typeof(next));
-
-	/*
-	 * If tracer_switch_func only points to the local
-	 * switch func, it still needs the ptr passed to it.
-	 */
-	sched_switch_func(probe_data, __rq, prev, next);
-}
-
 static void
-wakeup_func(void *private, void *__rq, struct task_struct *wakee, struct
-			task_struct *curr)
+probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee)
 {
-	struct trace_array **ptr = private;
-	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
 	int cpu;
 
-	if (!tracer_enabled)
+	if (!likely(tracer_enabled))
 		return;
 
-	tracing_record_cmdline(curr);
+	tracing_record_cmdline(current);
 
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
+	data = ctx_trace->data[cpu];
 	disabled = atomic_inc_return(&data->disabled);
 
 	if (likely(disabled == 1))
-		tracing_sched_wakeup_trace(tr, data, wakee, curr, flags);
+		tracing_sched_wakeup_trace(ctx_trace, data, wakee, current,
+			flags);
 
 	atomic_dec(&data->disabled);
 	local_irq_restore(flags);
 }
 
-static notrace void
-wake_up_callback(void *probe_data, void *call_data,
-		 const char *format, va_list *args)
-{
-	struct task_struct *curr;
-	struct task_struct *task;
-	struct rq *__rq;
-
-	if (likely(!tracer_enabled))
-		return;
-
-	/* Skip pid %d state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	/* now get the meat: "rq %p task %p rq->curr %p" */
-	__rq = va_arg(*args, typeof(__rq));
-	task = va_arg(*args, typeof(task));
-	curr = va_arg(*args, typeof(curr));
-
-	tracing_record_cmdline(task);
-	tracing_record_cmdline(curr);
-
-	wakeup_func(probe_data, __rq, task, curr);
-}
-
 static void sched_switch_reset(struct trace_array *tr)
 {
 	int cpu;
@@ -140,60 +88,40 @@ static int tracing_sched_register(void)
 {
 	int ret;
 
-	ret = marker_probe_register("kernel_sched_wakeup",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&ctx_trace);
+	ret = register_trace_sched_wakeup(probe_sched_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return ret;
 	}
 
-	ret = marker_probe_register("kernel_sched_wakeup_new",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&ctx_trace);
+	ret = register_trace_sched_wakeup_new(probe_sched_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
-	ret = marker_probe_register("kernel_sched_schedule",
-		"prev_pid %d next_pid %d prev_state %ld "
-		"## rq %p prev %p next %p",
-		sched_switch_callback,
-		&ctx_trace);
+	ret = register_trace_sched_switch(probe_sched_switch);
 	if (ret) {
-		pr_info("sched trace: Couldn't add marker"
+		pr_info("sched trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_schedule\n");
 		goto fail_deprobe_wake_new;
 	}
 
 	return ret;
 fail_deprobe_wake_new:
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&ctx_trace);
+	unregister_trace_sched_wakeup_new(probe_sched_wakeup);
 fail_deprobe:
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&ctx_trace);
+	unregister_trace_sched_wakeup(probe_sched_wakeup);
 	return ret;
 }
 
 static void tracing_sched_unregister(void)
 {
-	marker_probe_unregister("kernel_sched_schedule",
-				sched_switch_callback,
-				&ctx_trace);
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&ctx_trace);
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&ctx_trace);
+	unregister_trace_sched_switch(probe_sched_switch);
+	unregister_trace_sched_wakeup_new(probe_sched_wakeup);
+	unregister_trace_sched_wakeup(probe_sched_wakeup);
 }
 
 static void tracing_start_sched_switch(void)
Index: linux-2.6-lttng/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-2.6-lttng.orig/kernel/trace/trace_sched_wakeup.c	2008-07-09 23:50:26.000000000 -0400
+++ linux-2.6-lttng/kernel/trace/trace_sched_wakeup.c	2008-07-09 23:53:33.000000000 -0400
@@ -15,8 +15,8 @@
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
-#include <linux/marker.h>
 
+#include "../sched-trace.h"
 #include "trace.h"
 
 static struct trace_array	*wakeup_trace;
@@ -109,18 +109,18 @@ static int report_latency(cycle_t delta)
 }
 
 static void notrace
-wakeup_sched_switch(void *private, void *rq, struct task_struct *prev,
+probe_wakeup_sched_switch(struct rq *rq, struct task_struct *prev,
 	struct task_struct *next)
 {
 	unsigned long latency = 0, t0 = 0, t1 = 0;
-	struct trace_array **ptr = private;
-	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
 	long disabled;
 	int cpu;
 
+	tracing_record_cmdline(prev);
+
 	if (unlikely(!tracer_enabled))
 		return;
 
@@ -137,11 +137,11 @@ wakeup_sched_switch(void *private, void 
 		return;
 
 	/* The task we are waiting for is waking up */
-	data = tr->data[wakeup_cpu];
+	data = wakeup_trace->data[wakeup_cpu];
 
 	/* disable local data, not wakeup_cpu data */
 	cpu = raw_smp_processor_id();
-	disabled = atomic_inc_return(&tr->data[cpu]->disabled);
+	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
 	if (likely(disabled != 1))
 		goto out;
 
@@ -151,7 +151,7 @@ wakeup_sched_switch(void *private, void 
 	if (unlikely(!tracer_enabled || next != wakeup_task))
 		goto out_unlock;
 
-	trace_function(tr, data, CALLER_ADDR1, CALLER_ADDR2, flags);
+	trace_function(wakeup_trace, data, CALLER_ADDR1, CALLER_ADDR2, flags);
 
 	/*
 	 * usecs conversion is slow so we try to delay the conversion
@@ -170,38 +170,13 @@ wakeup_sched_switch(void *private, void 
 	t0 = nsecs_to_usecs(T0);
 	t1 = nsecs_to_usecs(T1);
 
-	update_max_tr(tr, wakeup_task, wakeup_cpu);
+	update_max_tr(wakeup_trace, wakeup_task, wakeup_cpu);
 
 out_unlock:
-	__wakeup_reset(tr);
+	__wakeup_reset(wakeup_trace);
 	spin_unlock_irqrestore(&wakeup_lock, flags);
 out:
-	atomic_dec(&tr->data[cpu]->disabled);
-}
-
-static notrace void
-sched_switch_callback(void *probe_data, void *call_data,
-		      const char *format, va_list *args)
-{
-	struct task_struct *prev;
-	struct task_struct *next;
-	struct rq *__rq;
-
-	/* skip prev_pid %d next_pid %d prev_state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	__rq = va_arg(*args, typeof(__rq));
-	prev = va_arg(*args, typeof(prev));
-	next = va_arg(*args, typeof(next));
-
-	tracing_record_cmdline(prev);
-
-	/*
-	 * If tracer_switch_func only points to the local
-	 * switch func, it still needs the ptr passed to it.
-	 */
-	wakeup_sched_switch(probe_data, __rq, prev, next);
+	atomic_dec(&wakeup_trace->data[cpu]->disabled);
 }
 
 static void __wakeup_reset(struct trace_array *tr)
@@ -235,19 +210,24 @@ static void wakeup_reset(struct trace_ar
 }
 
 static void
-wakeup_check_start(struct trace_array *tr, struct task_struct *p,
-		   struct task_struct *curr)
+probe_wakeup(struct rq *rq, struct task_struct *p)
 {
 	int cpu = smp_processor_id();
 	unsigned long flags;
 	long disabled;
 
+	if (likely(!tracer_enabled))
+		return;
+
+	tracing_record_cmdline(p);
+	tracing_record_cmdline(current);
+
 	if (likely(!rt_task(p)) ||
 			p->prio >= wakeup_prio ||
-			p->prio >= curr->prio)
+			p->prio >= current->prio)
 		return;
 
-	disabled = atomic_inc_return(&tr->data[cpu]->disabled);
+	disabled = atomic_inc_return(&wakeup_trace->data[cpu]->disabled);
 	if (unlikely(disabled != 1))
 		goto out;
 
@@ -259,7 +239,7 @@ wakeup_check_start(struct trace_array *t
 		goto out_locked;
 
 	/* reset the trace */
-	__wakeup_reset(tr);
+	__wakeup_reset(wakeup_trace);
 
 	wakeup_cpu = task_cpu(p);
 	wakeup_prio = p->prio;
@@ -269,74 +249,37 @@ wakeup_check_start(struct trace_array *t
 
 	local_save_flags(flags);
 
-	tr->data[wakeup_cpu]->preempt_timestamp = ftrace_now(cpu);
-	trace_function(tr, tr->data[wakeup_cpu],
+	wakeup_trace->data[wakeup_cpu]->preempt_timestamp = ftrace_now(cpu);
+	trace_function(wakeup_trace, wakeup_trace->data[wakeup_cpu],
 		       CALLER_ADDR1, CALLER_ADDR2, flags);
 
 out_locked:
 	spin_unlock(&wakeup_lock);
 out:
-	atomic_dec(&tr->data[cpu]->disabled);
-}
-
-static notrace void
-wake_up_callback(void *probe_data, void *call_data,
-		 const char *format, va_list *args)
-{
-	struct trace_array **ptr = probe_data;
-	struct trace_array *tr = *ptr;
-	struct task_struct *curr;
-	struct task_struct *task;
-	struct rq *__rq;
-
-	if (likely(!tracer_enabled))
-		return;
-
-	/* Skip pid %d state %ld */
-	(void)va_arg(*args, int);
-	(void)va_arg(*args, long);
-	/* now get the meat: "rq %p task %p rq->curr %p" */
-	__rq = va_arg(*args, typeof(__rq));
-	task = va_arg(*args, typeof(task));
-	curr = va_arg(*args, typeof(curr));
-
-	tracing_record_cmdline(task);
-	tracing_record_cmdline(curr);
-
-	wakeup_check_start(tr, task, curr);
+	atomic_dec(&wakeup_trace->data[cpu]->disabled);
 }
 
 static void start_wakeup_tracer(struct trace_array *tr)
 {
 	int ret;
 
-	ret = marker_probe_register("kernel_sched_wakeup",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&wakeup_trace);
+	ret = register_trace_sched_wakeup(probe_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup\n");
 		return;
 	}
 
-	ret = marker_probe_register("kernel_sched_wakeup_new",
-			"pid %d state %ld ## rq %p task %p rq->curr %p",
-			wake_up_callback,
-			&wakeup_trace);
+	ret = register_trace_sched_wakeup_new(probe_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't add marker"
+		pr_info("wakeup trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
-	ret = marker_probe_register("kernel_sched_schedule",
-		"prev_pid %d next_pid %d prev_state %ld "
-		"## rq %p prev %p next %p",
-		sched_switch_callback,
-		&wakeup_trace);
+	ret = register_trace_sched_switch(probe_wakeup_sched_switch);
 	if (ret) {
-		pr_info("sched trace: Couldn't add marker"
+		pr_info("sched trace: Couldn't activate tracepoint"
 			" probe to kernel_sched_schedule\n");
 		goto fail_deprobe_wake_new;
 	}
@@ -357,28 +300,18 @@ static void start_wakeup_tracer(struct t
 
 	return;
 fail_deprobe_wake_new:
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&wakeup_trace);
+	unregister_trace_sched_wakeup_new(probe_wakeup);
 fail_deprobe:
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&wakeup_trace);
+	unregister_trace_sched_wakeup(probe_wakeup);
 }
 
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
-	marker_probe_unregister("kernel_sched_schedule",
-				sched_switch_callback,
-				&wakeup_trace);
-	marker_probe_unregister("kernel_sched_wakeup_new",
-				wake_up_callback,
-				&wakeup_trace);
-	marker_probe_unregister("kernel_sched_wakeup",
-				wake_up_callback,
-				&wakeup_trace);
+	unregister_trace_sched_switch(probe_wakeup_sched_switch);
+	unregister_trace_sched_wakeup_new(probe_wakeup);
+	unregister_trace_sched_wakeup(probe_wakeup);
 }
 
 static void wakeup_tracer_init(struct trace_array *tr)
 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
