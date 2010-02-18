Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab0BRRCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:02:16 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:46019 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758720Ab0BRRCO (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 12:02:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/10] swiotlb: do_map_single: abstract out swiotlb_virt_to_bus calls out.
Date: Thu, 18 Feb 2010 11:27:02 -0500
Message-Id: <1266510426-6815-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-6-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-4-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-5-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-6-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B7D6EA1.00C4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to move that function out of do_map_single so that the caller
of this function does the virt->phys->bus address translation.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 9085eab..4ab3885 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -394,20 +394,19 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-do_map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+do_map_single(struct device *hwdev, phys_addr_t phys,
+	       unsigned long start_dma_addr, size_t size, int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
 	unsigned int nslots, stride, index, wrap;
 	int i;
-	unsigned long start_dma_addr;
 	unsigned long mask;
 	unsigned long offset_slots;
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start) & mask;
-
+	start_dma_addr = start_dma_addr & mask;
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
 	/*
@@ -574,6 +573,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	void *ret;
 	int order = get_order(size);
 	u64 dma_mask = DMA_BIT_MASK(32);
+	unsigned long start_dma_addr;
 
 	if (hwdev && hwdev->coherent_dma_mask)
 		dma_mask = hwdev->coherent_dma_mask;
@@ -592,7 +592,9 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 * to GFP_DMA memory; fall back on do_map_single(), which
 		 * will grab memory from the lowest available address range.
 		 */
-		ret = do_map_single(hwdev, 0, size, DMA_FROM_DEVICE);
+		start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
+		ret = do_map_single(hwdev, 0, start_dma_addr, size,
+				    DMA_FROM_DEVICE);
 		if (!ret)
 			return NULL;
 	}
@@ -607,7 +609,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
 
-		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
+		/* DMA_TO_DEVICE to avoid memcpy in do_unmap_single */
 		do_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
 		return NULL;
 	}
@@ -666,6 +668,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    enum dma_data_direction dir,
 			    struct dma_attrs *attrs)
 {
+	unsigned long start_dma_addr;
 	phys_addr_t phys = page_to_phys(page) + offset;
 	dma_addr_t dev_addr = phys_to_dma(dev, phys);
 	void *map;
@@ -682,7 +685,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = do_map_single(dev, phys, size, dir);
+	start_dma_addr = swiotlb_virt_to_bus(dev, io_tlb_start);
+	map = do_map_single(dev, phys, start_dma_addr, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
@@ -836,11 +840,13 @@ int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		     enum dma_data_direction dir, struct dma_attrs *attrs)
 {
+	unsigned long start_dma_addr;
 	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
+	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
 		dma_addr_t dev_addr = phys_to_dma(hwdev, paddr);
@@ -848,7 +854,8 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length)) {
 			void *map = do_map_single(hwdev, sg_phys(sg),
-					       sg->length, dir);
+						  start_dma_addr,
+						  sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
-- 
1.6.2.5

