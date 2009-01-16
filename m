Return-Path: <linux-kernel-owner+w=401wt.eu-S934065AbZAPAm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934065AbZAPAm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754810AbZAPAl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:41:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35991 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZAPAlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:41:23 -0500
Message-Id: <20090116004121.302184848@goodmis.org>
References: <20090116004050.273665842@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 19:40:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: add stack trace to function tracer
Content-Disposition: inline; filename=0002-ftrace-add-stack-trace-to-function-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: new feature to stack trace any function

Chris Mason asked about being able to pick and choose a function
and get a stack trace from it. This feature enables his request.

 # echo io_schedule > /debug/tracing/set_ftrace_filter
 # echo function > /debug/tracing/current_tracer
 # echo func_stack_trace > /debug/tracing/trace_options

Produces the following in /debug/tracing/trace:

       kjournald-702   [001]   135.673060: io_schedule <-sync_buffer
       kjournald-702   [002]   135.673671:
 <= sync_buffer
 <= __wait_on_bit
 <= out_of_line_wait_on_bit
 <= __wait_on_buffer
 <= sync_dirty_buffer
 <= journal_commit_transaction
 <= kjournald

Note, be careful about turning this on without filtering the functions.
You may find that you have a 10 second lag between typing and seeing
what you typed. This is why the stack trace for the function tracer
does not use the same stack_trace flag as the other tracers use.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c           |   26 ++++++++----
 kernel/trace/trace.h           |    7 +++
 kernel/trace/trace_functions.c |   84 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index dcb757f..3c54cb1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -835,10 +835,10 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 		trace_function(tr, data, ip, parent_ip, flags, pc);
 }
 
-static void ftrace_trace_stack(struct trace_array *tr,
-			       struct trace_array_cpu *data,
-			       unsigned long flags,
-			       int skip, int pc)
+static void __ftrace_trace_stack(struct trace_array *tr,
+				 struct trace_array_cpu *data,
+				 unsigned long flags,
+				 int skip, int pc)
 {
 #ifdef CONFIG_STACKTRACE
 	struct ring_buffer_event *event;
@@ -846,9 +846,6 @@ static void ftrace_trace_stack(struct trace_array *tr,
 	struct stack_trace trace;
 	unsigned long irq_flags;
 
-	if (!(trace_flags & TRACE_ITER_STACKTRACE))
-		return;
-
 	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
 					 &irq_flags);
 	if (!event)
@@ -869,12 +866,23 @@ static void ftrace_trace_stack(struct trace_array *tr,
 #endif
 }
 
+static void ftrace_trace_stack(struct trace_array *tr,
+			       struct trace_array_cpu *data,
+			       unsigned long flags,
+			       int skip, int pc)
+{
+	if (!(trace_flags & TRACE_ITER_STACKTRACE))
+		return;
+
+	__ftrace_trace_stack(tr, data, flags, skip, pc);
+}
+
 void __trace_stack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long flags,
-		   int skip)
+		   int skip, int pc)
 {
-	ftrace_trace_stack(tr, data, flags, skip, preempt_count());
+	__ftrace_trace_stack(tr, data, flags, skip, pc);
 }
 
 static void ftrace_trace_userstack(struct trace_array *tr,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 79c8721..bf39a36 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -457,6 +457,11 @@ void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
 
+void __trace_stack(struct trace_array *tr,
+		   struct trace_array_cpu *data,
+		   unsigned long flags,
+		   int skip, int pc);
+
 extern cycle_t ftrace_now(int cpu);
 
 #ifdef CONFIG_FUNCTION_TRACER
@@ -467,6 +472,8 @@ void tracing_stop_function_trace(void);
 # define tracing_stop_function_trace()		do { } while (0)
 #endif
 
+extern int ftrace_function_enabled;
+
 #ifdef CONFIG_CONTEXT_SWITCH_TRACER
 typedef void
 (*tracer_switch_func_t)(void *private,
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 9236d7e..3a5fa08 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -16,6 +16,8 @@
 
 #include "trace.h"
 
+static struct trace_array	*func_trace;
+
 static void start_function_trace(struct trace_array *tr)
 {
 	tr->cpu = get_cpu();
@@ -34,6 +36,7 @@ static void stop_function_trace(struct trace_array *tr)
 
 static int function_trace_init(struct trace_array *tr)
 {
+	func_trace = tr;
 	start_function_trace(tr);
 	return 0;
 }
@@ -48,12 +51,93 @@ static void function_trace_start(struct trace_array *tr)
 	tracing_reset_online_cpus(tr);
 }
 
+static void
+function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array *tr = func_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu;
+	int pc;
+
+	if (unlikely(!ftrace_function_enabled))
+		return;
+
+	/*
+	 * Need to use raw, since this must be called before the
+	 * recursive protection is performed.
+	 */
+	local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1)) {
+		pc = preempt_count();
+		/*
+		 * skip over 5 funcs:
+		 *    __ftrace_trace_stack,
+		 *    __trace_stack,
+		 *    function_stack_trace_call
+		 *    ftrace_list_func
+		 *    ftrace_call
+		 */
+		__trace_stack(tr, data, flags, 5, pc);
+	}
+
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
+static struct ftrace_ops trace_stack_ops __read_mostly =
+{
+	.func = function_stack_trace_call,
+};
+
+/* Our two options */
+enum {
+	TRACE_FUNC_OPT_STACK = 0x1,
+};
+
+static struct tracer_opt func_opts[] = {
+#ifdef CONFIG_STACKTRACE
+	{ TRACER_OPT(func_stack_trace, TRACE_FUNC_OPT_STACK) },
+#endif
+	{ } /* Always set a last empty entry */
+};
+
+static struct tracer_flags func_flags = {
+	.val = 0, /* By default: all flags disabled */
+	.opts = func_opts
+};
+
+static int func_set_flag(u32 old_flags, u32 bit, int set)
+{
+	if (bit == TRACE_FUNC_OPT_STACK) {
+		/* do nothing if already set */
+		if (!!set == !!(func_flags.val & TRACE_FUNC_OPT_STACK))
+			return 0;
+
+		if (set)
+			register_ftrace_function(&trace_stack_ops);
+		else
+			unregister_ftrace_function(&trace_stack_ops);
+
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static struct tracer function_trace __read_mostly =
 {
 	.name	     = "function",
 	.init	     = function_trace_init,
 	.reset	     = function_trace_reset,
 	.start	     = function_trace_start,
+	.flags		= &func_flags,
+	.set_flag	= func_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_function,
 #endif
-- 
1.5.6.5

-- 
