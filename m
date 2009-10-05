Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZJEAzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZJEAzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbZJEAza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:55:30 -0400
Received: from mail.perches.com ([173.55.12.10]:1729 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219AbZJEAzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:19 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 13/21] testmmiotrace.c: Add and use pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:40 -0700
Message-Id: <3bb66cc7f85f77b9416902e1be7076f7e3f4ad48.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Strip MODULE_NAME from pr_<level>s
Remove MODULE_NAME definition

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/mm/testmmiotrace.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
index 427fd1b..8565d94 100644
--- a/arch/x86/mm/testmmiotrace.c
+++ b/arch/x86/mm/testmmiotrace.c
@@ -1,12 +1,13 @@
 /*
  * Written by Pekka Paalanen, 2008-2009 <pq@iki.fi>
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/mmiotrace.h>
 
-#define MODULE_NAME "testmmiotrace"
-
 static unsigned long mmio_address;
 module_param(mmio_address, ulong, 0);
 MODULE_PARM_DESC(mmio_address, " Start address of the mapping of 16 kB "
@@ -30,7 +31,7 @@ static unsigned v32(unsigned i)
 static void do_write_test(void __iomem *p)
 {
 	unsigned int i;
-	pr_info(MODULE_NAME ": write test.\n");
+	pr_info("write test.\n");
 	mmiotrace_printk("Write test.\n");
 
 	for (i = 0; i < 256; i++)
@@ -47,7 +48,7 @@ static void do_read_test(void __iomem *p)
 {
 	unsigned int i;
 	unsigned errs[3] = { 0 };
-	pr_info(MODULE_NAME ": read test.\n");
+	pr_info("read test.\n");
 	mmiotrace_printk("Read test.\n");
 
 	for (i = 0; i < 256; i++)
@@ -68,7 +69,7 @@ static void do_read_test(void __iomem *p)
 
 static void do_read_far_test(void __iomem *p)
 {
-	pr_info(MODULE_NAME ": read far test.\n");
+	pr_info("read far test.\n");
 	mmiotrace_printk("Read far test.\n");
 
 	ioread32(p + read_far);
@@ -78,7 +79,7 @@ static void do_test(unsigned long size)
 {
 	void __iomem *p = ioremap_nocache(mmio_address, size);
 	if (!p) {
-		pr_err(MODULE_NAME ": could not ioremap, aborting.\n");
+		pr_err("could not ioremap, aborting.\n");
 		return;
 	}
 	mmiotrace_printk("ioremap returned %p.\n", p);
@@ -94,24 +95,22 @@ static int __init init(void)
 	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
 
 	if (mmio_address == 0) {
-		pr_err(MODULE_NAME ": you have to use the module argument "
-							"mmio_address.\n");
-		pr_err(MODULE_NAME ": DO NOT LOAD THIS MODULE UNLESS"
-				" YOU REALLY KNOW WHAT YOU ARE DOING!\n");
+		pr_err("you have to use the module argument mmio_address.\n");
+		pr_err("DO NOT LOAD THIS MODULE UNLESS YOU REALLY KNOW WHAT YOU ARE DOING!\n");
 		return -ENXIO;
 	}
 
-	pr_warning(MODULE_NAME ": WARNING: mapping %lu kB @ 0x%08lx in PCI "
-		"address space, and writing 16 kB of rubbish in there.\n",
-		 size >> 10, mmio_address);
+	pr_warning("WARNING: mapping %lu kB @ 0x%08lx in PCI address space, "
+		   "and writing 16 kB of rubbish in there.\n",
+		   size >> 10, mmio_address);
 	do_test(size);
-	pr_info(MODULE_NAME ": All done.\n");
+	pr_info("All done.\n");
 	return 0;
 }
 
 static void __exit cleanup(void)
 {
-	pr_debug(MODULE_NAME ": unloaded.\n");
+	pr_debug("unloaded.\n");
 }
 
 module_init(init);
-- 
1.6.3.1.10.g659a0.dirty

