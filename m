Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbYGAXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbYGAXdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbYGAXcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:32:24 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:18270 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801AbYGAXcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:32:21 -0400
Date: Wed, 2 Jul 2008 01:29:44 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: initial changes to unify traps_32.c and traps_64.c
Message-ID: <20080701232944.GA29903@mailshack.com>
References: <20080701193643.GA29695@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701193643.GA29695@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 02 Jul 2008 01:32:00 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.59; VDF: 7.0.5.30; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does not change the generated object files.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   78 ++++++------
 arch/x86/kernel/traps_64.c |  309 ++++++++++++++++++++++----------------------
 2 files changed, 191 insertions(+), 196 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 18c8b8d..9dd2521 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1,5 +1,6 @@
 /*
  *  Copyright (C) 1991, 1992  Linus Torvalds
+ *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
  *
  *  Pentium III FXSR, SSE support
  *	Gareth Hughes <gareth@valinux.com>, May 2000
@@ -131,7 +132,8 @@ void printk_address(unsigned long address, int reliable)
 #endif
 }
 
-static inline int valid_stack_ptr(struct thread_info *tinfo, void *p, unsigned size)
+static inline int valid_stack_ptr(struct thread_info *tinfo,
+			void *p, unsigned int size)
 {
 	return	p > (void *)tinfo &&
 		p <= (void *)tinfo + THREAD_SIZE - size;
@@ -139,14 +141,14 @@ static inline int valid_stack_ptr(struct thread_info *tinfo, void *p, unsigned s
 
 /* The form of the top of the frame on the stack */
 struct stack_frame {
-	struct stack_frame	*next_frame;
-	unsigned long		return_address;
+	struct stack_frame *next_frame;
+	unsigned long return_address;
 };
 
 static inline unsigned long
 print_context_stack(struct thread_info *tinfo,
-		    unsigned long *stack, unsigned long bp,
-		    const struct stacktrace_ops *ops, void *data)
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data)
 {
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
@@ -168,8 +170,6 @@ print_context_stack(struct thread_info *tinfo,
 	return bp;
 }
 
-#define MSG(msg)		ops->warning(data, msg)
-
 void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
@@ -179,7 +179,6 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 	if (!stack) {
 		unsigned long dummy;
-
 		stack = &dummy;
 		if (task != current)
 			stack = (unsigned long *)task->thread.sp;
@@ -197,7 +196,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	}
 #endif
 
-	while (1) {
+	for (;;) {
 		struct thread_info *context;
 
 		context = (struct thread_info *)
@@ -249,10 +248,10 @@ static void print_trace_address(void *data, unsigned long addr, int reliable)
 }
 
 static const struct stacktrace_ops print_trace_ops = {
-	.warning		= print_trace_warning,
-	.warning_symbol		= print_trace_warning_symbol,
-	.stack			= print_trace_stack,
-	.address		= print_trace_address,
+	.warning = print_trace_warning,
+	.warning_symbol = print_trace_warning_symbol,
+	.stack = print_trace_stack,
+	.address = print_trace_address,
 };
 
 static void
@@ -352,15 +351,14 @@ void show_registers(struct pt_regs *regs)
 		printk(KERN_EMERG "Code: ");
 
 		ip = (u8 *)regs->ip - code_prologue;
-		if (ip < (u8 *)PAGE_OFFSET ||
-			probe_kernel_address(ip, c)) {
+		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
 			/* try starting at EIP */
 			ip = (u8 *)regs->ip;
 			code_len = code_len - code_prologue + 1;
 		}
 		for (i = 0; i < code_len; i++, ip++) {
 			if (ip < (u8 *)PAGE_OFFSET ||
-				probe_kernel_address(ip, c)) {
+					probe_kernel_address(ip, c)) {
 				printk(" Bad EIP value.");
 				break;
 			}
@@ -550,7 +548,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 {									\
 	trace_hardirqs_fixup();						\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-						== NOTIFY_STOP)		\
+							== NOTIFY_STOP)	\
 		return;							\
 	do_trap(trapnr, signr, str, 0, regs, error_code, NULL);		\
 }
@@ -566,7 +564,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	info.si_code = sicode;						\
 	info.si_addr = (void __user *)siaddr;				\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-						== NOTIFY_STOP)		\
+							== NOTIFY_STOP)	\
 		return;							\
 	do_trap(trapnr, signr, str, 0, regs, error_code, &info);	\
 }
