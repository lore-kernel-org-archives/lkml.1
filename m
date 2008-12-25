Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbYLYMU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbYLYMU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 07:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYLYMUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 07:20:51 -0500
Received: from ozlabs.org ([203.10.76.45]:41428 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYLYMUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 07:20:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH] param: start_kernel_with_args()
Date: Thu, 25 Dec 2008 22:50:44 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Hugh Dickins <hugh@veritas.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Luck, Tony" <tony.luck@intel.com>
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <20081223143327.GF29151@elte.hu> <200812252247.12957.rusty@rustcorp.com.au>
In-Reply-To: <200812252247.12957.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812252250.45071.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cute corollary of the cleanup patches.  IA64 could particularly
benefit I think.

Impact: cleanup, new API

This gives a nicer entry point for archs to start_kernel; they don't
have to use boot_command_line (though they can if they want).

A nice side effect is that archs which use this entry point don't have
a COMMAND_LINE_SIZE limit any more (and if you don't define it,
boot_command_line does not exist).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/start_kernel.h b/include/linux/start_kernel.h
--- a/include/linux/start_kernel.h
+++ b/include/linux/start_kernel.h
@@ -7,6 +7,13 @@
 /* Define the prototype for start_kernel here, rather than cluttering
    up something else. */
 
+/*
+ * Command-line pointer must be writable, must be NUL-terminated, but
+ * has no length limit and may be __initdata.
+ */
+extern asmlinkage void __init start_kernel_with_args(char *cmdline);
+
+/* Old entry point: calls arch_get_boot_command_line(). */
 extern asmlinkage void __init start_kernel(void);
 
 #endif /* _LINUX_START_KERNEL_H */
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -119,8 +119,11 @@ void (*late_time_init)(void);
 void (*late_time_init)(void);
 extern void softirq_init(void);
 
+#ifdef COMMAND_LINE_SIZE
 /* Untouched command line saved by arch-specific code. */
 char __initdata boot_command_line[COMMAND_LINE_SIZE];
+#endif
+
 /* Untouched saved command line (eg. for /proc) */
 char *saved_command_line;
 
@@ -522,15 +525,22 @@ void __init __weak thread_info_cache_ini
 {
 }
 
+#ifdef COMMAND_LINE_SIZE
 asmlinkage void __init start_kernel(void)
+{
+	arch_get_boot_command_line();
+	start_kernel_with_args(boot_command_line);
+}
+#endif
+
+asmlinkage void __init start_kernel_with_args(char *cmdline)
 {
 	char *static_command_line;
 
 	printk(KERN_NOTICE);
 	printk(linux_banner);
 
-	arch_get_boot_command_line();
-	parse_args("Core and early params", boot_command_line,
+	parse_args("Core and early params", cmdline,
 		   __start___core_param,
 		   __stop___core_param - __start___core_param,
 		   do_early_param, true);
@@ -579,10 +589,10 @@ asmlinkage void __init start_kernel(void
 	preempt_disable();
 	build_all_zonelists();
 	page_alloc_init();
-	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
+	printk(KERN_NOTICE "Kernel command line: %s\n", cmdline);
 	/* param parsing can keep pointers to the commandline. */
-	static_command_line = alloc_bootmem(strlen(boot_command_line)+1);
-	strcpy(static_command_line, boot_command_line);
+	static_command_line = alloc_bootmem(strlen(cmdline)+1);
+	strcpy(static_command_line, cmdline);
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption, false);
@@ -684,7 +694,7 @@ asmlinkage void __init start_kernel(void
 
 	ftrace_init();
 
-	saved_command_line = kstrdup(boot_command_line, GFP_KERNEL);
+	saved_command_line = kstrdup(cmdline, GFP_KERNEL);
 
 	/* Do the rest non-__init'ed, we're now alive */
 	rest_init();
