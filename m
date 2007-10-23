Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXJWFBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXJWFBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXJWFBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:01:11 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:60197 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXJWFBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:01:09 -0400
To: jens.axboe@oracle.com
Cc: torvalds@linux-foundation.org, anil.s.keshavamurthy@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] intel-iommu: fix sg_page()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071023135926A.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 23 Oct 2007 13:59:26 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pci/intel-iommu.c: In function 'intel_unmap_sg':
drivers/pci/intel-iommu.c:1987: error: 'struct scatterlist' has no member named 'page'
drivers/pci/intel-iommu.c: In function 'intel_nontranslate_map_sg':
drivers/pci/intel-iommu.c:2013: error: 'struct scatterlist' has no member named 'page'
drivers/pci/intel-iommu.c:2014: error: 'struct scatterlist' has no member named 'page'
drivers/pci/intel-iommu.c: In function 'intel_map_sg':
drivers/pci/intel-iommu.c:2044: error: 'struct scatterlist' has no member named 'page'
drivers/pci/intel-iommu.c:2068: error: 'struct scatterlist' has no member named 'page'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/pci/intel-iommu.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b3d7031..0f6e528 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1962,7 +1962,6 @@ static void intel_free_coherent(struct device *hwdev, size_t size,
 	free_pages((unsigned long)vaddr, order);
 }
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
 static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 	int nelems, int dir)
 {
@@ -1984,7 +1983,7 @@ static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 	if (!iova)
 		return;
 	for_each_sg(sglist, sg, nelems, i) {
-		addr = SG_ENT_VIRT_ADDRESS(sg);
+		addr = sg_virt(sg);
 		size += aligned_size((u64)addr, sg->length);
 	}
 
@@ -2010,8 +2009,8 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 	struct scatterlist *sg;
 
 	for_each_sg(sglist, sg, nelems, i) {
-		BUG_ON(!sg->page);
-		sg->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(sg));
+		BUG_ON(!sg_page(sg));
+		sg->dma_address = virt_to_bus(sg_virt(sg));
 		sg->dma_length = sg->length;
 	}
 	return nelems;
@@ -2041,7 +2040,7 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 		return 0;
 
 	for_each_sg(sglist, sg, nelems, i) {
-		addr = SG_ENT_VIRT_ADDRESS(sg);
+		addr = sg_virt(sg);
 		addr = (void *)virt_to_phys(addr);
 		size += aligned_size((u64)addr, sg->length);
 	}
@@ -2065,7 +2064,7 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist,
 	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
 	offset = 0;
 	for_each_sg(sglist, sg, nelems, i) {
-		addr = SG_ENT_VIRT_ADDRESS(sg);
+		addr = sg_virt(sg);
 		addr = (void *)virt_to_phys(addr);
 		size = aligned_size((u64)addr, sg->length);
 		ret = domain_page_mapping(domain, start_addr + offset,
-- 
1.5.2.4

