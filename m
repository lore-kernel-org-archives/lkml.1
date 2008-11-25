Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbYKYUH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbYKYUH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 15:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYKYUHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 15:07:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:42581 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYKYUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 15:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=uflqSUFeKDwwdp2rHqQ9Zgc/bXFsmceLqDe2G5H+KjFJ9iE3N6xLdlMxwRnBIP6U+q
         E51n5zK/46qlSwIRmZbx4e4hkQJP9c1Y9c6zi7kva/sWoGz1wNW7lALboqgStpnKgFhQ
         vOud2rBZ8NDfQhik8hkFTfvcCuXIo0yxFH19Y=
Message-ID: <492C5AE8.50707@gmail.com>
Date: Tue, 25 Nov 2008 21:07:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/function-return-tracer: change the name into function-graph-tracer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanups

This patch changes the name of the return function tracer into
function-graph-tracer which is a more suitable name for a tracing
which makes one able to retrieve the ordered call stack during
the code flow.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/Kconfig                     |    2 +-
 arch/x86/include/asm/ftrace.h        |    4 +-
 arch/x86/kernel/Makefile             |    4 +-
 arch/x86/kernel/entry_32.S           |   12 ++--
 arch/x86/kernel/ftrace.c             |   12 ++--
 include/linux/ftrace.h               |   24 ++++----
 include/linux/ftrace_irq.h           |    2 +-
 include/linux/sched.h                |    2 +-
 kernel/Makefile                      |    2 +-
 kernel/fork.c                        |    4 +-
 kernel/sched.c                       |    2 +-
 kernel/trace/Kconfig                 |   19 ++++---
 kernel/trace/Makefile                |    2 +-
 kernel/trace/ftrace.c                |   26 +++++-----
 kernel/trace/trace.c                 |   18 +++---
 kernel/trace/trace.h                 |   12 ++--
 kernel/trace/trace_functions_graph.c |   98 ++++++++++++++++++++++++++++++++++
 17 files changed, 173 insertions(+), 72 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f10d40b..e7c0a1b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -29,7 +29,7 @@ config X86
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
-	select HAVE_FUNCTION_RET_TRACER if X86_32
+	select HAVE_FUNCTION_GRAPH_TRACER if X86_32
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index 754a3e0..7e61b4c 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -28,7 +28,7 @@ struct dyn_arch_ftrace {
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 #ifndef __ASSEMBLY__
 
@@ -51,6 +51,6 @@ struct ftrace_ret_stack {
 extern void return_to_handler(void);
 
 #endif /* __ASSEMBLY__ */
-#endif /* CONFIG_FUNCTION_RET_TRACER */
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 01272a4..6074f7c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -15,7 +15,7 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
-ifdef CONFIG_FUNCTION_RET_TRACER
+ifdef CONFIG_FUNCTION_GRAPH_TRACER
 # Don't trace __switch_to() but let it for function tracer
 CFLAGS_REMOVE_process_32.o = -pg
 endif
@@ -72,7 +72,7 @@ obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
-obj-$(CONFIG_FUNCTION_RET_TRACER)	+= ftrace.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 7a934c0..dbe8488 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1199,9 +1199,9 @@ ENTRY(mcount)
 
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
-#ifdef CONFIG_FUNCTION_RET_TRACER
-	cmpl $ftrace_stub, ftrace_function_return
-	jnz ftrace_return_caller
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	cmpl $ftrace_stub, ftrace_graph_function
+	jnz ftrace_graph_caller
 #endif
 .globl ftrace_stub
 ftrace_stub:
@@ -1226,8 +1226,8 @@ END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
-ENTRY(ftrace_return_caller)
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+ENTRY(ftrace_graph_caller)
 	cmpl $0, function_trace_stop
 	jne ftrace_stub
 
@@ -1241,7 +1241,7 @@ ENTRY(ftrace_return_caller)
 	popl %ecx
 	popl %eax
 	ret
-END(ftrace_return_caller)
+END(ftrace_graph_caller)
 
 .globl return_to_handler
 return_to_handler:
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index bb137f7..3595a4c 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -323,7 +323,7 @@ int __init ftrace_dyn_arch_init(void *data)
 }
 #endif
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 #ifndef CONFIG_DYNAMIC_FTRACE
 
@@ -389,11 +389,11 @@ static void pop_return_trace(unsigned long *ret, unsigned long long *time,
  */
 unsigned long ftrace_return_to_handler(void)
 {
-	struct ftrace_retfunc trace;
+	struct ftrace_graph_ret trace;
 	pop_return_trace(&trace.ret, &trace.calltime, &trace.func,
 			&trace.overrun);
 	trace.rettime = cpu_clock(raw_smp_processor_id());
-	ftrace_function_return(&trace);
+	ftrace_graph_function(&trace);
 
 	return trace.ret;
 }
@@ -440,12 +440,12 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 	);
 
 	if (WARN_ON(faulted)) {
-		unregister_ftrace_return();
+		unregister_ftrace_graph();
 		return;
 	}
 
 	if (WARN_ON(!__kernel_text_address(old))) {
-		unregister_ftrace_return();
+		unregister_ftrace_graph();
 		*parent = old;
 		return;
 	}
@@ -456,4 +456,4 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		*parent = old;
 }
 
