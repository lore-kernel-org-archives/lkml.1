Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYLAM62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYLAM62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbYLAM5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:57:07 -0500
Received: from ozlabs.org ([203.10.76.45]:44084 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956AbYLAM5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:57:05 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 23:26:59 +1030
Subject: [RFC 8/8] params: don't use alloc_bootmem for saved_command_line
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012327.00134.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We only need it for /proc, so just use kstrdup().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 init/main.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -123,8 +123,6 @@ char __initdata boot_command_line[COMMAN
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
 /* Untouched saved command line (eg. for /proc) */
 char *saved_command_line;
-/* Command line for parameter parsing */
-static char *static_command_line;
 
 static char *execute_command;
 static char *ramdisk_execute_command;
@@ -453,20 +451,6 @@ static void __init smp_init(void)
 #endif
 
 /*
- * We need to store the untouched command line for future reference.
- * We also need to store the touched command line since the parameter
- * parsing is performed in place, and we should allow a component to
- * store reference of name/value for future reference.
- */
-static void __init setup_command_line(void)
-{
-	saved_command_line = alloc_bootmem(strlen (boot_command_line)+1);
-	static_command_line = alloc_bootmem(strlen (boot_command_line)+1);
-	strcpy (saved_command_line, boot_command_line);
-	strcpy (static_command_line, boot_command_line);
-}
-
-/*
  * We need to finalize in a non-__init function or else race conditions
  * between the root thread and the init thread may cause start_kernel to
  * be reaped by free_initmem before the root thread has proceeded to
@@ -547,6 +531,8 @@ void __init __weak arch_get_boot_command
 /* Ideally, this would take a 'const char *cmdline' param. */
 asmlinkage void __init start_kernel(void)
 {
+	char *static_command_line;
+
 	arch_get_boot_command_line();
 	parse_args("Core params", boot_command_line, __start___core_param,
 		   __stop___core_param - __start___core_param,
@@ -582,7 +568,6 @@ asmlinkage void __init start_kernel(void
 	printk(linux_banner);
 	setup_arch();
 	mm_init_owner(&init_mm, &init_task);
-	setup_command_line();
 
 	unwind_setup();
 	setup_per_cpu_areas();
@@ -603,6 +588,9 @@ asmlinkage void __init start_kernel(void
 	build_all_zonelists();
 	page_alloc_init();
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
+	/* param parsing can keep pointers to the commandline. */
+	static_command_line = alloc_bootmem(strlen(boot_command_line)+1);
+	strcpy(static_command_line, boot_command_line);
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption, false);
@@ -704,6 +692,8 @@ asmlinkage void __init start_kernel(void
 
 	ftrace_init();
 
+	saved_command_line = kstrdup(boot_command_line, GFP_KERNEL);
+
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
 }


