Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab0BKOdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:33:46 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:40828
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755735Ab0BKOdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:33:44 -0500
X-SpamScore: 15
X-BigFish: VPS15(z1857rzab9bh936eMab78ozz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXOLRK-01-0UH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/7] x86/amd-iommu: Introduce iommu_update_domain_tlb function
Date: Thu, 11 Feb 2010 15:33:12 +0100
Message-ID: <1265898797-32183-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
References: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Feb 2010 14:33:21.0478 (UTC) FILETIME=[2914BE60:01CAAB27]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a function which only flushes the
necessary parts of the IO/TLB for a domain using size aware
flushing commands.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   51 +++++++++++++++++++++++++++---------------
 1 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fcb85e8..9318512 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -617,24 +617,35 @@ static void __iommu_flush_pages(struct protection_domain *domain,
 	return;
 }
 
-static void iommu_flush_pages(struct protection_domain *domain,
-			     u64 address, size_t size)
-{
-	__iommu_flush_pages(domain, address, size, 0);
-}
-
-/* Flush the whole IO/TLB for a given protection domain */
-static void iommu_flush_tlb(struct protection_domain *domain)
-{
-	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 0);
-}
-
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
 static void iommu_flush_tlb_pde(struct protection_domain *domain)
 {
 	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
 }
 
+/* Flush a range of pages in the domain */
+static void iommu_update_domain_tlb(struct protection_domain *domain, bool pde)
+{
+	u64 address, mask;
+	int i, order;
+
+	if (!domain->flush.tlb)
+		return;
+
+	order   = get_order(domain->flush.end - domain->flush.start);
+	mask    = (0x1000ULL << order) - 1;
+	address = ((domain->flush.start & ~mask) | (mask >> 1)) & ~0xfffULL;
+
+	for (i = 0; i < amd_iommus_present; ++i) {
+		if (!domain->dev_iommu[i])
+			continue;
+
+		iommu_queue_inv_iommu_pages(amd_iommus[i], address,
+					    domain->id, pde, (order != 0));
+	}
+
+	domain->flush.tlb = false;
+}
 
 /*
  * This function flushes the DTEs for all devices in domain
@@ -1865,11 +1876,11 @@ retry:
 	if (unlikely(amd_iommu_np_cache))
 		update_flush_info_tlb(&dma_dom->domain, start, size);
 
-	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
-		iommu_flush_tlb(&dma_dom->domain);
+	if (unlikely((dma_dom->need_flush && !amd_iommu_unmap_flush)) ||
+		      amd_iommu_np_cache) {
+		iommu_update_domain_tlb(&dma_dom->domain, false);
 		dma_dom->need_flush = false;
-	} else if (unlikely(amd_iommu_np_cache))
-		iommu_flush_pages(&dma_dom->domain, address, size);
+	}
 
 out:
 	return address;
@@ -1918,7 +1929,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(&dma_dom->domain, dma_addr, size);
+		iommu_update_domain_tlb(&dma_dom->domain, false);
 		dma_dom->need_flush = false;
 	}
 }
@@ -2486,6 +2497,9 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	if (unlikely(amd_iommu_np_cache))
 		update_flush_info_tlb(domain, iova, iova + size);
 
+	iommu_update_domain_tlb(domain, true);
+	iommu_flush_complete(domain);
+
 	return 0;
 }
 
@@ -2505,7 +2519,8 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 
 	update_flush_info_tlb(domain, iova, iova + size);
 
-	iommu_flush_tlb_pde(domain);
+	iommu_update_domain_tlb(domain, true);
+	iommu_flush_complete(domain);
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
-- 
1.6.6


