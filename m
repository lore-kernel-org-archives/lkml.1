Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYJCUhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYJCUhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYJCUhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:37:13 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:7978 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYJCUhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:37:09 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 8/9] traps: x86: make traps_32.c and traps_64.c equal
Date: Fri,  3 Oct 2008 22:00:39 +0200
Message-Id: <1223064040-23170-9-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223064040-23170-8-git-send-email-heukelum@fastmail.fm>
References: <1223064040-23170-1-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-2-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-3-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-4-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-5-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-6-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-7-git-send-email-heukelum@fastmail.fm>
 <1223064040-23170-8-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Fri, 03 Oct 2008 22:36:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.242; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CONFIG_X86_64/CONFIG_X86_32 to condtionally compile the
parts needed for x86_64 or i386 only.

Runs a small userspace for a number of minimal configurations
and boots the defconfigs.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |  172 ++++++++++++++++++++-
 arch/x86/kernel/traps_64.c |  367 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 536 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index d994e92..54e08d2 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -59,6 +59,11 @@
 
 #include <mach_traps.h>
 
+#ifdef CONFIG_X86_64
+#include <asm/pgalloc.h>
+#include <asm/proto.h>
+#include <asm/pda.h>
+#else
 #include <asm/processor-flags.h>
 #include <asm/arch_hooks.h>
 #include <asm/nmi.h>
@@ -82,6 +87,7 @@ char ignore_fpu_irq;
  */
 gate_desc idt_table[256]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
+#endif
 
 static int ignore_nmis;
 
@@ -105,6 +111,7 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
+#ifdef CONFIG_X86_32
 static inline void
 die_if_kernel(const char *str, struct pt_regs *regs, long err)
 {
@@ -152,6 +159,7 @@ static int lazy_iobitmap_copy(void)
 
 	return 0;
 }
+#endif
 
 static void __kprobes
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
@@ -159,6 +167,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 {
 	struct task_struct *tsk = current;
 
+#ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK) {
 		/*
 		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
@@ -168,11 +177,14 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 			goto vm86_trap;
 		goto trap_signal;
 	}
+#endif
 
 	if (!user_mode(regs))
 		goto kernel_trap;
 
+#ifdef CONFIG_X86_32
 trap_signal:
+#endif
 	/*
 	 * We want error_code and trap_no set for userspace faults and
 	 * kernelspace faults which result in die(), but not
@@ -185,6 +197,18 @@ trap_signal:
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_no = trapnr;
 
+#ifdef CONFIG_X86_64
+	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
+	    printk_ratelimit()) {
+		printk(KERN_INFO
+		       "%s[%d] trap %s ip:%lx sp:%lx error:%lx",
+		       tsk->comm, tsk->pid, str,
+		       regs->ip, regs->sp, error_code);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
+#endif
+
 	if (info)
 		force_sig_info(signr, info, tsk);
 	else
@@ -199,11 +223,13 @@ kernel_trap:
 	}
 	return;
 
+#ifdef CONFIG_X86_32
 vm86_trap:
 	if (handle_vm86_trap((struct kernel_vm86_regs *) regs,
 						error_code, trapnr))
 		goto trap_signal;
 	return;
+#endif
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
@@ -238,9 +264,41 @@ DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
 DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+#ifdef CONFIG_X86_32
 DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
+#endif
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
 
+#ifdef CONFIG_X86_64
+/* Runs on IST stack */
+dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
+{
+	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
+			12, SIGBUS) == NOTIFY_STOP)
+		return;
+	preempt_conditional_sti(regs);
+	do_trap(12, SIGBUS, "stack segment", regs, error_code, NULL);
+	preempt_conditional_cli(regs);
+}
+
+dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
+{
+	static const char str[] = "double fault";
+	struct task_struct *tsk = current;
+
+	/* Return not checked because double check cannot be ignored */
+	notify_die(DIE_TRAP, str, regs, error_code, 8, SIGSEGV);
+
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = 8;
+
+	/* This is always a kernel trap and never fixable (and thus must
+	   never return). */
+	for (;;)
+		die(str, regs, error_code);
+}
+#endif
+
 dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
