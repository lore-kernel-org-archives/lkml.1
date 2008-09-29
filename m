Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbYI2SIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbYI2SIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYI2SDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:16 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54322 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753964AbYI2SCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:52 -0400
Message-Id: <20080929180252.051945000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:04 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 14/31] cpumask: change first/next_cpu to cpus_first/next
Content-Disposition: inline; filename=first-next_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/acpi/boot.c                |    2 -
 arch/x86/kernel/apic.c                     |    2 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 +--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c  |    6 ++---
 arch/x86/kernel/cpu/intel_cacheinfo.c      |    4 +--
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c    |    2 -
 arch/x86/kernel/cpu/proc.c                 |    4 +--
 arch/x86/kernel/genapic_flat_64.c          |    4 +--
 arch/x86/kernel/genx2apic_cluster.c        |    6 ++---
 arch/x86/kernel/genx2apic_phys.c           |    6 ++---
 arch/x86/kernel/genx2apic_uv_x.c           |    4 +--
 arch/x86/kernel/io_apic.c                  |    2 -
 arch/x86/kernel/smpboot.c                  |    2 -
 arch/x86/mm/mmio-mod.c                     |    2 -
 arch/x86/oprofile/op_model_p4.c            |    2 -
 drivers/infiniband/hw/ehca/ehca_irq.c      |    4 +--
 drivers/parisc/iosapic.c                   |    2 -
 drivers/xen/events.c                       |    2 -
 include/asm-x86/bigsmp/apic.h              |    4 +--
 include/asm-x86/es7000/apic.h              |    6 ++---
 include/asm-x86/summit/apic.h              |    8 +++----
 include/asm-x86/topology.h                 |    4 +--
 kernel/cpu.c                               |    6 ++---
 kernel/power/poweroff.c                    |    2 -
 kernel/sched.c                             |   32 ++++++++++++++---------------
 kernel/sched_rt.c                          |    2 -
 kernel/smp.c                               |    2 -
 kernel/stop_machine.c                      |    2 -
 kernel/time/clocksource.c                  |   11 +++++----
 kernel/time/tick-broadcast.c               |    2 -
 kernel/time/tick-common.c                  |    2 -
 kernel/workqueue.c                         |    2 -
 net/core/dev.c                             |    4 +--
 net/iucv/iucv.c                            |    4 +--
 34 files changed, 77 insertions(+), 76 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/acpi/boot.c
+++ struct-cpumasks/arch/x86/kernel/acpi/boot.c
@@ -564,7 +564,7 @@ static int __cpuinit _acpi_map_lsapic(ac
 		return -EINVAL;
 	}
 
-	cpu = first_cpu(new_map);
+	cpu = cpus_first(new_map);
 
 	*pcpu = cpu;
 	return 0;