-#endif /* CONFIG_FUNCTION_RET_TRACER */
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7854d87..b4ac734 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -115,8 +115,8 @@ extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
-#ifdef CONFIG_FUNCTION_RET_TRACER
-extern void ftrace_return_caller(void);
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+extern void ftrace_graph_caller(void);
 #endif
 
 /**
@@ -315,7 +315,7 @@ ftrace_init_module(struct module *mod,
 /*
  * Structure that defines a return function trace.
  */
-struct ftrace_retfunc {
+struct ftrace_graph_ret {
 	unsigned long ret; /* Return address */
 	unsigned long func; /* Current function */
 	unsigned long long calltime;
@@ -324,22 +324,22 @@ struct ftrace_retfunc {
 	unsigned long overrun;
 };
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 #define FTRACE_RETFUNC_DEPTH 50
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
 /* Type of a callback handler of tracing return function */
-typedef void (*trace_function_return_t)(struct ftrace_retfunc *);
+typedef void (*trace_function_graph_t)(struct ftrace_graph_ret *);
 
-extern int register_ftrace_return(trace_function_return_t func);
+extern int register_ftrace_graph(trace_function_graph_t func);
 /* The current handler in use */
-extern trace_function_return_t ftrace_function_return;
-extern void unregister_ftrace_return(void);
+extern trace_function_graph_t ftrace_graph_function;
+extern void unregister_ftrace_graph(void);
 
-extern void ftrace_retfunc_init_task(struct task_struct *t);
-extern void ftrace_retfunc_exit_task(struct task_struct *t);
+extern void ftrace_graph_init_task(struct task_struct *t);
+extern void ftrace_graph_exit_task(struct task_struct *t);
 #else
-static inline void ftrace_retfunc_init_task(struct task_struct *t) { }
-static inline void ftrace_retfunc_exit_task(struct task_struct *t) { }
+static inline void ftrace_graph_init_task(struct task_struct *t) { }
+static inline void ftrace_graph_exit_task(struct task_struct *t) { }
 #endif
 
 #endif /* _LINUX_FTRACE_H */
diff --git a/include/linux/ftrace_irq.h b/include/linux/ftrace_irq.h
index 0b4df55..366a054 100644
--- a/include/linux/ftrace_irq.h
+++ b/include/linux/ftrace_irq.h
@@ -2,7 +2,7 @@
 #define _LINUX_FTRACE_IRQ_H
 
 
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_FUNCTION_RET_TRACER)
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_FUNCTION_GRAPH_TRACER)
 extern void ftrace_nmi_enter(void);
 extern void ftrace_nmi_exit(void);
 #else
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3f80f40..a572392 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1362,7 +1362,7 @@ struct task_struct {
 	unsigned long default_timer_slack_ns;
 
 	struct list_head	*scm_work_list;
-#ifdef CONFIG_FUNCTION_RET_TRACER
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	/* Index of current stored adress in ret_stack */
 	int curr_ret_stack;
 	/* Stack of return addresses for return function tracing */
diff --git a/kernel/Makefile b/kernel/Makefile
index 010ccb3..86e2d82 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -20,7 +20,7 @@ CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
 endif
-ifdef CONFIG_FUNCTION_RET_TRACER
+ifdef CONFIG_FUNCTION_GRAPH_TRACER
 CFLAGS_REMOVE_extable.o = -pg # For __kernel_text_address()
 CFLAGS_REMOVE_module.o = -pg # For __module_text_address()
 endif
diff --git a/kernel/fork.c b/kernel/fork.c
index d183739..afb376d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -141,7 +141,7 @@ void free_task(struct task_struct *tsk)
 	prop_local_destroy_single(&tsk->dirties);
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
-	ftrace_retfunc_exit_task(tsk);
+	ftrace_graph_exit_task(tsk);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -1276,7 +1276,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
 	write_unlock_irq(&tasklist_lock);
-	ftrace_retfunc_init_task(p);
+	ftrace_graph_init_task(p);
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	return p;
diff --git a/kernel/sched.c b/kernel/sched.c
index 60fa98a..6ff2667 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5864,7 +5864,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 * The idle tasks have their own, simple scheduling class:
 	 */
 	idle->sched_class = &idle_sched_class;
-	ftrace_retfunc_init_task(idle);
+	ftrace_graph_init_task(idle);
 }
 
 /*
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 620fead..eb9b901 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -12,7 +12,7 @@ config NOP_TRACER
 config HAVE_FUNCTION_TRACER
 	bool
 
-config HAVE_FUNCTION_RET_TRACER
+config HAVE_FUNCTION_GRAPH_TRACER
 	bool
 
 config HAVE_FUNCTION_TRACE_MCOUNT_TEST
@@ -63,15 +63,18 @@ config FUNCTION_TRACER
 	  (the bootup default), then the overhead of the instructions is very
 	  small and not measurable even in micro-benchmarks.
 
-config FUNCTION_RET_TRACER
-	bool "Kernel Function return Tracer"
-	depends on HAVE_FUNCTION_RET_TRACER
+config FUNCTION_GRAPH_TRACER
+	bool "Kernel Function Graph Tracer"
+	depends on HAVE_FUNCTION_GRAPH_TRACER
 	depends on FUNCTION_TRACER
 	help
-	  Enable the kernel to trace a function at its return.
-	  It's first purpose is to trace the duration of functions.
-	  This is done by setting the current return address on the thread
-	  info structure of the current task.
+	  Enable the kernel to trace a function at both its return
+	  and its entry.
+	  It's first purpose is to trace the duration of functions and
+	  draw a call graph for each thread with some informations like
+	  the return value.
+	  This is done by setting the current return address on the current
+	  task structure into a stack of calls.
 
 config IRQSOFF_TRACER
 	bool "Interrupts-off Latency Tracer"
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index cef4bcb..08c5fe6 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
-obj-$(CONFIG_FUNCTION_RET_TRACER) += trace_functions_return.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_BTS_TRACER) += trace_bts.o
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 53042f1..9e19976 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -395,11 +395,11 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	unsigned long ip, fl;
 	unsigned long ftrace_addr;
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (ftrace_tracing_type == FTRACE_TYPE_ENTER)
 		ftrace_addr = (unsigned long)ftrace_caller;
 	else
-		ftrace_addr = (unsigned long)ftrace_return_caller;
+		ftrace_addr = (unsigned long)ftrace_graph_caller;
 #else
 	ftrace_addr = (unsigned long)ftrace_caller;
 #endif
@@ -1496,13 +1496,13 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 
 static atomic_t ftrace_retfunc_active;
 
 /* The callback that hooks the return of a function */
