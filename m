Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbYKEVeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbYKEVeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYKEVeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:34:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40047 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYKEVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:34:09 -0500
Message-Id: <20081105213406.884121126@goodmis.org>
References: <20081105212428.148612398@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 05 Nov 2008 16:24:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/3] ftrace: restructure tracing start/stop infrastructure
Content-Disposition: inline; filename=0003-ftrace-restructure-tracing-start-stop-infrastructur.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: change where tracing is started up and stopped

Currently, when a new tracer is selected via echo'ing a tracer name into
the current_tracer file, the startup is only done if tracing_enabled is
set to one. If tracing_enabled is changed to zero (by echo'ing 0 into
the tracing_enabled file) a full shutdown is performed.

The full startup and shutdown of a tracer can be expensive and the
user can lose out traces when echo'ing in 0 to the tracing_enabled file,
because the process takes too long. There can also be places that
the user would like to start and stop the tracer several times and
doing the full startup and shutdown of a tracer might be too expensive.

This patch performs the full startup and shutdown when a tracer is
selected. It also adds a way to do a quick start or stop of a tracer.
The quick version is just a flag that prevents the tracing from
taking place, but the overhead of the code is still there.

For example, the startup of a tracer may enable tracepoints, or enable
the function tracer.  The stop and start will just set a flag to
have the tracer ignore the calls when the tracepoint or function trace
is called.  The overhead of the tracer may still be present when
the tracer is stopped, but no tracing will occur. Setting the tracer
to the 'nop' tracer (or any other tracer) will perform the shutdown
of the tracer which will disable the tracepoint or disable the
function tracer.

The tracing_enabled file will simply start or stop tracing.

This change is all internal. The end result for the user should be the same
as before. If tracing_enabled is not set, no trace will happen.
If tracing_enabled is set, then the trace will happen. The tracing_enabled
variable is static between tracers. Enabling  tracing_enabled and
going to another tracer will keep tracing_enabled enabled. Same
is true with disabling tracing_enabled.

This patch will now provide a fast start/stop method to the users
for enabling or disabling tracing.

Note: There were two methods to the struct tracer that were never
 used: The methods start and stop. These were to be used as a hook
 to the reading of the trace output, but ended up not being
 necessary. These two methods are now used to enable the start
 and stop of each tracer, in case the tracer needs to do more than
 just not write into the buffer. For example, the irqsoff tracer
 must stop recording max latencies when tracing is stopped.


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c              |   64 ++++++++++++++++---------------------
 kernel/trace/trace.h              |    5 ++-
 kernel/trace/trace_functions.c    |    6 +++
 kernel/trace/trace_irqsoff.c      |   41 +++++++++++++++++++++---
 kernel/trace/trace_sched_switch.c |   13 +++++++
 kernel/trace/trace_sched_wakeup.c |   39 +++++++++++++++++++---
 6 files changed, 120 insertions(+), 48 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 411ab5c..fe458e4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -150,6 +150,19 @@ static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
 /* tracer_enabled is used to toggle activation of a tracer */
 static int			tracer_enabled = 1;
 
+/**
+ * tracing_is_enabled - return tracer_enabled status
+ *
+ * This function is used by other tracers to know the status
+ * of the tracer_enabled flag.  Tracers may use this function
+ * to know if it should enable their features when starting
+ * up. See irqsoff tracer for an example (start_irqsoff_tracer).
+ */
+int tracing_is_enabled(void)
+{
+	return tracer_enabled;
+}
+
 /* function tracing enabled */
 int				ftrace_function_enabled;
 
@@ -1041,8 +1054,7 @@ void tracing_start_function_trace(void)
 		trace_ops.func = function_trace_call;
 
 	register_ftrace_function(&trace_ops);
-	if (tracer_enabled)
-		ftrace_function_enabled = 1;
+	ftrace_function_enabled = 1;
 }
 
 void tracing_stop_function_trace(void)
