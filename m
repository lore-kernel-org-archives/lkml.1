Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab0CDKLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:11:17 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57437 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab0CDKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:10:21 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 04 Mar 2010 02:08:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/12] x86: make irq_chip to use desc_mask instead of mask
In-reply-to: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1267697339-5491-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

core irq_chip ...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/i8259.h   |    2 +-
 arch/x86/include/asm/irq.h     |    4 +-
 arch/x86/kernel/apic/io_apic.c |  314 ++++++++++++++++------------------------
 arch/x86/kernel/i8259.c        |   45 +++---
 arch/x86/kernel/irq.c          |   19 ++-
 5 files changed, 165 insertions(+), 219 deletions(-)

diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index 1655147..0b2ad6f 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -58,7 +58,7 @@ struct legacy_pic {
 	void (*mask_all)(void);
 	void (*restore_mask)(void);
 	void (*init)(int auto_eoi);
-	int (*irq_pending)(unsigned int irq);
+	int (*irq_pending)(struct irq_desc *desc);
 	void (*make_irq)(unsigned int irq);
 };
 
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 64c5f6f..078e449 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -31,15 +31,15 @@ static inline int irq_canonicalize(int irq)
 # endif
 #endif
 
+struct irq_desc;
 #ifdef CONFIG_HOTPLUG_CPU
 #include <linux/cpumask.h>
 extern void fixup_irqs(void);
-extern void irq_force_complete_move(int);
+void irq_force_complete_move(struct irq_desc *desc);
 #endif
 
 extern void (*x86_platform_ipi_callback)(void);
 extern void native_init_IRQ(void);
-struct irq_desc;
 extern bool handle_irq(struct irq_desc *desc, struct pt_regs *regs);
 
 extern unsigned int do_IRQ(struct pt_regs *regs);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ddcf4fa..44fc842 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -176,18 +176,6 @@ int __init arch_early_irq_init(void)
 }
 
 #ifdef CONFIG_SPARSE_IRQ
-struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	struct irq_cfg *cfg = NULL;
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-	if (desc)
-		cfg = desc->chip_data;
-
-	return cfg;
-}
-
 static struct irq_cfg *get_one_free_irq_cfg(int node)
 {
 	struct irq_cfg *cfg;
@@ -326,13 +314,6 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 	}
 }
 /* end for move_irq_desc */
