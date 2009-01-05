Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbZAEOxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbZAEOxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZAEOv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:51:29 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:57853 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbZAEOv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:51:28 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 4/8] calgary: add map_page and unmap_page
Date: Mon,  5 Jan 2009 23:47:24 +0900
Message-Id: <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of struct dma_mapping_ops unification. We use
map_page and unmap_page instead of map_single and unmap_single.

We will remove map_single and unmap_single hooks in the last patch in
this patchset.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86/kernel/pci-calgary_64.c |   35 +++++++++++++++++++++++++++--------
 1 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index d28bbdc..e33cfcf 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -445,10 +445,12 @@ error:
 	return 0;
 }
 
-static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
-	size_t size, int direction)
+static dma_addr_t calgary_map_page(struct device *dev, struct page *page,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction dir,
+				   struct dma_attrs *attrs)
 {
-	void *vaddr = phys_to_virt(paddr);
+	void *vaddr = page_address(page) + offset;
 	unsigned long uaddr;
 	unsigned int npages;
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -456,17 +458,32 @@ static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
 	uaddr = (unsigned long)vaddr;
 	npages = iommu_num_pages(uaddr, size, PAGE_SIZE);
 
-	return iommu_alloc(dev, tbl, vaddr, npages, direction);
+	return iommu_alloc(dev, tbl, vaddr, npages, dir);
 }
 
-static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
-	size_t size, int direction)
+static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
+				     size_t size, int direction)
+{
+	return calgary_map_page(dev, pfn_to_page(paddr >> PAGE_SHIFT),
+				paddr & ~PAGE_MASK, size,
+				direction, NULL);
+}
+
+static void calgary_unmap_page(struct device *dev, dma_addr_t dma_addr,
+			       size_t size, enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	npages = iommu_num_pages(dma_handle, size, PAGE_SIZE);
-	iommu_free(tbl, dma_handle, npages);
+	npages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
+	iommu_free(tbl, dma_addr, npages);
+}
+
+static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
+				 size_t size, int direction)
+{
+	calgary_unmap_page(dev, dma_handle, size, direction, NULL);
 }
 
 static void* calgary_alloc_coherent(struct device *dev, size_t size,
@@ -522,6 +539,8 @@ static struct dma_mapping_ops calgary_dma_ops = {
 	.unmap_single = calgary_unmap_single,
 	.map_sg = calgary_map_sg,
 	.unmap_sg = calgary_unmap_sg,
+	.map_page = calgary_map_page,
+	.unmap_page = calgary_unmap_page,
 };
 
 static inline void __iomem * busno_to_bbar(unsigned char num)
-- 
1.6.0.6

