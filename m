Return-Path: <linux-kernel-owner+w=401wt.eu-S1763166AbYDOJMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763166AbYDOJMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbYDOJMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:12:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44108 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbYDOJMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:12:13 -0400
Date: Tue, 15 Apr 2008 11:11:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415091134.GA23497@elte.hu>
References: <20080411074145.GA4944@elte.hu> <84144f020804110121l8444aafl4631071b34c458fe@mail.gmail.com> <84144f020804110150q367260f6k473380a1309db878@mail.gmail.com> <20080411085411.GA10181@elte.hu> <84144f020804110205u3d073e76lbcdd36ec293a169b@mail.gmail.com> <84144f020804110208m41414c0h2ed71b85efbb426c@mail.gmail.com> <84144f020804110211w4ae41414od24cf2de72453e13@mail.gmail.com> <20080415062534.GA9172@elte.hu> <84144f020804142341ic4621c9o6de06d68eee74871@mail.gmail.com> <20080415070811.GA15499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415070811.GA15499@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> i did a .config bisection and it pinpointed CONFIG_SPARSEMEM=y as the 
> culprit. Changing it to FLATMEM gives a correctly booting system.
> 
> if you look at the good versus bad bootup log:
> 
>   http://redhat.com/~mingo/misc/log-Tue_Apr_15_07_24_59_CEST_2008.good
>   http://redhat.com/~mingo/misc/log-Tue_Apr_15_07_24_59_CEST_2008.bad
> 
> (both SLUB) you'll see that the zone layout provided by the 
> architecture code is _exactly_ the same and looks sane as well. So 
> this is not an architecture zone layout bug, this is probably 
> sparsemem setup (and/or the page allocator) getting confused by 
> something.

i've done a revert of the page allocator to v2.6.24 status (with fixes 
ontop to make it work on .25 infrastructure), via the patch below - but 
this didnt change the problem.

i also doubled the sparse mem_map[] allocations on the theory that they 
might overflow - but that didnt solve the crash either.

	Ingo

------------------------>
Subject: revert: page alloc
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Apr 15 10:44:34 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/gfp.h    |    2 
 include/linux/mmzone.h |    2 
 mm/page_alloc.c        |  169 ++++++++++++++++++++++---------------------------
 mm/vmstat.c            |   61 ++++++++---------
 4 files changed, 110 insertions(+), 124 deletions(-)

