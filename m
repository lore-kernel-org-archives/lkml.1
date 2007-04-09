Return-Path: <linux-kernel-owner+w=401wt.eu-S966007AbXDIWt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966007AbXDIWt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXDIWt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:49:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:21199 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965913AbXDIWsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="70978883:sNHT19138284"
Message-Id: <20070409215723.969189000@intel.com>
References: <20070409215552.221374000@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 09 Apr 2007 14:55:57 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com
Subject: [patch 5/8] [Intel IOMMU] Graphics driver workarounds to provide unity map
Content-Disposition: inline; filename=iommu-gfx.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most GFX drivers don't call standard PCI DMA APIs to allocate DMA buffer,
Such drivers will be broken with IOMMU enabled. To workaround this issue, 
we added two options.

Once graphics devices are converted over to use the DMA-API's this entire
patch can be removed... 

a. intel_iommu=igfx_off. With this option, DMAR who has just gfx devices
   under it will be ignored. This mostly affect intergated gfx devices.
   If the DMAR is ignored, gfx device under it will get physical address
   for DMA.
b. intel_iommu=gfx_workaround. With this option, we will setup 1:1 mapping
   for whole memory for gfx devices, that is physical address equals to
   virtual address.In this way, gfx will use physical address for DMA, this
   is primarily for add-in card GFX device.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Index: linux-2.6.21-rc5/arch/x86_64/kernel/e820.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/e820.c	2007-04-09 03:02:37.000000000 -0700
+++ linux-2.6.21-rc5/arch/x86_64/kernel/e820.c	2007-04-09 03:05:34.000000000 -0700
@@ -730,3 +730,22 @@
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
Index: linux-2.6.21-rc5/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pci/intel-iommu.c	2007-04-09 03:05:32.000000000 -0700
+++ linux-2.6.21-rc5/drivers/pci/intel-iommu.c	2007-04-09 03:05:34.000000000 -0700
@@ -36,6 +36,7 @@
 #include "iova.h"
 #include "pci.h"
 
+#define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IOAPIC_RANGE_START	(0xfee00000)
 #define IOAPIC_RANGE_END	(0xfeefffff)
 #define IOAPIC_RANGE_SIZE	(IOAPIC_RANGE_END - IOAPIC_RANGE_START + 1)
@@ -85,6 +86,7 @@
 };
 
 static int dmar_disabled, dmar_force_rw;
+static int dmar_map_gfx = 1, dmar_no_gfx_identity_map = 1;
 
 static char *get_fault_reason(u8 fault_reason)
 {
@@ -105,7 +107,14 @@
 		} else if (!strncmp(str, "forcerw", 7)) {
 			dmar_force_rw = 1;
 			printk(KERN_INFO"Intel-IOMMU: force R/W for W/O mapping\n");
+		} else if (!strncmp(str, "igfx_off", 8)) {
+			dmar_map_gfx = 0;
+			printk(KERN_INFO"Intel-IOMMU: disable GFX device mapping\n");
+		} else if (!strncmp(str, "gfx_workaround", 14)) {
+			dmar_no_gfx_identity_map = 0;
+			printk(KERN_INFO"Intel-IOMMU: do 1-1 mapping whole physical memory for GFX device\n");
 		}
+
 		str += strcspn(str, ",");
 		while (*str == ',')
 			str++;
@@ -1311,6 +1320,7 @@
 	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
 	struct domain *domain;
 };
+#define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
 static LIST_HEAD(device_domain_list);
 
@@ -1531,10 +1541,40 @@
 static inline int iommu_prepare_rmrr_dev(struct acpi_rmrr_unit *rmrr,
 	struct pci_dev *pdev)
 {
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return 0;
 	return iommu_prepare_identity_map(pdev, rmrr->base_address,
 		rmrr->end_address + 1);
 }
 
