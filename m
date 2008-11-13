Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYKMFLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYKMFLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 00:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYKMFLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 00:11:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61064 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYKMFLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 00:11:08 -0500
Message-Id: <20081113051105.605442613@goodmis.org>
References: <20081113050933.625130887@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Nov 2008 00:09:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/2] ftrace: do not update max buffer with no users
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

This patch checks if the max tracer is NULL before resizing it.
It also hides the modification functions of the max tracer behind
the TRACER_MAX_TRACE config.

Reported-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |  171 ++++++++++++++++++++++++++------------------------
 1 files changed, 88 insertions(+), 83 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 40c9cc1..20fe77d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -133,20 +133,6 @@ static struct trace_array	global_trace;
 
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
 
@@ -279,6 +265,21 @@ static raw_spinlock_t ftrace_max_lock =
 	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
 /*
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
+#ifdef CONFIG_TRACER_MAX_TRACE
+/*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
  * for later retrieval via /debugfs/tracing/latency_trace)
@@ -306,6 +307,65 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
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
@@ -447,63 +507,6 @@ trace_print_seq(struct seq_file *m, struct trace_seq *s)
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
@@ -2966,19 +2969,21 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 			goto out;
 		}
 
-		ret = ring_buffer_resize(max_tr.buffer, val);
-		if (ret < 0) {
-			int r;
-			cnt = ret;
-			r = ring_buffer_resize(global_trace.buffer,
-					       global_trace.entries);
-			if (r < 0) {
-				/* AARGH! We are left with different
-				 * size max buffer!!!! */
-				WARN_ON(1);
-				tracing_disabled = 1;
+		if (max_tr.buffer) {
+			ret = ring_buffer_resize(max_tr.buffer, val);
+			if (ret < 0) {
+				int r;
+				cnt = ret;
+				r = ring_buffer_resize(global_trace.buffer,
+						       global_trace.entries);
+				if (r < 0) {
+					/* AARGH! We are left with different
+					 * size max buffer!!!! */
+					WARN_ON(1);
+					tracing_disabled = 1;
+				}
+				goto out;
 			}
-			goto out;
 		}
 
 		global_trace.entries = val;
-- 
1.5.6.5

-- 
