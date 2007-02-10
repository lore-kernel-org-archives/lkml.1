Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbXBJLvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbXBJLvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933375AbXBJLvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:51:36 -0500
Received: from ns2.suse.de ([195.135.220.15]:55774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372AbXBJLu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:50:29 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101250.142420000@suse.de>
In-Reply-To: <200702101250.142420000@suse.de>
To: Jeff Dike <jdike@addtoit.com>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review I] [4/25] x86: kernel-mode faults pollute current->thead
Message-Id: <20070210115016.652C913DCE@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:50:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeff Dike <jdike@addtoit.com>

Kernel-mode traps on x86_64 can pollute the trap information for a previous
userspace trap for which the signal has not yet been delivered to the
process.

do_trap and do_general_protection set task->thread.error_code and .trapno
for kernel traps.  If a kernel-mode trap arrives between the arrival of a
userspace trap and the delivery of the associated SISGEGV to the process,
the process will get the kernel trap information in its sigcontext.

This causes UML process segfaults, as the trapno that the UML kernel sees
is 13, rather than the 14 for normal page faults.  So, the UML kernel
passes the SIGSEGV along to its process.

I don't claim to fully understand the problem.  On the one hand, a check in
do_general_protection for a pending SIGSEGV turned up nothing.  On the
other hand, this patch fixed the UML process segfault problem.

The patch below moves the setting of error_code and trapno so that that
only happens in the case of userspace faults.  As a side-effect, this
should speed up kernel-mode fault handling a tiny bit.

I looked at i386, and there is a similar situation.  In this case, there is
duplicate code setting task->thread.error_code and trapno.  I deleted one,
leaving the copy that runs in the case of a userspace fault.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/traps.c   |    8 +++-----
 arch/x86_64/kernel/traps.c |   12 ++++++------
 2 files changed, 9 insertions(+), 11 deletions(-)

Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -474,8 +474,6 @@ static void __kprobes do_trap(int trapnr
 			      siginfo_t *info)
 {
 	struct task_struct *tsk = current;
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
 
 	if (regs->eflags & VM_MASK) {
 		if (vm86)
@@ -487,6 +485,9 @@ static void __kprobes do_trap(int trapnr
 		goto kernel_trap;
 
 	trap_signal: {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (info)
 			force_sig_info(signr, info, tsk);
 		else
@@ -601,9 +602,6 @@ fastcall void __kprobes do_general_prote
 	}
 	put_cpu();
 
-	current->thread.error_code = error_code;
-	current->thread.trap_no = 13;
-
 	if (regs->eflags & VM_MASK)
 		goto gp_in_vm86;
 
Index: linux/arch/x86_64/kernel/traps.c
===================================================================
--- linux.orig/arch/x86_64/kernel/traps.c
+++ linux/arch/x86_64/kernel/traps.c
@@ -581,10 +581,10 @@ static void __kprobes do_trap(int trapnr
 {
 	struct task_struct *tsk = current;
 
-	tsk->thread.error_code = error_code;
-	tsk->thread.trap_no = trapnr;
-
 	if (user_mode(regs)) {
+		tsk->thread.error_code = error_code;
+		tsk->thread.trap_no = trapnr;
+
 		if (exception_trace && unhandled_signal(tsk, signr))
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
@@ -682,10 +682,10 @@ asmlinkage void __kprobes do_general_pro
 
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
