Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYJGXYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYJGXYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYJGXYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:24:09 -0400
Received: from mga10.intel.com ([192.55.52.92]:41656 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753660AbYJGXYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:24:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="388798940"
Message-ID: <48EBEF53.9060904@linux.intel.com>
Date: Tue, 07 Oct 2008 16:22:59 -0700
From: Joseph Cihula <joseph.cihula@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: shane.wang@intel.com, gang.wei@intel.com, arjan@linux.intel.com,
       asit.k.mallick@intel.com, jun.nakajima@intel.com, chrisw@sous-sol.org,
       jbeulich@novell.com, mingo@elte.hu, tytso@mit.edu,
       linux-kernel@vger.kernel.org, joseph.cihula@intel.com
Subject: [RFC][PATCH 2/3] TXT: Intel IOMMU PMR Disable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-posted with apologies for formatting and email addresses)

Disable Intel VT-d (IOMMU) Protected Memory Regions (PMRs) when DMA 
remapping is enabled.

Leaving the PMRs enabled may add more delay to the VT-d DMA request 
processing (as another lookup may be performed) but whether they are 
even used is not deterministic:
    DMA requests that are subject to address remapping, and accessing the
    protected memory regions may or may not be blocked by hardware. For
    such requests, software must not depend on hardware protection of the
    protected memory regions, and instead program the DMA-remapping
    page-tables to block DMA to protected memory regions.
    -- from the description field of the PMEN_REG register in the v1.2 
(May '08) VT-d spec.

Signed-off-by:  Shane Wang <shane.wang@intel.com>
Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>

---

diff -r 29cfdc52a076 drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c	Mon Oct 06 12:50:47 2008 -0700
+++ b/drivers/pci/intel-iommu.c	Mon Oct 06 15:54:59 2008 -0700
@@ -742,6 +742,22 @@ static void iommu_disable_protect_mem_re
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 }
 
+static void disable_pmr(struct intel_iommu *iommu)
+{
+	u32 data;
+
+	data = readl(iommu->reg + DMAR_PMEN_REG);
+	if (!(data & DMA_PMEN_PRS))
+		return;
+
+	data = data & ~DMA_PMEN_EPM;
+	writel(data, iommu->reg + DMAR_PMEN_REG);
+
+	IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
+		readl, !(data & DMA_PMEN_PRS), data);
+	return;
+}
+
 static int iommu_enable_translation(struct intel_iommu *iommu)
 {
 	u32 sts;
@@ -755,6 +771,7 @@ static int iommu_enable_translation(stru
 		readl, (sts & DMA_GSTS_TES), sts);
 
 	iommu->gcmd |= DMA_GCMD_TE;
+	disable_pmr(iommu);
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 	return 0;
 }
diff -r 29cfdc52a076 drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h	Mon Oct 06 12:50:47 2008 -0700
+++ b/drivers/pci/intel-iommu.h	Mon Oct 06 15:54:59 2008 -0700
@@ -158,6 +158,10 @@ static inline void dmar_writeq(void __io
 #define DMA_GSTS_FLS (((u32)1) << 29)
 #define DMA_GSTS_AFLS (((u32)1) << 28)
 #define DMA_GSTS_WBFS (((u32)1) << 27)
+
+/* PMEN_REG */
+#define DMA_PMEN_EPM (((u32)1) << 31)
+#define DMA_PMEN_PRS (((u32)1) << 0)
 
 /* CCMD_REG */
 #define DMA_CCMD_ICC (((u64)1) << 63)


