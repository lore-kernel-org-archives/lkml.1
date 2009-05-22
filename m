Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbZEVMYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbZEVMYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZEVMWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:22:34 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:50822 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbZEVMWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:22:25 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KK1P0Y-02-JFZ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/12] amd-iommu: make address allocator aware of multiple aperture ranges
Date: Fri, 22 May 2009 14:21:25 +0200
Message-ID: <1242994893-28902-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:32.0767 (UTC) FILETIME=[D7A776F0:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: prepare to increase maximum aperture size to 4GB ]

This patch changes the AMD IOMMU address allocator to allow up to 32
aperture ranges per dma_ops domain.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   11 ++-
 arch/x86/kernel/amd_iommu.c            |  138 +++++++++++++++++++++++---------
 2 files changed, 110 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 4c64c9b..eca9129 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -195,7 +195,12 @@
 #define PD_DEFAULT_MASK		(1UL << 1) /* domain is a default dma_ops
 					      domain for an IOMMU */
 
-#define APERTURE_RANGE_SIZE	(128 * 1024 * 1024)
+#define APERTURE_RANGE_SHIFT	27	/* 128 MB */
+#define APERTURE_RANGE_SIZE	(1ULL << APERTURE_RANGE_SHIFT)
+#define APERTURE_RANGE_PAGES	(APERTURE_RANGE_SIZE >> PAGE_SHIFT)
+#define APERTURE_MAX_RANGES	32	/* allows 4GB of DMA address space */
+#define APERTURE_RANGE_INDEX(a)	((a) >> APERTURE_RANGE_SHIFT)
+#define APERTURE_PAGE_INDEX(a)	(((a) >> 21) & 0x3fULL)
 
 /*
  * This structure contains generic data for  IOMMU protection domains
@@ -227,6 +232,8 @@ struct aperture_range {
 	 * just calculate its address in constant time.
 	 */
 	u64 *pte_pages[64];
+
+	unsigned long offset;
 };
 
 /*
@@ -245,7 +252,7 @@ struct dma_ops_domain {
 	unsigned long next_bit;
 
 	/* address space relevant data */
-	struct aperture_range aperture;
+	struct aperture_range *aperture[APERTURE_MAX_RANGES];
 
 	/* This will be set to true when TLB needs to be flushed */
 	bool need_flush;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a467add..794163a 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -578,7 +578,7 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 		 */
 		if (addr < dma_dom->aperture_size)
 			__set_bit(addr >> PAGE_SHIFT,
-				  dma_dom->aperture.bitmap);
+				  dma_dom->aperture[0]->bitmap);
 	}
 
 	return 0;
@@ -615,43 +615,74 @@ static int init_unity_mappings_for_device(struct dma_ops_domain *dma_dom,
  ****************************************************************************/
 
 /*
- * The address allocator core function.
+ * The address allocator core functions.
  *
  * called with domain->lock held
  */
+
+static unsigned long dma_ops_area_alloc(struct device *dev,
+					struct dma_ops_domain *dom,
+					unsigned int pages,
+					unsigned long align_mask,
+					u64 dma_mask,
+					unsigned long start)
+{
+	unsigned long next_bit = dom->next_bit % APERTURE_RANGE_PAGES;
+	int max_index = dom->aperture_size >> APERTURE_RANGE_SHIFT;
+	int i = start >> APERTURE_RANGE_SHIFT;
+	unsigned long boundary_size;
+	unsigned long address = -1;
+	unsigned long limit;
+
+	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
+			PAGE_SIZE) >> PAGE_SHIFT;
+
+	for (;i < max_index; ++i) {
+		unsigned long offset = dom->aperture[i]->offset >> PAGE_SHIFT;
+
+		if (dom->aperture[i]->offset >= dma_mask)
+			break;
+
+		limit = iommu_device_max_index(APERTURE_RANGE_PAGES, offset,
+					       dma_mask >> PAGE_SHIFT);
+
+		address = iommu_area_alloc(dom->aperture[i]->bitmap,
+					   limit, next_bit, pages, 0,
+					    boundary_size, align_mask);
+		if (address != -1) {
+			address = dom->aperture[i]->offset +
+				  (address << PAGE_SHIFT);
+			dom->next_bit = (address >> PAGE_SHIFT) + pages;
+			break;
+		}
+
+		next_bit = 0;
+	}
+
+	return address;
+}
+
 static unsigned long dma_ops_alloc_addresses(struct device *dev,
 					     struct dma_ops_domain *dom,
 					     unsigned int pages,
 					     unsigned long align_mask,
 					     u64 dma_mask)
 {
-	unsigned long limit;
 	unsigned long address;
-	unsigned long boundary_size;
+	unsigned long start = dom->next_bit << PAGE_SHIFT;
 
-	boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
-			PAGE_SIZE) >> PAGE_SHIFT;
-	limit = iommu_device_max_index(dom->aperture_size >> PAGE_SHIFT, 0,
-				       dma_mask >> PAGE_SHIFT);
 
