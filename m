Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZIII1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZIII1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZIII1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:27:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:59273 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZIII1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:27:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,357,1249282800"; 
   d="scan'208";a="548993252"
Date: Wed, 9 Sep 2009 12:05:39 -0400
From: Youquan Song <youquan.song@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, gorcunov@gmail.com,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Youquan Song <youquan.song@intel.com>
Subject: [PATCH] IR: Fix kernel hang if interrupt remapping disable in BIOS
Message-ID: <20090909160538.GA3799@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BIOS clear DMAR table INTR_REMAP flag to disable interrupt remapping. Current
kernel only check interrupt remapping(IR) flag in DRHD's extended capability 
register to decide interrupt remapping support or not. But IR flag will not 
change when BIOS disable/enable interrupt remapping. 

When user disable interrupt remapping in BIOS or BIOS often defaultly disable 
interrupt remapping feature when BIOS is not mature.Though BIOS disable
interrupt remapping but intr_remapping_supported function will always report 
to OS support interrupt remapping if VT-d2 chipset populated. On this 
cases, kernel will continue enable interrupt remapping and result kernel panic. 
This bug exist on almost all platforms with interrupt remapping support.      

This patch add DMAR table INTR_REMAP flag check before enable interrup remapping

Signed-off-by: Youquan Song <youquan.song@intel.com>
---

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index a8a4383..d943e95 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1302,3 +1302,13 @@ int dmar_reenable_qi(struct intel_iommu *iommu)
 
 	return 0;
 }
+
+/*
+ * Check interrupt remapping support in DMAR table description.
+ */
+int dmar_ir_support(void)
+{
+	struct acpi_table_dmar *dmar;
+	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	return dmar->flags & 0x1;
+}
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index ebfa47b..ac06514 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -611,6 +611,9 @@ int __init intr_remapping_supported(void)
 	if (disable_intremap)
 		return 0;
 
+	if (!dmar_ir_support())
+		return 0;
+
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 482dc91..4f0a72a 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -360,4 +360,6 @@ extern void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 qdep,
 
 extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
+extern int dmar_ir_support(void);
+
 #endif
