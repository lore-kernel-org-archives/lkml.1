Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYKSOk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYKSOk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 09:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYKSOku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 09:40:50 -0500
Received: from ozlabs.org ([203.10.76.45]:51734 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278AbYKSOks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 09:40:48 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 20 Nov 2008 01:10:43 +1030
Subject: [PATCH 1/1] cpumask: make irq_set_affinity() take a const struct cpumask
Cc: Mike Travis <travis@sgi.com>, ralf@linux-mips.org,
       Ingo Molnar <mingo@redhat.com>, grundler@parisc-linux.org,
       jeremy@xensource.com
Cc: ralf@linux-mips.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: grundler@parisc-linux.org
Cc: jeremy@xensource.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811200110.44281.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Ingo, this is for you directly, not linux-next).

Not much point with gentle transition here: the struct irq_chip's
setaffinity method signature needs to change.

Fortunately, not widely used code, but hits a few architectures.

Note: In irq_select_affinity() I save a temporary in by mangling
irq_desc[irq].affinity directly.  Ingo, does this break anything?

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: ralf@linux-mips.org
Cc: grundler@parisc-linux.org
Cc: jeremy@xensource.com
---
 arch/mips/kernel/cevt-bcm1480.c |    2 
 arch/mips/kernel/cevt-sb1250.c  |    2 
 arch/x86/kernel/hpet.c          |    4 -
 arch/x86/kernel/io_apic.c       |   83 +++++++++++++++++++---------------------
 arch/x86/kernel/irq_32.c        |    2 
 drivers/parisc/iosapic.c        |    7 +--
 drivers/xen/events.c            |    6 +-
 include/linux/interrupt.h       |    4 -
 include/linux/irq.h             |    7 +--
 kernel/irq/chip.c               |    2 
 kernel/irq/manage.c             |   13 ++----
 kernel/irq/migration.c          |   18 ++++----
 kernel/irq/proc.c               |   29 +++++++++----
 kernel/time/tick-common.c       |    6 +-
 14 files changed, 97 insertions(+), 88 deletions(-)

diff -r 646eaa4a98b9 arch/mips/kernel/cevt-bcm1480.c
--- a/arch/mips/kernel/cevt-bcm1480.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/arch/mips/kernel/cevt-bcm1480.c	Tue Nov 18 10:31:02 2008 +1030
@@ -148,6 +148,6 @@
 	action->name	= name;
 	action->dev_id	= cd;
 
-	irq_set_affinity(irq, cpumask_of_cpu(cpu));
+	irq_set_affinity(irq, cpumask_of(cpu));
 	setup_irq(irq, action);
 }
diff -r 646eaa4a98b9 arch/mips/kernel/cevt-sb1250.c
--- a/arch/mips/kernel/cevt-sb1250.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/arch/mips/kernel/cevt-sb1250.c	Tue Nov 18 10:31:02 2008 +1030
@@ -147,6 +147,6 @@
 	action->name	= name;
 	action->dev_id	= cd;
 
-	irq_set_affinity(irq, cpumask_of_cpu(cpu));
+	irq_set_affinity(irq, cpumask_of(cpu));
 	setup_irq(irq, action);
 }
diff -r 646eaa4a98b9 arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/arch/x86/kernel/hpet.c	Tue Nov 18 10:31:02 2008 +1030
@@ -301,7 +301,7 @@
 			struct hpet_dev *hdev = EVT_TO_HPET_DEV(evt);
 			hpet_setup_msi_irq(hdev->irq);
 			disable_irq(hdev->irq);
-			irq_set_affinity(hdev->irq, cpumask_of_cpu(hdev->cpu));
+			irq_set_affinity(hdev->irq, cpumask_of(hdev->cpu));
 			enable_irq(hdev->irq);
 		}
 		break;
@@ -449,7 +449,7 @@
 		return -1;
 
 	disable_irq(dev->irq);
