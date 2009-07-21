Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZGUK2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZGUK2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZGUK16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:27:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:36999 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbZGUK1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:53 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/20] percpu: add pcpu_unit_offsets[]
Date: Tue, 21 Jul 2009 19:26:10 +0900
Message-Id: <1248171979-29166-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently units are mapped sequentially into address space.  This
patch adds pcpu_unit_offsets[] which allows units to be mapped to
arbitrary offsets from the chunk base address.  This is necessary to
allow sparse embedding which might would need to allocate address
ranges and memory areas which aren't aligned to unit size but
allocation atom size (page or large page size).  This also simplifies
things a bit by removing the need to calculate offset from unit
number.

With this change, there's no need for the arch code to know
pcpu_unit_size.  Update pcpu_setup_first_chunk() and first chunk
allocators to return regular 0 or -errno return code instead of unit
size or -errno.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/smp_64.c     |   12 +++--
 arch/x86/kernel/setup_percpu.c |   51 ++++++++++------------
 include/linux/percpu.h         |   16 +++----
 mm/percpu.c                    |   95 ++++++++++++++++++++--------------------
 4 files changed, 84 insertions(+), 90 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index a42a4a7..b03fd36 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1478,9 +1478,10 @@ void __init setup_per_cpu_areas(void)
 	static struct vm_struct vm;
 	struct pcpu_alloc_info *ai;
 	unsigned long delta, cpu;
-	size_t size_sum, pcpu_unit_size;
+	size_t size_sum;
 	size_t ptrs_size;
 	void **ptrs;
+	int rc;
 
 	ai = pcpu_alloc_alloc_info(1, nr_cpu_ids);
 
@@ -1526,14 +1527,15 @@ void __init setup_per_cpu_areas(void)
 		pcpu_map_range(start, end, virt_to_page(ptrs[cpu]));
 	}
 
-	pcpu_unit_size = pcpu_setup_first_chunk(ai, vm.addr);
+	rc = pcpu_setup_first_chunk(ai, vm.addr);
+	if (rc)
+		panic("failed to setup percpu first chunk (%d)", rc);
 
 	free_bootmem(__pa(ptrs), ptrs_size);
 
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
-	for_each_possible_cpu(cpu) {
-		__per_cpu_offset(cpu) = delta + cpu * pcpu_unit_size;
-	}
+	for_each_possible_cpu(cpu)
+		__per_cpu_offset(cpu) = delta + pcpu_unit_offsets[cpu];
 
 	/* Setup %g5 for the boot cpu.  */
 	__local_per_cpu_offset = __per_cpu_offset(smp_processor_id());
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 934f285..477d2de 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -157,12 +157,12 @@ static int pcpu_lpage_cpu_distance(unsigned int from, unsigned int to)
 		return REMOTE_DISTANCE;
 }
 
-static ssize_t __init setup_pcpu_lpage(bool chosen)
+static int __init setup_pcpu_lpage(bool chosen)
 {
 	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 	size_t dyn_size = reserve - PERCPU_FIRST_CHUNK_RESERVE;
 	struct pcpu_alloc_info *ai;
-	ssize_t ret;
+	int rc;
 
 	/* on non-NUMA, embedding is better */
 	if (!chosen && !pcpu_need_numa())
@@ -196,19 +196,18 @@ static ssize_t __init setup_pcpu_lpage(bool chosen)
 		if (tot_size > vm_size / 5) {
 			pr_info("PERCPU: too large chunk size %zuMB for "
 				"large page remap\n", tot_size >> 20);
-			ret = -EINVAL;
+			rc = -EINVAL;
 			goto out_free;
 		}
 	}
 
-	ret = pcpu_lpage_first_chunk(ai, pcpu_fc_alloc, pcpu_fc_free,
-				     pcpul_map);
+	rc = pcpu_lpage_first_chunk(ai, pcpu_fc_alloc, pcpu_fc_free, pcpul_map);
 out_free:
 	pcpu_free_alloc_info(ai);
-	return ret;
+	return rc;
 }
 #else