@@ -575,7 +573,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 void do_##name(struct pt_regs *regs, long error_code)			\
 {									\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-						== NOTIFY_STOP)		\
+							== NOTIFY_STOP)	\
 		return;							\
 	do_trap(trapnr, signr, str, 1, regs, error_code, NULL);		\
 }
@@ -590,22 +588,22 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 	info.si_addr = (void __user *)siaddr;				\
 	trace_hardirqs_fixup();						\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
-						== NOTIFY_STOP)		\
+							== NOTIFY_STOP)	\
 		return;							\
 	do_trap(trapnr, signr, str, 1, regs, error_code, &info);	\
 }
 
-DO_VM86_ERROR_INFO(0, SIGFPE,  "divide error", divide_error, FPE_INTDIV, regs->ip)
+DO_VM86_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
 #if !defined(CONFIG_KPROBES) && !defined(CONFIG_IMMEDIATE)
 DO_VM86_ERROR(3, SIGTRAP, "int3", int3)
 #endif
 DO_VM86_ERROR(4, SIGSEGV, "overflow", overflow)
 DO_VM86_ERROR(5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO(6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
-DO_ERROR(9, SIGFPE,  "coprocessor segment overrun", coprocessor_segment_overrun)
+DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip, 0)
+DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
-DO_ERROR(12, SIGBUS,  "stack segment", stack_segment)
+DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
 DO_ERROR_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
@@ -803,7 +801,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 
 	if (!(reason & 0xc0)) {
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
-							== NOTIFY_STOP)
+								== NOTIFY_STOP)
 			return;
 #ifdef CONFIG_X86_LOCAL_APIC
 		/*
@@ -822,6 +820,8 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	}
 	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
 		return;
+
+	/* AK: following checks seem to be broken on modern chipsets. FIXME */
 	if (reason & 0x80)
 		mem_parity_error(reason, regs);
 	if (reason & 0x40)
@@ -927,7 +927,7 @@ void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	tsk->thread.debugctlmsr = 0;
 
 	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
-					SIGTRAP) == NOTIFY_STOP)
+						SIGTRAP) == NOTIFY_STOP)
 		return;
 	/* It's safe to allow irq's after DR6 has been saved */
 	if (regs->flags & X86_EFLAGS_IF)
@@ -1009,7 +1009,7 @@ void math_error(void __user *ip)
 	 * C1 reg you need in case of a stack fault, 0x040 is the stack
 	 * fault bit.  We should only be taking one exception at a time,
 	 * so if this combination doesn't produce any single exception,
-	 * then we have a bad program that isn't syncronizing its FPU usage
+	 * then we have a bad program that isn't synchronizing its FPU usage
 	 * and it will suffer the consequences since we won't be able to
 	 * fully reproduce the context of the exception
 	 */
@@ -1018,7 +1018,7 @@ void math_error(void __user *ip)
 	switch (swd & ~cwd & 0x3f) {
 	case 0x000: /* No unmasked exception */
 		return;
-	default:    /* Multiple exceptions */
+	default: /* Multiple exceptions */
 		break;
 	case 0x001: /* Invalid Op */
 		/*
@@ -1213,16 +1213,16 @@ void __init trap_init(void)
 #ifdef CONFIG_X86_LOCAL_APIC
 	init_apic_mappings();
 #endif
-	set_trap_gate(0,  &divide_error);
-	set_intr_gate(1,  &debug);
-	set_intr_gate(2,  &nmi);
-	set_system_intr_gate(3, &int3); /* int3/4 can be called from all */
-	set_system_gate(4, &overflow);
-	set_trap_gate(5,  &bounds);
-	set_trap_gate(6,  &invalid_op);
-	set_trap_gate(7,  &device_not_available);
-	set_task_gate(8,  GDT_ENTRY_DOUBLEFAULT_TSS);
-	set_trap_gate(9,  &coprocessor_segment_overrun);
+	set_trap_gate(0, &divide_error);
+	set_intr_gate(1, &debug);
+	set_intr_gate(2, &nmi);
+	set_system_intr_gate(3, &int3); /* int3 can be called from all */
+	set_system_gate(4, &overflow); /* int4 can be called from all */
+	set_trap_gate(5, &bounds);
+	set_trap_gate(6, &invalid_op);
+	set_trap_gate(7, &device_not_available);
+	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
+	set_trap_gate(9, &coprocessor_segment_overrun);
 	set_trap_gate(10, &invalid_TSS);
 	set_trap_gate(11, &segment_not_present);
 	set_trap_gate(12, &stack_segment);
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index fc5b66e..46af2d8 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -206,8 +206,6 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 	return NULL;
 }
 
