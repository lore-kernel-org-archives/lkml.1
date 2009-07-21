Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZGUK23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZGUK23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbZGUK22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:37050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbZGUK2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:01 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 10/20] percpu: introduce pcpu_alloc_info and pcpu_group_info
Date: Tue, 21 Jul 2009 19:26:09 +0900
Message-Id: <1248171979-29166-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Till now, non-linear cpu->unit map was expressed using an integer
array which maps each cpu to a unit and used only by lpage allocator.
Although how many units have been placed in a single contiguos area
(group) is known while building unit_map, the information is lost when
the result is recorded into the unit_map array.  For lpage allocator,
as all allocations are done by lpages and whether two adjacent lpages
are in the same group or not is irrelevant, this didn't cause any
problem.  Non-linear cpu->unit mapping will be used for sparse
embedding and this grouping information is necessary for that.

This patch introduces pcpu_alloc_info which contains all the
information necessary for initializing percpu allocator.
pcpu_alloc_info contains array of pcpu_group_info which describes how
units are grouped and mapped to cpus.  pcpu_group_info also has
base_offset field to specify its offset from the chunk's base address.
pcpu_build_alloc_info() initializes this field as if all groups are
allocated back-to-back as is currently done but this will be used to
sparsely place groups.

pcpu_alloc_info is a rather complex data structure which contains a
flexible array which in turn points to nested cpu_map arrays.

* pcpu_alloc_alloc_info() and pcpu_free_alloc_info() are provided to
  help dealing with pcpu_alloc_info.

* pcpu_lpage_build_unit_map() is updated to build pcpu_alloc_info,
  generalized and renamed to pcpu_build_alloc_info().
  @cpu_distance_fn may be NULL indicating that all cpus are of
  LOCAL_DISTANCE.

* pcpul_lpage_dump_cfg() is updated to process pcpu_alloc_info,
  generalized and renamed to pcpu_dump_alloc_info().  It now also
  prints which group each alloc unit belongs to.

* pcpu_setup_first_chunk() now takes pcpu_alloc_info instead of the
  separate parameters.  All first chunk allocators are updated to use
  pcpu_build_alloc_info() to build alloc_info and call
  pcpu_setup_first_chunk() with it.  This has the side effect of
  packing units for sparse possible cpus.  ie. if cpus 0, 2 and 4 are
  possible, they'll be assigned unit 0, 1 and 2 instead of 0, 2 and 4.

* x86 setup_pcpu_lpage() is updated to deal with alloc_info.

* sparc64 setup_per_cpu_areas() is updated to build alloc_info.