+static void iommu_prepare_gfx_mapping(void)
+{
+	struct pci_dev *pdev = NULL;
+	u64 base, size;
+	int slot;
+	int ret;
+
+	if (dmar_no_gfx_identity_map)
+		return;
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
+
 int __init init_dmars(void)
 {
 	struct acpi_drhd_unit *drhd;
@@ -1550,6 +1590,8 @@
 	 * endfor
 	 */
 	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
 		iommu = alloc_iommu(drhd);
 		if (!iommu) {
 			ret = -ENOMEM;
@@ -1588,6 +1630,8 @@
 			printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
 	end_for_each_rmrr_device(rmrr, pdev)
 
+	iommu_prepare_gfx_mapping();
+
 	/*
 	 * for each drhd
 	 *   enable fault log
@@ -1596,6 +1640,8 @@
 	 *   enable translation
 	 */
 	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
 		iommu = drhd->iommu;
 		sprintf (iommu->name, "dmar%d", unit++);
 
@@ -1618,6 +1664,8 @@
 	return 0;
 error:
 	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
 		iommu = drhd->iommu;
 		free_iommu(iommu);
 	}
@@ -1711,6 +1759,9 @@
 	u64 flush_addr;
 	unsigned int flush_size;
 
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return virt_to_bus(addr);
+
 	ret = __intel_map_single(dev, addr, size, dir, &flush_addr, &flush_size);
 	if (ret) {
 		domain = find_domain(pdev);
@@ -1758,6 +1809,9 @@
 	u64 flush_addr;
 	unsigned int flush_size;
 
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return;
+
 	domain = find_domain(pdev);
 	__intel_unmap_single(dev, dev_addr, size, dir, &flush_addr, &flush_size);
 	if (flush_size == 0)
@@ -1781,6 +1835,7 @@
 	if (!ret)
 		return NULL;
 	memset(ret, 0, size);
+
 	*dma_handle = intel_map_single(hwdev, ret, size, DMA_BIDIRECTIONAL);
 	if (*dma_handle)
 		return ret;
@@ -1809,6 +1864,9 @@
 	u64 flush_addr;
 	unsigned int flush_size;
 
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return;
+
 	domain = find_domain(pdev);
 	for (i = 0; i < nelems; i++, sg++)
 		__intel_unmap_single(hwdev, sg->dma_address,
@@ -1819,6 +1877,20 @@
 }
 
 #define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
+static int intel_nontranslate_map_sg(struct device* hddev,
+	struct scatterlist *sg, int nelems, int dir)
+{
+	int i;
+
+ 	for (i = 0; i < nelems; i++) {
+		struct scatterlist *s = &sg[i];
+		BUG_ON(!s->page);
+		s->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(s));
+		s->dma_length = s->length;
+	}
+	return nelems;
+}
+
 static int intel_map_sg(struct device *hwdev, struct scatterlist *sg,
 	int nelems, int dir)
 {
@@ -1831,6 +1903,8 @@
 	unsigned int flush_size;
 
 	BUG_ON(dir == DMA_NONE);
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
 
 	for (i = 0; i < nelems; i++, sg++) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
@@ -1919,6 +1993,49 @@
 	}
 }
 
+static void __init init_no_remapping_devices(void)
+{
+	struct acpi_drhd_unit *drhd;
+
+	for_each_drhd_unit(drhd) {
+		int i;
+		if (drhd->devices_cnt == 0 && !drhd->include_all)  {
+			drhd->ignored = 1;
+			continue;
+		}
+		for (i = 0; i < drhd->devices_cnt; i++)
+			if (drhd->devices[i] != NULL)
+				break;
+		if (!drhd->include_all && i == drhd->devices_cnt) {
+			drhd->ignored = 1;
+			continue;
+		}
+	}
+
+	if (dmar_map_gfx)
+		return;
+
+	for_each_drhd_unit(drhd) {
+		int i;
+		if (drhd->ignored || drhd->include_all)
+			continue;
+
+		for (i = 0; i < drhd->devices_cnt; i++)
+			if (drhd->devices[i] && !IS_GFX_DEVICE(drhd->devices[i]))
+				break;
+		if (i < drhd->devices_cnt)
+			continue;
+
+		/* bypass IOMMU if it is just for gfx devices */
+		drhd->ignored = 1;
+		for (i = 0; i < drhd->devices_cnt; i++) {
+			if (!drhd->devices[i])
+				continue;
+			drhd->devices[i]->sysdata = DUMMY_DEVICE_DOMAIN_INFO;
+		}
+	}
+}
+
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
@@ -1932,6 +2049,8 @@
 	iommu_init_mempool();
 	dmar_init_reserved_ranges();
 
+	init_no_remapping_devices();
+
 	ret = init_dmars();
 	if (ret) {
 		printk(KERN_ERR "IOMMU: dmar init failed\n");
Index: linux-2.6.21-rc5/include/acpi/dmar.h
===================================================================
--- linux-2.6.21-rc5.orig/include/acpi/dmar.h	2007-04-09 03:03:30.000000000 -0700
+++ linux-2.6.21-rc5/include/acpi/dmar.h	2007-04-09 03:05:34.000000000 -0700
@@ -32,6 +32,7 @@
 	int	devices_cnt;
 	u8	include_all:1;
 	struct iommu *iommu;
+	int	ignored:1; /* the drhd should be ignored */
 };
 
 struct acpi_rmrr_unit {
Index: linux-2.6.21-rc5/include/linux/intel-iommu.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/intel-iommu.h	2007-04-09 03:05:32.000000000 -0700
+++ linux-2.6.21-rc5/include/linux/intel-iommu.h	2007-04-09 03:05:34.000000000 -0700
@@ -262,6 +262,8 @@
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
+extern int arch_get_ram_range(int slot, u64 *addr, u64 *size);
+
 extern int init_dmars(void);
 extern void detect_intel_iommu(void);
 extern int early_dmar_detect(void);

-- 
