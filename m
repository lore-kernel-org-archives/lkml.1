Return-Path: <linux-kernel-owner+w=401wt.eu-S933073AbXBLHhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbXBLHhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933075AbXBLHhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:37:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:49594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933073AbXBLHht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:37:49 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [2/39] x86_64: Break init() in two parts to avoid MODPOST warnings
Message-Id: <20070212073748.1FF6013D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:37:48 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Vivek Goyal <vgoyal@in.ibm.com>

o init() is a non __init function in .text section but it calls many
  functions which are in .init.text section. Hence MODPOST generates lots
  of cross reference warnings on i386 if compiled with CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.text:smp_prepare_cpus from .text between 'init' (at offset 0xc0101049) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to .init.text:migration_init from .text between 'init' (at offset 0xc010104e) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to .init.text:spawn_ksoftirqd from .text between 'init' (at offset 0xc0101053) and 'rest_init'

o This patch breaks down init() in two parts. One part which can go
  in .init.text section and can be freed and other part which has to
  be non __init(init_post()). Now init() calls init_post() and init_post()
  does not call any functions present in .init sections. Hence getting
  rid of warnings.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 init/main.c |   81 +++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 36 deletions(-)

Index: linux/init/main.c
===================================================================
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -713,7 +713,49 @@ static void run_init_process(char *init_
 	kernel_execve(init_filename, argv_init, envp_init);
 }
 
-static int init(void * unused)
+/* This is a non __init function. Force it to be noinline otherwise gcc
+ * makes it inline to init() and it becomes part of init.text section
+ */
+static int noinline init_post(void)
+{
+	free_initmem();
+	unlock_kernel();
+	mark_rodata_ro();
+	system_state = SYSTEM_RUNNING;
+	numa_default_policy();
+
+	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
+		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
+
+	(void) sys_dup(0);
+	(void) sys_dup(0);
+
+	if (ramdisk_execute_command) {
+		run_init_process(ramdisk_execute_command);
+		printk(KERN_WARNING "Failed to execute %s\n",
+				ramdisk_execute_command);
+	}
+
+	/*
+	 * We try each of these until one succeeds.
+	 *
+	 * The Bourne shell can be used instead of init if we are
+	 * trying to recover a really broken machine.
+	 */
+	if (execute_command) {
+		run_init_process(execute_command);
+		printk(KERN_WARNING "Failed to execute %s.  Attempting "
+					"defaults...\n", execute_command);
+	}
+	run_init_process("/sbin/init");
+	run_init_process("/etc/init");
+	run_init_process("/bin/init");
+	run_init_process("/bin/sh");
+
+	panic("No init found.  Try passing init= option to kernel.");
+}
+
+static int __init init(void * unused)
 {
 	lock_kernel();
 	/*
@@ -761,39 +803,6 @@ static int init(void * unused)
 	 * we're essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
 	 */
-	free_initmem();
-	unlock_kernel();
-	mark_rodata_ro();
-	system_state = SYSTEM_RUNNING;
-	numa_default_policy();
-
-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
-
-	(void) sys_dup(0);
-	(void) sys_dup(0);
-
-	if (ramdisk_execute_command) {
-		run_init_process(ramdisk_execute_command);
-		printk(KERN_WARNING "Failed to execute %s\n",
-				ramdisk_execute_command);
-	}
-
-	/*
-	 * We try each of these until one succeeds.
-	 *
-	 * The Bourne shell can be used instead of init if we are 
-	 * trying to recover a really broken machine.
-	 */
-	if (execute_command) {
-		run_init_process(execute_command);
-		printk(KERN_WARNING "Failed to execute %s.  Attempting "
-					"defaults...\n", execute_command);
-	}
-	run_init_process("/sbin/init");
-	run_init_process("/etc/init");
-	run_init_process("/bin/init");
-	run_init_process("/bin/sh");
-
-	panic("No init found.  Try passing init= option to kernel.");
+	init_post();
+	return 0;
 }