Although the changes made by this patch are pretty pervasive, it
doesn't cause any behavior difference other than packing of sparse
cpus.  It mostly changes how information is passed among
initialization functions and makes room for more flexibility.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
---
 arch/sparc/kernel/smp_64.c     |   24 ++-
 arch/x86/kernel/setup_percpu.c |   38 ++--
 include/linux/percpu.h         |   42 +++-
 mm/percpu.c                    |  529 +++++++++++++++++++++++++---------------
 4 files changed, 389 insertions(+), 244 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 9856d86..a42a4a7 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1475,17 +1475,29 @@ static void __init pcpu_map_range(unsigned long start, unsigned long end,
 
 void __init setup_per_cpu_areas(void)
 {
-	size_t dyn_size, static_size = __per_cpu_end - __per_cpu_start;
 	static struct vm_struct vm;
+	struct pcpu_alloc_info *ai;
 	unsigned long delta, cpu;
 	size_t size_sum, pcpu_unit_size;
 	size_t ptrs_size;
 	void **ptrs;
 
-	size_sum = PFN_ALIGN(static_size + PERCPU_MODULE_RESERVE +
+	ai = pcpu_alloc_alloc_info(1, nr_cpu_ids);
+
+	ai->static_size = __per_cpu_end - __per_cpu_start;
+	ai->reserved_size = PERCPU_MODULE_RESERVE;
+
+	size_sum = PFN_ALIGN(ai->static_size + ai->reserved_size +
 			     PERCPU_DYNAMIC_RESERVE);
-	dyn_size = size_sum - static_size - PERCPU_MODULE_RESERVE;
 
+	ai->dyn_size = size_sum - ai->static_size - ai->reserved_size;
+	ai->unit_size = PCPU_CHUNK_SIZE;
+	ai->atom_size = PCPU_CHUNK_SIZE;
+	ai->alloc_size = PCPU_CHUNK_SIZE;
+	ai->groups[0].nr_units = nr_cpu_ids;
+
+	for_each_possible_cpu(cpu)
+		ai->groups[0].cpu_map[cpu] = cpu;
 
 	ptrs_size = PFN_ALIGN(nr_cpu_ids * sizeof(ptrs[0]));
 	ptrs = alloc_bootmem(ptrs_size);
@@ -1497,7 +1509,7 @@ void __init setup_per_cpu_areas(void)
 		free_bootmem(__pa(ptrs[cpu] + size_sum),
 			     PCPU_CHUNK_SIZE - size_sum);
 
-		memcpy(ptrs[cpu], __per_cpu_load, static_size);
+		memcpy(ptrs[cpu], __per_cpu_load, ai->static_size);
 	}
 
 	/* allocate address and map */
@@ -1514,9 +1526,7 @@ void __init setup_per_cpu_areas(void)
 		pcpu_map_range(start, end, virt_to_page(ptrs[cpu]));
 	}
 
-	pcpu_unit_size = pcpu_setup_first_chunk(static_size,
-						PERCPU_MODULE_RESERVE, dyn_size,
-						PCPU_CHUNK_SIZE, vm.addr, NULL);
+	pcpu_unit_size = pcpu_setup_first_chunk(ai, vm.addr);
 
 	free_bootmem(__pa(ptrs), ptrs_size);
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 7cc5303..934f285 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -161,9 +161,7 @@ static ssize_t __init setup_pcpu_lpage(bool chosen)
 {
 	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 	size_t dyn_size = reserve - PERCPU_FIRST_CHUNK_RESERVE;
-	size_t unit_map_size, unit_size;
-	int *unit_map;
-	int nr_units;
+	struct pcpu_alloc_info *ai;
 	ssize_t ret;
 
 	/* on non-NUMA, embedding is better */
@@ -177,26 +175,22 @@ static ssize_t __init setup_pcpu_lpage(bool chosen)
 	}
 
 	/* allocate and build unit_map */
-	unit_map_size = num_possible_cpus() * sizeof(int);
-	unit_map = alloc_bootmem_nopanic(unit_map_size);
-	if (!unit_map) {
-		pr_warning("PERCPU: failed to allocate unit_map\n");
-		return -ENOMEM;
+	ai = pcpu_build_alloc_info(PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
+				   PMD_SIZE, pcpu_lpage_cpu_distance);
+	if (IS_ERR(ai)) {
+		pr_warning("PERCPU: failed to build unit_map (%ld)\n",
+			   PTR_ERR(ai));
+		return PTR_ERR(ai);
 	}
 
-	ret = pcpu_lpage_build_unit_map(PERCPU_FIRST_CHUNK_RESERVE,
-					&dyn_size, &unit_size, PMD_SIZE,
-					unit_map, pcpu_lpage_cpu_distance);
-	if (ret < 0) {
-		pr_warning("PERCPU: failed to build unit_map\n");
-		goto out_free;
-	}
-	nr_units = ret;
-
 	/* do the parameters look okay? */
 	if (!chosen) {
 		size_t vm_size = VMALLOC_END - VMALLOC_START;
-		size_t tot_size = nr_units * unit_size;
+		size_t tot_size = 0;
+		int group;
+
+		for (group = 0; group < ai->nr_groups; group++)
+			tot_size += ai->unit_size * ai->groups[group].nr_units;
 
 		/* don't consume more than 20% of vmalloc area */
 		if (tot_size > vm_size / 5) {
@@ -207,12 +201,10 @@ static ssize_t __init setup_pcpu_lpage(bool chosen)
 		}
 	}
 
-	ret = pcpu_lpage_first_chunk(PERCPU_FIRST_CHUNK_RESERVE, dyn_size,
-				     unit_size, PMD_SIZE, unit_map, nr_units,
-				     pcpu_fc_alloc, pcpu_fc_free, pcpul_map);
+	ret = pcpu_lpage_first_chunk(ai, pcpu_fc_alloc, pcpu_fc_free,
+				     pcpul_map);
 out_free:
-	if (ret < 0)
-		free_bootmem(__pa(unit_map), unit_map_size);
+	pcpu_free_alloc_info(ai);
 	return ret;
 }
 #else
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 570fb18..77b86be 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -59,6 +59,25 @@
 extern void *pcpu_base_addr;
 extern const int *pcpu_unit_map;
 
+struct pcpu_group_info {
+	int			nr_units;	/* aligned # of units */
+	unsigned long		base_offset;	/* base address offset */
+	unsigned int		*cpu_map;	/* unit->cpu map, empty
+						 * entries contain NR_CPUS */
+};
+
+struct pcpu_alloc_info {
+	size_t			static_size;
+	size_t			reserved_size;
+	size_t			dyn_size;
+	size_t			unit_size;
+	size_t			atom_size;
+	size_t			alloc_size;
+	size_t			__ai_size;	/* internal, don't use */
+	int			nr_groups;	/* 0 if grouping unnecessary */
+	struct pcpu_group_info	groups[];
+};
+
 enum pcpu_fc {
 	PCPU_FC_AUTO,
 	PCPU_FC_EMBED,
@@ -78,18 +97,17 @@ typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);
 typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 
-#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
-extern int __init pcpu_lpage_build_unit_map(
-				size_t reserved_size, ssize_t *dyn_sizep,
-				size_t *unit_sizep, size_t lpage_size,
-				int *unit_map,
+extern struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
+							     int nr_units);
+extern void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai);
+
+extern struct pcpu_alloc_info * __init pcpu_build_alloc_info(
+				size_t reserved_size, ssize_t dyn_size,
+				size_t atom_size,
 				pcpu_fc_cpu_distance_fn_t cpu_distance_fn);
-#endif
 
