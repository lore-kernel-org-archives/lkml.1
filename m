Return-Path: <linux-kernel-owner+w=401wt.eu-S1761826AbZEARIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761826AbZEARIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbZEARIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:08:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:42743 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZEARIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:08:14 -0400
Date: Fri, 1 May 2009 17:06:42 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F654AF.8000808@kernel.org>
References: <49F654AF.8000808@kernel.org>
Subject: [tip:irq/numa] x86/irq: remove leftover code from NUMA_MIGRATE_IRQ_DESC
Message-ID: <tip-fcef5911c7ea89b80d5bfc727f402f37c9eefd57@git.kernel.org>
Git-Commit-ID: fcef5911c7ea89b80d5bfc727f402f37c9eefd57
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:06:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcef5911c7ea89b80d5bfc727f402f37c9eefd57
Gitweb:     http://git.kernel.org/tip/fcef5911c7ea89b80d5bfc727f402f37c9eefd57
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 17:58:23 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:15 +0200

x86/irq: remove leftover code from NUMA_MIGRATE_IRQ_DESC

The original feature of migrating irq_desc dynamic was too fragile
and was causing problems: it caused crashes on systems with lots of
cards with MSI-X when user-space irq-balancer was enabled.

We now have new patches that create irq_desc according to device
numa node. This patch removes the leftover bits of the dynamic balancer.

[ Impact: remove dead code ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <49F654AF.8000808@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/Kconfig                  |   10 ------
 arch/x86/configs/x86_64_defconfig |    1 -
 arch/x86/kernel/apic/io_apic.c    |   56 ++----------------------------------
 include/linux/irq.h               |   10 ------
 kernel/irq/Makefile               |    2 +-
 kernel/irq/chip.c                 |   12 +------
 kernel/irq/handle.c               |    9 +----
 kernel/irq/numa_migrate.c         |    2 -
 8 files changed, 9 insertions(+), 93 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..e1b2543 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -274,16 +274,6 @@ config SPARSE_IRQ
 
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
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 9fe5d21..27b8ce0 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -195,7 +195,6 @@ CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
 CONFIG_SPARSE_IRQ=y
-# CONFIG_NUMA_MIGRATE_IRQ_DESC is not set
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
 # CONFIG_X86_ELAN is not set
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 30da617..9fbf0f7 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -148,9 +148,6 @@ struct irq_cfg {
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-	u8 move_desc_pending : 1;
-#endif
 };
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
@@ -254,8 +251,7 @@ int arch_init_chip_data(struct irq_desc *desc, int cpu)
 	return 0;
 }
 
-#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
-
+/* for move_irq_desc */
 static void
 init_copy_irq_2_pin(struct irq_cfg *old_cfg, struct irq_cfg *cfg, int cpu)
 {
@@ -356,19 +352,7 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
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
@@ -378,13 +362,6 @@ static struct irq_cfg *irq_cfg(unsigned int irq)
 
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
@@ -592,9 +569,6 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 	if (assign_irq_vector(irq, cfg, mask))
 		return BAD_APICID;
 
-	/* check that before desc->addinity get updated */
-	set_extra_move_desc(desc, mask);
-
 	cpumask_copy(desc->affinity, mask);
 
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
@@ -2393,8 +2367,6 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	if (assign_irq_vector(irq, cfg, mask))
 		return;
 
-	set_extra_move_desc(desc, mask);
-
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
 
 	irte.vector = cfg->vector;
@@ -2491,34 +2463,14 @@ static void irq_complete_move(struct irq_desc **descp)
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
diff --git a/include/linux/irq.h b/include/linux/irq.h
index c4953cf..2a34cd6 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -212,16 +212,6 @@ extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
 
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
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 3394f8f..2f06527 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -3,5 +3,5 @@ obj-y := handle.o manage.o spurious.o resend.o chip.o devres.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
-obj-$(CONFIG_NUMA_MIGRATE_IRQ_DESC) += numa_migrate.o
+obj-$(CONFIG_SPARSE_IRQ) += numa_migrate.o
 obj-$(CONFIG_PM_SLEEP) += pm.o
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c687ba4..13c68e7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -359,7 +359,6 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 
 	spin_lock(&desc->lock);
 	mask_ack_irq(desc, irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -438,7 +437,6 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	desc->status &= ~IRQ_INPROGRESS;
 out:
 	desc->chip->eoi(irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	spin_unlock(&desc->lock);
 }
@@ -475,7 +473,6 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
 		mask_ack_irq(desc, irq);
-		desc = irq_remap_to_desc(irq, desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -483,7 +480,6 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	/* Start handling the irq */
 	if (desc->chip->ack)
 		desc->chip->ack(irq);
-	desc = irq_remap_to_desc(irq, desc);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -544,10 +540,8 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->chip->eoi) {
+	if (desc->chip->eoi)
 		desc->chip->eoi(irq);
-		desc = irq_remap_to_desc(irq, desc);
-	}
 }
 
 void
@@ -582,10 +576,8 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 
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
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 882c798..3e0cbc4 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -458,11 +458,8 @@ unsigned int __do_IRQ(unsigned int irq)
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
@@ -473,10 +470,8 @@ unsigned int __do_IRQ(unsigned int irq)
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
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 5760d72..ce72bc3 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -97,9 +97,7 @@ static struct irq_desc *__real_move_irq_desc(struct irq_desc *old_desc,
 
 	/* free the old one */
 	free_one_irq_desc(old_desc, desc);
-	spin_unlock(&old_desc->lock);
 	kfree(old_desc);
-	spin_lock(&desc->lock);
 
 	return desc;
 
