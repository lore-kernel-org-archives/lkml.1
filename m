Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbZD1BAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbZD1BAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 21:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZD1BAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 21:00:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:56649 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbZD1BAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 21:00:04 -0400
Message-ID: <49F654AF.8000808@kernel.org>
Date: Mon, 27 Apr 2009 17:58:23 -0700
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
Subject: [PATCH 2/9] x86/irq: remove NUMA_MIGRATE_IRQ_DESC -v2
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E80305.8080200@kernel.org>
In-Reply-To: <49E80305.8080200@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it causes crash on system with lots of cards with MSI-X
when irq_balancer enabled...

will have new patches that create irq_desc according to device numa node.

v2: still keep move_irq_desc, will use it later

Impact: it is not ready yet.remove it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/Kconfig                  |   10 ------
 arch/x86/configs/x86_64_defconfig |    1 
 arch/x86/kernel/apic/io_apic.c    |   56 ++------------------------------------
 include/linux/irq.h               |   10 ------
 kernel/irq/Makefile               |    2 -
 kernel/irq/chip.c                 |   12 +-------
 kernel/irq/handle.c               |    9 +-----
 kernel/irq/numa_migrate.c         |    2 -
 8 files changed, 9 insertions(+), 93 deletions(-)

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
@@ -255,8 +252,7 @@ int arch_init_chip_data(struct irq_desc
 	return 0;
 }
 
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-
+/* for move_irq_desc */
 static void
 init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
 {
@@ -357,19 +353,7 @@ void arch_free_chip_data(struct irq_desc
 		old_desc->chip_data = NULL;
 	}
 }
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
+/* end for move_irq_desc */
 
 #else
 static struct irq_cfg *irq_cfg(unsigned int irq)
@@ -379,13 +363,6 @@ static struct irq_cfg *irq_cfg(unsigned
 
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
@@ -2302,9 +2279,6 @@ set_desc_affinity(struct irq_desc *desc,
 	if (assign_irq_vector(irq, cfg, mask))
 		return BAD_APICID;
 
-	/* check that before desc->addinity get updated */
-	set_extra_move_desc(desc, mask);
-
 	cpumask_copy(desc->affinity, mask);
 
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
@@ -2373,8 +2347,6 @@ migrate_ioapic_irq_desc(struct irq_desc
 	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	set_extra_move_desc(desc, mask);
-
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
 
 	irte.vector = cfg->vector;
@@ -2471,34 +2443,14 @@ static void irq_complete_move(struct irq
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
@@ -212,16 +212,6 @@ extern struct irq_desc *move_irq_desc(st
 
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
@@ -3,5 +3,5 @@ obj-y := handle.o manage.o spurious.o re
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
-obj-$(CONFIG_NUMA_MIGRATE_IRQ_DESC) += numa_migrate.o
+obj-$(CONFIG_SPARSE_IRQ) += numa_migrate.o
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
@@ -457,11 +457,8 @@ unsigned int __do_IRQ(unsigned int irq)
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
@@ -472,10 +469,8 @@ unsigned int __do_IRQ(unsigned int irq)
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
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -280,16 +280,6 @@ config SPARSE_IRQ
 
 	  If you don't know what to do here, say N.
 
-config NUMA_MIGRATE_IRQ_DESC
-	bool "Move irq desc when changing irq smp_affinity"
-	depends on SPARSE_IRQ && NUMA
-	depends on BROKEN
-	default n
-	---help---
-	  This enables moving irq_desc to cpu/node that irq will use handled.
-
-	  If you don't know what to do here, say N.
-
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -97,9 +97,7 @@ static struct irq_desc *__real_move_irq_
 
 	/* free the old one */
 	free_one_irq_desc(old_desc, desc);
-	spin_unlock(&old_desc->lock);
 	kfree(old_desc);
-	spin_lock(&desc->lock);
 
 	return desc;
 
