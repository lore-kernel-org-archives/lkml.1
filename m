Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbZBMQ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbZBMQ2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbZBMQ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:28:11 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:46055 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261AbZBMQ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:28:10 -0500
Date: Fri, 13 Feb 2009 20:25:51 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, richardj_moore@uk.ibm.com,
       jason.wessel@windriver.com
Subject: [Patch 3/10] Modifying generic debug exception to use virtual
	debug registers
Message-ID: <20090213145551.GC32064@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090213145301.GA31546@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213145301.GA31546@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Modifying generic debug exception to use virtual debug registers

From: Alan Stern <stern@rowland.harvard.edu>

This patch modifies the breakpoint exception handler code to use the abstract
register names.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/traps.c |   66 +++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 42 deletions(-)

Index: linux-2.6-tip.hbkpt/arch/x86/kernel/traps.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/arch/x86/kernel/traps.c
+++ linux-2.6-tip.hbkpt/arch/x86/kernel/traps.c
@@ -570,10 +570,11 @@ asmlinkage __kprobes struct pt_regs *syn
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
-	unsigned long condition;
+	unsigned long dr6;
 	int si_code;
 
-	get_debugreg(condition, 6);
+	get_debugreg(dr6, 6);
+	set_debugreg(0, 6);	/* DR6 may or may not be cleared by the CPU */
 
 	/* Catch kmemcheck conditions first of all! */
 	if (condition & DR_STEP && kmemcheck_trap(regs))
@@ -585,61 +586,42 @@ dotraplinkage void __kprobes do_debug(st
 	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
 	tsk->thread.debugctlmsr = 0;
 
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
+	/* Store the virtualized DR6 value */
+	tsk->thread.vdr6 = dr6;
+
+	if (notify_die(DIE_DEBUG, "debug", regs, dr6, error_code,
 						SIGTRAP) == NOTIFY_STOP)
 		return;
 
 	/* It's safe to allow irq's after DR6 has been saved */
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
 
 #ifdef CONFIG_X86_32
-	if (regs->flags & X86_VM_MASK)
-		goto debug_vm86;
 #endif
 
-	/* Save debug status register where ptrace can see it */
-	tsk->thread.debugreg6 = condition;
-
-	/*
-	 * Single-stepping through TF: make sure we ignore any events in
-	 * kernel space (but re-enable TF when returning to user mode).
-	 */
-	if (condition & DR_STEP) {
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
-	}
-
-	si_code = get_si_code(condition);
-	/* Ok, finally something we can handle */
-	send_sigtrap(tsk, regs, error_code, si_code);
-
 	/*
-	 * Disable additional traps. They'll be re-enabled when
-	 * the signal is delivered.
+	 * Single-stepping through system calls: ignore any exceptions in
+	 * kernel space, but re-enable TF when returning to user mode.
+	 *
+	 * We already checked v86 mode above, so we can check for kernel mode
+	 * by just checking the CPL of CS.
 	 */
-clear_dr7:
-	set_debugreg(0, 7);
-	preempt_conditional_cli(regs);
-	return;
-
-#ifdef CONFIG_X86_32
-debug_vm86:
-	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
-	preempt_conditional_cli(regs);
-	return;
-#endif
+	if ((dr6 & DR_STEP) && !user_mode(regs)) {
+		tsk->thread.vdr6 &= ~DR_STEP;
+		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+		regs->flags &= ~X86_EFLAGS_TF;
+	}
+	si_code = get_si_code(dr6);
+	if (tsk->thread.vdr6 & (DR_STEP|DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
+		send_sigtrap(tsk, regs, error_code, si_code);
 
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->flags &= ~X86_EFLAGS_TF;
 	preempt_conditional_cli(regs);
-	return;
 }
 
 #ifdef CONFIG_X86_64
