Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYKHDuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYKHDuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 22:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYKHDr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 22:47:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYKHDrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 22:47:51 -0500
Message-Id: <20081108034749.715932501@goodmis.org>
References: <20081108034605.289816911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 22:46:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 06/10] ftrace: remove ctrl_update method
Content-Disposition: inline; filename=0006-ftrace-remove-ctrl_update-method.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Remove the ctrl_update tracer method

With the new quick start/stop method of tracing, the ctrl_update
method is out of date.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |    2 -
 kernel/trace/trace.h              |    1 -
 kernel/trace/trace_boot.c         |    9 -------
 kernel/trace/trace_functions.c    |    9 -------
 kernel/trace/trace_irqsoff.c      |   11 --------
 kernel/trace/trace_mmiotrace.c    |   11 ++------
 kernel/trace/trace_nop.c          |   10 -------
 kernel/trace/trace_sched_switch.c |   10 -------
 kernel/trace/trace_sched_wakeup.c |    9 -------
 kernel/trace/trace_selftest.c     |   48 ++++++++++++++++++++-----------------
 kernel/trace/trace_sysprof.c      |   10 -------
 11 files changed, 29 insertions(+), 101 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dbbdacf..9e83188 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3357,8 +3357,6 @@ __init static int tracer_alloc_buffers(void)
 
 	register_tracer(&nop_trace);
 #ifdef CONFIG_BOOT_TRACER
-	/* We don't want to launch sched_switch tracer yet */
-	global_trace.ctrl = 0;
 	register_tracer(&boot_tracer);
 	current_trace = &boot_tracer;
 	current_trace->init(&global_trace);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 25abfc4..e481eda 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -244,7 +244,6 @@ struct tracer {
 	ssize_t			(*read)(struct trace_iterator *iter,
 					struct file *filp, char __user *ubuf,
 					size_t cnt, loff_t *ppos);
-	void			(*ctrl_update)(struct trace_array *tr);
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	int			(*selftest)(struct tracer *trace,
 					    struct trace_array *tr);
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 0203c10..8f71915 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -58,14 +58,6 @@ static void boot_trace_init(struct trace_array *tr)
 	tracing_sched_switch_assign_trace(tr);
 }
 
-static void boot_trace_ctrl_update(struct trace_array *tr)
-{
-	if (tr->ctrl)
-		enable_boot_trace();
-	else
-		disable_boot_trace();
-}
-
 static enum print_line_t initcall_print_line(struct trace_iterator *iter)
 {
 	int ret;
@@ -102,7 +94,6 @@ struct tracer boot_tracer __read_mostly =
 	.name		= "initcall",
 	.init		= boot_trace_init,
 	.reset		= reset_boot_trace,
-	.ctrl_update	= boot_trace_ctrl_update,
 	.print_line	= initcall_print_line,
 };
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 9f1b0de..e980b87 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -54,14 +54,6 @@ static void function_trace_reset(struct trace_array *tr)
 		stop_function_trace(tr);
 }
 
-static void function_trace_ctrl_update(struct trace_array *tr)
-{
-	if (tr->ctrl)
-		start_function_trace(tr);
-	else
-		stop_function_trace(tr);
-}
-
 static void function_trace_start(struct trace_array *tr)
 {
 	function_reset(tr);
@@ -73,7 +65,6 @@ static struct tracer function_trace __read_mostly =
 	.init	     = function_trace_init,
 	.reset	     = function_trace_reset,
 	.start	     = function_trace_start,
-	.ctrl_update = function_trace_ctrl_update,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_function,
 #endif
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 3509086..ffdf592 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -394,14 +394,6 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
 		stop_irqsoff_tracer(tr);
 }
 
