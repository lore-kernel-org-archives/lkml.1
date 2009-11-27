Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZK0N4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZK0N4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbZK0N4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:56:02 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:52763
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752794AbZK0Nz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:56 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i27bh6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KTRTD3-02-34P-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/34] x86/amd-iommu: Remove iommu parameter from __(un)map_single
Date: Fri, 27 Nov 2009 14:55:28 +0100
Message-ID: <1259330145-14865-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0217 (UTC) FILETIME=[52A36690:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Bypass-Agent: IPF-1;
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the prior changes this parameter is not longer
required. This patch removes it from the function and all
callers.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 687f617..c04dcb7 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1653,7 +1653,6 @@ static void dma_ops_domain_unmap(struct dma_ops_domain *dom,
  * Must be called with the domain lock held.
  */
 static dma_addr_t __map_single(struct device *dev,
-			       struct amd_iommu *iommu,
 			       struct dma_ops_domain *dma_dom,
 			       phys_addr_t paddr,
 			       size_t size,
@@ -1737,8 +1736,7 @@ out_unmap:
  * Does the reverse of the __map_single function. Must be called with
  * the domain lock held too
  */
-static void __unmap_single(struct amd_iommu *iommu,
-			   struct dma_ops_domain *dma_dom,
+static void __unmap_single(struct dma_ops_domain *dma_dom,
 			   dma_addr_t dma_addr,
 			   size_t size,
 			   int dir)
@@ -1797,7 +1795,7 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 		return DMA_ERROR_CODE;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	addr = __map_single(dev, iommu, domain->priv, paddr, size, dir, false,
+	addr = __map_single(dev, domain->priv, paddr, size, dir, false,
 			    dma_mask);
 	if (addr == DMA_ERROR_CODE)
 		goto out;
@@ -1832,7 +1830,7 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
+	__unmap_single(domain->priv, dma_addr, size, dir);
 
 	iommu_flush_complete(domain);
 
@@ -1890,7 +1888,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 	for_each_sg(sglist, s, nelems, i) {
 		paddr = sg_phys(s);
 
-		s->dma_address = __map_single(dev, iommu, domain->priv,
+		s->dma_address = __map_single(dev, domain->priv,
 					      paddr, s->length, dir, false,
 					      dma_mask);
 
@@ -1910,7 +1908,7 @@ out:
 unmap:
 	for_each_sg(sglist, s, mapped_elems, i) {
 		if (s->dma_address)
-			__unmap_single(iommu, domain->priv, s->dma_address,
+			__unmap_single(domain->priv, s->dma_address,
 				       s->dma_length, dir);
 		s->dma_address = s->dma_length = 0;
 	}
@@ -1946,7 +1944,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_lock_irqsave(&domain->lock, flags);
 
 	for_each_sg(sglist, s, nelems, i) {
-		__unmap_single(iommu, domain->priv, s->dma_address,
+		__unmap_single(domain->priv, s->dma_address,
 			       s->dma_length, dir);
 		s->dma_address = s->dma_length = 0;
 	}
@@ -1996,7 +1994,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	*dma_addr = __map_single(dev, iommu, domain->priv, paddr,
+	*dma_addr = __map_single(dev, domain->priv, paddr,
 				 size, DMA_BIDIRECTIONAL, true, dma_mask);
 
 	if (*dma_addr == DMA_ERROR_CODE) {
@@ -2038,7 +2036,7 @@ static void free_coherent(struct device *dev, size_t size,
 
 	spin_lock_irqsave(&domain->lock, flags);
 
-	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
+	__unmap_single(domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
 	iommu_flush_complete(domain);
 
-- 
1.6.5.3