-static ssize_t __init setup_pcpu_lpage(bool chosen)
+static int __init setup_pcpu_lpage(bool chosen)
 {
 	return -EINVAL;
 }
@@ -222,7 +221,7 @@ static ssize_t __init setup_pcpu_lpage(bool chosen)
  * mapping so that it can use PMD mapping without additional TLB
  * pressure.
  */
-static ssize_t __init setup_pcpu_embed(bool chosen)
+static int __init setup_pcpu_embed(bool chosen)
 {
 	size_t reserve = PERCPU_MODULE_RESERVE + PERCPU_DYNAMIC_RESERVE;
 
@@ -250,7 +249,7 @@ static void __init pcpup_populate_pte(unsigned long addr)
 	populate_extra_pte(addr);
 }
 
-static ssize_t __init setup_pcpu_page(void)
+static int __init setup_pcpu_page(void)
 {
 	return pcpu_page_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 				     pcpu_fc_alloc, pcpu_fc_free,
@@ -274,8 +273,7 @@ void __init setup_per_cpu_areas(void)
 {
 	unsigned int cpu;
 	unsigned long delta;
-	size_t pcpu_unit_size;
-	ssize_t ret;
+	int rc;
 
 	pr_info("NR_CPUS:%d nr_cpumask_bits:%d nr_cpu_ids:%d nr_node_ids:%d\n",
 		NR_CPUS, nr_cpumask_bits, nr_cpu_ids, nr_node_ids);
@@ -285,36 +283,33 @@ void __init setup_per_cpu_areas(void)
 	 * of large page mappings.  Please read comments on top of
 	 * each allocator for details.
 	 */
-	ret = -EINVAL;
+	rc = -EINVAL;
 	if (pcpu_chosen_fc != PCPU_FC_AUTO) {
 		if (pcpu_chosen_fc != PCPU_FC_PAGE) {
 			if (pcpu_chosen_fc == PCPU_FC_LPAGE)
-				ret = setup_pcpu_lpage(true);
+				rc = setup_pcpu_lpage(true);
 			else
-				ret = setup_pcpu_embed(true);
+				rc = setup_pcpu_embed(true);
 
-			if (ret < 0)
-				pr_warning("PERCPU: %s allocator failed (%zd), "
+			if (rc < 0)
+				pr_warning("PERCPU: %s allocator failed (%d), "
 					   "falling back to page\n",
-					   pcpu_fc_names[pcpu_chosen_fc], ret);
+					   pcpu_fc_names[pcpu_chosen_fc], rc);
 		}
 	} else {
-		ret = setup_pcpu_lpage(false);
-		if (ret < 0)
-			ret = setup_pcpu_embed(false);
+		rc = setup_pcpu_lpage(false);
+		if (rc < 0)
+			rc = setup_pcpu_embed(false);
 	}
-	if (ret < 0)
-		ret = setup_pcpu_page();
-	if (ret < 0)
-		panic("cannot initialize percpu area (err=%zd)", ret);
-
-	pcpu_unit_size = ret;
+	if (rc < 0)
+		rc = setup_pcpu_page();
+	if (rc < 0)
+		panic("cannot initialize percpu area (err=%d)", rc);
 
 	/* alrighty, percpu areas up and running */
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu) {
-		per_cpu_offset(cpu) =
-			delta + pcpu_unit_map[cpu] * pcpu_unit_size;
+		per_cpu_offset(cpu) = delta + pcpu_unit_offsets[cpu];
 		per_cpu(this_cpu_off, cpu) = per_cpu_offset(cpu);
 		per_cpu(cpu_number, cpu) = cpu;
 		setup_percpu_segment(cpu);
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 77b86be..a7ec840 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -57,7 +57,7 @@
 #endif
 
 extern void *pcpu_base_addr;
-extern const int *pcpu_unit_map;
+extern const unsigned long *pcpu_unit_offsets;
 
 struct pcpu_group_info {
 	int			nr_units;	/* aligned # of units */
@@ -106,25 +106,23 @@ extern struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 				size_t atom_size,
 				pcpu_fc_cpu_distance_fn_t cpu_distance_fn);
 
-extern size_t __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
-					    void *base_addr);
+extern int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
+					 void *base_addr);
 
 #ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
