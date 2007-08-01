Return-Path: <linux-kernel-owner+w=401wt.eu-S1759131AbXHAUMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759131AbXHAUMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXHAUMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:12:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:63247 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXHAUM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:12:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,210,1183359600"; 
   d="scan'208";a="257468608"
Date: Wed, 1 Aug 2007 13:06:23 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Andi K <ak@suse.de>, akpm@linux-foundation.org,
       arjan <arjan@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
       Suresh B <suresh.b.siddha@intel.com>
Subject: [patch -mm][Intel-IOMMU] Optimize sg map/unmap calls
Message-ID: <20070801200623.GA20780@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PageSelectiveInvalidation support 
replacing existing DomainSelectiveInvalidation for 
intel_{map/unmap}_sg() calls and also enables
to mapping one big contiguous DMA virtual address
which is mapped to discontiguous physical address
for SG map/unmap calls.


"Doamin selective invalidations" wipes out the IOMMU address
translation cache based on domain ID where as "Page selective
invalidations" wipes out the IOMMU address translation cache for
that address mask range which is more cache friendly when
compared to Domain selective invalidations.


Here is how it is done.
1) changes to iova.c
alloc_iova() now takes a bool size_aligned argument, which
when when set, returns the io virtual address that is 
naturally aligned to 2 ^ x, where x is the order 
of the size requested.

Returning this io vitual address which is naturally 
aligned helps iommu to do the "page selective 
invalidations" which is IOMMU cache friendly
over "domain selective invalidations".

2) Changes to driver/pci/intel-iommu.c
Clean up intel_{map/unmap}_{single/sg} () calls so that
s/g map/unamp calls is no more dependent on 
intel_{map/unmap}_single()

intel_map_sg() now computes the total DMA virtual address
required and allocates the size aligned total DMA virtual address
and maps the discontiguous physical address to the allocated
contiguous DMA virtual address.

In the intel_unmap_sg() case since the DMA virtual address
is contiguous and size_aligned, PageSelectiveInvalidation
is used replacing earlier DomainSelectiveInvalidations.

Andrew,
	Please add this patch to you mm queue.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 drivers/pci/intel-iommu.c |  325 +++++++++++++++++++++++++---------------------
 drivers/pci/iova.c        |   63 +++++++-
 drivers/pci/iova.h        |    3 
 3 files changed, 231 insertions(+), 160 deletions(-)

Index: work/drivers/pci/intel-iommu.c
===================================================================
--- work.orig/drivers/pci/intel-iommu.c	2007-08-01 11:18:12.000000000 -0700
+++ work/drivers/pci/intel-iommu.c	2007-08-01 11:18:31.000000000 -0700
@@ -665,24 +665,10 @@
 		non_present_entry_flush);
 }
 
-static int iommu_get_alignment(u64 base, unsigned int size)
-{
-	int t = 0;
-	u64 end;
-
-	end = base + size - 1;
-	while (base != end) {
-		t++;
-		base >>= 1;
-		end >>= 1;
-	}
-	return t;
-}
-
 static int iommu_flush_iotlb_psi(struct intel_iommu *iommu, u16 did,
 	u64 addr, unsigned int pages, int non_present_entry_flush)
 {
-	unsigned int align;
+	unsigned int mask;
 
 	BUG_ON(addr & (~PAGE_MASK_4K));
 	BUG_ON(pages == 0);
@@ -696,16 +682,13 @@
 	 * PSI requires page size to be 2 ^ x, and the base address is naturally
 	 * aligned to the size
 	 */
-	align = iommu_get_alignment(addr >> PAGE_SHIFT_4K, pages);
+	mask = ilog2(__roundup_pow_of_two(pages));
 	/* Fallback to domain selective flush if size is too big */
-	if (align > cap_max_amask_val(iommu->cap))
+	if (mask > cap_max_amask_val(iommu->cap))
 		return iommu_flush_iotlb_dsi(iommu, did,
 			non_present_entry_flush);
 
-	addr >>= PAGE_SHIFT_4K + align;
-	addr <<= PAGE_SHIFT_4K + align;
-
-	return __iommu_flush_iotlb(iommu, did, addr, align,
+	return __iommu_flush_iotlb(iommu, did, addr, mask,
 		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
 }
 
@@ -1772,78 +1755,103 @@
 }
 
 struct iova *
-iommu_alloc_iova(struct dmar_domain *domain, void *host_addr, size_t size,
-		u64 start, u64 end)
+iommu_alloc_iova(struct dmar_domain *domain, size_t size, u64 end)
 {
-	u64 start_addr;
 	struct iova *piova;
 
 	/* Make sure it's in range */
-	if ((start > DOMAIN_MAX_ADDR(domain->gaw)) || end < start)
-		return NULL;
-
 	end = min_t(u64, DOMAIN_MAX_ADDR(domain->gaw), end);
-	start_addr = PAGE_ALIGN_4K(start);
-	size = aligned_size((u64)host_addr, size);
-	if (!size || (start_addr + size > end))
+	if (!size || (IOVA_START_ADDR + size > end))
 		return NULL;
 
 	piova = alloc_iova(&domain->iovad,
-			size >> PAGE_SHIFT_4K, IOVA_PFN(end));
-
+			size >> PAGE_SHIFT_4K, IOVA_PFN(end), 1);
 	return piova;
 }
 
