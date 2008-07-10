Return-Path: <linux-kernel-owner+w=401wt.eu-S1761643AbYGJSpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761643AbYGJSpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758661AbYGJSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:43326 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbYGJSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="11424648"
Message-Id: <20080710182239.205057000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:57 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 23/26] x64, x2apic/intr-remap: MSI and MSI-X support for interrupt remapping infrastructure
Content-Disposition: inline; filename=msi_intr_remap_support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSI and MSI-X support for interrupt remapping infrastructure.

MSI address register will be programmed with interrupt-remapping table
entry(IRTE) index and the IRTE will contain information about the vector,
cpu destination, etc.

For MSI-X, all the IRTE's will be consecutively allocated in the table,
and the address registers will contain the starting index to the block
and the data register will contain the subindex with in that block.

This also introduces a new irq_chip for cleaner irq migration (in the process
context as opposed to the current irq migration in the context of an interrupt.
interrupt-remapping infrastructure will help us achieve this).

As MSI is edge triggered, irq migration is a simple atomic update(of vector
and cpu destination) of IRTE and flushing the hardware cache.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/io_apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/io_apic_64.c	2008-07-10 09:52:31.000000000 -0700
+++ tree-x86/arch/x86/kernel/io_apic_64.c	2008-07-10 09:52:34.000000000 -0700
@@ -2289,6 +2289,9 @@
 
 	dynamic_irq_cleanup(irq);
 
+#ifdef CONFIG_INTR_REMAP
+	free_irte(irq);
+#endif
 	spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq);
 	spin_unlock_irqrestore(&vector_lock, flags);
@@ -2307,11 +2310,42 @@
 
 	tmp = TARGET_CPUS;
 	err = assign_irq_vector(irq, tmp);
-	if (!err) {
-		cpus_and(tmp, cfg->domain, tmp);
-		dest = cpu_mask_to_apicid(tmp);
+	if (err)
+		return err;
+
+	cpus_and(tmp, cfg->domain, tmp);
+	dest = cpu_mask_to_apicid(tmp);
+
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		struct irte irte;
+		int ir_index;
+		u16 sub_handle;
+
+		ir_index = map_irq_to_irte_handle(irq, &sub_handle);
+		BUG_ON(ir_index == -1);
+
+		memset (&irte, 0, sizeof(irte));
+
+		irte.present = 1;
+		irte.dst_mode = INT_DEST_MODE;
+		irte.trigger_mode = 0; /* edge */
+		irte.dlvry_mode = INT_DELIVERY_MODE;
+		irte.vector = cfg->vector;
+		irte.dest_id = IRTE_DEST(dest);
+
+		modify_irte(irq, &irte);
 
 		msg->address_hi = MSI_ADDR_BASE_HI;
+		msg->data = sub_handle;
+		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+				  MSI_ADDR_IR_SHV |
+				  MSI_ADDR_IR_INDEX1(ir_index) |
+				  MSI_ADDR_IR_INDEX2(ir_index);
+	} else
+#endif
+	{
+		msg->address_hi = MSI_ADDR_BASE_HI;
 		msg->address_lo =
 			MSI_ADDR_BASE_LO |
 			((INT_DEST_MODE == 0) ?
@@ -2361,6 +2395,55 @@
 	write_msi_msg(irq, &msg);
 	irq_desc[irq].affinity = mask;
 }
+
+#ifdef CONFIG_INTR_REMAP
+/*
+ * Migrate the MSI irq to another cpumask. This migration is
+ * done in the process context using interrupt-remapping hardware.
+ */
+static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg = irq_cfg + irq;
+	unsigned int dest;
+	cpumask_t tmp, cleanup_mask;
+	struct irte irte;
+
+	cpus_and(tmp, mask, cpu_online_map);
+	if (cpus_empty(tmp))
+		return;
+
+	if (get_irte(irq, &irte))
+		return;
+
+	if (assign_irq_vector(irq, mask))
+		return;
+
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
+
+	irte.vector = cfg->vector;
+	irte.dest_id = IRTE_DEST(dest);
+
+	/*
+	 * atomically update the IRTE with the new destination and vector.
+	 */
+	modify_irte(irq, &irte);
+
+	/*
+	 * After this point, all the interrupts will start arriving
+	 * at the new destination. So, time to cleanup the previous
+	 * vector allocation.
+	 */
+	if (cfg->move_in_progress) {
+		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cfg->move_in_progress = 0;
+	}
+
+	irq_desc[irq].affinity = mask;
+}
+#endif
 #endif /* CONFIG_SMP */
 
 /*
@@ -2378,26 +2461,157 @@
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip msi_ir_chip = {
+	.name		= "IR-PCI-MSI",
+	.unmask		= unmask_msi_irq,
+	.mask		= mask_msi_irq,
+	.ack		= ack_x2apic_edge,
+#ifdef CONFIG_SMP
+	.set_affinity	= ir_set_msi_irq_affinity,
+#endif
+	.retrigger	= ioapic_retrigger_irq,
+};
+
+/*
+ * Map the PCI dev to the corresponding remapping hardware unit
+ * and allocate 'nvec' consecutive interrupt-remapping table entries
+ * in it.
+ */
+static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 {
+	struct intel_iommu *iommu;
+	int index;
+
+	iommu = map_dev_to_ir(dev);
+	if (!iommu) {
+		printk(KERN_ERR
+		       "Unable to map PCI %s to iommu\n", pci_name(dev));
+		return -ENOENT;
+	}
+
+	index = alloc_irte(iommu, irq, nvec);
+	if (index < 0) {
+		printk(KERN_ERR
+		       "Unable to allocate %d IRTE for PCI %s\n", nvec,
+		        pci_name(dev));
+		return -ENOSPC;
+	}
+	return index;
+}
+#endif
+
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
+{
+	int ret;
 	struct msi_msg msg;
+
+	ret = msi_compose_msg(dev, irq, &msg);
+	if (ret < 0)
+		return ret;
+
+	set_irq_msi(irq, desc);
+	write_msi_msg(irq, &msg);
+
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		struct irq_desc *desc = irq_desc + irq;
+		/*
+		 * irq migration in process context
+		 */
+		desc->status |= IRQ_MOVE_PCNTXT;
+		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
+	} else
+#endif
+		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+
+	return 0;
+}
+
+int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+{
 	int irq, ret;
+
 	irq = create_irq();
 	if (irq < 0)
 		return irq;
 
-	ret = msi_compose_msg(dev, irq, &msg);
+#ifdef CONFIG_INTR_REMAP
+	if (!intr_remapping_enabled)
+		goto no_ir;
+
+	ret = msi_alloc_irte(dev, irq, 1);
+	if (ret < 0)
+		goto error;
+no_ir:
+#endif
+	ret = setup_msi_irq(dev, desc, irq);
 	if (ret < 0) {
 		destroy_irq(irq);
 		return ret;
 	}
+	return 0;
 
-	set_irq_msi(irq, desc);
-	write_msi_msg(irq, &msg);
+#ifdef CONFIG_INTR_REMAP
+error:
+	destroy_irq(irq);
+	return ret;
+#endif
+}
 
