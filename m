Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbYGAXf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbYGAXf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 19:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYGAXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 19:35:20 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:19170 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbYGAXfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 19:35:17 -0400
Date: Wed, 2 Jul 2008 01:32:04 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] x86: traps_xx: restructure do_general_protection()
Message-ID: <20080701233204.GE29903@mailshack.com>
References: <20080701193643.GA29695@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701193643.GA29695@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 02 Jul 2008 01:35:00 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.0.59; VDF: 7.0.5.30; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - if (cond) block -> if (!cond) goto end_of_block
 - local caching of current

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/traps_32.c |   36 ++++++++++++++++++++----------------
 arch/x86/kernel/traps_64.c |   41 ++++++++++++++++++++++-------------------
 2 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 9ed060e..68e800f 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -602,8 +602,10 @@ DO_ERROR(12, SIGBUS, "stack segment", stack_segment)
 DO_ERROR_INFO(17, SIGBUS, "alignment check", alignment_check, BUS_ADRALN, 0, 0)
 DO_ERROR_INFO(32, SIGILL, "iret exception", iret_error, ILL_BADSTK, 0, 1)
 
-void __kprobes do_general_protection(struct pt_regs *regs, long error_code)
+void __kprobes
+do_general_protection(struct pt_regs *regs, long error_code)
 {
+	struct task_struct *tsk;
 	struct thread_struct *thread;
 	struct tss_struct *tss;
 	int cpu;
@@ -644,23 +646,24 @@ void __kprobes do_general_protection(struct pt_regs *regs, long error_code)
 	if (regs->flags & X86_VM_MASK)
 		goto gp_in_vm86;
 
+	tsk = current;
 	if (!user_mode(regs))
 		goto gp_in_kernel;
 
-	current->thread.error_code = error_code;
-	current->thread.trap_no = 13;
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = 13;
 
-	if (show_unhandled_signals && unhandled_signal(current, SIGSEGV) &&
-	    printk_ratelimit()) {
+	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+			printk_ratelimit()) {
 		printk(KERN_INFO
-		    "%s[%d] general protection ip:%lx sp:%lx error:%lx",
-		    current->comm, task_pid_nr(current),
-		    regs->ip, regs->sp, error_code);
+			"%s[%d] general protection ip:%lx sp:%lx error:%lx",
+			tsk->comm, task_pid_nr(tsk),
+			regs->ip, regs->sp, error_code);
 		print_vma_addr(" in ", regs->ip);
 		printk("\n");
 	}
 
-	force_sig(SIGSEGV, current);
+	force_sig(SIGSEGV, tsk);
 	return;
 
 gp_in_vm86:
@@ -669,14 +672,15 @@ gp_in_vm86:
 	return;
 
 gp_in_kernel:
-	if (!fixup_exception(regs)) {
-		current->thread.error_code = error_code;
-		current->thread.trap_no = 13;
-		if (notify_die(DIE_GPF, "general protection fault", regs,
+	if (fixup_exception(regs))
+		return;
+
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = 13;
+	if (notify_die(DIE_GPF, "general protection fault", regs,
 				error_code, 13, SIGSEGV) == NOTIFY_STOP)
-			return;
-		die("general protection fault", regs, error_code);
-	}
+		return;
+	die("general protection fault", regs, error_code);
 }
 
 static notrace __kprobes void
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index b49c886..677b4e5 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -738,31 +738,34 @@ asmlinkage void do_double_fault(struct pt_regs * regs, long error_code)
 		die(str, regs, error_code);
 }
 
-asmlinkage void __kprobes do_general_protection(struct pt_regs * regs,
-						long error_code)
+asmlinkage void __kprobes
+do_general_protection(struct pt_regs *regs, long error_code)
 {
-	struct task_struct *tsk = current;
+	struct task_struct *tsk;
 
 	conditional_sti(regs);
 
-	if (user_mode(regs)) {
-		tsk->thread.error_code = error_code;
-		tsk->thread.trap_no = 13;
-
-		if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
-		    printk_ratelimit()) {
-			printk(KERN_INFO
-		       "%s[%d] general protection ip:%lx sp:%lx error:%lx",
-			       tsk->comm, tsk->pid,
-			       regs->ip, regs->sp, error_code);
-			print_vma_addr(" in ", regs->ip);
-			printk("\n");
-		}
+	tsk = current;
+	if (!user_mode(regs))
+		goto gp_in_kernel;
 
-		force_sig(SIGSEGV, tsk);
-		return;
-	} 
+	tsk->thread.error_code = error_code;
+	tsk->thread.trap_no = 13;
+
+	if (show_unhandled_signals && unhandled_signal(tsk, SIGSEGV) &&
+			printk_ratelimit()) {
+		printk(KERN_INFO
+			"%s[%d] general protection ip:%lx sp:%lx error:%lx",
+			tsk->comm, tsk->pid,
+			regs->ip, regs->sp, error_code);
+		print_vma_addr(" in ", regs->ip);
+		printk("\n");
+	}
+
+	force_sig(SIGSEGV, tsk);
+	return;
 
+gp_in_kernel:
 	if (fixup_exception(regs))
 		return;
 
-- 
1.5.4.3