-static dma_addr_t __intel_map_single(struct device *dev, void *addr,
-	size_t size, int dir, u64 *flush_addr, unsigned int *flush_size)
+static struct iova *
+__intel_alloc_iova(struct device *dev, struct dmar_domain *domain,
+		size_t size)
 {
-	struct dmar_domain *domain;
 	struct pci_dev *pdev = to_pci_dev(dev);
-	int ret;
-	int prot = 0;
 	struct iova *iova = NULL;
-	u64 start_addr;
-
-	addr = (void *)virt_to_phys(addr);
-
-	domain = get_domain_for_dev(pdev,
-			DEFAULT_DOMAIN_ADDRESS_WIDTH);
-	if (!domain) {
-		printk(KERN_ERR
-			"Allocating domain for %s failed", pci_name(pdev));
-		return 0;
-	}
-
-	start_addr = IOVA_START_ADDR;
 
 	if ((pdev->dma_mask <= DMA_32BIT_MASK) || (dmar_forcedac)) {
-		iova = iommu_alloc_iova(domain, addr, size, start_addr,
-			pdev->dma_mask);
+		iova = iommu_alloc_iova(domain, size, pdev->dma_mask);
 	} else  {
 		/*
 		 * First try to allocate an io virtual address in
 		 * DMA_32BIT_MASK and if that fails then try allocating
 		 * from higer range
 		 */
-		iova = iommu_alloc_iova(domain, addr, size, start_addr,
-			DMA_32BIT_MASK);
+		iova = iommu_alloc_iova(domain, size, DMA_32BIT_MASK);
 		if (!iova)
-			iova = iommu_alloc_iova(domain, addr, size, start_addr,
-			pdev->dma_mask);
+			iova = iommu_alloc_iova(domain, size, pdev->dma_mask);
 	}
 
 	if (!iova) {
 		printk(KERN_ERR"Allocating iova for %s failed", pci_name(pdev));
+		return NULL;
+	}
+
+	return iova;
+}
+
+static struct dmar_domain *
+get_valid_domain_for_dev(struct pci_dev *pdev)
+{
+	struct dmar_domain *domain;
+	int ret;
+
+	domain = get_domain_for_dev(pdev,
+			DEFAULT_DOMAIN_ADDRESS_WIDTH);
+	if (!domain) {
+		printk(KERN_ERR
+			"Allocating domain for %s failed", pci_name(pdev));
 		return 0;
 	}
 
 	/* make sure context mapping is ok */
 	if (unlikely(!domain_context_mapped(domain, pdev))) {
 		ret = domain_context_mapping(domain, pdev);
-		if (ret)
-			goto error;
+		if (ret) {
+			printk(KERN_ERR
+				"Domain context map for %s failed",
+				pci_name(pdev));
+			return 0;
+		}
 	}
 
+	return domain;
+}
+
+static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
+	size_t size, int dir)
+{
+	struct pci_dev *pdev = to_pci_dev(hwdev);
+	int ret;
+	struct dmar_domain *domain;
+	unsigned long start_addr;
+	struct iova *iova;
+	int prot = 0;
+
+	BUG_ON(dir == DMA_NONE);
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return virt_to_bus(addr);
+
+	domain = get_valid_domain_for_dev(pdev);
+	if (!domain)
+		return 0;
+
+	addr = (void *)virt_to_phys(addr);
+	size = aligned_size((u64)addr, size);
+
+	iova = __intel_alloc_iova(hwdev, domain, size);
+	if (!iova)
+		goto error;
+
+	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+
 	/*
 	 * Check if DMAR supports zero-length reads on write only
 	 * mappings..
@@ -1859,101 +1867,65 @@
 	 * might have two guest_addr mapping to the same host addr, but this
 	 * is not a big problem
 	 */
-	ret = domain_page_mapping(domain, iova->pfn_lo << PAGE_SHIFT_4K,
-		((u64)addr) & PAGE_MASK_4K,
-		(iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K, prot);
+	ret = domain_page_mapping(domain, start_addr,
+		((u64)addr) & PAGE_MASK_4K, size, prot);
 	if (ret)
 		goto error;
 
 	pr_debug("Device %s request: %lx@%llx mapping: %lx@%llx, dir %d\n",
 		pci_name(pdev), size, (u64)addr,
-		(iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K,
-		(u64)(iova->pfn_lo << PAGE_SHIFT_4K), dir);
+		size, (u64)start_addr, dir);
+
+	/* it's a non-present to present mapping */
+	ret = iommu_flush_iotlb_psi(domain->iommu, domain->id,
+			start_addr, size >> PAGE_SHIFT_4K, 1);
+	if (ret)
+		iommu_flush_write_buffer(domain->iommu);
+
+	return (start_addr + ((u64)addr & (~PAGE_MASK_4K)));
 
-	*flush_addr = iova->pfn_lo << PAGE_SHIFT_4K;
-	*flush_size = (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K;
-	return (iova->pfn_lo << PAGE_SHIFT_4K) + ((u64)addr & (~PAGE_MASK_4K));
 error:
-	__free_iova(&domain->iovad, iova);
+	if (iova)
+		__free_iova(&domain->iovad, iova);
 	printk(KERN_ERR"Device %s request: %lx@%llx dir %d --- failed\n",
 		pci_name(pdev), size, (u64)addr, dir);
 	return 0;
 }
 
-static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
+static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
 	size_t size, int dir)
 {
-	struct pci_dev *pdev = to_pci_dev(hwdev);
-	dma_addr_t ret;
-	struct dmar_domain *domain;
-	u64 flush_addr;
-	unsigned int flush_size;
-
-	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
-		return virt_to_bus(addr);
-
-	ret = __intel_map_single(hwdev, addr, size,
-			dir, &flush_addr, &flush_size);
-	if (ret) {
-		domain = find_domain(pdev);
-		/* it's a non-present to present mapping */
-		if (iommu_flush_iotlb_psi(domain->iommu, domain->id,
-				flush_addr, flush_size >> PAGE_SHIFT_4K, 1))
-			iommu_flush_write_buffer(domain->iommu);
-	}
-	return ret;
-}
-
-static void __intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
-	size_t size, int dir, u64 *flush_addr, unsigned int *flush_size)
-{
-	struct dmar_domain *domain;
 	struct pci_dev *pdev = to_pci_dev(dev);
+	struct dmar_domain *domain;
+	unsigned long start_addr;
 	struct iova *iova;
 
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
 
 	iova = find_iova(&domain->iovad, IOVA_PFN(dev_addr));
-	if (!iova) {
-		*flush_size = 0;
+	if (!iova)
 		return;
-	}
-	pr_debug("Device %s unmapping: %lx@%llx\n",
-		pci_name(pdev),
-		(iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K,
-		(u64)(iova->pfn_lo << PAGE_SHIFT_4K));
-
-	*flush_addr = iova->pfn_lo << PAGE_SHIFT_4K;
-	*flush_size = (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K;
-	/*  clear the whole page, not just dev_addr - (dev_addr + size) */
-	dma_pte_clear_range(domain, *flush_addr, *flush_addr + *flush_size);
-	/* free page tables */
-	dma_pte_free_pagetable(domain, *flush_addr, *flush_addr + *flush_size);
-	/* free iova */
-	__free_iova(&domain->iovad, iova);
-}
 
-static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
-	size_t size, int dir)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct dmar_domain *domain;
-	u64 flush_addr;
-	unsigned int flush_size;
+	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	size = aligned_size((u64)dev_addr, size);
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
-		return;
+	pr_debug("Device %s unmapping: %lx@%llx\n",
+		pci_name(pdev), size, (u64)start_addr);
 
-	domain = find_domain(pdev);
-	__intel_unmap_single(dev, dev_addr, size,
-		dir, &flush_addr, &flush_size);
-	if (flush_size == 0)
-		return;
-	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, flush_addr,
-			flush_size >> PAGE_SHIFT_4K, 0))
+	/*  clear the whole page */
+	dma_pte_clear_range(domain, start_addr, start_addr + size);
+	/* free page tables */
+	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
+
+	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, start_addr,
+			size >> PAGE_SHIFT_4K, 0))
 		iommu_flush_write_buffer(domain->iommu);
