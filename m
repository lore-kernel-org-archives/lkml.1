Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbXFSWUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbXFSWUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXFSWS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:18:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:50152 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273AbXFSWSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:18:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,439,1175497200"; 
   d="scan'208";a="258836666"
Message-Id: <20070619213809.033447000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 14:37:10 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: ak@suse.de, gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Subject: [Intel IOMMU 09/10] Iommu Gfx workaround
Content-Disposition: inline; filename=gfx_wrkaround.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When we fix all the opensource gfx drivers to use the DMA api's,
at that time we can yank this config options out.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 Documentation/Intel-IOMMU.txt |    5 +++++
 arch/x86_64/Kconfig           |   11 +++++++++++
 arch/x86_64/kernel/e820.c     |   19 +++++++++++++++++++
 drivers/pci/intel-iommu.c     |   33 +++++++++++++++++++++++++++++++++
 drivers/pci/intel-iommu.h     |    7 +++++++
 5 files changed, 75 insertions(+)

Index: linux-2.6.22-rc4-mm2/Documentation/Intel-IOMMU.txt
===================================================================
--- linux-2.6.22-rc4-mm2.orig/Documentation/Intel-IOMMU.txt	2007-06-18 15:45:08.000000000 -0700
+++ linux-2.6.22-rc4-mm2/Documentation/Intel-IOMMU.txt	2007-06-18 15:45:08.000000000 -0700
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
Index: linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc4-mm2.orig/arch/x86_64/Kconfig	2007-06-18 15:45:07.000000000 -0700
+++ linux-2.6.22-rc4-mm2/arch/x86_64/Kconfig	2007-06-18 15:45:08.000000000 -0700
@@ -741,6 +741,17 @@
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
Index: linux-2.6.22-rc4-mm2/arch/x86_64/kernel/e820.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/arch/x86_64/kernel/e820.c	2007-06-18 15:44:44.000000000 -0700
+++ linux-2.6.22-rc4-mm2/arch/x86_64/kernel/e820.c	2007-06-18 15:45:08.000000000 -0700
@@ -723,3 +723,22 @@
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
+		if (e820.map[i].type != E820_RAM)
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
Index: linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/intel-iommu.c	2007-06-18 15:45:08.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c	2007-06-18 15:45:08.000000000 -0700
@@ -1601,6 +1601,36 @@
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
+		slot = arch_get_ram_range(0, &base, &size);
+		while (slot >= 0) {
+			ret = iommu_prepare_identity_map(pdev,
+					base, base + size);
+			if (ret)
+				goto error;
+			slot = arch_get_ram_range(slot, &base, &size);
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
@@ -1664,6 +1694,8 @@
 		}
 	}
 
+	iommu_prepare_gfx_mapping();
+
 	/*
 	 * for each drhd
 	 *   enable fault log
@@ -2175,3 +2207,4 @@
 	dma_ops = &intel_dma_ops;
 	return 0;
 }
+
Index: linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/intel-iommu.h	2007-06-18 15:45:08.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.h	2007-06-18 15:45:08.000000000 -0700
@@ -315,4 +315,11 @@
 	struct sys_device sysdev;
 };
 
+#ifndef CONFIG_DMAR_GFX_WA
+static inline void iommu_prepare_gfx_mapping(void)
+{
+	return;
+}
+#endif /* !CONFIG_DMAR_GFX_WA */
+
 #endif

-- 