-#define MSG(txt) ops->warning(data, txt)
-
 /*
  * x86-64 can have up to three kernel stacks: 
  * process stack
@@ -234,11 +232,11 @@ struct stack_frame {
 	unsigned long return_address;
 };
 
-
-static inline unsigned long print_context_stack(struct thread_info *tinfo,
-				unsigned long *stack, unsigned long bp,
-				const struct stacktrace_ops *ops, void *data,
-				unsigned long *end)
+static inline unsigned long
+print_context_stack(struct thread_info *tinfo,
+		unsigned long *stack, unsigned long bp,
+		const struct stacktrace_ops *ops, void *data,
+		unsigned long *end)
 {
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
@@ -260,7 +258,7 @@ static inline unsigned long print_context_stack(struct thread_info *tinfo,
 	return bp;
 }
 
-void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
+void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp,
 		const struct stacktrace_ops *ops, void *data)
 {
@@ -269,31 +267,29 @@ void dump_trace(struct task_struct *tsk, struct pt_regs *regs,
 	unsigned used = 0;
 	struct thread_info *tinfo;
 
-	if (!tsk)
-		tsk = current;
-	tinfo = task_thread_info(tsk);
+	if (!task)
+		task = current;
+	tinfo = task_thread_info(task);
 
 	if (!stack) {
 		unsigned long dummy;
 		stack = &dummy;
-		if (tsk && tsk != current)
-			stack = (unsigned long *)tsk->thread.sp;
+		if (task && task != current)
+			stack = (unsigned long *)task->thread.sp;
 	}
 
 #ifdef CONFIG_FRAME_POINTER
 	if (!bp) {
-		if (tsk == current) {
+		if (task == current) {
 			/* Grab bp right from our regs */
-			asm("movq %%rbp, %0" : "=r" (bp):);
+			asm("movq %%rbp, %0" : "=r" (bp) :);
 		} else {
 			/* bp is the last reg pushed by switch_to */
-			bp = *(unsigned long *) tsk->thread.sp;
+			bp = *(unsigned long *) task->thread.sp;
 		}
 	}
 #endif
 
-
-
 	/*
 	 * Print function call entries in all stacks, starting at the
 	 * current stack address. If the stacks consist of nested
@@ -383,18 +379,17 @@ static const struct stacktrace_ops print_trace_ops = {
 	.address = print_trace_address,
 };
 
-void
-show_trace(struct task_struct *tsk, struct pt_regs *regs, unsigned long *stack,
-		unsigned long bp)
+void show_trace(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *stack, unsigned long bp)
 {
 	printk("\nCall Trace:\n");
-	dump_trace(tsk, regs, stack, bp, &print_trace_ops, NULL);
+	dump_trace(task, regs, stack, bp, &print_trace_ops, NULL);
 	printk("\n");
 }
 
 static void
-_show_stack(struct task_struct *tsk, struct pt_regs *regs, unsigned long *sp,
-							unsigned long bp)
+_show_stack(struct task_struct *task, struct pt_regs *regs,
+		unsigned long *sp, unsigned long bp)
 {
 	unsigned long *stack;
 	int i;
@@ -406,14 +401,14 @@ _show_stack(struct task_struct *tsk, struct pt_regs *regs, unsigned long *sp,
 	// back trace for this cpu.
 
 	if (sp == NULL) {
-		if (tsk)
-			sp = (unsigned long *)tsk->thread.sp;
+		if (task)
+			sp = (unsigned long *)task->thread.sp;
 		else
 			sp = (unsigned long *)&sp;
 	}
 
 	stack = sp;
-	for(i=0; i < kstack_depth_to_print; i++) {
+	for (i = 0; i < kstack_depth_to_print; i++) {
 		if (stack >= irqstack && stack <= irqstack_end) {
 			if (stack == irqstack_end) {
 				stack = (unsigned long *) (irqstack_end[-1]);
@@ -428,12 +423,12 @@ _show_stack(struct task_struct *tsk, struct pt_regs *regs, unsigned long *sp,
 		printk(" %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
-	show_trace(tsk, regs, sp, bp);
+	show_trace(task, regs, sp, bp);
 }
 
-void show_stack(struct task_struct *tsk, unsigned long * sp)
+void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	_show_stack(tsk, NULL, sp, 0);
+	_show_stack(task, NULL, sp, 0);
 }
 
 /*
@@ -441,7 +436,7 @@ void show_stack(struct task_struct *tsk, unsigned long * sp)
  */
 void dump_stack(void)
 {
-	unsigned long dummy;
+	unsigned long stack;
 	unsigned long bp = 0;
 
 #ifdef CONFIG_FRAME_POINTER
@@ -454,7 +449,7 @@ void dump_stack(void)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	show_trace(NULL, NULL, &dummy, bp);
+	show_trace(NULL, NULL, &stack, bp);
 }
 
 EXPORT_SYMBOL(dump_stack);
