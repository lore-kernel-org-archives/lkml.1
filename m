Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbZBLBQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbZBLBQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbZBLBNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:13:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157AbZBLBNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:13:47 -0500
Message-Id: <20090212011342.607138533@goodmis.org>
References: <20090212011051.265346435@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 11 Feb 2009 20:10:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/7][RFC] tracing/function-graph-tracer: make arch generic push pop functions
Content-Disposition: inline; filename=0001-tracing-function-graph-tracer-make-arch-generic-pus.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There is nothing really arch specific of the push and pop functions
used by the function graph tracer. This patch moves them to generic
code.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/include/asm/ftrace.h        |   25 -----------
 arch/x86/kernel/ftrace.c             |   75 +---------------------------------
 include/linux/ftrace.h               |   24 +++++++++++
 kernel/trace/trace_functions_graph.c |   75 ++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 99 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index b55b4a7..db24c22 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -55,29 +55,4 @@ struct dyn_arch_ftrace {
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-
-#ifndef __ASSEMBLY__
-
-/*
- * Stack of return addresses for functions
- * of a thread.
- * Used in struct thread_info
- */
-struct ftrace_ret_stack {
-	unsigned long ret;
-	unsigned long func;
-	unsigned long long calltime;
-};
-
-/*
- * Primary handler of a function return.
- * It relays on ftrace_return_to_handler.
- * Defined in entry_32/64.S
- */
-extern void return_to_handler(void);
-
-#endif /* __ASSEMBLY__ */
-#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1b43086..258c8d5 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -389,79 +389,6 @@ void ftrace_nmi_exit(void)
 
 #endif /* !CONFIG_DYNAMIC_FTRACE */
 
-/* Add a function return address to the trace stack on thread info.*/
-static int push_return_trace(unsigned long ret, unsigned long long time,
-				unsigned long func, int *depth)
-{
-	int index;
-
-	if (!current->ret_stack)
-		return -EBUSY;
-
-	/* The return trace stack is full */
-	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
-		atomic_inc(&current->trace_overrun);
-		return -EBUSY;
-	}
-
-	index = ++current->curr_ret_stack;
-	barrier();
-	current->ret_stack[index].ret = ret;
-	current->ret_stack[index].func = func;
-	current->ret_stack[index].calltime = time;
-	*depth = index;
-
-	return 0;
-}
-
-/* Retrieve a function return address to the trace stack on thread info.*/
-static void pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
-{
-	int index;
-
-	index = current->curr_ret_stack;
-
-	if (unlikely(index < 0)) {
-		ftrace_graph_stop();
-		WARN_ON(1);
-		/* Might as well panic, otherwise we have no where to go */
-		*ret = (unsigned long)panic;
-		return;
-	}
-
-	*ret = current->ret_stack[index].ret;
-	trace->func = current->ret_stack[index].func;
-	trace->calltime = current->ret_stack[index].calltime;
-	trace->overrun = atomic_read(&current->trace_overrun);
-	trace->depth = index;
-	barrier();
-	current->curr_ret_stack--;
-
-}
-
-/*
- * Send the trace to the ring-buffer.
- * @return the original return address.
- */
-unsigned long ftrace_return_to_handler(void)
-{
-	struct ftrace_graph_ret trace;
-	unsigned long ret;
-
-	pop_return_trace(&trace, &ret);
-	trace.rettime = cpu_clock(raw_smp_processor_id());
-	ftrace_graph_return(&trace);
-
-	if (unlikely(!ret)) {
-		ftrace_graph_stop();
-		WARN_ON(1);
-		/* Might as well panic. What else to do? */
-		ret = (unsigned long)panic;
-	}
-
-	return ret;
-}
-
 /*
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
@@ -520,7 +447,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 
 	calltime = cpu_clock(raw_smp_processor_id());
 
-	if (push_return_trace(old, calltime,
+	if (ftrace_push_return_trace(old, calltime,
 				self_addr, &trace.depth) == -EBUSY) {
 		*parent = old;
 		return;
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 677432b..a7f8134 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -380,6 +380,30 @@ struct ftrace_graph_ret {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 /*
+ * Stack of return addresses for functions
+ * of a thread.
+ * Used in struct thread_info
+ */
+struct ftrace_ret_stack {
+	unsigned long ret;
+	unsigned long func;
+	unsigned long long calltime;
+};
+
+/*
+ * Primary handler of a function return.
+ * It relays on ftrace_return_to_handler.
+ * Defined in entry_32/64.S
+ */
+extern void return_to_handler(void);
+
+extern int
+ftrace_push_return_trace(unsigned long ret, unsigned long long time,
+			 unsigned long func, int *depth);
+extern void
+ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret);
+
+/*
  * Sometimes we don't want to trace a function with the function
  * graph tracer but we want them to keep traced by the usual function
  * tracer if the function graph tracer is not configured.
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 930c08e..dce71a5 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -42,6 +42,81 @@ static struct tracer_flags tracer_flags = {
 /* pid on the last trace processed */
 static pid_t last_pid[NR_CPUS] = { [0 ... NR_CPUS-1] = -1 };
 
+/* Add a function return address to the trace stack on thread info.*/
+int
+ftrace_push_return_trace(unsigned long ret, unsigned long long time,
+			 unsigned long func, int *depth)
+{
+	int index;
+
+	if (!current->ret_stack)
+		return -EBUSY;
+
+	/* The return trace stack is full */
+	if (current->curr_ret_stack == FTRACE_RETFUNC_DEPTH - 1) {
+		atomic_inc(&current->trace_overrun);
+		return -EBUSY;
+	}
+
+	index = ++current->curr_ret_stack;
+	barrier();
+	current->ret_stack[index].ret = ret;
+	current->ret_stack[index].func = func;
+	current->ret_stack[index].calltime = time;
+	*depth = index;
+
+	return 0;
+}
+
+/* Retrieve a function return address to the trace stack on thread info.*/
+void
+ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret)
+{
+	int index;
+
+	index = current->curr_ret_stack;
+
+	if (unlikely(index < 0)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		/* Might as well panic, otherwise we have no where to go */
+		*ret = (unsigned long)panic;
+		return;
+	}
+
+	*ret = current->ret_stack[index].ret;
+	trace->func = current->ret_stack[index].func;
+	trace->calltime = current->ret_stack[index].calltime;
+	trace->overrun = atomic_read(&current->trace_overrun);
+	trace->depth = index;
+	barrier();
+	current->curr_ret_stack--;
+
+}
+
+/*
+ * Send the trace to the ring-buffer.
+ * @return the original return address.
+ */
+unsigned long ftrace_return_to_handler(void)
+{
+	struct ftrace_graph_ret trace;
+	unsigned long ret;
+
+	ftrace_pop_return_trace(&trace, &ret);
+	trace.rettime = cpu_clock(raw_smp_processor_id());
+	ftrace_graph_return(&trace);
+
+	if (unlikely(!ret)) {
+		ftrace_graph_stop();
+		WARN_ON(1);
+		/* Might as well panic. What else to do? */
+		ret = (unsigned long)panic;
+	}
+
+	return ret;
+}
+
 static int graph_trace_init(struct trace_array *tr)
 {
 	int cpu, ret;
-- 
1.5.6.5

-- 
