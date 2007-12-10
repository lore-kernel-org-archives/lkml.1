Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbXLJSBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbXLJSBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXLJSBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:01:06 -0500
Received: from [198.99.130.12] ([198.99.130.12]:55203 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756097AbXLJSBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:01:04 -0500
Date: Mon, 10 Dec 2007 13:00:09 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       caker@linode.com
Subject: [PATCH 4/5] UML - Install panic notifier earlier
Message-ID: <20071210180009.GA9338@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that if there's a panic early enough, UML will just sit
there in the LED-blinking loop because the panic notifier hadn't been
installed yet.

This patch installs it earlier.

It also fixes the problem which exposed the hang, namely that if you
give UML a zero-sized initrd, it will ask alloc_bootmem for zero
bytes, and that will cause the panic.

While I was in initrd.c, I gave it a style makeover.

Prompted by checkpatch, I moved a couple extern declarations of
uml_exitcode to kern_util.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/include/kern_util.h |    2 ++
 arch/um/kernel/initrd.c     |   29 ++++++++++++++++++++---------
 arch/um/kernel/um_arch.c    |   41 ++++++++++++++++++++---------------------
 arch/um/os-Linux/main.c     |    2 --
 4 files changed, 42 insertions(+), 32 deletions(-)

Index: linux-2.6-git/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/um_arch.c	2007-12-07 17:19:58.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/um_arch.c	2007-12-07 17:31:32.000000000 -0500
@@ -223,6 +223,23 @@ static void __init uml_postsetup(void)
 	return;
 }
 
+static int panic_exit(struct notifier_block *self, unsigned long unused1,
+		      void *unused2)
+{
+	bust_spinlocks(1);
+	show_regs(&(current->thread.regs));
+	bust_spinlocks(0);
+	uml_exitcode = 1;
+	os_dump_core();
+	return 0;
+}
+
+static struct notifier_block panic_exit_notifier = {
+	.notifier_call 		= panic_exit,
+	.next 			= NULL,
+	.priority 		= 0
+};
+
 /* Set during early boot */
 unsigned long task_size;
 EXPORT_SYMBOL(task_size);
@@ -336,6 +353,9 @@ int __init linux_main(int argc, char **a
 		printf("Kernel virtual memory size shrunk to %lu bytes\n",
 		       virtmem_size);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &panic_exit_notifier);
+
 	uml_postsetup();
 
 	stack_protections((unsigned long) &init_thread_info);
@@ -344,29 +364,8 @@ int __init linux_main(int argc, char **a
 	return start_uml();
 }
 
-extern int uml_exitcode;
-
-static int panic_exit(struct notifier_block *self, unsigned long unused1,
-		      void *unused2)
-{
-	bust_spinlocks(1);
-	show_regs(&(current->thread.regs));
-	bust_spinlocks(0);
-	uml_exitcode = 1;
-	os_dump_core();
-	return 0;
-}
-
-static struct notifier_block panic_exit_notifier = {
-	.notifier_call 		= panic_exit,
-	.next 			= NULL,
-	.priority 		= 0
-};
-
 void __init setup_arch(char **cmdline_p)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&panic_exit_notifier);
 	paging_init();
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
Index: linux-2.6-git/arch/um/kernel/initrd.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/initrd.c	2007-12-07 14:35:55.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/initrd.c	2007-12-07 17:26:58.000000000 -0500
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -20,18 +20,27 @@ static int __init read_initrd(void)
 	long long size;
 	int err;
 
-	if(initrd == NULL)
+	if (initrd == NULL)
 		return 0;
 
 	err = os_file_size(initrd, &size);
-	if(err)
+	if (err)
 		return 0;
 
+	/*
+	 * This is necessary because alloc_bootmem craps out if you
+	 * ask for no memory.
+	 */
+	if (size == 0) {
+		printk(KERN_ERR "\"%\" is a zero-size initrd\n");
+		return 0;
+	}
+
 	area = alloc_bootmem(size);
-	if(area == NULL)
+	if (area == NULL)
 		return 0;
 
-	if(load_initrd(initrd, area, size) == -1)
+	if (load_initrd(initrd, area, size) == -1)
 		return 0;
 
 	initrd_start = (unsigned long) area;
@@ -58,13 +67,15 @@ int load_initrd(char *filename, void *bu
 	int fd, n;
 
 	fd = os_open_file(filename, of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("Opening '%s' failed - err = %d\n", filename, -fd);
+	if (fd < 0) {
+		printk(KERN_ERR "Opening '%s' failed - err = %d\n", filename,
+		       -fd);
 		return -1;
 	}
 	n = os_read_file(fd, buf, size);
-	if(n != size){
-		printk("Read of %d bytes from '%s' failed, err = %d\n", size,
+	if (n != size) {
+		printk(KERN_ERR "Read of %d bytes from '%s' failed, "
+		       "err = %d\n", size,
 		       filename, -n);
 		return -1;
 	}
Index: linux-2.6-git/arch/um/include/kern_util.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/kern_util.h	2007-12-07 14:35:55.000000000 -0500
+++ linux-2.6-git/arch/um/include/kern_util.h	2007-12-07 17:31:42.000000000 -0500
@@ -9,6 +9,8 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/faultinfo.h"
 
+extern int uml_exitcode;
+
 extern int ncpus;
 extern int kmalloc_ok;
 extern int nsyscalls;
Index: linux-2.6-git/arch/um/os-Linux/main.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/main.c	2007-12-07 14:35:54.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/main.c	2007-12-07 17:32:25.000000000 -0500
@@ -111,8 +111,6 @@ static void setup_env_path(void)
 	}
 }
 
-extern int uml_exitcode;
-
 extern void scan_elf_aux( char **envp);
 
 int __init main(int argc, char **argv, char **envp)
