Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbYC0Plc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbYC0Plc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 11:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYC0PlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 11:41:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55183 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbYC0PlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 11:41:21 -0400
Date: Thu, 27 Mar 2008 16:40:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch for 2.6.26 0/7] Architecture Independent Markers
Message-ID: <20080327154053.GA5890@elte.hu>
References: <20080327132057.449831367@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327132057.449831367@polymtl.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Andrew,
> 
> After a few RFC rounds, I propose these markers for 2.6.26. They 
> include work done after comments from the memory management community. 
> Most of them have been used by the LTTng project for about 2 years.

very strong NACK. When markers went into 2.6.24 i initially believed 
your claims that my earlier objections about markers have been resolved 
and that it's a lightweight, useful facility.

so we optimistically used markers in ftrace (see sched-devel.git) for 
the scheduler, and i was shocked about marker impact:

just 3 ftrace markers in the scheduler plus their support code bloated 
the kernel by 5k (!), 288 bytes for only 3 markers in the scheduler 
itself, the rest in support code to manage the markers - that's 96 bytes 
added per every marker (44 (!) bytes of that in the fastpath!).

44 bytes per marker per fastpast is _NOT_ acceptable in any way, shape 
or form. Those 3 limited markers have the same cache cost as adding 
mcount callbacks for dyn-ftrace to the _whole_ scheduler ...

as i told you many, many moons ago, repeatedly: acceptable cost is a 5 
bytes callout that is patched to a NOP, and _maybe_ a little bit more to 
prepare parameters for the function calls. Not 44 bytes. Not 96 bytes. 
Not 5K total cost. Paravirt ops are super-lightweight in comparison.

and this stuff _can_ be done sanely and cheaply and in fact we have done 
it: see ftrace in sched-devel.git, and compare its cost.

see further details in the tongue-in-cheek commit below.

	Ingo

--------------------->
Subject: sched: reintroduce markers
From: Ingo Molnar <mingo@elte.hu>

Scheduler markers are seriously bloated - so lets add them:

      text    data     bss     dec     hex filename
   7209664  852020 1634872 9696556  93f52c vmlinux.before
   7214679  852188 1634872 9701739  94096b vmlinux.after

5K more bloat!

but that's not just bloat in the slowpath and tracer bloat, it's
also fastpath bloat:

     text    data     bss     dec     hex filename
    37642    7014     384   45040    aff0 sched.o.before
    37930    7134     384   45448    b188 sched.o.after

288 bytes for only 3 markers in the scheduler - that's 96 bytes added
per every marker (44 bytes of that in the fastpath).

and the tracer codepath is now slower and more complex as well.

A classic lose-lose situation, so let's apply this patch. Not!

