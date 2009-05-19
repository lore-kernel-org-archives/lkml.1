Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZESKcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZESKcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZESKcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:32:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:40240 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZESKcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:32:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,214,1241420400"; 
   d="scan'208";a="144423496"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       kvm@vger.kernel.org, Weidong Han <weidong.han@intel.com>
Subject: [PATCH v2 1/2] Intel-IOMMU, intr-remap: set the whole 128bits of irte when modify/free it
Date: Wed, 20 May 2009 02:31:51 +0800
Message-Id: <1242757912-6041-2-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
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
 drivers/pci/intr_remapping.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index f5e0ea7..946e170 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -309,7 +309,8 @@ int modify_irte(int irq, struct irte *irte_modified)
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	irte = &iommu->ir_table->base[index];
 
-	set_64bit((unsigned long *)irte, irte_modified->low);
+	set_64bit((unsigned long *)&irte->low, irte_modified->low);
+	set_64bit((unsigned long *)&irte->high, irte_modified->high);
 	__iommu_flush_cache(iommu, irte, sizeof(*irte));
 
 	rc = qi_flush_iec(iommu, index, 0);
@@ -386,8 +387,11 @@ int free_irte(int irq)
 	irte = &iommu->ir_table->base[index];
 
 	if (!irq_iommu->sub_handle) {
-		for (i = 0; i < (1 << irq_iommu->irte_mask); i++)
-			set_64bit((unsigned long *)(irte + i), 0);
+		for (i = 0; i < (1 << irq_iommu->irte_mask); i++) {
+			set_64bit((unsigned long *)&irte->low, 0);
+			set_64bit((unsigned long *)&irte->high, 0);
+			irte++;
+		}
 		rc = qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 	}
 
-- 
1.6.0.4

