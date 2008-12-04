Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbYLDRar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbYLDRar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbYLDR3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:17 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36479 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbYLDR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:10 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KBD4K5-04-Y6Y-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/11] VT-d: adapt device attach and detach functions for IOMMU API
Date: Thu, 4 Dec 2008 18:28:52 +0100
Message-ID: <1228411736-22644-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0771 (UTC) FILETIME=[C9536130:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |   27 +++++++++++++++------------
 include/linux/intel-iommu.h |    4 ----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index c939039..27dc896 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2695,9 +2695,11 @@ static void intel_iommu_domain_destroy(struct iommu_domain *domain)
 	vm_domain_exit(dmar_domain);
 }
 
-int intel_iommu_attach_device(struct dmar_domain *domain,
-			      struct pci_dev *pdev)
+static int intel_iommu_attach_device(struct iommu_domain *domain,
+				     struct device *dev)
 {
+	struct dmar_domain *dmar_domain = domain->priv;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct intel_iommu *iommu;
 	int addr_width;
 	u64 end;
@@ -2709,7 +2711,7 @@ int intel_iommu_attach_device(struct dmar_domain *domain,
 
 		old_domain = find_domain(pdev);
 		if (old_domain) {
-			if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
+			if (dmar_domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
 				vm_domain_remove_one_dev_info(old_domain, pdev);
 			else
 				domain_remove_dev_info(old_domain);
@@ -2724,28 +2726,29 @@ int intel_iommu_attach_device(struct dmar_domain *domain,
 	addr_width = agaw_to_width(iommu->agaw);
 	end = DOMAIN_MAX_ADDR(addr_width);
 	end = end & VTD_PAGE_MASK;
-	if (end < domain->max_addr) {
+	if (end < dmar_domain->max_addr) {
 		printk(KERN_ERR "%s: iommu agaw (%d) is not "
 		       "sufficient for the mapped address (%llx)\n",
-		       __func__, iommu->agaw, domain->max_addr);
+		       __func__, iommu->agaw, dmar_domain->max_addr);
 		return -EFAULT;
 	}
 
-	ret = domain_context_mapping(domain, pdev);
+	ret = domain_context_mapping(dmar_domain, pdev);
 	if (ret)
 		return ret;
 
-	ret = vm_domain_add_dev_info(domain, pdev);
+	ret = vm_domain_add_dev_info(dmar_domain, pdev);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_attach_device);
 
-void intel_iommu_detach_device(struct dmar_domain *domain,
-			       struct pci_dev *pdev)
+static void intel_iommu_detach_device(struct iommu_domain *domain,
+				      struct device *dev)
 {
-	vm_domain_remove_one_dev_info(domain, pdev);
+	struct dmar_domain *dmar_domain = domain->priv;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	vm_domain_remove_one_dev_info(dmar_domain, pdev);
 }
-EXPORT_SYMBOL_GPL(intel_iommu_detach_device);
 
 int intel_iommu_map_address(struct dmar_domain *domain, dma_addr_t iova,
 			    u64 hpa, size_t size, int prot)
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index b4a2c2d..2b4961f 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -335,10 +335,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-int intel_iommu_attach_device(struct dmar_domain *domain,
-			      struct pci_dev *pdev);
-void intel_iommu_detach_device(struct dmar_domain *domain,
-			       struct pci_dev *pdev);
 int intel_iommu_map_address(struct dmar_domain *domain, dma_addr_t iova,
 			    u64 hpa, size_t size, int prot);
 void intel_iommu_unmap_address(struct dmar_domain *domain,
-- 
1.5.6.4