-static void irqsoff_tracer_ctrl_update(struct trace_array *tr)
-{
-	if (tr->ctrl)
-		start_irqsoff_tracer(tr);
-	else
-		stop_irqsoff_tracer(tr);
-}
-
 static void irqsoff_tracer_start(struct trace_array *tr)
 {
 	tracer_enabled = 1;
@@ -442,7 +434,6 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.stop		= irqsoff_tracer_stop,
 	.open		= irqsoff_tracer_open,
 	.close		= irqsoff_tracer_close,
-	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
@@ -470,7 +461,6 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.stop		= irqsoff_tracer_stop,
 	.open		= irqsoff_tracer_open,
 	.close		= irqsoff_tracer_close,
-	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
@@ -500,7 +490,6 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.stop		= irqsoff_tracer_stop,
 	.open		= irqsoff_tracer_open,
 	.close		= irqsoff_tracer_close,
-	.ctrl_update	= irqsoff_tracer_ctrl_update,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index f284846..fa9354e 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -49,15 +49,10 @@ static void mmio_trace_reset(struct trace_array *tr)
 	mmio_trace_array = NULL;
 }
 
-static void mmio_trace_ctrl_update(struct trace_array *tr)
+static void mmio_trace_start(struct trace_array *tr)
 {
 	pr_debug("in %s\n", __func__);
-	if (tr->ctrl) {
-		mmio_reset_data(tr);
-		enable_mmiotrace();
-	} else {
-		disable_mmiotrace();
-	}
+	mmio_reset_data(tr);
 }
 
 static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
@@ -298,10 +293,10 @@ static struct tracer mmio_tracer __read_mostly =
 	.name		= "mmiotrace",
 	.init		= mmio_trace_init,
 	.reset		= mmio_trace_reset,
+	.start		= mmio_trace_start,
 	.pipe_open	= mmio_pipe_open,
 	.close		= mmio_close,
 	.read		= mmio_read,
-	.ctrl_update	= mmio_trace_ctrl_update,
 	.print_line	= mmio_print_line,
 };
 
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 4592b48..e3c5fbf 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -42,21 +42,11 @@ static void nop_trace_reset(struct trace_array *tr)
 		stop_nop_trace(tr);
 }
 
-static void nop_trace_ctrl_update(struct trace_array *tr)
-{
-	/* When starting a new trace, reset the buffers */
-	if (tr->ctrl)
-		start_nop_trace(tr);
-	else
-		stop_nop_trace(tr);
-}
-
 struct tracer nop_trace __read_mostly =
 {
 	.name		= "nop",
 	.init		= nop_trace_init,
 	.reset		= nop_trace_reset,
-	.ctrl_update	= nop_trace_ctrl_update,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest	= trace_selftest_startup_nop,
 #endif
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 79410db..7b73fd1 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -220,15 +220,6 @@ static void sched_switch_trace_reset(struct trace_array *tr)
 		stop_sched_trace(tr);
 }
 
-static void sched_switch_trace_ctrl_update(struct trace_array *tr)
-{
-	/* When starting a new trace, reset the buffers */
-	if (tr->ctrl)
-		start_sched_trace(tr);
-	else
-		stop_sched_trace(tr);
-}
-
 static void sched_switch_trace_start(struct trace_array *tr)
 {
 	sched_switch_reset(tr);
@@ -247,7 +238,6 @@ static struct tracer sched_switch_trace __read_mostly =
 	.reset		= sched_switch_trace_reset,
 	.start		= sched_switch_trace_start,
 	.stop		= sched_switch_trace_stop,
-	.ctrl_update	= sched_switch_trace_ctrl_update,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_sched_switch,
 #endif
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 240577b..23e54d4 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -348,14 +348,6 @@ static void wakeup_tracer_reset(struct trace_array *tr)
 	}
 }
 
