Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZAEOvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZAEOvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZAEOug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:50:36 -0500
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53972 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbZAEOuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:50:35 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/8] gart: add map_page and unmap_page
Date: Mon,  5 Jan 2009 23:47:23 +0900
Message-Id: <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of struct dma_mapping_ops unification. We use
map_page and unmap_page instead of map_single and unmap_single.

We will remove map_single and unmap_single hooks in the last patch in
this patchset.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 00c2bcd..e49c6dd 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -255,10 +255,13 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 }
 
 /* Map a single area into the IOMMU */
-static dma_addr_t
-gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
+static dma_addr_t gart_map_page(struct device *dev, struct page *page,
+				unsigned long offset, size_t size,
+				enum dma_data_direction dir,
+				struct dma_attrs *attrs)
 {
 	unsigned long bus;
+	phys_addr_t paddr = page_to_phys(page) + offset;
 
 	if (!dev)
 		dev = &x86_dma_fallback_dev;
@@ -272,11 +275,19 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 	return bus;
 }
 
+static dma_addr_t gart_map_single(struct device *dev, phys_addr_t paddr,
+				  size_t size, int dir)
+{
+	return gart_map_page(dev, pfn_to_page(paddr >> PAGE_SHIFT),
+			     paddr & ~PAGE_MASK, size, dir, NULL);
+}
+
 /*
  * Free a DMA mapping.
  */
-static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
-			      size_t size, int direction)
+static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
+			    size_t size, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
 {
 	unsigned long iommu_page;
 	int npages;
@@ -295,6 +306,12 @@ static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
 	free_iommu(iommu_page, npages);
 }
 
+static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
+			      size_t size, int direction)
+{
+	gart_unmap_page(dev, dma_addr, size, direction, NULL);
+}
+
 /*
  * Wrapper for pci_unmap_single working with scatterlists.
  */
@@ -712,6 +729,8 @@ static struct dma_mapping_ops gart_dma_ops = {
 	.unmap_single			= gart_unmap_single,
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
+	.map_page			= gart_map_page,
+	.unmap_page			= gart_unmap_page,
 	.alloc_coherent			= gart_alloc_coherent,
 	.free_coherent			= gart_free_coherent,
 };
-- 
1.6.0.6

