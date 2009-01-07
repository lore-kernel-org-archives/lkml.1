Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZAGUAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZAGUAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 15:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZAGT6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:58:40 -0500
Received: from relay3.sgi.com ([192.48.171.31]:42349 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755977AbZAGT6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:58:38 -0500
Message-Id: <20090107195832.465094000@polaris-admin.engr.sgi.com>
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 07 Jan 2009 11:58:33 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/5] cpumask: update irq_desc to use cpumask_var_t
Content-Disposition: inline; filename=cpumask:update-irq_desc-to-use-cpumask_var_t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce memory usage, use new cpumask API.

Replace the affinity and pending_masks with cpumask_var_t's.  This adds
to the significant size reduction done with the SPARSE_IRQS changes.

The added functions (init_alloc_desc_masks & init_copy_desc_masks) are
in the include file so they can be inlined (and optimized out for the
!CONFIG_CPUMASKS_OFFSTACK case.)  [Naming chosen to be consistent with
the other init*irq functions, as well as the backwards arg declaration
of "from, to" instead of the more common "to, from" standard.]

Includes a slight change to the declaration of struct irq_desc to embed
the pending_mask within ifdef(CONFIG_SMP) to be consistent with other
references, and some small changes to Xen.

Tested: sparse/non-sparse/cpumask_offstack/non-cpumask_offstack/nonuma/nosmp on x86_64

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: virtualization@lists.osdl.org
Cc: xen-devel@lists.xensource.com
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic.c |   20 +++++------
 arch/x86/kernel/irq_32.c  |    2 -
 arch/x86/kernel/irq_64.c  |    2 -
 drivers/xen/events.c      |    4 +-
 include/linux/irq.h       |   81 ++++++++++++++++++++++++++++++++++++++++++++--
 kernel/irq/chip.c         |    5 ++
 kernel/irq/handle.c       |   26 +++++++-------
 kernel/irq/manage.c       |   12 +++---
 kernel/irq/migration.c    |   12 +++---
 kernel/irq/numa_migrate.c |   12 ++++++
 kernel/irq/proc.c         |    4 +-
 11 files changed, 135 insertions(+), 45 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/io_apic.c
@@ -358,7 +358,7 @@ set_extra_move_desc(struct irq_desc *des
 
 	if (!cfg->move_in_progress) {
 		/* it means that domain is not changed */
-		if (!cpumask_intersects(&desc->affinity, mask))
+		if (!cpumask_intersects(desc->affinity, mask))
 			cfg->move_desc_pending = 1;
 	}
 }
@@ -581,9 +581,9 @@ set_desc_affinity(struct irq_desc *desc,
 	if (assign_irq_vector(irq, cfg, mask))
 		return BAD_APICID;
 
-	cpumask_and(&desc->affinity, cfg->domain, mask);
+	cpumask_and(desc->affinity, cfg->domain, mask);
 	set_extra_move_desc(desc, mask);
-	return cpu_mask_to_apicid_and(&desc->affinity, cpu_online_mask);
+	return cpu_mask_to_apicid_and(desc->affinity, cpu_online_mask);
 }
 
 static void
@@ -2385,7 +2385,7 @@ migrate_ioapic_irq_desc(struct irq_desc 
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	cpumask_copy(&desc->affinity, mask);
+	cpumask_copy(desc->affinity, mask);
 }
 
 static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
@@ -2407,11 +2407,11 @@ static int migrate_irq_remapped_level_de
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq_desc(desc, &desc->pending_mask);
+	migrate_ioapic_irq_desc(desc, desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
-	cpumask_clear(&desc->pending_mask);
+	cpumask_clear(desc->pending_mask);
 
 unmask:
 	unmask_IO_APIC_irq_desc(desc);
@@ -2436,7 +2436,7 @@ static void ir_irq_migration(struct work
 				continue;
 			}
 
-			desc->chip->set_affinity(irq, &desc->pending_mask);
+			desc->chip->set_affinity(irq, desc->pending_mask);
 			spin_unlock_irqrestore(&desc->lock, flags);
 		}
 	}
@@ -2450,7 +2450,7 @@ static void set_ir_ioapic_affinity_irq_d
 {
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
-		cpumask_copy(&desc->pending_mask, mask);
+		cpumask_copy(desc->pending_mask, mask);
 		migrate_irq_remapped_level_desc(desc);
 		return;
 	}
