Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbZCQA3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbZCQA3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZCQA2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:57059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZCQA2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="395024216"
Message-Id: <20090317001320.285393000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:04:56 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 04/13] dmar: routines for disabling queued invalidation and intr remapping
Content-Disposition: inline; filename=dmar_qi_routines.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Routines for disabling queued invalidation and interrupt remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c
+++ tip/drivers/pci/dmar.c
@@ -754,6 +754,42 @@ int qi_flush_iotlb(struct intel_iommu *i
 }
 
 /*
+ * Disable Queued Invalidation interface.
+ */
+void dmar_disable_qi(struct intel_iommu *iommu)
+{
+	unsigned long flags;
+	u32 sts;
+	cycles_t start_time = get_cycles();
+
+	if (!ecap_qis(iommu->ecap))
+		return;
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+
+	sts =  dmar_readq(iommu->reg + DMAR_GSTS_REG);
+	if (!(sts & DMA_GSTS_QIES))
+		goto end;
+
+	/*
+	 * Give a chance to HW to complete the pending invalidation requests.
+	 */
+	while ((readl(iommu->reg + DMAR_IQT_REG) !=
+		readl(iommu->reg + DMAR_IQH_REG)) &&
+		(DMAR_OPERATION_TIMEOUT > (get_cycles() - start_time)))
+		cpu_relax();
+
+	iommu->gcmd &= ~DMA_GCMD_QIE;
+
+	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
+
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, readl,
+		      !(sts & DMA_GSTS_QIES), sts);
+end:
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
+/*
  * Enable Queued Invalidation interface. This is a must to support
  * interrupt-remapping. Also used by DMA-remapping, which replaces
  * register based IOTLB invalidation.
Index: tip/include/linux/intel-iommu.h
===================================================================
--- tip.orig/include/linux/intel-iommu.h
+++ tip/include/linux/intel-iommu.h
@@ -321,6 +321,7 @@ extern struct dmar_drhd_unit * dmar_find
 extern int alloc_iommu(struct dmar_drhd_unit *drhd);
 extern void free_iommu(struct intel_iommu *iommu);
 extern int dmar_enable_qi(struct intel_iommu *iommu);
+extern void dmar_disable_qi(struct intel_iommu *iommu);
 extern void qi_global_iec(struct intel_iommu *iommu);
 
 extern int qi_flush_context(struct intel_iommu *iommu, u16 did, u16 sid,
Index: tip/drivers/pci/intr_remapping.c
===================================================================
--- tip.orig/drivers/pci/intr_remapping.c
+++ tip/drivers/pci/intr_remapping.c
@@ -467,6 +467,33 @@ static int setup_intr_remapping(struct i
 	return 0;
 }
 
+/*
+ * Disable Interrupt Remapping.
+ */
+static void disable_intr_remapping(struct intel_iommu *iommu)
+{
+	unsigned long flags;
+	u32 sts;
+
+	if (!ecap_ir_support(iommu->ecap))
+		return;
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+
+	sts = dmar_readq(iommu->reg + DMAR_GSTS_REG);
+	if (!(sts & DMA_GSTS_IRES))
+		goto end;
+
+	iommu->gcmd &= ~DMA_GCMD_IRE;
+	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
+
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
+		      readl, !(sts & DMA_GSTS_IRES), sts);
+
+end:
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
 int __init enable_intr_remapping(int eim)
 {
 	struct dmar_drhd_unit *drhd;

-- 

