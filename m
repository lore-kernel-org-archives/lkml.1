Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYIQQxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYIQQxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYIQQxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:10 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:64254 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbYIQQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:09 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0K7CMW6-04-URM-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/23] AMD IOMMU: move TLB flushing to the map/unmap helper functions
Date: Wed, 17 Sep 2008 18:52:36 +0200
Message-ID: <1221670377-19295-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:57.0901 (UTC) FILETIME=[D65175D0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the invocation of the flushing functions to the
map/unmap helper functions because its common code in all dma_ops
relevant mapping/unmapping functions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 695e0fc..691e023 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -795,6 +795,9 @@ static dma_addr_t __map_single(struct device *dev,
 	}
 	address += offset;
 
+	if (unlikely(iommu_has_npcache(iommu)))
+		iommu_flush_pages(iommu, dma_dom->domain.id, address, size);
+
 out:
 	return address;
 }
@@ -825,6 +828,8 @@ static void __unmap_single(struct amd_iommu *iommu,
 	}
 
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
+
+	iommu_flush_pages(iommu, dma_dom->domain.id, dma_addr, size);
 }
 
 /*
@@ -853,9 +858,6 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	if (addr == bad_dma_address)
 		goto out;
 
-	if (iommu_has_npcache(iommu))
-		iommu_flush_pages(iommu, domain->id, addr, size);
-
 	if (iommu->need_sync)
 		iommu_completion_wait(iommu);
 
@@ -885,8 +887,6 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
 
-	iommu_flush_pages(iommu, domain->id, dma_addr, size);
-
 	if (iommu->need_sync)
 		iommu_completion_wait(iommu);
 
@@ -948,9 +948,6 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			mapped_elems++;
 		} else
 			goto unmap;
-		if (iommu_has_npcache(iommu))
-			iommu_flush_pages(iommu, domain->id, s->dma_address,
-					  s->dma_length);
 	}
 
 	if (iommu->need_sync)
@@ -996,8 +993,6 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	for_each_sg(sglist, s, nelems, i) {
 		__unmap_single(iommu, domain->priv, s->dma_address,
 			       s->dma_length, dir);
-		iommu_flush_pages(iommu, domain->id, s->dma_address,
-				  s->dma_length);
 		s->dma_address = s->dma_length = 0;
 	}
 
@@ -1048,9 +1043,6 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		goto out;
 	}
 
-	if (iommu_has_npcache(iommu))
-		iommu_flush_pages(iommu, domain->id, *dma_addr, size);
-
 	if (iommu->need_sync)
 		iommu_completion_wait(iommu);
 
@@ -1082,7 +1074,6 @@ static void free_coherent(struct device *dev, size_t size,
 	spin_lock_irqsave(&domain->lock, flags);
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
-	iommu_flush_pages(iommu, domain->id, dma_addr, size);
 
 	if (iommu->need_sync)
 		iommu_completion_wait(iommu);
-- 
1.5.6.4


