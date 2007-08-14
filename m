Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbXHNWAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbXHNWAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbXHNVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:40:48 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42222 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934151AbXHNVkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:40:43 -0400
Date: Tue, 14 Aug 2007 17:40:23 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 9/14] UML - Get rid of do_longjmp
Message-ID: <20070814214023.GA17559@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

do_longjmp used to be needed when UML didn't have its own
implementation of setjmp and longjmp.  They came from libc, and
couldn't be called directly from kernel code, as the libc jmp_buf
couldn't be imported there.  do_longjmp was a userspace function which
served to provide longjmp access to kernel code.

This is gone, and a number of void * pointers can now be jmp_buf *.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/os.h               |    5 ++---
 arch/um/include/um_uaccess.h       |    4 ++++
 arch/um/include/uml_uaccess.h      |   24 ------------------------
 arch/um/kernel/exec.c              |    2 +-
 arch/um/kernel/mem.c               |    2 +-
 arch/um/kernel/trap.c              |    6 +++---
 arch/um/kernel/uaccess.c           |    2 +-
 arch/um/os-Linux/process.c         |    2 +-
 arch/um/os-Linux/trap.c            |    7 -------
 arch/um/os-Linux/uaccess.c         |    2 +-
 include/asm-um/processor-generic.h |    4 ++--
 11 files changed, 16 insertions(+), 44 deletions(-)

Index: linux-2.6.22/arch/um/include/os.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/os.h	2007-08-13 13:44:46.000000000 -0400
+++ linux-2.6.22/arch/um/include/os.h	2007-08-13 13:44:53.000000000 -0400
@@ -193,7 +193,7 @@ extern int os_getpid(void);
 extern int os_getpgrp(void);
 
 extern void init_new_thread_signals(void);
-extern int run_kernel_thread(int (*fn)(void *), void *arg, void **jmp_ptr);
+extern int run_kernel_thread(int (*fn)(void *), void *arg, jmp_buf **jmp_ptr);
 
 extern int os_map_memory(void *virt, int fd, unsigned long long off,
 			 unsigned long len, int r, int w, int x);
@@ -206,7 +206,7 @@ extern void os_flush_stdout(void);
 
 /* uaccess.c */
 extern unsigned long __do_user_copy(void *to, const void *from, int n,
-				    void **fault_addr, void **fault_catcher,
+				    void **fault_addr, jmp_buf **fault_catcher,
 				    void (*op)(void *to, const void *from,
 					       int n), int *faulted_out);
 
@@ -240,7 +240,6 @@ extern int set_signals(int enable);
 
 /* trap.c */
 extern void os_fill_handlinfo(struct kern_handlers h);
-extern void do_longjmp(void *p, int val);
 
 /* util.c */
 extern void stack_protections(unsigned long address);
Index: linux-2.6.22/arch/um/include/um_uaccess.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/um_uaccess.h	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/arch/um/include/um_uaccess.h	2007-08-13 13:44:53.000000000 -0400
@@ -30,6 +30,10 @@
 extern int copy_from_user(void *to, const void __user *from, int n);
 extern int copy_to_user(void __user *to, const void *from, int n);
 
+extern int __do_copy_to_user(void *to, const void *from, int n,
+			     void **fault_addr, jmp_buf **fault_catcher);
+extern void __do_copy(void *to, const void *from, int n);
+
 /*
  * strncpy_from_user: - Copy a NUL terminated string from userspace.
  * @dst:   Destination address, in kernel space.  This buffer must be at
Index: linux-2.6.22/arch/um/include/uml_uaccess.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/uml_uaccess.h	2007-08-13 13:44:23.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,24 +0,0 @@
-/*
- * Copyright (C) 2001 Jeff Dike (jdike@karaya.com)
- * Licensed under the GPL
- */
-
-#ifndef __UML_UACCESS_H__
-#define __UML_UACCESS_H__
-
-extern int __do_copy_to_user(void *to, const void *from, int n,
-			     void **fault_addr, void **fault_catcher);
-void __do_copy(void *to, const void *from, int n);
-
-#endif
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
Index: linux-2.6.22/arch/um/kernel/exec.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/exec.c	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/exec.c	2007-08-13 13:44:56.000000000 -0400
@@ -75,7 +75,7 @@ long um_execve(char *file, char __user *
 
 	err = execve1(file, argv, env);
 	if (!err)
-		do_longjmp(current->thread.exec_buf, 1);
+		UML_LONGJMP(current->thread.exec_buf, 1);
 	return err;
 }
 
