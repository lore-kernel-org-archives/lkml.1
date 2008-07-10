Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYGJSmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYGJSmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbYGJSlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:20499 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYGJSln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="11424547"
Message-Id: <20080710182237.197735000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:43 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 09/26] x64, x2apic/intr-remap: Interrupt remapping infrastructure
Content-Disposition: inline; filename=intr_remapping_infrastructure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interrupt remapping (part of Intel Virtualization Tech for directed I/O)
infrastructure.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/drivers/pci/intel-iommu.h
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.h	2008-07-10 09:52:01.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.h	2008-07-10 09:52:03.000000000 -0700
@@ -56,6 +56,7 @@
 #define DMAR_IQT_REG	0x88	/* Invalidation queue tail register */
 #define DMAR_IQA_REG	0x90	/* Invalidation queue addr register */
 #define DMAR_ICS_REG	0x98	/* Invalidation complete status register */
+#define DMAR_IRTA_REG	0xb8    /* Interrupt remapping table addr register */
 
 #define OFFSET_STRIDE		(9)
 /*
@@ -157,16 +158,20 @@
 #define DMA_GCMD_SRTP (((u32)1) << 30)
 #define DMA_GCMD_SFL (((u32)1) << 29)
 #define DMA_GCMD_EAFL (((u32)1) << 28)
-#define DMA_GCMD_QIE (((u32)1) << 26)
 #define DMA_GCMD_WBF (((u32)1) << 27)
+#define DMA_GCMD_QIE (((u32)1) << 26)
+#define DMA_GCMD_SIRTP (((u32)1) << 24)
+#define DMA_GCMD_IRE (((u32) 1) << 25)
 
 /* GSTS_REG */
 #define DMA_GSTS_TES (((u32)1) << 31)
 #define DMA_GSTS_RTPS (((u32)1) << 30)
 #define DMA_GSTS_FLS (((u32)1) << 29)
 #define DMA_GSTS_AFLS (((u32)1) << 28)
-#define DMA_GSTS_QIES (((u32)1) << 26)
 #define DMA_GSTS_WBFS (((u32)1) << 27)
+#define DMA_GSTS_QIES (((u32)1) << 26)
+#define DMA_GSTS_IRTPS (((u32)1) << 24)
+#define DMA_GSTS_IRES (((u32)1) << 25)
 
 /* CCMD_REG */
 #define DMA_CCMD_ICC (((u64)1) << 63)
@@ -245,6 +250,16 @@
 	int             free_cnt;
 };
 
