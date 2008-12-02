Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbYLBND5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbYLBND5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbYLBNCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:02:00 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:5385 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbYLBNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:47 -0500
X-BigFish: VPS3(zzzzzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KB92UB-04-VCN-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Weidong Han <weidong.han@intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/12] VT-d: Support multiple device assignment for KVM
Date: Tue, 2 Dec 2008 14:01:12 +0100
Message-ID: <1228222883-17207-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0786 (UTC) FILETIME=[142CC2A0:01C9547E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weidong Han <weidong.han@intel.com>

In order to support multiple device assignment for KVM, this patch does
following main changes:

- extend dmar_domain to own multiple devices from different iommus,
  use a bitmap of iommus to replace iommu pointer in dmar_domain.
- implement independent low level functions for kvm, then won't
  impact native VT-d.
- "SAGAW" capability may be different across iommus, that's to
  say the VT-d page table levels may be different among iommus.
  This patch uses a defaut agaw, and skip top levels of page
  tables for iommus which have smaller agaw than default.
- rename the APIs for kvm VT-d, make it more readable.

[Joerg: coding style cleanups]

Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/dmar.c            |   15 +-
 drivers/pci/intel-iommu.c     |  696 ++++++++++++++++++++++++++++++++++------
 include/linux/dma_remapping.h |   21 +-
 include/linux/dmar.h          |    2 +
 include/linux/intel-iommu.h   |   21 +-
 5 files changed, 636 insertions(+), 119 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 691b3ad..d54d3db 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -484,13 +484,14 @@ void __init detect_intel_iommu(void)
 	dmar_tbl = NULL;
 }
 
-
 int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
 	int map_size;
 	u32 ver;
 	static int iommu_allocated = 0;
+	unsigned long sagaw;
+	int agaw;
 
 	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
@@ -506,6 +507,18 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
 	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
 
+	/* set agaw, "SAGAW" may be different across iommus */
+	sagaw = cap_sagaw(iommu->cap);
+	for (agaw = width_to_agaw(DEFAULT_DOMAIN_ADDRESS_WIDTH);
+	     agaw >= 0; agaw--)
+		if (test_bit(agaw, &sagaw))
+			break;
+	if (agaw < 0) {
+		printk(KERN_ERR "IOMMU: unsupported sagaw %lx\n", sagaw);
+		goto error;
+	}
+	iommu->agaw = agaw;
+
 	/* the registers might be more than one page */
 	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
 		cap_max_fault_reg_offset(iommu->cap));
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 5c8baa4..7f12852 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -50,8 +50,6 @@
 #define IOAPIC_RANGE_END	(0xfeefffff)
 #define IOVA_START_ADDR		(0x1000)
 
-#define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
-
 #define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
 
 
@@ -64,6 +62,7 @@ struct deferred_flush_tables {
 	int next;
 	struct iova *iova[HIGH_WATER_MARK];
 	struct dmar_domain *domain[HIGH_WATER_MARK];
+	struct intel_iommu *iommu;
 };
 
 static struct deferred_flush_tables *deferred_flush;
@@ -184,6 +183,68 @@ void free_iova_mem(struct iova *iova)
 	kmem_cache_free(iommu_iova_cache, iova);
 }
 
+/* in native case, each domain is related to only one iommu */
+static struct intel_iommu *domain_get_only_iommu(struct dmar_domain *domain)
+{
+	struct dmar_drhd_unit *drhd;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		if (test_bit(drhd->iommu->seq_id, &domain->iommu_bmp))
+			return drhd->iommu;
+	}
+
+	return NULL;
+}
+
+static void domain_flush_cache(struct dmar_domain *domain,
+			       void *addr, int size)
+{
+	struct intel_iommu *iommu;
+
+	if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) {
+		struct dmar_drhd_unit *drhd;
+
+		for_each_drhd_unit(drhd) {
+			if (drhd->ignored)
+				continue;
+			iommu = drhd->iommu;
+
+			if (!test_bit(iommu->seq_id, &domain->iommu_bmp))
+				continue;
+
+			if (!ecap_coherent(iommu->ecap))
+				clflush_cache_range(addr, size);
+		}
+	} else {
+		iommu = domain_get_only_iommu(domain);
+		if (iommu && !ecap_coherent(iommu->ecap))
+			clflush_cache_range(addr, size);
+	}
+}
+
+static struct intel_iommu *device_find_matched_iommu(u8 bus, u8 devfn)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+	int i;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		for (i = 0; i < drhd->devices_cnt; i++)
+			if (drhd->devices[i]->bus->number == bus &&
+			    drhd->devices[i]->devfn == devfn)
+				return drhd->iommu;
+
+		if (drhd->include_all)
+			return drhd->iommu;
+	}
+
+	return NULL;
+}
+
 /* Gets context entry for a given bus and devfn */
 static struct context_entry * device_to_context_entry(struct intel_iommu *iommu,
 		u8 bus, u8 devfn)
@@ -287,7 +348,7 @@ static inline int agaw_to_width(int agaw)
 
 }
 
-static inline int width_to_agaw(int width)
+int width_to_agaw(int width)
 {
 	return (width - 30) / LEVEL_STRIDE;
 }
@@ -347,8 +408,7 @@ static struct dma_pte * addr_to_dma_pte(struct dmar_domain *domain, u64 addr)
 					flags);
 				return NULL;
 			}
