Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbZDQESl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbZDQESl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZDQESc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:18:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:32905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZDQESb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:18:31 -0400
Message-ID: <49E802CE.5030406@kernel.org>
Date: Thu, 16 Apr 2009 21:17:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] x86/irq: remove NUMA_MIGRATE_IRQ_DESC
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu>
In-Reply-To: <20090416090315.GF9813@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: it is not ready yet.remove it

it causes crash on system with lots of cards with MSI-X
when irq_balancer enabled...

will have new patches that create irq_desc according to device numa node.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/configs/x86_64_defconfig |    1 
 arch/x86/kernel/apic/io_apic.c    |  155 --------------------------------------
 include/linux/irq.h               |   12 --
 kernel/irq/Makefile               |    1 
 kernel/irq/chip.c                 |   12 --
 kernel/irq/handle.c               |    9 --
 kernel/irq/numa_migrate.c         |  133 --------------------------------
 7 files changed, 6 insertions(+), 317 deletions(-)

Index: linux-2.6/arch/x86/configs/x86_64_defconfig
===================================================================
--- linux-2.6.orig/arch/x86/configs/x86_64_defconfig
+++ linux-2.6/arch/x86/configs/x86_64_defconfig
@@ -195,7 +195,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
 CONFIG_SPARSE_IRQ=y