+#ifdef CONFIG_INTR_REMAP
+/* 1MB - maximum possible interrupt remapping table size */
+#define INTR_REMAP_PAGE_ORDER	8
+#define INTR_REMAP_TABLE_REG_SIZE	0xf
+
+struct ir_table {
+	struct irte *base;
+};
+#endif
+
 struct intel_iommu {
 	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
 	u64		cap;
@@ -266,6 +281,9 @@
 	struct sys_device sysdev;
 #endif
 	struct q_inval  *qi;            /* Queued invalidation info */
+#ifdef CONFIG_INTR_REMAP
+	struct ir_table *ir_table;	/* Interrupt remapping info */
+#endif
 };
 
 static inline void __iommu_flush_cache(
@@ -279,5 +297,7 @@
 
 extern int alloc_iommu(struct dmar_drhd_unit *drhd);
 extern void free_iommu(struct intel_iommu *iommu);
+extern int dmar_enable_qi(struct intel_iommu *iommu);
+extern void qi_global_iec(struct intel_iommu *iommu);
 
 #endif
Index: tree-x86/drivers/pci/intr_remapping.c
===================================================================
--- tree-x86.orig/drivers/pci/intr_remapping.c	2008-07-10 09:51:57.000000000 -0700
+++ tree-x86/drivers/pci/intr_remapping.c	2008-07-10 09:52:03.000000000 -0700
@@ -1,10 +1,147 @@
 #include <linux/dmar.h>
+#include <linux/spinlock.h>
+#include <linux/jiffies.h>
+#include <linux/pci.h>
 #include <asm/io_apic.h>
 #include "intel-iommu.h"
 #include "intr_remapping.h"
 
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
+int intr_remapping_enabled;
+
+static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
+{
+	u64 addr;
+	u32 cmd, sts;
+	unsigned long flags;
+
+	addr = virt_to_phys((void *)iommu->ir_table->base);
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+
+	dmar_writeq(iommu->reg + DMAR_IRTA_REG,
+		    (addr) | IR_X2APIC_MODE(mode) | INTR_REMAP_TABLE_REG_SIZE);
+
+	/* Set interrupt-remapping table pointer */
+	cmd = iommu->gcmd | DMA_GCMD_SIRTP;
+	writel(cmd, iommu->reg + DMAR_GCMD_REG);
+
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
+		      readl, (sts & DMA_GSTS_IRTPS), sts);
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+
+	/*
+	 * global invalidation of interrupt entry cache before enabling
+	 * interrupt-remapping.
+	 */
+	qi_global_iec(iommu);
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+
+	/* Enable interrupt-remapping */
+	cmd = iommu->gcmd | DMA_GCMD_IRE;
+	iommu->gcmd |= DMA_GCMD_IRE;
+	writel(cmd, iommu->reg + DMAR_GCMD_REG);
+
+	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
+		      readl, (sts & DMA_GSTS_IRES), sts);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
+
+static int setup_intr_remapping(struct intel_iommu *iommu, int mode)
+{
+	struct ir_table *ir_table;
+	struct page *pages;
+
+	ir_table = iommu->ir_table = kzalloc(sizeof(struct ir_table),
+					     GFP_KERNEL);
+
+	if (!iommu->ir_table)
+		return -ENOMEM;
+
+	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, INTR_REMAP_PAGE_ORDER);
+
+	if (!pages) {
+		printk(KERN_ERR "failed to allocate pages of order %d\n",
+		       INTR_REMAP_PAGE_ORDER);
+		kfree(iommu->ir_table);
+		return -ENOMEM;
+	}
+
+	ir_table->base = page_address(pages);
+
+	iommu_set_intr_remapping(iommu, mode);
+	return 0;
+}
+
+int __init enable_intr_remapping(int eim)
+{
+	struct dmar_drhd_unit *drhd;
+	int setup = 0;
+
+	/*
+	 * check for the Interrupt-remapping support
+	 */
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		if (!ecap_ir_support(iommu->ecap))
+			continue;
+
+		if (eim && !ecap_eim_support(iommu->ecap)) {
+			printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
+			       " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
+			return -1;
+		}
+	}
+
+	/*
+	 * Enable queued invalidation for all the DRHD's.
+	 */
+	for_each_drhd_unit(drhd) {
+		int ret;
+		struct intel_iommu *iommu = drhd->iommu;
+		ret = dmar_enable_qi(iommu);
+
+		if (ret) {
+			printk(KERN_ERR "DRHD %Lx: failed to enable queued, "
+			       " invalidation, ecap %Lx, ret %d\n",
+			       drhd->reg_base_addr, iommu->ecap, ret);
+			return -1;
+		}
+	}
+
+	/*
+	 * Setup Interrupt-remapping for all the DRHD's now.
+	 */
+	for_each_drhd_unit(drhd) {
+		struct intel_iommu *iommu = drhd->iommu;
+
+		if (!ecap_ir_support(iommu->ecap))
+			continue;
+
+		if (setup_intr_remapping(iommu, eim))
+			goto error;
+
+		setup = 1;
+	}
+
+	if (!setup)
+		goto error;
+
+	intr_remapping_enabled = 1;
+
+	return 0;
+
+error:
+	/*
+	 * handle error condition gracefully here!
+	 */
+	return -1;
+}
 
 static int ir_parse_ioapic_scope(struct acpi_dmar_header *header,
 				 struct intel_iommu *iommu)