@@ -2518,7 +2518,7 @@ static void irq_complete_move(struct irq
 
 		/* domain has not changed, but affinity did */
 		me = smp_processor_id();
-		if (cpu_isset(me, desc->affinity)) {
+		if (cpumask_test_cpu(me, desc->affinity)) {
 			*descp = desc = move_irq_desc(desc, me);
 			/* get the new one */
 			cfg = desc->chip_data;
@@ -4041,7 +4041,7 @@ void __init setup_ioapic_dest(void)
 			 */
 			if (desc->status &
 			    (IRQ_NO_BALANCING | IRQ_AFFINITY_SET))
-				mask = &desc->affinity;
+				mask = desc->affinity;
 			else
 				mask = TARGET_CPUS;
 
--- linux-2.6-for-ingo.orig/arch/x86/kernel/irq_32.c
+++ linux-2.6-for-ingo/arch/x86/kernel/irq_32.c
@@ -248,7 +248,7 @@ void fixup_irqs(void)
 		if (irq == 2)
 			continue;
 
-		affinity = &desc->affinity;
+		affinity = desc->affinity;
 		if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
 			printk("Breaking affinity for irq %i\n", irq);
 			affinity = cpu_all_mask;
--- linux-2.6-for-ingo.orig/arch/x86/kernel/irq_64.c
+++ linux-2.6-for-ingo/arch/x86/kernel/irq_64.c
@@ -100,7 +100,7 @@ void fixup_irqs(void)
 		/* interrupt's are disabled at this point */
 		spin_lock(&desc->lock);
 
-		affinity = &desc->affinity;
+		affinity = desc->affinity;
 		if (!irq_has_action(irq) ||
 		    cpumask_equal(affinity, cpu_online_mask)) {
 			spin_unlock(&desc->lock);
--- linux-2.6-for-ingo.orig/drivers/xen/events.c
+++ linux-2.6-for-ingo/drivers/xen/events.c
@@ -125,7 +125,7 @@ static void bind_evtchn_to_cpu(unsigned 
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	irq_to_desc(irq)->affinity = cpumask_of_cpu(cpu);
+	cpumask_copy(irq_to_desc(irq)->affinity, cpumask_of(cpu));
 #endif
 
 	__clear_bit(chn, cpu_evtchn_mask[cpu_evtchn[chn]]);
@@ -142,7 +142,7 @@ static void init_evtchn_cpu_bindings(voi
 
 	/* By default all event channels notify CPU#0. */
 	for_each_irq_desc(i, desc) {
-		desc->affinity = cpumask_of_cpu(0);
+		cpumask_copy(desc->affinity, cpumask_of(0));
 	}
 #endif
 
--- linux-2.6-for-ingo.orig/include/linux/irq.h
+++ linux-2.6-for-ingo/include/linux/irq.h
@@ -182,11 +182,11 @@ struct irq_desc {
 	unsigned int		irqs_unhandled;
 	spinlock_t		lock;
 #ifdef CONFIG_SMP
-	cpumask_t		affinity;
+	cpumask_var_t		affinity;
 	unsigned int		cpu;
-#endif
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	cpumask_t		pending_mask;
+	cpumask_var_t		pending_mask;
+#endif
 #endif
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
@@ -422,4 +422,79 @@ extern int set_irq_msi(unsigned int irq,
 
 #endif /* !CONFIG_S390 */
 
+#ifdef CONFIG_SMP
+/**
+ * init_alloc_desc_masks - allocate cpumasks for irq_desc
+ * @desc:	pointer to irq_desc struct
+ * @boot:	true if need bootmem
+ *
+ * Allocates affinity and pending_mask cpumask if required.
+ * Returns true if successful (or not required).
+ * Side effect: affinity has all bits set, pending_mask has all bits clear.
+ */
+static inline bool init_alloc_desc_masks(struct irq_desc *desc, int node,
+								bool boot)
+{
+	if (boot) {
+		alloc_bootmem_cpumask_var(&desc->affinity);
+		cpumask_setall(desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+		alloc_bootmem_cpumask_var(&desc->pending_mask);
+		cpumask_clear(desc->pending_mask);
+#endif
+		return true;
+	}
+
+	if (!alloc_cpumask_var_node(&desc->affinity, GFP_ATOMIC, node))
+		return false;
+	cpumask_setall(desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	if (!alloc_cpumask_var_node(&desc->pending_mask, GFP_ATOMIC, node)) {
+		free_cpumask_var(desc->affinity);
+		return false;
+	}
+	cpumask_clear(desc->pending_mask);
+#endif
+	return true;
+}
+
+/**
+ * init_copy_desc_masks - copy cpumasks for irq_desc
+ * @old_desc:	pointer to old irq_desc struct
+ * @new_desc:	pointer to new irq_desc struct
+ *
+ * Insures affinity and pending_masks are copied to new irq_desc.
+ * If !CONFIG_CPUMASKS_OFFSTACK the cpumasks are embedded in the
+ * irq_desc struct so the copy is redundant.
+ */
+
+static inline void init_copy_desc_masks(struct irq_desc *old_desc,
+					struct irq_desc *new_desc)
+{
+#ifdef CONFIG_CPUMASKS_OFFSTACK
+	cpumask_copy(new_desc->affinity, old_desc->affinity);
+
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_copy(new_desc->pending_mask, old_desc->pending_mask);
+#endif
+#endif
+}
+
+#else /* !CONFIG_SMP */
+
+static inline bool init_alloc_desc_masks(struct irq_desc *desc, int node,
+								bool boot)
+{
+	return true;
+}
+
+static inline void init_copy_desc_masks(struct irq_desc *old_desc,
+					struct irq_desc *new_desc)
+{
+}
+
+#endif	/* CONFIG_SMP */
+
 #endif /* _LINUX_IRQ_H */
--- linux-2.6-for-ingo.orig/kernel/irq/chip.c
+++ linux-2.6-for-ingo/kernel/irq/chip.c
@@ -46,7 +46,10 @@ void dynamic_irq_init(unsigned int irq)
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 #ifdef CONFIG_SMP
-	cpumask_setall(&desc->affinity);
+	cpumask_setall(desc->affinity);
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	cpumask_clear(desc->pending_mask);
+#endif
 #endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
--- linux-2.6-for-ingo.orig/kernel/irq/handle.c
+++ linux-2.6-for-ingo/kernel/irq/handle.c
@@ -64,9 +64,6 @@ static struct irq_desc irq_desc_init = {
 	.handle_irq = handle_bad_irq,
 	.depth      = 1,
 	.lock       = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
-#ifdef CONFIG_SMP
-	.affinity   = CPU_MASK_ALL
-#endif
 };
 
 void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
@@ -88,6 +85,8 @@ void init_kstat_irqs(struct irq_desc *de
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
 {
+	int node = cpu_to_node(cpu);
+
 	memcpy(desc, &irq_desc_init, sizeof(struct irq_desc));
 
 	spin_lock_init(&desc->lock);
@@ -101,6 +100,10 @@ static void init_one_irq_desc(int irq, s
 		printk(KERN_ERR "can not alloc kstat_irqs\n");
 		BUG_ON(1);
 	}
+	if (!init_alloc_desc_masks(desc, node, false)) {
+		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
+		BUG_ON(1);
+	}
 	arch_init_chip_data(desc, cpu);
 }
 
@@ -119,9 +122,6 @@ static struct irq_desc irq_desc_legacy[N
 		.handle_irq = handle_bad_irq,
 		.depth	    = 1,
 		.lock	    = __SPIN_LOCK_UNLOCKED(irq_desc_init.lock),
-#ifdef CONFIG_SMP
-		.affinity   = CPU_MASK_ALL
-#endif
 	}
 };
 
@@ -141,7 +141,7 @@ int __init early_irq_init(void)
 		desc[i].irq = i;
 		desc[i].kstat_irqs = kstat_irqs_legacy[i];
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-
+		init_alloc_desc_masks(&desc[i], 0, true);
 		irq_desc_ptrs[i] = desc + i;
 	}
 
@@ -188,6 +188,10 @@ struct irq_desc *irq_to_desc_alloc_cpu(u
 		printk(KERN_ERR "can not alloc irq_desc\n");
 		BUG_ON(1);
 	}
+	if (!init_alloc_desc_masks(desc, node, false)) {
+		printk(KERN_ERR "can not alloc irq_desc cpumasks\n");
+		BUG_ON(1);
+	}
 	init_one_irq_desc(irq, desc, cpu);
 
 	irq_desc_ptrs[irq] = desc;
@@ -207,9 +211,6 @@ struct irq_desc irq_desc[NR_IRQS] __cach
 		.handle_irq = handle_bad_irq,
 		.depth = 1,
 		.lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
-#ifdef CONFIG_SMP
-		.affinity = CPU_MASK_ALL
-#endif
 	}
 };
 
@@ -222,9 +223,10 @@ int __init early_irq_init(void)
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
 
-	for (i = 0; i < count; i++)
+	for (i = 0; i < count; i++) {
 		desc[i].irq = i;
-
+		init_alloc_desc_masks(&desc[i], 0, true);
+	}
 	return arch_early_irq_init();
 }
 
--- linux-2.6-for-ingo.orig/kernel/irq/manage.c
+++ linux-2.6-for-ingo/kernel/irq/manage.c
@@ -98,14 +98,14 @@ int irq_set_affinity(unsigned int irq, c
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
-		cpumask_copy(&desc->affinity, cpumask);
+		cpumask_copy(desc->affinity, cpumask);
 		desc->chip->set_affinity(irq, cpumask);
 	} else {
 		desc->status |= IRQ_MOVE_PENDING;
-		cpumask_copy(&desc->pending_mask, cpumask);
+		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	cpumask_copy(&desc->affinity, cpumask);
+	cpumask_copy(desc->affinity, cpumask);
 	desc->chip->set_affinity(irq, cpumask);
 #endif
 	desc->status |= IRQ_AFFINITY_SET;
@@ -127,16 +127,16 @@ int do_irq_select_affinity(unsigned int 
 	 * one of the targets is online.
 	 */
 	if (desc->status & (IRQ_AFFINITY_SET | IRQ_NO_BALANCING)) {
-		if (cpumask_any_and(&desc->affinity, cpu_online_mask)
+		if (cpumask_any_and(desc->affinity, cpu_online_mask)
 		    < nr_cpu_ids)
 			goto set_affinity;
 		else
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
 
-	cpumask_and(&desc->affinity, cpu_online_mask, irq_default_affinity);
+	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->chip->set_affinity(irq, &desc->affinity);
+	desc->chip->set_affinity(irq, desc->affinity);
 
 	return 0;
 }
--- linux-2.6-for-ingo.orig/kernel/irq/migration.c
+++ linux-2.6-for-ingo/kernel/irq/migration.c
@@ -18,7 +18,7 @@ void move_masked_irq(int irq)
 
 	desc->status &= ~IRQ_MOVE_PENDING;
 
-	if (unlikely(cpumask_empty(&desc->pending_mask)))
+	if (unlikely(cpumask_empty(desc->pending_mask)))
 		return;
 
 	if (!desc->chip->set_affinity)
@@ -38,13 +38,13 @@ void move_masked_irq(int irq)
 	 * For correct operation this depends on the caller
 	 * masking the irqs.
 	 */
-	if (likely(cpumask_any_and(&desc->pending_mask, cpu_online_mask)
+	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids)) {
-		cpumask_and(&desc->affinity,
-			    &desc->pending_mask, cpu_online_mask);
-		desc->chip->set_affinity(irq, &desc->affinity);
+		cpumask_and(desc->affinity,
+			    desc->pending_mask, cpu_online_mask);
+		desc->chip->set_affinity(irq, desc->affinity);
 	}
-	cpumask_clear(&desc->pending_mask);
+	cpumask_clear(desc->pending_mask);
 }
 
 void move_native_irq(int irq)
--- linux-2.6-for-ingo.orig/kernel/irq/numa_migrate.c
+++ linux-2.6-for-ingo/kernel/irq/numa_migrate.c
@@ -46,6 +46,7 @@ static void init_copy_one_irq_desc(int i
 	desc->cpu = cpu;
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 	init_copy_kstat_irqs(old_desc, desc, cpu, nr_cpu_ids);
+	init_copy_desc_masks(old_desc, desc);
 	arch_init_copy_chip_data(old_desc, desc, cpu);
 }
 
@@ -76,11 +77,20 @@ static struct irq_desc *__real_move_irq_
 	node = cpu_to_node(cpu);
 	desc = kzalloc_node(sizeof(*desc), GFP_ATOMIC, node);
 	if (!desc) {
-		printk(KERN_ERR "irq %d: can not get new irq_desc for migration.\n", irq);
+		printk(KERN_ERR "irq %d: can not get new irq_desc "
+				"for migration.\n", irq);
 		/* still use old one */
 		desc = old_desc;
 		goto out_unlock;
 	}
+	if (!init_alloc_desc_masks(desc, node, false)) {
+		printk(KERN_ERR "irq %d: can not get new irq_desc cpumask "
+				"for migration.\n", irq);
+		/* still use old one */
+		kfree(desc);
+		desc = old_desc;
+		goto out_unlock;
+	}
 	init_copy_one_irq_desc(irq, old_desc, desc, cpu);
 
 	irq_desc_ptrs[irq] = desc;
--- linux-2.6-for-ingo.orig/kernel/irq/proc.c
+++ linux-2.6-for-ingo/kernel/irq/proc.c
@@ -20,11 +20,11 @@ static struct proc_dir_entry *root_irq_d
 static int irq_affinity_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long)m->private);
-	const struct cpumask *mask = &desc->affinity;
+	const struct cpumask *mask = desc->affinity;
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PENDING)
-		mask = &desc->pending_mask;
+		mask = desc->pending_mask;
 #endif
 	seq_cpumask(m, mask);
 	seq_putc(m, '\n');

-- 
