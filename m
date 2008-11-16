Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbYKPE5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbYKPE5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYKPE5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:57:33 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:19256 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYKPE5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:57:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ipS7MAGFA0ohhavFoJEOousrKazGVuS6vS7uHFkIT4Gx0gdm5SYzGhv5wwQasitupd
         gUIvOa4jdKaDMztZzq0N36v/BdA29izuhHmtj8KG2AZ++MqRYED5yy2x4JAH5Q4jSP/x
         lck7TUIpPJ2HawzV14h+TOrzKWC+La0TVHL4Y=
Message-ID: <491FA836.4020101@gmail.com>
Date: Sun, 16 Nov 2008 05:57:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH 2/4] tracing/ftrace: Change the type of the init() callback
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Handle errors during initialization of a tracer

This bring a way to know if the initialization of a tracer successed.
A tracer must return 0 on success and a traditional error (ie: -ENOMEM)
if it fails.
If a tracer fails to init, it is free to print a detailed warn. The tracing
api will not and switch to a new tracer will just return the error from the init
callback.

Note: this will be used for the return tracer.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Paalanen <pq@iki.fi>
Cc: Steven Noonan <steven@uplinklabs.net>
---
 kernel/trace/trace.c                  |    7 ++-
 kernel/trace/trace.h                  |    3 +-
 kernel/trace/trace_boot.c             |    3 +-
 kernel/trace/trace_branch.c           |    3 +-
 kernel/trace/trace_functions.c        |    3 +-
 kernel/trace/trace_functions_return.c |    3 +-
 kernel/trace/trace_irqsoff.c          |    9 +++-
 kernel/trace/trace_mmiotrace.c        |    3 +-
 kernel/trace/trace_nop.c              |    3 +-
 kernel/trace/trace_sched_switch.c     |    3 +-
 kernel/trace/trace_sched_wakeup.c     |    3 +-
 kernel/trace/trace_selftest.c         |   66 ++++++++++++++++++++++++++++----
 kernel/trace/trace_sysprof.c          |    3 +-
 13 files changed, 88 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2d5672d..938ee31 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2638,8 +2638,11 @@ static int tracing_set_tracer(char *buf)
 		current_trace->reset(tr);
 
 	current_trace = t;
-	if (t->init)
-		t->init(tr);
+	if (t->init) {
+		ret = t->init(tr);
+		if (ret)
+			goto out;
+	}
 
 	trace_branch_enable(tr);
  out:
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 790ea8c..cdbd5cc 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -264,7 +264,8 @@ enum print_line_t {
  */
 struct tracer {
 	const char		*name;
-	void			(*init)(struct trace_array *tr);
+	/* Your tracer should raise a warning if init fails */
+	int			(*init)(struct trace_array *tr);
 	void			(*reset)(struct trace_array *tr);
 	void			(*start)(struct trace_array *tr);
 	void			(*stop)(struct trace_array *tr);
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index cb333b7..a4fa2c5 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -47,7 +47,7 @@ static void reset_boot_trace(struct trace_array *tr)
 		tracing_reset(tr, cpu);
 }
 
-static void boot_trace_init(struct trace_array *tr)
+static int boot_trace_init(struct trace_array *tr)
 {
 	int cpu;
 	boot_trace = tr;
@@ -56,6 +56,7 @@ static void boot_trace_init(struct trace_array *tr)
 		tracing_reset(tr, cpu);
 
 	tracing_sched_switch_assign_trace(tr);
+	return 0;
 }
 
 static enum print_line_t
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 8526555..44bd395 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -125,7 +125,7 @@ static void stop_branch_trace(struct trace_array *tr)
 	disable_branch_tracing();
 }
 
-static void branch_trace_init(struct trace_array *tr)
+static int branch_trace_init(struct trace_array *tr)
 {
 	int cpu;
 
@@ -133,6 +133,7 @@ static void branch_trace_init(struct trace_array *tr)
 		tracing_reset(tr, cpu);
 
 	start_branch_trace(tr);
+	return 0;
 }
 
 static void branch_trace_reset(struct trace_array *tr)
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 8693b7a..e74f6d0 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -42,9 +42,10 @@ static void stop_function_trace(struct trace_array *tr)
 	tracing_stop_cmdline_record();
 }
 
-static void function_trace_init(struct trace_array *tr)
+static int function_trace_init(struct trace_array *tr)
 {
 	start_function_trace(tr);
+	return 0;
 }
 
 static void function_trace_reset(struct trace_array *tr)
diff --git a/kernel/trace/trace_functions_return.c b/kernel/trace/trace_functions_return.c
index 7680b21..61185f7 100644
--- a/kernel/trace/trace_functions_return.c
+++ b/kernel/trace/trace_functions_return.c
@@ -24,13 +24,14 @@ static void stop_return_trace(struct trace_array *tr)
 	unregister_ftrace_return();
 }
 
-static void return_trace_init(struct trace_array *tr)
+static int return_trace_init(struct trace_array *tr)
 {
 	int cpu;
 	for_each_online_cpu(cpu)
 		tracing_reset(tr, cpu);
 
 	start_return_trace(tr);
+	return 0;
 }
 
 static void return_trace_reset(struct trace_array *tr)
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index d919d4e..7c2e326 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -416,11 +416,12 @@ static void irqsoff_tracer_close(struct trace_iterator *iter)
 }
 
 #ifdef CONFIG_IRQSOFF_TRACER
-static void irqsoff_tracer_init(struct trace_array *tr)
+static int irqsoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_IRQS_OFF;
 
 	__irqsoff_tracer_init(tr);
