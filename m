Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYKMBdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYKMBdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYKMBcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:32:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59632 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYKMBcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:32:50 -0500
Message-Id: <20081113013247.974941878@goodmis.org>
References: <20081113013041.086583690@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 20:30:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/1] ftrace: do not update max buffer with no users
Content-Disposition: inline; filename=0001-ftrace-do-not-update-max-buffer-with-no-users.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: only use max latency buffer when a user is configured

Pekka reported a bug with the resizing of the buffers when only the
MMIO tracer was configured. The issue was, to save memory, the max
latency trace buffer was only initialized if a tracer that uses it
is configured in.

What happened was that the max latency buffer was never initialized
when only the MMIO tracer was configurued. The MMIO tracer does not
use the max tracer, which kept it from being initialized. But the
resize code still tried to resize the max latency buffers, but because
they were never allocated, the resize code was passed a NULL pointer.

This patch puts all of the max_tr (max tracer buffer) inside the
TRACER_MAX_TRACE config, to prevent any more errors in its use when
not configured.

Reported-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  157 +++++++++++++++++++++++++++----------------------
 1 files changed, 86 insertions(+), 71 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index abfa810..639b9c0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -95,20 +95,6 @@ static struct trace_array	global_trace;
 
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
-/*
- * The max_tr is used to snapshot the global_trace when a maximum
- * latency is reached. Some tracers will use this to store a maximum
- * trace while it continues examining live traces.
- *
- * The buffers for the max_tr are set up the same as the global_trace.
- * When a snapshot is taken, the link list of the max_tr is swapped
- * with the link list of the global_trace and the buffers are reset for
- * the global_trace so the tracing can continue.
- */
-static struct trace_array	max_tr;
-
-static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
-
 /* tracer_enabled is used to toggle activation of a tracer */
 static int			tracer_enabled = 1;
 
