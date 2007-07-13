Return-Path: <linux-kernel-owner+w=401wt.eu-S935575AbXGMG6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575AbXGMG6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXGMG6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:58:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35703 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752074AbXGMG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:58:08 -0400
Date: Thu, 12 Jul 2007 23:58:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: ak@suse.de
cc: linux-kernel@vger.kernel.org, travis@sgi.com,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: x86: Convert cpu_core_map to be a per cpu variable
Message-ID: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_core_map is currently an array defined using NR_CPUS. This means that
we overallocate since we will rarely really use the maximum 
number of configured cpus. This may become a problem when we need to 
increase the NR_CPUs on x86_64 for our new product line.

If we put the cpu_core_map into the per cpu area then it will be allocated
for each processor as it comes online.

However, this means that the core map cannot be accessed until the per cpu 
area has been allocated. Xen does a weird thing here looping over all 
processors and zeroing the masks that are not yet allocated and that will 
be zeroed when they are allocated. I commented the code out. Maybe there 
is another purpose? Jeremy?

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c       |    2 -
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c        |   10 +++---
 arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c |    2 -
 arch/i386/kernel/cpu/proc.c                       |    3 +
 arch/i386/kernel/smpboot.c                        |   34 +++++++++++-----------
 arch/i386/xen/smp.c                               |   13 +++++++-
 arch/x86_64/kernel/mce_amd.c                      |    6 +--
 arch/x86_64/kernel/setup.c                        |    2 -
 arch/x86_64/kernel/smpboot.c                      |   24 +++++++--------
 include/asm-i386/smp.h                            |    2 -
 include/asm-i386/topology.h                       |    2 -
 include/asm-x86_64/topology.h                     |    2 -
 12 files changed, 56 insertions(+), 46 deletions(-)

