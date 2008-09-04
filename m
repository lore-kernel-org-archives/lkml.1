Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbYIDNxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbYIDNxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbYIDNw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:52:56 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:59155
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756397AbYIDNwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:52:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/4] Revert "sched: zap the migration init / cache-hot
	balancing code"
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: peterz@infradead.org, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, mingo@elte.hu
Date: Thu, 04 Sep 2008 09:50:29 -0400
Message-ID: <20080904135028.26109.24290.stgit@dev.haskins.net>
In-Reply-To: <20080904134959.26109.90529.stgit@dev.haskins.net>
References: <20080904134959.26109.90529.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From commit: 0437e109e1841607f2988891eaa36c531c6aa6ac

We want to restore the concept of using empirical cache_hot data for
managing migrations.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 Documentation/kernel-parameters.txt |   43 +++
 arch/ia64/kernel/setup.c            |    6 
 arch/mips/kernel/smp.c              |   11 +
 arch/sparc/kernel/smp.c             |   10 +
 arch/sparc64/kernel/smp.c           |   27 ++
 arch/x86/kernel/smpboot.c           |   12 +
 include/linux/sched.h               |    6 
 kernel/sched.c                      |  483 +++++++++++++++++++++++++++++++++++
 8 files changed, 598 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1150444..6e7b78f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1247,6 +1247,49 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	mga=		[HW,DRM]
 
+	migration_cost=
+			[KNL,SMP] debug: override scheduler migration costs
+			Format: <level-1-usecs>,<level-2-usecs>,...
+			This debugging option can be used to override the
+			default scheduler migration cost matrix. The numbers
+			are indexed by 'CPU domain distance'.
+			E.g. migration_cost=1000,2000,3000 on an SMT NUMA
+			box will set up an intra-core migration cost of
+			1 msec, an inter-core migration cost of 2 msecs,
+			and an inter-node migration cost of 3 msecs.
+
+			WARNING: using the wrong values here can break
+			scheduler performance, so it's only for scheduler
+			development purposes, not production environments.
+
+	migration_debug=
+			[KNL,SMP] migration cost auto-detect verbosity
+			Format=<0|1|2>
+			If a system's migration matrix reported at bootup
+			seems erroneous then this option can be used to
+			increase verbosity of the detection process.
+			We default to 0 (no extra messages), 1 will print
+			some more information, and 2 will be really
+			verbose (probably only useful if you also have a
+			serial console attached to the system).
+
+	migration_factor=
+			[KNL,SMP] multiply/divide migration costs by a factor
+			Format=<percent>
+			This debug option can be used to proportionally
+			increase or decrease the auto-detected migration
+			costs for all entries of the migration matrix.
+			E.g. migration_factor=150 will increase migration
+			costs by 50%. (and thus the scheduler will be less
+			eager migrating cache-hot tasks)
+			migration_factor=80 will decrease migration costs
+			by 20%. (thus the scheduler will be more eager to
+			migrate tasks)
+
+			WARNING: using the wrong values here can break
+			scheduler performance, so it's only for scheduler
+			development purposes, not production environments.
+
 	mminit_loglevel=
 			[KNL] When CONFIG_DEBUG_MEMORY_INIT is set, this
 			parameter allows control of the logging verbosity for
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index c0050ab..d2e1724 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -854,6 +854,7 @@ static void __cpuinit
 get_max_cacheline_size (void)
 {
 	unsigned long line_size, max = 1;
+	unsigned int cache_size = 0;
 	u64 l, levels, unique_caches;
         pal_cache_config_info_t cci;
         s64 status;
@@ -883,6 +884,8 @@ get_max_cacheline_size (void)
 		line_size = 1 << cci.pcci_line_size;
 		if (line_size > max)
 			max = line_size;
+		if (cache_size < cci.pcci_cache_size)
+			cache_size = cci.pcci_cache_size;
 		if (!cci.pcci_unified) {
 			status = ia64_pal_cache_config_info(l,
 						    /* cache_type (instruction)= */ 1,
@@ -899,6 +902,9 @@ get_max_cacheline_size (void)
 			ia64_i_cache_stride_shift = cci.pcci_stride;
 	}
   out:
+#ifdef CONFIG_SMP
+	max_cache_size = max(max_cache_size, cache_size);
+#endif
 	if (max > ia64_max_cacheline_size)
 		ia64_max_cacheline_size = max;
 }
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 4410f17..cb63c56 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -53,6 +53,16 @@ int __cpu_logical_map[NR_CPUS];		/* Map logical to physical */
 EXPORT_SYMBOL(phys_cpu_present_map);
 EXPORT_SYMBOL(cpu_online_map);
 
+/* This happens early in bootup, can't really do it better */
+static void smp_tune_scheduling (void)
+{
+ 	struct cache_desc *cd = &current_cpu_data.scache;
+ 	unsigned long cachesize = cd->linesz * cd->sets * cd->ways;
+	
+ 	if (cachesize > max_cache_size)
+ 		max_cache_size = cachesize;
+}
+ 
 extern void cpu_idle(void);
 
 /* Number of TCs (or siblings in Intel speak) per CPU core */
@@ -181,6 +191,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 {
 	init_new_context(current, &init_mm);
 	current_thread_info()->cpu = 0;
+	smp_tune_scheduling();
 	mp_ops->prepare_cpus(max_cpus);
 	set_cpu_sibling_map(0);
 #ifndef CONFIG_HOTPLUG_CPU
diff --git a/arch/sparc/kernel/smp.c b/arch/sparc/kernel/smp.c
index 1619ec1..44a0448 100644
--- a/arch/sparc/kernel/smp.c
+++ b/arch/sparc/kernel/smp.c
@@ -63,6 +63,16 @@ void __cpuinit smp_store_cpu_info(int id)
 	cpu_data(id).prom_node = cpu_node;
 	cpu_data(id).mid = cpu_get_hwmid(cpu_node);
 
+	/* this is required to tune the scheduler correctly */
+	/* is it possible to have CPUs with different cache sizes? */
+	if (id == boot_cpu_id) {
+		int cache_line,cache_nlines;
+		cache_line = 0x20;
+		cache_line = prom_getintdefault(cpu_node, "ecache-line-size", cache_line);
+		cache_nlines = 0x8000;
+		cache_nlines = prom_getintdefault(cpu_node, "ecache-nlines", cache_nlines);
+		max_cache_size = cache_line * cache_nlines;
+	}
 	if (cpu_data(id).mid < 0)
 		panic("No MID found for CPU%d at node 0x%08d", id, cpu_node);
 }
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index 743ccad..926072b 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -1174,8 +1174,35 @@ int setup_profiling_timer(unsigned int multiplier)
 	return -EINVAL;
 }
 