-	irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
+	irq_set_affinity(dev->irq, cpumask_of(dev->cpu));
 	enable_irq(dev->irq);
 
 	printk(KERN_DEBUG "hpet: %s irq %d for MSI\n",
diff -r 646eaa4a98b9 arch/x86/kernel/io_apic.c
--- a/arch/x86/kernel/io_apic.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/arch/x86/kernel/io_apic.c	Tue Nov 18 10:31:02 2008 +1030
@@ -361,7 +361,8 @@
 
 static int assign_irq_vector(int irq, cpumask_t mask);
 
-static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ioapic_affinity_irq(unsigned int irq,
+				    const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
@@ -369,15 +370,14 @@
 	cpumask_t tmp;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	if (!cpumask_intersects(mask, cpu_online_mask))
 		return;
 
 	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, *mask))
 		return;
 
-	cpus_and(tmp, cfg->domain, mask);
+	cpumask_and(&tmp, &cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 	/*
 	 * Only the high 8 bits are valid.
@@ -387,7 +387,7 @@
 	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
-	desc->affinity = mask;
+	cpumask_copy(&desc->affinity, mask);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 #endif /* CONFIG_SMP */
@@ -2175,7 +2175,7 @@
 				continue;
 			}
 
-			desc->chip->set_affinity(irq, desc->pending_mask);
+			desc->chip->set_affinity(irq, &desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -2184,18 +2184,19 @@
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq(unsigned int irq,
+				       const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
-		desc->pending_mask = mask;
+		cpumask_copy(&desc->pending_mask, mask);
 		migrate_irq_remapped_level(irq);
 		return;
 	}
 
-	migrate_ioapic_irq(irq, mask);
+	migrate_ioapic_irq(irq, *mask);
 }
 #endif
 
@@ -3013,7 +3014,7 @@
 }
 
 #ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
@@ -3021,15 +3022,14 @@
 	cpumask_t tmp;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	if (!cpumask_intersects(mask, cpu_online_mask))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, *mask))
 		return;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
+	cpumask_and(&tmp, &cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	read_msi_msg(irq, &msg);
@@ -3041,7 +3041,7 @@
 
 	write_msi_msg(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpumask_copy(&desc->affinity, mask);
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -3049,7 +3049,8 @@
  * Migrate the MSI irq to another cpumask. This migration is
  * done in the process context using interrupt-remapping hardware.
  */
-static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+static void ir_set_msi_irq_affinity(unsigned int irq,
+				    const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
@@ -3057,18 +3058,17 @@
 	struct irte irte;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	if (!cpumask_intersects(mask, cpu_online_mask))
 		return;
 
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, *mask))
 		return;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
+	cpumask_and(&tmp, &cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	irte.vector = cfg->vector;
@@ -3092,7 +3092,7 @@
 	}
 
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpumask_copy(&desc->affinity, mask);
 }
 #endif
 #endif /* CONFIG_SMP */
@@ -3294,7 +3294,7 @@
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
+static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
@@ -3302,15 +3302,14 @@
 	cpumask_t tmp;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	if (!cpumask_intersects(mask, cpu_online_mask))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, *mask))
 		return;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
+	cpumask_and(&tmp, &cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	dmar_msi_read(irq, &msg);
@@ -3322,7 +3321,7 @@
 
 	dmar_msi_write(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpumask_copy(&desc->affinity, mask);
 }
 #endif /* CONFIG_SMP */
 
@@ -3355,7 +3354,7 @@
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
+static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
@@ -3363,15 +3362,14 @@
 	unsigned int dest;
 	cpumask_t tmp;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	if (!cpumask_intersects(mask, cpu_online_mask))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, *mask))
 		return;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
+	cpumask_and(&tmp, &cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	hpet_msi_read(irq, &msg);
@@ -3383,7 +3381,7 @@
 
 	hpet_msi_write(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpumask_copy(&desc->affinity, mask);
 }
 #endif /* CONFIG_SMP */
 
@@ -3437,27 +3435,26 @@
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
+static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
 	cpumask_t tmp;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	if (!cpumask_intersects(mask, cpu_online_mask))
 		return;
 
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, *mask))
 		return;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
