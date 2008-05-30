Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbYE3EHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbYE3EHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYE3EAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:49 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56645 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbYE3EAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:25 -0400
Message-Id: <20080530040022.456883377@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:54 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 34/41] cpu alloc: Page allocator conversion
Content-Disposition: inline; filename=cpu_alloc_page_allocator_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new cpu_alloc functionality to avoid per cpu arrays in struct zone.
This drastically reduces the size of struct zone for systems with a large
amounts of processors and allows placement of critical variables of struct
zone in one cacheline even on very large systems.

Another effect is that the pagesets of one processor are placed near one
another. If multiple pagesets from different zones fit into one cacheline
then additional cacheline fetches can be avoided on the hot paths when
allocating memory from multiple zones.

Surprisingly this clears up much of the painful NUMA bringup. Bootstrap
becomes simpler if we use the same scheme for UP, SMP, NUMA. #ifdefs are
reduced and we can drop the zone_pcp macro.

Hotplug handling is also simplified since hotplug already brings up a
percpu area which comes with a per cpu alloc area. So there is no need to
allocate or free individual pagesets anymore.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/x86/kernel/setup.c |    6 +
 include/linux/gfp.h     |    1 
 include/linux/mm.h      |    4 -
 include/linux/mmzone.h  |   12 ---
 init/main.c             |    5 +
 mm/page_alloc.c         |  172 +++++++++++++++++++-----------------------------
 mm/vmstat.c             |   14 ++-
 7 files changed, 93 insertions(+), 121 deletions(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-05-09 18:46:19.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2008-05-29 19:13:54.000000000 -0700
@@ -1024,11 +1024,7 @@ extern void show_mem(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
-#ifdef CONFIG_NUMA
 extern void setup_per_cpu_pageset(void);
-#else
-static inline void setup_per_cpu_pageset(void) {}
-#endif
 
 /* prio_tree.c */
 void vma_prio_tree_add(struct vm_area_struct *, struct vm_area_struct *old);
Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h	2008-05-28 11:16:24.000000000 -0700
+++ linux-2.6/include/linux/mmzone.h	2008-05-29 19:13:54.000000000 -0700
@@ -123,13 +123,7 @@ struct per_cpu_pageset {
 	s8 stat_threshold;
 	s8 vm_stat_diff[NR_VM_ZONE_STAT_ITEMS];
 #endif
-} ____cacheline_aligned_in_smp;
-
-#ifdef CONFIG_NUMA
-#define zone_pcp(__z, __cpu) ((__z)->pageset[(__cpu)])
-#else
-#define zone_pcp(__z, __cpu) (&(__z)->pageset[(__cpu)])
-#endif
+};
 
 #endif /* !__GENERATING_BOUNDS.H */
 
@@ -224,10 +218,8 @@ struct zone {
 	 */
 	unsigned long		min_unmapped_pages;
 	unsigned long		min_slab_pages;
-	struct per_cpu_pageset	*pageset[NR_CPUS];
-#else
-	struct per_cpu_pageset	pageset[NR_CPUS];
 #endif
+	struct per_cpu_pageset	*pageset;
 	/*
 	 * free areas of different sizes
 	 */
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2008-05-28 11:16:24.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2008-05-29 19:39:58.000000000 -0700
@@ -923,7 +923,7 @@ static void drain_pages(unsigned int cpu
 		if (!populated_zone(zone))
 			continue;
 
-		pset = zone_pcp(zone, cpu);
+		pset = CPU_PTR(zone->pageset, cpu);
 
 		pcp = &pset->pcp;
 		local_irq_save(flags);
@@ -1006,8 +1006,8 @@ static void free_hot_cold_page(struct pa
 	arch_free_page(page, 0);
 	kernel_map_pages(page, 1, 0);
 
-	pcp = &zone_pcp(zone, get_cpu())->pcp;
 	local_irq_save(flags);
+	pcp = &THIS_CPU(zone->pageset)->pcp;
 	__count_vm_event(PGFREE);
 	if (cold)
 		list_add_tail(&page->lru, &pcp->list);
@@ -1020,7 +1020,6 @@ static void free_hot_cold_page(struct pa
 		pcp->count -= pcp->batch;
 	}
 	local_irq_restore(flags);
-	put_cpu();
 }
 
 void free_hot_page(struct page *page)
@@ -1062,16 +1061,14 @@ static struct page *buffered_rmqueue(str
 	unsigned long flags;
 	struct page *page;
 	int cold = !!(gfp_flags & __GFP_COLD);
-	int cpu;
 	int migratetype = allocflags_to_migratetype(gfp_flags);
 
 again:
-	cpu  = get_cpu();
 	if (likely(order == 0)) {
 		struct per_cpu_pages *pcp;
 
-		pcp = &zone_pcp(zone, cpu)->pcp;
 		local_irq_save(flags);
+		pcp = &THIS_CPU(zone->pageset)->pcp;
 		if (!pcp->count) {
 			pcp->count = rmqueue_bulk(zone, 0,
 					pcp->batch, &pcp->list, migratetype);
@@ -1110,7 +1107,6 @@ again:
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(preferred_zone, zone);
 	local_irq_restore(flags);
-	put_cpu();
 
 	VM_BUG_ON(bad_range(zone, page));
 	if (prep_new_page(page, order, gfp_flags))
@@ -1119,7 +1115,6 @@ again:
 
 failed:
 	local_irq_restore(flags);
-	put_cpu();
 	return NULL;
 }
 
@@ -1836,7 +1831,7 @@ void show_free_areas(void)
 		for_each_online_cpu(cpu) {
 			struct per_cpu_pageset *pageset;
 
-			pageset = zone_pcp(zone, cpu);
+			pageset = CPU_PTR(zone->pageset, cpu);
 
 			printk("CPU %4d: hi:%5d, btch:%4d usd:%4d\n",
 			       cpu, pageset->pcp.high,
@@ -2670,82 +2665,77 @@ static void setup_pagelist_highmark(stru
 		pcp->batch = PAGE_SHIFT * 8;
 }
 
-
-#ifdef CONFIG_NUMA
 /*
- * Boot pageset table. One per cpu which is going to be used for all
- * zones and all nodes. The parameters will be set in such a way
- * that an item put on a list will immediately be handed over to
- * the buddy list. This is safe since pageset manipulation is done
- * with interrupts disabled.
- *
- * Some NUMA counter updates may also be caught by the boot pagesets.
+ * The boot_pageset enables bootstrapping of the page allocator
+ * before pagesets can be allocated.
  *
- * The boot_pagesets must be kept even after bootup is complete for
- * unused processors and/or zones. They do play a role for bootstrapping
- * hotplugged processors.
- *
- * zoneinfo_show() and maybe other functions do
- * not check if the processor is online before following the pageset pointer.
- * Other parts of the kernel may not check if the zone is available.
+ * The boot pageset is configued in such a way that therew will be no pages
+ * permanently queued. A page is added to the list and then we reach the
+ * highwater mark and the queue is drained.
+ *
+ * All zone pageset pointers for zones not activated by process_zones() point
+ * to the boot_pageset. Only one processor may be using the pageset at a time
+ * though. So only a single processor may perform bootstrap.
+ */
+static struct per_cpu_pageset boot_pageset = {
+	{
+		.count = 0,
+		.high = 1,
+		.batch = 1,
+		.list = LIST_HEAD_INIT(boot_pageset.pcp.list)
+	}
+};
+
+/*
+ * Initialize a pageset pointer during early boot.
+ * We need to undo the effect that THIS_CPU() would have in order to
+ * have CPU_PTR() return a pointer to the boot pageset.
  */
-static struct per_cpu_pageset boot_pageset[NR_CPUS];
+static void setup_zone_boot_pageset(struct zone *zone)
+{
+	zone->pageset = SHIFT_PERCPU_PTR(&boot_pageset, -my_cpu_offset);
+}
+
+void __cpuinit setup_boot_pagesets(void)
+{
+	struct zone *zone;
+
+	for_each_zone(zone)
+		if (populated_zone(zone))
+			setup_zone_boot_pageset(zone);
+}
 
 /*
- * Dynamically allocate memory for the
- * per cpu pageset array in struct zone.
+ * Prepare the pagesets in struct zone.
  */
-static int __cpuinit process_zones(int cpu)
+static void __cpuinit process_zones(int cpu)
 {
-	struct zone *zone, *dzone;
+	struct zone *zone;
 	int node = cpu_to_node(cpu);
 
 	node_set_state(node, N_CPU);	/* this node has a cpu */
 
 	for_each_zone(zone) {
+		struct per_cpu_pageset *pcp;
 
 		if (!populated_zone(zone))
 			continue;
 
-		zone_pcp(zone, cpu) = kmalloc_node(sizeof(struct per_cpu_pageset),
-					 GFP_KERNEL, node);
-		if (!zone_pcp(zone, cpu))
-			goto bad;
+		if (CPU_PTR(zone->pageset, cpu) == &boot_pageset)
+			zone->pageset = CPU_ALLOC(struct per_cpu_pageset,
+						GFP_KERNEL|__GFP_ZERO);
 
-		setup_pageset(zone_pcp(zone, cpu), zone_batchsize(zone));
+		pcp = CPU_PTR(zone->pageset, cpu);
+		setup_pageset(pcp, zone_batchsize(zone));
 
 		if (percpu_pagelist_fraction)
-			setup_pagelist_highmark(zone_pcp(zone, cpu),
-			 	(zone->present_pages / percpu_pagelist_fraction));
-	}
-
-	return 0;
-bad:
-	for_each_zone(dzone) {
-		if (!populated_zone(dzone))
-			continue;
-		if (dzone == zone)
-			break;
-		kfree(zone_pcp(dzone, cpu));
-		zone_pcp(dzone, cpu) = NULL;
-	}
-	return -ENOMEM;
-}
-
-static inline void free_zone_pagesets(int cpu)
-{
-	struct zone *zone;
-
-	for_each_zone(zone) {
-		struct per_cpu_pageset *pset = zone_pcp(zone, cpu);
+			setup_pagelist_highmark(pcp, zone->present_pages /
+						percpu_pagelist_fraction);
 
-		/* Free per_cpu_pageset if it is slab allocated */
-		if (pset != &boot_pageset[cpu])
-			kfree(pset);
-		zone_pcp(zone, cpu) = NULL;
 	}
 }
 
+#ifdef CONFIG_SMP
 static int __cpuinit pageset_cpuup_callback(struct notifier_block *nfb,
 		unsigned long action,
 		void *hcpu)
@@ -2756,14 +2746,7 @@ static int __cpuinit pageset_cpuup_callb
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (process_zones(cpu))
-			ret = NOTIFY_BAD;
-		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		free_zone_pagesets(cpu);
+		process_zones(cpu);
 		break;
 	default:
 		break;
@@ -2773,21 +2756,20 @@ static int __cpuinit pageset_cpuup_callb
 
 static struct notifier_block __cpuinitdata pageset_notifier =
 	{ &pageset_cpuup_callback, NULL, 0 };
+#endif
 
 void __init setup_per_cpu_pageset(void)
 {
-	int err;
-
-	/* Initialize per_cpu_pageset for cpu 0.
+	/*
+	 * Initialize per_cpu settings for the boot cpu.
 	 * A cpuup callback will do this for every cpu
-	 * as it comes online
+	 * as it comes online.
 	 */
-	err = process_zones(smp_processor_id());
-	BUG_ON(err);
+	process_zones(smp_processor_id());
+#ifdef CONFIG_SMP
 	register_cpu_notifier(&pageset_notifier);
-}
-
 #endif
+}
 
 static noinline __init_refok
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
@@ -2832,25 +2814,6 @@ int zone_wait_table_init(struct zone *zo
 	return 0;
 }
 
-static __meminit void zone_pcp_init(struct zone *zone)
-{
-	int cpu;
-	unsigned long batch = zone_batchsize(zone);
-
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
-#ifdef CONFIG_NUMA
-		/* Early boot. Slab allocator not functional yet */
-		zone_pcp(zone, cpu) = &boot_pageset[cpu];
-		setup_pageset(&boot_pageset[cpu],0);
-#else
-		setup_pageset(zone_pcp(zone,cpu), batch);
-#endif
-	}
-	if (zone->present_pages)
-		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%lu\n",
-			zone->name, zone->present_pages, batch);
-}
-
 __meminit int init_currently_empty_zone(struct zone *zone,
 					unsigned long zone_start_pfn,
 					unsigned long size,
@@ -3420,7 +3383,12 @@ static void __paginginit free_area_init_
 
 		zone->prev_priority = DEF_PRIORITY;
 
-		zone_pcp_init(zone);
+		setup_zone_boot_pageset(zone);
+		if (zone->present_pages)
+			printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%u\n",
+				zone->name, zone->present_pages,
+				zone_batchsize(zone));
+
 		INIT_LIST_HEAD(&zone->active_list);
 		INIT_LIST_HEAD(&zone->inactive_list);
 		zone->nr_scan_active = 0;
@@ -4295,11 +4263,13 @@ int percpu_pagelist_fraction_sysctl_hand
 	ret = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
 	if (!write || (ret == -EINVAL))
 		return ret;
-	for_each_zone(zone) {
-		for_each_online_cpu(cpu) {
+	for_each_online_cpu(cpu) {
+		for_each_zone(zone) {
 			unsigned long  high;
+
 			high = zone->present_pages / percpu_pagelist_fraction;
-			setup_pagelist_highmark(zone_pcp(zone, cpu), high);
+			setup_pagelist_highmark(CPU_PTR(zone->pageset, cpu),
+									high);
 		}
 	}
 	return 0;
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2008-05-29 19:13:53.000000000 -0700
+++ linux-2.6/mm/vmstat.c	2008-05-29 19:13:54.000000000 -0700
@@ -142,7 +142,8 @@ static void refresh_zone_stat_thresholds
 		threshold = calculate_threshold(zone);
 
 		for_each_online_cpu(cpu)
-			zone_pcp(zone, cpu)->stat_threshold = threshold;
+			CPU_PTR(zone->pageset, cpu)->stat_threshold
+							= threshold;
 	}
 }
 
@@ -152,7 +153,8 @@ static void refresh_zone_stat_thresholds
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 				int delta)
 {
-	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	struct per_cpu_pageset *pcp = THIS_CPU(zone->pageset);
+
 	s8 *p = pcp->vm_stat_diff + item;
 	long x;
 
@@ -205,7 +207,7 @@ EXPORT_SYMBOL(mod_zone_page_state);
  */
 void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	struct per_cpu_pageset *pcp = THIS_CPU(zone->pageset);
 	s8 *p = pcp->vm_stat_diff + item;
 
 	(*p)++;
@@ -226,7 +228,7 @@ EXPORT_SYMBOL(__inc_zone_page_state);
 
 void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	struct per_cpu_pageset *pcp = THIS_CPU(zone->pageset);
 	s8 *p = pcp->vm_stat_diff + item;
 
 	(*p)--;
@@ -306,7 +308,7 @@ void refresh_cpu_vm_stats(int cpu)
 		if (!populated_zone(zone))
 			continue;
 
-		p = zone_pcp(zone, cpu);
+		p = CPU_PTR(zone->pageset, cpu);
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 			if (p->vm_stat_diff[i]) {
@@ -698,7 +700,7 @@ static void zoneinfo_show_print(struct s
 	for_each_online_cpu(i) {
 		struct per_cpu_pageset *pageset;
 
-		pageset = zone_pcp(zone, i);
+		pageset = CPU_PTR(zone->pageset, i);
 		seq_printf(m,
 			   "\n    cpu: %i"
 			   "\n              count: %i"
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c	2008-05-29 19:13:53.000000000 -0700
+++ linux-2.6/arch/x86/kernel/setup.c	2008-05-29 19:40:08.000000000 -0700
@@ -125,6 +125,12 @@ void __init setup_per_cpu_areas(void)
 		highest_cpu = i;
 	}
 
+	/*
+	 * The per_cpu offsets have changed and therefore the pageset
+	 * pointers need to be updated.
+	 */
+	setup_boot_pagesets();
+
 	nr_cpu_ids = highest_cpu + 1;
 	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d\n", NR_CPUS, nr_cpu_ids);
 
Index: linux-2.6/include/linux/gfp.h
===================================================================
--- linux-2.6.orig/include/linux/gfp.h	2008-04-29 12:13:29.000000000 -0700
+++ linux-2.6/include/linux/gfp.h	2008-05-29 19:13:54.000000000 -0700
@@ -233,5 +233,6 @@ void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(void);
 void drain_local_pages(void *dummy);
+void setup_boot_pagesets(void);
 
 #endif /* __LINUX_GFP_H */
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c	2008-05-29 19:13:53.000000000 -0700
+++ linux-2.6/init/main.c	2008-05-29 19:13:54.000000000 -0700
@@ -405,6 +405,11 @@ static void __init setup_per_cpu_areas(v
 		memcpy(ptr, __per_cpu_start, __per_cpu_size);
 		ptr += __per_cpu_size;
 	}
+	/*
+	 * __per_cpu_offset[] have changed. Need to update the
+	 * pointers to the boot page set.
+	 */
+	setup_boot_pagesets();
 }
 #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
 

-- 
