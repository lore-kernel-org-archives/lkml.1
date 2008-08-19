Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYHSOf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYHSOf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbYHSOdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:33:18 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:63437 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYHSOdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:33:17 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K5UR2L-04-SOX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/8] x86: cleanup dma_*_coherent functions
Date: Tue, 19 Aug 2008 16:32:44 +0200
Message-ID: <1219156366-32498-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0672 (UTC) FILETIME=[72DB0500:01C90208]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All dma_ops implementations support the alloc_coherent and free_coherent
callbacks now. This allows a big simplification of the dma_alloc_coherent
function which is done with this patch. The dma_free_coherent functions is also
cleaned up and calls now the free_coherent callback of the dma_ops
implementation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-dma.c |  121 +++++----------------------------------------
 1 files changed, 12 insertions(+), 109 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index f704cb5..514f3b8 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -241,33 +241,15 @@ int dma_supported(struct device *dev, u64 mask)
 }
 EXPORT_SYMBOL(dma_supported);
 
-/* Allocate DMA memory on node near device */
-static noinline struct page *
-dma_alloc_pages(struct device *dev, gfp_t gfp, unsigned order)
-{
-	int node;
-
-	node = dev_to_node(dev);
-
-	return alloc_pages_node(node, gfp, order);
-}
-
 /*
  * Allocate memory for a coherent mapping.
  */
-void *
+	void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		   gfp_t gfp)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
-	void *memory = NULL;
-	struct page *page;
-	unsigned long dma_mask = 0;
-	dma_addr_t bus;
-	int noretry = 0;
-
-	/* ignore region specifiers */
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
+	void *memory;
 
 	if (dma_alloc_from_coherent(dev, size, dma_handle, &memory))
 		return memory;
@@ -276,89 +258,10 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		dev = &fallback_dev;
 		gfp |= GFP_DMA;
 	}
-	dma_mask = dev->coherent_dma_mask;
-	if (dma_mask == 0)
-		dma_mask = (gfp & GFP_DMA) ? DMA_24BIT_MASK : DMA_32BIT_MASK;
-
-	/* Device not DMA able */
-	if (dev->dma_mask == NULL)
-		return NULL;
-
-	/* Don't invoke OOM killer or retry in lower 16MB DMA zone */
-	if (gfp & __GFP_DMA)
-		noretry = 1;
-
-#ifdef CONFIG_X86_64
-	/* Why <=? Even when the mask is smaller than 4GB it is often
-	   larger than 16MB and in this case we have a chance of
-	   finding fitting memory in the next higher zone first. If
-	   not retry with true GFP_DMA. -AK */
-	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
-		gfp |= GFP_DMA32;
-		if (dma_mask < DMA_32BIT_MASK)
-			noretry = 1;
-	}
-#endif
 
- again:
-	page = dma_alloc_pages(dev,
-		noretry ? gfp | __GFP_NORETRY : gfp, get_order(size));
-	if (page == NULL)
-		return NULL;
-
-	{
-		int high, mmu;
-		bus = page_to_phys(page);
-		memory = page_address(page);
-		high = (bus + size) >= dma_mask;
-		mmu = high;
-		if (force_iommu && !(gfp & GFP_DMA))
-			mmu = 1;
-		else if (high) {
-			free_pages((unsigned long)memory,
-				   get_order(size));
-
-			/* Don't use the 16MB ZONE_DMA unless absolutely
-			   needed. It's better to use remapping first. */
-			if (dma_mask < DMA_32BIT_MASK && !(gfp & GFP_DMA)) {
-				gfp = (gfp & ~GFP_DMA32) | GFP_DMA;
-				goto again;
-			}
-
-			/* Let low level make its own zone decisions */
-			gfp &= ~(GFP_DMA32|GFP_DMA);
-
-			if (ops->alloc_coherent)
-				return ops->alloc_coherent(dev, size,
-							   dma_handle, gfp);
-			return NULL;
-		}
-
-		memset(memory, 0, size);
-		if (!mmu) {
-			*dma_handle = bus;
-			return memory;
-		}
-	}
-
-	if (ops->alloc_coherent) {
-		free_pages((unsigned long)memory, get_order(size));
-		gfp &= ~(GFP_DMA|GFP_DMA32);
-		return ops->alloc_coherent(dev, size, dma_handle, gfp);
-	}
-
-	if (ops->map_simple) {
-		*dma_handle = ops->map_simple(dev, virt_to_phys(memory),
-					      size,
-					      PCI_DMA_BIDIRECTIONAL);
-		if (*dma_handle != bad_dma_address)
-			return memory;
-	}
-
-	if (panic_on_overflow)
-		panic("dma_alloc_coherent: IOMMU overflow by %lu bytes\n",
-		      (unsigned long)size);
-	free_pages((unsigned long)memory, get_order(size));
+	if (ops->alloc_coherent)
+		return ops->alloc_coherent(dev, size,
+				dma_handle, gfp);
 	return NULL;
 }
 EXPORT_SYMBOL(dma_alloc_coherent);
@@ -368,17 +271,17 @@ EXPORT_SYMBOL(dma_alloc_coherent);
  * The caller must ensure that the device has finished accessing the mapping.
  */
 void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t bus)
+		       void *vaddr, dma_addr_t bus)
 {
 	struct dma_mapping_ops *ops = get_dma_ops(dev);
 
-	int order = get_order(size);
-	WARN_ON(irqs_disabled());	/* for portability */
-	if (dma_release_from_coherent(dev, order, vaddr))
+	WARN_ON(irqs_disabled());       /* for portability */
+
+	if (dma_release_from_coherent(dev, get_order(size), vaddr))
 		return;
-	if (ops->unmap_single)
-		ops->unmap_single(dev, bus, size, 0);
-	free_pages((unsigned long)vaddr, order);
+
+	if (ops->free_coherent)
+		ops->free_coherent(dev, size, vaddr, bus);
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
-- 
1.5.3.7


