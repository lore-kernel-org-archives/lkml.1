Return-Path: <linux-kernel-owner+w=401wt.eu-S1762767AbZCQAb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762767AbZCQAb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbZCQA2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:5180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760273AbZCQA2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="395024230"
Message-Id: <20090317001320.975986000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:05:01 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, rajesh.sankaran@intel.com
Subject: [patch 09/13] x86: cleanup the IO-APIC level migration with interrupt-remapping
Content-Disposition: inline; filename=ioapic_eoi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code, for level triggered migration, we need to modify the
io-apic RTE with the update vector information, along with modifying interrupt
remapping table entry(IRTE) with vector and destination. This is to ensure that
remote IRR bit inthe IOAPIC RTE gets cleared when the cpu does EOI.

With this patch, for level triggered, we eliminate the io-apic RTE modification
(with the updated vector information), by using a virtual vector (io-apic pin
number).  Real vector that is used for interrupting cpu will be coming from
the interrupt-remapping table entry. Trigger mode in the IRTE will always be
edge, and the actual level or edge trigger will be setup in the IO-APIC RTE.
So a level triggered interrupt will appear as an edge to the local apic
cpu but still as level to the IO-APIC.

With this change, level irq migration can be done by simply modifying
the interrupt-remapping table entry with out changing the io-apic RTE.
And as the interrupt appears as edge at the cpu, in addition to do the
local apic EOI, we need to do IO-APIC directed EOI to clear the remote
IRR bit in  the IO-APIC RTE.

This simplies the irq migration in the presence of interrupt-remapping.

Idea-by: Rajesh Sankaran <rajesh.sankaran@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -389,6 +389,8 @@ struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
 	unsigned int data;
+	unsigned int unused2[11];
+	unsigned int eoi;
 };
 
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
@@ -397,6 +399,12 @@ static __attribute_const__ struct io_api
 		+ (mp_ioapics[idx].apicaddr & ~PAGE_MASK);
 }
 