-
-#else
-struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	return irq < nr_irqs ? irq_cfgx + irq : NULL;
-}
-
 #endif
 
 struct io_apic {
@@ -580,7 +561,7 @@ static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
 
-static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
+static void mask_IO_APIC_irq(struct irq_desc *desc)
 {
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
@@ -592,7 +573,7 @@ static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
+static void unmask_IO_APIC_irq(struct irq_desc *desc)
 {
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
@@ -602,19 +583,6 @@ static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void mask_IO_APIC_irq(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	mask_IO_APIC_irq_desc(desc);
-}
-static void unmask_IO_APIC_irq(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	unmask_IO_APIC_irq_desc(desc);
-}
-
 static void clear_IO_APIC_pin(unsigned int apic, unsigned int pin)
 {
 	struct IO_APIC_route_entry entry;
@@ -1470,7 +1438,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 
 	ioapic_register_intr(irq, desc, trigger);
 	if (irq < legacy_pic->nr_legacy_irqs)
-		legacy_pic->chip->mask(irq);
+		desc_chip_mask(legacy_pic->chip, irq, desc);
 
 	ioapic_write_entry(apic_id, pin, entry);
 }
@@ -2267,29 +2235,29 @@ static int __init timer_irq_works(void)
  * an edge even if it isn't on the 8259A...
  */
 
-static unsigned int startup_ioapic_irq(unsigned int irq)
+static unsigned int startup_ioapic_irq(struct irq_desc *desc)
 {
 	int was_pending = 0;
 	unsigned long flags;
 	struct irq_cfg *cfg;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
-	if (irq < legacy_pic->nr_legacy_irqs) {
-		legacy_pic->chip->mask(irq);
-		if (legacy_pic->irq_pending(irq))
+	if (desc->irq < legacy_pic->nr_legacy_irqs) {
+		desc_chip_mask(legacy_pic->chip, -1, desc);
+		if (legacy_pic->irq_pending(desc))
 			was_pending = 1;
 	}
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 	__unmask_IO_APIC_irq(cfg);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
 }
 
-static int ioapic_retrigger_irq(unsigned int irq)
+static int ioapic_retrigger_irq(struct irq_desc *desc)
 {
 
-	struct irq_cfg *cfg = irq_cfg(irq);
+	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
@@ -2374,7 +2342,7 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask,
 }
 
 static int
-set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+set_ioapic_affinity_irq(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
@@ -2397,16 +2365,6 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	return ret;
 }
 
-static int
-set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
-{
-	struct irq_desc *desc;
-
-	desc = irq_to_desc(irq);
-
-	return set_ioapic_affinity_irq_desc(desc, mask);
-}
-
 #ifdef CONFIG_INTR_REMAP
 
 /*
@@ -2421,7 +2379,7 @@ set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
  * the interrupt-remapping table entry.
  */
 static int
-migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+migrate_ioapic_irq(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
@@ -2461,20 +2419,13 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 /*
  * Migrates the IRQ destination in the process context.
  */
-static int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
+static int set_ir_ioapic_affinity_irq(struct irq_desc *desc,
 					    const struct cpumask *mask)
 {
-	return migrate_ioapic_irq_desc(desc, mask);
-}
-static int set_ir_ioapic_affinity_irq(unsigned int irq,
-				       const struct cpumask *mask)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	return set_ir_ioapic_affinity_irq_desc(desc, mask);
+	return migrate_ioapic_irq(desc, mask);
 }
 #else
-static inline int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
+static inline int set_ir_ioapic_affinity_irq(struct irq_desc *desc,
 						   const struct cpumask *mask)
 {
 	return 0;
@@ -2532,9 +2483,8 @@ unlock:
 	irq_exit();
 }
 
-static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
+static void __irq_complete_move(struct irq_desc *desc, unsigned vector)
 {
-	struct irq_desc *desc = *descp;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned me;
 
@@ -2547,28 +2497,25 @@ static void __irq_complete_move(struct irq_desc **descp, unsigned vector)
 		send_cleanup_vector(cfg);
 }
 
-static void irq_complete_move(struct irq_desc **descp)
+static void irq_complete_move(struct irq_desc *desc)
 {
-	__irq_complete_move(descp, ~get_irq_regs()->orig_ax);
+	__irq_complete_move(desc, ~get_irq_regs()->orig_ax);
 }
 
-void irq_force_complete_move(int irq)
+void irq_force_complete_move(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg = desc->chip_data;
 
-	__irq_complete_move(&desc, cfg->vector);
+	__irq_complete_move(desc, cfg->vector);
 }
 #else
-static inline void irq_complete_move(struct irq_desc **descp) {}
+static inline void irq_complete_move(struct irq_desc *desc) {}
 #endif
 
-static void ack_apic_edge(unsigned int irq)
+static void ack_apic_edge(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	irq_complete_move(&desc);
-	move_native_irq(irq);
+	irq_complete_move(desc);
+	move_native_irq_desc(desc);
 	ack_APIC_irq();
 }
 
@@ -2627,20 +2574,19 @@ static void eoi_ioapic_irq(struct irq_desc *desc)
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void ack_apic_level(unsigned int irq)
+static void ack_apic_level(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 	int i;
 	struct irq_cfg *cfg;
 	int do_unmask_irq = 0;
 
-	irq_complete_move(&desc);
+	irq_complete_move(desc);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(desc->status & IRQ_MOVE_PENDING)) {
 		do_unmask_irq = 1;
-		mask_IO_APIC_irq_desc(desc);
+		mask_IO_APIC_irq(desc);
 	}
 #endif
 
@@ -2729,52 +2675,50 @@ static void ack_apic_level(unsigned int irq)
 		 */
 		cfg = desc->chip_data;
 		if (!io_apic_level_ack_pending(cfg))
-			move_masked_irq(irq);
-		unmask_IO_APIC_irq_desc(desc);
+			move_masked_irq_desc(desc);
+		unmask_IO_APIC_irq(desc);
 	}
 }
 
 #ifdef CONFIG_INTR_REMAP
-static void ir_ack_apic_edge(unsigned int irq)
+static void ir_ack_apic_edge(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
-static void ir_ack_apic_level(unsigned int irq)
+static void ir_ack_apic_level(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	ack_APIC_irq();
 	eoi_ioapic_irq(desc);
 }
 #endif /* CONFIG_INTR_REMAP */
 
 static struct irq_chip ioapic_chip __read_mostly = {
-	.name		= "IO-APIC",
-	.startup	= startup_ioapic_irq,
-	.mask		= mask_IO_APIC_irq,
-	.unmask		= unmask_IO_APIC_irq,
-	.ack		= ack_apic_edge,
-	.eoi		= ack_apic_level,
+	.name			= "IO-APIC",
+	.desc_startup		= startup_ioapic_irq,
+	.desc_mask		= mask_IO_APIC_irq,
+	.desc_unmask		= unmask_IO_APIC_irq,
+	.desc_ack		= ack_apic_edge,
+	.desc_eoi		= ack_apic_level,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_ioapic_affinity_irq,
+	.desc_set_affinity	= set_ioapic_affinity_irq,
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 static struct irq_chip ir_ioapic_chip __read_mostly = {
-	.name		= "IR-IO-APIC",
-	.startup	= startup_ioapic_irq,
-	.mask		= mask_IO_APIC_irq,
-	.unmask		= unmask_IO_APIC_irq,
+	.name			= "IR-IO-APIC",
+	.desc_startup		= startup_ioapic_irq,
+	.desc_mask		= mask_IO_APIC_irq,
+	.desc_unmask		= unmask_IO_APIC_irq,
 #ifdef CONFIG_INTR_REMAP
-	.ack		= ir_ack_apic_edge,
-	.eoi		= ir_ack_apic_level,
+	.desc_ack		= ir_ack_apic_edge,
+	.desc_eoi		= ir_ack_apic_level,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_ir_ioapic_affinity_irq,
+	.desc_set_affinity	= set_ir_ioapic_affinity_irq,
 #endif
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 static inline void init_IO_APIC_traps(void)
@@ -2815,7 +2759,7 @@ static inline void init_IO_APIC_traps(void)
  * The local APIC irq-chip implementation:
  */
 
-static void mask_lapic_irq(unsigned int irq)
+static void mask_lapic_irq(struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2823,7 +2767,7 @@ static void mask_lapic_irq(unsigned int irq)
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+static void unmask_lapic_irq(struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2831,16 +2775,16 @@ static void unmask_lapic_irq(unsigned int irq)
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void ack_lapic_irq(unsigned int irq)
+static void ack_lapic_irq(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
 static struct irq_chip lapic_chip __read_mostly = {
 	.name		= "local-APIC",
-	.mask		= mask_lapic_irq,
-	.unmask		= unmask_lapic_irq,
-	.ack		= ack_lapic_irq,
+	.desc_mask	= mask_lapic_irq,
+	.desc_unmask	= unmask_lapic_irq,
+	.desc_ack	= ack_lapic_irq,
 };
 
 static void lapic_register_intr(int irq, struct irq_desc *desc)
@@ -2960,7 +2904,7 @@ static inline void __init check_timer(void)
 	/*
 	 * get/set the timer IRQ vector:
 	 */
-	legacy_pic->chip->mask(0);
+	desc_chip_mask(legacy_pic->chip, 0, desc);
 	assign_irq_vector(desc, cfg, apic->target_cpus());
 
 	/*
@@ -3027,12 +2971,12 @@ static inline void __init check_timer(void)
 			int idx;
 			idx = find_irq_entry(apic1, pin1, mp_INT);
 			if (idx != -1 && irq_trigger(idx))
-				unmask_IO_APIC_irq_desc(desc);
+				unmask_IO_APIC_irq(desc);
 		}
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
 				setup_nmi();
-				legacy_pic->chip->unmask(0);
+				desc_chip_unmask(legacy_pic->chip, 0, desc);
 			}
 			if (disable_timer_pin_1 > 0)
 				clear_IO_APIC_pin(apic1, pin1);
@@ -3055,14 +2999,14 @@ static inline void __init check_timer(void)
 		 */
 		replace_pin_at_irq_node(cfg, node, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
-		legacy_pic->chip->unmask(0);
+		desc_chip_unmask(legacy_pic->chip, 0, desc);
 		if (timer_irq_works()) {
 			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
 			timer_through_8259 = 1;
 			if (nmi_watchdog == NMI_IO_APIC) {
-				legacy_pic->chip->mask(0);
+				desc_chip_mask(legacy_pic->chip, 0, desc);
 				setup_nmi();
-				legacy_pic->chip->unmask(0);
+				desc_chip_unmask(legacy_pic->chip, 0, desc);
 			}
 			goto out;
 		}
@@ -3070,7 +3014,7 @@ static inline void __init check_timer(void)
 		 * Cleanup, just in case ...
 		 */
 		local_irq_disable();
-		legacy_pic->chip->mask(0);
+		desc_chip_mask(legacy_pic->chip, 0, desc);
 		clear_IO_APIC_pin(apic2, pin2);
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
@@ -3089,14 +3033,14 @@ static inline void __init check_timer(void)
 
 	lapic_register_intr(0, desc);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
-	legacy_pic->chip->unmask(0);
+	desc_chip_unmask(legacy_pic->chip, 0, desc);
 
 	if (timer_irq_works()) {
 		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
 	local_irq_disable();
-	legacy_pic->chip->mask(0);
+	desc_chip_mask(legacy_pic->chip, 0, desc);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
 
@@ -3298,7 +3242,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	if (irq > 0)
-		dynamic_irq_init_keep_chip_data(irq);
+		dynamic_irq_init_keep_chip_data(irq_to_desc(irq));
 
 	return irq;
 }
@@ -3324,7 +3268,7 @@ void destroy_irq(unsigned int irq)
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
 
-	dynamic_irq_cleanup_keep_chip_data(irq);
+	dynamic_irq_cleanup_keep_chip_data(irq_to_desc(irq));
 
 	free_irte(irq);
 	raw_spin_lock_irqsave(&vector_lock, flags);
@@ -3338,10 +3282,10 @@ void destroy_irq(unsigned int irq)
  * MSI message composition
  */
 #ifdef CONFIG_PCI_MSI
-static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
+static int msi_compose_msg(struct pci_dev *pdev, struct irq_desc *desc,
 			   struct msi_msg *msg, u8 hpet_id)
 {
-	struct irq_desc *desc;
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
@@ -3349,7 +3293,6 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 	if (disable_apic)
 		return -ENXIO;
 
-	desc = irq_to_desc(irq);
 	cfg = desc->chip_data;
 	err = assign_irq_vector(desc, cfg, apic->target_cpus());
 	if (err)
@@ -3417,9 +3360,8 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
 }
 
 #ifdef CONFIG_SMP
-static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3446,9 +3388,9 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
  * done in the process context using interrupt-remapping hardware.
  */
 static int
-ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+ir_set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	struct irte irte;
@@ -3486,27 +3428,27 @@ ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
  * which implement the MSI or MSI-X Capability Structure.
  */
 static struct irq_chip msi_chip = {
-	.name		= "PCI-MSI",
-	.unmask		= unmask_msi_irq,
-	.mask		= mask_msi_irq,
-	.ack		= ack_apic_edge,
+	.name			= "PCI-MSI",
+	.desc_unmask		= unmask_msi_irq_desc,
+	.desc_mask		= mask_msi_irq_desc,
+	.desc_ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_msi_irq_affinity,
+	.desc_set_affinity	= set_msi_irq_affinity,
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 static struct irq_chip msi_ir_chip = {
-	.name		= "IR-PCI-MSI",
-	.unmask		= unmask_msi_irq,
-	.mask		= mask_msi_irq,
+	.name			= "IR-PCI-MSI",
+	.desc_unmask		= unmask_msi_irq_desc,
+	.desc_mask		= mask_msi_irq_desc,
 #ifdef CONFIG_INTR_REMAP
-	.ack		= ir_ack_apic_edge,
+	.desc_ack		= ir_ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity	= ir_set_msi_irq_affinity,
+	.desc_set_affinity	= ir_set_msi_irq_affinity,
 #endif
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 /*
@@ -3540,8 +3482,9 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(dev, irq, &msg, -1);
+	ret = msi_compose_msg(dev, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
 
@@ -3549,7 +3492,6 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	write_msi_msg(irq, &msg);
 
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_to_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -3631,9 +3573,8 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3643,14 +3584,14 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	dmar_msi_read(irq, &msg);
+	dmar_msi_read_desc(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	dmar_msi_write(irq, &msg);
+	dmar_msi_write_desc(desc, &msg);
 
 	return 0;
 }
@@ -3658,25 +3599,26 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 #endif /* CONFIG_SMP */
 
 static struct irq_chip dmar_msi_type = {
-	.name = "DMAR_MSI",
-	.unmask = dmar_msi_unmask,
-	.mask = dmar_msi_mask,
-	.ack = ack_apic_edge,
+	.name			= "DMAR_MSI",
+	.desc_unmask		= dmar_msi_unmask_desc,
+	.desc_mask		= dmar_msi_mask_desc,
+	.desc_ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity = dmar_msi_set_affinity,
+	.desc_set_affinity	= dmar_msi_set_affinity,
 #endif
-	.retrigger = ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 int arch_setup_dmar_msi(unsigned int irq)
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(NULL, irq, &msg, -1);
+	ret = msi_compose_msg(NULL, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
-	dmar_msi_write(irq, &msg);
+	dmar_msi_write_desc(desc, &msg);
 	set_irq_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
 		"edge");
 	return 0;
@@ -3686,9 +3628,8 @@ int arch_setup_dmar_msi(unsigned int irq)
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int hpet_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3698,14 +3639,14 @@ static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	hpet_msi_read(irq, &msg);
+	hpet_msi_read_desc(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write_desc(desc, &msg);
 
 	return 0;
 }
@@ -3713,27 +3654,27 @@ static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 #endif /* CONFIG_SMP */
 
 static struct irq_chip ir_hpet_msi_type = {
-	.name = "IR-HPET_MSI",
-	.unmask = hpet_msi_unmask,
-	.mask = hpet_msi_mask,
+	.name			= "IR-HPET_MSI",
+	.desc_unmask		= hpet_msi_unmask_desc,
+	.desc_mask		= hpet_msi_mask_desc,
 #ifdef CONFIG_INTR_REMAP
-	.ack = ir_ack_apic_edge,
+	.desc_ack		= ir_ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity = ir_set_msi_irq_affinity,
+	.desc_set_affinity	= ir_set_msi_irq_affinity,
 #endif
 #endif
-	.retrigger = ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 static struct irq_chip hpet_msi_type = {
-	.name = "HPET_MSI",
-	.unmask = hpet_msi_unmask,
-	.mask = hpet_msi_mask,
-	.ack = ack_apic_edge,
+	.name			= "HPET_MSI",
+	.desc_unmask		= hpet_msi_unmask_desc,
+	.desc_mask		= hpet_msi_mask_desc,
+	.desc_ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity = hpet_msi_set_affinity,
+	.desc_set_affinity	 = hpet_msi_set_affinity,
 #endif
-	.retrigger = ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3754,11 +3695,11 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 			return -1;
 	}
 
-	ret = msi_compose_msg(NULL, irq, &msg, id);
+	ret = msi_compose_msg(NULL, desc, &msg, id);
 	if (ret < 0)
 		return ret;
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write_desc(desc, &msg);
 	desc->status |= IRQ_MOVE_PCNTXT;
 	if (irq_remapped(irq))
 		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
@@ -3779,10 +3720,10 @@ int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
 
 #ifdef CONFIG_SMP
 
-static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
+static void target_ht_irq(struct irq_desc *desc, unsigned int dest, u8 vector)
 {
 	struct ht_irq_msg msg;
-	fetch_ht_irq_msg(irq, &msg);
+	fetch_ht_irq_desc_msg(desc, &msg);
 
 	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
 	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
@@ -3790,12 +3731,11 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
 	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
 
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_desc_msg(desc, &msg);
 }
 
-static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_ht_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 
@@ -3804,7 +3744,7 @@ static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	target_ht_irq(irq, dest, cfg->vector);
+	target_ht_irq(desc, dest, cfg->vector);
 
 	return 0;
 }
@@ -3812,14 +3752,14 @@ static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 #endif
 
 static struct irq_chip ht_irq_chip = {
-	.name		= "PCI-HT",
-	.mask		= mask_ht_irq,
-	.unmask		= unmask_ht_irq,
-	.ack		= ack_apic_edge,
+	.name			= "PCI-HT",
+	.desc_mask		= mask_ht_irq_desc,
+	.desc_unmask		= unmask_ht_irq_desc,
+	.desc_ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_ht_irq_affinity,
+	.desc_set_affinity	= set_ht_irq_affinity,
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
@@ -3856,7 +3796,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 				HT_IRQ_LOW_MT_ARBITRATED) |
 			HT_IRQ_LOW_IRQ_MASKED;
 
-		write_ht_irq_msg(irq, &msg);
+		write_ht_irq_desc_msg(desc, &msg);
 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
@@ -4159,9 +4099,9 @@ void __init setup_ioapic_dest(void)
 			mask = apic->target_cpus();
 
 		if (intr_remapping_enabled)
-			set_ir_ioapic_affinity_irq_desc(desc, mask);
+			set_ir_ioapic_affinity_irq(desc, mask);
 		else
-			set_ioapic_affinity_irq_desc(desc, mask);
+			set_ioapic_affinity_irq(desc, mask);
 	}
 
 }
@@ -4346,7 +4286,7 @@ void __init pre_init_apic_IRQ0(void)
 
 	setup_local_APIC();
 
-	cfg = irq_cfg(0);
+	cfg = desc->chip_data;
 	add_pin_to_irq_node(cfg, 0, 0, 0);
 	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index fb725ee..41867ef 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -33,20 +33,20 @@
 
 static int i8259A_auto_eoi;
 DEFINE_RAW_SPINLOCK(i8259A_lock);
-static void mask_and_ack_8259A(unsigned int);
+static void mask_and_ack_8259A(struct irq_desc *desc);
 static void mask_8259A(void);
 static void unmask_8259A(void);
-static void disable_8259A_irq(unsigned int irq);
-static void enable_8259A_irq(unsigned int irq);
+static void disable_8259A_irq(struct irq_desc *desc);
+static void enable_8259A_irq(struct irq_desc *desc);
 static void init_8259A(int auto_eoi);
-static int i8259A_irq_pending(unsigned int irq);
+static int i8259A_irq_pending(struct irq_desc *desc);
 
 struct irq_chip i8259A_chip = {
 	.name		= "XT-PIC",
-	.mask		= disable_8259A_irq,
-	.disable	= disable_8259A_irq,
-	.unmask		= enable_8259A_irq,
-	.mask_ack	= mask_and_ack_8259A,
+	.desc_mask	= disable_8259A_irq,
+	.desc_disable	= disable_8259A_irq,
+	.desc_unmask	= enable_8259A_irq,
+	.desc_mask_ack	= mask_and_ack_8259A,
 };
 
 /*
@@ -69,8 +69,9 @@ unsigned int cached_irq_mask = 0xffff;
  */
 unsigned long io_apic_irqs;
 
-static void disable_8259A_irq(unsigned int irq)
+static void disable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1 << irq;
 	unsigned long flags;
 
@@ -83,8 +84,9 @@ static void disable_8259A_irq(unsigned int irq)
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static void enable_8259A_irq(unsigned int irq)
+static void enable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = ~(1 << irq);
 	unsigned long flags;
 
@@ -97,8 +99,9 @@ static void enable_8259A_irq(unsigned int irq)
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static int i8259A_irq_pending(unsigned int irq)
+static int i8259A_irq_pending(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1<<irq;
 	unsigned long flags;
 	int ret;
@@ -151,8 +154,9 @@ static inline int i8259A_irq_real(unsigned int irq)
  * first, _then_ send the EOI, and the order of EOI
  * to the two 8259s is important!
  */
-static void mask_and_ack_8259A(unsigned int irq)
+static void mask_and_ack_8259A(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int irqmask = 1 << irq;
 	unsigned long flags;
 
@@ -353,9 +357,9 @@ static void init_8259A(int auto_eoi)
 		 * In AEOI mode we just have to mask the interrupt
 		 * when acking.
 		 */
-		i8259A_chip.mask_ack = disable_8259A_irq;
+		i8259A_chip.desc_mask_ack = disable_8259A_irq;
 	else
-		i8259A_chip.mask_ack = mask_and_ack_8259A;
+		i8259A_chip.desc_mask_ack = mask_and_ack_8259A;
 
 	udelay(100);		/* wait for 8259A to initialize */
 
@@ -372,17 +376,18 @@ static void init_8259A(int auto_eoi)
  */
 
 static void legacy_pic_noop(void) { };
+static void legacy_pic_desc_noop(struct irq_desc *desc) { };
 static void legacy_pic_uint_noop(unsigned int unused) { };
 static void legacy_pic_int_noop(int unused) { };
 
 static struct irq_chip dummy_pic_chip  = {
-	.name = "dummy pic",
-	.mask = legacy_pic_uint_noop,
-	.unmask = legacy_pic_uint_noop,
-	.disable = legacy_pic_uint_noop,
-	.mask_ack = legacy_pic_uint_noop,
+	.name		= "dummy pic",
+	.desc_mask	= legacy_pic_desc_noop,
+	.desc_unmask	= legacy_pic_desc_noop,
+	.desc_disable	= legacy_pic_desc_noop,
+	.desc_mask_ack	= legacy_pic_desc_noop,
 };
-static int legacy_pic_irq_pending_noop(unsigned int irq)
+static int legacy_pic_irq_pending_noop(struct irq_desc *desc)
 {
 	return 0;
 }
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index f71625c..775cd75 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -27,7 +27,7 @@ void (*x86_platform_ipi_callback)(void) = NULL;
 void ack_bad_irq(unsigned int irq)
 {
 	if (printk_ratelimit())
-		pr_err("unexpected IRQ trap at vector %02x\n", irq);
+		pr_err("unexpected IRQ trap at irq %02x\n", irq);
 
 	/*
 	 * Currently unexpected vectors happen only on SMP and APIC.
@@ -308,23 +308,25 @@ void fixup_irqs(void)
 		 * non intr-remapping case, we can't wait till this interrupt
 		 * arrives at this cpu before completing the irq move.
 		 */
-		irq_force_complete_move(irq);
+		irq_force_complete_move(desc);
 
 		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			break_affinity = 1;
 			affinity = cpu_all_mask;
 		}
 
-		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->mask)
-			desc->chip->mask(irq);
+		if (!(desc->status & IRQ_MOVE_PCNTXT))
+			desc_chip_mask(desc->chip, irq, desc);
 
-		if (desc->chip->set_affinity)
+		if (desc->chip->desc_set_affinity)
+			desc->chip->desc_set_affinity(desc, affinity);
+		else if (desc->chip->set_affinity)
 			desc->chip->set_affinity(irq, affinity);
 		else if (!(warned++))
 			set_affinity = 0;
 
-		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
-			desc->chip->unmask(irq);
+		if (!(desc->status & IRQ_MOVE_PCNTXT))
+			desc_chip_unmask(desc->chip, irq, desc);
 
 		raw_spin_unlock(&desc->lock);
 
@@ -356,8 +358,7 @@ void fixup_irqs(void)
 			desc = __get_cpu_var(vector_desc)[vector];
 
 			raw_spin_lock(&desc->lock);
-			if (desc->chip->retrigger)
-				desc->chip->retrigger(irq);
+			desc_chip_retrigger(desc->chip, desc->irq, desc);
 			raw_spin_unlock(&desc->lock);
 		}
 	}
-- 
1.6.4.2