-			__iommu_flush_cache(domain->iommu, tmp_page,
-					PAGE_SIZE);
+			domain_flush_cache(domain, tmp_page, PAGE_SIZE);
 			dma_set_pte_addr(*pte, virt_to_phys(tmp_page));
 			/*
 			 * high level table always sets r/w, last level page
@@ -356,7 +416,7 @@ static struct dma_pte * addr_to_dma_pte(struct dmar_domain *domain, u64 addr)
 			 */
 			dma_set_pte_readable(*pte);
 			dma_set_pte_writable(*pte);
-			__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
+			domain_flush_cache(domain, pte, sizeof(*pte));
 		}
 		parent = phys_to_virt(dma_pte_addr(*pte));
 		level--;
@@ -399,7 +459,7 @@ static void dma_pte_clear_one(struct dmar_domain *domain, u64 addr)
 
 	if (pte) {
 		dma_clear_pte(*pte);
-		__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
+		domain_flush_cache(domain, pte, sizeof(*pte));
 	}
 }
 
@@ -447,8 +507,7 @@ static void dma_pte_free_pagetable(struct dmar_domain *domain,
 				free_pgtable_page(
 					phys_to_virt(dma_pte_addr(*pte)));
 				dma_clear_pte(*pte);
-				__iommu_flush_cache(domain->iommu,
-						pte, sizeof(*pte));
+				domain_flush_cache(domain, pte, sizeof(*pte));
 			}
 			tmp += level_size(level);
 		}
@@ -948,8 +1007,8 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	return 0;
 }
 
-
 static void domain_exit(struct dmar_domain *domain);
+static void vm_domain_exit(struct dmar_domain *domain);
 
 void free_dmar_iommu(struct intel_iommu *iommu)
 {
@@ -960,7 +1019,13 @@ void free_dmar_iommu(struct intel_iommu *iommu)
 	for (; i < cap_ndoms(iommu->cap); ) {
 		domain = iommu->domains[i];
 		clear_bit(i, iommu->domain_ids);
-		domain_exit(domain);
+
+		if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) {
+			if (--domain->iommu_count == 0)
+				vm_domain_exit(domain);
+		} else
+			domain_exit(domain);
+
 		i = find_next_bit(iommu->domain_ids,
 			cap_ndoms(iommu->cap), i+1);
 	}
@@ -1006,8 +1071,11 @@ static struct dmar_domain * iommu_alloc_domain(struct intel_iommu *iommu)
 
 	set_bit(num, iommu->domain_ids);
 	domain->id = num;
-	domain->iommu = iommu;
+	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	set_bit(iommu->seq_id, &domain->iommu_bmp);
 	iommu->domains[num] = domain;
+	domain->iommu_count = 1;
+	domain->flags = 0;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return domain;
@@ -1016,10 +1084,12 @@ static struct dmar_domain * iommu_alloc_domain(struct intel_iommu *iommu)
 static void iommu_free_domain(struct dmar_domain *domain)
 {
 	unsigned long flags;
+	struct intel_iommu *iommu;
 
-	spin_lock_irqsave(&domain->iommu->lock, flags);
-	clear_bit(domain->id, domain->iommu->domain_ids);
-	spin_unlock_irqrestore(&domain->iommu->lock, flags);
+	iommu = domain_get_only_iommu(domain);
+	spin_lock_irqsave(&iommu->lock, flags);
+	clear_bit(domain->id, iommu->domain_ids);
+	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
 static struct iova_domain reserved_iova_list;
@@ -1098,7 +1168,7 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 	domain_reserve_special_ranges(domain);
 
 	/* calculate AGAW */
-	iommu = domain->iommu;
+	iommu = domain_get_only_iommu(domain);
 	if (guest_width > cap_mgaw(iommu->cap))
 		guest_width = cap_mgaw(iommu->cap);
 	domain->gaw = guest_width;
@@ -1107,19 +1177,21 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 	sagaw = cap_sagaw(iommu->cap);
 	if (!test_bit(agaw, &sagaw)) {
 		/* hardware doesn't support it, choose a bigger one */
-		pr_debug("IOMMU: hardware doesn't support agaw %d\n", agaw);
+		pr_debug("IOMMU: hardware doesn't support agaw %d\n",
+		  agaw);
 		agaw = find_next_bit(&sagaw, 5, agaw);
 		if (agaw >= 5)
 			return -ENODEV;
 	}
 	domain->agaw = agaw;
+
 	INIT_LIST_HEAD(&domain->devices);
 
 	/* always allocate the top pgd */
 	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
 	if (!domain->pgd)
 		return -ENOMEM;
-	__iommu_flush_cache(iommu, domain->pgd, PAGE_SIZE);
+	domain_flush_cache(domain, domain->pgd, PAGE_SIZE);
 	return 0;
 }
 
