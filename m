Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZH1UiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZH1UiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZH1UiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:38:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56383 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZH1UiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:38:15 -0400
Message-Id: <20090828203815.739073744@goodmis.org>
References: <20090828203736.440768383@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 28 Aug 2009 16:37:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] tracing: only show tracing_max_latency when latency tracer configured
Content-Disposition: inline; filename=0002-tracing-only-show-tracing_max_latency-when-latency-t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The tracing_max_latency file should only be present when one of the
latency tracers ({preempt|irqs}off, wakeup*) are enabled.

This patch also removes tracing_thresh when latency tracers are not
enabled, as well as compiles out code that is only used for latency
tracers.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   92 +++++++++++++++++++++++++++-----------------------
 kernel/trace/trace.h |    2 +
 2 files changed, 52 insertions(+), 42 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 63dbc7f..0f08816 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -43,9 +43,6 @@
 
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
 
-unsigned long __read_mostly	tracing_max_latency;
-unsigned long __read_mostly	tracing_thresh;
-
 /*
  * On boot up, the ring buffer is set to the minimum size, so that
  * we do not waste memory on systems that are not using tracing.
@@ -338,45 +335,6 @@ static struct {
 
 int trace_clock_id;
 
-/*
- * ftrace_max_lock is used to protect the swapping of buffers
- * when taking a max snapshot. The buffers themselves are
- * protected by per_cpu spinlocks. But the action of the swap
- * needs its own lock.
- *
- * This is defined as a raw_spinlock_t in order to help
- * with performance when lockdep debugging is enabled.
- */
-static raw_spinlock_t ftrace_max_lock =
-	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-
-/*
- * Copy the new maximum trace into the separate maximum-trace
- * structure. (this way the maximum trace is permanently saved,
- * for later retrieval via /sys/kernel/debug/tracing/latency_trace)
- */
-static void
-__update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
-{
-	struct trace_array_cpu *data = tr->data[cpu];
-
-	max_tr.cpu = cpu;
-	max_tr.time_start = data->preempt_timestamp;
-
-	data = max_tr.data[cpu];
-	data->saved_latency = tracing_max_latency;
-
-	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
-	data->pid = tsk->pid;
-	data->uid = task_uid(tsk);
-	data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
-	data->policy = tsk->policy;
-	data->rt_priority = tsk->rt_priority;
-
-	/* record this tasks comm */
-	tracing_record_cmdline(tsk);
-}
-
 ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
 {
 	int len;
@@ -420,6 +378,53 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 	return cnt;
 }
 
+/*
+ * ftrace_max_lock is used to protect the swapping of buffers
+ * when taking a max snapshot. The buffers themselves are
+ * protected by per_cpu spinlocks. But the action of the swap
+ * needs its own lock.
+ *
+ * This is defined as a raw_spinlock_t in order to help
+ * with performance when lockdep debugging is enabled.
+ *
+ * It is also used in other places outside the update_max_tr
+ * so it needs to be defined outside of the
+ * CONFIG_TRACER_MAX_TRACE.
+ */
+static raw_spinlock_t ftrace_max_lock =
+	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+unsigned long __read_mostly	tracing_max_latency;
+unsigned long __read_mostly	tracing_thresh;
+
+/*
+ * Copy the new maximum trace into the separate maximum-trace
+ * structure. (this way the maximum trace is permanently saved,
+ * for later retrieval via /sys/kernel/debug/tracing/latency_trace)
+ */
+static void
+__update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
+{
+	struct trace_array_cpu *data = tr->data[cpu];
+
+	max_tr.cpu = cpu;
+	max_tr.time_start = data->preempt_timestamp;
+
+	data = max_tr.data[cpu];
+	data->saved_latency = tracing_max_latency;
+
+	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
+	data->pid = tsk->pid;
+	data->uid = task_uid(tsk);
+	data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
+	data->policy = tsk->policy;
+	data->rt_priority = tsk->rt_priority;
+
+	/* record this tasks comm */
+	tracing_record_cmdline(tsk);
+}
+
 /**
  * update_max_tr - snapshot all trace buffers from global_trace to max_tr
  * @tr: tracer
@@ -476,6 +481,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	__update_max_tr(tr, tsk, cpu);
 	__raw_spin_unlock(&ftrace_max_lock);
 }
+#endif /* CONFIG_TRACER_MAX_TRACE */
 
 /**
  * register_tracer - register a tracer with the ftrace system.
@@ -3952,11 +3958,13 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("current_tracer", 0644, d_tracer,
 			&global_trace, &set_tracer_fops);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_file("tracing_max_latency", 0644, d_tracer,
 			&tracing_max_latency, &tracing_max_lat_fops);
 
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&tracing_thresh, &tracing_max_lat_fops);
+#endif
 
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 654fd65..e2c06b2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -473,12 +473,14 @@ void unregister_tracer(struct tracer *type);
 
 extern unsigned long nsecs_to_usecs(unsigned long nsecs);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 extern unsigned long tracing_max_latency;
 extern unsigned long tracing_thresh;
 
 void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
+#endif /* CONFIG_TRACER_MAX_TRACE */
 
 #ifdef CONFIG_STACKTRACE
 void ftrace_trace_stack(struct trace_array *tr, unsigned long flags,
-- 
1.6.3.3

-- 
