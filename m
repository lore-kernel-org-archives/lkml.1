Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbZAPE4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbZAPE4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbZAPEyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:54:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbZAPEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:54:20 -0500
Message-Id: <20090116045417.632296101@goodmis.org>
References: <20090116045342.748642160@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 23:53:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/6] ftrace: move function tracer functions out of trace.c
Content-Disposition: inline; filename=0001-ftrace-move-function-tracer-functions-out-of-trace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: clean up of trace.c

The function tracer functions were put in trace.c because it needed
to share static variables that were in trace.c.  Since then, those
variables have become global for various reasons. This patch moves
the function tracer functions into trace_function.c where they belong.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c           |   84 ----------------------------------------
 kernel/trace/trace_functions.c |   84 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 85 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3c54cb1..2585ffb 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1046,65 +1046,6 @@ ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3)
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_FUNCTION_TRACER
-static void
-function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
-{
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int cpu, resched;
-	int pc;
-
-	if (unlikely(!ftrace_function_enabled))
-		return;
-
-	pc = preempt_count();
-	resched = ftrace_preempt_disable();
-	local_save_flags(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-
-	if (likely(disabled == 1))
-		trace_function(tr, data, ip, parent_ip, flags, pc);
-
-	atomic_dec(&data->disabled);
-	ftrace_preempt_enable(resched);
-}
-
-static void
-function_trace_call(unsigned long ip, unsigned long parent_ip)
-{
-	struct trace_array *tr = &global_trace;
-	struct trace_array_cpu *data;
-	unsigned long flags;
-	long disabled;
-	int cpu;
-	int pc;
-
-	if (unlikely(!ftrace_function_enabled))
-		return;
-
-	/*
-	 * Need to use raw, since this must be called before the
-	 * recursive protection is performed.
-	 */
-	local_irq_save(flags);
-	cpu = raw_smp_processor_id();
-	data = tr->data[cpu];
-	disabled = atomic_inc_return(&data->disabled);
-
-	if (likely(disabled == 1)) {
-		pc = preempt_count();
-		trace_function(tr, data, ip, parent_ip, flags, pc);
-	}
-
-	atomic_dec(&data->disabled);
-	local_irq_restore(flags);
-}
-
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 int trace_graph_entry(struct ftrace_graph_ent *trace)
 {
@@ -1162,31 +1103,6 @@ void trace_graph_return(struct ftrace_graph_ret *trace)
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-static struct ftrace_ops trace_ops __read_mostly =
-{
-	.func = function_trace_call,
-};
-
-void tracing_start_function_trace(void)
-{
-	ftrace_function_enabled = 0;
-
-	if (trace_flags & TRACE_ITER_PREEMPTONLY)
-		trace_ops.func = function_trace_call_preempt_only;
-	else
-		trace_ops.func = function_trace_call;
-
-	register_ftrace_function(&trace_ops);
-	ftrace_function_enabled = 1;
-}
-
-void tracing_stop_function_trace(void)
-{
-	ftrace_function_enabled = 0;
-	unregister_ftrace_function(&trace_ops);
-}
-#endif
-
 enum trace_file_type {
 	TRACE_FILE_LAT_FMT	= 1,
 	TRACE_FILE_ANNOTATE	= 2,
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 3a5fa08..2dce3c7 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -20,6 +20,7 @@ static struct trace_array	*func_trace;
 
 static void start_function_trace(struct trace_array *tr)
 {
+	func_trace = tr;
 	tr->cpu = get_cpu();
 	tracing_reset_online_cpus(tr);
 	put_cpu();
@@ -36,7 +37,6 @@ static void stop_function_trace(struct trace_array *tr)
 
 static int function_trace_init(struct trace_array *tr)
 {
-	func_trace = tr;
 	start_function_trace(tr);
 	return 0;
 }
@@ -52,6 +52,64 @@ static void function_trace_start(struct trace_array *tr)
 }
 
 static void
+function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
+{
+	struct trace_array *tr = func_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu, resched;
+	int pc;
+
+	if (unlikely(!ftrace_function_enabled))
+		return;
+
+	pc = preempt_count();
+	resched = ftrace_preempt_disable();
+	local_save_flags(flags);
+	cpu = raw_smp_processor_id();
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+
+	if (likely(disabled == 1))
+		trace_function(tr, data, ip, parent_ip, flags, pc);
+
+	atomic_dec(&data->disabled);
+	ftrace_preempt_enable(resched);
+}
+
+static void
+function_trace_call(unsigned long ip, unsigned long parent_ip)
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
+		trace_function(tr, data, ip, parent_ip, flags, pc);
+	}
+
+	atomic_dec(&data->disabled);
+	local_irq_restore(flags);
+}
+
+static void
 function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 {
 	struct trace_array *tr = func_trace;
@@ -90,6 +148,30 @@ function_stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	local_irq_restore(flags);
 }
 
+
+static struct ftrace_ops trace_ops __read_mostly =
+{
+	.func = function_trace_call,
+};
+
+void tracing_start_function_trace(void)
+{
+	ftrace_function_enabled = 0;
+
+	if (trace_flags & TRACE_ITER_PREEMPTONLY)
+		trace_ops.func = function_trace_call_preempt_only;
+	else
+		trace_ops.func = function_trace_call;
+
+	register_ftrace_function(&trace_ops);
+	ftrace_function_enabled = 1;
+}
+
+void tracing_stop_function_trace(void)
+{
+	ftrace_function_enabled = 0;
+	unregister_ftrace_function(&trace_ops);
+}
 static struct ftrace_ops trace_stack_ops __read_mostly =
 {
 	.func = function_stack_trace_call,
-- 
1.5.6.5

-- 
