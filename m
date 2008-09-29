Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYI2SM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYI2SM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYI2SDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:34 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54338 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753993AbYI2SCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:54 -0400
Message-Id: <20080929180253.392857000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:14 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 24/31] cpumask: clean cpu files
Content-Disposition: inline; filename=clean-cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/common.c            |    2 
 arch/x86/kernel/cpu/intel_cacheinfo.c   |   16 +++----
 arch/x86/kernel/cpu/mcheck/mce_64.c     |    4 -
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |   44 +++++++++++----------
 arch/x86/kernel/setup_percpu.c          |    8 +--
 drivers/base/cpu.c                      |    6 +-
 include/linux/cpuset.h                  |   12 ++---
 include/linux/percpu.h                  |    7 +--
 kernel/cpu.c                            |   28 ++++++-------
 kernel/cpuset.c                         |   66 ++++++++++++++++----------------
 10 files changed, 98 insertions(+), 95 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/cpu/common.c
+++ struct-cpumasks/arch/x86/kernel/cpu/common.c
@@ -842,7 +842,7 @@ static __init int setup_disablecpuid(cha
 }
 __setup("clearcpuid=", setup_disablecpuid);
 
-cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
+cpumask_map_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
 #ifdef CONFIG_X86_64
 struct x8664_pda **_cpu_pda __read_mostly;
--- struct-cpumasks.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ struct-cpumasks/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -132,7 +132,7 @@ struct _cpuid4_info {
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
 	unsigned long can_disable;
-	cpumask_t shared_cpu_map;	/* future?: only cpus/node is needed */
+	cpumask_map_t shared_cpu_map;	/* future?: only cpus/node is needed */
 };
 
 #ifdef CONFIG_PCI
@@ -539,7 +539,7 @@ static int __cpuinit detect_cache_attrib
 	struct _cpuid4_info	*this_leaf;
 	unsigned long		j;
 	int			retval;
-	cpumask_t		oldmask;
+	cpumask_var_t		oldmask;
 
 	if (num_cache_leaves == 0)
 		return -ENOENT;
@@ -549,7 +549,7 @@ static int __cpuinit detect_cache_attrib
 	if (per_cpu(cpuid4_info, cpu) == NULL)
 		return -ENOMEM;
 
-	oldmask = current->cpus_allowed;
+	cpus_copy(oldmask, current->cpus_allowed);
 	retval = set_cpus_allowed(current, cpumask_of_cpu(cpu));
 	if (retval)
 		goto out;
@@ -567,7 +567,7 @@ static int __cpuinit detect_cache_attrib
 		}
 		cache_shared_cpu_map_setup(cpu, j);
 	}
