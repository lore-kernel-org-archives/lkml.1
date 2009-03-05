Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZCEDKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZCEDKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZCEDKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:10:20 -0500
Received: from ozlabs.org ([203.10.76.45]:49720 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZCEDKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:10:18 -0500
Subject: [PULL] cpumask updates for powerpc
From: Rusty Russell <rusty@rustcorp.com.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, travis@sgi.com
CC: mingo@redhat.com
CC: travis@sgi.com
Date: Thu, 5 Mar 2009 13:40:12 +1030
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051340.12873.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 559595a985e106d2fa9f0c79b7f5805453fed593:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-powerpc.git master

Rusty Russell (5):
      powerpc: avoid cpumask games in arch/powerpc/kernel/sysfs.c
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): powerpc
      cpumask: arch_send_call_function_ipi_mask: powerpc
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: powerpc
      cpumask: Use accessors code.: powerpc

 arch/powerpc/include/asm/cputhreads.h        |    2 +-
 arch/powerpc/include/asm/smp.h               |    3 +-
 arch/powerpc/include/asm/topology.h          |    5 ----
 arch/powerpc/kernel/irq.c                    |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c       |    2 +-
 arch/powerpc/kernel/process.c                |    2 +-
 arch/powerpc/kernel/setup-common.c           |   14 ++++++------
 arch/powerpc/kernel/smp.c                    |    4 +-
 arch/powerpc/kernel/sysfs.c                  |   31 ++++---------------------
 arch/powerpc/mm/numa.c                       |    4 +-
 arch/powerpc/platforms/powermac/setup.c      |    4 +-
 arch/powerpc/platforms/powermac/smp.c        |    4 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    2 +-
 arch/powerpc/platforms/pseries/rtasd.c       |    2 +-
 arch/powerpc/platforms/pseries/xics.c        |    2 +-
 arch/powerpc/xmon/xmon.c                     |    4 +-
 16 files changed, 31 insertions(+), 56 deletions(-)

diff --git a/arch/powerpc/include/asm/cputhreads.h b/arch/powerpc/include/asm/cputhreads.h
index fb11b0c..73ab9c1 100644
--- a/arch/powerpc/include/asm/cputhreads.h
+++ b/arch/powerpc/include/asm/cputhreads.h
@@ -34,7 +34,7 @@ static inline cpumask_t cpu_thread_mask_to_cores(cpumask_t threads)
 	int		i;
 
 	res = CPU_MASK_NONE;
-	for (i = 0; i < NR_CPUS; i += threads_per_core) {
+	for (i = 0; i < nr_cpu_ids; i += threads_per_core) {
 		cpus_shift_left(tmp, threads_core_mask, i);
 		if (cpus_intersects(threads, tmp))
 			cpu_set(i, res);
diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index c25f73d..ec53b31 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -146,7 +146,8 @@ extern void smp_generic_take_timebase(void);
 extern struct smp_ops_t *smp_ops;
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif /* __ASSEMBLY__ */
 
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 3752585..770921a 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -41,11 +41,6 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 }
 #endif
 
-#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
-					node_to_cpumask(pcibus_to_node(bus)) \
-				)
-
 #define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
 				 cpu_all_mask :				\
 				 cpumask_of_node(pcibus_to_node(bus)))
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 23b8b5e..7573591 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -232,7 +232,7 @@ void fixup_irqs(cpumask_t map)
 			continue;
 
 		cpus_and(mask, irq_desc[irq].affinity, map);