@@ -489,7 +484,7 @@ void show_registers(struct pt_regs *regs)
 		printk(KERN_EMERG "Code: ");
 		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
 			/* try starting at RIP */
-			ip = (u8 *) regs->ip;
+			ip = (u8 *)regs->ip;
 			code_len = code_len - code_prologue + 1;
 		}
 		for (i = 0; i < code_len; i++, ip++) {
@@ -505,7 +500,7 @@ void show_registers(struct pt_regs *regs)
 		}
 	}
 	printk("\n");
-}	
+}
 
 int is_valid_bugaddr(unsigned long ip)
 {
@@ -581,8 +576,10 @@ int __kprobes __die(const char * str, struct pt_regs * regs, long err)
 	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
-	if (notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+	if (notify_die(DIE_OOPS, str, regs, err,
+			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
 		return 1;
+
 	show_registers(regs);
 	add_taint(TAINT_DIE);
 	/* Executive summary in case the oops scrolled away */
@@ -594,7 +591,7 @@ int __kprobes __die(const char * str, struct pt_regs * regs, long err)
 	return 0;
 }
 
-void die(const char * str, struct pt_regs * regs, long err)
+void die(const char * str, struct pt_regs *regs, long err)
 {
 	unsigned long flags = oops_begin();
 
@@ -611,8 +608,7 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 {
 	unsigned long flags;
 
-	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) ==
-	    NOTIFY_STOP)
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
 		return;
 
 	flags = oops_begin();
@@ -634,9 +630,9 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 	do_exit(SIGBUS);
 }
 
-static void __kprobes do_trap(int trapnr, int signr, char *str,
-			      struct pt_regs * regs, long error_code,
-			      siginfo_t *info)
+static void __kprobes
+do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
+	long error_code, siginfo_t *info)
 {
 	struct task_struct *tsk = current;
 
@@ -681,38 +677,38 @@ static void __kprobes do_trap(int trapnr, int signr, char *str,
 }
 
 #define DO_ERROR(trapnr, signr, str, name) \
-asmlinkage void do_##name(struct pt_regs * regs, long error_code) \
-{ \
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) \
-							== NOTIFY_STOP) \
-		return; \
+asmlinkage void do_##name(struct pt_regs * regs, long error_code)	\
+{									\
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
+							== NOTIFY_STOP)	\
+		return;							\
 	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, NULL); \
+	do_trap(trapnr, signr, str, regs, error_code, NULL);		\
 }
 
-#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr) \
-asmlinkage void do_##name(struct pt_regs * regs, long error_code) \
-{ \
-	siginfo_t info; \
-	info.si_signo = signr; \
-	info.si_errno = 0; \
-	info.si_code = sicode; \
-	info.si_addr = (void __user *)siaddr; \
-	trace_hardirqs_fixup(); \
-	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) \
-							== NOTIFY_STOP) \
-		return; \
+#define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
+asmlinkage void do_##name(struct pt_regs * regs, long error_code)	\
+{									\
+	siginfo_t info;							\
+	info.si_signo = signr;						\
+	info.si_errno = 0;						\
+	info.si_code = sicode;						\
+	info.si_addr = (void __user *)siaddr;				\
+	trace_hardirqs_fixup();						\
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
+							== NOTIFY_STOP)	\
+		return;							\
 	conditional_sti(regs);						\
-	do_trap(trapnr, signr, str, regs, error_code, &info); \
+	do_trap(trapnr, signr, str, regs, error_code, &info);		\
 }
 
