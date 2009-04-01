Return-Path: <linux-kernel-owner+w=401wt.eu-S933457AbZDAVKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbZDAVKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759813AbZDAVKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:10:20 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:38633 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755705AbZDAVKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:10:18 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] x86: Support for multiple MSI
Date: Wed,  1 Apr 2009 17:10:09 -0400
Message-Id: <1238620209-11980-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function __assign_irq_vector_block() which allocates an aligned
block of vectors suitable for multiple-MSI.
Change create_irq_nr, msi_compose_msg and setup_msi_irq to take a 'count'.
Split arch_setup_msi_irqs() into setup_msi_irqs and setup_msix_irqs.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/x86/include/asm/pci.h     |    1 +
 arch/x86/kernel/apic/io_apic.c |  390 +++++++++++++++++++++++++++++++---------
 arch/x86/kernel/dumpstack.c    |    1 +
 include/linux/irq.h            |    2 +-
 4 files changed, 310 insertions(+), 84 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index a0301bf..7fcb9ab 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -88,6 +88,7 @@ extern void pci_iommu_alloc(void);
 
 /* MSI arch hook */
 #define arch_setup_msi_irqs arch_setup_msi_irqs
+#define arch_teardown_msi_irqs arch_teardown_msi_irqs
 
 #endif  /* __KERNEL__ */
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1bb5c6c..df055e8 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -572,6 +572,41 @@ static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq
 
 static int
 assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
+static int
+assign_irq_vector_block(int irq, unsigned count, const struct cpumask *mask);
+
+/*
+ * The P6 family and Pentium processors (presumably also earlier processors),
+ * can queue no more than two interrupts per priority level, and will ignore
+ * other interrupts that are received within the same priority level (the
+ * priority level is the vector number shifted right by 4), so we try to
+ * spread these out a bit to avoid this happening.
+ *
+ * Pentium 4, Xeon and later processors do not have this limitation.
+ * It is unknown what limitations AMD, Cyrix, Transmeta, VIA, IDT and
+ * other manufacturers have.
+ */
+static int many_vectors_per_prio(void)
+{
+	struct cpuinfo_x86 *c;
+	static char init, result;
+	if (init)
+		return result;
+
+	c = &boot_cpu_data;
+	switch (c->x86_vendor) {
+	case X86_VENDOR_INTEL:
+		if (c->x86 > 6 ||
+		    ((c->x86 == 6) && (c->x86_model >= 13)))
+			result = 1;
+		break;
+	default:
+		break;
+	}
+
+	init = 1;
+	return result;
+}
 
 /*
  * Either sets desc->affinity to a valid value, and returns
@@ -589,13 +624,30 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return BAD_APICID;
 
-	/* check that before desc->addinity get updated */
-	set_extra_move_desc(desc, mask);
+	if (many_vectors_per_prio()) {
+		struct msi_desc *msi_desc = desc->msi_desc;
+		unsigned i, count = 1;
 
-	cpumask_copy(desc->affinity, mask);
+		if (msi_desc)
+			count = 1 << msi_desc->msi_attrib.multiple;
+
+		/* Multiple MSIs all go to the same destination */
+		if (assign_irq_vector_block(irq, count, mask))
+			return BAD_APICID;
+		for (i = 0; i < count; i++) {
+			desc = irq_to_desc(irq + i);
+			set_extra_move_desc(desc, mask);
+			cpumask_copy(desc->affinity, mask);
+		}
+	} else {
+		if (assign_irq_vector(irq, cfg, mask))
+			return BAD_APICID;
+
+		/* check that before desc->addinity get updated */
+		set_extra_move_desc(desc, mask);
+		cpumask_copy(desc->affinity, mask);
+	}
 
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
 }
@@ -1285,18 +1337,7 @@ void unlock_vector_lock(void)
 static int
 __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
-	/*
-	 * NOTE! The local APIC isn't very good at handling
-	 * multiple interrupts at the same interrupt level.
-	 * As the interrupt level is determined by taking the
-	 * vector number and shifting that right by 4, we
-	 * want to spread these out a bit so that they don't
-	 * all fall in the same interrupt level.
-	 *
-	 * Also, we've got to be careful not to trash gate
-	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
-	 */
-	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
+	static int current_vector = FIRST_DEVICE_VECTOR;
 	unsigned int old_vector;
 	int cpu, err;
 	cpumask_var_t tmp_mask;
