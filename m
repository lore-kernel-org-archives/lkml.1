Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbZFEIVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbZFEIVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZFEIG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37586 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbZFEIGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 47/62] Blackfin: override default uClinux MTD addr/size
Date: Fri,  5 Jun 2009 04:04:56 -0400
Message-Id: <1244189111-19639-48-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a processor anomaly (05000263 to be exact), most Blackfin parts
cannot keep the embedded filesystem image directly after the kernel in
RAM.  Instead, the filesystem needs to be relocated to the end of memory.
As such, we need to tweak the map addr/size during boot for Blackfin
systems.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/setup.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 59d9e3f..ed8452f 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -18,9 +18,12 @@
 #include <linux/tty.h>
 #include <linux/pfn.h>
 
+#ifdef CONFIG_MTD_UCLINUX
+#include <linux/mtd/map.h>
 #include <linux/ext2_fs.h>
 #include <linux/cramfs_fs.h>
 #include <linux/romfs_fs.h>
+#endif
 
 #include <asm/cplb.h>
 #include <asm/cacheflush.h>
@@ -45,6 +48,7 @@ EXPORT_SYMBOL(_ramend);
 EXPORT_SYMBOL(reserved_mem_dcache_on);
 
 #ifdef CONFIG_MTD_UCLINUX
+extern struct map_info uclinux_ram_map;
 unsigned long memory_mtd_end, memory_mtd_start, mtd_size;
 unsigned long _ebss;
 EXPORT_SYMBOL(memory_mtd_end);
@@ -535,10 +539,9 @@ static __init void memory_setup(void)
 	}
 
 	/* Relocate MTD image to the top of memory after the uncached memory area */
-	dma_memcpy((char *)memory_end, _end, mtd_size);
-
-	memory_mtd_start = memory_end;
-	_ebss = memory_mtd_start;	/* define _ebss for compatible */
+	uclinux_ram_map.phys = memory_mtd_start = memory_end;
+	uclinux_ram_map.size = mtd_size;
+	dma_memcpy((void *)uclinux_ram_map.phys, _end, uclinux_ram_map.size);
 #endif				/* CONFIG_MTD_UCLINUX */
 
 #if (defined(CONFIG_BFIN_ICACHE) && ANOMALY_05000263)
-- 
1.6.3.1

