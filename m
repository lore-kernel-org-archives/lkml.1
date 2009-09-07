Return-Path: <linux-kernel-owner+w=401wt.eu-S1759019AbZIGGeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019AbZIGGeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758982AbZIGGet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:34:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:15810 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758954AbZIGGet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:34:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,344,1249282800"; 
   d="scan'208";a="491119478"
Date: Mon, 7 Sep 2009 10:13:13 -0400
From: Youquan Song <youquan.song@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       Suresh Siddha <suresh.b.siddha@intel.com>, youqun.song@intel.com
Subject: Fix interrupt remapping hang if interrupt remapping disable in BIOS
Message-ID: <20090907141313.GA26091@youquan-linux.bj.intel.com>
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
affected by BIOS setting. 

So though BIOS disable interrupt remapping feature, However, 
intr_remapping_supported function will report interrupt supported. On this 
cases, it will continue to enable interrupt remapping result kernel hang. 
This bug exists on most platforms support interrupt remapping.      

This patch add DMAR table INTR_REMAP flag check before enable interrup remapping

Signed-off-by: Youquan Song <youquan.song@intel.com>
---

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index a8a4383..78f4ca8 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -43,7 +43,7 @@
  */
 LIST_HEAD(dmar_drhd_units);
 
-static struct acpi_table_header * __initdata dmar_tbl;
+struct acpi_table_header * __initdata dmar_tbl;
 static acpi_size dmar_tbl_size;
 
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index ebfa47b..97d1561 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -16,6 +16,7 @@
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
 int intr_remapping_enabled;
+extern struct acpi_table_header *__initdata dmar_tbl;
 
 static int disable_intremap;
 static __init int setup_nointremap(char *str)
@@ -607,9 +608,14 @@ end:
 int __init intr_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
-
+	struct acpi_table_dmar *dmar;
+
 	if (disable_intremap)
 		return 0;
+
+	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	if (!(dmar->flags & 0x1))
+		return 0;
 
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
