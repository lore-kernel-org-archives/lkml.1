Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbZGUKbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbZGUKbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZGUKbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:31:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:37065 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbZGUK2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:02 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/20] percpu: move pcpu_lpage_build_unit_map() and pcpul_lpage_dump_cfg() upward
Date: Tue, 21 Jul 2009 19:26:08 +0900
Message-Id: <1248171979-29166-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unit map handling will be generalized and extended and used for
embedding sparse first chunk and other purposes.  Relocate two
unit_map related functions upward in preparation.  This patch just
moves the code without any actual change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |   14 +-
 mm/percpu.c            |  339 ++++++++++++++++++++++++------------------------
 2 files changed, 180 insertions(+), 173 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index d385dbc..570fb18 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -78,6 +78,14 @@ typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);
 typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 
+#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
+extern int __init pcpu_lpage_build_unit_map(
+				size_t reserved_size, ssize_t *dyn_sizep,
+				size_t *unit_sizep, size_t lpage_size,
+				int *unit_map,
+				pcpu_fc_cpu_distance_fn_t cpu_distance_fn);
+#endif
+
 extern size_t __init pcpu_setup_first_chunk(
 				size_t static_size, size_t reserved_size,
 				size_t dyn_size, size_t unit_size,
@@ -97,12 +105,6 @@ extern ssize_t __init pcpu_page_first_chunk(
 #endif
 
 #ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
-extern int __init pcpu_lpage_build_unit_map(
-				size_t reserved_size, ssize_t *dyn_sizep,
-				size_t *unit_sizep, size_t lpage_size,
-				int *unit_map,
-				pcpu_fc_cpu_distance_fn_t cpu_distance_fn);
-
 extern ssize_t __init pcpu_lpage_first_chunk(
 				size_t reserved_size, size_t dyn_size,
 				size_t unit_size, size_t lpage_size,
diff --git a/mm/percpu.c b/mm/percpu.c
index cfdc03e..b3d0ca0 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1231,6 +1231,178 @@ void free_percpu(void *ptr)
 }
 EXPORT_SYMBOL_GPL(free_percpu);
 
+static inline size_t pcpu_calc_fc_sizes(size_t static_size,
+					size_t reserved_size,
+					ssize_t *dyn_sizep)
+{
+	size_t size_sum;
+
+	size_sum = PFN_ALIGN(static_size + reserved_size +
+			     (*dyn_sizep >= 0 ? *dyn_sizep : 0));
+	if (*dyn_sizep != 0)
+		*dyn_sizep = size_sum - static_size - reserved_size;
+
+	return size_sum;
+}
+
+#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
+/**
+ * pcpu_lpage_build_unit_map - build unit_map for large page remapping
+ * @reserved_size: the size of reserved percpu area in bytes
+ * @dyn_sizep: in/out parameter for dynamic size, -1 for auto
+ * @unit_sizep: out parameter for unit size
+ * @unit_map: unit_map to be filled
+ * @cpu_distance_fn: callback to determine distance between cpus
+ *
+ * This function builds cpu -> unit map and determine other parameters
+ * considering needed percpu size, large page size and distances
+ * between CPUs in NUMA.
+ *
+ * CPUs which are of LOCAL_DISTANCE both ways are grouped together and
+ * may share units in the same large page.  The returned configuration
+ * is guaranteed to have CPUs on different nodes on different large
+ * pages and >=75% usage of allocated virtual address space.
+ *
+ * RETURNS:
+ * On success, fills in @unit_map, sets *@dyn_sizep, *@unit_sizep and
+ * returns the number of units to be allocated.  -errno on failure.
+ */
+int __init pcpu_lpage_build_unit_map(size_t reserved_size, ssize_t *dyn_sizep,
+				     size_t *unit_sizep, size_t lpage_size,
+				     int *unit_map,
+				     pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
+{
+	static int group_map[NR_CPUS] __initdata;
+	static int group_cnt[NR_CPUS] __initdata;
+	const size_t static_size = __per_cpu_end - __per_cpu_start;
+	int group_cnt_max = 0;
+	size_t size_sum, min_unit_size, alloc_size;
+	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
+	int last_allocs;
+	unsigned int cpu, tcpu;
+	int group, unit;
+
+	/*
+	 * Determine min_unit_size, alloc_size and max_upa such that
+	 * alloc_size is multiple of lpage_size and is the smallest
+	 * which can accomodate 4k aligned segments which are equal to
+	 * or larger than min_unit_size.
+	 */
+	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, dyn_sizep);
+	min_unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
+
+	alloc_size = roundup(min_unit_size, lpage_size);
+	upa = alloc_size / min_unit_size;
+	while (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
+		upa--;
+	max_upa = upa;
+
+	/* group cpus according to their proximity */
+	for_each_possible_cpu(cpu) {
+		group = 0;
+	next_group:
+		for_each_possible_cpu(tcpu) {
+			if (cpu == tcpu)
+				break;
+			if (group_map[tcpu] == group &&
+			    (cpu_distance_fn(cpu, tcpu) > LOCAL_DISTANCE ||
+			     cpu_distance_fn(tcpu, cpu) > LOCAL_DISTANCE)) {
+				group++;
+				goto next_group;
+			}
+		}
+		group_map[cpu] = group;
+		group_cnt[group]++;
+		group_cnt_max = max(group_cnt_max, group_cnt[group]);
+	}
+
+	/*
+	 * Expand unit size until address space usage goes over 75%
+	 * and then as much as possible without using more address
+	 * space.
+	 */
+	last_allocs = INT_MAX;
+	for (upa = max_upa; upa; upa--) {
+		int allocs = 0, wasted = 0;
+
+		if (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
+			continue;
+
+		for (group = 0; group_cnt[group]; group++) {
+			int this_allocs = DIV_ROUND_UP(group_cnt[group], upa);
+			allocs += this_allocs;
+			wasted += this_allocs * upa - group_cnt[group];
+		}
+
+		/*
+		 * Don't accept if wastage is over 25%.  The
+		 * greater-than comparison ensures upa==1 always
+		 * passes the following check.
+		 */
+		if (wasted > num_possible_cpus() / 3)
+			continue;
+
+		/* and then don't consume more memory */
+		if (allocs > last_allocs)
+			break;
+		last_allocs = allocs;
+		best_upa = upa;
+	}
+	*unit_sizep = alloc_size / best_upa;
+
+	/* assign units to cpus accordingly */
+	unit = 0;
+	for (group = 0; group_cnt[group]; group++) {
+		for_each_possible_cpu(cpu)
+			if (group_map[cpu] == group)
+				unit_map[cpu] = unit++;
+		unit = roundup(unit, best_upa);
+	}
+
+	return unit;	/* unit contains aligned number of units */
+}
+
+static bool __init pcpul_unit_to_cpu(int unit, const int *unit_map,
+				     unsigned int *cpup);
+
+static void __init pcpul_lpage_dump_cfg(const char *lvl, size_t static_size,
+					size_t reserved_size, size_t dyn_size,
+					size_t unit_size, size_t lpage_size,
+					const int *unit_map, int nr_units)
+{
+	int width = 1, v = nr_units;
+	char empty_str[] = "--------";
+	int upl, lpl;	/* units per lpage, lpage per line */
+	unsigned int cpu;
+	int lpage, unit;
+
+	while (v /= 10)
+		width++;
+	empty_str[min_t(int, width, sizeof(empty_str) - 1)] = '\0';
+
+	upl = max_t(int, lpage_size / unit_size, 1);
+	lpl = rounddown_pow_of_two(max_t(int, 60 / (upl * (width + 1) + 2), 1));
+
+	printk("%spcpu-lpage: sta/res/dyn=%zu/%zu/%zu unit=%zu lpage=%zu", lvl,
+	       static_size, reserved_size, dyn_size, unit_size, lpage_size);
+
+	for (lpage = 0, unit = 0; unit < nr_units; unit++) {
+		if (!(unit % upl)) {
+			if (!(lpage++ % lpl)) {
+				printk("\n");
+				printk("%spcpu-lpage: ", lvl);
+			} else
+				printk("| ");
+		}
+		if (pcpul_unit_to_cpu(unit, unit_map, &cpu))
+			printk("%0*d ", width, cpu);
+		else
+			printk("%s ", empty_str);
+	}
+	printk("\n");
+}
+#endif
+
 /**
  * pcpu_setup_first_chunk - initialize the first percpu chunk
  * @static_size: the size of static percpu area in bytes
@@ -1441,20 +1613,6 @@ static int __init percpu_alloc_setup(char *str)
 }
 early_param("percpu_alloc", percpu_alloc_setup);
 
-static inline size_t pcpu_calc_fc_sizes(size_t static_size,
-					size_t reserved_size,
-					ssize_t *dyn_sizep)
-{
-	size_t size_sum;
-
-	size_sum = PFN_ALIGN(static_size + reserved_size +
-			     (*dyn_sizep >= 0 ? *dyn_sizep : 0));
-	if (*dyn_sizep != 0)
-		*dyn_sizep = size_sum - static_size - reserved_size;
-
-	return size_sum;
-}
-
 #if defined(CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK) || \
 	!defined(CONFIG_HAVE_SETUP_PER_CPU_AREA)
 /**
@@ -1637,122 +1795,6 @@ out_free_ar:
 #endif /* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK */
 
 #ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
-/**
- * pcpu_lpage_build_unit_map - build unit_map for large page remapping
- * @reserved_size: the size of reserved percpu area in bytes
- * @dyn_sizep: in/out parameter for dynamic size, -1 for auto
- * @unit_sizep: out parameter for unit size
- * @unit_map: unit_map to be filled
- * @cpu_distance_fn: callback to determine distance between cpus
- *
- * This function builds cpu -> unit map and determine other parameters
- * considering needed percpu size, large page size and distances
- * between CPUs in NUMA.
- *
- * CPUs which are of LOCAL_DISTANCE both ways are grouped together and
- * may share units in the same large page.  The returned configuration
- * is guaranteed to have CPUs on different nodes on different large
- * pages and >=75% usage of allocated virtual address space.
- *
- * RETURNS:
- * On success, fills in @unit_map, sets *@dyn_sizep, *@unit_sizep and
- * returns the number of units to be allocated.  -errno on failure.
- */
-int __init pcpu_lpage_build_unit_map(size_t reserved_size, ssize_t *dyn_sizep,
-				     size_t *unit_sizep, size_t lpage_size,
-				     int *unit_map,
-				     pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
-{
-	static int group_map[NR_CPUS] __initdata;
-	static int group_cnt[NR_CPUS] __initdata;
-	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	int group_cnt_max = 0;
-	size_t size_sum, min_unit_size, alloc_size;
-	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
-	int last_allocs;
-	unsigned int cpu, tcpu;
-	int group, unit;
-
-	/*
-	 * Determine min_unit_size, alloc_size and max_upa such that
-	 * alloc_size is multiple of lpage_size and is the smallest
-	 * which can accomodate 4k aligned segments which are equal to
-	 * or larger than min_unit_size.
-	 */
-	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, dyn_sizep);
-	min_unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
-
-	alloc_size = roundup(min_unit_size, lpage_size);
-	upa = alloc_size / min_unit_size;
-	while (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
-		upa--;
-	max_upa = upa;
-
-	/* group cpus according to their proximity */
-	for_each_possible_cpu(cpu) {
-		group = 0;
-	next_group:
-		for_each_possible_cpu(tcpu) {
-			if (cpu == tcpu)
-				break;
-			if (group_map[tcpu] == group &&
-			    (cpu_distance_fn(cpu, tcpu) > LOCAL_DISTANCE ||
-			     cpu_distance_fn(tcpu, cpu) > LOCAL_DISTANCE)) {
-				group++;
-				goto next_group;
-			}
-		}
-		group_map[cpu] = group;
-		group_cnt[group]++;
-		group_cnt_max = max(group_cnt_max, group_cnt[group]);
-	}
-
-	/*
-	 * Expand unit size until address space usage goes over 75%
-	 * and then as much as possible without using more address
-	 * space.
-	 */
-	last_allocs = INT_MAX;
-	for (upa = max_upa; upa; upa--) {
-		int allocs = 0, wasted = 0;
-
-		if (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
-			continue;
-
-		for (group = 0; group_cnt[group]; group++) {
-			int this_allocs = DIV_ROUND_UP(group_cnt[group], upa);
-			allocs += this_allocs;
-			wasted += this_allocs * upa - group_cnt[group];
-		}
-
-		/*
-		 * Don't accept if wastage is over 25%.  The
-		 * greater-than comparison ensures upa==1 always
-		 * passes the following check.
-		 */
-		if (wasted > num_possible_cpus() / 3)
-			continue;
-
-		/* and then don't consume more memory */
-		if (allocs > last_allocs)
-			break;
-		last_allocs = allocs;
-		best_upa = upa;
-	}
-	*unit_sizep = alloc_size / best_upa;
-
-	/* assign units to cpus accordingly */
-	unit = 0;
-	for (group = 0; group_cnt[group]; group++) {
-		for_each_possible_cpu(cpu)
-			if (group_map[cpu] == group)
-				unit_map[cpu] = unit++;
-		unit = roundup(unit, best_upa);
-	}
-
-	return unit;	/* unit contains aligned number of units */
-}
-
 struct pcpul_ent {
 	void		*ptr;
 	void		*map_addr;
@@ -1778,43 +1820,6 @@ static bool __init pcpul_unit_to_cpu(int unit, const int *unit_map,
 	return false;
 }
 
-static void __init pcpul_lpage_dump_cfg(const char *lvl, size_t static_size,
-					size_t reserved_size, size_t dyn_size,
-					size_t unit_size, size_t lpage_size,
-					const int *unit_map, int nr_units)
-{
-	int width = 1, v = nr_units;
-	char empty_str[] = "--------";
-	int upl, lpl;	/* units per lpage, lpage per line */
-	unsigned int cpu;
-	int lpage, unit;
-
-	while (v /= 10)
-		width++;
-	empty_str[min_t(int, width, sizeof(empty_str) - 1)] = '\0';
-
-	upl = max_t(int, lpage_size / unit_size, 1);
-	lpl = rounddown_pow_of_two(max_t(int, 60 / (upl * (width + 1) + 2), 1));
-
-	printk("%spcpu-lpage: sta/res/dyn=%zu/%zu/%zu unit=%zu lpage=%zu", lvl,
-	       static_size, reserved_size, dyn_size, unit_size, lpage_size);
-
-	for (lpage = 0, unit = 0; unit < nr_units; unit++) {
-		if (!(unit % upl)) {
-			if (!(lpage++ % lpl)) {
-				printk("\n");
-				printk("%spcpu-lpage: ", lvl);
-			} else
-				printk("| ");
-		}
-		if (pcpul_unit_to_cpu(unit, unit_map, &cpu))
-			printk("%0*d ", width, cpu);
-		else
-			printk("%s ", empty_str);
-	}
-	printk("\n");
-}
-
 /**
  * pcpu_lpage_first_chunk - remap the first percpu chunk using large page
  * @reserved_size: the size of reserved percpu area in bytes
-- 
1.6.0.2

