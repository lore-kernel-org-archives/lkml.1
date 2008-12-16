Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbYLPCZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbYLPCZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYLPCYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:17 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40534 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751556AbYLPCYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:13 -0500
Message-Id: <20081216022410.662835000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:15 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] x86: Update io_apic.c to use new cpumask API
Content-Disposition: inline; filename=update-io_apic.c-to-new-cpumask-api.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, consolidate patches, use new API

Consolidate the following into a single patch to adapt to new
sparseirq code in arch/x86/kernel/io_apic.c, add allocation of
cpumask_var_t's in domain and old_domain, and reduce further
merge conflicts.  Only one file (arch/x86/kernel/io_apic.c) is
changed in all of these patches.

	0006-x86-io_apic-change-irq_cfg-domain-old_domain-to.patch
	0007-x86-io_apic-set_desc_affinity.patch
	0008-x86-io_apic-send_cleanup_vector.patch
	0009-x86-io_apic-eliminate-remaining-cpumask_ts-from-st.patch
	0021-x86-final-cleanups-in-io_apic-to-use-new-cpumask-AP.patch

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/io_apic.c |  304 ++++++++++++++++++++++------------------------
 1 file changed, 146 insertions(+), 158 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6-for-ingo/arch/x86/kernel/io_apic.c
