Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbYIQQ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbYIQQ5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYIQQxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:22 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:65085 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbYIQQxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:19 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0K7CMW6-03-U8V-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/23] AMD IOMMU: align alloc_coherent addresses properly
Date: Wed, 17 Sep 2008 18:52:39 +0200
Message-ID: <1221670377-19295-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0001 (UTC) FILETIME=[D660B810:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The API definition for dma_alloc_coherent states that the bus address
has to be aligned to the next power of 2 boundary greater than the
allocation size. This is violated by AMD IOMMU so far and this patch
fixes it.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 7e9e4e7..fdec963 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -383,7 +383,8 @@ static unsigned long dma_mask_to_pages(unsigned long mask)
  */
 static unsigned long dma_ops_alloc_addresses(struct device *dev,
 					     struct dma_ops_domain *dom,
-					     unsigned int pages)
+					     unsigned int pages,
+					     unsigned long align_mask)
 {
 	unsigned long limit = dma_mask_to_pages(*dev->dma_mask);
 	unsigned long address;
@@ -400,10 +401,10 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 	}
 
 	address = iommu_area_alloc(dom->bitmap, limit, dom->next_bit, pages,
-			0 , boundary_size, 0);
+				   0 , boundary_size, align_mask);
 	if (address == -1) {
 		address = iommu_area_alloc(dom->bitmap, limit, 0, pages,
-				0, boundary_size, 0);
+				0, boundary_size, align_mask);
 		dom->need_flush = true;
 	}
 
@@ -787,17 +788,22 @@ static dma_addr_t __map_single(struct device *dev,
 			       struct dma_ops_domain *dma_dom,
 			       phys_addr_t paddr,
 			       size_t size,
-			       int dir)
+			       int dir,
+			       bool align)
 {
 	dma_addr_t offset = paddr & ~PAGE_MASK;
 	dma_addr_t address, start;
 	unsigned int pages;
+	unsigned long align_mask = 0;
 	int i;
 
 	pages = iommu_num_pages(paddr, size);
 	paddr &= PAGE_MASK;
 
-	address = dma_ops_alloc_addresses(dev, dma_dom, pages);
+	if (align)
+		align_mask = (1UL << get_order(size)) - 1;
+
+	address = dma_ops_alloc_addresses(dev, dma_dom, pages, align_mask);
 	if (unlikely(address == bad_dma_address))
 		goto out;
 
@@ -872,7 +878,7 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 		return (dma_addr_t)paddr;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir);
+	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir, false);
 	if (addr == bad_dma_address)
 		goto out;
 
@@ -959,7 +965,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 		paddr = sg_phys(s);
 
 		s->dma_address = __map_single(dev, iommu, domain->priv,
-					      paddr, s->length, dir);
+					      paddr, s->length, dir, false);
 
 		if (s->dma_address) {
 			s->dma_length = s->length;
@@ -1053,7 +1059,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	spin_lock_irqsave(&domain->lock, flags);
 
 	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
-				 size, DMA_BIDIRECTIONAL);
+				 size, DMA_BIDIRECTIONAL, true);
 
 	if (*dma_addr == bad_dma_address) {
 		free_pages((unsigned long)virt_addr, get_order(size));
-- 
1.5.6.4


