Return-Path: <linux-kernel-owner+w=401wt.eu-S933557AbZINUVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbZINUVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933531AbZINUVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:21:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54042 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501AbZINUIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 22/72] Blackfin: clean up early memory setup code
Date: Mon, 14 Sep 2009 16:07:26 -0400
Message-Id: <1252958896-25150-23-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Remove code duplication, and only print out memory warnings when they are
an actual problem.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |   60 ++++++++++++++++++++++-------------------
 1 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 6225eda..6dbf219 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -511,6 +511,7 @@ static __init void memory_setup(void)
 #ifdef CONFIG_MTD_UCLINUX
 	unsigned long mtd_phys = 0;
 #endif
+	unsigned long max_mem;
 
 	_rambase = (unsigned long)_stext;
 	_ramstart = (unsigned long)_end;
@@ -520,7 +521,22 @@ static __init void memory_setup(void)
 		panic("DMA region exceeds memory limit: %lu.",
 			_ramend - _ramstart);
 	}
-	memory_end = _ramend - DMA_UNCACHED_REGION;
+	max_mem = memory_end = _ramend - DMA_UNCACHED_REGION;
+
+#if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
+	/* Due to a Hardware Anomaly we need to limit the size of usable
+	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
+	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
+	 */
+# if (defined(CONFIG_DEBUG_HUNT_FOR_ZERO))
+	if (max_mem >= 56 * 1024 * 1024)
+		max_mem = 56 * 1024 * 1024;
+# else
+	if (max_mem >= 60 * 1024 * 1024)
+		max_mem = 60 * 1024 * 1024;
+# endif				/* CONFIG_DEBUG_HUNT_FOR_ZERO */
+#endif				/* ANOMALY_05000263 */
+
 
 #ifdef CONFIG_MPU
 	/* Round up to multiple of 4MB */
@@ -549,22 +565,16 @@ static __init void memory_setup(void)
 
 # if defined(CONFIG_ROMFS_FS)
 	if (((unsigned long *)mtd_phys)[0] == ROMSB_WORD0
-	    && ((unsigned long *)mtd_phys)[1] == ROMSB_WORD1)
+	    && ((unsigned long *)mtd_phys)[1] == ROMSB_WORD1) {
 		mtd_size =
 		    PAGE_ALIGN(be32_to_cpu(((unsigned long *)mtd_phys)[2]));
-#  if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
-	/* Due to a Hardware Anomaly we need to limit the size of usable
-	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
-	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
-	 */
-#   if (defined(CONFIG_DEBUG_HUNT_FOR_ZERO))
-	if (memory_end >= 56 * 1024 * 1024)
-		memory_end = 56 * 1024 * 1024;
-#   else
-	if (memory_end >= 60 * 1024 * 1024)
-		memory_end = 60 * 1024 * 1024;
-#   endif				/* CONFIG_DEBUG_HUNT_FOR_ZERO */
-#  endif				/* ANOMALY_05000263 */
+
+		/* ROM_FS is XIP, so if we found it, we need to limit memory */
+		if (memory_end > max_mem) {
+			pr_info("Limiting kernel memory to %liMB due to anomaly 05000263\n", max_mem >> 20);
+			memory_end = max_mem;
+		}
+	}
 # endif				/* CONFIG_ROMFS_FS */
 
 	/* Since the default MTD_UCLINUX has no magic number, we just blindly
@@ -586,20 +596,14 @@ static __init void memory_setup(void)
 	}
 #endif				/* CONFIG_MTD_UCLINUX */
 
-#if (defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) && ANOMALY_05000263)
-	/* Due to a Hardware Anomaly we need to limit the size of usable
-	 * instruction memory to max 60MB, 56 if HUNT_FOR_ZERO is on
-	 * 05000263 - Hardware loop corrupted when taking an ICPLB exception
+	/* We need lo limit memory, since everything could have a text section
+	 * of userspace in it, and expose anomaly 05000263. If the anomaly
+	 * doesn't exist, or we don't need to - then dont.
 	 */
-#if (defined(CONFIG_DEBUG_HUNT_FOR_ZERO))
-	if (memory_end >= 56 * 1024 * 1024)
-		memory_end = 56 * 1024 * 1024;
-#else
-	if (memory_end >= 60 * 1024 * 1024)
-		memory_end = 60 * 1024 * 1024;
-#endif				/* CONFIG_DEBUG_HUNT_FOR_ZERO */
-	printk(KERN_NOTICE "Warning: limiting memory to %liMB due to hardware anomaly 05000263\n", memory_end >> 20);
-#endif				/* ANOMALY_05000263 */
+	if (memory_end > max_mem) {
+		pr_info("Limiting kernel memory to %liMB due to anomaly 05000263\n", max_mem >> 20);
+		memory_end = max_mem;
+	}
 
 #ifdef CONFIG_MPU
 	page_mask_nelts = ((_ramend >> PAGE_SHIFT) + 31) / 32;
-- 
1.6.4.2

