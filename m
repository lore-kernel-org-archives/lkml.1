Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYKPFCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYKPFCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYKPFCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:02:13 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:12720 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYKPFCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 00:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=jx0CGzXoFVYIdXmn6I4hB5LlE2bvl3Xj33JTuzE4Zjo4Yf5qKoUZQ2+i40QwLndwRU
         KpYLv3Fe7lMZJ+ffM2zxuRqC11OE30jfeeJsIafuJCYnoRB2yPufRRg+m8Rop4JOwTsb
         wcvZMNpFOgqzqC0MspkrnYUc8qfdVH6zoMcGA=
Message-ID: <491FA94E.9090207@gmail.com>
Date: Sun, 16 Nov 2008 06:02:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] tracing/function-return-tracer: Support for dynamic ftrace
 on function return tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the support for dynamic tracing on the function return tracer.
The whole difference with normal dynamic function tracing is that we don't need
to hook on a particular callback. The only pro that we want is to nop or set
dynamically the calls to ftrace_caller (which is ftrace_return_caller here).

Some security checks ensure that we are not trying to launch dynamic tracing for
return tracing while normal function tracing is already running.

An example of trace with getnstimeofday set as a filter:

ktime_get_ts+0x22/0x50 -> getnstimeofday (2283 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1396 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1382 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1825 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1426 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1464 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1524 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1382 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1382 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1434 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1464 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1502 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1404 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1397 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1051 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1314 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1344 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1163 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1390 ns)
ktime_get_ts+0x22/0x50 -> getnstimeofday (1374 ns)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S            |   18 ++-
 arch/x86/kernel/ftrace.c              |  258 +++++++++++++++++----------------
 include/linux/ftrace.h                |   16 ++-
 kernel/trace/Kconfig                  |    1 -
 kernel/trace/ftrace.c                 |   58 +++++++-
 kernel/trace/trace_functions_return.c |   15 +--
 6 files changed, 211 insertions(+), 155 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 266b317..fa4d1b1 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1200,7 +1200,7 @@ ENTRY(mcount)
 	jnz trace
 #ifdef CONFIG_FUNCTION_RET_TRACER
 	cmpl $ftrace_stub, ftrace_function_return
-	jnz trace_return
+	jnz ftrace_return_caller
 #endif
 .globl ftrace_stub
 ftrace_stub:
@@ -1221,9 +1221,15 @@ trace:
 	popl %ecx
 	popl %eax
 	jmp ftrace_stub
+END(mcount)
+#endif /* CONFIG_DYNAMIC_FTRACE */
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #ifdef CONFIG_FUNCTION_RET_TRACER
-trace_return:
+ENTRY(ftrace_return_caller)
+	cmpl $0, function_trace_stop
+	jne ftrace_stub
+
 	pushl %eax
 	pushl %ecx
 	pushl %edx
@@ -1233,7 +1239,8 @@ trace_return:
 	popl %edx
 	popl %ecx
 	popl %eax
-	jmp ftrace_stub
+	ret
+END(ftrace_return_caller)
 
 .globl return_to_handler
 return_to_handler:
@@ -1247,10 +1254,7 @@ return_to_handler:
 	popl %ecx
 	popl %eax
 	ret
-#endif /* CONFIG_FUNCTION_RET_TRACER */
-END(mcount)
-#endif /* CONFIG_DYNAMIC_FTRACE */
-#endif /* CONFIG_FUNCTION_TRACER */
+#endif
 
 .section .rodata,"a"
 #include "syscall_table_32.S"
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d98b5a8..924153e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -24,134 +24,6 @@
 #include <asm/nmi.h>
 
 
