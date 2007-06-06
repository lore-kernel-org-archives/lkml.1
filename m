Return-Path: <linux-kernel-owner+w=401wt.eu-S935448AbXFFTTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448AbXFFTTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934729AbXFFTQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:16:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:18125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496AbXFFTQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:16:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="253987306"
Message-Id: <20070606190043.136940000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 11:57:08 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 10/10] Iommu floppy workaround
Content-Disposition: inline; filename=floppy_disk_wrkaround.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	This config option (DMAR_FLPY_WA) sets up 1:1 mapping for the
floppy device so that the floppy device which does not use
DMA api's will continue to work.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 arch/x86_64/Kconfig       |   10 ++++++++++
 drivers/pci/intel-iommu.c |   23 +++++++++++++++++++++++
 2 files changed, 33 insertions(+)

Index: linux-2.6.22-rc3/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/Kconfig	2007-06-05 12:58:08.000000000 -0700
+++ linux-2.6.22-rc3/arch/x86_64/Kconfig	2007-06-05 12:58:08.000000000 -0700
@@ -738,6 +738,16 @@
 	 all the OS visible memory. Hence the driver can continue
 	 to use physical addresses for DMA.
 
+config DMAR_FLPY_WA
+	bool "Support for Floppy disk workaround"
+	depends on DMAR
+	default y
+	help
+	 Floppy disk drivers are know to by pass dma api calls
+	 their by failing to work when IOMMU is enabled. This
+	 work around will setup a 1 to 1 mappings for the first
+	 16M to make floppy(isa device) work.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
Index: linux-2.6.22-rc3/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pci/intel-iommu.c	2007-06-05 12:58:08.000000000 -0700
+++ linux-2.6.22-rc3/drivers/pci/intel-iommu.c	2007-06-05 12:58:08.000000000 -0700
@@ -1584,6 +1584,25 @@
 }
 #endif
 
+#ifdef CONFIG_DMAR_FLPY_WA
+static void iommu_prepare_isa(void)
+{
+	struct pci_dev *pdev = NULL;
+	int ret;
+
+	pdev = pci_get_class (PCI_CLASS_BRIDGE_ISA << 8, NULL);
+	if (!pdev)
+		return;
+
+	printk (KERN_INFO "IOMMU: Prepare 0-16M unity mapping for LPC\n");
+	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
+
+	if (ret)
+		printk ("IOMMU: Failed to create 0-64M identity map, Floppy might not work\n");
+
+}
+#endif
+
 int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -1643,6 +1662,10 @@
 	iommu_prepare_gfx_mapping();
 #endif
 
+#ifdef CONFIG_DMAR_FLPY_WA
+	iommu_prepare_isa();
+#endif
+
 	/*
 	 * for each drhd
 	 *   enable fault log

-- 
