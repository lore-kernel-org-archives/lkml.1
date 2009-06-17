Return-Path: <linux-kernel-owner+w=401wt.eu-S1764887AbZFQE1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764887AbZFQE1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbZFQE0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:26:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:57888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764405AbZFQE0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:26:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       JBeulich@novell.com, cl@linux-foundation.org, davem@davemloft.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] percpu: teach large page allocator about NUMA
Date: Wed, 17 Jun 2009 13:26:09 +0900
Message-Id: <1245212769-29134-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245212769-29134-1-git-send-email-tj@kernel.org>
References: <1245212769-29134-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:26:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Large page first chunk allocator is primarily used for NUMA machines;
however, its NUMA handling is extremely simplistic.  Regardless of
their proximity, each cpu is put into separate large page just to
return most of the allocated space back wasting large amount of
vmalloc space and increasing cache footprint.

This patch teachs NUMA details to large page allocator.  Given
processor proximity information, pcpu_lpage_build_unit_map() will find
fitting cpu -> unit mapping in which cpus in LOCAL_DISTANCE share the
same large page and not too much virtual address space is wasted.

This greatly reduces the unit and thus chunk size and wastes much less
address space for the first chunk.  For example, on 4/4 NUMA machine,
the original code occupied 16MB of virtual space for the first chunk
while the new code only uses 4MB - one 2MB page for each node.

[ Impact: much better space efficiency on NUMA machines ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>
---
 arch/x86/kernel/setup_percpu.c |   72 ++++++--
 include/linux/percpu.h         |   24 +++-
 mm/percpu.c                    |  358 +++++++++++++++++++++++++++++++---------
 3 files changed, 359 insertions(+), 95 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 4f2e0ac..7501bb1 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -149,36 +149,73 @@ static void __init pcpul_map(void *ptr, size_t size, void *addr)
 	set_pmd(pmd, pmd_v);
 }
 
+static int pcpu_lpage_cpu_distance(unsigned int from, unsigned int to)
+{
+	if (early_cpu_to_node(from) == early_cpu_to_node(to))
+		return LOCAL_DISTANCE;
+	else
+		return REMOTE_DISTANCE;
+}
+
 static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
 {
 	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
+	size_t dyn_size = reserve - PERCPU_FIRST_CHUNK_RESERVE;
+	size_t unit_map_size, unit_size;
+	int *unit_map;
+	int nr_units;
+	ssize_t ret;
+
+	/* on non-NUMA, embedding is better */
+	if (!chosen && !pcpu_need_numa())
+		return -EINVAL;
+
+	/* need PSE */
+	if (!cpu_has_pse) {
+		pr_warning("PERCPU: lpage allocator requires PSE\n");
+		return -EINVAL;
+	}
 
+	/* allocate and build unit_map */
+	unit_map_size = num_possible_cpus() * sizeof(int);
+	unit_map = alloc_bootmem_nopanic(unit_map_size);
+	if (!unit_map) {
+		pr_warning("PERCPU: failed to allocate unit_map\n");
+		return -ENOMEM;
+	}
+
+	ret = pcpu_lpage_build_unit_map(static_size,
+					PERCPU_FIRST_CHUNK_RESERVE,
+					&dyn_size, &unit_size, PMD_SIZE,
+					unit_map, pcpu_lpage_cpu_distance);
+	if (ret < 0) {
+		pr_warning("PERCPU: failed to build unit_map\n");
+		goto out_free;
+	}
+	nr_units = ret;
+
+	/* do the parameters look okay? */
 	if (!chosen) {
 		size_t vm_size = VMALLOC_END - VMALLOC_START;
-		size_t tot_size = num_possible_cpus() * PMD_SIZE;
-
-		/* on non-NUMA, embedding is better */
-		if (!pcpu_need_numa())
-			return -EINVAL;
+		size_t tot_size = nr_units * unit_size;
 
 		/* don't consume more than 20% of vmalloc area */
 		if (tot_size > vm_size / 5) {
 			pr_info("PERCPU: too large chunk size %zuMB for "
 				"large page remap\n", tot_size >> 20);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out_free;
 		}
 	}
 
-	/* need PSE */
-	if (!cpu_has_pse) {
-		pr_warning("PERCPU: lpage allocator requires PSE\n");
-		return -EINVAL;
-	}
-
-	return pcpu_lpage_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
-				      reserve - PERCPU_FIRST_CHUNK_RESERVE,
-				      PMD_SIZE,
-				      pcpu_fc_alloc, pcpu_fc_free, pcpul_map);
+	ret = pcpu_lpage_first_chunk(static_size, PERCPU_FIRST_CHUNK_RESERVE,
+				     dyn_size, unit_size, PMD_SIZE,
+				     unit_map, nr_units,
+				     pcpu_fc_alloc, pcpu_fc_free, pcpul_map);
+out_free:
+	if (ret < 0)
+		free_bootmem(__pa(unit_map), unit_map_size);
+	return ret;
 }
 #else
 static ssize_t __init setup_pcpu_lpage(size_t static_size, bool chosen)