Index: linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c	2007-07-12 23:02:11.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c	2007-07-12 23:14:04.000000000 -0700
@@ -609,7 +609,7 @@ static int acpi_cpufreq_cpu_init(struct 
 	dmi_check_system(sw_any_bug_dmi_table);
 	if (bios_with_sw_any_bug && cpus_weight(policy->cpus) == 1) {
 		policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
-		policy->cpus = cpu_core_map[cpu];
+		policy->cpus = per_cpu(cpu_core_map, cpu);
 	}
 #endif
 
Index: linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/cpufreq/powernow-k8.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/kernel/cpu/cpufreq/powernow-k8.c	2007-07-12 23:02:11.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/cpufreq/powernow-k8.c	2007-07-12 23:14:04.000000000 -0700
@@ -57,7 +57,7 @@ static struct powernow_k8_data *powernow
 static int cpu_family = CPU_OPTERON;
 
 #ifndef CONFIG_SMP
-static cpumask_t cpu_core_map[1];
+DEFINE_PER_CPU(cpumask_t, cpu_core_map)
 #endif
 
 /* Return a frequency in MHz, given an input fid */
@@ -661,7 +661,7 @@ static int fill_powernow_table(struct po
 
 	dprintk("cfid 0x%x, cvid 0x%x\n", data->currfid, data->currvid);
 	data->powernow_table = powernow_table;
-	if (first_cpu(cpu_core_map[data->cpu]) == data->cpu)
+	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 
 	for (j = 0; j < data->numps; j++)
@@ -815,7 +815,7 @@ static int powernow_k8_cpu_init_acpi(str
 
 	/* fill in data */
 	data->numps = data->acpi_data.state_count;
-	if (first_cpu(cpu_core_map[data->cpu]) == data->cpu)
+	if (first_cpu(per_cpu(cpu_core_map, data->cpu)) == data->cpu)
 		print_basics(data);
 	powernow_k8_acpi_pst_values(data, 0);
 
@@ -1209,7 +1209,7 @@ static int __cpuinit powernowk8_cpu_init
 	if (cpu_family == CPU_HW_PSTATE)
 		pol->cpus = cpumask_of_cpu(pol->cpu);
 	else
-		pol->cpus = cpu_core_map[pol->cpu];
+		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
 
 	/* Take a crude guess here.
@@ -1276,7 +1276,7 @@ static unsigned int powernowk8_get (unsi
 	cpumask_t oldmask = current->cpus_allowed;
 	unsigned int khz = 0;
 
-	data = powernow_data[first_cpu(cpu_core_map[cpu])];
+	data = powernow_data[first_cpu(per_cpu(cpu_core_map, cpu))];
 
 	if (!data)
 		return -EINVAL;
Index: linux-2.6.22-rc6-mm1/arch/x86_64/kernel/mce_amd.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/x86_64/kernel/mce_amd.c	2007-07-12 23:02:11.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/x86_64/kernel/mce_amd.c	2007-07-12 23:14:04.000000000 -0700
@@ -472,7 +472,7 @@ static __cpuinit int threshold_create_ba
 
 #ifdef CONFIG_SMP
 	if (cpu_data[cpu].cpu_core_id && shared_bank[bank]) {	/* symlink */
-		i = first_cpu(cpu_core_map[cpu]);
+		i = first_cpu(per_cpu(cpu_core_map, cpu));
 
 		/* first core not up yet */
 		if (cpu_data[i].cpu_core_id)
@@ -492,7 +492,7 @@ static __cpuinit int threshold_create_ba
 		if (err)
 			goto out;
 
-		b->cpus = cpu_core_map[cpu];
+		b->cpus = per_cpu(cpu_core_map, cpu);
 		per_cpu(threshold_banks, cpu)[bank] = b;
 		goto out;
 	}
@@ -509,7 +509,7 @@ static __cpuinit int threshold_create_ba
 #ifndef CONFIG_SMP
 	b->cpus = CPU_MASK_ALL;
 #else
-	b->cpus = cpu_core_map[cpu];
+	b->cpus = per_cpu(cpu_core_map, cpu);
 #endif
 	err = kobject_register(&b->kobj);
 	if (err)
Index: linux-2.6.22-rc6-mm1/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/x86_64/kernel/setup.c	2007-07-12 23:02:11.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/x86_64/kernel/setup.c	2007-07-12 23:14:04.000000000 -0700
@@ -1042,7 +1042,7 @@ static int show_cpuinfo(struct seq_file 
 	if (smp_num_siblings * c->x86_max_cores > 1) {
 		int cpu = c - cpu_data;
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n", cpus_weight(cpu_core_map[cpu]));
+		seq_printf(m, "siblings\t: %d\n", cpus_weight(per_cpu(cpu_core_map, cpu)));
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 	}
Index: linux-2.6.22-rc6-mm1/arch/x86_64/kernel/smpboot.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/x86_64/kernel/smpboot.c	2007-07-12 23:02:11.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/x86_64/kernel/smpboot.c	2007-07-12 23:25:36.000000000 -0700
@@ -95,8 +95,8 @@ cpumask_t cpu_sibling_map[NR_CPUS] __rea
 EXPORT_SYMBOL(cpu_sibling_map);
 
 /* representing HT and core siblings of each logical CPU */
-cpumask_t cpu_core_map[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(cpu_core_map);
+DEFINE_PER_CPU(cpumask_t, cpu_core_map);
+EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
 /*
  * Trampoline 80x86 program as an array.
@@ -243,7 +243,7 @@ cpumask_t cpu_coregroup_map(int cpu)
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return cpu_core_map[cpu];
+		return per_cpu(cpu_core_map, cpu);
 	else
 		return c->llc_shared_map;
 }
@@ -264,8 +264,8 @@ static inline void set_cpu_sibling_map(i
 			    c[cpu].cpu_core_id == c[i].cpu_core_id) {
 				cpu_set(i, cpu_sibling_map[cpu]);
 				cpu_set(cpu, cpu_sibling_map[i]);
-				cpu_set(i, cpu_core_map[cpu]);
-				cpu_set(cpu, cpu_core_map[i]);
+				cpu_set(i, per_cpu(cpu_core_map, cpu));
+				cpu_set(cpu, per_cpu(cpu_core_map, i));
 				cpu_set(i, c[cpu].llc_shared_map);
 				cpu_set(cpu, c[i].llc_shared_map);
 			}
@@ -277,7 +277,7 @@ static inline void set_cpu_sibling_map(i
 	cpu_set(cpu, c[cpu].llc_shared_map);
 
 	if (current_cpu_data.x86_max_cores == 1) {
-		cpu_core_map[cpu] = cpu_sibling_map[cpu];
+		per_cpu(cpu_core_map, cpu) = cpu_sibling_map[cpu];
 		c[cpu].booted_cores = 1;
 		return;
 	}
@@ -289,8 +289,8 @@ static inline void set_cpu_sibling_map(i
 			cpu_set(cpu, c[i].llc_shared_map);
 		}
 		if (c[cpu].phys_proc_id == c[i].phys_proc_id) {
-			cpu_set(i, cpu_core_map[cpu]);
-			cpu_set(cpu, cpu_core_map[i]);
+			cpu_set(i, per_cpu(cpu_core_map, cpu));
+			cpu_set(cpu, per_cpu(cpu_core_map, i));
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
@@ -739,7 +739,7 @@ static __init void disable_smp(void)
 	else
 		phys_cpu_present_map = physid_mask_of_physid(0);
 	cpu_set(0, cpu_sibling_map[0]);
-	cpu_set(0, cpu_core_map[0]);
+	cpu_set(0, per_cpu(cpu_core_map, 0));
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -974,8 +974,8 @@ static void remove_siblinginfo(int cpu)
 	int sibling;
 	struct cpuinfo_x86 *c = cpu_data;
 
-	for_each_cpu_mask(sibling, cpu_core_map[cpu]) {
-		cpu_clear(cpu, cpu_core_map[sibling]);
+	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
+		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
 		/*
 		 * last thread sibling in this cpu core going down
 		 */
@@ -986,7 +986,7 @@ static void remove_siblinginfo(int cpu)
 	for_each_cpu_mask(sibling, cpu_sibling_map[cpu])
 		cpu_clear(cpu, cpu_sibling_map[sibling]);
 	cpus_clear(cpu_sibling_map[cpu]);
-	cpus_clear(cpu_core_map[cpu]);
+	cpus_clear(per_cpu(cpu_core_map, cpu));
 	c[cpu].phys_proc_id = 0;
 	c[cpu].cpu_core_id = 0;
 	cpu_clear(cpu, cpu_sibling_setup_map);
Index: linux-2.6.22-rc6-mm1/include/asm-i386/smp.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/asm-i386/smp.h	2007-07-12 23:26:57.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/asm-i386/smp.h	2007-07-12 23:27:20.000000000 -0700
@@ -31,7 +31,7 @@ extern void smp_alloc_memory(void);
 extern int pic_mode;
 extern int smp_num_siblings;
 extern cpumask_t cpu_sibling_map[];
-extern cpumask_t cpu_core_map[];
+DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 
 extern void (*mtrr_hook) (void);
 extern void zap_low_mappings (void);
Index: linux-2.6.22-rc6-mm1/include/asm-i386/topology.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/asm-i386/topology.h	2007-07-12 23:27:28.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/asm-i386/topology.h	2007-07-12 23:27:37.000000000 -0700
@@ -30,7 +30,7 @@
 #ifdef CONFIG_X86_HT
 #define topology_physical_package_id(cpu)	(cpu_data[cpu].phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data[cpu].cpu_core_id)
-#define topology_core_siblings(cpu)		(cpu_core_map[cpu])
+#define topology_core_siblings(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_siblings(cpu)		(cpu_sibling_map[cpu])
 #endif
 
Index: linux-2.6.22-rc6-mm1/include/asm-x86_64/topology.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/asm-x86_64/topology.h	2007-07-12 23:26:14.000000000 -0700
+++ linux-2.6.22-rc6-mm1/include/asm-x86_64/topology.h	2007-07-12 23:26:28.000000000 -0700
@@ -58,7 +58,7 @@ extern int __node_distance(int, int);
 #ifdef CONFIG_SMP
 #define topology_physical_package_id(cpu)	(cpu_data[cpu].phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data[cpu].cpu_core_id)
-#define topology_core_siblings(cpu)		(cpu_core_map[cpu])
+#define topology_core_siblings(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_siblings(cpu)		(cpu_sibling_map[cpu])
 #define mc_capable()			(boot_cpu_data.x86_max_cores > 1)
 #define smt_capable() 			(smp_num_siblings > 1)
Index: linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c	2007-07-12 23:30:11.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c	2007-07-12 23:30:50.000000000 -0700
@@ -444,7 +444,7 @@ static int centrino_cpu_init_acpi(struct
 	dmi_check_system(sw_any_bug_dmi_table);
 	if (bios_with_sw_any_bug && cpus_weight(policy->cpus) == 1) {
 		policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
-		policy->cpus = cpu_core_map[cpu];
+		policy->cpus = per_cpu(cpu_core_map, cpu);
 	}
 #endif
 
Index: linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/proc.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/kernel/cpu/proc.c	2007-07-12 23:31:30.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/proc.c	2007-07-12 23:32:01.000000000 -0700
@@ -122,7 +122,8 @@ static int show_cpuinfo(struct seq_file 
 #ifdef CONFIG_X86_HT
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
-		seq_printf(m, "siblings\t: %d\n", cpus_weight(cpu_core_map[n]));
+		seq_printf(m, "siblings\t: %d\n",
+				cpus_weight(per_cpu(cpu_core_map, n)));
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 	}
Index: linux-2.6.22-rc6-mm1/arch/i386/kernel/smpboot.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/kernel/smpboot.c	2007-07-12 23:33:30.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/smpboot.c	2007-07-12 23:39:13.000000000 -0700
@@ -74,8 +74,8 @@ cpumask_t cpu_sibling_map[NR_CPUS] __rea
 EXPORT_SYMBOL(cpu_sibling_map);
 
 /* representing HT and core siblings of each logical CPU */
-cpumask_t cpu_core_map[NR_CPUS] __read_mostly;
-EXPORT_SYMBOL(cpu_core_map);
+DEFINE_PER_CPU(cpumask_t, cpu_core_map);
+EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
 /* bitmap of online cpus */
 cpumask_t cpu_online_map __read_mostly;
@@ -300,7 +300,7 @@ cpumask_t cpu_coregroup_map(int cpu)
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return cpu_core_map[cpu];
+		return per_cpu(cpu_core_map, cpu);
 	else
 		return c->llc_shared_map;
 }
@@ -321,8 +321,8 @@ void __cpuinit set_cpu_sibling_map(int c
 			    c[cpu].cpu_core_id == c[i].cpu_core_id) {
 				cpu_set(i, cpu_sibling_map[cpu]);
 				cpu_set(cpu, cpu_sibling_map[i]);
-				cpu_set(i, cpu_core_map[cpu]);
-				cpu_set(cpu, cpu_core_map[i]);
+				cpu_set(i, per_cpu(cpu_core_map, cpu));
+				cpu_set(cpu, per_cpu(cpu_core_map, i));
 				cpu_set(i, c[cpu].llc_shared_map);
 				cpu_set(cpu, c[i].llc_shared_map);
 			}
@@ -334,7 +334,7 @@ void __cpuinit set_cpu_sibling_map(int c
 	cpu_set(cpu, c[cpu].llc_shared_map);
 
 	if (current_cpu_data.x86_max_cores == 1) {
-		cpu_core_map[cpu] = cpu_sibling_map[cpu];
+		per_cpu(cpu_core_map, cpu) = cpu_sibling_map[cpu];
 		c[cpu].booted_cores = 1;
 		return;
 	}
@@ -346,8 +346,8 @@ void __cpuinit set_cpu_sibling_map(int c
 			cpu_set(cpu, c[i].llc_shared_map);
 		}
 		if (c[cpu].phys_proc_id == c[i].phys_proc_id) {
-			cpu_set(i, cpu_core_map[cpu]);
-			cpu_set(cpu, cpu_core_map[i]);
+			cpu_set(i, per_cpu(cpu_core_map, cpu));
+			cpu_set(cpu, per_cpu(cpu_core_map, i));
 			/*
 			 *  Does this new cpu bringup a new core?
 			 */
@@ -984,7 +984,7 @@ static void __init smp_boot_cpus(unsigne
 					   " Using dummy APIC emulation.\n");
 		map_cpu_to_logical_apicid();
 		cpu_set(0, cpu_sibling_map[0]);
-		cpu_set(0, cpu_core_map[0]);
+		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return;
 	}
 
@@ -1009,7 +1009,7 @@ static void __init smp_boot_cpus(unsigne
 		smpboot_clear_io_apic_irqs();
 		phys_cpu_present_map = physid_mask_of_physid(0);
 		cpu_set(0, cpu_sibling_map[0]);
-		cpu_set(0, cpu_core_map[0]);
+		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return;
 	}
 
@@ -1024,7 +1024,7 @@ static void __init smp_boot_cpus(unsigne
 		smpboot_clear_io_apic_irqs();
 		phys_cpu_present_map = physid_mask_of_physid(0);
 		cpu_set(0, cpu_sibling_map[0]);
-		cpu_set(0, cpu_core_map[0]);
+		cpu_set(0, per_cpu(cpu_core_map, 0));
 		return;
 	}
 
@@ -1107,11 +1107,11 @@ static void __init smp_boot_cpus(unsigne
 	 */
 	for (cpu = 0; cpu < NR_CPUS; cpu++) {
 		cpus_clear(cpu_sibling_map[cpu]);
-		cpus_clear(cpu_core_map[cpu]);
+		cpus_clear(per_cpu(cpu_core_map, cpu));
 	}
 
 	cpu_set(0, cpu_sibling_map[0]);
-	cpu_set(0, cpu_core_map[0]);
+	cpu_set(0, per_cpu(cpu_core_map, 0));
 
 	smpboot_setup_io_apic();
 
@@ -1148,9 +1148,9 @@ void remove_siblinginfo(int cpu)
 	int sibling;
 	struct cpuinfo_x86 *c = cpu_data;
 
-	for_each_cpu_mask(sibling, cpu_core_map[cpu]) {
-		cpu_clear(cpu, cpu_core_map[sibling]);
-		/*
+	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
+		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
+		/*/
 		 * last thread sibling in this cpu core going down
 		 */
 		if (cpus_weight(cpu_sibling_map[cpu]) == 1)
@@ -1160,7 +1160,7 @@ void remove_siblinginfo(int cpu)
 	for_each_cpu_mask(sibling, cpu_sibling_map[cpu])
 		cpu_clear(cpu, cpu_sibling_map[sibling]);
 	cpus_clear(cpu_sibling_map[cpu]);
-	cpus_clear(cpu_core_map[cpu]);
+	cpus_clear(per_cpu(cpu_core_map, cpu));
 	c[cpu].phys_proc_id = 0;
 	c[cpu].cpu_core_id = 0;
 	cpu_clear(cpu, cpu_sibling_setup_map);
Index: linux-2.6.22-rc6-mm1/arch/i386/xen/smp.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/i386/xen/smp.c	2007-07-12 23:32:37.000000000 -0700
+++ linux-2.6.22-rc6-mm1/arch/i386/xen/smp.c	2007-07-12 23:52:08.000000000 -0700
@@ -150,7 +150,12 @@ void __init xen_smp_prepare_boot_cpu(voi
 
 	for (cpu = 0; cpu < NR_CPUS; cpu++) {
 		cpus_clear(cpu_sibling_map[cpu]);
-		cpus_clear(cpu_core_map[cpu]);
+		/*
+		 * cpu_core_map lives in a per cpu area that is cleared
+		 * when the per cpu array is allocated.
+		 *
+		 * cpus_clear(per_cpu(cpu_core_map, cpu));
+		 */
 	}
 }
 
@@ -160,7 +165,11 @@ void __init xen_smp_prepare_cpus(unsigne
 
 	for (cpu = 0; cpu < NR_CPUS; cpu++) {
 		cpus_clear(cpu_sibling_map[cpu]);
-		cpus_clear(cpu_core_map[cpu]);
+		/*
+		 * cpu_core_ map will be zeroed when the per cpu area is allocated.
+		 *
+		 * cpus_clear(per_cpu(cpu_core_map, cpu));
+		 */
 	}
 
 	smp_store_cpu_info(0);
