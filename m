Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYI3Q5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYI3Q5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYI3Q5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:57:05 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:29160 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYI3Q5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:57:02 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH 3/4] traps: x86: introduce dotraplinkage
Date: Tue, 30 Sep 2008 18:41:36 +0200
Message-Id: <1222792897-5691-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1222792897-5691-3-git-send-email-heukelum@fastmail.fm>
References: <1222792897-5691-1-git-send-email-heukelum@fastmail.fm>
 <1222792897-5691-2-git-send-email-heukelum@fastmail.fm>
 <1222792897-5691-3-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Tue, 30 Sep 2008 18:56:51 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.231; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the exception handlers with "dotraplinkage" to hide the
calling convention differences between i386 and x86_64.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_64.S |    2 +-
 arch/x86/kernel/traps_32.c |   28 +++++++++-------
 arch/x86/kernel/traps_64.c |   31 +++++++++++-------
 include/asm-x86/traps.h    |   73 +++++++++++++++++++++----------------------
 4 files changed, 72 insertions(+), 62 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1924659..291dd21 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1266,7 +1266,7 @@ ENTRY(simd_coprocessor_error)
 END(simd_coprocessor_error)
 
 ENTRY(device_not_available)
-	zeroentry math_state_restore
+	zeroentry do_device_not_available
 END(device_not_available)
 
 	/* runs on exception stack */
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 78113d3..6ecc1b7 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -191,7 +191,7 @@ vm86_trap:
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
-void do_##name(struct pt_regs *regs, long error_code)			\
+dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
@@ -201,7 +201,7 @@ void do_##name(struct pt_regs *regs, long error_code)			\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
-void do_##name(struct pt_regs *regs, long error_code)			\
+dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
 	info.si_signo = signr;						\
@@ -225,7 +225,7 @@ DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
 DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
 
-void __kprobes
+dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
@@ -429,7 +429,8 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 	reassert_nmi();
 }
 
-notrace __kprobes void do_nmi(struct pt_regs *regs, long error_code)
+dotraplinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
 {
 	int cpu;
 
@@ -457,7 +458,7 @@ void restart_nmi(void)
 	acpi_nmi_enable();
 }
 
-void __kprobes do_int3(struct pt_regs *regs, long error_code)
+dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_KPROBES
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
@@ -495,7 +496,7 @@ void __kprobes do_int3(struct pt_regs *regs, long error_code)
  * find every occurrence of the TF bit that could be saved away even
  * by user code)
  */
-void __kprobes do_debug(struct pt_regs *regs, long error_code)
+dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	unsigned int condition;
@@ -632,7 +633,7 @@ void math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-void do_coprocessor_error(struct pt_regs *regs, long error_code)
+dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
 	ignore_fpu_irq = 1;
@@ -687,7 +688,8 @@ static void simd_math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
+dotraplinkage void
+do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
 
@@ -711,7 +713,8 @@ void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 	force_sig(SIGSEGV, current);
 }
 
-void do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
+dotraplinkage void
+do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
 #if 0
@@ -789,7 +792,8 @@ asmlinkage void math_emulate(long arg)
 
 #endif /* CONFIG_MATH_EMULATION */
 
-void __kprobes do_device_not_available(struct pt_regs *regs, long error)
+dotraplinkage void __kprobes
+do_device_not_available(struct pt_regs *regs, long error)
 {
 	if (read_cr0() & X86_CR0_EM) {
 		conditional_sti(regs);
@@ -801,14 +805,14 @@ void __kprobes do_device_not_available(struct pt_regs *regs, long error)
 }
 
 #ifdef CONFIG_X86_MCE
-void __kprobes do_machine_check(struct pt_regs *regs, long error)
+dotraplinkage void __kprobes do_machine_check(struct pt_regs *regs, long error)
 {
 	conditional_sti(regs);
 	machine_check_vector(regs, error);
 }
 #endif
 
-void do_iret_error(struct pt_regs *regs, long error_code)
+dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 {
 	siginfo_t info;
 	local_irq_enable();
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 201f98d..d4e02c1 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -126,7 +126,7 @@ kernel_trap:
 }
 
 #define DO_ERROR(trapnr, signr, str, name)				\
-asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
+dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr)	\
 							== NOTIFY_STOP)	\