+static void __init smp_tune_scheduling(void)
+{
+	unsigned int smallest = ~0U;
+	int i;
+
+	for (i = 0; i < NR_CPUS; i++) {
+		unsigned int val = cpu_data(i).ecache_size;
+
+		if (val && val < smallest)
+			smallest = val;
+	}
+
+	/* Any value less than 256K is nonsense.  */
+	if (smallest < (256U * 1024U))
+		smallest = 256 * 1024;
+
+	max_cache_size = smallest;
+
+	if (smallest < 1U * 1024U * 1024U)
+		printk(KERN_INFO "Using max_cache_size of %uKB\n",
+		       smallest / 1024U);
+	else
+		printk(KERN_INFO "Using max_cache_size of %uMB\n",
+		       smallest / 1024U / 1024U);
+}
+
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
+	smp_tune_scheduling();
 }
 
 void __devinit smp_prepare_boot_cpu(void)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7985c5b..c98fdc5 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1029,6 +1029,17 @@ int __cpuinit native_cpu_up(unsigned int cpu)
 	return 0;
 }
 
+static void smp_tune_scheduling(void)
+{
+	if (cpu_khz) {
+		/* cache size in kB */
+		long cachesize = boot_cpu_data.x86_cache_size;
+
+		if (cachesize > 0)
+			max_cache_size = cachesize * 1024;
+	}
+}
+
 /*
  * Fall back to non SMP mode after errors.
  *
@@ -1177,6 +1188,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	smp_store_cpu_info(0); /* Final full version of the data */
 	boot_cpu_logical_apicid = logical_smp_processor_id();
 	current_thread_info()->cpu = 0;  /* needed? */