@@ -136,8 +136,8 @@ static struct irq_pin_list *get_one_free
 
 struct irq_cfg {
 	struct irq_pin_list *irq_2_pin;
-	cpumask_t domain;
-	cpumask_t old_domain;
+	cpumask_var_t domain;
+	cpumask_var_t old_domain;
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
@@ -149,22 +149,22 @@ static struct irq_cfg irq_cfgx[] = {
 #else
 static struct irq_cfg irq_cfgx[NR_IRQS] = {
 #endif
-	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
-	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
-	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
-	[3]  = { .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
-	[4]  = { .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
-	[5]  = { .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
-	[6]  = { .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
-	[7]  = { .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
-	[8]  = { .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
-	[9]  = { .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
-	[10] = { .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
-	[11] = { .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
-	[12] = { .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
-	[13] = { .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
-	[14] = { .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
-	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
+	[0]  = { .vector = IRQ0_VECTOR,  },
+	[1]  = { .vector = IRQ1_VECTOR,  },
+	[2]  = { .vector = IRQ2_VECTOR,  },
+	[3]  = { .vector = IRQ3_VECTOR,  },
+	[4]  = { .vector = IRQ4_VECTOR,  },
+	[5]  = { .vector = IRQ5_VECTOR,  },
+	[6]  = { .vector = IRQ6_VECTOR,  },
+	[7]  = { .vector = IRQ7_VECTOR,  },
+	[8]  = { .vector = IRQ8_VECTOR,  },
+	[9]  = { .vector = IRQ9_VECTOR,  },
+	[10] = { .vector = IRQ10_VECTOR, },
+	[11] = { .vector = IRQ11_VECTOR, },
+	[12] = { .vector = IRQ12_VECTOR, },
+	[13] = { .vector = IRQ13_VECTOR, },
+	[14] = { .vector = IRQ14_VECTOR, },
+	[15] = { .vector = IRQ15_VECTOR, },
 };
 
 void __init arch_early_irq_init(void)
@@ -180,6 +180,10 @@ void __init arch_early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
+		alloc_bootmem_cpumask_var(&cfg[i].domain);
+		alloc_bootmem_cpumask_var(&cfg[i].old_domain);
+		if (i < NR_IRQS_LEGACY)
+			cpumask_setall(cfg[i].domain);
 	}
 }
 
@@ -204,6 +208,20 @@ static struct irq_cfg *get_one_free_irq_
 	node = cpu_to_node(cpu);
 
 	cfg = kzalloc_node(sizeof(*cfg), GFP_ATOMIC, node);
+	if (cfg) {
+		/* FIXME: needs alloc_cpumask_var_node() */
+		if (!alloc_cpumask_var(&cfg->domain, GFP_ATOMIC)) {
+			kfree(cfg);
+			cfg = NULL;
+		} else if (!alloc_cpumask_var(&cfg->old_domain, GFP_ATOMIC)) {
+			free_cpumask_var(cfg->domain);
+			kfree(cfg);
+			cfg = NULL;
+		} else {
+			cpumask_clear(cfg->domain);
+			cpumask_clear(cfg->old_domain);
+		}
+	}
 	printk(KERN_DEBUG "  alloc irq_cfg on cpu %d node %d\n", cpu, node);
 
 	return cfg;
@@ -362,6 +380,26 @@ static void ioapic_mask_entry(int apic, 
 }
 
 #ifdef CONFIG_SMP
+static void send_cleanup_vector(struct irq_cfg *cfg)
+{
+	cpumask_var_t cleanup_mask;
+
+	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
+		unsigned int i;
+		cfg->move_cleanup_count = 0;
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			cfg->move_cleanup_count++;
+		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+			send_IPI_mask(cpumask_of(i), IRQ_MOVE_CLEANUP_VECTOR);
+	} else {
+		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
+		cfg->move_cleanup_count = cpumask_weight(cleanup_mask);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		free_cpumask_var(cleanup_mask);
+	}
+	cfg->move_in_progress = 0;
+}
+
 static void __target_IO_APIC_irq(unsigned int irq, unsigned int dest, struct irq_cfg *cfg)
 {
 	int apic, pin;
@@ -400,40 +438,52 @@ static void __target_IO_APIC_irq(unsigne
 static int
 assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask);
 
-static void set_ioapic_affinity_irq_desc(struct irq_desc *desc,
-					 const struct cpumask *mask)
+/*
+ * Either sets desc->affinity to a valid value, and returns cpu_mask_to_apicid
+ * of that, or returns BAD_APICID and leaves desc->affinity untouched.
+ */
+static unsigned int
+set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
-	unsigned long flags;
-	unsigned int dest;
-	cpumask_t tmp;
 	unsigned int irq;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
+		return BAD_APICID;
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
 	if (assign_irq_vector(irq, cfg, mask))
-		return;
+		return BAD_APICID;
 
+	cpumask_and(&desc->affinity, cfg->domain, mask);
 	set_extra_move_desc(desc, mask);
+	return cpu_mask_to_apicid_and(&desc->affinity, cpu_online_mask);
+}
 
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
-	/*
-	 * Only the high 8 bits are valid.
-	 */
-	dest = SET_APIC_LOGICAL_ID(dest);
+static void
+set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	unsigned int dest;
+	unsigned int irq;
+
+	irq = desc->irq;
+	cfg = desc->chip_data;
 
 	spin_lock_irqsave(&ioapic_lock, flags);
-	__target_IO_APIC_irq(irq, dest, cfg);
-	cpumask_copy(&desc->affinity, mask);
+	dest = set_desc_affinity(desc, mask);
+	if (dest != BAD_APICID) {
+		/* Only the high 8 bits are valid. */
+		dest = SET_APIC_LOGICAL_ID(dest);
+		__target_IO_APIC_irq(irq, dest, cfg);
+	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-static void set_ioapic_affinity_irq(unsigned int irq,
-				    const struct cpumask *mask)
+static void
+set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc;
 
@@ -1117,26 +1167,32 @@ __assign_irq_vector(int irq, struct irq_
 	 */
 	static int current_vector = FIRST_DEVICE_VECTOR, current_offset = 0;
 	unsigned int old_vector;
-	int cpu;
-	cpumask_t tmp_mask;
+	int cpu, err;
+	cpumask_var_t tmp_mask;
 
 	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
 		return -EBUSY;
 
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return -ENOMEM;
+
 	old_vector = cfg->vector;
 	if (old_vector) {
-		cpus_and(tmp_mask, *mask, cpu_online_map);
-		cpus_and(tmp_mask, cfg->domain, tmp_mask);
-		if (!cpus_empty(tmp_mask))
-			return 0;
+		cpumask_and(tmp_mask, mask, cpu_online_mask);
+		cpumask_and(tmp_mask, cfg->domain, tmp_mask);
+		if (!cpumask_empty(tmp_mask)) {
+			free_cpumask_var(tmp_mask);
+ 			return 0;
+		}
 	}
 
 	/* Only try and allocate irqs on cpus that are present */
-	for_each_cpu_and(cpu, mask, &cpu_online_map) {
+	err = -ENOSPC;
+	for_each_cpu_and(cpu, mask, cpu_online_mask) {
 		int new_cpu;
 		int vector, offset;
 
-		vector_allocation_domain(cpu, &tmp_mask);
+		vector_allocation_domain(cpu, tmp_mask);
 
 		vector = current_vector;
 		offset = current_offset;
@@ -1156,7 +1212,7 @@ next:
 		if (vector == SYSCALL_VECTOR)
 			goto next;
 #endif
-		for_each_cpu_and(new_cpu, &tmp_mask, &cpu_online_map)
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -1164,15 +1220,17 @@ next:
 		current_offset = offset;
 		if (old_vector) {
 			cfg->move_in_progress = 1;
-			cfg->old_domain = cfg->domain;
+			cpumask_copy(cfg->old_domain, cfg->domain);
 		}
-		for_each_cpu_and(new_cpu, &tmp_mask, &cpu_online_map)
+		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
-		cfg->domain = tmp_mask;
-		return 0;
+		cpumask_copy(cfg->domain, tmp_mask);
+		err = 0;
+		break;
 	}
-	return -ENOSPC;
+	free_cpumask_var(tmp_mask);
+	return err;
 }
 
 static int
@@ -1189,23 +1247,20 @@ assign_irq_vector(int irq, struct irq_cf
 
 static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 {
-	cpumask_t mask;
 	int cpu, vector;
 
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
-	cpus_and(mask, cfg->domain, cpu_online_map);
-	for_each_cpu_mask_nr(cpu, mask)
+	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
-	cpus_clear(cfg->domain);
+	cpumask_clear(cfg->domain);
 
 	if (likely(!cfg->move_in_progress))
 		return;
-	cpus_and(mask, cfg->old_domain, cpu_online_map);
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 								vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
@@ -1230,7 +1285,7 @@ void __setup_vector_irq(int cpu)
 		if (!desc)
 			continue;
 		cfg = desc->chip_data;
-		if (!cpu_isset(cpu, cfg->domain))
+		if (!cpumask_test_cpu(cpu, cfg->domain))
 			continue;
 		vector = cfg->vector;
 		per_cpu(vector_irq, cpu)[vector] = irq;
@@ -1242,7 +1297,7 @@ void __setup_vector_irq(int cpu)
 			continue;
 
 		cfg = irq_cfg(irq);
-		if (!cpu_isset(cpu, cfg->domain))
+		if (!cpumask_test_cpu(cpu, cfg->domain))
 			per_cpu(vector_irq, cpu)[vector] = -1;
 	}
 }
@@ -1378,18 +1433,17 @@ static void setup_IO_APIC_irq(int apic, 
 {
 	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
-	cpumask_t mask;
+	unsigned int dest;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
 	cfg = desc->chip_data;
 
-	mask = *TARGET_CPUS;
-	if (assign_irq_vector(irq, cfg, &mask))
+	if (assign_irq_vector(irq, cfg, TARGET_CPUS))
 		return;
 
-	cpus_and(mask, cfg->domain, mask);
+	dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1399,8 +1453,7 @@ static void setup_IO_APIC_irq(int apic, 
 
 
 	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
-			       cpu_mask_to_apicid(&mask), trigger, polarity,
-			       cfg->vector)) {
+			       dest, trigger, polarity, cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
 		__clear_irq_vector(irq, cfg);
@@ -2122,7 +2175,7 @@ static int ioapic_retrigger_irq(unsigned
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	send_IPI_mask(&cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
+	send_IPI_mask(cpumask_of(cpumask_first(cfg->domain)), cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
@@ -2175,15 +2228,13 @@ static void
 migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
-	cpumask_t tmpmask;
 	struct irte irte;
 	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
 	unsigned int irq;
 
-	cpus_and(tmpmask, *mask, cpu_online_map);
-	if (cpus_empty(tmpmask))
+	if (!cpumask_intersects(mask, cpu_online_mask))
 		return;
 
 	irq = desc->irq;
@@ -2196,8 +2247,7 @@ migrate_ioapic_irq_desc(struct irq_desc 
 
 	set_extra_move_desc(desc, mask);
 
-	cpus_and(tmpmask, cfg->domain, *mask);
-	dest = cpu_mask_to_apicid(&tmpmask);
+	dest = cpu_mask_to_apicid_and(cfg->domain, mask);
 
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
 	if (modify_ioapic_rte) {
@@ -2214,14 +2264,10 @@ migrate_ioapic_irq_desc(struct irq_desc 
 	 */
 	modify_irte(irq, &irte);
 
-	if (cfg->move_in_progress) {
-		cpus_and(tmpmask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(tmpmask);
-		send_IPI_mask(&tmpmask, IRQ_MOVE_CLEANUP_VECTOR);
-		cfg->move_in_progress = 0;
-	}
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
 
-	desc->affinity = *mask;
+	cpumask_copy(&desc->affinity, mask);
 }
 
 static int migrate_irq_remapped_level_desc(struct irq_desc *desc)
@@ -2247,7 +2293,7 @@ static int migrate_irq_remapped_level_de
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
-	cpus_clear(desc->pending_mask);
+	cpumask_clear(&desc->pending_mask);
 
 unmask:
 	unmask_IO_APIC_irq_desc(desc);
@@ -2333,7 +2379,7 @@ asmlinkage void smp_irq_move_cleanup_int
 		if (!cfg->move_cleanup_count)
 			goto unlock;
 
-		if ((vector == cfg->vector) && cpu_isset(me, cfg->domain))
+		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
 
 		__get_cpu_var(vector_irq)[vector] = -1;
@@ -2356,14 +2402,8 @@ static void irq_complete_move(struct irq
 
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
-	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
-		cpumask_t cleanup_mask;
-
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(&cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
-		cfg->move_in_progress = 0;
-	}
+	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
+		send_cleanup_vector(cfg);
 }
 #else
 static inline void irq_complete_move(struct irq_desc **descp) {}
@@ -3088,16 +3128,13 @@ static int msi_compose_msg(struct pci_de
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
-	cpumask_t tmp;
 
 	cfg = irq_cfg(irq);
-	tmp = *TARGET_CPUS;
-	err = assign_irq_vector(irq, cfg, &tmp);
+	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
 	if (err)
 		return err;
 
-	cpus_and(tmp, cfg->domain, tmp);
-	dest = cpu_mask_to_apicid(&tmp);
+	dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
@@ -3157,19 +3194,12 @@ static void set_msi_irq_affinity(unsigne
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
-
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
 
 	read_msi_msg_desc(desc, &msg);
 
@@ -3179,7 +3209,6 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg_desc(desc, &msg);
-	cpumask_copy(&desc->affinity, mask);
 }
 #ifdef CONFIG_INTR_REMAP
 /*
@@ -3192,24 +3221,15 @@ ir_set_msi_irq_affinity(unsigned int irq
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp, cleanup_mask;
 	struct irte irte;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
-
 	if (get_irte(irq, &irte))
 		return;
 
-	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
-	set_extra_move_desc(desc, mask);
-
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
-
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
 
@@ -3223,14 +3243,8 @@ ir_set_msi_irq_affinity(unsigned int irq
 	 * at the new destination. So, time to cleanup the previous
 	 * vector allocation.
 	 */
-	if (cfg->move_in_progress) {
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(&cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
-		cfg->move_in_progress = 0;
-	}
-
-	cpumask_copy(&desc->affinity, mask);
+	if (cfg->move_in_progress)
+		send_cleanup_vector(cfg);
 }
 
 #endif
@@ -3421,25 +3435,18 @@ void arch_teardown_msi_irq(unsigned int 
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, const cpumask_t *mask)
+static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
-
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
 
 	dmar_msi_read(irq, &msg);
 
@@ -3449,7 +3456,6 @@ static void dmar_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
-	cpumask_copy(&desc->affinity, mask);
 }
 
 #endif /* CONFIG_SMP */
@@ -3483,25 +3489,18 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static void hpet_msi_set_affinity(unsigned int irq, const cpumask_t *mask)
+static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
-
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
 
 	hpet_msi_read(irq, &msg);
 
@@ -3511,7 +3510,6 @@ static void hpet_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
-	cpumask_copy(&desc->affinity, mask);
 }
 
 #endif /* CONFIG_SMP */
@@ -3566,27 +3564,19 @@ static void target_ht_irq(unsigned int i
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, const cpumask_t *mask)
+static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	dest = set_desc_affinity(desc, mask);
+	if (dest == BAD_APICID)
 		return;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return;
-
-	set_extra_move_desc(desc, mask);
-
-	cpumask_and(&tmp, &cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
-	cpumask_copy(&desc->affinity, mask);
 }
 
 #endif
@@ -3606,7 +3596,6 @@ int arch_setup_ht_irq(unsigned int irq, 
 {
 	struct irq_cfg *cfg;
 	int err;
-	cpumask_t tmp;
 
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
@@ -3614,8 +3603,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 		struct ht_irq_msg msg;
 		unsigned dest;
 
-		cpus_and(tmp, cfg->domain, tmp);
-		dest = cpu_mask_to_apicid(&tmp);
+		dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3651,7 +3639,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 int arch_enable_uv_irq(char *irq_name, unsigned int irq, int cpu, int mmr_blade,
 		       unsigned long mmr_offset)
 {
-	const cpumask_t *eligible_cpu = &cpumask_of_cpu(cpu);
+	const struct cpumask *eligible_cpu = cpumask_of(cpu);
 	struct irq_cfg *cfg;
 	int mmr_pnode;
 	unsigned long mmr_value;
@@ -3891,7 +3879,7 @@ void __init setup_ioapic_dest(void)
 	int pin, ioapic, irq, irq_entry;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	const cpumask_t *mask;
+	const struct cpumask *mask;
 
 	if (skip_ioapic_setup == 1)
 		return;

-- 