-
-#ifdef CONFIG_FUNCTION_RET_TRACER
-
-/*
- * These functions are picked from those used on
- * this page for dynamic ftrace. They have been
- * simplified to ignore all traces in NMI context.
- */
-static atomic_t in_nmi;
-
-void ftrace_nmi_enter(void)
-{
-	atomic_inc(&in_nmi);
-}
-
-void ftrace_nmi_exit(void)
-{
-	atomic_dec(&in_nmi);
-}
-
-/* Add a function return address to the trace stack on thread info.*/
-static int push_return_trace(unsigned long ret, unsigned long long time,
-				unsigned long func)
-{
-	int index;
-	struct thread_info *ti = current_thread_info();
-
-	/* The return trace stack is full */
-	if (ti->curr_ret_stack == FTRACE_RET_STACK_SIZE - 1)
-		return -EBUSY;
-
-	index = ++ti->curr_ret_stack;
-	barrier();
-	ti->ret_stack[index].ret = ret;
-	ti->ret_stack[index].func = func;
-	ti->ret_stack[index].calltime = time;
-
-	return 0;
-}
-
-/* Retrieve a function return address to the trace stack on thread info.*/
-static void pop_return_trace(unsigned long *ret, unsigned long long *time,
-				unsigned long *func)
-{
-	int index;
-
-	struct thread_info *ti = current_thread_info();
-	index = ti->curr_ret_stack;
-	*ret = ti->ret_stack[index].ret;
-	*func = ti->ret_stack[index].func;
-	*time = ti->ret_stack[index].calltime;
-	ti->curr_ret_stack--;
-}
-
-/*
- * Send the trace to the ring-buffer.
- * @return the original return address.
- */
-unsigned long ftrace_return_to_handler(void)
-{
-	struct ftrace_retfunc trace;
-	pop_return_trace(&trace.ret, &trace.calltime, &trace.func);
-	trace.rettime = cpu_clock(raw_smp_processor_id());
-	ftrace_function_return(&trace);
-
-	return trace.ret;
-}
-
-/*
- * Hook the return address and push it in the stack of return addrs
- * in current thread info.
- */
-void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
-{
-	unsigned long old;
-	unsigned long long calltime;
-	int faulted;
-	unsigned long return_hooker = (unsigned long)
-				&return_to_handler;
-
-	/* Nmi's are currently unsupported */
-	if (atomic_read(&in_nmi))
-		return;
-
-	/*
-	 * Protect against fault, even if it shouldn't
-	 * happen. This tool is too much intrusive to
-	 * ignore such a protection.
-	 */
-	asm volatile(
-		"1: movl (%[parent_old]), %[old]\n"
-		"2: movl %[return_hooker], (%[parent_replaced])\n"
-		"   movl $0, %[faulted]\n"
-
-		".section .fixup, \"ax\"\n"
-		"3: movl $1, %[faulted]\n"
-		".previous\n"
-
-		".section __ex_table, \"a\"\n"
-		"   .long 1b, 3b\n"
-		"   .long 2b, 3b\n"
-		".previous\n"
-
-		: [parent_replaced] "=r" (parent), [old] "=r" (old),
-		  [faulted] "=r" (faulted)
-		: [parent_old] "0" (parent), [return_hooker] "r" (return_hooker)
-		: "memory"
-	);
-
-	if (WARN_ON(faulted)) {
-		unregister_ftrace_return();
-		return;
-	}
-
-	if (WARN_ON(!__kernel_text_address(old))) {
-		unregister_ftrace_return();
-		*parent = old;
-		return;
-	}
-
-	calltime = cpu_clock(raw_smp_processor_id());
-
-	if (push_return_trace(old, calltime, self_addr) == -EBUSY)
-		*parent = old;
-}
-
-#endif
-
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 union ftrace_code_union {
@@ -450,3 +322,133 @@ int __init ftrace_dyn_arch_init(void *data)
 	return 0;
 }
 #endif
