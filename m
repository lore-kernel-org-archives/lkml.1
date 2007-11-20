Return-Path: <linux-kernel-owner+w=401wt.eu-S1763389AbXKTScv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763389AbXKTScv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761696AbXKTS1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:27:01 -0500
Received: from [198.99.130.12] ([198.99.130.12]:53242 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761679AbXKTS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:26:59 -0500
Date: Tue, 20 Nov 2007 13:26:32 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/4] UML - use ptrace directly in libc code
Message-ID: <20071120182632.GA7689@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some register accessor cleanups -
	userspace() was calling restore_registers and save_registers for no
reason, since userspace() is on the libc side of the house, and these
add no value over calling ptrace directly
	init_thread_registers and get_safe_registers were the same thing,
so init_thread_registers is gone

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/registers.h     |    1 -
 arch/um/kernel/process.c        |    2 +-
 arch/um/os-Linux/registers.c    |   13 ++++---------
 arch/um/os-Linux/skas/process.c |    9 +++++++--
 4 files changed, 12 insertions(+), 13 deletions(-)

Index: linux-2.6.22/arch/um/os-Linux/skas/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/skas/process.c	2007-11-20 13:05:22.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/skas/process.c	2007-11-20 13:05:45.000000000 -0500
@@ -298,7 +298,9 @@ void userspace(struct uml_pt_regs *regs)
 	nsecs += os_nsecs();
 
 	while (1) {
-		restore_registers(pid, regs);
+		if (ptrace(PTRACE_SETREGS, pid, 0, regs->gp))
+			panic("userspace - PTRACE_SETREGS failed, "
+			      "errno = %d\n", errno);
 
 		/* Now we set local_using_sysemu to be used for one loop */
 		local_using_sysemu = get_using_sysemu();
@@ -318,7 +320,10 @@ void userspace(struct uml_pt_regs *regs)
 			      errno);
 
 		regs->is_user = 1;
-		save_registers(pid, regs);
+		if (ptrace(PTRACE_GETREGS, pid, 0, regs->gp))
+			panic("userspace - saving registers failed, "
+			      "errno = %d\n", errno);
+
 		UPT_SYSCALL_NR(regs) = -1; /* Assume: It's not a syscall */
 
 		if (WIFSTOPPED(status)) {
@@ -341,7 +346,7 @@ void userspace(struct uml_pt_regs *regs)
 				break;
 			case SIGVTALRM:
 				now = os_nsecs();
-				if(now < nsecs)
+				if (now < nsecs)
 					break;
 				block_signals();
 				(*sig_info[sig])(sig, regs);
Index: linux-2.6.22/arch/um/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/process.c	2007-11-20 13:05:20.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/process.c	2007-11-20 13:05:24.000000000 -0500
@@ -200,7 +200,7 @@ int copy_thread(int nr, unsigned long cl
 		arch_copy_thread(&current->thread.arch, &p->thread.arch);
 	}
 	else {
-		init_thread_registers(&p->thread.regs.regs);
+		get_safe_registers(p->thread.regs.regs.gp);
 		p->thread.request.u.thread = current->thread.request.u.thread;
 		handler = new_thread_handler;
 	}
Index: linux-2.6.22/arch/um/os-Linux/registers.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/registers.c	2007-11-20 13:05:20.000000000 -0500
+++ linux-2.6.22/arch/um/os-Linux/registers.c	2007-11-20 13:05:24.000000000 -0500
@@ -10,15 +10,6 @@
 #include "sysdep/ptrace.h"
 #include "user.h"
 
-/* This is set once at boot time and not changed thereafter */
-
-static unsigned long exec_regs[MAX_REG_NR];
-
-void init_thread_registers(struct uml_pt_regs *to)
-{
-	memcpy(to->gp, exec_regs, sizeof(to->gp));
-}
-
 void save_registers(int pid, struct uml_pt_regs *regs)
 {
 	int err;
@@ -39,6 +30,10 @@ void restore_registers(int pid, struct u
 		      "errno = %d\n", errno);
 }
 
+/* This is set once at boot time and not changed thereafter */
+
+static unsigned long exec_regs[MAX_REG_NR];
+
 void init_registers(int pid)
 {
 	int err;
Index: linux-2.6.22/arch/um/include/registers.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/registers.h	2007-11-20 13:05:20.000000000 -0500
+++ linux-2.6.22/arch/um/include/registers.h	2007-11-20 13:05:24.000000000 -0500
@@ -9,7 +9,6 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/archsetjmp.h"
 
-extern void init_thread_registers(struct uml_pt_regs *to);
 extern int save_fp_registers(int pid, unsigned long *fp_regs);
 extern int restore_fp_registers(int pid, unsigned long *fp_regs);
 extern int save_fpx_registers(int pid, unsigned long *fp_regs);
