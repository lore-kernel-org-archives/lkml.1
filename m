Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZJBASF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZJBASF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbZJBASD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:18:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:37356 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbZJBAR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:17:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,490,1249282800"; 
   d="scan'208";a="499058838"
Message-Id: <20091001230744.229683461@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 01 Oct 2009 16:06:19 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/4] iommu: Allocate dma-remapping structures using numa locality info
References: <20091001230743.949931468@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=iommu_use_affinity_info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate dma-remapping structures using numa locality info. On platforms
having remapping hardware units span different nodes, this enables
optimized dma-remapping transalation structures access by remapping hardware.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/pci/intel-iommu.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

Index: tip/drivers/pci/intel-iommu.c
===================================================================
--- tip.orig/drivers/pci/intel-iommu.c
+++ tip/drivers/pci/intel-iommu.c
@@ -267,6 +267,7 @@ struct dmar_domain *si_domain;
 
 struct dmar_domain {
 	int	id;			/* domain id */
+	int	nid;			/* node id */
 	unsigned long iommu_bmp;	/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
@@ -390,15 +391,18 @@ static inline void *iommu_kmem_cache_all
 }
 
 
-static inline void *alloc_pgtable_page(void)
+static inline void *alloc_pgtable_page(int node)
 {
 	unsigned int flags;
-	void *vaddr;
+	struct page *page;
+	void *vaddr = NULL;
 
 	/* trying to avoid low memory issues */
 	flags = current->flags & PF_MEMALLOC;
 	current->flags |= PF_MEMALLOC;
-	vaddr = (void *)get_zeroed_page(GFP_ATOMIC);
+	page = alloc_pages_node(node, GFP_ATOMIC | __GFP_ZERO, 0);
+	if (page)
+		vaddr = page_address(page);
 	current->flags &= (~PF_MEMALLOC | flags);
 	return vaddr;
 }
@@ -579,7 +583,8 @@ static struct context_entry * device_to_
 	root = &iommu->root_entry[bus];
 	context = get_context_addr_from_root(root);
 	if (!context) {
-		context = (struct context_entry *)alloc_pgtable_page();
+		context = (struct context_entry *)
+				alloc_pgtable_page(iommu->node);
 		if (!context) {
 			spin_unlock_irqrestore(&iommu->lock, flags);
 			return NULL;
@@ -722,7 +727,7 @@ static struct dma_pte *pfn_to_dma_pte(st
 		if (!dma_pte_present(pte)) {
 			uint64_t pteval;
 
-			tmp_page = alloc_pgtable_page();
+			tmp_page = alloc_pgtable_page(domain->nid);
 
 			if (!tmp_page)
 				return NULL;
@@ -855,7 +860,7 @@ static int iommu_alloc_root_entry(struct
 	struct root_entry *root;
 	unsigned long flags;
 
-	root = (struct root_entry *)alloc_pgtable_page();
+	root = (struct root_entry *)alloc_pgtable_page(iommu->node);
 	if (!root)
 		return -ENOMEM;
 
@@ -1249,6 +1254,7 @@ static struct dmar_domain *alloc_domain(
 	if (!domain)
 		return NULL;
 
+	domain->nid = -1;
 	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
 	domain->flags = 0;
 
@@ -1409,9 +1415,10 @@ static int domain_init(struct dmar_domai
 		domain->iommu_snooping = 0;
 
 	domain->iommu_count = 1;
+	domain->nid = iommu->node;
 
 	/* always allocate the top pgd */
-	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
+	domain->pgd = (struct dma_pte *)alloc_pgtable_page(domain->nid);
 	if (!domain->pgd)
 		return -ENOMEM;
 	__iommu_flush_cache(iommu, domain->pgd, PAGE_SIZE);
@@ -1566,6 +1573,8 @@ static int domain_context_mapping_one(st
 	spin_lock_irqsave(&domain->iommu_lock, flags);
 	if (!test_and_set_bit(iommu->seq_id, &domain->iommu_bmp)) {
 		domain->iommu_count++;
+		if (domain->iommu_count == 1)
+			domain->nid = iommu->node;
 		domain_update_iommu_cap(domain);
 	}
 	spin_unlock_irqrestore(&domain->iommu_lock, flags);
@@ -3397,6 +3406,7 @@ static struct dmar_domain *iommu_alloc_v
 		return NULL;
 
 	domain->id = vm_domid++;
+	domain->nid = -1;
 	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
 
@@ -3423,9 +3433,10 @@ static int md_domain_init(struct dmar_do
 	domain->iommu_coherency = 0;
 	domain->iommu_snooping = 0;
 	domain->max_addr = 0;
+	domain->nid = -1;
 
 	/* always allocate the top pgd */
-	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
+	domain->pgd = (struct dma_pte *)alloc_pgtable_page(domain->nid);
 	if (!domain->pgd)
 		return -ENOMEM;
 	domain_flush_cache(domain, domain->pgd, PAGE_SIZE);