--- struct-cpumasks.orig/arch/x86/kernel/apic.c
+++ struct-cpumasks/arch/x86/kernel/apic.c
@@ -1857,7 +1857,7 @@ void __cpuinit generic_processor_info(in
 
 	num_processors++;
 	cpus_complement(tmp_map, cpu_present_map);
-	cpu = first_cpu(tmp_map);
+	cpu = cpus_first(tmp_map);
 
 	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -219,14 +219,14 @@ static u32 get_cur_val(const cpumask_t *
 	if (unlikely(cpus_empty(*mask)))
 		return 0;
 
-	switch (per_cpu(drv_data, first_cpu(*mask))->cpu_feature) {
+	switch (per_cpu(drv_data, cpus_first(*mask))->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
 		cmd.type = SYSTEM_INTEL_MSR_CAPABLE;
 		cmd.addr.msr.reg = MSR_IA32_PERF_STATUS;
 		break;
 	case SYSTEM_IO_CAPABLE:
 		cmd.type = SYSTEM_IO_CAPABLE;
-		perf = per_cpu(drv_data, first_cpu(*mask))->acpi_data;
+		perf = per_cpu(drv_data, cpus_first(*mask))->acpi_data;
 		cmd.addr.io.port = perf->control_register.address;
 		cmd.addr.io.bit_width = perf->control_register.bit_width;
 		break;
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -639,7 +639,7 @@ static int fill_powernow_table(struct po
 
 	dprintk("cfid 0x%x, cvid 0x%x\n", data->currfid, data->currvid);
 	data->powernow_table = powernow_table;
-	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
+	if (cpus_first(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 
 	for (j = 0; j < data->numps; j++)
@@ -793,7 +793,7 @@ static int powernow_k8_cpu_init_acpi(str
 
 	/* fill in data */
 	data->numps = data->acpi_data.state_count;
-	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
+	if (cpus_first(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 	powernow_k8_acpi_pst_values(data, 0);
 
@@ -1244,7 +1244,7 @@ static unsigned int powernowk8_get (unsi
 	unsigned int khz = 0;
 	unsigned int first;
 
-	first = first_cpu(per_cpu(cpu_core_map, cpu));
+	first = cpus_first(per_cpu(cpu_core_map, cpu));
 	data = per_cpu(powernow_data, first);
 
 	if (!data)
--- struct-cpumasks.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ struct-cpumasks/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -690,7 +690,7 @@ static struct pci_dev *get_k8_northbridg
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf)
 {
-	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	int node = cpu_to_node(cpus_first(this_leaf->shared_cpu_map));
 	struct pci_dev *dev = NULL;
 	ssize_t ret = 0;
 	int i;
@@ -724,7 +724,7 @@ static ssize_t
 store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 		    size_t count)
 {
-	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
+	int node = cpu_to_node(cpus_first(this_leaf->shared_cpu_map));
 	struct pci_dev *dev = NULL;
 	unsigned int ret, index, val;
 
--- struct-cpumasks.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ struct-cpumasks/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -475,7 +475,7 @@ static __cpuinit int threshold_create_ba
 
 #ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = first_cpu(per_cpu(cpu_core_map, cpu));
+		i = cpus_first(per_cpu(cpu_core_map, cpu));
 
 		/* first core not up yet */
 		if (cpu_data(i).cpu_core_id)
--- struct-cpumasks.orig/arch/x86/kernel/cpu/proc.c
+++ struct-cpumasks/arch/x86/kernel/cpu/proc.c
@@ -159,7 +159,7 @@ static int show_cpuinfo(struct seq_file 
 static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
-		*pos = first_cpu(cpu_online_map);
+		*pos = cpus_first(cpu_online_map);
 	if ((*pos) < nr_cpu_ids && cpu_online(*pos))
 		return &cpu_data(*pos);
 	return NULL;
@@ -167,7 +167,7 @@ static void *c_start(struct seq_file *m,
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	*pos = next_cpu(*pos, cpu_online_map);
+	*pos = cpus_next(*pos, cpu_online_map);
 	return c_start(m, pos);
 }
 
--- struct-cpumasks.orig/arch/x86/kernel/genapic_flat_64.c
+++ struct-cpumasks/arch/x86/kernel/genapic_flat_64.c
@@ -222,7 +222,7 @@ static void physflat_send_IPI_all(int ve
 	physflat_send_IPI_mask(&cpu_online_map, vector);
 }
 
-static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int physflat_cpu_mask_to_apicid(const cpumask_t cpumask)
 {
 	int cpu;
 
@@ -230,7 +230,7 @@ static unsigned int physflat_cpu_mask_to
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(*cpumask);
+	cpu = cpus_first(cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
--- struct-cpumasks.orig/arch/x86/kernel/genx2apic_cluster.c
+++ struct-cpumasks/arch/x86/kernel/genx2apic_cluster.c
@@ -93,7 +93,7 @@ static int x2apic_apic_id_registered(voi
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t cpumask)
 {
 	int cpu;
 
@@ -101,8 +101,8 @@ static unsigned int x2apic_cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(*cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	cpu = cpus_first(cpumask);
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_logical_apicid, cpu);
 	else
 		return BAD_APICID;
--- struct-cpumasks.orig/arch/x86/kernel/genx2apic_phys.c
+++ struct-cpumasks/arch/x86/kernel/genx2apic_phys.c
@@ -90,7 +90,7 @@ static int x2apic_apic_id_registered(voi
 	return 1;
 }
 
-static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int x2apic_cpu_mask_to_apicid(const cpumask_t cpumask)
 {
 	int cpu;
 
@@ -98,8 +98,8 @@ static unsigned int x2apic_cpu_mask_to_a
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(*cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	cpu = cpus_first(cpumask);
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
--- struct-cpumasks.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ struct-cpumasks/arch/x86/kernel/genx2apic_uv_x.c
@@ -155,7 +155,7 @@ static void uv_init_apic_ldr(void)
 {
 }
 
-static unsigned int uv_cpu_mask_to_apicid(const cpumask_t *cpumask)
+static unsigned int uv_cpu_mask_to_apicid(const cpumask_t cpumask)
 {
 	int cpu;
 
@@ -163,7 +163,7 @@ static unsigned int uv_cpu_mask_to_apici
 	 * We're using fixed IRQ delivery, can only return one phys APIC ID.
 	 * May as well be the first.
 	 */
-	cpu = first_cpu(*cpumask);
+	cpu = cpus_first(cpumask);
 	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
--- struct-cpumasks.orig/arch/x86/kernel/io_apic.c
+++ struct-cpumasks/arch/x86/kernel/io_apic.c
@@ -2202,7 +2202,7 @@ static int ioapic_retrigger_irq(unsigned
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	send_IPI_mask(&cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
+	send_IPI_mask(cpumask_of_cpu(cpus_first(cfg->domain)), cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
--- struct-cpumasks.orig/arch/x86/kernel/smpboot.c
+++ struct-cpumasks/arch/x86/kernel/smpboot.c
@@ -488,7 +488,7 @@ void __cpuinit set_cpu_sibling_map(int c
 				 * for each core in package, increment
 				 * the booted_cores for this new cpu
 				 */
-				if (first_cpu(per_cpu(cpu_sibling_map, i)) == i)
+				if (cpus_first(per_cpu(cpu_sibling_map, i)) == i)
 					c->booted_cores++;
 				/*
 				 * increment the core count for all
--- struct-cpumasks.orig/arch/x86/mm/mmio-mod.c
+++ struct-cpumasks/arch/x86/mm/mmio-mod.c
@@ -387,7 +387,7 @@ static void enter_uniprocessor(void)
 
 	get_online_cpus();
 	downed_cpus = cpu_online_map;
-	cpu_clear(first_cpu(cpu_online_map), downed_cpus);
+	cpu_clear(cpus_first(cpu_online_map), downed_cpus);
 	if (num_online_cpus() > 1)
 		pr_notice(NAME "Disabling non-boot CPUs...\n");
 	put_online_cpus();
--- struct-cpumasks.orig/arch/x86/oprofile/op_model_p4.c
+++ struct-cpumasks/arch/x86/oprofile/op_model_p4.c
@@ -380,7 +380,7 @@ static unsigned int get_stagger(void)
 {
 #ifdef CONFIG_SMP
 	int cpu = smp_processor_id();
-	return (cpu != first_cpu(per_cpu(cpu_sibling_map, cpu)));
+	return (cpu != cpus_first(per_cpu(cpu_sibling_map, cpu)));
 #endif
 	return 0;
 }
--- struct-cpumasks.orig/drivers/infiniband/hw/ehca/ehca_irq.c
+++ struct-cpumasks/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -650,9 +650,9 @@ static inline int find_next_online_cpu(s
 		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = next_cpu(pool->last_cpu, cpu_online_map);
+	cpu = cpus_next(pool->last_cpu, cpu_online_map);
 	if (cpu >= nr_cpu_ids)
-		cpu = first_cpu(cpu_online_map);
+		cpu = cpus_first(cpu_online_map);
 	pool->last_cpu = cpu;
 	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
 
--- struct-cpumasks.orig/drivers/parisc/iosapic.c
+++ struct-cpumasks/drivers/parisc/iosapic.c
@@ -713,7 +713,7 @@ static void iosapic_set_affinity_irq(uns
 	if (cpu_check_affinity(irq, &dest))
 		return;
 
-	vi->txn_addr = txn_affinity_addr(irq, first_cpu(dest));
+	vi->txn_addr = txn_affinity_addr(irq, cpus_first(dest));
 
 	spin_lock_irqsave(&iosapic_lock, flags);
 	/* d1 contains the destination CPU, so only want to set that
--- struct-cpumasks.orig/drivers/xen/events.c
+++ struct-cpumasks/drivers/xen/events.c
@@ -612,7 +612,7 @@ static void rebind_irq_to_cpu(unsigned i
 
 static void set_affinity_irq(unsigned irq, cpumask_t dest)
 {
-	unsigned tcpu = first_cpu(dest);
+	unsigned tcpu = cpus_first(dest);
 	rebind_irq_to_cpu(irq, tcpu);
 }
 
--- struct-cpumasks.orig/include/asm-x86/bigsmp/apic.h
+++ struct-cpumasks/include/asm-x86/bigsmp/apic.h
@@ -121,12 +121,12 @@ static inline int check_phys_apicid_pres
 }
 
 /* As we are using single CPU as destination, pick only one CPU here */
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t cpumask)
 {
 	int cpu;
 	int apicid;	
 
-	cpu = first_cpu(*cpumask);
+	cpu = cpus_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	return apicid;
 }
--- struct-cpumasks.orig/include/asm-x86/es7000/apic.h
+++ struct-cpumasks/include/asm-x86/es7000/apic.h
@@ -144,7 +144,7 @@ static inline int check_phys_apicid_pres
 	return (1);
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
@@ -163,10 +163,10 @@ static inline unsigned int cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(*cpumask);
+	cpu = cpus_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, *cpumask)) {
+		if (cpu_isset(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
--- struct-cpumasks.orig/include/asm-x86/summit/apic.h
+++ struct-cpumasks/include/asm-x86/summit/apic.h
@@ -137,14 +137,14 @@ static inline void enable_apic_mode(void
 {
 }
 
-static inline unsigned int cpu_mask_to_apicid(const cpumask_t *cpumask)
+static inline unsigned int cpu_mask_to_apicid(const cpumask_t cpumask)
 {
 	int num_bits_set;
 	int cpus_found = 0;
 	int cpu;
 	int apicid;
 
-	num_bits_set = cpus_weight(*cpumask);
+	num_bits_set = cpus_weight(cpumask);
 	/* Return id to all */
 	if (num_bits_set == NR_CPUS)
 		return (int) 0xFF;
@@ -152,10 +152,10 @@ static inline unsigned int cpu_mask_to_a
 	 * The cpus in the mask must all be on the apic cluster.  If are not
 	 * on the same apicid cluster return default value of TARGET_CPUS.
 	 */
-	cpu = first_cpu(*cpumask);
+	cpu = cpus_first(cpumask);
 	apicid = cpu_to_logical_apicid(cpu);
 	while (cpus_found < num_bits_set) {
-		if (cpu_isset(cpu, *cpumask)) {
+		if (cpu_isset(cpu, cpumask)) {
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)){
--- struct-cpumasks.orig/include/asm-x86/topology.h
+++ struct-cpumasks/include/asm-x86/topology.h
@@ -196,7 +196,7 @@ static inline cpumask_t node_to_cpumask(
 }
 static inline int node_to_first_cpu(int node)
 {
-	return first_cpu(cpu_online_map);
+	return cpus_first(cpu_online_map);
 }
 
 /* Replace default node_to_cpumask_ptr with optimized version */
@@ -214,7 +214,7 @@ static inline int node_to_first_cpu(int 
 static inline int node_to_first_cpu(int node)
 {
 	node_to_cpumask_ptr(mask, node);
-	return first_cpu(*mask);
+	return cpus_first(*mask);
 }
 #endif
 
--- struct-cpumasks.orig/kernel/cpu.c
+++ struct-cpumasks/kernel/cpu.c
@@ -401,17 +401,17 @@ static cpumask_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error = 0;
+	int cpu, cpus_first, error = 0;
 
 	cpu_maps_update_begin();
-	first_cpu = first_cpu(cpu_online_map);
+	cpus_first = cpus_first(cpu_online_map);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpus_clear(frozen_cpus);
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
-		if (cpu == first_cpu)
+		if (cpu == cpus_first)
 			continue;
 		error = _cpu_down(cpu, 1);
 		if (!error) {
--- struct-cpumasks.orig/kernel/power/poweroff.c
+++ struct-cpumasks/kernel/power/poweroff.c
@@ -27,7 +27,7 @@ static DECLARE_WORK(poweroff_work, do_po
 static void handle_poweroff(int key, struct tty_struct *tty)
 {
 	/* run sysrq poweroff on boot cpu */
-	schedule_work_on(first_cpu(cpu_online_map), &poweroff_work);
+	schedule_work_on(cpus_first(cpu_online_map), &poweroff_work);
 }
 
 static struct sysrq_key_op	sysrq_poweroff_op = {
--- struct-cpumasks.orig/kernel/sched.c
+++ struct-cpumasks/kernel/sched.c
@@ -3120,7 +3120,7 @@ find_busiest_group(struct sched_domain *
 		local_group = cpu_isset(this_cpu, group->cpumask);
 
 		if (local_group)
-			balance_cpu = first_cpu(group->cpumask);
+			balance_cpu = cpus_first(group->cpumask);
 
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
@@ -3246,8 +3246,8 @@ find_busiest_group(struct sched_domain *
 		 */
 		if ((sum_nr_running < min_nr_running) ||
 		    (sum_nr_running == min_nr_running &&
-		     first_cpu(group->cpumask) <
-		     first_cpu(group_min->cpumask))) {
+		     cpus_first(group->cpumask) <
+		     cpus_first(group_min->cpumask))) {
 			group_min = group;
 			min_nr_running = sum_nr_running;
 			min_load_per_task = sum_weighted_load /
@@ -3262,8 +3262,8 @@ find_busiest_group(struct sched_domain *
 		if (sum_nr_running <= group_capacity - 1) {
 			if (sum_nr_running > leader_nr_running ||
 			    (sum_nr_running == leader_nr_running &&
-			     first_cpu(group->cpumask) >
-			      first_cpu(group_leader->cpumask))) {
+			     cpus_first(group->cpumask) >
+			      cpus_first(group_leader->cpumask))) {
 				group_leader = group;
 				leader_nr_running = sum_nr_running;
 			}
@@ -4001,7 +4001,7 @@ static inline void trigger_load_balance(
 			 * TBD: Traverse the sched domains and nominate
 			 * the nearest cpu in the nohz.cpu_mask.
 			 */
-			int ilb = first_cpu(nohz.cpu_mask);
+			int ilb = cpus_first(nohz.cpu_mask);
 
 			if (ilb < nr_cpu_ids)
 				resched_cpu(ilb);
@@ -7098,7 +7098,7 @@ cpu_to_core_group(int cpu, const cpumask
 
 	*mask = per_cpu(cpu_sibling_map, cpu);
 	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	group = cpus_first(*mask);
 	if (sg)
 		*sg = &per_cpu(sched_group_core, group);
 	return group;
@@ -7125,11 +7125,11 @@ cpu_to_phys_group(int cpu, const cpumask
 #ifdef CONFIG_SCHED_MC
 	*mask = cpu_coregroup_map(cpu);
 	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	group = cpus_first(*mask);
 #elif defined(CONFIG_SCHED_SMT)
 	*mask = per_cpu(cpu_sibling_map, cpu);
 	cpus_and(*mask, *mask, *cpu_map);
-	group = first_cpu(*mask);
+	group = cpus_first(*mask);
 #else
 	group = cpu;
 #endif
@@ -7157,7 +7157,7 @@ static int cpu_to_allnodes_group(int cpu
 
 	*nodemask = node_to_cpumask(cpu_to_node(cpu));
 	cpus_and(*nodemask, *nodemask, *cpu_map);
-	group = first_cpu(*nodemask);
+	group = cpus_first(*nodemask);
 
 	if (sg)
 		*sg = &per_cpu(sched_group_allnodes, group);
@@ -7176,7 +7176,7 @@ static void init_numa_sched_groups_power
 			struct sched_domain *sd;
 
 			sd = &per_cpu(phys_domains, j);
-			if (j != first_cpu(sd->groups->cpumask)) {
+			if (j != cpus_first(sd->groups->cpumask)) {
 				/*
 				 * Only add "power" once for each
 				 * physical package.
@@ -7253,7 +7253,7 @@ static void init_sched_groups_power(int 
 
 	WARN_ON(!sd || !sd->groups);
 
-	if (cpu != first_cpu(sd->groups->cpumask))
+	if (cpu != cpus_first(sd->groups->cpumask))
 		return;
 
 	child = sd->child;
@@ -7430,7 +7430,7 @@ static int __build_sched_domains(const c
 
 
 #ifdef CONFIG_NUMA
-	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
+	sched_group_nodes_bycpu[cpus_first(*cpu_map)] = sched_group_nodes;
 #endif
 
 	/*
@@ -7509,7 +7509,7 @@ static int __build_sched_domains(const c
 
 		*this_sibling_map = per_cpu(cpu_sibling_map, i);
 		cpus_and(*this_sibling_map, *this_sibling_map, *cpu_map);
-		if (i != first_cpu(*this_sibling_map))
+		if (i != cpus_first(*this_sibling_map))
 			continue;
 
 		init_sched_build_groups(this_sibling_map, cpu_map,
@@ -7526,7 +7526,7 @@ static int __build_sched_domains(const c
 
 		*this_core_map = cpu_coregroup_map(i);
 		cpus_and(*this_core_map, *this_core_map, *cpu_map);
-		if (i != first_cpu(*this_core_map))
+		if (i != cpus_first(*this_core_map))
 			continue;
 
 		init_sched_build_groups(this_core_map, cpu_map,
@@ -7660,7 +7660,7 @@ static int __build_sched_domains(const c
 	if (sd_allnodes) {
 		struct sched_group *sg;
 
-		cpu_to_allnodes_group(first_cpu(*cpu_map), cpu_map, &sg,
+		cpu_to_allnodes_group(cpus_first(*cpu_map), cpu_map, &sg,
 								tmpmask);
 		init_numa_sched_groups_power(sg);
 	}
--- struct-cpumasks.orig/kernel/sched_rt.c
+++ struct-cpumasks/kernel/sched_rt.c
@@ -966,7 +966,7 @@ static inline int pick_optimal_cpu(int t
 	if ((this_cpu != -1) && cpu_isset(this_cpu, *mask))
 		return this_cpu;
 
-	first = first_cpu(*mask);
+	first = cpus_first(*mask);
 	if (first != NR_CPUS)
 		return first;
 
--- struct-cpumasks.orig/kernel/smp.c
+++ struct-cpumasks/kernel/smp.c
@@ -342,7 +342,7 @@ int smp_call_function_mask(cpumask_t mas
 	if (!num_cpus)
 		return 0;
 	else if (num_cpus == 1) {
-		cpu = first_cpu(mask);
+		cpu = cpus_first(mask);
 		return smp_call_function_single(cpu, func, info, wait);
 	}
 
--- struct-cpumasks.orig/kernel/stop_machine.c
+++ struct-cpumasks/kernel/stop_machine.c
@@ -127,7 +127,7 @@ int __stop_machine(int (*fn)(void *), vo
 		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 		if (!cpus) {
-			if (i == first_cpu(cpu_online_map))
+			if (i == cpus_first(cpu_online_map))
 				smdata = &active;
 		} else {
 			if (cpu_isset(i, *cpus))
--- struct-cpumasks.orig/kernel/time/clocksource.c
+++ struct-cpumasks/kernel/time/clocksource.c
@@ -151,12 +151,13 @@ static void clocksource_watchdog(unsigne
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = cpus_next(raw_smp_processor_id(),
+					 cpu_online_map);
 
 		if (next_cpu >= nr_cpu_ids)
-			next_cpu = first_cpu(cpu_online_map);
+			next_cpu = cpus_first(cpu_online_map);
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
-		add_timer_on(&watchdog_timer, next_cpu);
+		add_timer_on(&watchdog_timer, cpus_next);
 	}
 	spin_unlock(&watchdog_lock);
 }
@@ -179,7 +180,7 @@ static void clocksource_check_watchdog(s
 			watchdog_last = watchdog->read();
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 			add_timer_on(&watchdog_timer,
-				     first_cpu(cpu_online_map));
+				     cpus_first(cpu_online_map));
 		}
 	} else {
 		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
@@ -201,7 +202,7 @@ static void clocksource_check_watchdog(s
 				watchdog_timer.expires =
 					jiffies + WATCHDOG_INTERVAL;
 				add_timer_on(&watchdog_timer,
-					     first_cpu(cpu_online_map));
+					     cpus_first(cpu_online_map));
 			}
 		}
 	}
--- struct-cpumasks.orig/kernel/time/tick-broadcast.c
+++ struct-cpumasks/kernel/time/tick-broadcast.c
@@ -148,7 +148,7 @@ static void tick_do_broadcast(cpumask_t 
 		 * one of the first device. This works as long as we have this
 		 * misfeature only on x86 (lapic)
 		 */
-		cpu = first_cpu(mask);
+		cpu = cpus_first(mask);
 		td = &per_cpu(tick_cpu_device, cpu);
 		td->evtdev->broadcast(mask);
 	}
--- struct-cpumasks.orig/kernel/time/tick-common.c
+++ struct-cpumasks/kernel/time/tick-common.c
@@ -299,7 +299,7 @@ static void tick_shutdown(unsigned int *
 	}
 	/* Transfer the do_timer job away from this cpu */
 	if (*cpup == tick_do_timer_cpu) {
-		int cpu = first_cpu(cpu_online_map);
+		int cpu = cpus_first(cpu_online_map);
 
 		tick_do_timer_cpu = (cpu != NR_CPUS) ? cpu :
 			TICK_DO_TIMER_NONE;
--- struct-cpumasks.orig/kernel/workqueue.c
+++ struct-cpumasks/kernel/workqueue.c
@@ -968,7 +968,7 @@ undo:
 void __init init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
-	singlethread_cpu = first_cpu(cpu_possible_map);
+	singlethread_cpu = cpus_first(cpu_possible_map);
 	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
--- struct-cpumasks.orig/net/core/dev.c
+++ struct-cpumasks/net/core/dev.c
@@ -4550,7 +4550,7 @@ static void net_dma_rebalance(struct net
 	}
 
 	i = 0;
-	cpu = first_cpu(cpu_online_map);
+	cpu = cpus_first(cpu_online_map);
 
 	for_each_cpu(chan_idx, net_dma->channel_mask) {
 		chan = net_dma->channels[chan_idx];
@@ -4561,7 +4561,7 @@ static void net_dma_rebalance(struct net
 
 		while(n) {
 			per_cpu(softnet_data, cpu).net_dma = chan;
-			cpu = next_cpu(cpu, cpu_online_map);
+			cpu = cpus_next(cpu, cpu_online_map);
 			n--;
 		}
 		i++;
--- struct-cpumasks.orig/net/iucv/iucv.c
+++ struct-cpumasks/net/iucv/iucv.c
@@ -496,7 +496,7 @@ static void iucv_setmask_up(void)
 
 	/* Disable all cpu but the first in cpu_irq_cpumask. */
 	cpumask = iucv_irq_cpumask;
-	cpu_clear(first_cpu(iucv_irq_cpumask), cpumask);
+	cpu_clear(cpus_first(iucv_irq_cpumask), cpumask);
 	for_each_cpu(cpu, cpumask)
 		smp_call_function_single(cpu, iucv_block_cpu, NULL, 1);
 }
@@ -596,7 +596,7 @@ static int __cpuinit iucv_cpu_notify(str
 			return NOTIFY_BAD;
 		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 1);
 		if (cpus_empty(iucv_irq_cpumask))
-			smp_call_function_single(first_cpu(iucv_buffer_cpumask),
+			smp_call_function_single(cpus_first(iucv_buffer_cpumask),
 						 iucv_allow_cpu, NULL, 1);
 		break;
 	}

-- 
