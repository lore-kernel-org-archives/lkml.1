Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYI1Ptu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYI1Ptu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYI1Ppu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50882 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbYI1Ppr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, "Kay, Allen M" <allen.m.kay@intel.com>
Subject: [PATCH 19/25] VT-d: Changes to support KVM
Date: Sun, 28 Sep 2008 18:44:55 +0300
Message-Id: <1222616701-1206-20-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay, Allen M <allen.m.kay@intel.com>

This patch extends the VT-d driver to support KVM

[Ben: fixed memory pinning]

Signed-off-by: Kay, Allen M <allen.m.kay@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Signed-off-by: Ben-Ami Yassour <benami@il.ibm.com>
Signed-off-by: Amit Shah <amit.shah@qumranet.com>

Acked-by: Mark Gross <mgross@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/pci/dmar.c                           |    4 +-
 drivers/pci/intel-iommu.c                    |  116 +++++++++++++++++++++++++-
 drivers/pci/iova.c                           |    2 +-
 {drivers/pci => include/linux}/intel-iommu.h |   11 +++
 {drivers/pci => include/linux}/iova.h        |    0
 5 files changed, 126 insertions(+), 7 deletions(-)
 rename {drivers/pci => include/linux}/intel-iommu.h (94%)
 rename {drivers/pci => include/linux}/iova.h (100%)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 8bf86ae..1df28ea 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -26,8 +26,8 @@
 
 #include <linux/pci.h>
 #include <linux/dmar.h>
-#include "iova.h"
-#include "intel-iommu.h"
+#include <linux/iova.h>
+#include <linux/intel-iommu.h>
 
 #undef PREFIX
 #define PREFIX "DMAR:"
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c3edcdc..089ba3f 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -33,8 +33,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/mempool.h>
 #include <linux/timer.h>
-#include "iova.h"
-#include "intel-iommu.h"
+#include <linux/iova.h>
+#include <linux/intel-iommu.h>
 #include <asm/proto.h> /* force_iommu in this header in x86-64*/
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -160,7 +160,7 @@ static inline void *alloc_domain_mem(void)
 	return iommu_kmem_cache_alloc(iommu_domain_cache);
 }
 
-static inline void free_domain_mem(void *vaddr)
+static void free_domain_mem(void *vaddr)
 {
 	kmem_cache_free(iommu_domain_cache, vaddr);
 }
@@ -1414,7 +1414,7 @@ static void domain_remove_dev_info(struct dmar_domain *domain)
  * find_domain
  * Note: we use struct pci_dev->dev.archdata.iommu stores the info
  */
-struct dmar_domain *
+static struct dmar_domain *
 find_domain(struct pci_dev *pdev)
 {
 	struct device_domain_info *info;
@@ -2453,3 +2453,111 @@ int __init intel_iommu_init(void)
 	return 0;
 }
 
