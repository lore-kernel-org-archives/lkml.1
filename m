Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbZBJEIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbZBJEIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 23:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbZBJEIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 23:08:34 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:55003 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZBJEId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 23:08:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:date:subject;
        b=AoWSkRsmbajjK1aN/qDAGujUP9NYiouVeEr6yTLKQfM2XpXAQjRXR44xyqSi71DHX2
         h19GhkEhJr0Fp4UPGlHfyujFvZEWXlLyqtKBBO80TpW2e6tM+B2LklobpVazEnyzW1bF
         4EH6dxJjo/81ZvGY4At6d1YaplclKtIeACpjg=
Message-ID: <4990fdc0.0af5660a.678f.ffffd47b@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 10 Feb 2009 04:47:22 +0100
Subject: [PATCH 2/2] tracing/core: use appropriate waiting on trace_pipe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the waiting used in tracing_read_pipe() was done through a
scheduling_timeout() loop for 100 msecs which periodically checked
if there was traces on the buffer.

This can cause small latencies for programs which are reading the incoming
events.

This patch makes the reader waiting for the trace_wait waitqueue except
for few tracers such as sched_switch and the function tracers which might be
already hold the runqueue lock while waking up the reader.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c                 |   48 ++++++++++++++++++++++------------
 kernel/trace/trace.h                 |    6 ++++
 kernel/trace/trace_functions.c       |    2 +-
 kernel/trace/trace_functions_graph.c |    2 +-
 kernel/trace/trace_sched_switch.c    |    2 +-
 5 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d898212..b136e4b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -240,6 +240,13 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO;
 
+
+static inline int might_hold_runqueue_lock(struct tracer *t)
+{
+	return t == &sched_switch_trace || t == &function_trace ||
+		t == &graph_trace;
+}
+
 /**
  * trace_wake_up - wake up tasks waiting for trace input
  *
@@ -2391,34 +2398,39 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
 /* Must be called with trace_types_lock mutex held. */
 static int tracing_wait_pipe(struct file *filp)
 {
+	DEFINE_WAIT(wait);
 	struct trace_iterator *iter = filp->private_data;
 
 	while (trace_empty(iter)) {
-
 		if ((filp->f_flags & O_NONBLOCK)) {
 			return -EAGAIN;
 		}
 
-		/*
-		 * This is a make-shift waitqueue. The reason we don't use
-		 * an actual wait queue is because:
-		 *  1) we only ever have one waiter
-		 *  2) the tracing, traces all functions, we don't want
-		 *     the overhead of calling wake_up and friends
-		 *     (and tracing them too)
-		 *     Anyway, this is really very primitive wakeup.
-		 */
-		set_current_state(TASK_INTERRUPTIBLE);
-		iter->tr->waiter = current;
-
 		mutex_unlock(&trace_types_lock);
 
-		/* sleep for 100 msecs, and try again. */
-		schedule_timeout(HZ/10);
+		if (might_hold_runqueue_lock(iter->trace)) {
+			/*
+			 * This is a make-shift waitqueue. The reason we don't
+			 * use an actual wait queue is because:
+			 *  1) we only ever have one waiter
+			 *  2) the tracing, traces all functions, we don't want
+			 *     the overhead of calling wake_up and friends
+			 *     (and tracing them too)
+			 *     Anyway, this is really very primitive wakeup.
+			 */
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(HZ / 10);
 
-		mutex_lock(&trace_types_lock);
+		} else {
+			prepare_to_wait(&trace_wait, &wait, TASK_INTERRUPTIBLE);
+
+			if (trace_empty(iter))
+				schedule();
+
+			finish_wait(&trace_wait, &wait);
+		}
 
-		iter->tr->waiter = NULL;
+		mutex_lock(&trace_types_lock);
 
 		if (signal_pending(current)) {
 			return -EINTR;
@@ -3032,6 +3044,8 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
  out:
 	preempt_enable_notrace();
 
+	trace_wake_up();
+
 	return len;
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index dbff020..5680936 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -625,6 +625,12 @@ enum trace_iterator_flags {
 
 extern struct tracer nop_trace;
 
+/*
+ * Tracers for which the user shouldn't wait the traces in common ways,
+ * since the tracer can hold the runqueue lock.
+ */
+extern struct tracer sched_switch_trace, function_trace, graph_trace;
+
 /**
  * ftrace_preempt_disable - disable preemption scheduler safe
  *
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 36bf956..dbca500 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -218,7 +218,7 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
 	return -EINVAL;
 }
 
-static struct tracer function_trace __read_mostly =
+struct tracer function_trace __read_mostly =
 {
 	.name		= "function",
 	.init		= function_trace_init,
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 782ec0f..0715f19 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -753,7 +753,7 @@ static void graph_trace_close(struct trace_iterator *iter)
 	percpu_free(iter->private);
 }
 
-static struct tracer graph_trace __read_mostly = {
+struct tracer graph_trace __read_mostly = {
 	.name	     	= "function_graph",
 	.open		= graph_trace_open,
 	.close		= graph_trace_close,
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 30e14fe..8ec54e3 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -214,7 +214,7 @@ static void sched_switch_trace_stop(struct trace_array *tr)
 	tracing_stop_sched_switch();
 }
 
-static struct tracer sched_switch_trace __read_mostly =
+struct tracer sched_switch_trace __read_mostly =
 {
 	.name		= "sched_switch",
 	.init		= sched_switch_trace_init,
-- 
1.6.1