-trace_function_return_t ftrace_function_return =
-			(trace_function_return_t)ftrace_stub;
+trace_function_graph_t ftrace_graph_function =
+			(trace_function_graph_t)ftrace_stub;
 
 
 /* Try to assign a return stack array on FTRACE_RETSTACK_ALLOC_SIZE tasks. */
@@ -1549,7 +1549,7 @@ free:
 }
 
 /* Allocate a return stack for each task */
-static int start_return_tracing(void)
+static int start_graph_tracing(void)
 {
 	struct ftrace_ret_stack **ret_stack_list;
 	int ret;
@@ -1569,7 +1569,7 @@ static int start_return_tracing(void)
 	return ret;
 }
 
-int register_ftrace_return(trace_function_return_t func)
+int register_ftrace_graph(trace_function_graph_t func)
 {
 	int ret = 0;
 
@@ -1584,13 +1584,13 @@ int register_ftrace_return(trace_function_return_t func)
 		goto out;
 	}
 	atomic_inc(&ftrace_retfunc_active);
-	ret = start_return_tracing();
+	ret = start_graph_tracing();
 	if (ret) {
 		atomic_dec(&ftrace_retfunc_active);
 		goto out;
 	}
 	ftrace_tracing_type = FTRACE_TYPE_RETURN;
