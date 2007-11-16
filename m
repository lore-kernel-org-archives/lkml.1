Return-Path: <linux-kernel-owner+w=401wt.eu-S933820AbXKPWjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbXKPWjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757728AbXKPWjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:39:47 -0500
Received: from mga10.intel.com ([192.55.52.92]:8253 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755029AbXKPWjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:39:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,428,1188802800"; 
   d="scan'208";a="207235625"
Date: Fri, 16 Nov 2007 14:39:57 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: [PATCH]intel-iommu-PMEN support
Message-ID: <20071116223957.GA26796@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds support for protected memory enable bits by
clearing them if they are set at startup time.  Some future boot loaders
or firmware could have this bit set after it loads the kernel, and it
needs to be cleared if DMA's are going to happen effectively.

please apply

--mgross

Signed-off-by: mark gross <mgross@intel.com>


Index: linux-2.6.23-rc2-iommu/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.23-rc2-iommu.orig/drivers/pci/intel-iommu.c	2007-11-16 13:25:14.000000000 -0800
+++ linux-2.6.23-rc2-iommu/drivers/pci/intel-iommu.c	2007-11-16 13:26:07.000000000 -0800
@@ -692,6 +692,23 @@
 		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
 }
 
+static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
+{
+	u32 pmen;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+	pmen = readl(iommu->reg + DMAR_PMEN_REG);
+	pmen &= ~DMA_PMEN_EPM;
+	writel(pmen, iommu->reg + DMAR_PMEN_REG);
+
+	/* wait for the protected region status bit to clear */
+	IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
+		readl, (pmen & DMA_PMEN_PRS), pmen);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
 static int iommu_enable_translation(struct intel_iommu *iommu)
 {
 	u32 sts;
@@ -745,7 +762,7 @@
 	"non-zero reserved fields in PTE",
 	"Unknown"
 };
-#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings) - 1
+#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
 
 char *dmar_get_fault_reason(u8 fault_reason)
 {
@@ -1730,6 +1747,8 @@
 		iommu_flush_context_global(iommu, 0);
 		iommu_flush_iotlb_global(iommu, 0);
 
+		iommu_disable_protect_mem_regions(iommu);
+
 		ret = iommu_enable_translation(iommu);
 		if (ret)
 			goto error;
Index: linux-2.6.23-rc2-iommu/drivers/pci/intel-iommu.h
===================================================================
--- linux-2.6.23-rc2-iommu.orig/drivers/pci/intel-iommu.h	2007-11-16 13:26:01.000000000 -0800
+++ linux-2.6.23-rc2-iommu/drivers/pci/intel-iommu.h	2007-11-16 13:26:36.000000000 -0800
@@ -71,7 +71,7 @@
 		hi = readl(dmar + reg + 4); \
 		(((u64) hi) << 32) + lo; })
 */
-static inline u64 dmar_readq(void *addr)
+static inline u64 dmar_readq(void __iomem *addr)
 {
 	u32 lo, hi;
 	lo = readl(addr);
@@ -139,6 +139,10 @@
 #define DMA_TLB_IH_NONLEAF (((u64)1) << 6)
 #define DMA_TLB_MAX_SIZE (0x3f)
 
+/* PMEN_REG */
+#define DMA_PMEN_EPM (((u32)1)<<31)
+#define DMA_PMEN_PRS (((u32)1)<<0)
+
 /* GCMD_REG */
 #define DMA_GCMD_TE (((u32)1) << 31)
 #define DMA_GCMD_SRTP (((u32)1) << 30)
