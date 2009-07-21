Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZGUK2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZGUK2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbZGUK2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:37029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105AbZGUK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:27:58 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 18/20] percpu: kill lpage first chunk allocator
Date: Tue, 21 Jul 2009 19:26:17 +0900
Message-Id: <1248171979-29166-19-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With x86 converted to embedding allocator, lpage doesn't have any user
left.  Kill it along with cpa handling code.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>
---
 Documentation/kernel-parameters.txt |   10 +-
 arch/x86/mm/pageattr.c              |   20 +---
 include/linux/percpu.h              |   16 ---
 mm/percpu.c                         |  241 -----------------------------------
 4 files changed, 6 insertions(+), 281 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 89b7568..720b758 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1916,11 +1916,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			See arch/parisc/kernel/pdc_chassis.c
 
 	percpu_alloc=	Select which percpu first chunk allocator to use.
-			Currently supported values are "embed", "page" and
-			"lpage".  Archs may support subset or none of the
-			selections.  See comments in mm/percpu.c for details
-			on each allocator.  This parameter is primarily	for
-			debugging and performance comparison.
+			Currently supported values are "embed" and "page".
+			Archs may support subset or none of the	selections.
+			See comments in mm/percpu.c for details on each
+			allocator.  This parameter is primarily	for debugging
+			and performance comparison.
 
 	pf.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index c106f78..b0a09ba 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -684,7 +684,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 {
 	struct cpa_data alias_cpa;
 	unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
-	unsigned long vaddr, remapped;
+	unsigned long vaddr;
 	int ret;
 
 	if (cpa->pfn >= max_pfn_mapped)
@@ -739,24 +739,6 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	}
 #endif
 
-	/*
-	 * If the PMD page was partially used for per-cpu remapping,
-	 * the recycled area needs to be split and modified.  Because
-	 * the area is always proper subset of a PMD page
-	 * cpa->numpages is guaranteed to be 1 for these areas, so
-	 * there's no need to loop over and check for further remaps.
-	 */
-	remapped = (unsigned long)pcpu_lpage_remapped((void *)laddr);
-	if (remapped) {
-		WARN_ON(cpa->numpages > 1);
-		alias_cpa = *cpa;
-		alias_cpa.vaddr = &remapped;
-		alias_cpa.flags &= ~(CPA_PAGES_ARRAY | CPA_ARRAY);
-		ret = __change_page_attr_set_clr(&alias_cpa, 0);
-		if (ret)
-			return ret;
-	}
-
 	return 0;
 }
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 2535993..878836c 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -82,7 +82,6 @@ enum pcpu_fc {
 	PCPU_FC_AUTO,
 	PCPU_FC_EMBED,
 	PCPU_FC_PAGE,
-	PCPU_FC_LPAGE,
 
 	PCPU_FC_NR,
 };
@@ -95,7 +94,6 @@ typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size,
 typedef void (*pcpu_fc_free_fn_t)(void *ptr, size_t size);
 typedef void (*pcpu_fc_populate_pte_fn_t)(unsigned long addr);
 typedef int (pcpu_fc_cpu_distance_fn_t)(unsigned int from, unsigned int to);
-typedef void (*pcpu_fc_map_fn_t)(void *ptr, size_t size, void *addr);
 
 extern struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
 							     int nr_units);
@@ -124,20 +122,6 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
 #endif
 
-#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
-extern int __init pcpu_lpage_first_chunk(const struct pcpu_alloc_info *ai,
-				pcpu_fc_alloc_fn_t alloc_fn,
-				pcpu_fc_free_fn_t free_fn,
-				pcpu_fc_map_fn_t map_fn);
-
-extern void *pcpu_lpage_remapped(void *kaddr);
-#else
-static inline void *pcpu_lpage_remapped(void *kaddr)
-{
-	return NULL;
-}
-#endif
-
 /*
  * Use this to get to a cpu's version of the per-cpu object
  * dynamically allocated. Non-atomic access to the current CPU's
diff --git a/mm/percpu.c b/mm/percpu.c
index c2826d0..7793392 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1713,7 +1713,6 @@ const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
 	[PCPU_FC_AUTO]	= "auto",
 	[PCPU_FC_EMBED]	= "embed",
 	[PCPU_FC_PAGE]	= "page",
-	[PCPU_FC_LPAGE]	= "lpage",
 };
 
 enum pcpu_fc pcpu_chosen_fc __initdata = PCPU_FC_AUTO;
@@ -1730,10 +1729,6 @@ static int __init percpu_alloc_setup(char *str)
 	else if (!strcmp(str, "page"))
 		pcpu_chosen_fc = PCPU_FC_PAGE;
 #endif
-#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
-	else if (!strcmp(str, "lpage"))
-		pcpu_chosen_fc = PCPU_FC_LPAGE;
-#endif
 	else
 		pr_warning("PERCPU: unknown allocator %s specified\n", str);
 
@@ -1970,242 +1965,6 @@ out_free_ar:
 }
 #endif /* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK */
 