@@ -248,6 +306,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 
 	conditional_sti(regs);
 
+#ifdef CONFIG_X86_32
 	if (lazy_iobitmap_copy()) {
 		/* restart the faulting instruction */
 		return;
@@ -255,6 +314,7 @@ do_general_protection(struct pt_regs *regs, long error_code)
 
 	if (regs->flags & X86_VM_MASK)
 		goto gp_in_vm86;
+#endif
 
 	tsk = current;
 	if (!user_mode(regs))
@@ -276,10 +336,12 @@ do_general_protection(struct pt_regs *regs, long error_code)
 	force_sig(SIGSEGV, tsk);
 	return;
 
+#ifdef CONFIG_X86_32
 gp_in_vm86:
 	local_irq_enable();
 	handle_vm86_fault((struct kernel_vm86_regs *) regs, error_code);
 	return;
+#endif
 
 gp_in_kernel:
 	if (fixup_exception(regs))
@@ -367,6 +429,7 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
 
+#ifdef CONFIG_X86_32
 static DEFINE_SPINLOCK(nmi_print_lock);
 
 void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
@@ -401,6 +464,7 @@ void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
 
 	do_exit(SIGSEGV);
 }
+#endif
 
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
@@ -440,11 +504,13 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		mem_parity_error(reason, regs);
 	if (reason & 0x40)
 		io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
 	/*
 	 * Reassert NMI in case it became active meanwhile
 	 * as it's edge-triggered:
 	 */
 	reassert_nmi();
+#endif
 }
 
 dotraplinkage notrace __kprobes void
@@ -452,7 +518,11 @@ do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
 
+#ifdef CONFIG_X86_32
 	{ int cpu; cpu = smp_processor_id(); ++nmi_count(cpu); }
+#else
+	add_pda(__nmi_count, 1);
+#endif
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
@@ -490,6 +560,29 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 	preempt_conditional_cli(regs);
 }
 
+#ifdef CONFIG_X86_64
+/* Help handler running on IST stack to switch back to user stack
+   for scheduling or signal handling. The actual stack switch is done in
+   entry.S */
+asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
+{
+	struct pt_regs *regs = eregs;
+	/* Did already sync */
+	if (eregs == (struct pt_regs *)eregs->sp)
+		;
+	/* Exception from user space */
+	else if (user_mode(eregs))
+		regs = task_pt_regs(current);
+	/* Exception from kernel and interrupts are enabled. Move to
+	   kernel process stack. */
+	else if (eregs->flags & X86_EFLAGS_IF)
+		regs = (struct pt_regs *)(eregs->sp -= sizeof(struct pt_regs));
+	if (eregs != regs)
+		*regs = *eregs;
+	return regs;
+}
+#endif
+
 /*
  * Our handling of the processor debug registers is non-trivial.
  * We do not clear them on entry and exit from the kernel. Therefore
@@ -545,8 +638,10 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 			goto clear_dr7;
 	}
 
+#ifdef CONFIG_X86_32
 	if (regs->flags & X86_VM_MASK)
 		goto debug_vm86;
+#endif
 
 	/* Save debug status register where ptrace can see it */
 	tsk->thread.debugreg6 = condition;
@@ -573,10 +668,12 @@ clear_dr7:
 	preempt_conditional_cli(regs);
 	return;
 
+#ifdef CONFIG_X86_32
 debug_vm86:
 	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
 	preempt_conditional_cli(regs);
 	return;
+#endif
 
 clear_TF_reenable:
 	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
@@ -585,6 +682,20 @@ clear_TF_reenable:
 	return;
 }
 
+#ifdef CONFIG_X86_64
+static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
+{
+	if (fixup_exception(regs))
+		return 1;
+
+	notify_die(DIE_GPF, str, regs, 0, trapnr, SIGFPE);
+	/* Illegal floating point operation in the kernel */
+	current->thread.trap_no = trapnr;
+	die(str, regs, 0);
+	return 0;
+}
+#endif
+
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
  * the correct behaviour even in the presence of the asynchronous
