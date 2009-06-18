Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbZFRSF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbZFRSF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbZFRSFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:05:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:21490 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbZFRSFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:05:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,246,1243839600"; 
   d="scan'208";a="156112555"
Date: Thu, 18 Jun 2009 11:05:27 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: David Woodhouse <dwmw2@infradead.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'Christopher Wright'" <chrisw@redhat.com>,
       "'Allen Kay'" <allen.m.kay@intel.com>
Cc: "'lkml'" <linux-kernel@vger.kernel.org>,
       "'iommu'" <iommu@lists.linux-foundation.org>
Subject: [PATCH 2/2] IOMMU Identity Mapping Support: Intel IOMMU implementation
Message-ID: <20090618180527.GA24078@linux-os.sc.intel.com>
References: <20090327212241.234500000@intel.com> <20090327212321.070229000@intel.com> <20090416001957.GA1527@linux-os.sc.intel.com> <1240135508.3589.75.camel@macbook.infradead.org> <A6AD88C3F2289247BE726C37303E1EB8A4DF7DB1@orsmsx505.amr.corp.intel.com> <20090520174259.GA10646@linux-os.sc.intel.com> <20090526225146.2faeeb05.akpm@linux-foundation.org> <A6AD88C3F2289247BE726C37303E1EB8AF9331CE@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8AF9331CE@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU Identity Mapping Support: Intel IOMMU implementation

Identity mapping for IOMMU defines a single domain to 1:1 map all pci devices
to all usable memory.

This reduces map/unmap overhead in DMA API's and improve IOMMU performance.
On 10Gb network cards, Netperf shows no performance degradation compared to
non-IOMMU performance.

This method may lose some of DMA remapping benefits like isolation.

The second patch sets up identity mapping for all pci devices to all usable
memory. In the DMA API's, there is no overhead to maintain page tables,
invalidate iotlb, flush cache etc.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 intel-iommu.c |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 182 insertions(+), 28 deletions(-)


diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 178853a..26da407 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -39,6 +39,7 @@
 #include <linux/sysdev.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
+#include <asm/e820.h>
 #include "pci.h"
 
 #define ROOT_SIZE		VTD_PAGE_SIZE
@@ -220,10 +221,26 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 /* devices under the same p2p bridge are owned in one domain */
 #define DOMAIN_FLAG_P2P_MULTIPLE_DEVICES (1 << 0)
 
-/* domain represents a virtual machine, more than one devices
- * across iommus may be owned in one domain, e.g. kvm guest.
+/*
+ * This domain is a statically identity mapping domain.
+ *	1. This domain creats a static 1:1 mapping to all usable memory.
+ * 	2. It maps to each iommu if successful.
+ *	3. Each iommu mapps to this domain if successful.
+ */
+struct dmar_domain *si_domain;
+
+/*
+ * There are three types of domains which are determined by flags in the
+ * domains:
+ *	0: A domain only containing one pci device.
+ *	1: A specific domain si_domain which has static 1:1 map to all
+ *	   usable memory for all pci devices.
+ *	2: Domain represents a virtual machine, more than one devices across
+ *	   iommus may be owned in one domain, e.g. kvm guest.
  */
-#define DOMAIN_FLAG_VIRTUAL_MACHINE	(1 << 1)
+#define DOMAIN_FLAG_SINGLE_DEVICE	1
+#define DOMAIN_FLAG_STATIC_IDENTITY	2
+#define DOMAIN_FLAG_VIRTUAL_MACHINE	4
 
 struct dmar_domain {
 	int	id;			/* domain id */
@@ -435,12 +452,13 @@ int iommu_calculate_agaw(struct intel_iommu *iommu)
 	return __iommu_calculate_agaw(iommu, DEFAULT_DOMAIN_ADDRESS_WIDTH);
 }
 
-/* in native case, each domain is related to only one iommu */
+/* This functionin only returns single iommu in a domain */
 static struct intel_iommu *domain_get_iommu(struct dmar_domain *domain)
 {
 	int iommu_id;
 
-	BUG_ON(domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE);
+	/* si_domain and vm domain should not get here. */
+	BUG_ON(domain->flags & ~DOMAIN_FLAG_SINGLE_DEVICE);
 
 	iommu_id = find_first_bit(&domain->iommu_bmp, g_num_of_iommus);
 	if (iommu_id < 0 || iommu_id >= g_num_of_iommus)
@@ -1189,48 +1207,74 @@ void free_dmar_iommu(struct intel_iommu *iommu)
 	free_context_table(iommu);
 }
 
