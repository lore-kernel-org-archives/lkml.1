Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYLBNCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYLBNCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYLBNBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:01:39 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:49422 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbYLBNBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:01:36 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KB92UC-04-VCV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alexander Graf <agraf@suse.de>,
       Han Weidong <weidong.han@intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/12] VT-d: adapt domain init and destroy functions for IOMMU API
Date: Tue, 2 Dec 2008 14:01:19 +0100
Message-ID: <1228222883-17207-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2008 13:01:23.0940 (UTC) FILETIME=[14444240:01C9547E]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |   30 +++++++++++++++++-------------
 include/linux/intel-iommu.h |    2 --
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 7f12852..59b9cdb 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -35,6 +35,7 @@
 #include <linux/mempool.h>
 #include <linux/timer.h>
 #include <linux/iova.h>
+#include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -2779,32 +2780,34 @@ static struct dmar_domain *iommu_alloc_vm_domain(void)
 	return domain;
 }
 
-struct dmar_domain *intel_iommu_alloc_domain(void)
+static int intel_iommu_domain_init(struct iommu_domain *domain)
 {
-	struct dmar_domain *domain;
+	struct dmar_domain *dmar_domain;
 
-	domain = iommu_alloc_vm_domain();
-	if (!domain) {
+	dmar_domain = iommu_alloc_vm_domain();
+	if (!dmar_domain) {
 		printk(KERN_ERR
 			"intel_iommu_domain_alloc: domain == NULL\n");
-		return NULL;
+		return -ENOMEM;
 	}
-	if (vm_domain_init(domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
+	if (vm_domain_init(dmar_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		printk(KERN_ERR
 			"intel_iommu_domain_alloc: domain_init() failed\n");
-		vm_domain_exit(domain);
-		return NULL;
+		vm_domain_exit(dmar_domain);
+		return -ENOMEM;
 	}
+	domain->priv = dmar_domain;
 
-	return domain;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(intel_iommu_alloc_domain);
 
-void intel_iommu_free_domain(struct dmar_domain *domain)
+static void intel_iommu_domain_destroy(struct iommu_domain *domain)
 {
-	vm_domain_exit(domain);
+	struct dmar_domain *dmar_domain = domain->priv;
+
+	domain->priv = NULL;
+	vm_domain_exit(dmar_domain);
 }
-EXPORT_SYMBOL_GPL(intel_iommu_free_domain);
 
 int intel_iommu_assign_device(struct dmar_domain *domain,
 			      struct pci_dev *pdev)
@@ -2922,3 +2925,4 @@ u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova)
 	return pfn >> VTD_PAGE_SHIFT;
 }
 EXPORT_SYMBOL_GPL(intel_iommu_iova_to_pfn);
+
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index c2f37b8..5a4ce23 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -337,8 +337,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-struct dmar_domain *intel_iommu_alloc_domain(void);
-void intel_iommu_free_domain(struct dmar_domain *domain);
 int intel_iommu_assign_device(struct dmar_domain *domain,
 			      struct pci_dev *pdev);
 void intel_iommu_deassign_device(struct dmar_domain *domain,
-- 
1.5.6.4