+
+	/* free iova */
+	__free_iova(&domain->iovad, iova);
 }
 
 static void * intel_alloc_coherent(struct device *hwdev, size_t size,
@@ -1990,28 +1962,46 @@
 	free_pages((unsigned long)vaddr, order);
 }
 
+#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
 static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sg,
 	int nelems, int dir)
 {
 	int i;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
-	u64 flush_addr;
-	unsigned int flush_size;
+	unsigned long start_addr;
+	struct iova *iova;
+	size_t size = 0;
+	void *addr;
 
 	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
-	for (i = 0; i < nelems; i++, sg++)
-		__intel_unmap_single(hwdev, sg->dma_address,
-			sg->dma_length, dir, &flush_addr, &flush_size);
 
-	if (iommu_flush_iotlb_dsi(domain->iommu, domain->id, 0))
+	iova = find_iova(&domain->iovad, IOVA_PFN(sg[0].dma_address));
+	if (!iova)
+		return;
+	for (i = 0; i < nelems; i++, sg++) {
+		addr = SG_ENT_VIRT_ADDRESS(sg);
+		size += aligned_size((u64)addr, sg->length);
+	}
+
+	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+
+	/*  clear the whole page */
+	dma_pte_clear_range(domain, start_addr, start_addr + size);
+	/* free page tables */
+	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
+
+	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, start_addr,
+			size >> PAGE_SHIFT_4K, 0))
 		iommu_flush_write_buffer(domain->iommu);
