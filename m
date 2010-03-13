Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab0CMQdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 11:33:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab0CMQdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 11:33:20 -0500
Date: Sat, 13 Mar 2010 17:33:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] tracing fixes
Message-ID: <20100313163302.GA12447@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      tracing: Update the comm field in the right variable in update_max_tr

Frederic Weisbecker (1):
      tracing: Include irqflags headers from trace clock

Lai Jiangshan (2):
      tracing: Fix warning in s_next of trace file ops
      ring-buffer: Move disabled check into preempt disable section

Steven Rostedt (6):
      function-graph: Fix unused reference to ftrace_set_func()
      function-graph: Use comment notation for func names of dangling '}'
      function-graph: Init curr_ret_stack with ret_stack
      tracing: Use same local variable when resetting the ring buffer
      tracing: Disable buffer switching when starting or stopping trace
      tracing: Do not record user stack trace from NMI context

Tim Bird (1):
      function-graph: Add tracing_thresh support to function_graph tracer


 kernel/trace/ftrace.c                |    8 ++---
 kernel/trace/ring_buffer.c           |   12 ++++----
 kernel/trace/trace.c                 |   49 ++++++++++++++++++++++++++++-----
 kernel/trace/trace.h                 |    3 +-
 kernel/trace/trace_clock.c           |    1 +
 kernel/trace/trace_functions_graph.c |   27 ++++++++++++++++--
 6 files changed, 77 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8378357..bb53edb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -84,10 +84,6 @@ ftrace_func_t ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t __ftrace_trace_function __read_mostly = ftrace_stub;
 ftrace_func_t ftrace_pid_function __read_mostly = ftrace_stub;
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
-#endif
-
 static void ftrace_list_func(unsigned long ip, unsigned long parent_ip)
 {
 	struct ftrace_ops *op = ftrace_list;
@@ -2276,6 +2272,8 @@ __setup("ftrace_filter=", set_ftrace_filter);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
+static int ftrace_set_func(unsigned long *array, int *idx, char *buffer);
+
 static int __init set_graph_function(char *str)
 {
 	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
@@ -3351,6 +3349,7 @@ void ftrace_graph_init_task(struct task_struct *t)
 {
 	/* Make sure we do not use the parent ret_stack */
 	t->ret_stack = NULL;
+	t->curr_ret_stack = -1;
 
 	if (ftrace_graph_active) {
 		struct ftrace_ret_stack *ret_stack;
@@ -3360,7 +3359,6 @@ void ftrace_graph_init_task(struct task_struct *t)
 				GFP_KERNEL);
 		if (!ret_stack)
 			return;
-		t->curr_ret_stack = -1;
 		atomic_set(&t->tracing_graph_pause, 0);
 		atomic_set(&t->trace_overrun, 0);
 		t->ftrace_timestamp = 0;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8c1b2d2..54191d6 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2232,12 +2232,12 @@ ring_buffer_lock_reserve(struct ring_buffer *buffer, unsigned long length)
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return NULL;
 
-	if (atomic_read(&buffer->record_disabled))
-		return NULL;
-
 	/* If we are tracing schedule, we don't want to recurse */
 	resched = ftrace_preempt_disable();
 
+	if (atomic_read(&buffer->record_disabled))
+		goto out_nocheck;
+
 	if (trace_recursive_lock())
 		goto out_nocheck;
 
@@ -2469,11 +2469,11 @@ int ring_buffer_write(struct ring_buffer *buffer,
 	if (ring_buffer_flags != RB_BUFFERS_ON)
 		return -EBUSY;
 
-	if (atomic_read(&buffer->record_disabled))
-		return -EBUSY;
-
 	resched = ftrace_preempt_disable();
 
+	if (atomic_read(&buffer->record_disabled))
+		goto out;
+
 	cpu = raw_smp_processor_id();
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 032c57c..e52683f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -374,6 +374,21 @@ static int __init set_buf_size(char *str)
 }
 __setup("trace_buf_size=", set_buf_size);
 
+static int __init set_tracing_thresh(char *str)
+{
+	unsigned long threshhold;
+	int ret;
+
+	if (!str)
+		return 0;
+	ret = strict_strtoul(str, 0, &threshhold);
+	if (ret < 0)
+		return 0;
+	tracing_thresh = threshhold * 1000;
+	return 1;
+}
+__setup("tracing_thresh=", set_tracing_thresh);
+
 unsigned long nsecs_to_usecs(unsigned long nsecs)
 {
 	return nsecs / 1000;
@@ -579,9 +594,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 static arch_spinlock_t ftrace_max_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
+unsigned long __read_mostly	tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 unsigned long __read_mostly	tracing_max_latency;
-unsigned long __read_mostly	tracing_thresh;
 
 /*
  * Copy the new maximum trace into the separate maximum-trace
@@ -592,7 +608,7 @@ static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	struct trace_array_cpu *data = tr->data[cpu];
-	struct trace_array_cpu *max_data = tr->data[cpu];
+	struct trace_array_cpu *max_data;
 
 	max_tr.cpu = cpu;
 	max_tr.time_start = data->preempt_timestamp;
@@ -602,7 +618,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	max_data->critical_start = data->critical_start;
 	max_data->critical_end = data->critical_end;
 
-	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
+	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
 	max_data->pid = tsk->pid;
 	max_data->uid = task_uid(tsk);
 	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
@@ -824,10 +840,10 @@ out:
 	mutex_unlock(&trace_types_lock);
 }
 
-static void __tracing_reset(struct trace_array *tr, int cpu)
+static void __tracing_reset(struct ring_buffer *buffer, int cpu)
 {
 	ftrace_disable_cpu();
-	ring_buffer_reset_cpu(tr->buffer, cpu);
+	ring_buffer_reset_cpu(buffer, cpu);
 	ftrace_enable_cpu();
 }
 
@@ -839,7 +855,7 @@ void tracing_reset(struct trace_array *tr, int cpu)
 
 	/* Make sure all commits have finished */
 	synchronize_sched();
-	__tracing_reset(tr, cpu);
+	__tracing_reset(buffer, cpu);
 
 	ring_buffer_record_enable(buffer);
 }
@@ -857,7 +873,7 @@ void tracing_reset_online_cpus(struct trace_array *tr)
 	tr->time_start = ftrace_now(tr->cpu);
 
 	for_each_online_cpu(cpu)
-		__tracing_reset(tr, cpu);
+		__tracing_reset(buffer, cpu);
 
 	ring_buffer_record_enable(buffer);
 }
@@ -934,6 +950,8 @@ void tracing_start(void)
 		goto out;
 	}
 
+	/* Prevent the buffers from switching */
+	arch_spin_lock(&ftrace_max_lock);
 
 	buffer = global_trace.buffer;
 	if (buffer)
@@ -943,6 +961,8 @@ void tracing_start(void)
 	if (buffer)
 		ring_buffer_record_enable(buffer);
 
+	arch_spin_unlock(&ftrace_max_lock);
+
 	ftrace_start();
  out:
 	spin_unlock_irqrestore(&tracing_start_lock, flags);
@@ -964,6 +984,9 @@ void tracing_stop(void)
 	if (trace_stop_count++)
 		goto out;
 
+	/* Prevent the buffers from switching */
+	arch_spin_lock(&ftrace_max_lock);
+
 	buffer = global_trace.buffer;
 	if (buffer)
 		ring_buffer_record_disable(buffer);
@@ -972,6 +995,8 @@ void tracing_stop(void)
 	if (buffer)
 		ring_buffer_record_disable(buffer);
 
+	arch_spin_unlock(&ftrace_max_lock);
+
  out:
 	spin_unlock_irqrestore(&tracing_start_lock, flags);
 }