-# CONFIG_NUMA_MIGRATE_IRQ_DESC is not set
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
 # CONFIG_X86_ELAN is not set
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -149,9 +149,6 @@ struct irq_cfg {
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-	u8 move_desc_pending : 1;
-#endif
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
@@ -255,122 +252,6 @@ int arch_init_chip_data(struct irq_desc
 	return 0;
 }
 
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-
-static void
-init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
-{
-	struct irq_pin_list *old_entry, *head, *tail, *entry;
-
-	cfg->irq_2_pin = NULL;
-	old_entry = old_cfg->irq_2_pin;
-	if (!old_entry)
-		return;
-
-	entry = get_one_free_irq_2_pin(cpu);
-	if (!entry)
-		return;
-
-	entry->apic	= old_entry->apic;
-	entry->pin	= old_entry->pin;
-	head		= entry;
-	tail		= entry;
-	old_entry	= old_entry->next;
-	while (old_entry) {
-		entry = get_one_free_irq_2_pin(cpu);
-		if (!entry) {
-			entry = head;
-			while (entry) {
-				head = entry->next;
-				kfree(entry);
-				entry = head;
-			}
-			/* still use the old one */
-			return;
-		}
-		entry->apic	= old_entry->apic;
-		entry->pin	= old_entry->pin;
-		tail->next	= entry;
-		tail		= entry;
-		old_entry	= old_entry->next;
-	}
-
-	tail->next = NULL;
-	cfg->irq_2_pin = head;
-}
-
-static void free_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg)
-{
-	struct irq_pin_list *entry, *next;
-
-	if (old_cfg->irq_2_pin == cfg->irq_2_pin)
-		return;
-
-	entry = old_cfg->irq_2_pin;
-
-	while (entry) {
-		next = entry->next;
-		kfree(entry);
-		entry = next;
-	}
-	old_cfg->irq_2_pin = NULL;
-}
-
-void arch_init_copy_chip_data(struct irq_desc *old_desc,
-				 struct irq_desc *desc, int cpu)
-{
-	struct irq_cfg *cfg;
-	struct irq_cfg *old_cfg;
-
-	cfg = get_one_free_irq_cfg(cpu);
-
-	if (!cfg)
-		return;
-
-	desc->chip_data = cfg;
-
-	old_cfg = old_desc->chip_data;
-
-	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
-
-	init_copy_irq_2_pin(old_cfg, cfg, cpu);
-}
-
-static void free_irq_cfg(struct irq_cfg *old_cfg)
-{
-	kfree(old_cfg);
-}
-
-void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
-{
-	struct irq_cfg *old_cfg, *cfg;
-
-	old_cfg = old_desc->chip_data;
-	cfg = desc->chip_data;
-
-	if (old_cfg == cfg)
-		return;
-
-	if (old_cfg) {
-		free_irq_2_pin(old_cfg, cfg);
-		free_irq_cfg(old_cfg);
-		old_desc->chip_data = NULL;
-	}
-}
-
-static void
-set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
-{
-	struct irq_cfg *cfg = desc->chip_data;
-
-	if (!cfg->move_in_progress) {
-		/* it means that domain is not changed */
-		if (!cpumask_intersects(desc->affinity, mask))
-			cfg->move_desc_pending = 1;
-	}
-}
-#endif
-
 #else
 static struct irq_cfg *irq_cfg(unsigned int irq)
 {
@@ -379,13 +260,6 @@ static struct irq_cfg *irq_cfg(unsigned
 
 #endif
 
-#ifndef CONFIG_NUMA_MIGRATE_IRQ_DESC
-static inline void
-set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
-{
-}
-#endif
-
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -2318,9 +2192,6 @@ set_desc_affinity(struct irq_desc *desc,
 	if (assign_irq_vector(irq, cfg, mask))
 		return BAD_APICID;
 
-	/* check that before desc->addinity get updated */
-	set_extra_move_desc(desc, mask);
-
 	cpumask_copy(desc->affinity, mask);
 
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
@@ -2389,8 +2260,6 @@ migrate_ioapic_irq_desc(struct irq_desc
 	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	set_extra_move_desc(desc, mask);
-
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
 
 	irte.vector = cfg->vector;
@@ -2487,34 +2356,14 @@ static void irq_complete_move(struct irq
 	struct irq_cfg *cfg = desc->chip_data;
 	unsigned vector, me;
 
-	if (likely(!cfg->move_in_progress)) {
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-		if (likely(!cfg->move_desc_pending))
-			return;
-
-		/* domain has not changed, but affinity did */
-		me = smp_processor_id();
-		if (cpumask_test_cpu(me, desc->affinity)) {
-			*descp = desc = move_irq_desc(desc, me);
-			/* get the new one */
-			cfg = desc->chip_data;
-			cfg->move_desc_pending = 0;
-		}
-#endif
+	if (likely(!cfg->move_in_progress))
 		return;
-	}
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 
-	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain)) {
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-		*descp = desc = move_irq_desc(desc, me);
-		/* get the new one */
-		cfg = desc->chip_data;
-#endif
+	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 		send_cleanup_vector(cfg);
-	}
 }
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -206,22 +206,10 @@ extern void arch_free_chip_data(struct i
 
 #ifndef CONFIG_SPARSE_IRQ
 extern struct irq_desc irq_desc[NR_IRQS];
-#else /* CONFIG_SPARSE_IRQ */
-extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
 #endif /* CONFIG_SPARSE_IRQ */
 
 extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
 
-static inline struct irq_desc *
-irq_remap_to_desc(unsigned int irq, struct irq_desc *desc)
-{
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-	return irq_to_desc(irq);
-#else
-	return desc;
-#endif
-}
-
 /*
  * Migration helpers for obsolete names, they will go away:
  */
Index: linux-2.6/kernel/irq/Makefile
===================================================================
--- linux-2.6.orig/kernel/irq/Makefile
+++ linux-2.6/kernel/irq/Makefile
@@ -3,5 +3,4 @@ obj-y := handle.o manage.o spurious.o re
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
-obj-$(CONFIG_NUMA_MIGRATE_IRQ_DESC) += numa_migrate.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -359,7 +359,6 @@ handle_level_irq(unsigned int irq, struc
 
 	spin_lock(&desc->lock);
 	mask_ack_irq(desc, irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -438,7 +437,6 @@ handle_fasteoi_irq(unsigned int irq, str
 	desc->status &= ~IRQ_INPROGRESS;
 out:
 	desc->chip->eoi(irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	spin_unlock(&desc->lock);
 }
@@ -475,7 +473,6 @@ handle_edge_irq(unsigned int irq, struct
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
 		mask_ack_irq(desc, irq);
-		desc = irq_remap_to_desc(irq, desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -483,7 +480,6 @@ handle_edge_irq(unsigned int irq, struct
 	/* Start handling the irq */
 	if (desc->chip->ack)
 		desc->chip->ack(irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -544,10 +540,8 @@ handle_percpu_irq(unsigned int irq, stru
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi) {
+	if (desc->chip->eoi)
 		desc->chip->eoi(irq);
-		desc = irq_remap_to_desc(irq, desc);
-	}
 }
 
 void
@@ -582,10 +576,8 @@ __set_irq_handler(unsigned int irq, irq_
 
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
-		if (desc->chip != &no_irq_chip) {
+		if (desc->chip != &no_irq_chip)
 			mask_ack_irq(desc, irq);
-			desc = irq_remap_to_desc(irq, desc);
-		}
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -454,11 +454,8 @@ unsigned int __do_IRQ(unsigned int irq)
 		/*
 		 * No locking required for CPU-local interrupts:
 		 */
-		if (desc->chip->ack) {
+		if (desc->chip->ack)
 			desc->chip->ack(irq);
-			/* get new one */
-			desc = irq_remap_to_desc(irq, desc);
-		}
 		if (likely(!(desc->status & IRQ_DISABLED))) {
 			action_ret = handle_IRQ_event(irq, desc->action);
 			if (!noirqdebug)
@@ -469,10 +466,8 @@ unsigned int __do_IRQ(unsigned int irq)
 	}
 
 	spin_lock(&desc->lock);
-	if (desc->chip->ack) {
+	if (desc->chip->ack)
 		desc->chip->ack(irq);
-		desc = irq_remap_to_desc(irq, desc);
-	}
 	/*
 	 * REPLAY is when Linux resends an IRQ that was dropped earlier
 	 * WAITING is used by probe to mark irqs that are being tested
Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- * NUMA irq-desc migration code
- *
- * Migrate IRQ data structures (irq_desc, chip_data, etc.) over to
- * the new "home node" of the IRQ.
- */
-
-#include <linux/irq.h>
-#include <linux/module.h>
-#include <linux/random.h>
-#include <linux/interrupt.h>
-#include <linux/kernel_stat.h>
-
-#include "internals.h"
-
-static void init_copy_kstat_irqs(struct irq_desc *old_desc,
-				 struct irq_desc *desc,
-				 int cpu, int nr)
-{
-	init_kstat_irqs(desc, cpu, nr);
-
-	if (desc->kstat_irqs != old_desc->kstat_irqs)
-		memcpy(desc->kstat_irqs, old_desc->kstat_irqs,
-			 nr * sizeof(*desc->kstat_irqs));
-}
-
-static void free_kstat_irqs(struct irq_desc *old_desc, struct irq_desc *desc)
-{
-	if (old_desc->kstat_irqs == desc->kstat_irqs)
-		return;
-
-	kfree(old_desc->kstat_irqs);
-	old_desc->kstat_irqs = NULL;
-}
-
-static bool init_copy_one_irq_desc(int irq, struct irq_desc *old_desc,
-		 struct irq_desc *desc, int cpu)
-{
-	memcpy(desc, old_desc, sizeof(struct irq_desc));
-	if (!init_alloc_desc_masks(desc, cpu, false)) {
-		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
-				"for migration.\n", irq);
-		return false;
-	}
-	spin_lock_init(&desc->lock);
-	desc->cpu = cpu;
-	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
-	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
-	init_copy_desc_masks(old_desc, desc);
-	arch_init_copy_chip_data(old_desc, desc, cpu);
-	return true;
-}
-
-static void free_one_irq_desc(struct irq_desc *old_desc, struct irq_desc *desc)
-{
-	free_kstat_irqs(old_desc, desc);
-	free_desc_masks(old_desc, desc);
-	arch_free_chip_data(old_desc, desc);
-}
-
-static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
-						int cpu)
-{
-	struct irq_desc *desc;
-	unsigned int irq;
-	unsigned long flags;
-	int node;
-
-	irq = old_desc->irq;
-
-	spin_lock_irqsave(&sparse_irq_lock, flags);
-
-	/* We have to check it to avoid races with another CPU */
-	desc = irq_desc_ptrs[irq];
-
-	if (desc && old_desc != desc)
-		goto out_unlock;
-
-	node = cpu_to_node(cpu);
-	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
-	if (!desc) {
-		printk(KERN_ERR "irq %d: can not get new irq_desc "
-				"for migration.\n", irq);
-		/* still use old one */
-		desc = old_desc;
-		goto out_unlock;
-	}
-	if (!init_copy_one_irq_desc(irq, old_desc, desc, cpu)) {
-		/* still use old one */
-		kfree(desc);
-		desc = old_desc;
-		goto out_unlock;
-	}
-
-	irq_desc_ptrs[irq] = desc;
-	spin_unlock_irqrestore(&sparse_irq_lock, flags);
-
-	/* free the old one */
-	free_one_irq_desc(old_desc, desc);
-	spin_unlock(&old_desc->lock);
-	kfree(old_desc);
-	spin_lock(&desc->lock);
-
-	return desc;
-
-out_unlock:
-	spin_unlock_irqrestore(&sparse_irq_lock, flags);
-
-	return desc;
-}
-
-struct irq_desc *move_irq_desc(struct irq_desc *desc, int cpu)
-{
-	int old_cpu;
-	int node, old_node;
-
-	/* those all static, do move them */
-	if (desc->irq < NR_IRQS_LEGACY)
-		return desc;
-
-	old_cpu = desc->cpu;
-	if (old_cpu != cpu) {
-		node = cpu_to_node(cpu);
-		old_node = cpu_to_node(old_cpu);
-		if (old_node != node)
-			desc = __real_move_irq_desc(desc, cpu);
-		else
-			desc->cpu = cpu;
-	}
-
-	return desc;
-}
-