+
+#ifdef CONFIG_FUNCTION_RET_TRACER
+
+#ifndef CONFIG_DYNAMIC_FTRACE
+
+/*
+ * These functions are picked from those used on
+ * this page for dynamic ftrace. They have been
+ * simplified to ignore all traces in NMI context.
+ */
+static atomic_t in_nmi;
+
+void ftrace_nmi_enter(void)
+{
+	atomic_inc(&in_nmi);
+}
+
+void ftrace_nmi_exit(void)
+{
+	atomic_dec(&in_nmi);
+}
+#endif /* !CONFIG_DYNAMIC_FTRACE */
+
+/* Add a function return address to the trace stack on thread info.*/
+static int push_return_trace(unsigned long ret, unsigned long long time,
+				unsigned long func)
+{
+	int index;
+	struct thread_info *ti = current_thread_info();
+
+	/* The return trace stack is full */
+	if (ti->curr_ret_stack == FTRACE_RET_STACK_SIZE - 1)
+		return -EBUSY;
+
+	index = ++ti->curr_ret_stack;
+	barrier();
+	ti->ret_stack[index].ret = ret;
+	ti->ret_stack[index].func = func;
+	ti->ret_stack[index].calltime = time;
+
+	return 0;
+}
+
+/* Retrieve a function return address to the trace stack on thread info.*/
+static void pop_return_trace(unsigned long *ret, unsigned long long *time,
+				unsigned long *func)
+{
+	int index;
+
+	struct thread_info *ti = current_thread_info();
+	index = ti->curr_ret_stack;
+	*ret = ti->ret_stack[index].ret;
+	*func = ti->ret_stack[index].func;
+	*time = ti->ret_stack[index].calltime;
+	ti->curr_ret_stack--;
+}
+
+/*
+ * Send the trace to the ring-buffer.
+ * @return the original return address.
+ */
+unsigned long ftrace_return_to_handler(void)
+{
+	struct ftrace_retfunc trace;
+	pop_return_trace(&trace.ret, &trace.calltime, &trace.func);
+	trace.rettime = cpu_clock(raw_smp_processor_id());
+	ftrace_function_return(&trace);
+
+	return trace.ret;
+}
+
+/*
+ * Hook the return address and push it in the stack of return addrs
+ * in current thread info.
+ */
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
+{
+	unsigned long old;
+	unsigned long long calltime;
+	int faulted;
+	unsigned long return_hooker = (unsigned long)
+				&return_to_handler;
+
+	/* Nmi's are currently unsupported */
+	if (atomic_read(&in_nmi))
+		return;
+
+	/*
+	 * Protect against fault, even if it shouldn't
+	 * happen. This tool is too much intrusive to
+	 * ignore such a protection.
+	 */
+	asm volatile(
+		"1: movl (%[parent_old]), %[old]\n"
+		"2: movl %[return_hooker], (%[parent_replaced])\n"
+		"   movl $0, %[faulted]\n"
+
+		".section .fixup, \"ax\"\n"
+		"3: movl $1, %[faulted]\n"
+		".previous\n"
+
+		".section __ex_table, \"a\"\n"
+		"   .long 1b, 3b\n"
+		"   .long 2b, 3b\n"
+		".previous\n"
+
+		: [parent_replaced] "=r" (parent), [old] "=r" (old),
+		  [faulted] "=r" (faulted)
+		: [parent_old] "0" (parent), [return_hooker] "r" (return_hooker)
+		: "memory"
+	);
+
+	if (WARN_ON(faulted)) {
+		unregister_ftrace_return();
+		return;
+	}
+
+	if (WARN_ON(!__kernel_text_address(old))) {
+		unregister_ftrace_return();
+		*parent = old;
+		return;
+	}
+
+	calltime = cpu_clock(raw_smp_processor_id());
+
+	if (push_return_trace(old, calltime, self_addr) == -EBUSY)
+		*parent = old;
+}
+
+#endif /* CONFIG_FUNCTION_RET_TRACER */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 166a207..f1af1aa 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -25,6 +25,17 @@ struct ftrace_ops {
 
 extern int function_trace_stop;
 
+/*
+ * Type of the current tracing.
+ */
+enum ftrace_tracing_type_t {
+	FTRACE_TYPE_ENTER = 0, /* Hook the call of the function */
+	FTRACE_TYPE_RETURN,	/* Hook the return of the function */
+};
+
+/* Current tracing type, default is FTRACE_TYPE_ENTER */
+extern enum ftrace_tracing_type_t ftrace_tracing_type;
+
 /**
  * ftrace_stop - stop function tracer.
  *
@@ -104,6 +115,9 @@ extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
+#ifdef CONFIG_FUNCTION_RET_TRACER
+extern void ftrace_return_caller(void);
+#endif
 
 /**
  * ftrace_make_nop - convert code into top
@@ -310,7 +324,7 @@ struct ftrace_retfunc {
 /* Type of a callback handler of tracing return function */
 typedef void (*trace_function_return_t)(struct ftrace_retfunc *);
 
-extern void register_ftrace_return(trace_function_return_t func);
+extern int register_ftrace_return(trace_function_return_t func);
 /* The current handler in use */
 extern trace_function_return_t ftrace_function_return;
 extern void unregister_ftrace_return(void);
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 9c89526..b8378fa 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -59,7 +59,6 @@ config FUNCTION_TRACER
 
 config FUNCTION_RET_TRACER
 	bool "Kernel Function return Tracer"
-	depends on !DYNAMIC_FTRACE
 	depends on HAVE_FUNCTION_RET_TRACER
 	depends on FUNCTION_TRACER
 	help
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index b42ec1d..2f78a45 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -50,6 +50,9 @@ static int last_ftrace_enabled;
 /* Quick disabling of function tracer. */
 int function_trace_stop;
 
