Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbYGJSoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbYGJSoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbYGJSlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:28099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180AbYGJSlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061688"
Message-Id: <20080710182239.058438000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:56 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 22/26] x64, x2apic/intr-remap: IO-APIC support for interrupt-remapping
Content-Disposition: inline; filename=ioapic_support_for_ir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IO-APIC support in the presence of interrupt-remapping infrastructure.

IO-APIC RTE will be programmed with interrupt-remapping table entry(IRTE)
index and the IRTE will contain information about the vector, cpu destination,
trigger mode etc, which traditionally was present in the IO-APIC RTE.

Introduce a new irq_chip for cleaner irq migration (in the process
context as opposed to the current irq migration in the context of an interrupt.
interrupt-remapping infrastructure will help us achieve this cleanly).

For edge triggered, irq migration is a simple atomic update(of vector
and cpu destination) of IRTE and flush the hardware cache.

For level triggered, we need to modify the io-apic RTE aswell with the update
vector information, along with modifying IRTE with vector and cpu destination.
So irq migration for level triggered is little  bit more complex compared to
edge triggered migration. But the good news is, we use the same algorithm
for level triggered migration as we have today, only difference being,
we now initiate the irq migration from process context instead of the
interrupt context.

In future, when we do a directed EOI (combined with cpu EOI broadcast
suppression) to the IO-APIC, level triggered irq migration will also be
as simple as edge triggered migration and we can do the irq migration
with a simple atomic update to IO-APIC RTE.

TBD: some tests/changes needed in the presence of fixup_irqs() for
level triggered irq migration.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/io_apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/io_apic_64.c	2008-07-10 09:52:14.000000000 -0700
+++ tree-x86/arch/x86/kernel/io_apic_64.c	2008-07-10 09:52:31.000000000 -0700
@@ -37,6 +37,7 @@
 #include <acpi/acpi_bus.h>
 #endif
 #include <linux/bootmem.h>
+#include <linux/dmar.h>
 
 #include <asm/idle.h>
 #include <asm/io.h>
@@ -48,6 +49,7 @@
 #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
+#include <asm/irq_remapping.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
@@ -312,7 +314,12 @@
 		pin = entry->pin;
 		if (pin == -1)
 			break;
-		io_apic_write(apic, 0x11 + pin*2, dest);
+		/*
+		 * With interrupt-remapping, destination information comes
+		 * from interrupt-remapping table entry.
+		 */
+		if (!irq_remapped(irq))
+			io_apic_write(apic, 0x11 + pin*2, dest);
 		reg = io_apic_read(apic, 0x10 + pin*2);
 		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
 		reg |= vector;
@@ -906,18 +913,98 @@
 
 
 static struct irq_chip ioapic_chip;
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip ir_ioapic_chip;
+#endif
 
 static void ioapic_register_intr(int irq, unsigned long trigger)
 {
-	if (trigger) {
+	if (trigger)
 		irq_desc[irq].status |= IRQ_LEVEL;
-		set_irq_chip_and_handler_name(irq, &ioapic_chip,
-					      handle_fasteoi_irq, "fasteoi");
-	} else {
+	else
 		irq_desc[irq].status &= ~IRQ_LEVEL;
+
+#ifdef CONFIG_INTR_REMAP
+	if (irq_remapped(irq)) {
+		irq_desc[irq].status |= IRQ_MOVE_PCNTXT;
+		if (trigger)
+			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
+						      handle_fasteoi_irq,
+						     "fasteoi");
+		else
+			set_irq_chip_and_handler_name(irq, &ir_ioapic_chip,
+						      handle_edge_irq, "edge");
+		return;
+	}
+#endif
+	if (trigger)
+		set_irq_chip_and_handler_name(irq, &ioapic_chip,
+					      handle_fasteoi_irq,
+					      "fasteoi");
+	else
 		set_irq_chip_and_handler_name(irq, &ioapic_chip,
 					      handle_edge_irq, "edge");
+}
+
+static int setup_ioapic_entry(int apic, int irq,
+			      struct IO_APIC_route_entry *entry,
+			      unsigned int destination, int trigger,
+			      int polarity, int vector)
+{
+	/*
+	 * add it to the IO-APIC irq-routing table:
+	 */
+	memset(entry,0,sizeof(*entry));
+
+#ifdef CONFIG_INTR_REMAP
+	if (intr_remapping_enabled) {
+		struct intel_iommu *iommu = map_ioapic_to_ir(apic);
+		struct irte irte;
+		struct IR_IO_APIC_route_entry *ir_entry =
+			(struct IR_IO_APIC_route_entry *) entry;
+		int index;
+
+		if (!iommu)
+			panic("No mapping iommu for ioapic %d\n", apic);
+
+		index = alloc_irte(iommu, irq, 1);
+		if (index < 0)
+			panic("Failed to allocate IRTE for ioapic %d\n", apic);
+
+		memset(&irte, 0, sizeof(irte));
+
+		irte.present = 1;
+		irte.dst_mode = INT_DEST_MODE;
+		irte.trigger_mode = trigger;
+		irte.dlvry_mode = INT_DELIVERY_MODE;
+		irte.vector = vector;
+		irte.dest_id = IRTE_DEST(destination);
+
+		modify_irte(irq, &irte);
+
+		ir_entry->index2 = (index >> 15) & 0x1;
+		ir_entry->zero = 0;
+		ir_entry->format = 1;
+		ir_entry->index = (index & 0x7fff);
+	} else
+#endif
+	{
+		entry->delivery_mode = INT_DELIVERY_MODE;
+		entry->dest_mode = INT_DEST_MODE;
+		entry->dest = destination;
 	}
+
+	entry->mask = 0;				/* enable IRQ */
+	entry->trigger = trigger;
+	entry->polarity = polarity;
+	entry->vector = vector;
+
+	/* Mask level triggered irqs.
+	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
+	 */
+	if (trigger)
+		entry->mask = 1;
+	return 0;
 }
 
 static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