@@ -228,6 +214,21 @@ static const char *trace_options[] = {
 static raw_spinlock_t ftrace_max_lock =
 	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
+#ifdef CONFIG_TRACER_MAX_TRACE
+/*
+ * The max_tr is used to snapshot the global_trace when a maximum
+ * latency is reached. Some tracers will use this to store a maximum
+ * trace while it continues examining live traces.
+ *
+ * The buffers for the max_tr are set up the same as the global_trace.
+ * When a snapshot is taken, the link list of the max_tr is swapped
+ * with the link list of the global_trace and the buffers are reset for
+ * the global_trace so the tracing can continue.
+ */
+static struct trace_array	max_tr;
+
+static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
+
 /*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
@@ -256,6 +257,65 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 }
 
 /**
+ * update_max_tr - snapshot all trace buffers from global_trace to max_tr
+ * @tr: tracer
+ * @tsk: the task with the latency
+ * @cpu: The cpu that initiated the trace.
+ *
+ * Flip the buffers between the @tr and the max_tr and record information
+ * about which task was the cause of this latency.
+ */
+void
+update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
+{
+	struct ring_buffer *buf = tr->buffer;
+
+	WARN_ON_ONCE(!irqs_disabled());
+	__raw_spin_lock(&ftrace_max_lock);
+
+	tr->buffer = max_tr.buffer;
+	max_tr.buffer = buf;
+
+	ftrace_disable_cpu();
+	ring_buffer_reset(tr->buffer);
+	ftrace_enable_cpu();
+
+	__update_max_tr(tr, tsk, cpu);
+	__raw_spin_unlock(&ftrace_max_lock);
+}
+
+/**
+ * update_max_tr_single - only copy one trace over, and reset the rest
+ * @tr - tracer
+ * @tsk - task with the latency
+ * @cpu - the cpu of the buffer to copy.
+ *
+ * Flip the trace of a single CPU buffer between the @tr and the max_tr.
+ */
+void
+update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
+{
+	int ret;
+
+	WARN_ON_ONCE(!irqs_disabled());
+	__raw_spin_lock(&ftrace_max_lock);
+
+	ftrace_disable_cpu();
+
+	ring_buffer_reset(max_tr.buffer);
+	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
+
+	ftrace_enable_cpu();
+
+	WARN_ON_ONCE(ret);
+
+	__update_max_tr(tr, tsk, cpu);
+	__raw_spin_unlock(&ftrace_max_lock);
+}
+
+#endif /* CONFIG_TRACER_MAX_TRACE */
+
+/**
  * trace_seq_printf - sequence printing of trace information
  * @s: trace sequence descriptor
  * @fmt: printf format string
@@ -397,63 +457,6 @@ trace_print_seq(struct seq_file *m, struct trace_seq *s)
 }
 
 /**
- * update_max_tr - snapshot all trace buffers from global_trace to max_tr
- * @tr: tracer
- * @tsk: the task with the latency
- * @cpu: The cpu that initiated the trace.
- *
- * Flip the buffers between the @tr and the max_tr and record information
- * about which task was the cause of this latency.
- */
-void
-update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
-{
-	struct ring_buffer *buf = tr->buffer;
-
-	WARN_ON_ONCE(!irqs_disabled());
-	__raw_spin_lock(&ftrace_max_lock);
-
-	tr->buffer = max_tr.buffer;
-	max_tr.buffer = buf;
-
-	ftrace_disable_cpu();
-	ring_buffer_reset(tr->buffer);
-	ftrace_enable_cpu();
-
-	__update_max_tr(tr, tsk, cpu);
-	__raw_spin_unlock(&ftrace_max_lock);
-}
-
-/**
- * update_max_tr_single - only copy one trace over, and reset the rest
- * @tr - tracer
- * @tsk - task with the latency
- * @cpu - the cpu of the buffer to copy.
- *
- * Flip the trace of a single CPU buffer between the @tr and the max_tr.
- */
-void
-update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
-{
-	int ret;
-
-	WARN_ON_ONCE(!irqs_disabled());
-	__raw_spin_lock(&ftrace_max_lock);
-
-	ftrace_disable_cpu();
-
-	ring_buffer_reset(max_tr.buffer);
-	ret = ring_buffer_swap_cpu(max_tr.buffer, tr->buffer, cpu);
-
-	ftrace_enable_cpu();
-
-	WARN_ON_ONCE(ret);
-
-	__update_max_tr(tr, tsk, cpu);
-	__raw_spin_unlock(&ftrace_max_lock);
-}
-
-/**
  * register_tracer - register a tracer with the ftrace system.
  * @type - the plugin for the tracer
  *
@@ -1892,9 +1895,11 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	}
 
 	mutex_lock(&trace_types_lock);
+#ifdef CONFIG_TRACER_MAX_TRACE
 	if (current_trace && current_trace->print_max)
 		iter->tr = &max_tr;
 	else
+#endif
 		iter->tr = inode->i_private;
 	iter->trace = current_trace;
 	iter->pos = -1;
@@ -2708,8 +2713,10 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	for_each_tracing_cpu(cpu) {
 		if (global_trace.data[cpu])
 			atomic_inc(&global_trace.data[cpu]->disabled);
+#ifdef CONFIG_TRACER_MAX_TRACE
 		if (max_tr.data[cpu])
 			atomic_inc(&max_tr.data[cpu]->disabled);
+#endif
 	}
 
 	if (val != global_trace.entries) {
@@ -2719,6 +2726,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 			goto out;
 		}
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 		ret = ring_buffer_resize(max_tr.buffer, val);
 		if (ret < 0) {
 			int r;
@@ -2733,6 +2741,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 			}
 			goto out;
 		}
+#endif
 
 		global_trace.entries = val;
 	}
@@ -2746,11 +2755,15 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	for_each_tracing_cpu(cpu) {
 		if (global_trace.data[cpu])
 			atomic_dec(&global_trace.data[cpu]->disabled);
+#ifdef CONFIG_TRACER_MAX_TRACE
 		if (max_tr.data[cpu])
 			atomic_dec(&max_tr.data[cpu]->disabled);
+#endif
 	}
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	max_tr.entries = global_trace.entries;
+#endif
 	mutex_unlock(&trace_types_lock);
 
 	return cnt;
@@ -3205,7 +3218,9 @@ __init static int tracer_alloc_buffers(void)
 	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
 		data = global_trace.data[i] = &per_cpu(global_trace_cpu, i);
+#ifdef CONFIG_TRACER_MAX_TRACE
 		max_tr.data[i] = &per_cpu(max_data, i);
+#endif
 	}
 
 	trace_init_cmdlines();
-- 
1.5.6.5

-- 
