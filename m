Return-Path: <linux-kernel-owner+w=401wt.eu-S935316AbXKPVps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316AbXKPVps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935092AbXKPVna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:43:30 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59882 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S935049AbXKPVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:43:27 -0500
Date: Fri, 16 Nov 2007 16:42:26 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/8] UML - current.h cleanup
Message-ID: <20071116214226.GA13862@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tidy current-related stuff.  There was a comment in current.h saying
that current_thread was obsolete, so this patch turns all instances of
current_thread into current_thread_info().  There's some simplifying
of the result in arch/um/sys-i386/signal.c.

current.h and thread_info also get style cleanups.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/process.c     |    8 ++++----
 arch/um/sys-i386/signal.c    |   18 ++++++++----------
 arch/um/sys-x86_64/signal.c  |    4 ++--
 include/asm-um/current.h     |   23 ++---------------------
 include/asm-um/thread_info.h |    8 ++++----
 5 files changed, 20 insertions(+), 41 deletions(-)

Index: linux-2.6.22/arch/um/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/process.c	2007-11-16 13:30:15.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/process.c	2007-11-16 14:01:21.000000000 -0500
@@ -252,7 +252,7 @@ void default_idle(void)
 
 void cpu_idle(void)
 {
-	cpu_tasks[current_thread->cpu].pid = os_getpid();
+	cpu_tasks[current_thread_info()->cpu].pid = os_getpid();
 	default_idle();
 }
 
@@ -266,7 +266,7 @@ int user_context(unsigned long sp)
 	unsigned long stack;
 
 	stack = sp & (PAGE_MASK << CONFIG_KERNEL_STACK_ORDER);
-	return stack != (unsigned long) current_thread;
+	return stack != (unsigned long) current_thread_info();
 }
 
 extern exitcall_t __uml_exitcall_begin, __uml_exitcall_end;
