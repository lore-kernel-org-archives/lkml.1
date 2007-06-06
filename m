Return-Path: <linux-kernel-owner+w=401wt.eu-S935501AbXFFTUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935501AbXFFTUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933638AbXFFTQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:16:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:17803 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765595AbXFFTQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:16:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="251572521"
Message-Id: <20070606190042.823168000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 11:57:04 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 06/10] Intel IOMMU driver
Content-Disposition: inline; filename=intel_iommu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Actual intel IOMMU driver. Hardware spec can be found at:
http://www.intel.com/technology/virtualization

This driver sets X86_64 'dma_ops', so hook into standard DMA APIs. In this way,
PCI driver will get virtual DMA address. This change is transparent to PCI
drivers.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 Documentation/Intel-IOMMU.txt       |   93 +
 Documentation/kernel-parameters.txt |   10 
 arch/x86_64/kernel/pci-dma.c        |    9 
 drivers/pci/Makefile                |    5 
 drivers/pci/intel-iommu.c           | 1918 ++++++++++++++++++++++++++++++++++++
 drivers/pci/intel-iommu.h           |  296 +++++
 include/linux/dmar.h                |   23 
 7 files changed, 2353 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc3/Documentation/Intel-IOMMU.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc3/Documentation/Intel-IOMMU.txt	2007-06-06 11:35:01.000000000 -0700
@@ -0,0 +1,93 @@
+Linux IOMMU Support
+===================
+
+The architecture spec can be obtained from the below location.
+
+http://www.intel.com/technology/virtualization/
+
+This guide gives a quick cheat sheet for some basic understanding.
+
+Some Keywords
+
+DMAR - DMA remapping
+DRHD - DMA Engine Reporting Structure
+RMRR - Reserved memory Region Reporting Structure
+ZLR  - Zero length reads from PCI devices
+IOVA - IO Virtual address.
+
+Basic stuff
+-----------
+
+ACPI enumerates and lists the different DMA engines in the platform, and
+device scope relationships between PCI devices and which DMA engine  controls
+them.
+
+What is RMRR?
+-------------
+
+There are some devices the BIOS controls, for e.g USB devices to perform
+PS2 emulation. The regions of memory used for these devices are marked
+reserved in the e820 map. When we turn on DMA translation, DMA to those
+regions will fail. Hence BIOS uses RMRR to specify these regions along with
+devices that need to access these regions. OS is expected to setup
+unity mappings for these regions for these devices to access these regions.
+
+How is IOVA generated?
+---------------------
+
+Well behaved drivers call pci_map_*() calls before sending command to device
+that needs to perform DMA. Once DMA is completed and mapping is no longer
+required, device performs a pci_unmap_*() calls to unmap the region.
+
+The Intel IOMMU driver allocates a virtual address per domain. Each PCIE
+device has its own domain (hence protection). Devices under p2p bridges
+share the virtual address with all devices under the p2p bridge due to
+transaction id aliasing for p2p bridges.
+
+IOVA generation is pretty generic. We used the same technique as vmalloc()
+but these are not global address spaces, but separate for each domain.
+Different DMA engines may support different number of domains.
+
+We also allocate gaurd pages with each mapping, so we can attempt to catch
+any overflow that might happen.
+
+
+Graphics Problems?
+------------------
+If you encounter issues with graphics devices, you can try adding
+option intel_iommu=igfx_off to turn off the integrated graphics engine.
+
+Some exceptions to IOVA
+-----------------------
+Interrupt ranges are not address translated, (0xfee00000 - 0xfeefffff).
+The same is true for peer to peer transactions. Hence we reserve the
+address from PCI MMIO ranges so they are not allocated for IOVA addresses.
+
+Boot Message Sample
+-------------------
+
+Something like this gets printed indicating presence of DMAR tables
+in ACPI.
+
+ACPI: DMAR (v001 A M I  OEMDMAR  0x00000001 MSFT 0x00000097) @ 0x000000007f5b5ef0
+
+When DMAR is being processed and initialized by ACPI, prints DMAR locations
+and any RMRR's processed.
+
+ACPI DMAR:Host address width 36
+ACPI DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed90000
+ACPI DMAR:DRHD (flags: 0x00000000)base: 0x00000000fed91000
+ACPI DMAR:DRHD (flags: 0x00000001)base: 0x00000000fed93000
+ACPI DMAR:RMRR base: 0x00000000000ed000 end: 0x00000000000effff
+ACPI DMAR:RMRR base: 0x000000007f600000 end: 0x000000007fffffff
+
+When DMAR is enabled for use, you will notice..
+
+PCI-DMA: Using DMAR IOMMU
+
+TBD
+----
+
+- For compatibility testing, could use unity map domain for all devices, just
+  provide a 1-1 for all useful memory under a single domain for all devices.
+- API for paravirt ops for abstracting functionlity for VMM folks.
Index: linux-2.6.22-rc3/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/kernel-parameters.txt	2007-06-06 11:33:21.000000000 -0700
+++ linux-2.6.22-rc3/Documentation/kernel-parameters.txt	2007-06-06 11:35:01.000000000 -0700
@@ -776,6 +776,16 @@
 
 	inttest=	[IA64]
 
+	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
+		off
+			Disable intel iommu driver.
+		igfx_off [Default Off]
+			By default, gfx is mapped as normal device. If a gfx
+			device has a dedicated DMAR unit, the DMAR unit is
+			bypassed by not enabling DMAR with this option. In
+			this case, gfx device will use physical address for
+			DMA.
+
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
Index: linux-2.6.22-rc3/arch/x86_64/kernel/pci-dma.c
===================================================================
--- linux-2.6.22-rc3.orig/arch/x86_64/kernel/pci-dma.c	2007-06-06 11:33:21.000000000 -0700
+++ linux-2.6.22-rc3/arch/x86_64/kernel/pci-dma.c	2007-06-06 11:35:01.000000000 -0700
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/dmar.h>
 #include <asm/io.h>
 #include <asm/proto.h>
 #include <asm/calgary.h>
@@ -303,6 +304,10 @@
 	detect_calgary();
 #endif
 
+#ifdef CONFIG_DMAR
+	detect_intel_iommu();
+#endif
+
 #ifdef CONFIG_SWIOTLB
 	pci_swiotlb_init();
 #endif
@@ -314,6 +319,10 @@
 	calgary_iommu_init();
 #endif
 
+#ifdef CONFIG_DMAR
+	intel_iommu_init();
+#endif
+
 #ifdef CONFIG_IOMMU
 	gart_iommu_init();
 #endif
Index: linux-2.6.22-rc3/drivers/pci/Makefile
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pci/Makefile	2007-06-06 11:33:23.000000000 -0700
+++ linux-2.6.22-rc3/drivers/pci/Makefile	2007-06-06 11:35:01.000000000 -0700
@@ -21,7 +21,10 @@
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
 # Build Intel IOMMU support
-obj-$(CONFIG_DMAR) += dmar.o
+obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
+
+#Build Intel-IOMMU support
+obj-$(CONFIG_DMAR) += iova.o dmar.o intel-iommu.o
 
 #
 # Some architectures use the generic PCI setup functions
