Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYJGUgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYJGUgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYJGUf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:35:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:20913 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275AbYJGUfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:35:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="345106224"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [RFC][PATCH 2/3] TXT: Intel IOMMU PMR Disable
Date: Tue, 7 Oct 2008 13:34:52 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005AC105E@orsmsx416.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 2/3] TXT: Intel IOMMU PMR Disable
Thread-Index: AckovCaqOpdV0yk+RfiIxVbPkDYs2g==
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 07 Oct 2008 20:34:53.0383 (UTC) FILETIME=[2739C570:01C928BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable Intel VT-d (IOMMU) Protected Memory Regions (PMRs) when DMA
remapping is enabled.

Leaving the PMRs enabled may add more delay to the VT-d DMA request
processing (as another lookup may be performed) but whether they are
even used is not deterministic:
	DMA requests that are subject to address remapping, and
accessing the
	protected memory regions may or may not be blocked by hardware.
For
	such requests, software must not depend on hardware protection
of the
	protected memory regions, and instead program the DMA-remapping
	page-tables to block DMA to protected memory regions.
	-- from the description field of the PMEN_REG register in the
v1.2 (May '08) VT-d spec.

Signed-off-by:  Shane Wang <shane.wang@intel.com>
Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>

diff -r 29cfdc52a076 drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c Mon Oct 06 12:50:47 2008 -0700
+++ b/drivers/pci/intel-iommu.c Mon Oct 06 15:54:59 2008 -0700
@@ -742,6 +742,22 @@ static void iommu_disable_protect_mem_re
        spin_unlock_irqrestore(&iommu->register_lock, flags);
 }

+static void disable_pmr(struct intel_iommu *iommu)
+{
+       u32 data;
+
+       data = readl(iommu->reg + DMAR_PMEN_REG);
+       if (!(data & DMA_PMEN_PRS))
+               return;
+
+       data = data & ~DMA_PMEN_EPM;
+       writel(data, iommu->reg + DMAR_PMEN_REG);
+
+       IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
+               readl, !(data & DMA_PMEN_PRS), data);
+       return;
+}
+
 static int iommu_enable_translation(struct intel_iommu *iommu)
 {
        u32 sts;
@@ -755,6 +771,7 @@ static int iommu_enable_translation(stru
                readl, (sts & DMA_GSTS_TES), sts);

        iommu->gcmd |= DMA_GCMD_TE;
+       disable_pmr(iommu);
        spin_unlock_irqrestore(&iommu->register_lock, flags);
        return 0;
 }
diff -r 29cfdc52a076 drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h Mon Oct 06 12:50:47 2008 -0700
+++ b/drivers/pci/intel-iommu.h Mon Oct 06 15:54:59 2008 -0700
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
