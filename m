Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZFEIJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZFEIJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZFEIFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37478 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbZFEIFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 07/62] Blackfin: fix data cache flushing when doing icache flushing
Date: Fri,  5 Jun 2009 04:04:16 -0400
Message-Id: <1244189111-19639-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we flush all data caches and their write buffers before flushing
icache, otherwise random edge cases could crop up where stale data is read
into icache from external memory.  As fallout, punt the combined icache +
dcache flush function since we cannot safely do them back to back -- the
SSYNC is needed between the dcache flush and the icache flush.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/include/asm/cacheflush.h |   35 ++++++++++++++-----------------
 arch/blackfin/kernel/bfin_ksyms.c      |    1 -
 arch/blackfin/mach-common/cache.S      |   16 --------------
 3 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/arch/blackfin/include/asm/cacheflush.h b/arch/blackfin/include/asm/cacheflush.h
index 1b040f5..d7726ab 100644
--- a/arch/blackfin/include/asm/cacheflush.h
+++ b/arch/blackfin/include/asm/cacheflush.h
@@ -30,7 +30,8 @@
 #ifndef _BLACKFIN_CACHEFLUSH_H
 #define _BLACKFIN_CACHEFLUSH_H
 
-extern void blackfin_icache_dcache_flush_range(unsigned long start_address, unsigned long end_address);
+#include <asm/blackfin.h>	/* for SSYNC() */
+
 extern void blackfin_icache_flush_range(unsigned long start_address, unsigned long end_address);
 extern void blackfin_dcache_flush_range(unsigned long start_address, unsigned long end_address);
 extern void blackfin_dcache_invalidate_range(unsigned long start_address, unsigned long end_address);
@@ -54,32 +55,28 @@ extern void blackfin_invalidate_entire_dcache(void);
 
 static inline void flush_icache_range(unsigned start, unsigned end)
 {
-#if defined(CONFIG_BFIN_DCACHE) && defined(CONFIG_BFIN_ICACHE)
-
-# if defined(CONFIG_BFIN_WT)
-	blackfin_icache_flush_range((start), (end));
-	flush_icache_range_others(start, end);
-# else
-	blackfin_icache_dcache_flush_range((start), (end));
-# endif
-
-#else
+#if defined(CONFIG_BFIN_WB)
+	blackfin_dcache_flush_range(start, end);
+#endif
 
-# if defined(CONFIG_BFIN_ICACHE)
-	blackfin_icache_flush_range((start), (end));
+	/* Make sure all write buffers in the data side of the core
+	 * are flushed before trying to invalidate the icache.  This
+	 * needs to be after the data flush and before the icache
+	 * flush so that the SSYNC does the right thing in preventing
+	 * the instruction prefetcher from hitting things in cached
+	 * memory at the wrong time -- it runs much further ahead than
+	 * the pipeline.
+	 */
+	SSYNC();
+#if defined(CONFIG_BFIN_ICACHE)
+	blackfin_icache_flush_range(start, end);
 	flush_icache_range_others(start, end);
-# endif
-# if defined(CONFIG_BFIN_DCACHE)
-	blackfin_dcache_flush_range((start), (end));
-# endif
-
 #endif
 }
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len)		\
 do { memcpy(dst, src, len);						\
      flush_icache_range((unsigned) (dst), (unsigned) (dst) + (len));	\
-     flush_icache_range_others((unsigned long) (dst), (unsigned long) (dst) + (len));\
 } while (0)
 
 #define copy_from_user_page(vma, page, vaddr, dst, src, len)	memcpy(dst, src, len)
diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index 01f917d..53e893f 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -16,7 +16,6 @@ EXPORT_SYMBOL(bfin_return_from_exception);
 
 /* All the Blackfin cache functions: mach-common/cache.S */
 EXPORT_SYMBOL(blackfin_dcache_invalidate_range);
-EXPORT_SYMBOL(blackfin_icache_dcache_flush_range);
 EXPORT_SYMBOL(blackfin_icache_flush_range);
 EXPORT_SYMBOL(blackfin_dcache_flush_range);
 EXPORT_SYMBOL(blackfin_dflush_page);
diff --git a/arch/blackfin/mach-common/cache.S b/arch/blackfin/mach-common/cache.S
index aa0648c..c295e8f 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -80,22 +80,6 @@ ENTRY(_blackfin_icache_flush_range)
 	do_flush IFLUSH, , nop
 ENDPROC(_blackfin_icache_flush_range)
 
-/* Flush all cache lines assocoiated with this area of memory. */
-ENTRY(_blackfin_icache_dcache_flush_range)
-/*
- * Walkaround to avoid loading wrong instruction after invalidating icache
- * and following sequence is met.
- *
- * 1) One instruction address is cached in the instruction cache.
- * 2) This instruction in SDRAM is changed.
- * 3) IFLASH[P0] is executed only once in blackfin_icache_flush_range().
- * 4) This instruction is executed again, but the old one is loaded.
- */
-	P0 = R0;
-	IFLUSH[P0];
-	do_flush FLUSH, IFLUSH
-ENDPROC(_blackfin_icache_dcache_flush_range)
-
 /* Throw away all D-cached data in specified region without any obligation to
  * write them back.  Since the Blackfin ISA does not have an "invalidate"
  * instruction, we use flush/invalidate.  Perhaps as a speed optimization we
-- 
1.6.3.1

