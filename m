Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZJZX3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZJZX3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZJZX3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:29:07 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:34639 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbZJZX3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:29:03 -0400
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH 1/5] dma: create dma_generic_alloc/free_coherent()
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 26 Oct 2009 17:24:58 -0600
Message-ID: <20091026232458.9646.36818.stgit@nehalem.aw>
In-Reply-To: <20091026232401.9646.90540.stgit@nehalem.aw>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move dma_generic_alloc_coherent() out of x86 code and create
corresponding dma_generic_free_coherent() for symmetry.  These
can then be used by IOMMU drivers attempting to implement
passthrough mode.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

 arch/x86/include/asm/dma-mapping.h |    3 --
 arch/x86/kernel/pci-dma.c          |   31 -------------------------
 arch/x86/kernel/pci-nommu.c        |   10 +++++++-
 include/linux/dma-mapping.h        |   44 ++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 0ee770d..e6d2c9f 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -52,9 +52,6 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 
-extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
-					dma_addr_t *dma_addr, gfp_t flag);
-
 static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
 {
 	if (!dev->dma_mask)
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b2a71dc..ecd9df0 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -144,37 +144,6 @@ void __init pci_iommu_alloc(void)
 	pci_swiotlb_init();
 }
 
-void *dma_generic_alloc_coherent(struct device *dev, size_t size,
-				 dma_addr_t *dma_addr, gfp_t flag)
-{
-	unsigned long dma_mask;
-	struct page *page;
-	dma_addr_t addr;
-
-	dma_mask = dma_alloc_coherent_mask(dev, flag);
-
-	flag |= __GFP_ZERO;
-again:
-	page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
-	if (!page)
-		return NULL;
-
-	addr = page_to_phys(page);
-	if (addr + size > dma_mask) {
-		__free_pages(page, get_order(size));
-
-		if (dma_mask < DMA_BIT_MASK(32) && !(flag & GFP_DMA)) {
-			flag = (flag & ~GFP_DMA32) | GFP_DMA;
-			goto again;
-		}
-
-		return NULL;
-	}
-
-	*dma_addr = addr;
-	return page_address(page);
-}
-
 /*
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index a3933d4..ed9e12e 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -73,10 +73,16 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	return nents;
 }
 
+static void *nommu_alloc_coherent(struct device *dev, size_t size,
+				  dma_addr_t *dma_addr, gfp_t flag)
+{
+	return dma_generic_alloc_coherent(dev, size, dma_addr, flag);
+}
+
 static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 				dma_addr_t dma_addr)
 {
-	free_pages((unsigned long)vaddr, get_order(size));
+	dma_generic_free_coherent(dev, size, vaddr, dma_addr);
 }
 
 static void nommu_sync_single_for_device(struct device *dev,
@@ -95,7 +101,7 @@ static void nommu_sync_sg_for_device(struct device *dev,
 }
 
 struct dma_map_ops nommu_dma_ops = {
-	.alloc_coherent		= dma_generic_alloc_coherent,
+	.alloc_coherent		= nommu_alloc_coherent,
 	.free_coherent		= nommu_free_coherent,
 	.map_sg			= nommu_map_sg,
 	.map_page		= nommu_map_page,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 91b7618..285043c 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -232,4 +232,48 @@ struct dma_attrs;
 
 #endif /* CONFIG_HAVE_DMA_ATTRS */
 
+static inline void *dma_generic_alloc_coherent(struct device *dev, size_t size,
+					       dma_addr_t *dma_addr, gfp_t flag)
+{
+	unsigned long dma_mask;
+	struct page *page;
+	dma_addr_t addr;
+
+	dma_mask = dev->coherent_dma_mask;
+	if (!dma_mask) {
+#ifdef CONFIG_ISA
+		dma_mask = (flag & GFP_DMA) ? DMA_BIT_MASK(24)
+		                            : DMA_BIT_MASK(32);
+#else
+		dma_mask = DMA_BIT_MASK(32);
+#endif
+	}
+
+	flag |= __GFP_ZERO;
+again:
+	page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
+	if (!page)
+		return NULL;
+
+	addr = page_to_phys(page);
+	if (addr + size > dma_mask) {
+		__free_pages(page, get_order(size));
+
+		if (dma_mask < DMA_BIT_MASK(32) && !(flag & GFP_DMA)) {
+			flag = (flag & ~GFP_DMA32) | GFP_DMA;
+			goto again;
+		}
+
+		return NULL;
+	}
+
+	*dma_addr = addr;
+	return page_address(page);
+}
+
+static inline void dma_generic_free_coherent(struct device *dev, size_t size,
+					     void *vaddr, dma_addr_t dma_addr)
+{
+	free_pages((unsigned long)vaddr, get_order(size));
+}
 #endif

