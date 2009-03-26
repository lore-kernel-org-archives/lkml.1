Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZCZNNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZCZNNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 09:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbZCZNNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 09:13:06 -0400
Received: from mx1.emlix.com ([193.175.82.87]:46892 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbZCZNNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 09:13:04 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Piet Delaney <piet@tensilica.com>, linux-kernel@vger.kernel.org,
       linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 1/2] xtensa: use DMA zone to manage coherent dma memory
Date: Thu, 26 Mar 2009 14:14:05 +0100
Message-Id: <1238073246-23753-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the init code put all memory into the DMA zone as there are no
peripherals with address space restrictions. On the other hand there is
dma_alloc_coherent which on mmu xtensa variants makes use of fixed TLB
translations that provide an uncached mirror of the first 128MB. When the
old implementation by chance was given memory outside that region, it
called BUG().

This patch uses the DMA zone to keep memory that can be made uncached.
It calls per-variant functions (with the current behavior as weak defaults)
to determine the size of that area and to get the uncached virtual address.
On nommu variants the defaults are different, resulting in an empty DMA
zone and failing all remapping attempts.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/include/asm/dma-mapping.h      |   21 +++---
 arch/xtensa/include/asm/uncached-mapping.h |    8 ++
 arch/xtensa/kernel/pci-dma.c               |  108 ++++++++++++++++++++-------
 arch/xtensa/mm/init.c                      |   11 ++-
 4 files changed, 106 insertions(+), 42 deletions(-)
 create mode 100644 arch/xtensa/include/asm/uncached-mapping.h

diff --git a/arch/xtensa/include/asm/dma-mapping.h b/arch/xtensa/include/asm/dma-mapping.h
index 51882ae..0138f41 100644
--- a/arch/xtensa/include/asm/dma-mapping.h
+++ b/arch/xtensa/include/asm/dma-mapping.h
@@ -24,14 +24,17 @@ extern void *consistent_alloc(int, size_t, dma_addr_t, unsigned long);
 extern void consistent_free(void*, size_t, dma_addr_t);
 extern void consistent_sync(void*, size_t, int);
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
+int dma_is_consistent(struct device *dev, dma_addr_t dma_handle);
+void *dma_alloc_both(struct device *dev, size_t size,
+		     dma_addr_t *dma_handle, gfp_t flag);
+void dma_free_both(struct device *dev, size_t size,
+		   void *vaddr, dma_addr_t dma_handle);
+#define dma_alloc_noncoherent(d, s, h, f) \
+		dma_alloc_both(d, s, h, (f) & ~__GFP_DMA)
+#define dma_alloc_coherent(d, s, h, f) \
+		dma_alloc_both(d, s, h, (f) | __GFP_DMA)
+#define dma_free_noncoherent(d, s, v, h) dma_free_both(d, s, v, h)
+#define dma_free_coherent(d, s, v, h) dma_free_both(d, s, v, h)
 
 static inline dma_addr_t
 dma_map_single(struct device *dev, void *ptr, size_t size,
@@ -167,8 +170,6 @@ dma_get_cache_alignment(void)
 	return L1_CACHE_BYTES;
 }
 
-#define dma_is_consistent(d, h)	(1)
-
 static inline void
 dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 	       enum dma_data_direction direction)
diff --git a/arch/xtensa/include/asm/uncached-mapping.h b/arch/xtensa/include/asm/uncached-mapping.h
new file mode 100644
index 0000000..c995f4e
--- /dev/null
+++ b/arch/xtensa/include/asm/uncached-mapping.h
@@ -0,0 +1,8 @@
+#ifndef __XTENSA_UNCACHED_MAPPING_H
+#define __XTENSA_UNCACHED_MAPPING_H
+
+unsigned long variant_uncacheable_pages(unsigned long page);
+void *variant_map_uncached(void *cvaddr, unsigned long size);
+void *variant_unmap_uncached(void *ucvaddr, unsigned long size);
+
+#endif
diff --git a/arch/xtensa/kernel/pci-dma.c b/arch/xtensa/kernel/pci-dma.c
index f5319d7..6619155 100644
--- a/arch/xtensa/kernel/pci-dma.c
+++ b/arch/xtensa/kernel/pci-dma.c
@@ -22,58 +22,65 @@
 #include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/cacheflush.h>
+#include <asm/uncached-mapping.h>
 
 /*
- * Note: We assume that the full memory space is always mapped to 'kseg'
- *	 Otherwise we have to use page attributes (not implemented).
+ * We abuse the DMA zone to hold memory that can be made consistent.
+ * Whether this is done by remapping to a different address or by changing
+ * page attributes is left to variant specific code.
  */
+int dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
+{
+	void *vaddr = bus_to_virt(dma_handle);
+
+	if (virt_addr_valid(vaddr))
+		return (page_zonenum(virt_to_page(vaddr)) == ZONE_DMA);
+	return 0;
+}
 
 void *
