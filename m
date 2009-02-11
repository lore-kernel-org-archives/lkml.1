Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbZBKCjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbZBKCjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 21:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbZBKCjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 21:39:36 -0500
Received: from mail-bw0-f167.google.com ([209.85.218.167]:64785 "EHLO
	mail-bw0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZBKCjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 21:39:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:date:to:cc:subject;
        b=WO/wjxZyDXr3QFCr5PzouDtHYuH0GqMSKnhzX3XKjAfswhPiPMbOmiZc4AvtPT7QKk
         AJlNoC9S26t/Ur89HUAW9TbEMNeYNN7xOu9tA34ml3MngmW3Xrtoe4MJGkE2w5AZGs7Y
         fRGWXe9V01iFYeZlAi6IOAvSSdWs9pAk5iakg=
Message-ID: <49923a65.1358560a.198e.63ad@mx.google.com>
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 11 Feb 2009 02:25:00 +0100
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 1/2 v2] tracing/core: use appropriate waiting on trace_pipe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: api and pipe waiting change

Currently, the waiting used in tracing_read_pipe() is done through a
100 msecs schedule_timeout() loop which periodically check if there
are traces on the buffer.

This can cause small latencies for programs which are reading the incoming
events.

This patch makes the reader waiting for the trace_wait waitqueue except
for few tracers such as the sched and functions tracers which might be
already hold the runqueue lock while waking up the reader.

This is performed through a new callback wait_pipe() on struct tracer.
If none is implemented on a specific tracer, the default waiting for
trace_wait queue is attached.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c                 |   62 ++++++++++++++++++++++-----------
 kernel/trace/trace.h                 |   25 ++++++++++++--
 kernel/trace/trace_functions.c       |    1 +
 kernel/trace/trace_functions_graph.c |    1 +
 kernel/trace/trace_sched_switch.c    |    1 +
 kernel/trace/trace_sched_wakeup.c    |    1 +
 6 files changed, 67 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d7c175a..9c3b684 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -497,6 +497,9 @@ int register_tracer(struct tracer *type)
 	else
 		if (!type->flags->opts)
 			type->flags->opts = dummy_tracer_opt;
+	if (!type->wait_pipe)
+		type->wait_pipe = default_wait_pipe;
+
 
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	if (type->selftest && !tracing_selftest_disabled) {
@@ -1060,7 +1063,10 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_prio		= wakee->prio;
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
-	trace_buffer_unlock_commit(tr, event, flags, pc);
+
+	ring_buffer_unlock_commit(tr->buffer, event);
+	ftrace_trace_stack(tr, flags, 6, pc);
+	ftrace_trace_userstack(tr, flags, pc);
 }
 
 void
@@ -2388,6 +2394,38 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
 	}
 }
 
