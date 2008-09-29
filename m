Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYI2SN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYI2SN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYI2SDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58627 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753968AbYI2SCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:53 -0400
Message-Id: <20080929180252.316666000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:06 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 16/31] cpumask: clean apic files
Content-Disposition: inline; filename=clean-apic
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic.c                   |   10 -
 arch/x86/kernel/genapic_flat_64.c        |   38 +++----
 arch/x86/kernel/genx2apic_cluster.c      |   16 +--
 arch/x86/kernel/genx2apic_phys.c         |   16 +--
 arch/x86/kernel/genx2apic_uv_x.c         |   18 +--
 arch/x86/kernel/io_apic.c                |  157 +++++++++++++++----------------
 arch/x86/kernel/ipi.c                    |    6 -
 include/asm-x86/bigsmp/apic.h            |    2 
 include/asm-x86/es7000/apic.h            |    2 
 include/asm-x86/genapic_32.h             |    4 
 include/asm-x86/genapic_64.h             |    8 -
 include/asm-x86/ipi.h                    |    4 
 include/asm-x86/mach-default/mach_apic.h |    2 
 include/asm-x86/mach-default/mach_ipi.h  |   10 -
 include/asm-x86/numaq/apic.h             |    2 
 include/asm-x86/numaq/ipi.h              |    6 -
 include/asm-x86/summit/apic.h            |    2 
 include/asm-x86/summit/ipi.h             |    6 -
 18 files changed, 156 insertions(+), 153 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/apic.c
+++ struct-cpumasks/arch/x86/kernel/apic.c
@@ -141,7 +141,7 @@ static int lapic_next_event(unsigned lon
 			    struct clock_event_device *evt);
 static void lapic_timer_setup(enum clock_event_mode mode,
 			      struct clock_event_device *evt);
-static void lapic_timer_broadcast(cpumask_t mask);
+static void lapic_timer_broadcast(const_cpumask_t mask);
 static void apic_pm_activate(void);
 
 /*
@@ -457,10 +457,10 @@ static void lapic_timer_setup(enum clock
 /*
  * Local APIC timer broadcast function
  */
-static void lapic_timer_broadcast(cpumask_t mask)
+static void lapic_timer_broadcast(const_cpumask_t mask)
 {
 #ifdef CONFIG_SMP
-	send_IPI_mask(&mask, LOCAL_TIMER_VECTOR);
+	send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
 #endif
 }
 
@@ -473,7 +473,7 @@ static void __cpuinit setup_APIC_timer(v
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
 	memcpy(levt, &lapic_clockevent, sizeof(*levt));
-	levt->cpumask = cpumask_of_cpu(smp_processor_id());
+	cpus_copy(levt->cpumask, cpumask_of_cpu(smp_processor_id()));
 
 	clockevents_register_device(levt);
 }
