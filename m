Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZK0OBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZK0OBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZK0OBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:01:39 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:49872
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752948AbZK0Nzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:55:55 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KTRTD1-02-34L-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/34] x86/amd-iommu: Use __iommu_flush_pages for tlb flushes
Date: Fri, 27 Nov 2009 14:55:18 +0100
Message-ID: <1259330145-14865-8-git-send-email-joerg.roedel@amd.com>
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

This patch re-implements iommu_flush_tlb functions to use
the __iommu_flush_pages logic.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 7c06e57..c55aa07 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -451,7 +451,7 @@ static void __iommu_flush_pages(struct protection_domain *domain,
 				u64 address, size_t size, int pde)
 {
 	int s = 0, i;
-	unsigned pages = iommu_num_pages(address, size, PAGE_SIZE);
+	unsigned long pages = iommu_num_pages(address, size, PAGE_SIZE);
 
 	address &= PAGE_MASK;
 
@@ -487,23 +487,15 @@ static void iommu_flush_pages(struct protection_domain *domain,
 }
 
 /* Flush the whole IO/TLB for a given protection domain */
-static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
+static void iommu_flush_tlb(struct protection_domain *domain)
 {
-	u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-
-	INC_STATS_COUNTER(domain_flush_single);
-
-	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
+	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 0);
 }
 
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
-static void iommu_flush_tlb_pde(struct amd_iommu *iommu, u16 domid)
+static void iommu_flush_tlb_pde(struct protection_domain *domain)
 {
-       u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-
-       INC_STATS_COUNTER(domain_flush_single);
-
-       iommu_queue_inv_iommu_pages(iommu, address, domid, 1, 1);
+	__iommu_flush_pages(domain, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS, 1);
 }
 
 /*
@@ -1236,7 +1228,7 @@ static void attach_device(struct amd_iommu *iommu,
 	 * here to evict all dirty stuff.
 	 */
 	iommu_queue_inv_dev_entry(iommu, devid);
-	iommu_flush_tlb_pde(iommu, domain->id);
+	iommu_flush_tlb_pde(domain);
 }
 
 /*
@@ -1697,7 +1689,7 @@ retry:
 	ADD_STATS_COUNTER(alloced_io_mem, size);
 
 	if (unlikely(dma_dom->need_flush && !amd_iommu_unmap_flush)) {
-		iommu_flush_tlb(iommu, dma_dom->domain.id);
+		iommu_flush_tlb(&dma_dom->domain);
 		dma_dom->need_flush = false;
 	} else if (unlikely(iommu_has_npcache(iommu)))
 		iommu_flush_pages(&dma_dom->domain, address, size);
-- 
1.6.5.3