+
+void default_wait_pipe(struct trace_iterator *iter)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&trace_wait, &wait, TASK_INTERRUPTIBLE);
+
+	if (trace_empty(iter))
+		schedule();
+
+	finish_wait(&trace_wait, &wait);
+}
+
+/*
+ * This is a make-shift waitqueue.
+ * A tracer might use this callback on some rare cases:
+ *
+ *  1) the current tracer might hold the runqueue lock when it wakes up
+ *     a reader, hence a deadlock (sched, function, and function graph tracers)
+ *  2) the function tracers, trace all functions, we don't want
+ *     the overhead of calling wake_up and friends
+ *     (and tracing them too)
+ *
+ *     Anyway, this is really very primitive wakeup.
+ */
+void poll_wait_pipe(struct trace_iterator *iter)
+{
+	set_current_state(TASK_INTERRUPTIBLE);
+	/* sleep for 100 msecs, and try again. */
+	schedule_timeout(HZ / 10);
+}
+
 /* Must be called with trace_types_lock mutex held. */
 static int tracing_wait_pipe(struct file *filp)
 {
@@ -2399,30 +2437,14 @@ static int tracing_wait_pipe(struct file *filp)
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
+		iter->trace->wait_pipe(iter);
 
 		mutex_lock(&trace_types_lock);
 
-		iter->tr->waiter = NULL;
-
-		if (signal_pending(current)) {
+		if (signal_pending(current))
 			return -EINTR;
-		}
 
 		if (iter->trace != current_trace)
 			return 0;
@@ -2438,8 +2460,6 @@ static int tracing_wait_pipe(struct file *filp)
 		 */
 		if (!tracer_enabled && iter->pos)
 			break;
-
-		continue;
 	}
 
 	return 1;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index dbff020..eed732c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -337,18 +337,34 @@ struct tracer_flags {
 #define TRACER_OPT(s, b)	.name = #s, .bit = b
 
 
-/*
- * A specific tracer, represented by methods that operate on a trace array:
+/**
+ * struct tracer - a specific tracer and its callbacks to interact with debugfs
+ * @name: the name chosen to select it on the available_tracers file
+ * @init: called when one switches to this tracer (echo name > current_tracer)
+ * @reset: called when one switches to another tracer
+ * @start: called when tracing is unpaused (echo 1 > tracing_enabled)
+ * @stop: called when tracing is paused (echo 0 > tracing_enabled)
+ * @open: called when the trace file is opened
+ * @pipe_open: called when the trace_pipe file is opened
+ * @wait_pipe: override how the user waits for traces on trace_pipe
+ * @close: called when the trace file is released
+ * @read: override the default read callback on trace_pipe
+ * @splice_read: override the default splice_read callback on trace_pipe
+ * @selftest: selftest to run on boot (see trace_selftest.c)
+ * @print_headers: override the first lines that describe your columns
+ * @print_line: callback that prints a trace
+ * @set_flag: signals one of your private flags changed (trace_options file)
+ * @flags: your private flags
  */
 struct tracer {
 	const char		*name;
-	/* Your tracer should raise a warning if init fails */
 	int			(*init)(struct trace_array *tr);
 	void			(*reset)(struct trace_array *tr);
 	void			(*start)(struct trace_array *tr);
 	void			(*stop)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
 	void			(*pipe_open)(struct trace_iterator *iter);
+	void			(*wait_pipe)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
 	ssize_t			(*read)(struct trace_iterator *iter,
 					struct file *filp, char __user *ubuf,
@@ -432,6 +448,9 @@ void tracing_generic_entry_update(struct trace_entry *entry,
 				  unsigned long flags,
 				  int pc);
 
+void default_wait_pipe(struct trace_iterator *iter);
+void poll_wait_pipe(struct trace_iterator *iter);
+
 void ftrace(struct trace_array *tr,
 			    struct trace_array_cpu *data,
 			    unsigned long ip,
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 36bf956..e1bceae 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -224,6 +224,7 @@ static struct tracer function_trace __read_mostly =
 	.init		= function_trace_init,
 	.reset		= function_trace_reset,
 	.start		= function_trace_start,
+	.wait_pipe	= poll_wait_pipe,
 	.flags		= &func_flags,
 	.set_flag	= func_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 519a0ca..0ff5cb6 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -757,6 +757,7 @@ static struct tracer graph_trace __read_mostly = {
 	.name	     	= "function_graph",
 	.open		= graph_trace_open,
 	.close		= graph_trace_close,
+	.wait_pipe	= poll_wait_pipe,
 	.init	     	= graph_trace_init,
 	.reset	     	= graph_trace_reset,
 	.print_line	= print_graph_function,
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 30e14fe..dfe90e4 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -221,6 +221,7 @@ static struct tracer sched_switch_trace __read_mostly =
 	.reset		= sched_switch_trace_reset,
 	.start		= sched_switch_trace_start,
 	.stop		= sched_switch_trace_stop,
+	.wait_pipe	= poll_wait_pipe,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_sched_switch,
 #endif
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 96d7164..8c2d1c3 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -380,6 +380,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.reset		= wakeup_tracer_reset,
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
+	.wait_pipe	= poll_wait_pipe,
 	.print_max	= 1,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
-- 
1.6.1


