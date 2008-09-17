Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYIQQyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYIQQyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYIQQxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:15 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:52820 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbYIQQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:12 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K7CMW5-03-U8T-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/23] AMD IOMMU: add branch hints to completion wait checks
Date: Wed, 17 Sep 2008 18:52:38 +0200
Message-ID: <1221670377-19295-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:57.0923 (UTC) FILETIME=[D654D130:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds branch hints to the cecks if a completion_wait is
necessary. The completion_waits in the mapping paths are unlikly because
they will only happen on software implementations of AMD IOMMU which
don't exists today or with lazy IO/TLB flushing when the allocator wraps
around the address space. With lazy IO/TLB flushing the completion_wait
in the unmapping path is unlikely too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0569098..7e9e4e7 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -876,7 +876,7 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	if (addr == bad_dma_address)
 		goto out;
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 out:
@@ -905,7 +905,7 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -968,7 +968,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			goto unmap;
 	}
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 out:
@@ -1014,7 +1014,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		s->dma_address = s->dma_length = 0;
 	}
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1061,7 +1061,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		goto out;
 	}
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 out:
@@ -1093,7 +1093,7 @@ static void free_coherent(struct device *dev, size_t size,
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
-	if (iommu->need_sync)
+	if (unlikely(iommu->need_sync))
 		iommu_completion_wait(iommu);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
-- 
1.5.6.4


