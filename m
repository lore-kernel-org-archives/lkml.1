Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYJGLml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYJGLml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYJGLmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:42:32 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:34421 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753179AbYJGLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:42:31 -0400
Date: Tue, 7 Oct 2008 17:12:20 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Roland McGrath <roland@redhat.com>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: [RFC Patch 3/9] Modifying generic debug exception to use virtual
	debug registers
Message-ID: <20081007114220.GC25627@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081007113815.GA23523@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007113815.GA23523@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the breakpoint exception handler code to use the abstract
register names.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/traps_32.c |   67 ++++++++++++++++-----------------------------
 arch/x86/kernel/traps_64.c |   64 ++++++++++++++++++++----------------------
 2 files changed, 54 insertions(+), 77 deletions(-)

Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/traps_32.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/traps_32.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/traps_32.c
@@ -890,11 +890,12 @@ void __kprobes do_int3(struct pt_regs *r
 void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
-	unsigned int condition;
+	unsigned long dr6;
 
 	trace_hardirqs_fixup();
 
-	get_debugreg(condition, 6);
+	get_debugreg(dr6, 6);
+	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
 
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
@@ -902,60 +903,40 @@ void __kprobes do_debug(struct pt_regs *
 	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
 	tsk->thread.debugctlmsr = 0;
 
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
-						SIGTRAP) == NOTIFY_STOP)
+	/* Store the virtualized DR6 value */
+	tsk->thread.vdr6 = dr6;
+
+	if (notify_die(DIE_DEBUG, "debug", regs, dr6, error_code,
+			SIGTRAP) == NOTIFY_STOP)
 		return;
 	/* It's safe to allow irq's after DR6 has been saved */
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 
-	/* Mask out spurious debug traps due to lazy DR7 setting */
-	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
-		if (!tsk->thread.debugreg7)
-			goto clear_dr7;
+	if (regs->flags & X86_VM_MASK) {
+		handle_vm86_trap((struct kernel_vm86_regs *) regs,
+				error_code, 1);
+		return;
 	}
 
-	if (regs->flags & X86_VM_MASK)
-		goto debug_vm86;
-
-	/* Save debug status register where ptrace can see it */
-	tsk->thread.debugreg6 = condition;
-
 	/*
-	 * Single-stepping through TF: make sure we ignore any events in
-	 * kernel space (but re-enable TF when returning to user mode).
+	 * Single-stepping through system calls: ignore any exceptions in
+	 * kernel space, but re-enable TF when returning to user mode.
+	 *
+	 * We already checked v86 mode above, so we can check for kernel mode
+	 * by just checking the CPL of CS.
 	 */
-	if (condition & DR_STEP) {
-		/*
-		 * We already checked v86 mode above, so we can
-		 * check for kernel mode by just checking the CPL
-		 * of CS.
-		 */
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
+	if ((dr6 & DR_STEP) && !user_mode(regs)) {
+		tsk->thread.vdr6 &= ~DR_STEP;
+		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+		regs->flags &= ~X86_EFLAGS_TF;
 	}
 
-	/* Ok, finally something we can handle */
-	send_sigtrap(tsk, regs, error_code);
-
-	/*
-	 * Disable additional traps. They'll be re-enabled when
-	 * the signal is delivered.
-	 */
-clear_dr7:
-	set_debugreg(0, 7);
-	return;
-
-debug_vm86:
-	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
-	return;
-
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->flags &= ~X86_EFLAGS_TF;
-	return;
+	if (tsk->thread.vdr6 & (DR_STEP|DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
+		send_sigtrap(tsk, regs, error_code);
 }
 
+
 /*
  * Note that we play around with the 'TS' bit in an attempt to get
  * the correct behaviour even in the presence of the asynchronous
Index: linux-bkpt-lkml-27-rc9/arch/x86/kernel/traps_64.c
===================================================================
--- linux-bkpt-lkml-27-rc9.orig/arch/x86/kernel/traps_64.c
+++ linux-bkpt-lkml-27-rc9/arch/x86/kernel/traps_64.c
@@ -894,13 +894,14 @@ asmlinkage __kprobes struct pt_regs *syn
 asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 				   unsigned long error_code)
 {
+	unsigned long dr6;;
 	struct task_struct *tsk = current;
-	unsigned long condition;
 	siginfo_t info;
 
 	trace_hardirqs_fixup();
 
-	get_debugreg(condition, 6);
+	get_debugreg(dr6, 6);
+	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
 
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
@@ -908,48 +909,43 @@ asmlinkage void __kprobes do_debug(struc
 	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
 	tsk->thread.debugctlmsr = 0;
 
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
-						SIGTRAP) == NOTIFY_STOP)
+	/* Store the virtualized DR6 value */
+	tsk->thread.vdr6 = dr6;
+
+	if (notify_die(DIE_DEBUG, "debug", regs, dr6, error_code,
+			SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	preempt_conditional_sti(regs);
 
-	/* Mask out spurious debug traps due to lazy DR7 setting */
-	if (condition & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
-		if (!tsk->thread.debugreg7)
-			goto clear_dr7;
+	if (regs->flags & X86_VM_MASK) {
+		handle_vm86_trap((struct kernel_vm86_regs *) regs,
+				error_code, 1);
+		return;
 	}
 
-	tsk->thread.debugreg6 = condition;
-
 	/*
-	 * Single-stepping through TF: make sure we ignore any events in
-	 * kernel space (but re-enable TF when returning to user mode).
+	 * Single-stepping through system calls: ignore any exceptions in
+	 * kernel space, but re-enable TF when returning to user mode.
+	 *
+	 * We already checked v86 mode above, so we can check for kernel mode
+	 * by just checking the CPL of CS.
 	 */
-	if (condition & DR_STEP) {
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
+	if ((dr6 & DR_STEP) && !user_mode(regs)) {
+		tsk->thread.vdr6 &= ~DR_STEP;
+		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+		regs->flags &= ~X86_EFLAGS_TF;
 	}
 
-	/* Ok, finally something we can handle */
-	tsk->thread.trap_no = 1;
-	tsk->thread.error_code = error_code;
-	info.si_signo = SIGTRAP;
-	info.si_errno = 0;
-	info.si_code = TRAP_BRKPT;
-	info.si_addr = user_mode(regs) ? (void __user *)regs->ip : NULL;
-	force_sig_info(SIGTRAP, &info, tsk);
-
-clear_dr7:
-	set_debugreg(0, 7);
-	preempt_conditional_cli(regs);
-	return;
-
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->flags &= ~X86_EFLAGS_TF;
-	preempt_conditional_cli(regs);
-	return;
+	if (tsk->thread.vdr6 & (DR_STEP|DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)) {
+		tsk->thread.trap_no = 1;
+		tsk->thread.error_code = error_code;
+		info.si_signo = SIGTRAP;
+		info.si_errno = 0;
+		info.si_code = TRAP_BRKPT;
+		info.si_addr = user_mode(regs) ? (void __user *)regs->ip : NULL;
+		force_sig_info(SIGTRAP, &info, tsk);
+	}
 }
 
 static int kernel_math_error(struct pt_regs *regs, const char *str, int trapnr)
