Return-Path: <linux-kernel-owner+w=401wt.eu-S1422663AbXDXPLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422663AbXDXPLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161802AbXDXPIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:08:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:27094 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161799AbXDXPIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:08:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="78354392:sNHT17307477"
Message-Id: <20070423164957.498821000@linux.intel.com>
References: <20070423163837.447443000@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 09:38:44 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com
Subject: [Intel IOMMU][patch 7/8] Support for legacy ISA devices
Content-Disposition: inline; filename=fd0-workaround.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Floppy disk drivers dont work well with DMA remapping. Its possible to 
extend the current use for x86_64, but the gain is very little. If someone
feels compelled to clean this up, its up for grabs. Since these use 16M, we 
just provide a unity map for the ISA bridge device.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
------------------------------------
Index: linux-2.6.21-rc5/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.21-rc5.orig/Documentation/kernel-parameters.txt	2007-04-17 05:41:56.000000000 -0700
+++ linux-2.6.21-rc5/Documentation/kernel-parameters.txt	2007-04-17 05:41:59.000000000 -0700
@@ -730,6 +730,11 @@
 			the IOMMU driver to set a unity map for all OS
 			visible memory. Hence the driver can continue to use
 			physical addresses for DMA.
+		noisamap
+			This option is required to setup identify map for
+			first 16M. The floppy disk could be modified to use
+			the DMA api's but thats a lot of pain for very small
+			gain. This option is turned on by default.
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
Index: linux-2.6.21-rc5/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pci/intel-iommu.c	2007-04-17 05:41:53.000000000 -0700
+++ linux-2.6.21-rc5/drivers/pci/intel-iommu.c	2007-04-17 05:41:59.000000000 -0700
@@ -37,6 +37,8 @@
 #include "pci.h"
 
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
+#define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
+
 #define IOAPIC_RANGE_START	(0xfee00000)
 #define IOAPIC_RANGE_END	(0xfeefffff)
 #define IOAPIC_RANGE_SIZE	(IOAPIC_RANGE_END - IOAPIC_RANGE_START + 1)
@@ -87,6 +89,7 @@
 
 static int dmar_disabled, dmar_force_rw;
 static int dmar_map_gfx = 1, dmar_no_gfx_identity_map = 1;
+static int dmar_fix_isa = 1;
 
 static char *get_fault_reason(u8 fault_reason)
 {
@@ -113,6 +116,9 @@
 		} else if (!strncmp(str, "gfx_workaround", 14)) {
 			dmar_no_gfx_identity_map = 0;
 			printk(KERN_INFO"Intel-IOMMU: do 1-1 mapping whole physical memory for GFX device\n");
+		} else if (!strncmp(str, "noisamap", 8)) {
+			dmar_fix_isa = 0;
+			printk (KERN_INFO"Intel-IOMMU: Turning off 16M unity map for LPC\n");
 		}
 
 		str += strcspn(str, ",");
@@ -1582,6 +1588,25 @@
 	}
 }
 
+static void iommu_prepare_isa(void)
+{
+	struct pci_dev *pdev = NULL;
+	int ret;
+
+	if (!dmar_fix_isa)
+		return;
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
 int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -1638,6 +1663,7 @@
 	end_for_each_rmrr_device(rmrr, pdev)
 
 	iommu_prepare_gfx_mapping();
+	iommu_prepare_isa();
 
 	/*
 	 * for each drhd

-- 
