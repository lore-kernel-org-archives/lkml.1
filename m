Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYLBNFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYLBNFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbYLBNCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:02:13 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:49422 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbYLBNBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:35 -0500
X-BigFish: VPS3(zzzzzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KB92UE-04-VD0-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/12] VT-d: adapt domain map and unmap functions for IOMMU API
Date: Tue, 2 Dec 2008 14:01:21 +0100
Message-ID: <1228222883-17207-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0973 (UTC) FILETIME=[14494B50:01C9547E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |   22 +++++++++++-----------
 include/linux/intel-iommu.h |    4 ----
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 62ae6b1..ac22973 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2864,20 +2864,21 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
 	vm_domain_remove_one_dev_info(dmar_domain, pdev);
 }
 
-int intel_iommu_map_pages(struct dmar_domain *domain, dma_addr_t iova,
-			  u64 hpa, size_t size, int prot)
+static int intel_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			   phys_addr_t hpa, size_t size, int prot)
 {
+	struct dmar_domain *dmar_domain = domain->priv;
 	u64 max_addr;
 	int addr_width;
 	int ret;
 
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
@@ -2887,25 +2888,24 @@ int intel_iommu_map_pages(struct dmar_domain *domain, dma_addr_t iova,
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
-EXPORT_SYMBOL_GPL(intel_iommu_map_pages);
 
-void intel_iommu_unmap_pages(struct dmar_domain *domain,
-			     dma_addr_t iova, size_t size)
+static void intel_iommu_unmap(struct iommu_domain *domain,
+			      unsigned long iova, size_t size)
 {
+	struct dmar_domain *dmar_domain = domain->priv;
 	dma_addr_t base;
 
 	/* The address might not be aligned */
 	base = iova & PAGE_MASK;
 	size = PAGE_ALIGN(size);
-	dma_pte_clear_range(domain, base, base + size);
+	dma_pte_clear_range(dmar_domain, base, base + size);
 }
-EXPORT_SYMBOL_GPL(intel_iommu_unmap_pages);
 
 int intel_iommu_found(void)
 {
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 41d2a3b..ac79a1c 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -337,10 +337,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-int intel_iommu_map_pages(struct dmar_domain *domain, dma_addr_t iova,
-			  u64 hpa, size_t size, int prot);
-void intel_iommu_unmap_pages(struct dmar_domain *domain,
-			     dma_addr_t iova, size_t size);
 u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova);
 
 #ifdef CONFIG_DMAR
-- 
1.5.6.4


