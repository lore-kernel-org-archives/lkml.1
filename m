Return-Path: <linux-kernel-owner+w=401wt.eu-S1161797AbXDXPPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161797AbXDXPPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422689AbXDXPPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:15:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:19686 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161803AbXDXPIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:08:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="218705681:sNHT521657192"
Message-Id: <20070423164957.006549000@linux.intel.com>
References: <20070423163837.447443000@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 09:38:40 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com
Subject: [Intel IOMMU][patch 3/8] Generic hardware support for Intel IOMMU.
Content-Disposition: inline; filename=intel-iommu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Actual intel IOMMU driver. Hardware spec can be found at:
http://www.intel.com/technology/virtualization

The current version of spec is slightly outdated, but an updated version of
spec is in works and comming very soon. I will send a note to the list
when new updated spec is available. For the most part existing spec should be 
good for basic understanding of the mechanics of the IOMMU.

This driver sets X86_64 'dma_ops', so hook into standard DMA APIs. In this way,
PCI driver will get virtual DMA address. This change is transparent to PCI 
drivers.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Index: 2.6.21-rc6/arch/x86_64/kernel/io_apic.c
===================================================================
--- 2.6.21-rc6.orig/arch/x86_64/kernel/io_apic.c	2007-04-20 11:03:02.000000000 +0800
+++ 2.6.21-rc6/arch/x86_64/kernel/io_apic.c	2007-04-20 11:42:57.000000000 +0800
@@ -32,6 +32,7 @@
 #include <linux/sysdev.h>
 #include <linux/msi.h>
 #include <linux/htirq.h>
+#include <linux/intel-iommu.h>
 #ifdef CONFIG_ACPI
 #include <acpi/acpi_bus.h>
 #endif
@@ -2002,8 +2003,64 @@ void arch_teardown_msi_irq(unsigned int 
 	destroy_irq(irq);
 }
 
-#endif /* CONFIG_PCI_MSI */
+#ifdef CONFIG_DMAR
+#ifdef CONFIG_SMP
+static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg = irq_cfg + irq;
+	struct msi_msg msg;
+	unsigned int dest;
+	cpumask_t tmp;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	dmar_msi_read(irq, &msg);
+
+	msg.data &= ~MSI_DATA_VECTOR_MASK;
+	msg.data |= MSI_DATA_VECTOR(cfg->vector);
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
+
+	dmar_msi_write(irq, &msg);
+	irq_desc[irq].affinity = mask;
+}
+#endif /* CONFIG_SMP */
+
+struct irq_chip dmar_msi_type = {
+	.name = "DMAR_MSI",
+	.unmask = dmar_msi_unmask,
+	.mask = dmar_msi_mask,
+	.ack = ack_apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity = dmar_msi_set_affinity,
+#endif
+	.retrigger = ioapic_retrigger_irq,
+};
+
+int arch_setup_dmar_msi(unsigned int irq)
+{
+	int ret;
+	struct msi_msg msg;
+
+	ret = msi_compose_msg(NULL, irq, &msg);
+	if (ret < 0)
+		return ret;
+	dmar_msi_write(irq, &msg);
+	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
+		"edge");
+	return 0;
+}
+#endif
 
+#endif /* CONFIG_PCI_MSI */
 /*
  * Hypertransport interrupt support
  */
Index: 2.6.21-rc6/arch/x86_64/kernel/pci-dma.c
===================================================================
--- 2.6.21-rc6.orig/arch/x86_64/kernel/pci-dma.c	2007-04-20 11:03:02.000000000 +0800
+++ 2.6.21-rc6/arch/x86_64/kernel/pci-dma.c	2007-04-20 11:42:57.000000000 +0800
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <linux/module.h>
+#include <linux/intel-iommu.h>
 #include <asm/io.h>
 #include <asm/proto.h>
 #include <asm/calgary.h>
@@ -303,6 +304,10 @@ void __init pci_iommu_alloc(void)
 	detect_calgary();
 #endif
 
+#ifdef CONFIG_DMAR
+	detect_intel_iommu();
+#endif
+
 #ifdef CONFIG_SWIOTLB
 	pci_swiotlb_init();
 #endif
@@ -314,6 +319,10 @@ static int __init pci_iommu_init(void)
 	calgary_iommu_init();
 #endif
 
+#ifdef CONFIG_DMAR
+	intel_iommu_init();
+#endif
+
 #ifdef CONFIG_IOMMU
 	gart_iommu_init();
 #endif
Index: 2.6.21-rc6/arch/x86_64/mm/pageattr.c
===================================================================
--- 2.6.21-rc6.orig/arch/x86_64/mm/pageattr.c	2007-04-20 11:03:02.000000000 +0800
+++ 2.6.21-rc6/arch/x86_64/mm/pageattr.c	2007-04-20 11:42:57.000000000 +0800
@@ -61,10 +61,10 @@ static struct page *split_large_page(uns
 	return base;
 } 
 
-static void cache_flush_page(void *adr)
+void clflush_cache_range(void *adr, int size)
 {
 	int i;
-	for (i = 0; i < PAGE_SIZE; i += boot_cpu_data.x86_clflush_size)
+	for (i = 0; i < size; i += boot_cpu_data.x86_clflush_size)
 		asm volatile("clflush (%0)" :: "r" (adr + i));
 }
 
@@ -80,7 +80,7 @@ static void flush_kernel_map(void *arg)
 	list_for_each_entry(pg, l, lru) {
 		void *adr = page_address(pg);
 		if (cpu_has_clflush)
-			cache_flush_page(adr);
+			clflush_cache_range(adr, PAGE_SIZE);
 		__flush_tlb_one(adr);
 	}
 }
Index: 2.6.21-rc6/drivers/pci/Kconfig
===================================================================
--- 2.6.21-rc6.orig/drivers/pci/Kconfig	2007-04-20 11:03:02.000000000 +0800
+++ 2.6.21-rc6/drivers/pci/Kconfig	2007-04-20 11:42:57.000000000 +0800
@@ -60,3 +60,11 @@ config HT_IRQ
 	   This allows native hypertransport devices to use interrupts.
 
 	   If unsure say Y.
+
+config IOVA_GUARD_PAGE
+	bool "Enables gaurd page when allocating IO Virtual Address for IOMMU"
+	depends on DMAR
+
+config IOVA_NEXT_CONTIG
+	bool "Keeps IOVA allocations consequent between allocations"
+	depends on DMAR && EXPERIMENTAL
Index: 2.6.21-rc6/drivers/pci/Makefile
===================================================================
--- 2.6.21-rc6.orig/drivers/pci/Makefile	2007-04-20 11:03:02.000000000 +0800
+++ 2.6.21-rc6/drivers/pci/Makefile	2007-04-20 11:42:57.000000000 +0800
@@ -20,6 +20,9 @@ obj-$(CONFIG_PCI_MSI) += msi.o
 # Build the Hypertransport interrupt support
 obj-$(CONFIG_HT_IRQ) += htirq.o
 
