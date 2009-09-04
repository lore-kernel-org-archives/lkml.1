Return-Path: <linux-kernel-owner+w=401wt.eu-S934470AbZIEACh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470AbZIEACh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934399AbZIEACf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:02:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:44611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934152AbZIEABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:01:24 -0400
Message-Id: <20090905000125.504815587@goodmis.org>
References: <20090904235527.520961911@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 Sep 2009 19:55:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/18] tracing: use timestamp to determine start of latency traces
Content-Disposition: inline; filename=0012-tracing-use-timestamp-to-determine-start-of-latency-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the latency tracers reset the ring buffer. Unfortunately
if a commit is in process (due to a trace event), this can corrupt
the ring buffer. When this happens, the ring buffer will detect
the corruption and then permanently disable the ring buffer.

The bug does not crash the system, but it does prevent further tracing
after the bug is hit.

Instead of reseting the trace buffers, the timestamp of the start of
the trace is used instead. The buffers will still contain the previous
data, but the output will not count any data that is before the
timestamp of the trace.

Note, this only affects the static trace output (trace) and not the
runtime trace output (trace_pipe). The runtime trace output does not
make sense for the latency tracers anyway.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |   80 +++++++++++++++++++++++++++++--------
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |    3 +-
 kernel/trace/trace_sched_wakeup.c |    7 +--
 4 files changed, 67 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 54517a8..7daf372 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -454,10 +454,6 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 
-	ftrace_disable_cpu();
-	ring_buffer_reset(tr->buffer);
-	ftrace_enable_cpu();
-
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
 }
@@ -483,7 +479,6 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	ftrace_disable_cpu();
 
-	ring_buffer_reset(max_tr.buffer);
 	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
 
 	ftrace_enable_cpu();
@@ -1374,6 +1369,37 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 	return ent;
 }
 
+static void tracing_iter_reset(struct trace_iterator *iter, int cpu)
+{
+	struct trace_array *tr = iter->tr;
+	struct ring_buffer_event *event;
+	struct ring_buffer_iter *buf_iter;
+	unsigned long entries = 0;
+	u64 ts;
+
+	tr->data[cpu]->skipped_entries = 0;
+
+	if (!iter->buffer_iter[cpu])
+		return;
+
+	buf_iter = iter->buffer_iter[cpu];
+	ring_buffer_iter_reset(buf_iter);
+
+	/*
+	 * We could have the case with the max latency tracers
+	 * that a reset never took place on a cpu. This is evident
+	 * by the timestamp being before the start of the buffer.
+	 */
+	while ((event = ring_buffer_iter_peek(buf_iter, &ts))) {
+		if (ts >= iter->tr->time_start)
+			break;
+		entries++;
+		ring_buffer_read(buf_iter, NULL);
+	}
+
+	tr->data[cpu]->skipped_entries = entries;
+}
+
 /*
  * No necessary locking here. The worst thing which can
  * happen is loosing events consumed at the same time
@@ -1412,10 +1438,9 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 		if (cpu_file == TRACE_PIPE_ALL_CPU) {
 			for_each_tracing_cpu(cpu)
-				ring_buffer_iter_reset(iter->buffer_iter[cpu]);
+				tracing_iter_reset(iter, cpu);
 		} else
-			ring_buffer_iter_reset(iter->buffer_iter[cpu_file]);
-
+			tracing_iter_reset(iter, cpu_file);
 
 		ftrace_enable_cpu();
 
@@ -1464,16 +1489,32 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 	struct trace_array *tr = iter->tr;
 	struct trace_array_cpu *data = tr->data[tr->cpu];
 	struct tracer *type = current_trace;
-	unsigned long total;
-	unsigned long entries;
+	unsigned long entries = 0;
+	unsigned long total = 0;
+	unsigned long count;
 	const char *name = "preemption";
+	int cpu;
 
 	if (type)
 		name = type->name;
 
-	entries = ring_buffer_entries(iter->tr->buffer);
-	total = entries +
-		ring_buffer_overruns(iter->tr->buffer);
+
+	for_each_tracing_cpu(cpu) {
+		count = ring_buffer_entries_cpu(tr->buffer, cpu);
+		/*
+		 * If this buffer has skipped entries, then we hold all
+		 * entries for the trace and we need to ignore the
+		 * ones before the time stamp.
+		 */
+		if (tr->data[cpu]->skipped_entries) {
+			count -= tr->data[cpu]->skipped_entries;
+			/* total is the same as the entries */
+			total += count;
+		} else
+			total += count +
+				ring_buffer_overrun_cpu(tr->buffer, cpu);
+		entries += count;
+	}
 
 	seq_printf(m, "# %s latency trace v1.1.5 on %s\n",
 		   name, UTS_RELEASE);
