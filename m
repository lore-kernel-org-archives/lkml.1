Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXFSWVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXFSWVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbXFSWSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:18:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:40775 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbXFSWSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:18:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,439,1175497200"; 
   d="scan'208";a="256480260"
Message-Id: <20070619213809.110034000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 14:37:11 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: ak@suse.de, gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Subject: [Intel IOMMU 10/10] Iommu floppy workaround
Content-Disposition: inline; filename=floppy_disk_wrkaround.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	This config option (DMAR_FLPY_WA) sets up 1:1 mapping for the
floppy device so that the floppy device which does not use
DMA api's will continue to work. 

Once the floppy driver starts using DMA api's this config option
can be turn off or this patch can be yanked out of kernel at that
time.


Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 arch/x86_64/Kconfig       |   10 ++++++++++
 drivers/pci/intel-iommu.c |   22 ++++++++++++++++++++++
 drivers/pci/intel-iommu.h |    7 +++++++
 3 files changed, 39 insertions(+)

Index: linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm2.orig/arch/x86_64/Kconfig	2007-06-18 15:45:08.000000000 -0700
+++ linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig	2007-06-18 15:45:09.000000000 -0700
@@ -752,6 +752,16 @@
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
Index: linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/intel-iommu.c	2007-06-18 15:45:08.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c	2007-06-18 15:45:09.000000000 -0700
@@ -1631,6 +1631,26 @@
 }
 #endif
 
+#ifdef CONFIG_DMAR_FLPY_WA
+static inline void iommu_prepare_isa(void)
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
+		printk ("IOMMU: Failed to create 0-64M identity map, \
+			Floppy might not work\n");
+
+}
+#endif
+
 int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -1696,6 +1716,8 @@
 
 	iommu_prepare_gfx_mapping();
 
+	iommu_prepare_isa();
+
 	/*
 	 * for each drhd
 	 *   enable fault log
Index: linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/intel-iommu.h	2007-06-18 15:45:08.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.h	2007-06-18 15:45:09.000000000 -0700
@@ -322,4 +322,11 @@
 }
 #endif /* !CONFIG_DMAR_GFX_WA */
 
+#ifndef CONFIG_DMAR_FLPY_WA
+static inline void iommu_prepare_isa(void)
+{
+	return;
+}
+#endif /* !CONFIG_DMAR_FLPY_WA */
+
 #endif

-- 