Index: tree-x86/include/linux/dmar.h
===================================================================
--- tree-x86.orig/include/linux/dmar.h	2008-07-10 09:51:57.000000000 -0700
+++ tree-x86/include/linux/dmar.h	2008-07-10 09:52:03.000000000 -0700
@@ -25,9 +25,85 @@
 #include <linux/types.h>
 #include <linux/msi.h>
 
-#ifdef CONFIG_DMAR
+#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
 struct intel_iommu;
 
+struct dmar_drhd_unit {
+	struct list_head list;		/* list of drhd units	*/
+	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
+	u64	reg_base_addr;		/* register base address*/
+	struct	pci_dev **devices; 	/* target device array	*/
+	int	devices_cnt;		/* target device count	*/
+	u8	ignored:1; 		/* ignore drhd		*/
+	u8	include_all:1;
+	struct intel_iommu *iommu;
+};
+
+extern struct list_head dmar_drhd_units;
+
+#define for_each_drhd_unit(drhd) \
+	list_for_each_entry(drhd, &dmar_drhd_units, list)
+
+extern int dmar_table_init(void);
+extern int early_dmar_detect(void);
+extern int dmar_dev_scope_init(void);
+
+/* Intel IOMMU detection */
+extern void detect_intel_iommu(void);
+
+
+extern int parse_ioapics_under_ir(void);
+extern int alloc_iommu(struct dmar_drhd_unit *);
+#else
+static inline void detect_intel_iommu(void)
+{
+	return;
+}
+
+static inline int dmar_table_init(void)
+{
+	return -ENODEV;
+}
+#endif /* !CONFIG_DMAR && !CONFIG_INTR_REMAP */
+
+#ifdef CONFIG_INTR_REMAP
+extern int intr_remapping_enabled;
+extern int enable_intr_remapping(int);
+
+struct irte {
+	union {
+		struct {
+			__u64	present 	: 1,
+				fpd		: 1,
+				dst_mode	: 1,
+				redir_hint	: 1,
+				trigger_mode	: 1,
+				dlvry_mode	: 3,
+				avail		: 4,
+				__reserved_1	: 4,
+				vector		: 8,
+				__reserved_2	: 8,
+				dest_id		: 32;
+		};
+		__u64 low;
+	};
+
+	union {
+		struct {
+			__u64	sid		: 16,
+				sq		: 2,
+				svt		: 2,
+				__reserved_3	: 44;
+		};
+		__u64 high;
+	};
+};
+#else
+#define enable_intr_remapping(mode)	(-1)
+#define intr_remapping_enabled		(0)
+#endif
+
+#ifdef CONFIG_DMAR
 extern const char *dmar_get_fault_reason(u8 fault_reason);
 
 /* Can't use the common MSI interrupt functions
@@ -40,29 +116,8 @@
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
-/* Intel IOMMU detection and initialization functions */
-extern void detect_intel_iommu(void);
-extern int intel_iommu_init(void);
-
-extern int dmar_table_init(void);
-extern int early_dmar_detect(void);
-extern int dmar_dev_scope_init(void);
-extern int parse_ioapics_under_ir(void);
-
-extern struct list_head dmar_drhd_units;
+extern int iommu_detected, no_iommu;
 extern struct list_head dmar_rmrr_units;
-
-struct dmar_drhd_unit {
-	struct list_head list;		/* list of drhd units	*/
-	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
-	u64	reg_base_addr;		/* register base address*/
-	struct	pci_dev **devices; 	/* target device array	*/
-	int	devices_cnt;		/* target device count	*/
-	u8	ignored:1; 		/* ignore drhd		*/
-	u8	include_all:1;
-	struct intel_iommu *iommu;
-};
-
 struct dmar_rmrr_unit {
 	struct list_head list;		/* list of rmrr units	*/
 	struct acpi_dmar_header *hdr;	/* ACPI header		*/
@@ -72,24 +127,19 @@
 	int	devices_cnt;		/* target device count */
 };
 