-DO_ERROR_INFO( 0, SIGFPE,  "divide error", divide_error, FPE_INTDIV, regs->ip)
-DO_ERROR( 4, SIGSEGV, "overflow", overflow)
-DO_ERROR( 5, SIGSEGV, "bounds", bounds)
-DO_ERROR_INFO( 6, SIGILL,  "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
-DO_ERROR( 9, SIGFPE,  "coprocessor segment overrun", coprocessor_segment_overrun)
+DO_ERROR_INFO(0, SIGFPE, "divide error", divide_error, FPE_INTDIV, regs->ip)
+DO_ERROR(4, SIGSEGV, "overflow", overflow)
+DO_ERROR(5, SIGSEGV, "bounds", bounds)
+DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
+DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
-DO_ERROR(11, SIGBUS,  "segment not present", segment_not_present)
+DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
 
 /* Runs on IST stack */
@@ -780,14 +776,14 @@ asmlinkage void __kprobes do_general_protection(struct pt_regs * regs,
 }
 
 static notrace __kprobes void
-mem_parity_error(unsigned char reason, struct pt_regs * regs)
+mem_parity_error(unsigned char reason, struct pt_regs *regs)
 {
 	printk(KERN_EMERG "Uhhuh. NMI received for unknown reason %02x.\n",
 		reason);
 	printk(KERN_EMERG "You have some hardware problem, likely on the PCI bus.\n");
 
 #if defined(CONFIG_EDAC)
-	if(edac_handler_set()) {
+	if (edac_handler_set()) {
 		edac_atomic_assert_error();
 		return;
 	}
@@ -804,7 +800,7 @@ mem_parity_error(unsigned char reason, struct pt_regs * regs)
 }
 
 static notrace __kprobes void
-io_check_error(unsigned char reason, struct pt_regs * regs)
+io_check_error(unsigned char reason, struct pt_regs *regs)
 {
 	printk("NMI: IOCK error (debug interrupt?)\n");
 	show_registers(regs);
@@ -841,7 +837,7 @@ asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
 
 	cpu = smp_processor_id();
 
-	/* Only the BSP gets external NMIs from the system.  */
+	/* Only the BSP gets external NMIs from the system. */
 	if (!cpu)
 		reason = get_nmi_reason();
 
@@ -853,18 +849,17 @@ asmlinkage notrace  __kprobes void default_do_nmi(struct pt_regs *regs)
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
 		 */
-		if (nmi_watchdog_tick(regs,reason))
+		if (nmi_watchdog_tick(regs, reason))
 			return;
-		if (!do_nmi_callback(regs,cpu))
+		if (!do_nmi_callback(regs, cpu))
 			unknown_nmi_error(reason, regs);
 
 		return;
 	}
 	if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == NOTIFY_STOP)
-		return; 
+		return;
 
 	/* AK: following checks seem to be broken on modern chipsets. FIXME */
-
 	if (reason & 0x80)
 		mem_parity_error(reason, regs);
 	if (reason & 0x40)
@@ -875,9 +870,12 @@ asmlinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
+
 	add_pda(__nmi_count, 1);
+
 	if (!ignore_nmis)
 		default_do_nmi(regs);
+
 	nmi_exit();
 }
 
@@ -894,13 +892,14 @@ void restart_nmi(void)
 }
 
 /* runs on IST stack. */
-asmlinkage void __kprobes do_int3(struct pt_regs * regs, long error_code)
+asmlinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	trace_hardirqs_fixup();
 
-	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP) == NOTIFY_STOP) {
+	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
+			== NOTIFY_STOP)
 		return;
-	}
+
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
@@ -961,21 +960,19 @@ asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 
 	/* Mask out spurious debug traps due to lazy DR7 setting */
 	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
-		if (!tsk->thread.debugreg7) { 
+		if (!tsk->thread.debugreg7)
 			goto clear_dr7;
-		}
 	}
 
 	tsk->thread.debugreg6 = condition;
 
-
 	/*
 	 * Single-stepping through TF: make sure we ignore any events in
 	 * kernel space (but re-enable TF when returning to user mode).
 	 */
 	if (condition & DR_STEP) {
-                if (!user_mode(regs))
-                       goto clear_TF_reenable;
+		if (!user_mode(regs))
+			goto clear_TF_reenable;
 	}
 
 	/* Ok, finally something we can handle */
@@ -988,7 +985,7 @@ asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 	force_sig_info(SIGTRAP, &info, tsk);
 
 clear_dr7:
-	set_debugreg(0UL, 7);
+	set_debugreg(0, 7);
 	preempt_conditional_cli(regs);
 	return;
 
@@ -996,6 +993,7 @@ clear_TF_reenable:
 	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
 	regs->flags &= ~X86_EFLAGS_TF;
 	preempt_conditional_cli(regs);
+	return;
 }
 
 static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
@@ -1018,7 +1016,7 @@ static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
 asmlinkage void do_coprocessor_error(struct pt_regs *regs)
 {
 	void __user *ip = (void __user *)(regs->ip);
-	struct task_struct * task;
+	struct task_struct *task;
 	siginfo_t info;
 	unsigned short cwd, swd;
 
@@ -1051,30 +1049,30 @@ asmlinkage void do_coprocessor_error(struct pt_regs *regs)
 	cwd = get_fpu_cwd(task);
 	swd = get_fpu_swd(task);
 	switch (swd & ~cwd & 0x3f) {
-		case 0x000:
-		default:
-			break;
-		case 0x001: /* Invalid Op */
-			/*
-			 * swd & 0x240 == 0x040: Stack Underflow
-			 * swd & 0x240 == 0x240: Stack Overflow
-			 * User must clear the SF bit (0x40) if set
-			 */
-			info.si_code = FPE_FLTINV;
-			break;
-		case 0x002: /* Denormalize */
-		case 0x010: /* Underflow */
-			info.si_code = FPE_FLTUND;
-			break;
-		case 0x004: /* Zero Divide */
-			info.si_code = FPE_FLTDIV;
-			break;
-		case 0x008: /* Overflow */
-			info.si_code = FPE_FLTOVF;
-			break;
-		case 0x020: /* Precision */
-			info.si_code = FPE_FLTRES;
-			break;
+	case 0x000: /* No unmasked exception */
+	default: /* Multiple exceptions */
+		break;
+	case 0x001: /* Invalid Op */
+		/*
+		 * swd & 0x240 == 0x040: Stack Underflow
+		 * swd & 0x240 == 0x240: Stack Overflow
+		 * User must clear the SF bit (0x40) if set
+		 */
+		info.si_code = FPE_FLTINV;
+		break;
+	case 0x002: /* Denormalize */
+	case 0x010: /* Underflow */
+		info.si_code = FPE_FLTUND;
+		break;
+	case 0x004: /* Zero Divide */
+		info.si_code = FPE_FLTDIV;
+		break;
+	case 0x008: /* Overflow */
+		info.si_code = FPE_FLTOVF;
+		break;
+	case 0x020: /* Precision */
+		info.si_code = FPE_FLTRES;
+		break;
 	}
 	force_sig_info(SIGFPE, &info, task);
 }
@@ -1087,7 +1085,7 @@ asmlinkage void bad_intr(void)
 asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
 {
 	void __user *ip = (void __user *)(regs->ip);
-	struct task_struct * task;
+	struct task_struct *task;
 	siginfo_t info;
 	unsigned short mxcsr;
 
@@ -1115,25 +1113,25 @@ asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs)
 	 */
 	mxcsr = get_fpu_mxcsr(task);
 	switch (~((mxcsr & 0x1f80) >> 7) & (mxcsr & 0x3f)) {
-		case 0x000:
-		default:
-			break;
-		case 0x001: /* Invalid Op */
-			info.si_code = FPE_FLTINV;
-			break;
-		case 0x002: /* Denormalize */
-		case 0x010: /* Underflow */
-			info.si_code = FPE_FLTUND;
-			break;
-		case 0x004: /* Zero Divide */
-			info.si_code = FPE_FLTDIV;
-			break;
-		case 0x008: /* Overflow */
-			info.si_code = FPE_FLTOVF;
-			break;
-		case 0x020: /* Precision */
-			info.si_code = FPE_FLTRES;
-			break;
+	case 0x000:
+	default:
+		break;
+	case 0x001: /* Invalid Op */
+		info.si_code = FPE_FLTINV;
+		break;
+	case 0x002: /* Denormalize */
+	case 0x010: /* Underflow */
+		info.si_code = FPE_FLTUND;
+		break;
+	case 0x004: /* Zero Divide */
+		info.si_code = FPE_FLTDIV;
+		break;
+	case 0x008: /* Overflow */
+		info.si_code = FPE_FLTOVF;
+		break;
+	case 0x020: /* Precision */
+		info.si_code = FPE_FLTRES;
+		break;
 	}
 	force_sig_info(SIGFPE, &info, task);
 }