Index: linux-2.6.22-rc3/drivers/pci/intel-iommu.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc3/drivers/pci/intel-iommu.c	2007-06-06 11:35:36.000000000 -0700
@@ -0,0 +1,1918 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Copyright (C) Ashok Raj <ashok.raj@intel.com>
+ * Copyright (C) Shaohua Li <shaohua.li@intel.com>
+ */
+
+#include <linux/init.h>
+#include <linux/bitmap.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/sysdev.h>
+#include <linux/spinlock.h>
+#include <linux/pci.h>
+#include <linux/dmar.h>
+#include <linux/dma-mapping.h>
+#include <linux/mempool.h>
+#include <linux/respool.h>
+#include "iova.h"
+#include "intel-iommu.h"
+#include <asm/proto.h> /* force_iommu in this header in x86-64*/
+#include <asm/cacheflush.h>
+#include "pci.h"
+
+#define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
+#define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
+
+#define IOAPIC_RANGE_START	(0xfee00000)
+#define IOAPIC_RANGE_END	(0xfeefffff)
+#define IOVA_START_ADDR		(0x1000)
+
+#define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
+
+#define DMAR_OPERATION_TIMEOUT (HZ*60) /* 1m */
+
+#define DOMAIN_MAX_ADDR(gaw) ((((u64)1) << gaw) - 1)
+
+static void domain_remove_dev_info(struct domain *domain);
+
+static int dmar_disabled;
+static int __initdata dmar_map_gfx = 1;
+
+#define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
+static DEFINE_SPINLOCK(device_domain_lock);
+static LIST_HEAD(device_domain_list);
+
+static int __init intel_iommu_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	while (*str) {
+		if (!strncmp(str, "off", 3)) {
+			dmar_disabled = 1;
+			printk(KERN_INFO"Intel-IOMMU: disabled\n");
+		} else if (!strncmp(str, "igfx_off", 8)) {
+			dmar_map_gfx = 0;
+			printk(KERN_INFO"Intel-IOMMU: disable GFX device mapping\n");
+		}
+
+		str += strcspn(str, ",");
+		while (*str == ',')
+			str++;
+	}
+	return 0;
+}
+__setup("intel_iommu=", intel_iommu_setup);
+
+#define MIN_PGTABLE_PAGES	(10)
+#define GROW_PGTABLE_PAGES	(6)
+
+#define MIN_DOMAIN_REQ		(10)
+#define GROW_DOMAIN_REQ		(4)
+
+#define MIN_DEVINFO_REQ		(10)
+#define GROW_DEVINFO_REQ	(4)
+
+#define MIN_IOVA_REQ		(1024)
+#define GROW_IOVA_REQ		(256)
+
+static struct resource_pool iommu_pgtable_pool;
+static struct resource_pool iommu_domain_pool;
+static struct resource_pool iommu_devinfo_pool;
+static struct resource_pool iommu_iova_pool;
+
+static inline void *alloc_pgtable_page(void)
+{
+	return get_resource_pool_obj(&iommu_pgtable_pool);
+}
+
+static inline void free_pgtable_page(void *vaddr)
+{
+	return put_resource_pool_obj(vaddr, &iommu_pgtable_pool);
+}
+
+static inline void *alloc_domain_mem(void)
+{
+	return get_resource_pool_obj(&iommu_domain_pool);
+}
+
+static inline void free_domain_mem(void *vaddr)
+{
+	return put_resource_pool_obj(vaddr, &iommu_domain_pool);
+}
+
+static inline void * alloc_devinfo_mem(void)
+{
+	return get_resource_pool_obj(&iommu_devinfo_pool);
+}
+
+static inline void free_devinfo_mem(void *vaddr)
+{
+	return put_resource_pool_obj(vaddr, &iommu_devinfo_pool);
+}
+
+struct iova *alloc_iova_mem(void)
+{
+	return get_resource_pool_obj(&iommu_iova_pool);
+}
+
+void free_iova_mem(struct iova *iova)
+{
+	put_resource_pool_obj(iova, &iommu_iova_pool);
+}
+
+static inline void __iommu_flush_cache(struct intel_iommu *iommu, void *addr, int size)
+{
+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(addr, size);
+}
+
+/* context entry handling */
+static struct context_entry * device_to_context_entry(struct intel_iommu *iommu,
+		u8 bus, u8 devfn)
+{
+	struct root_entry *root;
+	struct context_entry *context;
+	unsigned long phy_addr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	root = &iommu->root_entry[bus];
+	if (!(context = get_context_addr_from_root(*root))) {
+		context = (struct context_entry *)alloc_pgtable_page();
+		if (!context) {
+			spin_unlock_irqrestore(&iommu->lock, flags);
+			return NULL;
+		}
+		__iommu_flush_cache(iommu, (void *)context, PAGE_SIZE_4K);
+		phy_addr = virt_to_phys((void *)context);
+		set_root_value(*root, phy_addr);
+		set_root_present(*root);
+		__iommu_flush_cache(iommu, root, sizeof(*root));
+	}
+	spin_unlock_irqrestore(&iommu->lock, flags);
+	return &context[devfn];
+}
+
+static int device_context_mapped(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	struct root_entry *root;
+	struct context_entry *context;
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	root = &iommu->root_entry[bus];
+	if (!(context = get_context_addr_from_root(*root))) {
+		ret = 0;
+		goto out;
+	}
+	ret = context_present(context[devfn]);
+out:
+	spin_unlock_irqrestore(&iommu->lock, flags);
+	return ret;
+}
+
+static void clear_context_table(struct intel_iommu *iommu, u8 bus, u8 devfn)
+{
+	struct root_entry *root;
+	struct context_entry *context;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	root = &iommu->root_entry[bus];
+	if ((context = get_context_addr_from_root(*root))) {
+		context_clear_entry(context[devfn]);
+		__iommu_flush_cache(iommu, &context[devfn], \
+			sizeof(*context));
+	}
+	spin_unlock_irqrestore(&iommu->lock, flags);
+}
+
+static void free_context_table(struct intel_iommu *iommu)
+{
+	struct root_entry *root;
+	int i;
+	unsigned long flags;
+	struct context_entry *context;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	if (!iommu->root_entry) {
+		goto out;
+	}
+	for (i = 0; i < ROOT_ENTRY_NR; i++) {
+		root = &iommu->root_entry[i];
+		if ((context = get_context_addr_from_root(*root)))
+			free_pgtable_page(context);
+	}
+	free_pgtable_page(iommu->root_entry);
+	iommu->root_entry = NULL;
+out:
+	spin_unlock_irqrestore(&iommu->lock, flags);
+}
+
+/* page table handling */
+#define LEVEL_STRIDE		(9)
+#define LEVEL_MASK		(((u64)1 << LEVEL_STRIDE) - 1)
+#define agaw_to_level(val) ((val) + 2)
+#define agaw_to_width(val) (30 + val * LEVEL_STRIDE)
+#define width_to_agaw(w)  ((w - 30)/LEVEL_STRIDE)
+#define level_to_offset_bits(l) (12 + (l - 1) * LEVEL_STRIDE)
+#define address_level_offset(addr, level) \
+	((addr >> level_to_offset_bits(level)) & LEVEL_MASK)
+#define level_mask(l) (((u64)(-1)) << level_to_offset_bits(l))
+#define level_size(l) ((u64)1 << level_to_offset_bits(l))
+#define align_to_level(addr, l) ((addr + level_size(l) - 1) & level_mask(l))
+static struct dma_pte * addr_to_dma_pte(struct domain *domain, u64 addr)
+{
+	int addr_width = agaw_to_width(domain->agaw);
+	struct dma_pte *parent, *pte = NULL;
+	int level = agaw_to_level(domain->agaw);
+	int offset;
+	unsigned long flags;
+
+	BUG_ON(!domain->pgd);
+
+	addr &= (((u64)1) << addr_width) - 1;
+	parent = domain->pgd;
+
+	spin_lock_irqsave(&domain->mapping_lock, flags);
+	while (level > 0) {
+		void *tmp_page;
+
+		offset = address_level_offset(addr, level);
+		pte = &parent[offset];
+		if (level == 1)
+			break;
+
+		if (!dma_pte_present(*pte)) {
+			tmp_page = alloc_pgtable_page();
+
+			if (!tmp_page) {
+				spin_unlock_irqrestore(&domain->mapping_lock, flags);
+				return NULL;
+			}
+			__iommu_flush_cache(domain->iommu, tmp_page, PAGE_SIZE_4K);
+			dma_set_pte_addr(*pte, virt_to_phys(tmp_page));
+			/*
+			 * high level table always sets r/w, last level page
+			 * table control read/write
+			 */
+			dma_set_pte_readable(*pte);
+			dma_set_pte_writable(*pte);
+			__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
+		}
+		parent = phys_to_virt(dma_pte_addr(*pte));
+		level--;
+	}
+
+	spin_unlock_irqrestore(&domain->mapping_lock, flags);
+	return pte;
+}
+
+/* return address's pte at specific level */
+static struct dma_pte *dma_addr_level_pte(struct domain *domain, u64 addr,
+		int level)
+{
+	struct dma_pte *parent, *pte = NULL;
+	int total = agaw_to_level(domain->agaw);
+	int offset;
+
+	parent = domain->pgd;
+	while (level <= total) {
+		offset = address_level_offset(addr, total);
+		pte = &parent[offset];
+		if (level == total)
+			return pte;
+
+		if (!dma_pte_present(*pte))
+			break;
+		parent = phys_to_virt(dma_pte_addr(*pte));
+		total--;
+	}
+	return NULL;
+}
+
+/* clear one page's page table */
+static void dma_pte_clear_one(struct domain *domain, u64 addr)
+{
+	struct dma_pte *pte = NULL;
+
+	/* get last level pte */
+	pte = dma_addr_level_pte(domain, addr, 1);
+
+	if (pte) {
+		dma_clear_pte(*pte);
+		__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
+	}
+}
+
+/* clear last level pte, a tlb flush should be followed */
+static void dma_pte_clear_range(struct domain *domain, u64 start, u64 end)
+{
+	int addr_width = agaw_to_width(domain->agaw);
+
+	start &= (((u64)1) << addr_width) - 1;
+	end &= (((u64)1) << addr_width) - 1;
+	/* in case it's partial page */
+	start = PAGE_ALIGN_4K(start);
+	end &= PAGE_MASK_4K;
+
+	/* we don't need lock here, nobody else touches the iova range */
+	while (start < end) {
+		dma_pte_clear_one(domain, start);
+		start += PAGE_SIZE_4K;
+	}
+}
+
+/* free page table pages. last level pte should already be cleared */
+static void dma_pte_free_pagetable(struct domain *domain, u64 start, u64 end)
+{
+	int addr_width = agaw_to_width(domain->agaw);
+	struct dma_pte *pte;
+	int total = agaw_to_level(domain->agaw);
+	int level;
+	u64 tmp;
+
+	start &= (((u64)1) << addr_width) - 1;
+	end &= (((u64)1) << addr_width) - 1;
+
+	/* we don't need lock here, nobody else touches the iova range */
+	level = 2;
+	while (level <= total) {
+		tmp = align_to_level(start, level);
+		if (tmp >= end || (tmp + level_size(level) > end))
+			return;
+
+		while (tmp < end) {
+			pte = dma_addr_level_pte(domain, tmp, level);
+			if (pte) {
+				free_pgtable_page(
+					phys_to_virt(dma_pte_addr(*pte)));
+				dma_clear_pte(*pte);
+				__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
+			}
+			tmp += level_size(level);
+		}
+		level++;
+	}
+	/* free pgd */
+	if (start == 0 && end >= ((((u64)1) << addr_width) - 1)) {
+		free_pgtable_page(domain->pgd);
+		domain->pgd = NULL;
+	}
+}
+
+/* iommu handling */
+static int iommu_alloc_root_entry(struct intel_iommu *iommu)
+{
+	struct root_entry *root;
+	unsigned long flags;
+
+	root = (struct root_entry *)alloc_pgtable_page();
+	if (!root)
+		return -ENOMEM;
+
+	__iommu_flush_cache(iommu, root, PAGE_SIZE_4K);
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	iommu->root_entry = root;
+	spin_unlock_irqrestore(&iommu->lock, flags);
+
+	return 0;
+}
+
+#define IOMMU_WAIT_OP(iommu, offset, op, cond, sts) \
+{\
+	unsigned long start_time = jiffies;\
+	while (1) {\
+		sts = op (iommu->reg, offset);\
+		if (cond)\
+			break;\
+		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))\
+			panic("DMAR hardware is malfunctional, please disable IOMMU\n");\
+		cpu_relax();\
+	}\
+}
+
+static void iommu_set_root_entry(struct intel_iommu *iommu)
+{
+	void *addr;
+	u32 cmd, sts;
+	unsigned long flag;
+
+	addr = iommu->root_entry;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writeq(iommu->reg, DMAR_RTADDR_REG, virt_to_phys(addr));
+
+	cmd = iommu->gcmd | DMA_GCMD_SRTP;
+	dmar_writel(iommu->reg, DMAR_GCMD_REG, cmd);
+
+	/* Make sure hardware complete it */
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, dmar_readl, (sts & DMA_GSTS_RTPS), sts);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+static void iommu_flush_write_buffer(struct intel_iommu *iommu)
+{
+	u32 val;
+	unsigned long flag;
+
+	if (!cap_rwbf(iommu->cap))
+		return;
+	val = iommu->gcmd | DMA_GCMD_WBF;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writel(iommu->reg, DMAR_GCMD_REG, val);
+
+	/* Make sure hardware complete it */
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, dmar_readl, (!(val & DMA_GSTS_WBFS)), val);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+/* return value determine if we need a write buffer flush */
+static int __iommu_flush_context(struct intel_iommu *iommu,
+	u16 did, u16 source_id, u8 function_mask, u64 type,
+	int non_present_entry_flush)
+{
+	u64 val = 0;
+	unsigned long flag;
+
+	/*
+	 * In the non-present entry flush case, if hardware doesn't cache
+	 * non-present entry we do nothing and if hardware cache non-present
+	 * entry, we flush entries of domain 0 (the domain id is used to cache
+	 * any non-present entries)
+	 */
+	if (non_present_entry_flush) {
+		if (!cap_caching_mode(iommu->cap))
+			return 1;
+		else
+			did = 0;
+	}
+
+	switch (type)
+	{
+	case DMA_CCMD_GLOBAL_INVL:
+		val = DMA_CCMD_GLOBAL_INVL;
+		break;
+	case DMA_CCMD_DOMAIN_INVL:
+		val = DMA_CCMD_DOMAIN_INVL|DMA_CCMD_DID(did);
+		break;
+	case DMA_CCMD_DEVICE_INVL:
+		val = DMA_CCMD_DEVICE_INVL|DMA_CCMD_DID(did)
+			|DMA_CCMD_SID(source_id)|DMA_CCMD_FM(function_mask);
+		break;
+	default:
+		BUG();
+	}
+	val |= DMA_CCMD_ICC;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writeq(iommu->reg, DMAR_CCMD_REG, val);
+
+	/* Make sure hardware complete it */
+	IOMMU_WAIT_OP(iommu, DMAR_CCMD_REG, dmar_readq, (!(val & DMA_CCMD_ICC)), val);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+	/* flush context entry will implictly flush write buffer */
+	return 0;
+}
+
+static int inline iommu_flush_context_global(struct intel_iommu *iommu,
+	int non_present_entry_flush)
+{
+	return __iommu_flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
+		non_present_entry_flush);
+}
+
+static int inline iommu_flush_context_domain(struct intel_iommu *iommu, u16 did,
+	int non_present_entry_flush)
+{
+	return __iommu_flush_context(iommu, did, 0, 0, DMA_CCMD_DOMAIN_INVL,
+		non_present_entry_flush);
+}
+
+static int inline iommu_flush_context_device(struct intel_iommu *iommu,
+	u16 did, u16 source_id, u8 function_mask, int non_present_entry_flush)
+{
+	return __iommu_flush_context(iommu, did, source_id, function_mask,
+		DMA_CCMD_DEVICE_INVL, non_present_entry_flush);
+}
+
+/* return value determine if we need a write buffer flush */
+static int __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did,
+	u64 addr, unsigned int size_order, u64 type,
+	int non_present_entry_flush)
+{
+	int tlb_offset = ecap_iotlb_offset(iommu->ecap);
+	u64 val = 0, val_iva = 0;
+	unsigned long flag;
+
+	/*
+	 * In the non-present entry flush case, if hardware doesn't cache
+	 * non-present entry we do nothing and if hardware cache non-present
+	 * entry, we flush entries of domain 0 (the domain id is used to cache
+	 * any non-present entries)
+	 */
+	if (non_present_entry_flush) {
+		if (!cap_caching_mode(iommu->cap))
+			return 1;
+		else
+			did = 0;
+	}
+
+	switch (type) {
+	case DMA_TLB_GLOBAL_FLUSH:
+		/* global flush doesn't need set IVA_REG */
+		val = DMA_TLB_GLOBAL_FLUSH|DMA_TLB_IVT;
+		break;
+	case DMA_TLB_DSI_FLUSH:
+		val = DMA_TLB_DSI_FLUSH|DMA_TLB_IVT|DMA_TLB_DID(did);
+		break;
+	case DMA_TLB_PSI_FLUSH:
+		val = DMA_TLB_PSI_FLUSH|DMA_TLB_IVT|DMA_TLB_DID(did);
+		/* Note: always flush non-leaf currently */
+		val_iva = size_order | addr;
+		break;
+	default:
+		BUG();
+	}
+	/* Note: set drain read/write */
+#if 0
+	/*
+	 * This is probably to be super secure.. Looks like we can
+	 * ignore it without any impact.
+	 */
+	if (cap_read_drain(iommu->cap))
+		val |= DMA_TLB_READ_DRAIN;
+#endif
+	if (cap_write_drain(iommu->cap))
+		val |= DMA_TLB_WRITE_DRAIN;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	/* Note: Only uses first TLB reg currently */
+	if (val_iva)
+		dmar_writeq(iommu->reg, tlb_offset, val_iva);
+	dmar_writeq(iommu->reg, tlb_offset + 8, val);
+
+	/* Make sure hardware complete it */
+	IOMMU_WAIT_OP(iommu, tlb_offset + 8, dmar_readq, (!(val & DMA_TLB_IVT)), val);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+	/* check IOTLB invalidation granularity */
+	if (DMA_TLB_IAIG(val) == 0)
+		printk(KERN_ERR"IOMMU: flush IOTLB failed\n");
+	if (DMA_TLB_IAIG(val) != DMA_TLB_IIRG(type))
+		pr_debug("IOMMU: tlb flush request %Lx, actual %Lx\n",
+			DMA_TLB_IIRG(type), DMA_TLB_IAIG(val));
+	/* flush context entry will implictly flush write buffer */
+	return 0;
+}
+
+static int inline iommu_flush_iotlb_global(struct intel_iommu *iommu,
+	int non_present_entry_flush)
+{
+	return __iommu_flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
+		non_present_entry_flush);
+}
+
+static int inline iommu_flush_iotlb_dsi(struct intel_iommu *iommu, u16 did,
+	int non_present_entry_flush)
+{
+	return __iommu_flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH,
+		non_present_entry_flush);
+}
+
+static int inline get_alignment(u64 base, unsigned int size)
+{
+	int t = 0;
+	u64 end;
+
+	end = base + size - 1;
+	while (base != end) {
+		t++;
+		base >>= 1;
+		end >>= 1;
+	}
+	return t;
+}
+
+static int inline iommu_flush_iotlb_psi(struct intel_iommu *iommu, u16 did,
+	u64 addr, unsigned int pages, int non_present_entry_flush)
+{
+	unsigned int align;
+
+	BUG_ON(addr & (~PAGE_MASK_4K));
+	BUG_ON(pages == 0);
+
+	/* Fallback to domain selective flush if no PSI support */
+	if (!cap_pgsel_inv(iommu->cap))
+		return iommu_flush_iotlb_dsi(iommu, did,
+			non_present_entry_flush);
+
+	/*
+	 * PSI requires page size is 2 ^ x, and the base address is naturally
+	 * aligned to the size
+	 */
+	align = get_alignment(addr >> PAGE_SHIFT_4K, pages);
+	/* Fallback to domain selective flush if size is too big */
+	if (align > cap_max_amask_val(iommu->cap))
+		return iommu_flush_iotlb_dsi(iommu, did,
+			non_present_entry_flush);
+
+	addr >>= PAGE_SHIFT_4K + align;
+	addr <<= PAGE_SHIFT_4K + align;
+
+	return __iommu_flush_iotlb(iommu, did, addr, align,
+		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
+}
+
+static int iommu_enable_translation(struct intel_iommu *iommu)
+{
+	u32 sts;
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writel(iommu->reg, DMAR_GCMD_REG, iommu->gcmd|DMA_GCMD_TE);
+
+	/* Make sure hardware complete it */
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, dmar_readl, (sts & DMA_GSTS_TES), sts);
+
+	iommu->gcmd |= DMA_GCMD_TE;
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	return 0;
+}
+
+static int iommu_disable_translation(struct intel_iommu *iommu)
+{
+	u32 sts;
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	iommu->gcmd &= ~ DMA_GCMD_TE;
+	dmar_writel(iommu->reg, DMAR_GCMD_REG, iommu->gcmd);
+
+	/* Make sure hardware complete it */
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG, dmar_readl, (!(sts & DMA_GSTS_TES)), sts);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	return 0;
+}
+
+static int iommu_init_domains(struct intel_iommu *iommu)
+{
+	unsigned long ndomains;
+	unsigned long nlongs;
+
+	ndomains = cap_ndoms(iommu->cap);
+	pr_debug("Number of Domains supportd <%ld>\n", ndomains);
+	nlongs = BITS_TO_LONGS(ndomains);
+
+	/* TBD: there might be 64K domains, consider other allocation for future chip */
+	iommu->domain_ids = kcalloc(nlongs, sizeof(unsigned long), GFP_KERNEL);
+	if (!iommu->domain_ids) {
+		printk(KERN_ERR "Allocating domain id array failed\n");
+		return -ENOMEM;
+	}
+	iommu->domains = kcalloc(ndomains, sizeof(struct domain *), GFP_KERNEL);
+	if (!iommu->domains) {
+		printk(KERN_ERR "Allocating domain array failed\n");
+		kfree(iommu->domain_ids);
+		return -ENOMEM;
+	}
+
+	/*
+	 * if Caching mode is set, then invalid translations are tagged
+	 * with domainid 0. Hence we need to pre-allocate it.
+	 */
+	if (cap_caching_mode(iommu->cap))
+		set_bit(0, iommu->domain_ids);
+	return 0;
+}
+
+static struct intel_iommu *alloc_iommu(struct dmar_drhd_unit *drhd)
+{
+	struct intel_iommu *iommu;
+	int ret;
+	int map_size;
+	u32 ver;
+
+	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
+	if (!iommu)
+		return NULL;
+	iommu->reg = ioremap(drhd->reg_base_addr, PAGE_SIZE_4K);
+	if (!iommu->reg) {
+		printk(KERN_ERR "IOMMU: can't map the region\n");
+		goto error;
+	}
+	iommu->cap = dmar_readq(iommu->reg, DMAR_CAP_REG);
+	iommu->ecap = dmar_readq(iommu->reg, DMAR_ECAP_REG);
+
+	/* the registers might be more than one page */
+	map_size = max_t(int, ecap_max_iotlb_offset(iommu->ecap),
+		cap_max_fault_reg_offset(iommu->cap));
+	map_size = PAGE_ALIGN_4K(map_size);
+	if (map_size > PAGE_SIZE_4K) {
+		iounmap(iommu->reg);
+		iommu->reg = ioremap(drhd->reg_base_addr, map_size);
+		if (!iommu->reg) {
+			printk(KERN_ERR "IOMMU: can't map the region\n");
+			goto error;
+		}
+	}
+
+	ver = dmar_readl(iommu->reg, DMAR_VER_REG);
+	pr_debug("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
+		drhd->reg_base_addr, VER_MAJOR(ver), VER_MINOR(ver),
+		iommu->cap, iommu->ecap);
+	ret = iommu_init_domains(iommu);
+	if (ret)
+		goto error_unmap;
+	spin_lock_init(&iommu->lock);
+	spin_lock_init(&iommu->register_lock);
+
+	drhd->iommu = iommu;
+	return iommu;
+error_unmap:
+	iounmap(iommu->reg);
+	iommu->reg = 0;
+error:
+	kfree(iommu);
+	return NULL;
+}
+
+#define iommu_for_each_domain_id(iommu, i) \
+for (i = find_first_bit(iommu->domain_ids, cap_ndoms(iommu->cap)); \
+	i < cap_ndoms(iommu->cap); \
+	i = find_next_bit(iommu->domain_ids, cap_ndoms(iommu->cap), i+1))
+static void domain_exit(struct domain *domain);
+static void free_iommu(struct intel_iommu *iommu)
+{
+	struct domain *domain;
+	int i;
+
+	if (!iommu)
+		return;
+
+	iommu_for_each_domain_id(iommu, i) {
+		domain = iommu->domains[i];
+		clear_bit(i, iommu->domain_ids);
+		domain_exit(domain);
+	}
+
+	if (iommu->gcmd & DMA_GCMD_TE)
+		iommu_disable_translation(iommu);
+
+	if (iommu->irq) {
+		set_irq_data(iommu->irq, NULL);
+		/* This will mask the irq */
+		free_irq(iommu->irq, iommu);
+		destroy_irq(iommu->irq);
+	}
+
+	kfree(iommu->domains);
+	kfree(iommu->domain_ids);
+
+	/* free context mapping */
+	free_context_table(iommu);
+
+	if (iommu->reg)
+		iounmap(iommu->reg);
+	kfree(iommu);
+}
+
+static struct domain * iommu_alloc_domain(struct intel_iommu *iommu)
+{
+	unsigned long num;
+	unsigned long ndomains;
+	struct domain *domain;
+	unsigned long flags;
+
+	domain = alloc_domain_mem();
+	if (!domain)
+		return NULL;
+
+	ndomains = cap_ndoms(iommu->cap);
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	num = find_first_zero_bit(iommu->domain_ids, ndomains);
+	if (num >= ndomains) {
+		spin_unlock_irqrestore(&iommu->lock, flags);
+		free_domain_mem(domain);
+		printk(KERN_ERR "IOMMU: no free domain ids\n");
+		return NULL;
+	}
+
+	set_bit(num, iommu->domain_ids);
+	domain->id = num;
+	domain->iommu = iommu;
+	iommu->domains[num] = domain;
+	spin_unlock_irqrestore(&iommu->lock, flags);
+
+	return domain;
+}
+
+static void iommu_free_domain(struct domain *domain)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&domain->iommu->lock, flags);
+	clear_bit(domain->id, domain->iommu->domain_ids);
+	spin_unlock_irqrestore(&domain->iommu->lock, flags);
+}
+
+static struct iova_domain reserved_iova_list;
+#ifdef DEBUG
+static void print_iova_list(struct iova_domain *head)
+{
+	struct rb_node *node = rb_first(&head->rbroot);
+	struct iova *iova;
+
+	while (node) {
+		iova = container_of(node, struct iova, node);
+
+		pr_debug("Start %lx, end %lx\n",
+			iova->pfn_lo, iova->pfn_hi);
+		node = rb_next(node);
+	}
+}
+#endif
+
+static void dmar_init_reserved_ranges(void)
+{
+	struct pci_dev *pdev = NULL;
+	struct iova *iova;
+	int i;
+	u64 addr, size;
+
+	init_iova_domain(&reserved_iova_list);
+
+	/* IOAPIC ranges shouldn't be accessed by DMA */
+	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
+		IOVA_PFN(IOAPIC_RANGE_END));
+	if (!iova)
+		printk(KERN_ERR "Reserve IOAPIC range failed\n");
+
+	/* Reserve all PCI MMIO to avoid peer-to-peer access */
+	for_each_pci_dev(pdev) {
+		struct resource *r;
+
+		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+			r = &pdev->resource[i];
+			if (!r->flags || !(r->flags & IORESOURCE_MEM))
+				continue;
+			addr = r->start;
+			addr &= PAGE_MASK_4K;
+			size = r->end - addr;
+			size = PAGE_ALIGN_4K(size);
+			iova = reserve_iova(&reserved_iova_list, IOVA_PFN(addr),
+				IOVA_PFN(size + addr) - 1);
+			if (!iova)
+				printk(KERN_ERR "Reserve iova failed\n");
+		}
+	}
+
+#ifdef DEBUG
+	pr_debug("System reserved iova ranges:\n");
+	print_iova_list(&reserved_iova_list);
+#endif
+}
+
+static void domain_reserve_special_ranges(struct domain *domain)
+{
+	copy_reserved_iova(&reserved_iova_list, &domain->iovad);
+}
+
+static inline int guestwidth_to_adjustwidth(int gaw)
+{
+	int agaw;
+	int r = (gaw - 12) % 9;
+
+	if (r == 0)
+		agaw = gaw;
+	else
+		agaw = gaw + 9 - r;
+	if (agaw > 64)
+		agaw = 64;
+	return agaw;
+}
+
+static int domain_init(struct domain *domain, int guest_width)
+{
+	struct intel_iommu *iommu;
+	int adjust_width, agaw;
+	unsigned long sagaw;
+
+	init_iova_domain(&domain->iovad);
+	spin_lock_init(&domain->mapping_lock);
+
+	domain_reserve_special_ranges(domain);
+
+	/* calculate AGAW */
+	iommu = domain->iommu;
+	if (guest_width > cap_mgaw(iommu->cap))
+		guest_width = cap_mgaw(iommu->cap);
+	domain->gaw = guest_width;
+	adjust_width = guestwidth_to_adjustwidth(guest_width);
+	agaw = width_to_agaw(adjust_width);
+	sagaw = cap_sagaw(iommu->cap);
+	if (!test_bit(agaw, &sagaw)) {
+		/* hardware doesn't support it, choose a bigger one */
+		pr_debug("IOMMU: hardware doesn't support agaw %d\n", agaw);
+		agaw = find_next_bit(&sagaw, 5, agaw);
+		if (agaw >= 5)
+			return -ENODEV;
+	}
+	domain->agaw = agaw;
+	INIT_LIST_HEAD(&domain->devices);
+
+	/* always allocate the top pgd */
+	domain->pgd = (struct dma_pte *)alloc_pgtable_page();
+	if (!domain->pgd)
+		return -ENOMEM;
+	__iommu_flush_cache(iommu, domain->pgd, PAGE_SIZE_4K);
+	return 0;
+}
+
+
+static void domain_exit(struct domain *domain)
+{
+	u64 end;
+
+	/* Domain 0 is reserved, so dont process it */
+	if (!domain)
+		return;
+
+	domain_remove_dev_info(domain);
+	/* destroy iovas */
+	put_iova_domain(&domain->iovad);
+	end = DOMAIN_MAX_ADDR(domain->gaw);
+	end = end & (~PAGE_MASK_4K);
+
+	/* clear ptes */
+	dma_pte_clear_range(domain, 0, end);
+
+	/* free page tables */
+	dma_pte_free_pagetable(domain, 0, end);
+
+	iommu_free_domain(domain);
+	free_domain_mem(domain);
+}
+
+static int domain_context_mapping_one(struct domain *domain, u8 bus, u8 devfn)
+{
+	struct context_entry *context;
+	struct intel_iommu *iommu = domain->iommu;
+	unsigned long flags;
+
+	pr_debug("Set context mapping for %02x:%02x.%d\n", bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
+	BUG_ON(!domain->pgd);
+	context = device_to_context_entry(iommu, bus, devfn);
+	if (!context)
+		return -ENOMEM;
+	spin_lock_irqsave(&iommu->lock, flags);
+	if (context_present(*context)) {
+		spin_unlock_irqrestore(&iommu->lock, flags);
+		return 0;
+	}
+
+	context_set_domain_id(*context, domain->id);
+	context_set_address_width(*context, domain->agaw);
+	context_set_address_root(*context, virt_to_phys(domain->pgd));
+	context_set_translation_type(*context, CONTEXT_TT_MULTI_LEVEL);
+	context_set_fault_enable(*context);
+	context_set_present(*context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
+
+	/* it's a non-present to present mapping */
+	if (iommu_flush_context_device(iommu, domain->id,
+			(((u16)bus) << 8) | devfn, DMA_CCMD_MASK_NOBIT, 1))
+		iommu_flush_write_buffer(iommu);
+	else
+		iommu_flush_iotlb_dsi(iommu, 0, 0);
+	spin_unlock_irqrestore(&iommu->lock, flags);
+	return 0;
+}
+
+static int
+domain_context_mapping(struct domain *domain, struct pci_dev *pdev)
+{
+	int ret;
+	struct pci_dev *tmp, *parent;
+
+	ret = domain_context_mapping_one(domain, pdev->bus->number,
+		pdev->devfn);
+	if (ret)
+		return ret;
+
+	/* dependent device mapping */
+	tmp = pci_find_upstream_pcie_bridge(pdev);
+	if (!tmp)
+		return 0;
+	/* Secondary interface's bus number and devfn 0 */
+	parent = pdev->bus->self;
+	while (parent != tmp) {
+		ret = domain_context_mapping_one(domain, parent->bus->number,
+			parent->devfn);
+		if (ret)
+			return ret;
+		parent = parent->bus->self;
+	}
+	if (tmp->is_pcie) /* this is a PCIE-to-PCI bridge */
+		return domain_context_mapping_one(domain,
+			tmp->subordinate->number, 0);
+	else /* this is a legacy PCI bridge */
+		return domain_context_mapping_one(domain,
+			tmp->bus->number, tmp->devfn);
+}
+
+static int domain_context_mapped(struct domain *domain, struct pci_dev *pdev)
+{
+	int ret;
+	struct pci_dev *tmp, *parent;
+
+	ret = device_context_mapped(domain->iommu, pdev->bus->number, pdev->devfn);
+	if (!ret)
+		return ret;
+	/* dependent device mapping */
+	tmp = pci_find_upstream_pcie_bridge(pdev);
+	if (!tmp)
+		return ret;
+	/* Secondary interface's bus number and devfn 0 */
+	parent = pdev->bus->self;
+	while (parent != tmp) {
+		ret = device_context_mapped(domain->iommu, parent->bus->number,
+			parent->devfn);
+		if (!ret)
+			return ret;
+		parent = parent->bus->self;
+	}
+	if (tmp->is_pcie)
+		return device_context_mapped(domain->iommu,
+			tmp->subordinate->number, 0);
+	else
+		return device_context_mapped(domain->iommu,
+			tmp->bus->number, tmp->devfn);
+}
+
+static int
+domain_page_mapping(struct domain *domain, dma_addr_t iova,
+			u64 hpa, size_t size, int prot)
+{
+	u64 start_pfn, end_pfn;
+	struct dma_pte *pte;
+	int index;
+
+	if ((prot & (DMA_PTE_READ|DMA_PTE_WRITE)) == 0)
+		return -EINVAL;
+	iova &= PAGE_MASK_4K;
+	start_pfn = ((u64)hpa) >> PAGE_SHIFT_4K;
+	end_pfn = (PAGE_ALIGN_4K(((u64)hpa) + size)) >> PAGE_SHIFT_4K;
+	index = 0;
+	while (start_pfn < end_pfn) {
+		pte = addr_to_dma_pte(domain, iova + PAGE_SIZE_4K * index);
+		if (!pte)
+			return -ENOMEM;
+		/* we don't need lock here, nobody else touches the iova range */
+		BUG_ON(dma_pte_addr(*pte));
+		dma_set_pte_addr(*pte, start_pfn << PAGE_SHIFT_4K);
+		dma_set_pte_prot(*pte, prot);
+		__iommu_flush_cache(domain->iommu, pte, sizeof(*pte));
+		start_pfn++;
+		index++;
+	}
+	return 0;
+}
+
+
+static void detach_domain_for_dev(struct domain *domain, u8 bus, u8 devfn)
+{
+	clear_context_table(domain->iommu, bus, devfn);
+	iommu_flush_context_global(domain->iommu, 0);
+	iommu_flush_iotlb_global(domain->iommu, 0);
+}
+
+static void domain_remove_dev_info(struct domain *domain)
+{
+	struct device_domain_info *info;
+	unsigned long flags;
+
+	spin_lock_irqsave(&device_domain_lock, flags);
+	while (!list_empty(&domain->devices)) {
+		info = list_entry(domain->devices.next,
+			struct device_domain_info, link);
+		list_del(&info->link);
+		list_del(&info->global);
+		if (info->dev)
+			info->dev->sysdata = NULL;
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+
+		detach_domain_for_dev(info->domain, info->bus, info->devfn);
+		free_devinfo_mem(info);
+
+		spin_lock_irqsave(&device_domain_lock, flags);
+	}
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+}
+
+/*
+ * find_domain
+ * Note: we use struct pci_dev->sysdata stores the info
+ */
+struct domain *
+find_domain(struct pci_dev *pdev)
+{
+	struct device_domain_info *info;
+
+	/* No lock here, assumes no domain exit in normal case */
+	info = (struct device_domain_info *)pdev->sysdata;
+	if (info)
+		return info->domain;
+	return NULL;
+}
+
+static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
+			     struct pci_dev *dev)
+{
+	int index;
+
+	while (dev) {
+		for (index = 0; index < cnt; index ++)
+			if (dev == devices[index])
+				return 1;
+
+		/* Check our parent */
+		dev = dev->bus->self;
+	}
+
+	return 0;
+}
+
+static struct dmar_drhd_unit *
+dmar_find_matched_drhd_unit(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd = NULL;
+
+	list_for_each_entry(drhd, &dmar_drhd_units, list) {
+		if (drhd->include_all || dmar_pci_device_match(drhd->devices,
+						drhd->devices_cnt, dev))
+			return drhd;
+	}
+
+	return NULL;
+}
+
+
+/* domain is initialized */
+static struct domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
+{
+	struct domain *domain, *found = NULL;
+	struct intel_iommu *iommu;
+	struct dmar_drhd_unit *drhd;
+	struct device_domain_info *info, *tmp;
+	struct pci_dev *dev_tmp;
+	unsigned long flags;
+	int bus = 0, devfn = 0;
+
+	domain = find_domain(pdev);
+	if (domain)
+		return domain;
+
+	dev_tmp = pci_find_upstream_pcie_bridge(pdev);
+	if (dev_tmp) {
+		if (dev_tmp->is_pcie) {
+			bus = dev_tmp->subordinate->number;
+			devfn = 0;
+		} else {
+			bus = dev_tmp->bus->number;
+			devfn = dev_tmp->devfn;
+		}
+		spin_lock_irqsave(&device_domain_lock, flags);
+		list_for_each_entry(info, &device_domain_list, global) {
+			if (info->bus == bus && info->devfn == devfn) {
+				found = info->domain;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		/* pcie-pci bridge already has a domain, uses it */
+		if (found) {
+			domain = found;
+			goto found_domain;
+		}
+	}
+
+	/* Allocate new domain for the device */
+	drhd = dmar_find_matched_drhd_unit(pdev);
+	if (!drhd) {
+		printk(KERN_ERR "IOMMU: can't find DMAR for device %s\n",
+			pci_name(pdev));
+		return NULL;
+	}
+	iommu = drhd->iommu;
+
+	domain = iommu_alloc_domain(iommu);
+	if (!domain)
+		goto error;
+
+	if (domain_init(domain, gaw)) {
+		domain_exit(domain);
+		goto error;
+	}
+
+	/* register pcie-to-pci device */
+	if (dev_tmp) {
+		info = alloc_devinfo_mem();
+		if (!info) {
+			domain_exit(domain);
+			goto error;
+		}
+		info->bus = bus;
+		info->devfn = devfn;
+		info->dev = NULL;
+		info->domain = domain;
+		/* This domain is shared by devices under p2p bridge */
+		domain->flags |= DOMAIN_FLAG_MULTIPLE_DEVICES;
+
+		/* pcie-to-pci bridge already has a domain, uses it */
+		found = NULL;
+		spin_lock_irqsave(&device_domain_lock, flags);
+		list_for_each_entry(tmp, &device_domain_list, global) {
+			if (tmp->bus == bus && tmp->devfn == devfn) {
+				found = tmp->domain;
+				break;
+			}
+		}
+		if (found) {
+			free_devinfo_mem(info);
+			domain_exit(domain);
+			domain = found;
+		} else {
+			list_add(&info->link, &domain->devices);
+			list_add(&info->global, &device_domain_list);
+		}
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+	}
+
+found_domain:
+	info = alloc_devinfo_mem();
+	if (!info)
+		goto error;
+	info->bus = pdev->bus->number;
+	info->devfn = pdev->devfn;
+	info->dev = pdev;
+	info->domain = domain;
+	spin_lock_irqsave(&device_domain_lock, flags);
+	/* somebody is fast */
+	if ((found = find_domain(pdev)) != NULL) {
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		if (found != domain) {
+			domain_exit(domain);
+			domain = found;
+		}
+		free_devinfo_mem(info);
+		return domain;
+	}
+	list_add(&info->link, &domain->devices);
+	list_add(&info->global, &device_domain_list);
+	pdev->sysdata = info;
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+	return domain;
+error:
+	/* recheck it here, maybe others set it */
+	return find_domain(pdev);
+}
+
+static int iommu_prepare_identity_map(struct pci_dev *pdev, u64 start, u64 end)
+{
+	struct domain *domain;
+	unsigned long size;
+	u64 base;
+	int ret;
+
+	printk(KERN_INFO
+		"IOMMU: Setting identity map for device %s [0x%Lx - 0x%Lx]\n",
+		pci_name(pdev), start, end);
+	/* page table init */
+	domain = get_domain_for_dev(pdev, DEFAULT_DOMAIN_ADDRESS_WIDTH);
+	if (!domain)
+		return -ENOMEM;
+
+	/* The address might not be aligned */
+	base = start & PAGE_MASK_4K;
+	size = end - base;
+	size = PAGE_ALIGN_4K(size);
+	if (!reserve_iova(&domain->iovad, IOVA_PFN(base),
+			IOVA_PFN(base + size) - 1)) {
+		printk(KERN_ERR "IOMMU: reserve iova failed\n");
+		ret = -ENOMEM;
+		goto error;
+	}
+
+	pr_debug("Mapping reserved region %lx@%llx for %s\n",
+		size, base, pci_name(pdev));
+	/*
+	 * RMRR range might have overlap with physical memory range,
+	 * clear it first
+	 */
+	dma_pte_clear_range(domain, base, base + size);
+
+	ret = domain_page_mapping(domain, base, base, size,
+		DMA_PTE_READ|DMA_PTE_WRITE);
+	if (ret)
+		goto error;
+
+	/* context entry init */
+	ret = domain_context_mapping(domain, pdev);
+	if (!ret)
+		return 0;
+error:
+	domain_exit(domain);
+	return ret;
+
+}
+
+static inline int iommu_prepare_rmrr_dev(struct dmar_rmrr_unit *rmrr,
+	struct pci_dev *pdev)
+{
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return 0;
+	return iommu_prepare_identity_map(pdev, rmrr->base_address,
+		rmrr->end_address + 1);
+}
+
+int __init init_dmars(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct dmar_rmrr_unit *rmrr;
+	struct pci_dev *pdev;
+	struct intel_iommu *iommu;
+	int ret, unit = 0;
+
+	/*
+	 * for each drhd
+	 *    allocate root
+	 *    initialize and program root entry to not present
+	 * endfor
+	 */
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		iommu = alloc_iommu(drhd);
+		if (!iommu) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		/*
+		 * TBD:
+		 * we could share the same root & context tables
+		 * amoung all IOMMU's. Need to Split it later.
+		 */
+		ret = iommu_alloc_root_entry(iommu);
+		if (ret) {
+			printk(KERN_ERR "IOMMU: allocate root entry failed\n");
+			goto error;
+		}
+	}
+
+	/*
+	 * For each rmrr
+	 *   for each dev attached to rmrr
+	 *   do
+	 *     locate drhd for dev, alloc domain for dev
+	 *     allocate free domain
+	 *     allocate page table entries for rmrr
+	 *     if context not allocated for bus
+	 *           allocate and init context
+	 *           set present in root table for this bus
+	 *     init context with domain, translation etc
+	 *    endfor
+	 * endfor
+	 */
+	begin_for_each_rmrr_device(rmrr, pdev)
+		ret = iommu_prepare_rmrr_dev(rmrr, pdev);
+		if (ret)
+			printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
+	end_for_each_rmrr_device(rmrr, pdev)
+
+	/*
+	 * for each drhd
+	 *   enable fault log
+	 *   global invalidate context cache
+	 *   global invalidate iotlb
+	 *   enable translation
+	 */
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		iommu = drhd->iommu;
+		sprintf (iommu->name, "dmar%d", unit++);
+
+		iommu_flush_write_buffer(iommu);
+
+		iommu_set_root_entry(iommu);
+
+		iommu_flush_context_global(iommu, 0);
+		iommu_flush_iotlb_global(iommu, 0);
+
+		ret = iommu_enable_translation(iommu);
+		if (ret)
+			goto error;
+	}
+
+	return 0;
+error:
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+		iommu = drhd->iommu;
+		free_iommu(iommu);
+	}
+	return ret;
+}
+
+#define aligned_size(host_addr, size) \
+	PAGE_ALIGN_4K((host_addr & (~PAGE_MASK_4K)) + size)
+struct iova *
+iommu_alloc_iova(struct domain *domain, void *host_addr, size_t size,
+		u64 start, u64 end)
+{
+	u64 start_addr;
+	struct iova *piova;
+
+	/* Make sure it's in range */
+	if ((start > DOMAIN_MAX_ADDR(domain->gaw)) || end < start)
+		return NULL;
+
+	end = min_t(u64, DOMAIN_MAX_ADDR(domain->gaw), end);
+	start_addr = PAGE_ALIGN_4K(start);
+	size = aligned_size((u64)host_addr, size);
+	if (!size || (start_addr + size > end))
+		return NULL;
+
+	piova = alloc_iova(&domain->iovad, size >> PAGE_SHIFT_4K, IOVA_PFN(end));
+
+	return piova;
+}
+
+
+/* iotlb */
+static dma_addr_t __intel_map_single(struct device *dev, void *addr,
+	size_t size, int dir, u64 *flush_addr, unsigned int *flush_size)
+{
+	struct domain *domain;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	int ret;
+	int prot = 0;
+	struct iova *iova = NULL;
+	u64 start_addr;
+
+	addr = (void *)virt_to_phys(addr);
+
+	domain = get_domain_for_dev(pdev,
+			DEFAULT_DOMAIN_ADDRESS_WIDTH);
+	if (!domain) {
+		printk(KERN_ERR"Allocating domain for %s failed", pci_name(pdev));
+		return 0;
+	}
+
+	start_addr = IOVA_START_ADDR;
+
+	if (pdev->dma_mask <= DMA_32BIT_MASK) {
+		iova = iommu_alloc_iova(domain, addr, size, start_addr,
+			pdev->dma_mask);
+	} else  {
+		/*
+		 * First try to allocate an io virtual address in
+		 * DMA_32BIT_MASK and if that fails then try allocating
+		 * from higer range
+		 */
+		iova = iommu_alloc_iova(domain, addr, size, start_addr,
+			DMA_32BIT_MASK);
+		if (!iova)
+			iova = iommu_alloc_iova(domain, addr, size, start_addr,
+			pdev->dma_mask);
+	}
+
+	if (!iova) {
+		printk(KERN_ERR"Allocating iova for %s failed", pci_name(pdev));
+		return 0;
+	}
+
+	/* make sure context mapping is ok */
+	if (unlikely(!domain_context_mapped(domain, pdev))) {
+		ret = domain_context_mapping(domain, pdev);
+		if (ret)
+			goto error;
+	}
+
+	/*
+	 * Check if DMAR supports zero-length reads on write only
+	 * mappings..
+	 */
+	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL || \
+			!cap_zlr(domain->iommu->cap))
+		prot |= DMA_PTE_READ;
+	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
+		prot |= DMA_PTE_WRITE;
+	/*
+	 * addr - (addr + size) might be partial page, we should map the whole
+	 * page.  Note: if two part of one page are separately mapped, we
+	 * might have two guest_addr mapping to the same host addr, but this
+	 * is not a big problem
+	 */
+	ret = domain_page_mapping(domain, iova->pfn_lo << PAGE_SHIFT_4K,
+		((u64)addr) & PAGE_MASK_4K,
+		(iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K, prot);
+	if (ret)
+		goto error;
+
+	pr_debug("Device %s request: %lx@%llx mapping: %lx@%llx, dir %d\n",
+		pci_name(pdev), size, (u64)addr,
+		(iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K,
+		(u64)(iova->pfn_lo << PAGE_SHIFT_4K), dir);
+
+	*flush_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	*flush_size = (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K;
+	return (iova->pfn_lo << PAGE_SHIFT_4K) + ((u64)addr & (~PAGE_MASK_4K));
+error:
+	__free_iova(&domain->iovad, iova);
+	printk(KERN_ERR"Device %s request: %lx@%llx dir %d --- failed\n",
+		pci_name(pdev), size, (u64)addr, dir);
+	return 0;
+}
+
+static dma_addr_t intel_map_single(struct device *hwdev, void *addr,
+	size_t size, int dir)
+{
+	struct pci_dev *pdev = to_pci_dev(hwdev);
+	dma_addr_t ret;
+	struct domain *domain;
+	u64 flush_addr;
+	unsigned int flush_size;
+
+	BUG_ON(dir == DMA_NONE);
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return virt_to_bus(addr);
+
+	ret = __intel_map_single(hwdev, addr, size, dir, &flush_addr, &flush_size);
+	if (ret) {
+		domain = find_domain(pdev);
+		/* it's a non-present to present mapping */
+		if (iommu_flush_iotlb_psi(domain->iommu, domain->id,
+				flush_addr, flush_size >> PAGE_SHIFT_4K, 1))
+			iommu_flush_write_buffer(domain->iommu);
+	}
+	return ret;
+}
+
+static void __intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
+	size_t size, int dir, u64 *flush_addr, unsigned int *flush_size)
+{
+	struct domain *domain;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct iova *iova;
+
+	domain = find_domain(pdev);
+	BUG_ON(!domain);
+
+	iova = find_iova(&domain->iovad, IOVA_PFN(dev_addr));
+	if (!iova) {
+		*flush_size = 0;
+		return;
+	}
+	pr_debug("Device %s unmapping: %lx@%llx\n",
+		pci_name(pdev), (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K,
+		(u64)(iova->pfn_lo << PAGE_SHIFT_4K));
+
+	*flush_addr = iova->pfn_lo << PAGE_SHIFT_4K;
+	*flush_size = (iova->pfn_hi - iova->pfn_lo + 1) << PAGE_SHIFT_4K;
+	/*  clear the whole page, not just dev_addr - (dev_addr + size) */
+	dma_pte_clear_range(domain, *flush_addr, *flush_addr + *flush_size);
+	/* free page tables */
+	dma_pte_free_pagetable(domain, *flush_addr, *flush_addr + *flush_size);
+	/* free iova */
+	__free_iova(&domain->iovad, iova);
+}
+
+static void intel_unmap_single(struct device *dev, dma_addr_t dev_addr,
+	size_t size, int dir)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct domain *domain;
+	u64 flush_addr;
+	unsigned int flush_size;
+
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return;
+
+	domain = find_domain(pdev);
+	__intel_unmap_single(dev, dev_addr, size, dir, &flush_addr, &flush_size);
+	if (flush_size == 0)
+		return;
+	if (iommu_flush_iotlb_psi(domain->iommu, domain->id, flush_addr,
+			flush_size >> PAGE_SHIFT_4K, 0))
+		iommu_flush_write_buffer(domain->iommu);
+}
+
+static void * intel_alloc_coherent(struct device *hwdev, size_t size,
+		       dma_addr_t *dma_handle, gfp_t flags)
+{
+	void *vaddr;
+	int order;
+
+	size = PAGE_ALIGN_4K(size);
+	order = get_order(size);
+	flags &= ~(GFP_DMA | GFP_DMA32);
+
+	vaddr = (void *)__get_free_pages(flags, order);
+	if (!vaddr)
+		return NULL;
+	memset(vaddr, 0, size);
+
+	*dma_handle = intel_map_single(hwdev, vaddr, size, DMA_BIDIRECTIONAL);
+	if (*dma_handle)
+		return vaddr;
+	free_pages((unsigned long)vaddr, order);
+	return NULL;
+}
+
+static void intel_free_coherent(struct device *hwdev, size_t size,
+	void *vaddr, dma_addr_t dma_handle)
+{
+	int order;
+
+	size = PAGE_ALIGN_4K(size);
+	order = get_order(size);
+
+	intel_unmap_single(hwdev, dma_handle, size, DMA_BIDIRECTIONAL);
+	free_pages((unsigned long)vaddr, order);
+}
+
+static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sg,
+	int nelems, int dir)
+{
+	int i;
+	struct pci_dev *pdev = to_pci_dev(hwdev);
+	struct domain *domain;
+	u64 flush_addr;
+	unsigned int flush_size;
+
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return;
+
+	domain = find_domain(pdev);
+	for (i = 0; i < nelems; i++, sg++)
+		__intel_unmap_single(hwdev, sg->dma_address,
+			sg->dma_length, dir, &flush_addr, &flush_size);
+
+	if (iommu_flush_iotlb_dsi(domain->iommu, domain->id, 0))
+		iommu_flush_write_buffer(domain->iommu);
+}
+
+#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
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
+static int intel_map_sg(struct device *hwdev, struct scatterlist *sg,
+	int nelems, int dir)
+{
+	void *addr;
+	int i;
+	dma_addr_t dma_handle;
+	struct pci_dev *pdev = to_pci_dev(hwdev);
+	struct domain *domain;
+	u64 flush_addr;
+	unsigned int flush_size;
+
+	BUG_ON(dir == DMA_NONE);
+	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
+
+	for (i = 0; i < nelems; i++, sg++) {
+		addr = SG_ENT_VIRT_ADDRESS(sg);
+		dma_handle = __intel_map_single(hwdev, addr,
+				sg->length, dir, &flush_addr, &flush_size);
+		if (!dma_handle) {
+			intel_unmap_sg(hwdev, sg - i, i, dir);
+			sg[0].dma_length = 0;
+			return 0;
+		}
+		sg->dma_address = dma_handle;
+		sg->dma_length = sg->length;
+	}
+
+	domain = find_domain(pdev);
+
+	/* it's a non-present to present mapping */
+	if (iommu_flush_iotlb_dsi(domain->iommu, domain->id, 1))
+		iommu_flush_write_buffer(domain->iommu);
+	return nelems;
+}
+
+struct dma_mapping_ops intel_dma_ops = {
+	.alloc_coherent = intel_alloc_coherent,
+	.free_coherent = intel_free_coherent,
+	.map_single = intel_map_single,
+	.unmap_single = intel_unmap_single,
+	.map_sg = intel_map_sg,
+	.unmap_sg = intel_unmap_sg,
+};
+
+void *iommu_rpool_alloc(unsigned int size, gfp_t flag)
+{
+	if (size == PAGE_SIZE_4K)
+		return(void *)get_zeroed_page(flag);
+	else
+		return kzalloc(size, flag);
+}
+
+void iommu_rpool_free(void *pobj, unsigned int size)
+{
+	if (size == PAGE_SIZE_4K)
+		free_page((unsigned long)pobj);
+	else
+		kfree(pobj);
+}
+
+static inline int
+iommu_pgtable_pool_init(void)
+{
+
+	return init_resource_pool(&iommu_pgtable_pool, MIN_PGTABLE_PAGES,
+		PAGE_SIZE_4K, GROW_PGTABLE_PAGES, iommu_rpool_alloc,
+		iommu_rpool_free);
+}
+
+static inline int
+iommu_domain_pool_init(void)
+{
+	return init_resource_pool(&iommu_domain_pool, MIN_DOMAIN_REQ,
+		sizeof(struct domain), GROW_DOMAIN_REQ, iommu_rpool_alloc,
+		iommu_rpool_free);
+}
+
+static inline int
+iommu_devinfo_pool_init(void)
+{
+	return init_resource_pool(&iommu_devinfo_pool, MIN_DEVINFO_REQ,
+		sizeof(struct device_domain_info),
+		GROW_DEVINFO_REQ, iommu_rpool_alloc,
+		iommu_rpool_free);
+}
+
+static inline int
+iommu_iova_pool_init(void)
+{
+	return init_resource_pool(&iommu_iova_pool, MIN_IOVA_REQ,
+		sizeof(struct iova),
+		GROW_IOVA_REQ, iommu_rpool_alloc, iommu_rpool_free);
+}
+
+static int iommu_init_mempool(void)
+{
+	int ret;
+	ret = iommu_iova_pool_init();
+	if (ret)
+		return ret;
+
+	ret = iommu_pgtable_pool_init();
+	if (ret)
+		goto pgtable_error;
+
+	ret = iommu_domain_pool_init();
+	if (ret)
+		goto domain_error;
+
+	ret = iommu_devinfo_pool_init();
+	if (!ret)
+		return ret;
+
+	destroy_resource_pool(&iommu_domain_pool);
+domain_error:
+	destroy_resource_pool(&iommu_pgtable_pool);
+pgtable_error:
+	destroy_resource_pool(&iommu_iova_pool);
+
+	return -ENOMEM;
+}
+
+static void iommu_exit_mempool(void)
+{
+	destroy_resource_pool(&iommu_devinfo_pool);
+	destroy_resource_pool(&iommu_domain_pool);
+	destroy_resource_pool(&iommu_pgtable_pool);
+	destroy_resource_pool(&iommu_iova_pool);
+}
+
+void __init detect_intel_iommu(void)
+{
+	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
+		return;
+	if (early_dmar_detect()) {
+		iommu_detected = 1;
+	}
+}
+
+static void __init init_no_remapping_devices(void)
+{
+	struct dmar_drhd_unit *drhd;
+
+	for_each_drhd_unit(drhd)
+		if (!drhd->include_all) {
+			int i;
+			for (i=0; i < drhd->devices_cnt; i++)
+				if (drhd->devices[i] != NULL)
+					break;
+			/* ignore DMAR unit if no pci devices exist */
+			if (i == drhd->devices_cnt)
+				drhd->ignored = 1;
+		}
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
+
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
+int __init intel_iommu_init(void)
+{
+	int ret = 0;
+
+	if (no_iommu || swiotlb || dmar_disabled)
+		return -ENODEV;
+
+	if (dmar_table_init())
+		return 	-ENODEV;
+
+	iommu_init_mempool();
+	dmar_init_reserved_ranges();
+
+	init_no_remapping_devices();
+
+	ret = init_dmars();
+	if (ret) {
+		printk(KERN_ERR "IOMMU: dmar init failed\n");
+		put_iova_domain(&reserved_iova_list);
+		iommu_exit_mempool();
+		return ret;
+	}
+	printk(KERN_INFO
+		"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
+
+	force_iommu = 1;
+	dma_ops = &intel_dma_ops;
+	return 0;
+}
Index: linux-2.6.22-rc3/drivers/pci/intel-iommu.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.22-rc3/drivers/pci/intel-iommu.h	2007-06-06 11:35:01.000000000 -0700
@@ -0,0 +1,296 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Copyright (C) Ashok Raj <ashok.raj@intel.com>
+ */
+
+#ifndef _INTEL_IOMMU_H_
+#define _INTEL_IOMMU_H_
+
+#include <linux/types.h>
+#include <linux/msi.h>
+#include "iova.h"
+#include <asm/io.h>
+
+/*
+ * Intel IOMMU register specification per version 1.0 public spec.
+ */
+
+#define	DMAR_VER_REG	0x0	/* Arch version supported by this IOMMU */
+#define	DMAR_CAP_REG	0x8	/* Hardware supported capabilities */
+#define	DMAR_ECAP_REG	0x10	/* Extended capabilities supported */
+#define	DMAR_GCMD_REG	0x18	/* Global command register */
+#define	DMAR_GSTS_REG	0x1c	/* Global status register */
+#define	DMAR_RTADDR_REG	0x20	/* Root entry table */
+#define	DMAR_CCMD_REG	0x28	/* Context command reg */
+#define	DMAR_FSTS_REG	0x34	/* Fault Status register */
+#define	DMAR_FECTL_REG	0x38	/* Fault control register */
+#define	DMAR_FEDATA_REG	0x3c	/* Fault event interrupt data register */
+#define	DMAR_FEADDR_REG	0x40	/* Fault event interrupt addr register */
+#define	DMAR_FEUADDR_REG 0x44	/* Upper address register */
+#define	DMAR_AFLOG_REG	0x58	/* Advanced Fault control */
+#define	DMAR_PMEN_REG	0x64	/* Enable Protected Memory Region */
+#define	DMAR_PLMBASE_REG 0x68	/* PMRR Low addr */
+#define	DMAR_PLMLIMIT_REG 0x6c	/* PMRR low limit */
+#define	DMAR_PHMBASE_REG 0x70	/* pmrr high base addr */
+#define	DMAR_PHMLIMIT_REG 0x78	/* pmrr high limit */
+
+#define OFFSET_STRIDE		(9)
+#define dmar_readl(dmar, reg) readl(dmar + reg)
+#define dmar_writel(dmar, reg, val) writel((val), dmar + reg)
+#define dmar_readq(dmar, reg) ({ \
+		u32 lo, hi; \
+		lo = dmar_readl(dmar, reg); \
+		hi = dmar_readl(dmar, reg + 4); \
+		(((u64) hi) << 32) + lo; })
+#define dmar_writeq(dmar, reg, val) do {\
+		dmar_writel(dmar, reg, (u32)(val)); \
+		dmar_writel(dmar, reg + 4, (u32)((val) >> 32)); \
+	} while (0)
+
+#define VER_MAJOR(v)		(((v) & 0xf0) >> 4)
+#define VER_MINOR(v)		((v) & 0x0f)
+
+/*
+ * Decoding Capability Register
+ */
+#define cap_read_drain(c)	(((c) >> 55) & 1)
+#define cap_write_drain(c)	(((c) >> 54) & 1)
+#define cap_max_amask_val(c)	(((c) >> 48) & 0x3f)
+#define cap_num_fault_regs(c)	((((c) >> 40) & 0xff) + 1)
+#define cap_pgsel_inv(c)	(((c) >> 39) & 1)
+
+#define cap_super_page_val(c)	(((c) >> 34) & 0xf)
+#define cap_super_offset(c)	(((find_first_bit(&cap_super_page_val(c), 4)) \
+					* OFFSET_STRIDE) + 21)
+
+#define cap_fault_reg_offset(c)	((((c) >> 24) & 0x3ff) * 16)
+#define cap_max_fault_reg_offset(c) \
+	(cap_fault_reg_offset(c) + cap_num_fault_regs(c) * 16)
+
+#define cap_zlr(c)		(((c) >> 22) & 1)
+#define cap_isoch(c)		(((c) >> 23) & 1)
+#define cap_mgaw(c)		((((c) >> 16) & 0x3f) + 1)
+#define cap_sagaw(c)		(((c) >> 8) & 0x1f)
+#define cap_caching_mode(c)	(((c) >> 7) & 1)
+#define cap_phmr(c)		(((c) >> 6) & 1)
+#define cap_plmr(c)		(((c) >> 5) & 1)
+#define cap_rwbf(c)		(((c) >> 4) & 1)
+#define cap_afl(c)		(((c) >> 3) & 1)
+#define cap_ndoms(c)		(((unsigned long)1) << (4 + 2 * ((c) & 0x7)))
+/*
+ * Extended Capability Register
+ */
+
+#define ecap_niotlb_iunits(e)	((((e) >> 24) & 0xff) + 1)
+#define ecap_iotlb_offset(e) 	((((e) >> 8) & 0x3ff) * 16)
+#define ecap_max_iotlb_offset(e) \
+	(ecap_iotlb_offset(e) + ecap_niotlb_iunits(e) * 16)
+#define ecap_coherent(e)	((e) & 0x1)
+
+
+/* IOTLB_REG */
+#define DMA_TLB_GLOBAL_FLUSH (((u64)1) << 60)
+#define DMA_TLB_DSI_FLUSH (((u64)2) << 60)
+#define DMA_TLB_PSI_FLUSH (((u64)3) << 60)
+#define DMA_TLB_IIRG(type) ((type >> 60) & 7)
+#define DMA_TLB_IAIG(val) (((val) >> 57) & 7)
+#define DMA_TLB_READ_DRAIN (((u64)1) << 49)
+#define DMA_TLB_WRITE_DRAIN (((u64)1) << 48)
+#define DMA_TLB_DID(id)	(((u64)((id) & 0xffff)) << 32)
+#define DMA_TLB_IVT (((u64)1) << 63)
+#define DMA_TLB_IH_NONLEAF (((u64)1) << 6)
+#define DMA_TLB_MAX_SIZE (0x3f)
+
+/* GCMD_REG */
+#define DMA_GCMD_TE (((u32)1) << 31)
+#define DMA_GCMD_SRTP (((u32)1) << 30)
+#define DMA_GCMD_SFL (((u32)1) << 29)
+#define DMA_GCMD_EAFL (((u32)1) << 28)
+#define DMA_GCMD_WBF (((u32)1) << 27)
+
+/* GSTS_REG */
+#define DMA_GSTS_TES (((u32)1) << 31)
+#define DMA_GSTS_RTPS (((u32)1) << 30)
+#define DMA_GSTS_FLS (((u32)1) << 29)
+#define DMA_GSTS_AFLS (((u32)1) << 28)
+#define DMA_GSTS_WBFS (((u32)1) << 27)
+
+/* CCMD_REG */
+#define DMA_CCMD_ICC (((u64)1) << 63)
+#define DMA_CCMD_GLOBAL_INVL (((u64)1) << 61)
+#define DMA_CCMD_DOMAIN_INVL (((u64)2) << 61)
+#define DMA_CCMD_DEVICE_INVL (((u64)3) << 61)
+#define DMA_CCMD_FM(m) (((u64)((m) & 0x3)) << 32)
+#define DMA_CCMD_MASK_NOBIT 0
+#define DMA_CCMD_MASK_1BIT 1
+#define DMA_CCMD_MASK_2BIT 2
+#define DMA_CCMD_MASK_3BIT 3
+#define DMA_CCMD_SID(s) (((u64)((s) & 0xffff)) << 16)
+#define DMA_CCMD_DID(d) ((u64)((d) & 0xffff))
+
+/* FECTL_REG */
+#define DMA_FECTL_IM (((u32)1) << 31)
+
+/* FSTS_REG */
+#define DMA_FSTS_PPF ((u32)2)
+#define DMA_FSTS_PFO ((u32)1)
+#define dma_fsts_fault_record_index(s) (((s) >> 8) & 0xff)
+
+/* FRCD_REG, 32 bits access */
+#define DMA_FRCD_F (((u32)1) << 31)
+#define dma_frcd_type(d) ((d >> 30) & 1)
+#define dma_frcd_fault_reason(c) (c & 0xff)
+#define dma_frcd_source_id(c) (c & 0xffff)
+#define dma_frcd_page_addr(d) (d & (((u64)-1) << 12)) /* low 64 bit */
+
+/*
+ * 0: Present
+ * 1-11: Reserved
+ * 12-63: Context Ptr (12 - (haw-1))
+ * 64-127: Reserved
+ */
+struct root_entry {
+	u64	val;
+	u64	rsvd1;
+};
+#define ROOT_ENTRY_NR (PAGE_SIZE_4K/sizeof(struct root_entry))
+#define root_present(root)	((root).val & 1)
+#define set_root_present(root) do {(root).val |= 1;} while(0)
+
+struct context_entry;
+static inline struct context_entry *
+get_context_addr_from_root(struct root_entry root)
+{
+	return (struct context_entry *) (root_present(root)?phys_to_virt( 	\
+		(root).val & PAGE_MASK_4K):					\
+		NULL);								\
+}
+
+#define set_root_value(root, value) \
+	do {(root).val |= ((value) & PAGE_MASK_4K);} while(0)
+
+/*
+ * low 64 bits:
+ * 0: present
+ * 1: fault processing disable
+ * 2-3: translation type
+ * 12-63: address space root
+ * high 64 bits:
+ * 0-2: address width
+ * 3-6: aval
+ * 8-23: domain id
+ */
+struct context_entry {
+	u64 lo;
+	u64 hi;
+};
+#define context_present(c) ((c).lo & 1)
+#define context_fault_disable(c) (((c).lo >> 1) & 1)
+#define context_translation_type(c) (((c).lo >> 2) & 3)
+#define context_address_root(c) ((c).lo & PAGE_MASK_4K)
+#define context_address_width(c) ((c).hi &  7)
+#define context_domain_id(c) (((c).hi >> 8) & ((1 << 16) - 1))
+
+#define context_set_present(c) do {(c).lo |= 1;} while(0)
+#define context_set_fault_enable(c) \
+	do {(c).lo &= (((u64)-1) << 2) | 1;} while(0)
+#define context_set_translation_type(c, val) do { \
+		(c).lo &= (((u64)-1) << 4) | 3; \
+		(c).lo |= ((val) & 3) << 2; \
+	} while(0)
+#define CONTEXT_TT_MULTI_LEVEL 0
+#define context_set_address_root(c, val) \
+	do {(c).lo |= (val) & PAGE_MASK_4K;} while(0)
+#define context_set_address_width(c, val) do {(c).hi |= (val) & 7;} while(0)
+#define context_set_domain_id(c, val) \
+	do {(c).hi |= ((val) & ((1 << 16) - 1)) << 8;} while(0)
+#define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while(0)
+
+/*
+ * 0: readable
+ * 1: writable
+ * 2-6: reserved
+ * 7: super page
+ * 8-11: available
+ * 12-63: Host physcial address
+ */
+struct dma_pte {
+	u64 val;
+};
+#define dma_clear_pte(p)	do {(p).val = 0;} while(0)
+
+#define DMA_PTE_READ (1)
+#define DMA_PTE_WRITE (2)
+
+#define dma_set_pte_readable(p) do {(p).val |= DMA_PTE_READ;} while(0)
+#define dma_set_pte_writable(p) do {(p).val |= DMA_PTE_WRITE;} while(0)
+#define dma_set_pte_prot(p, prot) do {\
+	(p).val = ((p).val & ~3) | ((prot) & 3); } while(0)
+#define dma_pte_addr(p) ((p).val & PAGE_MASK_4K)
+#define dma_set_pte_addr(p, addr) do {\
+		(p).val |= ((addr) & PAGE_MASK_4K); } while(0)
+#define dma_pte_present(p) (((p).val & 3) != 0)
+
+struct intel_iommu;
+
+struct domain {
+	int	id;			/* domain id */
+	struct intel_iommu *iommu;	/* back pointer to owning iommu */
+
+	struct list_head devices; 	/* all devices' list */
+	struct iova_domain iovad;	/* iova's that belong to this domain */
+
+	struct dma_pte	*pgd;		/* virtual address */
+	spinlock_t	mapping_lock;	/* page table lock */
+	int		gaw;		/* max guest address width */
+	int		agaw;		/* adjusted guest address width, 0 is level 2 30-bit */
+
+#define DOMAIN_FLAG_MULTIPLE_DEVICES 1
+	int		flags;
+};
+
+/* PCI domain-device relationship */
+struct device_domain_info {
+	struct list_head link;	/* link to domain siblings */
+	struct list_head global; /* link to global list */
+	u8 bus;			/* PCI bus numer */
+	u8 devfn;		/* PCI devfn number */
+	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
+	struct domain *domain; /* pointer to domain */
+};
+
+extern int init_dmars(void);
+
+struct intel_iommu {
+	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
+	u64		cap;
+	u64		ecap;
+	unsigned long 	*domain_ids; /* bitmap of domains */
+	struct domain **domains; /* ptr to domains */
+	int		seg;
+	u32		gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */
+	spinlock_t	lock; /* protect context, domain ids */
+	spinlock_t	register_lock; /* protect register handling */
+	struct root_entry *root_entry; /* virtual address */
+
+	unsigned int irq;
+	unsigned char name[7];    /* Device Name */
+	struct msi_msg saved_msg;
+	struct sys_device sysdev;
+};
+
+#endif
Index: linux-2.6.22-rc3/include/linux/dmar.h
===================================================================
--- linux-2.6.22-rc3.orig/include/linux/dmar.h	2007-06-06 11:33:23.000000000 -0700
+++ linux-2.6.22-rc3/include/linux/dmar.h	2007-06-06 11:35:01.000000000 -0700
@@ -23,8 +23,15 @@
 
 #include <linux/acpi.h>
 #include <linux/types.h>
+#include <linux/msi.h>
 
 
+struct intel_iommu;
+
+/* Intel IOMMU detection and initialization functions */
+extern void detect_intel_iommu(void);
+extern int intel_iommu_init(void);
+
 extern int dmar_table_init(void);
 extern int early_dmar_detect(void);
 
@@ -49,4 +56,20 @@
 	int	devices_cnt;		/* target device count */
 };
 
+#define for_each_drhd_unit(drhd) \
+	list_for_each_entry(drhd, &dmar_drhd_units, list)
+#define for_each_rmrr_units(rmrr) \
+	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
+#define begin_for_each_rmrr_device(rmrr, pdev) \
+	for_each_rmrr_units(rmrr) { \
+		int _i; \
+		for (_i = 0; _i < rmrr->devices_cnt; _i++) { \
+			pdev = rmrr->devices[_i]; \
+			/* some BIOS lists non-exist devices in DMAR table */\
+			if (!pdev) \
+				continue;
+#define end_for_each_rmrr_device(rmrr, pdev) \
+		} \
+	}
+
 #endif /* __DMAR_H__ */

-- 
