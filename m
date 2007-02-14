Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbXBNR7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbXBNR7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 12:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXBNR7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 12:59:16 -0500
Received: from [198.99.130.12] ([198.99.130.12]:33373 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbXBNR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 12:59:16 -0500
Date: Wed, 14 Feb 2007 12:51:14 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: Re: [patches] [PATCH 2.6.21 review I] [4/25] x86: kernel-mode faults pollute current->thead
Message-ID: <20070214175114.GB5801@ccure.user-mode-linux.org>
References: <45D17C66.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D17C66.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 07:52:54AM +0000, Jan Beulich wrote:
> Actually, after a second round of thinking I believe there's still more to do
> - your second patch missed fixing i386's do_trap() similarly to x86-64's
> and, vice versa, x86-64's do_general_protection() similarly to i386's.

Sigh, here's another go at it - the full patch instead of
incrementally fixing the old one:

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
@@ -486,6 +484,9 @@ static void __kprobes do_trap(int trapnr
 		goto kernel_trap;
 
 	trap_signal: {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (info)
 			force_sig_info(signr, info, tsk);
 		else
@@ -494,8 +495,11 @@ static void __kprobes do_trap(int trapnr
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
 
@@ -600,15 +604,21 @@ fastcall void __kprobes do_general_prote
 	}
 	put_cpu();
 
-	current->thread.error_code = error_code;
-	current->thread.trap_no = 13;
-
 	if (regs->eflags & VM_MASK)
 		goto gp_in_vm86;
 
 	if (!user_mode(regs))
 		goto gp_in_kernel;
 
+	/*
+	 * We want error_code and trap_no set for userspace faults and
+	 * kernelspace faults which result in die(), but not
+	 * kernelspace faults which are fixed up.  die() gives the
+	 * process no chance to handle the signal and notice the
+	 * kernel fault information, so that won't result in polluting
+	 * the information about previously queued, but not yet
+	 * delivered, fault.
+	 */
 	current->thread.error_code = error_code;
 	current->thread.trap_no = 13;
 	force_sig(SIGSEGV, current);
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
@@ -581,10 +581,19 @@ static void __kprobes do_trap(int trapnr
 {
 	struct task_struct *tsk = current;
 
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
-
 	if (user_mode(regs)) {
+		/*
+		 * We want error_code and trap_no set for userspace faults
+		 * and kernelspace faults which result in die(), but
+		 * not kernelspace faults which are fixed up.  die()
+		 * gives the process no chance to handle the signal
+		 * and notice the kernel fault information, so that
+		 * won't result in polluting the information about
+		 * previously queued, but not yet delivered, fault.
+		 */
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (exception_trace && unhandled_signal(tsk, signr))
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
@@ -605,8 +614,11 @@ static void __kprobes do_trap(int trapnr
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
@@ -682,10 +694,10 @@ asmlinkage void __kprobes do_general_pro
 
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
@@ -704,6 +716,10 @@ asmlinkage void __kprobes do_general_pro
 			regs->rip = fixup->fixup;
 			return;
 		}
+
+
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = 13;
 		if (notify_die(DIE_GPF, "general protection fault", regs,
 					error_code, 13, SIGSEGV) == NOTIFY_STOP)
 			return;

-- 
Work email - jdike at linux dot intel dot com