-	ftrace_function_return = func;
+	ftrace_graph_function = func;
 	ftrace_startup();
 
 out:
@@ -1598,12 +1598,12 @@ out:
 	return ret;
 }
 
-void unregister_ftrace_return(void)
+void unregister_ftrace_graph(void)
 {
 	mutex_lock(&ftrace_sysctl_lock);
 
 	atomic_dec(&ftrace_retfunc_active);
-	ftrace_function_return = (trace_function_return_t)ftrace_stub;
+	ftrace_graph_function = (trace_function_graph_t)ftrace_stub;
 	ftrace_shutdown();
 	/* Restore normal tracing type */
 	ftrace_tracing_type = FTRACE_TYPE_ENTER;
@@ -1612,7 +1612,7 @@ void unregister_ftrace_return(void)
 }
 
 /* Allocate a return stack for newly created task */
-void ftrace_retfunc_init_task(struct task_struct *t)
+void ftrace_graph_init_task(struct task_struct *t)
 {
 	if (atomic_read(&ftrace_retfunc_active)) {
 		t->ret_stack = kmalloc(FTRACE_RETFUNC_DEPTH
@@ -1626,7 +1626,7 @@ void ftrace_retfunc_init_task(struct task_struct *t)
 		t->ret_stack = NULL;
 }
 
-void ftrace_retfunc_exit_task(struct task_struct *t)
+void ftrace_graph_exit_task(struct task_struct *t)
 {
 	struct ftrace_ret_stack	*ret_stack = t->ret_stack;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8df8fdd..f21ab2c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -878,15 +878,15 @@ trace_function(struct trace_array *tr, struct trace_array_cpu *data,
 	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
 }
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
-static void __trace_function_return(struct trace_array *tr,
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static void __trace_function_graph(struct trace_array *tr,
 				struct trace_array_cpu *data,
-				struct ftrace_retfunc *trace,
+				struct ftrace_graph_ret *trace,
 				unsigned long flags,
 				int pc)
 {
 	struct ring_buffer_event *event;
-	struct ftrace_ret_entry *entry;
+	struct ftrace_graph_entry *entry;
 	unsigned long irq_flags;
 
 	if (unlikely(local_read(&__get_cpu_var(ftrace_cpu_disabled))))
@@ -1177,8 +1177,8 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
 	local_irq_restore(flags);
 }
 
-#ifdef CONFIG_FUNCTION_RET_TRACER
-void trace_function_return(struct ftrace_retfunc *trace)
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+void trace_function_graph(struct ftrace_graph_ret *trace)
 {
 	struct trace_array *tr = &global_trace;
 	struct trace_array_cpu *data;
@@ -1193,12 +1193,12 @@ void trace_function_return(struct ftrace_retfunc *trace)
 	disabled = atomic_inc_return(&data->disabled);
 	if (likely(disabled == 1)) {
 		pc = preempt_count();
-		__trace_function_return(tr, data, trace, flags, pc);
+		__trace_function_graph(tr, data, trace, flags, pc);
 	}
 	atomic_dec(&data->disabled);
 	raw_local_irq_restore(flags);
 }
-#endif /* CONFIG_FUNCTION_RET_TRACER */
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 static struct ftrace_ops trace_ops __read_mostly =
 {
@@ -2001,7 +2001,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		break;
 	}
 	case TRACE_FN_RET: {
-		return print_return_function(iter);
+		return print_graph_function(iter);
 		break;
 	}
 	case TRACE_BRANCH: {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3abd645..72b5ef8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -57,7 +57,7 @@ struct ftrace_entry {
 };
 
 /* Function return entry */
-struct ftrace_ret_entry {
+struct ftrace_graph_entry {
 	struct trace_entry	ent;
 	unsigned long		ip;
 	unsigned long		parent_ip;
@@ -264,7 +264,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_boot_call, TRACE_BOOT_CALL);\
 		IF_ASSIGN(var, ent, struct trace_boot_ret, TRACE_BOOT_RET);\
 		IF_ASSIGN(var, ent, struct trace_branch, TRACE_BRANCH); \
-		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET);\
+		IF_ASSIGN(var, ent, struct ftrace_graph_entry, TRACE_FN_RET);\
 		IF_ASSIGN(var, ent, struct bts_entry, TRACE_BTS);\
 		__ftrace_bad_type();					\
 	} while (0)
@@ -398,7 +398,7 @@ void trace_function(struct trace_array *tr,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
 void
-trace_function_return(struct ftrace_retfunc *trace);
+trace_function_graph(struct ftrace_graph_ret *trace);
 
 void trace_bts(struct trace_array *tr,
 	       unsigned long from,
@@ -489,11 +489,11 @@ extern int trace_vprintk(unsigned long ip, const char *fmt, va_list args);
 extern unsigned long trace_flags;
 
 /* Standard output formatting function used for function return traces */
-#ifdef CONFIG_FUNCTION_RET_TRACER
-extern enum print_line_t print_return_function(struct trace_iterator *iter);
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+extern enum print_line_t print_graph_function(struct trace_iterator *iter);
 #else
 static inline enum print_line_t
-print_return_function(struct trace_iterator *iter)
+print_graph_function(struct trace_iterator *iter)
 {
 	return TRACE_TYPE_UNHANDLED;
 }
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
new file mode 100644
index 0000000..f5bad46
--- /dev/null
+++ b/kernel/trace/trace_functions_graph.c
@@ -0,0 +1,98 @@
+/*
+ *
+ * Function graph tracer.
+ * Copyright (c) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ * Mostly borrowed from function tracer which
+ * is Copyright (c) Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+#include <linux/fs.h>
+
+#include "trace.h"
+
+
+#define TRACE_GRAPH_PRINT_OVERRUN	0x1
+static struct tracer_opt trace_opts[] = {
+	/* Display overruns or not */
+	{ TRACER_OPT(overrun, TRACE_GRAPH_PRINT_OVERRUN) },
+	{ } /* Empty entry */
+};
+
+static struct tracer_flags tracer_flags = {
+	.val = 0, /* Don't display overruns by default */
+	.opts = trace_opts
+};
+
+
+static int graph_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+
+	return register_ftrace_graph(&trace_function_graph);
+}
+
+static void graph_trace_reset(struct trace_array *tr)
+{
+		unregister_ftrace_graph();
+}
+
+
+enum print_line_t
+print_graph_function(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	struct ftrace_graph_entry *field;
+	int ret;
+
+	if (entry->type == TRACE_FN_RET) {
+		trace_assign_type(field, entry);
+		ret = trace_seq_printf(s, "%pF -> ", (void *)field->parent_ip);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+
+		ret = seq_print_ip_sym(s, field->ip,
+					trace_flags & TRACE_ITER_SYM_MASK);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+
+		ret = trace_seq_printf(s, " (%llu ns)",
+					field->rettime - field->calltime);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+
+		if (tracer_flags.val & TRACE_GRAPH_PRINT_OVERRUN) {
+			ret = trace_seq_printf(s, " (Overruns: %lu)",
+						field->overrun);
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
+
+		ret = trace_seq_printf(s, "\n");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+
+		return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static struct tracer graph_trace __read_mostly = {
+	.name	     = "function-graph",
+	.init	     = graph_trace_init,
+	.reset	     = graph_trace_reset,
+	.print_line = print_graph_function,
+	.flags		= &tracer_flags,
+};
+
+static __init int init_graph_trace(void)
+{
+	return register_tracer(&graph_trace);
+}
+
+device_initcall(init_graph_trace);
-- 
1.5.2.5
