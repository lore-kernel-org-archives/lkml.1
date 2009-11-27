Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZK0OBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZK0OBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZK0OBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:01:41 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:14501
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752942AbZK0Nzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:55 -0500
X-SpamScore: 2
X-BigFish: VPS2(zz10d1Izz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KTRTD2-01-6RL-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/34] x86/amd-iommu: Make iommu_flush_pages aware of multiple IOMMUs
Date: Fri, 27 Nov 2009 14:55:17 +0100
Message-ID: <1259330145-14865-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
References: <1259330145-14865-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2009 13:55:48.0045 (UTC) FILETIME=[528927D0:01CA6F69]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the iommu_flush_pages function to flush
the TLB entries on all IOMMUs the domain has devices on.
This basically gives up the former assumption that dma_ops
domains are only bound to one IOMMU in the system.
For dma_ops domains this is still true but not for
IOMMU-API managed domains. Giving this assumption up for
dma_ops domains too allows code simplification.
Further it splits out the main logic into a generic function
which can be used by iommu_flush_tlb too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   31 ++++++++++++++++++++++++-------
 1 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8fa5cc3..7c06e57 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -447,10 +447,10 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
  * It invalidates a single PTE if the range to flush is within a single
  * page. Otherwise it flushes the whole TLB of the IOMMU.
  */
-static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
-		u64 address, size_t size)
+static void __iommu_flush_pages(struct protection_domain *domain,
+				u64 address, size_t size, int pde)
 {
-	int s = 0;
+	int s = 0, i;
 	unsigned pages = iommu_num_pages(address, size, PAGE_SIZE);
 
 	address &= PAGE_MASK;
@@ -464,9 +464,26 @@ static int iommu_flush_pages(struct amd_iommu *iommu, u16 domid,
 		s = 1;
 	}
 
-	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, s);
 
-	return 0;
+	for (i = 0; i < amd_iommus_present; ++i) {
+		if (!domain->dev_iommu[i])
+			continue;
+
+		/*
+		 * Devices of this domain are behind this IOMMU
+		 * We need a TLB flush
+		 */
+		iommu_queue_inv_iommu_pages(amd_iommus[i], address,
+					    domain->id, pde, s);
+	}
+
+	return;
+}
+
+static void iommu_flush_pages(struct protection_domain *domain,
+			     u64 address, size_t size)
+{
+	__iommu_flush_pages(domain, address, size, 0);
 }
 
 /* Flush the whole IO/TLB for a given protection domain */
@@ -1683,7 +1700,7 @@ retry:
 		iommu_flush_tlb(iommu, dma_dom->domain.id);
 		dma_dom->need_flush = false;
 	} else if (unlikely(iommu_has_npcache(iommu)))
-		iommu_flush_pages(iommu, dma_dom->domain.id, address, size);
+		iommu_flush_pages(&dma_dom->domain, address, size);
 
 out:
 	return address;
@@ -1731,7 +1748,7 @@ static void __unmap_single(struct amd_iommu *iommu,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(iommu, dma_dom->domain.id, dma_addr, size);
+		iommu_flush_pages(&dma_dom->domain, dma_addr, size);
 		dma_dom->need_flush = false;
 	}
 }
-- 
1.6.5.3