@@ -136,7 +136,7 @@ asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
 }
 
 #define DO_ERROR_INFO(trapnr, signr, str, name, sicode, siaddr)		\
-asmlinkage void do_##name(struct pt_regs *regs, long error_code)	\
+dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 {									\
 	siginfo_t info;							\
 	info.si_signo = signr;						\
@@ -160,7 +160,7 @@ DO_ERROR(11, SIGBUS, "segment not present", segment_not_present)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0)
 
 /* Runs on IST stack */
-asmlinkage void do_stack_segment(struct pt_regs *regs, long error_code)
+dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
 			12, SIGBUS) == NOTIFY_STOP)
@@ -170,7 +170,7 @@ asmlinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 	preempt_conditional_cli(regs);
 }
 
-asmlinkage void do_double_fault(struct pt_regs *regs, long error_code)
+dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 {
 	static const char str[] = "double fault";
 	struct task_struct *tsk = current;
@@ -187,7 +187,7 @@ asmlinkage void do_double_fault(struct pt_regs *regs, long error_code)
 		die(str, regs, error_code);
 }
 
-asmlinkage void __kprobes
+dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk;
@@ -318,7 +318,7 @@ asmlinkage notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 		io_check_error(reason, regs);
 }
 
-asmlinkage notrace __kprobes void
+dotraplinkage notrace __kprobes void
 do_nmi(struct pt_regs *regs, long error_code)
 {
 	nmi_enter();
@@ -344,7 +344,7 @@ void restart_nmi(void)
 }
 
 /* runs on IST stack. */
-asmlinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
+dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 {
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
@@ -377,8 +377,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 }
 
 /* runs on IST stack. */
-asmlinkage void __kprobes do_debug(struct pt_regs *regs,
-				   unsigned long error_code)
+dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
 	unsigned long condition;
