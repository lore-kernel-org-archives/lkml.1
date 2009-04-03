Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbZDCJR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbZDCJR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZDCJQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:16:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:18725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbZDCJQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:16:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,318,1235980800"; 
   d="scan'208";a="678442771"
From: "Han, Weidong" <weidong.han@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kay, Allen M" <allen.m.kay@intel.com>
CC: IOMMU <iommu@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 3 Apr 2009 17:15:47 +0800
Subject: [patch 1/2] intel-iommu: set compatibility format interrupt
Thread-Topic: [patch 1/2] intel-iommu: set compatibility format interrupt
Thread-Index: Acm0PMX+fHDyYg0xQkGKxvso3rZhHQ==
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7C3A6@pdsmsx503.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When extended interrupt mode (x2apic mode) is not supported in a
system, it must set compatibility format interrupt to bypass
interrupt remapping, otherwise compatibility format interrupts
will be blocked.

This will be used when interrupt remapping is enabled while x2apic
is not supported.

Signed-off-by: Weidong Han <weidong.han@intel.com>
---
 drivers/pci/intr_remapping.c |   15 +++++++++++++++
 include/linux/intel-iommu.h  |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 9d07a05..02dfd1a 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -407,12 +407,27 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 
 	/* Set interrupt-remapping table pointer */
 	cmd = iommu->gcmd | DMA_GCMD_SIRTP;
+	iommu->gcmd |= DMA_GCMD_SIRTP;
 	writel(cmd, iommu->reg + DMAR_GCMD_REG);
 
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_IRTPS), sts);
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 
+	if (mode == 0) {
+		spin_lock_irqsave(&iommu->register_lock, flags);
+
+		/* enable comaptiblity format interrupt pass through */
+		cmd = iommu->gcmd | DMA_GCMD_CFI;
+		iommu->gcmd |= DMA_GCMD_CFI;
+		writel(cmd, iommu->reg + DMAR_GCMD_REG);
+
+		IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
+			      readl, (sts & DMA_GSTS_CFIS), sts);
+
+		spin_unlock_irqrestore(&iommu->register_lock, flags);
+	}
+
 	/*
 	 * global invalidation of interrupt entry cache before enabling
 	 * interrupt-remapping.
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index d2e3cbf..0f60ccc 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -164,6 +164,7 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 #define DMA_GCMD_QIE (((u32)1) << 26)
 #define DMA_GCMD_SIRTP (((u32)1) << 24)
 #define DMA_GCMD_IRE (((u32) 1) << 25)
+#define DMA_GCMD_CFI (((u32) 1) << 23)
 
 /* GSTS_REG */
 #define DMA_GSTS_TES (((u32)1) << 31)
@@ -174,6 +175,7 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 #define DMA_GSTS_QIES (((u32)1) << 26)
 #define DMA_GSTS_IRTPS (((u32)1) << 24)
 #define DMA_GSTS_IRES (((u32)1) << 25)
+#define DMA_GSTS_CFIS (((u32)1) << 23)
 
 /* CCMD_REG */
 #define DMA_CCMD_ICC (((u64)1) << 63)
-- 
1.6.0.4
