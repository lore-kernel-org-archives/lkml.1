Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab0CDShA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:37:00 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62399 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517Ab0CDSg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:36:57 -0500
Subject: Re: [RFC PATCH] ARM: Assume new page cache pages have dirty D-cache
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20100304164416.GD13417@n2100.arm.linux.org.uk>
References: <20100302172947.27766.61539.stgit@e102109-lin.cambridge.arm.com>
	 <20100304164416.GD13417@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 04 Mar 2010 18:36:42 +0000
Message-ID: <1267727802.6526.545.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 18:36:43.0614 (UTC) FILETIME=[A34E9FE0:01CABBC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 16:44 +0000, Russell King - ARM Linux wrote:
> On Tue, Mar 02, 2010 at 05:34:29PM +0000, Catalin Marinas wrote:
> > There are places in Linux where writes to newly allocated page cache
> > pages happen without a subsequent call to flush_dcache_page() (several
> > PIO drivers including USB HCD). This patch changes the meaning of
> > PG_arch_1 to be PG_dcache_clean and always flush the D-cache for a newly
> > mapped page in update_mmu_cache().
> >
> > The patch also sets the PG_arch_1 bit in the DMA cache maintenance
> > function to avoid additional cache flushing in update_mmu_cache().
> ...
> >  arch/arm/include/asm/cacheflush.h |    6 +++---
> >  arch/arm/mm/copypage-v6.c         |    2 +-
> >  arch/arm/mm/dma-mapping.c         |    5 +++++
> >  arch/arm/mm/fault-armv.c          |    2 +-
> >  arch/arm/mm/flush.c               |    2 +-
> >  5 files changed, 11 insertions(+), 6 deletions(-)
> 
> Could you please send for RFC a fuller patch which covers all places that
> PG_dcache_dirty is used and/or mentioned?

ARM: Assume new page cache pages have dirty D-cache

From: Catalin Marinas <catalin.marinas@arm.com>

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
 arch/arm/include/asm/cacheflush.h |    6 +++---
 arch/arm/include/asm/tlbflush.h   |    2 +-
 arch/arm/mm/copypage-v4mc.c       |    2 +-
 arch/arm/mm/copypage-v6.c         |    2 +-
 arch/arm/mm/copypage-xscale.c     |    2 +-
 arch/arm/mm/dma-mapping.c         |    5 +++++
 arch/arm/mm/fault-armv.c          |    4 ++--
 arch/arm/mm/flush.c               |    2 +-
 8 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index ed7d289..96d666f 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -137,10 +137,10 @@
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
diff --git a/arch/arm/include/asm/tlbflush.h b/arch/arm/include/asm/tlbflush.h
index c2f1605..ccc3a2a 100644
--- a/arch/arm/include/asm/tlbflush.h
+++ b/arch/arm/include/asm/tlbflush.h
@@ -525,7 +525,7 @@ extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 #endif
 
 /*
- * if PG_dcache_dirty is set for the page, we need to ensure that any
+ * If PG_dcache_clean is not set for the page, we need to ensure that any
  * cache entries for the kernels virtual memory range are written
  * back to the page.
  */
diff --git a/arch/arm/mm/copypage-v4mc.c b/arch/arm/mm/copypage-v4mc.c
index 7370a71..34c9fe5 100644
--- a/arch/arm/mm/copypage-v4mc.c
+++ b/arch/arm/mm/copypage-v4mc.c
@@ -73,7 +73,7 @@ void v4_mc_copy_user_highpage(struct page *to, struct page *from,
 {
 	void *kto = kmap_atomic(to, KM_USER1);
 
-	if (test_and_clear_bit(PG_dcache_dirty, &from->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
 
 	spin_lock(&minicache_lock);
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
diff --git a/arch/arm/mm/copypage-xscale.c b/arch/arm/mm/copypage-xscale.c
index 76824d3..4c94ea3 100644
--- a/arch/arm/mm/copypage-xscale.c
+++ b/arch/arm/mm/copypage-xscale.c
@@ -95,7 +95,7 @@ void xscale_mc_copy_user_highpage(struct page *to, struct page *from,
 {
 	void *kto = kmap_atomic(to, KM_USER1);
 
-	if (test_and_clear_bit(PG_dcache_dirty, &from->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &from->flags))
 		__flush_dcache_page(page_mapping(from), from);
 
 	spin_lock(&minicache_lock);
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
index 8b755ff..baa5742 100644
--- a/arch/arm/mm/fault-armv.c
+++ b/arch/arm/mm/fault-armv.c
@@ -136,7 +136,7 @@ make_coherent(struct address_space *mapping, struct vm_area_struct *vma, unsigne
  * a page table, or changing an existing PTE.  Basically, there are two
  * things that we need to take care of:
  *
- *  1. If PG_dcache_dirty is set for the page, we need to ensure
+ *  1. If PG_dcache_clean is not set for the page, we need to ensure
  *     that any cache entries for the kernels virtual memory
  *     range are written back to the page.
  *  2. If we have multiple shared mappings of the same space in
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


-- 
Catalin

