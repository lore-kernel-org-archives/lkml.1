Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbZAGPHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbZAGPHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZAGPG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:06:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:60941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743AbZAGPG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:06:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,226,1231142400"; 
   d="scan'208";a="479650909"
Date: Wed, 7 Jan 2009 23:00:01 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] VT-d: cleanup iommu_flush_iotlb_psi and flush_unmaps
Message-ID: <20090107150001.GF4697@yzhao12-linux.sh.intel.com>
References: <20090107144716.GA4697@yzhao12-linux.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107144716.GA4697@yzhao12-linux.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make iommu_flush_iotlb_psi() and flush_unmaps() easier to read.

Signed-off-by: Yu Zhao <yu.zhao@intel.com>

---
 drivers/pci/intel-iommu.c |   46 +++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 235fb7a..261b6bd 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -916,30 +916,27 @@ static int __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did,
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
@@ -2292,15 +2289,16 @@ static void flush_unmaps(void)
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
1.5.6.4