@@ -1321,19 +1362,15 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	err = -ENOSPC;
 	for_each_cpu_and(cpu, mask, cpu_online_mask) {
 		int new_cpu;
-		int vector, offset;
+		int vector;
 
 		apic->vector_allocation_domain(cpu, tmp_mask);
 
 		vector = current_vector;
-		offset = current_offset;
 next:
-		vector += 8;
-		if (vector >= first_system_vector) {
-			/* If out of vectors on large boxen, must share them. */
-			offset = (offset + 1) % 8;
-			vector = FIRST_DEVICE_VECTOR + offset;
-		}
+		vector += 4;
+		if (vector >= first_system_vector)
+			vector = FIRST_DEVICE_VECTOR;
 		if (unlikely(current_vector == vector))
 			continue;
 
@@ -1345,7 +1382,6 @@ next:
 				goto next;
 		/* Found one! */
 		current_vector = vector;
-		current_offset = offset;
 		if (old_vector) {
 			cfg->move_in_progress = 1;
 			cpumask_copy(cfg->old_domain, cfg->domain);
@@ -1362,13 +1398,113 @@ next:
 }
 
 static int
+__assign_irq_vector_block(int irq, unsigned count, const struct cpumask *mask)
+{
+	static int current_vector = FIRST_DEVICE_VECTOR;
+	unsigned int old_vector;
+	unsigned i, cpu;
+	int err;
+	struct irq_cfg *cfg;
+	cpumask_var_t tmp_mask;
+
+	BUG_ON(irq + count > NR_IRQS);
+	BUG_ON(count & (count - 1));
+
+	for (i = 0; i < count; i++) {
+		cfg = irq_cfg(irq + i);
+		if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+			return -EBUSY;
+	}
+
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return -ENOMEM;
+
+	cfg = irq_cfg(irq);
+	old_vector = cfg->vector;
+	if (old_vector) {
+		err = 0;
+		cpumask_and(tmp_mask, mask, cpu_online_mask);
+		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
+		if (!cpumask_empty(tmp_mask))
+			goto out;
+	}
+
+	/* Only try and allocate irqs on cpus that are present */
+	err = -ENOSPC;
+	for_each_cpu_and(cpu, mask, cpu_online_mask) {
+		int new_cpu;
+		int vector;
+
+		apic->vector_allocation_domain(cpu, tmp_mask);
+
+		vector = current_vector & ~(count - 1);
+next:
+		vector += count;
+		if (vector + count >= first_system_vector) {
+			vector = FIRST_DEVICE_VECTOR & ~(count - 1);
+			if (vector < FIRST_DEVICE_VECTOR)
+				vector += count;
+		}
+		if (unlikely((current_vector & ~(count - 1)) == vector))
+			continue;
+
+		for (i = 0; i < count; i++)
+			if (test_bit(vector + i, used_vectors))
+				goto next;
+
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask) {
+			for (i = 0; i < count; i++) {
+				if (per_cpu(vector_irq, new_cpu)[vector + i]
+									!= -1)
+					goto next;
+			}
+		}
+		/* Found one! */
+		current_vector = vector + count - 1;
+		for (i = 0; i < count; i++) {
+			cfg = irq_cfg(irq + i);
+			if (old_vector) {
+				cfg->move_in_progress = 1;
+				cpumask_copy(cfg->old_domain, cfg->domain);
+			}
+			for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+				per_cpu(vector_irq, new_cpu)[vector + i] =
+									irq + i;
+			cfg->vector = vector;
+			cpumask_copy(cfg->domain, tmp_mask);
+		}
+		err = 0;
+		break;
+	}
+ out:
+	free_cpumask_var(tmp_mask);
+	return err;
+}
+
+static int
 assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, cfg, mask);
+	if (many_vectors_per_prio())
+		err = __assign_irq_vector_block(irq, 1, mask);
+	else
+		err = __assign_irq_vector(irq, cfg, mask);
+	spin_unlock_irqrestore(&vector_lock, flags);
+	return err;
+}
+
+/* Assumes that count is a power of two and aligns to that power of two */
+static int
+assign_irq_vector_block(int irq, unsigned count, const struct cpumask *mask)
+{
+	int err;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vector_lock, flags);
+	err = __assign_irq_vector_block(irq, count, mask);
 	spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
@@ -3166,59 +3302,75 @@ device_initcall(ioapic_init_sysfs);
 static int nr_irqs_gsi = NR_IRQS_LEGACY;
 /*
  * Dynamic irq allocate and deallocation
+ *
+ * Returns the interrupt number created, or 0 on error
  */
