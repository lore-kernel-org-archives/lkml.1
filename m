Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYLFDAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYLFDAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 22:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYLFC7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:59:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:36151 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYLFC7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:59:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=VwrSSaqR2wr37pwoo177VVXhOUDZnY9HpA+fg3xSiGPNMJow+wydTLJQnSD4lGPwDP
         S9DJTvFoRb1DfSkEu7DgpEfusGGuMxBD9i8ZEnCFFk4L0oWyQoqxxu7r3AWnLK8ZlgYx
         podsqvycIQme0/FbpKh0du0WCqYomzx6w8PBs=
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/5] pass irq_cfg and irq_desc
Date: Fri,  5 Dec 2008 18:58:34 -0800
Message-Id: <1228532315-28799-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
References: <1228532315-28799-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

impact: only need pass cfg and desc

instead of keep look up for it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/io_apic.c |  318 ++++++++++++++++++++++++++--------------------
 drivers/pci/msi.c         |   55 +++++--
 include/linux/msi.h       |    3 
 3 files changed, 222 insertions(+), 154 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -231,6 +231,10 @@ static struct irq_cfg *irq_cfg(unsigned
 
 #endif
 
+static inline void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+{
+}
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -272,11 +276,10 @@ static inline void io_apic_modify(unsign
 	writel(value, &io_apic->data);
 }
 
-static bool io_apic_level_ack_pending(unsigned int irq)
+static bool io_apic_level_ack_pending(struct irq_cfg *cfg)
 {
 	struct irq_pin_list *entry;
 	unsigned long flags;
-	struct irq_cfg *cfg = irq_cfg(irq);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	entry = cfg->irq_2_pin;
@@ -358,13 +361,12 @@ static void ioapic_mask_entry(int apic,
 }
 
 #ifdef CONFIG_SMP
-static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, u8 vector)
+static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
 {
 	int apic, pin;
-	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
+	u8 vector = cfg->vector;
 
-	cfg = irq_cfg(irq);
 	entry = cfg->irq_2_pin;
 	for (;;) {
 		unsigned int reg;
@@ -394,24 +396,27 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask);
+static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask);
 
-static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ioapic_affinity_irq_desc(struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
+	unsigned int irq;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, mask))
+	irq = desc->irq;
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 	/*
@@ -419,12 +424,20 @@ static void set_ioapic_affinity_irq(unsi
 	 */
 	dest = SET_APIC_LOGICAL_ID(dest);
 
-	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__target_IO_APIC_irq(irq, dest, cfg->vector);
+	__target_IO_APIC_irq(irq, dest, cfg);
 	desc->affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
+
+static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+{
+	struct irq_desc *desc;
+
+	desc = irq_to_desc(irq);
+
+	set_ioapic_affinity_irq_desc(desc, mask);
+}
 #endif /* CONFIG_SMP */
 
 /*
@@ -432,10 +445,9 @@ static void set_ioapic_affinity_irq(unsi
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static void add_pin_to_irq_cpu(unsigned int irq, int cpu, int apic, int pin)
+static void add_pin_to_irq_cpu(struct irq_cfg *cfg, int cpu, int apic, int pin)
 {
 	struct irq_pin_list *entry;
-	struct irq_cfg *cfg = irq_cfg(irq);
 
 	entry = cfg->irq_2_pin;
 	if (!entry) {
@@ -468,11 +480,10 @@ static void add_pin_to_irq_cpu(unsigned
 /*
  * Reroute an IRQ to a different pin.
  */