@@ -1148,10 +1220,9 @@ static void domain_exit(struct dmar_domain *domain)
 }
 
 static int domain_context_mapping_one(struct dmar_domain *domain,
-		u8 bus, u8 devfn)
+		struct intel_iommu *iommu, u8 bus, u8 devfn)
 {
 	struct context_entry *context;
-	struct intel_iommu *iommu = domain->iommu;
 	unsigned long flags;
 
 	pr_debug("Set context mapping for %02x:%02x.%d\n",
@@ -1191,9 +1262,14 @@ domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev)
 {
 	int ret;
 	struct pci_dev *tmp, *parent;
+	struct intel_iommu *iommu;
 
-	ret = domain_context_mapping_one(domain, pdev->bus->number,
-		pdev->devfn);
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return 	-ENODEV;
+
+	ret = domain_context_mapping_one(domain, iommu,
+		pdev->bus->number, pdev->devfn);
 	if (ret)
 		return ret;
 
@@ -1204,27 +1280,31 @@ domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev)
 	/* Secondary interface's bus number and devfn 0 */
 	parent = pdev->bus->self;
 	while (parent != tmp) {
-		ret = domain_context_mapping_one(domain, parent->bus->number,
-			parent->devfn);
+		ret = domain_context_mapping_one(domain, iommu,
+			parent->bus->number, parent->devfn);
 		if (ret)
 			return ret;
 		parent = parent->bus->self;
 	}
 	if (tmp->is_pcie) /* this is a PCIE-to-PCI bridge */
-		return domain_context_mapping_one(domain,
+		return domain_context_mapping_one(domain, iommu,
 			tmp->subordinate->number, 0);
 	else /* this is a legacy PCI bridge */
-		return domain_context_mapping_one(domain,
+		return domain_context_mapping_one(domain, iommu,
 			tmp->bus->number, tmp->devfn);
 }
 
-static int domain_context_mapped(struct dmar_domain *domain,
-	struct pci_dev *pdev)
+static int domain_context_mapped(struct pci_dev *pdev)
 {
 	int ret;
 	struct pci_dev *tmp, *parent;
+	struct intel_iommu *iommu;
+
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return 0;
 
-	ret = device_context_mapped(domain->iommu,
+	ret = device_context_mapped(iommu,
 		pdev->bus->number, pdev->devfn);
 	if (!ret)
 		return ret;
@@ -1235,17 +1315,17 @@ static int domain_context_mapped(struct dmar_domain *domain,
 	/* Secondary interface's bus number and devfn 0 */
 	parent = pdev->bus->self;
 	while (parent != tmp) {
-		ret = device_context_mapped(domain->iommu, parent->bus->number,
+		ret = device_context_mapped(iommu, parent->bus->number,
 			parent->devfn);
 		if (!ret)
 			return ret;
 		parent = parent->bus->self;
 	}
 	if (tmp->is_pcie)
-		return device_context_mapped(domain->iommu,
+		return device_context_mapped(iommu,
 			tmp->subordinate->number, 0);
 	else
-		return device_context_mapped(domain->iommu,
+		return device_context_mapped(iommu,
 			tmp->bus->number, tmp->devfn);
 }
 
@@ -1276,20 +1356,27 @@ domain_page_mapping(struct dmar_domain *domain, dma_addr_t iova,
 		BUG_ON(dma_pte_addr(*pte));
 		dma_set_pte_addr(*pte, start_pfn << VTD_PAGE_SHIFT);
 		dma_set_pte_prot(*pte, prot);
-		__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
+		domain_flush_cache(domain, pte, sizeof(*pte));
 		start_pfn++;
 		index++;
 	}
 	return 0;
 }
 
-static void detach_domain_for_dev(struct dmar_domain *domain, u8 bus, u8 devfn)
+static void detach_domain_for_dev(struct dmar_domain *domain,
+				  u8 bus, u8 devfn)
 {
-	clear_context_table(domain->iommu, bus, devfn);
-	domain->iommu->flush.flush_context(domain->iommu, 0, 0, 0,
-					   DMA_CCMD_GLOBAL_INVL, 0);
-	domain->iommu->flush.flush_iotlb(domain->iommu, 0, 0, 0,
-					 DMA_TLB_GLOBAL_FLUSH, 0);
+	struct intel_iommu *iommu;
+
+	iommu = device_find_matched_iommu(bus, devfn);
+	if (!iommu)
+		return;
+
+	clear_context_table(iommu, bus, devfn);
+	iommu->flush.flush_context(iommu, 0, 0, 0,
+				   DMA_CCMD_GLOBAL_INVL, 0);
+	iommu->flush.flush_iotlb(iommu, 0, 0, 0,
+				 DMA_TLB_GLOBAL_FLUSH, 0);
 }
 
 static void domain_remove_dev_info(struct dmar_domain *domain)
@@ -1336,7 +1423,6 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 {
 	struct dmar_domain *domain, *found = NULL;
 	struct intel_iommu *iommu;
-	struct dmar_drhd_unit *drhd;
 	struct device_domain_info *info, *tmp;
 	struct pci_dev *dev_tmp;
 	unsigned long flags;
@@ -1371,13 +1457,9 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	}
 
 	/* Allocate new domain for the device */
-	drhd = dmar_find_matched_drhd_unit(pdev);
-	if (!drhd) {
-		printk(KERN_ERR "IOMMU: can't find DMAR for device %s\n",
-			pci_name(pdev));
-		return NULL;
-	}
-	iommu = drhd->iommu;
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return 	NULL;
 
 	domain = iommu_alloc_domain(iommu);
 	if (!domain)
@@ -1400,7 +1482,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		info->dev = NULL;
 		info->domain = domain;
 		/* This domain is shared by devices under p2p bridge */
-		domain->flags |= DOMAIN_FLAG_MULTIPLE_DEVICES;
+		domain->flags |= DOMAIN_FLAG_P2P_MULTIPLE_DEVICES;
 
 		/* pcie-to-pci bridge already has a domain, uses it */
 		found = NULL;
@@ -1805,7 +1887,7 @@ get_valid_domain_for_dev(struct pci_dev *pdev)
 	}
 
 	/* make sure context mapping is ok */
-	if (unlikely(!domain_context_mapped(domain, pdev))) {
+	if (unlikely(!domain_context_mapped(pdev))) {
 		ret = domain_context_mapping(domain, pdev);
 		if (ret) {
 			printk(KERN_ERR
@@ -1823,6 +1905,7 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 {
 	struct pci_dev *pdev = to_pci_dev(hwdev);
 	struct dmar_domain *domain;
+	struct intel_iommu *iommu;
 	phys_addr_t start_paddr;
 	struct iova *iova;
 	int prot = 0;
@@ -1836,6 +1919,10 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 	if (!domain)
 		return 0;
 
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return 0;
+
 	size = aligned_size((u64)paddr, size);
 
 	iova = __intel_alloc_iova(hwdev, domain, size, pdev->dma_mask);
@@ -1849,7 +1936,7 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 	 * mappings..
 	 */
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL || \
-			!cap_zlr(domain->iommu->cap))
+			!cap_zlr(iommu->cap))
 		prot |= DMA_PTE_READ;
 	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
 		prot |= DMA_PTE_WRITE;
@@ -1865,10 +1952,10 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 		goto error;
 
 	/* it's a non-present to present mapping */
-	ret = iommu_flush_iotlb_psi(domain->iommu, domain->id,
+	ret = iommu_flush_iotlb_psi(iommu, domain->id,
 			start_paddr, size >> VTD_PAGE_SHIFT, 1);
 	if (ret)
-		iommu_flush_write_buffer(domain->iommu);
+		iommu_flush_write_buffer(iommu);
 
 	return start_paddr + ((u64)paddr & (~PAGE_MASK));
 
@@ -1896,8 +1983,7 @@ static void flush_unmaps(void)
 	/* just flush them all */
 	for (i = 0; i < g_num_of_iommus; i++) {
 		if (deferred_flush[i].next) {
-			struct intel_iommu *iommu =
-				deferred_flush[i].domain[0]->iommu;
+			struct intel_iommu *iommu = deferred_flush[i].iommu;
 
 			iommu->flush.flush_iotlb(iommu, 0, 0, 0,
 						 DMA_TLB_GLOBAL_FLUSH, 0);
@@ -1921,7 +2007,8 @@ static void flush_unmaps_timeout(unsigned long data)
 	spin_unlock_irqrestore(&async_umap_flush_lock, flags);
 }
 
-static void add_unmap(struct dmar_domain *dom, struct iova *iova)
+static void add_unmap(struct dmar_domain *dom,
+		      struct intel_iommu *iommu, struct iova *iova)
 {
 	unsigned long flags;
 	int next, iommu_id;
@@ -1930,11 +2017,12 @@ static void add_unmap(struct dmar_domain *dom, struct iova *iova)
 	if (list_size == HIGH_WATER_MARK)
 		flush_unmaps();
 
-	iommu_id = dom->iommu->seq_id;
+	iommu_id = iommu->seq_id;
 
 	next = deferred_flush[iommu_id].next;
 	deferred_flush[iommu_id].domain[next] = dom;
 	deferred_flush[iommu_id].iova[next] = iova;
+	deferred_flush[iommu_id].iommu = iommu;
 	deferred_flush[iommu_id].next++;
 
 	if (!timer_on) {
@@ -1952,12 +2040,17 @@ void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
 	struct dmar_domain *domain;
 	unsigned long start_addr;
 	struct iova *iova;
+	struct intel_iommu *iommu;
 
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
 
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return;
+
 	iova = find_iova(&domain->iovad, IOVA_PFN(dev_addr));
 	if (!iova)
 		return;
@@ -1973,13 +2066,13 @@ void intel_unmap_single(struct device *dev, dma_addr_t dev_addr, size_t size,
 	/* free page tables */
 	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
 	if (intel_iommu_strict) {
-		if (iommu_flush_iotlb_psi(domain->iommu,
+		if (iommu_flush_iotlb_psi(iommu,
 			domain->id, start_addr, size >> VTD_PAGE_SHIFT, 0))
-			iommu_flush_write_buffer(domain->iommu);
+			iommu_flush_write_buffer(iommu);
 		/* free iova */
 		__free_iova(&domain->iovad, iova);
 	} else {
-		add_unmap(domain, iova);
+		add_unmap(domain, iommu, iova);
 		/*
 		 * queue up the release of the unmap to save the 1/6th of the
 		 * cpu used up by the iotlb flush operation...
@@ -2036,12 +2129,17 @@ void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 	size_t size = 0;
 	void *addr;
 	struct scatterlist *sg;
+	struct intel_iommu *iommu;
 
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
 
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return;
+
 	iova = find_iova(&domain->iovad, IOVA_PFN(sglist[0].dma_address));
 	if (!iova)
 		return;
@@ -2057,9 +2155,9 @@ void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 	/* free page tables */
 	dma_pte_free_pagetable(domain, start_addr, start_addr + size);
 
-	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, start_addr,
+	if (iommu_flush_iotlb_psi(iommu, domain->id, start_addr,
 			size >> VTD_PAGE_SHIFT, 0))
-		iommu_flush_write_buffer(domain->iommu);
+		iommu_flush_write_buffer(iommu);
 
 	/* free iova */
 	__free_iova(&domain->iovad, iova);
@@ -2093,6 +2191,7 @@ int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
 	int ret;
 	struct scatterlist *sg;
 	unsigned long start_addr;
+	struct intel_iommu *iommu;
 
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
@@ -2102,6 +2201,10 @@ int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
 	if (!domain)
 		return 0;
 
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return 0;
+
 	for_each_sg(sglist, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		addr = (void *)virt_to_phys(addr);
@@ -2119,7 +2222,7 @@ int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
 	 * mappings..
 	 */
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL || \
-			!cap_zlr(domain->iommu->cap))
+			!cap_zlr(iommu->cap))
 		prot |= DMA_PTE_READ;
 	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
 		prot |= DMA_PTE_WRITE;
@@ -2151,9 +2254,9 @@ int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
 	}
 
 	/* it's a non-present to present mapping */
-	if (iommu_flush_iotlb_psi(domain->iommu, domain->id,
+	if (iommu_flush_iotlb_psi(iommu, domain->id,
 			start_addr, offset >> VTD_PAGE_SHIFT, 1))
-		iommu_flush_write_buffer(domain->iommu);
+		iommu_flush_write_buffer(iommu);
 	return nelems;
 }
 
@@ -2328,7 +2431,314 @@ int __init intel_iommu_init(void)
 	return 0;
 }
 
-void intel_iommu_domain_exit(struct dmar_domain *domain)
+/* domain id for virtual machine, it won't be set in context */
+static unsigned long vm_domid;
+
+static int vm_domain_min_agaw(struct dmar_domain *domain)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	int min_agaw = domain->agaw;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		iommu = drhd->iommu;
+
+		if (test_bit(iommu->seq_id, &domain->iommu_bmp))
+			if (min_agaw > iommu->agaw)
+				min_agaw = iommu->agaw;
+	}
+
+	return min_agaw;
+}
+
+static int vm_domain_add_dev_info(struct dmar_domain *domain,
+				  struct pci_dev *pdev)
+{
+	struct device_domain_info *info;
+	unsigned long flags;
+
+	info = alloc_devinfo_mem();
+	if (!info)
+		return -ENOMEM;
+
+	info->bus = pdev->bus->number;
+	info->devfn = pdev->devfn;
+	info->dev = pdev;
+	info->domain = domain;
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	list_add(&info->link, &domain->devices);
+	list_add(&info->global, &device_domain_list);
+	pdev->dev.archdata.iommu = info;
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+
+	return 0;
+}
+
+static void vm_domain_remove_one_dev_info(struct dmar_domain *domain,
+					  struct pci_dev *pdev)
+{
+	struct device_domain_info *info;
+	struct intel_iommu *iommu;
+	unsigned long flags;
+	int found = 0;
+
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	while (!list_empty(&domain->devices)) {
+		info = list_entry(domain->devices.next,
+			struct device_domain_info, link);
+		if (info->bus == pdev->bus->number &&
+		    info->devfn == pdev->devfn) {
+			list_del(&info->link);
+			list_del(&info->global);
+			if (info->dev)
+				info->dev->dev.archdata.iommu = NULL;
+			spin_unlock_irqrestore(&device_domain_lock, flags);
+
+			detach_domain_for_dev(info->domain,
+					      info->bus, info->devfn);
+			free_devinfo_mem(info);
+
+			spin_lock_irqsave(&device_domain_lock, flags);
+
+			if (found)
+				break;
+			else
+				continue;
+		}
+
+		/* if there is no other devices under the same iommu
+		 * owned by this domain, clear this iommu in iommu_bmp
+		 */
+		if (device_find_matched_iommu(info->bus, info->devfn) == iommu)
+			found = 1;
+	}
+
+	if (found == 0) {
+		spin_lock_irqsave(&iommu->lock, flags);
+		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		domain->iommu_count--;
+		spin_unlock_irqrestore(&iommu->lock, flags);
+	}
+
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+}
+
+static void vm_domain_remove_all_dev_info(struct dmar_domain *domain)
+{
+	struct device_domain_info *info;
+	struct intel_iommu *iommu;
+	unsigned long flags;
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	while (!list_empty(&domain->devices)) {
+		info = list_entry(domain->devices.next,
+			struct device_domain_info, link);
+		list_del(&info->link);
+		list_del(&info->global);
+		if (info->dev)
+			info->dev->dev.archdata.iommu = NULL;
+
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		detach_domain_for_dev(info->domain,
+				      info->bus, info->devfn);
+
+		/* clear this iommu in iommu_bmp */
+		iommu = device_find_matched_iommu(info->bus, info->devfn);
+		spin_lock_irqsave(&iommu->lock, flags);
+		if (test_and_clear_bit(iommu->seq_id,
+				       &domain->iommu_bmp))
+			domain->iommu_count--;
+		spin_unlock_irqrestore(&iommu->lock, flags);
+
+		free_devinfo_mem(info);
+		spin_lock_irqsave(&device_domain_lock, flags);
+	}
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+}
+
+static int vm_domain_context_mapping_one(struct dmar_domain *domain,
+		struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	struct context_entry *context;
+	unsigned long flags;
+	struct dma_pte *pgd;
+	unsigned long num;
+	unsigned long ndomains;
+	int id;
+	int agaw;
+	int found = 0;
+
+	pr_debug("Set context mapping for %02x:%02x.%d\n",
+		bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
+	BUG_ON(!domain->pgd);
+	context = device_to_context_entry(iommu, bus, devfn);
+	if (!context)
+		return -ENOMEM;
+	spin_lock_irqsave(&iommu->lock, flags);
+	if (context_present(*context)) {
+		spin_unlock_irqrestore(&iommu->lock, flags);
+		return 0;
+	}
+
+	id = domain->id;
+
+	/* find an available domain id for this device in iommu */
+	ndomains = cap_ndoms(iommu->cap);
+	num = find_first_bit(iommu->domain_ids, ndomains);
+	for (; num < ndomains; ) {
+		if (iommu->domains[num] == domain) {
+			id = num;
+			found = 1;
+			break;
+		}
+		num = find_next_bit(iommu->domain_ids,
+		  cap_ndoms(iommu->cap), num+1);
+	}
+
+	if (found == 0) {
+		num = find_first_zero_bit(iommu->domain_ids, ndomains);
+		if (num >= ndomains) {
+			spin_unlock_irqrestore(&iommu->lock, flags);
+			printk(KERN_ERR "IOMMU: no free domain ids\n");
+			return -EFAULT;
+		}
+
+		set_bit(num, iommu->domain_ids);
+		iommu->domains[num] = domain;
+		id = num;
+	}
+
+	pgd = domain->pgd;
+
+	/* Skip top levels of page tables for
+	 * iommu which has less agaw than default.
+	 */
+	for (agaw = domain->agaw; agaw != iommu->agaw; agaw--) {
+		pgd = phys_to_virt(dma_pte_addr(*pgd));
+		if (!dma_pte_present(*pgd)) {
+			spin_unlock_irqrestore(&iommu->lock, flags);
+			return -ENOMEM;
+		}
+	}
+
+	context_set_domain_id(*context, id);
+	context_set_address_width(*context, iommu->agaw);
+	context_set_address_root(*context, virt_to_phys(pgd));
+	context_set_translation_type(*context, CONTEXT_TT_MULTI_LEVEL);
+	context_set_fault_enable(*context);
+	context_set_present(*context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
+
+	/* it's a non-present to present mapping */
+	if (iommu->flush.flush_context(iommu, id,
+		(((u16)bus) << 8) | devfn, DMA_CCMD_MASK_NOBIT,
+		DMA_CCMD_DEVICE_INVL, 1))
+		iommu_flush_write_buffer(iommu);
+	else
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_DSI_FLUSH, 0);
+
+	if (!test_and_set_bit(iommu->seq_id, &domain->iommu_bmp))
+		domain->iommu_count++;
+	spin_unlock_irqrestore(&iommu->lock, flags);
+	return 0;
+}
+
+static int
+vm_domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev)
+{
+	int ret;
+	struct pci_dev *tmp, *parent;
+	struct intel_iommu *iommu;
+
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return 	-ENODEV;
+
+	ret = vm_domain_context_mapping_one(domain, iommu,
+		pdev->bus->number, pdev->devfn);
+	if (ret)
+		return ret;
+
+	/* dependent device mapping */
+	tmp = pci_find_upstream_pcie_bridge(pdev);
+	if (!tmp)
+		return 0;
+	/* Secondary interface's bus number and devfn 0 */
+	parent = pdev->bus->self;
+	while (parent != tmp) {
+		ret = vm_domain_context_mapping_one(domain, iommu,
+			parent->bus->number, parent->devfn);
+		if (ret)
+			return ret;
+		parent = parent->bus->self;
+	}
+	if (tmp->is_pcie) /* this is a PCIE-to-PCI bridge */
+		return vm_domain_context_mapping_one(domain, iommu,
+			tmp->subordinate->number, 0);
+	else /* this is a legacy PCI bridge */
+		return vm_domain_context_mapping_one(domain, iommu,
+			tmp->bus->number, tmp->devfn);
+}
+
+
+static int vm_domain_init(struct dmar_domain *domain, int guest_width)
+{
+	int adjust_width;
+
+	init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
+	spin_lock_init(&domain->mapping_lock);
+
+	domain_reserve_special_ranges(domain);
+
+	/* calculate AGAW */
+	domain->gaw = guest_width;
+	adjust_width = guestwidth_to_adjustwidth(guest_width);
+	domain->agaw = width_to_agaw(adjust_width);
+
+	INIT_LIST_HEAD(&domain->devices);
+
+	/* always allocate the top pgd */
+	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
+	if (!domain->pgd)
+		return -ENOMEM;
+	domain_flush_cache(domain, domain->pgd, PAGE_SIZE);
+	return 0;
+}
+
+static void iommu_free_vm_domain(struct dmar_domain *domain)
+{
+	unsigned long flags;
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	unsigned long i;
+	unsigned long ndomains;
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		iommu = drhd->iommu;
+
+		ndomains = cap_ndoms(iommu->cap);
+		i = find_first_bit(iommu->domain_ids, ndomains);
+		for (; i < ndomains; ) {
+			if (iommu->domains[i] == domain) {
+				spin_lock_irqsave(&iommu->lock, flags);
+				clear_bit(i, iommu->domain_ids);
+				iommu->domains[i] = NULL;
+				spin_unlock_irqrestore(&iommu->lock, flags);
+				break;
+			}
+			i = find_next_bit(iommu->domain_ids, ndomains, i+1);
+		}
+	}
+}
+
+static void vm_domain_exit(struct dmar_domain *domain)
 {
 	u64 end;
 
@@ -2336,8 +2746,11 @@ void intel_iommu_domain_exit(struct dmar_domain *domain)
 	if (!domain)
 		return;
 
+	vm_domain_remove_all_dev_info(domain);
+	/* destroy iovas */
+	put_iova_domain(&domain->iovad);
 	end = DOMAIN_MAX_ADDR(domain->gaw);
-	end = end & (~VTD_PAGE_MASK);
+	end &= VTD_PAGE_MASK;
 
 	/* clear ptes */
 	dma_pte_clear_range(domain, 0, end);
@@ -2345,76 +2758,149 @@ void intel_iommu_domain_exit(struct dmar_domain *domain)
 	/* free page tables */
 	dma_pte_free_pagetable(domain, 0, end);
 
-	iommu_free_domain(domain);
+	iommu_free_vm_domain(domain);
 	free_domain_mem(domain);
 }
-EXPORT_SYMBOL_GPL(intel_iommu_domain_exit);
 
-struct dmar_domain *intel_iommu_domain_alloc(struct pci_dev *pdev)
+static struct dmar_domain *iommu_alloc_vm_domain(void)
 {
-	struct dmar_drhd_unit *drhd;
 	struct dmar_domain *domain;
-	struct intel_iommu *iommu;
 
-	drhd = dmar_find_matched_drhd_unit(pdev);
-	if (!drhd) {
-		printk(KERN_ERR "intel_iommu_domain_alloc: drhd == NULL\n");
+	domain = alloc_domain_mem();
+	if (!domain)
 		return NULL;
-	}
 
-	iommu = drhd->iommu;
-	if (!iommu) {
-		printk(KERN_ERR
-			"intel_iommu_domain_alloc: iommu == NULL\n");
-		return NULL;
-	}
-	domain = iommu_alloc_domain(iommu);
+	domain->id = vm_domid++;
+	domain->iommu_count = 0;
+	domain->max_addr = 0;
+	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	domain->flags = DOMAIN_FLAG_VIRTUAL_MACHINE;
+
+	return domain;
+}
+
+struct dmar_domain *intel_iommu_alloc_domain(void)
+{
+	struct dmar_domain *domain;
+
+	domain = iommu_alloc_vm_domain();
 	if (!domain) {
 		printk(KERN_ERR
 			"intel_iommu_domain_alloc: domain == NULL\n");
 		return NULL;
 	}
-	if (domain_init(domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
+	if (vm_domain_init(domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		printk(KERN_ERR
 			"intel_iommu_domain_alloc: domain_init() failed\n");
-		intel_iommu_domain_exit(domain);
+		vm_domain_exit(domain);
 		return NULL;
 	}
+
 	return domain;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_domain_alloc);
+EXPORT_SYMBOL_GPL(intel_iommu_alloc_domain);
 
-int intel_iommu_context_mapping(
-	struct dmar_domain *domain, struct pci_dev *pdev)
+void intel_iommu_free_domain(struct dmar_domain *domain)
 {
-	int rc;
-	rc = domain_context_mapping(domain, pdev);
-	return rc;
+	vm_domain_exit(domain);
+}
+EXPORT_SYMBOL_GPL(intel_iommu_free_domain);
+
+int intel_iommu_assign_device(struct dmar_domain *domain,
+			      struct pci_dev *pdev)
+{
+	struct intel_iommu *iommu;
+	int addr_width;
+	u64 end;
+	int ret;
+
+	/* normally pdev is not mapped */
+	if (unlikely(domain_context_mapped(pdev))) {
+		struct dmar_domain *old_domain;
+
+		old_domain = find_domain(pdev);
+		if (old_domain) {
+			if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
+				vm_domain_remove_one_dev_info(old_domain, pdev);
+			else
+				domain_remove_dev_info(old_domain);
+		}
+	}
+
+	iommu = device_find_matched_iommu(pdev->bus->number, pdev->devfn);
+	if (!iommu)
+		return 	-ENODEV;
+
+	/* check if this iommu agaw is sufficient for max mapped address */
+	addr_width = agaw_to_width(iommu->agaw);
+	end = DOMAIN_MAX_ADDR(addr_width);
+	end = end & VTD_PAGE_MASK;
+	if (end < domain->max_addr) {
+		printk(KERN_ERR "%s: iommu agaw (%d) is not "
+		       "sufficient for the mapped address (%llx)\n",
+		       __func__, iommu->agaw, domain->max_addr);
+		return -EFAULT;
+	}
+
+	ret = vm_domain_context_mapping(domain, pdev);
+	if (ret)
+		return ret;
+
+	ret = vm_domain_add_dev_info(domain, pdev);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_context_mapping);
+EXPORT_SYMBOL_GPL(intel_iommu_assign_device);
 
-int intel_iommu_page_mapping(
-	struct dmar_domain *domain, dma_addr_t iova,
-	u64 hpa, size_t size, int prot)
+
+void intel_iommu_deassign_device(struct dmar_domain *domain,
+				 struct pci_dev *pdev)
 {
-	int rc;
-	rc = domain_page_mapping(domain, iova, hpa, size, prot);
-	return rc;
+	vm_domain_remove_one_dev_info(domain, pdev);
 }
-EXPORT_SYMBOL_GPL(intel_iommu_page_mapping);
+EXPORT_SYMBOL_GPL(intel_iommu_deassign_device);
 
-void intel_iommu_detach_dev(struct dmar_domain *domain, u8 bus, u8 devfn)
+int intel_iommu_map_pages(struct dmar_domain *domain, dma_addr_t iova,
+			  u64 hpa, size_t size, int prot)
 {
-	detach_domain_for_dev(domain, bus, devfn);
+	u64 max_addr;
+	int addr_width;
+	int ret;
+
+	max_addr = (iova & VTD_PAGE_MASK) + VTD_PAGE_ALIGN(size);
+	if (domain->max_addr < max_addr) {
+		int min_agaw;
+		u64 end;
+
+		/* check if minimum agaw is sufficient for mapped address */
+		min_agaw = vm_domain_min_agaw(domain);
+		addr_width = agaw_to_width(min_agaw);
+		end = DOMAIN_MAX_ADDR(addr_width);
+		end = end & VTD_PAGE_MASK;
+		if (end < max_addr) {
+			printk(KERN_ERR "%s: iommu agaw (%d) is not "
+			       "sufficient for the mapped address (%llx)\n",
+			       __func__, min_agaw, max_addr);
+			return -EFAULT;
+		}
+		domain->max_addr = max_addr;
+	}
+
+	ret = domain_page_mapping(domain, iova, hpa, size, prot);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_detach_dev);
+EXPORT_SYMBOL_GPL(intel_iommu_map_pages);
 
-struct dmar_domain *
-intel_iommu_find_domain(struct pci_dev *pdev)
+void intel_iommu_unmap_pages(struct dmar_domain *domain,
+			     dma_addr_t iova, size_t size)
 {
-	return find_domain(pdev);
+	dma_addr_t base;
+
+	/* The address might not be aligned */
+	base = iova & PAGE_MASK;
+	size = PAGE_ALIGN(size);
+	dma_pte_clear_range(domain, base, base + size);
 }
-EXPORT_SYMBOL_GPL(intel_iommu_find_domain);
+EXPORT_SYMBOL_GPL(intel_iommu_unmap_pages);
 
 int intel_iommu_found(void)
 {
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 952df39..b4200bd 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -111,11 +111,21 @@ struct dma_pte {
 		(p).val |= ((addr) & VTD_PAGE_MASK); } while (0)
 #define dma_pte_present(p) (((p).val & 3) != 0)
 
+/* domain flags, one domain owns one device by default */
+
+/* devices under the same p2p bridge are owned in one domain */
+#define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES	(1 << 0)
+
+/* domain represents a virtual machine, more than one devices
+ * across iommus may be owned in one domain, e.g. kvm guest.
+ */
+#define DOMAIN_FLAG_VIRTUAL_MACHINE		(1 << 1)
+
 struct intel_iommu;
 
 struct dmar_domain {
 	int	id;			/* domain id */
-	struct intel_iommu *iommu;	/* back pointer to owning iommu */
+	unsigned long iommu_bmp;	/* bitmap of iommus this domain uses*/
 
 	struct list_head devices; 	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
@@ -123,12 +133,13 @@ struct dmar_domain {
 	struct dma_pte	*pgd;		/* virtual address */
 	spinlock_t	mapping_lock;	/* page table lock */
 	int		gaw;		/* max guest address width */
+	int		agaw;		/* adjusted guest address width */
 
-	/* adjusted guest address width, 0 is level 2 30-bit */
-	int		agaw;
+	int		flags;		/* domain flag */
 
-#define DOMAIN_FLAG_MULTIPLE_DEVICES 1
-	int		flags;
+	/* following fields are used in virtual machine case */
+	int		iommu_count;	/* reference count of iommu */
+	u64		max_addr;	/* maximum mapped address */
 };
 
 /* PCI domain-device relationship */
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index f1984fc..157dcb7 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -53,6 +53,8 @@ extern void detect_intel_iommu(void);
 
 extern int parse_ioapics_under_ir(void);
 extern int alloc_iommu(struct dmar_drhd_unit *);
+extern int width_to_agaw(int width);
+
 #else
 static inline void detect_intel_iommu(void)
 {
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 3d017cf..c2f37b8 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -219,6 +219,8 @@ do {									\
 	}								\
 } while (0)
 
+#define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
+
 #define QI_LENGTH	256	/* queue length */
 
 enum {
@@ -299,6 +301,7 @@ struct intel_iommu {
 	struct dmar_domain **domains; /* ptr to domains */
 	spinlock_t	lock; /* protect context, domain ids */
 	struct root_entry *root_entry; /* virtual address */
+	int		agaw;
 
 	unsigned int irq;
 	unsigned char name[7];    /* Device Name */
@@ -334,14 +337,16 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-void intel_iommu_domain_exit(struct dmar_domain *domain);
-struct dmar_domain *intel_iommu_domain_alloc(struct pci_dev *pdev);
-int intel_iommu_context_mapping(struct dmar_domain *domain,
-				struct pci_dev *pdev);
-int intel_iommu_page_mapping(struct dmar_domain *domain, dma_addr_t iova,
-			     u64 hpa, size_t size, int prot);
-void intel_iommu_detach_dev(struct dmar_domain *domain, u8 bus, u8 devfn);
-struct dmar_domain *intel_iommu_find_domain(struct pci_dev *pdev);
+struct dmar_domain *intel_iommu_alloc_domain(void);
+void intel_iommu_free_domain(struct dmar_domain *domain);
+int intel_iommu_assign_device(struct dmar_domain *domain,
+			      struct pci_dev *pdev);
+void intel_iommu_deassign_device(struct dmar_domain *domain,
+				 struct pci_dev *pdev);
+int intel_iommu_map_pages(struct dmar_domain *domain, dma_addr_t iova,
+			  u64 hpa, size_t size, int prot);
+void intel_iommu_unmap_pages(struct dmar_domain *domain,
+			     dma_addr_t iova, size_t size);
 u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova);
 
 #ifdef CONFIG_DMAR
-- 
1.5.6.4