-unsigned int create_irq_nr(unsigned int irq_want)
+unsigned int create_irq_nr(unsigned int irq_want, unsigned count)
 {
-	/* Allocate an unused irq */
-	unsigned int irq;
-	unsigned int new;
+	/* Allocate 'count' consecutive unused irqs */
+	unsigned i, irq, new, run;
 	unsigned long flags;
 	struct irq_cfg *cfg_new = NULL;
 	int cpu = boot_cpu_id;
 	struct irq_desc *desc_new = NULL;
 
-	irq = 0;
+	if (count > 1 && !many_vectors_per_prio())
+		return 0;
+
+	irq = run = 0;
+
 	if (irq_want < nr_irqs_gsi)
 		irq_want = nr_irqs_gsi;
 
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new < nr_irqs; new++) {
+		int err;
 		desc_new = irq_to_desc_alloc_cpu(new, cpu);
 		if (!desc_new) {
 			printk(KERN_INFO "can not get irq_desc for %d\n", new);
-			continue;
+			goto retry;
 		}
 		cfg_new = desc_new->chip_data;
 
 		if (cfg_new->vector != 0)
+			goto retry;
+		run++;
+		if (run < count)
 			continue;
-		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
-			irq = new;
-		break;
+
+		irq = new - run + 1;
+		if (many_vectors_per_prio())
+			err = __assign_irq_vector_block(irq, run,
+							apic->target_cpus());
+		else
+			err = __assign_irq_vector(irq, cfg_new,
+							apic->target_cpus());
+		if (err == 0)
+			break;
+		irq = 0;
+ retry:
+		run = 0;
 	}
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (irq > 0) {
-		dynamic_irq_init(irq);
+	if (irq == 0)
+		return 0;
+
+	for (i = 0; i < count; i++) {
+		desc_new = irq_to_desc(irq + i);
+		cfg_new = desc_new->chip_data;
+		dynamic_irq_init(irq + i);
 		/* restore it, in case dynamic_irq_init clear it */
-		if (desc_new)
-			desc_new->chip_data = cfg_new;
+		desc_new->chip_data = cfg_new;
 	}
+
 	return irq;
 }
 
 int create_irq(void)
 {
-	unsigned int irq_want;
-	int irq;
-
-	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want);
-
-	if (irq == 0)
-		irq = -1;
-
-	return irq;
+	int irq = create_irq_nr(nr_irqs_gsi, 1);
+	return irq ? irq : -1;
 }
 
 void destroy_irq(unsigned int irq)
@@ -3245,7 +3397,8 @@ void destroy_irq(unsigned int irq)
  * MSI message composition
  */
 #ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
+static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+					unsigned count, struct msi_msg *msg)
 {
 	struct irq_cfg *cfg;
 	int err;
@@ -3255,7 +3408,10 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (count == 1)
+		err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	else
+		err = assign_irq_vector_block(irq, count, apic->target_cpus());
 	if (err)
 		return err;
 
@@ -3432,52 +3588,107 @@ static int msi_alloc_irte(struct pci_dev *dev, int irq, int nvec)
 	return index;
 }
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
+					unsigned count, unsigned base_irq)
 {
 	int ret;
 	struct msi_msg msg;
+	unsigned irq;
 
-	ret = msi_compose_msg(dev, irq, &msg);
+	ret = msi_compose_msg(dev, base_irq, count, &msg);
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, msidesc);
-	write_msi_msg(irq, &msg);
+	msidesc->msi_attrib.multiple = order_base_2(count);
 
-	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_to_desc(irq);
-		/*
-		 * irq migration in process context
-		 */
-		desc->status |= IRQ_MOVE_PCNTXT;
-		set_irq_chip_and_handler_name(irq, &msi_ir_chip, handle_edge_irq, "edge");
-	} else
-		set_irq_chip_and_handler_name(irq, &msi_chip, handle_edge_irq, "edge");
+	/*
+	 * The loop is in reverse order so set_irq_msi ends up setting
+	 * desc->irq to base_irq
+	 */
+	for (irq = base_irq + count - 1; irq >= base_irq; irq--) {
+		set_irq_msi(irq, msidesc);
+		if (irq_remapped(irq)) {
+			struct irq_desc *desc = irq_to_desc(irq);
+			desc->status |= IRQ_MOVE_PCNTXT;
+			set_irq_chip_and_handler_name(irq, &msi_ir_chip,
+						handle_edge_irq, "edge");
+		} else {
+			set_irq_chip_and_handler_name(irq, &msi_chip,
+						handle_edge_irq, "edge");
+		}
+	}
+
+	write_msi_msg(base_irq, &msg);
 
