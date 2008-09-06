Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbYIFXx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbYIFXx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYIFXus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:48 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59404 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753055AbYIFXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235038.148283000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:45 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 09/13] genapic: reduce stack pressuge in io_apic.c step 1 temp cpumask_ts
Content-Disposition: inline; filename=stack-hogs-io_apic_c-step-1-temp-cpumask_ts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Step 1 of cleaning up io_apic.c removes local cpumask_t variables
    from the stack.

  - Method 1: remove unnecessary "extra" cpumask variables.

  - Method 2: use for_each_online_cpu_mask_nr() to logically AND
              the passed in mask with cpu_online_map, eliminating
	      the need for a temp cpumask variable.

  - Method 3: use get_cpumask_var variables where possible. The current
    assignment of temp variables is:
	

    /*
     * Temporary cpumask variables
     *
     * (XXX - would be _MUCH_ better as a "stack" of temp cpumasks.)
     *
     * level 4:
     *     irq_complete_move()
     *     check_timer()
     *     msi_compose_msg()
     *     set_msi_irq_affinity()
     *     ir_set_msi_irq_affinity()
     *     dmar_msi_set_affinity()
     *     set_ht_irq_affinity()
     *     arch_setup_ht_irq()
     *     setup_ioapic_dest()
     *
     * level 3:
     *     set_ioapic_affinity_irq()
     *     setup_IO_APIC_irq()
     *     migrate_ioapic_irq()
     *
     * level 2:
     *     create_irq_nr()
     *
     * level 1:
     *     __assign_irq_vector()
     *     setup_timer_IRQ0_pin()
     */

  * Addition of temp cpumask variables for the "target" of TARGET_CPUS
    is in preparation of changing the TARGET_CPUS for x86_64.  I've
    kept those changes here to document which routines get which temp
    cpumask variables.

  * Total stack size savings are in the last step.

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/io_apic.c |  268 ++++++++++++++++++++++++++++++----------------
 1 file changed, 175 insertions(+), 93 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6.tip/arch/x86/kernel/io_apic.c
@@ -41,6 +41,7 @@
 #endif
 #include <linux/bootmem.h>
 #include <linux/dmar.h>
+#include <linux/cpumask_ptr.h>
 
 #include <asm/idle.h>
 #include <asm/io.h>
@@ -93,6 +94,39 @@ int mp_bus_id_to_type[MAX_MP_BUSSES];
 
 DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
+/*
+ * Temporary cpumask variables
+ *
+ * (XXX - would be _MUCH_ better as a "stack" of temp cpumasks.)
+ *
+ * level 4:
+ *     irq_complete_move()
+ *     check_timer()
+ *     msi_compose_msg()
+ *     set_msi_irq_affinity()
+ *     ir_set_msi_irq_affinity()
+ *     dmar_msi_set_affinity()
+ *     set_ht_irq_affinity()
+ *     arch_setup_ht_irq()
+ *     setup_ioapic_dest()
+ *
+ * level 3:
+ *     set_ioapic_affinity_irq()
+ *     setup_IO_APIC_irq()
+ *     migrate_ioapic_irq()
+ *
+ * level 2:
+ *     create_irq_nr()
+ *
+ * level 1:
+ *     __assign_irq_vector()
+ *     setup_timer_IRQ0_pin()
+ */
+static DEFINE_PER_CPUMASK(cpumask_irq_level_4);
+static DEFINE_PER_CPUMASK(cpumask_irq_level_3);
+static DEFINE_PER_CPUMASK(cpumask_irq_level_2);
+static DEFINE_PER_CPUMASK(cpumask_irq_level_1);
+
 int skip_ioapic_setup;
 
 static int __init parse_noapic(char *str)
@@ -551,19 +585,24 @@ static void set_ioapic_affinity_irq(unsi
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_ptr tmp;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	get_cpumask_var(tmp, cpumask_irq_level_3);
+	cpus_and(*tmp, mask, cpu_online_map);
+	if (cpus_empty(*tmp)) {
+		put_cpumask_var(tmp, cpumask_irq_level_3);
 		return;
+	}
 
 	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, mask))
