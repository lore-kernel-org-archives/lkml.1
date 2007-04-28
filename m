Return-Path: <linux-kernel-owner+w=401wt.eu-S1031803AbXD1Rzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031803AbXD1Rzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163307AbXD1Rx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:53:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163302AbXD1Rwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:47 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [20/35] x86: Fix i386 and x86_64 fault information pollution
Message-Id: <20070428175245.3E265151FC@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


a userspace fault or a kernelspace fault which will result in the
immediate death of the process.  They should not be filled in as a
result of a kernelspace fault which can be fixed up.

Otherwise, if the process is handling SIGSEGV and examining the fault
information, this can result in the kernel space fault trashing the
previously stored fault information if it arrives between the
userspace fault happening and the SIGSEGV being delivered to the process.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Jan Beulich <jbeulich@novell.com>
--
 arch/i386/kernel/traps.c   |   24 ++++++++++++++++++------
 arch/x86_64/kernel/traps.c |   30 +++++++++++++++++++++++-------
 2 files changed, 41 insertions(+), 13 deletions(-)

Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -476,8 +476,6 @@ static void __kprobes do_trap(int trapnr
 			      siginfo_t *info)
 {
 	struct task_struct *tsk = current;
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
 
 	if (regs->eflags & VM_MASK) {
 		if (vm86)
@@ -489,6 +487,18 @@ static void __kprobes do_trap(int trapnr
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
@@ -497,8 +507,11 @@ static void __kprobes do_trap(int trapnr
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
 
@@ -603,9 +616,6 @@ fastcall void __kprobes do_general_prote
 	}
 	put_cpu();
 
-	current->thread.error_code = error_code;
-	current->thread.trap_no = 13;
-
 	if (regs->eflags & VM_MASK)
 		goto gp_in_vm86;
 
@@ -624,6 +634,8 @@ gp_in_vm86:
 
 gp_in_kernel:
 	if (!fixup_exception(regs)) {
+		current->thread.error_code = error_code;
+		current->thread.trap_no = 13;
 		if (notify_die(DIE_GPF, "general protection fault", regs,
 				error_code, 13, SIGSEGV) == NOTIFY_STOP)
 			return;
Index: linux/arch/x86_64/kernel/traps.c
===================================================================
--- linux.orig/arch/x86_64/kernel/traps.c
+++ linux/arch/x86_64/kernel/traps.c
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