-	set_cpus_allowed(current, &oldmask);
+	set_cpus_allowed(current, oldmask);
 
 out:
 	if (retval) {
@@ -623,11 +623,11 @@ static ssize_t show_shared_cpu_map_func(
 	int n = 0;
 
 	if (len > 1) {
-		cpumask_t *mask = &this_leaf->shared_cpu_map;
+		const_cpumask_t mask = this_leaf->shared_cpu_map;
 
 		n = type?
-			cpulist_scnprintf(buf, len-2, *mask):
-			cpumask_scnprintf(buf, len-2, *mask);
+			cpulist_scnprintf(buf, len-2, mask):
+			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
@@ -869,7 +869,7 @@ err_out:
 	return -ENOMEM;
 }
 
-static cpumask_t cache_dev_map = CPU_MASK_NONE;
+static cpumask_map_t cache_dev_map = CPU_MASK_NONE;
 
 /* Add/Remove cache interface for CPU device */
 static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
--- struct-cpumasks.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ struct-cpumasks/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -510,7 +510,7 @@ static void __cpuinit mce_cpu_features(s
  */
 void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 {
-	static cpumask_t mce_cpus = CPU_MASK_NONE;
+	static cpumask_map_t mce_cpus = CPU_MASK_NONE;
 
 	mce_cpu_quirks(c);
 
@@ -822,7 +822,7 @@ static struct sysdev_attribute *mce_attr
 	NULL
 };
 
-static cpumask_t mce_device_initialized = CPU_MASK_NONE;
+static cpumask_map_t mce_device_initialized = CPU_MASK_NONE;
 
 /* Per cpu sysdev init.  All of the cpus still share the same ctl bank */
 static __cpuinit int mce_create_device(unsigned int cpu)
--- struct-cpumasks.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ struct-cpumasks/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -251,16 +251,16 @@ struct threshold_attr {
 	ssize_t(*store) (struct threshold_block *, const char *, size_t count);
 };
 
-static void affinity_set(unsigned int cpu, cpumask_t *oldmask,
-					   cpumask_t *newmask)
+static void affinity_set(unsigned int cpu, cpumask_t oldmask,
+					   cpumask_t newmask)
 {
-	*oldmask = current->cpus_allowed;
-	cpus_clear(*newmask);
-	cpu_set(cpu, *newmask);
+	cpus_copy(oldmask, current->cpus_allowed);
+	cpus_clear(newmask);
+	cpu_set(cpu, newmask);
 	set_cpus_allowed(current, newmask);
 }
 
-static void affinity_restore(const cpumask_t *oldmask)
+static void affinity_restore(const_cpumask_t oldmask)
 {
 	set_cpus_allowed(current, oldmask);
 }
@@ -277,15 +277,15 @@ static ssize_t store_interrupt_enable(st
 				      const char *buf, size_t count)
 {
 	char *end;
-	cpumask_t oldmask, newmask;
+	cpumask_var_t oldmask, newmask;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
 		return -EINVAL;
 	b->interrupt_enable = !!new;
 
-	affinity_set(b->cpu, &oldmask, &newmask);
+	affinity_set(b->cpu, oldmask, newmask);
 	threshold_restart_bank(b, 0, 0);
-	affinity_restore(&oldmask);
+	affinity_restore(oldmask);
 
 	return end - buf;
 }
@@ -294,7 +294,7 @@ static ssize_t store_threshold_limit(str
 				     const char *buf, size_t count)
 {
 	char *end;
-	cpumask_t oldmask, newmask;
+	cpumask_var_t oldmask, newmask;
 	u16 old;
 	unsigned long new = simple_strtoul(buf, &end, 0);
 	if (end == buf)
@@ -306,9 +306,9 @@ static ssize_t store_threshold_limit(str
 	old = b->threshold_limit;
 	b->threshold_limit = new;
 
-	affinity_set(b->cpu, &oldmask, &newmask);
+	affinity_set(b->cpu, oldmask, newmask);
 	threshold_restart_bank(b, 0, old);
-	affinity_restore(&oldmask);
+	affinity_restore(oldmask);
 
 	return end - buf;
 }
@@ -316,10 +316,11 @@ static ssize_t store_threshold_limit(str
 static ssize_t show_error_count(struct threshold_block *b, char *buf)
 {
 	u32 high, low;
-	cpumask_t oldmask, newmask;
-	affinity_set(b->cpu, &oldmask, &newmask);
+	cpumask_var_t oldmask, newmask;
+
+	affinity_set(b->cpu, oldmask, newmask);
 	rdmsr(b->address, low, high);
-	affinity_restore(&oldmask);
+	affinity_restore(oldmask);
 	return sprintf(buf, "%x\n",
 		       (high & 0xFFF) - (THRESHOLD_MAX - b->threshold_limit));
 }
@@ -327,10 +328,11 @@ static ssize_t show_error_count(struct t
 static ssize_t store_error_count(struct threshold_block *b,
 				 const char *buf, size_t count)
 {
-	cpumask_t oldmask, newmask;
-	affinity_set(b->cpu, &oldmask, &newmask);
+	cpumask_var_t oldmask, newmask;
+
+	affinity_set(b->cpu, oldmask, newmask);
 	threshold_restart_bank(b, 1, 0);
-	affinity_restore(&oldmask);
+	affinity_restore(oldmask);
 	return 1;
 }
 
@@ -468,7 +470,7 @@ static __cpuinit int threshold_create_ba
 {
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
-	cpumask_t oldmask, newmask;
+	cpumask_var_t oldmask, newmask;
 	char name[32];
 
 	sprintf(name, "threshold_bank%i", bank);
@@ -519,10 +521,10 @@ static __cpuinit int threshold_create_ba
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
 
-	affinity_set(cpu, &oldmask, &newmask);
+	affinity_set(cpu, oldmask, newmask);
 	err = allocate_threshold_blocks(cpu, bank, 0,
 					MSR_IA32_MC0_MISC + bank * 4);
-	affinity_restore(&oldmask);
+	affinity_restore(oldmask);
 
 	if (err)
 		goto out_free;
--- struct-cpumasks.orig/arch/x86/kernel/setup_percpu.c
+++ struct-cpumasks/arch/x86/kernel/setup_percpu.c
@@ -41,7 +41,7 @@ DEFINE_EARLY_PER_CPU(int, x86_cpu_to_nod
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
 /* which logical CPUs are on which nodes */
-const cpumask_t node_to_cpumask_map;
+const_cpumask_t node_to_cpumask_map;
 EXPORT_SYMBOL(node_to_cpumask_map);
 
 /* setup node_to_cpumask_map */
@@ -350,16 +350,16 @@ const_cpumask_t node_to_cpumask(int node
 			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
 			node);
 		dump_stack();
-		return (const cpumask_t)cpu_online_map;
+		return (const_cpumask_t)cpu_online_map;
 	}
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
 			"_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
 			node, nr_node_ids);
 		dump_stack();
-		return (const cpumask_t)cpu_mask_none;
+		return (const_cpumask_t)cpu_mask_none;
 	}
-	return (const cpumask_t)&node_to_cpumask_map[node];
+	return (const_cpumask_t)&node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(node_to_cpumask);
 
--- struct-cpumasks.orig/drivers/base/cpu.c
+++ struct-cpumasks/drivers/base/cpu.c
@@ -107,9 +107,9 @@ static SYSDEV_ATTR(crash_notes, 0400, sh
 /*
  * Print cpu online, possible, present, and system maps
  */
-static ssize_t print_cpus_map(char *buf, cpumask_t *map)
+static ssize_t print_cpus_map(char *buf, const_cpumask_t map)
 {
-	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, *map);
+	int n = cpulist_scnprintf(buf, PAGE_SIZE-2, map);
 
 	buf[n++] = '\n';
 	buf[n] = '\0';
@@ -119,7 +119,7 @@ static ssize_t print_cpus_map(char *buf,
 #define	print_cpus_func(type) \
 static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
 {									\
-	return print_cpus_map(buf, &cpu_##type##_map);			\
+	return print_cpus_map(buf, cpu_##type##_map);			\
 }									\
 static struct sysdev_class_attribute attr_##type##_map = 		\
 	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
--- struct-cpumasks.orig/include/linux/cpuset.h
+++ struct-cpumasks/include/linux/cpuset.h
@@ -20,8 +20,8 @@ extern int number_of_cpusets;	/* How man
 extern int cpuset_init_early(void);
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_cpus_allowed(struct task_struct *p, cpumask_t *mask);
-extern void cpuset_cpus_allowed_locked(struct task_struct *p, cpumask_t *mask);
+extern void cpuset_cpus_allowed(struct task_struct *p, cpumask_t mask);
+extern void cpuset_cpus_allowed_locked(struct task_struct *p, cpumask_t mask);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -86,14 +86,14 @@ static inline int cpuset_init_early(void
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
-static inline void cpuset_cpus_allowed(struct task_struct *p, cpumask_t *mask)
+static inline void cpuset_cpus_allowed(struct task_struct *p, cpumask_t mask)
 {
-	*mask = cpu_possible_map;
+	cpus_copy(mask, cpu_possible_map);
 }
 static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
-								cpumask_t *mask)
+								cpumask_t mask)
 {
-	*mask = cpu_possible_map;
+	cpus_copy(mask, cpu_possible_map);
 }
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
--- struct-cpumasks.orig/include/linux/percpu.h
+++ struct-cpumasks/include/linux/percpu.h
@@ -96,14 +96,15 @@ struct percpu_data {
         (__typeof__(ptr))__p->ptrs[(cpu)];	          \
 })
 
-extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
+extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, const_cpumask_t mask);
 extern void percpu_free(void *__pdata);
 
 #else /* CONFIG_SMP */
 
 #define percpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static __always_inline void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
+static __always_inline void *__percpu_alloc_mask(size_t size, gfp_t gfp,
+						const_cpumask_t mask)
 {
 	return kzalloc(size, gfp);
 }
@@ -116,7 +117,7 @@ static inline void percpu_free(void *__p
 #endif /* CONFIG_SMP */
 
 #define percpu_alloc_mask(size, gfp, mask) \
-	__percpu_alloc_mask((size), (gfp), &(mask))
+	__percpu_alloc_mask((size), (gfp), mask)
 
 #define percpu_alloc(size, gfp) percpu_alloc_mask((size), (gfp), cpu_online_map)
 
--- struct-cpumasks.orig/kernel/cpu.c
+++ struct-cpumasks/kernel/cpu.c
@@ -21,7 +21,7 @@
  * as new cpu's are detected in the system via any platform specific
  * method, such as ACPI for e.g.
  */
-cpumask_t cpu_present_map __read_mostly;
+cpumask_map_t cpu_present_map __read_mostly;
 EXPORT_SYMBOL(cpu_present_map);
 
 #if NR_CPUS > BITS_PER_LONG
@@ -34,10 +34,10 @@ EXPORT_SYMBOL(cpu_mask_all);
 /*
  * Represents all cpu's that are currently online.
  */
-cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
+cpumask_map_t cpu_online_map __read_mostly = CPU_MASK_ALL;
 EXPORT_SYMBOL(cpu_online_map);
 
-cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
+cpumask_map_t cpu_possible_map __read_mostly = CPU_MASK_ALL;
 EXPORT_SYMBOL(cpu_possible_map);
 
 #else /* CONFIG_SMP */
@@ -69,7 +69,7 @@ void __init cpu_hotplug_init(void)
 	cpu_hotplug.refcount = 0;
 }
 
-cpumask_t cpu_active_map;
+cpumask_map_t cpu_active_map;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
@@ -222,7 +222,7 @@ static int __ref take_cpu_down(void *_pa
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	cpumask_t old_allowed, tmp;
+	cpumask_var_t old_allowed, tmp;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
@@ -250,13 +250,13 @@ static int __ref _cpu_down(unsigned int 
 	}
 
 	/* Ensure that we are not runnable on dying cpu */
-	old_allowed = current->cpus_allowed;
+	cpus_copy(old_allowed, current->cpus_allowed);
 	cpus_setall(tmp);
 	cpu_clear(cpu, tmp);
-	set_cpus_allowed(current, &tmp);
-	tmp = cpumask_of_cpu(cpu);
+	set_cpus_allowed(current, tmp);
+	cpus_copy(tmp, cpumask_of_cpu(cpu));
 
-	err = __stop_machine(take_cpu_down, &tcd_param, &tmp);
+	err = __stop_machine(take_cpu_down, &tcd_param, tmp);
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
 		if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
@@ -282,7 +282,7 @@ static int __ref _cpu_down(unsigned int 
 	check_for_tasks(cpu);
 
 out_allowed:
-	set_cpus_allowed(current, &old_allowed);
+	set_cpus_allowed(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -397,21 +397,21 @@ out:
 }
 
 #ifdef CONFIG_PM_SLEEP_SMP
-static cpumask_t frozen_cpus;
+static cpumask_map_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, cpus_first, error = 0;
+	int cpu, first_cpu, error = 0;
 
 	cpu_maps_update_begin();
-	cpus_first = cpus_first(cpu_online_map);
+	first_cpu = cpus_first(cpu_online_map);
 	/* We take down all of the non-boot CPUs in one shot to avoid races
 	 * with the userspace trying to use the CPU hotplug at the same time
 	 */
 	cpus_clear(frozen_cpus);
 	printk("Disabling non-boot CPUs ...\n");
 	for_each_online_cpu(cpu) {
-		if (cpu == cpus_first)
+		if (cpu == first_cpu)
 			continue;
 		error = _cpu_down(cpu, 1);
 		if (!error) {
--- struct-cpumasks.orig/kernel/cpuset.c
+++ struct-cpumasks/kernel/cpuset.c
@@ -83,7 +83,7 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
-	cpumask_t cpus_allowed;		/* CPUs allowed to tasks in cpuset */
+	cpumask_map_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
 	struct cpuset *parent;		/* my parent */
@@ -279,15 +279,15 @@ static struct file_system_type cpuset_fs
  * Call with callback_mutex held.
  */
 
-static void guarantee_online_cpus(const struct cpuset *cs, cpumask_t *pmask)
+static void guarantee_online_cpus(const struct cpuset *cs, cpumask_t pmask)
 {
 	while (cs && !cpus_intersects(cs->cpus_allowed, cpu_online_map))
 		cs = cs->parent;
 	if (cs)
-		cpus_and(*pmask, cs->cpus_allowed, cpu_online_map);
+		cpus_and(pmask, cs->cpus_allowed, cpu_online_map);
 	else
-		*pmask = cpu_online_map;
-	BUG_ON(!cpus_intersects(*pmask, cpu_online_map));
+		cpus_copy(pmask, cpu_online_map);
+	BUG_ON(!cpus_intersects(pmask, cpu_online_map));
 }
 
 /*
@@ -574,7 +574,7 @@ update_domain_attr_tree(struct sched_dom
  *	element of the partition (one sched domain) to be passed to
  *	partition_sched_domains().
  */
-static int generate_sched_domains(cpumask_t **domains,
+static int generate_sched_domains(cpumask_t domains,
 			struct sched_domain_attr **attributes)
 {
 	LIST_HEAD(q);		/* queue of cpusets to be scanned */
@@ -582,7 +582,7 @@ static int generate_sched_domains(cpumas
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
 	int i, j, k;		/* indices for partition finding loops */
-	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
+	cpumask_t doms;		/* resulting partition; i.e. sched domains */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
@@ -594,7 +594,7 @@ static int generate_sched_domains(cpumas
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (is_sched_load_balance(&top_cpuset)) {
-		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+		doms = kmalloc(cpumask_size(), GFP_KERNEL);
 		if (!doms)
 			goto done;
 
@@ -603,7 +603,7 @@ static int generate_sched_domains(cpumas
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		*doms = top_cpuset.cpus_allowed;
+		cpus_copy(doms, top_cpuset.cpus_allowed);
 
 		ndoms = 1;
 		goto done;
@@ -673,7 +673,7 @@ restart:
 	 * Now we know how many domains to create.
 	 * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
 	 */
-	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
+	doms = kmalloc(ndoms * cpumask_size(), GFP_KERNEL);
 	if (!doms) {
 		ndoms = 0;
 		goto done;
@@ -687,7 +687,7 @@ restart:
 
 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
-		cpumask_t *dp;
+		cpumask_var_t dp;
 		int apn = a->pn;
 
 		if (apn < 0) {
@@ -695,7 +695,7 @@ restart:
 			continue;
 		}
 
-		dp = doms + nslot;
+		cpus_copy(dp, doms + nslot);
 
 		if (nslot == ndoms) {
 			static int warnings = 10;
@@ -710,14 +710,14 @@ restart:
 			continue;
 		}
 
-		cpus_clear(*dp);
+		cpus_clear(dp);
 		if (dattr)
 			*(dattr + nslot) = SD_ATTR_INIT;
 		for (j = i; j < csn; j++) {
 			struct cpuset *b = csa[j];
 
 			if (apn == b->pn) {
-				cpus_or(*dp, *dp, b->cpus_allowed);
+				cpus_or(dp, dp, b->cpus_allowed);
 				if (dattr)
 					update_domain_attr_tree(dattr + nslot, b);
 
@@ -732,7 +732,7 @@ restart:
 done:
 	kfree(csa);
 
-	*domains    = doms;
+	cpus_copy(domains, doms);
 	*attributes = dattr;
 	return ndoms;
 }
@@ -750,14 +750,14 @@ done:
 static void do_rebuild_sched_domains(struct work_struct *unused)
 {
 	struct sched_domain_attr *attr;
-	cpumask_t *doms;
+	cpumask_var_t doms;
 	int ndoms;
 
 	get_online_cpus();
 
 	/* Generate domain masks and attrs */
 	cgroup_lock();
-	ndoms = generate_sched_domains(&doms, &attr);
+	ndoms = generate_sched_domains(doms, &attr);
 	cgroup_unlock();
 
 	/* Have scheduler rebuild the domains */
@@ -837,7 +837,7 @@ static int cpuset_test_cpumask(struct ta
 static void cpuset_change_cpumask(struct task_struct *tsk,
 				  struct cgroup_scanner *scan)
 {
-	set_cpus_allowed(tsk, &((cgroup_cs(scan->cg))->cpus_allowed));
+	set_cpus_allowed(tsk, ((cgroup_cs(scan->cg))->cpus_allowed));
 }
 
 /**
@@ -913,7 +913,7 @@ static int update_cpumask(struct cpuset 
 	is_load_balanced = is_sched_load_balance(&trialcs);
 
 	mutex_lock(&callback_mutex);
-	cs->cpus_allowed = trialcs.cpus_allowed;
+	cpus_copy(cs->cpus_allowed, trialcs.cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1305,10 +1305,10 @@ static int cpuset_can_attach(struct cgro
 	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
 	if (tsk->flags & PF_THREAD_BOUND) {
-		cpumask_t mask;
+		cpumask_var_t mask;
 
 		mutex_lock(&callback_mutex);
-		mask = cs->cpus_allowed;
+		cpus_copy(mask, cs->cpus_allowed);
 		mutex_unlock(&callback_mutex);
 		if (!cpus_equal(tsk->cpus_allowed, mask))
 			return -EINVAL;
@@ -1321,7 +1321,7 @@ static void cpuset_attach(struct cgroup_
 			  struct cgroup *cont, struct cgroup *oldcont,
 			  struct task_struct *tsk)
 {
-	cpumask_t cpus;
+	cpumask_var_t cpus;
 	nodemask_t from, to;
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
@@ -1329,8 +1329,8 @@ static void cpuset_attach(struct cgroup_
 	int err;
 
 	mutex_lock(&callback_mutex);
-	guarantee_online_cpus(cs, &cpus);
-	err = set_cpus_allowed(tsk, &cpus);
+	guarantee_online_cpus(cs, cpus);
+	err = set_cpus_allowed(tsk, cpus);
 	mutex_unlock(&callback_mutex);
 	if (err)
 		return;
@@ -1472,10 +1472,10 @@ static int cpuset_write_resmask(struct c
 
 static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 
 	mutex_lock(&callback_mutex);
-	mask = cs->cpus_allowed;
+	cpus_copy(mask, cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	return cpulist_scnprintf(page, PAGE_SIZE, mask);
@@ -1714,7 +1714,7 @@ static void cpuset_post_clone(struct cgr
 	parent_cs = cgroup_cs(parent);
 
 	cs->mems_allowed = parent_cs->mems_allowed;
-	cs->cpus_allowed = parent_cs->cpus_allowed;
+	cpus_copy(cs->cpus_allowed, parent_cs->cpus_allowed);
 	return;
 }
 
@@ -1980,7 +1980,7 @@ static int cpuset_track_online_cpus(stru
 				unsigned long phase, void *unused_cpu)
 {
 	struct sched_domain_attr *attr;
-	cpumask_t *doms;
+	cpumask_var_t doms;
 	int ndoms;
 
 	switch (phase) {
@@ -1995,9 +1995,9 @@ static int cpuset_track_online_cpus(stru
 	}
 
 	cgroup_lock();
-	top_cpuset.cpus_allowed = cpu_online_map;
+	cpus_copy(top_cpuset.cpus_allowed, cpu_online_map);
 	scan_for_empty_cpusets(&top_cpuset);
-	ndoms = generate_sched_domains(&doms, &attr);
+	ndoms = generate_sched_domains(doms, &attr);
 	cgroup_unlock();
 
 	/* Have scheduler rebuild the domains */
@@ -2029,7 +2029,7 @@ void cpuset_track_online_nodes(void)
 
 void __init cpuset_init_smp(void)
 {
-	top_cpuset.cpus_allowed = cpu_online_map;
+	cpus_copy(top_cpuset.cpus_allowed, cpu_online_map);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	hotcpu_notifier(cpuset_track_online_cpus, 0);
@@ -2046,7 +2046,7 @@ void __init cpuset_init_smp(void)
  * tasks cpuset.
  **/
 
-void cpuset_cpus_allowed(struct task_struct *tsk, cpumask_t *pmask)
+void cpuset_cpus_allowed(struct task_struct *tsk, cpumask_t pmask)
 {
 	mutex_lock(&callback_mutex);
 	cpuset_cpus_allowed_locked(tsk, pmask);
@@ -2057,7 +2057,7 @@ void cpuset_cpus_allowed(struct task_str
  * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
  * Must be called with callback_mutex held.
  **/
-void cpuset_cpus_allowed_locked(struct task_struct *tsk, cpumask_t *pmask)
+void cpuset_cpus_allowed_locked(struct task_struct *tsk, cpumask_t pmask)
 {
 	task_lock(tsk);
 	guarantee_online_cpus(task_cs(tsk), pmask);

-- 