+	return 0;
 }
 static struct tracer irqsoff_tracer __read_mostly =
 {
@@ -442,11 +443,12 @@ static struct tracer irqsoff_tracer __read_mostly =
 #endif
 
 #ifdef CONFIG_PREEMPT_TRACER
-static void preemptoff_tracer_init(struct trace_array *tr)
+static int preemptoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_PREEMPT_OFF;
 
 	__irqsoff_tracer_init(tr);
+	return 0;
 }
 
 static struct tracer preemptoff_tracer __read_mostly =
@@ -471,11 +473,12 @@ static struct tracer preemptoff_tracer __read_mostly =
 #if defined(CONFIG_IRQSOFF_TRACER) && \
 	defined(CONFIG_PREEMPT_TRACER)
 
-static void preemptirqsoff_tracer_init(struct trace_array *tr)
+static int preemptirqsoff_tracer_init(struct trace_array *tr)
 {
 	trace_type = TRACER_IRQS_OFF | TRACER_PREEMPT_OFF;
 
 	__irqsoff_tracer_init(tr);
+	return 0;
 }
 
 static struct tracer preemptirqsoff_tracer __read_mostly =
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 51bcf37..433d650 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -30,13 +30,14 @@ static void mmio_reset_data(struct trace_array *tr)
 		tracing_reset(tr, cpu);
 }
 
-static void mmio_trace_init(struct trace_array *tr)
+static int mmio_trace_init(struct trace_array *tr)
 {
 	pr_debug("in %s\n", __func__);
 	mmio_trace_array = tr;
 
 	mmio_reset_data(tr);
 	enable_mmiotrace();
+	return 0;
 }
 
 static void mmio_trace_reset(struct trace_array *tr)
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 2ef1d22..0e77415 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -24,7 +24,7 @@ static void stop_nop_trace(struct trace_array *tr)
 	/* Nothing to do! */
 }
 
-static void nop_trace_init(struct trace_array *tr)
+static int nop_trace_init(struct trace_array *tr)
 {
 	int cpu;
 	ctx_trace = tr;
@@ -33,6 +33,7 @@ static void nop_trace_init(struct trace_array *tr)
 		tracing_reset(tr, cpu);
 
 	start_nop_trace(tr);
+	return 0;
 }
 
 static void nop_trace_reset(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index be35bdf..8633905 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -206,10 +206,11 @@ static void stop_sched_trace(struct trace_array *tr)
 	tracing_stop_sched_switch_record();
 }
 
-static void sched_switch_trace_init(struct trace_array *tr)
+static int sched_switch_trace_init(struct trace_array *tr)
 {
 	ctx_trace = tr;
 	start_sched_trace(tr);
+	return 0;
 }
 
 static void sched_switch_trace_reset(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 983f2b1..0067b49 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -331,10 +331,11 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 	unregister_trace_sched_wakeup(probe_wakeup);
 }
 
-static void wakeup_tracer_init(struct trace_array *tr)
+static int wakeup_tracer_init(struct trace_array *tr)
 {
 	wakeup_trace = tr;
 	start_wakeup_tracer(tr);
+	return 0;
 }
 
 static void wakeup_tracer_reset(struct trace_array *tr)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 24e6e07..c9fa616 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -71,6 +71,11 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 	return ret;
 }
 
+static inline void warn_failed_init_tracer(struct tracer *trace, int init_ret)
+{
+	printk(KERN_WARNING "Failed to init %s tracer, init returned %d\n",
+		trace->name, init_ret);
+}
 #ifdef CONFIG_FUNCTION_TRACER
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -111,7 +116,11 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	ftrace_set_filter(func_name, strlen(func_name), 1);
 
 	/* enable tracing */
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		goto out;
+	}
 
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
@@ -181,7 +190,12 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 	ftrace_enabled = 1;
 	tracer_enabled = 1;
 
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		goto out;
+	}
+
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 	/* stop the tracing. */
@@ -223,7 +237,12 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return ret;
+	}
+
 	/* reset the max latency */
 	tracing_max_latency = 0;
 	/* disable interrupts for a bit */
@@ -272,7 +291,12 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	}
 
 	/* start the tracing */
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return ret;
+	}
+
 	/* reset the max latency */
 	tracing_max_latency = 0;
 	/* disable preemption for a bit */
@@ -321,7 +345,11 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	}
 
 	/* start the tracing */
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		goto out;
+	}
 
 	/* reset the max latency */
 	tracing_max_latency = 0;
@@ -449,7 +477,12 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	wait_for_completion(&isrt);
 
 	/* start the tracing */
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return ret;
+	}
+
 	/* reset the max latency */
 	tracing_max_latency = 0;
 
@@ -505,7 +538,12 @@ trace_selftest_startup_sched_switch(struct tracer *trace, struct trace_array *tr
 	int ret;
 
 	/* start the tracing */
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return ret;
+	}
+
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 	/* stop the tracing. */
@@ -532,7 +570,12 @@ trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return 0;
+	}
+
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 	/* stop the tracing. */
@@ -554,7 +597,12 @@ trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	trace->init(tr);
+	ret = trace->init(tr);
+	if (ret) {
+		warn_failed_init_tracer(trace, ret);
+		return ret;
+	}
+
 	/* Sleep for a 1/10 of a second */
 	msleep(100);
 	/* stop the tracing. */
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index dc2f690..a10a8dc 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -261,11 +261,12 @@ static void stop_stack_trace(struct trace_array *tr)
 	mutex_unlock(&sample_timer_lock);
 }
 
-static void stack_trace_init(struct trace_array *tr)
+static int stack_trace_init(struct trace_array *tr)
 {
 	sysprof_trace = tr;
 
 	start_stack_trace(tr);
+	return 0;
 }
 
 static void stack_trace_reset(struct trace_array *tr)
-- 
1.5.2.5
