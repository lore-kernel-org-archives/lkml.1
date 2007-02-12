Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbXBLUaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbXBLUaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:30:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXBLUaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:30:12 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53391 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965351AbXBLUaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:30:09 -0500
Message-Id: <200702122022.l1CKMKYF007139@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org, "Andi Kleen" <ak@suse.de>
cc: linux-kernel@vger.kernel.org, "Jan Beulich" <jbeulich@novell.com>,
       patches@x86-64.org
Subject: [PATCH] Fatal kernel faults should update thread struct
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 12 Feb 2007 15:22:20 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug introduced in my earlier fault information pollution
prevention patch.  That patch assumed that no kernel fault information
should ever be put in thread.error_code and .trap_no.  It turns out
that die() reads those fields, so fatal kernel faults, as well as
userspace faults, need those fields set.  The case where they aren't
set is kernelspace faults which are fixed up.

Thanks to Jan Beulich for his review and spotting this bug.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/i386/kernel/traps.c   |   11 +++++++++++
 arch/x86_64/kernel/traps.c |   14 +++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/i386/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/traps.c
+++ linux-2.6/arch/i386/kernel/traps.c
@@ -607,6 +607,15 @@ fastcall void __kprobes do_general_prote
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
@@ -619,6 +628,8 @@ gp_in_vm86:
 
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
@@ -582,6 +582,15 @@ static void __kprobes do_trap(int trapnr
 	struct task_struct *tsk = current;
 
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
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_no = trapnr;
 
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

