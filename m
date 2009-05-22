Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZEVImW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZEVImW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbZEVIly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:41:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:42752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbZEVIlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:41:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,232,1241420400"; 
   d="scan'208";a="145786374"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, ebiederm@xmission.com,
       Weidong Han <weidong.han@intel.com>
Subject: [PATCH v3 1/2] Intel-IOMMU, intr-remap: set the whole 128bits of irte when modify/free it
Date: Sat, 23 May 2009 00:41:14 +0800
Message-Id: <1243010475-7411-2-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1243010475-7411-1-git-send-email-weidong.han@intel.com>
References: <1243010475-7411-1-git-send-email-weidong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt remapping table entry is 128bits. Currently, it only sets low
64bits of irte in modify_irte and free_irte. This ignores high 64bits
setting of irte, that means source-id setting will be ignored. This patch
sets the whole 128bits of irte when modify/free it. Following source-id
checking patch depends on this.

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 drivers/pci/intr_remapping.c |   40 ++++++++++++++++++++++++++--------------
 1 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 3a0cb0b..a2ccb62 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -314,7 +314,8 @@ int modify_irte(int irq, struct irte *irte_modified)
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	irte = &iommu->ir_table->base[index];
 
-	set_64bit((unsigned long *)irte, irte_modified->low);
+	set_64bit((unsigned long *)&irte->low, irte_modified->low);
+	set_64bit((unsigned long *)&irte->high, irte_modified->high);
 	__iommu_flush_cache(iommu, irte, sizeof(*irte));
 
 	rc = qi_flush_iec(iommu, index, 0);
@@ -369,12 +370,32 @@ struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
 	return drhd->iommu;
 }
 
+static int clear_entries(struct irq_2_iommu *irq_iommu)
+{
+	struct irte *start, *entry, *end;
+	struct intel_iommu *iommu;
+	int index;
+
+	if (irq_iommu->sub_handle)
+		return 0;
+
+	iommu = irq_iommu->iommu;
+	index = irq_iommu->irte_index + irq_iommu->sub_handle;
+
+	start = iommu->ir_table->base + index;
+	end = start + (1 << irq_iommu->irte_mask);
+
+	for (entry = start; entry < end; entry++) {
+		set_64bit((unsigned long *)&entry->low, 0);
+		set_64bit((unsigned long *)&entry->high, 0);
+	}
+
+	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
+}
+
 int free_irte(int irq)
 {
 	int rc = 0;
-	int index, i;
-	struct irte *irte;
-	struct intel_iommu *iommu;
 	struct irq_2_iommu *irq_iommu;
 	unsigned long flags;
 
@@ -385,16 +406,7 @@ int free_irte(int irq)
 		return -1;
 	}
 
-	iommu = irq_iommu->iommu;
-
-	index = irq_iommu->irte_index + irq_iommu->sub_handle;
-	irte = &iommu->ir_table->base[index];
-
-	if (!irq_iommu->sub_handle) {
-		for (i = 0; i < (1 << irq_iommu->irte_mask); i++)
-			set_64bit((unsigned long *)(irte + i), 0);
-		rc = qi_flush_iec(iommu, index, irq_iommu->irte_mask);
-	}
+	rc = clear_entries(irq_iommu);
 
 	irq_iommu->iommu = NULL;
 	irq_iommu->irte_index = 0;
-- 
1.6.0.4