-static struct dmar_domain * iommu_alloc_domain(struct intel_iommu *iommu)
+/* Sequential domain id starting from 0. */
+static unsigned long domain_id;
+
+static struct dmar_domain *alloc_domain(void)
 {
-	unsigned long num;
-	unsigned long ndomains;
 	struct dmar_domain *domain;
-	unsigned long flags;
 
 	domain = alloc_domain_mem();
 	if (!domain)
 		return NULL;
 
+	domain->id = domain_id++;
+	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
+	domain->flags = 0;
+
+	return domain;
+}
+
+static int iommu_attach_domain(struct dmar_domain *domain,
+			       struct intel_iommu *iommu)
+{
+	int num;
+	unsigned long ndomains;
+	unsigned long flags;
+
 	ndomains = cap_ndoms(iommu->cap);
 
 	spin_lock_irqsave(&iommu->lock, flags);
+
 	num = find_first_zero_bit(iommu->domain_ids, ndomains);
 	if (num >= ndomains) {
 		spin_unlock_irqrestore(&iommu->lock, flags);
-		free_domain_mem(domain);
 		printk(KERN_ERR "IOMMU: no free domain ids\n");
-		return NULL;
+		return -ENOMEM;
 	}
 
 	set_bit(num, iommu->domain_ids);
-	domain->id = num;
-	memset(&domain->iommu_bmp, 0, sizeof(unsigned long));
 	set_bit(iommu->seq_id, &domain->iommu_bmp);
-	domain->flags = 0;
 	iommu->domains[num] = domain;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
-	return domain;
+	return 0;
 }
 
-static void iommu_free_domain(struct dmar_domain *domain)
+static void iommu_detach_domain(struct dmar_domain *domain,
+				struct intel_iommu *iommu)
 {
 	unsigned long flags;
-	struct intel_iommu *iommu;
-
-	iommu = domain_get_iommu(domain);
+	int num, ndomains;
+	int found = 0;
 
 	spin_lock_irqsave(&iommu->lock, flags);
-	clear_bit(domain->id, iommu->domain_ids);
+	ndomains = cap_ndoms(iommu->cap);
+	num = find_first_bit(iommu->domain_ids, ndomains);
+	for (; num < ndomains; ) {
+		if (iommu->domains[num] == domain) {
+			found = 1;
+			break;
+		}
+		num = find_next_bit(iommu->domain_ids,
+				    cap_ndoms(iommu->cap), num+1);
+	}
+
+	if (found) {
+		clear_bit(num, iommu->domain_ids);
+		clear_bit(iommu->seq_id, &domain->iommu_bmp);
+		iommu->domains[num] = NULL;
+	}
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
@@ -1310,6 +1354,7 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 
 	domain_reserve_special_ranges(domain);
 
+	domain->flags = DOMAIN_FLAG_SINGLE_DEVICE;
 	/* calculate AGAW */
 	iommu = domain_get_iommu(domain);
 	if (guest_width > cap_mgaw(iommu->cap))
@@ -1350,6 +1395,8 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
 
 static void domain_exit(struct dmar_domain *domain)
 {
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
 	u64 end;
 
 	/* Domain 0 is reserved, so dont process it */
@@ -1368,7 +1415,10 @@ static void domain_exit(struct dmar_domain *domain)
 	/* free page tables */
 	dma_pte_free_pagetable(domain, 0, end);
 
-	iommu_free_domain(domain);
+	for_each_active_iommu(iommu, drhd)
+		if (test_bit(iommu->seq_id, &domain->iommu_bmp))
+			iommu_detach_domain(domain, iommu);
+
 	free_domain_mem(domain);
 }
 
@@ -1383,6 +1433,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 	unsigned long ndomains;
 	int id;
 	int agaw;
+	int found = 0;
 	struct device_domain_info *info = NULL;
 
 	pr_debug("Set context mapping for %02x:%02x.%d\n",
@@ -1408,8 +1459,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 	id = domain->id;
 	pgd = domain->pgd;
 
-	if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE) {
-		int found = 0;
+	if (domain->flags != DOMAIN_FLAG_SINGLE_DEVICE) {
 
 		/* find an available domain id for this device in iommu */
 		ndomains = cap_ndoms(iommu->cap);
@@ -1433,6 +1483,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 			}
 
 			set_bit(num, iommu->domain_ids);
+			set_bit(iommu->seq_id, &domain->iommu_bmp);
 			iommu->domains[num] = domain;
 			id = num;
 		}
@@ -1675,6 +1726,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	unsigned long flags;
 	int bus = 0, devfn = 0;
 	int segment;
+	int ret;
 
 	domain = find_domain(pdev);
 	if (domain)
@@ -1707,6 +1759,10 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 		}
 	}
 
+	domain = alloc_domain();
+	if (!domain)
+		goto error;
+
 	/* Allocate new domain for the device */
 	drhd = dmar_find_matched_drhd_unit(pdev);
 	if (!drhd) {
@@ -1716,9 +1772,11 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	}
 	iommu = drhd->iommu;
 
