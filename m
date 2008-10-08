Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbYJHVgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbYJHVgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbYJHVfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:35:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:8676 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbYJHVft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:35:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,380,1220252400"; 
   d="scan'208";a="448772725"
Message-Id: <20081008210526.115962000@linux-os.sc.intel.com>
References: <20081008210101.487661000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 08 Oct 2008 14:01:04 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, youquan.song@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/4] tip, dmar: Use queued invalidation interface for IOTLB and context invalidation.
Content-Disposition: inline; filename=unify_iommu_cache_invalidate.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Youquan Song <youquan.song@intel.com>
Subject: Use queued invalidation interface for IOTLB and context invalidation

If queued invalidation interface is available and enabled, queued invalidation 
interface will be used instead of the register based interface.

According to Vt-d2 specification, when queued invalidation is enabled,
invalidation command submit works only through invalidation queue and not
through the command registers interface.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/intel-iommu.c
===================================================================
--- tip.orig/drivers/pci/intel-iommu.c	2008-10-08 11:24:31.000000000 -0700
+++ tip/drivers/pci/intel-iommu.c	2008-10-08 13:37:58.000000000 -0700
@@ -567,27 +567,6 @@
 	return 0;
 }
 
-static int inline iommu_flush_context_global(struct intel_iommu *iommu,
-	int non_present_entry_flush)
-{
-	return __iommu_flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
-		non_present_entry_flush);
-}
-
-static int inline iommu_flush_context_domain(struct intel_iommu *iommu, u16 did,
-	int non_present_entry_flush)
-{
-	return __iommu_flush_context(iommu, did, 0, 0, DMA_CCMD_DOMAIN_INVL,
-		non_present_entry_flush);
-}
-
-static int inline iommu_flush_context_device(struct intel_iommu *iommu,
-	u16 did, u16 source_id, u8 function_mask, int non_present_entry_flush)
-{
-	return __iommu_flush_context(iommu, did, source_id, function_mask,
-		DMA_CCMD_DEVICE_INVL, non_present_entry_flush);
-}
-
 /* return value determine if we need a write buffer flush */
 static int __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did,
 	u64 addr, unsigned int size_order, u64 type,
@@ -660,20 +639,6 @@
 	return 0;
 }
 
-static int inline iommu_flush_iotlb_global(struct intel_iommu *iommu,
-	int non_present_entry_flush)
-{
-	return __iommu_flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
-		non_present_entry_flush);
-}
-
-static int inline iommu_flush_iotlb_dsi(struct intel_iommu *iommu, u16 did,
-	int non_present_entry_flush)
-{
-	return __iommu_flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH,
-		non_present_entry_flush);
-}
-
 static int iommu_flush_iotlb_psi(struct intel_iommu *iommu, u16 did,
 	u64 addr, unsigned int pages, int non_present_entry_flush)
 {
@@ -684,8 +649,9 @@
 
 	/* Fallback to domain selective flush if no PSI support */
 	if (!cap_pgsel_inv(iommu->cap))
-		return iommu_flush_iotlb_dsi(iommu, did,
-			non_present_entry_flush);
+		return iommu->flush.flush_iotlb(iommu, did, 0, 0,
+						DMA_TLB_DSI_FLUSH,
+						non_present_entry_flush);
 
 	/*
 	 * PSI requires page size to be 2 ^ x, and the base address is naturally
@@ -694,11 +660,12 @@
 	mask = ilog2(__roundup_pow_of_two(pages));
 	/* Fallback to domain selective flush if size is too big */
 	if (mask > cap_max_amask_val(iommu->cap))
-		return iommu_flush_iotlb_dsi(iommu, did,
-			non_present_entry_flush);
+		return iommu->flush.flush_iotlb(iommu, did, 0, 0,
+			DMA_TLB_DSI_FLUSH, non_present_entry_flush);
 
-	return __iommu_flush_iotlb(iommu, did, addr, mask,
-		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
+	return iommu->flush.flush_iotlb(iommu, did, addr, mask,
+					DMA_TLB_PSI_FLUSH,
+					non_present_entry_flush);
 }
 
 static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
@@ -1204,11 +1171,13 @@
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 
 	/* it's a non-present to present mapping */
-	if (iommu_flush_context_device(iommu, domain->id,
-			(((u16)bus) << 8) | devfn, DMA_CCMD_MASK_NOBIT, 1))
+	if (iommu->flush.flush_context(iommu, domain->id,
+		(((u16)bus) << 8) | devfn, DMA_CCMD_MASK_NOBIT,
+		DMA_CCMD_DEVICE_INVL, 1))
 		iommu_flush_write_buffer(iommu);
 	else
-		iommu_flush_iotlb_dsi(iommu, 0, 0);
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_DSI_FLUSH, 0);
+
 	spin_unlock_irqrestore(&iommu->lock, flags);
 	return 0;
 }