@@ -515,7 +514,7 @@ void math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-asmlinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
+dotraplinkage void do_coprocessor_error(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
 	if (!user_mode(regs) &&
@@ -577,7 +576,8 @@ static void simd_math_error(void __user *ip)
 	force_sig_info(SIGFPE, &info, task);
 }
 
-asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
+dotraplinkage void
+do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 {
 	conditional_sti(regs);
 	if (!user_mode(regs) &&
@@ -586,7 +586,8 @@ asmlinkage void do_simd_coprocessor_error(struct pt_regs *regs, long error_code)
 	simd_math_error((void __user *)regs->ip);
 }
 
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
+dotraplinkage void
+do_spurious_interrupt_bug(struct pt_regs *regs, long error_code)
 {
 }
 
@@ -638,6 +639,12 @@ asmlinkage void math_state_restore(void)
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
+dotraplinkage void __kprobes
+do_device_not_available(struct pt_regs *regs, long error)
+{
+	math_state_restore();
+}
+
 void __init trap_init(void)
 {
 	set_intr_gate(0, &divide_error);
diff --git a/include/asm-x86/traps.h b/include/asm-x86/traps.h
index c82c39c..6c3dc2c 100644
--- a/include/asm-x86/traps.h
+++ b/include/asm-x86/traps.h
@@ -3,7 +3,12 @@
 
 #include <asm/debugreg.h>
 
-/* Common in X86_32 and X86_64 */
+#ifdef CONFIG_X86_32
+#define dotraplinkage
+#else
+#define dotraplinkage asmlinkage
+#endif
+
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
 asmlinkage void nmi(void);
@@ -12,31 +17,47 @@ asmlinkage void overflow(void);
 asmlinkage void bounds(void);
 asmlinkage void invalid_op(void);
 asmlinkage void device_not_available(void);
+#ifdef CONFIG_X86_64
+asmlinkage void double_fault(void);
+#endif
 asmlinkage void coprocessor_segment_overrun(void);
 asmlinkage void invalid_TSS(void);
 asmlinkage void segment_not_present(void);
 asmlinkage void stack_segment(void);
 asmlinkage void general_protection(void);
 asmlinkage void page_fault(void);
+asmlinkage void spurious_interrupt_bug(void);
 asmlinkage void coprocessor_error(void);
-asmlinkage void simd_coprocessor_error(void);
 asmlinkage void alignment_check(void);
-asmlinkage void spurious_interrupt_bug(void);
 #ifdef CONFIG_X86_MCE
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
+asmlinkage void simd_coprocessor_error(void);
 
-void do_divide_error(struct pt_regs *, long);
-void do_overflow(struct pt_regs *, long);
-void do_bounds(struct pt_regs *, long);
-void do_coprocessor_segment_overrun(struct pt_regs *, long);
-void do_invalid_TSS(struct pt_regs *, long);
-void do_segment_not_present(struct pt_regs *, long);
-void do_stack_segment(struct pt_regs *, long);
-void do_alignment_check(struct pt_regs *, long);
-void do_invalid_op(struct pt_regs *, long);
-void do_general_protection(struct pt_regs *, long);
-void do_nmi(struct pt_regs *, long);
+dotraplinkage void do_divide_error(struct pt_regs *, long);
+dotraplinkage void do_debug(struct pt_regs *, long);
+dotraplinkage void do_nmi(struct pt_regs *, long);
+dotraplinkage void do_int3(struct pt_regs *, long);
+dotraplinkage void do_overflow(struct pt_regs *, long);
+dotraplinkage void do_bounds(struct pt_regs *, long);
+dotraplinkage void do_invalid_op(struct pt_regs *, long);
+dotraplinkage void do_device_not_available(struct pt_regs *, long);
+dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
+dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
+dotraplinkage void do_segment_not_present(struct pt_regs *, long);
+dotraplinkage void do_stack_segment(struct pt_regs *, long);
+dotraplinkage void do_general_protection(struct pt_regs *, long);
+dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
+dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
+dotraplinkage void do_coprocessor_error(struct pt_regs *, long);
+dotraplinkage void do_alignment_check(struct pt_regs *, long);
+#ifdef CONFIG_X86_MCE
+dotraplinkage void do_machine_check(struct pt_regs *, long);
+#endif
+dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
+#ifdef CONFIG_X86_32
+dotraplinkage void do_iret_error(struct pt_regs *, long);
+#endif
 
 static inline int get_si_code(unsigned long condition)
 {
@@ -52,31 +73,9 @@ extern int panic_on_unrecovered_nmi;
 extern int kstack_depth_to_print;
 
 #ifdef CONFIG_X86_32
-
-void do_iret_error(struct pt_regs *, long);
-void do_int3(struct pt_regs *, long);
-void do_debug(struct pt_regs *, long);
 void math_error(void __user *);
-void do_coprocessor_error(struct pt_regs *, long);
-void do_simd_coprocessor_error(struct pt_regs *, long);
-void do_spurious_interrupt_bug(struct pt_regs *, long);
 unsigned long patch_espfix_desc(unsigned long, unsigned long);
 asmlinkage void math_emulate(long);
+#endif
 
-void do_page_fault(struct pt_regs *regs, unsigned long error_code);
-
-#else /* CONFIG_X86_32 */
-
-asmlinkage void double_fault(void);
-
-asmlinkage void do_int3(struct pt_regs *, long);
-asmlinkage void do_stack_segment(struct pt_regs *, long);
-asmlinkage void do_debug(struct pt_regs *, unsigned long);
-asmlinkage void do_coprocessor_error(struct pt_regs *, long);
-asmlinkage void do_simd_coprocessor_error(struct pt_regs *, long);
-asmlinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
-
-asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long error_code);
-
-#endif /* CONFIG_X86_32 */
 #endif /* ASM_X86__TRAPS_H */
-- 
1.5.4.3