@@ -1534,6 +1575,9 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
 	if (cpumask_test_cpu(iter->cpu, iter->started))
 		return;
 
+	if (iter->tr->data[iter->cpu]->skipped_entries)
+		return;
+
 	cpumask_set_cpu(iter->cpu, iter->started);
 
 	/* Don't print started cpu buffer for the first entry of the trace */
@@ -1796,19 +1840,23 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (ring_buffer_overruns(iter->tr->buffer))
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
+	/* stop the trace while dumping */
+	tracing_stop();
+
 	if (iter->cpu_file == TRACE_PIPE_ALL_CPU) {
 		for_each_tracing_cpu(cpu) {
 
 			iter->buffer_iter[cpu] =
 				ring_buffer_read_start(iter->tr->buffer, cpu);
+			tracing_iter_reset(iter, cpu);
 		}
 	} else {
 		cpu = iter->cpu_file;
 		iter->buffer_iter[cpu] =
 				ring_buffer_read_start(iter->tr->buffer, cpu);
+		tracing_iter_reset(iter, cpu);
 	}
 
-	/* TODO stop tracer */
 	ret = seq_open(file, &tracer_seq_ops);
 	if (ret < 0) {
 		fail_ret = ERR_PTR(ret);
@@ -1818,9 +1866,6 @@ __tracing_open(struct inode *inode, struct file *file)
 	m = file->private_data;
 	m->private = iter;
 
-	/* stop the trace while dumping */
-	tracing_stop();
-
 	mutex_unlock(&trace_types_lock);
 
 	return iter;
@@ -1831,6 +1876,7 @@ __tracing_open(struct inode *inode, struct file *file)
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
 	}
 	free_cpumask_var(iter->started);
+	tracing_start();
  fail:
 	mutex_unlock(&trace_types_lock);
 	kfree(iter->trace);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f2af713..ca070de 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -241,6 +241,7 @@ struct trace_array_cpu {
 	unsigned long		nice;
 	unsigned long		policy;
 	unsigned long		rt_priority;
+	unsigned long		skipped_entries;
 	cycle_t			preempt_timestamp;
 	pid_t			pid;
 	uid_t			uid;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index b923d13..5555b75 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -178,7 +178,6 @@ out_unlock:
 out:
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
-	tracing_reset(tr, cpu);
 	trace_function(tr, CALLER_ADDR0, parent_ip, flags, pc);
 }
 
@@ -208,7 +207,6 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	data->critical_sequence = max_sequence;
 	data->preempt_timestamp = ftrace_now(cpu);
 	data->critical_start = parent_ip ? : ip;
-	tracing_reset(tr, cpu);
 
 	local_save_flags(flags);
 
@@ -379,6 +377,7 @@ static void __irqsoff_tracer_init(struct trace_array *tr)
 	irqsoff_trace = tr;
 	/* make sure that the tracer is visible */
 	smp_wmb();
+	tracing_reset_online_cpus(tr);
 	start_irqsoff_tracer(tr);
 }
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index eacb272..ad69f10 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -186,11 +186,6 @@ out:
 
 static void __wakeup_reset(struct trace_array *tr)
 {
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		tracing_reset(tr, cpu);
-
 	wakeup_cpu = -1;
 	wakeup_prio = -1;
 
@@ -204,6 +199,8 @@ static void wakeup_reset(struct trace_array *tr)
 {
 	unsigned long flags;
 
+	tracing_reset_online_cpus(tr);
+
 	local_irq_save(flags);
 	__raw_spin_lock(&wakeup_lock);
 	__wakeup_reset(tr);
-- 
1.6.3.3

-- 
