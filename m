Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXDEAiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXDEAiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDEAiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:38:22 -0400
Received: from [198.99.130.12] ([198.99.130.12]:50393 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbXDEAiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:38:21 -0400
Date: Wed, 4 Apr 2007 20:34:03 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 3/4] UML - Comment early boot locking
Message-ID: <20070405003403.GA13280@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commentary about missing locking.

Also got rid of uml_start because it was pointless.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/um_arch.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/um_arch.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/um_arch.c	2007-04-02 13:04:27.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/um_arch.c	2007-04-02 15:10:06.000000000 -0400
@@ -44,7 +44,7 @@
 
 #define DEFAULT_COMMAND_LINE "root=98:0"
 
-/* Changed in linux_main and setup_arch, which run before SMP is started */
+/* Changed in add_arg and setup_arch, which run before SMP is started */
 static char __initdata command_line[COMMAND_LINE_SIZE] = { 0 };
 
 static void __init add_arg(char *arg)
@@ -58,7 +58,12 @@ static void __init add_arg(char *arg)
 	strcat(command_line, arg);
 }
 
-struct cpuinfo_um boot_cpu_data = { 
+/*
+ * These fields are initialized at boot time and not changed.
+ * XXX This structure is used only in the non-SMP case.  Maybe this
+ * should be moved to smp.c.
+ */
+struct cpuinfo_um boot_cpu_data = {
 	.loops_per_jiffy	= 0,
 	.ipi_pipe		= { -1, -1 }
 };
@@ -119,14 +124,12 @@ const struct seq_operations cpuinfo_op =
 /* Set in linux_main */
 unsigned long host_task_size;
 unsigned long task_size;
-
-unsigned long uml_start;
-
-/* Set in early boot */
 unsigned long uml_physmem;
-unsigned long uml_reserved;
+unsigned long uml_reserved; /* Also modified in mem_init */
 unsigned long start_vm;
 unsigned long end_vm;
+
+/* Set in uml_ncpus_setup */
 int ncpus = 1;
 
 #ifdef CONFIG_CMDLINE_ON_HOST
@@ -140,6 +143,8 @@ static char *argv1_end = NULL;
 
 /* Set in early boot */
 static int have_root __initdata = 0;
+
+/* Set in uml_mem_setup and modified in linux_main */
 long long physmem_size = 32 * 1024 * 1024;
 
 void set_cmdline(char *cmd)
@@ -378,7 +383,6 @@ int __init linux_main(int argc, char **a
 
 	printf("UML running in %s mode\n", mode);
 
-	uml_start = (unsigned long) &__binary_start;
 	host_task_size = CHOOSE_MODE_PROC(set_task_sizes_tt,
 					  set_task_sizes_skas, &task_size);
 
@@ -400,7 +404,7 @@ int __init linux_main(int argc, char **a
 		physmem_size += UML_ROUND_UP(brk_start) - UML_ROUND_UP(&_end);
 	}
 
-	uml_physmem = uml_start & PAGE_MASK;
+	uml_physmem = (unsigned long) &__binary_start & PAGE_MASK;
 
 	/* Reserve up to 4M after the current brk */
 	uml_reserved = ROUND_4M(brk_start) + (1 << 22);