+	smp_tune_scheduling();
 	set_cpu_sibling_map(0);
 
 	if (smp_sanity_check(max_cpus) < 0) {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5619f3c..5046e3a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -831,6 +831,12 @@ extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
 
+/*
+ * Maximum cache size the migration-costs auto-tuning code will
+ * search from:
+ */
+extern unsigned int max_cache_size;
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
diff --git a/kernel/sched.c b/kernel/sched.c
index 0ca5218..fd28b64 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6838,6 +6838,483 @@ init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
 
 #define SD_NODES_PER_DOMAIN 16
 
+/*
+ * Self-tuning task migration cost measurement between source and target CPUs.
+ *
+ * This is done by measuring the cost of manipulating buffers of varying
+ * sizes. For a given buffer-size here are the steps that are taken:
+ *
+ * 1) the source CPU reads+dirties a shared buffer
+ * 2) the target CPU reads+dirties the same shared buffer
+ *
+ * We measure how long they take, in the following 4 scenarios:
+ *
+ *  - source: CPU1, target: CPU2 | cost1
+ *  - source: CPU2, target: CPU1 | cost2
+ *  - source: CPU1, target: CPU1 | cost3
+ *  - source: CPU2, target: CPU2 | cost4
+ *
+ * We then calculate the cost3+cost4-cost1-cost2 difference - this is
+ * the cost of migration.
+ *
+ * We then start off from a small buffer-size and iterate up to larger
+ * buffer sizes, in 5% steps - measuring each buffer-size separately, and
+ * doing a maximum search for the cost. (The maximum cost for a migration
+ * normally occurs when the working set size is around the effective cache
+ * size.)
+ */
+#define SEARCH_SCOPE		2
+#define MIN_CACHE_SIZE		(64*1024U)
+#define DEFAULT_CACHE_SIZE	(5*1024*1024U)
+#define ITERATIONS		1
+#define SIZE_THRESH		130
+#define COST_THRESH		130
+
+/*
+ * The migration cost is a function of 'domain distance'. Domain
+ * distance is the number of steps a CPU has to iterate down its
+ * domain tree to share a domain with the other CPU. The farther
+ * two CPUs are from each other, the larger the distance gets.
+ *
+ * Note that we use the distance only to cache measurement results,
+ * the distance value is not used numerically otherwise. When two
+ * CPUs have the same distance it is assumed that the migration
+ * cost is the same. (this is a simplification but quite practical)
+ */
+#define MAX_DOMAIN_DISTANCE 32
+
+static unsigned long long migration_cost[MAX_DOMAIN_DISTANCE] =
+		{ [ 0 ... MAX_DOMAIN_DISTANCE-1 ] =
+/*
+ * Architectures may override the migration cost and thus avoid
+ * boot-time calibration. Unit is nanoseconds. Mostly useful for
+ * virtualized hardware:
+ */
+#ifdef CONFIG_DEFAULT_MIGRATION_COST
+			CONFIG_DEFAULT_MIGRATION_COST
+#else
+			-1LL
+#endif
+};
+
+/*
+ * Allow override of migration cost - in units of microseconds.
+ * E.g. migration_cost=1000,2000,3000 will set up a level-1 cost
+ * of 1 msec, level-2 cost of 2 msecs and level3 cost of 3 msecs:
+ */
+static int __init migration_cost_setup(char *str)
+{
+	int ints[MAX_DOMAIN_DISTANCE+1], i;
+
+	str = get_options(str, ARRAY_SIZE(ints), ints);
+
+	printk("#ints: %d\n", ints[0]);
+	for (i = 1; i <= ints[0]; i++) {
+		migration_cost[i-1] = (unsigned long long)ints[i]*1000;
+		printk("migration_cost[%d]: %Ld\n", i-1, migration_cost[i-1]);
+	}
+	return 1;
+}
+
+__setup ("migration_cost=", migration_cost_setup);
+
+/*
+ * Global multiplier (divisor) for migration-cutoff values,
+ * in percentiles. E.g. use a value of 150 to get 1.5 times
+ * longer cache-hot cutoff times.
+ *
+ * (We scale it from 100 to 128 to long long handling easier.)
+ */
+
+#define MIGRATION_FACTOR_SCALE 128
+
+static unsigned int migration_factor = MIGRATION_FACTOR_SCALE;
+
+static int __init setup_migration_factor(char *str)
+{
+	get_option(&str, &migration_factor);
+	migration_factor = migration_factor * MIGRATION_FACTOR_SCALE / 100;
+	return 1;
+}
+
+__setup("migration_factor=", setup_migration_factor);
+
+/*
+ * Estimated distance of two CPUs, measured via the number of domains
+ * we have to pass for the two CPUs to be in the same span:
+ */
+static unsigned long domain_distance(int cpu1, int cpu2)
+{
+	unsigned long distance = 0;
+	struct sched_domain *sd;
+
+	for_each_domain(cpu1, sd) {
+		WARN_ON(!cpu_isset(cpu1, sd->span));
+		if (cpu_isset(cpu2, sd->span))
+			return distance;
+		distance++;
+	}
+	if (distance >= MAX_DOMAIN_DISTANCE) {
+		WARN_ON(1);
+		distance = MAX_DOMAIN_DISTANCE-1;
+	}
+
+	return distance;
+}
+
+static unsigned int migration_debug;
+
+static int __init setup_migration_debug(char *str)
+{
+	get_option(&str, &migration_debug);
+	return 1;
+}
+
+__setup("migration_debug=", setup_migration_debug);
+
+/*
+ * Maximum cache-size that the scheduler should try to measure.
+ * Architectures with larger caches should tune this up during
+ * bootup. Gets used in the domain-setup code (i.e. during SMP
+ * bootup).
+ */
+unsigned int max_cache_size;
+
+static int __init setup_max_cache_size(char *str)
+{
+	get_option(&str, &max_cache_size);
+	return 1;
+}
+
+__setup("max_cache_size=", setup_max_cache_size);
+
+/*
+ * Dirty a big buffer in a hard-to-predict (for the L2 cache) way. This
+ * is the operation that is timed, so we try to generate unpredictable
+ * cachemisses that still end up filling the L2 cache:
+ */
+static void touch_cache(void *__cache, unsigned long __size)
+{
+	unsigned long size = __size / sizeof(long);
+	unsigned long chunk1 = size / 3;
+	unsigned long chunk2 = 2 * size / 3;
+	unsigned long *cache = __cache;
+	int i;
+
+	for (i = 0; i < size/6; i += 8) {
+		switch (i % 6) {
+			case 0: cache[i]++;
+			case 1: cache[size-1-i]++;
+			case 2: cache[chunk1-i]++;
+			case 3: cache[chunk1+i]++;
+			case 4: cache[chunk2-i]++;
+			case 5: cache[chunk2+i]++;
+		}
+	}
+}
+
+/*
+ * Measure the cache-cost of one task migration. Returns in units of nsec.
+ */
+static unsigned long long
+measure_one(void *cache, unsigned long size, int source, int target)
+{
+	cpumask_t mask, saved_mask;
+	unsigned long long t0, t1, t2, t3, cost;
+
+	saved_mask = current->cpus_allowed;
+
+	/*
+	 * Flush source caches to RAM and invalidate them:
+	 */
+	sched_cacheflush();
+
+	/*
+	 * Migrate to the source CPU:
+	 */
+	mask = cpumask_of_cpu(source);
+	set_cpus_allowed(current, mask);
+	WARN_ON(smp_processor_id() != source);
+
+	/*
+	 * Dirty the working set:
+	 */
+	t0 = sched_clock();
+	touch_cache(cache, size);
+	t1 = sched_clock();
+
+	/*
+	 * Migrate to the target CPU, dirty the L2 cache and access
+	 * the shared buffer. (which represents the working set
+	 * of a migrated task.)
+	 */
+	mask = cpumask_of_cpu(target);
+	set_cpus_allowed(current, mask);
+	WARN_ON(smp_processor_id() != target);
+
+	t2 = sched_clock();
+	touch_cache(cache, size);
+	t3 = sched_clock();
+
+	cost = t1-t0 + t3-t2;
+
+	if (migration_debug >= 2)
+		printk("[%d->%d]: %8Ld %8Ld %8Ld => %10Ld.\n",
+			source, target, t1-t0, t1-t0, t3-t2, cost);
+	/*
+	 * Flush target caches to RAM and invalidate them:
+	 */
+	sched_cacheflush();
+
+	set_cpus_allowed(current, saved_mask);
+
+	return cost;
+}
+
+/*
+ * Measure a series of task migrations and return the average
+ * result. Since this code runs early during bootup the system
+ * is 'undisturbed' and the average latency makes sense.
+ *
+ * The algorithm in essence auto-detects the relevant cache-size,
+ * so it will properly detect different cachesizes for different
+ * cache-hierarchies, depending on how the CPUs are connected.
+ *
+ * Architectures can prime the upper limit of the search range via
+ * max_cache_size, otherwise the search range defaults to 20MB...64K.
+ */
+static unsigned long long
+measure_cost(int cpu1, int cpu2, void *cache, unsigned int size)
+{
+	unsigned long long cost1, cost2;
+	int i;
+
+	/*
+	 * Measure the migration cost of 'size' bytes, over an
+	 * average of 10 runs:
+	 *
+	 * (We perturb the cache size by a small (0..4k)
+	 *  value to compensate size/alignment related artifacts.
+	 *  We also subtract the cost of the operation done on
+	 *  the same CPU.)
+	 */
+	cost1 = 0;
+
+	/*
+	 * dry run, to make sure we start off cache-cold on cpu1,
+	 * and to get any vmalloc pagefaults in advance:
+	 */
+	measure_one(cache, size, cpu1, cpu2);
+	for (i = 0; i < ITERATIONS; i++)
+		cost1 += measure_one(cache, size - i * 1024, cpu1, cpu2);
+
+	measure_one(cache, size, cpu2, cpu1);
+	for (i = 0; i < ITERATIONS; i++)
+		cost1 += measure_one(cache, size - i * 1024, cpu2, cpu1);
+
+	/*
+	 * (We measure the non-migrating [cached] cost on both
+	 *  cpu1 and cpu2, to handle CPUs with different speeds)
+	 */
+	cost2 = 0;
+
+	measure_one(cache, size, cpu1, cpu1);
+	for (i = 0; i < ITERATIONS; i++)
+		cost2 += measure_one(cache, size - i * 1024, cpu1, cpu1);
+
+	measure_one(cache, size, cpu2, cpu2);
+	for (i = 0; i < ITERATIONS; i++)
+		cost2 += measure_one(cache, size - i * 1024, cpu2, cpu2);
+
+	/*
+	 * Get the per-iteration migration cost:
+	 */
+	do_div(cost1, 2 * ITERATIONS);
+	do_div(cost2, 2 * ITERATIONS);
+
+	return cost1 - cost2;
+}
+
+static unsigned long long measure_migration_cost(int cpu1, int cpu2)
+{
+	unsigned long long max_cost = 0, fluct = 0, avg_fluct = 0;
+	unsigned int max_size, size, size_found = 0;
+	long long cost = 0, prev_cost;
+	void *cache;
+
+	/*
+	 * Search from max_cache_size*5 down to 64K - the real relevant
+	 * cachesize has to lie somewhere inbetween.
+	 */
+	if (max_cache_size) {
+		max_size = max(max_cache_size * SEARCH_SCOPE, MIN_CACHE_SIZE);
+		size = max(max_cache_size / SEARCH_SCOPE, MIN_CACHE_SIZE);
+	} else {
+		/*
+		 * Since we have no estimation about the relevant
+		 * search range
+		 */
+		max_size = DEFAULT_CACHE_SIZE * SEARCH_SCOPE;
+		size = MIN_CACHE_SIZE;
+	}
+
+	if (!cpu_online(cpu1) || !cpu_online(cpu2)) {
+		printk("cpu %d and %d not both online!\n", cpu1, cpu2);
+		return 0;
+	}
+
+	/*
+	 * Allocate the working set:
+	 */
+	cache = vmalloc(max_size);
+	if (!cache) {
+		printk("could not vmalloc %d bytes for cache!\n", 2 * max_size);
+		return 1000000; /* return 1 msec on very small boxen */
+	}
+
+	while (size <= max_size) {
+		prev_cost = cost;
+		cost = measure_cost(cpu1, cpu2, cache, size);
+
+		/*
+		 * Update the max:
+		 */
+		if (cost > 0) {
+			if (max_cost < cost) {
+				max_cost = cost;
+				size_found = size;
+			}
+		}
+		/*
+		 * Calculate average fluctuation, we use this to prevent
+		 * noise from triggering an early break out of the loop:
+		 */
+		fluct = abs(cost - prev_cost);
+		avg_fluct = (avg_fluct + fluct)/2;
+
+		if (migration_debug)
+			printk("-> [%d][%d][%7d] %3ld.%ld [%3ld.%ld] (%ld): "
+				"(%8Ld %8Ld)\n",
+				cpu1, cpu2, size,
+				(long)cost / 1000000,
+				((long)cost / 100000) % 10,
+				(long)max_cost / 1000000,
+				((long)max_cost / 100000) % 10,
+				domain_distance(cpu1, cpu2),
+				cost, avg_fluct);
+
+		/*
+		 * If we iterated at least 20% past the previous maximum,
+		 * and the cost has dropped by more than 20% already,
+		 * (taking fluctuations into account) then we assume to
+		 * have found the maximum and break out of the loop early:
+		 */
+		if (size_found && (size*100 > size_found*SIZE_THRESH))
+			if (cost+avg_fluct <= 0 ||
+				max_cost*100 > (cost+avg_fluct)*COST_THRESH) {
+
+				if (migration_debug)
+					printk("-> found max.\n");
+				break;
+			}
+		/*
+		 * Increase the cachesize in 10% steps:
+		 */
+		size = size * 10 / 9;
+	}
+
+	if (migration_debug)
+		printk("[%d][%d] working set size found: %d, cost: %Ld\n",
+			cpu1, cpu2, size_found, max_cost);
+
+	vfree(cache);
+
+	/*
+	 * A task is considered 'cache cold' if at least 2 times
+	 * the worst-case cost of migration has passed.
+	 *
+	 * (this limit is only listened to if the load-balancing
+	 * situation is 'nice' - if there is a large imbalance we
+	 * ignore it for the sake of CPU utilization and
+	 * processing fairness.)
+	 */
+	return 2 * max_cost * migration_factor / MIGRATION_FACTOR_SCALE;
+}
+
+static void calibrate_migration_costs(const cpumask_t *cpu_map)
+{
+	int cpu1 = -1, cpu2 = -1, cpu, orig_cpu = raw_smp_processor_id();
+	unsigned long j0, j1, distance, max_distance = 0;
+	struct sched_domain *sd;
+
+	j0 = jiffies;
+
+	/*
+	 * First pass - calculate the cacheflush times:
+	 */
+	for_each_cpu_mask(cpu1, *cpu_map) {
+		for_each_cpu_mask(cpu2, *cpu_map) {
+			if (cpu1 == cpu2)
+				continue;
+			distance = domain_distance(cpu1, cpu2);
+			max_distance = max(max_distance, distance);
+			/*
+			 * No result cached yet?
+			 */
+			if (migration_cost[distance] == -1LL)
+				migration_cost[distance] =
+					measure_migration_cost(cpu1, cpu2);
+		}
+	}
+	/*
+	 * Second pass - update the sched domain hierarchy with
+	 * the new cache-hot-time estimations:
+	 */
+	for_each_cpu_mask(cpu, *cpu_map) {
+		distance = 0;
+		for_each_domain(cpu, sd) {
+			sd->cache_hot_time = migration_cost[distance];
+			distance++;
+		}
+	}
+	/*
+	 * Print the matrix:
+	 */
+	if (migration_debug)
+		printk("migration: max_cache_size: %d, cpu: %d MHz:\n",
+			max_cache_size,
+#ifdef CONFIG_X86
+			cpu_khz/1000
+#else
+			-1
+#endif
+		);
+	if (system_state == SYSTEM_BOOTING && num_online_cpus() > 1) {
+		printk("migration_cost=");
+		for (distance = 0; distance <= max_distance; distance++) {
+			if (distance)
+				printk(",");
+			printk("%ld", (long)migration_cost[distance] / 1000);
+		}
+		printk("\n");
+	}
+	j1 = jiffies;
+	if (migration_debug)
+		printk("migration: %ld seconds\n", (j1-j0) / HZ);
+
+	/*
+	 * Move back to the original CPU. NUMA-Q gets confused
+	 * if we migrate to another quad during bootup.
+	 */
+	if (raw_smp_processor_id() != orig_cpu) {
+		cpumask_t mask = cpumask_of_cpu(orig_cpu),
+			saved_mask = current->cpus_allowed;
+
+		set_cpus_allowed(current, mask);
+		set_cpus_allowed(current, saved_mask);
+	}
+}
+
 #ifdef CONFIG_NUMA
 
 /**
@@ -7528,6 +8005,12 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 	}
 
 	SCHED_CPUMASK_FREE((void *)allmasks);
+	
+ 	/*
+ 	 * Tune cache-hot values:
+ 	 */
+ 	calibrate_migration_costs(cpu_map);
+
 	return 0;
 
 #ifdef CONFIG_NUMA