+# Build DMAR if configured
+obj-$(CONFIG_DMAR) += intel-iommu.o iova.o
+
 #
 # Some architectures use the generic PCI setup functions
 #
Index: 2.6.21-rc6/drivers/pci/intel-iommu.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.21-rc6/drivers/pci/intel-iommu.c	2007-04-20 11:42:57.000000000 +0800
@@ -0,0 +1,2070 @@
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
+#include <linux/dma-mapping.h>
+#include <linux/mempool.h>
+
+#include <linux/intel-iommu.h>
+#include <asm/proto.h> /* force_iommu in this header in x86-64*/
+#include <asm/cacheflush.h>
+#include "dmar.h"
+#include "iova.h"
+#include "pci.h"
+
+#define IOAPIC_RANGE_START	(0xfee00000)
+#define IOAPIC_RANGE_END	(0xfeefffff)
+#define IOAPIC_RANGE_SIZE	(IOAPIC_RANGE_END - IOAPIC_RANGE_START + 1)
+#define IOVA_START_ADDR		(0x1000)
+
+#define DEFAULT_DOMAIN_ADDRESS_WIDTH 48
+
+#define DMAR_OPERATION_TIMEOUT (HZ*60) /* 1m */
+
+static char *fault_reason_strings[] =
+{
+	"Software",
+	"Present bit in root entry is clear",
+	"Present bit in context entry is clear",
+	"Invalid context entry",
+	"Access beyond MGAW",
+	"PTE Write access is not set",
+	"PTE Read access is not set",
+	"Next page table ptr is invalid",
+	"Root table address invalid",
+	"Context table ptr is invalid",
+	"non-zero reserved fields in RTP",
+	"non-zero reserved fields in CTP",
+	"non-zero reserved fields in PTE",
+	"Unknown"
+};
+
+#define MAX_FAULT_REASON_IDX 	(12)
+#define IOMMU_NAME_LEN		(7)
+
+struct iommu {
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
+static int dmar_disabled;
+
+static char *get_fault_reason(u8 fault_reason)
+{
+	if (fault_reason > MAX_FAULT_REASON_IDX)
+		return fault_reason_strings[MAX_FAULT_REASON_IDX];
+	else
+		return fault_reason_strings[fault_reason];
+}
+
+static int __init intel_iommu_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	while (*str) {
+		if (!strncmp(str, "off", 3)) {
+			dmar_disabled = 1;
+			printk(KERN_INFO"Intel-IOMMU: disabled\n");
+		}
+		str += strcspn(str, ",");
+		while (*str == ',')
+			str++;
+	}
+	return 0;
+}
+__setup("intel_iommu=", intel_iommu_setup);
+
+#define MIN_PGTABLE_PAGES	(10)
+static mempool_t *pgtable_mempool;
+#define MIN_DOMAIN_REQ		(20)
+static mempool_t *domain_mempool;
+#define MIN_DEVINFO_REQ		(20)
+static mempool_t *devinfo_mempool;
+
+#define alloc_pgtable_page() mempool_alloc(pgtable_mempool, GFP_ATOMIC)
+#define free_pgtable_page(vaddr) mempool_free(vaddr, pgtable_mempool)
+#define alloc_domain_mem() mempool_alloc(domain_mempool, GFP_ATOMIC)
+#define free_domain_mem(vaddr) mempool_free(vaddr, domain_mempool)
+#define alloc_devinfo_mem() mempool_alloc(devinfo_mempool, GFP_ATOMIC)
+#define free_devinfo_mem(vaddr) mempool_free(vaddr, devinfo_mempool)
+
+static void __iommu_flush_cache(struct iommu *iommu, void *addr, int size)
+{
+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(addr, size);
+}
+
+#define iommu_flush_cache_entry(iommu, addr) \
+	__iommu_flush_cache(iommu, addr, 8)
+#define iommu_flush_cache_page(iommu, addr) \
+	__iommu_flush_cache(iommu, addr, PAGE_SIZE_4K)
+
+/* context entry handling */
+static struct context_entry * device_to_context_entry(struct iommu *iommu,
+		u8 bus, u8 devfn)
+{
+	struct root_entry *root;
+	struct context_entry *context;
+	unsigned long phy_addr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	root = &iommu->root_entry[bus];
+	if (!root_present(*root)) {
+		phy_addr = (unsigned long)alloc_pgtable_page();
+		if (!phy_addr) {
+			spin_unlock_irqrestore(&iommu->lock, flags);
+			return NULL;
+		}
+		iommu_flush_cache_page(iommu, (void *)phy_addr);
+		phy_addr = virt_to_phys((void *)phy_addr);
+		set_root_value(*root, phy_addr);
+		set_root_present(*root);
+		iommu_flush_cache_entry(iommu, root);
+	}
+	phy_addr = get_context_addr(*root);
+	context = (struct context_entry *)phys_to_virt(phy_addr);
+	spin_unlock_irqrestore(&iommu->lock, flags);
+	return &context[devfn];
+}
+
+static int device_context_mapped(struct iommu *iommu, u8 bus, u8 devfn)
+{
+	struct root_entry *root;
+	struct context_entry *context;
+	u64 phy_addr;
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	root = &iommu->root_entry[bus];
+	if (!root_present(*root)) {
+		ret = 0;
+		goto out;
+	}
+	phy_addr = get_context_addr(*root);
+	context = (struct context_entry *)phys_to_virt(phy_addr);
+	ret = context_present(context[devfn]);
+out:
+	spin_unlock_irqrestore(&iommu->lock, flags);
+	return ret;
+}
+
+static void clear_context_table(struct iommu *iommu, u8 bus, u8 devfn)
+{
+	struct root_entry *root;
+	struct context_entry *context;
+	u64 phy_addr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	root = &iommu->root_entry[bus];
+	if (!root_present(*root))
+		goto out;
+
+	phy_addr = get_context_addr(*root);
+	context = (struct context_entry *)phys_to_virt(phy_addr);
+	context_clear_entry(context[devfn]);
+	iommu_flush_cache_entry(iommu, &context[devfn]);
+out:
+	spin_unlock_irqrestore(&iommu->lock, flags);
+}
+
+static void free_context_table(struct iommu *iommu)
+{
+	struct root_entry *root;
+	int i;
+	u64 addr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	if (!iommu->root_entry) {
+		spin_unlock_irqrestore(&iommu->lock, flags);
+		return;
+	}
+	for (i = 0; i < ROOT_ENTRY_NR; i++) {
+		root = &iommu->root_entry[i];
+		if (!root_present(*root))
+			continue;
+		addr = get_context_addr(*root);
+		free_pgtable_page(phys_to_virt(addr));
+	}
+	free_pgtable_page(iommu->root_entry);
+	iommu->root_entry = NULL;
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
+		void *tmp;
+
+		offset = address_level_offset(addr, level);
+		pte = &parent[offset];
+		if (level == 1)
+			break;
+
+		if (!dma_pte_present(*pte)) {
+			tmp = alloc_pgtable_page();
+
+			if (!tmp) {
+				spin_unlock_irqrestore(&domain->mapping_lock, flags);
+				return NULL;
+			}
+			iommu_flush_cache_page(domain->iommu, tmp);
+			dma_set_pte_addr(*pte, virt_to_phys(tmp));
+			/*
+			 * high level table always sets r/w, last level page
+			 * table control read/write
+			 */
+			dma_set_pte_readable(*pte);
+			dma_set_pte_writable(*pte);
+			iommu_flush_cache_entry(domain->iommu, pte);
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
+		iommu_flush_cache_entry(domain->iommu, pte);
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
+				iommu_flush_cache_entry(domain->iommu, pte);
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
+static int iommu_alloc_root_entry(struct iommu *iommu)
+{
+	struct root_entry *root;
+	unsigned long flags;
+
+	BUG_ON(iommu->root_entry);
+
+	root = (struct root_entry *)alloc_pgtable_page();
+	if (!root)
+		return -ENOMEM;
+
+	iommu_flush_cache_page(iommu, root);
+
+	spin_lock_irqsave(&iommu->lock, flags);
+	iommu->root_entry = root;
+	spin_unlock_irqrestore(&iommu->lock, flags);
+
+	return 0;
+}
+
+static void iommu_set_root_entry(struct iommu *iommu)
+{
+	void *addr;
+	u32 cmd, sts;
+	unsigned long flag;
+	unsigned long start_time;
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
+	start_time = jiffies;
+	while (1) {
+		sts = dmar_readl(iommu->reg, DMAR_GSTS_REG);
+		if (sts & DMA_GSTS_RTPS)
+			break;
+		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
+			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
+		cpu_relax();
+	}
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+static void iommu_flush_write_buffer(struct iommu *iommu)
+{
+	u32 val;
+	unsigned long flag;
+	unsigned long start_time;
+
+	if (!cap_rwbf(iommu->cap))
+		return;
+	val = iommu->gcmd | DMA_GCMD_WBF;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writel(iommu->reg, DMAR_GCMD_REG, val);
+
+	/* Make sure hardware complete it */
+	start_time = jiffies;
+	while (1) {
+		val = dmar_readl(iommu->reg, DMAR_GSTS_REG);
+		if (!(val & DMA_GSTS_WBFS))
+			break;
+		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
+			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
+		cpu_relax();
+	}
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+/* return value determine if we need a write buffer flush */
+static int __iommu_flush_context(struct iommu *iommu,
+	u16 did, u16 source_id, u8 function_mask, u64 type,
+	int non_present_entry_flush)
+{
+	u64 val = 0;
+	unsigned long flag;
+	unsigned long start_time;
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
+	start_time = jiffies;
+	while (1) {
+		val = dmar_readq(iommu->reg, DMAR_CCMD_REG);
+		if (!(val & DMA_CCMD_ICC))
+			break;
+		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
+			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
+		cpu_relax();
+	}
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+	/* flush context entry will implictly flush write buffer */
+	return 0;
+}
+
+static int inline iommu_flush_context_global(struct iommu *iommu,
+	int non_present_entry_flush)
+{
+	return __iommu_flush_context(iommu, 0, 0, 0, DMA_CCMD_GLOBAL_INVL,
+		non_present_entry_flush);
+}
+
+static int inline iommu_flush_context_domain(struct iommu *iommu, u16 did,
+	int non_present_entry_flush)
+{
+	return __iommu_flush_context(iommu, did, 0, 0, DMA_CCMD_DOMAIN_INVL,
+		non_present_entry_flush);
+}
+
+static int inline iommu_flush_context_device(struct iommu *iommu,
+	u16 did, u16 source_id, u8 function_mask, int non_present_entry_flush)
+{
+	return __iommu_flush_context(iommu, did, source_id, function_mask,
+		DMA_CCMD_DEVICE_INVL, non_present_entry_flush);
+}
+
+/* return value determine if we need a write buffer flush */
+static int __iommu_flush_iotlb(struct iommu *iommu, u16 did,
+	u64 addr, unsigned int size_order, u64 type,
+	int non_present_entry_flush)
+{
+	int tlb_offset = ecap_iotlb_offset(iommu->ecap);
+	u64 val = 0, val_iva = 0;
+	unsigned long flag;
+	unsigned long start_time;
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
+	start_time = jiffies;
+	while (1) {
+		val = dmar_readq(iommu->reg, tlb_offset + 8);
+		if (!(val & DMA_TLB_IVT))
+			break;
+		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
+			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
+		cpu_relax();
+	}
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
+static int inline iommu_flush_iotlb_global(struct iommu *iommu,
+	int non_present_entry_flush)
+{
+	return __iommu_flush_iotlb(iommu, 0, 0, 0, DMA_TLB_GLOBAL_FLUSH,
+		non_present_entry_flush);
+}
+
+static int inline iommu_flush_iotlb_dsi(struct iommu *iommu, u16 did,
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
+static int inline iommu_flush_iotlb_psi(struct iommu *iommu, u16 did,
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
+static int iommu_enable_translation(struct iommu *iommu)
+{
+	u32 sts;
+	unsigned long flag;
+	unsigned long start_time;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writel(iommu->reg, DMAR_GCMD_REG, iommu->gcmd|DMA_GCMD_TE);
+
+	/* Make sure hardware complete it */
+	start_time = jiffies;
+	while (1) {
+		sts = dmar_readl(iommu->reg, DMAR_GSTS_REG);
+		if (sts & DMA_GSTS_TES)
+			break;
+		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
+			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
+		cpu_relax();
+	}
+	iommu->gcmd |= DMA_GCMD_TE;
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	return 0;
+}
+
+static int iommu_disable_translation(struct iommu *iommu)
+{
+	u32 sts;
+	unsigned long flag;
+	unsigned long start_time;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	iommu->gcmd &= ~ DMA_GCMD_TE;
+	dmar_writel(iommu->reg, DMAR_GCMD_REG, iommu->gcmd);
+
+	/* Make sure hardware complete it */
+	start_time = jiffies;
+	while(1) {
+		sts = dmar_readl(iommu->reg, DMAR_GSTS_REG);
+		if (!(sts & DMA_GSTS_TES))
+			break;
+		if (time_after(jiffies, start_time + DMAR_OPERATION_TIMEOUT))
+			panic("DMAR hardware is malfunctional, please disable IOMMU\n");
+		cpu_relax();
+	}
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	return 0;
+}
+
+/* iommu interrupt handling. Most staffs are MSI-like. */
+static int iommu_page_fault_do_one(struct iommu *iommu, int type,
+		u8 fault_reason, u16 source_id, u64 addr)
+{
+	char *reason;
+
+	reason = get_fault_reason(fault_reason);
+
+	printk(KERN_ERR
+		"DMAR:[%s] Request device [%02x:%02x.%d] "
+		"fault addr %llx \n"
+		"DMAR:[fault reason %02d] %s\n",
+		(type ? "DMA Read" : "DMA Write"),
+		(source_id >> 8), PCI_SLOT(source_id & 0xFF),
+		PCI_FUNC(source_id & 0xFF), addr, fault_reason, reason);
+	return 0;
+}
+
+#define PRIMARY_FAULT_REG_LEN (16)
+static irqreturn_t iommu_page_fault(int irq, void *dev_id)
+{
+	struct iommu *iommu = dev_id;
+	int reg, fault_index;
+	u32 fault_status;
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	fault_status = dmar_readl(iommu->reg, DMAR_FSTS_REG);
+
+	/* TBD: ignore advanced fault log currently */
+	if (!(fault_status & DMA_FSTS_PPF))
+		goto clear_overflow;
+
+	fault_index = dma_fsts_fault_record_index(fault_status);
+	reg = cap_fault_reg_offset(iommu->cap);
+	while (1) {
+		u8 fault_reason;
+		u16 source_id;
+		u64 guest_addr;
+		int type;
+		u32 data;
+
+		/* highest 32 bits */
+		data = dmar_readl(iommu->reg, reg +
+				fault_index * PRIMARY_FAULT_REG_LEN + 12);
+		if (!(data & DMA_FRCD_F))
+			break;
+
+		fault_reason = dma_frcd_fault_reason(data);
+		type = dma_frcd_type(data);
+
+		data = dmar_readl(iommu->reg, reg +
+				fault_index * PRIMARY_FAULT_REG_LEN + 8);
+		source_id = dma_frcd_source_id(data);
+
+		guest_addr = dmar_readq(iommu->reg, reg +
+				fault_index * PRIMARY_FAULT_REG_LEN);
+		guest_addr = dma_frcd_page_addr(guest_addr);
+		/* clear the fault */
+		dmar_writel(iommu->reg, reg +
+			fault_index * PRIMARY_FAULT_REG_LEN + 12, DMA_FRCD_F);
+
+		spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+		iommu_page_fault_do_one(iommu, type, fault_reason,
+				source_id, guest_addr);
+
+		fault_index++;
+		if (fault_index > cap_num_fault_regs(iommu->cap))
+			fault_index = 0;
+		spin_lock_irqsave(&iommu->register_lock, flag);
+	}
+clear_overflow:
+	/* clear primary fault overflow */
+	fault_status = dmar_readl(iommu->reg, DMAR_FSTS_REG);
+	if (fault_status & DMA_FSTS_PFO)
+		dmar_writel(iommu->reg, DMAR_FSTS_REG, DMA_FSTS_PFO);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+	return IRQ_HANDLED;
+}
+
+void dmar_msi_unmask(unsigned int irq)
+{
+	struct iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	/* unmask it */
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writel(iommu->reg, DMAR_FECTL_REG, 0);
+	/* Read a reg to force flush the post write */
+	dmar_readl(iommu->reg, DMAR_FECTL_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_mask(unsigned int irq)
+{
+	unsigned long flag;
+	struct iommu *iommu = get_irq_data(irq);
+
+	/* mask it */
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writel(iommu->reg, DMAR_FECTL_REG, DMA_FECTL_IM);
+	/* Read a reg to force flush the post write */
+	dmar_readl(iommu->reg, DMAR_FECTL_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_write(int irq, struct msi_msg *msg)
+{
+	struct iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	dmar_writel(iommu->reg, DMAR_FEDATA_REG, msg->data);
+	dmar_writel(iommu->reg, DMAR_FEADDR_REG, msg->address_lo);
+	dmar_writel(iommu->reg, DMAR_FEUADDR_REG, msg->address_hi);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+void dmar_msi_read(int irq, struct msi_msg *msg)
+{
+	struct iommu *iommu = get_irq_data(irq);
+	unsigned long flag;
+
+	spin_lock_irqsave(&iommu->register_lock, flag);
+	msg->data = dmar_readl(iommu->reg, DMAR_FEDATA_REG);
+	msg->address_lo = dmar_readl(iommu->reg, DMAR_FEADDR_REG);
+	msg->address_hi = dmar_readl(iommu->reg, DMAR_FEUADDR_REG);
+	spin_unlock_irqrestore(&iommu->register_lock, flag);
+}
+
+static int iommu_set_interrupt(struct iommu *iommu)
+{
+	int irq, ret;
+
+	irq = create_irq();
+	if (!irq) {
+		printk(KERN_ERR "IOMMU: no free vectors\n");
+		return -EINVAL;
+	}
+
+	set_irq_data(irq, iommu);
+	iommu->irq = irq;
+
+	ret = arch_setup_dmar_msi(irq);
+	if (ret) {
+		set_irq_data(irq, NULL);
+		iommu->irq = 0;
+		destroy_irq(irq);
+		return 0;
+	}
+	/* Force fault register is cleared */
+	iommu_page_fault(irq, iommu);
+
+	ret = request_irq(irq, iommu_page_fault, 0, iommu->name, iommu);
+	if (ret)
+		printk(KERN_ERR "IOMMU: can't request irq\n");
+	return ret;
+}
+
+static int iommu_init_domains(struct iommu *iommu)
+{
+	unsigned long ndomains;
+	unsigned long nlongs;
+
+	ndomains = cap_ndoms(iommu->cap);
+	pr_debug("Domain number is %ld\n", ndomains);
+	nlongs = BITS_TO_LONGS(ndomains);
+
+	/* TBD: there might be 64K domains, consider other allocation for future chip */
+	iommu->domain_ids = kcalloc(nlongs, sizeof(unsigned long), GFP_KERNEL);
+	if (!iommu->domain_ids) {
+		pr_debug("Allocating domain id array failed\n");
+		return -ENOMEM;
+	}
+	iommu->domains = kcalloc(ndomains, sizeof(struct domain *), GFP_KERNEL);
+	if (!iommu->domains) {
+		pr_debug("Allocating domain array failed\n");
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
+static struct iommu *alloc_iommu(struct dmar_drhd_unit *drhd)
+{
+	struct iommu *iommu;
+	int ret;
+	int map_size;
+	u32 ver;
+
+	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
+	if (!iommu)
+		return NULL;
+	iommu->reg = ioremap(drhd->address, PAGE_SIZE_4K);
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
+		iommu->reg = ioremap(drhd->address, map_size);
+		if (!iommu->reg) {
+			printk(KERN_ERR "IOMMU: can't map the region\n");
+			goto error;
+		}
+	}
+
+	ver = dmar_readl(iommu->reg, DMAR_VER_REG);
+	pr_debug("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n", drhd->address,
+		VER_MAJOR(ver), VER_MINOR(ver),
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
+static void free_iommu(struct iommu *iommu)
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
+static struct domain * iommu_alloc_domain(struct iommu *iommu)
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
+static struct iova *reserved_iova_list;
+#ifdef DEBUG
+static void print_iova_list(struct iova *head)
+{
+	while (head) {
+		pr_debug("Start %p, size %lx\n",
+			(void *)head->addr, head->size);
+		head = head->next;
+	}
+}
+#endif
+
+static void dmar_init_reserved_ranges(void)
+{
+	struct pci_dev *pdev = NULL;
+	struct domain fake;
+	struct iova *iova;
+	int i;
+	u64 addr, size;
+
+	/* build a reference reserved range */
+	fake.iova = NULL;
+	spin_lock_init(&fake.lock);
+
+	/* IOAPIC ranges shouldn't be accessed by DMA */
+	iova = reserve_iova(&fake, IOAPIC_RANGE_START,
+		IOAPIC_RANGE_SIZE);
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
+			iova = reserve_iova(&fake, addr, size);
+			if (!iova)
+				printk(KERN_ERR "Reserve iova failed\n");
+		}
+	}
+	reserved_iova_list = fake.iova;
+#ifdef DEBUG
+	pr_debug("System reserved iova ranges:\n");
+	print_iova_list(reserved_iova_list);
+#endif
+}
+
+static void domain_reserve_special_ranges(struct domain *domain)
+{
+	struct iova *area, *tmp;
+
+	tmp = reserved_iova_list;
+	while (tmp) {
+		area = reserve_iova(domain, tmp->addr, tmp->size);
+		if (!area)
+			printk(KERN_ERR "Reserve iova range %lx@%llx failed\n",
+				tmp->size, tmp->addr);
+		tmp = tmp->next;
+	}
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
+	struct iommu *iommu;
+	int adjust_width, agaw;
+	unsigned long sagaw;
+
+	spin_lock_init(&domain->lock);
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
+	iommu_flush_cache_page(iommu, domain->pgd);
+	return 0;
+}
+
+static void domain_remove_dev_info(struct domain *domain);
+static void domain_exit(struct domain *domain)
+{
+	/* Domain 0 is reserved, so dont process it */
+	if (!domain)
+		return;
+
+	domain_remove_dev_info(domain);
+	/* destroy iovas */
+	destroy_iovas(domain);
+	/* clear ptes */
+	dma_pte_clear_range(domain, 0, domain->max_addr_used);
+	/* free page tables */
+	dma_pte_free_pagetable(domain, 0, domain->max_addr_used);
+
+	iommu_free_domain(domain);
+	free_domain_mem(domain);
+}
+
+static int domain_context_mapping_one(struct domain *domain, u8 bus, u8 devfn)
+{
+	struct context_entry *context;
+	struct iommu *iommu = domain->iommu;
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
+	iommu_flush_cache_entry(iommu, context);
+
+	/* it's a non-present to present mapping */
+	if (iommu_flush_context_device(iommu, domain->id,
+			(((u16)bus) << 8) | devfn, DMA_CCMD_MASK_NOBIT, 1))
+		iommu_flush_write_buffer(iommu);
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
+		iommu_flush_cache_entry(domain->iommu, pte);
+		start_pfn++;
+		index++;
+	}
+	return 0;
+}
+
+/* domain-device relationship */
+struct device_domain_info {
+	struct list_head link; /* link to domain siblings */
+	struct list_head global; /* link to global list */
+	u8 bus;
+	u8 devfn;
+	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
+	struct domain *domain;
+};
+static DEFINE_SPINLOCK(device_domain_lock);
+static LIST_HEAD(device_domain_list);
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
+/* domain is initialized */
+static struct domain *set_domain_for_dev(struct pci_dev *pdev, int gaw)
+{
+	struct domain *domain, *found = NULL;
+	struct iommu *iommu;
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
+	domain = set_domain_for_dev(pdev, DEFAULT_DOMAIN_ADDRESS_WIDTH);
+	if (!domain)
+		return -ENOMEM;
+
+	/* The address might not be aligned */
+	base = start & PAGE_MASK_4K;
+	size = end - base;
+	size = PAGE_ALIGN_4K(size);
+	if (!reserve_iova(domain, base, size)) {
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
+	return iommu_prepare_identity_map(pdev, rmrr->base_address,
+		rmrr->end_address + 1);
+}
+
+int __init init_dmars(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct dmar_rmrr_unit *rmrr;
+	struct pci_dev *pdev;
+	struct iommu *iommu;
+	int ret, unit = 0;
+
+	/*
+	 * for each drhd
+	 *    allocate root
+	 *    initialize and program root entry to not present
+	 * endfor
+	 */
+	for_each_drhd_unit(drhd) {
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
+	 *           allocate and init cotext
+	 *           set present in root table for this bus
+	 *     init context with domain, translation etc
+	 *    endfor
+	 * endfor
+	 */
+	for_each_rmrr_device(rmrr, pdev)
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
+		iommu = drhd->iommu;
+		sprintf (iommu->name, "dmar%d", unit++);
+
+		iommu_flush_write_buffer(iommu);
+
+		ret = iommu_set_interrupt(iommu);
+		if (ret)
+			goto error;
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
+		iommu = drhd->iommu;
+		free_iommu(iommu);
+	}
+	return ret;
+}
+
+#ifdef CONFIG_IOVA_NEXT_CONTIG
+u64 get_last_addr_max(u64 max_vaddr, u64 last_addr)
+{
+	last_addr += 1;
+
+	if (max_vaddr <= DMA_30BIT_MASK) {
+		return ((last_addr <= DMA_30BIT_MASK) ?
+			last_addr : IOVA_START_ADDR);
+	}
+	else if (max_vaddr <= DMA_31BIT_MASK) {
+		return ((last_addr <= DMA_31BIT_MASK) ?
+			last_addr : IOVA_START_ADDR);
+	}
+	else if (max_vaddr <= DMA_32BIT_MASK) {
+		return ((last_addr <= DMA_32BIT_MASK) ?
+			last_addr : IOVA_START_ADDR);
+	}
+	return last_addr;
+
+}
+#endif
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
+
+	BUG_ON(dir == DMA_NONE);
+	addr = (void *)virt_to_phys(addr);
+
+	domain = find_domain(pdev);
+	if (unlikely(!domain)) //allocate a new one
+		domain = set_domain_for_dev(pdev,
+			DEFAULT_DOMAIN_ADDRESS_WIDTH);
+	if (!domain) {
+		printk(KERN_ERR"Allocating domain for %s failed", pci_name(pdev));
+		return 0;
+	}
+
+	/*
+	 * If the device shares a domain with other devices and the device can
+	 * handle > 4G DMA, let the device use DMA address started from 4G, so to
+	 * leave rooms for other devices
+	 */
+	if ((domain->flags & DOMAIN_FLAG_MULTIPLE_DEVICES) &&
+			pdev->dma_mask > DMA_32BIT_MASK)
+		iova = alloc_iova(domain, addr, size,
+				DMA_32BIT_MASK + 1, pdev->dma_mask);
+	else {
+#ifndef CONFIG_IOVA_NEXT_CONTIG
+		iova = alloc_iova(domain, addr, size,
+				IOVA_START_ADDR, pdev->dma_mask);
+#else
+		u64  	last_addr;
+		/*
+		 * Try to allocate consecutive address for each subsequent
+		 * allocation, to have better chance of cache usage
+		 * when entries are prefetched.
+		 */
+		last_addr = get_last_addr_max(domain->max_addr_used,
+						domain->prev_addr);
+		iova = alloc_iova(domain, addr, size, last_addr,
+					pdev->dma_mask);
+
+		/*
+		 * if allocation fails, try reallocating with lower
+		 * addr
+		 */
+		if (unlikely(!iova)) {
+			iova = alloc_iova(domain, addr, size,
+				IOVA_START_ADDR, pdev->dma_mask);
+		}
+#endif
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
+	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
+		prot |= DMA_PTE_READ;
+	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
+		prot |= DMA_PTE_WRITE;
+	/*
+	 * addr - (addr + size) might be partial page, we should map the whole
+	 * page.  Note: if two part of one page are separately mapped, we
+	 * might have two guest_addr mapping to the same host addr, but this
+	 * is not a big problem
+	 */
+	ret = domain_page_mapping(domain, iova->addr, (u64)iova->host_addr,
+		iova->size, prot);
+	if (ret)
+		goto error;
+	pr_debug("Device %s request: %lx@%llx mapping: %lx@%llx, dir %d\n",
+		pci_name(pdev), size, (u64)addr, iova->size, iova->addr, dir);
+	*flush_addr = iova->addr;
+	*flush_size = iova->size;
+	return iova->addr + (addr - iova->host_addr);
+error:
+	free_iova(domain, iova->addr);
+	printk(KERN_ERR"Device %s request: %lx@%llx dir %d --- failed\n",
+		pci_name(pdev), size, (u64)addr, dir);
+	return 0;
+}
+
+static dma_addr_t intel_map_single(struct device *dev, void *addr,
+	size_t size, int dir)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	dma_addr_t ret;
+	struct domain *domain;
+	u64 flush_addr;
+	unsigned int flush_size;
+
+	ret = __intel_map_single(dev, addr, size, dir, &flush_addr, &flush_size);
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
+	iova = find_iova(domain, dev_addr);
+	if (!iova) {
+		*flush_size = 0;
+		return;
+	}
+	pr_debug("Device %s unmapping: %lx@%llx\n",
+		pci_name(pdev), iova->size, iova->addr);
+
+	*flush_addr = iova->addr;
+	*flush_size = iova->size;
+	/* clear the whole page, not just dev_addr - (dev_addr + size) */
+	dma_pte_clear_range(domain, iova->addr, iova->addr + iova->size);
+	/* free page tables */
+	dma_pte_free_pagetable(domain, iova->addr, iova->addr + iova->size);
+	/* free iova */
+	free_iova(domain, dev_addr);
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
+	void *ret;
+	int order;
+
+	size = PAGE_ALIGN_4K(size);
+	order = get_order(size);
+	flags &= ~(GFP_DMA | GFP_DMA32);
+
+	ret = (void *)__get_free_pages(flags, order);
+	if (!ret)
+		return NULL;
+	memset(ret, 0, size);
+	*dma_handle = intel_map_single(hwdev, ret, size, DMA_BIDIRECTIONAL);
+	if (*dma_handle)
+		return ret;
+	free_pages((unsigned long)ret, order);
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
+static void * pgtable_alloc_fn(gfp_t gfp, void *pool_data)
+{
+	/* TBD: we only allocate 4K size here, should fix this for IA64 */
+	return (void *)get_zeroed_page(gfp);
+}
+
+static void pgtable_free_fn(void *element, void *pool_data)
+{
+	free_page((unsigned long)element);
+}
+
+static int iommu_init_mempool(void)
+{
+	int ret;
+
+	ret = iova_create_mempool();
+	if (ret)
+		return ret;
+	pgtable_mempool = mempool_create(MIN_PGTABLE_PAGES, pgtable_alloc_fn,
+		pgtable_free_fn, NULL);
+	if (!pgtable_mempool)
+		goto pgtable_error;
+	domain_mempool = mempool_create(MIN_DOMAIN_REQ, mempool_kzalloc,
+		mempool_kfree, (void *)sizeof(struct domain));
+	if (!domain_mempool)
+		goto domain_error;
+	devinfo_mempool = mempool_create(MIN_DEVINFO_REQ, mempool_kzalloc,
+		mempool_kfree, (void *)sizeof(struct device_domain_info));
+	if (!devinfo_mempool)
+		goto devinfo_error;
+	return 0;
+devinfo_error:
+	mempool_destroy(domain_mempool);
+domain_error:
+	mempool_destroy(pgtable_mempool);
+pgtable_error:
+	iova_destroy_mempool();
+	return -ENOMEM;
+}
+
+static void iommu_exit_mempool(void)
+{
+	mempool_destroy(devinfo_mempool);
+	mempool_destroy(domain_mempool);
+	mempool_destroy(pgtable_mempool);
+	iova_destroy_mempool();
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
+	if (no_drhd_detected())
+		return -ENODEV;
+
+	iommu_init_mempool();
+	dmar_init_reserved_ranges();
+
+	ret = init_dmars();
+	if (ret) {
+		printk(KERN_ERR "IOMMU: dmar init failed\n");
+		iommu_exit_mempool();
+		destroy_iova_list(reserved_iova_list);
+		return ret;
+	}
+	printk(KERN_INFO
+		"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
+
+	force_iommu = 1;
+	dma_ops = &intel_dma_ops;
+	return 0;
+}
+
+/* sysfs init */
+#define sysdev_to_iommu(dev) container_of(dev, struct iommu, sysdev)
+
+static int iommu_shutdown(struct sys_device * dev)
+{
+	struct iommu *iommu = sysdev_to_iommu(dev);
+
+	if (!iommu->reg)
+		return 0;
+	dmar_msi_mask(iommu->irq);
+	return 0;
+}
+
+static int iommu_suspend(struct sys_device *dev, pm_message_t state)
+{
+	struct iommu *iommu = sysdev_to_iommu(dev);
+
+	if (!iommu->reg)
+		return 0;
+	dmar_msi_read(iommu->irq, &iommu->saved_msg);
+	dmar_msi_mask(iommu->irq);
+	iommu->gcmd = 0;
+	return 0;
+}
+
+static int iommu_resume(struct sys_device * dev)
+{
+	struct iommu *iommu = sysdev_to_iommu(dev);
+
+	if (!iommu->reg)
+		return 0;
+
+	wbinvd();
+	iommu_flush_write_buffer(iommu);
+
+	/* enable primary fault log */
+	dmar_msi_write(iommu->irq, &iommu->saved_msg);
+	dmar_msi_unmask(iommu->irq);
+
+	iommu_set_root_entry(iommu);
+	iommu_flush_context_global(iommu, 0);
+	iommu_flush_iotlb_global(iommu, 0);
+
+	return iommu_enable_translation(iommu);
+}
+
+static struct sysdev_class iommu_sysdev_class = {
+	set_kset_name("intel-iommu"),
+	.shutdown = iommu_shutdown,
+	.suspend = iommu_suspend,
+	.resume = iommu_resume,
+};
+
+static int __init init_iommu_sysfs(void)
+{
+	struct dmar_drhd_unit *drhd;
+	struct iommu *iommu;
+	int i = 0;
+
+	if (dmar_disabled)
+		return 0;
+	if (sysdev_class_register(&iommu_sysdev_class))
+		return -EINVAL;
+	for_each_drhd_unit(drhd) {
+		iommu = drhd->iommu;
+		if (!iommu)
+			continue;
+		iommu->sysdev.id = i++;
+		iommu->sysdev.cls = &iommu_sysdev_class;
+		sysdev_register(&iommu->sysdev);
+	}
+	return 0;
+}
+module_init(init_iommu_sysfs);
Index: 2.6.21-rc6/drivers/pci/iova.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.21-rc6/drivers/pci/iova.c	2007-04-20 11:42:57.000000000 +0800
@@ -0,0 +1,274 @@
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
+#include <linux/mempool.h>
+#include <linux/slab.h>
+#include "iova.h"
+#define IOVA_MIN_REQ	(1024)
+
+static struct kmem_cache *iova_cachep;
+static mempool_t *iova_mempool;
+
+int iova_create_mempool(void)
+{
+	iova_cachep = kmem_cache_create("iova", sizeof(struct iova), 0,
+		SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!iova_cachep)
+		return -ENOMEM;
+	iova_mempool = mempool_create(IOVA_MIN_REQ, mempool_alloc_slab,
+		mempool_free_slab, iova_cachep);
+	if (!iova_mempool) {
+		kmem_cache_destroy(iova_cachep);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+void iova_destroy_mempool(void)
+{
+	mempool_destroy(iova_mempool);
+	kmem_cache_destroy(iova_cachep);
+}
+
+static struct iova *alloc_iova_from_pool(void)
+{
+	struct iova *iova;
+	iova = mempool_alloc(iova_mempool, GFP_ATOMIC);
+	return iova;
+}
+
+static void free_iova_to_pool(struct iova *iova)
+{
+	mempool_free(iova, iova_mempool);
+}
+
+#define aligned_size(host_addr, size) \
+	PAGE_ALIGN_4K((host_addr & (~PAGE_MASK_4K)) + size)
+#define DOMAIN_MAX_ADDR(gaw) (((u64)1) << gaw)
+struct iova *
+alloc_iova(struct domain *domain, void *host_addr, size_t size,
+		u64 start, u64 end)
+{
+	struct iova **p, *tmp, *area;
+	unsigned long addr;
+	unsigned long flags;
+
+	/* Make sure it's in range */
+	if ((start > DOMAIN_MAX_ADDR(domain->gaw)) || end < start)
+		return NULL;
+	end = min_t(u64, DOMAIN_MAX_ADDR(domain->gaw), end);
+
+	addr = PAGE_ALIGN_4K(start);
+	size = aligned_size((u64)host_addr, size);
+
+	if (!size || (addr + size > end))
+		return NULL;
+
+	area = alloc_iova_from_pool();
+
+	if (!area)
+		return NULL;
+
+#ifdef CONFIG_IOVA_GUARD_PAGE
+	/*
+	 * Always allocate a guard page for safety
+	 */
+	size += PAGE_SIZE_4K * 2;
+#endif
+
+	spin_lock_irqsave(&domain->lock, flags);
+	/* the iova list is ordered by ->addr */
+	for (p = &domain->iova; (tmp = *p) != NULL; p = &tmp->next) {
+		if ((unsigned long)tmp->addr < addr) {
+			if (tmp->addr + tmp->size > addr)
+				addr = tmp->addr + tmp->size;
+			continue;
+		}
+		/* overflow  or size fits */
+		if (((size + addr) < addr) || ((size + addr) > end) ||
+		    ((size + addr) <= (unsigned long)tmp->addr))
+		    	break;
+
+		addr = tmp->addr + tmp->size;
+	}
+	if ((addr + size) < addr || (addr + size) > end)
+		goto out;
+
+	area->next = *p;
+	*p = area;
+	/* the first page is guard page */
+#ifdef CONFIG_IOVA_GUARD_PAGE
+	area->addr = addr + PAGE_SIZE_4K;
+	area->size = size - PAGE_SIZE_4K * 2;
+#else
+	area->addr = addr;
+	area->size = size;
+#endif
+	area->host_addr = (void *)((u64)host_addr & PAGE_MASK_4K);
+	if (domain->max_addr_used < (addr+size-1))
+		domain->max_addr_used = addr + size - 1;
+	spin_unlock_irqrestore(&domain->lock, flags);
+#ifdef CONFIG_IOVA_NEXT_CONTIG
+	domain->prev_addr = addr + size - 1;
+#endif
+	return area;
+
+out:
+	spin_unlock_irqrestore(&domain->lock, flags);
+	free_iova_to_pool(area);
+	return NULL;
+}
+
+void
+free_iova(struct domain *domain, dma_addr_t addr)
+{
+	struct iova **p, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	for (p = &domain->iova; (tmp = *p) != NULL; p = &tmp->next) {
+		if (tmp->addr <= addr && (tmp->addr + tmp->size > addr))
+			goto found;
+	}
+	spin_unlock_irqrestore(&domain->lock, flags);
+	return;
+found:
+	*p = tmp->next;
+	spin_unlock_irqrestore(&domain->lock, flags);
+	free_iova_to_pool(tmp);
+}
+
+/*
+ * Just add a range of addr so we dont dish out these as iova
+ * Assume add is 4K aligned.
+ */
+struct iova *
+reserve_iova(struct domain *domain, u64 addr, size_t size)
+{
+	struct iova *area, **p, *first = NULL, *last = NULL, *tmp;
+	unsigned long flags;
+
+	if (PAGE_ALIGN_4K(addr) != addr || PAGE_ALIGN_4K(size) != size) {
+		printk ("Attempt to add unaligned addr as reserved 0x%p\n",
+			(void *)addr);
+		return NULL;
+	}
+
+	area = alloc_iova_from_pool();
+	if (!area)
+		return NULL;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	for (p = &domain->iova; (first = *p) != NULL; p = &first->next) {
+		if (first->addr + first->size >= addr)
+			break;
+	}
+	/* This isn't conflict */
+	if (first && first->addr + first->size == addr
+		&& first->flags != IOVA_RESERVED) {
+		p = &first->next;
+		first = first->next;
+	}
+	if (first) {
+		for (last = first; last != NULL; last = last->next) {
+			if (last->addr >= addr + size)
+				break;
+		}
+		/* we could merge this region */
+		if (last && last->addr == addr + size
+			&& last->flags == IOVA_RESERVED)
+			last = last->next;
+	}
+	if (!first || first == last) {
+		area->next = *p;
+		*p = area;
+		area->addr = addr;
+		area->size = size;
+		area->flags = IOVA_RESERVED;
+		spin_unlock_irqrestore(&domain->lock, flags);
+		return area;
+	}
+
+	/* conflict */
+	tmp = first;
+	while (tmp != last) {
+		if (tmp->flags != IOVA_RESERVED) {
+			spin_unlock_irqrestore(&domain->lock, flags);
+			free_iova_to_pool(area);
+			return NULL;
+		}
+		tmp = tmp->next;
+	}
+
+	area->addr = min_t(dma_addr_t, addr, first->addr);
+	while (first != last) {
+		area->size = max_t(dma_addr_t, first->addr + first->size,
+			addr + size) - area->addr;
+		tmp = first->next;
+		free_iova_to_pool(first);
+		first = tmp;
+	}
+
+	area->flags = IOVA_RESERVED;
+	*p = area;
+	area->next = last;
+	spin_unlock_irqrestore(&domain->lock, flags);
+	return area;
+}
+
+struct iova *find_iova(struct domain *domain, dma_addr_t addr)
+{
+	struct iova *tmp = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	tmp = domain->iova;
+	while (tmp) {
+		if (tmp->addr <= addr && (tmp->addr + tmp->size > addr))
+			break;
+		tmp = tmp->next;
+	}
+	spin_unlock_irqrestore(&domain->lock, flags);
+	return tmp;
+}
+
+void destroy_iova_list(struct iova *iova)
+{
+	struct iova *tmp;
+
+	while (iova) {
+		tmp = iova->next;
+		free_iova_to_pool(iova);
+		iova = tmp;
+	}
+}
+
+void destroy_iovas(struct domain *domain)
+{
+	struct iova *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&domain->lock, flags);
+	tmp = domain->iova;
+	domain->iova = NULL;
+	spin_unlock_irqrestore(&domain->lock, flags);
+
+	destroy_iova_list(tmp);
+}
Index: 2.6.21-rc6/drivers/pci/iova.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.21-rc6/drivers/pci/iova.h	2007-04-20 11:42:57.000000000 +0800
@@ -0,0 +1,56 @@
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
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/intel-iommu.h>
+
+#ifndef _IOVA_H_
+#define _IOVA_H_
+
+#define IOVA_RESERVED	(0x1)
+
+struct iova {
+	dma_addr_t	addr;
+	void		*host_addr;
+	unsigned int	flags;
+	size_t		size;
+	struct iova 	*next;
+};
+
+extern int iova_create_mempool(void);
+extern void iova_destroy_mempool(void);
+
+extern struct iova *
+alloc_iova(struct domain *domain, void *host_addr, size_t size, u64 start, u64 end);
+
+extern void
+free_iova(struct domain *domain, dma_addr_t addr);
+
+extern
+struct iova * reserve_iova(struct domain *domain, u64 addr, size_t size);
+
+extern
+struct iova *find_iova(struct domain *domain, dma_addr_t addr);
+
+extern void destroy_iovas(struct domain *domain);
+extern void destroy_iova_list(struct iova *iova);
+#endif
Index: 2.6.21-rc6/include/asm-x86_64/cacheflush.h
===================================================================
--- 2.6.21-rc6.orig/include/asm-x86_64/cacheflush.h	2007-04-20 11:03:02.000000000 +0800
+++ 2.6.21-rc6/include/asm-x86_64/cacheflush.h	2007-04-20 11:42:57.000000000 +0800
@@ -27,6 +27,7 @@
 void global_flush_tlb(void); 
 int change_page_attr(struct page *page, int numpages, pgprot_t prot);
 int change_page_attr_addr(unsigned long addr, int numpages, pgprot_t prot);
+void clflush_cache_range(void *addr, int size);
 
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
Index: 2.6.21-rc6/include/linux/intel-iommu.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.21-rc6/include/linux/intel-iommu.h	2007-04-20 11:42:57.000000000 +0800
@@ -0,0 +1,269 @@
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
+#include <linux/types.h>
+#include <linux/msi.h>
+
+#ifndef _INTEL_IOMMU_H_
+#define _INTEL_IOMMU_H_
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
+#define PAGE_SHIFT_4K		(12)
+#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
+#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
+#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
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
+#define get_context_addr(root) ((root).val & PAGE_MASK_4K)
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
+struct domain {
+	int	id;		/* domain id */
+	u64	max_addr_used;	/* keep track of max pfn used */
+	u64	prev_addr;	/* Track the last allocation to optimize */
+	struct iommu *iommu;	/* back pointer to owning iommu */
+
+	struct iova *iova;	/* Pointer to address space */
+	struct list_head devices; /* all devices' list */
+	spinlock_t	lock;	/* Lock to protect iova */
+
+	struct dma_pte	*pgd; /* virtual address */
+	spinlock_t	mapping_lock; /* page table lock */
+	int		gaw; /* max guest address width */
+	int		agaw; /* adjusted guest address width, 0 is level 2 30-bit */
+	int		flags;
+};
+
+#define DOMAIN_FLAG_MULTIPLE_DEVICES 1
+
+extern void dmar_msi_unmask(unsigned int irq);
+extern void dmar_msi_mask(unsigned int irq);
+extern void dmar_msi_read(int irq, struct msi_msg *msg);
+extern void dmar_msi_write(int irq, struct msi_msg *msg);
+extern int arch_setup_dmar_msi(unsigned int irq);
+
+extern int init_dmars(void);
+extern void detect_intel_iommu(void);
+extern int early_dmar_detect(void);
+extern int intel_iommu_init(void);
+#endif

-- 