+	cpumask_and(&tmp, &cfg->domain, mask);
 	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpumask_copy(&desc->affinity, mask);
 }
 #endif
 
@@ -3762,6 +3759,8 @@
 {
 	int pin, ioapic, irq, irq_entry;
 	struct irq_cfg *cfg;
+	/* FIXME: Make TARGET_CPUS return a pointer. */
+	cpumask_t target = TARGET_CPUS;
 
 	if (skip_ioapic_setup == 1)
 		return;
@@ -3784,10 +3783,10 @@
 						  irq_polarity(irq_entry));
 #ifdef CONFIG_INTR_REMAP
 			else if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq(irq, TARGET_CPUS);
+				set_ir_ioapic_affinity_irq(irq, &target);
 #endif
 			else
-				set_ioapic_affinity_irq(irq, TARGET_CPUS);
+				set_ioapic_affinity_irq(irq, &target);
 		}
 
 	}
diff -r 646eaa4a98b9 arch/x86/kernel/irq_32.c
--- a/arch/x86/kernel/irq_32.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/arch/x86/kernel/irq_32.c	Tue Nov 18 10:31:02 2008 +1030
@@ -251,7 +251,7 @@
 			mask = map;
 		}
 		if (desc->chip->set_affinity)
-			desc->chip->set_affinity(irq, mask);
+			desc->chip->set_affinity(irq, &mask);
 		else if (desc->action && !(warned++))
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
diff -r 646eaa4a98b9 drivers/parisc/iosapic.c
--- a/drivers/parisc/iosapic.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/drivers/parisc/iosapic.c	Tue Nov 18 10:31:02 2008 +1030
@@ -704,16 +704,17 @@
 }
 
 #ifdef CONFIG_SMP
-static void iosapic_set_affinity_irq(unsigned int irq, cpumask_t dest)
+static void iosapic_set_affinity_irq(unsigned int irq,
+				     const struct cpumask *dest)
 {
 	struct vector_info *vi = iosapic_get_vector(irq);
 	u32 d0, d1, dummy_d0;
 	unsigned long flags;
 
-	if (cpu_check_affinity(irq, &dest))
+	if (cpu_check_affinity(irq, dest))
 		return;
 
-	vi->txn_addr = txn_affinity_addr(irq, first_cpu(dest));
+	vi->txn_addr = txn_affinity_addr(irq, cpumask_first(dest));
 
 	spin_lock_irqsave(&iosapic_lock, flags);
 	/* d1 contains the destination CPU, so only want to set that
diff -r 646eaa4a98b9 drivers/xen/events.c
--- a/drivers/xen/events.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/drivers/xen/events.c	Tue Nov 18 10:31:02 2008 +1030
@@ -579,7 +579,7 @@
 	spin_unlock(&irq_mapping_update_lock);
 
 	/* new event channels are always bound to cpu 0 */
-	irq_set_affinity(irq, cpumask_of_cpu(0));
+	irq_set_affinity(irq, cpumask_of(0));
 
 	/* Unmask the event channel. */
 	enable_irq(irq);
@@ -608,9 +608,9 @@
 }
 
 
-static void set_affinity_irq(unsigned irq, cpumask_t dest)
+static void set_affinity_irq(unsigned irq, const struct cpumask *dest)
 {
-	unsigned tcpu = first_cpu(dest);
+	unsigned tcpu = cpumask_first(dest);
 	rebind_irq_to_cpu(irq, tcpu);
 }
 
diff -r 646eaa4a98b9 include/linux/interrupt.h
--- a/include/linux/interrupt.h	Tue Nov 18 09:04:22 2008 +1030
+++ b/include/linux/interrupt.h	Tue Nov 18 10:31:02 2008 +1030
@@ -109,13 +109,13 @@
 
 extern cpumask_t irq_default_affinity;
 
-extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
 #else /* CONFIG_SMP */
 
-static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
 {
 	return -EINVAL;
 }
diff -r 646eaa4a98b9 include/linux/irq.h
--- a/include/linux/irq.h	Tue Nov 18 09:04:22 2008 +1030
+++ b/include/linux/irq.h	Tue Nov 18 10:31:02 2008 +1030
@@ -112,7 +112,8 @@
 	void		(*eoi)(unsigned int irq);
 
 	void		(*end)(unsigned int irq);
-	void		(*set_affinity)(unsigned int irq, cpumask_t dest);
+	void		(*set_affinity)(unsigned int irq,
+					const cpumask_t *dest);
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
@@ -210,7 +211,7 @@
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 
-void set_pending_irq(unsigned int irq, cpumask_t mask);
+void set_pending_irq(unsigned int irq, const cpumask_t *mask);
 void move_native_irq(int irq);
 void move_masked_irq(int irq);
 
@@ -228,7 +229,7 @@
 {
 }
 
-static inline void set_pending_irq(unsigned int irq, cpumask_t mask)
+static inline void set_pending_irq(unsigned int irq, const cpumask_t *mask)
 {
 }
 
diff -r 646eaa4a98b9 kernel/irq/chip.c
--- a/kernel/irq/chip.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/kernel/irq/chip.c	Tue Nov 18 10:31:02 2008 +1030
@@ -45,7 +45,7 @@
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 #ifdef CONFIG_SMP
-	cpus_setall(desc->affinity);
+	cpumask_setall(&desc->affinity);
 #endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
diff -r 646eaa4a98b9 kernel/irq/manage.c
--- a/kernel/irq/manage.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/kernel/irq/manage.c	Tue Nov 18 10:31:02 2008 +1030
@@ -79,7 +79,7 @@
  *	@cpumask:	cpumask
  *
  */
-int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
@@ -91,13 +91,13 @@
 		unsigned long flags;
 
 		spin_lock_irqsave(&desc->lock, flags);
-		desc->affinity = cpumask;
+		cpumask_copy(&desc->affinity, cpumask);
 		desc->chip->set_affinity(irq, cpumask);
 		spin_unlock_irqrestore(&desc->lock, flags);
 	} else
 		set_pending_irq(irq, cpumask);
 #else
-	desc->affinity = cpumask;
+	cpumask_copy(&desc->affinity, cpumask);
 	desc->chip->set_affinity(irq, cpumask);
 #endif
 	return 0;
@@ -109,17 +109,14 @@
  */
 int irq_select_affinity(unsigned int irq)
 {
-	cpumask_t mask;
 	struct irq_desc *desc;
 
 	if (!irq_can_set_affinity(irq))
 		return 0;
 
-	cpus_and(mask, cpu_online_map, irq_default_affinity);
-
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
-	desc->chip->set_affinity(irq, mask);
+	cpumask_and(&desc->affinity, cpu_online_mask, &irq_default_affinity);
+	desc->chip->set_affinity(irq, &desc->affinity);
 
 	return 0;
 }
diff -r 646eaa4a98b9 kernel/irq/migration.c
--- a/kernel/irq/migration.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/kernel/irq/migration.c	Tue Nov 18 10:31:02 2008 +1030
@@ -1,21 +1,21 @@
 
 #include <linux/irq.h>
 
-void set_pending_irq(unsigned int irq, cpumask_t mask)
+void set_pending_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&desc->lock, flags);
 	desc->status |= IRQ_MOVE_PENDING;
-	desc->pending_mask = mask;
+	cpumask_copy(&desc->pending_mask, mask);
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 void move_masked_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -30,7 +30,7 @@
 
 	desc->status &= ~IRQ_MOVE_PENDING;
 
