Return-Path: <linux-kernel-owner+w=401wt.eu-S1762312AbXFDWeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762312AbXFDWeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbXFDWcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:32:05 -0400
Received: from mga06.intel.com ([134.134.136.21]:56368 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759911AbXFDWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:32:03 -0400
X-ExtLoopCount2: 2 from 172.25.110.8
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="250776922"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,382,1175497200"; 
   d="scan'208";a="253128029"
Message-Id: <20070604210644.722217000@askeshav-devel.jf.intel.com>
References: <20070604210242.079459000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jun 2007 14:02:51 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 09/10] Iommu Gfx workaround
Content-Disposition: inline; filename=gfx_wrkaround.patch
X-OriginalArrivalTime: 04 Jun 2007 21:23:59.0696 (UTC) FILETIME=[AA8A3500:01C7A6EE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we fix all the opensource gfx drivers to use the DMA api's,
at that time we can yank this config options out.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 Documentation/Intel-IOMMU.txt |    5 +++++
 arch/x86_64/Kconfig           |   11 +++++++++++
 arch/x86_64/kernel/e820.c     |   19 +++++++++++++++++++
 drivers/pci/intel-iommu.c     |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 67 insertions(+)

Index: linux-2.6.22-rc3/Documentation/Intel-IOMMU.txt
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/Intel-IOMMU.txt	2007-06-04 12:40:58.000000000 -0700
+++ linux-2.6.22-rc3/Documentation/Intel-IOMMU.txt	2007-06-04 12:41:11.000000000 -0700
@@ -57,6 +57,11 @@
 If you encounter issues with graphics devices, you can try adding
 option intel_iommu=igfx_off to turn off the integrated graphics engine.
 
+If it happens to be a PCI device included in the INCLUDE_ALL Engine,
+then try enabling CONFIG_DMAR_GFX_WA to setup a 1-1 map. We hear
+graphics drivers may be in process of using DMA api's in the near
+future and at that time this option can be yanked out.
+
 Some exceptions to IOVA
 -----------------------
 Interrupt ranges are not address translated, (0xfee00000 - 0xfeefffff).
Index: linux-2.6.22-rc3/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/Kconfig	2007-06-04 12:35:19.000000000 -0700
+++ linux-2.6.22-rc3/arch/x86_64/Kconfig	2007-06-04 12:41:11.000000000 -0700
@@ -727,6 +727,17 @@
 	  and includes pci device scope covered by these DMA
 	  remapping device.
 
+config DMAR_GFX_WA
+	bool "Support for Graphics workaround"
+	depends on DMAR
+	default y
+	help
+	 Current Graphics drivers tend to use physical address
+	 for DMA and avoid using DMA api's. Setting this config
+	 option permits the IOMMU driver to set a unity map for
+	 all the OS visible memory. Hence the driver can continue
+	 to use physical addresses for DMA.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
Index: linux-2.6.22-rc3/arch/x86_64/kernel/e820.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/kernel/e820.c	2007-06-04 12:19:13.000000000 -0700
+++ linux-2.6.22-rc3/arch/x86_64/kernel/e820.c	2007-06-04 12:41:11.000000000 -0700
@@ -717,3 +717,22 @@
 	printk(KERN_INFO "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
 		pci_mem_start, gapstart, gapsize);
 }
+
+int __init arch_get_ram_range(int slot, u64 *addr, u64 *size)
+{
+	int i;
+
+	if (slot < 0 || slot >= e820.nr_map)
+		return -1;
+	for (i = slot; i < e820.nr_map; i++) {
+		if(e820.map[i].type != E820_RAM)
+			continue;
+		break;
+	}
+	if (i == e820.nr_map || e820.map[i].addr > (max_pfn << PAGE_SHIFT))
+		return -1;
+	*addr = e820.map[i].addr;
+	*size = min_t(u64, e820.map[i].size + e820.map[i].addr,
+		max_pfn << PAGE_SHIFT) - *addr;
+	return i + 1;
+}
Index: linux-2.6.22-rc3/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pci/intel-iommu.c	2007-06-04 12:40:58.000000000 -0700
+++ linux-2.6.22-rc3/drivers/pci/intel-iommu.c	2007-06-04 12:41:11.000000000 -0700
@@ -1556,6 +1556,34 @@
 		rmrr->end_address + 1);
 }
 
+#ifdef CONFIG_DMAR_GFX_WA
+extern int arch_get_ram_range(int slot, u64 *addr, u64 *size);
+static void __init iommu_prepare_gfx_mapping(void)
+{
+	struct pci_dev *pdev = NULL;
+	u64 base, size;
+	int slot;
+	int ret;
+
+	for_each_pci_dev(pdev) {
+		if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO ||
+				!IS_GFX_DEVICE(pdev))
+			continue;
+		printk(KERN_INFO "IOMMU: gfx device %s 1-1 mapping\n",
+			pci_name(pdev));
+		slot = 0;
+		while ((slot = arch_get_ram_range(slot, &base, &size)) >= 0) {
+			ret = iommu_prepare_identity_map(pdev, base, base + size);
+			if (ret)
+				goto error;
+		}
+		continue;
+error:
+		printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
+	}
+}
+#endif
+
 int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -1611,6 +1639,10 @@
 			printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
 	end_for_each_rmrr_device(rmrr, pdev)
 
+#ifdef CONFIG_DMAR_GFX_WA
+	iommu_prepare_gfx_mapping();
+#endif
+
 	/*
 	 * for each drhd
 	 *   enable fault log

-- 