-#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
-struct pcpul_ent {
-	void		*ptr;
-	void		*map_addr;
-};
-
-static size_t pcpul_size;
-static size_t pcpul_lpage_size;
-static int pcpul_nr_lpages;
-static struct pcpul_ent *pcpul_map;
-
-static bool __init pcpul_unit_to_cpu(int unit, const struct pcpu_alloc_info *ai,
-				     unsigned int *cpup)
-{
-	int group, cunit;
-
-	for (group = 0, cunit = 0; group < ai->nr_groups; group++) {
-		const struct pcpu_group_info *gi = &ai->groups[group];
-
-		if (unit < cunit + gi->nr_units) {
-			if (cpup)
-				*cpup = gi->cpu_map[unit - cunit];
-			return true;
-		}
-		cunit += gi->nr_units;
-	}
-
-	return false;
-}
-
-static int __init pcpul_cpu_to_unit(int cpu, const struct pcpu_alloc_info *ai)
-{
-	int group, unit, i;
-
-	for (group = 0, unit = 0; group < ai->nr_groups; group++, unit += i) {
-		const struct pcpu_group_info *gi = &ai->groups[group];
-
-		for (i = 0; i < gi->nr_units; i++)
-			if (gi->cpu_map[i] == cpu)
-				return unit + i;
-	}
-	BUG();
-}
-
-/**
- * pcpu_lpage_first_chunk - remap the first percpu chunk using large page
- * @ai: pcpu_alloc_info
- * @alloc_fn: function to allocate percpu lpage, always called with lpage_size
- * @free_fn: function to free percpu memory, @size <= lpage_size
- * @map_fn: function to map percpu lpage, always called with lpage_size
- *
- * This allocator uses large page to build and map the first chunk.
- * Unlike other helpers, the caller should provide fully initialized
- * @ai.  This can be done using pcpu_build_alloc_info().  This two
- * stage initialization is to allow arch code to evaluate the
- * parameters before committing to it.
- *
- * Large pages are allocated as directed by @unit_map and other
- * parameters and mapped to vmalloc space.  Unused holes are returned
- * to the page allocator.  Note that these holes end up being actively
- * mapped twice - once to the physical mapping and to the vmalloc area
- * for the first percpu chunk.  Depending on architecture, this might
- * cause problem when changing page attributes of the returned area.
- * These double mapped areas can be detected using
- * pcpu_lpage_remapped().
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int __init pcpu_lpage_first_chunk(const struct pcpu_alloc_info *ai,
-				  pcpu_fc_alloc_fn_t alloc_fn,
-				  pcpu_fc_free_fn_t free_fn,
-				  pcpu_fc_map_fn_t map_fn)
-{
-	static struct vm_struct vm;
-	const size_t lpage_size = ai->atom_size;
-	size_t chunk_size, map_size;
-	unsigned int cpu;
-	int i, j, unit, nr_units, rc;
-
-	nr_units = 0;
-	for (i = 0; i < ai->nr_groups; i++)
-		nr_units += ai->groups[i].nr_units;
-
-	chunk_size = ai->unit_size * nr_units;
-	BUG_ON(chunk_size % lpage_size);
-
-	pcpul_size = ai->static_size + ai->reserved_size + ai->dyn_size;
-	pcpul_lpage_size = lpage_size;
-	pcpul_nr_lpages = chunk_size / lpage_size;
-
-	/* allocate pointer array and alloc large pages */
-	map_size = pcpul_nr_lpages * sizeof(pcpul_map[0]);
-	pcpul_map = alloc_bootmem(map_size);
-
-	/* allocate all pages */
-	for (i = 0; i < pcpul_nr_lpages; i++) {
-		size_t offset = i * lpage_size;
-		int first_unit = offset / ai->unit_size;
-		int last_unit = (offset + lpage_size - 1) / ai->unit_size;
-		void *ptr;
-
-		/* find out which cpu is mapped to this unit */
-		for (unit = first_unit; unit <= last_unit; unit++)
-			if (pcpul_unit_to_cpu(unit, ai, &cpu))
-				goto found;
-		continue;
-	found:
-		ptr = alloc_fn(cpu, lpage_size, lpage_size);
-		if (!ptr) {
-			pr_warning("PERCPU: failed to allocate large page "
-				   "for cpu%u\n", cpu);
-			goto enomem;
-		}
-
-		pcpul_map[i].ptr = ptr;
-	}
-
-	/* return unused holes */
-	for (unit = 0; unit < nr_units; unit++) {
-		size_t start = unit * ai->unit_size;
-		size_t end = start + ai->unit_size;
-		size_t off, next;
-
-		/* don't free used part of occupied unit */
-		if (pcpul_unit_to_cpu(unit, ai, NULL))
-			start += pcpul_size;
-
-		/* unit can span more than one page, punch the holes */
-		for (off = start; off < end; off = next) {
-			void *ptr = pcpul_map[off / lpage_size].ptr;
-			next = min(roundup(off + 1, lpage_size), end);
-			if (ptr)
-				free_fn(ptr + off % lpage_size, next - off);
-		}
-	}
-
-	/* allocate address, map and copy */
-	vm.flags = VM_ALLOC;
-	vm.size = chunk_size;
-	vm_area_register_early(&vm, ai->unit_size);
-
-	for (i = 0; i < pcpul_nr_lpages; i++) {
-		if (!pcpul_map[i].ptr)
-			continue;
-		pcpul_map[i].map_addr = vm.addr + i * lpage_size;
-		map_fn(pcpul_map[i].ptr, lpage_size, pcpul_map[i].map_addr);
-	}
-
-	for_each_possible_cpu(cpu)
-		memcpy(vm.addr + pcpul_cpu_to_unit(cpu, ai) * ai->unit_size,
-		       __per_cpu_load, ai->static_size);
-
-	/* we're ready, commit */
-	pr_info("PERCPU: large pages @%p s%zu r%zu d%zu u%zu\n",
-		vm.addr, ai->static_size, ai->reserved_size, ai->dyn_size,
-		ai->unit_size);
-
-	rc = pcpu_setup_first_chunk(ai, vm.addr);
-
-	/*
-	 * Sort pcpul_map array for pcpu_lpage_remapped().  Unmapped
-	 * lpages are pushed to the end and trimmed.
-	 */
-	for (i = 0; i < pcpul_nr_lpages - 1; i++)
-		for (j = i + 1; j < pcpul_nr_lpages; j++) {
-			struct pcpul_ent tmp;
-
-			if (!pcpul_map[j].ptr)
-				continue;
-			if (pcpul_map[i].ptr &&
-			    pcpul_map[i].ptr < pcpul_map[j].ptr)
-				continue;
-
-			tmp = pcpul_map[i];
-			pcpul_map[i] = pcpul_map[j];
-			pcpul_map[j] = tmp;
-		}
-
-	while (pcpul_nr_lpages && !pcpul_map[pcpul_nr_lpages - 1].ptr)
-		pcpul_nr_lpages--;
-
-	return rc;
-
-enomem:
-	for (i = 0; i < pcpul_nr_lpages; i++)
-		if (pcpul_map[i].ptr)
-			free_fn(pcpul_map[i].ptr, lpage_size);
-	free_bootmem(__pa(pcpul_map), map_size);
-	return -ENOMEM;
-}
-
-/**
- * pcpu_lpage_remapped - determine whether a kaddr is in pcpul recycled area
- * @kaddr: the kernel address in question
- *
- * Determine whether @kaddr falls in the pcpul recycled area.  This is
- * used by pageattr to detect VM aliases and break up the pcpu large
- * page mapping such that the same physical page is not mapped under
- * different attributes.
- *
- * The recycled area is always at the tail of a partially used large
- * page.
- *
- * RETURNS:
- * Address of corresponding remapped pcpu address if match is found;
- * otherwise, NULL.
- */
-void *pcpu_lpage_remapped(void *kaddr)
-{
-	unsigned long lpage_mask = pcpul_lpage_size - 1;
-	void *lpage_addr = (void *)((unsigned long)kaddr & ~lpage_mask);
-	unsigned long offset = (unsigned long)kaddr & lpage_mask;
-	int left = 0, right = pcpul_nr_lpages - 1;
-	int pos;
-
-	/* pcpul in use at all? */
-	if (!pcpul_map)
-		return NULL;
-
-	/* okay, perform binary search */
-	while (left <= right) {
-		pos = (left + right) / 2;
-
-		if (pcpul_map[pos].ptr < lpage_addr)
-			left = pos + 1;
-		else if (pcpul_map[pos].ptr > lpage_addr)
-			right = pos - 1;
-		else
-			return pcpul_map[pos].map_addr + offset;
-	}
-
-	return NULL;
-}
-#endif /* CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK */
-
 /*
  * Generic percpu area setup.
  *
-- 
1.6.0.2