NACK-ed-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h             |   36 --------
 kernel/sched.c                    |   11 +-
 kernel/trace/trace.h              |   12 --
 kernel/trace/trace_functions.c    |    2 
 kernel/trace/trace_sched_switch.c |  163 +++++++++++++++++++++++++++++++++++---
 kernel/trace/trace_sched_wakeup.c |  146 +++++++++++++++++++++++++++++++---
 6 files changed, 299 insertions(+), 71 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -2031,42 +2031,6 @@ extern int sched_mc_power_savings, sched
 
 extern void normalize_rt_tasks(void);
 
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
-extern void
-ftrace_ctx_switch(struct task_struct *prev, struct task_struct *next);
-#else
-static inline void
-ftrace_ctx_switch(struct task_struct *prev, struct task_struct *next)
-{
-}
-#endif
-
-#ifdef CONFIG_SCHED_TRACER
-extern void
-ftrace_wake_up_task(struct task_struct *wakee, struct task_struct *curr);
-extern void
-ftrace_wake_up_new_task(struct task_struct *wakee, struct task_struct *curr);
-#else
-static inline void
-ftrace_wake_up_task(struct task_struct *wakee, struct task_struct *curr)
-{
-}
-static inline void
-ftrace_wake_up_new_task(struct task_struct *wakee, struct task_struct *curr)
-{
-}
-#endif
-
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
-extern void
-ftrace_ctx_switch(struct task_struct *prev, struct task_struct *next);
-#else
-static inline void
-ftrace_ctx_switch(struct task_struct *prev, struct task_struct *next)
-{
-}
-#endif
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 extern struct task_group init_task_group;
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -1886,7 +1886,9 @@ static int try_to_wake_up(struct task_st
 
 out_activate:
 #endif /* CONFIG_SMP */
-	ftrace_wake_up_task(p, rq->curr);
+	trace_mark(kernel_sched_wakeup,
+		   "p %p rq->curr %p",
+		   p, rq->curr);
 
 	schedstat_inc(p, se.nr_wakeups);
 	if (sync)
@@ -2028,7 +2030,9 @@ void fastcall wake_up_new_task(struct ta
 		p->sched_class->task_new(rq, p);
 		inc_nr_running(rq);
 	}
-	ftrace_wake_up_new_task(p, rq->curr);
+	trace_mark(kernel_sched_wakeup_new,
+		   "p %p rq->curr %p",
+		   p, rq->curr);
 
 	check_preempt_curr(rq, p);
 #ifdef CONFIG_SMP
@@ -2202,7 +2206,8 @@ context_switch(struct rq *rq, struct tas
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	ftrace_ctx_switch(prev, next);
+	trace_mark(kernel_sched_schedule,
+		   "prev %p next %p", prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
Index: linux/kernel/trace/trace.h
===================================================================
--- linux.orig/kernel/trace/trace.h
+++ linux/kernel/trace/trace.h
@@ -134,6 +134,8 @@ void tracing_start_function_trace(void);
 void tracing_stop_function_trace(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
+void tracing_start_sched_switch(void);
+void tracing_stop_sched_switch(void);
 
 extern int tracing_sched_switch_enabled;
 extern unsigned long tracing_max_latency;
@@ -148,16 +150,6 @@ static inline notrace cycle_t now(int cp
 	return cpu_clock(cpu);
 }
 
-#ifdef CONFIG_SCHED_TRACER
-extern void notrace
-wakeup_sched_switch(struct task_struct *prev, struct task_struct *next);
-#else
-static inline void
-wakeup_sched_switch(struct task_struct *prev, struct task_struct *next)
-{
-}
-#endif
-
 #ifdef CONFIG_CONTEXT_SWITCH_TRACER
 typedef void
 (*tracer_switch_func_t)(void *private,
Index: linux/kernel/trace/trace_functions.c
===================================================================
--- linux.orig/kernel/trace/trace_functions.c
+++ linux/kernel/trace/trace_functions.c
@@ -30,10 +30,12 @@ static notrace void start_function_trace
 {
 	function_reset(tr);
 	tracing_start_function_trace();
+	tracing_start_sched_switch();
 }
 
 static notrace void stop_function_trace(struct trace_array *tr)
 {
+	tracing_stop_sched_switch();
 	tracing_stop_function_trace();
 }
 
Index: linux/kernel/trace/trace_sched_switch.c
===================================================================
--- linux.orig/kernel/trace/trace_sched_switch.c
+++ linux/kernel/trace/trace_sched_switch.c
@@ -16,12 +16,17 @@
 
 static struct trace_array	*ctx_trace;
 static int __read_mostly	tracer_enabled;
+static atomic_t			sched_ref;
 int __read_mostly		tracing_sched_switch_enabled;
 
+static DEFINE_SPINLOCK(sched_switch_func_lock);
+
 static void notrace
-ctx_switch_func(struct task_struct *prev, struct task_struct *next)
+sched_switch_func(void *private, struct task_struct *prev,
+		  struct task_struct *next)
 {
-	struct trace_array *tr = ctx_trace;
+	struct trace_array **ptr = private;
+	struct trace_array *tr = *ptr;
 	struct trace_array_cpu *data;
 	unsigned long flags;
 	long disabled;
@@ -42,20 +47,115 @@ ctx_switch_func(struct task_struct *prev
 	raw_local_irq_restore(flags);
 }
 
-void ftrace_ctx_switch(struct task_struct *prev, struct task_struct *next)
+static struct tracer_switch_ops sched_switch_ops __read_mostly =
+{
+	.func		= sched_switch_func,
+	.private	= &ctx_trace,
+};
+
+static tracer_switch_func_t __read_mostly
+	tracer_switch_func = sched_switch_func;
+
+static struct tracer_switch_ops __read_mostly
+	*tracer_switch_func_ops = &sched_switch_ops;
+
+static void notrace
+sched_switch_func_loop(void *private, struct task_struct *prev,
+		       struct task_struct *next)
 {
-	tracing_record_cmdline(prev);
+	struct tracer_switch_ops *ops = tracer_switch_func_ops;
+
+	/* take care of alpha acting funny */
+	read_barrier_depends();
 
+	for (; ops != NULL; ops = ops->next) {
+		/* silly alpha */
+		read_barrier_depends();
+		ops->func(ops->private, prev, next);
+	}
+}
+
+notrace int register_tracer_switch(struct tracer_switch_ops *ops)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sched_switch_func_lock, flags);
+	ops->next = tracer_switch_func_ops;
 	/*
-	 * If tracer_switch_func only points to the local
-	 * switch func, it still needs the ptr passed to it.
+	 * We are entering ops into the switch list but another
+	 * CPU might be walking that list. We need to make sure
+	 * the ops->next pointer is valid before another CPU sees
+	 * the ops pointer included into the switch list.
 	 */
-	ctx_switch_func(prev, next);
+	smp_wmb();
+	tracer_switch_func_ops = ops;
+
+	if (ops->next == &sched_switch_ops)
+		tracer_switch_func = sched_switch_func_loop;
+
+	spin_unlock_irqrestore(&sched_switch_func_lock, flags);
+
+	return 0;
+}
+
+notrace int unregister_tracer_switch(struct tracer_switch_ops *ops)
+{
+	unsigned long flags;
+	struct tracer_switch_ops **p = &tracer_switch_func_ops;
+	int ret;
+
+	spin_lock_irqsave(&sched_switch_func_lock, flags);
 
 	/*
-	 * Chain to the wakeup tracer (this is a NOP if disabled):
+	 * If the sched_switch is the only one left, then
+	 *  only call that function.
 	 */
-	wakeup_sched_switch(prev, next);
+	if (*p == ops && ops->next == &sched_switch_ops) {
+		tracer_switch_func = sched_switch_func;
+		tracer_switch_func_ops = &sched_switch_ops;
+		goto out;
+	}
+
+	for (; *p != &sched_switch_ops; p = &(*p)->next)
+		if (*p == ops)
+			break;
+
+	if (*p != ops) {
+		ret = -1;
+		goto out;
+	}
+
+	*p = (*p)->next;
+
+ out:
+	spin_unlock_irqrestore(&sched_switch_func_lock, flags);
+
+	return 0;
+}
+
+static notrace void
+sched_switch_callback(const struct marker *mdata, void *private_data,
+		      const char *format, ...)
+{
+	struct task_struct *prev;
+	struct task_struct *next;
+	va_list ap;
+
+	if (!atomic_read(&sched_ref))
+		return;
+
+	tracing_record_cmdline(current);
+
+	va_start(ap, format);
+	prev = va_arg(ap, typeof(prev));
+	next = va_arg(ap, typeof(next));
+	va_end(ap);
+
+	/*
+	 * If tracer_switch_func only points to the local
+	 * switch func, it still needs the ptr passed to it.
+	 */
+	tracer_switch_func(mdata->private, prev, next);
 }
 
 static notrace void sched_switch_reset(struct trace_array *tr)
@@ -72,10 +172,12 @@ static notrace void start_sched_trace(st
 {
 	sched_switch_reset(tr);
 	tracer_enabled = 1;
+	tracing_start_sched_switch();
 }
 
 static notrace void stop_sched_trace(struct trace_array *tr)
 {
+	tracing_stop_sched_switch();
 	tracer_enabled = 0;
 }
 
@@ -110,6 +212,35 @@ static struct tracer sched_switch_trace 
 	.ctrl_update	= sched_switch_trace_ctrl_update,
 };
 
+static int tracing_sched_arm(void)
+{
+	int ret;
+
+	ret = marker_arm("kernel_sched_schedule");
+	if (ret)
+		pr_info("sched trace: Couldn't arm probe switch_to\n");
+
+	return ret;
+}
+
+void tracing_start_sched_switch(void)
+{
+	long ref;
+
+	ref = atomic_inc_return(&sched_ref);
+	if (tracing_sched_switch_enabled && ref == 1)
+		tracing_sched_arm();
+}
+
+void tracing_stop_sched_switch(void)
+{
+	long ref;
+
+	ref = atomic_dec_and_test(&sched_ref);
+	if (tracing_sched_switch_enabled && ref)
+		marker_disarm("kernel_sched_schedule");
+}
+
 __init static int init_sched_switch_trace(void)
 {
 	int ret;
@@ -118,8 +249,22 @@ __init static int init_sched_switch_trac
 	if (ret)
 		return ret;
 
+	ret = marker_probe_register("kernel_sched_schedule",
+				    "prev %p next %p",
+				    sched_switch_callback,
+				    &ctx_trace);
+	if (ret) {
+		pr_info("sched trace: Couldn't add marker"
+			" probe to switch_to\n");
+		goto out;
+	}
+
+	if (atomic_read(&sched_ref))
+		ret = tracing_sched_arm();
+
 	tracing_sched_switch_enabled = 1;
 
+out:
 	return ret;
 }
 device_initcall(init_sched_switch_trace);
Index: linux/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux.orig/kernel/trace/trace_sched_wakeup.c
+++ linux/kernel/trace/trace_sched_wakeup.c
@@ -44,12 +44,66 @@ static int notrace report_latency(cycle_
 	return 1;
 }
 
-void notrace
-wakeup_sched_switch(struct task_struct *prev, struct task_struct *next)
+#ifdef CONFIG_FTRACE
+/* irqsoff uses its own function trace to keep the overhead down */
+static void notrace
+wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
 {
-	unsigned long latency = 0, t0 = 0, t1 = 0;
 	struct trace_array *tr = wakeup_trace;
 	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int resched;
+	int tcpu;
+	int cpu;
+
+	if (likely(!tracer_enabled) || !tr)
+		return;
+
+	resched = need_resched();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (likely(disabled != 1))
+		goto out;
+
+	spin_lock_irqsave(&wakeup_lock, flags);
+	if (wakeup_task)
+		tcpu = task_cpu(wakeup_task);
+	else
+		tcpu = -1;
+	spin_unlock_irqrestore(&wakeup_lock, flags);
+
+	if (cpu == tcpu)
+		ftrace(tr, data, ip, parent_ip, flags);
+
+out:
+	atomic_dec(&data->disabled);
+
+	/* prevent recursion with scheduler */
+	if (resched)
+		preempt_enable_no_resched_notrace();
+	else
+		preempt_enable_notrace();
+}
+
+static struct ftrace_ops trace_ops __read_mostly =
+{
+	.func		= wakeup_tracer_call,
+};
+#endif /* CONFIG_FTRACE */
+
+static void notrace
+wakeup_sched_switch(void *private, struct task_struct *prev,
+		    struct task_struct *next)
+{
+	unsigned long latency = 0, t0 = 0, t1 = 0;
+	struct trace_array **ptr = private;
+	struct trace_array *tr = *ptr;
+	struct trace_array_cpu *data;
 	cycle_t T0, T1, delta;
 	unsigned long flags;
 	long disabled;
@@ -130,8 +184,14 @@ out_unlock:
 	spin_unlock_irqrestore(&wakeup_lock, flags);
 out:
 	atomic_dec(&tr->data[cpu]->disabled);
+
 }
 
+static struct tracer_switch_ops switch_ops __read_mostly = {
+	.func		= wakeup_sched_switch,
+	.private	= &wakeup_trace,
+};
+
 static void notrace __wakeup_reset(struct trace_array *tr)
 {
 	struct trace_array_cpu *data;
@@ -206,26 +266,51 @@ out:
 	atomic_dec(&tr->data[cpu]->disabled);
 }
 
-notrace void
-ftrace_wake_up_task(struct task_struct *wakee, struct task_struct *curr)
+static notrace void
+wake_up_callback(const struct marker *mdata, void *private_data,
+		 const char *format, ...)
 {
+	struct trace_array **ptr = mdata->private;
+	struct trace_array *tr = *ptr;
+	struct task_struct *curr;
+	struct task_struct *p;
+	va_list ap;
+
 	if (likely(!tracer_enabled))
 		return;
 
-	wakeup_check_start(wakeup_trace, wakee, curr);
-}
+	va_start(ap, format);
 
-notrace void
-ftrace_wake_up_new_task(struct task_struct *wakee, struct task_struct *curr)
-{
-	if (likely(!tracer_enabled))
-		return;
+	/* now get the meat: "p %p rq->curr %p" */
+	p = va_arg(ap, typeof(p));
+	curr = va_arg(ap, typeof(curr));
+
+	va_end(ap);
 
-	wakeup_check_start(wakeup_trace, wakee, curr);
+	wakeup_check_start(tr, p, curr);
 }
 
 static notrace void start_wakeup_tracer(struct trace_array *tr)
 {
+	int ret;
+
+	ret = marker_arm("kernel_sched_wakeup");
+	if (ret) {
+		pr_info("wakeup trace: Couldn't arm probe"
+			" kernel_sched_wakeup\n");
+		return;
+	}
+
+	ret = marker_arm("kernel_sched_wakeup_new");
+	if (ret) {
+		pr_info("wakeup trace: Couldn't arm probe"
+			" kernel_sched_wakeup_new\n");
+		goto out;
+	}
+
+	register_tracer_switch(&switch_ops);
+	tracing_start_sched_switch();
+
 	wakeup_reset(tr);
 
 	/*
@@ -238,13 +323,22 @@ static notrace void start_wakeup_tracer(
 	smp_wmb();
 
 	tracer_enabled = 1;
+	register_ftrace_function(&trace_ops);
 
 	return;
+
+out:
+	marker_disarm("kernel_sched_wakeup");
 }
 
 static notrace void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
+	tracing_stop_sched_switch();
+	unregister_tracer_switch(&switch_ops);
+	marker_disarm("kernel_sched_wakeup");
+	marker_disarm("kernel_sched_wakeup_new");
+	unregister_ftrace_function(&trace_ops);
 }
 
 static notrace void wakeup_tracer_init(struct trace_array *tr)
@@ -305,6 +399,32 @@ __init static int init_wakeup_tracer(voi
 	if (ret)
 		return ret;
 
+	ret = marker_probe_register("kernel_sched_wakeup",
+				    "p %p rq->curr %p",
+				    wake_up_callback,
+				    &wakeup_trace);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't add marker"
+			" probe to kernel_sched_wakeup\n");
+		goto fail;
+	}
+
+	ret = marker_probe_register("kernel_sched_wakeup_new",
+				    "p %p rq->curr %p",
+				    wake_up_callback,
+				    &wakeup_trace);
+	if (ret) {
+		pr_info("wakeup trace: Couldn't add marker"
+			" probe to kernel_sched_wakeup_new\n");
+		goto fail_deprobe;
+	}
+
+	return 0;
+
+fail_deprobe:
+	marker_probe_unregister("kernel_sched_wakeup");
+fail:
+	unregister_tracer(&wakeup_tracer);
 	return 0;
 }
 device_initcall(init_wakeup_tracer);