+void intel_iommu_domain_exit(struct dmar_domain *domain)
+{
+	u64 end;
+
+	/* Domain 0 is reserved, so dont process it */
+	if (!domain)
+		return;
+
+	end = DOMAIN_MAX_ADDR(domain->gaw);
+	end = end & (~PAGE_MASK_4K);
+
+	/* clear ptes */
+	dma_pte_clear_range(domain, 0, end);
+
+	/* free page tables */
+	dma_pte_free_pagetable(domain, 0, end);
+
+	iommu_free_domain(domain);
+	free_domain_mem(domain);
+}
+EXPORT_SYMBOL_GPL(intel_iommu_domain_exit);
+
+struct dmar_domain *intel_iommu_domain_alloc(struct pci_dev *pdev)
+{
+	struct dmar_drhd_unit *drhd;
+	struct dmar_domain *domain;
+	struct intel_iommu *iommu;
+
+	drhd = dmar_find_matched_drhd_unit(pdev);
+	if (!drhd) {
+		printk(KERN_ERR "intel_iommu_domain_alloc: drhd == NULL\n");
+		return NULL;
+	}
+
+	iommu = drhd->iommu;
+	if (!iommu) {
+		printk(KERN_ERR
+			"intel_iommu_domain_alloc: iommu == NULL\n");
+		return NULL;
+	}
+	domain = iommu_alloc_domain(iommu);
+	if (!domain) {
+		printk(KERN_ERR
+			"intel_iommu_domain_alloc: domain == NULL\n");
+		return NULL;
+	}
+	if (domain_init(domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
+		printk(KERN_ERR
+			"intel_iommu_domain_alloc: domain_init() failed\n");
+		intel_iommu_domain_exit(domain);
+		return NULL;
+	}
+	return domain;
+}
+EXPORT_SYMBOL_GPL(intel_iommu_domain_alloc);
+
+int intel_iommu_context_mapping(
+	struct dmar_domain *domain, struct pci_dev *pdev)
+{
+	int rc;
+	rc = domain_context_mapping(domain, pdev);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(intel_iommu_context_mapping);
+
+int intel_iommu_page_mapping(
+	struct dmar_domain *domain, dma_addr_t iova,
+	u64 hpa, size_t size, int prot)
+{
+	int rc;
+	rc = domain_page_mapping(domain, iova, hpa, size, prot);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(intel_iommu_page_mapping);
+
+void intel_iommu_detach_dev(struct dmar_domain *domain, u8 bus, u8 devfn)
+{
+	detach_domain_for_dev(domain, bus, devfn);
+}
+EXPORT_SYMBOL_GPL(intel_iommu_detach_dev);
+
+struct dmar_domain *
+intel_iommu_find_domain(struct pci_dev *pdev)
+{
+	return find_domain(pdev);
+}
+EXPORT_SYMBOL_GPL(intel_iommu_find_domain);
+
+int intel_iommu_found(void)
+{
+	return g_num_of_iommus;
+}
+EXPORT_SYMBOL_GPL(intel_iommu_found);
+
+u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova)
+{
+	struct dma_pte *pte;
+	u64 pfn;
+
+	pfn = 0;
+	pte = addr_to_dma_pte(domain, iova);
+
+	if (pte)
+		pfn = dma_pte_addr(*pte);
+
+	return pfn >> PAGE_SHIFT_4K;
+}
+EXPORT_SYMBOL_GPL(intel_iommu_iova_to_pfn);
diff --git a/drivers/pci/iova.c b/drivers/pci/iova.c
index 3ef4ac0..2287116 100644
--- a/drivers/pci/iova.c
+++ b/drivers/pci/iova.c
@@ -7,7 +7,7 @@
  * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
-#include "iova.h"
+#include <linux/iova.h>
 
 void
 init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit)
diff --git a/drivers/pci/intel-iommu.h b/include/linux/intel-iommu.h
similarity index 94%
rename from drivers/pci/intel-iommu.h
rename to include/linux/intel-iommu.h
index afc0ad9..1490fc0 100644
--- a/drivers/pci/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -341,4 +341,15 @@ static inline void iommu_prepare_gfx_mapping(void)
 }
 #endif /* !CONFIG_DMAR_GFX_WA */
 
+void intel_iommu_domain_exit(struct dmar_domain *domain);
+struct dmar_domain *intel_iommu_domain_alloc(struct pci_dev *pdev);
+int intel_iommu_context_mapping(struct dmar_domain *domain,
+				struct pci_dev *pdev);
+int intel_iommu_page_mapping(struct dmar_domain *domain, dma_addr_t iova,
+			     u64 hpa, size_t size, int prot);
+void intel_iommu_detach_dev(struct dmar_domain *domain, u8 bus, u8 devfn);
+struct dmar_domain *intel_iommu_find_domain(struct pci_dev *pdev);
+int intel_iommu_found(void);
+u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova);
+
 #endif
diff --git a/drivers/pci/iova.h b/include/linux/iova.h
similarity index 100%
rename from drivers/pci/iova.h
rename to include/linux/iova.h
-- 
1.6.0.1