-dma_alloc_coherent(struct device *dev,size_t size,dma_addr_t *handle,gfp_t flag)
+dma_alloc_both(struct device *dev, size_t size, dma_addr_t *handle, gfp_t flag)
 {
 	unsigned long ret;
-	unsigned long uncached = 0;
+	void *uncached = NULL;
 
-	/* ignore region speicifiers */
+	/* ignore region specifier */
 
-	flag &= ~(__GFP_DMA | __GFP_HIGHMEM);
+	flag &= ~__GFP_HIGHMEM;
 
-	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
-		flag |= GFP_DMA;
-	ret = (unsigned long)__get_free_pages(flag, get_order(size));
+	ret = __get_free_pages(flag, get_order(size));
 
 	if (ret == 0)
 		return NULL;
 
-	/* We currently don't support coherent memory outside KSEG */
+	memset((void *)ret, 0, size);
+	__flush_invalidate_dcache_range(ret, size);
+	*handle = virt_to_bus((void *)ret);
 
-	if (ret < XCHAL_KSEG_CACHED_VADDR
-	    || ret >= XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE)
-		BUG();
+	if (dma_is_consistent(dev, *handle)) {
+		uncached = variant_map_uncached((void *)ret, size);
+		flag |= __GFP_DMA;
+	}
 
+	if (!(flag & __GFP_DMA))
+		return (void *)ret;
 
-	if (ret != 0) {
-		memset((void*) ret, 0, size);
-		uncached = ret+XCHAL_KSEG_BYPASS_VADDR-XCHAL_KSEG_CACHED_VADDR;
-		*handle = virt_to_bus((void*)ret);
-		__flush_invalidate_dcache_range(ret, size);
-	}
+	if (!uncached)
+		free_pages(ret, get_order(size));
 
-	return (void*)uncached;
+	return uncached;
 }
 
-void dma_free_coherent(struct device *hwdev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle)
+void dma_free_both(struct device *hwdev, size_t size,
+		   void *vaddr, dma_addr_t dma_handle)
 {
-	long addr=(long)vaddr+XCHAL_KSEG_CACHED_VADDR-XCHAL_KSEG_BYPASS_VADDR;
-
-	if (addr < 0 || addr >= XCHAL_KSEG_SIZE)
-		BUG();
+	void *cached = vaddr;
 
-	free_pages(addr, get_order(size));
+	if (dma_is_consistent(hwdev, dma_handle))
+		cached = variant_unmap_uncached(vaddr, size);
+	free_pages((unsigned long)cached, get_order(size));
 }
 
-
 void consistent_sync(void *vaddr, size_t size, int direction)
 {
 	switch (direction) {
@@ -91,3 +98,48 @@ void consistent_sync(void *vaddr, size_t size, int direction)
 		break;
 	}
 }
+
+#ifdef CONFIG_MMU
+
+unsigned long __weak variant_uncacheable_pages(unsigned long page)
+{
+	const unsigned long kseg_end_page = (XCHAL_KSEG_PADDR + XCHAL_KSEG_SIZE)
+						>> PAGE_SHIFT;
+	if (page > kseg_end_page)
+		return 0;
+	return kseg_end_page - page;
+}
+
+void *__weak variant_map_uncached(void *addr, unsigned long size)
+{
+	if ((unsigned long)addr < XCHAL_KSEG_CACHED_VADDR ||
+	    (unsigned long)addr > XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE)
+		return 0;
+	return addr - XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_BYPASS_VADDR;
+}
+
+void *__weak variant_unmap_uncached(void *addr, unsigned long size)
+{
+	if ((unsigned long)addr < XCHAL_KSEG_BYPASS_VADDR ||
+	    (unsigned long)addr > XCHAL_KSEG_BYPASS_VADDR + XCHAL_KSEG_SIZE)
+		return 0;
+	return addr - XCHAL_KSEG_BYPASS_VADDR + XCHAL_KSEG_CACHED_VADDR;
+}
+
+#else
+
+unsigned long __weak variant_uncacheable_pages(unsigned long page)
+{
+	return 0;
+}
+
+void *__weak variant_map_uncached(void *addr, unsigned long size)
+{
+	return 0;
+}
+
+void *__weak variant_unmap_uncached(void *addr, unsigned long size)
+{
+	return 0;
+}
+#endif
diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index 427e14f..7eb25d2 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -26,6 +26,7 @@
 
 #include <asm/bootparam.h>
 #include <asm/page.h>
+#include <asm/uncached-mapping.h>
 
 /* References to section boundaries */
 
@@ -158,11 +159,13 @@ void __init zones_init(void)
 	unsigned long zones_size[MAX_NR_ZONES];
 	int i;
 
-	/* All pages are DMA-able, so we put them all in the DMA zone. */
-
-	zones_size[ZONE_DMA] = max_low_pfn - ARCH_PFN_OFFSET;
-	for (i = 1; i < MAX_NR_ZONES; i++)
+	for (i = 0; i < MAX_NR_ZONES; i++)
 		zones_size[i] = 0;
+	zones_size[ZONE_NORMAL] = max_low_pfn - ARCH_PFN_OFFSET;
+	zones_size[ZONE_DMA] = variant_uncacheable_pages(ARCH_PFN_OFFSET);
+	if (zones_size[ZONE_DMA] > zones_size[ZONE_NORMAL])
+		zones_size[ZONE_DMA] = zones_size[ZONE_NORMAL];
+	zones_size[ZONE_NORMAL] -= zones_size[ZONE_DMA];
 
 #ifdef CONFIG_HIGHMEM
 	zones_size[ZONE_HIGHMEM] = max_pfn - max_low_pfn;
-- 
1.6.2.107.ge47ee

