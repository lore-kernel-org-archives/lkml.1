Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYFTOod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYFTOod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYFTOoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:44:14 -0400
Received: from anchor-post-36.mail.demon.net ([194.217.242.86]:2009 "EHLO
	anchor-post-36.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbYFTOoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:44:13 -0400
Subject: [PATCH] module: reorder struct module to save space on 64 bit
	builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: rusty@rustcorp.com.au
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 15:44:11 +0100
Message-Id: <1213973051.3047.12.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder struct module to save space on 64 bit builds.
saves 1 cacheline_size  (128 on default x86_64 & 64 on AMD
Opteron/athlon) when CONFIG_MODULE_UNLOAD=y.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---

Patch against 2.6.26-rc6. tested & running successfully on AMD64 desktop
machine. This patch reduces the data segment of each module by 1
cacheline size.

I also compiled with this patch for 32 bit & there was no change in
size.

Richard




diff --git a/include/linux/module.h b/include/linux/module.h
index 3e03b1a..63f0eb6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -249,27 +249,28 @@ struct module
 
 	/* Exported symbols */
 	const struct kernel_symbol *syms;
-	unsigned int num_syms;
 	const unsigned long *crcs;
+	unsigned int num_syms;
 
 	/* GPL-only exported symbols. */
-	const struct kernel_symbol *gpl_syms;
 	unsigned int num_gpl_syms;
+	const struct kernel_symbol *gpl_syms;
 	const unsigned long *gpl_crcs;
 
 	/* unused exported symbols. */
 	const struct kernel_symbol *unused_syms;
-	unsigned int num_unused_syms;
 	const unsigned long *unused_crcs;
+	unsigned int num_unused_syms;
+
 	/* GPL-only, unused exported symbols. */
-	const struct kernel_symbol *unused_gpl_syms;
 	unsigned int num_unused_gpl_syms;
+	const struct kernel_symbol *unused_gpl_syms;
 	const unsigned long *unused_gpl_crcs;
 
 	/* symbols that will be GPL-only in the near future. */
 	const struct kernel_symbol *gpl_future_syms;
-	unsigned int num_gpl_future_syms;
 	const unsigned long *gpl_future_crcs;
+	unsigned int num_gpl_future_syms;
 
 	/* Exception table */
 	unsigned int num_exentries;
@@ -300,23 +301,9 @@ struct module
 
 #ifdef CONFIG_GENERIC_BUG
 	/* Support for BUG */
+	unsigned num_bugs;
 	struct list_head bug_list;
 	struct bug_entry *bug_table;
-	unsigned num_bugs;
-#endif
-
-#ifdef CONFIG_MODULE_UNLOAD
-	/* Reference counts */
-	struct module_ref ref[NR_CPUS];
-
-	/* What modules depend on me? */
-	struct list_head modules_which_use_me;
-
-	/* Who is waiting for us to be unloaded */
-	struct task_struct *waiter;
-
-	/* Destruction function. */
-	void (*exit)(void);
 #endif
 
 #ifdef CONFIG_KALLSYMS
@@ -342,6 +329,21 @@ struct module
 	struct marker *markers;
 	unsigned int num_markers;
 #endif
+
+#ifdef CONFIG_MODULE_UNLOAD
+	/* What modules depend on me? */
+	struct list_head modules_which_use_me;
+
+	/* Who is waiting for us to be unloaded */
+	struct task_struct *waiter;
+
+	/* Destruction function. */
+	void (*exit)(void);
+
+	/* Reference counts */
+	struct module_ref ref[NR_CPUS];
+#endif
+
 };
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}


