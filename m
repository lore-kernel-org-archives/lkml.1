Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZGJBKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZGJBKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZGJBJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:09:17 -0400
Received: from sh.osrg.net ([192.16.179.4]:55345 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbZGJBJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:09:10 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org,
       fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org
Subject: [PATCH 13/15] swiotlb: use phys_to_dma and dma_to_phys
Date: Fri, 10 Jul 2009 10:05:02 +0900
Message-Id: <1247187904-31999-14-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Jul 2009 10:08:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts swiotlb to use phys_to_dma and dma_to_phys instead of
swiotlb_phys_to_bus() and swiotlb_bus_to_phys().

swiotlb_phys_to_bus() and swiotlb_bus_to_phys() are not necessary so
this patch also removes them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/swiotlb.h |    5 -----
 lib/swiotlb.c           |   22 ++++++----------------
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index a977da2..73b1f1c 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -23,11 +23,6 @@ struct scatterlist;
 extern void
 swiotlb_init(void);
 
-extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
-				      phys_addr_t address);
-extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
-				       dma_addr_t address);
-
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index a0faeb0..de71dba 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -114,20 +114,10 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
-dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
-{
-	return paddr;
-}
-
-phys_addr_t __weak swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
-{
-	return baddr;
-}
-
 static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
 {
-	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
+	return phys_to_dma(hwdev, virt_to_phys(address));
 }
 
 static void swiotlb_print_info(unsigned long bytes)
@@ -566,7 +556,7 @@ void
 swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		      dma_addr_t dev_addr)
 {
-	phys_addr_t paddr = swiotlb_bus_to_phys(hwdev, dev_addr);
+	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
 	WARN_ON(irqs_disabled());
 	if (!is_swiotlb_buffer(paddr))
@@ -611,7 +601,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    struct dma_attrs *attrs)
 {
 	phys_addr_t phys = page_to_phys(page) + offset;
-	dma_addr_t dev_addr = swiotlb_phys_to_bus(dev, phys);
+	dma_addr_t dev_addr = phys_to_dma(dev, phys);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -655,7 +645,7 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
 static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			 size_t size, int dir)
 {
-	phys_addr_t paddr = swiotlb_bus_to_phys(hwdev, dev_addr);
+	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -692,7 +682,7 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	phys_addr_t paddr = swiotlb_bus_to_phys(hwdev, dev_addr);
+	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -781,7 +771,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
-		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
+		dma_addr_t dev_addr = phys_to_dma(hwdev, paddr);
 
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length)) {
-- 
1.6.0.6

