Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbZCMRFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbZCMRFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759753AbZCMRBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:01:20 -0400
Received: from gw.goop.org ([64.81.55.164]:57425 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759004AbZCMRBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:01:19 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 15/27] xen/swiotlb: use dma_alloc_from_coherent to get device coherent memory
Date: Fri, 13 Mar 2009 10:00:00 -0700
Message-Id: <1236963612-14287-16-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

This avoids the previous hack of replicating struct dma_coherent_mem.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/pci/xen-iommu.c |   39 ++++++++-------------------------------
 1 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 80bb7ed..608b8e2 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -36,14 +36,6 @@ do {							\
 	(unsigned long long)addr + size);		\
 } while (0)
 
-struct dma_coherent_mem {
-	void		*virt_base;
-	u32		device_base;
-	int		size;
-	int		flags;
-	unsigned long	*bitmap;
-};
-
 static int max_dma_bits = 32;
 
 void xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
@@ -200,7 +192,6 @@ static void *xen_alloc_coherent(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp)
 {
 	void *ret;
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	unsigned int order = get_order(size);
 	unsigned long vstart;
 	u64 mask;
@@ -208,18 +199,8 @@ static void *xen_alloc_coherent(struct device *dev, size_t size,
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
-	if (mem) {
-		int page = bitmap_find_free_region(mem->bitmap, mem->size,
-						     order);
-		if (page >= 0) {
-			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
-			ret = mem->virt_base + (page << PAGE_SHIFT);
-			memset(ret, 0, size);
-			return ret;
-		}
-		if (mem->flags & DMA_MEMORY_EXCLUSIVE)
-			return NULL;
-	}
+	if (dma_alloc_from_coherent(dev, size, dma_handle, &ret))
+		return ret;
 
 	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
 		gfp |= GFP_DMA;
@@ -245,19 +226,15 @@ static void *xen_alloc_coherent(struct device *dev, size_t size,
 }
 
 static void xen_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_addr)
+			      void *vaddr, dma_addr_t dma_addr)
 {
-	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
 	int order = get_order(size);
 
-	if (mem && vaddr >= mem->virt_base &&
-	    vaddr < (mem->virt_base + (mem->size << PAGE_SHIFT))) {
-		int page = (vaddr - mem->virt_base) >> PAGE_SHIFT;
-		bitmap_release_region(mem->bitmap, page, order);
-	} else {
-		xen_destroy_contiguous_region((unsigned long)vaddr, order);
-		free_pages((unsigned long)vaddr, order);
-	}
+	if (dma_release_from_coherent(dev, order, vaddr))
+		return;
+
+	xen_destroy_contiguous_region((unsigned long)vaddr, order);
+	free_pages((unsigned long)vaddr, order);
 }
 
 static dma_addr_t xen_map_page(struct device *dev, struct page *page,
-- 
1.6.0.6

