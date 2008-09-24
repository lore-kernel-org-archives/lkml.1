Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbYIXLwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbYIXLwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYIXLwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:52:18 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47981 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIXLwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:52:16 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, joerg.roedel@amd.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/3] x86: export pci-nommu's alloc_coherent
Date: Wed, 24 Sep 2008 20:48:35 +0900
Message-Id: <1222256917-14321-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exports nommu_alloc_coherent (renamed
dma_generic_alloc_coherent). GART needs this function.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-dma.c     |   31 +++++++++++++++++++++++++++++++
 arch/x86/kernel/pci-nommu.c   |   39 +--------------------------------------
 include/asm-x86/dma-mapping.h |    3 +++
 3 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 23882c4..0a3824e 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -134,6 +134,37 @@ unsigned long iommu_num_pages(unsigned long addr, unsigned long len)
 EXPORT_SYMBOL(iommu_num_pages);
 #endif
 
+void *dma_generic_alloc_coherent(struct device *dev, size_t size,
+				 dma_addr_t *dma_addr, gfp_t flag)
+{
+	unsigned long dma_mask;
+	struct page *page;
+	dma_addr_t addr;
+
+	dma_mask = dma_alloc_coherent_mask(dev, flag);
+
+	flag |= __GFP_ZERO;
+again:
+	page = alloc_pages_node(dev_to_node(dev), flag, get_order(size));
+	if (!page)
+		return NULL;
+
+	addr = page_to_phys(page);
+	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
+		__free_pages(page, get_order(size));
+
+		if (dma_mask < DMA_32BIT_MASK && !(flag & GFP_DMA)) {
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
 /*
  * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
  * documentation.
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 1c1c98a..c70ab5a 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -72,43 +72,6 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	return nents;
 }
 
-static void *
-nommu_alloc_coherent(struct device *hwdev, size_t size,
-		     dma_addr_t *dma_addr, gfp_t gfp)
-{
-	unsigned long dma_mask;
-	int node;
-	struct page *page;
-	dma_addr_t addr;
-
-	dma_mask = dma_alloc_coherent_mask(hwdev, gfp);
-
-	gfp |= __GFP_ZERO;
-
-	node = dev_to_node(hwdev);
-again:
-	page = alloc_pages_node(node, gfp, get_order(size));
-	if (!page)
-		return NULL;
-
-	addr = page_to_phys(page);
-	if (!is_buffer_dma_capable(dma_mask, addr, size) && !(gfp & GFP_DMA)) {
-		free_pages((unsigned long)page_address(page), get_order(size));
-		gfp |= GFP_DMA;
-		goto again;
-	}
-
-	if (check_addr("alloc_coherent", hwdev, addr, size)) {
-		*dma_addr = addr;
-		flush_write_buffers();
-		return page_address(page);
-	}
-
-	free_pages((unsigned long)page_address(page), get_order(size));
-
-	return NULL;
-}
-
 static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 				dma_addr_t dma_addr)
 {
@@ -116,7 +79,7 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 }
 
 struct dma_mapping_ops nommu_dma_ops = {
-	.alloc_coherent = nommu_alloc_coherent,
+	.alloc_coherent = dma_generic_alloc_coherent,
 	.free_coherent = nommu_free_coherent,
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 7b0fdd6..7b9f308 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -90,6 +90,9 @@ static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 extern int dma_supported(struct device *hwdev, u64 mask);
 extern int dma_set_mask(struct device *dev, u64 mask);
 
+extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
+					dma_addr_t *dma_addr, gfp_t flag);
+
 static inline dma_addr_t
 dma_map_single(struct device *hwdev, void *ptr, size_t size,
 	       int direction)
-- 
1.5.4.2

