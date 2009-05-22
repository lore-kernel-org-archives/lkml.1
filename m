Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZEVMXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZEVMXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758429AbZEVMWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21803 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758177AbZEVMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:21 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KK1P0V-01-JR2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/12] amd-iommu: introduce aperture_range structure
Date: Fri, 22 May 2009 14:21:22 +0200
Message-ID: <1242994893-28902-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:32.0720 (UTC) FILETIME=[D7A04B00:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: preperation for extended address allocator ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   32 +++++++++++++++-------
 arch/x86/kernel/amd_iommu.c            |   46 ++++++++++++++-----------------
 2 files changed, 43 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 95c8cd9..4c64c9b 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -195,6 +195,8 @@
 #define PD_DEFAULT_MASK		(1UL << 1) /* domain is a default dma_ops
 					      domain for an IOMMU */
 
+#define APERTURE_RANGE_SIZE	(128 * 1024 * 1024)
+
 /*
  * This structure contains generic data for  IOMMU protection domains
  * independent of their use.
@@ -210,6 +212,24 @@ struct protection_domain {
 };
 
 /*
+ * For dynamic growth the aperture size is split into ranges of 128MB of
+ * DMA address space each. This struct represents one such range.
+ */
+struct aperture_range {
+
+	/* address allocation bitmap */
+	unsigned long *bitmap;
+
+	/*
+	 * Array of PTE pages for the aperture. In this array we save all the
+	 * leaf pages of the domain page table used for the aperture. This way
+	 * we don't need to walk the page table to find a specific PTE. We can
+	 * just calculate its address in constant time.
+	 */
+	u64 *pte_pages[64];
+};
+
+/*
  * Data container for a dma_ops specific protection domain
  */
 struct dma_ops_domain {
@@ -224,16 +244,8 @@ struct dma_ops_domain {
 	/* address we start to search for free addresses */
 	unsigned long next_bit;
 
-	/* address allocation bitmap */
-	unsigned long *bitmap;
-
-	/*
-	 * Array of PTE pages for the aperture. In this array we save all the
-	 * leaf pages of the domain page table used for the aperture. This way
-	 * we don't need to walk the page table to find a specific PTE. We can
-	 * just calculate its address in constant time.
-	 */
-	u64 **pte_pages;
+	/* address space relevant data */
+	struct aperture_range aperture;
 
 	/* This will be set to true when TLB needs to be flushed */
 	bool need_flush;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a97db99..62acd09 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -595,7 +595,8 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 		 * as allocated in the aperture
 		 */
 		if (addr < dma_dom->aperture_size)
-			__set_bit(addr >> PAGE_SHIFT, dma_dom->bitmap);
+			__set_bit(addr >> PAGE_SHIFT,
+				  dma_dom->aperture.bitmap);
 	}
 
 	return 0;
@@ -656,11 +657,12 @@ static unsigned long dma_ops_alloc_addresses(struct device *dev,
 		dom->need_flush = true;
 	}
 
-	address = iommu_area_alloc(dom->bitmap, limit, dom->next_bit, pages,
-				   0 , boundary_size, align_mask);
+	address = iommu_area_alloc(dom->aperture.bitmap, limit, dom->next_bit,
+				   pages, 0 , boundary_size, align_mask);
 	if (address == -1) {
-		address = iommu_area_alloc(dom->bitmap, limit, 0, pages,
-				0, boundary_size, align_mask);
+		address = iommu_area_alloc(dom->aperture.bitmap, limit, 0,
+					   pages, 0, boundary_size,
+					   align_mask);
 		dom->need_flush = true;
 	}
 
@@ -685,7 +687,7 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 				   unsigned int pages)
 {
 	address >>= PAGE_SHIFT;
-	iommu_area_free(dom->bitmap, address, pages);
+	iommu_area_free(dom->aperture.bitmap, address, pages);
 
 	if (address >= dom->next_bit)
 		dom->need_flush = true;
@@ -741,7 +743,7 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 	if (start_page + pages > last_page)
 		pages = last_page - start_page;
 
-	iommu_area_reserve(dom->bitmap, start_page, pages);
+	iommu_area_reserve(dom->aperture.bitmap, start_page, pages);
 }
 
 static void free_pagetable(struct protection_domain *domain)
@@ -785,9 +787,7 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
 
 	free_pagetable(&dom->domain);
 
-	kfree(dom->pte_pages);
-
-	kfree(dom->bitmap);
+	free_page((unsigned long)dom->aperture.bitmap);
 
 	kfree(dom);
 }
