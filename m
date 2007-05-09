Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXEIUdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXEIUdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 16:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbXEIUdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 16:33:17 -0400
Received: from [198.99.130.12] ([198.99.130.12]:40440 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758623AbXEIUdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 16:33:15 -0400
Date: Wed, 9 May 2007 16:27:19 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/6] UML - Remove task_protections
Message-ID: <20070509202719.GA22444@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced task_protections with stack_protections since they do the same
thing, and task_protections was misnamed anyway.

This needs THREAD_SIZE, so that's imported via common-offsets.h

Also tidied up the code in the vicinity.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/common-offsets.h |    2 ++
 arch/um/include/os.h             |    1 -
 arch/um/kernel/tt/exec_kern.c    |    2 +-
 arch/um/kernel/tt/process_kern.c |    2 +-
 arch/um/kernel/um_arch.c         |    2 +-
 arch/um/os-Linux/util.c          |   23 +++--------------------
 6 files changed, 8 insertions(+), 24 deletions(-)

Index: linux-2.6.21-mm/arch/um/include/os.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/os.h	2007-05-07 15:01:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/os.h	2007-05-07 15:37:28.000000000 -0400
@@ -272,7 +272,6 @@ extern void do_longjmp(void *p, int val)
 
 /* util.c */
 extern void stack_protections(unsigned long address);
-extern void task_protections(unsigned long address);
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
Index: linux-2.6.21-mm/arch/um/kernel/tt/exec_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/exec_kern.c	2007-05-07 15:01:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/exec_kern.c	2007-05-07 15:37:29.000000000 -0400
@@ -57,7 +57,7 @@ void flush_thread_tt(void)
 	enable_timer();
 	free_page(stack);
 	protect_memory(uml_reserved, high_physmem - uml_reserved, 1, 1, 0, 1);
-	task_protections((unsigned long) current_thread);
+	stack_protections((unsigned long) current_thread);
 	force_flush_all();
 	unblock_signals();
 }
Index: linux-2.6.21-mm/arch/um/kernel/tt/process_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/tt/process_kern.c	2007-05-07 15:01:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/tt/process_kern.c	2007-05-07 15:37:29.000000000 -0400
@@ -209,7 +209,7 @@ void finish_fork_handler(int sig)
 	if(current->mm != current->parent->mm)
 		protect_memory(uml_reserved, high_physmem - uml_reserved, 1, 
 			       1, 0, 1);
-	task_protections((unsigned long) current_thread);
+	stack_protections((unsigned long) current_thread);
 
 	free_page(current->thread.temp_stack);
 	local_irq_disable();
Index: linux-2.6.21-mm/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/um_arch.c	2007-05-07 15:02:04.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/um_arch.c	2007-05-07 15:37:29.000000000 -0400
@@ -459,7 +459,7 @@ int __init linux_main(int argc, char **a
 
 	uml_postsetup();
 
-	task_protections((unsigned long) &init_thread_info);
+	stack_protections((unsigned long) &init_thread_info);
 	os_flush_stdout();
 
 	return CHOOSE_MODE(start_uml_tt(), start_uml_skas());
Index: linux-2.6.21-mm/arch/um/os-Linux/util.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/os-Linux/util.c	2007-05-07 15:01:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/os-Linux/util.c	2007-05-07 15:37:29.000000000 -0400
@@ -33,25 +33,8 @@
 
 void stack_protections(unsigned long address)
 {
-	int prot = PROT_READ | PROT_WRITE | PROT_EXEC;
-
-	if(mprotect((void *) address, UM_KERN_PAGE_SIZE, prot) < 0)
-		panic("protecting stack failed, errno = %d", errno);
-}
-
-void task_protections(unsigned long address)
-{
-	unsigned long guard = address + UM_KERN_PAGE_SIZE;
-	unsigned long stack = guard + UM_KERN_PAGE_SIZE;
-	int prot = 0, pages;
-
-#ifdef notdef
-	if(mprotect((void *) stack, UM_KERN_PAGE_SIZE, prot) < 0)
-		panic("protecting guard page failed, errno = %d", errno);
-#endif
-	pages = (1 << UML_CONFIG_KERNEL_STACK_ORDER) - 2;
-	prot = PROT_READ | PROT_WRITE | PROT_EXEC;
-	if(mprotect((void *) stack, pages * UM_KERN_PAGE_SIZE, prot) < 0)
+	if(mprotect((void *) address, UM_THREAD_SIZE,
+		    PROT_READ | PROT_WRITE | PROT_EXEC) < 0)
 		panic("protecting stack failed, errno = %d", errno);
 }
 
@@ -72,7 +55,7 @@ int raw(int fd)
 
 	/* XXX tcsetattr could have applied only some changes
 	 * (and cfmakeraw() is a set of changes) */
-	return(0);
+	return 0;
 }
 
 void setup_machinename(char *machine_out)
Index: linux-2.6.21-mm/arch/um/include/common-offsets.h
===================================================================
--- linux-2.6.21-mm.orig/arch/um/include/common-offsets.h	2007-05-07 15:01:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/include/common-offsets.h	2007-05-08 10:05:16.000000000 -0400
@@ -28,3 +28,5 @@ DEFINE(UM_NR_CPUS, NR_CPUS);
 
 /* For crypto assembler code. */
 DEFINE(crypto_tfm_ctx_offset, offsetof(struct crypto_tfm, __crt_ctx));
+
+DEFINE(UM_THREAD_SIZE, THREAD_SIZE);
