Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbZBMCwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbZBMCwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 21:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760591AbZBMCva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 21:51:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:61631 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758985AbZBMCvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 21:51:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,200,1233561600"; 
   d="scan'208";a="430659381"
From: Yu Zhao <yu.zhao@intel.com>
To: jbarnes@virtuousgeek.org, dwmw2@infradead.org
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yu Zhao <yu.zhao@intel.com>
Subject: [PATCH v3 5/6] VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
Date: Thu, 12 Feb 2009 20:50:37 +0800
Message-Id: <1234443038-15437-6-git-send-email-yu.zhao@intel.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make iommu_flush_iotlb_psi() and flush_unmaps() easier to read.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 drivers/pci/intel-iommu.c |   46 +++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index f4b7c79..5fdbed3 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -925,30 +925,27 @@ static int __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did,
 static int iommu_flush_iotlb_psi(struct intel_iommu *iommu, u16 did,
 	u64 addr, unsigned int pages, int non_present_entry_flush)
 {
-	unsigned int mask;
+	int rc;
+	unsigned int mask = ilog2(__roundup_pow_of_two(pages));
 
 	BUG_ON(addr & (~VTD_PAGE_MASK));
 	BUG_ON(pages == 0);
 
-	/* Fallback to domain selective flush if no PSI support */
-	if (!cap_pgsel_inv(iommu->cap))
-		return iommu->flush.flush_iotlb(iommu, did, 0, 0,
-						DMA_TLB_DSI_FLUSH,
-						non_present_entry_flush);
-
 	/*
+	 * Fallback to domain selective flush if no PSI support or the size is
+	 * too big.
 	 * PSI requires page size to be 2 ^ x, and the base address is naturally
 	 * aligned to the size
 	 */
-	mask = ilog2(__roundup_pow_of_two(pages));
-	/* Fallback to domain selective flush if size is too big */
-	if (mask > cap_max_amask_val(iommu->cap))
-		return iommu->flush.flush_iotlb(iommu, did, 0, 0,
-			DMA_TLB_DSI_FLUSH, non_present_entry_flush);
-
-	return iommu->flush.flush_iotlb(iommu, did, addr, mask,
-					DMA_TLB_PSI_FLUSH,
-					non_present_entry_flush);
+	if (!cap_pgsel_inv(iommu->cap) || mask > cap_max_amask_val(iommu->cap))
+		rc = iommu->flush.flush_iotlb(iommu, did, 0, 0,
+						DMA_TLB_DSI_FLUSH,
+						non_present_entry_flush);
+	else
+		rc = iommu->flush.flush_iotlb(iommu, did, addr, mask,
+						DMA_TLB_PSI_FLUSH,
+						non_present_entry_flush);
+	return rc;
 }
 
 static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
@@ -2301,15 +2298,16 @@ static void flush_unmaps(void)
 		if (!iommu)
 			continue;
 
-		if (deferred_flush[i].next) {
-			iommu->flush.flush_iotlb(iommu, 0, 0, 0,
-						 DMA_TLB_GLOBAL_FLUSH, 0);
-			for (j = 0; j < deferred_flush[i].next; j++) {
-				__free_iova(&deferred_flush[i].domain[j]->iovad,
-						deferred_flush[i].iova[j]);
-			}
-			deferred_flush[i].next = 0;
+		if (!deferred_flush[i].next)
+			continue;
+
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0,
+					 DMA_TLB_GLOBAL_FLUSH, 0);
+		for (j = 0; j < deferred_flush[i].next; j++) {
+			__free_iova(&deferred_flush[i].domain[j]->iovad,
+					deferred_flush[i].iova[j]);
 		}
+		deferred_flush[i].next = 0;
 	}
 
 	list_size = 0;
-- 
1.6.1

