Return-Path: <linux-kernel-owner+w=401wt.eu-S934249AbZLFSFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249AbZLFSFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934134AbZLFSFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:05:42 -0500
Received: from www.tglx.de ([62.245.132.106]:33317 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934142AbZLFSEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:04:04 -0500
Message-Id: <20091206111958.068187290@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 20/23] genirq: Convert irq_desc.lock to raw_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=irq-convert-to-core-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/kernel/irq.c                     |    4 -
 arch/arm/include/asm/mach/irq.h             |    4 -
 arch/arm/kernel/irq.c                       |   12 +--
 arch/arm/mach-ns9xxx/irq.c                  |    8 +-
 arch/avr32/kernel/irq.c                     |    4 -
 arch/blackfin/kernel/irqchip.c              |    6 -
 arch/blackfin/kernel/traps.c                |    4 -
 arch/cris/kernel/irq.c                      |    4 -
 arch/frv/kernel/irq.c                       |    4 -
 arch/h8300/kernel/irq.c                     |    4 -
 arch/ia64/kernel/iosapic.c                  |    6 -
 arch/ia64/kernel/irq.c                      |    4 -
 arch/ia64/kernel/irq_ia64.c                 |    4 -
 arch/m32r/kernel/irq.c                      |    4 -
 arch/microblaze/kernel/irq.c                |    4 -
 arch/mips/kernel/irq.c                      |    4 -
 arch/mips/vr41xx/common/icu.c               |   92 ++++++++++++++--------------
 arch/mn10300/kernel/irq.c                   |    4 -
 arch/parisc/kernel/irq.c                    |    4 -
 arch/powerpc/kernel/irq.c                   |    8 +-
 arch/powerpc/platforms/52xx/media5200.c     |    8 +-
 arch/powerpc/platforms/cell/interrupt.c     |    8 +-
 arch/powerpc/platforms/iseries/irq.c        |    4 -
 arch/powerpc/platforms/pseries/eeh_driver.c |    4 -
 arch/powerpc/platforms/pseries/xics.c       |    4 -
 arch/powerpc/sysdev/fsl_msi.c               |    4 -
 arch/powerpc/sysdev/uic.c                   |    8 +-
 arch/sh/kernel/irq.c                        |    4 -
 arch/sparc/kernel/irq_64.c                  |    8 +-
 arch/um/kernel/irq.c                        |    4 -
 arch/x86/kernel/apic/io_apic.c              |    4 -
 arch/x86/kernel/irq.c                       |   14 ++--
 arch/xtensa/kernel/irq.c                    |    4 -
 include/linux/irq.h                         |    2 
 kernel/irq/autoprobe.c                      |   20 +++---
 kernel/irq/chip.c                           |   86 +++++++++++++-------------
 kernel/irq/handle.c                         |   22 +++---
 kernel/irq/internals.h                      |    2 
 kernel/irq/manage.c                         |   50 +++++++--------
 kernel/irq/migration.c                      |    2 
 kernel/irq/numa_migrate.c                   |    8 +-
 kernel/irq/pm.c                             |    8 +-
 kernel/irq/proc.c                           |    4 -
 kernel/irq/spurious.c                       |   14 ++--
 44 files changed, 242 insertions(+), 242 deletions(-)