@@ -621,7 +732,9 @@ void math_error(void __user *ip)
 	swd = get_fpu_swd(task);
 	switch (swd & ~cwd & 0x3f) {
 	case 0x000: /* No unmasked exception */
+#ifdef CONFIG_X86_32
 		return;
+#endif
 	default: /* Multiple exceptions */
 		break;
 	case 0x001: /* Invalid Op */
@@ -652,7 +765,15 @@ void math_error(void __user *ip)
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
+
+#ifdef CONFIG_X86_32
 	ignore_fpu_irq = 1;
+#else
+	if (!user_mode(regs) &&
+	    kernel_math_error(regs, "kernel x87 math error", 16))
+		return;
+#endif
+
 	math_error((void __user *)regs->ip);
 }
 
@@ -709,6 +830,7 @@ do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
 
+#ifdef CONFIG_X86_32
 	if (cpu_has_xmm) {
 		/* Handle SIMD FPU exceptions on PIII+ processors. */
 		ignore_fpu_irq = 1;
@@ -727,6 +849,12 @@ do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 	current->thread.error_code = error_code;
 	die_if_kernel("cache flush denied", regs, error_code);
 	force_sig(SIGSEGV, current);
+#else
+	if (!user_mode(regs) &&
+			kernel_math_error(regs, "kernel simd math error", 19))
+		return;
+	simd_math_error((void __user *)regs->ip);
+#endif
 }
 
 dotraplinkage void
@@ -739,6 +867,7 @@ do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 #endif
 }
 
+#ifdef CONFIG_X86_32
 unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 {
 	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
@@ -757,6 +886,15 @@ unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
 
 	return new_kesp;
 }
+#else
+asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
+{
+}
+
+asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
+{
+}
+#endif
 
 /*
  * 'math_state_restore()' saves the current math information in the
@@ -789,14 +927,24 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
+#ifdef CONFIG_X86_32
 	restore_fpu(tsk);
+#else
+	/*
+	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
+	 */
+	if (unlikely(restore_fpu_checking(tsk))) {
+		stts();
+		force_sig(SIGSEGV, tsk);
+		return;
+	}
+#endif
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
 #ifndef CONFIG_MATH_EMULATION
-
 asmlinkage void math_emulate(long arg)
 {
 	printk(KERN_EMERG
@@ -805,12 +953,12 @@ asmlinkage void math_emulate(long arg)
 	force_sig(SIGFPE, current);
 	schedule();
 }
-
 #endif /* CONFIG_MATH_EMULATION */
 
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error)
 {
+#ifdef CONFIG_X86_32
 	if (read_cr0() & X86_CR0_EM) {
 		conditional_sti(regs);
 		math_emulate(0);
@@ -818,8 +966,12 @@ do_device_not_available(struct pt_regs *regs, long error)
 		math_state_restore(); /* interrupts still off */
 		conditional_sti(regs);
 	}
+#else
+	math_state_restore();
+#endif
 }
 
+#ifdef CONFIG_X86_32
 #ifdef CONFIG_X86_MCE
 dotraplinkage void __kprobes do_machine_check(struct pt_regs *regs, long error)
 {
@@ -842,10 +994,13 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 		return;
 	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
 }