@@ -942,24 +1029,15 @@
 		    apic, mp_ioapics[apic].mp_apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
-	/*
-	 * add it to the IO-APIC irq-routing table:
-	 */
-	memset(&entry,0,sizeof(entry));
-
-	entry.delivery_mode = INT_DELIVERY_MODE;
-	entry.dest_mode = INT_DEST_MODE;
-	entry.dest = cpu_mask_to_apicid(mask);
-	entry.mask = 0;				/* enable IRQ */
-	entry.trigger = trigger;
-	entry.polarity = polarity;
-	entry.vector = cfg->vector;
 
-	/* Mask level triggered irqs.
-	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
-	 */
-	if (trigger)
-		entry.mask = 1;
+	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
+			       cpu_mask_to_apicid(mask), trigger, polarity,
+			       cfg->vector)) {
+		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
+		       mp_ioapics[apic].mp_apicid, pin);
+		__clear_irq_vector(irq);
+		return;
+	}
 
 	ioapic_register_intr(irq, trigger);
 	if (irq < 16)
@@ -1011,6 +1089,9 @@
 {
 	struct IO_APIC_route_entry entry;
 
+	if (intr_remapping_enabled)
+		return;
+
 	memset(&entry, 0, sizeof(entry));
 
 	/*
@@ -1466,6 +1547,147 @@
  */
 
 #ifdef CONFIG_SMP
+
+#ifdef CONFIG_INTR_REMAP
+static void ir_irq_migration(struct work_struct *work);
+
+static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
+
+/*
+ * Migrate the IO-APIC irq in the presence of intr-remapping.
+ *
+ * For edge triggered, irq migration is a simple atomic update(of vector
+ * and cpu destination) of IRTE and flush the hardware cache.
+ *
+ * For level triggered, we need to modify the io-apic RTE aswell with the update
+ * vector information, along with modifying IRTE with vector and destination.
+ * So irq migration for level triggered is little  bit more complex compared to
+ * edge triggered migration. But the good news is, we use the same algorithm
+ * for level triggered migration as we have today, only difference being,
+ * we now initiate the irq migration from process context instead of the
+ * interrupt context.
+ *
+ * In future, when we do a directed EOI (combined with cpu EOI broadcast
+ * suppression) to the IO-APIC, level triggered irq migration will also be
+ * as simple as edge triggered migration and we can do the irq migration
+ * with a simple atomic update to IO-APIC RTE.
+ */
+static void migrate_ioapic_irq(int irq, cpumask_t mask)
+{
+	struct irq_cfg *cfg = irq_cfg + irq;
+	struct irq_desc *desc = irq_desc + irq;
+	cpumask_t tmp, cleanup_mask;
+	struct irte irte;
+	int modify_ioapic_rte = desc->status & IRQ_LEVEL;
+	unsigned int dest;
+	unsigned long flags;
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
+	if (modify_ioapic_rte) {
+		spin_lock_irqsave(&ioapic_lock, flags);
+		__target_IO_APIC_irq(irq, dest, cfg->vector);
+		spin_unlock_irqrestore(&ioapic_lock, flags);
+	}
+
+	irte.vector = cfg->vector;
+	irte.dest_id = IRTE_DEST(dest);
+
+	/*
+	 * Modified the IRTE and flushes the Interrupt entry cache.
+	 */
+	modify_irte(irq, &irte);
+
+	if (cfg->move_in_progress) {
+		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cfg->move_in_progress = 0;
+	}
+
+	irq_desc[irq].affinity = mask;
+}
+
+static int migrate_irq_remapped_level(int irq)
+{
+	int ret = -1;
+
+	mask_IO_APIC_irq(irq);
+
+	if (io_apic_level_ack_pending(irq)) {
+		/*
+	 	 * Interrupt in progress. Migrating irq now will change the
+		 * vector information in the IO-APIC RTE and that will confuse
+		 * the EOI broadcast performed by cpu.
+		 * So, delay the irq migration to the next instance.
+		 */
+		schedule_delayed_work(&ir_migration_work, 1);
+		goto unmask;
+	}
+
+	/* everthing is clear. we have right of way */
+	migrate_ioapic_irq(irq, irq_desc[irq].pending_mask);
+
+	ret = 0;
+	irq_desc[irq].status &= ~IRQ_MOVE_PENDING;
+	cpus_clear(irq_desc[irq].pending_mask);
+
+unmask:
+	unmask_IO_APIC_irq(irq);
+	return ret;
+}
+
+static void ir_irq_migration(struct work_struct *work)
+{
+	int irq;
+
+	for (irq = 0; irq < NR_IRQS; irq++) {
+		struct irq_desc *desc = irq_desc + irq;
+		if (desc->status & IRQ_MOVE_PENDING) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&desc->lock, flags);
+			if (!desc->chip->set_affinity ||
+			    !(desc->status & IRQ_MOVE_PENDING)) {
+				desc->status &= ~IRQ_MOVE_PENDING;
+				spin_unlock_irqrestore(&desc->lock, flags);
+				continue;
+			}
+
+			desc->chip->set_affinity(irq,
+					         irq_desc[irq].pending_mask);
+			spin_unlock_irqrestore(&desc->lock, flags);
+		}
+	}
+}
+
+/*
+ * Migrates the IRQ destination in the process context.
+ */
+static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+{
+	if (irq_desc[irq].status & IRQ_LEVEL) {
+		irq_desc[irq].status |= IRQ_MOVE_PENDING;
+		irq_desc[irq].pending_mask = mask;
+		migrate_irq_remapped_level(irq);
+		return;
+	}
+
+	migrate_ioapic_irq(irq, mask);
+}
+#endif
+
 asmlinkage void smp_irq_move_cleanup_interrupt(void)
 {
 	unsigned vector, me;
@@ -1522,6 +1744,17 @@
 #else
 static inline void irq_complete_move(unsigned int irq) {}
 #endif
+#ifdef CONFIG_INTR_REMAP
+static void ack_x2apic_level(unsigned int irq)
+{
+	ack_x2APIC_irq();
+}
+
+static void ack_x2apic_edge(unsigned int irq)
+{
+	ack_x2APIC_irq();
+}
+#endif
 
 static void ack_apic_edge(unsigned int irq)
 {
@@ -1596,6 +1829,21 @@
 	.retrigger	= ioapic_retrigger_irq,
 };
 
+#ifdef CONFIG_INTR_REMAP
+static struct irq_chip ir_ioapic_chip __read_mostly = {
+	.name 		= "IR-IO-APIC",
+	.startup 	= startup_ioapic_irq,
+	.mask	 	= mask_IO_APIC_irq,
+	.unmask	 	= unmask_IO_APIC_irq,
+	.ack 		= ack_x2apic_edge,
+	.eoi 		= ack_x2apic_level,
+#ifdef CONFIG_SMP
+	.set_affinity 	= set_ir_ioapic_affinity_irq,
+#endif
+	.retrigger	= ioapic_retrigger_irq,
+};
+#endif
+
 static inline void init_IO_APIC_traps(void)
 {
 	int irq;
@@ -1782,6 +2030,8 @@
 	 * 8259A.
 	 */
 	if (pin1 == -1) {
+		if (intr_remapping_enabled)
+			panic("BIOS bug: timer not connected to IO-APIC");
 		pin1 = pin2;
 		apic1 = apic2;
 		no_pin1 = 1;
@@ -1808,6 +2058,8 @@
 				clear_IO_APIC_pin(0, pin1);
 			goto out;
 		}
+		if (intr_remapping_enabled)
+			panic("timer doesn't work through Interrupt-remapped IO-APIC");
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
 			apic_printk(APIC_QUIET,KERN_ERR "..MP-BIOS bug: "
@@ -2393,6 +2645,10 @@
 				setup_IO_APIC_irq(ioapic, pin, irq,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
+#ifdef CONFIG_INTR_REMAP
+			else if (intr_remapping_enabled)
+				set_ir_ioapic_affinity_irq(irq, TARGET_CPUS);
+#endif
 			else
 				set_ioapic_affinity_irq(irq, TARGET_CPUS);
 		}
Index: tree-x86/drivers/pci/intr_remapping.c
===================================================================
--- tree-x86.orig/drivers/pci/intr_remapping.c	2008-07-10 09:52:05.000000000 -0700
+++ tree-x86/drivers/pci/intr_remapping.c	2008-07-10 09:52:31.000000000 -0700
@@ -220,6 +220,16 @@
 	return 0;
 }
 
+struct intel_iommu *map_ioapic_to_ir(int apic)
+{
+	int i;
+
+	for (i = 0; i < MAX_IO_APICS; i++)
+		if (ir_ioapic[i].id == apic)
+			return ir_ioapic[i].iommu;
+	return NULL;
+}
+
 int free_irte(int irq)
 {
 	int index, i;
Index: tree-x86/include/linux/dmar.h
===================================================================
--- tree-x86.orig/include/linux/dmar.h	2008-07-10 09:52:05.000000000 -0700
+++ tree-x86/include/linux/dmar.h	2008-07-10 09:52:31.000000000 -0700
@@ -109,6 +109,7 @@
 extern int free_irte(int irq);
 
 extern int irq_remapped(int irq);
+extern struct intel_iommu *map_ioapic_to_ir(int apic);
 #else
 #define irq_remapped(irq)		(0)
 #define enable_intr_remapping(mode)	(-1)
Index: tree-x86/arch/x86/kernel/apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/apic_64.c	2008-07-10 09:52:22.000000000 -0700
+++ tree-x86/arch/x86/kernel/apic_64.c	2008-07-10 09:52:31.000000000 -0700
@@ -46,6 +46,7 @@
 static int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
 int disable_apic;
+int x2apic;
 
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
Index: tree-x86/include/asm-x86/io_apic.h
===================================================================
--- tree-x86.orig/include/asm-x86/io_apic.h	2008-07-10 09:52:11.000000000 -0700
+++ tree-x86/include/asm-x86/io_apic.h	2008-07-10 09:52:31.000000000 -0700
@@ -107,6 +107,20 @@
 
 } __attribute__ ((packed));
 
+struct IR_IO_APIC_route_entry {
+	__u64	vector		: 8,
+		zero		: 3,
+		index2		: 1,
+		delivery_status : 1,
+		polarity	: 1,
+		irr		: 1,
+		trigger		: 1,
+		mask		: 1,
+		reserved	: 31,
+		format		: 1,
+		index		: 15;
+} __attribute__ ((packed));
+
 #ifdef CONFIG_X86_IO_APIC
 
 /*
Index: tree-x86/include/asm-x86/irq_remapping.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ tree-x86/include/asm-x86/irq_remapping.h	2008-07-10 09:52:31.000000000 -0700
@@ -0,0 +1,8 @@
+#ifndef _ASM_IRQ_REMAPPING_H
+#define _ASM_IRQ_REMAPPING_H
+
+extern int x2apic;
+
+#define IRTE_DEST(dest) ((x2apic) ? dest : dest << 8)
+
+#endif
Index: tree-x86/include/asm-x86/apic.h
===================================================================
--- tree-x86.orig/include/asm-x86/apic.h	2008-07-10 09:52:22.000000000 -0700
+++ tree-x86/include/asm-x86/apic.h	2008-07-10 09:52:31.000000000 -0700
@@ -134,6 +134,15 @@
 # define apic_write_around(x, y) apic_write_atomic((x), (y))
 #endif
 
+#ifdef CONFIG_X86_64
+static inline void ack_x2APIC_irq(void)
+{
+	/* Docs say use 0 for future compatibility */
+	native_apic_msr_write(APIC_EOI, 0);
+}
+#endif
+
+
 static inline void ack_APIC_irq(void)
 {
 	/*

-- 