@@ -1151,7 +1149,7 @@ asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
 }
 
 /*
- *  'math_state_restore()' saves the current math information in the
+ * 'math_state_restore()' saves the current math information in the
  * old math state array, and gets the new ones from the current task
  *
  * Careful.. There are problems with IBM-designed IRQ13 behaviour.
@@ -1176,7 +1174,7 @@ asmlinkage void math_state_restore(void)
 		local_irq_disable();
 	}
 
-	clts();			/* Allow maths ops (or we recurse) */
+	clts();				/* Allow maths ops (or we recurse) */
 	restore_fpu_checking(&me->thread.xstate->fxsave);
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
@@ -1185,64 +1183,61 @@ EXPORT_SYMBOL_GPL(math_state_restore);
 
 void __init trap_init(void)
 {
-	set_intr_gate(0,&divide_error);
-	set_intr_gate_ist(1,&debug,DEBUG_STACK);
-	set_intr_gate_ist(2,&nmi,NMI_STACK);
- 	set_system_gate_ist(3,&int3,DEBUG_STACK); /* int3 can be called from all */
-	set_system_gate(4,&overflow);	/* int4 can be called from all */
-	set_intr_gate(5,&bounds);
-	set_intr_gate(6,&invalid_op);
-	set_intr_gate(7,&device_not_available);
-	set_intr_gate_ist(8,&double_fault, DOUBLEFAULT_STACK);
-	set_intr_gate(9,&coprocessor_segment_overrun);
-	set_intr_gate(10,&invalid_TSS);
-	set_intr_gate(11,&segment_not_present);
-	set_intr_gate_ist(12,&stack_segment,STACKFAULT_STACK);
-	set_intr_gate(13,&general_protection);
-	set_intr_gate(14,&page_fault);
-	set_intr_gate(15,&spurious_interrupt_bug);
-	set_intr_gate(16,&coprocessor_error);
-	set_intr_gate(17,&alignment_check);
+	set_intr_gate(0, &divide_error);
+	set_intr_gate_ist(1, &debug, DEBUG_STACK);
+	set_intr_gate_ist(2, &nmi, NMI_STACK);
+ 	set_system_gate_ist(3, &int3, DEBUG_STACK); /* int3 can be called from all */
+	set_system_gate(4, &overflow); /* int4 can be called from all */
+	set_intr_gate(5, &bounds);
+	set_intr_gate(6, &invalid_op);
+	set_intr_gate(7, &device_not_available);
+	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+	set_intr_gate(9, &coprocessor_segment_overrun);
+	set_intr_gate(10, &invalid_TSS);
+	set_intr_gate(11, &segment_not_present);
+	set_intr_gate_ist(12, &stack_segment, STACKFAULT_STACK);
+	set_intr_gate(13, &general_protection);
+	set_intr_gate(14, &page_fault);
+	set_intr_gate(15, &spurious_interrupt_bug);
+	set_intr_gate(16, &coprocessor_error);
+	set_intr_gate(17, &alignment_check);
 #ifdef CONFIG_X86_MCE
-	set_intr_gate_ist(18,&machine_check, MCE_STACK); 
+	set_intr_gate_ist(18, &machine_check, MCE_STACK);
 #endif
-	set_intr_gate(19,&simd_coprocessor_error);
+	set_intr_gate(19, &simd_coprocessor_error);
 
 #ifdef CONFIG_IA32_EMULATION
 	set_system_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
 #endif
-       
 	/*
 	 * initialize the per thread extended state:
 	 */
         init_thread_xstate();
 	/*
-	 * Should be a barrier for any external CPU state.
+	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
 }
 
-
 static int __init oops_setup(char *s)
-{ 
+{
 	if (!s)
 		return -EINVAL;
 	if (!strcmp(s, "panic"))
 		panic_on_oops = 1;
 	return 0;
-} 
+}
 early_param("oops", oops_setup);
 
 static int __init kstack_setup(char *s)
 {
 	if (!s)
 		return -EINVAL;
-	kstack_depth_to_print = simple_strtoul(s,NULL,0);
+	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
 	return 0;
 }
 early_param("kstack", kstack_setup);
 
-
 static int __init code_bytes_setup(char *s)
 {
 	code_bytes = simple_strtoul(s, NULL, 0);
-- 
1.5.4.3

