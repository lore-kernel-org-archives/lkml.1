Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbYKKGED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbYKKGED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYKKGDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:03:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:57371 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYKKGDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=TPdQOwgQNMz1QGKk9uNlT2HC074i7zUTw4Il0GbKCLHUdN3/AZJdM5LPb2lrr0r6sm
         V1Uc5x5bicbzsBFn7FGNcm5DpwckEDSSZcr+54FeDqPQ0ydNQG0JkMyCXSkybSKGGcwe
         qN7kTUN6mi4jnkOId7QtbkAs68c+kKQme/yaE=
Message-ID: <49192041.7090302@gmail.com>
Date: Tue, 11 Nov 2008 07:03:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [RFC v3][PATCH 1/2] Add low level support for ftrace return tracing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add low level support for ftrace return tracing.
This plug-in stores return addresses on the thread_info structure of
the current task.
The index of the current return address is initialized when the task is the first one (init)
and when a process forks (the child). It is not needed when a task does a sys_execve because after this syscall, it still needs to return on the kernel functions it called.
Note that the code of return_to_handler has been suggested by Steven Rostedt as almost
all of the ideas of improvements in this V3.
For purpose of security, arch/x86/kernel/process_32.c is not traced because __switch_to() changes the
current task during its execution. That could cause inconsistency in the stored return address of this
function even if I didn't have any crash after testing with tracing on this function enabled.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b5e7143..0202a7b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -11,6 +11,7 @@ config 64BIT
 
 config X86_32
 	def_bool !64BIT
+	select HAVE_FTRACE_RETURN
 
 config X86_64
 	def_bool 64BIT
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index f8173ed..bf574b3 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -20,4 +20,30 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 #endif /* __ASSEMBLY__ */
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_FTRACE_RETURN
+#define FTRACE_RET_STACK_SIZE 20
+
+#ifndef __ASSEMBLY__
+
+/*
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
+ * Defined in entry32.S
+ */
+extern void return_to_handler(void);
+
+#endif /* __ASSEMBLY__ */
+#endif /* CONFIG_FTRACE_RETURN */
+
 #endif /* _ASM_X86_FTRACE_H */
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e44d379..8b9b3e2 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -20,6 +20,7 @@
 struct task_struct;
 struct exec_domain;
 #include <asm/processor.h>
+#include <asm/ftrace.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
@@ -38,8 +39,30 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
+
+#ifdef CONFIG_FTRACE_RETURN
+	/* Index of current stored adress in ret_stack */
+	int		curr_ret_stack;
+	/* Stack of return addresses for return function tracing */
+	struct ftrace_ret_stack	ret_stack[FTRACE_RET_STACK_SIZE];
+#endif
 };
 
+#ifdef CONFIG_FTRACE_RETURN
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= 1,			\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block = {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+	.curr_ret_stack = -1,\
+}
+#else
 #define INIT_THREAD_INFO(tsk)			\
 {						\
 	.task		= &tsk,			\
@@ -52,6 +75,7 @@ struct thread_info {
 		.fn = do_no_restart_syscall,	\
 	},					\
 }
+#endif
 
 #define init_thread_info	(init_thread_union.thread_info)
 #define init_stack		(init_thread_union.stack)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index fb62078..29c5bb4 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -15,6 +15,11 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
+ifdef CONFIG_FTRACE_RETURN
+# Don't trace __switch_to() but let it for function tracer
+CFLAGS_REMOVE_process_32.o = -pg
+endif
+
 #
 # vsyscalls (which work on the user stack) should have
 # no stack-protector checks:
@@ -67,6 +72,7 @@ obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_FTRACE_RETURN)	+= ftrace.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 9134de8..769cfec 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1188,6 +1188,10 @@ ENTRY(mcount)
 
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
+#ifdef CONFIG_FTRACE_RETURN
+	cmpl $ftrace_stub, ftrace_function_return
+	jnz trace_return
+#endif
 .globl ftrace_stub
 ftrace_stub:
 	ret
@@ -1206,8 +1210,37 @@ trace:
 	popl %edx
 	popl %ecx
 	popl %eax
+	jmp ftrace_stub
 
+#ifdef CONFIG_FTRACE_RETURN
+trace_return:
+	pushl %eax
+	pushl %ecx
+	pushl %edx
+	movl 0xc(%esp), %eax
+	pushl %eax
+	lea 0x4(%ebp), %eax
+	pushl %eax
+	call prepare_ftrace_return
+	addl $8, %esp
+	popl %edx
+	popl %ecx
+	popl %eax
 	jmp ftrace_stub
+
+.globl return_to_handler
+return_to_handler:
+	pushl $0
+	pushl %eax
+	pushl %ecx
+	pushl %edx
+	call ftrace_return_to_handler
+	movl %eax, 0xc(%esp)
+	popl %edx
+	popl %ecx
+	popl %eax
+	ret
+#endif /* CONFIG_FTRACE_RETURN */
 END(mcount)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 6914933..22f31cd 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -18,10 +18,173 @@
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
+#include <linux/ftrace.h>
 #include <asm/nops.h>
