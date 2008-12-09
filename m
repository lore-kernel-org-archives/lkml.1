Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYLIOUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYLIOUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYLIOQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:40 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40075 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYLIOQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:26 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KBM4YZ-03-KKC-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/11] VT-d: adapt device attach and detach functions for IOMMU API
Date: Tue, 9 Dec 2008 15:16:06 +0100
Message-ID: <1228832170-13405-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832170-13405-7-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832170-13405-1-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-2-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-3-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-4-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-5-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-6-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-7-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:10.0911 (UTC) FILETIME=[AF99F2F0:01C95A08]
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
index 5c95a5a..db9a26c 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2992,9 +2992,11 @@ static void intel_iommu_domain_destroy(struct iommu_domain *domain)
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
@@ -3006,7 +3008,7 @@ int intel_iommu_attach_device(struct dmar_domain *domain,
 
 		old_domain = find_domain(pdev);
 		if (old_domain) {
-			if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
+			if (dmar_domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
 				vm_domain_remove_one_dev_info(old_domain, pdev);
 			else
 				domain_remove_dev_info(old_domain);
@@ -3021,28 +3023,29 @@ int intel_iommu_attach_device(struct dmar_domain *domain,
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
index 0a7ba0c..9909c5a 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -330,10 +330,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
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