Index: linux-2.6.22/arch/um/kernel/mem.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/mem.c	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/mem.c	2007-08-13 13:44:53.000000000 -0400
@@ -17,7 +17,7 @@
 #include "as-layout.h"
 #include "kern.h"
 #include "mem_user.h"
-#include "uml_uaccess.h"
+#include "um_uaccess.h"
 #include "os.h"
 #include "linux/types.h"
 #include "linux/string.h"
Index: linux-2.6.22/arch/um/kernel/trap.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/trap.c	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/trap.c	2007-08-13 13:44:53.000000000 -0400
@@ -149,7 +149,7 @@ unsigned long segv(struct faultinfo fi, 
 		   struct uml_pt_regs *regs)
 {
 	struct siginfo si;
-	void *catcher;
+	jmp_buf *catcher;
 	int err;
 	int is_write = FAULT_WRITE(fi);
 	unsigned long address = FAULT_ADDRESS(fi);
@@ -181,7 +181,7 @@ unsigned long segv(struct faultinfo fi, 
 		return 0;
 	else if (catcher != NULL) {
 		current->thread.fault_addr = (void *) address;
-		do_longjmp(catcher, 1);
+		UML_LONGJMP(catcher, 1);
 	}
 	else if (current->thread.fault_addr != NULL)
 		panic("fault_addr set but no fault catcher");
@@ -233,7 +233,7 @@ void relay_signal(int sig, struct uml_pt
 static void bus_handler(int sig, struct uml_pt_regs *regs)
 {
 	if (current->thread.fault_catcher != NULL)
-		do_longjmp(current->thread.fault_catcher, 1);
+		UML_LONGJMP(current->thread.fault_catcher, 1);
 	else relay_signal(sig, regs);
 }
 
Index: linux-2.6.22/arch/um/kernel/uaccess.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/uaccess.c	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/arch/um/kernel/uaccess.c	2007-08-13 13:44:53.000000000 -0400
@@ -18,7 +18,7 @@ void __do_copy(void *to, const void *fro
 
 
 int __do_copy_to_user(void *to, const void *from, int n,
-		      void **fault_addr, void **fault_catcher)
+		      void **fault_addr, jmp_buf **fault_catcher)
 {
 	unsigned long fault;
 	int faulted;
Index: linux-2.6.22/arch/um/os-Linux/process.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/process.c	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/process.c	2007-08-13 13:44:53.000000000 -0400
@@ -249,7 +249,7 @@ void init_new_thread_signals(void)
 	init_irq_signals(1);
 }
 
-int run_kernel_thread(int (*fn)(void *), void *arg, void **jmp_ptr)
+int run_kernel_thread(int (*fn)(void *), void *arg, jmp_buf **jmp_ptr)
 {
 	jmp_buf buf;
 	int n;
Index: linux-2.6.22/arch/um/os-Linux/trap.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/trap.c	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/trap.c	2007-08-13 13:44:53.000000000 -0400
@@ -22,10 +22,3 @@ void os_fill_handlinfo(struct kern_handl
 	sig_info[SIGVTALRM] = h.timer_handler;
 	sig_info[SIGALRM] = h.timer_handler;
 }
-
-void do_longjmp(void *b, int val)
-{
-	jmp_buf *buf = b;
-
-	UML_LONGJMP(buf, val);
-}
Index: linux-2.6.22/include/asm-um/processor-generic.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/processor-generic.h	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/include/asm-um/processor-generic.h	2007-08-13 13:44:53.000000000 -0400
@@ -30,10 +30,10 @@ struct thread_struct {
 	struct pt_regs regs;
 	int singlestep_syscall;
 	void *fault_addr;
-	void *fault_catcher;
+	jmp_buf *fault_catcher;
 	struct task_struct *prev_sched;
 	unsigned long temp_stack;
-	void *exec_buf;
+	jmp_buf *exec_buf;
 	struct arch_thread arch;
 	jmp_buf switch_buf;
 	int mm_count;
Index: linux-2.6.22/arch/um/os-Linux/uaccess.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/uaccess.c	2007-08-13 13:44:23.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/uaccess.c	2007-08-13 13:44:53.000000000 -0400
@@ -8,7 +8,7 @@
 #include "longjmp.h"
 
 unsigned long __do_user_copy(void *to, const void *from, int n,
-			     void **fault_addr, void **fault_catcher,
+			     void **fault_addr, jmp_buf **fault_catcher,
 			     void (*op)(void *to, const void *from,
 					int n), int *faulted_out)
 {
