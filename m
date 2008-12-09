Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYLIOQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYLIOQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYLIOQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:22 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:51854 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYLIOQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:20 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KBM4Z0-03-KKG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/11] VT-d: adapt domain map and unmap functions for IOMMU API
Date: Tue, 9 Dec 2008 15:16:07 +0100
Message-ID: <1228832170-13405-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832170-13405-8-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832170-13405-1-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-2-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-3-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-4-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-5-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-6-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-7-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-8-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:10.0919 (UTC) FILETIME=[AF9B2B70:01C95A08]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |   33 ++++++++++++++++++++-------------
 include/linux/intel-iommu.h |    4 ----
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index db9a26c..8af6c96 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3047,20 +3047,28 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
 	vm_domain_remove_one_dev_info(dmar_domain, pdev);
 }
 
-int intel_iommu_map_address(struct dmar_domain *domain, dma_addr_t iova,
-			    u64 hpa, size_t size, int prot)
+static int intel_iommu_map_range(struct iommu_domain *domain,
+				 unsigned long iova, phys_addr_t hpa,
+				 size_t size, int iommu_prot)
 {
+	struct dmar_domain *dmar_domain = domain->priv;
 	u64 max_addr;
 	int addr_width;
+	int prot = 0;
 	int ret;
 
+	if (iommu_prot & IOMMU_READ)
+		prot |= DMA_PTE_READ;
+	if (iommu_prot & IOMMU_WRITE)
+		prot |= DMA_PTE_WRITE;
+
 	max_addr = (iova & VTD_PAGE_MASK) + VTD_PAGE_ALIGN(size);
-	if (domain->max_addr < max_addr) {
+	if (dmar_domain->max_addr < max_addr) {
 		int min_agaw;
 		u64 end;
 
 		/* check if minimum agaw is sufficient for mapped address */
-		min_agaw = vm_domain_min_agaw(domain);
+		min_agaw = vm_domain_min_agaw(dmar_domain);
 		addr_width = agaw_to_width(min_agaw);
 		end = DOMAIN_MAX_ADDR(addr_width);
 		end = end & VTD_PAGE_MASK;
@@ -3070,28 +3078,27 @@ int intel_iommu_map_address(struct dmar_domain *domain, dma_addr_t iova,
 			       __func__, min_agaw, max_addr);
 			return -EFAULT;
 		}
-		domain->max_addr = max_addr;
+		dmar_domain->max_addr = max_addr;
 	}
 
-	ret = domain_page_mapping(domain, iova, hpa, size, prot);
+	ret = domain_page_mapping(dmar_domain, iova, hpa, size, prot);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_map_address);
 
-void intel_iommu_unmap_address(struct dmar_domain *domain,
-			       dma_addr_t iova, size_t size)
+static void intel_iommu_unmap_range(struct iommu_domain *domain,
+				    unsigned long iova, size_t size)
 {
+	struct dmar_domain *dmar_domain = domain->priv;
 	dma_addr_t base;
 
 	/* The address might not be aligned */
 	base = iova & VTD_PAGE_MASK;
 	size = VTD_PAGE_ALIGN(size);
-	dma_pte_clear_range(domain, base, base + size);
+	dma_pte_clear_range(dmar_domain, base, base + size);
 
-	if (domain->max_addr == base + size)
-		domain->max_addr = base;
+	if (dmar_domain->max_addr == base + size)
+		dmar_domain->max_addr = base;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_unmap_address);
 
 int intel_iommu_found(void)
 {
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 9909c5a..6bc26e0 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -330,10 +330,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-int intel_iommu_map_address(struct dmar_domain *domain, dma_addr_t iova,
-			    u64 hpa, size_t size, int prot);
-void intel_iommu_unmap_address(struct dmar_domain *domain,
-			       dma_addr_t iova, size_t size);
 u64 intel_iommu_iova_to_phys(struct dmar_domain *domain, u64 iova);
 
 #ifdef CONFIG_DMAR
-- 
1.5.6.4