+static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
+{
+	struct io_apic __iomem *io_apic = io_apic_base(apic);
+	writel(vector, &io_apic->eoi);
+}
+
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
@@ -1478,7 +1486,7 @@ static void ioapic_register_intr(int irq
 int setup_ioapic_entry(int apic_id, int irq,
 		       struct IO_APIC_route_entry *entry,
 		       unsigned int destination, int trigger,
-		       int polarity, int vector)
+		       int polarity, int vector, int pin)
 {
 	/*
 	 * add it to the IO-APIC irq-routing table:
@@ -1504,7 +1512,14 @@ int setup_ioapic_entry(int apic_id, int 
 
 		irte.present = 1;
 		irte.dst_mode = apic->irq_dest_mode;
-		irte.trigger_mode = trigger;
+		/*
+		 * Trigger mode in the IRTE will always be edge, and the
+		 * actual level or edge trigger will be setup in the IO-APIC
+		 * RTE. This will help simplify level triggered irq migration.
+		 * For more details, see the comments above explainig IO-APIC
+		 * irq migration in the presence of interrupt-remapping.
+		 */
+		irte.trigger_mode = 0;
 		irte.dlvry_mode = apic->irq_delivery_mode;
 		irte.vector = vector;
 		irte.dest_id = IRTE_DEST(destination);
@@ -1515,18 +1530,23 @@ int setup_ioapic_entry(int apic_id, int 
 		ir_entry->zero = 0;
 		ir_entry->format = 1;
 		ir_entry->index = (index & 0x7fff);
+		/*
+		 * IO-APIC RTE will be configured with virtual vector.
+		 * irq handler will do the explicit EOI to the io-apic.
+		 */
+		ir_entry->vector = pin;
 	} else
 #endif
 	{
 		entry->delivery_mode = apic->irq_delivery_mode;
 		entry->dest_mode = apic->irq_dest_mode;
 		entry->dest = destination;
+		entry->vector = vector;
 	}
 
 	entry->mask = 0;				/* enable IRQ */
 	entry->trigger = trigger;
 	entry->polarity = polarity;
-	entry->vector = vector;
 
 	/* Mask level triggered irqs.
 	 * Use IRQ_DELAYED_DISABLE for edge triggered irqs.
@@ -1561,7 +1581,7 @@ static void setup_IO_APIC_irq(int apic_i
 
 
 	if (setup_ioapic_entry(mp_ioapics[apic_id].apicid, irq, &entry,
-			       dest, trigger, polarity, cfg->vector)) {
+			       dest, trigger, polarity, cfg->vector, pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic_id].apicid, pin);
 		__clear_irq_vector(irq, cfg);
@@ -2311,37 +2331,24 @@ static int ioapic_retrigger_irq(unsigned
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_INTR_REMAP
-static void ir_irq_migration(struct work_struct *work);
-
-static DECLARE_DELAYED_WORK(ir_migration_work, ir_irq_migration);
 
 /*
  * Migrate the IO-APIC irq in the presence of intr-remapping.
  *
- * For edge triggered, irq migration is a simple atomic update(of vector
- * and cpu destination) of IRTE and flush the hardware cache.
- *
- * For level triggered, we need to modify the io-apic RTE aswell with the update
- * vector information, along with modifying IRTE with vector and destination.
- * So irq migration for level triggered is little  bit more complex compared to
- * edge triggered migration. But the good news is, we use the same algorithm
- * for level triggered migration as we have today, only difference being,
- * we now initiate the irq migration from process context instead of the
- * interrupt context.
+ * For both level and edge triggered, irq migration is a simple atomic
+ * update(of vector and cpu destination) of IRTE and flush the hardware cache.
  *
- * In future, when we do a directed EOI (combined with cpu EOI broadcast
- * suppression) to the IO-APIC, level triggered irq migration will also be
- * as simple as edge triggered migration and we can do the irq migration
- * with a simple atomic update to IO-APIC RTE.
+ * For level triggered, we eliminate the io-apic RTE modification (with the
+ * updated vector information), by using a virtual vector (io-apic pin number).
+ * Real vector that is used for interrupting cpu will be coming from
+ * the interrupt-remapping table entry.
  */
 static void
 migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
-	int modify_ioapic_rte;
 	unsigned int dest;
-	unsigned long flags;
 	unsigned int irq;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
@@ -2359,13 +2366,6 @@ migrate_ioapic_irq_desc(struct irq_desc 
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
 
-	modify_ioapic_rte = desc->status & IRQ_LEVEL;
-	if (modify_ioapic_rte) {
-		spin_lock_irqsave(&ioapic_lock, flags);
-		__target_IO_APIC_irq(irq, dest, cfg);
-		spin_unlock_irqrestore(&ioapic_lock, flags);
-	}
-
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
 
@@ -2380,73 +2380,12 @@ migrate_ioapic_irq_desc(struct irq_desc 
 	cpumask_copy(desc->affinity, mask);
 }
 
-static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
-{
-	int ret = -1;
-	struct irq_cfg *cfg = desc->chip_data;
-
-	mask_IO_APIC_irq_desc(desc);
-
-	if (io_apic_level_ack_pending(cfg)) {
-		/*
-		 * Interrupt in progress. Migrating irq now will change the
-		 * vector information in the IO-APIC RTE and that will confuse
-		 * the EOI broadcast performed by cpu.
-		 * So, delay the irq migration to the next instance.
-		 */
-		schedule_delayed_work(&ir_migration_work, 1);
-		goto unmask;
-	}
-
-	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq_desc(desc, desc->pending_mask);
-
-	ret = 0;
-	desc->status &= ~IRQ_MOVE_PENDING;
-	cpumask_clear(desc->pending_mask);
-
-unmask:
-	unmask_IO_APIC_irq_desc(desc);
-
-	return ret;
-}
-
-static void ir_irq_migration(struct work_struct *work)
-{
-	unsigned int irq;
-	struct irq_desc *desc;
-
-	for_each_irq_desc(irq, desc) {
-		if (desc->status & IRQ_MOVE_PENDING) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&desc->lock, flags);
-			if (!desc->chip->set_affinity ||
-			    !(desc->status & IRQ_MOVE_PENDING)) {
-				desc->status &= ~IRQ_MOVE_PENDING;
-				spin_unlock_irqrestore(&desc->lock, flags);
-				continue;
-			}
-
-			desc->chip->set_affinity(irq, desc->pending_mask);
-			spin_unlock_irqrestore(&desc->lock, flags);
-		}
-	}
-}
-
 /*
  * Migrates the IRQ destination in the process context.
  */
 static void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 					    const struct cpumask *mask)
 {
-	if (desc->status & IRQ_LEVEL) {
-		desc->status |= IRQ_MOVE_PENDING;
-		cpumask_copy(desc->pending_mask, mask);
-		migrate_irq_remapped_level_desc(desc);
-		return;
-	}
-
 	migrate_ioapic_irq_desc(desc, mask);
 }
 static void set_ir_ioapic_affinity_irq(unsigned int irq,
@@ -2537,9 +2476,44 @@ static inline void irq_complete_move(str
 #endif
 
 #ifdef CONFIG_INTR_REMAP
+static void __eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
+{
+	int apic, pin;
+	struct irq_pin_list *entry;
+
+	entry = cfg->irq_2_pin;
+	for (;;) {
+
+		if (!entry)
+			break;
+
+		apic = entry->apic;
+		pin = entry->pin;
+		io_apic_eoi(apic, pin);
+		entry = entry->next;
+	}
+}
+
+static void
+eoi_ioapic_irq(struct irq_desc *desc)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	spin_lock_irqsave(&ioapic_lock, flags);
+	__eoi_ioapic_irq(irq, cfg);
+	spin_unlock_irqrestore(&ioapic_lock, flags);
+}
+
 static void ack_x2apic_level(unsigned int irq)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	ack_x2APIC_irq();
+	eoi_ioapic_irq(desc);
 }
 
 static void ack_x2apic_edge(unsigned int irq)
Index: tip/arch/x86/include/asm/io_apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/io_apic.h
+++ tip/arch/x86/include/asm/io_apic.h
@@ -172,7 +172,7 @@ extern void probe_nr_irqs_gsi(void);
 extern int setup_ioapic_entry(int apic, int irq,
 			      struct IO_APIC_route_entry *entry,
 			      unsigned int destination, int trigger,
-			      int polarity, int vector);
+			      int polarity, int vector, int pin);
 extern void ioapic_write_entry(int apic, int pin,
 			       struct IO_APIC_route_entry e);
 #else  /* !CONFIG_X86_IO_APIC */

-- 

