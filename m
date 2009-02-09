Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZBIVP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZBIVP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZBIVPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:15:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36311 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZBIVPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:15:48 -0500
Date: Mon, 9 Feb 2009 19:15:35 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] tracing: Use a single trace_enabled variable
Message-ID: <20090209211535.GA12820@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: API change/cleanup

$ codiff kernel/trace/built-in.o.before kernel/trace/built-in.o
kernel/trace/trace.c:
  tracing_is_enabled |  -12
  __find_next_entry  |   -5
 2 functions changed, 17 bytes removed, diff: -17

kernel/trace/trace_sched_switch.c:
  tracing_sched_switch_assign_trace |  -13
  tracing_stop_sched_switch_record  |  -74
  tracing_start_sched_switch_record |  -30
 3 functions changed, 117 bytes removed, diff: -117

kernel/trace/trace_sysprof.c:
  stack_trace_reset |  -10
  stack_trace_init  |  -10
 2 functions changed, 20 bytes removed, diff: -20

kernel/trace/trace_irqsoff.c:
  irqsoff_tracer_start |  -16
  irqsoff_tracer_stop  |  -16
  irqsoff_tracer_reset |  -10
  irqsoff_tracer_init  |  -19
 4 functions changed, 61 bytes removed, diff: -61

kernel/trace/trace_sched_wakeup.c:
  wakeup_tracer_stop  |  -16
  wakeup_tracer_start |  -10
  start_wakeup_tracer |  -19
  wakeup_tracer_reset |  -10
 4 functions changed, 55 bytes removed, diff: -55

kernel/trace/built-in.o:
 15 functions changed, 270 bytes removed, diff: -270

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/trace/trace.c              |   15 +-------------
 kernel/trace/trace.h              |    3 +-
 kernel/trace/trace_irqsoff.c      |   22 --------------------
 kernel/trace/trace_sched_switch.c |   40 +------------------------------------
 kernel/trace/trace_sched_wakeup.c |   26 ------------------------
 kernel/trace/trace_sysprof.c      |    5 +---
 6 files changed, 5 insertions(+), 106 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5b1e9a9..37bb6a9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -182,20 +182,7 @@ static struct trace_array	max_tr;
 static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
 
 /* tracer_enabled is used to toggle activation of a tracer */
-static int			tracer_enabled = 1;
-
-/**
- * tracing_is_enabled - return tracer_enabled status
- *
- * This function is used by other tracers to know the status
- * of the tracer_enabled flag.  Tracers may use this function
- * to know if it should enable their features when starting
- * up. See irqsoff tracer for an example (start_irqsoff_tracer).
- */
-int tracing_is_enabled(void)
-{
-	return tracer_enabled;
-}
+int tracer_enabled __read_mostly;
 
 /*
  * trace_buf_size is the size in bytes that is allocated
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7b0518a..faa4791 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -396,8 +396,9 @@ struct trace_iterator {
 	cpumask_var_t		started;
 };
 
+extern int tracer_enabled;
+
 int tracer_init(struct tracer *t, struct trace_array *tr);
-int tracing_is_enabled(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 void tracing_reset_online_cpus(struct trace_array *tr);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index c6b442d..42364e8 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -19,7 +19,6 @@
 #include "trace.h"
 
 static struct trace_array		*irqsoff_trace __read_mostly;
-static int				tracer_enabled __read_mostly;
 
 static DEFINE_PER_CPU(int, tracing_cpu);
 
@@ -356,15 +355,10 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 static void start_irqsoff_tracer(struct trace_array *tr)
 {
 	register_ftrace_function(&trace_ops);
-	if (tracing_is_enabled())
-		tracer_enabled = 1;
-	else
-		tracer_enabled = 0;
 }
 
 static void stop_irqsoff_tracer(struct trace_array *tr)
 {
-	tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
 }
 
@@ -382,16 +376,6 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
 	stop_irqsoff_tracer(tr);
 }
 
-static void irqsoff_tracer_start(struct trace_array *tr)
-{
-	tracer_enabled = 1;
-}
-
-static void irqsoff_tracer_stop(struct trace_array *tr)
-{
-	tracer_enabled = 0;
-}
-
 #ifdef CONFIG_IRQSOFF_TRACER
 static int irqsoff_tracer_init(struct trace_array *tr)
 {
@@ -405,8 +389,6 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.name		= "irqsoff",
 	.init		= irqsoff_tracer_init,
 	.reset		= irqsoff_tracer_reset,
-	.start		= irqsoff_tracer_start,
-	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_irqsoff,
@@ -431,8 +413,6 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.name		= "preemptoff",
 	.init		= preemptoff_tracer_init,
 	.reset		= irqsoff_tracer_reset,
-	.start		= irqsoff_tracer_start,
-	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptoff,
@@ -459,8 +439,6 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.name		= "preemptirqsoff",
 	.init		= preemptirqsoff_tracer_init,
 	.reset		= irqsoff_tracer_reset,
-	.start		= irqsoff_tracer_start,
-	.stop		= irqsoff_tracer_stop,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_preemptirqsoff,
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 30e14fe..828a70b 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -15,7 +15,6 @@
 #include "trace.h"
 
 static struct trace_array	*ctx_trace;
-static int __read_mostly	tracer_enabled;
 static int			sched_ref;
 static DEFINE_MUTEX(sched_register_mutex);
 
@@ -151,43 +150,6 @@ void tracing_start_sched_switch_record(void)
 	}
 
 	tracing_start_sched_switch();
-
-	mutex_lock(&sched_register_mutex);
-	tracer_enabled++;
-	mutex_unlock(&sched_register_mutex);
-}
-
-/**
- * tracing_stop_sched_switch_record - start tracing context switches
- *
- * Turns off context switch tracing for a tracer.
- */
-void tracing_stop_sched_switch_record(void)
-{
-	mutex_lock(&sched_register_mutex);
-	tracer_enabled--;
-	WARN_ON(tracer_enabled < 0);
-	mutex_unlock(&sched_register_mutex);
-
-	tracing_stop_sched_switch();
-}
-
-/**
- * tracing_sched_switch_assign_trace - assign a trace array for ctx switch
- * @tr: trace array pointer to assign
- *
- * Some tracers might want to record the context switches in their
- * trace. This function lets those tracers assign the trace array
- * to use.
- */
-void tracing_sched_switch_assign_trace(struct trace_array *tr)
-{
-	ctx_trace = tr;
-}
-
-static void stop_sched_trace(struct trace_array *tr)
-{
-	tracing_stop_sched_switch_record();
 }
 
 static int sched_switch_trace_init(struct trace_array *tr)
