Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZEVMWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZEVMWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbZEVMWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:00 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:21381 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920AbZEVMV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:21:59 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-WSS-ID: 0KK1OZY-04-A1S-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/12] amd-iommu: handle exlusion ranges and unity mappings in alloc_new_range
Date: Fri, 22 May 2009 14:21:28 +0200
Message-ID: <1242994893-28902-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:33.0064 (UTC) FILETIME=[D7D4C880:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: make sure no reserved addresses are allocated ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   71 ++++++++++++++++++++++++++++++++++++-------
 1 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8ff02ee..59ee1b9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -58,6 +58,9 @@ static struct dma_ops_domain *find_protection_domain(u16 devid);
 static u64* alloc_pte(struct protection_domain *dom,
 		      unsigned long address, u64
 		      **pte_page, gfp_t gfp);
+static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
+				      unsigned long start_page,
+				      unsigned int pages);
 
 #ifdef CONFIG_AMD_IOMMU_STATS
 
@@ -621,14 +624,42 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  */
 
 /*
+ * This function checks if there is a PTE for a given dma address. If
+ * there is one, it returns the pointer to it.
+ */
+static u64* fetch_pte(struct protection_domain *domain,
+		      unsigned long address)
+{
+	u64 *pte;
+
+	pte = &domain->pt_root[IOMMU_PTE_L2_INDEX(address)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return NULL;
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L1_INDEX(address)];
+
+	if (!IOMMU_PTE_PRESENT(*pte))
+		return NULL;
+
+	pte = IOMMU_PTE_PAGE(*pte);
+	pte = &pte[IOMMU_PTE_L0_INDEX(address)];
+
+	return pte;
+}
+
+/*
  * This function is used to add a new aperture range to an existing
  * aperture in case of dma_ops domain allocation or address allocation
  * failure.
  */
-static int alloc_new_range(struct dma_ops_domain *dma_dom,
+static int alloc_new_range(struct amd_iommu *iommu,
+			   struct dma_ops_domain *dma_dom,
 			   bool populate, gfp_t gfp)
 {
 	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
+	int i;
 
 	if (index >= APERTURE_MAX_RANGES)
 		return -ENOMEM;
@@ -662,6 +693,33 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 
 	dma_dom->aperture_size += APERTURE_RANGE_SIZE;
 
+	/* Intialize the exclusion range if necessary */
+	if (iommu->exclusion_start &&
+	    iommu->exclusion_start >= dma_dom->aperture[index]->offset &&
+	    iommu->exclusion_start < dma_dom->aperture_size) {
+		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
+		int pages = iommu_num_pages(iommu->exclusion_start,
+					    iommu->exclusion_length,
+					    PAGE_SIZE);
+		dma_ops_reserve_addresses(dma_dom, startpage, pages);
+	}
+
+	/*
+	 * Check for areas already mapped as present in the new aperture
+	 * range and mark those pages as reserved in the allocator. Such
+	 * mappings may already exist as a result of requested unity
+	 * mappings for devices.
+	 */
+	for (i = dma_dom->aperture[index]->offset;
+	     i < dma_dom->aperture_size;
+	     i += PAGE_SIZE) {
+		u64 *pte = fetch_pte(&dma_dom->domain, i);
+		if (!pte || !IOMMU_PTE_PRESENT(*pte))
+			continue;
+
+		dma_ops_reserve_addresses(dma_dom, i << PAGE_SHIFT, 1);
+	}
+
 	return 0;
 
 out_free:
@@ -911,7 +969,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->need_flush = false;
 	dma_dom->target_dev = 0xffff;
 
-	if (alloc_new_range(dma_dom, true, GFP_KERNEL))
+	if (alloc_new_range(iommu, dma_dom, true, GFP_KERNEL))
 		goto free_dma_dom;
 
 	/*
@@ -921,15 +979,6 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->aperture[0]->bitmap[0] = 1;
 	dma_dom->next_address = 0;
 
-	/* Intialize the exclusion range if necessary */
-	if (iommu->exclusion_start &&
-	    iommu->exclusion_start < dma_dom->aperture_size) {
-		unsigned long startpage = iommu->exclusion_start >> PAGE_SHIFT;
-		int pages = iommu_num_pages(iommu->exclusion_start,
-					    iommu->exclusion_length,
-					    PAGE_SIZE);
-		dma_ops_reserve_addresses(dma_dom, startpage, pages);
-	}
 
 	return dma_dom;
 
-- 
1.6.3.1