@@ -1310,8 +1279,10 @@
 static void detach_domain_for_dev(struct dmar_domain *domain, u8 bus, u8 devfn)
 {
 	clear_context_table(domain->iommu, bus, devfn);
-	iommu_flush_context_global(domain->iommu, 0);
-	iommu_flush_iotlb_global(domain->iommu, 0);
+	domain->iommu->flush.flush_context(domain->iommu, 0, 0, 0,
+					   DMA_CCMD_GLOBAL_INVL, 0);
+	domain->iommu->flush.flush_iotlb(domain->iommu, 0, 0, 0,
+					 DMA_TLB_GLOBAL_FLUSH, 0);
 }
 
 static void domain_remove_dev_info(struct dmar_domain *domain)
@@ -1662,6 +1633,28 @@
 		}
 	}
 
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+		if (dmar_enable_qi(iommu)) {
+			/*
+			 * Queued Invalidate not enabled, use Register Based
+			 * Invalidate
+			 */
+			iommu->flush.flush_context = __iommu_flush_context;
+			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
+			printk(KERN_INFO "IOMMU 0x%Lx: using Register based "
+			       "invalidation\n", drhd->reg_base_addr);
+		} else {
+			iommu->flush.flush_context = qi_flush_context;
+        		iommu->flush.flush_iotlb = qi_flush_iotlb;
+			printk(KERN_INFO "IOMMU 0x%Lx: using Queued"
+			       "invalidation\n", drhd->reg_base_addr);
+		}
+	}
+
 	/*
 	 * For each rmrr
 	 *   for each dev attached to rmrr
@@ -1714,9 +1707,10 @@
 
 		iommu_set_root_entry(iommu);
 
-		iommu_flush_context_global(iommu, 0);
-		iommu_flush_iotlb_global(iommu, 0);
-
+		iommu->flush.flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
+					   0);
+		iommu->flush.flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
+					 0);
 		iommu_disable_protect_mem_regions(iommu);
 
 		ret = iommu_enable_translation(iommu);
@@ -1891,7 +1885,8 @@
 			struct intel_iommu *iommu =
 				deferred_flush[i].domain[0]->iommu;
 
-			iommu_flush_iotlb_global(iommu, 0);
+			iommu->flush.flush_iotlb(iommu, 0, 0, 0,
+						 DMA_TLB_GLOBAL_FLUSH, 0);
 			for (j = 0; j < deferred_flush[i].next; j++) {
 				__free_iova(&deferred_flush[i].domain[j]->iovad,
 						deferred_flush[i].iova[j]);
Index: tip/drivers/pci/intel-iommu.h
===================================================================
--- tip.orig/drivers/pci/intel-iommu.h	2008-10-08 13:33:41.000000000 -0700
+++ tip/drivers/pci/intel-iommu.h	2008-10-08 13:33:43.000000000 -0700
@@ -278,6 +278,13 @@
 };
 #endif
 
+struct iommu_flush {
+	int (*flush_context)(struct intel_iommu *iommu, u16 did, u16 sid, u8 fm,
+		u64 type, int non_present_entry_flush);
+	int (*flush_iotlb)(struct intel_iommu *iommu, u16 did, u64 addr,
+		unsigned int size_order, u64 type, int non_present_entry_flush);
+};
+
 struct intel_iommu {
 	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
 	u64		cap;
@@ -297,6 +304,7 @@
 	unsigned char name[7];    /* Device Name */
 	struct msi_msg saved_msg;
 	struct sys_device sysdev;
+	struct iommu_flush flush;
 #endif
 	struct q_inval  *qi;            /* Queued invalidation info */
 #ifdef CONFIG_INTR_REMAP

-- 