-static void wakeup_tracer_ctrl_update(struct trace_array *tr)
-{
-	if (tr->ctrl)
-		start_wakeup_tracer(tr);
-	else
-		stop_wakeup_tracer(tr);
-}
-
 static void wakeup_tracer_start(struct trace_array *tr)
 {
 	wakeup_reset(tr);
@@ -393,7 +385,6 @@ static struct tracer wakeup_tracer __read_mostly =
 	.stop		= wakeup_tracer_stop,
 	.open		= wakeup_tracer_open,
 	.close		= wakeup_tracer_close,
-	.ctrl_update	= wakeup_tracer_ctrl_update,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 90bc752..7469343 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -134,13 +134,13 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	msleep(100);
 
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	ftrace_enabled = 0;
 
 	/* check the trace buffer */
 	ret = trace_test_buffer(tr, &count);
 	trace->reset(tr);
+	tracing_start();
 
 	/* we should only have one item */
 	if (!ret && count != 1) {
@@ -148,6 +148,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 		ret = -1;
 		goto out;
 	}
+
  out:
 	ftrace_enabled = save_ftrace_enabled;
 	tracer_enabled = save_tracer_enabled;
@@ -185,13 +186,13 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	ftrace_enabled = 0;
 
 	/* check the trace buffer */
 	ret = trace_test_buffer(tr, &count);
 	trace->reset(tr);
+	tracing_start();
 
 	if (!ret && !count) {
 		printk(KERN_CONT ".. no entries found ..");
@@ -232,13 +233,13 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	udelay(100);
 	local_irq_enable();
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	/* check both trace buffers */
 	ret = trace_test_buffer(tr, NULL);
 	if (!ret)
 		ret = trace_test_buffer(&max_tr, &count);
 	trace->reset(tr);
+	tracing_start();
 
 	if (!ret && !count) {
 		printk(KERN_CONT ".. no entries found ..");
@@ -269,13 +270,13 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	udelay(100);
 	preempt_enable();
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	/* check both trace buffers */
 	ret = trace_test_buffer(tr, NULL);
 	if (!ret)
 		ret = trace_test_buffer(&max_tr, &count);
 	trace->reset(tr);
+	tracing_start();
 
 	if (!ret && !count) {
 		printk(KERN_CONT ".. no entries found ..");
@@ -312,27 +313,30 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	local_irq_enable();
 
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	/* check both trace buffers */
 	ret = trace_test_buffer(tr, NULL);
-	if (ret)
+	if (ret) {
+		tracing_start();
 		goto out;
+	}
 
 	ret = trace_test_buffer(&max_tr, &count);
-	if (ret)
+	if (ret) {
+		tracing_start();
 		goto out;
+	}
 
 	if (!ret && !count) {
 		printk(KERN_CONT ".. no entries found ..");
 		ret = -1;
+		tracing_start();
 		goto out;
 	}
 
 	/* do the test by disabling interrupts first this time */
 	tracing_max_latency = 0;
-	tr->ctrl = 1;
-	trace->ctrl_update(tr);
+	tracing_start();
 	preempt_disable();
 	local_irq_disable();
 	udelay(100);
@@ -341,8 +345,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	local_irq_enable();
 
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	/* check both trace buffers */
 	ret = trace_test_buffer(tr, NULL);
 	if (ret)
@@ -358,6 +361,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 
  out:
 	trace->reset(tr);
+	tracing_start();
 	tracing_max_latency = save_max;
 
 	return ret;
@@ -448,8 +452,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	msleep(100);
 
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	/* check both trace buffers */
 	ret = trace_test_buffer(tr, NULL);
 	if (!ret)
@@ -457,6 +460,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 
 
 	trace->reset(tr);
+	tracing_start();
 
 	tracing_max_latency = save_max;
 
@@ -485,11 +489,11 @@ trace_selftest_startup_sched_switch(struct tracer *trace, struct trace_array *tr
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	/* check the trace buffer */
 	ret = trace_test_buffer(tr, &count);
 	trace->reset(tr);
+	tracing_start();
 
 	if (!ret && !count) {
 		printk(KERN_CONT ".. no entries found ..");
@@ -513,11 +517,11 @@ trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 	/* stop the tracing. */
-	tr->ctrl = 0;
-	trace->ctrl_update(tr);
+	tracing_stop();
 	/* check the trace buffer */
 	ret = trace_test_buffer(tr, &count);
 	trace->reset(tr);
+	tracing_start();
 
 	return ret;
 }
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 9587d3b..8097430 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -275,21 +275,11 @@ static void stack_trace_reset(struct trace_array *tr)
 		stop_stack_trace(tr);
 }
 
-static void stack_trace_ctrl_update(struct trace_array *tr)
-{
-	/* When starting a new trace, reset the buffers */
-	if (tr->ctrl)
-		start_stack_trace(tr);
-	else
-		stop_stack_trace(tr);
-}
-
 static struct tracer stack_trace __read_mostly =
 {
 	.name		= "sysprof",
 	.init		= stack_trace_init,
 	.reset		= stack_trace_reset,
-	.ctrl_update	= stack_trace_ctrl_update,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_sysprof,
 #endif
-- 
1.5.6.5

-- 
