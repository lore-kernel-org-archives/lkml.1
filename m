Return-Path: <linux-kernel-owner+w=401wt.eu-S966113AbXBOQq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966113AbXBOQq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966116AbXBOQq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:46:57 -0500
Received: from [198.99.130.12] ([198.99.130.12]:37054 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966113AbXBOQq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:46:56 -0500
Date: Thu, 15 Feb 2007 11:38:33 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andi Kleen <ak@suse.de>, akpm@osdl.org
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH] Fix i386 and x86_64 fault information pollution
Message-ID: <20070215163833.GB4925@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This, I hope, is a final working version of this fix.

			Jeff
-- 
Work email - jdike at linux dot intel dot com


a userspace fault or a kernelspace fault which will result in the
immediate death of the process.  They should not be filled in as a
result of a kernelspace fault which can be fixed up.

Otherwise, if the process is handling SIGSEGV and examining the fault
information, this can result in the kernel space fault trashing the
previously stored fault information if it arrives between the
userspace fault happening and the SIGSEGV being delivered to the process.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Acked-by: Jan Beulich <jbeulich@novell.com>
--
 arch/i386/kernel/traps.c   |   24 ++++++++++++++++++------
 arch/x86_64/kernel/traps.c |   30 +++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/i386/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/traps.c
+++ linux-2.6/arch/i386/kernel/traps.c
@@ -473,8 +473,6 @@ static void __kprobes do_trap(int trapnr
 			      siginfo_t *info)
 {
 	struct task_struct *tsk = current;
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
 
 	if (regs->eflags & VM_MASK) {
 		if (vm86)
@@ -486,6 +484,18 @@ static void __kprobes do_trap(int trapnr
 		goto kernel_trap;
 
 	trap_signal: {
+		/*
+		 * We want error_code and trap_no set for userspace faults and
+		 * kernelspace faults which result in die(), but not
+		 * kernelspace faults which are fixed up.  die() gives the
+		 * process no chance to handle the signal and notice the
+		 * kernel fault information, so that won't result in polluting
+		 * the information about previously queued, but not yet
+		 * delivered, faults.  See also do_general_protection below.
+		 */
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (info)
 			force_sig_info(signr, info, tsk);
 		else
@@ -494,8 +504,11 @@ static void __kprobes do_trap(int trapnr
 	}
 
 	kernel_trap: {
-		if (!fixup_exception(regs))
+		if (!fixup_exception(regs)) {
+			tsk->thread.error_code = error_code;
+			tsk->thread.trap_no = trapnr;
 			die(str, regs, error_code);
+		}
 		return;
 	}
 
@@ -600,9 +613,6 @@ fastcall void __kprobes do_general_prote
 	}
 	put_cpu();
 
-	current->thread.error_code = error_code;
-	current->thread.trap_no = 13;
-
 	if (regs->eflags & VM_MASK)
 		goto gp_in_vm86;
 
@@ -621,6 +631,8 @@ gp_in_vm86:
 
 gp_in_kernel:
 	if (!fixup_exception(regs)) {
+		current->thread.error_code = error_code;
+		current->thread.trap_no = 13;
 		if (notify_die(DIE_GPF, "general protection fault", regs,
 				error_code, 13, SIGSEGV) == NOTIFY_STOP)
 			return;
Index: linux-2.6/arch/x86_64/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/traps.c
+++ linux-2.6/arch/x86_64/kernel/traps.c
@@ -581,10 +581,20 @@ static void __kprobes do_trap(int trapnr
 {
 	struct task_struct *tsk = current;
 
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
-
 	if (user_mode(regs)) {
+		/*
+		 * We want error_code and trap_no set for userspace
+		 * faults and kernelspace faults which result in
+		 * die(), but not kernelspace faults which are fixed
+		 * up.  die() gives the process no chance to handle
+		 * the signal and notice the kernel fault information,
+		 * so that won't result in polluting the information
+		 * about previously queued, but not yet delivered,
+		 * faults.  See also do_general_protection below.
+		 */
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (exception_trace && unhandled_signal(tsk, signr))
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
@@ -605,8 +615,11 @@ static void __kprobes do_trap(int trapnr
 		fixup = search_exception_tables(regs->rip);
 		if (fixup)
 			regs->rip = fixup->fixup;
-		else	
+		else {
+			tsk->thread.error_code = error_code;
+			tsk->thread.trap_no = trapnr;
 			die(str, regs, error_code);
+		}
 		return;
 	}
 }
@@ -682,10 +695,10 @@ asmlinkage void __kprobes do_general_pro
 
 	conditional_sti(regs);
 
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = 13;
-
 	if (user_mode(regs)) {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = 13;
+
 		if (exception_trace && unhandled_signal(tsk, SIGSEGV))
 			printk(KERN_INFO
 		       "%s[%d] general protection rip:%lx rsp:%lx error:%lx\n",
@@ -704,6 +717,9 @@ asmlinkage void __kprobes do_general_pro
 			regs->rip = fixup->fixup;
 			return;
 		}
+
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = 13;
 		if (notify_die(DIE_GPF, "general protection fault", regs,
 					error_code, 13, SIGSEGV) == NOTIFY_STOP)
 			return;