@@ -1189,10 +1201,6 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 	atomic_inc(&trace_record_cmdline_disabled);
 
-	/* let the tracer grab locks here if needed */
-	if (current_trace->start)
-		current_trace->start(iter);
-
 	if (*pos != iter->pos) {
 		iter->ent = NULL;
 		iter->cpu = 0;
@@ -1219,14 +1227,7 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 
 static void s_stop(struct seq_file *m, void *p)
 {
-	struct trace_iterator *iter = m->private;
-
 	atomic_dec(&trace_record_cmdline_disabled);
-
-	/* let the tracer release locks here if needed */
-	if (current_trace && current_trace == iter->trace && iter->trace->stop)
-		iter->trace->stop(iter);
-
 	mutex_unlock(&trace_types_lock);
 }
 
@@ -2059,10 +2060,7 @@ __tracing_open(struct inode *inode, struct file *file, int *ret)
 	m->private = iter;
 
 	/* stop the trace while dumping */
-	if (iter->tr->ctrl) {
-		tracer_enabled = 0;
-		ftrace_function_enabled = 0;
-	}
+	tracing_stop();
 
 	if (iter->trace && iter->trace->open)
 			iter->trace->open(iter);
@@ -2107,14 +2105,7 @@ int tracing_release(struct inode *inode, struct file *file)
 		iter->trace->close(iter);
 
 	/* reenable tracing if it was previously enabled */
-	if (iter->tr->ctrl) {
-		tracer_enabled = 1;
-		/*
-		 * It is safe to enable function tracing even if it
-		 * isn't used
-		 */
-		ftrace_function_enabled = 1;
-	}
+	tracing_start();
 	mutex_unlock(&trace_types_lock);
 
 	seq_release(inode, file);
@@ -2452,11 +2443,10 @@ static ssize_t
 tracing_ctrl_read(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
-	struct trace_array *tr = filp->private_data;
 	char buf[64];
 	int r;
 
-	r = sprintf(buf, "%ld\n", tr->ctrl);
+	r = sprintf(buf, "%u\n", tracer_enabled);
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
@@ -2484,16 +2474,18 @@ tracing_ctrl_write(struct file *filp, const char __user *ubuf,
 	val = !!val;
 
 	mutex_lock(&trace_types_lock);
-	if (tr->ctrl ^ val) {
-		if (val)
+	if (tracer_enabled ^ val) {
+		if (val) {
 			tracer_enabled = 1;
-		else
+			if (current_trace->start)
+				current_trace->start(tr);
+			tracing_start();
+		} else {
 			tracer_enabled = 0;
-
-		tr->ctrl = val;
-
-		if (current_trace && current_trace->ctrl_update)
-			current_trace->ctrl_update(tr);
+			tracing_stop();
+			if (current_trace->stop)
+				current_trace->stop(tr);
+		}
 	}
 	mutex_unlock(&trace_types_lock);
 
@@ -3375,7 +3367,7 @@ __init static int tracer_alloc_buffers(void)
 #endif
 
 	/* All seems OK, enable tracing */
-	global_trace.ctrl = tracer_enabled;
+	global_trace.ctrl = 1;
 	tracing_disabled = 0;
 
 	atomic_notifier_chain_register(&panic_notifier_list,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index cc14a6b..3422489 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -237,11 +237,11 @@ struct tracer {
 	const char		*name;
 	void			(*init)(struct trace_array *tr);
 	void			(*reset)(struct trace_array *tr);
+	void			(*start)(struct trace_array *tr);
+	void			(*stop)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
 	void			(*pipe_open)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
-	void			(*start)(struct trace_iterator *iter);
-	void			(*stop)(struct trace_iterator *iter);
 	ssize_t			(*read)(struct trace_iterator *iter,
 					struct file *filp, char __user *ubuf,
 					size_t cnt, loff_t *ppos);
@@ -282,6 +282,7 @@ struct trace_iterator {
 	long			idx;
 };
 
+int tracing_is_enabled(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
 int tracing_open_generic(struct inode *inode, struct file *filp);
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 0f85a64..9f1b0de 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -62,11 +62,17 @@ static void function_trace_ctrl_update(struct trace_array *tr)
 		stop_function_trace(tr);
 }
 
+static void function_trace_start(struct trace_array *tr)
+{
+	function_reset(tr);
+}
+
 static struct tracer function_trace __read_mostly =
 {
 	.name	     = "function",
 	.init	     = function_trace_init,
 	.reset	     = function_trace_reset,
+	.start	     = function_trace_start,
 	.ctrl_update = function_trace_ctrl_update,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_function,
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 9c74071..a87a20f 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -353,15 +353,28 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
 }
 #endif /* CONFIG_PREEMPT_TRACER */
 
+/*
+ * save_tracer_enabled is used to save the state of the tracer_enabled
+ * variable when we disable it when we open a trace output file.
+ */
+static int save_tracer_enabled;
+
 static void start_irqsoff_tracer(struct trace_array *tr)
 {
 	register_ftrace_function(&trace_ops);
-	tracer_enabled = 1;
+	if (tracing_is_enabled()) {
+		tracer_enabled = 1;
+		save_tracer_enabled = 1;
+	} else {
+		tracer_enabled = 0;
+		save_tracer_enabled = 0;
+	}
 }
 
 static void stop_irqsoff_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
+	save_tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
 }
 
@@ -389,17 +402,29 @@ static void irqsoff_tracer_ctrl_update(struct trace_array *tr)
 		stop_irqsoff_tracer(tr);
 }
 
+static void irqsoff_tracer_start(struct trace_array *tr)
+{
+	irqsoff_tracer_reset(tr);
+	tracer_enabled = 1;
+	save_tracer_enabled = 1;
+}
+
+static void irqsoff_tracer_stop(struct trace_array *tr)
+{
+	tracer_enabled = 0;
+	save_tracer_enabled = 0;
+}
+
 static void irqsoff_tracer_open(struct trace_iterator *iter)
 {
 	/* stop the trace while dumping */
-	if (iter->tr->ctrl)
-		stop_irqsoff_tracer(iter->tr);
+	tracer_enabled = 0;
 }
 
 static void irqsoff_tracer_close(struct trace_iterator *iter)
 {
-	if (iter->tr->ctrl)
-		start_irqsoff_tracer(iter->tr);
+	/* restart tracing */
+	tracer_enabled = save_tracer_enabled;
 }
 
 #ifdef CONFIG_IRQSOFF_TRACER
@@ -414,6 +439,8 @@ static struct tracer irqsoff_tracer __read_mostly =
 	.name		= "irqsoff",
 	.init		= irqsoff_tracer_init,
 	.reset		= irqsoff_tracer_reset,
+	.start		= irqsoff_tracer_start,
+	.stop		= irqsoff_tracer_stop,
 	.open		= irqsoff_tracer_open,
 	.close		= irqsoff_tracer_close,
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
@@ -440,6 +467,8 @@ static struct tracer preemptoff_tracer __read_mostly =
 	.name		= "preemptoff",
 	.init		= preemptoff_tracer_init,
 	.reset		= irqsoff_tracer_reset,
+	.start		= irqsoff_tracer_start,
+	.stop		= irqsoff_tracer_stop,
 	.open		= irqsoff_tracer_open,
 	.close		= irqsoff_tracer_close,
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
@@ -468,6 +497,8 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 	.name		= "preemptirqsoff",
 	.init		= preemptirqsoff_tracer_init,
 	.reset		= irqsoff_tracer_reset,
+	.start		= irqsoff_tracer_start,
+	.stop		= irqsoff_tracer_stop,
 	.open		= irqsoff_tracer_open,
 	.close		= irqsoff_tracer_close,
 	.ctrl_update	= irqsoff_tracer_ctrl_update,
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 888944d..91c699b 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -186,11 +186,24 @@ static void sched_switch_trace_ctrl_update(struct trace_array *tr)
 		stop_sched_trace(tr);
 }
 
+static void sched_switch_trace_start(struct trace_array *tr)
+{
+	sched_switch_reset(tr);
+	tracing_start_sched_switch();
+}
+
+static void sched_switch_trace_stop(struct trace_array *tr)
+{
+	tracing_stop_sched_switch();
+}
+
 struct tracer sched_switch_trace __read_mostly =
 {
 	.name		= "sched_switch",
 	.init		= sched_switch_trace_init,
 	.reset		= sched_switch_trace_reset,
+	.start		= sched_switch_trace_start,
+	.stop		= sched_switch_trace_stop,
 	.ctrl_update	= sched_switch_trace_ctrl_update,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_sched_switch,
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 7bc4abf..240577b 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -262,6 +262,12 @@ out:
 	atomic_dec(&wakeup_trace->data[cpu]->disabled);
 }
 
+/*
+ * save_tracer_enabled is used to save the state of the tracer_enabled
+ * variable when we disable it when we open a trace output file.
+ */
+static int save_tracer_enabled;
+
 static void start_wakeup_tracer(struct trace_array *tr)
 {
 	int ret;
@@ -300,7 +306,13 @@ static void start_wakeup_tracer(struct trace_array *tr)
 
 	register_ftrace_function(&trace_ops);
 
-	tracer_enabled = 1;
+	if (tracing_is_enabled()) {
+		tracer_enabled = 1;
+		save_tracer_enabled = 1;
+	} else {
+		tracer_enabled = 0;
+		save_tracer_enabled = 0;
+	}
 
 	return;
 fail_deprobe_wake_new:
@@ -312,6 +324,7 @@ fail_deprobe:
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
+	save_tracer_enabled = 0;
 	unregister_ftrace_function(&trace_ops);
 	unregister_trace_sched_switch(probe_wakeup_sched_switch);
 	unregister_trace_sched_wakeup_new(probe_wakeup);
@@ -343,18 +356,32 @@ static void wakeup_tracer_ctrl_update(struct trace_array *tr)
 		stop_wakeup_tracer(tr);
 }
 
+static void wakeup_tracer_start(struct trace_array *tr)
+{
+	wakeup_reset(tr);
+	tracer_enabled = 1;
+	save_tracer_enabled = 1;
+}
+
+static void wakeup_tracer_stop(struct trace_array *tr)
+{
+	tracer_enabled = 0;
+	save_tracer_enabled = 0;
+}
+
 static void wakeup_tracer_open(struct trace_iterator *iter)
 {
 	/* stop the trace while dumping */
-	if (iter->tr->ctrl)
-		stop_wakeup_tracer(iter->tr);
+	tracer_enabled = 0;
 }
 
 static void wakeup_tracer_close(struct trace_iterator *iter)
 {
 	/* forget about any processes we were recording */
-	if (iter->tr->ctrl)
-		start_wakeup_tracer(iter->tr);
+	if (save_tracer_enabled) {
+		wakeup_reset(iter->tr);
+		tracer_enabled = 1;
+	}
 }
 
 static struct tracer wakeup_tracer __read_mostly =
@@ -362,6 +389,8 @@ static struct tracer wakeup_tracer __read_mostly =
 	.name		= "wakeup",
 	.init		= wakeup_tracer_init,
 	.reset		= wakeup_tracer_reset,
+	.start		= wakeup_tracer_start,
+	.stop		= wakeup_tracer_stop,
 	.open		= wakeup_tracer_open,
 	.close		= wakeup_tracer_close,
 	.ctrl_update	= wakeup_tracer_ctrl_update,
-- 
1.5.6.5

-- 
