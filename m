Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZGJBMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZGJBMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZGJBJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:09:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:55372 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZGJBJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:09:19 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org,
       fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org
Subject: [PATCH 02/15] swiotlb: remove unused swiotlb_alloc()
Date: Fri, 10 Jul 2009 10:04:51 +0900
Message-Id: <1247187904-31999-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Jul 2009 10:07:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody uses swiotlb_alloc().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-swiotlb.c |    5 -----
 include/linux/swiotlb.h       |    2 --
 lib/swiotlb.c                 |    8 ++------
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 0ac7cd5..ea675cf 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -13,11 +13,6 @@
 
 int swiotlb __read_mostly;
 
-void *swiotlb_alloc(unsigned order, unsigned long nslabs)
-{
-	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
-}
-
 dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 94db704..6bc5094 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -23,8 +23,6 @@ struct scatterlist;
 extern void
 swiotlb_init(void);
 
-extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
-
 extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 				      phys_addr_t address);
 extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 9edfdd4..3c4c21c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -114,11 +114,6 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
-void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
-{
-	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
-}
-
 dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
@@ -240,7 +235,8 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = swiotlb_alloc(order, io_tlb_nslabs);
+		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
+							order);
 		if (io_tlb_start)
 			break;
 		order--;
-- 
1.6.0.6