@@ -308,7 +308,7 @@ int strlen_user_proc(char __user *str)
 int smp_sigio_handler(void)
 {
 #ifdef CONFIG_SMP
-	int cpu = current_thread->cpu;
+	int cpu = current_thread_info()->cpu;
 	IPI_handler(cpu);
 	if (cpu != 0)
 		return 1;
@@ -318,7 +318,7 @@ int smp_sigio_handler(void)
 
 int cpu(void)
 {
-	return current_thread->cpu;
+	return current_thread_info()->cpu;
 }
 
 static atomic_t using_sysemu = ATOMIC_INIT(0);
Index: linux-2.6.22/arch/um/sys-i386/signal.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/signal.c	2007-11-16 13:14:40.000000000 -0500
+++ linux-2.6.22/arch/um/sys-i386/signal.c	2007-11-16 14:04:27.000000000 -0500
@@ -168,12 +168,13 @@ static int copy_sc_from_user(struct pt_r
 			     struct sigcontext __user *from)
 {
 	struct sigcontext sc;
-	int err;
+	int err, pid;
 
 	err = copy_from_user(&sc, from, sizeof(sc));
 	if (err)
 		return err;
 
+	pid = userspace_pid[current_thread_info()->cpu];
 	copy_sc(&regs->regs, &sc);
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
@@ -187,8 +188,7 @@ static int copy_sc_from_user(struct pt_r
 		if (err)
 			return 1;
 
-		err = restore_fpx_registers(userspace_pid[current_thread->cpu],
-					    (unsigned long *) &fpx);
+		err = restore_fpx_registers(pid, (unsigned long *) &fpx);
 		if (err < 0) {
 			printk(KERN_ERR "copy_sc_from_user - "
 			       "restore_fpx_registers failed, errno = %d\n",
@@ -204,8 +204,7 @@ static int copy_sc_from_user(struct pt_r
 		if (err)
 			return 1;
 
-		err = restore_fp_registers(userspace_pid[current_thread->cpu],
-					   (unsigned long *) &fp);
+		err = restore_fp_registers(pid, (unsigned long *) &fp);
 		if (err < 0) {
 			printk(KERN_ERR "copy_sc_from_user - "
 			       "restore_fp_registers failed, errno = %d\n",
@@ -223,7 +222,7 @@ static int copy_sc_to_user(struct sigcon
 {
 	struct sigcontext sc;
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
-	int err;
+	int err, pid;
 
 	sc.gs = REGS_GS(regs->regs.gp);
 	sc.fs = REGS_FS(regs->regs.gp);
@@ -249,11 +248,11 @@ static int copy_sc_to_user(struct sigcon
 	to_fp = (to_fp ? to_fp : (struct _fpstate __user *) (to + 1));
 	sc.fpstate = to_fp;
 
+	pid = userspace_pid[current_thread_info()->cpu];
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
 
-		err = save_fpx_registers(userspace_pid[current_thread->cpu],
-					 (unsigned long *) &fpx);
+		err = save_fpx_registers(pid, (unsigned long *) &fpx);
 		if (err < 0){
 			printk(KERN_ERR "copy_sc_to_user - save_fpx_registers "
 			       "failed, errno = %d\n", err);
@@ -276,8 +275,7 @@ static int copy_sc_to_user(struct sigcon
 	else {
 		struct user_i387_struct fp;
 
-		err = save_fp_registers(userspace_pid[current_thread->cpu],
-					(unsigned long *) &fp);
+		err = save_fp_registers(pid, (unsigned long *) &fp);
 		if (copy_to_user(to_fp, &fp, sizeof(struct user_i387_struct)))
 			return 1;
 	}
Index: linux-2.6.22/arch/um/sys-x86_64/signal.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-x86_64/signal.c	2007-11-16 13:14:40.000000000 -0500
+++ linux-2.6.22/arch/um/sys-x86_64/signal.c	2007-11-16 14:01:21.000000000 -0500
@@ -81,7 +81,7 @@ static int copy_sc_from_user(struct pt_r
 	if (err)
 		return 1;
 
-	err = restore_fp_registers(userspace_pid[current_thread->cpu],
+	err = restore_fp_registers(userspace_pid[current_thread_info()->cpu],
 				   (unsigned long *) &fp);
 	if (err < 0) {
 		printk(KERN_ERR "copy_sc_from_user - "
@@ -143,7 +143,7 @@ static int copy_sc_to_user(struct sigcon
 	if (err)
 		return 1;
 
-	err = save_fp_registers(userspace_pid[current_thread->cpu],
+	err = save_fp_registers(userspace_pid[current_thread_info()->cpu],
 				(unsigned long *) &fp);
 	if (err < 0) {
 		printk(KERN_ERR "copy_sc_from_user - restore_fp_registers "
Index: linux-2.6.22/include/asm-um/current.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/current.h	2007-11-16 13:14:40.000000000 -0500
+++ linux-2.6.22/include/asm-um/current.h	2007-11-16 14:01:21.000000000 -0500
@@ -1,32 +1,13 @@
-/* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
 #ifndef __UM_CURRENT_H
 #define __UM_CURRENT_H
 
-#ifndef __ASSEMBLY__
-
-#include "asm/page.h"
 #include "linux/thread_info.h"
 
 #define current (current_thread_info()->task)
 
-/*Backward compatibility - it's used inside arch/um.*/
-#define current_thread current_thread_info()
-
-#endif /* __ASSEMBLY__ */
-
 #endif
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-file-style: "linux"
- * End:
- */
Index: linux-2.6.22/include/asm-um/thread_info.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/thread_info.h	2007-11-16 13:30:15.000000000 -0500
+++ linux-2.6.22/include/asm-um/thread_info.h	2007-11-16 14:01:21.000000000 -0500
@@ -1,5 +1,5 @@
-/* 
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+/*
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -76,8 +76,8 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG      3       /* true if poll_idle() is polling 
-					 * TIF_NEED_RESCHED 
+#define TIF_POLLING_NRFLAG      3       /* true if poll_idle() is polling
+					 * TIF_NEED_RESCHED
 					 */
 #define TIF_RESTART_BLOCK 	4
 #define TIF_MEMDIE	 	5