+#endif
 
 void __init trap_init(void)
 {
+#ifdef CONFIG_X86_32
 	int i;
+#endif
 
 #ifdef CONFIG_EISA
 	void __iomem *p = early_ioremap(0x0FFFD9, 4);
@@ -865,7 +1020,11 @@ void __init trap_init(void)
 	set_intr_gate(5, &bounds);
 	set_intr_gate(6, &invalid_op);
 	set_intr_gate(7, &device_not_available);
+#ifdef CONFIG_X86_32
 	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
+#else
+	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+#endif
 	set_intr_gate(9, &coprocessor_segment_overrun);
 	set_intr_gate(10, &invalid_TSS);
 	set_intr_gate(11, &segment_not_present);
@@ -880,6 +1039,11 @@ void __init trap_init(void)
 #endif
 	set_intr_gate(19, &simd_coprocessor_error);
 
+#ifdef CONFIG_IA32_EMULATION
+	set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
+#endif
+
+#ifdef CONFIG_X86_32
 	if (cpu_has_fxsr) {
 		printk(KERN_INFO "Enabling fast FPU save and restore... ");
 		set_in_cr4(X86_CR4_OSFXSR);
@@ -899,11 +1063,13 @@ void __init trap_init(void)
 		set_bit(i, used_vectors);
 
 	set_bit(SYSCALL_VECTOR, used_vectors);
-
+#endif
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
 
+#ifdef CONFIG_X86_32
 	trap_init_hook();
+#endif
 }
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 334a3df..54e08d2 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -33,6 +33,15 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 
+#ifdef CONFIG_EISA
+#include <linux/ioport.h>
+#include <linux/eisa.h>
+#endif
+
+#ifdef CONFIG_MCA
+#include <linux/mca.h>
+#endif
+
 #if defined(CONFIG_EDAC)
 #include <linux/edac.h>
 #endif
@@ -50,10 +59,35 @@
 
 #include <mach_traps.h>
 
+#ifdef CONFIG_X86_64
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pda.h>
+#else
+#include <asm/processor-flags.h>
+#include <asm/arch_hooks.h>
+#include <asm/nmi.h>
+#include <asm/smp.h>
+#include <asm/io.h>
+
+#include "cpu/mcheck/mce.h"
 
+DECLARE_BITMAP(used_vectors, NR_VECTORS);
+EXPORT_SYMBOL_GPL(used_vectors);
+
+asmlinkage int system_call(void);
+
+/* Do we ignore FPU interrupts ? */
+char ignore_fpu_irq;
+
+/*
+ * The IDT has to be page-aligned to simplify the Pentium
+ * F0 0F bug workaround.. We have a special link segment
+ * for this.
+ */
+gate_desc idt_table[256]
+	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
+#endif
 
 static int ignore_nmis;
 
@@ -77,15 +111,80 @@ static inline void preempt_conditional_cli(struct pt_regs *regs)
 	dec_preempt_count();
 }
 
