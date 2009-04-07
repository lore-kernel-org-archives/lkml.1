Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZDGGg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZDGGg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZDGGgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:36:16 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:43511 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZDGGgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:36:15 -0400
Date: Tue, 7 Apr 2009 12:06:06 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [Patch 04/11] Modifying generic debug exception to use
	thread-specific debug registers
Message-ID: <20090407063606.GE17461@in.ibm.com>
References: <20090407063058.301701787@prasadkr_t60p.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=modify_debug_exception_handler_04
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch modifies the breakpoint exception handler code to use the abstract
register names.

[K.Prasad: Split-out from the bigger patch and minor changes following
           re-basing]

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 arch/x86/kernel/traps.c |   75 +++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 48 deletions(-)

Index: arch/x86/kernel/traps.c
===================================================================
--- arch/x86/kernel/traps.c.orig
+++ arch/x86/kernel/traps.c
@@ -530,13 +530,15 @@ asmlinkage __kprobes struct pt_regs *syn
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
-	if (condition & DR_STEP && kmemcheck_trap(regs))
+	if ((dr6 & DR_STEP && kmemcheck_trap(regs)) &&
+		!(dr6 & (DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3)))
 		return;
 
 	/*
@@ -545,61 +547,38 @@ dotraplinkage void __kprobes do_debug(st
 	clear_tsk_thread_flag(tsk, TIF_DEBUGCTLMSR);
 	tsk->thread.debugctlmsr = 0;
 
-	if (notify_die(DIE_DEBUG, "debug", regs, condition, error_code,
+	/* Store the virtualized DR6 value */
+	tsk->thread.debugreg6 = dr6;
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
-	}
-
-#ifdef CONFIG_X86_32
-	if (regs->flags & X86_VM_MASK)
-		goto debug_vm86;
-#endif
-
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
+	if (regs->flags & X86_VM_MASK) {
+		handle_vm86_trap((struct kernel_vm86_regs *) regs,
+				error_code, 1);
+		return;
 	}
 
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
-	/* reenable preemption: handle_vm86_trap() might sleep */
-	dec_preempt_count();
-	handle_vm86_trap((struct kernel_vm86_regs *) regs, error_code, 1);
-	conditional_cli(regs);
-	return;
-#endif
-
-clear_TF_reenable:
-	set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
-	regs->flags &= ~X86_EFLAGS_TF;
+	if ((dr6 & DR_STEP) && !user_mode(regs)) {
+		tsk->thread.debugreg6 &= ~DR_STEP;
+		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+		regs->flags &= ~X86_EFLAGS_TF;
+	}
+	si_code = get_si_code(dr6);
+	if (tsk->thread.debugreg6 &
+			(DR_STEP|DR_TRAP0|DR_TRAP1|DR_TRAP2|DR_TRAP3))
+		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
 	return;
 }