+
+	/* free iova */
+	__free_iova(&domain->iovad, iova);
 }
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
 static int intel_nontranslate_map_sg(struct device *hddev,
 	struct scatterlist *sg, int nelems, int dir)
 {
@@ -2031,33 +2021,76 @@
 {
 	void *addr;
 	int i;
-	dma_addr_t dma_handle;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
-	u64 flush_addr;
-	unsigned int flush_size;
+	size_t size = 0;
+	int prot = 0;
+	size_t offset = 0;
+	struct iova *iova = NULL;
+	int ret;
+	struct scatterlist *orig_sg = sg;
+	unsigned long start_addr;
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
 		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
 
+	domain = get_valid_domain_for_dev(pdev);
+	if (!domain)
+		return 0;
+
 	for (i = 0; i < nelems; i++, sg++) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
-		dma_handle = __intel_map_single(hwdev, addr,
-				sg->length, dir, &flush_addr, &flush_size);
-		if (!dma_handle) {
-			intel_unmap_sg(hwdev, sg - i, i, dir);
-			sg[0].dma_length = 0;
+		addr = (void *)virt_to_phys(addr);
+		size += aligned_size((u64)addr, sg->length);
+	}
+
+	iova = __intel_alloc_iova(hwdev, domain, size);
+	if (!iova) {
+		orig_sg->dma_length = 0;
+		return 0;
+	}
+
+	/*
+	 * Check if DMAR supports zero-length reads on write only
+	 * mappings..
+	 */
+	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL || \
+			!cap_zlr(domain->iommu->cap))
+		prot |= DMA_PTE_READ;
+	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
+		prot |= DMA_PTE_WRITE;
+
+	start_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	offset = 0;
+	sg = orig_sg;
+	for (i = 0; i < nelems; i++, sg++) {
+		addr = SG_ENT_VIRT_ADDRESS(sg);
+		addr = (void *)virt_to_phys(addr);
+		size = aligned_size((u64)addr, sg->length);
+		ret = domain_page_mapping(domain, start_addr + offset,
+			((u64)addr) & PAGE_MASK_4K,
+			size, prot);
+		if (ret) {
+			/*  clear the page */
+			dma_pte_clear_range(domain, start_addr,
+				  start_addr + offset);
+			/* free page tables */
+			dma_pte_free_pagetable(domain, start_addr,
+				  start_addr + offset);
+			/* free iova */
+			__free_iova(&domain->iovad, iova);
 			return 0;
 		}
-		sg->dma_address = dma_handle;
+		sg->dma_address = start_addr + offset +
+				((u64)addr & (~PAGE_MASK_4K));
 		sg->dma_length = sg->length;
+		offset += size;
 	}
 
-	domain = find_domain(pdev);
-
 	/* it's a non-present to present mapping */
-	if (iommu_flush_iotlb_dsi(domain->iommu, domain->id, 1))
+	if (iommu_flush_iotlb_psi(domain->iommu, domain->id,
+			start_addr, offset >> PAGE_SHIFT_4K, 1))
 		iommu_flush_write_buffer(domain->iommu);
 	return nelems;
 }
