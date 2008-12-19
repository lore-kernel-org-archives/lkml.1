Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYLSKIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYLSKIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 05:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYLSKIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 05:08:43 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48539 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYLSKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 05:08:42 -0500
Date: Fri, 19 Dec 2008 12:08:39 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: rostedt@goodmis.org
cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: introduce tracing_reset_online_cpus() helper
Message-ID: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch factors out common code from multiple tracers into a
tracing_reset_online_cpus() function and converts the tracers to use it.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/trace/trace.c              |   10 ++++++++++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_boot.c         |   12 +-----------
 kernel/trace/trace_functions.c    |   14 ++------------
 kernel/trace/trace_hw_branches.c  |   14 ++------------
 kernel/trace/trace_mmiotrace.c    |    6 +-----
 kernel/trace/trace_sched_switch.c |   14 ++------------
 kernel/trace/trace_sysprof.c      |   12 +-----------
 8 files changed, 20 insertions(+), 63 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1a3d6b3..c39a0d8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -679,6 +679,16 @@ void tracing_reset(struct trace_array *tr, int cpu)
 	ftrace_enable_cpu();
 }
 
+void tracing_reset_online_cpus(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+}
+
 #define SAVED_CMDLINES 128
 static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
 static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fc75dce..cc7a4f8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -374,6 +374,7 @@ struct trace_iterator {
 int tracing_is_enabled(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
+void tracing_reset_online_cpus(struct trace_array *tr);
 int tracing_open_generic(struct inode *inode, struct file *filp);
 struct dentry *tracing_init_dentry(void);
 void init_tracer_sysprof_debugfs(struct dentry *d_tracer);
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index a4fa2c5..3ccebde 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -37,16 +37,6 @@ void disable_boot_trace(void)
 		tracing_stop_sched_switch_record();
 }
 
-static void reset_boot_trace(struct trace_array *tr)
-{
-	int cpu;
-
-	tr->time_start = ftrace_now(tr->cpu);
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-}
-
 static int boot_trace_init(struct trace_array *tr)
 {
 	int cpu;
@@ -130,7 +120,7 @@ struct tracer boot_tracer __read_mostly =
 {
 	.name		= "initcall",
 	.init		= boot_trace_init,
-	.reset		= reset_boot_trace,
+	.reset		= tracing_reset_online_cpus,
 	.print_line	= initcall_print_line,
 };
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index e74f6d0..9236d7e 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -16,20 +16,10 @@
 
 #include "trace.h"
 
-static void function_reset(struct trace_array *tr)
-{
-	int cpu;
-
-	tr->time_start = ftrace_now(tr->cpu);
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-}
-
 static void start_function_trace(struct trace_array *tr)
 {
 	tr->cpu = get_cpu();
-	function_reset(tr);
+	tracing_reset_online_cpus(tr);
 	put_cpu();
 
 	tracing_start_cmdline_record();
@@ -55,7 +45,7 @@ static void function_trace_reset(struct trace_array *tr)
 
 static void function_trace_start(struct trace_array *tr)
 {
-	function_reset(tr);
+	tracing_reset_online_cpus(tr);
 }
 
 static struct tracer function_trace __read_mostly =
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index ee29e01..b6a3e20 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -25,16 +25,6 @@ static DEFINE_PER_CPU(unsigned char[SIZEOF_BTS], buffer);
 #define this_buffer per_cpu(buffer, smp_processor_id())
 
 
-static void bts_trace_reset(struct trace_array *tr)
-{
-	int cpu;
-
-	tr->time_start = ftrace_now(tr->cpu);
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-}
-
 static void bts_trace_start_cpu(void *arg)
 {
 	if (this_tracer)
@@ -54,7 +44,7 @@ static void bts_trace_start(struct trace_array *tr)
 {
 	int cpu;
 
-	bts_trace_reset(tr);
+	tracing_reset_online_cpus(tr);
 
 	for_each_cpu_mask(cpu, cpu_possible_map)
 		smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
@@ -78,7 +68,7 @@ static void bts_trace_stop(struct trace_array *tr)
 
 static int bts_trace_init(struct trace_array *tr)
 {
-	bts_trace_reset(tr);
+	tracing_reset_online_cpus(tr);
 	bts_trace_start(tr);
 
 	return 0;
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 2fb6da6..fffcb06 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -22,14 +22,10 @@ static unsigned long prev_overruns;
 
 static void mmio_reset_data(struct trace_array *tr)
 {
-	int cpu;
-
 	overrun_detected = false;
 	prev_overruns = 0;
-	tr->time_start = ftrace_now(tr->cpu);
 
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
+	tracing_reset_online_cpus(tr);
 }
 
 static int mmio_trace_init(struct trace_array *tr)
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 8633905..7f59f91 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -72,16 +72,6 @@ probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee)
 	local_irq_restore(flags);
 }
 
-static void sched_switch_reset(struct trace_array *tr)
-{
-	int cpu;
-
-	tr->time_start = ftrace_now(tr->cpu);
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-}
-
 static int tracing_sched_register(void)
 {
 	int ret;
@@ -197,7 +187,7 @@ void tracing_sched_switch_assign_trace(struct trace_array *tr)
 
 static void start_sched_trace(struct trace_array *tr)
 {
-	sched_switch_reset(tr);
+	tracing_reset_online_cpus(tr);
 	tracing_start_sched_switch_record();
 }
 
@@ -221,7 +211,7 @@ static void sched_switch_trace_reset(struct trace_array *tr)
 
 static void sched_switch_trace_start(struct trace_array *tr)
 {
-	sched_switch_reset(tr);
+	tracing_reset_online_cpus(tr);
 	tracing_start_sched_switch();
 }
 
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 54960ed..01becf1 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -234,20 +234,10 @@ static void stop_stack_timers(void)
 		stop_stack_timer(cpu);
 }
 
-static void stack_reset(struct trace_array *tr)
-{
-	int cpu;
-
-	tr->time_start = ftrace_now(tr->cpu);
-
-	for_each_online_cpu(cpu)
-		tracing_reset(tr, cpu);
-}
-
 static void start_stack_trace(struct trace_array *tr)
 {
 	mutex_lock(&sample_timer_lock);
-	stack_reset(tr);
+	tracing_reset_online_cpus(tr);
 	start_stack_timers();
 	tracer_enabled = 1;
 	mutex_unlock(&sample_timer_lock);
-- 
1.5.4.3