@@ -299,7 +336,8 @@ void __init setup_per_cpu_areas(void)
 	/* alrighty, percpu areas up and running */
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu) {
-		per_cpu_offset(cpu) = delta + cpu * pcpu_unit_size;
+		per_cpu_offset(cpu) =
+			delta + pcpu_unit_map[cpu] * pcpu_unit_size;
 		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 		per_cpu(cpu_number, cpu) = cpu;
 		setup_percpu_segment(cpu);
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 1e0e887..8ce91af 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -62,6 +62,7 @@ extern const int *pcpu_unit_map;
 typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size);
 typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
 typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
+typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);
 typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 
 extern size_t __init pcpu_setup_first_chunk(
@@ -80,18 +81,37 @@ extern ssize_t __init pcpu_4k_first_chunk(
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
+extern int __init pcpu_lpage_build_unit_map(
+				size_t static_size, size_t reserved_size,
+				ssize_t *dyn_sizep, size_t *unit_sizep,
+				size_t lpage_size, int *unit_map,
+				pcpu_fc_cpu_distance_fn_t cpu_distance_fn);
+
 extern ssize_t __init pcpu_lpage_first_chunk(
 				size_t static_size, size_t reserved_size,
-				ssize_t dyn_size, size_t lpage_size,
+				size_t dyn_size, size_t unit_size,
+				size_t lpage_size, const int *unit_map,
+				int nr_units,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_map_fn_t map_fn);
 
 extern void *pcpu_lpage_remapped(void *kaddr);
 #else
+static inline int pcpu_lpage_build_unit_map(
+				size_t static_size, size_t reserved_size,
+				ssize_t *dyn_sizep, size_t *unit_sizep,
+				size_t lpage_size, int *unit_map,
+				pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
+{
+	return -EINVAL;
+}
+
 static inline ssize_t __init pcpu_lpage_first_chunk(
 				size_t static_size, size_t reserved_size,
-				ssize_t dyn_size, size_t lpage_size,
+				size_t dyn_size, size_t unit_size,
+				size_t lpage_size, const int *unit_map,
+				int nr_units,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_map_fn_t map_fn)
diff --git a/mm/percpu.c b/mm/percpu.c
index f0fce38..b11ae7a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -59,6 +59,7 @@
 #include <linux/bitmap.h>
 #include <linux/bootmem.h>
 #include <linux/list.h>
+#include <linux/log2.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -1594,75 +1595,259 @@ out_free_ar:
  * Large page remapping first chunk setup helper
  */
 #ifdef CONFIG_NEED_MULTIPLE_NODES
+
+/**
+ * pcpu_lpage_build_unit_map - build unit_map for large page remapping
+ * @static_size: the size of static percpu area in bytes
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
+int __init pcpu_lpage_build_unit_map(size_t static_size, size_t reserved_size,
+				     ssize_t *dyn_sizep, size_t *unit_sizep,
+				     size_t lpage_size, int *unit_map,
+				     pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
+{
+	static int group_map[NR_CPUS] __initdata;
+	static int group_cnt[NR_CPUS] __initdata;
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
 struct pcpul_ent {
-	unsigned int	cpu;
 	void		*ptr;
+	void		*map_addr;
 };
 
 static size_t pcpul_size;
-static size_t pcpul_unit_size;
+static size_t pcpul_lpage_size;
+static int pcpul_nr_lpages;
 static struct pcpul_ent *pcpul_map;
-static struct vm_struct pcpul_vm;
+
+static bool __init pcpul_unit_to_cpu(int unit, const int *unit_map,
+				     unsigned int *cpup)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		if (unit_map[cpu] == unit) {
+			if (cpup)
+				*cpup = cpu;
+			return true;
+		}
+
+	return false;
+}
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
 
 /**
  * pcpu_lpage_first_chunk - remap the first percpu chunk using large page
  * @static_size: the size of static percpu area in bytes
  * @reserved_size: the size of reserved percpu area in bytes
- * @dyn_size: free size for dynamic allocation in bytes, -1 for auto
+ * @dyn_size: free size for dynamic allocation in bytes
+ * @unit_size: unit size in bytes
  * @lpage_size: the size of a large page
+ * @unit_map: cpu -> unit mapping
+ * @nr_units: the number of units
  * @alloc_fn: function to allocate percpu lpage, always called with lpage_size
  * @free_fn: function to free percpu memory, @size <= lpage_size
  * @map_fn: function to map percpu lpage, always called with lpage_size
  *
- * This allocator uses large page as unit.  A large page is allocated
- * for each cpu and each is remapped into vmalloc area using large
- * page mapping.  As large page can be quite large, only part of it is
- * used for the first chunk.  Unused part is returned to the bootmem
- * allocator.
- *
- * So, the large pages are mapped twice - once to the physical mapping
- * and to the vmalloc area for the first percpu chunk.  The double
- * mapping does add one more large TLB entry pressure but still is
- * much better than only using 4k mappings while still being NUMA
- * friendly.
+ * This allocator uses large page to build and map the first chunk.
+ * Unlike other helpers, the caller should always specify @dyn_size
+ * and @unit_size.  These parameters along with @unit_map and
+ * @nr_units can be determined using pcpu_lpage_build_unit_map().
+ * This two stage initialization is to allow arch code to evaluate the
+ * parameters before committing to it.
+ *
+ * Large pages are allocated as directed by @unit_map and other
+ * parameters and mapped to vmalloc space.  Unused holes are returned
+ * to the page allocator.  Note that these holes end up being actively
+ * mapped twice - once to the physical mapping and to the vmalloc area
+ * for the first percpu chunk.  Depending on architecture, this might
+ * cause problem when changing page attributes of the returned area.
+ * These double mapped areas can be detected using
+ * pcpu_lpage_remapped().
  *
  * RETURNS:
  * The determined pcpu_unit_size which can be used to initialize
  * percpu access on success, -errno on failure.
  */
 ssize_t __init pcpu_lpage_first_chunk(size_t static_size, size_t reserved_size,
-				      ssize_t dyn_size, size_t lpage_size,
+				      size_t dyn_size, size_t unit_size,
+				      size_t lpage_size, const int *unit_map,
+				      int nr_units,
 				      pcpu_fc_alloc_fn_t alloc_fn,
 				      pcpu_fc_free_fn_t free_fn,
 				      pcpu_fc_map_fn_t map_fn)
 {
-	size_t size_sum;
+	static struct vm_struct vm;
+	size_t chunk_size = unit_size * nr_units;
 	size_t map_size;
 	unsigned int cpu;
-	int i, j;
 	ssize_t ret;
+	int i, j, unit;
 
-	/*
-	 * Currently supports only single page.  Supporting multiple
-	 * pages won't be too difficult if it ever becomes necessary.
-	 */
-	size_sum = pcpu_calc_fc_sizes(static_size, reserved_size, &dyn_size);
+	pcpul_lpage_dump_cfg(KERN_DEBUG, static_size, reserved_size, dyn_size,
+			     unit_size, lpage_size, unit_map, nr_units);
 
-	pcpul_unit_size = lpage_size;
-	pcpul_size = max_t(size_t, size_sum, PCPU_MIN_UNIT_SIZE);
-	if (pcpul_size > pcpul_unit_size) {
-		pr_warning("PERCPU: static data is larger than large page, "
-			   "can't use large page\n");
-		return -EINVAL;
-	}
+	BUG_ON(chunk_size % lpage_size);
+
+	pcpul_size = static_size + reserved_size + dyn_size;
+	pcpul_lpage_size = lpage_size;
+	pcpul_nr_lpages = chunk_size / lpage_size;
 
 	/* allocate pointer array and alloc large pages */
-	map_size = PFN_ALIGN(num_possible_cpus() * sizeof(pcpul_map[0]));
+	map_size = pcpul_nr_lpages * sizeof(pcpul_map[0]);
 	pcpul_map = alloc_bootmem(map_size);
 
-	for_each_possible_cpu(cpu) {
+	/* allocate all pages */
+	for (i = 0; i < pcpul_nr_lpages; i++) {
+		size_t offset = i * lpage_size;
+		int first_unit = offset / unit_size;
+		int last_unit = (offset + lpage_size - 1) / unit_size;
 		void *ptr;
 
+		/* find out which cpu is mapped to this unit */
+		for (unit = first_unit; unit <= last_unit; unit++)
+			if (pcpul_unit_to_cpu(unit, unit_map, &cpu))
+				goto found;
+		continue;
+	found:
 		ptr = alloc_fn(cpu, lpage_size);
 		if (!ptr) {
 			pr_warning("PERCPU: failed to allocate large page "
@@ -1670,53 +1855,79 @@ ssize_t __init pcpu_lpage_first_chunk(size_t static_size, size_t reserved_size,
 			goto enomem;
 		}
 
-		/*
-		 * Only use pcpul_size bytes and give back the rest.
-		 *
-		 * Ingo: The lpage_size up-rounding bootmem is needed
-		 * to make sure the partial lpage is still fully RAM -
-		 * it's not well-specified to have a incompatible area
-		 * (unmapped RAM, device memory, etc.) in that hole.
-		 */
-		free_fn(ptr + pcpul_size, lpage_size - pcpul_size);
-
-		pcpul_map[cpu].cpu = cpu;
-		pcpul_map[cpu].ptr = ptr;
+		pcpul_map[i].ptr = ptr;
+	}
 
-		memcpy(ptr, __per_cpu_load, static_size);
+	/* return unused holes */
+	for (unit = 0; unit < nr_units; unit++) {
+		size_t start = unit * unit_size;
+		size_t end = start + unit_size;
+		size_t off, next;
+
+		/* don't free used part of occupied unit */
+		if (pcpul_unit_to_cpu(unit, unit_map, NULL))
+			start += pcpul_size;
+
+		/* unit can span more than one page, punch the holes */
+		for (off = start; off < end; off = next) {
+			void *ptr = pcpul_map[off / lpage_size].ptr;
+			next = min(roundup(off + 1, lpage_size), end);
+			if (ptr)
+				free_fn(ptr + off % lpage_size, next - off);
+		}
 	}
 
-	/* allocate address and map */
-	pcpul_vm.flags = VM_ALLOC;
-	pcpul_vm.size = num_possible_cpus() * pcpul_unit_size;
-	vm_area_register_early(&pcpul_vm, pcpul_unit_size);
+	/* allocate address, map and copy */
+	vm.flags = VM_ALLOC;
+	vm.size = chunk_size;
+	vm_area_register_early(&vm, unit_size);
+
+	for (i = 0; i < pcpul_nr_lpages; i++) {
+		if (!pcpul_map[i].ptr)
+			continue;
+		pcpul_map[i].map_addr = vm.addr + i * lpage_size;
+		map_fn(pcpul_map[i].ptr, lpage_size, pcpul_map[i].map_addr);
+	}
 
 	for_each_possible_cpu(cpu)
-		map_fn(pcpul_map[cpu].ptr, pcpul_unit_size,
-		       pcpul_vm.addr + cpu * pcpul_unit_size);
+		memcpy(vm.addr + unit_map[cpu] * unit_size, __per_cpu_load,
+		       static_size);
 
 	/* we're ready, commit */
 	pr_info("PERCPU: Remapped at %p with large pages, static data "
-		"%zu bytes\n", pcpul_vm.addr, static_size);
+		"%zu bytes\n", vm.addr, static_size);
 
 	ret = pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
-				     pcpul_unit_size, pcpul_vm.addr, NULL);
-
-	/* sort pcpul_map array for pcpu_lpage_remapped() */
-	for (i = 0; i < num_possible_cpus() - 1; i++)
-		for (j = i + 1; j < num_possible_cpus(); j++)
-			if (pcpul_map[i].ptr > pcpul_map[j].ptr) {
-				struct pcpul_ent tmp = pcpul_map[i];
-				pcpul_map[i] = pcpul_map[j];
-				pcpul_map[j] = tmp;
-			}
+				     unit_size, vm.addr, unit_map);
+
+	/*
+	 * Sort pcpul_map array for pcpu_lpage_remapped().  Unmapped
+	 * lpages are pushed to the end and trimmed.
+	 */
+	for (i = 0; i < pcpul_nr_lpages - 1; i++)
+		for (j = i + 1; j < pcpul_nr_lpages; j++) {
+			struct pcpul_ent tmp;
+
+			if (!pcpul_map[j].ptr)
+				continue;
+			if (pcpul_map[i].ptr &&
+			    pcpul_map[i].ptr < pcpul_map[j].ptr)
+				continue;
+
+			tmp = pcpul_map[i];
+			pcpul_map[i] = pcpul_map[j];
+			pcpul_map[j] = tmp;
+		}
+
+	while (pcpul_nr_lpages && !pcpul_map[pcpul_nr_lpages - 1].ptr)
+		pcpul_nr_lpages--;
 
 	return ret;
 
 enomem:
-	for_each_possible_cpu(cpu)
-		if (pcpul_map[cpu].ptr)
-			free_fn(pcpul_map[cpu].ptr, pcpul_size);
+	for (i = 0; i < pcpul_nr_lpages; i++)
+		if (pcpul_map[i].ptr)
+			free_fn(pcpul_map[i].ptr, lpage_size);
 	free_bootmem(__pa(pcpul_map), map_size);
 	return -ENOMEM;
 }
@@ -1739,10 +1950,10 @@ enomem:
  */
 void *pcpu_lpage_remapped(void *kaddr)
 {
-	unsigned long unit_mask = pcpul_unit_size - 1;
-	void *lpage_addr = (void *)((unsigned long)kaddr & ~unit_mask);
-	unsigned long offset = (unsigned long)kaddr & unit_mask;
-	int left = 0, right = num_possible_cpus() - 1;
+	unsigned long lpage_mask = pcpul_lpage_size - 1;
+	void *lpage_addr = (void *)((unsigned long)kaddr & ~lpage_mask);
+	unsigned long offset = (unsigned long)kaddr & lpage_mask;
+	int left = 0, right = pcpul_nr_lpages - 1;
 	int pos;
 
 	/* pcpul in use at all? */
@@ -1757,13 +1968,8 @@ void *pcpu_lpage_remapped(void *kaddr)
 			left = pos + 1;
 		else if (pcpul_map[pos].ptr > lpage_addr)
 			right = pos - 1;
-		else {
-			/* it shouldn't be in the area for the first chunk */
-			WARN_ON(offset < pcpul_size);
-
-			return pcpul_vm.addr +
-				pcpul_map[pos].cpu * pcpul_unit_size + offset;
-		}
+		else
+			return pcpul_map[pos].map_addr + offset;
 	}
 
 	return NULL;
-- 
1.6.0.2