Index: linux/include/linux/gfp.h
===================================================================
--- linux.orig/include/linux/gfp.h
+++ linux/include/linux/gfp.h
@@ -227,7 +227,5 @@ extern void free_cold_page(struct page *
 
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
-void drain_all_pages(void);
-void drain_local_pages(void *dummy);
 
 #endif /* __LINUX_GFP_H */
Index: linux/include/linux/mmzone.h
===================================================================
--- linux.orig/include/linux/mmzone.h
+++ linux/include/linux/mmzone.h
@@ -113,7 +113,7 @@ struct per_cpu_pages {
 };
 
 struct per_cpu_pageset {
-	struct per_cpu_pages pcp;
+	struct per_cpu_pages pcp[2];	/* 0: hot.  1: cold */
 #ifdef CONFIG_NUMA
 	s8 expire;
 #endif
Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -19,7 +19,6 @@
 #include <linux/swap.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
-#include <linux/jiffies.h>
 #include <linux/bootmem.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
@@ -44,7 +43,6 @@
 #include <linux/backing-dev.h>
 #include <linux/fault-inject.h>
 #include <linux/page-isolation.h>
-#include <linux/memcontrol.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -222,19 +220,13 @@ static inline int bad_range(struct zone 
 
 static void bad_page(struct page *page)
 {
-	void *pc = page_get_page_cgroup(page);
-
-	printk(KERN_EMERG "Bad page state in process '%s'\n" KERN_EMERG
-		"page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n",
+	printk(KERN_EMERG "Bad page state in process '%s'\n"
+		KERN_EMERG "page:%p flags:0x%0*lx mapping:%p mapcount:%d count:%d\n"
+		KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
+		KERN_EMERG "Backtrace:\n",
 		current->comm, page, (int)(2*sizeof(unsigned long)),
 		(unsigned long)page->flags, page->mapping,
 		page_mapcount(page), page_count(page));
-	if (pc) {
-		printk(KERN_EMERG "cgroup:%p\n", pc);
-		page_reset_bad_cgroup(page);
-	}
-	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
-		KERN_EMERG "Backtrace:\n");
 	dump_stack();
 	page->flags &= ~(1 << PG_lru	|
 			1 << PG_private |
@@ -460,7 +452,6 @@ static inline int free_pages_check(struc
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
-		(page_get_page_cgroup(page) != NULL) |
 		(page_count(page) != 0)  |
 		(page->flags & (
 			1 << PG_lru	|
@@ -610,7 +601,6 @@ static int prep_new_page(struct page *pa
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
-		(page_get_page_cgroup(page) != NULL) |
 		(page_count(page) != 0)  |
 		(page->flags & (
 			1 << PG_lru	|
@@ -900,51 +890,31 @@ void drain_zone_pages(struct zone *zone,
 }
 #endif
 
-/*
- * Drain pages of the indicated processor.
- *
- * The processor must either be the current processor and the
- * thread pinned to the current processor or a processor that
- * is not online.
- */
-static void drain_pages(unsigned int cpu)
+static void __drain_pages(unsigned int cpu)
 {
 	unsigned long flags;
 	struct zone *zone;
+	int i;
 
 	for_each_zone(zone) {
 		struct per_cpu_pageset *pset;
-		struct per_cpu_pages *pcp;
 
 		if (!populated_zone(zone))
 			continue;
 
 		pset = zone_pcp(zone, cpu);
+		for (i = 0; i < ARRAY_SIZE(pset->pcp); i++) {
+			struct per_cpu_pages *pcp;
 
-		pcp = &pset->pcp;
-		local_irq_save(flags);
-		free_pages_bulk(zone, pcp->count, &pcp->list, 0);
-		pcp->count = 0;
-		local_irq_restore(flags);
+			pcp = &pset->pcp[i];
+			local_irq_save(flags);
+			free_pages_bulk(zone, pcp->count, &pcp->list, 0);
+			pcp->count = 0;
+			local_irq_restore(flags);
+		}
 	}
 }
 
-/*
- * Spill all of this CPU's per-cpu pages back into the buddy allocator.
- */
-void drain_local_pages(void *arg)
-{
-	drain_pages(smp_processor_id());
-}
-
-/*
- * Spill all the per-cpu pages from all CPUs back into the buddy allocator
- */
-void drain_all_pages(void)
-{
-	on_each_cpu(drain_local_pages, NULL, 0, 1);
-}
-
 #ifdef CONFIG_HIBERNATION
 
 void mark_free_pages(struct zone *zone)
@@ -982,6 +952,37 @@ void mark_free_pages(struct zone *zone)
 #endif /* CONFIG_PM */
 
 /*
+ * Spill all of this CPU's per-cpu pages back into the buddy allocator.
+ */
+void drain_local_pages(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);	
+	__drain_pages(smp_processor_id());
+	local_irq_restore(flags);	
+}
+
+void smp_drain_local_pages(void *arg)
+{
+	drain_local_pages();
+}
+
+/*
+ * Spill all the per-cpu pages from all CPUs back into the buddy allocator
+ */
+void drain_all_local_pages(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__drain_pages(smp_processor_id());
+	local_irq_restore(flags);
+
+	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
+}
+
+/*
  * Free a 0-order page
  */
 static void free_hot_cold_page(struct page *page, int cold)
@@ -1000,13 +1001,10 @@ static void free_hot_cold_page(struct pa
 	arch_free_page(page, 0);
 	kernel_map_pages(page, 1, 0);
 
-	pcp = &zone_pcp(zone, get_cpu())->pcp;
+	pcp = &zone_pcp(zone, get_cpu())->pcp[cold];
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
-	if (cold)
-		list_add_tail(&page->lru, &pcp->list);
-	else
-		list_add(&page->lru, &pcp->list);
+	list_add(&page->lru, &pcp->list);
 	set_page_private(page, get_pageblock_migratetype(page));
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
@@ -1064,7 +1062,7 @@ again:
 	if (likely(order == 0)) {
 		struct per_cpu_pages *pcp;
 
-		pcp = &zone_pcp(zone, cpu)->pcp;
+		pcp = &zone_pcp(zone, cpu)->pcp[cold];
 		local_irq_save(flags);
 		if (!pcp->count) {
 			pcp->count = rmqueue_bulk(zone, 0,
@@ -1074,15 +1072,9 @@ again:
 		}
 
 		/* Find a page of the appropriate migrate type */
-		if (cold) {
-			list_for_each_entry_reverse(page, &pcp->list, lru)
-				if (page_private(page) == migratetype)
-					break;
-		} else {
-			list_for_each_entry(page, &pcp->list, lru)
-				if (page_private(page) == migratetype)
-					break;
-		}
+		list_for_each_entry(page, &pcp->list, lru)
+			if (page_private(page) == migratetype)
+				break;
 
 		/* Allocate more to the pcp list if necessary */
 		if (unlikely(&page->lru == &pcp->list)) {
@@ -1284,7 +1276,7 @@ static nodemask_t *zlc_setup(struct zone
 	if (!zlc)
 		return NULL;
 
-       if (time_after(jiffies, zlc->last_full_zap + HZ)) {
+	if (jiffies - zlc->last_full_zap > 1 * HZ) {
 		bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
 		zlc->last_full_zap = jiffies;
 	}
@@ -1578,7 +1570,7 @@ nofail_alloc:
 	cond_resched();
 
 	if (order != 0)
-		drain_all_pages();
+		drain_all_local_pages();
 
 	if (likely(did_some_progress)) {
 		page = get_page_from_freelist(gfp_mask, order,
@@ -1810,9 +1802,12 @@ void show_free_areas(void)
 
 			pageset = zone_pcp(zone, cpu);
 
-			printk("CPU %4d: hi:%5d, btch:%4d usd:%4d\n",
-			       cpu, pageset->pcp.high,
-			       pageset->pcp.batch, pageset->pcp.count);
+			printk("CPU %4d: Hot: hi:%5d, btch:%4d usd:%4d   "
+			       "Cold: hi:%5d, btch:%4d usd:%4d\n",
+			       cpu, pageset->pcp[0].high,
+			       pageset->pcp[0].batch, pageset->pcp[0].count,
+			       pageset->pcp[1].high, pageset->pcp[1].batch,
+			       pageset->pcp[1].count);
 		}
 	}
 
@@ -1885,8 +1880,6 @@ void show_free_areas(void)
 		printk("= %lukB\n", K(total));
 	}
 
-	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
-
 	show_swap_cache_info();
 }
 
@@ -2559,7 +2552,8 @@ void __meminit memmap_init_zone(unsigned
 	}
 }
 
-static void __meminit zone_init_free_lists(struct zone *zone)
+static void __meminit zone_init_free_lists(struct pglist_data *pgdat,
+				struct zone *zone, unsigned long size)
 {
 	int order, t;
 	for_each_migratetype_order(order, t) {
@@ -2573,7 +2567,7 @@ static void __meminit zone_init_free_lis
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int zone_batchsize(struct zone *zone)
+static int __devinit zone_batchsize(struct zone *zone)
 {
 	int batch;
 
@@ -2611,11 +2605,17 @@ inline void setup_pageset(struct per_cpu
 
 	memset(p, 0, sizeof(*p));
 
-	pcp = &p->pcp;
+	pcp = &p->pcp[0];		/* hot */
 	pcp->count = 0;
 	pcp->high = 6 * batch;
 	pcp->batch = max(1UL, 1 * batch);
 	INIT_LIST_HEAD(&pcp->list);
+
+	pcp = &p->pcp[1];		/* cold*/
+	pcp->count = 0;
+	pcp->high = 2 * batch;
+	pcp->batch = max(1UL, batch/2);
+	INIT_LIST_HEAD(&pcp->list);
 }
 
 /*
@@ -2628,7 +2628,7 @@ static void setup_pagelist_highmark(stru
 {
 	struct per_cpu_pages *pcp;
 
-	pcp = &p->pcp;
+	pcp = &p->pcp[0]; /* hot list */
 	pcp->high = high;
 	pcp->batch = max(1UL, high/4);
 	if ((high/4) > (PAGE_SHIFT * 8))
@@ -2832,7 +2832,7 @@ __meminit int init_currently_empty_zone(
 
 	memmap_init(size, pgdat->node_id, zone_idx(zone), zone_start_pfn);
 
-	zone_init_free_lists(zone);
+	zone_init_free_lists(pgdat, zone, zone->spanned_pages);
 
 	return 0;
 }
@@ -3322,7 +3322,7 @@ static inline int pageblock_default_orde
  *   - mark all memory queues empty
  *   - clear the memory bitmaps
  */
-static void __paginginit free_area_init_core(struct pglist_data *pgdat,
+static void __meminit free_area_init_core(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
 {
 	enum zone_type j;
@@ -3439,14 +3439,14 @@ static void __init_refok alloc_node_mem_
 		mem_map = NODE_DATA(0)->node_mem_map;
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
-			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
+			mem_map -= pgdat->node_start_pfn;
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 	}
 #endif
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
 
-void __paginginit free_area_init_node(int nid, struct pglist_data *pgdat,
+void __meminit free_area_init_node(int nid, struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long node_start_pfn,
 		unsigned long *zholes_size)
 {
@@ -3988,23 +3988,10 @@ static int page_alloc_cpu_notify(struct 
 	int cpu = (unsigned long)hcpu;
 
 	if (action == CPU_DEAD || action == CPU_DEAD_FROZEN) {
-		drain_pages(cpu);
-
-		/*
-		 * Spill the event counters of the dead processor
-		 * into the current processors event counters.
-		 * This artificially elevates the count of the current
-		 * processor.
-		 */
+		local_irq_disable();
+		__drain_pages(cpu);
 		vm_events_fold_cpu(cpu);
-
-		/*
-		 * Zero the differential counters of the dead processor
-		 * so that the vm statistics are consistent.
-		 *
-		 * This is only okay since the processor is dead and cannot
-		 * race with what we are doing.
-		 */
+		local_irq_enable();
 		refresh_cpu_vm_stats(cpu);
 	}
 	return NOTIFY_OK;
@@ -4503,7 +4490,7 @@ int set_migratetype_isolate(struct page 
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret)
-		drain_all_pages();
+		drain_all_local_pages();
 	return ret;
 }
 
Index: linux/mm/vmstat.c
===================================================================
--- linux.orig/mm/vmstat.c
+++ linux/mm/vmstat.c
@@ -21,14 +21,21 @@ EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
 static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
 {
-	int cpu;
+	int cpu = 0;
 	int i;
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu_mask(cpu, *cpumask) {
+	cpu = first_cpu(*cpumask);
+	while (cpu < NR_CPUS) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
+		cpu = next_cpu(cpu, *cpumask);
+
+		if (cpu < NR_CPUS)
+			prefetch(&per_cpu(vm_event_states, cpu));
+
+
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
 			ret[i] += this->event[i];
 	}
@@ -277,10 +284,6 @@ EXPORT_SYMBOL(dec_zone_page_state);
 /*
  * Update the zone counters for one cpu.
  *
- * The cpu specified must be either the current cpu or a processor that
- * is not online. If it is the current cpu then the execution thread must
- * be pinned to the current cpu.
- *
  * Note that refresh_cpu_vm_stats strives to only access
  * node local memory. The per cpu pagesets on remote zones are placed
  * in the memory local to the processor using that pageset. So the
@@ -296,7 +299,7 @@ void refresh_cpu_vm_stats(int cpu)
 {
 	struct zone *zone;
 	int i;
-	int global_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
+	unsigned long flags;
 
 	for_each_zone(zone) {
 		struct per_cpu_pageset *p;
@@ -308,19 +311,15 @@ void refresh_cpu_vm_stats(int cpu)
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 			if (p->vm_stat_diff[i]) {
-				unsigned long flags;
-				int v;
-
 				local_irq_save(flags);
-				v = p->vm_stat_diff[i];
+				zone_page_state_add(p->vm_stat_diff[i],
+					zone, i);
 				p->vm_stat_diff[i] = 0;
-				local_irq_restore(flags);
-				atomic_long_add(v, &zone->vm_stat[i]);
-				global_diff[i] += v;
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
 				p->expire = 3;
 #endif
+				local_irq_restore(flags);
 			}
 #ifdef CONFIG_NUMA
 		/*
@@ -330,7 +329,7 @@ void refresh_cpu_vm_stats(int cpu)
 		 * Check if there are pages remaining in this pageset
 		 * if not then there is nothing to expire.
 		 */
-		if (!p->expire || !p->pcp.count)
+		if (!p->expire || (!p->pcp[0].count && !p->pcp[1].count))
 			continue;
 
 		/*
@@ -345,14 +344,13 @@ void refresh_cpu_vm_stats(int cpu)
 		if (p->expire)
 			continue;
 
-		if (p->pcp.count)
-			drain_zone_pages(zone, &p->pcp);
+		if (p->pcp[0].count)
+			drain_zone_pages(zone, p->pcp + 0);
+
+		if (p->pcp[1].count)
+			drain_zone_pages(zone, p->pcp + 1);
 #endif
 	}
-
-	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
-		if (global_diff[i])
-			atomic_long_add(global_diff[i], &vm_stat[i]);
 }
 
 #endif
@@ -683,17 +681,20 @@ static void zoneinfo_show_print(struct s
 		   "\n  pagesets");
 	for_each_online_cpu(i) {
 		struct per_cpu_pageset *pageset;
+		int j;
 
 		pageset = zone_pcp(zone, i);
-		seq_printf(m,
-			   "\n    cpu: %i"
-			   "\n              count: %i"
-			   "\n              high:  %i"
-			   "\n              batch: %i",
-			   i,
-			   pageset->pcp.count,
-			   pageset->pcp.high,
-			   pageset->pcp.batch);
+		for (j = 0; j < ARRAY_SIZE(pageset->pcp); j++) {
+			seq_printf(m,
+				   "\n    cpu: %i pcp: %i"
+				   "\n              count: %i"
+				   "\n              high:  %i"
+				   "\n              batch: %i",
+				   i, j,
+				   pageset->pcp[j].count,
+				   pageset->pcp[j].high,
+				   pageset->pcp[j].batch);
+			}
 #ifdef CONFIG_SMP
 		seq_printf(m, "\n  vm stats threshold: %d",
 				pageset->stat_threshold);