-	set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	int irq, ret, sub_handle;
+	struct msi_desc *desc;
+#ifdef CONFIG_INTR_REMAP
+	struct intel_iommu *iommu = 0;
+	int index = 0;
+#endif
 
+	sub_handle = 0;
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		irq = create_irq();
+		if (irq < 0)
+			return irq;
+#ifdef CONFIG_INTR_REMAP
+		if (!intr_remapping_enabled)
+			goto no_ir;
+
+		if (!sub_handle) {
+			/*
+			 * allocate the consecutive block of IRTE's
+			 * for 'nvec'
+			 */
+			index = msi_alloc_irte(dev, irq, nvec);
+			if (index < 0) {
+				ret = index;
+				goto error;
+			}
+		} else {
+			iommu = map_dev_to_ir(dev);
+			if (!iommu) {
+				ret = -ENOENT;
+				goto error;
+			}
+			/*
+			 * setup the mapping between the irq and the IRTE
+			 * base index, the sub_handle pointing to the
+			 * appropriate interrupt remap table entry.
+			 */
+			set_irte_irq(irq, iommu, index, sub_handle);
+		}
+no_ir:
+#endif
+		ret = setup_msi_irq(dev, desc, irq);
+		if (ret < 0)
+			goto error;
+		sub_handle++;
+	}
 	return 0;
+
+error:
+	destroy_irq(irq);
+	return ret;
 }
 
 void arch_teardown_msi_irq(unsigned int irq)
Index: tree-x86/drivers/pci/intr_remapping.c
===================================================================
--- tree-x86.orig/drivers/pci/intr_remapping.c	2008-07-10 09:52:31.000000000 -0700
+++ tree-x86/drivers/pci/intr_remapping.c	2008-07-10 09:52:34.000000000 -0700
@@ -230,6 +230,17 @@
 	return NULL;
 }
 
+struct intel_iommu *map_dev_to_ir(struct pci_dev *dev)
+{
+	struct dmar_drhd_unit *drhd;
+
+	drhd = dmar_find_matched_drhd_unit(dev);
+	if (!drhd)
+		return NULL;
+
+	return drhd->iommu;
+}
+
 int free_irte(int irq)
 {
 	int index, i;
Index: tree-x86/include/linux/dmar.h
===================================================================
--- tree-x86.orig/include/linux/dmar.h	2008-07-10 09:52:31.000000000 -0700
+++ tree-x86/include/linux/dmar.h	2008-07-10 09:52:34.000000000 -0700
@@ -109,6 +109,7 @@
 extern int free_irte(int irq);
 
 extern int irq_remapped(int irq);
+extern struct intel_iommu *map_dev_to_ir(struct pci_dev *dev);
 extern struct intel_iommu *map_ioapic_to_ir(int apic);
 #else
 #define irq_remapped(irq)		(0)
Index: tree-x86/include/asm-x86/msidef.h
===================================================================
--- tree-x86.orig/include/asm-x86/msidef.h	2008-07-10 09:51:44.000000000 -0700
+++ tree-x86/include/asm-x86/msidef.h	2008-07-10 09:52:34.000000000 -0700
@@ -48,4 +48,8 @@
 #define  MSI_ADDR_DEST_ID(dest)		(((dest) << MSI_ADDR_DEST_ID_SHIFT) & \
 					 MSI_ADDR_DEST_ID_MASK)
 
+#define MSI_ADDR_IR_EXT_INT		(1 << 4)
+#define MSI_ADDR_IR_SHV			(1 << 3)
+#define MSI_ADDR_IR_INDEX1(index)	((index & 0x8000) >> 13)
+#define MSI_ADDR_IR_INDEX2(index)	((index & 0x7fff) << 5)
 #endif /* ASM_MSIDEF_H */

-- 