-	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", irq);
+	dev_printk(KERN_DEBUG, &dev->dev, "irq %d for MSI/MSI-X\n", base_irq);
 
 	return 0;
 }
 
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+static int setup_msi_irqs(struct pci_dev *dev, int nvec)
+{
+	unsigned base_irq, alloc, i;
+	int ret;
+	struct msi_desc *msidesc = list_first_entry(&dev->msi_list,
+							struct msi_desc, list);
+	struct intel_iommu *iommu = map_dev_to_ir(dev);
+
+	if (intr_remapping_enabled && !iommu)
+		return -ENOENT;
+	if (nvec > 1 && !many_vectors_per_prio())
+		return 1;
+
+	/*
+	 * MSI only lets you program the device with nvec that is a power
+	 * of two.  We could possibly trust the device driver that it'll
+	 * only use the number it asked for, but to be safe, let's reserve
+	 * all the interrupts we're telling the device it can use.
+	 */
+	alloc = roundup_pow_of_two(nvec);
+
+	base_irq = create_irq_nr(nr_irqs_gsi, alloc);
+	if (base_irq == 0)
+		return (alloc > 1) ? alloc / 2 : -ENOSPC;
+
+	if (intr_remapping_enabled) {
+		ret = msi_alloc_irte(dev, base_irq, alloc);
+		if (ret < 0)
+			goto error;
+
+		for (i = 1; i < alloc; i++)
+			set_irte_irq(base_irq + i, iommu, ret, i);
+	}
+
+	ret = setup_msi_irq(dev, msidesc, alloc, base_irq);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	for (i = 0; i < alloc; i++)
+		destroy_irq(base_irq + i);
+	return ret;
+}
+
+static int setup_msix_irqs(struct pci_dev *dev, int nvec)
 {
 	unsigned int irq;
 	int ret, sub_handle;
 	struct msi_desc *msidesc;
 	unsigned int irq_want;
-	struct intel_iommu *iommu = NULL;
+	struct intel_iommu *iommu = map_dev_to_ir(dev);
 	int index = 0;
 
-	/* x86 doesn't support multiple MSI yet */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
+	if (intr_remapping_enabled && !iommu)
+		return -ENOENT;
 
 	irq_want = nr_irqs_gsi;
 	sub_handle = 0;
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
-		irq = create_irq_nr(irq_want);
+		irq = create_irq_nr(irq_want, 1);
 		if (irq == 0)
-			return -1;
+			return -ENOSPC;
 		irq_want = irq + 1;
 		if (!intr_remapping_enabled)
 			goto no_ir;
@@ -3493,11 +3704,6 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 				goto error;
 			}
 		} else {
-			iommu = map_dev_to_ir(dev);
-			if (!iommu) {
-				ret = -ENOENT;
-				goto error;
-			}
 			/*
 			 * setup the mapping between the irq and the IRTE
 			 * base index, the sub_handle pointing to the
@@ -3506,7 +3712,7 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 			set_irte_irq(irq, iommu, index, sub_handle);
 		}
 no_ir:
-		ret = setup_msi_irq(dev, msidesc, irq);
+		ret = setup_msi_irq(dev, msidesc, 1, irq);
 		if (ret < 0)
 			goto error;
 		sub_handle++;
@@ -3518,9 +3724,27 @@ error:
 	return ret;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	if (type == PCI_CAP_ID_MSI) {
+		return setup_msi_irqs(dev, nvec);
+	} else {
+		return setup_msix_irqs(dev, nvec);
+	}
+}
+
+void arch_teardown_msi_irqs(struct pci_dev *dev)
 {
-	destroy_irq(irq);
+	struct msi_desc *desc;
+	unsigned i;
+
+	list_for_each_entry(desc, &dev->msi_list, list) {
+		if (desc->irq == 0)
+			continue;
+		for (i = 0; i < (1 << desc->msi_attrib.multiple); i++) {
+			destroy_irq(desc->irq + i);
+		}
+	}
 }
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
@@ -3566,7 +3790,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 	int ret;
 	struct msi_msg msg;
 
-	ret = msi_compose_msg(NULL, irq, &msg);
+	ret = msi_compose_msg(NULL, irq, 1, &msg);
 	if (ret < 0)
 		return ret;
 	dmar_msi_write(irq, &msg);
@@ -3620,7 +3844,7 @@ int arch_setup_hpet_msi(unsigned int irq)
 	int ret;
 	struct msi_msg msg;
 
-	ret = msi_compose_msg(NULL, irq, &msg);
+	ret = msi_compose_msg(NULL, irq, 1, &msg);
 	if (ret < 0)
 		return ret;
 
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index dd2130b..0c77a09 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -29,6 +29,7 @@ void printk_address(unsigned long address, int reliable)
 {
 	printk(" [<%p>] %s%pS\n", (void *) address,
 			reliable ? "" : "? ", (void *) address);
+	mdelay(2000);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 974890b..f77e53b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -381,7 +381,7 @@ extern void set_irq_noprobe(unsigned int irq);
 extern void set_irq_probe(unsigned int irq);
 
 /* Handle dynamic irq creation and destruction */
-extern unsigned int create_irq_nr(unsigned int irq_want);
+extern unsigned int create_irq_nr(unsigned int irq_want, unsigned count);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
 
-- 
1.6.2