-static void __init replace_pin_at_irq(unsigned int irq, int cpu,
+static void __init replace_pin_at_irq_cpu(struct irq_cfg *cfg, int cpu,
 				      int oldapic, int oldpin,
 				      int newapic, int newpin)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
 	struct irq_pin_list *entry = cfg->irq_2_pin;
 	int replaced = 0;
 
@@ -489,18 +500,16 @@ static void __init replace_pin_at_irq(un
 
 	/* why? call replace before add? */
 	if (!replaced)
-		add_pin_to_irq_cpu(irq, cpu, newapic, newpin);
+		add_pin_to_irq_cpu(cfg, cpu, newapic, newpin);
 }
 
-static inline void io_apic_modify_irq(unsigned int irq,
+static inline void io_apic_modify_irq(struct irq_cfg *cfg,
 				int mask_and, int mask_or,
 				void (*final)(struct irq_pin_list *entry))
 {
 	int pin;
-	struct irq_cfg *cfg;
 	struct irq_pin_list *entry;
 
-	cfg = irq_cfg(irq);
 	for (entry = cfg->irq_2_pin; entry != NULL; entry = entry->next) {
 		unsigned int reg;
 		pin = entry->pin;
@@ -513,9 +522,9 @@ static inline void io_apic_modify_irq(un
 	}
 }
 
-static void __unmask_IO_APIC_irq(unsigned int irq)
+static void __unmask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED, 0, NULL);
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED, 0, NULL);
 }
 
 #ifdef CONFIG_X86_64
@@ -530,47 +539,64 @@ void io_apic_sync(struct irq_pin_list *e
 	readl(&io_apic->data);
 }
 
-static void __mask_IO_APIC_irq(unsigned int irq)
+static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
+	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
 #else /* CONFIG_X86_32 */
-static void __mask_IO_APIC_irq(unsigned int irq)
+static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~0, IO_APIC_REDIR_MASKED, NULL);
+	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, NULL);
 }
 
-static void __mask_and_edge_IO_APIC_irq(unsigned int irq)
+static void __mask_and_edge_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_LEVEL_TRIGGER,
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_LEVEL_TRIGGER,
 			IO_APIC_REDIR_MASKED, NULL);
 }
 
