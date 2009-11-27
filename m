Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZK0OBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZK0OBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZK0OAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:00:55 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:38294
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752576AbZK0Nzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:55 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD0-02-34I-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/34] x86/amd-iommu: Add function to complete a tlb flush
Date: Fri, 27 Nov 2009 14:55:16 +0100
Message-ID: <1259330145-14865-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0029 (UTC) FILETIME=[5286B6D0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function to the AMD IOMMU driver which
completes all queued commands an all IOMMUs a specific
domain has devices attached on. This is required in a later
patch when per-domain flushing is implemented.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   28 ++++++++++++++++++++++------
 1 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8c38f00..8fa5cc3 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -376,6 +376,22 @@ out:
 	return 0;
 }
 
+static void iommu_flush_complete(struct protection_domain *domain)
+{
+	int i;
+
+	for (i = 0; i < amd_iommus_present; ++i) {
+		if (!domain->dev_iommu[i])
+			continue;
+
+		/*
+		 * Devices of this domain are behind this IOMMU
+		 * We need to wait for completion of all commands.
+		 */
+		iommu_completion_wait(amd_iommus[i]);
+	}
+}
+
 /*
  * Command send function for invalidating a device table entry
  */
@@ -1758,7 +1774,7 @@ static dma_addr_t map_page(struct device *dev, struct page *page,
 	if (addr == DMA_ERROR_CODE)
 		goto out;
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1791,7 +1807,7 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, dir);
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1863,7 +1879,7 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 			goto unmap;
 	}
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 out:
 	spin_unlock_irqrestore(&domain->lock, flags);
@@ -1914,7 +1930,7 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 		s->dma_address = s->dma_length = 0;
 	}
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 }
@@ -1969,7 +1985,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 		goto out_free;
 	}
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
@@ -2010,7 +2026,7 @@ static void free_coherent(struct device *dev, size_t size,
 
 	__unmap_single(iommu, domain->priv, dma_addr, size, DMA_BIDIRECTIONAL);
 
-	iommu_completion_wait(iommu);
+	iommu_flush_complete(domain);
 
 	spin_unlock_irqrestore(&domain->lock, flags);
 
-- 
1.6.5.3


