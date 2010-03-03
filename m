Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0CCIvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 03:51:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:50082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab0CCIv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 03:51:27 -0500
Message-ID: <4B8E22A9.8010807@kernel.org>
Date: Wed, 03 Mar 2010 00:49:45 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH -v2 2/2] genericirq: change ack/mask in irq_chip to take
 irq_desc instead of irq
References: <1266029390-30907-1-git-send-email-yinghai@kernel.org> <m1zl3dre9e.fsf@fess.ebiederm.org> <4B7676BB.8030608@kernel.org> <m1ljexpcjp.fsf@fess.ebiederm.org> <4B772A54.1000000@kernel.org> <m16360ohi2.fsf@fess.ebiederm.org> <4B773CEB.9010609@kernel.org> <m1sk94mzg0.fsf@fess.ebiederm.org> <4B7CA9A1.3020806@kernel.org> <4B7CAADD.2060000@kernel.org> <m1mxz6v4pm.fsf@fess.ebiederm.org> <4B83781B.20307@kernel.org> <4B837930.2050907@kernel.org> <m1ljei5n9q.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1003021522340.4245@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003021522340.4245@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The right way to do that is 
> 
>   1) add new function pointers, which take irq_desc as their argument
> 
>   2) make the generic code use them when the old function pointer is
>      NULL
> 
>   3) convert the irq_chip implementations one by one with separate
>      patches
> 
>   4) Remove the old function pointers and switch the generic code
>      fully over to use the new ones
> 
> Yes, it's more work, but it's less error prone and easier to review,
> as the maintainers just have to look at the patch which affects their
> particular area.

good. please check if you are happy with this version.

next step will make irte and iommu related to use irq_desc instead of irq to avoid irq_to_desc in fast calling path.

Thanks

Yinghai


Subject: [PATCH -v3 2/2] genericirq: change ack/mask in irq_chip to take irq_desc instead of irq

will have
void            (*ack)(struct irq_desc *desc);
void            (*mask)(struct irq_desc *desc);
void            (*mask_ack)(struct irq_desc *desc);
void            (*unmask)(struct irq_desc *desc);
void            (*eoi)(struct irq_desc *desc);

so for sparseirq with raidix tree, we don't call extra irq_to_desc, and could use desc directly

-v2: change all member of irq_chip to use desc only.
-v3: update after legacy_pic
     according to Thomas, use other copy for new member with *desc, so could
     make the transition more smooth

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/ia64/kernel/iosapic.c                  |    4 
 arch/ia64/kernel/msi_ia64.c                 |    2 
 arch/ia64/sn/kernel/irq.c                   |    2 
 arch/ia64/sn/kernel/msi_sn.c                |    2 
 arch/x86/include/asm/hpet.h                 |    8 
 arch/x86/include/asm/hw_irq.h               |    1 
 arch/x86/include/asm/i8259.h                |    2 
 arch/x86/include/asm/irq.h                  |    4 
 arch/x86/kernel/apic/io_apic.c              |  310 +++++++++++-----------------
 arch/x86/kernel/hpet.c                      |   16 -
 arch/x86/kernel/i8259.c                     |   45 ++--
 arch/x86/kernel/irq.c                       |   19 -
 arch/x86/kernel/uv_irq.c                    |   36 +--
 arch/x86/kernel/visws_quirks.c              |   51 ++--
 arch/x86/kernel/vmiclock_32.c               |   18 -
 arch/x86/lguest/boot.c                      |   14 -
 drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 
 drivers/misc/sgi-gru/grufile.c              |    8 
 drivers/pci/dmar.c                          |   33 ++
 drivers/pci/htirq.c                         |   22 -
 drivers/pci/msi.c                           |   17 +
 drivers/xen/events.c                        |   38 +--
 include/linux/dmar.h                        |    4 
 include/linux/htirq.h                       |   11 
 include/linux/irq.h                         |  139 ++++++++++++
 include/linux/msi.h                         |    2 
 kernel/irq/autoprobe.c                      |   13 -
 kernel/irq/chip.c                           |   90 +++++---
 kernel/irq/handle.c                         |   41 +++
 kernel/irq/internals.h                      |   38 ++-
 kernel/irq/manage.c                         |   67 ++----
 kernel/irq/migration.c                      |   16 -
 kernel/irq/pm.c                             |    4 
 kernel/irq/resend.c                         |    8 
 kernel/irq/spurious.c                       |    4 
 35 files changed, 638 insertions(+), 453 deletions(-)

Index: linux-2.6/arch/x86/include/asm/hpet.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hpet.h
+++ linux-2.6/arch/x86/include/asm/hpet.h
@@ -74,10 +74,10 @@ extern void hpet_disable(void);
 extern unsigned int hpet_readl(unsigned int a);
 extern void force_hpet_resume(void);
 
-extern void hpet_msi_unmask(unsigned int irq);
-extern void hpet_msi_mask(unsigned int irq);
-extern void hpet_msi_write(unsigned int irq, struct msi_msg *msg);
-extern void hpet_msi_read(unsigned int irq, struct msi_msg *msg);
+extern void hpet_msi_unmask(struct irq_desc *);
+extern void hpet_msi_mask(struct irq_desc *);
+extern void hpet_msi_write(struct irq_desc *desc, struct msi_msg *msg);
+extern void hpet_msi_read(struct irq_desc *desc, struct msi_msg *msg);
 
 #ifdef CONFIG_PCI_MSI
 extern int arch_setup_hpet_msi(unsigned int irq, unsigned int id);
