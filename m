Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbZEVMY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbZEVMY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbZEVMWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:32 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:54606
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758248AbZEVMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:23 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KK1P10-01-JR7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/12] amd-iommu: move aperture_range allocation code to seperate function
Date: Fri, 22 May 2009 14:21:27 +0200
Message-ID: <1242994893-28902-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:33.0048 (UTC) FILETIME=[D7D25780:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: prepare dynamic increasement of apertures ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   95 ++++++++++++++++++++++++++----------------
 1 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c1a08b9..8ff02ee 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -620,6 +620,59 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  * called with domain->lock held
  */
 
+/*
+ * This function is used to add a new aperture range to an existing
+ * aperture in case of dma_ops domain allocation or address allocation
+ * failure.
+ */
+static int alloc_new_range(struct dma_ops_domain *dma_dom,
+			   bool populate, gfp_t gfp)
+{
+	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
+
+	if (index >= APERTURE_MAX_RANGES)
+		return -ENOMEM;
+
+	dma_dom->aperture[index] = kzalloc(sizeof(struct aperture_range), gfp);
+	if (!dma_dom->aperture[index])
+		return -ENOMEM;
+
+	dma_dom->aperture[index]->bitmap = (void *)get_zeroed_page(gfp);
+	if (!dma_dom->aperture[index]->bitmap)
+		goto out_free;
+
+	dma_dom->aperture[index]->offset = dma_dom->aperture_size;
+
+	if (populate) {
+		unsigned long address = dma_dom->aperture_size;
+		int i, num_ptes = APERTURE_RANGE_PAGES / 512;
+		u64 *pte, *pte_page;
+
+		for (i = 0; i < num_ptes; ++i) {
+			pte = alloc_pte(&dma_dom->domain, address,
+					&pte_page, gfp);
+			if (!pte)
+				goto out_free;
+
+			dma_dom->aperture[index]->pte_pages[i] = pte_page;
+
+			address += APERTURE_RANGE_SIZE / 64;
+		}
+	}
+
+	dma_dom->aperture_size += APERTURE_RANGE_SIZE;
+
+	return 0;
+
+out_free:
+	free_page((unsigned long)dma_dom->aperture[index]->bitmap);
+
+	kfree(dma_dom->aperture[index]);
+	dma_dom->aperture[index] = NULL;
+
+	return -ENOMEM;
+}
+
 static unsigned long dma_ops_area_alloc(struct device *dev,
 					struct dma_ops_domain *dom,
 					unsigned int pages,
@@ -832,9 +885,6 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 						   unsigned order)
 {
 	struct dma_ops_domain *dma_dom;
-	unsigned i, num_pte_pages;
-	u64 *l2_pde;
-	u64 address;
 
 	/*
 	 * Currently the DMA aperture must be between 32 MB and 1GB in size
@@ -846,11 +896,6 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	if (!dma_dom)
 		return NULL;
 
-	dma_dom->aperture[0] = kzalloc(sizeof(struct aperture_range),
-				       GFP_KERNEL);
-	if (!dma_dom->aperture[0])
-		goto free_dma_dom;
-
 	spin_lock_init(&dma_dom->domain.lock);
 
 	dma_dom->domain.id = domain_id_alloc();
@@ -862,10 +907,13 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->domain.priv = dma_dom;
 	if (!dma_dom->domain.pt_root)
 		goto free_dma_dom;
-	dma_dom->aperture_size = APERTURE_RANGE_SIZE;
-	dma_dom->aperture[0]->bitmap = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!dma_dom->aperture[0]->bitmap)
+
+	dma_dom->need_flush = false;
+	dma_dom->target_dev = 0xffff;
+
+	if (alloc_new_range(dma_dom, true, GFP_KERNEL))
 		goto free_dma_dom;
+
 	/*
 	 * mark the first page as allocated so we never return 0 as
 	 * a valid dma-address. So we can use 0 as error value
@@ -873,9 +921,6 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->aperture[0]->bitmap[0] = 1;
 	dma_dom->next_address = 0;
 
-	dma_dom->need_flush = false;
-	dma_dom->target_dev = 0xffff;
-
 	/* Intialize the exclusion range if necessary */
 	if (iommu->exclusion_start &&
 	    iommu->exclusion_start < dma_dom->aperture_size) {
@@ -886,28 +931,6 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 		dma_ops_reserve_addresses(dma_dom, startpage, pages);
 	}
 
-	/*
-	 * At the last step, build the page tables so we don't need to
-	 * allocate page table pages in the dma_ops mapping/unmapping
-	 * path for the first 128MB of dma address space.
-	 */
-	num_pte_pages = dma_dom->aperture_size / (PAGE_SIZE * 512);
-
-	l2_pde = (u64 *)get_zeroed_page(GFP_KERNEL);
-	if (l2_pde == NULL)
-		goto free_dma_dom;
-
-	dma_dom->domain.pt_root[0] = IOMMU_L2_PDE(virt_to_phys(l2_pde));
-
-	for (i = 0; i < num_pte_pages; ++i) {
-		u64 **pte_page = &dma_dom->aperture[0]->pte_pages[i];
-		*pte_page = (u64 *)get_zeroed_page(GFP_KERNEL);
-		if (!*pte_page)
-			goto free_dma_dom;
-		address = virt_to_phys(*pte_page);
-		l2_pde[i] = IOMMU_L1_PDE(address);
-	}
-
 	return dma_dom;
 
 free_dma_dom:
-- 
1.6.3.1