+#ifdef CONFIG_X86_32
+static inline void
+die_if_kernel(const char *str, struct pt_regs *regs, long err)
+{
+	if (!user_mode_vm(regs))
+		die(str, regs, err);
+}
+
+/*
+ * Perform the lazy TSS's I/O bitmap copy. If the TSS has an
+ * invalid offset set (the LAZY one) and the faulting thread has
+ * a valid I/O bitmap pointer, we copy the I/O bitmap in the TSS,
+ * we set the offset field correctly and return 1.
+ */
+static int lazy_iobitmap_copy(void)
+{
+	struct thread_struct *thread;
+	struct tss_struct *tss;
+	int cpu;
+
+	cpu = get_cpu();
+	tss = &per_cpu(init_tss, cpu);
+	thread = &current->thread;
+
+	if (tss->x86_tss.io_bitmap_base == INVALID_IO_BITMAP_OFFSET_LAZY &&
+	    thread->io_bitmap_ptr) {
+		memcpy(tss->io_bitmap, thread->io_bitmap_ptr,
+		       thread->io_bitmap_max);
+		/*
+		 * If the previously set map was extending to higher ports
+		 * than the current one, pad extra space with 0xff (no access).
+		 */
+		if (thread->io_bitmap_max < tss->io_bitmap_max) {
+			memset((char *) tss->io_bitmap +
+				thread->io_bitmap_max, 0xff,
+				tss->io_bitmap_max - thread->io_bitmap_max);
+		}
+		tss->io_bitmap_max = thread->io_bitmap_max;
+		tss->x86_tss.io_bitmap_base = IO_BITMAP_OFFSET;
+		tss->io_bitmap_owner = thread;
+		put_cpu();
+
+		return 1;
+	}
+	put_cpu();
+
+	return 0;
+}
+#endif
+
 static void __kprobes
 do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	long error_code, siginfo_t *info)
 {
 	struct task_struct *tsk = current;
 
+#ifdef CONFIG_X86_32
+	if (regs->flags & X86_VM_MASK) {
+		/*
+		 * traps 0, 1, 3, 4, and 5 should be forwarded to vm86.
+		 * On nmi (interrupt 2), do_trap should not be called.
+		 */
+		if (trapnr < 6)
+			goto vm86_trap;
+		goto trap_signal;
+	}
+#endif
+
 	if (!user_mode(regs))
 		goto kernel_trap;
 
+#ifdef CONFIG_X86_32
+trap_signal:
+#endif
 	/*
 	 * We want error_code and trap_no set for userspace faults and
 	 * kernelspace faults which result in die(), but not
@@ -98,6 +197,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_no = trapnr;
 
+#ifdef CONFIG_X86_64
 	if (show_unhandled_signals && unhandled_signal(tsk, signr) &&
 	    printk_ratelimit()) {
 		printk(KERN_INFO
@@ -107,6 +207,7 @@ do_trap(int trapnr, int signr, char *str, struct pt_regs *regs,
 		print_vma_addr(" in ", regs->ip);
 		printk("\n");
 	}
+#endif
 
 	if (info)
 		force_sig_info(signr, info, tsk);
@@ -121,6 +222,14 @@ kernel_trap:
 		die(str, regs, error_code);
 	}
 	return;
+
+#ifdef CONFIG_X86_32
+vm86_trap:
+	if (handle_vm86_trap((struct kernel_vm86_regs *) regs,
+						error_code, trapnr))
+		goto trap_signal;
+	return;
+#endif
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
@@ -155,8 +264,12 @@ DO_ERROR_INFO(6, SIGILL, "invalid opcode", invalid_op, ILL_ILLOPN, regs->ip)
 DO_ERROR(9, SIGFPE, "coprocessor segment overrun", coprocessor_segment_overrun)
 DO_ERROR(10, SIGSEGV, "invalid TSS", invalid_TSS)
 DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
+#ifdef CONFIG_X86_32
+DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
+#endif
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
 
+#ifdef CONFIG_X86_64
 /* Runs on IST stack */
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
@@ -184,6 +297,7 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 	for (;;)
 		die(str, regs, error_code);
 }
+#endif
 
 dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
@@ -192,6 +306,16 @@ do_general_protection(struct pt_regs *regs, long error_code)
 
 	conditional_sti(regs);
 
+#ifdef CONFIG_X86_32
+	if (lazy_iobitmap_copy()) {
+		/* restart the faulting instruction */
+		return;
+	}
+
+	if (regs->flags & X86_VM_MASK)
+		goto gp_in_vm86;
+#endif
+
 	tsk = current;
 	if (!user_mode(regs))
 		goto gp_in_kernel;
@@ -212,6 +336,13 @@ do_general_protection(struct pt_regs *regs, long error_code)
 	force_sig(SIGSEGV, tsk);
 	return;
 
+#ifdef CONFIG_X86_32
+gp_in_vm86:
+	local_irq_enable();
+	handle_vm86_fault((struct kernel_vm86_regs *) regs, error_code);
+	return;
+#endif
+
 gp_in_kernel:
 	if (fixup_exception(regs))
 		return;
@@ -277,6 +408,16 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	if (notify_die(DIE_NMIUNKNOWN, "nmi", regs, reason, 2, SIGINT) ==
 			NOTIFY_STOP)
 		return;
+#ifdef CONFIG_MCA
+	/*
+	 * Might actually be able to figure out what the guilty party
+	 * is:
+	 */
+	if (MCA_bus) {
+		mca_handle_nmi();
+		return;
+	}
+#endif
 	printk(KERN_EMERG
 		"Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
 			reason, smp_processor_id());
@@ -288,6 +429,43 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "Dazed and confused, but trying to continue\n");
 }
 