+#include <asm/nmi.h>
 
 
-static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
+
+#ifdef CONFIG_FTRACE_RETURN
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
+
+/*
+ * Synchronize accesses to return adresses stack with
+ * interrupts.
+ */
+static raw_spinlock_t ret_stack_lock;
+
+/* Add a function return address to the trace stack on thread info.*/
+static int push_return_trace(unsigned long ret, unsigned long long time,
+				unsigned long func)
+{
+	int index;
+	struct thread_info *ti;
+	unsigned long flags;
+	int err = 0;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&ret_stack_lock);
+
+	ti = current_thread_info();
+	/* The return trace stack is full */
+	if (ti->curr_ret_stack == FTRACE_RET_STACK_SIZE - 1) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	index = ++ti->curr_ret_stack;
+	ti->ret_stack[index].ret = ret;
+	ti->ret_stack[index].func = func;
+	ti->ret_stack[index].calltime = time;
+
+out:
+	__raw_spin_unlock(&ret_stack_lock);
+	raw_local_irq_restore(flags);
+	return err;
+}
+
+/* Retrieve a function return address to the trace stack on thread info.*/
+static void pop_return_trace(unsigned long *ret, unsigned long long *time,
+				unsigned long *func)
+{
+	struct thread_info *ti;
+	int index;
+	unsigned long flags;
+
+	raw_local_irq_save(flags);
+	__raw_spin_lock(&ret_stack_lock);
+
+	ti = current_thread_info();
+	index = ti->curr_ret_stack;
+	*ret = ti->ret_stack[index].ret;
+	*func = ti->ret_stack[index].func;
+	*time = ti->ret_stack[index].calltime;
+	ti->curr_ret_stack--;
+
+	__raw_spin_unlock(&ret_stack_lock);
+	raw_local_irq_restore(flags);
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
+asmlinkage
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
+		: [parent_replaced] "=rm" (parent), [old] "=r" (old),
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
+static int __init init_ftrace_function_return(void)
+{
+	ret_stack_lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	return 0;
+}
+device_initcall(init_ftrace_function_return);
+
+
+#endif
+
+#ifdef CONFIG_DYNAMIC_FTRACE
 
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
@@ -31,17 +194,11 @@ union ftrace_code_union {
 	} __attribute__((packed));
 };
 
-
 static int ftrace_calc_offset(long ip, long addr)
 {
 	return (int)(addr - ip);
 }
 
-unsigned char *ftrace_nop_replace(void)
-{
-	return ftrace_nop;
-}
-
 unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 {
 	static union ftrace_code_union calc;
@@ -183,6 +340,15 @@ do_ftrace_mod_code(unsigned long ip, void *new_code)
 }
 
 
+
+
+static unsigned char ftrace_nop[MCOUNT_INSN_SIZE];
+
+unsigned char *ftrace_nop_replace(void)
+{
+	return ftrace_nop;
+}
+
 int
 ftrace_modify_code(unsigned long ip, unsigned char *old_code,
 		   unsigned char *new_code)
@@ -292,3 +458,4 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	return 0;
 }
+#endif
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 1f5608c..76faccd 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -268,6 +268,26 @@ ftrace_init_module(unsigned long *start, unsigned long *end) { }
 
 
 /*
+ * Structure that defines a return function trace.
+ */
+struct ftrace_retfunc {
+	unsigned long ret; /* Return address */
+	unsigned long func; /* Current function */
+	unsigned long long calltime;
+	unsigned long long rettime;
+};
+
+#ifdef CONFIG_FTRACE_RETURN
+/* Type of a callback handler of tracing return function */
+typedef void (*trace_function_return_t)(struct ftrace_retfunc *);
+
+extern void register_ftrace_return(trace_function_return_t func);
+/* The current handler in use */
+extern trace_function_return_t ftrace_function_return;
+extern void unregister_ftrace_return(void);
+#endif
+
+/*
  * Structure which defines the trace of an initcall.
  * You don't have to fill the func field since it is
  * only used internally by the tracer.
diff --git a/include/linux/ftrace_irq.h b/include/linux/ftrace_irq.h
index b1299d6..e47e432 100644
--- a/include/linux/ftrace_irq.h
+++ b/include/linux/ftrace_irq.h
@@ -2,7 +2,7 @@
 #define _LINUX_FTRACE_IRQ_H
 
 
-#ifdef CONFIG_DYNAMIC_FTRACE
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_FTRACE_RETURN)
 extern void ftrace_nmi_enter(void);
 extern void ftrace_nmi_exit(void);
 #else
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 51ad5af..05dd4b4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2004,6 +2004,17 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
 {
 	*task_thread_info(p) = *task_thread_info(org);
 	task_thread_info(p)->task = p;
+
+#ifdef CONFIG_FTRACE_RETURN
+	/*
+	 * When fork() creates a child process, this function is called.
+	 * But the child task may not inherit the return adresses traced
+	 * by the return function tracer because it will directly execute
+	 * in userspace and will not return to kernel functions its parent
+	 * used.
+	 */
+	task_thread_info(p)->curr_ret_stack = -1;
+#endif
 }
 
 static inline unsigned long *end_of_stack(struct task_struct *p)
diff --git a/kernel/Makefile b/kernel/Makefile
index e1af039..90b39f6 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -22,6 +22,10 @@ CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
 endif
+ifdef CONFIG_FTRACE_RETURN
+CFLAGS_REMOVE_extable.o = -pg # For __kernel_text_address()
+CFLAGS_REMOVE_module.o = -pg # For __module_text_address()
+endif
 
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
