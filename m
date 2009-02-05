Return-Path: <linux-kernel-owner+w=401wt.eu-S1761172AbZBEUC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbZBEUC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZBEUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:02:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33776 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbZBEUCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:02:16 -0500
Date: Thu, 5 Feb 2009 18:02:00 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 1/1] trace: Call tracing_reset_online_cpus before
	tracer->init()
Message-ID: <20090205200200.GB9846@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

To make it easy for ftrace plugin writers, as this was open coded in
the existing plugins

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 block/blktrace.c                     |    2 --
 kernel/trace/trace.c                 |    8 +++++++-
 kernel/trace/trace.h                 |    1 +
 kernel/trace/trace_branch.c          |    1 -
 kernel/trace/trace_functions.c       |   17 +++--------------
 kernel/trace/trace_functions_graph.c |    1 -
 kernel/trace/trace_hw_branches.c     |    1 -
 kernel/trace/trace_nop.c             |    1 -
 kernel/trace/trace_sched_switch.c    |    8 +-------
 kernel/trace/trace_selftest.c        |   18 +++++++++---------
 kernel/trace/trace_sysprof.c         |   14 ++++----------
 11 files changed, 25 insertions(+), 47 deletions(-)

diff --git a/block/blktrace.c b/block/blktrace.c
index 834cd84..ca6d320 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -1086,8 +1086,6 @@ static void blk_tracer_print_header(struct seq_file *m)
 
 static void blk_tracer_start(struct trace_array *tr)
 {
-	tracing_reset_online_cpus(tr);
-
 	mutex_lock(&blk_probe_mutex);
 	if (atomic_add_return(1, &blk_probes_ref) == 1)
 		if (blk_register_tracepoints())
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8fad377..ef4dbac 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2171,6 +2171,12 @@ tracing_set_trace_read(struct file *filp, char __user *ubuf,
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
+int tracer_init(struct tracer *t, struct trace_array *tr)
+{
+	tracing_reset_online_cpus(tr);
+	return t->init(tr);
+}
+
 static int tracing_set_tracer(const char *buf)
 {
 	struct trace_array *tr = &global_trace;
@@ -2195,7 +2201,7 @@ static int tracing_set_tracer(const char *buf)
 
 	current_trace = t;
 	if (t->init) {
-		ret = t->init(tr);
+		ret = tracer_init(t, tr);
 		if (ret)
 			goto out;
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e03f157..f2742fb 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -395,6 +395,7 @@ struct trace_iterator {
 	cpumask_var_t		started;
 };
 
+int tracer_init(struct tracer *t, struct trace_array *tr);
 int tracing_is_enabled(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 48b2196..f8ae2c5 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -131,7 +131,6 @@ static void stop_branch_trace(struct trace_array *tr)
 
 static int branch_trace_init(struct trace_array *tr)
 {
-	tracing_reset_online_cpus(tr);
 	start_branch_trace(tr);
 	return 0;
 }
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index d067cea..36bf956 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -24,32 +24,21 @@ static struct trace_array	*func_trace;
 static void tracing_start_function_trace(void);
 static void tracing_stop_function_trace(void);
 
-static void start_function_trace(struct trace_array *tr)
+static int function_trace_init(struct trace_array *tr)
 {
 	func_trace = tr;
 	tr->cpu = get_cpu();
-	tracing_reset_online_cpus(tr);
 	put_cpu();
 
 	tracing_start_cmdline_record();
 	tracing_start_function_trace();
-}
-
-static void stop_function_trace(struct trace_array *tr)
-{
-	tracing_stop_function_trace();
-	tracing_stop_cmdline_record();
-}
-
-static int function_trace_init(struct trace_array *tr)
-{
-	start_function_trace(tr);
 	return 0;
 }
 
 static void function_trace_reset(struct trace_array *tr)
 {
-	stop_function_trace(tr);
+	tracing_stop_function_trace();
+	tracing_stop_cmdline_record();
 }
 
 static void function_trace_start(struct trace_array *tr)
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index c97594d..222f97d 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -56,7 +56,6 @@ static int graph_trace_init(struct trace_array *tr)
 					&trace_graph_entry);
 	if (ret)
 		return ret;
-	tracing_reset_online_cpus(tr);
 	tracing_start_cmdline_record();
 
 	return 0;
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index 2aa1c9f..ca4bbcf 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -132,7 +132,6 @@ static int bts_trace_init(struct trace_array *tr)
 	hw_branch_trace = tr;
 
 	register_hotcpu_notifier(&bts_hotcpu_notifier);
-	tracing_reset_online_cpus(tr);
 	bts_trace_start(tr);
 
 	return 0;
diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
index 087b6cb..9aa84bd 100644
--- a/kernel/trace/trace_nop.c
+++ b/kernel/trace/trace_nop.c
@@ -48,7 +48,6 @@ static void stop_nop_trace(struct trace_array *tr)
 static int nop_trace_init(struct trace_array *tr)
 {
 	ctx_trace = tr;
-	tracing_reset_online_cpus(tr);
 	start_nop_trace(tr);
 	return 0;
 }
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index c4f9add..30e14fe 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -185,12 +185,6 @@ void tracing_sched_switch_assign_trace(struct trace_array *tr)
 	ctx_trace = tr;
 }
 
-static void start_sched_trace(struct trace_array *tr)
-{
-	tracing_reset_online_cpus(tr);
-	tracing_start_sched_switch_record();
-}
-
 static void stop_sched_trace(struct trace_array *tr)
 {
 	tracing_stop_sched_switch_record();
@@ -199,7 +193,7 @@ static void stop_sched_trace(struct trace_array *tr)
 static int sched_switch_trace_init(struct trace_array *tr)
 {
 	ctx_trace = tr;
-	start_sched_trace(tr);
+	tracing_start_sched_switch_record();
 	return 0;
 }
 
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 5013812..445700e 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -115,7 +115,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	ftrace_set_filter(func_name, strlen(func_name), 1);
 
 	/* enable tracing */
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		goto out;
@@ -189,7 +189,7 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 	ftrace_enabled = 1;
 	tracer_enabled = 1;
 
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		goto out;
@@ -236,7 +236,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		return ret;
@@ -290,7 +290,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	}
 
 	/* start the tracing */
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		return ret;
@@ -344,7 +344,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	}
 
 	/* start the tracing */
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		goto out;
@@ -476,7 +476,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	wait_for_completion(&isrt);
 
 	/* start the tracing */
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		return ret;
@@ -537,7 +537,7 @@ trace_selftest_startup_sched_switch(struct tracer *trace, struct trace_array *tr
 	int ret;
 
 	/* start the tracing */
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		return ret;
@@ -569,7 +569,7 @@ trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		return 0;
@@ -596,7 +596,7 @@ trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
 	int ret;
 
 	/* start the tracing */
-	ret = trace->init(tr);
+	ret = tracer_init(trace, tr);
 	if (ret) {
 		warn_failed_init_tracer(trace, ret);
 		return ret;
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index eaca5ad..84ca9d8 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -226,15 +226,6 @@ static void stop_stack_timers(void)
 		stop_stack_timer(cpu);
 }
 
-static void start_stack_trace(struct trace_array *tr)
-{
-	mutex_lock(&sample_timer_lock);
-	tracing_reset_online_cpus(tr);
-	start_stack_timers();
-	tracer_enabled = 1;
-	mutex_unlock(&sample_timer_lock);
-}
-
 static void stop_stack_trace(struct trace_array *tr)
 {
 	mutex_lock(&sample_timer_lock);
@@ -247,7 +238,10 @@ static int stack_trace_init(struct trace_array *tr)
 {
 	sysprof_trace = tr;
 
-	start_stack_trace(tr);
+	mutex_lock(&sample_timer_lock);
+	start_stack_timers();
+	tracer_enabled = 1;
+	mutex_unlock(&sample_timer_lock);
 	return 0;
 }
 
-- 
1.6.0.6