+	if (assign_irq_vector(irq, mask)) {
+		put_cpumask_var(tmp, cpumask_irq_level_3);
 		return;
+	}
 
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	cpus_and(*tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(*tmp);
 	/*
 	 * Only the high 8 bits are valid.
 	 */
@@ -574,6 +613,7 @@ static void set_ioapic_affinity_irq(unsi
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
 	desc->affinity = mask;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
+	put_cpumask_var(tmp, cpumask_irq_level_3);
 }
 #endif /* CONFIG_SMP */
 
@@ -1206,7 +1246,7 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, cpumask_t mask)
+static int __assign_irq_vector(int irq, cpumask_t inmask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1223,37 +1263,37 @@ static int __assign_irq_vector(int irq, 
 	unsigned int old_vector;
 	int cpu;
 	struct irq_cfg *cfg;
+	cpumask_ptr tmpmask;
 
 	cfg = irq_cfg(irq);
-
-	/* Only try and allocate irqs on cpus that are present */
-	cpus_and(mask, mask, cpu_online_map);
-
 	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
 		return -EBUSY;
 
+	/* Only try and allocate irqs on cpus that are present */
+	get_cpumask_var(tmpmask, cpumask_irq_level_1);
+
 	old_vector = cfg->vector;
 	if (old_vector) {
-		cpumask_t tmp;
-		cpus_and(tmp, cfg->domain, mask);
-		if (!cpus_empty(tmp))
+		cpus_and(*tmpmask, inmask, cpu_online_map);
+		cpus_and(*tmpmask, cfg->domain, *tmpmask);
+		if (!cpus_empty(*tmpmask)) {
+			put_cpumask_var(tmpmask, cpumask_irq_level_1);
 			return 0;
+		}
 	}
 
-	for_each_cpu_mask_nr(cpu, mask) {
-		cpumask_t domain, new_mask;
+	for_each_online_cpu_mask_nr(cpu, inmask) {
 		int new_cpu;
 		int vector, offset;
 
-		domain = vector_allocation_domain(cpu);
-		cpus_and(new_mask, domain, cpu_online_map);
+		*tmpmask = vector_allocation_domain(cpu);
 
 		vector = current_vector;
 		offset = current_offset;
 next:
 		vector += 8;
 		if (vector >= first_system_vector) {
-			/* If we run out of vectors on large boxen, must share them. */
+			/* If no more vectors on large boxen, must share them */
 			offset = (offset + 1) % 8;
 			vector = FIRST_DEVICE_VECTOR + offset;
 		}
@@ -1266,7 +1306,7 @@ next:
 		if (vector == SYSCALL_VECTOR)
 			goto next;
 #endif
-		for_each_cpu_mask_nr(new_cpu, new_mask)
+		for_each_online_cpu_mask_nr(new_cpu, *tmpmask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -1276,12 +1316,14 @@ next:
 			cfg->move_in_progress = 1;
 			cfg->old_domain = cfg->domain;
 		}
-		for_each_cpu_mask_nr(new_cpu, new_mask)
+		for_each_online_cpu_mask_nr(new_cpu, *tmpmask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
-		cfg->domain = domain;
+		cfg->domain = *tmpmask;
+		put_cpumask_var(tmpmask, cpumask_irq_level_1);
 		return 0;
 	}
+	put_cpumask_var(tmpmask, cpumask_irq_level_1);
 	return -ENOSPC;
 }
 
@@ -1299,15 +1341,13 @@ static int assign_irq_vector(int irq, cp
 static void __clear_irq_vector(int irq)
 {
 	struct irq_cfg *cfg;
-	cpumask_t mask;
 	int cpu, vector;
 
 	cfg = irq_cfg(irq);
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
-	cpus_and(mask, cfg->domain, cpu_online_map);
-	for_each_cpu_mask_nr(cpu, mask)
+	for_each_online_cpu_mask_nr(cpu, cfg->domain)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
@@ -1478,18 +1518,19 @@ static void setup_IO_APIC_irq(int apic, 
 {
 	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
-	cpumask_t mask;
+	cpumask_ptr mask;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
 	cfg = irq_cfg(irq);
 
-	mask = TARGET_CPUS;
-	if (assign_irq_vector(irq, mask))
-		return;
+	get_cpumask_var(mask, cpumask_irq_level_3);
+	*mask = TARGET_CPUS;
+	if (assign_irq_vector(irq, *mask))
+		goto out;
 
-	cpus_and(mask, cfg->domain, mask);
+	cpus_and(*mask, cfg->domain, *mask);
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1499,12 +1540,12 @@ static void setup_IO_APIC_irq(int apic, 
 
 
 	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
-			       cpu_mask_to_apicid(mask), trigger, polarity,
+			       cpu_mask_to_apicid(*mask), trigger, polarity,
 			       cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
 		__clear_irq_vector(irq);
-		return;
+		goto out;
 	}
 
 	ioapic_register_intr(irq, trigger);
@@ -1512,6 +1553,8 @@ static void setup_IO_APIC_irq(int apic, 
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic, pin, entry);
+out:
+	put_cpumask_var(mask, cpumask_irq_level_3);
 }
 
 static void __init setup_IO_APIC_irqs(void)
@@ -1560,6 +1603,7 @@ static void __init setup_timer_IRQ0_pin(
 					int vector)
 {
 	struct IO_APIC_route_entry entry;
+	cpumask_ptr tgt_cpus;
 
 #ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled)
@@ -1567,6 +1611,8 @@ static void __init setup_timer_IRQ0_pin(
 #endif
 
 	memset(&entry, 0, sizeof(entry));
+	get_cpumask_var(tgt_cpus, cpumask_irq_level_1);
+	*tgt_cpus = TARGET_CPUS;
 
 	/*
 	 * We use logical delivery to get the timer IRQ
@@ -1574,7 +1620,7 @@ static void __init setup_timer_IRQ0_pin(
 	 */
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 1;					/* mask IRQ now */
-	entry.dest = cpu_mask_to_apicid(TARGET_CPUS);
+	entry.dest = cpu_mask_to_apicid(*tgt_cpus);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -1590,6 +1636,7 @@ static void __init setup_timer_IRQ0_pin(
 	 * Add it to the IO-APIC irq-routing table:
 	 */
 	ioapic_write_entry(apic, pin, entry);
+	put_cpumask_var(tgt_cpus, cpumask_irq_level_1);
 }
 
 
@@ -2250,25 +2297,26 @@ static void migrate_ioapic_irq(int irq, 
 {
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
-	cpumask_t tmp, cleanup_mask;
+	cpumask_ptr tmpmask;
 	struct irte irte;
 	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
-		return;
+	get_cpumask_var(tmpmask, cpumask_irq_level_3);
+	cpus_and(*tmpmask, mask, cpu_online_map);
+	if (cpus_empty(*tmpmask))
+		goto out;
 
 	if (get_irte(irq, &irte))
-		return;
+		goto out;
 
 	if (assign_irq_vector(irq, mask))
-		return;
+		goto out;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	cpus_and(*tmpmask, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(*tmpmask);
 
 	desc = irq_to_desc(irq);
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
@@ -2287,13 +2335,15 @@ static void migrate_ioapic_irq(int irq, 
 	modify_irte(irq, &irte);
 
 	if (cfg->move_in_progress) {
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cpus_and(*tmpmask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(*tmpmask);
+		send_IPI_mask(*tmpmask, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 
 	desc->affinity = mask;
+out:
+	put_cpumask_var(tmpmask, cpumask_irq_level_3);
 }
 
 static int migrate_irq_remapped_level(int irq)
@@ -2415,11 +2465,13 @@ static void irq_complete_move(unsigned i
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
-		cpumask_t cleanup_mask;
+		cpumask_ptr cleanup_mask;
 
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		get_cpumask_var(cleanup_mask, cpumask_irq_level_4);
+		cpus_and(*cleanup_mask, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(*cleanup_mask);
+		send_IPI_mask(*cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		put_cpumask_var(cleanup_mask, cpumask_irq_level_4);
 		cfg->move_in_progress = 0;
 	}
 }
@@ -2749,6 +2801,7 @@ static inline void __init check_timer(vo
 	unsigned long flags;
 	unsigned int ver;
 	int no_pin1 = 0;
+	cpumask_ptr tgt_cpus;
 
 	local_irq_save(flags);
 
@@ -2759,7 +2812,10 @@ static inline void __init check_timer(vo
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, TARGET_CPUS);
+	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
+	*tgt_cpus = TARGET_CPUS;
+	assign_irq_vector(0, *tgt_cpus);
+	put_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -3059,12 +3115,15 @@ unsigned int create_irq_nr(unsigned int 
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new;
+	cpumask_ptr tgt_cpus;
 
 #ifndef CONFIG_HAVE_SPARSE_IRQ
 	irq_want = nr_irqs - 1;
 #endif
 
 	irq = 0;
+	get_cpumask_var(tgt_cpus, cpumask_irq_level_2);
+	*tgt_cpus = TARGET_CPUS;
 	spin_lock_irqsave(&vector_lock, flags);
 	for (new = irq_want; new > 0; new--) {
 		if (platform_legacy_irq(new))
@@ -3075,11 +3134,12 @@ unsigned int create_irq_nr(unsigned int 
 		/* check if need to create one */
 		if (!cfg_new)
 			cfg_new = irq_cfg_alloc(new);
-		if (__assign_irq_vector(new, TARGET_CPUS) == 0)
+		if (__assign_irq_vector(new, *tgt_cpus) == 0)
 			irq = new;
 		break;
 	}
 	spin_unlock_irqrestore(&vector_lock, flags);
+	put_cpumask_var(tgt_cpus, cpumask_irq_level_2);
 
 	if (irq > 0) {
 		dynamic_irq_init(irq);
@@ -3122,16 +3182,18 @@ static int msi_compose_msg(struct pci_de
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
-	cpumask_t tmp;
+	cpumask_ptr tgt_cpus;
 
-	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
+	*tgt_cpus = TARGET_CPUS;
+	err = assign_irq_vector(irq, *tgt_cpus);
 	if (err)
 		return err;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, tmp);
-	dest = cpu_mask_to_apicid(tmp);
+	cpus_and(*tgt_cpus, cfg->domain, *tgt_cpus);
+	dest = cpu_mask_to_apicid(*tgt_cpus);
+	put_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
@@ -3190,19 +3252,20 @@ static void set_msi_irq_affinity(unsigne
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_ptr tmp;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
-		return;
+	get_cpumask_var(tmp, cpumask_irq_level_4);
+	cpus_and(*tmp, mask, cpu_online_map);
+	if (cpus_empty(*tmp))
+		goto out;
 
 	if (assign_irq_vector(irq, mask))
-		return;
+		goto out;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	cpus_and(*tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(*tmp);
 
 	read_msi_msg(irq, &msg);
 
@@ -3214,6 +3277,8 @@ static void set_msi_irq_affinity(unsigne
 	write_msi_msg(irq, &msg);
 	desc = irq_to_desc(irq);
 	desc->affinity = mask;
+out:
+	put_cpumask_var(tmp, cpumask_irq_level_4);
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -3225,12 +3290,13 @@ static void ir_set_msi_irq_affinity(unsi
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp, cleanup_mask;
+	cpumask_ptr tmp;
 	struct irte irte;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
+	get_cpumask_var(tmp, cpumask_irq_level_4);
+	cpus_and(*tmp, mask, cpu_online_map);
+	if (cpus_empty(*tmp))
 		return;
 
 	if (get_irte(irq, &irte))
@@ -3240,8 +3306,8 @@ static void ir_set_msi_irq_affinity(unsi
 		return;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	cpus_and(*tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(*tmp);
 
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
@@ -3257,14 +3323,15 @@ static void ir_set_msi_irq_affinity(unsi
 	 * vector allocation.
 	 */
 	if (cfg->move_in_progress) {
-		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
-		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		cpus_and(*tmp, cfg->old_domain, cpu_online_map);
+		cfg->move_cleanup_count = cpus_weight(*tmp);
+		send_IPI_mask(*tmp, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 
 	desc = irq_to_desc(irq);
 	desc->affinity = mask;
+	put_cpumask_var(tmp, cpumask_irq_level_4);
 }
 #endif
 #endif /* CONFIG_SMP */
@@ -3469,19 +3536,20 @@ static void dmar_msi_set_affinity(unsign
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_ptr tmp;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
-		return;
+	get_cpumask_var(tmp, cpumask_irq_level_4);
+	cpus_and(*tmp, mask, cpu_online_map);
+	if (cpus_empty(*tmp))
+		goto out;
 
 	if (assign_irq_vector(irq, mask))
-		return;
+		goto out;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	cpus_and(*tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(*tmp);
 
 	dmar_msi_read(irq, &msg);
 
@@ -3493,6 +3561,8 @@ static void dmar_msi_set_affinity(unsign
 	dmar_msi_write(irq, &msg);
 	desc = irq_to_desc(irq);
 	desc->affinity = mask;
+out:
+	put_cpumask_var(tmp, cpumask_irq_level_4);
 }
 #endif /* CONFIG_SMP */
 
@@ -3548,23 +3618,26 @@ static void set_ht_irq_affinity(unsigned
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_ptr tmp;
 	struct irq_desc *desc;
 
-	cpus_and(tmp, mask, cpu_online_map);
-	if (cpus_empty(tmp))
-		return;
+	get_cpumask_var(tmp, cpumask_irq_level_4);
+	cpus_and(*tmp, mask, cpu_online_map);
+	if (cpus_empty(*tmp))
+		goto out;
 
 	if (assign_irq_vector(irq, mask))
-		return;
+		goto out;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(tmp);
+	cpus_and(*tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(*tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
 	desc = irq_to_desc(irq);
 	desc->affinity = mask;
+out:
+	put_cpumask_var(tmp, cpumask_irq_level_4);
 }
 #endif
 
@@ -3583,17 +3656,18 @@ int arch_setup_ht_irq(unsigned int irq, 
 {
 	struct irq_cfg *cfg;
 	int err;
-	cpumask_t tmp;
+	cpumask_ptr tgt_cpus;
 
-	tmp = TARGET_CPUS;
-	err = assign_irq_vector(irq, tmp);
+	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
+	*tgt_cpus = TARGET_CPUS;
+	err = assign_irq_vector(irq, *tgt_cpus);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
 		cfg = irq_cfg(irq);
-		cpus_and(tmp, cfg->domain, tmp);
-		dest = cpu_mask_to_apicid(tmp);
+		cpus_and(*tgt_cpus, cfg->domain, *tgt_cpus);
+		dest = cpu_mask_to_apicid(*tgt_cpus);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3615,6 +3689,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 		set_irq_chip_and_handler_name(irq, &ht_irq_chip,
 					      handle_edge_irq, "edge");
 	}
+	put_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 	return err;
 }
 #endif /* CONFIG_HT_IRQ */
@@ -3799,10 +3874,12 @@ void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
 	struct irq_cfg *cfg;
+	cpumask_ptr tgt_cpus;
 
 	if (skip_ioapic_setup == 1)
 		return;
 
+	get_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
 		for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
 			irq_entry = find_irq_entry(ioapic, pin, mp_INT);
@@ -3820,14 +3897,19 @@ void __init setup_ioapic_dest(void)
 						  irq_trigger(irq_entry),
 						  irq_polarity(irq_entry));
 #ifdef CONFIG_INTR_REMAP
-			else if (intr_remapping_enabled)
-				set_ir_ioapic_affinity_irq(irq, TARGET_CPUS);
+			else if (intr_remapping_enabled) {
+				*tgt_cpus = TARGET_CPUS;
+				set_ir_ioapic_affinity_irq(irq, *tgt_cpus);
+			}
 #endif
-			else
-				set_ioapic_affinity_irq(irq, TARGET_CPUS);
+			else {
+				*tgt_cpus = TARGET_CPUS;
+				set_ioapic_affinity_irq(irq, *tgt_cpus);
+			}
 		}
 
 	}
+	put_cpumask_var(tgt_cpus, cpumask_irq_level_4);
 }
 #endif
 

-- 
