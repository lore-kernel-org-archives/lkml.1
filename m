Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYJHVgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYJHVgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbYJHVft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:35:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:8676 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbYJHVfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:35:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,380,1220252400"; 
   d="scan'208";a="448772723"
Message-Id: <20081008210525.974962000@linux-os.sc.intel.com>
References: <20081008210101.487661000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 08 Oct 2008 14:01:03 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, youquan.song@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/4] tip, dmar: context cache and IOTLB invalidation using queued invalidation
Content-Disposition: inline; filename=qi_support_for_context_iotlb_invalidation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Youquan Song <youquan.song@intel.com>
Subject: context cache and IOTLB invalidation using queued invalidation

Implement context cache invalidate and IOTLB invalidation using
queued invalidation interface. This interface will be used by
DMA remapping, when queued invalidation is supported.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c	2008-10-07 16:27:47.000000000 -0700
+++ tip/drivers/pci/dmar.c	2008-10-07 16:27:50.000000000 -0700
@@ -657,6 +657,62 @@
 	qi_submit_sync(&desc, iommu);
 }
 
+int qi_flush_context(struct intel_iommu *iommu, u16 did, u16 sid, u8 fm,
+		     u64 type, int non_present_entry_flush)
+{
+
+	struct qi_desc desc;
+
+	if (non_present_entry_flush) {
+		if (!cap_caching_mode(iommu->cap))
+			return 1;
+		else
+			did = 0;
+	}
+
+	desc.low = QI_CC_FM(fm) | QI_CC_SID(sid) | QI_CC_DID(did)
+			| QI_CC_GRAN(type) | QI_CC_TYPE;
+	desc.high = 0;
+
+	qi_submit_sync(&desc, iommu);
+
+	return 0;
+
+}
+
+int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
+		   unsigned int size_order, u64 type,
+		   int non_present_entry_flush)
+{
+	u8 dw = 0, dr = 0;
+
+	struct qi_desc desc;
+	int ih = 0;
+
+	if (non_present_entry_flush) {
+		if (!cap_caching_mode(iommu->cap))
+			return 1;
+		else
+			did = 0;
+	}
+
+	if (cap_write_drain(iommu->cap))
+		dw = 1;
+
+	if (cap_read_drain(iommu->cap))
+		dr = 1;
+
+	desc.low = QI_IOTLB_DID(did) | QI_IOTLB_DR(dr) | QI_IOTLB_DW(dw)
+		| QI_IOTLB_GRAN(type) | QI_IOTLB_TYPE;
+	desc.high = QI_IOTLB_ADDR(addr) | QI_IOTLB_IH(ih)
+		| QI_IOTLB_AM(size_order);
+
+	qi_submit_sync(&desc, iommu);
+
+	return 0;
+
+}
+
 /*
  * Enable Queued Invalidation interface. This is a must to support
  * interrupt-remapping. Also used by DMA-remapping, which replaces
Index: tip/drivers/pci/intel-iommu.h
===================================================================
--- tip.orig/drivers/pci/intel-iommu.h	2008-10-07 15:42:47.000000000 -0700
+++ tip/drivers/pci/intel-iommu.h	2008-10-07 16:27:50.000000000 -0700
@@ -127,6 +127,7 @@
 
 
 /* IOTLB_REG */
+#define DMA_TLB_FLUSH_GRANU_OFFSET  60
 #define DMA_TLB_GLOBAL_FLUSH (((u64)1) << 60)
 #define DMA_TLB_DSI_FLUSH (((u64)2) << 60)
 #define DMA_TLB_PSI_FLUSH (((u64)3) << 60)
@@ -140,6 +141,7 @@
 #define DMA_TLB_MAX_SIZE (0x3f)
 
 /* INVALID_DESC */
+#define DMA_CCMD_INVL_GRANU_OFFSET  61
 #define DMA_ID_TLB_GLOBAL_FLUSH	(((u64)1) << 3)
 #define DMA_ID_TLB_DSI_FLUSH	(((u64)2) << 3)
 #define DMA_ID_TLB_PSI_FLUSH	(((u64)3) << 3)
@@ -238,6 +240,19 @@
 #define QI_IWD_STATUS_DATA(d)	(((u64)d) << 32)
 #define QI_IWD_STATUS_WRITE	(((u64)1) << 5)
 
+#define QI_IOTLB_DID(did) 	(((u64)did) << 16)
+#define QI_IOTLB_DR(dr) 	(((u64)dr) << 7)
+#define QI_IOTLB_DW(dw) 	(((u64)dw) << 6)
+#define QI_IOTLB_GRAN(gran) 	(((u64)gran) >> (DMA_TLB_FLUSH_GRANU_OFFSET-4))
+#define QI_IOTLB_ADDR(addr)	(((u64)addr) & PAGE_MASK_4K)
+#define QI_IOTLB_IH(ih)		(((u64)ih) << 6)
+#define QI_IOTLB_AM(am)		(((u8)am))
+
+#define QI_CC_FM(fm)		(((u64)fm) << 48)
+#define QI_CC_SID(sid)		(((u64)sid) << 32)
+#define QI_CC_DID(did)		(((u64)did) << 16)
+#define QI_CC_GRAN(gran)	(((u64)gran) >> (DMA_CCMD_INVL_GRANU_OFFSET-4))
+
 struct qi_desc {
 	u64 low, high;
 };
@@ -303,5 +318,11 @@
 extern int dmar_enable_qi(struct intel_iommu *iommu);
 extern void qi_global_iec(struct intel_iommu *iommu);
 
+extern int qi_flush_context(struct intel_iommu *iommu, u16 did, u16 sid,
+			        u8 fm, u64 type, int non_present_entry_flush);
+extern int qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
+			  unsigned int size_order, u64 type,
+			  int non_present_entry_flush);
+
 extern void qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 #endif

-- 