@@ -1259,6 +1284,13 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
 	if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
 
+	/*
+	 * NMIs can not handle page faults, even with fix ups.
+	 * The save user stack can (and often does) fault.
+	 */
+	if (unlikely(in_nmi()))
+		return;
+
 	event = trace_buffer_lock_reserve(buffer, TRACE_USER_STACK,
 					  sizeof(*entry), flags, pc);
 	if (!event)
@@ -1703,6 +1735,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 		ftrace_enable_cpu();
 
+		iter->leftover = 0;
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
 			;
 
@@ -4248,10 +4281,10 @@ static __init int tracer_init_debugfs(void)
 #ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);
+#endif
 
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
-#endif
 
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fd05bca..1bc8cd1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -396,9 +396,10 @@ extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
+extern unsigned long tracing_thresh;
+
 #ifdef CONFIG_TRACER_MAX_TRACE
 extern unsigned long tracing_max_latency;
-extern unsigned long tracing_thresh;
 
 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
index 84a3a7b..6fbfb8f 100644
--- a/kernel/trace/trace_clock.c
+++ b/kernel/trace/trace_clock.c
@@ -13,6 +13,7 @@
  * Tracer plugins will chose a default from these clocks.
  */
 #include <linux/spinlock.h>
+#include <linux/irqflags.h>
 #include <linux/hardirq.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index e998a82..e9df04b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -237,6 +237,14 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 	return ret;
 }
 
+int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
+{
+	if (tracing_thresh)
+		return 1;
+	else
+		return trace_graph_entry(trace);
+}
+
 static void __trace_graph_return(struct trace_array *tr,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
@@ -290,13 +298,26 @@ void set_graph_array(struct trace_array *tr)
 	smp_mb();
 }
 
+void trace_graph_thresh_return(struct ftrace_graph_ret *trace)
+{
+	if (tracing_thresh &&
+	    (trace->rettime - trace->calltime < tracing_thresh))
+		return;
+	else
+		trace_graph_return(trace);
+}
+
 static int graph_trace_init(struct trace_array *tr)
 {
 	int ret;
 
 	set_graph_array(tr);
-	ret = register_ftrace_graph(&trace_graph_return,
-				    &trace_graph_entry);
+	if (tracing_thresh)
+		ret = register_ftrace_graph(&trace_graph_thresh_return,
+					    &trace_graph_thresh_entry);
+	else
+		ret = register_ftrace_graph(&trace_graph_return,
+					    &trace_graph_entry);
 	if (ret)
 		return ret;
 	tracing_start_cmdline_record();
@@ -920,7 +941,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	} else {
-		ret = trace_seq_printf(s, "} (%ps)\n", (void *)trace->func);
+		ret = trace_seq_printf(s, "} /* %ps */\n", (void *)trace->func);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