@@ -1836,7 +1836,7 @@ void disconnect_bsp_APIC(int virt_wire_s
 void __cpuinit generic_processor_info(int apicid, int version)
 {
 	int cpu;
-	cpumask_t tmp_map;
+	cpumask_var_t tmp_map;
 
 	/*
 	 * Validate version
--- struct-cpumasks.orig/arch/x86/kernel/genapic_flat_64.c
+++ struct-cpumasks/arch/x86/kernel/genapic_flat_64.c
@@ -30,12 +30,12 @@ static int __init flat_acpi_madt_oem_che
 	return 1;
 }
 
-static void flat_target_cpus(cpumask_t *retmask)
+static void flat_target_cpus(cpumask_t retmask)
 {
-	*retmask = cpu_online_map;
+	cpus_copy(retmask, cpu_online_map);
 }
 
-static void flat_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void flat_vector_allocation_domain(int cpu, cpumask_t retmask)
 {
 	/* Careful. Some cpus do not strictly honor the set of cpus
 	 * specified in the interrupt destination when using lowest
@@ -45,7 +45,9 @@ static void flat_vector_allocation_domai
 	 * deliver interrupts to the wrong hyperthread when only one
 	 * hyperthread was specified in the interrupt desitination.
 	 */
-	*retmask = (cpumask_t) { { [0] = APIC_ALL_CPUS, } };
+	static cpumask_map_t all_cpus = CPU_MASK_INIT(APIC_ALL_CPUS);
+
+	cpus_copy(retmask, all_cpus);
 }
 
 /*
@@ -77,9 +79,9 @@ static void inline _flat_send_IPI_mask(u
 	local_irq_restore(flags);
 }
 
-static void flat_send_IPI_mask(const cpumask_t *cpumask, int vector)
+static void flat_send_IPI_mask(const_cpumask_t cpumask, int vector)
 {
-	unsigned long mask = cpus_addr(*cpumask)[0];
+	unsigned long mask = cpus_addr(cpumask)[0];
 
 	_flat_send_IPI_mask(mask, vector);
 }
@@ -109,7 +111,7 @@ static void flat_send_IPI_allbutself(int
 static void flat_send_IPI_all(int vector)
 {
 	if (vector == NMI_VECTOR)
-		flat_send_IPI_mask(&cpu_online_map, vector);
+		flat_send_IPI_mask(cpu_online_map, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
@@ -143,9 +145,9 @@ static int flat_apic_id_registered(void)
 	return physid_isset(read_xapic_id(), phys_cpu_present_map);
 }
 
-static unsigned int flat_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int flat_cpu_mask_to_apicid(const_cpumask_t cpumask)
 {
-	return cpus_addr(*cpumask)[0] & APIC_ALL_CPUS;
+	return cpus_addr(cpumask)[0] & APIC_ALL_CPUS;
 }
 
 static unsigned int phys_pkg_id(int index_msb)
@@ -196,33 +198,33 @@ static int __init physflat_acpi_madt_oem
 	return 0;
 }
 
-static cpumask_t physflat_target_cpus(void)
+static void physflat_target_cpus(cpumask_t retmask)
 {
-	return cpu_online_map;
+	cpus_copy(retmask, cpu_online_map);
 }
 
-static void physflat_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void physflat_vector_allocation_domain(int cpu, cpumask_t retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpus_clear(retmask);
+	cpu_set(cpu, retmask);
 }
 
-static void physflat_send_IPI_mask(const cpumask_t *cpumask, int vector)
+static void physflat_send_IPI_mask(const_cpumask_t cpumask, int vector)
 {
 	send_IPI_mask_sequence(cpumask, vector);
 }
 
 static void physflat_send_IPI_allbutself(int vector)
 {
-	send_IPI_mask_allbutself(&cpu_online_map, vector);
+	send_IPI_mask_allbutself(cpu_online_map, vector);
 }
 
 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(&cpu_online_map, vector);
+	physflat_send_IPI_mask(cpu_online_map, vector);
 }
 
-static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t cpumask)
+static unsigned int physflat_cpu_mask_to_apicid(const_cpumask_t cpumask)
 {
 	int cpu;
 
--- struct-cpumasks.orig/arch/x86/kernel/genx2apic_cluster.c
+++ struct-cpumasks/arch/x86/kernel/genx2apic_cluster.c
@@ -22,18 +22,18 @@ static int __init x2apic_acpi_madt_oem_c
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t x2apic_target_cpus(void)
+static void x2apic_target_cpus(cpumask_t retmask)
 {
-	return cpumask_of_cpu(0);
+	cpus_copy(retmask, cpumask_of_cpu(0));
 }
 
 /*
  * for now each logical cpu is in its own vector allocation domain.
  */
-static void x2apic_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void x2apic_vector_allocation_domain(int cpu, cpumask_t retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpus_clear(retmask);
+	cpu_set(cpu, retmask);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
@@ -55,7 +55,7 @@ static void __x2apic_send_IPI_dest(unsig
  * at once. We have 16 cpu's in a cluster. This will minimize IPI register
  * writes.
  */
-static void x2apic_send_IPI_mask(const cpumask_t *mask, int vector)
+static void x2apic_send_IPI_mask(const_cpumask_t mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
@@ -85,7 +85,7 @@ static void x2apic_send_IPI_allbutself(i
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(&cpu_online_map, vector);
+	x2apic_send_IPI_mask(cpu_online_map, vector);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -93,7 +93,7 @@ static int x2apic_apic_id_registered(voi
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const_cpumask_t cpumask)
 {
 	int cpu;
 
--- struct-cpumasks.orig/arch/x86/kernel/genx2apic_phys.c
+++ struct-cpumasks/arch/x86/kernel/genx2apic_phys.c
@@ -29,15 +29,15 @@ static int __init x2apic_acpi_madt_oem_c
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t x2apic_target_cpus(void)
+static void x2apic_target_cpus(cpumask_t retmask)
 {
-	return cpumask_of_cpu(0);
+	cpus_copy(retmask, cpumask_of_cpu(0));
 }
 
-static void x2apic_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void x2apic_vector_allocation_domain(int cpu, cpumask_t retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpus_clear(retmask);
+	cpu_set(cpu, retmask);
 }
 
 static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
@@ -53,7 +53,7 @@ static void __x2apic_send_IPI_dest(unsig
 	x2apic_icr_write(cfg, apicid);
 }
 
-static void x2apic_send_IPI_mask(const cpumask_t *mask, int vector)
+static void x2apic_send_IPI_mask(const_cpumask_t mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
@@ -82,7 +82,7 @@ static void x2apic_send_IPI_allbutself(i
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(&cpu_online_map, vector);
+	x2apic_send_IPI_mask(cpu_online_map, vector);
 }
 
 static int x2apic_apic_id_registered(void)
@@ -90,7 +90,7 @@ static int x2apic_apic_id_registered(voi
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const_cpumask_t cpumask)
 {
 	int cpu;
 
--- struct-cpumasks.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ struct-cpumasks/arch/x86/kernel/genx2apic_uv_x.c
@@ -76,15 +76,15 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 /* Start with all IRQs pointing to boot CPU.  IRQ balancing will shift them. */
 
-static cpumask_t uv_target_cpus(void)
+static void uv_target_cpus(cpumask_t retmask)
 {
-	return cpumask_of_cpu(0);
+	cpus_copy(retmask, cpumask_of_cpu(0));
 }
 
-static void uv_vector_allocation_domain(int cpu, cpumask_t *retmask)
+static void uv_vector_allocation_domain(int cpu, cpumask_t retmask)
 {
-	cpus_clear(*retmask);
-	cpu_set(cpu, *retmask);
+	cpus_clear(retmask);
+	cpu_set(cpu, retmask);
 }
 
 int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip)
@@ -123,11 +123,11 @@ static void uv_send_IPI_one(int cpu, int
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
 }
 
-static void uv_send_IPI_mask(const cpumask_t *mask, int vector)
+static void uv_send_IPI_mask(const_cpumask_t mask, int vector)
 {
 	unsigned int cpu;
 
-	for_each_cpu_mask_nr(cpu, *mask)
+	for_each_cpu(cpu, mask)
 		uv_send_IPI_one(cpu, vector);
 }
 
@@ -143,7 +143,7 @@ static void uv_send_IPI_allbutself(int v
 
 static void uv_send_IPI_all(int vector)
 {
-	uv_send_IPI_mask(&cpu_online_map, vector);
+	uv_send_IPI_mask(cpu_online_map, vector);
 }
 
 static int uv_apic_id_registered(void)
@@ -155,7 +155,7 @@ static void uv_init_apic_ldr(void)
 {
 }
 
-static unsigned int uv_cpu_mask_to_apicid(const cpumask_t cpumask)
+static unsigned int uv_cpu_mask_to_apicid(const_cpumask_t cpumask)
 {
 	int cpu;
 
--- struct-cpumasks.orig/arch/x86/kernel/io_apic.c
+++ struct-cpumasks/arch/x86/kernel/io_apic.c
@@ -113,8 +113,8 @@ struct irq_cfg {
 	struct irq_cfg *next;
 #endif
 	struct irq_pin_list *irq_2_pin;
-	cpumask_t domain;
-	cpumask_t old_domain;
+	cpumask_map_t domain;
+	cpumask_map_t old_domain;
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
@@ -529,14 +529,14 @@ static void __target_IO_APIC_irq(unsigne
 	}
 }
 
-static int assign_irq_vector(int irq, const cpumask_t *mask);
+static int assign_irq_vector(int irq, const_cpumask_t mask);
 
-static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ioapic_affinity_irq(unsigned int irq, const_cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
@@ -544,11 +544,11 @@ static void set_ioapic_affinity_irq(unsi
 		return;
 
 	cfg = irq_cfg(irq);
-	if (assign_irq_vector(irq, &mask))
+	if (assign_irq_vector(irq, mask))
 		return;
 
 	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
+	dest = cpu_mask_to_apicid(tmp);
 	/*
 	 * Only the high 8 bits are valid.
 	 */
@@ -557,7 +557,7 @@ static void set_ioapic_affinity_irq(unsi
 	desc = irq_to_desc(irq);
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__target_IO_APIC_irq(irq, dest, cfg->vector);
-	desc->affinity = mask;
+	cpus_copy(desc->affinity, mask);
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 #endif /* CONFIG_SMP */
@@ -1205,7 +1205,7 @@ void unlock_vector_lock(void)
 	spin_unlock(&vector_lock);
 }
 
-static int __assign_irq_vector(int irq, const cpumask_t *mask)
+static int __assign_irq_vector(int irq, const_cpumask_t mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -1222,7 +1222,7 @@ static int __assign_irq_vector(int irq, 
 	unsigned int old_vector;
 	int cpu;
 	struct irq_cfg *cfg;
-	cpumask_t tmpmask;
+	cpumask_var_t tmpmask;
 
 	cfg = irq_cfg(irq);
 
@@ -1231,7 +1231,7 @@ static int __assign_irq_vector(int irq, 
 
 	old_vector = cfg->vector;
 	if (old_vector) {
-		cpus_and(tmpmask, *mask, cpu_online_map);
+		cpus_and(tmpmask, mask, cpu_online_map);
 		cpus_and(tmpmask, tmpmask, cfg->domain);
 		if (!cpus_empty(tmpmask))
 			return 0;
@@ -1269,18 +1269,18 @@ next:
 		current_offset = offset;
 		if (old_vector) {
 			cfg->move_in_progress = 1;
-			cfg->old_domain = cfg->domain;
+			cpus_copy(cfg->old_domain, cfg->domain);
 		}
 		for_each_cpu_in(new_cpu, tmpmask, cpu_online_map)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
-		cfg->domain = tmpmask;
+		cpus_copy(cfg->domain, tmpmask);
 		return 0;
 	}
 	return -ENOSPC;
 }
 
-static int assign_irq_vector(int irq, const cpumask_t *mask)
+static int assign_irq_vector(int irq, const_cpumask_t mask)
 {
 	int err;
 	unsigned long flags;
@@ -1294,7 +1294,7 @@ static int assign_irq_vector(int irq, co
 static void __clear_irq_vector(int irq)
 {
 	struct irq_cfg *cfg;
-	cpumask_t mask;
+	cpumask_var_t mask;
 	int cpu, vector;
 
 	cfg = irq_cfg(irq);
@@ -1473,15 +1473,15 @@ static void setup_IO_APIC_irq(int apic, 
 {
 	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
 	cfg = irq_cfg(irq);
 
-	TARGET_CPUS(&mask);
-	if (assign_irq_vector(irq, &mask))
+	TARGET_CPUS(mask);
+	if (assign_irq_vector(irq, mask))
 		return;
 
 	cpus_and(mask, cfg->domain, mask);
@@ -1494,7 +1494,7 @@ static void setup_IO_APIC_irq(int apic, 
 
 
 	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
-			       cpu_mask_to_apicid(&mask), trigger, polarity,
+			       cpu_mask_to_apicid(mask), trigger, polarity,
 			       cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic].mp_apicid, pin);
@@ -1563,7 +1563,7 @@ static void __init setup_timer_IRQ0_pin(
 					int vector)
 {
 	struct IO_APIC_route_entry entry;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
 #ifdef CONFIG_INTR_REMAP
 	if (intr_remapping_enabled)
@@ -1571,7 +1571,7 @@ static void __init setup_timer_IRQ0_pin(
 #endif
 
 	memset(&entry, 0, sizeof(entry));
-	TARGET_CPUS(&mask);
+	TARGET_CPUS(mask);
 
 	/*
 	 * We use logical delivery to get the timer IRQ
@@ -1579,7 +1579,7 @@ static void __init setup_timer_IRQ0_pin(
 	 */
 	entry.dest_mode = INT_DEST_MODE;
 	entry.mask = 1;					/* mask IRQ now */
-	entry.dest = cpu_mask_to_apicid(&mask);
+	entry.dest = cpu_mask_to_apicid(mask);
 	entry.delivery_mode = INT_DELIVERY_MODE;
 	entry.polarity = 0;
 	entry.trigger = 0;
@@ -1919,7 +1919,8 @@ void __init enable_IO_APIC(void)
 			/* If the interrupt line is enabled and in ExtInt mode
 			 * I have found the pin where the i8259 is connected.
 			 */
-			if ((entry.mask == 0) && (entry.delivery_mode == dest_ExtINT)) {
+			if ((entry.mask == 0) &&
+				(entry.delivery_mode == dest_ExtINT)) {
 				ioapic_i8259.apic = apic;
 				ioapic_i8259.pin  = pin;
 				goto found_i8259;
@@ -2251,17 +2252,17 @@ static DECLARE_DELAYED_WORK(ir_migration
  * as simple as edge triggered migration and we can do the irq migration
  * with a simple atomic update to IO-APIC RTE.
  */
-static void migrate_ioapic_irq(int irq, const cpumask_t *mask)
+static void migrate_ioapic_irq(int irq, const_cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 	struct irte irte;
 	int modify_ioapic_rte;
 	unsigned int dest;
 	unsigned long flags;
 
-	cpus_and(tmp, *mask, cpu_online_map);
+	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
@@ -2272,8 +2273,8 @@ static void migrate_ioapic_irq(int irq, 
 		return;
 
 	cfg = irq_cfg(irq);
-	cpus_and(tmp, cfg->domain, *mask);
-	dest = cpu_mask_to_apicid(&tmp);
+	cpus_and(tmp, cfg->domain, mask);
+	dest = cpu_mask_to_apicid(tmp);
 
 	desc = irq_to_desc(irq);
 	modify_ioapic_rte = desc->status & IRQ_LEVEL;
@@ -2294,11 +2295,11 @@ static void migrate_ioapic_irq(int irq, 
 	if (cfg->move_in_progress) {
 		cpus_and(tmp, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(tmp);
-		send_IPI_mask(&tmp, IRQ_MOVE_CLEANUP_VECTOR);
+		send_IPI_mask(tmp, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 
-	desc->affinity = *mask;
+	cpus_copy(desc->affinity, mask);
 }
 
 static int migrate_irq_remapped_level(int irq)
@@ -2320,7 +2321,7 @@ static int migrate_irq_remapped_level(in
 	}
 
 	/* everthing is clear. we have right of way */
-	migrate_ioapic_irq(irq, &desc->pending_mask);
+	migrate_ioapic_irq(irq, desc->pending_mask);
 
 	ret = 0;
 	desc->status &= ~IRQ_MOVE_PENDING;
@@ -2357,18 +2358,18 @@ static void ir_irq_migration(struct work
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq(unsigned int irq, cpumask_t mask)
+static void set_ir_ioapic_affinity_irq(unsigned int irq, const_cpumask_t mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (desc->status & IRQ_LEVEL) {
 		desc->status |= IRQ_MOVE_PENDING;
-		desc->pending_mask = mask;
+		cpus_copy(desc->pending_mask, mask);
 		migrate_irq_remapped_level(irq);
 		return;
 	}
 
-	migrate_ioapic_irq(irq, &mask);
+	migrate_ioapic_irq(irq, mask);
 }
 #endif
 
@@ -2420,11 +2421,11 @@ static void irq_complete_move(unsigned i
 	vector = ~get_irq_regs()->orig_ax;
 	me = smp_processor_id();
 	if ((vector == cfg->vector) && cpu_isset(me, cfg->domain)) {
-		cpumask_t cleanup_mask;
+		cpumask_var_t cleanup_mask;
 
 		cpus_and(cleanup_mask, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(cleanup_mask);
-		send_IPI_mask(&cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
+		send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 }
@@ -2754,9 +2755,9 @@ static inline void __init check_timer(vo
 	unsigned long flags;
 	unsigned int ver;
 	int no_pin1 = 0;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
-	TARGET_CPUS(&mask);
+	TARGET_CPUS(mask);
 	local_irq_save(flags);
 
         ver = apic_read(APIC_LVR);
@@ -2766,7 +2767,7 @@ static inline void __init check_timer(vo
 	 * get/set the timer IRQ vector:
 	 */
 	disable_8259A_irq(0);
-	assign_irq_vector(0, &mask);
+	assign_irq_vector(0, mask);
 
 	/*
 	 * As IRQ0 is to be enabled in the 8259A, the virtual
@@ -3066,9 +3067,9 @@ unsigned int create_irq_nr(unsigned int 
 	unsigned int new;
 	unsigned long flags;
 	struct irq_cfg *cfg_new;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
-	TARGET_CPUS(&mask);
+	TARGET_CPUS(mask);
 #ifndef CONFIG_HAVE_SPARSE_IRQ
 	irq_want = nr_irqs - 1;
 #endif
@@ -3084,7 +3085,7 @@ unsigned int create_irq_nr(unsigned int 
 		/* check if need to create one */
 		if (!cfg_new)
 			cfg_new = irq_cfg_alloc(new);
-		if (__assign_irq_vector(new, &mask) == 0)
+		if (__assign_irq_vector(new, mask) == 0)
 			irq = new;
 		break;
 	}
@@ -3131,16 +3132,16 @@ static int msi_compose_msg(struct pci_de
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 
-	TARGET_CPUS(&tmp);
-	err = assign_irq_vector(irq, &tmp);
+	TARGET_CPUS(tmp);
+	err = assign_irq_vector(irq, tmp);
 	if (err)
 		return err;
 
 	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, tmp);
-	dest = cpu_mask_to_apicid(&tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
@@ -3194,24 +3195,24 @@ static int msi_compose_msg(struct pci_de
 }
 
 #ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+static void set_msi_irq_affinity(unsigned int irq, const_cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, &mask))
+	if (assign_irq_vector(irq, mask))
 		return;
 
 	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	read_msi_msg(irq, &msg);
 
@@ -3222,7 +3223,7 @@ static void set_msi_irq_affinity(unsigne
 
 	write_msi_msg(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpus_copy(desc->affinity, mask);
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -3230,11 +3231,11 @@ static void set_msi_irq_affinity(unsigne
  * Migrate the MSI irq to another cpumask. This migration is
  * done in the process context using interrupt-remapping hardware.
  */
-static void ir_set_msi_irq_affinity(unsigned int irq, cpumask_t mask)
+static void ir_set_msi_irq_affinity(unsigned int irq, const_cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 	struct irte irte;
 	struct irq_desc *desc;
 
@@ -3245,12 +3246,12 @@ static void ir_set_msi_irq_affinity(unsi
 	if (get_irte(irq, &irte))
 		return;
 
-	if (assign_irq_vector(irq, &mask))
+	if (assign_irq_vector(irq, mask))
 		return;
 
 	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
@@ -3268,12 +3269,12 @@ static void ir_set_msi_irq_affinity(unsi
 	if (cfg->move_in_progress) {
 		cpus_and(tmp, cfg->old_domain, cpu_online_map);
 		cfg->move_cleanup_count = cpus_weight(tmp);
-		send_IPI_mask(&tmp, IRQ_MOVE_CLEANUP_VECTOR);
+		send_IPI_mask(tmp, IRQ_MOVE_CLEANUP_VECTOR);
 		cfg->move_in_progress = 0;
 	}
 
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpus_copy(desc->affinity, mask);
 }
 #endif
 #endif /* CONFIG_SMP */
@@ -3473,24 +3474,24 @@ void arch_teardown_msi_irq(unsigned int 
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, cpumask_t mask)
+static void dmar_msi_set_affinity(unsigned int irq, const_cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, &mask))
+	if (assign_irq_vector(irq, mask))
 		return;
 
 	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	dmar_msi_read(irq, &msg);
 
@@ -3501,7 +3502,7 @@ static void dmar_msi_set_affinity(unsign
 
 	dmar_msi_write(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpus_copy(desc->affinity, mask);
 }
 #endif /* CONFIG_SMP */
 
@@ -3534,24 +3535,24 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static void hpet_msi_set_affinity(unsigned int irq, cpumask_t mask)
+static void hpet_msi_set_affinity(unsigned int irq, const_cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
 	struct msi_msg msg;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, &mask))
+	if (assign_irq_vector(irq, mask))
 		return;
 
 	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	hpet_msi_read(irq, &msg);
 
@@ -3562,7 +3563,7 @@ static void hpet_msi_set_affinity(unsign
 
 	hpet_msi_write(irq, &msg);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpus_copy(desc->affinity, mask);
 }
 #endif /* CONFIG_SMP */
 
@@ -3615,27 +3616,27 @@ static void target_ht_irq(unsigned int i
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, cpumask_t mask)
+static void set_ht_irq_affinity(unsigned int irq, const_cpumask_t mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int dest;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 	struct irq_desc *desc;
 
 	cpus_and(tmp, mask, cpu_online_map);
 	if (cpus_empty(tmp))
 		return;
 
-	if (assign_irq_vector(irq, &mask))
+	if (assign_irq_vector(irq, mask))
 		return;
 
 	cfg = irq_cfg(irq);
 	cpus_and(tmp, cfg->domain, mask);
-	dest = cpu_mask_to_apicid(&tmp);
+	dest = cpu_mask_to_apicid(tmp);
 
 	target_ht_irq(irq, dest, cfg->vector);
 	desc = irq_to_desc(irq);
-	desc->affinity = mask;
+	cpus_copy(desc->affinity, mask);
 }
 #endif
 
@@ -3654,17 +3655,17 @@ int arch_setup_ht_irq(unsigned int irq, 
 {
 	struct irq_cfg *cfg;
 	int err;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 
-	TARGET_CPUS(&tmp);
-	err = assign_irq_vector(irq, &tmp);
+	TARGET_CPUS(tmp);
+	err = assign_irq_vector(irq, tmp);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
 		cfg = irq_cfg(irq);
 		cpus_and(tmp, cfg->domain, tmp);
-		dest = cpu_mask_to_apicid(&tmp);
+		dest = cpu_mask_to_apicid(tmp);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3870,12 +3871,12 @@ void __init setup_ioapic_dest(void)
 {
 	int pin, ioapic, irq, irq_entry;
 	struct irq_cfg *cfg;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
 	if (skip_ioapic_setup == 1)
 		return;
 
-	TARGET_CPUS(&mask);
+	TARGET_CPUS(mask);
 	for (ioapic = 0; ioapic < nr_ioapics; ioapic++) {
 		for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
 			irq_entry = find_irq_entry(ioapic, pin, mp_INT);
--- struct-cpumasks.orig/arch/x86/kernel/ipi.c
+++ struct-cpumasks/arch/x86/kernel/ipi.c
@@ -116,7 +116,7 @@ static inline void __send_IPI_dest_field
 /*
  * This is only used on smaller machines.
  */
-void send_IPI_mask_bitmask(const cpumask_t *cpumask, int vector)
+void send_IPI_mask_bitmask(const_cpumask_t *cpumask, int vector)
 {
 	unsigned long mask = cpus_addr(*cpumask)[0];
 	unsigned long flags;
@@ -127,7 +127,7 @@ void send_IPI_mask_bitmask(const cpumask
 	local_irq_restore(flags);
 }
 
-void send_IPI_mask_sequence(const cpumask_t *mask, int vector)
+void send_IPI_mask_sequence(const_cpumask_t *mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
@@ -144,7 +144,7 @@ void send_IPI_mask_sequence(const cpumas
 	local_irq_restore(flags);
 }
 
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector)
+void send_IPI_mask_allbutself(const_cpumask_t *mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
--- struct-cpumasks.orig/include/asm-x86/bigsmp/apic.h
+++ struct-cpumasks/include/asm-x86/bigsmp/apic.h
@@ -121,7 +121,7 @@ static inline int check_phys_apicid_pres
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const_cpumask_t cpumask)
 {
 	int cpu;
 	int apicid;	
--- struct-cpumasks.orig/include/asm-x86/es7000/apic.h
+++ struct-cpumasks/include/asm-x86/es7000/apic.h
@@ -144,7 +144,7 @@ static inline int check_phys_apicid_pres
 	return (1);
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const_cpumask_t cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
--- struct-cpumasks.orig/include/asm-x86/genapic_32.h
+++ struct-cpumasks/include/asm-x86/genapic_32.h
@@ -56,12 +56,12 @@ struct genapic {
 
 	unsigned (*get_apic_id)(unsigned long x);
 	unsigned long apic_id_mask;
-	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
+	unsigned int (*cpu_mask_to_apicid)(const_cpumask_t *cpumask);
 	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
 
 #ifdef CONFIG_SMP
 	/* ipi */
-	void (*send_IPI_mask)(const cpumask_t *mask, int vector);
+	void (*send_IPI_mask)(const_cpumask_t *mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 #endif
--- struct-cpumasks.orig/include/asm-x86/genapic_64.h
+++ struct-cpumasks/include/asm-x86/genapic_64.h
@@ -18,16 +18,16 @@ struct genapic {
 	u32 int_delivery_mode;
 	u32 int_dest_mode;
 	int (*apic_id_registered)(void);
-	void (*target_cpus)(cpumask_t *retmask);
-	void (*vector_allocation_domain)(int cpu, cpumask_t *retmask);
+	void (*target_cpus)(cpumask_t retmask);
+	void (*vector_allocation_domain)(int cpu, cpumask_t retmask);
 	void (*init_apic_ldr)(void);
 	/* ipi */
-	void (*send_IPI_mask)(const cpumask_t *mask, int vector);
+	void (*send_IPI_mask)(const_cpumask_t mask, int vector);
 	void (*send_IPI_allbutself)(int vector);
 	void (*send_IPI_all)(int vector);
 	void (*send_IPI_self)(int vector);
 	/* */
-	unsigned int (*cpu_mask_to_apicid)(const cpumask_t *cpumask);
+	unsigned int (*cpu_mask_to_apicid)(const_cpumask_t cpumask);
 	unsigned int (*phys_pkg_id)(int index_msb);
 	unsigned int (*get_apic_id)(unsigned long x);
 	unsigned long (*set_apic_id)(unsigned int id);
--- struct-cpumasks.orig/include/asm-x86/ipi.h
+++ struct-cpumasks/include/asm-x86/ipi.h
@@ -117,7 +117,7 @@ static inline void __send_IPI_dest_field
 	native_apic_mem_write(APIC_ICR, cfg);
 }
 
-static inline void send_IPI_mask_sequence(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask_sequence(const_cpumask_t mask, int vector)
 {
 	unsigned long flags;
 	unsigned long query_cpu;
@@ -135,7 +135,7 @@ static inline void send_IPI_mask_sequenc
 	local_irq_restore(flags);
 }
 
-static inline void send_IPI_mask_allbutself(cpumask_t *mask, int vector)
+static inline void send_IPI_mask_allbutself(const_cpumask_t mask, int vector)
 {
 	unsigned long flags;
 	unsigned int query_cpu;
--- struct-cpumasks.orig/include/asm-x86/mach-default/mach_apic.h
+++ struct-cpumasks/include/asm-x86/mach-default/mach_apic.h
@@ -60,7 +60,7 @@ static inline int apic_id_registered(voi
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int cpu_mask_to_apicid(const_cpumask_t *cpumask)
 {
 	return cpus_addr(*cpumask)[0];
 }
--- struct-cpumasks.orig/include/asm-x86/mach-default/mach_ipi.h
+++ struct-cpumasks/include/asm-x86/mach-default/mach_ipi.h
@@ -4,8 +4,8 @@
 /* Avoid include hell */
 #define NMI_VECTOR 0x02
 
-void send_IPI_mask_bitmask(const cpumask_t *mask, int vector);
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+void send_IPI_mask_bitmask(const_cpumask_t mask, int vector);
+void send_IPI_mask_allbutself(const_cpumask_t mask, int vector);
 void __send_IPI_shortcut(unsigned int shortcut, int vector);
 
 extern int no_broadcast;
@@ -14,7 +14,7 @@ extern int no_broadcast;
 #include <asm/genapic.h>
 #define send_IPI_mask (genapic->send_IPI_mask)
 #else
-static inline void send_IPI_mask(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask(const_cpumask_t mask, int vector)
 {
 	send_IPI_mask_bitmask(mask, vector);
 }
@@ -23,7 +23,7 @@ static inline void send_IPI_mask(const c
 static inline void __local_send_IPI_allbutself(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask_allbutself(&cpu_online_map, vector);
+		send_IPI_mask_allbutself(cpu_online_map, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
 }
@@ -31,7 +31,7 @@ static inline void __local_send_IPI_allb
 static inline void __local_send_IPI_all(int vector)
 {
 	if (no_broadcast || vector == NMI_VECTOR)
-		send_IPI_mask(&cpu_online_map, vector);
+		send_IPI_mask(cpu_online_map, vector);
 	else
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector);
 }
--- struct-cpumasks.orig/include/asm-x86/numaq/apic.h
+++ struct-cpumasks/include/asm-x86/numaq/apic.h
@@ -122,7 +122,7 @@ static inline void enable_apic_mode(void
  * We use physical apicids here, not logical, so just return the default
  * physical broadcast to stop people from breaking us
  */
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int cpu_mask_to_apicid(const_cpumask_t *cpumask)
 {
 	return (int) 0xF;
 }
--- struct-cpumasks.orig/include/asm-x86/numaq/ipi.h
+++ struct-cpumasks/include/asm-x86/numaq/ipi.h
@@ -1,10 +1,10 @@
 #ifndef __ASM_NUMAQ_IPI_H
 #define __ASM_NUMAQ_IPI_H
 
-void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+void send_IPI_mask_sequence(const_cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const_cpumask_t *mask, int vector);
 
-static inline void send_IPI_mask(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask(const_cpumask_t *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }
--- struct-cpumasks.orig/include/asm-x86/summit/apic.h
+++ struct-cpumasks/include/asm-x86/summit/apic.h
@@ -137,7 +137,7 @@ static inline void enable_apic_mode(void
 {
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t cpumask)
+static inline unsigned int cpu_mask_to_apicid(const_cpumask_t cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
--- struct-cpumasks.orig/include/asm-x86/summit/ipi.h
+++ struct-cpumasks/include/asm-x86/summit/ipi.h
@@ -1,10 +1,10 @@
 #ifndef __ASM_SUMMIT_IPI_H
 #define __ASM_SUMMIT_IPI_H
 
-void send_IPI_mask_sequence(const cpumask_t *mask, int vector);
-void send_IPI_mask_allbutself(const cpumask_t *mask, int vector);
+void send_IPI_mask_sequence(const_cpumask_t *mask, int vector);
+void send_IPI_mask_allbutself(const_cpumask_t *mask, int vector);
 
-static inline void send_IPI_mask(const cpumask_t *mask, int vector)
+static inline void send_IPI_mask(const_cpumask_t *mask, int vector)
 {
 	send_IPI_mask_sequence(mask, vector);
 }

-- 