@@ -826,16 +826,15 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->domain.priv = dma_dom;
 	if (!dma_dom->domain.pt_root)
 		goto free_dma_dom;
-	dma_dom->aperture_size = (1ULL << order);
-	dma_dom->bitmap = kzalloc(dma_dom->aperture_size / (PAGE_SIZE * 8),
-				  GFP_KERNEL);
-	if (!dma_dom->bitmap)
+	dma_dom->aperture_size = APERTURE_RANGE_SIZE;
+	dma_dom->aperture.bitmap = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!dma_dom->aperture.bitmap)
 		goto free_dma_dom;
 	/*
 	 * mark the first page as allocated so we never return 0 as
 	 * a valid dma-address. So we can use 0 as error value
 	 */
-	dma_dom->bitmap[0] = 1;
+	dma_dom->aperture.bitmap[0] = 1;
 	dma_dom->next_bit = 0;
 
 	dma_dom->need_flush = false;
@@ -854,13 +853,9 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	/*
 	 * At the last step, build the page tables so we don't need to
 	 * allocate page table pages in the dma_ops mapping/unmapping
-	 * path.
+	 * path for the first 128MB of dma address space.
 	 */
 	num_pte_pages = dma_dom->aperture_size / (PAGE_SIZE * 512);
-	dma_dom->pte_pages = kzalloc(num_pte_pages * sizeof(void *),
-			GFP_KERNEL);
-	if (!dma_dom->pte_pages)
-		goto free_dma_dom;
 
 	l2_pde = (u64 *)get_zeroed_page(GFP_KERNEL);
 	if (l2_pde == NULL)
@@ -869,10 +864,11 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->domain.pt_root[0] = IOMMU_L2_PDE(virt_to_phys(l2_pde));
 
 	for (i = 0; i < num_pte_pages; ++i) {
-		dma_dom->pte_pages[i] = (u64 *)get_zeroed_page(GFP_KERNEL);
-		if (!dma_dom->pte_pages[i])
+		u64 **pte_page = &dma_dom->aperture.pte_pages[i];
+		*pte_page = (u64 *)get_zeroed_page(GFP_KERNEL);
+		if (!*pte_page)
 			goto free_dma_dom;
-		address = virt_to_phys(dma_dom->pte_pages[i]);
+		address = virt_to_phys(*pte_page);
 		l2_pde[i] = IOMMU_L1_PDE(address);
 	}
 
@@ -1159,7 +1155,7 @@ static dma_addr_t dma_ops_domain_map(struct amd_iommu *iommu,
 
 	paddr &= PAGE_MASK;
 
-	pte  = dom->pte_pages[IOMMU_PTE_L1_INDEX(address)];
+	pte  = dom->aperture.pte_pages[IOMMU_PTE_L1_INDEX(address)];
 	pte += IOMMU_PTE_L0_INDEX(address);
 
 	__pte = paddr | IOMMU_PTE_P | IOMMU_PTE_FC;
@@ -1192,7 +1188,7 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 
 	WARN_ON(address & ~PAGE_MASK || address >= dom->aperture_size);
 
-	pte  = dom->pte_pages[IOMMU_PTE_L1_INDEX(address)];
+	pte  = dom->aperture.pte_pages[IOMMU_PTE_L1_INDEX(address)];
 	pte += IOMMU_PTE_L0_INDEX(address);
 
 	WARN_ON(!*pte);
-- 
1.6.3.1