-static void __unmask_and_level_IO_APIC_irq(unsigned int irq)
+static void __unmask_and_level_IO_APIC_irq(struct irq_cfg *cfg)
 {
-	io_apic_modify_irq(irq, ~IO_APIC_REDIR_MASKED,
+	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED,
 			IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
 }
 #endif /* CONFIG_X86_32 */
 
-static void mask_IO_APIC_irq (unsigned int irq)
+static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
+	BUG_ON(!cfg);
+
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__mask_IO_APIC_irq(irq);
+	__mask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_IO_APIC_irq (unsigned int irq)
+static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__unmask_IO_APIC_irq(irq);
+	__unmask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
+static void mask_IO_APIC_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	mask_IO_APIC_irq_desc(desc);
+}
+static void unmask_IO_APIC_irq(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	unmask_IO_APIC_irq_desc(desc);
+}
+
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
@@ -1072,7 +1098,7 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+static int __assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1088,16 +1114,13 @@ static int __assign_irq_vector(int irq,
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	unsigned int old_vector;
 	int cpu;
-	struct irq_cfg *cfg;
 
-	cfg = irq_cfg(irq);
+	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
+		return -EBUSY;
 
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
 
-	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
-		return -EBUSY;
-
 	old_vector = cfg->vector;
 	if (old_vector) {
 		cpumask_t tmp;
@@ -1151,24 +1174,22 @@ next:
 	return -ENOSPC;
 }
 
-static int assign_irq_vector(int irq, cpumask_t mask)
+static int assign_irq_vector(int irq, struct irq_cfg *cfg, cpumask_t mask)
 {
 	int err;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, mask);
+	err = __assign_irq_vector(irq, cfg, mask);
 	spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
-static void __clear_irq_vector(int irq)
+static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 {
-	struct irq_cfg *cfg;
 	cpumask_t mask;
 	int cpu, vector;
 
-	cfg = irq_cfg(irq);
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
@@ -1257,11 +1278,8 @@ static inline int IO_APIC_irq_trigger(in
 }
 #endif
 
-static void ioapic_register_intr(int irq, unsigned long trigger)
+static void ioapic_register_intr(int irq, struct irq_desc *desc, unsigned long trigger)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
 
 	if ((trigger == IOAPIC_AUTO && IO_APIC_irq_trigger(irq)) ||
 	    trigger == IOAPIC_LEVEL)
@@ -1353,7 +1371,7 @@ static int setup_ioapic_entry(int apic,
 	return 0;
 }
 
-static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
+static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_desc *desc,
 			      int trigger, int polarity)
 {
 	struct irq_cfg *cfg;
@@ -1363,10 +1381,10 @@ static void setup_IO_APIC_irq(int apic,
 	if (!IO_APIC_IRQ(irq))
 		return;
 
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 
 	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -1383,11 +1401,11 @@ static void setup_IO_APIC_irq(int apic,
 			       cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
-		__clear_irq_vector(irq);
+		__clear_irq_vector(irq, cfg);
 		return;
 	}
 
-	ioapic_register_intr(irq, trigger);
+	ioapic_register_intr(irq, desc, trigger);
 	if (irq < NR_IRQS_LEGACY)
 		disable_8259A_irq(irq);
 
@@ -1399,6 +1417,7 @@ static void __init setup_IO_APIC_irqs(vo
 	int apic, pin, idx, irq;
 	int notcon = 0;
 	struct irq_desc *desc;
+	struct irq_cfg *cfg;
 	int cpu = boot_cpu_id;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
@@ -1436,9 +1455,10 @@ static void __init setup_IO_APIC_irqs(vo
 				printk(KERN_INFO "can not get irq_desc for %d\n", irq);
 				continue;
 			}
-			add_pin_to_irq_cpu(irq, cpu, apic, pin);
+			cfg = desc->chip_data;
+			add_pin_to_irq_cpu(cfg, cpu, apic, pin);
 
-			setup_IO_APIC_irq(apic, pin, irq,
+			setup_IO_APIC_irq(apic, pin, irq, desc,
 					irq_trigger(idx), irq_polarity(idx));
 		}
 	}
@@ -2086,7 +2106,7 @@ static unsigned int startup_ioapic_irq(u
 			was_pending = 1;
 	}
 	cfg = irq_cfg(irq);
-	__unmask_IO_APIC_irq(irq);
+	__unmask_IO_APIC_irq(cfg);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
@@ -2149,35 +2169,37 @@ static DECLARE_DELAYED_WORK(ir_migration
  * as simple as edge triggered migration and we can do the irq migration
  * with a simple atomic update to IO-APIC RTE.
  */
-static void migrate_ioapic_irq(int irq, cpumask_t mask)
+static void migrate_ioapic_irq_desc(struct irq_desc *desc, cpumask_t mask)
 {
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
 	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
+	unsigned int irq;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
+	irq = desc->irq;
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
-	desc = irq_to_desc(irq);
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
 		spin_lock_irqsave(&ioapic_lock, flags);
-		__target_IO_APIC_irq(irq, dest, cfg->vector);
+		__target_IO_APIC_irq(irq, dest, cfg);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 
@@ -2199,14 +2221,14 @@ static void migrate_ioapic_irq(int irq,
 	desc->affinity = mask;
 }
 
-static int migrate_irq_remapped_level(int irq)
+static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
 {
 	int ret = -1;
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_cfg *cfg = desc->chip_data;
 
-	mask_IO_APIC_irq(irq);
+	mask_IO_APIC_irq_desc(desc);
 
-	if (io_apic_level_ack_pending(irq)) {
+	if (io_apic_level_ack_pending(cfg)) {
 		/*
 		 * Interrupt in progress. Migrating irq now will change the
 		 * vector information in the IO-APIC RTE and that will confuse
@@ -2218,14 +2240,15 @@ static int migrate_irq_remapped_level(in
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq(irq, desc->pending_mask);
+	migrate_ioapic_irq_desc(desc, desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
 	cpus_clear(desc->pending_mask);
 
 unmask:
-	unmask_IO_APIC_irq(irq);
+	unmask_IO_APIC_irq_desc(desc);
+
 	return ret;
 }
 
@@ -2258,18 +2281,22 @@ static void ir_irq_migration(struct work
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc, cpumask_t mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
 		desc->pending_mask = mask;
-		migrate_irq_remapped_level(irq);
+		migrate_irq_remapped_level_desc(desc);
 		return;
 	}
 
-	migrate_ioapic_irq(irq, mask);
+	migrate_ioapic_irq_desc(desc, mask);
+}
+static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	set_ir_ioapic_affinity_irq_desc(desc, mask);
 }
 #endif
 
@@ -2313,9 +2340,10 @@ unlock:
 	irq_exit();
 }
 
-static void irq_complete_move(unsigned int irq)
+static void irq_complete_move(struct irq_desc **descp)
 {
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_desc *desc = *descp;
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
 	if (likely(!cfg->move_in_progress))
@@ -2333,8 +2361,9 @@ static void irq_complete_move(unsigned i
 	}
 }
 #else
-static inline void irq_complete_move(unsigned int irq) {}
+static inline void irq_complete_move(struct irq_desc **descp) {}
 #endif
+
 #ifdef CONFIG_INTR_REMAP
 static void ack_x2apic_level(unsigned int irq)
 {
@@ -2345,11 +2374,14 @@ static void ack_x2apic_edge(unsigned int
 {
 	ack_x2APIC_irq();
 }
+
 #endif
 
 static void ack_apic_edge(unsigned int irq)
 {
-	irq_complete_move(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	irq_complete_move(&desc);
 	move_native_irq(irq);
 	ack_APIC_irq();
 }
@@ -2358,18 +2390,21 @@ atomic_t irq_mis_count;
 
 static void ack_apic_level(unsigned int irq)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
+
 #ifdef CONFIG_X86_32
 	unsigned long v;
 	int i;
 #endif
+	struct irq_cfg *cfg;
 	int do_unmask_irq = 0;
 
-	irq_complete_move(irq);
+	irq_complete_move(&desc);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-	if (unlikely(irq_to_desc(irq)->status & IRQ_MOVE_PENDING)) {
+	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
-		mask_IO_APIC_irq(irq);
+		mask_IO_APIC_irq_desc(desc);
 	}
 #endif
 
@@ -2393,7 +2428,8 @@ static void ack_apic_level(unsigned int
 	* operation to prevent an edge-triggered interrupt escaping meanwhile.
 	* The idea is from Manfred Spraul.  --macro
 	*/
-	i = irq_cfg(irq)->vector;
+	cfg = desc->chip_data;
+	i = cfg->vector;
 
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
 #endif
@@ -2432,17 +2468,18 @@ static void ack_apic_level(unsigned int
 		 * accurate and is causing problems then it is a hardware bug
 		 * and you can go talk to the chipset vendor about it.
 		 */
-		if (!io_apic_level_ack_pending(irq))
+		cfg = desc->chip_data;
+		if (!io_apic_level_ack_pending(cfg))
 			move_masked_irq(irq);
-		unmask_IO_APIC_irq(irq);
+		unmask_IO_APIC_irq_desc(desc);
 	}
 
 #ifdef CONFIG_X86_32
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 		spin_lock(&ioapic_lock);
-		__mask_and_edge_IO_APIC_irq(irq);
-		__unmask_and_level_IO_APIC_irq(irq);
+		__mask_and_edge_IO_APIC_irq(cfg);
+		__unmask_and_level_IO_APIC_irq(cfg);
 		spin_unlock(&ioapic_lock);
 	}
 #endif
@@ -2533,7 +2570,7 @@ static void unmask_lapic_irq(unsigned in
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq (unsigned int irq)
+static void ack_lapic_irq(unsigned int irq)
 {
 	ack_APIC_irq();
 }
@@ -2545,11 +2582,8 @@ static struct irq_chip lapic_chip __read
 	.ack		= ack_lapic_irq,
 };
 
-static void lapic_register_intr(int irq)
+static void lapic_register_intr(int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
 	desc->status &= ~IRQ_LEVEL;
 	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
 				      "edge");
@@ -2653,7 +2687,9 @@ int timer_through_8259 __initdata;
  */
 static inline void __init check_timer(void)
 {
-	struct irq_cfg *cfg = irq_cfg(0);
+	struct irq_desc *desc = irq_to_desc(0);
+	struct irq_cfg *cfg = desc->chip_data;
+	int cpu = boot_cpu_id;
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	unsigned int ver;
@@ -2668,7 +2704,7 @@ static inline void __init check_timer(vo
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, TARGET_CPUS);
+	assign_irq_vector(0, cfg, TARGET_CPUS);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -2719,10 +2755,10 @@ static inline void __init check_timer(vo
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
 		if (no_pin1) {
-			add_pin_to_irq_cpu(0, boot_cpu_id, apic1, pin1);
+			add_pin_to_irq_cpu(cfg, cpu, apic1, pin1);
 			setup_timer_IRQ0_pin(apic1, pin1, cfg->vector);
 		}
-		unmask_IO_APIC_irq(0);
+		unmask_IO_APIC_irq_desc(desc);
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
@@ -2748,9 +2784,9 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		replace_pin_at_irq(0, boot_cpu_id, apic1, pin1, apic2, pin2);
+		replace_pin_at_irq_cpu(cfg, cpu, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		unmask_IO_APIC_irq(0);
+		unmask_IO_APIC_irq_desc(desc);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
@@ -2782,7 +2818,7 @@ static inline void __init check_timer(vo
 	apic_printk(APIC_QUIET, KERN_INFO
 		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
-	lapic_register_intr(0);
+	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
@@ -2986,7 +3022,7 @@ unsigned int create_irq_nr(unsigned int
 
 		if (cfg_new->vector != 0)
 			continue;
-		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
+		if (__assign_irq_vector(new, cfg_new, TARGET_CPUS) == 0)
 			irq = new;
 		break;
 	}
@@ -3034,7 +3070,7 @@ void destroy_irq(unsigned int irq)
 	free_irte(irq);
 #endif
 	spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq);
+	__clear_irq_vector(irq, cfg);
 	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
@@ -3049,12 +3085,12 @@ static int msi_compose_msg(struct pci_de
 	unsigned dest;
 	cpumask_t tmp;
 
+	cfg = irq_cfg(irq);
 	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	err = assign_irq_vector(irq, cfg, tmp);
 	if (err)
 		return err;
 
-	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, tmp);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3112,35 +3148,35 @@ static int msi_compose_msg(struct pci_de
 #ifdef CONFIG_SMP
 static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
-	read_msi_msg(irq, &msg);
+	read_msi_msg_desc(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	write_msi_msg(irq, &msg);
-	desc = irq_to_desc(irq);
+	write_msi_msg_desc(desc, &msg);
 	desc->affinity = mask;
 }
-
 #ifdef CONFIG_INTR_REMAP
 /*
  * Migrate the MSI irq to another cpumask. This migration is
@@ -3148,11 +3184,11 @@ static void set_msi_irq_affinity(unsigne
  */
 static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
@@ -3161,10 +3197,12 @@ static void ir_set_msi_irq_affinity(unsi
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3188,9 +3226,9 @@ static void ir_set_msi_irq_affinity(unsi
 		cfg->move_in_progress = 0;
 	}
 
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif
 #endif /* CONFIG_SMP */
 
@@ -3249,7 +3287,7 @@ static int msi_alloc_irte(struct pci_dev
 }
 #endif
 
-static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc, int irq)
+static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	int ret;
 	struct msi_msg msg;
@@ -3258,7 +3296,7 @@ static int setup_msi_irq(struct pci_dev
 	if (ret < 0)
 		return ret;
 
-	set_irq_msi(irq, desc);
+	set_irq_msi(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
 #ifdef CONFIG_INTR_REMAP
@@ -3381,20 +3419,22 @@ void arch_teardown_msi_irq(unsigned int
 #ifdef CONFIG_SMP
 static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3406,9 +3446,9 @@ static void dmar_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif /* CONFIG_SMP */
 
 struct irq_chip dmar_msi_type = {
@@ -3442,8 +3482,8 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_SMP
 static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	struct msi_msg msg;
 	unsigned int dest;
 	cpumask_t tmp;
@@ -3452,10 +3492,12 @@ static void hpet_msi_set_affinity(unsign
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
@@ -3467,9 +3509,9 @@ static void hpet_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif /* CONFIG_SMP */
 
 struct irq_chip hpet_msi_type = {
@@ -3524,26 +3566,28 @@ static void target_ht_irq(unsigned int i
 
 static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
 {
+	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
-	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	cfg = desc->chip_data;
+	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	cfg = irq_cfg(irq);
+	set_extra_move_desc(desc, mask);
+
 	cpus_and(tmp, cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	desc = irq_to_desc(irq);
 	desc->affinity = mask;
 }
+
 #endif
 
 static struct irq_chip ht_irq_chip = {
@@ -3563,13 +3607,13 @@ int arch_setup_ht_irq(unsigned int irq,
 	int err;
 	cpumask_t tmp;
 
+	cfg = irq_cfg(irq);
 	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	err = assign_irq_vector(irq, cfg, tmp);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
-		cfg = irq_cfg(irq);
 		cpus_and(tmp, cfg->domain, tmp);
 		dest = cpu_mask_to_apicid(tmp);
 
@@ -3615,7 +3659,9 @@ int arch_enable_uv_irq(char *irq_name, u
 	unsigned long flags;
 	int err;
 
-	err = assign_irq_vector(irq, *eligible_cpu);
+	cfg = irq_cfg(irq);
+
+	err = assign_irq_vector(irq, cfg, *eligible_cpu);
 	if (err != 0)
 		return err;
 
@@ -3624,8 +3670,6 @@ int arch_enable_uv_irq(char *irq_name, u
 				      irq_name);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	cfg = irq_cfg(irq);
-
 	mmr_value = 0;
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
 	BUG_ON(sizeof(struct uv_IO_APIC_route_entry) != sizeof(unsigned long));
@@ -3806,10 +3850,10 @@ int io_apic_set_pci_routing (int ioapic,
 	 */
 	if (irq >= NR_IRQS_LEGACY) {
 		cfg = desc->chip_data;
-		add_pin_to_irq_cpu(irq, cpu, ioapic, pin);
+		add_pin_to_irq_cpu(cfg, cpu, ioapic, pin);
 	}
 
-	setup_IO_APIC_irq(ioapic, pin, irq, triggering, polarity);
+	setup_IO_APIC_irq(ioapic, pin, irq, desc, triggering, polarity);
 
 	return 0;
 }
@@ -3866,7 +3910,7 @@ void __init setup_ioapic_dest(void)
 			desc = irq_to_desc(irq);
 			cfg = desc->chip_data;
 			if (!cfg->vector) {
-				setup_IO_APIC_irq(ioapic, pin, irq,
+				setup_IO_APIC_irq(ioapic, pin, irq, desc,
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
 				continue;
@@ -3884,10 +3928,10 @@ void __init setup_ioapic_dest(void)
 
 #ifdef CONFIG_INTR_REMAP
 			if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq(irq, mask);
+				set_ir_ioapic_affinity_irq_desc(desc, mask);
 			else
 #endif
-				set_ioapic_affinity_irq(irq, mask);
+				set_ioapic_affinity_irq_desc(desc, mask);
 		}
 
 	}
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -103,11 +103,11 @@ static void msix_set_enable(struct pci_d
 	}
 }
 
-static void msix_flush_writes(unsigned int irq)
+static void msix_flush_writes(struct irq_desc *desc)
 {
 	struct msi_desc *entry;
 
-	entry = get_irq_msi(irq);
+	entry = get_irq_desc_msi(desc);
 	BUG_ON(!entry || !entry->dev);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
@@ -135,11 +135,11 @@ static void msix_flush_writes(unsigned i
  * Returns 1 if it succeeded in masking the interrupt and 0 if the device
  * doesn't support MSI masking.
  */
-static int msi_set_mask_bits(unsigned int irq, u32 mask, u32 flag)
+static int msi_set_mask_bits(struct irq_desc *desc, u32 mask, u32 flag)
 {
 	struct msi_desc *entry;
 
-	entry = get_irq_msi(irq);
+	entry = get_irq_desc_msi(desc);
 	BUG_ON(!entry || !entry->dev);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
@@ -172,9 +172,9 @@ static int msi_set_mask_bits(unsigned in
 	return 1;
 }
 
-void read_msi_msg(unsigned int irq, struct msi_msg *msg)
+void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_msi(irq);
+	struct msi_desc *entry = get_irq_desc_msi(desc);
 	switch(entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
 	{
@@ -211,9 +211,16 @@ void read_msi_msg(unsigned int irq, stru
 	}
 }
 
-void write_msi_msg(unsigned int irq, struct msi_msg *msg)
+void read_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
-	struct msi_desc *entry = get_irq_msi(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	read_msi_msg_desc(desc, msg);
+}
+
+void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
+{
+	struct msi_desc *entry = get_irq_desc_msi(desc);
 	switch (entry->msi_attrib.type) {
 	case PCI_CAP_ID_MSI:
 	{
@@ -252,21 +259,31 @@ void write_msi_msg(unsigned int irq, str
 	entry->msg = *msg;
 }
 
+void write_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	write_msi_msg_desc(desc, msg);
+}
+
 void mask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bits(irq, 1, 1);
-	msix_flush_writes(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	msi_set_mask_bits(desc, 1, 1);
+	msix_flush_writes(desc);
 }
 
 void unmask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bits(irq, 1, 0);
-	msix_flush_writes(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	msi_set_mask_bits(desc, 1, 0);
+	msix_flush_writes(desc);
 }
 
 static int msi_free_irqs(struct pci_dev* dev);
 
-
 static struct msi_desc* alloc_msi_entry(void)
 {
 	struct msi_desc *entry;
@@ -303,9 +320,11 @@ static void __pci_restore_msi_state(stru
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, 0);
 	write_msi_msg(dev->irq, &entry->msg);
-	if (entry->msi_attrib.maskbit)
-		msi_set_mask_bits(dev->irq, entry->msi_attrib.maskbits_mask,
+	if (entry->msi_attrib.maskbit) {
+		struct irq_desc *desc = irq_to_desc(dev->irq);
+		msi_set_mask_bits(desc, entry->msi_attrib.maskbits_mask,
 				  entry->msi_attrib.masked);
+	}
 
 	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 	control &= ~PCI_MSI_FLAGS_QSIZE;
@@ -327,8 +346,9 @@ static void __pci_restore_msix_state(str
 	msix_set_enable(dev, 0);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
+		struct irq_desc *desc = irq_to_desc(entry->irq);
 		write_msi_msg(entry->irq, &entry->msg);
-		msi_set_mask_bits(entry->irq, 1, entry->msi_attrib.masked);
+		msi_set_mask_bits(desc, 1, entry->msi_attrib.masked);
 	}
 
 	BUG_ON(list_empty(&dev->msi_list));
@@ -596,7 +616,8 @@ void pci_msi_shutdown(struct pci_dev* de
 	/* Return the the pci reset with msi irqs unmasked */
 	if (entry->msi_attrib.maskbit) {
 		u32 mask = entry->msi_attrib.maskbits_mask;
-		msi_set_mask_bits(dev->irq, mask, ~mask);
+		struct irq_desc *desc = irq_to_desc(dev->irq);
+		msi_set_mask_bits(desc, mask, ~mask);
 	}
 	if (!entry->dev || entry->msi_attrib.type != PCI_CAP_ID_MSI)
 		return;
Index: linux-2.6/include/linux/msi.h
===================================================================
--- linux-2.6.orig/include/linux/msi.h
+++ linux-2.6/include/linux/msi.h
@@ -10,8 +10,11 @@ struct msi_msg {
 };
 
 /* Helper functions */
+struct irq_desc;
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
+extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
+extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