-	if (dom->next_bit >= limit) {
-		dom->next_bit = 0;
-		dom->need_flush = true;
-	}
+	address = dma_ops_area_alloc(dev, dom, pages, align_mask,
+				     dma_mask, start);
 
-	address = iommu_area_alloc(dom->aperture.bitmap, limit, dom->next_bit,
-				   pages, 0 , boundary_size, align_mask);
 	if (address == -1) {
-		address = iommu_area_alloc(dom->aperture.bitmap, limit, 0,
-					   pages, 0, boundary_size,
-					   align_mask);
+		dom->next_bit = 0;
+		address = dma_ops_area_alloc(dev, dom, pages, align_mask,
+					     dma_mask, 0);
 		dom->need_flush = true;
 	}
 
-	if (likely(address != -1)) {
-		dom->next_bit = address + pages;
-		address <<= PAGE_SHIFT;
-	} else
+	if (unlikely(address == -1))
 		address = bad_dma_address;
 
 	WARN_ON((address + (PAGE_SIZE*pages)) > dom->aperture_size);
@@ -668,11 +699,17 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 				   unsigned long address,
 				   unsigned int pages)
 {
-	address >>= PAGE_SHIFT;
-	iommu_area_free(dom->aperture.bitmap, address, pages);
+	unsigned i = address >> APERTURE_RANGE_SHIFT;
+	struct aperture_range *range = dom->aperture[i];
+
+	BUG_ON(i >= APERTURE_MAX_RANGES || range == NULL);
 
-	if (address >= dom->next_bit)
+	if ((address >> PAGE_SHIFT) >= dom->next_bit)
 		dom->need_flush = true;
+
+	address = (address % APERTURE_RANGE_SIZE) >> PAGE_SHIFT;
+	iommu_area_free(range->bitmap, address, pages);
+
 }
 
 /****************************************************************************
@@ -720,12 +757,16 @@ static void dma_ops_reserve_addresses(struct dma_ops_domain *dom,
 				      unsigned long start_page,
 				      unsigned int pages)
 {
-	unsigned int last_page = dom->aperture_size >> PAGE_SHIFT;
+	unsigned int i, last_page = dom->aperture_size >> PAGE_SHIFT;
 
 	if (start_page + pages > last_page)
 		pages = last_page - start_page;
 
-	iommu_area_reserve(dom->aperture.bitmap, start_page, pages);
+	for (i = start_page; i < start_page + pages; ++i) {
+		int index = i / APERTURE_RANGE_PAGES;
+		int page  = i % APERTURE_RANGE_PAGES;
+		__set_bit(page, dom->aperture[index]->bitmap);
+	}
 }
 
 static void free_pagetable(struct protection_domain *domain)
@@ -764,12 +805,19 @@ static void free_pagetable(struct protection_domain *domain)
  */
 static void dma_ops_domain_free(struct dma_ops_domain *dom)
 {
+	int i;
+
 	if (!dom)
 		return;
 
 	free_pagetable(&dom->domain);
 
-	free_page((unsigned long)dom->aperture.bitmap);
+	for (i = 0; i < APERTURE_MAX_RANGES; ++i) {
+		if (!dom->aperture[i])
+			continue;
+		free_page((unsigned long)dom->aperture[i]->bitmap);
+		kfree(dom->aperture[i]);
+	}
 
 	kfree(dom);
 }
