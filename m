Return-Path: <linux-kernel-owner+w=401wt.eu-S1759698AbZCQA3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759698AbZCQA3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761238AbZCQA2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:11828 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbZCQA2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="439438116"
Message-Id: <20090317001321.121117000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:05:02 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 10/13] cleanup ifdef CONFIG_INTR_REMAP in io_apic code
Content-Disposition: inline; filename=fix_ifdef_config_intr_remap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -554,16 +554,12 @@ static void __target_IO_APIC_irq(unsigne
 
 		apic = entry->apic;
 		pin = entry->pin;
-#ifdef CONFIG_INTR_REMAP
 		/*
 		 * With interrupt-remapping, destination information comes
 		 * from interrupt-remapping table entry.
 		 */
 		if (!irq_remapped(irq))
 			io_apic_write(apic, 0x11 + pin*2, dest);
-#else
-		io_apic_write(apic, 0x11 + pin*2, dest);
-#endif
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
@@ -1419,9 +1415,8 @@ void __setup_vector_irq(int cpu)
 }
 
 static struct irq_chip ioapic_chip;
-#ifdef CONFIG_INTR_REMAP
 static struct irq_chip ir_ioapic_chip;
-#endif
+static struct irq_chip msi_ir_chip;
 
 #define IOAPIC_AUTO     -1
 #define IOAPIC_EDGE     0
@@ -1460,7 +1455,6 @@ static void ioapic_register_intr(int irq
 	else
 		desc->status &= ~IRQ_LEVEL;
 
-#ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
 		desc->status |= IRQ_MOVE_PCNTXT;
 		if (trigger)
@@ -1472,7 +1466,7 @@ static void ioapic_register_intr(int irq
 						      handle_edge_irq, "edge");
 		return;
 	}
