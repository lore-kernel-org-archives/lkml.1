Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZJBSHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZJBSHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZJBSHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:07:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:64163 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbZJBSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:07:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,495,1249282800"; 
   d="scan'208";a="732522541"
Message-Id: <20091002180257.877207006@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 02 Oct 2009 11:01:24 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rdreier@cisco.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/4] iommu: Allocate dma-remapping structures using numa locality info
References: <20091002180120.234867335@sbs-t61.sc.intel.com>
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

Index: iommu-2.6/drivers/pci/intel-iommu.c
===================================================================
--- iommu-2.6.orig/drivers/pci/intel-iommu.c
+++ iommu-2.6/drivers/pci/intel-iommu.c
@@ -277,6 +277,7 @@ static int hw_pass_through = 1;
 
 struct dmar_domain {
 	int	id;			/* domain id */
+	int	nid;			/* node id */
 	unsigned long iommu_bmp;	/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
@@ -400,15 +401,18 @@ static inline void *iommu_kmem_cache_all
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
@@ -589,7 +593,8 @@ static struct context_entry * device_to_
 	root = &iommu->root_entry[bus];
 	context = get_context_addr_from_root(root);
 	if (!context) {
-		context = (struct context_entry *)alloc_pgtable_page();
+		context = (struct context_entry *)
+				alloc_pgtable_page(iommu->node);
 		if (!context) {
 			spin_unlock_irqrestore(&iommu->lock, flags);
 			return NULL;
@@ -732,7 +737,7 @@ static struct dma_pte *pfn_to_dma_pte(st
 		if (!dma_pte_present(pte)) {
 			uint64_t pteval;
 
-			tmp_page = alloc_pgtable_page();
+			tmp_page = alloc_pgtable_page(domain->nid);
 
 			if (!tmp_page)
 				return NULL;
@@ -868,7 +873,7 @@ static int iommu_alloc_root_entry(struct
 	struct root_entry *root;
 	unsigned long flags;
 
-	root = (struct root_entry *)alloc_pgtable_page();
+	root = (struct root_entry *)alloc_pgtable_page(iommu->node);
 	if (!root)
 		return -ENOMEM;
 
@@ -1263,6 +1268,7 @@ static struct dmar_domain *alloc_domain(
 	if (!domain)
 		return NULL;
 
+	domain->nid = -1;
 	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
 	domain->flags = 0;
 
@@ -1420,9 +1426,10 @@ static int domain_init(struct dmar_domai
 		domain->iommu_snooping = 0;
 
 	domain->iommu_count = 1;
+	domain->nid = iommu->node;
 
 	/* always allocate the top pgd */
-	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
+	domain->pgd = (struct dma_pte *)alloc_pgtable_page(domain->nid);
 	if (!domain->pgd)
 		return -ENOMEM;
 	__iommu_flush_cache(iommu, domain->pgd, PAGE_SIZE);
@@ -1577,6 +1584,8 @@ static int domain_context_mapping_one(st
 	spin_lock_irqsave(&domain->iommu_lock, flags);
 	if (!test_and_set_bit(iommu->seq_id, &domain->iommu_bmp)) {
 		domain->iommu_count++;
+		if (domain->iommu_count == 1)
+			domain->nid = iommu->node;
 		domain_update_iommu_cap(domain);
 	}
 	spin_unlock_irqrestore(&domain->iommu_lock, flags);
@@ -3416,6 +3425,7 @@ static struct dmar_domain *iommu_alloc_v
 		return NULL;
 
 	domain->id = vm_domid++;
+	domain->nid = -1;
 	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
 	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
 
@@ -3442,9 +3452,10 @@ static int md_domain_init(struct dmar_do
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