-	if (unlikely(cpus_empty(desc->pending_mask)))
+	if (unlikely(cpumask_empty(&desc->pending_mask)))
 		return;
 
 	if (!desc->chip->set_affinity)
@@ -38,7 +38,10 @@
 
 	assert_spin_locked(&desc->lock);
 
-	cpus_and(tmp, desc->pending_mask, cpu_online_map);
+	if (!alloc_cpumask_var(&tmp, GFP_ATOMIC))
+		return;
+
+	cpumask_and(tmp, &desc->pending_mask, cpu_online_mask);
 
 	/*
 	 * If there was a valid mask to work with, please
@@ -52,10 +55,9 @@
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (likely(!cpus_empty(tmp))) {
+	if (likely(!cpumask_empty(tmp)))
 		desc->chip->set_affinity(irq,tmp);
-	}
-	cpus_clear(desc->pending_mask);
+	cpumask_clear(&desc->pending_mask);
 }
 
 void move_native_irq(int irq)
diff -r 646eaa4a98b9 kernel/irq/proc.c
--- a/kernel/irq/proc.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/kernel/irq/proc.c	Tue Nov 18 10:31:02 2008 +1030
@@ -40,33 +40,42 @@
 		const char __user *buffer, size_t count, loff_t *pos)
 {
 	unsigned int irq = (int)(long)PDE(file->f_path.dentry->d_inode)->data;
-	cpumask_t new_value;
+	cpumask_var_t new_value;
 	int err;
 
 	if (!irq_to_desc(irq)->chip->set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
-	err = cpumask_parse_user(buffer, count, &new_value);
+	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
+		return -ENOMEM;
+
+	err = cpumask_parse_user(buffer, count, new_value);
 	if (err)
-		return err;
+		goto free_cpumask;
 
-	if (!is_affinity_mask_valid(new_value))
-		return -EINVAL;
+	if (!is_affinity_mask_valid(new_value)) {
+		err = -EINVAL;
+		goto free_cpumask;
+	}
 
 	/*
 	 * Do not allow disabling IRQs completely - it's a too easy
 	 * way to make the system unusable accidentally :-) At least
 	 * one online CPU still has to be targeted.
 	 */
-	if (!cpus_intersects(new_value, cpu_online_map))
+	if (!cpumask_intersects(new_value, cpu_online_mask)) {
 		/* Special case for empty set - allow the architecture
 		   code to set default SMP affinity. */
-		return irq_select_affinity(irq) ? -EINVAL : count;
+		err = irq_select_affinity(irq) ? -EINVAL : count;
+	} else {
+		irq_set_affinity(irq, new_value);
+		err = count;
+	}
 
-	irq_set_affinity(irq, new_value);
-
-	return count;
+free_cpumask:
+	free_cpumask_var(new_value);
+	return err;
 }
 
 static int irq_affinity_proc_open(struct inode *inode, struct file *file)
diff -r 646eaa4a98b9 kernel/time/tick-common.c
--- a/kernel/time/tick-common.c	Tue Nov 18 09:04:22 2008 +1030
+++ b/kernel/time/tick-common.c	Tue Nov 18 10:31:02 2008 +1030
@@ -136,7 +136,7 @@
  */
 static void tick_setup_device(struct tick_device *td,
 			      struct clock_event_device *newdev, int cpu,
-			      const cpumask_t *cpumask)
+			      const struct cpumask *cpumask)
 {
 	ktime_t next_event;
 	void (*handler)(struct clock_event_device *) = NULL;
@@ -171,8 +171,8 @@
 	 * When the device is not per cpu, pin the interrupt to the
 	 * current cpu:
 	 */
-	if (!cpus_equal(newdev->cpumask, *cpumask))
-		irq_set_affinity(newdev->irq, *cpumask);
+	if (!cpumask_equal(&newdev->cpumask, cpumask))
+		irq_set_affinity(newdev->irq, cpumask);
 
 	/*
 	 * When global broadcasting is active, check if the current