+#ifdef CONFIG_X86_32
+static DEFINE_SPINLOCK(nmi_print_lock);
+
+void notrace __kprobes die_nmi(char *str, struct pt_regs *regs, int do_panic)
+{
+	if (notify_die(DIE_NMIWATCHDOG, str, regs, 0, 2, SIGINT) == NOTIFY_STOP)
+		return;
+
+	spin_lock(&nmi_print_lock);
+	/*
+	* We are in trouble anyway, lets at least try
+	* to get a message out:
+	*/
+	bust_spinlocks(1);
+	printk(KERN_EMERG "%s", str);
+	printk(" on CPU%d, ip %08lx, registers:\n",
+		smp_processor_id(), regs->ip);
+	show_registers(regs);
+	if (do_panic)
+		panic("Non maskable interrupt");
+	console_silent();
+	spin_unlock(&nmi_print_lock);
+	bust_spinlocks(0);
+
+	/*
+	 * If we are in kernel we are probably nested up pretty bad
+	 * and might aswell get out now while we still can:
+	 */
+	if (!user_mode_vm(regs)) {
+		current->thread.trap_no = 2;
+		crash_kexec(regs);
+	}
+
+	do_exit(SIGSEGV);
+}
+#endif
+
 static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 {
 	unsigned char reason = 0;
@@ -303,6 +481,7 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		if (notify_die(DIE_NMI_IPI, "nmi_ipi", regs, reason, 2, SIGINT)
 								== NOTIFY_STOP)
 			return;
+#ifdef CONFIG_X86_LOCAL_APIC
 		/*
 		 * Ok, so this is none of the documented NMI sources,
 		 * so it must be the NMI watchdog.
@@ -311,6 +490,9 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 			return;
 		if (!do_nmi_callback(regs, cpu))
 			unknown_nmi_error(reason, regs);
+#else
+		unknown_nmi_error(reason, regs);
+#endif
 
 		return;
 	}
@@ -322,6 +504,13 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		mem_parity_error(reason, regs);
 	if (reason & 0x40)
 		io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
+	/*
+	 * Reassert NMI in case it became active meanwhile
+	 * as it's edge-triggered:
+	 */
+	reassert_nmi();
+#endif
 }
 
 dotraplinkage notrace __kprobes void
@@ -329,7 +518,11 @@ do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
 
+#ifdef CONFIG_X86_32
+	{ int cpu; cpu = smp_processor_id(); ++nmi_count(cpu); }
+#else
 	add_pda(__nmi_count, 1);
+#endif
 
 	if (!ignore_nmis)
 		default_do_nmi(regs);
@@ -352,15 +545,22 @@ void restart_nmi(void)
 /* May run on IST stack. */
 dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
+#ifdef CONFIG_KPROBES
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
+#else
+	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
+			== NOTIFY_STOP)
+		return;
+#endif
 
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
 }
 
+#ifdef CONFIG_X86_64
 /* Help handler running on IST stack to switch back to user stack
    for scheduling or signal handling. The actual stack switch is done in
    entry.S */
@@ -381,6 +581,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 		*regs = *eregs;
 	return regs;
 }
+#endif
 
 /*
  * Our handling of the processor debug registers is non-trivial.
@@ -437,6 +638,11 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 			goto clear_dr7;
 	}
 
+#ifdef CONFIG_X86_32
+	if (regs->flags & X86_VM_MASK)
+		goto debug_vm86;
+#endif
+
 	/* Save debug status register where ptrace can see it */
 	tsk->thread.debugreg6 = condition;
 
@@ -462,6 +668,13 @@ clear_dr7:
 	preempt_conditional_cli(regs);
 	return;
 
+#ifdef CONFIG_X86_32
+debug_vm86:
+	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
+	preempt_conditional_cli(regs);
+	return;
+#endif
+
 clear_TF_reenable:
 	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
 	regs->flags &= ~X86_EFLAGS_TF;
@@ -469,6 +682,7 @@ clear_TF_reenable:
 	return;
 }
 
+#ifdef CONFIG_X86_64
 static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
 {
 	if (fixup_exception(regs))
@@ -480,6 +694,7 @@ static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
 	die(str, regs, 0);
 	return 0;
 }
