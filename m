Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0BKOdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:33:43 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:40639
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751832Ab0BKOdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:33:40 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KXOLRT-01-0UP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/7] x86/amd-iommu: Introduce iommu_update_dma_ops_domain()
Date: Thu, 11 Feb 2010 15:33:16 +0100
Message-ID: <1265898797-32183-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
References: <1265898797-32183-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 11 Feb 2010 14:33:21.0759 (UTC) FILETIME=[293F9EF0:01CAAB27]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new functions does the same for dma_ops domains as
iommu_update_domain for other domains. For dma_ops domains
we can't use iommu_update_domain because we need to care
about lazy tlb flushing.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   45 ++++++++++++++++++++----------------------
 1 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4063f55..a645756 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -768,6 +768,18 @@ static void iommu_update_domain(struct protection_domain *domain)
 	iommu_flush_complete(domain);
 }
 
+static void iommu_update_dma_ops_domain(struct dma_ops_domain *dma_dom)
+{
+	iommu_update_domain_dte(&dma_dom->domain);
+
+	if (dma_dom->need_flush) {
+		iommu_update_domain_tlb(&dma_dom->domain, false);
+		dma_dom->need_flush = false;
+	}
+
+	iommu_flush_complete(&dma_dom->domain);
+}
+
 /****************************************************************************
  *
  * The functions below are used the create the page table mappings for
@@ -1120,12 +1132,9 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
 	}
 
-	iommu_update_domain_dte(&dma_dom->domain);
-
 	return 0;
 
 out_free:
-	iommu_update_domain_dte(&dma_dom->domain);
 
 	free_page((unsigned long)dma_dom->aperture[index]->bitmap);
 
@@ -1744,8 +1753,6 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 	} else
 		pte += PM_LEVEL_INDEX(0, address);
 
-	iommu_update_domain_dte(&dom->domain);
-
 	return pte;
 }
 
@@ -1876,15 +1883,10 @@ retry:
 
 	ADD_STATS_COUNTER(alloced_io_mem, size);
 
-	if (unlikely(amd_iommu_np_cache))
+	if (unlikely(amd_iommu_np_cache ||
+		     (dma_dom->need_flush && !amd_iommu_unmap_flush)))
 		update_flush_info_tlb(&dma_dom->domain, start, size);
 
-	if (unlikely((dma_dom->need_flush && !amd_iommu_unmap_flush)) ||
-		      amd_iommu_np_cache) {
-		iommu_update_domain_tlb(&dma_dom->domain, false);
-		dma_dom->need_flush = false;
-	}
-
 out:
 	return address;
 
@@ -1930,11 +1932,6 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	SUB_STATS_COUNTER(alloced_io_mem, size);
 
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
-
-	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_update_domain_tlb(&dma_dom->domain, false);
-		dma_dom->need_flush = false;
-	}
 }
 
 /*
@@ -1968,7 +1965,7 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 	if (addr == DMA_ERROR_CODE)
 		goto out;
 
-	iommu_flush_complete(domain);
+	iommu_update_dma_ops_domain(domain->priv);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1995,7 +1992,7 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	__unmap_single(domain->priv, dma_addr, size, dir);
 
-	iommu_flush_complete(domain);
+	iommu_update_dma_ops_domain(domain->priv);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -2060,9 +2057,9 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			goto unmap;
 	}
 
-	iommu_flush_complete(domain);
-
 out:
+	iommu_update_dma_ops_domain(domain->priv);
+
 	spin_unlock_irqrestore(&domain->lock, flags);
 
 	return mapped_elems;
@@ -2106,7 +2103,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		s->dma_address = s->dma_length = 0;
 	}
 
-	iommu_flush_complete(domain);
+	iommu_update_dma_ops_domain(domain->priv);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -2156,7 +2153,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		goto out_free;
 	}
 
-	iommu_flush_complete(domain);
+	iommu_update_dma_ops_domain(domain->priv);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -2188,7 +2185,7 @@ static void free_coherent(struct device *dev, size_t size,
 
 	__unmap_single(domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
-	iommu_flush_complete(domain);
+	iommu_update_dma_ops_domain(domain->priv);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
-- 
1.6.6