-		if (any_online_cpu(mask) == NR_CPUS) {
+		if (cpumask_any_and(&mask, cpu_online_mask) >= nr_cpu_ids) {
 			printk("Breaking affinity for irq %i\n", irq);
 			mask = map;
 		}
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 49e705f..b549ab0 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -176,7 +176,7 @@ static void kexec_prepare_cpus(void)
 	my_cpu = get_cpu();
 
 	/* check the others cpus are now down (via paca hw cpu id == -1) */
-	for (i=0; i < NR_CPUS; i++) {
+	for (i = 0; i < nr_cpu_ids; i++) {
 		if (i == my_cpu)
 			continue;
 
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index fb7049c..dca82b2 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -944,7 +944,7 @@ static inline int valid_irq_stack(unsigned long sp, struct task_struct *p,
 	 * Avoid crashing if the stack has overflowed and corrupted
 	 * task_cpu(p), which is in the thread_info struct.
 	 */
-	if (cpu < NR_CPUS && cpu_possible(cpu)) {
+	if (cpu < nr_cpu_ids && cpu_possible(cpu)) {
 		stack_page = (unsigned long) hardirq_ctx[cpu];
 		if (sp >= stack_page + sizeof(struct thread_struct)
 		    && sp <= stack_page + THREAD_SIZE - nbytes)
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 705fc4b..7a4b359 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -167,7 +167,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	unsigned short maj;
 	unsigned short min;
 
-	if (cpu_id == NR_CPUS) {
+	if (cpu_id == nr_cpu_ids) {
 		struct device_node *root;
 		const char *model = NULL;
 #if defined(CONFIG_SMP) && defined(CONFIG_PPC32)
@@ -203,7 +203,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	/* We only show online cpus: disable preempt (overzealous, I
 	 * knew) to prevent cpu going down. */
 	preempt_disable();
-	if (!cpu_online(cpu_id)) {
+	if (cpu_id >= nr_cpu_ids || !cpu_online(cpu_id)) {
 		preempt_enable();
 		return 0;
 	}
@@ -314,7 +314,7 @@ static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	unsigned long i = *pos;
 
-	return i <= NR_CPUS ? (void *)(i + 1) : NULL;
+	return i <= nr_cpu_ids ? (void *)(i + 1) : NULL;
 }
 
 static void *c_next(struct seq_file *m, void *v, loff_t *pos)
@@ -409,7 +409,7 @@ void __init smp_setup_cpu_maps(void)
 
 	DBG("smp_setup_cpu_maps()\n");
 
-	while ((dn = of_find_node_by_type(dn, "cpu")) && cpu < NR_CPUS) {
+	while ((dn = of_find_node_by_type(dn, "cpu")) && cpu < nr_cpu_ids) {
 		const int *intserv;
 		int j, len;
 
@@ -428,12 +428,12 @@ void __init smp_setup_cpu_maps(void)
 				intserv = &cpu;	/* assume logical == phys */
 		}
 
-		for (j = 0; j < nthreads && cpu < NR_CPUS; j++) {
+		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, intserv[j]);
 			cpu_set(cpu, cpu_present_map);
 			set_hard_smp_processor_id(cpu, intserv[j]);
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 			cpu++;
 		}
 	}
@@ -479,7 +479,7 @@ void __init smp_setup_cpu_maps(void)
 			       maxcpus);
 
 		for (cpu = 0; cpu < maxcpus; cpu++)
-			cpu_set(cpu, cpu_possible_map);
+			set_cpu_possible(cpu, true);
 	out:
 		of_node_put(dn);
 	}
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 65484b2..12fc997 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -188,11 +188,11 @@ void arch_send_call_function_single_ipi(int cpu)
 	smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu(cpu, mask)
 		smp_ops->message_pass(cpu, PPC_MSG_CALL_FUNCTION);
 }
 
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 4a2ee08..d51cf0b 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -134,36 +134,15 @@ void ppc_enable_pmcs(void)
 }
 EXPORT_SYMBOL(ppc_enable_pmcs);
 
-#if defined(CONFIG_6xx) || defined(CONFIG_PPC64)
-/* XXX convert to rusty's on_one_cpu */
-static unsigned long run_on_cpu(unsigned long cpu,
-			        unsigned long (*func)(unsigned long),
-				unsigned long arg)
-{
-	cpumask_t old_affinity = current->cpus_allowed;
-	unsigned long ret;
-
-	/* should return -EINVAL to userspace */
-	if (set_cpus_allowed(current, cpumask_of_cpu(cpu)))
-		return 0;
-
-	ret = func(arg);
-
-	set_cpus_allowed(current, old_affinity);
-
-	return ret;
-}
-#endif
-
 #define SYSFS_PMCSETUP(NAME, ADDRESS) \
-static unsigned long read_##NAME(unsigned long junk) \
+static long read_##NAME(void *junk) \
 { \
 	return mfspr(ADDRESS); \
 } \
-static unsigned long write_##NAME(unsigned long val) \
+static long write_##NAME(void *val) \
 { \
 	ppc_enable_pmcs(); \
-	mtspr(ADDRESS, val); \
+	mtspr(ADDRESS, (unsigned long)val);	\
 	return 0; \
 } \
 static ssize_t show_##NAME(struct sys_device *dev, \
@@ -171,7 +150,7 @@ static ssize_t show_##NAME(struct sys_device *dev, \
 			char *buf) \
 { \
 	struct cpu *cpu = container_of(dev, struct cpu, sysdev); \
-	unsigned long val = run_on_cpu(cpu->sysdev.id, read_##NAME, 0); \
+	unsigned long val = work_on_cpu(cpu->sysdev.id, read_##NAME, NULL); \
 	return sprintf(buf, "%lx\n", val); \
 } \
 static ssize_t __used \
@@ -183,7 +162,7 @@ static ssize_t __used \
 	int ret = sscanf(buf, "%lx", &val); \
 	if (ret != 1) \
 		return -EINVAL; \
-	run_on_cpu(cpu->sysdev.id, write_##NAME, val); \
+	work_on_cpu(cpu->sysdev.id, write_##NAME, (void *)val);	\
 	return count; \
 }
 
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 5ac08b8..3e46618 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -766,7 +766,7 @@ void __init dump_numa_cpu_topology(void)
 		 * If we used a CPU iterator here we would miss printing
 		 * the holes in the cpumap.
 		 */
-		for (cpu = 0; cpu < NR_CPUS; cpu++) {
+		for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
 			if (cpu_isset(cpu, numa_cpumask_lookup_table[node])) {
 				if (count == 0)
 					printk(" %u", cpu);
@@ -779,7 +779,7 @@ void __init dump_numa_cpu_topology(void)
 		}
 
 		if (count > 1)
-			printk("-%u", NR_CPUS - 1);
+			printk("-%u", nr_cpu_ids - 1);
 		printk("\n");
 	}
 }
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 9b78f53..e0c106f 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -362,8 +362,8 @@ static void __init pmac_setup_arch(void)
 		 */
 		int cpu;
 
-		for (cpu = 1; cpu < 4 && cpu < NR_CPUS; ++cpu)
-			cpu_set(cpu, cpu_possible_map);
+		for (cpu = 1; cpu < 4 && cpu < nr_cpu_ids; ++cpu)
+			set_cpu_possible(cpu, true);
 		smp_ops = &psurge_smp_ops;
 	}
 #endif
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index bd8817b..5df7d43 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -314,8 +314,8 @@ static int __init smp_psurge_probe(void)
 	 * device tree for them, and smp_setup_cpu_maps hasn't
 	 * set their bits in cpu_possible_map and cpu_present_map.
 	 */
-	if (ncpus > NR_CPUS)
-		ncpus = NR_CPUS;
+	if (ncpus > nr_cpu_ids)
+		ncpus = nr_cpu_ids;
 	for (i = 1; i < ncpus ; ++i) {
 		cpu_set(i, cpu_present_map);
 		set_hard_smp_processor_id(i, i);
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index a20ead8..e62ddcf 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -221,7 +221,7 @@ static void pseries_remove_processor(struct device_node *np)
 			set_hard_smp_processor_id(cpu, -1);
 			break;
 		}
-		if (cpu == NR_CPUS)
+		if (cpu >= nr_cpu_ids)
 			printk(KERN_WARNING "Could not find cpu to remove "
 			       "with physical id 0x%x\n", intserv[i]);
 	}
diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index afad9f5..de1a848 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -404,7 +404,7 @@ static void do_event_scan_all_cpus(long delay)
 		get_online_cpus();
 
 		cpu = next_cpu(cpu, cpu_online_map);
-		if (cpu == NR_CPUS)
+		if (cpu >= nr_cpu_ids)
 			break;
 	}
 	put_online_cpus();
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 84e058f..b8613e6 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -164,7 +164,7 @@ static int get_irq_server(unsigned int virq, unsigned int strict_check)
 
 		server = first_cpu(tmp);
 
-		if (server < NR_CPUS)
+		if (server < nr_cpu_ids)
 			return get_hard_smp_processor_id(server);
 
 		if (strict_check)
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 8dfad7d..5f4011f 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -937,7 +937,7 @@ static int cpu_cmd(void)
 		/* print cpus waiting or in xmon */
 		printf("cpus stopped:");
 		count = 0;
-		for (cpu = 0; cpu < NR_CPUS; ++cpu) {
+		for (cpu = 0; cpu < nr_cpu_ids; ++cpu) {
 			if (cpu_isset(cpu, cpus_in_xmon)) {
 				if (count == 0)
 					printf(" %x", cpu);
@@ -949,7 +949,7 @@ static int cpu_cmd(void)
 			}
 		}
 		if (count > 1)
-			printf("-%x", NR_CPUS - 1);
+			printf("-%x", nr_cpu_ids - 1);
 		printf("\n");
 		return 0;
 	}