Index: linux-2.6/arch/x86/include/asm/i8259.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/i8259.h
+++ linux-2.6/arch/x86/include/asm/i8259.h
@@ -58,7 +58,7 @@ struct legacy_pic {
 	void (*mask_all)(void);
 	void (*restore_mask)(void);
 	void (*init)(int auto_eoi);
-	int (*irq_pending)(unsigned int irq);
+	int (*irq_pending)(struct irq_desc *desc);
 	void (*make_irq)(unsigned int irq);
 };
 
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
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
@@ -326,13 +314,6 @@ void arch_free_chip_data(struct irq_desc
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
@@ -580,7 +561,7 @@ static void __mask_IO_APIC_irq(struct ir
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
 
-static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
+static void mask_IO_APIC_irq(struct irq_desc *desc)
 {
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
@@ -592,7 +573,7 @@ static void mask_IO_APIC_irq_desc(struct
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void unmask_IO_APIC_irq_desc(struct irq_desc *desc)
+static void unmask_IO_APIC_irq(struct irq_desc *desc)
 {
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned long flags;
@@ -602,19 +583,6 @@ static void unmask_IO_APIC_irq_desc(stru
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
@@ -1470,7 +1438,7 @@ static void setup_IO_APIC_irq(int apic_i
 
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
@@ -2374,7 +2342,7 @@ set_desc_affinity(struct irq_desc *desc,
 }
 
 static int
-set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+set_ioapic_affinity_irq(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
@@ -2397,16 +2365,6 @@ set_ioapic_affinity_irq_desc(struct irq_
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
@@ -2421,7 +2379,7 @@ set_ioapic_affinity_irq(unsigned int irq
  * the interrupt-remapping table entry.
  */
 static int
-migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+migrate_ioapic_irq(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
@@ -2461,20 +2419,13 @@ migrate_ioapic_irq_desc(struct irq_desc
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
 
@@ -2547,28 +2497,25 @@ static void __irq_complete_move(struct i
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
+	move_native_irq(desc);
 	ack_APIC_irq();
 }
 
@@ -2627,20 +2574,19 @@ static void eoi_ioapic_irq(struct irq_de
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
 
@@ -2729,52 +2675,50 @@ static void ack_apic_level(unsigned int
 		 */
 		cfg = desc->chip_data;
 		if (!io_apic_level_ack_pending(cfg))
-			move_masked_irq(irq);
-		unmask_IO_APIC_irq_desc(desc);
+			move_masked_irq(desc);
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
@@ -2815,7 +2759,7 @@ static inline void init_IO_APIC_traps(vo
  * The local APIC irq-chip implementation:
  */
 
-static void mask_lapic_irq(unsigned int irq)
+static void mask_lapic_irq(struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2823,7 +2767,7 @@ static void mask_lapic_irq(unsigned int
 	apic_write(APIC_LVT0, v | APIC_LVT_MASKED);
 }
 
-static void unmask_lapic_irq(unsigned int irq)
+static void unmask_lapic_irq(struct irq_desc *desc)
 {
 	unsigned long v;
 
@@ -2831,16 +2775,16 @@ static void unmask_lapic_irq(unsigned in
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
@@ -2960,7 +2904,7 @@ static inline void __init check_timer(vo
 	/*
 	 * get/set the timer IRQ vector:
 	 */
-	legacy_pic->chip->mask(0);
+	desc_chip_mask(legacy_pic->chip, 0, desc);
 	assign_irq_vector(desc, cfg, apic->target_cpus());
 
 	/*
@@ -3027,12 +2971,12 @@ static inline void __init check_timer(vo
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
@@ -3055,14 +2999,14 @@ static inline void __init check_timer(vo
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
@@ -3070,7 +3014,7 @@ static inline void __init check_timer(vo
 		 * Cleanup, just in case ...
 		 */
 		local_irq_disable();
-		legacy_pic->chip->mask(0);
+		desc_chip_mask(legacy_pic->chip, 0, desc);
 		clear_IO_APIC_pin(apic2, pin2);
 		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
@@ -3089,14 +3033,14 @@ static inline void __init check_timer(vo
 
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
@@ -3349,7 +3293,6 @@ static int msi_compose_msg(struct pci_de
 	if (disable_apic)
 		return -ENXIO;
 
-	desc = irq_to_desc(irq);
 	cfg = desc->chip_data;
 	err = assign_irq_vector(desc, cfg, apic->target_cpus());
 	if (err)
@@ -3417,9 +3360,8 @@ static int msi_compose_msg(struct pci_de
 }
 
 #ifdef CONFIG_SMP
-static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_msi_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3446,9 +3388,9 @@ static int set_msi_irq_affinity(unsigned
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
@@ -3486,27 +3428,27 @@ ir_set_msi_irq_affinity(unsigned int irq
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
@@ -3540,8 +3482,9 @@ static int setup_msi_irq(struct pci_dev
 {
 	int ret;
 	struct msi_msg msg;
+	struct irq_desc *desc = irq_to_desc(irq);
 
-	ret = msi_compose_msg(dev, irq, &msg, -1);
+	ret = msi_compose_msg(dev, desc, &msg, -1);
 	if (ret < 0)
 		return ret;
 
@@ -3549,7 +3492,6 @@ static int setup_msi_irq(struct pci_dev
 	write_msi_msg(irq, &msg);
 
 	if (irq_remapped(irq)) {
-		struct irq_desc *desc = irq_to_desc(irq);
 		/*
 		 * irq migration in process context
 		 */
@@ -3631,9 +3573,8 @@ void arch_teardown_msi_irq(unsigned int
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3643,14 +3584,14 @@ static int dmar_msi_set_affinity(unsigne
 
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
@@ -3658,25 +3599,26 @@ static int dmar_msi_set_affinity(unsigne
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
@@ -3686,9 +3628,8 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int hpet_msi_set_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
@@ -3698,14 +3639,14 @@ static int hpet_msi_set_affinity(unsigne
 
 	cfg = desc->chip_data;
 
-	hpet_msi_read(irq, &msg);
+	hpet_msi_read(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
 	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write(desc, &msg);
 
 	return 0;
 }
@@ -3713,27 +3654,27 @@ static int hpet_msi_set_affinity(unsigne
 #endif /* CONFIG_SMP */
 
 static struct irq_chip ir_hpet_msi_type = {
-	.name = "IR-HPET_MSI",
-	.unmask = hpet_msi_unmask,
-	.mask = hpet_msi_mask,
+	.name			= "IR-HPET_MSI",
+	.desc_unmask		= hpet_msi_unmask,
+	.desc_mask		= hpet_msi_mask,
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
+	.desc_unmask		= hpet_msi_unmask,
+	.desc_mask		= hpet_msi_mask,
+	.desc_ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity = hpet_msi_set_affinity,
+	.desc_set_affinity	 = hpet_msi_set_affinity,
 #endif
-	.retrigger = ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 int arch_setup_hpet_msi(unsigned int irq, unsigned int id)
@@ -3754,11 +3695,11 @@ int arch_setup_hpet_msi(unsigned int irq
 			return -1;
 	}
 
-	ret = msi_compose_msg(NULL, irq, &msg, id);
+	ret = msi_compose_msg(NULL, desc, &msg, id);
 	if (ret < 0)
 		return ret;
 
-	hpet_msi_write(irq, &msg);
+	hpet_msi_write(desc, &msg);
 	desc->status |= IRQ_MOVE_PCNTXT;
 	if (irq_remapped(irq))
 		set_irq_chip_and_handler_name(irq, &ir_hpet_msi_type,
@@ -3779,10 +3720,10 @@ int arch_setup_hpet_msi(unsigned int irq
 
 #ifdef CONFIG_SMP
 
-static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
+static void target_ht_irq(struct irq_desc *desc, unsigned int dest, u8 vector)
 {
 	struct ht_irq_msg msg;
-	fetch_ht_irq_msg(irq, &msg);
+	fetch_ht_irq_msg(desc, &msg);
 
 	msg.address_lo &= ~(HT_IRQ_LOW_VECTOR_MASK | HT_IRQ_LOW_DEST_ID_MASK);
 	msg.address_hi &= ~(HT_IRQ_HIGH_DEST_ID_MASK);
@@ -3790,12 +3731,11 @@ static void target_ht_irq(unsigned int i
 	msg.address_lo |= HT_IRQ_LOW_VECTOR(vector) | HT_IRQ_LOW_DEST_ID(dest);
 	msg.address_hi |= HT_IRQ_HIGH_DEST_ID(dest);
 
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
-static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_ht_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
 
@@ -3804,7 +3744,7 @@ static int set_ht_irq_affinity(unsigned
 
 	cfg = desc->chip_data;
 
-	target_ht_irq(irq, dest, cfg->vector);
+	target_ht_irq(desc, dest, cfg->vector);
 
 	return 0;
 }
@@ -3812,14 +3752,14 @@ static int set_ht_irq_affinity(unsigned
 #endif
 
 static struct irq_chip ht_irq_chip = {
-	.name		= "PCI-HT",
-	.mask		= mask_ht_irq,
-	.unmask		= unmask_ht_irq,
-	.ack		= ack_apic_edge,
+	.name			= "PCI-HT",
+	.desc_mask		= mask_ht_irq,
+	.desc_unmask		= unmask_ht_irq,
+	.desc_ack		= ack_apic_edge,
 #ifdef CONFIG_SMP
-	.set_affinity	= set_ht_irq_affinity,
+	.desc_set_affinity	= set_ht_irq_affinity,
 #endif
-	.retrigger	= ioapic_retrigger_irq,
+	.desc_retrigger		= ioapic_retrigger_irq,
 };
 
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
@@ -3856,7 +3796,7 @@ int arch_setup_ht_irq(unsigned int irq,
 				HT_IRQ_LOW_MT_ARBITRATED) |
 			HT_IRQ_LOW_IRQ_MASKED;
 
-		write_ht_irq_msg(irq, &msg);
+		write_ht_irq_msg(desc, &msg);
 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
@@ -4137,9 +4077,9 @@ void __init setup_ioapic_dest(void)
 			mask = apic->target_cpus();
 
 		if (intr_remapping_enabled)
-			set_ir_ioapic_affinity_irq_desc(desc, mask);
+			set_ir_ioapic_affinity_irq(desc, mask);
 		else
-			set_ioapic_affinity_irq_desc(desc, mask);
+			set_ioapic_affinity_irq(desc, mask);
 	}
 
 }
@@ -4324,7 +4264,7 @@ void __init pre_init_apic_IRQ0(void)
 
 	setup_local_APIC();
 
-	cfg = irq_cfg(0);
+	cfg = desc->chip_data;
 	add_pin_to_irq_node(cfg, 0, 0, 0);
 	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
 
Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -426,9 +426,9 @@ static int hpet_legacy_next_event(unsign
 static DEFINE_PER_CPU(struct hpet_dev *, cpu_hpet_dev);
 static struct hpet_dev	*hpet_devs;
 
-void hpet_msi_unmask(unsigned int irq)
+void hpet_msi_unmask(struct irq_desc *desc)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 	unsigned int cfg;
 
 	/* unmask it */
@@ -437,10 +437,10 @@ void hpet_msi_unmask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_mask(unsigned int irq)
+void hpet_msi_mask(struct irq_desc *desc)
 {
 	unsigned int cfg;
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
@@ -448,17 +448,17 @@ void hpet_msi_mask(unsigned int irq)
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
-void hpet_msi_write(unsigned int irq, struct msi_msg *msg)
+void hpet_msi_write(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	hpet_writel(msg->data, HPET_Tn_ROUTE(hdev->num));
 	hpet_writel(msg->address_lo, HPET_Tn_ROUTE(hdev->num) + 4);
 }
 
-void hpet_msi_read(unsigned int irq, struct msi_msg *msg)
+void hpet_msi_read(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct hpet_dev *hdev = get_irq_data(irq);
+	struct hpet_dev *hdev = get_irq_desc_data(desc);
 
 	msg->data = hpet_readl(HPET_Tn_ROUTE(hdev->num));
 	msg->address_lo = hpet_readl(HPET_Tn_ROUTE(hdev->num) + 4);
Index: linux-2.6/arch/x86/kernel/i8259.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/i8259.c
+++ linux-2.6/arch/x86/kernel/i8259.c
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
 
@@ -83,8 +84,9 @@ static void disable_8259A_irq(unsigned i
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static void enable_8259A_irq(unsigned int irq)
+static void enable_8259A_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = ~(1 << irq);
 	unsigned long flags;
 
@@ -97,8 +99,9 @@ static void enable_8259A_irq(unsigned in
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 }
 
-static int i8259A_irq_pending(unsigned int irq)
+static int i8259A_irq_pending(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	unsigned int mask = 1<<irq;
 	unsigned long flags;
 	int ret;
@@ -151,8 +154,9 @@ static inline int i8259A_irq_real(unsign
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
Index: linux-2.6/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/irq.c
+++ linux-2.6/arch/x86/kernel/irq.c
@@ -27,7 +27,7 @@ void (*x86_platform_ipi_callback)(void)
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
Index: linux-2.6/arch/x86/kernel/uv_irq.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/uv_irq.c
+++ linux-2.6/arch/x86/kernel/uv_irq.c
@@ -27,34 +27,34 @@ struct uv_irq_2_mmr_pnode{
 static spinlock_t		uv_irq_lock;
 static struct rb_root		uv_irq_root;
 
-static int uv_set_irq_affinity(unsigned int, const struct cpumask *);
+static int uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *);
 
-static void uv_noop(unsigned int irq)
+static void uv_noop(struct irq_desc *desc)
 {
 }
 
-static unsigned int uv_noop_ret(unsigned int irq)
+static unsigned int uv_noop_ret(struct irq_desc *desc)
 {
 	return 0;
 }
 
-static void uv_ack_apic(unsigned int irq)
+static void uv_ack_apic(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
 struct irq_chip uv_irq_chip = {
-	.name		= "UV-CORE",
-	.startup	= uv_noop_ret,
-	.shutdown	= uv_noop,
-	.enable		= uv_noop,
-	.disable	= uv_noop,
-	.ack		= uv_noop,
-	.mask		= uv_noop,
-	.unmask		= uv_noop,
-	.eoi		= uv_ack_apic,
-	.end		= uv_noop,
-	.set_affinity	= uv_set_irq_affinity,
+	.name			= "UV-CORE",
+	.desc_startup		= uv_noop_ret,
+	.desc_shutdown		= uv_noop,
+	.desc_enable		= uv_noop,
+	.desc_disable		= uv_noop,
+	.desc_ack		= uv_noop,
+	.desc_mask		= uv_noop,
+	.desc_unmask		= uv_noop,
+	.desc_eoi		= uv_ack_apic,
+	.desc_end		= uv_noop,
+	.desc_set_affinity	= uv_set_irq_affinity,
 };
 
 /*
@@ -153,7 +153,7 @@ arch_enable_uv_irq(char *irq_name, unsig
 	BUILD_BUG_ON(sizeof(struct uv_IO_APIC_route_entry) !=
 			sizeof(unsigned long));
 
-	cfg = irq_cfg(irq);
+	cfg = desc->chip_data;
 
 	err = assign_irq_vector(irq, cfg, eligible_cpu);
 	if (err != 0)
@@ -205,9 +205,9 @@ static void arch_disable_uv_irq(int mmr_
 	uv_write_global_mmr64(mmr_pnode, mmr_offset, mmr_value);
 }
 
-static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int uv_set_irq_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned int irq = desc->irq;
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned int dest;
 	unsigned long mmr_value;
Index: linux-2.6/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6/arch/x86/kernel/visws_quirks.c
@@ -430,14 +430,15 @@ static int is_co_apic(unsigned int irq)
  * This is the SGI Cobalt (IO-)APIC:
  */
 
-static void enable_cobalt_irq(unsigned int irq)
+static void enable_cobalt_irq(struct irq_desc *desc)
 {
+	unsigned int irq = desc->irq;
 	co_apic_set(is_co_apic(irq), irq);
 }
 
-static void disable_cobalt_irq(unsigned int irq)
+static void disable_cobalt_irq(struct irq_desc *desc)
 {
-	int entry = is_co_apic(irq);
+	int entry = is_co_apic(desc->irq);
 
 	co_apic_write(CO_APIC_LO(entry), CO_APIC_MASK);
 	co_apic_read(CO_APIC_LO(entry));
@@ -448,48 +449,46 @@ static void disable_cobalt_irq(unsigned
  * map this to the Cobalt APIC entry where it's physically wired.
  * This is called via request_irq -> setup_irq -> irq_desc->startup()
  */
-static unsigned int startup_cobalt_irq(unsigned int irq)
+static unsigned int startup_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
 		desc->status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 	return 0;
 }
 
-static void ack_cobalt_irq(unsigned int irq)
+static void ack_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	disable_cobalt_irq(irq);
+	disable_cobalt_irq(desc);
 	apic_write(APIC_EOI, APIC_EIO_ACK);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
-static void end_cobalt_irq(unsigned int irq)
+static void end_cobalt_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
 
 	spin_lock_irqsave(&cobalt_lock, flags);
 	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_cobalt_irq(irq);
+		enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
 static struct irq_chip cobalt_irq_type = {
-	.name =		"Cobalt-APIC",
-	.startup =	startup_cobalt_irq,
-	.shutdown =	disable_cobalt_irq,
-	.enable =	enable_cobalt_irq,
-	.disable =	disable_cobalt_irq,
-	.ack =		ack_cobalt_irq,
-	.end =		end_cobalt_irq,
+	.name		= "Cobalt-APIC",
+	.desc_startup	= startup_cobalt_irq,
+	.desc_shutdown	= disable_cobalt_irq,
+	.desc_enable	= enable_cobalt_irq,
+	.desc_disable	= disable_cobalt_irq,
+	.desc_ack	= ack_cobalt_irq,
+	.desc_end	= end_cobalt_irq,
 };
 
 
@@ -503,27 +502,27 @@ static struct irq_chip cobalt_irq_type =
  * interrupt controller type, and through a special virtual interrupt-
  * controller. Device drivers only see the virtual interrupt sources.
  */
-static unsigned int startup_piix4_master_irq(unsigned int irq)
+static unsigned int startup_piix4_master_irq(struct irq_desc *desc)
 {
 	legacy_pic->init(0);
 
-	return startup_cobalt_irq(irq);
+	return startup_cobalt_irq(desc);
 }
 
-static void end_piix4_master_irq(unsigned int irq)
+static void end_piix4_master_irq(struct irq_desc *desc)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(desc);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
 static struct irq_chip piix4_master_irq_type = {
-	.name =		"PIIX4-master",
-	.startup =	startup_piix4_master_irq,
-	.ack =		ack_cobalt_irq,
-	.end =		end_piix4_master_irq,
+	.name		= "PIIX4-master",
+	.desc_startup	= startup_piix4_master_irq,
+	.desc_ack	= ack_cobalt_irq,
+	.desc_end	= end_piix4_master_irq,
 };
 
 
Index: linux-2.6/arch/x86/kernel/vmiclock_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmiclock_32.c
+++ linux-2.6/arch/x86/kernel/vmiclock_32.c
@@ -84,7 +84,7 @@ static inline unsigned int vmi_get_timer
 
 /** vmi clockchip */
 #ifdef CONFIG_X86_LOCAL_APIC
-static unsigned int startup_timer_irq(unsigned int irq)
+static unsigned int startup_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, vmi_get_timer_vector());
@@ -92,29 +92,29 @@ static unsigned int startup_timer_irq(un
 	return (val & APIC_SEND_PENDING);
 }
 
-static void mask_timer_irq(unsigned int irq)
+static void mask_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val | APIC_LVT_MASKED);
 }
 
-static void unmask_timer_irq(unsigned int irq)
+static void unmask_timer_irq(struct irq_desc *desc)
 {
 	unsigned long val = apic_read(APIC_LVTT);
 	apic_write(APIC_LVTT, val & ~APIC_LVT_MASKED);
 }
 
-static void ack_timer_irq(unsigned int irq)
+static void ack_timer_irq(struct irq_desc *desc)
 {
 	ack_APIC_irq();
 }
 
 static struct irq_chip vmi_chip __read_mostly = {
-	.name 		= "VMI-LOCAL",
-	.startup 	= startup_timer_irq,
-	.mask	 	= mask_timer_irq,
-	.unmask	 	= unmask_timer_irq,
-	.ack 		= ack_timer_irq
+	.name		= "VMI-LOCAL",
+	.desc_startup	= startup_timer_irq,
+	.desc_mask	= mask_timer_irq,
+	.desc_unmask	= unmask_timer_irq,
+	.desc_ack	= ack_timer_irq
 };
 #endif
 
Index: linux-2.6/arch/x86/lguest/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/lguest/boot.c
+++ linux-2.6/arch/x86/lguest/boot.c
@@ -789,22 +789,22 @@ static void lguest_flush_tlb_kernel(void
  * simple as setting a bit.  We don't actually "ack" interrupts as such, we
  * just mask and unmask them.  I wonder if we should be cleverer?
  */
-static void disable_lguest_irq(unsigned int irq)
+static void disable_lguest_irq(struct irq_desc *desc)
 {
-	set_bit(irq, lguest_data.blocked_interrupts);
+	set_bit(desc->irq, lguest_data.blocked_interrupts);
 }
 
-static void enable_lguest_irq(unsigned int irq)
+static void enable_lguest_irq(struct irq_desc *desc)
 {
-	clear_bit(irq, lguest_data.blocked_interrupts);
+	clear_bit(desc->irq, lguest_data.blocked_interrupts);
 }
 
 /* This structure describes the lguest IRQ controller. */
 static struct irq_chip lguest_irq_controller = {
 	.name		= "lguest",
-	.mask		= disable_lguest_irq,
-	.mask_ack	= disable_lguest_irq,
-	.unmask		= enable_lguest_irq,
+	.desc_mask	= disable_lguest_irq,
+	.desc_mask_ack	= disable_lguest_irq,
+	.desc_unmask	= enable_lguest_irq,
 };
 
 /*
Index: linux-2.6/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-gru/grufile.c
+++ linux-2.6/drivers/misc/sgi-gru/grufile.c
@@ -348,15 +348,15 @@ static unsigned long gru_chiplet_cpu_to_
 
 static int gru_irq_count[GRU_CHIPLETS_PER_BLADE];
 
-static void gru_noop(unsigned int irq)
+static void gru_noop(struct irq_desc *desc)
 {
 }
 
 static struct irq_chip gru_chip[GRU_CHIPLETS_PER_BLADE] = {
 	[0 ... GRU_CHIPLETS_PER_BLADE - 1] {
-		.mask		= gru_noop,
-		.unmask		= gru_noop,
-		.ack		= gru_noop
+		.desc_mask		= gru_noop,
+		.desc_unmask		= gru_noop,
+		.desc_ack		= gru_noop
 	}
 };
 
Index: linux-2.6/drivers/pci/dmar.c
===================================================================
--- linux-2.6.orig/drivers/pci/dmar.c
+++ linux-2.6/drivers/pci/dmar.c
@@ -1240,9 +1240,9 @@ const char *dmar_get_fault_reason(u8 fau
 	}
 }
 
-void dmar_msi_unmask(unsigned int irq)
+void dmar_msi_unmask_desc(struct irq_desc *desc)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	/* unmask it */
@@ -1252,11 +1252,15 @@ void dmar_msi_unmask(unsigned int irq)
 	readl(iommu->reg + DMAR_FECTL_REG);
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
+void dmar_msi_unmask(unsigned int irq)
+{
+	dmar_msi_unmask_desc(irq_to_desc(irq));
+}
 
-void dmar_msi_mask(unsigned int irq)
+void dmar_msi_mask_desc(struct irq_desc *desc)
 {
 	unsigned long flag;
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 
 	/* mask it */
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1266,9 +1270,14 @@ void dmar_msi_mask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_write(int irq, struct msi_msg *msg)
+void dmar_msi_mask(unsigned int irq)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	dmar_msi_mask_desc(irq_to_desc(irq));
+}
+
+void dmar_msi_write_desc(struct irq_desc *desc, struct msi_msg *msg)
+{
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1277,10 +1286,14 @@ void dmar_msi_write(int irq, struct msi_
 	writel(msg->address_hi, iommu->reg + DMAR_FEUADDR_REG);
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
+void dmar_msi_write(int irq, struct msi_msg *msg)
+{
+	dmar_msi_write_desc(irq_to_desc(irq), msg);
+}
 
-void dmar_msi_read(int irq, struct msi_msg *msg)
+void dmar_msi_read_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = get_irq_desc_data(desc);
 	unsigned long flag;
 
 	spin_lock_irqsave(&iommu->register_lock, flag);
@@ -1290,6 +1303,10 @@ void dmar_msi_read(int irq, struct msi_m
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
+void dmar_msi_read(int irq, struct msi_msg *msg)
+{
+	dmar_msi_read_desc(irq_to_desc(irq), msg);
+}
 static int dmar_fault_do_one(struct intel_iommu *iommu, int type,
 		u8 fault_reason, u16 source_id, unsigned long long addr)
 {
Index: linux-2.6/drivers/pci/htirq.c
===================================================================
--- linux-2.6.orig/drivers/pci/htirq.c
+++ linux-2.6/drivers/pci/htirq.c
@@ -33,9 +33,9 @@ struct ht_irq_cfg {
 };
 
 
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void write_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg)
 {
-	struct ht_irq_cfg *cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = get_irq_desc_data(desc);
 	unsigned long flags;
 	spin_lock_irqsave(&ht_irq_lock, flags);
 	if (cfg->msg.address_lo != msg->address_lo) {
@@ -47,39 +47,39 @@ void write_ht_irq_msg(unsigned int irq,
 		pci_write_config_dword(cfg->dev, cfg->pos + 4, msg->address_hi);
 	}
 	if (cfg->update)
-		cfg->update(cfg->dev, irq, msg);
+		cfg->update(cfg->dev, desc, msg);
 	spin_unlock_irqrestore(&ht_irq_lock, flags);
 	cfg->msg = *msg;
 }
 
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg)
+void fetch_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg)
 {
-	struct ht_irq_cfg *cfg = get_irq_data(irq);
+	struct ht_irq_cfg *cfg = get_irq_desc_data(desc);
 	*msg = cfg->msg;
 }
 
-void mask_ht_irq(unsigned int irq)
+void mask_ht_irq(struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
 
-	cfg = get_irq_data(irq);
+	cfg = get_irq_desc_data(desc);
 
 	msg = cfg->msg;
 	msg.address_lo |= 1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
-void unmask_ht_irq(unsigned int irq)
+void unmask_ht_irq(struct irq_desc *desc)
 {
 	struct ht_irq_cfg *cfg;
 	struct ht_irq_msg msg;
 
-	cfg = get_irq_data(irq);
+	cfg = get_irq_desc_data(desc);
 
 	msg = cfg->msg;
 	msg.address_lo &= ~1;
-	write_ht_irq_msg(irq, &msg);
+	write_ht_irq_msg(desc, &msg);
 }
 
 /**
Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -169,9 +169,10 @@ static void msix_mask_irq(struct msi_des
 	desc->masked = __msix_mask_irq(desc, flag);
 }
 
-static void msi_set_mask_bit(unsigned irq, u32 flag)
+static void msi_set_mask_bit(struct irq_desc *descx, u32 flag)
 {
-	struct msi_desc *desc = get_irq_msi(irq);
+	unsigned int irq = descx->irq;
+	struct msi_desc *desc = get_irq_desc_msi(descx);
 
 	if (desc->msi_attrib.is_msix) {
 		msix_mask_irq(desc, flag);
@@ -182,14 +183,22 @@ static void msi_set_mask_bit(unsigned ir
 	}
 }
 
+void mask_msi_irq_desc(struct irq_desc *desc)
+{
+	msi_set_mask_bit(desc, 1);
+}
 void mask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bit(irq, 1);
+	mask_msi_irq_desc(irq_to_desc(irq));
 }
 
+void unmask_msi_irq_desc(struct irq_desc *desc)
+{
+	msi_set_mask_bit(desc, 0);
+}
 void unmask_msi_irq(unsigned int irq)
 {
-	msi_set_mask_bit(irq, 0);
+	unmask_msi_irq_desc(irq_to_desc(irq));
 }
 
 void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -725,11 +725,11 @@ static int rebind_irq_to_cpu(unsigned ir
 	return 0;
 }
 
-static int set_affinity_irq(unsigned irq, const struct cpumask *dest)
+static int set_affinity_irq(struct irq_desc *desc, const struct cpumask *dest)
 {
 	unsigned tcpu = cpumask_first(dest);
 
-	return rebind_irq_to_cpu(irq, tcpu);
+	return rebind_irq_to_cpu(desc->irq, tcpu);
 }
 
 int resend_irq_on_evtchn(unsigned int irq)
@@ -748,35 +748,35 @@ int resend_irq_on_evtchn(unsigned int ir
 	return 1;
 }
 
-static void enable_dynirq(unsigned int irq)
+static void enable_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		unmask_evtchn(evtchn);
 }
 
-static void disable_dynirq(unsigned int irq)
+static void disable_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		mask_evtchn(evtchn);
 }
 
-static void ack_dynirq(unsigned int irq)
+static void ack_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 
-	move_native_irq(irq);
+	move_native_irq(desc);
 
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
 }
 
-static int retrigger_dynirq(unsigned int irq)
+static int retrigger_dynirq(struct irq_desc *desc)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(desc->irq);
 	struct shared_info *sh = HYPERVISOR_shared_info;
 	int ret = 0;
 
@@ -921,15 +921,15 @@ void xen_irq_resume(void)
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
-	.name		= "xen-dyn",
+	.name			= "xen-dyn",
 
-	.disable	= disable_dynirq,
-	.mask		= disable_dynirq,
-	.unmask		= enable_dynirq,
-
-	.ack		= ack_dynirq,
-	.set_affinity	= set_affinity_irq,
-	.retrigger	= retrigger_dynirq,
+	.desc_disable		= disable_dynirq,
+	.desc_mask		= disable_dynirq,
+	.desc_unmask		= enable_dynirq,
+
+	.desc_ack		= ack_dynirq,
+	.desc_set_affinity	= set_affinity_irq,
+	.desc_retrigger		= retrigger_dynirq,
 };
 
 void __init xen_init_IRQ(void)
Index: linux-2.6/include/linux/dmar.h
===================================================================
--- linux-2.6.orig/include/linux/dmar.h
+++ linux-2.6/include/linux/dmar.h
@@ -191,6 +191,10 @@ extern void dmar_msi_unmask(unsigned int
 extern void dmar_msi_mask(unsigned int irq);
 extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
+extern void dmar_msi_unmask_desc(struct irq_desc *);
+extern void dmar_msi_mask_desc(struct irq_desc *);
+extern void dmar_msi_read_desc(struct irq_desc *desc, struct msi_msg *msg);
+extern void dmar_msi_write_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
 extern int arch_setup_dmar_msi(unsigned int irq);
Index: linux-2.6/include/linux/htirq.h
===================================================================
--- linux-2.6.orig/include/linux/htirq.h
+++ linux-2.6/include/linux/htirq.h
@@ -7,16 +7,17 @@ struct ht_irq_msg {
 };
 
 /* Helper functions.. */
-void fetch_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void write_ht_irq_msg(unsigned int irq, struct ht_irq_msg *msg);
-void mask_ht_irq(unsigned int irq);
-void unmask_ht_irq(unsigned int irq);
+struct irq_desc;
+void fetch_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
+void write_ht_irq_msg(struct irq_desc *desc, struct ht_irq_msg *msg);
+void mask_ht_irq(struct irq_desc *);
+void unmask_ht_irq(struct irq_desc *);
 
 /* The arch hook for getting things started */
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev);
 
 /* For drivers of buggy hardware */
-typedef void (ht_irq_update_t)(struct pci_dev *dev, int irq,
+typedef void (ht_irq_update_t)(struct pci_dev *dev, struct irq_desc *desc,
 			       struct ht_irq_msg *msg);
 int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update);
 
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -110,6 +110,7 @@ struct msi_desc;
  */
 struct irq_chip {
 	const char	*name;
+
 	unsigned int	(*startup)(unsigned int irq);
 	void		(*shutdown)(unsigned int irq);
 	void		(*enable)(unsigned int irq);
@@ -135,6 +136,34 @@ struct irq_chip {
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
 #endif
+
+	unsigned int	(*desc_startup)(struct irq_desc *desc);
+	void		(*desc_shutdown)(struct irq_desc *desc);
+	void		(*desc_enable)(struct irq_desc *desc);
+	void		(*desc_disable)(struct irq_desc *desc);
+
+	void		(*desc_ack)(struct irq_desc *desc);
+	void		(*desc_mask)(struct irq_desc *desc);
+	void		(*desc_mask_ack)(struct irq_desc *desc);
+	void		(*desc_unmask)(struct irq_desc *desc);
+	void		(*desc_eoi)(struct irq_desc *desc);
+
+	void		(*desc_end)(struct irq_desc *desc);
+	int		(*desc_set_affinity)(struct irq_desc *desc,
+					const struct cpumask *dest);
+	int		(*desc_retrigger)(struct irq_desc *desc);
+
+	int		(*desc_set_type)(struct irq_desc *desc, unsigned int flow_type);
+	int		(*desc_set_wake)(struct irq_desc *desc, unsigned int on);
+
+	void		(*desc_bus_lock)(struct irq_desc *desc);
+	void		(*desc_bus_sync_unlock)(struct irq_desc *desc);
+
+	/* Currently used only by UML, might disappear one day.*/
+#ifdef CONFIG_IRQ_RELEASE_METHOD
+	void		(*desc_release)(struct irq_desc *desc, void *dev_id);
+#endif
+
 	/*
 	 * For compatibility, ->typename is copied into ->name.
 	 * Will disappear.
@@ -227,6 +256,106 @@ static inline struct irq_desc *move_irq_
 
 extern struct irq_desc *irq_to_desc_alloc_node(unsigned int irq, int node);
 
+static inline unsigned int
+desc_chip_startup(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_startup)
+		return chip->desc_startup(desc);
+	else if (chip->startup)
+		return chip->startup(irq);
+	return 0;
+}
+static inline void
+desc_chip_shutdown(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_shutdown)
+		chip->desc_shutdown(desc);
+	else if (chip->shutdown)
+		chip->shutdown(irq);
+}
+static inline void
+desc_chip_enable(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_enable)
+		chip->desc_enable(desc);
+	else if (chip->enable)
+		chip->enable(irq);
+}
+static inline void
+desc_chip_disable(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_disable)
+		chip->desc_disable(desc);
+	else if (chip->disable)
+		chip->disable(irq);
+}
+static inline void
+desc_chip_ack(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_ack)
+		chip->desc_ack(desc);
+	else if (chip->ack)
+		chip->ack(irq);
+}
+static inline void
+desc_chip_mask(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_mask)
+		chip->desc_mask(desc);
+	else if (chip->mask)
+		chip->mask(irq);
+}
+static inline void
+desc_chip_mask_ack(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_mask_ack)
+		chip->desc_mask_ack(desc);
+	else if (chip->mask_ack)
+		chip->mask_ack(irq);
+}
+static inline void
+desc_chip_unmask(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_unmask)
+		chip->desc_unmask(desc);
+	else if (chip->unmask)
+		chip->unmask(irq);
+}
+static inline void
+desc_chip_eoi(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_eoi)
+		chip->desc_eoi(desc);
+	else if (chip->eoi)
+		chip->eoi(irq);
+}
+static inline void
+desc_chip_end(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_end)
+		chip->desc_end(desc);
+	else if (chip->end)
+		chip->end(irq);
+}
+static inline int
+desc_chip_set_affinity(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc, const struct cpumask *dest)
+{
+	if (chip->desc_set_affinity)
+		return chip->desc_set_affinity(desc, dest);
+	else if (chip->set_affinity)
+		return chip->set_affinity(irq, dest);
+	return 0;
+}
+static inline int
+desc_chip_retrigger(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc)
+{
+	if (chip->desc_retrigger)
+		return chip->desc_retrigger(desc);
+	else if (chip->startup)
+		return chip->retrigger(irq);
+	return 0;
+}
+
 /*
  * Pick up the arch-dependent methods:
  */
@@ -241,8 +370,8 @@ extern void remove_irq(unsigned int irq,
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void move_native_irq(int irq);
-void move_masked_irq(int irq);
+void move_native_irq(struct irq_desc *desc);
+void move_masked_irq(struct irq_desc *desc);
 
 #else /* CONFIG_GENERIC_PENDING_IRQ */
 
@@ -250,11 +379,11 @@ static inline void move_irq(int irq)
 {
 }
 
-static inline void move_native_irq(int irq)
+static inline void move_native_irq(struct irq_desc *desc)
 {
 }
 
-static inline void move_masked_irq(int irq)
+static inline void move_masked_irq(struct irq_desc *desc)
 {
 }
 
@@ -327,7 +456,7 @@ extern void note_interrupt(unsigned int
 			   irqreturn_t action_ret);
 
 /* Resending of interrupts :*/
-void check_irq_resend(struct irq_desc *desc, unsigned int irq);
+void check_irq_resend(struct irq_desc *desc);
 
 /* Enable/disable irq debugging output: */
 extern int noirqdebug_setup(char *str);
Index: linux-2.6/include/linux/msi.h
===================================================================
--- linux-2.6.orig/include/linux/msi.h
+++ linux-2.6/include/linux/msi.h
@@ -13,6 +13,8 @@ struct msi_msg {
 struct irq_desc;
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
+void mask_msi_irq_desc(struct irq_desc *);
+void unmask_msi_irq_desc(struct irq_desc *);
 extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
Index: linux-2.6/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6.orig/kernel/irq/autoprobe.c
+++ linux-2.6/kernel/irq/autoprobe.c
@@ -57,9 +57,8 @@ unsigned long probe_irq_on(void)
 			 * Some chips need to know about probing in
 			 * progress:
 			 */
-			if (desc->chip->set_type)
-				desc->chip->set_type(i, IRQ_TYPE_PROBE);
-			desc->chip->startup(i);
+			desc_chip_set_type(desc->chip, i, desc, IRQ_TYPE_PROBE);
+			desc_chip_startup(desc->chip, i, desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -76,7 +75,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->chip->startup(i))
+			if (desc_chip_startup(desc->chip, i, desc))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -98,7 +97,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->chip->shutdown(i);
+				desc_chip_shutdown(desc->chip, i, desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -137,7 +136,7 @@ unsigned int probe_irq_mask(unsigned lon
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc_chip_shutdown(desc->chip, i, desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -181,7 +180,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->chip->shutdown(i);
+			desc_chip_shutdown(desc->chip, i, desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -294,6 +294,11 @@ static void default_enable(unsigned int
 	desc->chip->unmask(irq);
 	desc->status &= ~IRQ_MASKED;
 }
+static void default_enable_desc(struct irq_desc *desc)
+{
+	desc->chip->desc_unmask(desc);
+	desc->status &= ~IRQ_MASKED;
+}
 
 /*
  * default disable function
@@ -301,6 +306,9 @@ static void default_enable(unsigned int
 static void default_disable(unsigned int irq)
 {
 }
+static void default_disable_desc(struct irq_desc *desc)
+{
+}
 
 /*
  * default startup function
@@ -312,6 +320,11 @@ static unsigned int default_startup(unsi
 	desc->chip->enable(irq);
 	return 0;
 }
+static unsigned int default_startup_desc(struct irq_desc *desc)
+{
+	desc->chip->desc_enable(desc);
+	return 0;
+}
 
 /*
  * default shutdown function
@@ -323,12 +336,36 @@ static void default_shutdown(unsigned in
 	desc->chip->mask(irq);
 	desc->status |= IRQ_MASKED;
 }
+static void default_shutdown_desc(struct irq_desc *desc)
+{
+	desc->chip->desc_mask(desc);
+	desc->status |= IRQ_MASKED;
+}
 
 /*
  * Fixup enable/disable function pointers
  */
 void irq_chip_set_defaults(struct irq_chip *chip)
 {
+	if (!chip->desc_enable)
+		chip->desc_enable = default_enable_desc;
+	if (!chip->desc_disable)
+		chip->desc_disable = default_disable_desc;
+	if (!chip->desc_startup)
+		chip->desc_startup = default_startup_desc;
+	/*
+	 * We use chip->disable, when the user provided its own. When
+	 * we have default_disable set for chip->disable, then we need
+	 * to use default_shutdown, otherwise the irq line is not
+	 * disabled on free_irq():
+	 */
+	if (!chip->desc_shutdown)
+		chip->desc_shutdown = chip->desc_disable != default_disable_desc ?
+			chip->desc_disable : default_shutdown_desc;
+	if (!chip->desc_end)
+		chip->desc_end = dummy_irq_chip.desc_end;
+
+
 	if (!chip->enable)
 		chip->enable = default_enable;
 	if (!chip->disable)
@@ -344,20 +381,22 @@ void irq_chip_set_defaults(struct irq_ch
 	if (!chip->shutdown)
 		chip->shutdown = chip->disable != default_disable ?
 			chip->disable : default_shutdown;
-	if (!chip->name)
-		chip->name = chip->typename;
 	if (!chip->end)
 		chip->end = dummy_irq_chip.end;
+
+	if (!chip->name)
+		chip->name = chip->typename;
 }
 
-static inline void mask_ack_irq(struct irq_desc *desc, int irq)
+static inline void mask_ack_irq(struct irq_desc *desc)
 {
-	if (desc->chip->mask_ack)
-		desc->chip->mask_ack(irq);
+	if (desc->chip->desc_mask_ack)
+		desc->chip->desc_mask_ack(desc);
+	else if (desc->chip->mask_ack)
+		desc->chip->mask_ack(desc->irq);
 	else {
-		desc->chip->mask(irq);
-		if (desc->chip->ack)
-			desc->chip->ack(irq);
+		desc_chip_mask(desc->chip, desc->irq, desc);
+		desc_chip_ack(desc->chip, desc->irq, desc);
 	}
 }
 
@@ -459,7 +498,7 @@ handle_level_irq(unsigned int irq, struc
 	irqreturn_t action_ret;
 
 	raw_spin_lock(&desc->lock);
-	mask_ack_irq(desc, irq);
+	mask_ack_irq(desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -486,8 +525,9 @@ handle_level_irq(unsigned int irq, struc
 
 	if (unlikely(desc->status & IRQ_ONESHOT))
 		desc->status |= IRQ_MASKED;
-	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-		desc->chip->unmask(irq);
+	else if (!(desc->status & IRQ_DISABLED))
+		desc_chip_unmask(desc->chip, irq, desc);
+
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -524,8 +564,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
-		if (desc->chip->mask)
-			desc->chip->mask(irq);
+		desc_chip_mask(desc->chip, irq, desc);
 		goto out;
 	}
 
@@ -540,7 +579,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	desc->chip->eoi(irq);
+	desc_chip_eoi(desc->chip, irq, desc);
 
 	raw_spin_unlock(&desc->lock);
 }
@@ -576,14 +615,13 @@ handle_edge_irq(unsigned int irq, struct
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc, irq);
+		mask_ack_irq(desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	if (desc->chip->ack)
-		desc->chip->ack(irq);
+	desc_chip_ack(desc->chip, irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -593,7 +631,7 @@ handle_edge_irq(unsigned int irq, struct
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			desc->chip->mask(irq);
+			desc_chip_mask(desc->chip, irq, desc);
 			goto out_unlock;
 		}
 
@@ -605,7 +643,7 @@ handle_edge_irq(unsigned int irq, struct
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			desc->chip->unmask(irq);
+			desc_chip_unmask(desc->chip, irq, desc);
 			desc->status &= ~IRQ_MASKED;
 		}
 
@@ -637,15 +675,13 @@ handle_percpu_irq(unsigned int irq, stru
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (desc->chip->ack)
-		desc->chip->ack(irq);
+	desc_chip_ack(desc->chip, irq, desc);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi)
-		desc->chip->eoi(irq);
+	desc_chip_eoi(desc->chip, irq, desc);
 }
 
 void
@@ -676,13 +712,13 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->chip = &dummy_irq_chip;
 	}
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
 		if (desc->chip != &no_irq_chip)
-			mask_ack_irq(desc, irq);
+			mask_ack_irq(desc);
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
@@ -693,10 +729,10 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->chip->startup(irq);
+		desc_chip_startup(desc->chip, irq, desc);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
 
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -38,7 +38,7 @@ struct lock_class_key irq_desc_lock_clas
  */
 void handle_bad_irq(unsigned int irq, struct irq_desc *desc)
 {
-	print_irq_desc(irq, desc);
+	print_irq_desc(desc);
 	kstat_incr_irqs_this_cpu(irq, desc);
 	ack_bad_irq(irq);
 }
@@ -295,10 +295,14 @@ void clear_kstat_irqs(struct irq_desc *d
 static void ack_bad(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-
-	print_irq_desc(irq, desc);
+	print_irq_desc(desc);
 	ack_bad_irq(irq);
 }
+static void ack_bad_desc(struct irq_desc *desc)
+{
+	print_irq_desc(desc);
+	ack_bad_irq(desc->irq);
+}
 
 /*
  * NOP functions
@@ -306,11 +310,18 @@ static void ack_bad(unsigned int irq)
 static void noop(unsigned int irq)
 {
 }
+static void noop_desc(struct irq_desc *desc)
+{
+}
 
 static unsigned int noop_ret(unsigned int irq)
 {
 	return 0;
 }
+static unsigned int noop_ret_desc(struct irq_desc *des)
+{
+	return 0;
+}
 
 /*
  * Generic no controller implementation
@@ -323,6 +334,13 @@ struct irq_chip no_irq_chip = {
 	.disable	= noop,
 	.ack		= ack_bad,
 	.end		= noop,
+
+	.desc_startup	= noop_ret_desc,
+	.desc_shutdown	= noop_desc,
+	.desc_enable	= noop_desc,
+	.desc_disable	= noop_desc,
+	.desc_ack	= ack_bad_desc,
+	.desc_end	= noop_desc,
 };
 
 /*
@@ -339,6 +357,15 @@ struct irq_chip dummy_irq_chip = {
 	.mask		= noop,
 	.unmask		= noop,
 	.end		= noop,
+
+	.desc_startup	= noop_ret_desc,
+	.desc_shutdown	= noop_desc,
+	.desc_enable	= noop_desc,
+	.desc_disable	= noop_desc,
+	.desc_ack	= noop_desc,
+	.desc_mask	= noop_desc,
+	.desc_unmask	= noop_desc,
+	.desc_end	= noop_desc,
 };
 
 /*
@@ -461,19 +488,19 @@ unsigned int __do_IRQ(unsigned int irq)
 		 * No locking required for CPU-local interrupts:
 		 */
 		if (desc->chip->ack)
-			desc->chip->ack(irq);
+			desc_chip_ack(desc->chip, irq, desc);
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
 				note_interrupt(irq, desc, action_ret);
 		}
-		desc->chip->end(irq);
+		desc_chip_end(desc->chip, irq, desc);
 		return 1;
 	}
 
 	raw_spin_lock(&desc->lock);
 	if (desc->chip->ack)
-		desc->chip->ack(irq);
+		desc_chip_ack(desc->chip, irq, desc);
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
@@ -533,7 +560,7 @@ out:
 	 * The ->end() handler has to deal with interrupts which got
 	 * disabled while the handler was running.
 	 */
-	desc->chip->end(irq);
+	desc_chip_end(desc->chip, irq, desc);
 	raw_spin_unlock(&desc->lock);
 
 	return 1;
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -12,8 +12,8 @@ extern void compat_irq_chip_set_default_
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
-extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
-extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
+extern void __disable_irq(struct irq_desc *desc, bool susp);
+extern void __enable_irq(struct irq_desc *desc, bool resume);
 
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
@@ -40,17 +40,39 @@ extern int irq_select_affinity_usr(unsig
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
+static inline int
+desc_chip_set_type(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc, unsigned int flow_type)
+{
+	if (chip->desc_set_type)
+		return chip->desc_set_type(desc, flow_type);
+	else if (chip->set_type)
+		return chip->set_type(irq, flow_type);
+	return 0;
+}
+static inline int
+desc_chip_set_wake(struct irq_chip *chip, unsigned int irq, struct irq_desc *desc, unsigned int on)
+{
+	if (chip->desc_set_wake)
+		return chip->desc_set_wake(desc, on);
+	else if (chip->set_wake)
+		return chip->set_wake(irq, on);
+	return 0;
+}
 /* Inline functions for support of irq chips on slow busses */
-static inline void chip_bus_lock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_lock(struct irq_desc *desc)
 {
+	if (unlikely(desc->chip->desc_bus_lock))
+		desc->chip->desc_bus_lock(desc);
 	if (unlikely(desc->chip->bus_lock))
-		desc->chip->bus_lock(irq);
+		desc->chip->bus_lock(desc->irq);
 }
 
-static inline void chip_bus_sync_unlock(unsigned int irq, struct irq_desc *desc)
+static inline void chip_bus_sync_unlock(struct irq_desc *desc)
 {
+	if (unlikely(desc->chip->desc_bus_sync_unlock))
+		desc->chip->desc_bus_sync_unlock(desc);
 	if (unlikely(desc->chip->bus_sync_unlock))
-		desc->chip->bus_sync_unlock(irq);
+		desc->chip->bus_sync_unlock(desc->irq);
 }
 
 /*
@@ -61,10 +83,10 @@ static inline void chip_bus_sync_unlock(
 
 #define P(f) if (desc->status & f) printk("%14s set\n", #f)
 
-static inline void print_irq_desc(unsigned int irq, struct irq_desc *desc)
+static inline void print_irq_desc(struct irq_desc *desc)
 {
 	printk("irq %d, desc: %p, depth: %d, count: %d, unhandled: %d\n",
-		irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
+		desc->irq, desc, desc->depth, desc->irq_count, desc->irqs_unhandled);
 	printk("->handle_irq():  %p, ", desc->handle_irq);
 	print_symbol("%s\n", (unsigned long)desc->handle_irq);
 	printk("->chip(): %p, ", desc->chip);
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -118,7 +118,7 @@ int irq_set_affinity(unsigned int irq, c
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!desc->chip->set_affinity(irq, cpumask)) {
+		if (!desc_chip_set_affinity(desc->chip, irq, desc, cpumask)) {
 			cpumask_copy(desc->affinity, cpumask);
 			irq_set_thread_affinity(desc);
 		}
@@ -128,7 +128,7 @@ int irq_set_affinity(unsigned int irq, c
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	if (!desc->chip->set_affinity(irq, cpumask)) {
+	if (!desc_chip_set_affinity(desc->chip, irq, desc, cpumask)) {
 		cpumask_copy(desc->affinity, cpumask);
 		irq_set_thread_affinity(desc);
 	}
@@ -161,7 +161,7 @@ static int setup_affinity(unsigned int i
 
 	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->chip->set_affinity(irq, desc->affinity);
+	desc_chip_set_affinity(desc->chip, irq, desc, desc->affinity);
 
 	return 0;
 }
@@ -197,7 +197,7 @@ static inline int setup_affinity(unsigne
 }
 #endif
 
-void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
+void __disable_irq(struct irq_desc *desc, bool suspend)
 {
 	if (suspend) {
 		if (!desc->action || (desc->action->flags & IRQF_TIMER))
@@ -207,7 +207,7 @@ void __disable_irq(struct irq_desc *desc
 
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
+		desc_chip_disable(desc->chip, desc->irq, desc);
 	}
 }
 
@@ -230,11 +230,11 @@ void disable_irq_nosync(unsigned int irq
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	__disable_irq(desc, irq, false);
+	__disable_irq(desc, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
@@ -263,7 +263,7 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
-void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
+void __enable_irq(struct irq_desc *desc, bool resume)
 {
 	if (resume)
 		desc->status &= ~IRQ_SUSPENDED;
@@ -271,7 +271,7 @@ void __enable_irq(struct irq_desc *desc,
 	switch (desc->depth) {
 	case 0:
  err_out:
-		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
+		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", desc->irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
@@ -280,7 +280,7 @@ void __enable_irq(struct irq_desc *desc,
 			goto err_out;
 		/* Prevent probing on this irq: */
 		desc->status = status | IRQ_NOPROBE;
-		check_irq_resend(desc, irq);
+		check_irq_resend(desc);
 		/* fall-through */
 	}
 	default:
@@ -307,21 +307,20 @@ void enable_irq(unsigned int irq)
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	__enable_irq(desc, irq, false);
+	__enable_irq(desc, false);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(enable_irq);
 
-static int set_irq_wake_real(unsigned int irq, unsigned int on)
+static int set_irq_wake_real(struct irq_desc *desc, unsigned int on)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
 	int ret = -ENXIO;
 
 	if (desc->chip->set_wake)
-		ret = desc->chip->set_wake(irq, on);
+		ret = desc_chip_set_wake(desc->chip, desc->irq, desc, on);
 
 	return ret;
 }
@@ -350,7 +349,7 @@ int set_irq_wake(unsigned int irq, unsig
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (on) {
 		if (desc->wake_depth++ == 0) {
-			ret = set_irq_wake_real(irq, on);
+			ret = set_irq_wake_real(desc, on);
 			if (ret)
 				desc->wake_depth = 0;
 			else
@@ -360,7 +359,7 @@ int set_irq_wake(unsigned int irq, unsig
 		if (desc->wake_depth == 0) {
 			WARN(1, "Unbalanced IRQ %d wake disable\n", irq);
 		} else if (--desc->wake_depth == 0) {
-			ret = set_irq_wake_real(irq, on);
+			ret = set_irq_wake_real(desc, on);
 			if (ret)
 				desc->wake_depth = 1;
 			else
@@ -414,7 +413,7 @@ int __irq_set_trigger(struct irq_desc *d
 	int ret;
 	struct irq_chip *chip = desc->chip;
 
-	if (!chip || !chip->set_type) {
+	if (!chip || !(chip->set_type || chip->desc_set_type)) {
 		/*
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
@@ -425,7 +424,7 @@ int __irq_set_trigger(struct irq_desc *d
 	}
 
 	/* caller masked out all except trigger mode flags */
-	ret = chip->set_type(irq, flags);
+	ret = desc_chip_set_type(chip, irq, desc, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
@@ -481,16 +480,16 @@ static int irq_wait_for_interrupt(struct
  * handler finished. unmask if the interrupt has not been disabled and
  * is marked MASKED.
  */
-static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
+static void irq_finalize_oneshot(struct irq_desc *desc)
 {
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
-		desc->chip->unmask(irq);
+		desc_chip_unmask(desc->chip, desc->irq, desc);
 	}
 	raw_spin_unlock_irq(&desc->lock);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 
 #ifdef CONFIG_SMP
@@ -562,7 +561,7 @@ static int irq_thread(void *data)
 			action->thread_fn(action->irq, action->dev_id);
 
 			if (oneshot)
-				irq_finalize_oneshot(action->irq, desc);
+				irq_finalize_oneshot(desc);
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
@@ -738,7 +737,7 @@ __setup_irq(unsigned int irq, struct irq
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			desc->chip->startup(irq);
+			desc_chip_startup(desc->chip, irq, desc);
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
@@ -772,7 +771,7 @@ __setup_irq(unsigned int irq, struct irq
 	 */
 	if (shared && (desc->status & IRQ_SPURIOUS_DISABLED)) {
 		desc->status &= ~IRQ_SPURIOUS_DISABLED;
-		__enable_irq(desc, irq, false);
+		__enable_irq(desc, false);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -879,9 +878,9 @@ static struct irqaction *__free_irq(unsi
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
 		if (desc->chip->shutdown)
-			desc->chip->shutdown(irq);
+			desc_chip_shutdown(desc->chip, irq, desc);
 		else
-			desc->chip->disable(irq);
+			desc_chip_disable(desc->chip, irq, desc);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
@@ -950,9 +949,9 @@ void free_irq(unsigned int irq, void *de
 	if (!desc)
 		return;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -1059,9 +1058,9 @@ int request_threaded_irq(unsigned int ir
 	action->name = devname;
 	action->dev_id = dev_id;
 
-	chip_bus_lock(irq, desc);
+	chip_bus_lock(desc);
 	retval = __setup_irq(irq, desc, action);
-	chip_bus_sync_unlock(irq, desc);
+	chip_bus_sync_unlock(desc);
 
 	if (retval)
 		kfree(action);
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -4,10 +4,8 @@
 
 #include "internals.h"
 
-void move_masked_irq(int irq)
+void move_masked_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
@@ -43,7 +41,7 @@ void move_masked_irq(int irq)
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids))
-		if (!desc->chip->set_affinity(irq, desc->pending_mask)) {
+		if (!desc_chip_set_affinity(desc->chip, desc->irq, desc, desc->pending_mask)) {
 			cpumask_copy(desc->affinity, desc->pending_mask);
 			irq_set_thread_affinity(desc);
 		}
@@ -51,18 +49,16 @@ void move_masked_irq(int irq)
 	cpumask_clear(desc->pending_mask);
 }
 
-void move_native_irq(int irq)
+void move_native_irq(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
 
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->chip->mask(irq);
-	move_masked_irq(irq);
-	desc->chip->unmask(irq);
+	desc_chip_mask(desc->chip, desc->irq, desc);
+	move_masked_irq(desc);
+	desc_chip_unmask(desc->chip, desc->irq, desc);
 }
 
Index: linux-2.6/kernel/irq/pm.c
===================================================================
--- linux-2.6.orig/kernel/irq/pm.c
+++ linux-2.6/kernel/irq/pm.c
@@ -29,7 +29,7 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		__disable_irq(desc, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
@@ -57,7 +57,7 @@ void resume_device_irqs(void)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__enable_irq(desc, irq, true);
+		__enable_irq(desc, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
Index: linux-2.6/kernel/irq/resend.c
===================================================================
--- linux-2.6.orig/kernel/irq/resend.c
+++ linux-2.6/kernel/irq/resend.c
@@ -53,14 +53,14 @@ static DECLARE_TASKLET(resend_tasklet, r
  *
  * Is called with interrupts disabled and desc->lock held.
  */
-void check_irq_resend(struct irq_desc *desc, unsigned int irq)
+void check_irq_resend(struct irq_desc *desc)
 {
 	unsigned int status = desc->status;
 
 	/*
 	 * Make sure the interrupt is enabled, before resending it:
 	 */
-	desc->chip->enable(irq);
+	desc_chip_enable(desc->chip, desc->irq, desc);
 
 	/*
 	 * We do not resend level type interrupts. Level type
@@ -70,10 +70,10 @@ void check_irq_resend(struct irq_desc *d
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->chip->retrigger || !desc->chip->retrigger(irq)) {
+		if (!desc_chip_retrigger(desc->chip, desc->irq, desc)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
-			set_bit(irq, irqs_resend);
+			set_bit(desc->irq, irqs_resend);
 			tasklet_schedule(&resend_tasklet);
 #endif
 		}
Index: linux-2.6/kernel/irq/spurious.c
===================================================================
--- linux-2.6.orig/kernel/irq/spurious.c
+++ linux-2.6/kernel/irq/spurious.c
@@ -79,7 +79,7 @@ static int try_one_irq(int irq, struct i
 	 * IRQ controller clean up too
 	 */
 	if (work && desc->chip && desc->chip->end)
-		desc->chip->end(irq);
+		desc_chip_end(desc->chip, irq, desc);
 	raw_spin_unlock(&desc->lock);
 
 	return ok;
@@ -254,7 +254,7 @@ void note_interrupt(unsigned int irq, st
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->chip->disable(irq);
+		desc_chip_disable(desc->chip, irq, desc);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_iba6110.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_iba6110.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_iba6110.c
@@ -986,7 +986,7 @@ static int ipath_ht_intconfig(struct ipa
 	return ret;
 }
 
-static void ipath_ht_irq_update(struct pci_dev *dev, int irq,
+static void ipath_ht_irq_update(struct pci_dev *dev, struct irq_desc *desc,
 				struct ht_irq_msg *msg)
 {
 	struct ipath_devdata *dd = pci_get_drvdata(dev);
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -409,7 +409,7 @@ iosapic_end_level_irq (unsigned int irq)
 		iosapic_eoi(rte->iosapic->addr, vec);
 
 	if (unlikely(do_unmask_irq)) {
-		move_masked_irq(irq);
+		move_masked_irq(irq_to_desc(irq));
 		unmask_irq(irq);
 	}
 }
@@ -454,7 +454,7 @@ iosapic_ack_edge_irq (unsigned int irq)
 	struct irq_desc *idesc = irq_desc + irq;
 
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(idesc);
 	/*
 	 * Once we have recorded IRQ_PENDING already, we can mask the
 	 * interrupt for real. This prevents IRQ storms from unhandled
Index: linux-2.6/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6/arch/ia64/kernel/msi_ia64.c
@@ -87,7 +87,7 @@ void ia64_teardown_msi_irq(unsigned int
 static void ia64_ack_msi_irq(unsigned int irq)
 {
 	irq_complete_move(irq);
-	move_native_irq(irq);
+	move_native_irq(irq_to_desc(irq));
 	ia64_eoi();
 }
 
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -110,7 +110,7 @@ static void sn_ack_irq(unsigned int irq)
 	HUB_S((u64*)LOCAL_MMR_ADDR(SH_EVENT_OCCURRED_ALIAS), mask);
 	__set_bit(irq, (volatile void *)pda->sn_in_service_ivecs);
 
-	move_native_irq(irq);
+	move_native_irq(irq_to_desc(irq));
 }
 
 static void sn_end_irq(unsigned int irq)
Index: linux-2.6/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6/arch/ia64/sn/kernel/msi_sn.c
@@ -213,7 +213,7 @@ static int sn_set_msi_irq_affinity(unsig
 
 static void sn_ack_msi_irq(unsigned int irq)
 {
-	move_native_irq(irq);
+	move_native_irq(irq_to_desc(irq));
 	ia64_eoi();
 }
 
Index: linux-2.6/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/hw_irq.h
+++ linux-2.6/arch/x86/include/asm/hw_irq.h
@@ -91,7 +91,6 @@ struct irq_cfg {
 	u8			move_in_progress : 1;
 };
 
-extern struct irq_cfg *irq_cfg(unsigned int);
 extern int assign_irq_vector(struct irq_desc *, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
 
Index: linux-2.6/arch/x86/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq.h
+++ linux-2.6/arch/x86/include/asm/irq.h
@@ -31,15 +31,15 @@ static inline int irq_canonicalize(int i
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
