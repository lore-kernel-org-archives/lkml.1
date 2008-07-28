Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbYG1M2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbYG1M2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 08:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYG1M2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 08:28:40 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:58219 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbYG1M2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 08:28:39 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4PUN6-04-ZPT-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH] x86 calgary: replace num_dma_pages() with iommu_num_pages()
Date: Mon, 28 Jul 2008 14:28:20 +0200
Message-ID: <1217248100-3019-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 28 Jul 2008 12:28:20.0474 (UTC) FILETIME=[6B911DA0:01C8F0AD]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the num_dma_pages() function from Calgary IOMMU code and
replaces it with the generic iommu_num_pages() function.

Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-calgary_64.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 2bef2e3..f022a21 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -217,16 +217,6 @@ static inline unsigned long verify_bit_range(unsigned long* bitmap,
 
 #endif /* CONFIG_IOMMU_DEBUG */
 
-static inline unsigned int num_dma_pages(unsigned long dma, unsigned int dmalen)
-{
-	unsigned int npages;
-
-	npages = PAGE_ALIGN(dma + dmalen) - (dma & PAGE_MASK);
-	npages >>= PAGE_SHIFT;
-
-	return npages;
-}
-
 static inline int translation_enabled(struct iommu_table *tbl)
 {
 	/* only PHBs with translation enabled have an IOMMU table */
@@ -408,7 +398,7 @@ static void calgary_unmap_sg(struct device *dev,
 		if (dmalen == 0)
 			break;
 
-		npages = num_dma_pages(dma, dmalen);
+		npages = iommu_num_pages(dma, dmalen);
 		iommu_free(tbl, dma, npages);
 	}
 }
@@ -427,7 +417,7 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		BUG_ON(!sg_page(s));
 
 		vaddr = (unsigned long) sg_virt(s);
-		npages = num_dma_pages(vaddr, s->length);
+		npages = iommu_num_pages(vaddr, s->length);
 
 		entry = iommu_range_alloc(dev, tbl, npages);
 		if (entry == bad_dma_address) {
@@ -464,7 +454,7 @@ static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
 	struct iommu_table *tbl = find_iommu_table(dev);
 
 	uaddr = (unsigned long)vaddr;
-	npages = num_dma_pages(uaddr, size);
+	npages = iommu_num_pages(uaddr, size);
 
 	return iommu_alloc(dev, tbl, vaddr, npages, direction);
 }
@@ -475,7 +465,7 @@ static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	struct iommu_table *tbl = find_iommu_table(dev);
 	unsigned int npages;
 
-	npages = num_dma_pages(dma_handle, size);
+	npages = iommu_num_pages(dma_handle, size);
 	iommu_free(tbl, dma_handle, npages);
 }
 
-- 
1.5.3.7