Index: work/drivers/pci/iova.c
===================================================================
--- work.orig/drivers/pci/iova.c	2007-08-01 11:18:14.000000000 -0700
+++ work/drivers/pci/iova.c	2007-08-01 11:18:31.000000000 -0700
@@ -57,12 +57,28 @@
 		iovad->cached32_node = rb_next(&free->node);
 }
 
-static int __alloc_iova_range(struct iova_domain *iovad,
-	unsigned long size, unsigned long limit_pfn, struct iova *new)
+/* Computes the padding size required, to make the
+ * the start address naturally aligned on its size
+ */
+static int
+iova_get_pad_size(int size, unsigned int limit_pfn)
+{
+	unsigned int pad_size = 0;
+	unsigned int order = ilog2(size);
+
+	if (order)
+		pad_size = (limit_pfn + 1) % (1 << order);
+
+	return pad_size;
+}
+
+static int __alloc_iova_range(struct iova_domain *iovad, unsigned long size,
+		unsigned long limit_pfn, struct iova *new, bool size_aligned)
 {
 	struct rb_node *curr = NULL;
 	unsigned long flags;
 	unsigned long saved_pfn;
+	unsigned int pad_size = 0;
 
 	/* Walk the tree backwards */
 	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
@@ -72,22 +88,32 @@
 		struct iova *curr_iova = container_of(curr, struct iova, node);
 		if (limit_pfn < curr_iova->pfn_lo)
 			goto move_left;
-		if (limit_pfn < curr_iova->pfn_hi)
+		else if (limit_pfn < curr_iova->pfn_hi)
 			goto adjust_limit_pfn;
-		if ((curr_iova->pfn_hi + size) <= limit_pfn)
-			break;	/* found a free slot */
+		else {
+			if (size_aligned)
+				pad_size = iova_get_pad_size(size, limit_pfn);
+			if ((curr_iova->pfn_hi + size + pad_size) <= limit_pfn)
+				break;	/* found a free slot */
+		}
 adjust_limit_pfn:
 		limit_pfn = curr_iova->pfn_lo - 1;
 move_left:
 		curr = rb_prev(curr);
 	}
 
-	if ((!curr) && !(IOVA_START_PFN + size <= limit_pfn)) {
-		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-		return -ENOMEM;
+	if (!curr) {
+		if (size_aligned)
+			pad_size = iova_get_pad_size(size, limit_pfn);
+		if ((IOVA_START_PFN + size + pad_size) > limit_pfn) {
+			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+			return -ENOMEM;
+		}
 	}
-	new->pfn_hi = limit_pfn;
-	new->pfn_lo = limit_pfn - size + 1;
+
+	/* pfn_lo will point to size aligned address if size_aligned is set */
+	new->pfn_lo = limit_pfn - (size + pad_size) + 1;
+	new->pfn_hi = new->pfn_lo + size - 1;
 
 	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
 	return 0;
@@ -119,12 +145,16 @@
  * @iovad - iova domain in question
  * @size - size of page frames to allocate
  * @limit_pfn - max limit address
+ * @size_aligned - set if size_aligned address range is required
  * This function allocates an iova in the range limit_pfn to IOVA_START_PFN
- * looking from limit_pfn instead from IOVA_START_PFN.
+ * looking from limit_pfn instead from IOVA_START_PFN. If the size_aligned
+ * flag is set then the allocated address iova->pfn_lo will be naturally
+ * aligned on roundup_power_of_two(size).
  */
 struct iova *
 alloc_iova(struct iova_domain *iovad, unsigned long size,
-	unsigned long limit_pfn)
+	unsigned long limit_pfn,
+	bool size_aligned)
 {
 	unsigned long flags;
 	struct iova *new_iova;
@@ -134,8 +164,15 @@
 	if (!new_iova)
 		return NULL;
 
+	/* If size aligned is set then round the size to
+	 * to next power of two.
+	 */
+	if (size_aligned)
+		size = __roundup_pow_of_two(size);
+
 	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
-	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova);
+	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova,
+			size_aligned);
 
 	if (ret) {
 		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
Index: work/drivers/pci/iova.h
===================================================================
--- work.orig/drivers/pci/iova.h	2007-08-01 11:18:14.000000000 -0700
+++ work/drivers/pci/iova.h	2007-08-01 11:18:31.000000000 -0700
@@ -51,7 +51,8 @@
 void free_iova(struct iova_domain *iovad, unsigned long pfn);
 void __free_iova(struct iova_domain *iovad, struct iova *iova);
 struct iova *alloc_iova(struct iova_domain *iovad, unsigned long size,
-	unsigned long limit_pfn);
+	unsigned long limit_pfn,
+	bool size_aligned);
 struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
 	unsigned long pfn_hi);
 void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
