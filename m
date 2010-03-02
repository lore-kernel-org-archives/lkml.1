Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0CBReo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:34:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55740 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344Ab0CBRem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:34:42 -0500
Subject: [RFC PATCH] ARM: Assume new page cache pages have dirty D-cache
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King <rmk@arm.linux.org.uk>
Date: Tue, 02 Mar 2010 17:34:29 +0000
Message-ID: <20100302172947.27766.61539.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-54-g1b0c0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Mar 2010 17:34:30.0154 (UTC) FILETIME=[9D2A56A0:01CABA2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are places in Linux where writes to newly allocated page cache
pages happen without a subsequent call to flush_dcache_page() (several
PIO drivers including USB HCD). This patch changes the meaning of
PG_arch_1 to be PG_dcache_clean and always flush the D-cache for a newly
mapped page in update_mmu_cache().

The patch also sets the PG_arch_1 bit in the DMA cache maintenance
function to avoid additional cache flushing in update_mmu_cache().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---

This idea came up during a long discussion on USB mass storage and ARM
cache coherency and is also the approach used on PowerPC:

http://thread.gmane.org/gmane.linux.usb.general/27072

The patch is against 2.6.33 but there maybe be some additional patches
in Linus' tree and may no apply cleanly. Anyway, at this stage it is
meant for comments.

With this patch, we may no longer need a PIO mapping API.


 arch/arm/include/asm/cacheflush.h |    6 +++---
 arch/arm/mm/copypage-v6.c         |    2 +-
 arch/arm/mm/dma-mapping.c         |    5 +++++
 arch/arm/mm/fault-armv.c          |    2 +-
 arch/arm/mm/flush.c               |    2 +-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 8113bb5..691c5b3 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -136,10 +136,10 @@
 #endif
 
 /*
- * This flag is used to indicate that the page pointed to by a pte
- * is dirty and requires cleaning before returning it to the user.
+ * This flag is used to indicate that the page pointed to by a pte is clean
+ * and does not require cleaning before returning it to the user.
  */
-#define PG_dcache_dirty PG_arch_1
+#define PG_dcache_clean PG_arch_1
 
 /*
  *	MM Cache Management
diff --git a/arch/arm/mm/copypage-v6.c b/arch/arm/mm/copypage-v6.c
index 0fa1319..7e0a050 100644
--- a/arch/arm/mm/copypage-v6.c
+++ b/arch/arm/mm/copypage-v6.c
@@ -86,7 +86,7 @@ static void v6_copy_user_highpage_aliasing(struct page *to,
 	unsigned int offset = CACHE_COLOUR(vaddr);
 	unsigned long kfrom, kto;
 
-	if (test_and_clear_bit(PG_dcache_dirty, &from->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
 
 	/* FIXME: not highmem safe */
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index dcf1ecc..105a3a9 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -478,6 +478,11 @@ static void dma_cache_maint_contiguous(struct page *page, unsigned long offset,
 
 	paddr = page_to_phys(page) + offset;
 	outer_op(paddr, paddr + size);
+
+	/*
+	 * Mark the D-cache clean for this page to avoid extra flushing.
+	 */
+	set_bit(PG_dcache_clean, &page->flags);
 }
 
 void dma_cache_maint_page(struct page *page, unsigned long offset,
diff --git a/arch/arm/mm/fault-armv.c b/arch/arm/mm/fault-armv.c
index 8b755ff..89dc1dd 100644
--- a/arch/arm/mm/fault-armv.c
+++ b/arch/arm/mm/fault-armv.c
@@ -162,7 +162,7 @@ void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 		return;
 
 	mapping = page_mapping(page);
-	if (test_and_clear_bit(PG_dcache_dirty, &page->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &page->flags))
 		__flush_dcache_page(mapping, page);
 	if (mapping) {
 		if (cache_is_vivt())
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 834db87..b829d30 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -209,7 +209,7 @@ void flush_dcache_page(struct page *page)
 
 	if (!cache_ops_need_broadcast() &&
 	    !PageHighMem(page) && mapping && !mapping_mapped(mapping))
-		set_bit(PG_dcache_dirty, &page->flags);
+		clear_bit(PG_dcache_clean, &page->flags);
 	else {
 		__flush_dcache_page(mapping, page);
 		if (mapping && cache_is_vivt())