+#endif
 
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
@@ -517,6 +732,9 @@ void math_error(void __user *ip)
 	swd = get_fpu_swd(task);
 	switch (swd & ~cwd & 0x3f) {
 	case 0x000: /* No unmasked exception */
+#ifdef CONFIG_X86_32
+		return;
+#endif
 	default: /* Multiple exceptions */
 		break;
 	case 0x001: /* Invalid Op */
@@ -547,9 +765,15 @@ void math_error(void __user *ip)
 dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
+
+#ifdef CONFIG_X86_32
+	ignore_fpu_irq = 1;
+#else
 	if (!user_mode(regs) &&
 	    kernel_math_error(regs, "kernel x87 math error", 16))
 		return;
+#endif
+
 	math_error((void __user *)regs->ip);
 }
 
@@ -605,17 +829,64 @@ dotraplinkage void
 do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
+
+#ifdef CONFIG_X86_32
+	if (cpu_has_xmm) {
+		/* Handle SIMD FPU exceptions on PIII+ processors. */
+		ignore_fpu_irq = 1;
+		simd_math_error((void __user *)regs->ip);
+		return;
+	}
+	/*
+	 * Handle strange cache flush from user space exception
+	 * in all other cases.  This is undocumented behaviour.
+	 */
+	if (regs->flags & X86_VM_MASK) {
+		handle_vm86_fault((struct kernel_vm86_regs *)regs, error_code);
+		return;
+	}
+	current->thread.trap_no = 19;
+	current->thread.error_code = error_code;
+	die_if_kernel("cache flush denied", regs, error_code);
+	force_sig(SIGSEGV, current);
+#else
 	if (!user_mode(regs) &&
 			kernel_math_error(regs, "kernel simd math error", 19))
 		return;
 	simd_math_error((void __user *)regs->ip);
+#endif
 }
 
 dotraplinkage void
 do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 {
+	conditional_sti(regs);
+#if 0
+	/* No need to warn about this any longer. */
+	printk(KERN_INFO "Ignoring P6 Local APIC Spurious Interrupt Bug...\n");
+#endif
 }
 
+#ifdef CONFIG_X86_32
+unsigned long patch_espfix_desc(unsigned long uesp, unsigned long kesp)
+{
+	struct desc_struct *gdt = get_cpu_gdt_table(smp_processor_id());
+	unsigned long base = (kesp - uesp) & -THREAD_SIZE;
+	unsigned long new_kesp = kesp - base;
+	unsigned long lim_pages = (new_kesp | (THREAD_SIZE - 1)) >> PAGE_SHIFT;
+	__u64 desc = *(__u64 *)&gdt[GDT_ENTRY_ESPFIX_SS];
+
+	/* Set up base for espfix segment */
+	desc &= 0x00f0ff0000000000ULL;
+	desc |=	((((__u64)base) << 16) & 0x000000ffffff0000ULL) |
+		((((__u64)base) << 32) & 0xff00000000000000ULL) |
+		((((__u64)lim_pages) << 32) & 0x000f000000000000ULL) |
+		(lim_pages & 0xffff);
+	*(__u64 *)&gdt[GDT_ENTRY_ESPFIX_SS] = desc;
+
+	return new_kesp;
+}
+#else
 asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
 {
 }
@@ -623,6 +894,7 @@ asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
 asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
 {
 }
+#endif
 
 /*
  * 'math_state_restore()' saves the current math information in the
@@ -630,6 +902,9 @@ asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
  *
  * Careful.. There are problems with IBM-designed IRQ13 behaviour.
  * Don't touch unless you *really* know how it works.
+ *
+ * Must be called with kernel preemption disabled (in this case,
+ * local interrupts are disabled at the call-site in entry.S).
  */
 asmlinkage void math_state_restore(void)
 {
@@ -652,6 +927,9 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
+#ifdef CONFIG_X86_32
+	restore_fpu(tsk);
+#else
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
@@ -660,19 +938,78 @@ asmlinkage void math_state_restore(void)
 		force_sig(SIGSEGV, tsk);
 		return;
 	}