@@ -797,6 +845,11 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	if (!dma_dom)
 		return NULL;
 
+	dma_dom->aperture[0] = kzalloc(sizeof(struct aperture_range),
+				       GFP_KERNEL);
+	if (!dma_dom->aperture[0])
+		goto free_dma_dom;
+
 	spin_lock_init(&dma_dom->domain.lock);
 
 	dma_dom->domain.id = domain_id_alloc();
@@ -809,14 +862,14 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	if (!dma_dom->domain.pt_root)
 		goto free_dma_dom;
 	dma_dom->aperture_size = APERTURE_RANGE_SIZE;
-	dma_dom->aperture.bitmap = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!dma_dom->aperture.bitmap)
+	dma_dom->aperture[0]->bitmap = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!dma_dom->aperture[0]->bitmap)
 		goto free_dma_dom;
 	/*
 	 * mark the first page as allocated so we never return 0 as
 	 * a valid dma-address. So we can use 0 as error value
 	 */
-	dma_dom->aperture.bitmap[0] = 1;
+	dma_dom->aperture[0]->bitmap[0] = 1;
 	dma_dom->next_bit = 0;
 
 	dma_dom->need_flush = false;
@@ -846,7 +899,7 @@ static struct dma_ops_domain *dma_ops_domain_alloc(struct amd_iommu *iommu,
 	dma_dom->domain.pt_root[0] = IOMMU_L2_PDE(virt_to_phys(l2_pde));
 
 	for (i = 0; i < num_pte_pages; ++i) {
-		u64 **pte_page = &dma_dom->aperture.pte_pages[i];
+		u64 **pte_page = &dma_dom->aperture[0]->pte_pages[i];
 		*pte_page = (u64 *)get_zeroed_page(GFP_KERNEL);
 		if (!*pte_page)
 			goto free_dma_dom;
@@ -1164,14 +1217,19 @@ static u64* alloc_pte(struct protection_domain *dom,
 static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 			    unsigned long address)
 {
-	struct aperture_range *aperture = &dom->aperture;
+	struct aperture_range *aperture;
 	u64 *pte, *pte_page;
 
-	pte = aperture->pte_pages[IOMMU_PTE_L1_INDEX(address)];
+	aperture = dom->aperture[APERTURE_RANGE_INDEX(address)];
+	if (!aperture)
+		return NULL;
+
+	pte = aperture->pte_pages[APERTURE_PAGE_INDEX(address)];
 	if (!pte) {
 		pte = alloc_pte(&dom->domain, address, &pte_page, GFP_ATOMIC);
-		aperture->pte_pages[IOMMU_PTE_L1_INDEX(address)] = pte_page;
-	}
+		aperture->pte_pages[APERTURE_PAGE_INDEX(address)] = pte_page;
+	} else
+		pte += IOMMU_PTE_L0_INDEX(address);
 
 	return pte;
 }
@@ -1219,14 +1277,20 @@ static void dma_ops_domain_unmap(struct amd_iommu *iommu,
 				 struct dma_ops_domain *dom,
 				 unsigned long address)
 {
+	struct aperture_range *aperture;
 	u64 *pte;
 
 	if (address >= dom->aperture_size)
 		return;
 
-	WARN_ON(address & ~PAGE_MASK || address >= dom->aperture_size);
+	aperture = dom->aperture[APERTURE_RANGE_INDEX(address)];
+	if (!aperture)
+		return;
+
+	pte  = aperture->pte_pages[APERTURE_PAGE_INDEX(address)];
+	if (!pte)
+		return;
 
-	pte  = dom->aperture.pte_pages[IOMMU_PTE_L1_INDEX(address)];
 	pte += IOMMU_PTE_L0_INDEX(address);
 
 	WARN_ON(!*pte);
-- 
1.6.3.1


