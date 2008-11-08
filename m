Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYKHDvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYKHDvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYKHDr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbYKHDrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:52 -0500
Message-Id: <20081108034749.956095925@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 07/10] ftrace: remove trace array ctrl
Content-Disposition: inline; filename=0007-ftrace-remove-trace-array-ctrl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: remove obsolete variable in trace_array structure

With the new start / stop method of ftrace, the ctrl variable
in the trace_array structure is now obsolete. Remove it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |   20 +++++---------------
 kernel/trace/trace.h              |    1 -
 kernel/trace/trace_functions.c    |    6 ++----
 kernel/trace/trace_irqsoff.c      |    7 ++-----
 kernel/trace/trace_mmiotrace.c    |   11 +++++------
 kernel/trace/trace_nop.c          |    6 ++----
 kernel/trace/trace_sched_switch.c |    6 ++----
 kernel/trace/trace_sched_wakeup.c |   12 ++++--------
 kernel/trace/trace_selftest.c     |    8 --------
 kernel/trace/trace_sysprof.c      |    6 ++----
 10 files changed, 24 insertions(+), 59 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9e83188..5843541 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -537,7 +537,6 @@ int register_tracer(struct tracer *type)
 	if (type->selftest) {
 		struct tracer *saved_tracer = current_trace;
 		struct trace_array *tr = &global_trace;
-		int saved_ctrl = tr->ctrl;
 		int i;
 		/*
 		 * Run a selftest on this tracer.
@@ -550,13 +549,11 @@ int register_tracer(struct tracer *type)
 			tracing_reset(tr, i);
 		}
 		current_trace = type;
-		tr->ctrl = 0;
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
 		ret = type->selftest(type, tr);
 		/* the test is responsible for resetting too */
 		current_trace = saved_tracer;
-		tr->ctrl = saved_ctrl;
 		if (ret) {
 			printk(KERN_CONT "FAILED!\n");
 			goto out;
@@ -966,7 +963,7 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 	int cpu;
 	int pc;
 
-	if (tracing_disabled || !tr->ctrl)
+	if (tracing_disabled)
 		return;
 
 	pc = preempt_count();
@@ -2820,7 +2817,6 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	unsigned long val;
 	char buf[64];
 	int ret;
-	struct trace_array *tr = filp->private_data;
 
 	if (cnt >= sizeof(buf))
 		return -EINVAL;
@@ -2840,12 +2836,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 
 	mutex_lock(&trace_types_lock);
 
-	if (tr->ctrl) {
-		cnt = -EBUSY;
-		pr_info("ftrace: please disable tracing"
-			" before modifying buffer size\n");
-		goto out;
-	}
+	tracing_stop();
 
 	if (val != global_trace.entries) {
 		ret = ring_buffer_resize(global_trace.buffer, val);
@@ -2878,6 +2869,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	if (tracing_disabled)
 		cnt = -ENOMEM;
  out:
+	tracing_start();
 	max_tr.entries = global_trace.entries;
 	mutex_unlock(&trace_types_lock);
 
@@ -2900,9 +2892,8 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 {
 	char *buf;
 	char *end;
-	struct trace_array *tr = &global_trace;
 
-	if (!tr->ctrl || tracing_disabled)
+	if (tracing_disabled)
 		return -EINVAL;
 
 	if (cnt > TRACE_BUF_SIZE)
@@ -3131,7 +3122,7 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	unsigned long flags, irq_flags;
 	int cpu, len = 0, size, pc;
 
-	if (!tr->ctrl || tracing_disabled)
+	if (tracing_disabled)
 		return 0;
 
 	pc = preempt_count();
@@ -3365,7 +3356,6 @@ __init static int tracer_alloc_buffers(void)
 #endif
 
 	/* All seems OK, enable tracing */
-	global_trace.ctrl = 1;
 	tracing_disabled = 0;
 
 	atomic_notifier_chain_register(&panic_notifier_list,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e481eda..cfda9d2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -172,7 +172,6 @@ struct trace_iterator;
 struct trace_array {
 	struct ring_buffer	*buffer;
 	unsigned long		entries;
-	long			ctrl;
 	int			cpu;
 	cycle_t			time_start;
 	struct task_struct	*waiter;
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index e980b87..8693b7a 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -44,14 +44,12 @@ static void stop_function_trace(struct trace_array *tr)
 
 static void function_trace_init(struct trace_array *tr)
 {
-	if (tr->ctrl)
-		start_function_trace(tr);
+	start_function_trace(tr);
 }
 
 static void function_trace_reset(struct trace_array *tr)
 {
-	if (tr->ctrl)
-		stop_function_trace(tr);
+	stop_function_trace(tr);
 }
 
 static void function_trace_start(struct trace_array *tr)
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index ffdf592..d919d4e 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -383,15 +383,12 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
 	smp_wmb();
-
-	if (tr->ctrl)
-		start_irqsoff_tracer(tr);
+	start_irqsoff_tracer(tr);
 }
 
 static void irqsoff_tracer_reset(struct trace_array *tr)
 {
-	if (tr->ctrl)
-		stop_irqsoff_tracer(tr);
+	stop_irqsoff_tracer(tr);
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index fa9354e..51bcf37 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -34,17 +34,16 @@ static void mmio_trace_init(struct trace_array *tr)
 {
 	pr_debug("in %s\n", __func__);
 	mmio_trace_array = tr;
-	if (tr->ctrl) {
-		mmio_reset_data(tr);
-		enable_mmiotrace();
-	}
+
+	mmio_reset_data(tr);
+	enable_mmiotrace();
 }
 
 static void mmio_trace_reset(struct trace_array *tr)
 {
 	pr_debug("in %s\n", __func__);
-	if (tr->ctrl)
-		disable_mmiotrace();
+
+	disable_mmiotrace();
 	mmio_reset_data(tr);
 	mmio_trace_array = NULL;
 }
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index e3c5fbf..2ef1d22 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -32,14 +32,12 @@ static void nop_trace_init(struct trace_array *tr)
 	for_each_online_cpu(cpu)
 		tracing_reset(tr, cpu);
 
-	if (tr->ctrl)
-		start_nop_trace(tr);
+	start_nop_trace(tr);
 }
 
 static void nop_trace_reset(struct trace_array *tr)
 {
-	if (tr->ctrl)
-		stop_nop_trace(tr);
+	stop_nop_trace(tr);
 }
 
 struct tracer nop_trace __read_mostly =
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 7b73fd1..be35bdf 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -209,14 +209,12 @@ static void stop_sched_trace(struct trace_array *tr)
 static void sched_switch_trace_init(struct trace_array *tr)
 {
 	ctx_trace = tr;
-
-	if (tr->ctrl)
-		start_sched_trace(tr);
+	start_sched_trace(tr);
 }
 
 static void sched_switch_trace_reset(struct trace_array *tr)
 {
-	if (tr->ctrl && sched_ref)
+	if (sched_ref)
 		stop_sched_trace(tr);
 }
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 23e54d4..983f2b1 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -334,18 +334,14 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 static void wakeup_tracer_init(struct trace_array *tr)
 {
 	wakeup_trace = tr;
-
-	if (tr->ctrl)
-		start_wakeup_tracer(tr);
+	start_wakeup_tracer(tr);
 }
 
 static void wakeup_tracer_reset(struct trace_array *tr)
 {
-	if (tr->ctrl) {
-		stop_wakeup_tracer(tr);
-		/* make sure we put back any tasks we are tracing */
-		wakeup_reset(tr);
-	}
+	stop_wakeup_tracer(tr);
+	/* make sure we put back any tasks we are tracing */
+	wakeup_reset(tr);
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 7469343..ea4e5d3 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -110,7 +110,6 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	ftrace_set_filter(func_name, strlen(func_name), 1);
 
 	/* enable tracing */
-	tr->ctrl = 1;
 	trace->init(tr);
 
 	/* Sleep for a 1/10 of a second */
@@ -181,7 +180,6 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 	ftrace_enabled = 1;
 	tracer_enabled = 1;
 
-	tr->ctrl = 1;
 	trace->init(tr);
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
@@ -224,7 +222,6 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	tr->ctrl = 1;
 	trace->init(tr);
 	/* reset the max latency */
 	tracing_max_latency = 0;
@@ -261,7 +258,6 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	tr->ctrl = 1;
 	trace->init(tr);
 	/* reset the max latency */
 	tracing_max_latency = 0;
@@ -298,7 +294,6 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	int ret;
 
 	/* start the tracing */
-	tr->ctrl = 1;
 	trace->init(tr);
 
 	/* reset the max latency */
@@ -427,7 +422,6 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	wait_for_completion(&isrt);
 
 	/* start the tracing */
-	tr->ctrl = 1;
 	trace->init(tr);
 	/* reset the max latency */
 	tracing_max_latency = 0;
@@ -484,7 +478,6 @@ trace_selftest_startup_sched_switch(struct tracer *trace, struct trace_array *tr
 	int ret;
 
 	/* start the tracing */
-	tr->ctrl = 1;
 	trace->init(tr);
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
@@ -512,7 +505,6 @@ trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	tr->ctrl = 1;
 	trace->init(tr);
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 8097430..05f7534 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -265,14 +265,12 @@ static void stack_trace_init(struct trace_array *tr)
 {
 	sysprof_trace = tr;
 
-	if (tr->ctrl)
-		start_stack_trace(tr);
+	start_stack_trace(tr);
 }
 
 static void stack_trace_reset(struct trace_array *tr)
 {
-	if (tr->ctrl)
-		stop_stack_trace(tr);
+	stop_stack_trace(tr);
 }
 
 static struct tracer stack_trace __read_mostly =
-- 
1.5.6.5

-- 
