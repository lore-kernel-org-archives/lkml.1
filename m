Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbYLDRdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbYLDRdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYLDR3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:29:30 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:20877 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbYLDR3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:29:19 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KBD4K7-03-CRD-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/11] VT-d: adapt domain init and destroy functions for IOMMU API
Date: Thu, 4 Dec 2008 18:28:51 +0100
Message-ID: <1228411736-22644-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <20081204172142.GH12816@amd.com>
References: <20081204172142.GH12816@amd.com>
X-OriginalArrivalTime: 04 Dec 2008 17:28:56.0772 (UTC) FILETIME=[C9538840:01C95635]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c   |   33 ++++++++++++++++++---------------
 include/linux/intel-iommu.h |    2 --
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a8c2e58..c939039 100644
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
@@ -2665,32 +2666,34 @@ static void vm_domain_exit(struct dmar_domain *domain)
 	free_domain_mem(domain);
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
-			"intel_iommu_domain_alloc: domain == NULL\n");
-		return NULL;
+			"intel_iommu_domain_init: dmar_domain == NULL\n");
+		return -ENOMEM;
 	}
-	if (vm_domain_init(domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
+	if (vm_domain_init(dmar_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		printk(KERN_ERR
-			"intel_iommu_domain_alloc: domain_init() failed\n");
-		vm_domain_exit(domain);
-		return NULL;
+			"intel_iommu_domain_init() failed\n");
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
 
 int intel_iommu_attach_device(struct dmar_domain *domain,
 			      struct pci_dev *pdev)
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 39a68b3..b4a2c2d 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -335,8 +335,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-struct dmar_domain *intel_iommu_alloc_domain(void);
-void intel_iommu_free_domain(struct dmar_domain *domain);
 int intel_iommu_attach_device(struct dmar_domain *domain,
 			      struct pci_dev *pdev);
 void intel_iommu_detach_device(struct dmar_domain *domain,
-- 
1.5.6.4