-	domain = iommu_alloc_domain(iommu);
-	if (!domain)
+	ret = iommu_attach_domain(domain, iommu);
+	if (ret) {
+		domain_exit(domain);
 		goto error;
+	}
 
 	if (domain_init(domain, gaw)) {
 		domain_exit(domain);
@@ -1804,8 +1862,11 @@ static int iommu_prepare_identity_map(struct pci_dev *pdev,
 	printk(KERN_INFO
 		"IOMMU: Setting identity map for device %s [0x%Lx - 0x%Lx]\n",
 		pci_name(pdev), start, end);
-	/* page table init */
-	domain = get_domain_for_dev(pdev, DEFAULT_DOMAIN_ADDRESS_WIDTH);
+	if (iommu_identity_mapping)
+		domain = si_domain;
+	else
+		/* page table init */
+		domain = get_domain_for_dev(pdev, DEFAULT_DOMAIN_ADDRESS_WIDTH);
 	if (!domain)
 		return -ENOMEM;
 
@@ -1952,7 +2013,76 @@ static int __init init_context_pass_through(void)
 	return 0;
 }
 
-static int __init init_dmars(void)
+static int si_domain_init(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+	int ret = 0;
+
+	si_domain = alloc_domain();
+	if (!si_domain)
+		return -EFAULT;
+
+	si_domain->flags = DOMAIN_FLAG_STATIC_IDENTITY;
+
+	for_each_active_iommu(iommu, drhd) {
+		ret = iommu_attach_domain(si_domain, iommu);
+		if (ret) {
+			domain_exit(si_domain);
+			return -EFAULT;
+		}
+	}
+
+	if (domain_init(si_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
+		domain_exit(si_domain);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int identity_list(struct pci_dev *pdev)
+{
+	if (iommu_identity_mapping)
+		return 1;
+
+	return 0;
+}
+
+static int iommu_prepare_static_identity_mapping(void)
+{
+	int i;
+	struct pci_dev *pdev = NULL;
+	int ret;
+
+	ret = si_domain_init();
+	if (ret)
+		return -EFAULT;
+
+	printk(KERN_INFO "IOMMU: Setting identity map:\n");
+	for_each_pci_dev(pdev) {
+		/* Devices not in the identity list won't do identity map. */
+		if (!identity_list(pdev))
+			continue;
+
+		for (i = 0; i < e820.nr_map; i++) {
+			struct e820entry *ei = &e820.map[i];
+
+			if (ei->type == E820_RAM) {
+				ret = iommu_prepare_identity_map(pdev,
+					ei->addr, ei->addr + ei->size);
+				if (ret)  {
+					printk(KERN_INFO "1:1 mapping to one domain failed.\n");
+					return -EFAULT;
+				}
+			}
+		}
+	}
+
+	return 0;
+}
+
+int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct dmar_rmrr_unit *rmrr;
@@ -2076,6 +2206,7 @@ static int __init init_dmars(void)
 		}
 	}
 
+
 	/*
 	 * If pass through is set and enabled, context entries of all pci
 	 * devices are intialized by pass through translation type.
@@ -2093,6 +2224,9 @@ static int __init init_dmars(void)
 	 * identity mappings for rmrr, gfx, and isa.
 	 */
 	if (!iommu_pass_through) {
+		if (iommu_identity_mapping)
+			iommu_prepare_static_identity_mapping();
+
 		/*
 		 * For each rmrr
 		 *   for each dev attached to rmrr
@@ -2107,6 +2241,7 @@ static int __init init_dmars(void)
 		 *    endfor
 		 * endfor
 		 */
+		printk(KERN_INFO "IOMMU: Setting RMRR:\n");
 		for_each_rmrr_units(rmrr) {
 			for (i = 0; i < rmrr->devices_cnt; i++) {
 				pdev = rmrr->devices[i];
@@ -2259,6 +2394,9 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 	int ret;
 	struct intel_iommu *iommu;
 
+	if (identity_list(pdev))
+		return paddr;
+
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return paddr;
@@ -2401,6 +2539,9 @@ static void intel_unmap_page(struct device *dev, dma_addr_t dev_addr,
 	struct iova *iova;
 	struct intel_iommu *iommu;
 
+	if (identity_list(pdev))
+		return;
+
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 	domain = find_domain(pdev);
@@ -2492,6 +2633,9 @@ static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 	struct scatterlist *sg;
 	struct intel_iommu *iommu;
 
+	if (identity_list(pdev))
+		return;
+
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
@@ -2552,6 +2696,16 @@ static int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int ne
 	unsigned long start_addr;
 	struct intel_iommu *iommu;
 
+	if (identity_list(pdev)) {
+		for_each_sg(sglist, sg, nelems, i) {
+			addr = page_to_phys(sg_page(sg)) + sg->offset;
+			sg->dma_address = addr;
+			sg->dma_length = sg->length;
+		}
+
+		return nelems;
+	}
+
 	BUG_ON(dir == DMA_NONE);
 	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return intel_nontranslate_map_sg(hwdev, sglist, nelems, dir);