-extern size_t __init pcpu_setup_first_chunk(
-				size_t static_size, size_t reserved_size,
-				size_t dyn_size, size_t unit_size,
-				void *base_addr, const int *unit_map);
+extern size_t __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
+					    void *base_addr);
 
 #ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
 extern ssize_t __init pcpu_embed_first_chunk(
@@ -106,9 +124,7 @@ extern ssize_t __init pcpu_page_first_chunk(
 
 #ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
 extern ssize_t __init pcpu_lpage_first_chunk(
-				size_t reserved_size, size_t dyn_size,
-				size_t unit_size, size_t lpage_size,
-				const int *unit_map, int nr_units,
+				const struct pcpu_alloc_info *ai,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_map_fn_t map_fn);
diff --git a/mm/percpu.c b/mm/percpu.c
index b3d0ca0..816cea4 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -58,6 +58,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/bootmem.h>
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/log2.h>
 #include <linux/mm.h>
@@ -1245,53 +1246,108 @@ static inline size_t pcpu_calc_fc_sizes(size_t static_size,
 	return size_sum;
 }
 
-#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
 /**
- * pcpu_lpage_build_unit_map - build unit_map for large page remapping
+ * pcpu_alloc_alloc_info - allocate percpu allocation info
+ * @nr_groups: the number of groups
+ * @nr_units: the number of units
+ *
+ * Allocate ai which is large enough for @nr_groups groups containing
+ * @nr_units units.  The returned ai's groups[0].cpu_map points to the
+ * cpu_map array which is long enough for @nr_units and filled with
+ * NR_CPUS.  It's the caller's responsibility to initialize cpu_map
+ * pointer of other groups.
+ *
+ * RETURNS:
+ * Pointer to the allocated pcpu_alloc_info on success, NULL on
+ * failure.
+ */
+struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
+						      int nr_units)
+{
+	struct pcpu_alloc_info *ai;
+	size_t base_size, ai_size;
+	void *ptr;
+	int unit;
+
+	base_size = ALIGN(sizeof(*ai) + nr_groups * sizeof(ai->groups[0]),
+			  __alignof__(ai->groups[0].cpu_map[0]));
+	ai_size = base_size + nr_units * sizeof(ai->groups[0].cpu_map[0]);
+
+	ptr = alloc_bootmem_nopanic(PFN_ALIGN(ai_size));
+	if (!ptr)
+		return NULL;
+	ai = ptr;
+	ptr += base_size;
+
+	ai->groups[0].cpu_map = ptr;
+
+	for (unit = 0; unit < nr_units; unit++)
+		ai->groups[0].cpu_map[unit] = NR_CPUS;
+
+	ai->nr_groups = nr_groups;
+	ai->__ai_size = PFN_ALIGN(ai_size);
+
+	return ai;
+}
+
+/**
+ * pcpu_free_alloc_info - free percpu allocation info
+ * @ai: pcpu_alloc_info to free
+ *
+ * Free @ai which was allocated by pcpu_alloc_alloc_info().
+ */
+void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
+{
+	free_bootmem(__pa(ai), ai->__ai_size);
+}
+
+/**
+ * pcpu_build_alloc_info - build alloc_info considering distances between CPUs
  * @reserved_size: the size of reserved percpu area in bytes
- * @dyn_sizep: in/out parameter for dynamic size, -1 for auto
- * @unit_sizep: out parameter for unit size
- * @unit_map: unit_map to be filled
- * @cpu_distance_fn: callback to determine distance between cpus
+ * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
+ * @atom_size: allocation atom size
+ * @cpu_distance_fn: callback to determine distance between cpus, optional
  *
- * This function builds cpu -> unit map and determine other parameters
- * considering needed percpu size, large page size and distances
- * between CPUs in NUMA.
+ * This function determines grouping of units, their mappings to cpus
+ * and other parameters considering needed percpu size, allocation
+ * atom size and distances between CPUs.
  *
- * CPUs which are of LOCAL_DISTANCE both ways are grouped together and
- * may share units in the same large page.  The returned configuration
- * is guaranteed to have CPUs on different nodes on different large
- * pages and >=75% usage of allocated virtual address space.
+ * Groups are always mutliples of atom size and CPUs which are of
+ * LOCAL_DISTANCE both ways are grouped together and share space for
+ * units in the same group.  The returned configuration is guaranteed
+ * to have CPUs on different nodes on different groups and >=75% usage
+ * of allocated virtual address space.
  *
  * RETURNS:
- * On success, fills in @unit_map, sets *@dyn_sizep, *@unit_sizep and
- * returns the number of units to be allocated.  -errno on failure.
+ * On success, pointer to the new allocation_info is returned.  On
+ * failure, ERR_PTR value is returned.
  */
-int __init pcpu_lpage_build_unit_map(size_t reserved_size, ssize_t *dyn_sizep,
-				     size_t *unit_sizep, size_t lpage_size,
-				     int *unit_map,
-				     pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
+struct pcpu_alloc_info * __init pcpu_build_alloc_info(
+				size_t reserved_size, ssize_t dyn_size,
+				size_t atom_size,
+				pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
 {
 	static int group_map[NR_CPUS] __initdata;
 	static int group_cnt[NR_CPUS] __initdata;
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	int group_cnt_max = 0;
+	int group_cnt_max = 0, nr_groups = 1, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
 	int upa, max_upa, uninitialized_var(best_upa);	/* units_per_alloc */
-	int last_allocs;
+	int last_allocs, group, unit;
 	unsigned int cpu, tcpu;
-	int group, unit;
+	struct pcpu_alloc_info *ai;
+	unsigned int *cpu_map;
 
 	/*
 	 * Determine min_unit_size, alloc_size and max_upa such that
-	 * alloc_size is multiple of lpage_size and is the smallest
+	 * alloc_size is multiple of atom_size and is the smallest
 	 * which can accomodate 4k aligned segments which are equal to
 	 * or larger than min_unit_size.
 	 */
-	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, dyn_sizep);
+	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
 	min_unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
 
-	alloc_size = roundup(min_unit_size, lpage_size);
+	alloc_size = roundup(min_unit_size, atom_size);
 	upa = alloc_size / min_unit_size;
 	while (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
 		upa--;
@@ -1304,10 +1360,11 @@ int __init pcpu_lpage_build_unit_map(size_t reserved_size, ssize_t *dyn_sizep,
 		for_each_possible_cpu(tcpu) {
 			if (cpu == tcpu)
 				break;
-			if (group_map[tcpu] == group &&
+			if (group_map[tcpu] == group && cpu_distance_fn &&
 			    (cpu_distance_fn(cpu, tcpu) > LOCAL_DISTANCE ||
 			     cpu_distance_fn(tcpu, cpu) > LOCAL_DISTANCE)) {
 				group++;
+				nr_groups = max(nr_groups, group + 1);
 				goto next_group;
 			}
 		}
@@ -1328,7 +1385,7 @@ int __init pcpu_lpage_build_unit_map(size_t reserved_size, ssize_t *dyn_sizep,
 		if (alloc_size % upa || ((alloc_size / upa) & ~PAGE_MASK))
 			continue;
 
-		for (group = 0; group_cnt[group]; group++) {
+		for (group = 0; group < nr_groups; group++) {
 			int this_allocs = DIV_ROUND_UP(group_cnt[group], upa);
 			allocs += this_allocs;
 			wasted += this_allocs * upa - group_cnt[group];
@@ -1348,75 +1405,122 @@ int __init pcpu_lpage_build_unit_map(size_t reserved_size, ssize_t *dyn_sizep,
 		last_allocs = allocs;
 		best_upa = upa;
 	}
-	*unit_sizep = alloc_size / best_upa;
+	upa = best_upa;
+
+	/* allocate and fill alloc_info */
+	for (group = 0; group < nr_groups; group++)
+		nr_units += roundup(group_cnt[group], upa);
+
+	ai = pcpu_alloc_alloc_info(nr_groups, nr_units);
+	if (!ai)
+		return ERR_PTR(-ENOMEM);
+	cpu_map = ai->groups[0].cpu_map;
+
+	for (group = 0; group < nr_groups; group++) {
+		ai->groups[group].cpu_map = cpu_map;
+		cpu_map += roundup(group_cnt[group], upa);
+	}
+
+	ai->static_size = static_size;
+	ai->reserved_size = reserved_size;
+	ai->dyn_size = dyn_size;
+	ai->unit_size = alloc_size / upa;
+	ai->atom_size = atom_size;
+	ai->alloc_size = alloc_size;
+
+	for (group = 0, unit = 0; group_cnt[group]; group++) {
+		struct pcpu_group_info *gi = &ai->groups[group];
+
+		/*
+		 * Initialize base_offset as if all groups are located
+		 * back-to-back.  The caller should update this to
+		 * reflect actual allocation.
+		 */
+		gi->base_offset = unit * ai->unit_size;
 
-	/* assign units to cpus accordingly */
-	unit = 0;
-	for (group = 0; group_cnt[group]; group++) {
 		for_each_possible_cpu(cpu)
 			if (group_map[cpu] == group)
-				unit_map[cpu] = unit++;
-		unit = roundup(unit, best_upa);
+				gi->cpu_map[gi->nr_units++] = cpu;
+		gi->nr_units = roundup(gi->nr_units, upa);
+		unit += gi->nr_units;
 	}
+	BUG_ON(unit != nr_units);
 
-	return unit;	/* unit contains aligned number of units */
+	return ai;
 }
 
-static bool __init pcpul_unit_to_cpu(int unit, const int *unit_map,
-				     unsigned int *cpup);
-
-static void __init pcpul_lpage_dump_cfg(const char *lvl, size_t static_size,
-					size_t reserved_size, size_t dyn_size,
-					size_t unit_size, size_t lpage_size,
-					const int *unit_map, int nr_units)
+/**
+ * pcpu_dump_alloc_info - print out information about pcpu_alloc_info
+ * @lvl: loglevel
+ * @ai: allocation info to dump
+ *
+ * Print out information about @ai using loglevel @lvl.
+ */
+static void pcpu_dump_alloc_info(const char *lvl,
+				 const struct pcpu_alloc_info *ai)
 {
-	int width = 1, v = nr_units;
+	int group_width = 1, cpu_width = 1, width;
 	char empty_str[] = "--------";
-	int upl, lpl;	/* units per lpage, lpage per line */
-	unsigned int cpu;
-	int lpage, unit;
+	int alloc = 0, alloc_end = 0;
+	int group, v;
+	int upa, apl;	/* units per alloc, allocs per line */
+
+	v = ai->nr_groups;
+	while (v /= 10)
+		group_width++;
 
+	v = num_possible_cpus();
 	while (v /= 10)
-		width++;
-	empty_str[min_t(int, width, sizeof(empty_str) - 1)] = '\0';
+		cpu_width++;
+	empty_str[min_t(int, cpu_width, sizeof(empty_str) - 1)] = '\0';
 
-	upl = max_t(int, lpage_size / unit_size, 1);
-	lpl = rounddown_pow_of_two(max_t(int, 60 / (upl * (width + 1) + 2), 1));
+	upa = ai->alloc_size / ai->unit_size;
+	width = upa * (cpu_width + 1) + group_width + 3;
+	apl = rounddown_pow_of_two(max(60 / width, 1));
 
-	printk("%spcpu-lpage: sta/res/dyn=%zu/%zu/%zu unit=%zu lpage=%zu", lvl,
-	       static_size, reserved_size, dyn_size, unit_size, lpage_size);
+	printk("%spcpu-alloc: s%zu r%zu d%zu u%zu alloc=%zu*%zu",
+	       lvl, ai->static_size, ai->reserved_size, ai->dyn_size,
+	       ai->unit_size, ai->alloc_size / ai->atom_size, ai->atom_size);
 
-	for (lpage = 0, unit = 0; unit < nr_units; unit++) {
-		if (!(unit % upl)) {
-			if (!(lpage++ % lpl)) {
+	for (group = 0; group < ai->nr_groups; group++) {
+		const struct pcpu_group_info *gi = &ai->groups[group];
+		int unit = 0, unit_end = 0;
+
+		BUG_ON(gi->nr_units % upa);
+		for (alloc_end += gi->nr_units / upa;
+		     alloc < alloc_end; alloc++) {
+			if (!(alloc % apl)) {
 				printk("\n");
-				printk("%spcpu-lpage: ", lvl);
-			} else
-				printk("| ");
+				printk("%spcpu-alloc: ", lvl);
+			}
+			printk("[%0*d] ", group_width, group);
+
+			for (unit_end += upa; unit < unit_end; unit++)
+				if (gi->cpu_map[unit] != NR_CPUS)
+					printk("%0*d ", cpu_width,
+					       gi->cpu_map[unit]);
+				else
+					printk("%s ", empty_str);
 		}
-		if (pcpul_unit_to_cpu(unit, unit_map, &cpu))
-			printk("%0*d ", width, cpu);
-		else
-			printk("%s ", empty_str);
 	}
 	printk("\n");
 }
-#endif
 
 /**
  * pcpu_setup_first_chunk - initialize the first percpu chunk
- * @static_size: the size of static percpu area in bytes
- * @reserved_size: the size of reserved percpu area in bytes, 0 for none
- * @dyn_size: free size for dynamic allocation in bytes
- * @unit_size: unit size in bytes, must be multiple of PAGE_SIZE
+ * @ai: pcpu_alloc_info describing how to percpu area is shaped
  * @base_addr: mapped address
- * @unit_map: cpu -> unit map, NULL for sequential mapping
  *
  * Initialize the first percpu chunk which contains the kernel static
  * perpcu area.  This function is to be called from arch percpu area
  * setup path.
  *
- * @reserved_size, if non-zero, specifies the amount of bytes to
+ * @ai contains all information necessary to initialize the first
+ * chunk and prime the dynamic percpu allocator.
+ *
+ * @ai->static_size is the size of static percpu area.
+ *
+ * @ai->reserved_size, if non-zero, specifies the amount of bytes to
  * reserve after the static area in the first chunk.  This reserves
  * the first chunk such that it's available only through reserved
  * percpu allocation.  This is primarily used to serve module percpu
@@ -1424,13 +1528,26 @@ static void __init pcpul_lpage_dump_cfg(const char *lvl, size_t static_size,
  * limited offset range for symbol relocations to guarantee module
  * percpu symbols fall inside the relocatable range.
  *
- * @dyn_size determines the number of bytes available for dynamic
- * allocation in the first chunk.  The area between @static_size +
- * @reserved_size + @dyn_size and @unit_size is unused.
+ * @ai->dyn_size determines the number of bytes available for dynamic
+ * allocation in the first chunk.  The area between @ai->static_size +
+ * @ai->reserved_size + @ai->dyn_size and @ai->unit_size is unused.
  *
- * @unit_size specifies unit size and must be aligned to PAGE_SIZE and
- * equal to or larger than @static_size + @reserved_size + if
- * non-negative, @dyn_size.
+ * @ai->unit_size specifies unit size and must be aligned to PAGE_SIZE
+ * and equal to or larger than @ai->static_size + @ai->reserved_size +
+ * @ai->dyn_size.
+ *
+ * @ai->atom_size is the allocation atom size and used as alignment
+ * for vm areas.
+ *
+ * @ai->alloc_size is the allocation size and always multiple of
+ * @ai->atom_size.  This is larger than @ai->atom_size if
+ * @ai->unit_size is larger than @ai->atom_size.
+ *
+ * @ai->nr_groups and @ai->groups describe virtual memory layout of
+ * percpu areas.  Units which should be colocated are put into the
+ * same group.  Dynamic VM areas will be allocated according to these
+ * groupings.  If @ai->nr_groups is zero, a single group containing
+ * all units is assumed.
  *
  * The caller should have mapped the first chunk at @base_addr and
  * copied static data to each unit.
@@ -1446,70 +1563,63 @@ static void __init pcpul_lpage_dump_cfg(const char *lvl, size_t static_size,
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access.
  */
-size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
-				     size_t dyn_size, size_t unit_size,
-				     void *base_addr, const int *unit_map)
+size_t __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
+				     void *base_addr)
 {
 	static struct vm_struct first_vm;
 	static int smap[2], dmap[2];
-	size_t size_sum = static_size + reserved_size + dyn_size;
+	size_t dyn_size = ai->dyn_size;
+	size_t size_sum = ai->static_size + ai->reserved_size + dyn_size;
 	struct pcpu_chunk *schunk, *dchunk = NULL;
-	unsigned int cpu, tcpu;
-	int i;
+	unsigned int cpu;
+	int *unit_map;
+	int group, unit, i;
 
 	/* sanity checks */
 	BUILD_BUG_ON(ARRAY_SIZE(smap) >= PCPU_DFL_MAP_ALLOC ||
 		     ARRAY_SIZE(dmap) >= PCPU_DFL_MAP_ALLOC);
-	BUG_ON(!static_size);
+	BUG_ON(ai->nr_groups <= 0);
+	BUG_ON(!ai->static_size);
 	BUG_ON(!base_addr);
-	BUG_ON(unit_size < size_sum);
-	BUG_ON(unit_size & ~PAGE_MASK);
-	BUG_ON(unit_size < PCPU_MIN_UNIT_SIZE);
+	BUG_ON(ai->unit_size < size_sum);
+	BUG_ON(ai->unit_size & ~PAGE_MASK);
+	BUG_ON(ai->unit_size < PCPU_MIN_UNIT_SIZE);
+
+	pcpu_dump_alloc_info(KERN_DEBUG, ai);
 
 	/* determine number of units and verify and initialize pcpu_unit_map */
-	if (unit_map) {
-		int first_unit = INT_MAX, last_unit = INT_MIN;
-
-		for_each_possible_cpu(cpu) {
-			int unit = unit_map[cpu];
-
-			BUG_ON(unit < 0);
-			for_each_possible_cpu(tcpu) {
-				if (tcpu == cpu)
-					break;
-				/* the mapping should be one-to-one */
-				BUG_ON(unit_map[tcpu] == unit);
-			}
+	unit_map = alloc_bootmem(nr_cpu_ids * sizeof(unit_map[0]));
 
-			if (unit < first_unit) {
-				pcpu_first_unit_cpu = cpu;
-				first_unit = unit;
-			}
-			if (unit > last_unit) {
-				pcpu_last_unit_cpu = cpu;
-				last_unit = unit;
-			}
-		}
-		pcpu_nr_units = last_unit + 1;
-		pcpu_unit_map = unit_map;
-	} else {
-		int *identity_map;
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
+		unit_map[cpu] = NR_CPUS;
+	pcpu_first_unit_cpu = NR_CPUS;
 
-		/* #units == #cpus, identity mapped */
-		identity_map = alloc_bootmem(nr_cpu_ids *
-					     sizeof(identity_map[0]));
+	for (group = 0, unit = 0; group < ai->nr_groups; group++, unit += i) {
+		const struct pcpu_group_info *gi = &ai->groups[group];
 
-		for_each_possible_cpu(cpu)
-			identity_map[cpu] = cpu;
+		for (i = 0; i < gi->nr_units; i++) {
+			cpu = gi->cpu_map[i];
+			if (cpu == NR_CPUS)
+				continue;
 
-		pcpu_first_unit_cpu = 0;
-		pcpu_last_unit_cpu = pcpu_nr_units - 1;
-		pcpu_nr_units = nr_cpu_ids;
-		pcpu_unit_map = identity_map;
+			BUG_ON(cpu > nr_cpu_ids || !cpu_possible(cpu));
+			BUG_ON(unit_map[cpu] != NR_CPUS);
+
+			unit_map[cpu] = unit + i;
+			if (pcpu_first_unit_cpu == NR_CPUS)
+				pcpu_first_unit_cpu = cpu;
+		}
 	}
+	pcpu_last_unit_cpu = cpu;
+	pcpu_nr_units = unit;
+
+	for_each_possible_cpu(cpu)
+		BUG_ON(unit_map[cpu] == NR_CPUS);
+
+	pcpu_unit_map = unit_map;
 
 	/* determine basic parameters */
-	pcpu_unit_pages = unit_size >> PAGE_SHIFT;
+	pcpu_unit_pages = ai->unit_size >> PAGE_SHIFT;
 	pcpu_unit_size = pcpu_unit_pages << PAGE_SHIFT;
 	pcpu_chunk_size = pcpu_nr_units * pcpu_unit_size;
 	pcpu_chunk_struct_size = sizeof(struct pcpu_chunk) +
@@ -1543,17 +1653,17 @@ size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
 	schunk->immutable = true;
 	bitmap_fill(schunk->populated, pcpu_unit_pages);
 
-	if (reserved_size) {
-		schunk->free_size = reserved_size;
+	if (ai->reserved_size) {
+		schunk->free_size = ai->reserved_size;
 		pcpu_reserved_chunk = schunk;
-		pcpu_reserved_chunk_limit = static_size + reserved_size;
+		pcpu_reserved_chunk_limit = ai->static_size + ai->reserved_size;
 	} else {
 		schunk->free_size = dyn_size;
 		dyn_size = 0;			/* dynamic area covered */
 	}
 	schunk->contig_hint = schunk->free_size;
 
-	schunk->map[schunk->map_used++] = -static_size;
+	schunk->map[schunk->map_used++] = -ai->static_size;
 	if (schunk->free_size)
 		schunk->map[schunk->map_used++] = schunk->free_size;
 
@@ -1643,44 +1753,47 @@ early_param("percpu_alloc", percpu_alloc_setup);
  */
 ssize_t __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size)
 {
-	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	size_t size_sum, unit_size, chunk_size;
+	struct pcpu_alloc_info *ai;
+	size_t size_sum, chunk_size;
 	void *base;
-	unsigned int cpu;
+	int unit;
+	ssize_t ret;
 
-	/* determine parameters and allocate */
-	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
+	ai = pcpu_build_alloc_info(reserved_size, dyn_size, PAGE_SIZE, NULL);
+	if (IS_ERR(ai))
+		return PTR_ERR(ai);
+	BUG_ON(ai->nr_groups != 1);
+	BUG_ON(ai->groups[0].nr_units != num_possible_cpus());
 
-	unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
-	chunk_size = unit_size * nr_cpu_ids;
+	size_sum = ai->static_size + ai->reserved_size + ai->dyn_size;
+	chunk_size = ai->unit_size * num_possible_cpus();
 
 	base = __alloc_bootmem_nopanic(chunk_size, PAGE_SIZE,
 				       __pa(MAX_DMA_ADDRESS));
 	if (!base) {
 		pr_warning("PERCPU: failed to allocate %zu bytes for "
 			   "embedding\n", chunk_size);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free_ai;
 	}
 
 	/* return the leftover and copy */
-	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
-		void *ptr = base + cpu * unit_size;
-
-		if (cpu_possible(cpu)) {
-			free_bootmem(__pa(ptr + size_sum),
-				     unit_size - size_sum);
-			memcpy(ptr, __per_cpu_load, static_size);
-		} else
-			free_bootmem(__pa(ptr), unit_size);
+	for (unit = 0; unit < num_possible_cpus(); unit++) {
+		void *ptr = base + unit * ai->unit_size;
+
+		free_bootmem(__pa(ptr + size_sum), ai->unit_size - size_sum);
+		memcpy(ptr, __per_cpu_load, ai->static_size);
 	}
 
 	/* we're ready, commit */
 	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
-		PFN_DOWN(size_sum), base, static_size, reserved_size, dyn_size,
-		unit_size);
+		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
+		ai->dyn_size, ai->unit_size);
 
-	return pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
-				      unit_size, base, NULL);
+	ret = pcpu_setup_first_chunk(ai, base);
+out_free_ai:
+	pcpu_free_alloc_info(ai);
+	return ret;
 }
 #endif /* CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK ||
 	  !CONFIG_HAVE_SETUP_PER_CPU_AREA */
@@ -1709,31 +1822,34 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 				     pcpu_fc_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct vm;
-	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	ssize_t dyn_size = -1;
-	size_t size_sum, unit_size;
+	struct pcpu_alloc_info *ai;
 	char psize_str[16];
 	int unit_pages;
 	size_t pages_size;
 	struct page **pages;
-	unsigned int cpu;
-	int i, j;
+	int unit, i, j;
 	ssize_t ret;
 
 	snprintf(psize_str, sizeof(psize_str), "%luK", PAGE_SIZE >> 10);
 
-	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
-	unit_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
-	unit_pages = unit_size >> PAGE_SHIFT;
+	ai = pcpu_build_alloc_info(reserved_size, -1, PAGE_SIZE, NULL);
+	if (IS_ERR(ai))
+		return PTR_ERR(ai);
+	BUG_ON(ai->nr_groups != 1);
+	BUG_ON(ai->groups[0].nr_units != num_possible_cpus());
+
+	unit_pages = ai->unit_size >> PAGE_SHIFT;
 
 	/* unaligned allocations can't be freed, round up to page size */
-	pages_size = PFN_ALIGN(unit_pages * nr_cpu_ids * sizeof(pages[0]));
+	pages_size = PFN_ALIGN(unit_pages * num_possible_cpus() *
+			       sizeof(pages[0]));
 	pages = alloc_bootmem(pages_size);
 
 	/* allocate pages */
 	j = 0;
-	for_each_possible_cpu(cpu)
+	for (unit = 0; unit < num_possible_cpus(); unit++)
 		for (i = 0; i < unit_pages; i++) {
+			unsigned int cpu = ai->groups[0].cpu_map[unit];
 			void *ptr;
 
 			ptr = alloc_fn(cpu, PAGE_SIZE, PAGE_SIZE);
@@ -1747,18 +1863,18 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 
 	/* allocate vm area, map the pages and copy static data */
 	vm.flags = VM_ALLOC;
-	vm.size = nr_cpu_ids * unit_size;
+	vm.size = num_possible_cpus() * ai->unit_size;
 	vm_area_register_early(&vm, PAGE_SIZE);
 
-	for_each_possible_cpu(cpu) {
+	for (unit = 0; unit < num_possible_cpus(); unit++) {
 		unsigned long unit_addr =
-			(unsigned long)vm.addr + cpu * unit_size;
+			(unsigned long)vm.addr + unit * ai->unit_size;
 
 		for (i = 0; i < unit_pages; i++)
 			populate_pte_fn(unit_addr + (i << PAGE_SHIFT));
 
 		/* pte already populated, the following shouldn't fail */
-		ret = __pcpu_map_pages(unit_addr, &pages[cpu * unit_pages],
+		ret = __pcpu_map_pages(unit_addr, &pages[unit * unit_pages],
 				       unit_pages);
 		if (ret < 0)
 			panic("failed to map percpu area, err=%zd\n", ret);
@@ -1772,16 +1888,15 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 		 */
 
 		/* copy static data */
-		memcpy((void *)unit_addr, __per_cpu_load, static_size);
+		memcpy((void *)unit_addr, __per_cpu_load, ai->static_size);
 	}
 
 	/* we're ready, commit */
 	pr_info("PERCPU: %d %s pages/cpu @%p s%zu r%zu d%zu\n",
-		unit_pages, psize_str, vm.addr, static_size, reserved_size,
-		dyn_size);
+		unit_pages, psize_str, vm.addr, ai->static_size,
+		ai->reserved_size, ai->dyn_size);
 
-	ret = pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
-				     unit_size, vm.addr, NULL);
+	ret = pcpu_setup_first_chunk(ai, vm.addr);
 	goto out_free_ar;
 
 enomem:
@@ -1790,6 +1905,7 @@ enomem:
 	ret = -ENOMEM;
 out_free_ar:
 	free_bootmem(__pa(pages), pages_size);
+	pcpu_free_alloc_info(ai);
 	return ret;
 }
 #endif /* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK */
@@ -1805,38 +1921,50 @@ static size_t pcpul_lpage_size;
 static int pcpul_nr_lpages;
 static struct pcpul_ent *pcpul_map;
 
-static bool __init pcpul_unit_to_cpu(int unit, const int *unit_map,
+static bool __init pcpul_unit_to_cpu(int unit, const struct pcpu_alloc_info *ai,
 				     unsigned int *cpup)
 {
-	unsigned int cpu;
+	int group, cunit;
 
-	for_each_possible_cpu(cpu)
-		if (unit_map[cpu] == unit) {
+	for (group = 0, cunit = 0; group < ai->nr_groups; group++) {
+		const struct pcpu_group_info *gi = &ai->groups[group];
+
+		if (unit < cunit + gi->nr_units) {
 			if (cpup)
-				*cpup = cpu;
+				*cpup = gi->cpu_map[unit - cunit];
 			return true;
 		}
+		cunit += gi->nr_units;
+	}
 
 	return false;
 }
 
+static int __init pcpul_cpu_to_unit(int cpu, const struct pcpu_alloc_info *ai)
+{
+	int group, unit, i;
+
+	for (group = 0, unit = 0; group < ai->nr_groups; group++, unit += i) {
+		const struct pcpu_group_info *gi = &ai->groups[group];
+
+		for (i = 0; i < gi->nr_units; i++)
+			if (gi->cpu_map[i] == cpu)
+				return unit + i;
+	}
+	BUG();
+}
+
 /**
  * pcpu_lpage_first_chunk - remap the first percpu chunk using large page
- * @reserved_size: the size of reserved percpu area in bytes
- * @dyn_size: free size for dynamic allocation in bytes
- * @unit_size: unit size in bytes
- * @lpage_size: the size of a large page
- * @unit_map: cpu -> unit mapping
- * @nr_units: the number of units
+ * @ai: pcpu_alloc_info
  * @alloc_fn: function to allocate percpu lpage, always called with lpage_size
  * @free_fn: function to free percpu memory, @size <= lpage_size
  * @map_fn: function to map percpu lpage, always called with lpage_size
  *
  * This allocator uses large page to build and map the first chunk.
- * Unlike other helpers, the caller should always specify @dyn_size
- * and @unit_size.  These parameters along with @unit_map and
- * @nr_units can be determined using pcpu_lpage_build_unit_map().
- * This two stage initialization is to allow arch code to evaluate the
+ * Unlike other helpers, the caller should provide fully initialized
+ * @ai.  This can be done using pcpu_build_alloc_info().  This two
+ * stage initialization is to allow arch code to evaluate the
  * parameters before committing to it.
  *
  * Large pages are allocated as directed by @unit_map and other
@@ -1852,27 +1980,26 @@ static bool __init pcpul_unit_to_cpu(int unit, const int *unit_map,
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access on success, -errno on failure.
  */
-ssize_t __init pcpu_lpage_first_chunk(size_t reserved_size, size_t dyn_size,
-				      size_t unit_size, size_t lpage_size,
-				      const int *unit_map, int nr_units,
+ssize_t __init pcpu_lpage_first_chunk(const struct pcpu_alloc_info *ai,
 				      pcpu_fc_alloc_fn_t alloc_fn,
 				      pcpu_fc_free_fn_t free_fn,
 				      pcpu_fc_map_fn_t map_fn)
 {
 	static struct vm_struct vm;
-	const size_t static_size = __per_cpu_end - __per_cpu_start;
-	size_t chunk_size = unit_size * nr_units;
-	size_t map_size;
+	const size_t lpage_size = ai->atom_size;
+	size_t chunk_size, map_size;
 	unsigned int cpu;
 	ssize_t ret;
-	int i, j, unit;
+	int i, j, unit, nr_units;
 
-	pcpul_lpage_dump_cfg(KERN_DEBUG, static_size, reserved_size, dyn_size,
-			     unit_size, lpage_size, unit_map, nr_units);
+	nr_units = 0;
+	for (i = 0; i < ai->nr_groups; i++)
+		nr_units += ai->groups[i].nr_units;
 
+	chunk_size = ai->unit_size * nr_units;
 	BUG_ON(chunk_size % lpage_size);
 
-	pcpul_size = static_size + reserved_size + dyn_size;
+	pcpul_size = ai->static_size + ai->reserved_size + ai->dyn_size;
 	pcpul_lpage_size = lpage_size;
 	pcpul_nr_lpages = chunk_size / lpage_size;
 
@@ -1883,13 +2010,13 @@ ssize_t __init pcpu_lpage_first_chunk(size_t reserved_size, size_t dyn_size,
 	/* allocate all pages */
 	for (i = 0; i < pcpul_nr_lpages; i++) {
 		size_t offset = i * lpage_size;
-		int first_unit = offset / unit_size;
-		int last_unit = (offset + lpage_size - 1) / unit_size;
+		int first_unit = offset / ai->unit_size;
+		int last_unit = (offset + lpage_size - 1) / ai->unit_size;
 		void *ptr;
 
 		/* find out which cpu is mapped to this unit */
 		for (unit = first_unit; unit <= last_unit; unit++)
-			if (pcpul_unit_to_cpu(unit, unit_map, &cpu))
+			if (pcpul_unit_to_cpu(unit, ai, &cpu))
 				goto found;
 		continue;
 	found:
@@ -1905,12 +2032,12 @@ ssize_t __init pcpu_lpage_first_chunk(size_t reserved_size, size_t dyn_size,
 
 	/* return unused holes */
 	for (unit = 0; unit < nr_units; unit++) {
-		size_t start = unit * unit_size;
-		size_t end = start + unit_size;
+		size_t start = unit * ai->unit_size;
+		size_t end = start + ai->unit_size;
 		size_t off, next;
 
 		/* don't free used part of occupied unit */
-		if (pcpul_unit_to_cpu(unit, unit_map, NULL))
+		if (pcpul_unit_to_cpu(unit, ai, NULL))
 			start += pcpul_size;
 
 		/* unit can span more than one page, punch the holes */
@@ -1925,7 +2052,7 @@ ssize_t __init pcpu_lpage_first_chunk(size_t reserved_size, size_t dyn_size,
 	/* allocate address, map and copy */
 	vm.flags = VM_ALLOC;
 	vm.size = chunk_size;
-	vm_area_register_early(&vm, unit_size);
+	vm_area_register_early(&vm, ai->unit_size);
 
 	for (i = 0; i < pcpul_nr_lpages; i++) {
 		if (!pcpul_map[i].ptr)
@@ -1935,15 +2062,15 @@ ssize_t __init pcpu_lpage_first_chunk(size_t reserved_size, size_t dyn_size,
 	}
 
 	for_each_possible_cpu(cpu)
-		memcpy(vm.addr + unit_map[cpu] * unit_size, __per_cpu_load,
-		       static_size);
+		memcpy(vm.addr + pcpul_cpu_to_unit(cpu, ai) * ai->unit_size,
+		       __per_cpu_load, ai->static_size);
 
 	/* we're ready, commit */
 	pr_info("PERCPU: large pages @%p s%zu r%zu d%zu u%zu\n",
-		vm.addr, static_size, reserved_size, dyn_size, unit_size);
+		vm.addr, ai->static_size, ai->reserved_size, ai->dyn_size,
+		ai->unit_size);
 
-	ret = pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
-				     unit_size, vm.addr, unit_map);
+	ret = pcpu_setup_first_chunk(ai, vm.addr);
 
 	/*
 	 * Sort pcpul_map array for pcpu_lpage_remapped().  Unmapped
-- 
1.6.0.2

