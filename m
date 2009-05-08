Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZEHAlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZEHAlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762817AbZEHARd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:17:33 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:48374
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762966AbZEHAR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:17:27 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 9/9] xen/swiotlb: update to new new dma_ops
Date: Thu,  7 May 2009 17:17:22 -0700
Message-Id: <1241741842-7966-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241741842-7966-1-git-send-email-jeremy@goop.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Convert to use map_page/unmap_page rather than map_single, use enum
dma_data_direction.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/pci/xen-iommu.c |   54 ++++++++++++++++++++---------------------------
 1 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/xen-iommu.c b/drivers/pci/xen-iommu.c
index 81338b2..41c276f 100644
--- a/drivers/pci/xen-iommu.c
+++ b/drivers/pci/xen-iommu.c
@@ -154,7 +154,9 @@ static inline dma_addr_t xen_dma_map_page(struct page *page)
 }
 
 static int xen_map_sg(struct device *hwdev, struct scatterlist *sg,
-			int nents, int direction)
+		      int nents,
+		      enum dma_data_direction direction,
+		      struct dma_attrs *attrs)
 {
 	struct scatterlist *s;
 	struct page *page;
@@ -179,7 +181,9 @@ static int xen_map_sg(struct device *hwdev, struct scatterlist *sg,
 }
 
 static void xen_unmap_sg(struct device *hwdev, struct scatterlist *sg,
-			 int nents, int direction)
+			 int nents,
+			 enum dma_data_direction direction,
+			 struct dma_attrs *attrs)
 {
 	struct scatterlist *s;
 	struct page *page;
@@ -242,53 +246,41 @@ static void xen_free_coherent(struct device *dev, size_t size,
 	free_pages((unsigned long)vaddr, order);
 }
 
-static dma_addr_t xen_swiotlb_map_single(struct device *dev, phys_addr_t paddr,
-					 size_t size, int direction)
+static dma_addr_t xen_map_page(struct device *dev, struct page *page,
+			       unsigned long offset, size_t size,
+			       enum dma_data_direction direction,
+			       struct dma_attrs *attrs)
 {
 	dma_addr_t dma;
-	BUG_ON(direction == DMA_NONE);
-
-	WARN_ON(size == 0);
-	dma = swiotlb_map_single(dev, phys_to_virt(paddr), size, direction);
-
-	flush_write_buffers();
-	return dma;
-}
-
-static dma_addr_t xen_map_single(struct device *dev, phys_addr_t paddr,
-					size_t size, int direction)
-{
-	struct page *page;
-	dma_addr_t dma;
 
 	BUG_ON(direction == DMA_NONE);
 
 	WARN_ON(size == 0);
-	page = pfn_to_page(PFN_DOWN(paddr));
 
-	dma = xen_dma_map_page(page) + offset_in_page(paddr);
+	dma = xen_dma_map_page(page) + offset;
 
 	IOMMU_BUG_ON(address_needs_mapping(dev, dma));
-	IOMMU_BUG_ON(range_straddles_page_boundary(paddr, size));
 	flush_write_buffers();
 	return dma;
 }
 
-static void xen_unmap_single(struct device *dev, dma_addr_t dma_addr,
-				size_t size, int direction)
+static void xen_unmap_page(struct device *dev, dma_addr_t dma_addr,
+			   size_t size,
+			   enum dma_data_direction direction,
+			   struct dma_attrs *attrs)
 {
 	BUG_ON(direction == DMA_NONE);
 	xen_dma_unmap_page(pfn_to_page(mfn_to_pfn(PFN_DOWN(dma_addr))));
 }
 
-static struct dma_mapping_ops xen_dma_ops = {
+static struct dma_map_ops xen_dma_ops = {
 	.dma_supported = NULL,
 
 	.alloc_coherent = xen_alloc_coherent,
 	.free_coherent = xen_free_coherent,
 
-	.map_single = xen_map_single,
-	.unmap_single = xen_unmap_single,
+	.map_page = xen_map_page,
+	.unmap_page = xen_unmap_page,
 
 	.map_sg = xen_map_sg,
 	.unmap_sg = xen_unmap_sg,
@@ -298,17 +290,17 @@ static struct dma_mapping_ops xen_dma_ops = {
 	.is_phys = 0,
 };
 
-static struct dma_mapping_ops xen_swiotlb_dma_ops = {
+static struct dma_map_ops xen_swiotlb_dma_ops = {
 	.dma_supported = swiotlb_dma_supported,
 
 	.alloc_coherent = xen_alloc_coherent,
 	.free_coherent = xen_free_coherent,
 
-	.map_single = xen_swiotlb_map_single,	/* swiotlb_map_single has a different prototype */
-	.unmap_single = swiotlb_unmap_single,
+	.map_page = swiotlb_map_page,
+	.unmap_page = swiotlb_unmap_page,
 
-	.map_sg = swiotlb_map_sg,
-	.unmap_sg = swiotlb_unmap_sg,
+	.map_sg = swiotlb_map_sg_attrs,
+	.unmap_sg = swiotlb_unmap_sg_attrs,
 
 	.mapping_error = swiotlb_dma_mapping_error,
 
-- 
1.6.0.6