-#endif
+
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL)
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
@@ -1493,7 +1487,6 @@ int setup_ioapic_entry(int apic_id, int 
 	 */
 	memset(entry,0,sizeof(*entry));
 
-#ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled) {
 		struct intel_iommu *iommu = map_ioapic_to_ir(apic_id);
 		struct irte irte;
@@ -1535,9 +1528,7 @@ int setup_ioapic_entry(int apic_id, int 
 		 * irq handler will do the explicit EOI to the io-apic.
 		 */
 		ir_entry->vector = pin;
-	} else
-#endif
-	{
+	} else {
 		entry->delivery_mode = apic->irq_delivery_mode;
 		entry->dest_mode = apic->irq_dest_mode;
 		entry->dest = destination;
@@ -1662,10 +1653,8 @@ static void __init setup_timer_IRQ0_pin(
 {
 	struct IO_APIC_route_entry entry;
 
-#ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled)
 		return;
-#endif
 
 	memset(&entry, 0, sizeof(entry));
 
@@ -2395,6 +2384,11 @@ static void set_ir_ioapic_affinity_irq(u
 
 	set_ir_ioapic_affinity_irq_desc(desc, mask);
 }
+#else
+static inline void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
+						   const struct cpumask *mask)
+{
+}
 #endif
 
 asmlinkage void smp_irq_move_cleanup_interrupt(void)
@@ -2883,10 +2877,8 @@ static inline void __init check_timer(vo
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
-#ifdef CONFIG_INTR_REMAP
 		if (intr_remapping_enabled)
 			panic("BIOS bug: timer not connected to IO-APIC");
-#endif
 		pin1 = pin2;
 		apic1 = apic2;
 		no_pin1 = 1;
@@ -2922,10 +2914,8 @@ static inline void __init check_timer(vo
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
-#ifdef CONFIG_INTR_REMAP
 		if (intr_remapping_enabled)
 			panic("timer doesn't work through Interrupt-remapped IO-APIC");
-#endif
 		local_irq_disable();
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
@@ -3219,9 +3209,7 @@ void destroy_irq(unsigned int irq)
 	if (desc)
 		desc->chip_data = cfg;
 
-#ifdef CONFIG_INTR_REMAP
 	free_irte(irq);
-#endif
 	spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq, cfg);
 	spin_unlock_irqrestore(&vector_lock, flags);
@@ -3247,7 +3235,6 @@ static int msi_compose_msg(struct pci_de
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
 
-#ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
 		struct irte irte;
 		int ir_index;
@@ -3273,9 +3260,7 @@ static int msi_compose_msg(struct pci_de
 				  MSI_ADDR_IR_SHV |
 				  MSI_ADDR_IR_INDEX1(ir_index) |
 				  MSI_ADDR_IR_INDEX2(ir_index);
-	} else
-#endif
-	{
+	} else {
 		if (x2apic_enabled())
 			msg->address_hi = MSI_ADDR_BASE_HI |
 					  MSI_ADDR_EXT_DEST_ID(dest);
@@ -3392,6 +3377,7 @@ static struct irq_chip msi_ir_chip = {
 #endif
 	.retrigger	= ioapic_retrigger_irq,
 };
+#endif
 
 /*
  * Map the PCI dev to the corresponding remapping hardware unit
@@ -3419,7 +3405,6 @@ static int msi_alloc_irte(struct pci_dev
 	}
 	return index;
 }
-#endif
 
 static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
@@ -3433,7 +3418,6 @@ static int setup_msi_irq(struct pci_dev 
 	set_irq_msi(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
-#ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
 		struct irq_desc *desc = irq_to_desc(irq);
 		/*
@@ -3442,7 +3426,6 @@ static int setup_msi_irq(struct pci_dev 
 		desc->status |= IRQ_MOVE_PCNTXT;
 		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
 	} else
-#endif
 		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
 
 	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
@@ -3456,11 +3439,8 @@ int arch_setup_msi_irqs(struct pci_dev *
 	int ret, sub_handle;
 	struct msi_desc *msidesc;
 	unsigned int irq_want;
-
-#ifdef CONFIG_INTR_REMAP
 	struct intel_iommu *iommu = 0;
 	int index = 0;
-#endif
 
 	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
@@ -3469,7 +3449,6 @@ int arch_setup_msi_irqs(struct pci_dev *
 		if (irq == 0)
 			return -1;
 		irq_want = irq + 1;
-#ifdef CONFIG_INTR_REMAP
 		if (!intr_remapping_enabled)
 			goto no_ir;
 
@@ -3497,7 +3476,6 @@ int arch_setup_msi_irqs(struct pci_dev *
 			set_irte_irq(irq, iommu, index, sub_handle);
 		}
 no_ir:
-#endif
 		ret = setup_msi_irq(dev, msidesc, irq);
 		if (ret < 0)
 			goto error;
@@ -4032,11 +4010,9 @@ void __init setup_ioapic_dest(void)
 			else
 				mask = apic->target_cpus();
 
-#ifdef CONFIG_INTR_REMAP
 			if (intr_remapping_enabled)
 				set_ir_ioapic_affinity_irq_desc(desc, mask);
 			else
-#endif
 				set_ioapic_affinity_irq_desc(desc, mask);
 		}
 
Index: tip/include/linux/dmar.h
===================================================================
--- tip.orig/include/linux/dmar.h
+++ tip/include/linux/dmar.h
@@ -26,9 +26,8 @@
 #include <linux/msi.h>
 #include <linux/irqreturn.h>
 
-#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
 struct intel_iommu;
-
+#if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
 struct dmar_drhd_unit {
 	struct list_head list;		/* list of drhd units	*/
 	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
@@ -52,7 +51,6 @@ extern int dmar_dev_scope_init(void);
 extern void detect_intel_iommu(void);
 extern int enable_drhd_fault_handling(void);
 
-
 extern int parse_ioapics_under_ir(void);
 extern int alloc_iommu(struct dmar_drhd_unit *);
 #else
@@ -65,12 +63,12 @@ static inline int dmar_table_init(void)
 {
 	return -ENODEV;
 }
+static inline int enable_drhd_fault_handling(void)
+{
+	return -1;
+}
 #endif /* !CONFIG_DMAR && !CONFIG_INTR_REMAP */
 
-#ifdef CONFIG_INTR_REMAP
-extern int intr_remapping_enabled;
-extern int enable_intr_remapping(int);
-
 struct irte {
 	union {
 		struct {
@@ -99,6 +97,10 @@ struct irte {
 		__u64 high;
 	};
 };
+#ifdef CONFIG_INTR_REMAP
+extern int intr_remapping_enabled;
+extern int enable_intr_remapping(int);
+
 extern int get_irte(int irq, struct irte *entry);
 extern int modify_irte(int irq, struct irte *irte_modified);
 extern int alloc_irte(struct intel_iommu *iommu, int irq, u16 count);
@@ -113,6 +115,35 @@ extern int irq_remapped(int irq);
 extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
 extern struct intel_iommu *map_ioapic_to_ir(int apic);
 #else
+static inline int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+{
+	return -1;
+}
+static inline int modify_irte(int irq, struct irte *irte_modified)
+{
+	return -1;
+}
+static inline int free_irte(int irq)
+{
+	return -1;
+}
+static inline int map_irq_to_irte_handle(int irq, u16 *sub_handle)
+{
+	return -1;
+}
+static inline int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index,
+			       u16 sub_handle)
+{
+	return -1;
+}
+static inline struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
+{
+	return NULL;
+}
+static inline struct intel_iommu *map_ioapic_to_ir(int apic)
+{
+	return NULL;
+}
 #define irq_remapped(irq)		(0)
 #define enable_intr_remapping(mode)	(-1)
 #define intr_remapping_enabled		(0)
Index: tip/arch/x86/kernel/apic/probe_64.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/probe_64.c
+++ tip/arch/x86/kernel/apic/probe_64.c
@@ -69,14 +69,12 @@ void __init default_setup_apic_routing(v
 		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 
-#ifdef CONFIG_X86_X2APIC
 	/*
 	 * Now that apic routing model is selected, configure the
 	 * fault handling for intr remapping.
 	 */
 	if (intr_remapping_enabled)
 		enable_drhd_fault_handling();
-#endif
 }
 
 /* Same for both flat and physical. */

-- 