-extern ssize_t __init pcpu_embed_first_chunk(
-				size_t reserved_size, ssize_t dyn_size);
+extern int __init pcpu_embed_first_chunk(size_t reserved_size,
+					 ssize_t dyn_size);
 #endif
 
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-extern ssize_t __init pcpu_page_first_chunk(
-				size_t reserved_size,
+extern int __init pcpu_page_first_chunk(size_t reserved_size,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 #endif
 
 #ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
-extern ssize_t __init pcpu_lpage_first_chunk(
-				const struct pcpu_alloc_info *ai,
+extern int __init pcpu_lpage_first_chunk(const struct pcpu_alloc_info *ai,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_map_fn_t map_fn);
diff --git a/mm/percpu.c b/mm/percpu.c
index 816cea4..8167fb8 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -117,8 +117,8 @@ static unsigned int pcpu_last_unit_cpu __read_mostly;
 void *pcpu_base_addr __read_mostly;
 EXPORT_SYMBOL_GPL(pcpu_base_addr);
 
-/* cpu -> unit map */
-const int *pcpu_unit_map __read_mostly;
+static const int *pcpu_unit_map __read_mostly;		/* cpu -> unit */
+const unsigned long *pcpu_unit_offsets __read_mostly;	/* cpu -> unit offset */
 
 /*
  * The first chunk which always exists.  Note that unlike other
@@ -196,8 +196,8 @@ static int pcpu_page_idx(unsigned int cpu, int page_idx)
 static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
 				     unsigned int cpu, int page_idx)
 {
-	return (unsigned long)chunk->vm->addr +
-		(pcpu_page_idx(cpu, page_idx) << PAGE_SHIFT);
+	return (unsigned long)chunk->vm->addr + pcpu_unit_offsets[cpu] +
+		(page_idx << PAGE_SHIFT);
 }
 
 static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
@@ -341,7 +341,7 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 	 * space.  Note that any possible cpu id can be used here, so
 	 * there's no need to worry about preemption or cpu hotplug.
 	 */
-	addr += pcpu_unit_map[smp_processor_id()] * pcpu_unit_size;
+	addr += pcpu_unit_offsets[smp_processor_id()];
 	return pcpu_get_page_chunk(vmalloc_to_page(addr));
 }
 
@@ -1560,17 +1560,17 @@ static void pcpu_dump_alloc_info(const char *lvl,
  * and available for dynamic allocation like any other chunks.
  *
  * RETURNS:
- * The determined pcpu_unit_size which can be used to initialize
- * percpu access.
+ * 0 on success, -errno on failure.
  */
-size_t __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
-				     void *base_addr)
+int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
+				  void *base_addr)
 {
 	static struct vm_struct first_vm;
 	static int smap[2], dmap[2];
 	size_t dyn_size = ai->dyn_size;
 	size_t size_sum = ai->static_size + ai->reserved_size + dyn_size;
 	struct pcpu_chunk *schunk, *dchunk = NULL;
+	unsigned long *unit_off;
 	unsigned int cpu;
 	int *unit_map;
 	int group, unit, i;
@@ -1587,8 +1587,9 @@ size_t __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 	pcpu_dump_alloc_info(KERN_DEBUG, ai);
 
-	/* determine number of units and verify and initialize pcpu_unit_map */
+	/* determine number of units and initialize unit_map and base */
 	unit_map = alloc_bootmem(nr_cpu_ids * sizeof(unit_map[0]));
+	unit_off = alloc_bootmem(nr_cpu_ids * sizeof(unit_off[0]));
 
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
 		unit_map[cpu] = NR_CPUS;
@@ -1606,6 +1607,8 @@ size_t __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 			BUG_ON(unit_map[cpu] != NR_CPUS);
 
 			unit_map[cpu] = unit + i;
+			unit_off[cpu] = gi->base_offset + i * ai->unit_size;
+
 			if (pcpu_first_unit_cpu == NR_CPUS)
 				pcpu_first_unit_cpu = cpu;
 		}
@@ -1617,6 +1620,7 @@ size_t __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 		BUG_ON(unit_map[cpu] == NR_CPUS);
 
 	pcpu_unit_map = unit_map;
+	pcpu_unit_offsets = unit_off;
 
 	/* determine basic parameters */
 	pcpu_unit_pages = ai->unit_size >> PAGE_SHIFT;
@@ -1688,7 +1692,7 @@ size_t __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 	/* we're done */
 	pcpu_base_addr = schunk->vm->addr;
-	return pcpu_unit_size;
+	return 0;
 }
 
 const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