@@ -200,7 +162,7 @@ static int sched_switch_trace_init(struct trace_array *tr)
 static void sched_switch_trace_reset(struct trace_array *tr)
 {
 	if (sched_ref)
-		stop_sched_trace(tr);
+		tracing_stop_sched_switch();
 }
 
 static void sched_switch_trace_start(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 96d7164..c526a1b 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -20,7 +20,6 @@
 #include "trace.h"
 
 static struct trace_array	*wakeup_trace;
-static int __read_mostly	tracer_enabled;
 
 static struct task_struct	*wakeup_task;
 static int			wakeup_cpu;
@@ -289,23 +288,7 @@ static void start_wakeup_tracer(struct trace_array *tr)
 	}
 
 	wakeup_reset(tr);
-
-	/*
-	 * Don't let the tracer_enabled = 1 show up before
-	 * the wakeup_task is reset. This may be overkill since
-	 * wakeup_reset does a spin_unlock after setting the
-	 * wakeup_task to NULL, but I want to be safe.
-	 * This is a slow path anyway.
-	 */
-	smp_wmb();
-
 	register_ftrace_function(&trace_ops);
-
-	if (tracing_is_enabled())
-		tracer_enabled = 1;
-	else
-		tracer_enabled = 0;
-
 	return;
 fail_deprobe_wake_new:
 	unregister_trace_sched_wakeup_new(probe_wakeup);
@@ -315,7 +298,6 @@ fail_deprobe:
 
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
-	tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
 	unregister_trace_sched_switch(probe_wakeup_sched_switch);
 	unregister_trace_sched_wakeup_new(probe_wakeup);
@@ -352,12 +334,6 @@ static void wakeup_tracer_reset(struct trace_array *tr)
 static void wakeup_tracer_start(struct trace_array *tr)
 {
 	wakeup_reset(tr);
-	tracer_enabled = 1;
-}
-
-static void wakeup_tracer_stop(struct trace_array *tr)
-{
-	tracer_enabled = 0;
 }
 
 static struct tracer wakeup_tracer __read_mostly =
@@ -366,7 +342,6 @@ static struct tracer wakeup_tracer __read_mostly =
 	.init		= wakeup_tracer_init,
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
-	.stop		= wakeup_tracer_stop,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
@@ -379,7 +354,6 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.init		= wakeup_rt_tracer_init,
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
-	.stop		= wakeup_tracer_stop,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 84ca9d8..5c986b4 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -18,8 +18,7 @@
 
 #include "trace.h"
 
-static struct trace_array	*sysprof_trace;
-static int __read_mostly	tracer_enabled;
+static struct trace_array *sysprof_trace;
 
 /*
  * 1 msec sample interval by default:
@@ -230,7 +229,6 @@ static void stop_stack_trace(struct trace_array *tr)
 {
 	mutex_lock(&sample_timer_lock);
 	stop_stack_timers();
-	tracer_enabled = 0;
 	mutex_unlock(&sample_timer_lock);
 }
 
@@ -240,7 +238,6 @@ static int stack_trace_init(struct trace_array *tr)
 
 	mutex_lock(&sample_timer_lock);
 	start_stack_timers();
-	tracer_enabled = 1;
 	mutex_unlock(&sample_timer_lock);
 	return 0;
 }
-- 
1.6.0.6

