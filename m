Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbZCQAbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbZCQAbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761169AbZCQA21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:9470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759262AbZCQA2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="395024220"
Message-Id: <20090317001320.145901000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:04:55 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 03/13] enable fault handling for intr-remapping
Content-Disposition: inline; filename=enable_dmar_fault_for_interrupt_remapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable fault handling flow for intr-remapping aswell. Fault handling
code now shared by both dma-remapping and intr-remapping.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c
+++ tip/drivers/pci/dmar.c
@@ -511,6 +511,7 @@ int alloc_iommu(struct dmar_drhd_unit *d
 		return -ENOMEM;
 
 	iommu->seq_id = iommu_allocated++;
+	sprintf (iommu->name, "dmar%d", iommu->seq_id);
 
 	iommu->reg = ioremap(drhd->reg_base_addr, VTD_PAGE_SIZE);
 	if (!iommu->reg) {
@@ -817,7 +818,13 @@ int dmar_enable_qi(struct intel_iommu *i
 
 /* iommu interrupt handling. Most stuff are MSI-like. */
 
-static const char *fault_reason_strings[] =
+enum faulttype {
+	DMA_REMAP,
+	INTR_REMAP,
+	UNKNOWN,
+};
+
+static const char *dma_remap_fault_reasons[] =
 {
 	"Software",
 	"Present bit in root entry is clear",
@@ -833,14 +840,33 @@ static const char *fault_reason_strings[
 	"non-zero reserved fields in CTP",
 	"non-zero reserved fields in PTE",
 };
+
+static const char *intr_remap_fault_reasons[] =
+{
+	"Detected reserved fields in the decoded interrupt-remapped request",
+	"Interrupt index exceeded the interrupt-remapping table size",
+	"Present field in the IRTE entry is clear",
+	"Error accessing interrupt-remapping table pointed by IRTA_REG",
+	"Detected reserved fields in the IRTE entry",
+	"Blocked a compatibility format interrupt request",
+	"Blocked an interrupt request due to source-id verification failure",
+};
+
 #define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
 
-const char *dmar_get_fault_reason(u8 fault_reason)
+const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
-	if (fault_reason > MAX_FAULT_REASON_IDX)
+	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
+				     ARRAY_SIZE(intr_remap_fault_reasons))) {
+		*fault_type = INTR_REMAP;
+		return intr_remap_fault_reasons[fault_reason - 0x20];
+	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {
+		*fault_type = DMA_REMAP;
+		return dma_remap_fault_reasons[fault_reason];
+	} else {
+		*fault_type = UNKNOWN;
 		return "Unknown";
-	else
-		return fault_reason_strings[fault_reason];
+	}
 }
 
 void dmar_msi_unmask(unsigned int irq)
@@ -897,16 +923,25 @@ static int dmar_fault_do_one(struct inte
 		u8 fault_reason, u16 source_id, unsigned long long addr)
 {
 	const char *reason;
+	int fault_type;
 
-	reason = dmar_get_fault_reason(fault_reason);
+	reason = dmar_get_fault_reason(fault_reason, &fault_type);
 
-	printk(KERN_ERR
-		"DMAR:[%s] Request device [%02x:%02x.%d] "
-		"fault addr %llx \n"
-		"DMAR:[fault reason %02d] %s\n",
-		(type ? "DMA Read" : "DMA Write"),
-		(source_id >> 8), PCI_SLOT(source_id & 0xFF),
-		PCI_FUNC(source_id & 0xFF), addr, fault_reason, reason);
+	if (fault_type == INTR_REMAP)
+		printk(KERN_ERR "INTR-REMAP: Request device [[%02x:%02x.%d] "
+		       "fault index %llx\n"
+			"INTR-REMAP:[fault reason %02d] %s\n",
+			(source_id >> 8), PCI_SLOT(source_id & 0xFF),
+			PCI_FUNC(source_id & 0xFF), addr >> 48,
+			fault_reason, reason);
+	else
+		printk(KERN_ERR
+		       "DMAR:[%s] Request device [%02x:%02x.%d] "
+		       "fault addr %llx \n"
+		       "DMAR:[fault reason %02d] %s\n",
+		       (type ? "DMA Read" : "DMA Write"),
+		       (source_id >> 8), PCI_SLOT(source_id & 0xFF),
+		       PCI_FUNC(source_id & 0xFF), addr, fault_reason, reason);
 	return 0;
 }
 
@@ -920,10 +955,13 @@ static irqreturn_t dmar_fault(int irq, v
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
 	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
+	if (fault_status)
+		printk(KERN_ERR "DRHD: handling fault status reg %x\n",
+		       fault_status);
 
 	/* TBD: ignore advanced fault log currently */
 	if (!(fault_status & DMA_FSTS_PPF))
-		goto clear_overflow;
+		goto clear_rest;
 
 	fault_index = dma_fsts_fault_record_index(fault_status);
 	reg = cap_fault_reg_offset(iommu->cap);
@@ -964,11 +1002,10 @@ static irqreturn_t dmar_fault(int irq, v
 			fault_index = 0;
 		spin_lock_irqsave(&iommu->register_lock, flag);
 	}
-clear_overflow:
-	/* clear primary fault overflow */
+clear_rest:
+	/* clear all the other faults */
 	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
-	if (fault_status & DMA_FSTS_PFO)
-		writel(DMA_FSTS_PFO, iommu->reg + DMAR_FSTS_REG);
+	writel(fault_status, iommu->reg + DMAR_FSTS_REG);
 
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 	return IRQ_HANDLED;
@@ -978,6 +1015,12 @@ int dmar_set_interrupt(struct intel_iomm
 {
 	int irq, ret;
 
+	/*
+	 * Check if the fault interrupt is already initialized.
+	 */
+	if (iommu->irq)
+		return 0;
+
 	irq = create_irq();
 	if (!irq) {
 		printk(KERN_ERR "IOMMU: no free vectors\n");
@@ -1003,3 +1046,26 @@ int dmar_set_interrupt(struct intel_iomm
 		printk(KERN_ERR "IOMMU: can't request irq\n");
 	return ret;
 }
+
+int __init enable_drhd_fault_handling(void)
+{
+	struct dmar_drhd_unit *drhd;
+
+	/*
+	 * Enable fault control interrupt.
+	 */
+	for_each_drhd_unit(drhd) {
+		int ret;
+		struct intel_iommu *iommu = drhd->iommu;
+		ret = dmar_set_interrupt(iommu);
+
+		if (ret) {
+			printk(KERN_ERR "DRHD %Lx: failed to enable fault, "
+			       " interrupt, ret %d\n",
+			       (unsigned long long)drhd->reg_base_addr, ret);
+			return -1;
+		}
+	}
+
+	return 0;
+}
Index: tip/include/linux/dmar.h
===================================================================
--- tip.orig/include/linux/dmar.h
+++ tip/include/linux/dmar.h
@@ -49,6 +49,7 @@ extern int dmar_dev_scope_init(void);
 
 /* Intel IOMMU detection */
 extern void detect_intel_iommu(void);
+extern int enable_drhd_fault_handling(void);
 
 
 extern int parse_ioapics_under_ir(void);
@@ -116,9 +117,6 @@ extern struct intel_iommu *map_ioapic_to
 #define intr_remapping_enabled		(0)
 #endif
 
-#ifdef CONFIG_DMAR
-extern const char *dmar_get_fault_reason(u8 fault_reason);
-
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
  */
@@ -129,6 +127,7 @@ extern void dmar_msi_write(int irq, stru
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern int arch_setup_dmar_msi(unsigned int irq);
 
+#ifdef CONFIG_DMAR
 extern int iommu_detected, no_iommu;
 extern struct list_head dmar_rmrr_units;
 struct dmar_rmrr_unit {
Index: tip/drivers/pci/intr_remapping.c
===================================================================
--- tip.orig/drivers/pci/intr_remapping.c
+++ tip/drivers/pci/intr_remapping.c
@@ -308,7 +308,7 @@ int modify_irte(int irq, struct irte *ir
 	index = irq_iommu->irte_index + irq_iommu->sub_handle;
 	irte = &iommu->ir_table->base[index];
 
-	set_64bit((unsigned long *)irte, irte_modified->low | (1 << 1));
+	set_64bit((unsigned long *)irte, irte_modified->low);
 	__iommu_flush_cache(iommu, irte, sizeof(*irte));
 
 	rc = qi_flush_iec(iommu, index, 0);
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -3294,7 +3294,12 @@ static int msi_compose_msg(struct pci_de
 	} else
 #endif
 	{
-		msg->address_hi = MSI_ADDR_BASE_HI;
+		if (x2apic_enabled())
+			msg->address_hi = MSI_ADDR_BASE_HI |
+					  MSI_ADDR_EXT_DEST_ID(dest);
+		else
+			msg->address_hi = MSI_ADDR_BASE_HI;
+
 		msg->address_lo =
 			MSI_ADDR_BASE_LO |
 			((apic->irq_dest_mode == 0) ?
@@ -3528,7 +3533,7 @@ void arch_teardown_msi_irq(unsigned int 
 	destroy_irq(irq);
 }
 
-#ifdef CONFIG_DMAR
+#if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
 static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
Index: tip/arch/x86/include/asm/msidef.h
===================================================================
--- tip.orig/arch/x86/include/asm/msidef.h
+++ tip/arch/x86/include/asm/msidef.h
@@ -47,6 +47,7 @@
 #define	 MSI_ADDR_DEST_ID_MASK		0x00ffff0
 #define  MSI_ADDR_DEST_ID(dest)		(((dest) << MSI_ADDR_DEST_ID_SHIFT) & \
 					 MSI_ADDR_DEST_ID_MASK)
+#define MSI_ADDR_EXT_DEST_ID(dest)	((dest) & 0xffffff00)
 
 #define MSI_ADDR_IR_EXT_INT		(1 << 4)
 #define MSI_ADDR_IR_SHV			(1 << 3)
Index: tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/probe_64.c
+++ tip/arch/x86/kernel/apic/probe_64.c
@@ -68,6 +68,15 @@ void __init default_setup_apic_routing(v
 			apic = &apic_physflat;
 		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
+
+#ifdef CONFIG_X86_X2APIC
+	/*
+	 * Now that apic routing model is selected, configure the
+	 * fault handling for intr remapping.
+	 */
+	if (intr_remapping_enabled)
+		enable_drhd_fault_handling();
+#endif
 }
 
 /* Same for both flat and physical. */
Index: tip/include/linux/intel-iommu.h
===================================================================
--- tip.orig/include/linux/intel-iommu.h
+++ tip/include/linux/intel-iommu.h
@@ -292,6 +292,8 @@ struct intel_iommu {
 	spinlock_t	register_lock; /* protect register handling */
 	int		seq_id;	/* sequence id of the iommu */
 	int		agaw; /* agaw of this iommu */
+	unsigned int 	irq;
+	unsigned char 	name[13];    /* Device Name */
 
 #ifdef CONFIG_DMAR
 	unsigned long 	*domain_ids; /* bitmap of domains */
@@ -299,8 +301,6 @@ struct intel_iommu {
 	spinlock_t	lock; /* protect context, domain ids */
 	struct root_entry *root_entry; /* virtual address */
 
-	unsigned int irq;
-	unsigned char name[7];    /* Device Name */
 	struct iommu_flush flush;
 #endif
 	struct q_inval  *qi;            /* Queued invalidation info */
Index: tip/drivers/pci/intel-iommu.c
===================================================================
--- tip.orig/drivers/pci/intel-iommu.c
+++ tip/drivers/pci/intel-iommu.c
@@ -1799,7 +1799,7 @@ static int __init init_dmars(void)
 	struct dmar_rmrr_unit *rmrr;
 	struct pci_dev *pdev;
 	struct intel_iommu *iommu;
-	int i, ret, unit = 0;
+	int i, ret;
 
 	/*
 	 * for each drhd
@@ -1921,7 +1921,6 @@ static int __init init_dmars(void)
 		if (drhd->ignored)
 			continue;
 		iommu = drhd->iommu;
-		sprintf (iommu->name, "dmar%d", unit++);
 
 		iommu_flush_write_buffer(iommu);
 

-- 

