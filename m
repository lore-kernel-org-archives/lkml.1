Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbZFBWow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbZFBWow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZFBWnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21607 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbZFBWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=po59l4nyHlvQ+6Ba6CmtdWSmqyIOjhWWCfISFLfcJWLEPW0Gs1iB1vidmdVewHqDOc
         Z7aECFGIbMon9b7ymsfyjeqbeKIhNq0lnQY/lmkkYbJvfWdDizXKReCXxTztMH8ovGPs
         ThDULsmZKhKwaDvm6bznp1Afl0A3Cg8e2m764=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/12] hw-breakpoints: modifying generic debug exception to use thread-specific debug registers
Date: Wed,  3 Jun 2009 00:43:28 +0200
Message-Id: <1243982616-18212-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

This patch modifies the breakpoint exception handler code to use the new
abstract debug register names.

[ fweisbec@gmail.com: fix conflict against kmemcheck ]

[ Impact: refactor and cleanup x86 debug exception handler ]

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/traps.c |   69 ++++++++++++++++------------------------------
 1 files changed, 24 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..de99132 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -529,73 +529,52 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
-	unsigned long condition;
+	unsigned long dr6;
 	int si_code;
 
-	get_debugreg(condition, 6);
+	get_debugreg(dr6, 6);
 
+	/* DR6 may or may not be cleared by the CPU */
+	set_debugreg(0, 6);
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
 	 */
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
+	if (regs->flags & X86_VM_MASK) {
+		handle_vm86_trap((struct kernel_vm86_regs *) regs,
+				error_code, 1);
+		return;
 	}
 
-#ifdef CONFIG_X86_32
-	if (regs->flags & X86_VM_MASK)
-		goto debug_vm86;
-#endif
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
-		if (!user_mode(regs))
-			goto clear_TF_reenable;
+	if ((dr6 & DR_STEP) && !user_mode(regs)) {
+		tsk->thread.debugreg6 &= ~DR_STEP;
+		set_tsk_thread_flag(tsk, TIF_SINGLESTEP);
+		regs->flags &= ~X86_EFLAGS_TF;
 	}
-
-	si_code = get_si_code(condition);
-	/* Ok, finally something we can handle */
-	send_sigtrap(tsk, regs, error_code, si_code);
-
-	/*
-	 * Disable additional traps. They'll be re-enabled when
-	 * the signal is delivered.
-	 */
-clear_dr7:
-	set_debugreg(0, 7);
+	si_code = get_si_code(tsk->thread.debugreg6);
+	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
+		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
-	return;
 
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
-	preempt_conditional_cli(regs);
 	return;
 }
 
-- 
1.6.2.3

