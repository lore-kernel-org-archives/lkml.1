Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYLBNEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYLBNEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYLBNCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:02:03 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:4881 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYLBNBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:40 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KB92UD-04-VCW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/12] VT-d: adapt device attach and detach functions for IOMMU API
Date: Tue, 2 Dec 2008 14:01:20 +0100
Message-ID: <1228222883-17207-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0942 (UTC) FILETIME=[14449060:01C9547E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |   28 +++++++++++++++-------------
 include/linux/intel-iommu.h |    4 ----
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 59b9cdb..62ae6b1 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2809,9 +2809,11 @@ static void intel_iommu_domain_destroy(struct iommu_domain *domain)
 	vm_domain_exit(dmar_domain);
 }
 
-int intel_iommu_assign_device(struct dmar_domain *domain,
-			      struct pci_dev *pdev)
+static int intel_iommu_attach_device(struct iommu_domain *domain,
+				     struct device *dev)
 {
+	struct dmar_domain *dmar_domain = domain->priv;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct intel_iommu *iommu;
 	int addr_width;
 	u64 end;
@@ -2823,7 +2825,7 @@ int intel_iommu_assign_device(struct dmar_domain *domain,
 
 		old_domain = find_domain(pdev);
 		if (old_domain) {
-			if (domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
+			if (dmar_domain->flags & DOMAIN_FLAG_VIRTUAL_MACHINE)
 				vm_domain_remove_one_dev_info(old_domain, pdev);
 			else
 				domain_remove_dev_info(old_domain);
@@ -2838,29 +2840,29 @@ int intel_iommu_assign_device(struct dmar_domain *domain,
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
 
-	ret = vm_domain_context_mapping(domain, pdev);
+	ret = vm_domain_context_mapping(dmar_domain, pdev);
 	if (ret)
 		return ret;
 
-	ret = vm_domain_add_dev_info(domain, pdev);
+	ret = vm_domain_add_dev_info(dmar_domain, pdev);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_assign_device);
-
 
-void intel_iommu_deassign_device(struct dmar_domain *domain,
-				 struct pci_dev *pdev)
+static void intel_iommu_detach_device(struct iommu_domain *domain,
+			       struct device *dev)
 {
-	vm_domain_remove_one_dev_info(domain, pdev);
+	struct dmar_domain *dmar_domain = domain->priv;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	vm_domain_remove_one_dev_info(dmar_domain, pdev);
 }
-EXPORT_SYMBOL_GPL(intel_iommu_deassign_device);
 
 int intel_iommu_map_pages(struct dmar_domain *domain, dma_addr_t iova,
 			  u64 hpa, size_t size, int prot)
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 5a4ce23..41d2a3b 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -337,10 +337,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-int intel_iommu_assign_device(struct dmar_domain *domain,
-			      struct pci_dev *pdev);
-void intel_iommu_deassign_device(struct dmar_domain *domain,
-				 struct pci_dev *pdev);
 int intel_iommu_map_pages(struct dmar_domain *domain, dma_addr_t iova,
 			  u64 hpa, size_t size, int prot);
 void intel_iommu_unmap_pages(struct dmar_domain *domain,
-- 
1.5.6.4