+/* By default, current tracing type is normal tracing. */
+enum ftrace_tracing_type_t ftrace_tracing_type = FTRACE_TYPE_ENTER;
+
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -385,12 +388,21 @@ static void ftrace_bug(int failed, unsigned long ip)
 	}
 }
 
-#define FTRACE_ADDR ((long)(ftrace_caller))
 
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
 	unsigned long ip, fl;
+	unsigned long ftrace_addr;
+
+#ifdef CONFIG_FUNCTION_RET_TRACER
+	if (ftrace_tracing_type == FTRACE_TYPE_ENTER)
+		ftrace_addr = (unsigned long)ftrace_caller;
+	else
+		ftrace_addr = (unsigned long)ftrace_return_caller;
+#else
+	ftrace_addr = (unsigned long)ftrace_caller;
+#endif
 
 	ip = rec->ip;
 
@@ -450,9 +462,9 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	}
 
 	if (rec->flags & FTRACE_FL_ENABLED)
-		return ftrace_make_call(rec, FTRACE_ADDR);
+		return ftrace_make_call(rec, ftrace_addr);
 	else
-		return ftrace_make_nop(NULL, rec, FTRACE_ADDR);
+		return ftrace_make_nop(NULL, rec, ftrace_addr);
 }
 
 static void ftrace_replace_code(int enable)
@@ -1405,10 +1417,17 @@ int register_ftrace_function(struct ftrace_ops *ops)
 		return -1;
 
 	mutex_lock(&ftrace_sysctl_lock);
+
+	if (ftrace_tracing_type == FTRACE_TYPE_RETURN) {
+		ret = -EBUSY;
+		goto out;
+	}
+
 	ret = __register_ftrace_function(ops);
 	ftrace_startup();
-	mutex_unlock(&ftrace_sysctl_lock);
 
+out:
+	mutex_unlock(&ftrace_sysctl_lock);
 	return ret;
 }
 
@@ -1474,16 +1493,45 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 }
 
 #ifdef CONFIG_FUNCTION_RET_TRACER
+
+/* The callback that hooks the return of a function */
 trace_function_return_t ftrace_function_return =
 			(trace_function_return_t)ftrace_stub;
-void register_ftrace_return(trace_function_return_t func)
+
+int register_ftrace_return(trace_function_return_t func)
 {
+	int ret = 0;
+
+	mutex_lock(&ftrace_sysctl_lock);
+
+	/*
+	 * Don't launch return tracing if normal function
+	 * tracing is already running.
+	 */
+	if (ftrace_trace_function != ftrace_stub) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ftrace_tracing_type = FTRACE_TYPE_RETURN;
 	ftrace_function_return = func;
+	ftrace_startup();
+
+out:
+	mutex_unlock(&ftrace_sysctl_lock);
+	return ret;
 }
 
 void unregister_ftrace_return(void)
 {
+	mutex_lock(&ftrace_sysctl_lock);
+
 	ftrace_function_return = (trace_function_return_t)ftrace_stub;
+	ftrace_shutdown();
+	/* Restore normal tracing type */
+	ftrace_tracing_type = FTRACE_TYPE_ENTER;
+
+	mutex_unlock(&ftrace_sysctl_lock);
 }
 #endif
 
diff --git a/kernel/trace/trace_functions_return.c b/kernel/trace/trace_functions_return.c
index 61185f7..a68564a 100644
--- a/kernel/trace/trace_functions_return.c
+++ b/kernel/trace/trace_functions_return.c
@@ -14,29 +14,18 @@
 #include "trace.h"
 
 
-static void start_return_trace(struct trace_array *tr)
-{
-	register_ftrace_return(&trace_function_return);
-}
-
-static void stop_return_trace(struct trace_array *tr)
-{
-	unregister_ftrace_return();
-}
-
 static int return_trace_init(struct trace_array *tr)
 {
 	int cpu;
 	for_each_online_cpu(cpu)
 		tracing_reset(tr, cpu);
 
-	start_return_trace(tr);
-	return 0;
+	return register_ftrace_return(&trace_function_return);
 }
 
 static void return_trace_reset(struct trace_array *tr)
 {
-		stop_return_trace(tr);
+		unregister_ftrace_return();
 }
 
 
-- 
1.5.2.5