-#define for_each_drhd_unit(drhd) \
-	list_for_each_entry(drhd, &dmar_drhd_units, list)
 #define for_each_rmrr_units(rmrr) \
 	list_for_each_entry(rmrr, &dmar_rmrr_units, list)
-
-extern int alloc_iommu(struct dmar_drhd_unit *);
+/* Intel DMAR  initialization functions */
+extern int intel_iommu_init(void);
+extern int dmar_disabled;
 #else
-static inline void detect_intel_iommu(void)
-{
-	return;
-}
 static inline int intel_iommu_init(void)
 {
+#ifdef CONFIG_INTR_REMAP
+	return dmar_dev_scope_init();
+#else
 	return -ENODEV;
-}
-static inline int dmar_table_init(void)
-{
-	return -ENODEV;
+#endif
 }
 #endif /* !CONFIG_DMAR */
 #endif /* __DMAR_H__ */
Index: tree-x86/drivers/pci/dma_remapping.h
===================================================================
--- tree-x86.orig/drivers/pci/dma_remapping.h	2008-07-10 09:51:46.000000000 -0700
+++ tree-x86/drivers/pci/dma_remapping.h	2008-07-10 09:52:03.000000000 -0700
@@ -145,6 +145,8 @@
 extern int init_dmars(void);
 extern void free_dmar_iommu(struct intel_iommu *iommu);
 
+extern int dmar_disabled;
+
 #ifndef CONFIG_DMAR_GFX_WA
 static inline void iommu_prepare_gfx_mapping(void)
 {
Index: tree-x86/drivers/pci/intel-iommu.c
===================================================================
--- tree-x86.orig/drivers/pci/intel-iommu.c	2008-07-10 09:52:01.000000000 -0700
+++ tree-x86/drivers/pci/intel-iommu.c	2008-07-10 09:52:03.000000000 -0700
@@ -76,7 +76,7 @@
 
 static void domain_remove_dev_info(struct dmar_domain *domain);
 
-static int dmar_disabled;
+int dmar_disabled;
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
 static int intel_iommu_strict;
@@ -2238,15 +2238,6 @@
 
 }
 
-void __init detect_intel_iommu(void)
-{
-	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
-		return;
-	if (early_dmar_detect()) {
-		iommu_detected = 1;
-	}
-}
-
 static void __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -2293,15 +2284,19 @@
 {
 	int ret = 0;
 
-	if (no_iommu || swiotlb || dmar_disabled)
-		return -ENODEV;
-
 	if (dmar_table_init())
 		return 	-ENODEV;
 
 	if (dmar_dev_scope_init())
 		return 	-ENODEV;
 
+	/*
+	 * Check the need for DMA-remapping initialization now.
+	 * Above initialization will also be used by Interrupt-remapping.
+	 */
+	if (no_iommu || swiotlb || dmar_disabled)
+		return -ENODEV;
+
 	iommu_init_mempool();
 	dmar_init_reserved_ranges();
 
Index: tree-x86/drivers/pci/intr_remapping.h
===================================================================
--- tree-x86.orig/drivers/pci/intr_remapping.h	2008-07-10 09:51:57.000000000 -0700
+++ tree-x86/drivers/pci/intr_remapping.h	2008-07-10 09:52:03.000000000 -0700
@@ -4,3 +4,5 @@
 	struct intel_iommu *iommu;
 	unsigned int id;
 };
+
+#define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
Index: tree-x86/drivers/pci/dmar.c
===================================================================
--- tree-x86.orig/drivers/pci/dmar.c	2008-07-10 09:52:01.000000000 -0700
+++ tree-x86/drivers/pci/dmar.c	2008-07-10 09:52:03.000000000 -0700
@@ -449,6 +449,22 @@
 	return (ACPI_SUCCESS(status) ? 1 : 0);
 }
 
+void __init detect_intel_iommu(void)
+{
+	int ret;
+
+	ret = early_dmar_detect();
+
+#ifdef CONFIG_DMAR
+	{
+		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
+		    !dmar_disabled)
+			iommu_detected = 1;
+	}
+#endif
+}
+
+
 int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;

-- 