Index: linux-2.6-tip/arch/alpha/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/alpha/kernel/irq.c
+++ linux-2.6-tip/arch/alpha/kernel/irq.c
@@ -81,7 +81,7 @@ show_interrupts(struct seq_file *p, void
 #endif
 
 	if (irq < ACTUAL_NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[irq].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[irq].lock, flags);
 		action = irq_desc[irq].action;
 		if (!action) 
 			goto unlock;
@@ -105,7 +105,7 @@ show_interrupts(struct seq_file *p, void
 
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	} else if (irq == ACTUAL_NR_IRQS) {
 #ifdef CONFIG_SMP
 		seq_puts(p, "IPI: ");
Index: linux-2.6-tip/arch/arm/include/asm/mach/irq.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/mach/irq.h
+++ linux-2.6-tip/arch/arm/include/asm/mach/irq.h
@@ -26,9 +26,9 @@ extern int show_fiq_list(struct seq_file
  */
 #define do_bad_IRQ(irq,desc)				\
 do {							\
-	spin_lock(&desc->lock);				\
+	raw_spin_lock(&desc->lock);			\
 	handle_bad_irq(irq, desc);			\
-	spin_unlock(&desc->lock);			\
+	raw_spin_unlock(&desc->lock);			\
 } while(0)
 
 #endif
Index: linux-2.6-tip/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/kernel/irq.c
+++ linux-2.6-tip/arch/arm/kernel/irq.c
@@ -69,7 +69,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto unlock;
@@ -84,7 +84,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 #ifdef CONFIG_FIQ
 		show_fiq_list(p, v);
@@ -139,7 +139,7 @@ void set_irq_flags(unsigned int irq, uns
 	}
 
 	desc = irq_desc + irq;
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
 	if (iflags & IRQF_VALID)
 		desc->status &= ~IRQ_NOREQUEST;
@@ -147,7 +147,7 @@ void set_irq_flags(unsigned int irq, uns
 		desc->status &= ~IRQ_NOPROBE;
 	if (!(iflags & IRQF_NOAUTOEN))
 		desc->status &= ~IRQ_NOAUTOEN;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 void __init init_IRQ(void)
@@ -166,9 +166,9 @@ static void route_irq(struct irq_desc *d
 {
 	pr_debug("IRQ%u: moving from cpu%u to cpu%u\n", irq, desc->node, cpu);
 
-	spin_lock_irq(&desc->lock);
+	raw_spin_lock_irq(&desc->lock);
 	desc->chip->set_affinity(irq, cpumask_of(cpu));
-	spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irq(&desc->lock);
 }
 
 /*
Index: linux-2.6-tip/arch/arm/mach-ns9xxx/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-ns9xxx/irq.c
+++ linux-2.6-tip/arch/arm/mach-ns9xxx/irq.c
@@ -66,7 +66,7 @@ static void handle_prio_irq(unsigned int
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 
 	BUG_ON(desc->status & IRQ_INPROGRESS);
 
@@ -78,7 +78,7 @@ static void handle_prio_irq(unsigned int
 		goto out_mask;
 
 	desc->status |= IRQ_INPROGRESS;
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);
 
@@ -87,7 +87,7 @@ static void handle_prio_irq(unsigned int
 	 * Maybe this function should go to kernel/irq/chip.c? */
 	note_interrupt(irq, desc, action_ret);
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 
 	if (desc->status & IRQ_DISABLED)
@@ -97,7 +97,7 @@ out_mask:
 	/* ack unconditionally to unmask lower prio irqs */
 	desc->chip->ack(irq);
 
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 #define handle_irq handle_prio_irq
 #endif
Index: linux-2.6-tip/arch/avr32/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/avr32/kernel/irq.c
+++ linux-2.6-tip/arch/avr32/kernel/irq.c
@@ -51,7 +51,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto unlock;
@@ -66,7 +66,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 	unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 
 	return 0;
Index: linux-2.6-tip/arch/blackfin/kernel/irqchip.c
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/kernel/irqchip.c
+++ linux-2.6-tip/arch/blackfin/kernel/irqchip.c
@@ -23,7 +23,7 @@ void ack_bad_irq(unsigned int irq)
 
 static struct irq_desc bad_irq_desc = {
 	.handle_irq = handle_bad_irq,
-	.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+	.lock = __RAW_SPIN_LOCK_UNLOCKED(bad_irq_desc.lock),
 };
 
 #ifdef CONFIG_CPUMASK_OFFSTACK
@@ -39,7 +39,7 @@ int show_interrupts(struct seq_file *p, 
 	unsigned long flags;
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -53,7 +53,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
  skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
Index: linux-2.6-tip/arch/blackfin/kernel/traps.c
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/kernel/traps.c
+++ linux-2.6-tip/arch/blackfin/kernel/traps.c
@@ -1140,7 +1140,7 @@ void show_regs(struct pt_regs *fp)
 	if (fp->ipend & ~0x3F) {
 		for (i = 0; i < (NR_IRQS - 1); i++) {
 			if (!in_atomic)
-				spin_lock_irqsave(&irq_desc[i].lock, flags);
+				raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 
 			action = irq_desc[i].action;
 			if (!action)
@@ -1155,7 +1155,7 @@ void show_regs(struct pt_regs *fp)
 			verbose_printk("\n");
 unlock:
 			if (!in_atomic)
-				spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+				raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 		}
 	}
 
Index: linux-2.6-tip/arch/cris/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/cris/kernel/irq.c
+++ linux-2.6-tip/arch/cris/kernel/irq.c
@@ -52,7 +52,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -71,7 +71,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 	return 0;
 }
Index: linux-2.6-tip/arch/frv/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/frv/kernel/irq.c
+++ linux-2.6-tip/arch/frv/kernel/irq.c
@@ -69,7 +69,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (action) {
 			seq_printf(p, "%3d: ", i);
@@ -85,7 +85,7 @@ int show_interrupts(struct seq_file *p, 
 			seq_putc(p, '\n');
 		}
 
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "Err: %10u\n", atomic_read(&irq_err_count));
 	}
Index: linux-2.6-tip/arch/h8300/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/h8300/kernel/irq.c
+++ linux-2.6-tip/arch/h8300/kernel/irq.c
@@ -186,7 +186,7 @@ int show_interrupts(struct seq_file *p, 
 		seq_puts(p, "           CPU0");
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto unlock;
@@ -200,7 +200,7 @@ int show_interrupts(struct seq_file *p, 
 			seq_printf(p, ", %s", action->name);
 		seq_putc(p, '\n');
 unlock:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 	return 0;
 }
Index: linux-2.6-tip/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6-tip/arch/ia64/kernel/iosapic.c
@@ -793,12 +793,12 @@ iosapic_register_intr (unsigned int gsi,
 			goto unlock_iosapic_lock;
 	}
 
-	spin_lock(&irq_desc[irq].lock);
+	raw_spin_lock(&irq_desc[irq].lock);
 	dest = get_target_cpu(gsi, irq);
 	dmode = choose_dmode();
 	err = register_intr(gsi, irq, dmode, polarity, trigger);
 	if (err < 0) {
-		spin_unlock(&irq_desc[irq].lock);
+		raw_spin_unlock(&irq_desc[irq].lock);
 		irq = err;
 		goto unlock_iosapic_lock;
 	}
@@ -817,7 +817,7 @@ iosapic_register_intr (unsigned int gsi,
 	       (polarity == IOSAPIC_POL_HIGH ? "high" : "low"),
 	       cpu_logical_id(dest), dest, irq_to_vector(irq));
 
-	spin_unlock(&irq_desc[irq].lock);
+	raw_spin_unlock(&irq_desc[irq].lock);
  unlock_iosapic_lock:
 	spin_unlock_irqrestore(&iosapic_lock, flags);
 	return irq;
Index: linux-2.6-tip/arch/ia64/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/irq.c
+++ linux-2.6-tip/arch/ia64/kernel/irq.c
@@ -71,7 +71,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -91,7 +91,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS)
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
 	return 0;
Index: linux-2.6-tip/arch/ia64/kernel/irq_ia64.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/irq_ia64.c
+++ linux-2.6-tip/arch/ia64/kernel/irq_ia64.c
@@ -345,7 +345,7 @@ static irqreturn_t smp_irq_move_cleanup_
 
 		desc = irq_desc + irq;
 		cfg = irq_cfg + irq;
-		spin_lock(&desc->lock);
+		raw_spin_lock(&desc->lock);
 		if (!cfg->move_cleanup_count)
 			goto unlock;
 
@@ -358,7 +358,7 @@ static irqreturn_t smp_irq_move_cleanup_
 		spin_unlock_irqrestore(&vector_lock, flags);
 		cfg->move_cleanup_count--;
 	unlock:
-		spin_unlock(&desc->lock);
+		raw_spin_unlock(&desc->lock);
 	}
 	return IRQ_HANDLED;
 }
Index: linux-2.6-tip/arch/m32r/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/m32r/kernel/irq.c
+++ linux-2.6-tip/arch/m32r/kernel/irq.c
@@ -40,7 +40,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -59,7 +59,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 	return 0;
 }
Index: linux-2.6-tip/arch/microblaze/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/microblaze/kernel/irq.c
+++ linux-2.6-tip/arch/microblaze/kernel/irq.c
@@ -68,7 +68,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < nr_irq) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -89,7 +89,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 	return 0;
 }
Index: linux-2.6-tip/arch/mips/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/kernel/irq.c
+++ linux-2.6-tip/arch/mips/kernel/irq.c
@@ -99,7 +99,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -118,7 +118,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_putc(p, '\n');
 		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