+#endif
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
+#ifndef CONFIG_MATH_EMULATION
+asmlinkage void math_emulate(long arg)
+{
+	printk(KERN_EMERG
+		"math-emulation not enabled and no coprocessor found.\n");
+	printk(KERN_EMERG "killing %s.\n", current->comm);
+	force_sig(SIGFPE, current);
+	schedule();
+}
+#endif /* CONFIG_MATH_EMULATION */
+
 dotraplinkage void __kprobes
 do_device_not_available(struct pt_regs *regs, long error)
 {
+#ifdef CONFIG_X86_32
+	if (read_cr0() & X86_CR0_EM) {
+		conditional_sti(regs);
+		math_emulate(0);
+	} else {
+		math_state_restore(); /* interrupts still off */
+		conditional_sti(regs);
+	}
+#else
 	math_state_restore();
+#endif
+}
+
+#ifdef CONFIG_X86_32
+#ifdef CONFIG_X86_MCE
+dotraplinkage void __kprobes do_machine_check(struct pt_regs *regs, long error)
+{
+	conditional_sti(regs);
+	machine_check_vector(regs, error);
 }
+#endif
+
+dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
+{
+	siginfo_t info;
+	local_irq_enable();
+
+	info.si_signo = SIGILL;
+	info.si_errno = 0;
+	info.si_code = ILL_BADSTK;
+	info.si_addr = 0;
+	if (notify_die(DIE_TRAP, "iret exception",
+			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
+		return;
+	do_trap(32, SIGILL, "iret exception", regs, error_code, &info);
+}
+#endif
 
 void __init trap_init(void)
 {
+#ifdef CONFIG_X86_32
+	int i;
+#endif
+
+#ifdef CONFIG_EISA
+	void __iomem *p = early_ioremap(0x0FFFD9, 4);
+
+	if (readl(p) == 'E' + ('I'<<8) + ('S'<<16) + ('A'<<24))
+		EISA_bus = 1;
+	early_iounmap(p, 4);
+#endif
+
 	set_intr_gate(0, &divide_error);
 	set_intr_gate_ist(1, &debug, DEBUG_STACK);
 	set_intr_gate_ist(2, &nmi, NMI_STACK);
@@ -683,7 +1020,11 @@ void __init trap_init(void)
 	set_intr_gate(5, &bounds);
 	set_intr_gate(6, &invalid_op);
 	set_intr_gate(7, &device_not_available);
+#ifdef CONFIG_X86_32
+	set_task_gate(8, GDT_ENTRY_DOUBLEFAULT_TSS);
+#else
 	set_intr_gate_ist(8, &double_fault, DOUBLEFAULT_STACK);
+#endif
 	set_intr_gate(9, &coprocessor_segment_overrun);
 	set_intr_gate(10, &invalid_TSS);
 	set_intr_gate(11, &segment_not_present);
@@ -701,8 +1042,34 @@ void __init trap_init(void)
 #ifdef CONFIG_IA32_EMULATION
 	set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
 #endif
+
+#ifdef CONFIG_X86_32
+	if (cpu_has_fxsr) {
+		printk(KERN_INFO "Enabling fast FPU save and restore... ");
+		set_in_cr4(X86_CR4_OSFXSR);
+		printk("done.\n");
+	}
+	if (cpu_has_xmm) {
+		printk(KERN_INFO
+			"Enabling unmasked SIMD FPU exception support... ");
+		set_in_cr4(X86_CR4_OSXMMEXCPT);
+		printk("done.\n");
+	}
+
+	set_system_trap_gate(SYSCALL_VECTOR, &system_call);
+
+	/* Reserve all the builtin and the syscall vector: */
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
+		set_bit(i, used_vectors);
+
+	set_bit(SYSCALL_VECTOR, used_vectors);
+#endif
 	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
+
+#ifdef CONFIG_X86_32
+	trap_init_hook();
+#endif
 }
-- 
1.5.4.3

