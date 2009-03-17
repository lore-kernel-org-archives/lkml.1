Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbZCQA33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbZCQA33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760593AbZCQA2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:32172 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbZCQA2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="120907276"
Message-Id: <20090317001320.425227000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:04:57 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 05/13] dmar: start with sane state while enabling dma and interrupt-remapping
Content-Disposition: inline; filename=dmar_error_status_clear.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start from a sane state while enabling dma and interrupt-remapping, by
clearing the previous recorded faults and disabling previously
enabled queued invalidation and interrupt-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/intel-iommu.c
===================================================================
--- tip.orig/drivers/pci/intel-iommu.c
+++ tip/drivers/pci/intel-iommu.c
@@ -1855,11 +1855,40 @@ static int __init init_dmars(void)
 		}
 	}
 
+	/*
+	 * Start from the sane iommu hardware state.
+	 */
 	for_each_drhd_unit(drhd) {
 		if (drhd->ignored)
 			continue;
 
 		iommu = drhd->iommu;
+
+		/*
+		 * If the queued invalidation is already initialized by us
+		 * (for example, while enabling interrupt-remapping) then
+		 * we got the things already rolling from a sane state.
+		 */
+		if (iommu->qi)
+			continue;
+
+		/*
+		 * Clear any previous faults.
+		 */
+		dmar_fault(-1, iommu);
+		/*
+		 * Disable queued invalidation if supported and already enabled
+		 * before OS handover.
+		 */
+		dmar_disable_qi(iommu);
+	}
+
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+
 		if (dmar_enable_qi(iommu)) {
 			/*
 			 * Queued Invalidate not enabled, use Register Based
Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c
+++ tip/drivers/pci/dmar.c
@@ -982,7 +982,7 @@ static int dmar_fault_do_one(struct inte
 }
 
 #define PRIMARY_FAULT_REG_LEN (16)
-static irqreturn_t dmar_fault(int irq, void *dev_id)
+irqreturn_t dmar_fault(int irq, void *dev_id)
 {
 	struct intel_iommu *iommu = dev_id;
 	int reg, fault_index;
@@ -1074,9 +1074,6 @@ int dmar_set_interrupt(struct intel_iomm
 		return 0;
 	}
 
-	/* Force fault register is cleared */
-	dmar_fault(irq, iommu);
-
 	ret = request_irq(irq, dmar_fault, 0, iommu->name, iommu);
 	if (ret)
 		printk(KERN_ERR "IOMMU: can't request irq\n");
Index: tip/include/linux/dmar.h
===================================================================
--- tip.orig/include/linux/dmar.h
+++ tip/include/linux/dmar.h
@@ -24,6 +24,7 @@
 #include <linux/acpi.h>
 #include <linux/types.h>
 #include <linux/msi.h>
+#include <linux/irqreturn.h>
 
 #if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
 struct intel_iommu;
@@ -125,6 +126,7 @@ extern void dmar_msi_mask(unsigned int i
 extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
+extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
 #ifdef CONFIG_DMAR
Index: tip/drivers/pci/intr_remapping.c
===================================================================
--- tip.orig/drivers/pci/intr_remapping.c
+++ tip/drivers/pci/intr_remapping.c
@@ -499,6 +499,23 @@ int __init enable_intr_remapping(int eim
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
 
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		/*
+		 * Clear previous faults.
+		 */
+		dmar_fault(-1, iommu);
+
+		/*
+		 * Disable intr remapping and queued invalidation, if already
+		 * enabled prior to OS handover.
+		 */
+		disable_intr_remapping(iommu);
+
+		dmar_disable_qi(iommu);
+	}
+
 	/*
 	 * check for the Interrupt-remapping support
 	 */

-- 