Index: linux-2.6-tip/arch/mips/vr41xx/common/icu.c
===================================================================
--- linux-2.6-tip.orig/arch/mips/vr41xx/common/icu.c
+++ linux-2.6-tip/arch/mips/vr41xx/common/icu.c
@@ -159,9 +159,9 @@ void vr41xx_enable_piuint(uint16_t mask)
 
 	if (current_cpu_type() == CPU_VR4111 ||
 	    current_cpu_type() == CPU_VR4121) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu1_set(MPIUINTREG, mask);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -174,9 +174,9 @@ void vr41xx_disable_piuint(uint16_t mask
 
 	if (current_cpu_type() == CPU_VR4111 ||
 	    current_cpu_type() == CPU_VR4121) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu1_clear(MPIUINTREG, mask);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -189,9 +189,9 @@ void vr41xx_enable_aiuint(uint16_t mask)
 
 	if (current_cpu_type() == CPU_VR4111 ||
 	    current_cpu_type() == CPU_VR4121) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu1_set(MAIUINTREG, mask);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -204,9 +204,9 @@ void vr41xx_disable_aiuint(uint16_t mask
 
 	if (current_cpu_type() == CPU_VR4111 ||
 	    current_cpu_type() == CPU_VR4121) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu1_clear(MAIUINTREG, mask);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -219,9 +219,9 @@ void vr41xx_enable_kiuint(uint16_t mask)
 
 	if (current_cpu_type() == CPU_VR4111 ||
 	    current_cpu_type() == CPU_VR4121) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu1_set(MKIUINTREG, mask);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -234,9 +234,9 @@ void vr41xx_disable_kiuint(uint16_t mask
 
 	if (current_cpu_type() == CPU_VR4111 ||
 	    current_cpu_type() == CPU_VR4121) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu1_clear(MKIUINTREG, mask);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -247,9 +247,9 @@ void vr41xx_enable_macint(uint16_t mask)
 	struct irq_desc *desc = irq_desc + ETHERNET_IRQ;
 	unsigned long flags;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	icu1_set(MMACINTREG, mask);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 EXPORT_SYMBOL(vr41xx_enable_macint);
@@ -259,9 +259,9 @@ void vr41xx_disable_macint(uint16_t mask
 	struct irq_desc *desc = irq_desc + ETHERNET_IRQ;
 	unsigned long flags;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	icu1_clear(MMACINTREG, mask);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 EXPORT_SYMBOL(vr41xx_disable_macint);
@@ -271,9 +271,9 @@ void vr41xx_enable_dsiuint(uint16_t mask
 	struct irq_desc *desc = irq_desc + DSIU_IRQ;
 	unsigned long flags;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	icu1_set(MDSIUINTREG, mask);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 EXPORT_SYMBOL(vr41xx_enable_dsiuint);
@@ -283,9 +283,9 @@ void vr41xx_disable_dsiuint(uint16_t mas
 	struct irq_desc *desc = irq_desc + DSIU_IRQ;
 	unsigned long flags;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	icu1_clear(MDSIUINTREG, mask);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 EXPORT_SYMBOL(vr41xx_disable_dsiuint);
@@ -295,9 +295,9 @@ void vr41xx_enable_firint(uint16_t mask)
 	struct irq_desc *desc = irq_desc + FIR_IRQ;
 	unsigned long flags;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	icu2_set(MFIRINTREG, mask);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 EXPORT_SYMBOL(vr41xx_enable_firint);
@@ -307,9 +307,9 @@ void vr41xx_disable_firint(uint16_t mask
 	struct irq_desc *desc = irq_desc + FIR_IRQ;
 	unsigned long flags;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	icu2_clear(MFIRINTREG, mask);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 EXPORT_SYMBOL(vr41xx_disable_firint);
@@ -322,9 +322,9 @@ void vr41xx_enable_pciint(void)
 	if (current_cpu_type() == CPU_VR4122 ||
 	    current_cpu_type() == CPU_VR4131 ||
 	    current_cpu_type() == CPU_VR4133) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu2_write(MPCIINTREG, PCIINT0);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -338,9 +338,9 @@ void vr41xx_disable_pciint(void)
 	if (current_cpu_type() == CPU_VR4122 ||
 	    current_cpu_type() == CPU_VR4131 ||
 	    current_cpu_type() == CPU_VR4133) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu2_write(MPCIINTREG, 0);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -354,9 +354,9 @@ void vr41xx_enable_scuint(void)
 	if (current_cpu_type() == CPU_VR4122 ||
 	    current_cpu_type() == CPU_VR4131 ||
 	    current_cpu_type() == CPU_VR4133) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu2_write(MSCUINTREG, SCUINT0);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -370,9 +370,9 @@ void vr41xx_disable_scuint(void)
 	if (current_cpu_type() == CPU_VR4122 ||
 	    current_cpu_type() == CPU_VR4131 ||
 	    current_cpu_type() == CPU_VR4133) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu2_write(MSCUINTREG, 0);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -386,9 +386,9 @@ void vr41xx_enable_csiint(uint16_t mask)
 	if (current_cpu_type() == CPU_VR4122 ||
 	    current_cpu_type() == CPU_VR4131 ||
 	    current_cpu_type() == CPU_VR4133) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu2_set(MCSIINTREG, mask);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -402,9 +402,9 @@ void vr41xx_disable_csiint(uint16_t mask
 	if (current_cpu_type() == CPU_VR4122 ||
 	    current_cpu_type() == CPU_VR4131 ||
 	    current_cpu_type() == CPU_VR4133) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu2_clear(MCSIINTREG, mask);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -418,9 +418,9 @@ void vr41xx_enable_bcuint(void)
 	if (current_cpu_type() == CPU_VR4122 ||
 	    current_cpu_type() == CPU_VR4131 ||
 	    current_cpu_type() == CPU_VR4133) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu2_write(MBCUINTREG, BCUINTR);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -434,9 +434,9 @@ void vr41xx_disable_bcuint(void)
 	if (current_cpu_type() == CPU_VR4122 ||
 	    current_cpu_type() == CPU_VR4131 ||
 	    current_cpu_type() == CPU_VR4133) {
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		icu2_write(MBCUINTREG, 0);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 
@@ -486,7 +486,7 @@ static inline int set_sysint1_assign(uns
 
 	pin = SYSINT1_IRQ_TO_PIN(irq);
 
-	spin_lock_irq(&desc->lock);
+	raw_spin_lock_irq(&desc->lock);
 
 	intassign0 = icu1_read(INTASSIGN0);
 	intassign1 = icu1_read(INTASSIGN1);
@@ -525,7 +525,7 @@ static inline int set_sysint1_assign(uns
 		intassign1 |= (uint16_t)assign << 9;
 		break;
 	default:
-		spin_unlock_irq(&desc->lock);
+		raw_spin_unlock_irq(&desc->lock);
 		return -EINVAL;
 	}
 
@@ -533,7 +533,7 @@ static inline int set_sysint1_assign(uns
 	icu1_write(INTASSIGN0, intassign0);
 	icu1_write(INTASSIGN1, intassign1);
 
-	spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irq(&desc->lock);
 
 	return 0;
 }
@@ -546,7 +546,7 @@ static inline int set_sysint2_assign(uns
 
 	pin = SYSINT2_IRQ_TO_PIN(irq);
 
-	spin_lock_irq(&desc->lock);
+	raw_spin_lock_irq(&desc->lock);
 
 	intassign2 = icu1_read(INTASSIGN2);
 	intassign3 = icu1_read(INTASSIGN3);
@@ -593,7 +593,7 @@ static inline int set_sysint2_assign(uns
 		intassign3 |= (uint16_t)assign << 12;
 		break;
 	default:
-		spin_unlock_irq(&desc->lock);
+		raw_spin_unlock_irq(&desc->lock);
 		return -EINVAL;
 	}
 
@@ -601,7 +601,7 @@ static inline int set_sysint2_assign(uns
 	icu1_write(INTASSIGN2, intassign2);
 	icu1_write(INTASSIGN3, intassign3);
 
-	spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irq(&desc->lock);
 
 	return 0;
 }
Index: linux-2.6-tip/arch/mn10300/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/mn10300/kernel/irq.c
+++ linux-2.6-tip/arch/mn10300/kernel/irq.c
@@ -215,7 +215,7 @@ int show_interrupts(struct seq_file *p, 
 
 		/* display information rows, one per active CPU */
 	case 1 ... NR_IRQS - 1:
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 
 		action = irq_desc[i].action;
 		if (action) {
@@ -235,7 +235,7 @@ int show_interrupts(struct seq_file *p, 
 			seq_putc(p, '\n');
 		}
 
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 		break;
 
 		/* polish off with NMI and error counters */
Index: linux-2.6-tip/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/parisc/kernel/irq.c
+++ linux-2.6-tip/arch/parisc/kernel/irq.c
@@ -180,7 +180,7 @@ int show_interrupts(struct seq_file *p, 
 	if (i < NR_IRQS) {
 		struct irqaction *action;
 
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -224,7 +224,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
  skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	}
 
 	return 0;
Index: linux-2.6-tip/arch/powerpc/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/irq.c
+++ linux-2.6-tip/arch/powerpc/kernel/irq.c
@@ -193,7 +193,7 @@ int show_interrupts(struct seq_file *p, 
 
 	if (i < NR_IRQS) {
 		desc = get_irq_desc(i);
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		action = desc->action;
 		if (!action || !action->handler)
 			goto skip;
@@ -214,7 +214,7 @@ int show_interrupts(struct seq_file *p, 
 			seq_printf(p, ", %s", action->name);
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	} else if (i == NR_IRQS) {
 #if defined(CONFIG_PPC32) && defined(CONFIG_TAU_INT)
 		if (tau_initialized){
@@ -1071,7 +1071,7 @@ static int virq_debug_show(struct seq_fi
 
 	for (i = 1; i < NR_IRQS; i++) {
 		desc = get_irq_desc(i);
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 
 		if (desc->action && desc->action->handler) {
 			seq_printf(m, "%5d  ", i);
@@ -1090,7 +1090,7 @@ static int virq_debug_show(struct seq_fi
 			seq_printf(m, "%s\n", p);
 		}
 
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
 	return 0;
Index: linux-2.6-tip/arch/powerpc/platforms/52xx/media5200.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/52xx/media5200.c
+++ linux-2.6-tip/arch/powerpc/platforms/52xx/media5200.c
@@ -86,9 +86,9 @@ void media5200_irq_cascade(unsigned int 
 	u32 status, enable;
 
 	/* Mask off the cascaded IRQ */
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	desc->chip->mask(virq);
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	/* Ask the FPGA for IRQ status.  If 'val' is 0, then no irqs
 	 * are pending.  'ffs()' is 1 based */
@@ -104,11 +104,11 @@ void media5200_irq_cascade(unsigned int 
 	}
 
 	/* Processing done; can reenable the cascade now */
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	desc->chip->ack(virq);
 	if (!(desc->status & IRQ_DISABLED))
 		desc->chip->unmask(virq);
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 
 static int media5200_irq_map(struct irq_host *h, unsigned int virq,
Index: linux-2.6-tip/arch/powerpc/platforms/cell/interrupt.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/interrupt.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/interrupt.c
@@ -237,7 +237,7 @@ extern int noirqdebug;
 
 static void handle_iic_irq(unsigned int irq, struct irq_desc *desc)
 {
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 
@@ -265,18 +265,18 @@ static void handle_iic_irq(unsigned int 
 			goto out_eoi;
 
 		desc->status &= ~IRQ_PENDING;
-		spin_unlock(&desc->lock);
+		raw_spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
-		spin_lock(&desc->lock);
+		raw_spin_lock(&desc->lock);
 
 	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
 
 	desc->status &= ~IRQ_INPROGRESS;
 out_eoi:
 	desc->chip->eoi(irq);
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 
 static int iic_host_map(struct irq_host *h, unsigned int virq,
Index: linux-2.6-tip/arch/powerpc/platforms/iseries/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/iseries/irq.c
+++ linux-2.6-tip/arch/powerpc/platforms/iseries/irq.c
@@ -217,9 +217,9 @@ void __init iSeries_activate_IRQs()
 		struct irq_desc *desc = get_irq_desc(irq);
 
 		if (desc && desc->chip && desc->chip->startup) {
-			spin_lock_irqsave(&desc->lock, flags);
+			raw_spin_lock_irqsave(&desc->lock, flags);
 			desc->chip->startup(irq);
-			spin_unlock_irqrestore(&desc->lock, flags);
+			raw_spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
 }
Index: linux-2.6-tip/arch/powerpc/platforms/pseries/eeh_driver.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/pseries/eeh_driver.c
+++ linux-2.6-tip/arch/powerpc/platforms/pseries/eeh_driver.c
@@ -72,10 +72,10 @@ static int irq_in_use(unsigned int irq)
 	unsigned long flags;
    struct irq_desc *desc = irq_desc + irq;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action)
 		rc = 1;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return rc;
 }
 
Index: linux-2.6-tip/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6-tip/arch/powerpc/platforms/pseries/xics.c
@@ -860,7 +860,7 @@ void xics_migrate_irqs_away(void)
 		    || desc->chip->set_affinity == NULL)
 			continue;
 
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 
 		status = rtas_call(ibm_get_xive, 1, 3, xics_status, irq);
 		if (status) {
@@ -884,7 +884,7 @@ void xics_migrate_irqs_away(void)
 		cpumask_setall(irq_desc[virq].affinity);
 		desc->chip->set_affinity(virq, cpu_all_mask);
 unlock:
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 #endif
Index: linux-2.6-tip/arch/powerpc/sysdev/fsl_msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/fsl_msi.c
+++ linux-2.6-tip/arch/powerpc/sysdev/fsl_msi.c
@@ -173,7 +173,7 @@ static void fsl_msi_cascade(unsigned int
 	u32 intr_index;
 	u32 have_shift = 0;
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	if ((msi_data->feature &  FSL_PIC_IP_MASK) == FSL_PIC_IP_IPIC) {
 		if (desc->chip->mask_ack)
 			desc->chip->mask_ack(irq);
@@ -225,7 +225,7 @@ static void fsl_msi_cascade(unsigned int
 		break;
 	}
 unlock:
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 
 static int __devinit fsl_of_msi_probe(struct of_device *dev,
Index: linux-2.6-tip/arch/powerpc/sysdev/uic.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/uic.c
+++ linux-2.6-tip/arch/powerpc/sysdev/uic.c
@@ -225,12 +225,12 @@ void uic_irq_cascade(unsigned int virq, 
 	int src;
 	int subvirq;
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	if (desc->status & IRQ_LEVEL)
 		desc->chip->mask(virq);
 	else
 		desc->chip->mask_ack(virq);
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	msr = mfdcr(uic->dcrbase + UIC_MSR);
 	if (!msr) /* spurious interrupt */
@@ -242,12 +242,12 @@ void uic_irq_cascade(unsigned int virq, 
 	generic_handle_irq(subvirq);
 
 uic_irq_ret:
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	if (desc->status & IRQ_LEVEL)
 		desc->chip->ack(virq);
 	if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(virq);
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 
 static struct uic * __init uic_init_one(struct device_node *node)
Index: linux-2.6-tip/arch/sh/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/sh/kernel/irq.c
+++ linux-2.6-tip/arch/sh/kernel/irq.c
@@ -68,7 +68,7 @@ int show_interrupts(struct seq_file *p, 
 	if (!desc)
 		return 0;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	for_each_online_cpu(j)
 		any_count |= kstat_irqs_cpu(i, j);
 	action = desc->action;
@@ -89,7 +89,7 @@ int show_interrupts(struct seq_file *p, 
 
 	seq_putc(p, '\n');
 out:
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
 #endif
Index: linux-2.6-tip/arch/sparc/kernel/irq_64.c
===================================================================
--- linux-2.6-tip.orig/arch/sparc/kernel/irq_64.c
+++ linux-2.6-tip/arch/sparc/kernel/irq_64.c
@@ -176,7 +176,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -195,7 +195,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
@@ -785,14 +785,14 @@ void fixup_irqs(void)
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		unsigned long flags;
 
-		spin_lock_irqsave(&irq_desc[irq].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[irq].lock, flags);
 		if (irq_desc[irq].action &&
 		    !(irq_desc[irq].status & IRQ_PER_CPU)) {
 			if (irq_desc[irq].chip->set_affinity)
 				irq_desc[irq].chip->set_affinity(irq,
 					irq_desc[irq].affinity);
 		}
-		spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[irq].lock, flags);
 	}
 
 	tick_ops->disable_irq();
Index: linux-2.6-tip/arch/um/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/um/kernel/irq.c
+++ linux-2.6-tip/arch/um/kernel/irq.c
@@ -34,7 +34,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -53,7 +53,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS)
 		seq_putc(p, '\n');
 
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -2431,7 +2431,7 @@ asmlinkage void smp_irq_move_cleanup_int
 			continue;
 
 		cfg = irq_cfg(irq);
-		spin_lock(&desc->lock);
+		raw_spin_lock(&desc->lock);
 
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
@@ -2450,7 +2450,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		}
 		__get_cpu_var(vector_irq)[vector] = -1;
 unlock:
-		spin_unlock(&desc->lock);
+		raw_spin_unlock(&desc->lock);
 	}
 
 	irq_exit();
Index: linux-2.6-tip/arch/x86/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/irq.c
+++ linux-2.6-tip/arch/x86/kernel/irq.c
@@ -149,7 +149,7 @@ int show_interrupts(struct seq_file *p, 
 	if (!desc)
 		return 0;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	for_each_online_cpu(j)
 		any_count |= kstat_irqs_cpu(i, j);
 	action = desc->action;
@@ -170,7 +170,7 @@ int show_interrupts(struct seq_file *p, 
 
 	seq_putc(p, '\n');
 out:
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
 
@@ -294,12 +294,12 @@ void fixup_irqs(void)
 			continue;
 
 		/* interrupt's are disabled at this point */
-		spin_lock(&desc->lock);
+		raw_spin_lock(&desc->lock);
 
 		affinity = desc->affinity;
 		if (!irq_has_action(irq) ||
 		    cpumask_equal(affinity, cpu_online_mask)) {
-			spin_unlock(&desc->lock);
+			raw_spin_unlock(&desc->lock);
 			continue;
 		}
 
@@ -326,7 +326,7 @@ void fixup_irqs(void)
 		if (!(desc->status & IRQ_MOVE_PCNTXT) && desc->chip->unmask)
 			desc->chip->unmask(irq);
 
-		spin_unlock(&desc->lock);
+		raw_spin_unlock(&desc->lock);
 
 		if (break_affinity && set_affinity)
 			printk("Broke affinity for irq %i\n", irq);
@@ -356,10 +356,10 @@ void fixup_irqs(void)
 			irq = __get_cpu_var(vector_irq)[vector];
 
 			desc = irq_to_desc(irq);
-			spin_lock(&desc->lock);
+			raw_spin_lock(&desc->lock);
 			if (desc->chip->retrigger)
 				desc->chip->retrigger(irq);
-			spin_unlock(&desc->lock);
+			raw_spin_unlock(&desc->lock);
 		}
 	}
 }
Index: linux-2.6-tip/arch/xtensa/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/xtensa/kernel/irq.c
+++ linux-2.6-tip/arch/xtensa/kernel/irq.c
@@ -90,7 +90,7 @@ int show_interrupts(struct seq_file *p, 
 	}
 
 	if (i < NR_IRQS) {
-		spin_lock_irqsave(&irq_desc[i].lock, flags);
+		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
 		action = irq_desc[i].action;
 		if (!action)
 			goto skip;
@@ -109,7 +109,7 @@ int show_interrupts(struct seq_file *p, 
 
 		seq_putc(p, '\n');
 skip:
-		spin_unlock_irqrestore(&irq_desc[i].lock, flags);
+		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
 	} else if (i == NR_IRQS) {
 		seq_printf(p, "NMI: ");
 		for_each_online_cpu(j)
Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -192,7 +192,7 @@ struct irq_desc {
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
-	spinlock_t		lock;
+	raw_spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
 	unsigned int		node;
Index: linux-2.6-tip/kernel/irq/autoprobe.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/autoprobe.c
+++ linux-2.6-tip/kernel/irq/autoprobe.c
@@ -45,7 +45,7 @@ unsigned long probe_irq_on(void)
 	 * flush such a longstanding irq before considering it as spurious.
 	 */
 	for_each_irq_desc_reverse(i, desc) {
-		spin_lock_irq(&desc->lock);
+		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			/*
 			 * An old-style architecture might still have
@@ -61,7 +61,7 @@ unsigned long probe_irq_on(void)
 				desc->chip->set_type(i, IRQ_TYPE_PROBE);
 			desc->chip->startup(i);
 		}
-		spin_unlock_irq(&desc->lock);
+		raw_spin_unlock_irq(&desc->lock);
 	}
 
 	/* Wait for longstanding interrupts to trigger. */
@@ -73,13 +73,13 @@ unsigned long probe_irq_on(void)
 	 * happened in the previous stage, it may have masked itself)
 	 */
 	for_each_irq_desc_reverse(i, desc) {
-		spin_lock_irq(&desc->lock);
+		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
 			if (desc->chip->startup(i))
 				desc->status |= IRQ_PENDING;
 		}
-		spin_unlock_irq(&desc->lock);
+		raw_spin_unlock_irq(&desc->lock);
 	}
 
 	/*
@@ -91,7 +91,7 @@ unsigned long probe_irq_on(void)
 	 * Now filter out any obviously spurious interrupts
 	 */
 	for_each_irq_desc(i, desc) {
-		spin_lock_irq(&desc->lock);
+		raw_spin_lock_irq(&desc->lock);
 		status = desc->status;
 
 		if (status & IRQ_AUTODETECT) {
@@ -103,7 +103,7 @@ unsigned long probe_irq_on(void)
 				if (i < 32)
 					mask |= 1 << i;
 		}
-		spin_unlock_irq(&desc->lock);
+		raw_spin_unlock_irq(&desc->lock);
 	}
 
 	return mask;
@@ -129,7 +129,7 @@ unsigned int probe_irq_mask(unsigned lon
 	int i;
 
 	for_each_irq_desc(i, desc) {
-		spin_lock_irq(&desc->lock);
+		raw_spin_lock_irq(&desc->lock);
 		status = desc->status;
 
 		if (status & IRQ_AUTODETECT) {
@@ -139,7 +139,7 @@ unsigned int probe_irq_mask(unsigned lon
 			desc->status = status & ~IRQ_AUTODETECT;
 			desc->chip->shutdown(i);
 		}
-		spin_unlock_irq(&desc->lock);
+		raw_spin_unlock_irq(&desc->lock);
 	}
 	mutex_unlock(&probing_active);
 
@@ -171,7 +171,7 @@ int probe_irq_off(unsigned long val)
 	unsigned int status;
 
 	for_each_irq_desc(i, desc) {
-		spin_lock_irq(&desc->lock);
+		raw_spin_lock_irq(&desc->lock);
 		status = desc->status;
 
 		if (status & IRQ_AUTODETECT) {
@@ -183,7 +183,7 @@ int probe_irq_off(unsigned long val)
 			desc->status = status & ~IRQ_AUTODETECT;
 			desc->chip->shutdown(i);
 		}
-		spin_unlock_irq(&desc->lock);
+		raw_spin_unlock_irq(&desc->lock);
 	}
 	mutex_unlock(&probing_active);
 
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -34,7 +34,7 @@ void dynamic_irq_init(unsigned int irq)
 	}
 
 	/* Ensure we don't have left over values from a previous use of this irq */
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->status = IRQ_DISABLED;
 	desc->chip = &no_irq_chip;
 	desc->handle_irq = handle_bad_irq;
@@ -51,7 +51,7 @@ void dynamic_irq_init(unsigned int irq)
 	cpumask_clear(desc->pending_mask);
 #endif
 #endif
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 /**
@@ -68,9 +68,9 @@ void dynamic_irq_cleanup(unsigned int ir
 		return;
 	}
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (desc->action) {
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 		WARN(1, KERN_ERR "Destroying IRQ%d without calling free_irq\n",
 			irq);
 		return;
@@ -82,7 +82,7 @@ void dynamic_irq_cleanup(unsigned int ir
 	desc->chip = &no_irq_chip;
 	desc->name = NULL;
 	clear_kstat_irqs(desc);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 
@@ -104,10 +104,10 @@ int set_irq_chip(unsigned int irq, struc
 	if (!chip)
 		chip = &no_irq_chip;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	irq_chip_set_defaults(chip);
 	desc->chip = chip;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	return 0;
 }
@@ -133,9 +133,9 @@ int set_irq_type(unsigned int irq, unsig
 	if (type == IRQ_TYPE_NONE)
 		return 0;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	ret = __irq_set_trigger(desc, irq, type);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(set_irq_type);
@@ -158,9 +158,9 @@ int set_irq_data(unsigned int irq, void 
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->handler_data = data;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
 EXPORT_SYMBOL(set_irq_data);
@@ -183,11 +183,11 @@ int set_irq_msi(unsigned int irq, struct
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->msi_desc = entry;
 	if (entry)
 		entry->irq = irq;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
 
@@ -214,9 +214,9 @@ int set_irq_chip_data(unsigned int irq, 
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->chip_data = data;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	return 0;
 }
@@ -241,12 +241,12 @@ void set_irq_nested_thread(unsigned int 
 	if (!desc)
 		return;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (nest)
 		desc->status |= IRQ_NESTED_THREAD;
 	else
 		desc->status &= ~IRQ_NESTED_THREAD;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 
@@ -343,7 +343,7 @@ void handle_nested_irq(unsigned int irq)
 
 	might_sleep();
 
-	spin_lock_irq(&desc->lock);
+	raw_spin_lock_irq(&desc->lock);
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
@@ -352,17 +352,17 @@ void handle_nested_irq(unsigned int irq)
 		goto out_unlock;
 
 	desc->status |= IRQ_INPROGRESS;
-	spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irq(&desc->lock);
 
 	action_ret = action->thread_fn(action->irq, action->dev_id);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	spin_lock_irq(&desc->lock);
+	raw_spin_lock_irq(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 
 out_unlock:
-	spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irq(&desc->lock);
 }
 EXPORT_SYMBOL_GPL(handle_nested_irq);
 
@@ -384,7 +384,7 @@ handle_simple_irq(unsigned int irq, stru
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -396,16 +396,16 @@ handle_simple_irq(unsigned int irq, stru
 		goto out_unlock;
 
 	desc->status |= IRQ_INPROGRESS;
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out_unlock:
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 
 /**
@@ -424,7 +424,7 @@ handle_level_irq(unsigned int irq, struc
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	mask_ack_irq(desc, irq);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
@@ -441,13 +441,13 @@ handle_level_irq(unsigned int irq, struc
 		goto out_unlock;
 
 	desc->status |= IRQ_INPROGRESS;
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 
 	if (unlikely(desc->status & IRQ_ONESHOT))
@@ -455,7 +455,7 @@ handle_level_irq(unsigned int irq, struc
 	else if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
 		desc->chip->unmask(irq);
 out_unlock:
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 EXPORT_SYMBOL_GPL(handle_level_irq);
 
@@ -475,7 +475,7 @@ handle_fasteoi_irq(unsigned int irq, str
 	struct irqaction *action;
 	irqreturn_t action_ret;
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out;
@@ -497,18 +497,18 @@ handle_fasteoi_irq(unsigned int irq, str
 
 	desc->status |= IRQ_INPROGRESS;
 	desc->status &= ~IRQ_PENDING;
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	action_ret = handle_IRQ_event(irq, action);
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
 	desc->chip->eoi(irq);
 
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 
 /**
@@ -530,7 +530,7 @@ out:
 void
 handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 {
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 
 	desc->status &= ~(IRQ_REPLAY | IRQ_WAITING);
 
@@ -576,17 +576,17 @@ handle_edge_irq(unsigned int irq, struct
 		}
 
 		desc->status &= ~IRQ_PENDING;
-		spin_unlock(&desc->lock);
+		raw_spin_unlock(&desc->lock);
 		action_ret = handle_IRQ_event(irq, action);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
-		spin_lock(&desc->lock);
+		raw_spin_lock(&desc->lock);
 
 	} while ((desc->status & (IRQ_PENDING | IRQ_DISABLED)) == IRQ_PENDING);
 
 	desc->status &= ~IRQ_INPROGRESS;
 out_unlock:
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 }
 
 /**
@@ -643,7 +643,7 @@ __set_irq_handler(unsigned int irq, irq_
 	}
 
 	chip_bus_lock(irq, desc);
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
@@ -661,7 +661,7 @@ __set_irq_handler(unsigned int irq, irq_
 		desc->depth = 0;
 		desc->chip->startup(irq);
 	}
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL_GPL(__set_irq_handler);
@@ -692,9 +692,9 @@ void __init set_irq_noprobe(unsigned int
 		return;
 	}
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_NOPROBE;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 void __init set_irq_probe(unsigned int irq)
@@ -707,7 +707,7 @@ void __init set_irq_probe(unsigned int i
 		return;
 	}
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	desc->status &= ~IRQ_NOPROBE;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -80,7 +80,7 @@ static struct irq_desc irq_desc_init = {
 	.chip	    = &no_irq_chip,
 	.handle_irq = handle_bad_irq,
 	.depth      = 1,
-	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+	.lock       = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
 };
 
 void __ref init_kstat_irqs(struct irq_desc *desc, int node, int nr)
@@ -108,7 +108,7 @@ static void init_one_irq_desc(int irq, s
 {
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 
-	spin_lock_init(&desc->lock);
+	raw_spin_lock_init(&desc->lock);
 	desc->irq = irq;
 #ifdef CONFIG_SMP
 	desc->node = node;
@@ -130,7 +130,7 @@ static void init_one_irq_desc(int irq, s
 /*
  * Protect the sparse_irqs:
  */
-DEFINE_SPINLOCK(sparse_irq_lock);
+DEFINE_RAW_SPINLOCK(sparse_irq_lock);
 
 struct irq_desc **irq_desc_ptrs __read_mostly;
 
@@ -141,7 +141,7 @@ static struct irq_desc irq_desc_legacy[N
 		.chip	    = &no_irq_chip,
 		.handle_irq = handle_bad_irq,
 		.depth	    = 1,
-		.lock	    = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
+		.lock	    = __RAW_SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
 	}
 };
 
@@ -212,7 +212,7 @@ struct irq_desc * __ref irq_to_desc_allo
 	if (desc)
 		return desc;
 
-	spin_lock_irqsave(&sparse_irq_lock, flags);
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 
 	/* We have to check it to avoid races with another CPU */
 	desc = irq_desc_ptrs[irq];
@@ -234,7 +234,7 @@ struct irq_desc * __ref irq_to_desc_allo
 	irq_desc_ptrs[irq] = desc;
 
 out_unlock:
-	spin_unlock_irqrestore(&sparse_irq_lock, flags);
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
 
 	return desc;
 }
@@ -247,7 +247,7 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 		.chip = &no_irq_chip,
 		.handle_irq = handle_bad_irq,
 		.depth = 1,
-		.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
+		.lock = __RAW_SPIN_LOCK_UNLOCKED(irq_desc->lock),
 	}
 };
 
@@ -473,7 +473,7 @@ unsigned int __do_IRQ(unsigned int irq)
 		return 1;
 	}
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	if (desc->chip->ack)
 		desc->chip->ack(irq);
 	/*
@@ -517,13 +517,13 @@ unsigned int __do_IRQ(unsigned int irq)
 	for (;;) {
 		irqreturn_t action_ret;
 
-		spin_unlock(&desc->lock);
+		raw_spin_unlock(&desc->lock);
 
 		action_ret = handle_IRQ_event(irq, action);
 		if (!noirqdebug)
 			note_interrupt(irq, desc, action_ret);
 
-		spin_lock(&desc->lock);
+		raw_spin_lock(&desc->lock);
 		if (likely(!(desc->status & IRQ_PENDING)))
 			break;
 		desc->status &= ~IRQ_PENDING;
@@ -536,7 +536,7 @@ out:
 	 * disabled while the handler was running.
 	 */
 	desc->chip->end(irq);
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	return 1;
 }
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -18,7 +18,7 @@ extern void __enable_irq(struct irq_desc
 extern struct lock_class_key irq_desc_lock_class;
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 extern void clear_kstat_irqs(struct irq_desc *desc);
-extern spinlock_t sparse_irq_lock;
+extern raw_spinlock_t sparse_irq_lock;
 
 #ifdef CONFIG_SPARSE_IRQ
 /* irq_desc_ptrs allocated at boot time */
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -46,9 +46,9 @@ void synchronize_irq(unsigned int irq)
 			cpu_relax();
 
 		/* Ok, that indicated we're done: double-check carefully. */
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		status = desc->status;
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 		/* Oops, that failed? */
 	} while (status & IRQ_INPROGRESS);
@@ -114,7 +114,7 @@ int irq_set_affinity(unsigned int irq, c
 	if (!desc->chip->set_affinity)
 		return -EINVAL;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT) {
@@ -134,7 +134,7 @@ int irq_set_affinity(unsigned int irq, c
 	}
 #endif
 	desc->status |= IRQ_AFFINITY_SET;
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
 
@@ -181,11 +181,11 @@ int irq_select_affinity_usr(unsigned int
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	ret = setup_affinity(irq, desc);
 	if (!ret)
 		irq_set_thread_affinity(desc);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	return ret;
 }
@@ -231,9 +231,9 @@ void disable_irq_nosync(unsigned int irq
 		return;
 
 	chip_bus_lock(irq, desc);
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	__disable_irq(desc, irq, false);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
@@ -308,9 +308,9 @@ void enable_irq(unsigned int irq)
 		return;
 
 	chip_bus_lock(irq, desc);
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	__enable_irq(desc, irq, false);
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(irq, desc);
 }
 EXPORT_SYMBOL(enable_irq);
@@ -347,7 +347,7 @@ int set_irq_wake(unsigned int irq, unsig
 	/* wakeup-capable irqs can be shared between drivers that
 	 * don't need to have the same sleep mode behaviors.
 	 */
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (on) {
 		if (desc->wake_depth++ == 0) {
 			ret = set_irq_wake_real(irq, on);
@@ -368,7 +368,7 @@ int set_irq_wake(unsigned int irq, unsig
 		}
 	}
 
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(set_irq_wake);
@@ -484,12 +484,12 @@ static int irq_wait_for_interrupt(struct
 static void irq_finalize_oneshot(unsigned int irq, struct irq_desc *desc)
 {
 	chip_bus_lock(irq, desc);
-	spin_lock_irq(&desc->lock);
+	raw_spin_lock_irq(&desc->lock);
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
 		desc->chip->unmask(irq);
 	}
-	spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(irq, desc);
 }
 
@@ -514,9 +514,9 @@ irq_thread_check_affinity(struct irq_des
 		return;
 	}
 
-	spin_lock_irq(&desc->lock);
+	raw_spin_lock_irq(&desc->lock);
 	cpumask_copy(mask, desc->affinity);
-	spin_unlock_irq(&desc->lock);
+	raw_spin_unlock_irq(&desc->lock);
 
 	set_cpus_allowed_ptr(current, mask);
 	free_cpumask_var(mask);
@@ -545,7 +545,7 @@ static int irq_thread(void *data)
 
 		atomic_inc(&desc->threads_active);
 
-		spin_lock_irq(&desc->lock);
+		raw_spin_lock_irq(&desc->lock);
 		if (unlikely(desc->status & IRQ_DISABLED)) {
 			/*
 			 * CHECKME: We might need a dedicated
@@ -555,9 +555,9 @@ static int irq_thread(void *data)
 			 * retriggers the interrupt itself --- tglx
 			 */
 			desc->status |= IRQ_PENDING;
-			spin_unlock_irq(&desc->lock);
+			raw_spin_unlock_irq(&desc->lock);
 		} else {
-			spin_unlock_irq(&desc->lock);
+			raw_spin_unlock_irq(&desc->lock);
 
 			action->thread_fn(action->irq, action->dev_id);
 
@@ -679,7 +679,7 @@ __setup_irq(unsigned int irq, struct irq
 	/*
 	 * The following block of code has to be executed atomically
 	 */
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	old_ptr = &desc->action;
 	old = *old_ptr;
 	if (old) {
@@ -775,7 +775,7 @@ __setup_irq(unsigned int irq, struct irq
 		__enable_irq(desc, irq, false);
 	}
 
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	/*
 	 * Strictly no need to wake it up, but hung_task complains
@@ -802,7 +802,7 @@ mismatch:
 	ret = -EBUSY;
 
 out_thread:
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	if (new->thread) {
 		struct task_struct *t = new->thread;
 
@@ -844,7 +844,7 @@ static struct irqaction *__free_irq(unsi
 	if (!desc)
 		return NULL;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 
 	/*
 	 * There can be multiple actions per IRQ descriptor, find the right
@@ -856,7 +856,7 @@ static struct irqaction *__free_irq(unsi
 
 		if (!action) {
 			WARN(1, "Trying to free already-free IRQ %d\n", irq);
-			spin_unlock_irqrestore(&desc->lock, flags);
+			raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 			return NULL;
 		}
@@ -884,7 +884,7 @@ static struct irqaction *__free_irq(unsi
 			desc->chip->disable(irq);
 	}
 
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	unregister_handler_proc(irq, action);
 
Index: linux-2.6-tip/kernel/irq/migration.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/migration.c
+++ linux-2.6-tip/kernel/irq/migration.c
@@ -27,7 +27,7 @@ void move_masked_irq(int irq)
 	if (!desc->chip->set_affinity)
 		return;
 
-	assert_spin_locked(&desc->lock);
+	assert_raw_spin_locked(&desc->lock);
 
 	/*
 	 * If there was a valid mask to work with, please
Index: linux-2.6-tip/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/numa_migrate.c
+++ linux-2.6-tip/kernel/irq/numa_migrate.c
@@ -42,7 +42,7 @@ static bool init_copy_one_irq_desc(int i
 				"for migration.\n", irq);
 		return false;
 	}
-	spin_lock_init(&desc->lock);
+	raw_spin_lock_init(&desc->lock);
 	desc->node = node;
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_copy_kstat_irqs(old_desc, desc, node, nr_cpu_ids);
@@ -67,7 +67,7 @@ static struct irq_desc *__real_move_irq_
 
 	irq = old_desc->irq;
 
-	spin_lock_irqsave(&sparse_irq_lock, flags);
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
 
 	/* We have to check it to avoid races with another CPU */
 	desc = irq_desc_ptrs[irq];
@@ -91,7 +91,7 @@ static struct irq_desc *__real_move_irq_
 	}
 
 	irq_desc_ptrs[irq] = desc;
-	spin_unlock_irqrestore(&sparse_irq_lock, flags);
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
 
 	/* free the old one */
 	free_one_irq_desc(old_desc, desc);
@@ -100,7 +100,7 @@ static struct irq_desc *__real_move_irq_
 	return desc;
 
 out_unlock:
-	spin_unlock_irqrestore(&sparse_irq_lock, flags);
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
 
 	return desc;
 }
Index: linux-2.6-tip/kernel/irq/pm.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/pm.c
+++ linux-2.6-tip/kernel/irq/pm.c
@@ -28,9 +28,9 @@ void suspend_device_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		__disable_irq(desc, irq, true);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
 	for_each_irq_desc(irq, desc)
@@ -56,9 +56,9 @@ void resume_device_irqs(void)
 		if (!(desc->status & IRQ_SUSPENDED))
 			continue;
 
-		spin_lock_irqsave(&desc->lock, flags);
+		raw_spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
-		spin_unlock_irqrestore(&desc->lock, flags);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
 EXPORT_SYMBOL_GPL(resume_device_irqs);
Index: linux-2.6-tip/kernel/irq/proc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/proc.c
+++ linux-2.6-tip/kernel/irq/proc.c
@@ -179,7 +179,7 @@ static int name_unique(unsigned int irq,
 	unsigned long flags;
 	int ret = 1;
 
-	spin_lock_irqsave(&desc->lock, flags);
+	raw_spin_lock_irqsave(&desc->lock, flags);
 	for (action = desc->action ; action; action = action->next) {
 		if ((action != new_action) && action->name &&
 				!strcmp(new_action->name, action->name)) {
@@ -187,7 +187,7 @@ static int name_unique(unsigned int irq,
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&desc->lock, flags);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	return ret;
 }
 
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -28,7 +28,7 @@ static int try_one_irq(int irq, struct i
 	struct irqaction *action;
 	int ok = 0, work = 0;
 
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	/* Already running on another processor */
 	if (desc->status & IRQ_INPROGRESS) {
 		/*
@@ -37,13 +37,13 @@ static int try_one_irq(int irq, struct i
 		 */
 		if (desc->action && (desc->action->flags & IRQF_SHARED))
 			desc->status |= IRQ_PENDING;
-		spin_unlock(&desc->lock);
+		raw_spin_unlock(&desc->lock);
 		return ok;
 	}
 	/* Honour the normal IRQ locking */
 	desc->status |= IRQ_INPROGRESS;
 	action = desc->action;
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	while (action) {
 		/* Only shared IRQ handlers are safe to call */
@@ -56,7 +56,7 @@ static int try_one_irq(int irq, struct i
 	}
 	local_irq_disable();
 	/* Now clean up the flags */
-	spin_lock(&desc->lock);
+	raw_spin_lock(&desc->lock);
 	action = desc->action;
 
 	/*
@@ -68,9 +68,9 @@ static int try_one_irq(int irq, struct i
 		 * Perform real IRQ processing for the IRQ we deferred
 		 */
 		work = 1;
-		spin_unlock(&desc->lock);
+		raw_spin_unlock(&desc->lock);
 		handle_IRQ_event(irq, action);
-		spin_lock(&desc->lock);
+		raw_spin_lock(&desc->lock);
 		desc->status &= ~IRQ_PENDING;
 	}
 	desc->status &= ~IRQ_INPROGRESS;
@@ -80,7 +80,7 @@ static int try_one_irq(int irq, struct i
 	 */
 	if (work && desc->chip && desc->chip->end)
 		desc->chip->end(irq);
-	spin_unlock(&desc->lock);
+	raw_spin_unlock(&desc->lock);
 
 	return ok;
 }


