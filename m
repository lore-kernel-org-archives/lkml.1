Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbYLIOTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbYLIOTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 09:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYLIOQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 09:16:35 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40059 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbYLIOQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 09:16:26 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBM4YZ-04-AEB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org, gregkh@suse.de,
       weidong.han@intel.com
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/11] VT-d: adapt domain init and destroy functions for IOMMU API
Date: Tue, 9 Dec 2008 15:16:05 +0100
Message-ID: <1228832170-13405-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1228832170-13405-6-git-send-email-joerg.roedel@amd.com>
References: <20081209141143.GW12816@amd.com>
 <1228832170-13405-1-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-2-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-3-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-4-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-5-git-send-email-joerg.roedel@amd.com>
 <1228832170-13405-6-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 09 Dec 2008 14:16:10.0857 (UTC) FILETIME=[AF91B590:01C95A08]
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
index 772fb22..5c95a5a 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -34,6 +34,7 @@
 #include <linux/mempool.h>
 #include <linux/timer.h>
 #include <linux/iova.h>
+#include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -2962,32 +2963,34 @@ static void vm_domain_exit(struct dmar_domain *domain)
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
index 07973c4..0a7ba0c 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -330,8 +330,6 @@ extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-struct dmar_domain *intel_iommu_alloc_domain(void);
-void intel_iommu_free_domain(struct dmar_domain *domain);
 int intel_iommu_attach_device(struct dmar_domain *domain,
 			      struct pci_dev *pdev);
 void intel_iommu_detach_device(struct dmar_domain *domain,
-- 
1.5.6.4


