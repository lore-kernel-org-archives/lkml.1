Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab0BYUNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:13:39 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:15098 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab0BYUNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:13:38 -0500
X-Spam-Processed: digidescorp.com, Thu, 25 Feb 2010 14:13:36 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1672ac1db0=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: microblaze-uclinux@itee.uq.edu.au
Cc: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       "Steven J. Magnani" <steve@digidescorp.com>
Subject: [RFC] microblaze: Support FRAME_POINTER for better backtrace
Date: Thu, 25 Feb 2010 14:13:29 -0600
Message-Id: <1267128809-22749-1-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a FRAME_POINTER option and when it is enabled, use frame pointers
to walk the stack during a backtrace dump. This eliminates printout of
confusing "function calls" corresponding to stack values that look like they
might be return addresses, but aren't.

This patch is dependent upon
   [PATCH] microblaze: Begin stack dump with caller of dump_stack()

I'm not certain whether the MMU compiler generates frame pointers the same
way as the noMMU compiler I am using. I'm also not sure what all the 
ramifications of providing FRAME_POINTER are. It looks like tracing 
functionality makes use of it. Need someone familiar with these areas
to comment on the patch.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
--- a/arch/microblaze/Kconfig.debug	2010-02-25 13:52:30.000000000 -0600
+++ b/arch/microblaze/Kconfig.debug	2010-02-25 13:52:49.000000000 -0600
@@ -26,4 +26,11 @@ config DEBUG_BOOTMEM
 	depends on DEBUG_KERNEL
 	bool "Debug BOOTMEM initialization"
 
+config FRAME_POINTER
+	bool "Use frame pointers"
+	default n
+	help
+	  If you say N here, the resulting kernel will be slightly smaller and
+	  faster. However, stack dumps will be much harder to interpret.
+
 endmenu
diff -uprN a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
--- a/arch/microblaze/kernel/traps.c	2010-02-25 13:50:00.000000000 -0600
+++ b/arch/microblaze/kernel/traps.c	2010-02-25 13:51:11.000000000 -0600
@@ -8,6 +8,7 @@
  * for more details.
  */
 
+#include <generated/autoconf.h>
 #include <linux/kernel.h>
 #include <linux/kallsyms.h>
 #include <linux/module.h>
@@ -44,7 +45,7 @@ void show_trace(struct task_struct *task
 	printk(KERN_NOTICE "\n");
 #endif
 	while (!kstack_end(stack)) {
-		addr = *stack++;
+		addr = *stack;
 		/*
 		 * If the address is either in the text segment of the
 		 * kernel, or in the region which contains vmalloc'ed
@@ -55,6 +56,13 @@ void show_trace(struct task_struct *task
 		 */
 		if (kernel_text_address(addr))
 			print_ip_sym(addr);
+
+#if defined(CONFIG_FRAME_POINTER)
+		/* Fetch the caller's frame pointer */
+		stack = (unsigned long *) stack[7];
+#else
+		stack++;
+#endif
 	}
 	printk(KERN_NOTICE "\n");
 