@@ -1748,16 +1752,15 @@ early_param("percpu_alloc", percpu_alloc_setup);
  * size, the leftover is returned to the bootmem allocator.
  *
  * RETURNS:
- * The determined pcpu_unit_size which can be used to initialize
- * percpu access on success, -errno on failure.
+ * 0 on success, -errno on failure.
  */
-ssize_t __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size)
+int __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size)
 {
 	struct pcpu_alloc_info *ai;
 	size_t size_sum, chunk_size;
 	void *base;
 	int unit;
-	ssize_t ret;
+	int rc;
 
 	ai = pcpu_build_alloc_info(reserved_size, dyn_size, PAGE_SIZE, NULL);
 	if (IS_ERR(ai))
@@ -1773,7 +1776,7 @@ ssize_t __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size)
 	if (!base) {
 		pr_warning("PERCPU: failed to allocate %zu bytes for "
 			   "embedding\n", chunk_size);
-		ret = -ENOMEM;
+		rc = -ENOMEM;
 		goto out_free_ai;
 	}
 
@@ -1790,10 +1793,10 @@ ssize_t __init pcpu_embed_first_chunk(size_t reserved_size, ssize_t dyn_size)
 		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
 		ai->dyn_size, ai->unit_size);
 
-	ret = pcpu_setup_first_chunk(ai, base);
+	rc = pcpu_setup_first_chunk(ai, base);
 out_free_ai:
 	pcpu_free_alloc_info(ai);
-	return ret;
+	return rc;
 }
 #endif /* CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK ||
 	  !CONFIG_HAVE_SETUP_PER_CPU_AREA */
@@ -1813,13 +1816,12 @@ out_free_ai:
  * page-by-page into vmalloc area.
  *
  * RETURNS:
- * The determined pcpu_unit_size which can be used to initialize
- * percpu access on success, -errno on failure.
+ * 0 on success, -errno on failure.
  */
-ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
-				     pcpu_fc_alloc_fn_t alloc_fn,
-				     pcpu_fc_free_fn_t free_fn,
-				     pcpu_fc_populate_pte_fn_t populate_pte_fn)
+int __init pcpu_page_first_chunk(size_t reserved_size,
+				 pcpu_fc_alloc_fn_t alloc_fn,
+				 pcpu_fc_free_fn_t free_fn,
+				 pcpu_fc_populate_pte_fn_t populate_pte_fn)
 {
 	static struct vm_struct vm;
 	struct pcpu_alloc_info *ai;
@@ -1827,8 +1829,7 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 	int unit_pages;
 	size_t pages_size;
 	struct page **pages;
-	int unit, i, j;
-	ssize_t ret;
+	int unit, i, j, rc;
 
 	snprintf(psize_str, sizeof(psize_str), "%luK", PAGE_SIZE >> 10);
 
@@ -1874,10 +1875,10 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 			populate_pte_fn(unit_addr + (i << PAGE_SHIFT));
 
 		/* pte already populated, the following shouldn't fail */
-		ret = __pcpu_map_pages(unit_addr, &pages[unit * unit_pages],
-				       unit_pages);
-		if (ret < 0)
-			panic("failed to map percpu area, err=%zd\n", ret);
+		rc = __pcpu_map_pages(unit_addr, &pages[unit * unit_pages],
+				      unit_pages);
+		if (rc < 0)
+			panic("failed to map percpu area, err=%d\n", rc);
 
 		/*
 		 * FIXME: Archs with virtual cache should flush local
@@ -1896,17 +1897,17 @@ ssize_t __init pcpu_page_first_chunk(size_t reserved_size,
 		unit_pages, psize_str, vm.addr, ai->static_size,
 		ai->reserved_size, ai->dyn_size);
 
-	ret = pcpu_setup_first_chunk(ai, vm.addr);
+	rc = pcpu_setup_first_chunk(ai, vm.addr);
 	goto out_free_ar;
 
 enomem:
 	while (--j >= 0)
 		free_fn(page_address(pages[j]), PAGE_SIZE);
-	ret = -ENOMEM;
+	rc = -ENOMEM;
 out_free_ar:
 	free_bootmem(__pa(pages), pages_size);
 	pcpu_free_alloc_info(ai);
-	return ret;
+	return rc;
 }
 #endif /* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK */
 
@@ -1977,20 +1978,18 @@ static int __init pcpul_cpu_to_unit(int cpu, const struct pcpu_alloc_info *ai)
  * pcpu_lpage_remapped().
  *
  * RETURNS:
- * The determined pcpu_unit_size which can be used to initialize
- * percpu access on success, -errno on failure.
+ * 0 on success, -errno on failure.
  */
-ssize_t __init pcpu_lpage_first_chunk(const struct pcpu_alloc_info *ai,
-				      pcpu_fc_alloc_fn_t alloc_fn,
-				      pcpu_fc_free_fn_t free_fn,
-				      pcpu_fc_map_fn_t map_fn)
+int __init pcpu_lpage_first_chunk(const struct pcpu_alloc_info *ai,
+				  pcpu_fc_alloc_fn_t alloc_fn,
+				  pcpu_fc_free_fn_t free_fn,
+				  pcpu_fc_map_fn_t map_fn)
 {
 	static struct vm_struct vm;
 	const size_t lpage_size = ai->atom_size;
 	size_t chunk_size, map_size;
 	unsigned int cpu;
-	ssize_t ret;
-	int i, j, unit, nr_units;
+	int i, j, unit, nr_units, rc;
 
 	nr_units = 0;
 	for (i = 0; i < ai->nr_groups; i++)
@@ -2070,7 +2069,7 @@ ssize_t __init pcpu_lpage_first_chunk(const struct pcpu_alloc_info *ai,
 		vm.addr, ai->static_size, ai->reserved_size, ai->dyn_size,
 		ai->unit_size);
 
-	ret = pcpu_setup_first_chunk(ai, vm.addr);
+	rc = pcpu_setup_first_chunk(ai, vm.addr);
 
 	/*
 	 * Sort pcpul_map array for pcpu_lpage_remapped().  Unmapped
@@ -2094,7 +2093,7 @@ ssize_t __init pcpu_lpage_first_chunk(const struct pcpu_alloc_info *ai,
 	while (pcpul_nr_lpages && !pcpul_map[pcpul_nr_lpages - 1].ptr)
 		pcpul_nr_lpages--;
 
-	return ret;
+	return rc;
 
 enomem:
 	for (i = 0; i < pcpul_nr_lpages; i++)
@@ -2166,21 +2165,21 @@ EXPORT_SYMBOL(__per_cpu_offset);
 
 void __init setup_per_cpu_areas(void)
 {
-	ssize_t unit_size;
 	unsigned long delta;
 	unsigned int cpu;
+	int rc;
 
 	/*
 	 * Always reserve area for module percpu variables.  That's
 	 * what the legacy allocator did.
 	 */
-	unit_size = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-					   PERCPU_DYNAMIC_RESERVE);
-	if (unit_size < 0)
+	rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
+				    PERCPU_DYNAMIC_RESERVE);
+	if (rc < 0)
 		panic("Failed to initialized percpu areas.");
 
 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu)
-		__per_cpu_offset[cpu] = delta + cpu * unit_size;
+		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
 }
 #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
-- 
1.6.0.2

