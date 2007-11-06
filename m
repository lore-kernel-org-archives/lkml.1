Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbXKFTyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbXKFTyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbXKFTwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:12 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52117 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755452AbXKFTwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:00 -0500
Message-Id: <20071106195159.250168789@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:51 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/28] cpu alloc: page allocator conversion
Content-Disposition: inline; filename=cpu_alloc_page_alloc
Sender: linux-kernel-owner@vger.kernel.org
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

Hotplug handling is also simplified since cpu alloc can bring up and
shut down cpu areas for a specific cpu as a whole. So there is no need to
allocate or free individual pagesets.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/mm.h     |    4 -
 include/linux/mmzone.h |   12 ---
 mm/page_alloc.c        |  162 +++++++++++++++++++------------------------------
 mm/vmstat.c            |   15 ++--
 4 files changed, 74 insertions(+), 119 deletions(-)

Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h	2007-11-05 18:46:55.654284629 -0800
+++ linux-2.6/include/linux/mmzone.h	2007-11-05 19:37:52.171534088 -0800
@@ -121,13 +121,7 @@ struct per_cpu_pageset {
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
 
 enum zone_type {
 #ifdef CONFIG_ZONE_DMA
@@ -231,10 +225,8 @@ struct zone {
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
--- linux-2.6.orig/mm/page_alloc.c	2007-11-05 18:46:55.670285090 -0800
+++ linux-2.6/mm/page_alloc.c	2007-11-05 19:37:52.171534088 -0800
@@ -43,6 +43,7 @@
 #include <linux/backing-dev.h>
 #include <linux/fault-inject.h>
 #include <linux/page-isolation.h>
+#include <linux/cpu_alloc.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -912,7 +913,7 @@ static void __drain_pages(unsigned int c
 		if (!populated_zone(zone))
 			continue;
 
-		pset = zone_pcp(zone, cpu);
+		pset = CPU_PTR(zone->pageset, cpu);
 		for (i = 0; i < ARRAY_SIZE(pset->pcp); i++) {
 			struct per_cpu_pages *pcp;
 
@@ -1011,8 +1012,8 @@ static void fastcall free_hot_cold_page(
 	arch_free_page(page, 0);
 	kernel_map_pages(page, 1, 0);
 
-	pcp = &zone_pcp(zone, get_cpu())->pcp[cold];
 	local_irq_save(flags);
+	pcp = &THIS_CPU(zone->pageset)->pcp[cold];
 	__count_vm_event(PGFREE);
 	list_add(&page->lru, &pcp->list);
 	set_page_private(page, get_pageblock_migratetype(page));
@@ -1022,7 +1023,6 @@ static void fastcall free_hot_cold_page(
 		pcp->count -= pcp->batch;
 	}
 	local_irq_restore(flags);
-	put_cpu();
 }
 
 void fastcall free_hot_page(struct page *page)
@@ -1064,16 +1064,14 @@ static struct page *buffered_rmqueue(str
 	unsigned long flags;
 	struct page *page;
 	int cold = !!(gfp_flags & __GFP_COLD);
-	int cpu;
 	int migratetype = allocflags_to_migratetype(gfp_flags);
 
 again:
-	cpu  = get_cpu();
 	if (likely(order == 0)) {
 		struct per_cpu_pages *pcp;
 
-		pcp = &zone_pcp(zone, cpu)->pcp[cold];
 		local_irq_save(flags);
+		pcp = &THIS_CPU(zone->pageset)->pcp[cold];
 		if (!pcp->count) {
 			pcp->count = rmqueue_bulk(zone, 0,
 					pcp->batch, &pcp->list, migratetype);
@@ -1106,7 +1104,6 @@ again:
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
 	zone_statistics(zonelist, zone);
 	local_irq_restore(flags);
-	put_cpu();
 
 	VM_BUG_ON(bad_range(zone, page));
 	if (prep_new_page(page, order, gfp_flags))
@@ -1115,7 +1112,6 @@ again:
 
 failed:
 	local_irq_restore(flags);
-	put_cpu();
 	return NULL;
 }
 
@@ -1809,7 +1805,7 @@ void show_free_areas(void)
 		for_each_online_cpu(cpu) {
 			struct per_cpu_pageset *pageset;
 
-			pageset = zone_pcp(zone, cpu);
+			pageset = CPU_PTR(zone->pageset, cpu);
 
 			printk("CPU %4d: Hot: hi:%5d, btch:%4d usd:%4d   "
 			       "Cold: hi:%5d, btch:%4d usd:%4d\n",
@@ -2644,82 +2640,33 @@ static void setup_pagelist_highmark(stru
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
- *
- * The boot_pagesets must be kept even after bootup is complete for
- * unused processors and/or zones. They do play a role for bootstrapping
- * hotplugged processors.
- *
- * zoneinfo_show() and maybe other functions do
- * not check if the processor is online before following the pageset pointer.
- * Other parts of the kernel may not check if the zone is available.
+ * Dynamically allocate memory for the per cpu pageset array in struct zone.
  */
-static struct per_cpu_pageset boot_pageset[NR_CPUS];
-
-/*
- * Dynamically allocate memory for the
- * per cpu pageset array in struct zone.
- */
-static int __cpuinit process_zones(int cpu)
+static void __cpuinit process_zones(int cpu)
 {
-	struct zone *zone, *dzone;
+	struct zone *zone;
 	int node = cpu_to_node(cpu);
 
 	node_set_state(node, N_CPU);	/* this node has a cpu */
 
 	for_each_zone(zone) {
+		struct per_cpu_pageset *pcp =
+				CPU_PTR(zone->pageset, cpu);
 
 		if (!populated_zone(zone))
 			continue;
 
-		zone_pcp(zone, cpu) = kmalloc_node(sizeof(struct per_cpu_pageset),
-					 GFP_KERNEL, node);
-		if (!zone_pcp(zone, cpu))
-			goto bad;
-
-		setup_pageset(zone_pcp(zone, cpu), zone_batchsize(zone));
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
+			setup_pagelist_highmark(pcp, zone->present_pages /
+						percpu_pagelist_fraction);
 
-static inline void free_zone_pagesets(int cpu)
-{
-	struct zone *zone;
-
-	for_each_zone(zone) {
-		struct per_cpu_pageset *pset = zone_pcp(zone, cpu);
-
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
@@ -2730,14 +2677,7 @@ static int __cpuinit pageset_cpuup_callb
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
@@ -2747,21 +2687,34 @@ static int __cpuinit pageset_cpuup_callb
 
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
+	 *
+	 * This is also initializing the cpu areas for the
+	 * pagesets.
 	 */
-	err = process_zones(smp_processor_id());
-	BUG_ON(err);
-	register_cpu_notifier(&pageset_notifier);
-}
+	struct zone *zone;
 
+	for_each_zone(zone) {
+
+		if (!populated_zone(zone))
+			continue;
+
+		zone->pageset = CPU_ALLOC(struct per_cpu_pageset,
+					GFP_KERNEL|__GFP_ZERO);
+		BUG_ON(!zone->pageset);
+	}
+	process_zones(smp_processor_id());
+#ifdef CONFIG_SMP
+	register_cpu_notifier(&pageset_notifier);
 #endif
+}
 
 static noinline __init_refok
 int zone_wait_table_init(struct zone *zone, unsigned long zone_size_pages)
@@ -2808,21 +2761,30 @@ int zone_wait_table_init(struct zone *zo
 
 static __meminit void zone_pcp_init(struct zone *zone)
 {
-	int cpu;
-	unsigned long batch = zone_batchsize(zone);
+	static struct per_cpu_pageset boot_pageset;
 
-	for (cpu = 0; cpu < NR_CPUS; cpu++) {
-#ifdef CONFIG_NUMA
-		/* Early boot. Slab allocator not functional yet */
-		zone_pcp(zone, cpu) = &boot_pageset[cpu];
-		setup_pageset(&boot_pageset[cpu],0);
-#else
-		setup_pageset(zone_pcp(zone,cpu), batch);
-#endif
-	}
+	/*
+	 * Fake a cpu_alloc pointer that can take the required
+	 * offset to get to the boot pageset. This is only
+	 * needed for the boot pageset while bootstrapping
+	 * the new zone. In the course of zone bootstrap
+	 * setup_cpu_pagesets() will do the proper CPU_ALLOC and
+	 * set things up the right way.
+	 *
+	 * Deferral allows CPU_ALLOC() to use the boot pageset
+	 * to allocate the initial memory to get going and then provide
+	 * the proper memory when called from setup_cpu_pagesets() to
+	 * install the proper pagesets.
+	 *
+	 * Deferral also allows slab allocators to perform their
+	 * initialization without resorting to bootmem.
+	 */
+	zone->pageset = &boot_pageset - CPU_OFFSET(smp_processor_id());
+	setup_pageset(&boot_pageset, 0);
 	if (zone->present_pages)
-		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%lu\n",
-			zone->name, zone->present_pages, batch);
+		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%u\n",
+			zone->name, zone->present_pages,
+			zone_batchsize(zone));
 }
 
 __meminit int init_currently_empty_zone(struct zone *zone,
@@ -4237,11 +4199,13 @@ int percpu_pagelist_fraction_sysctl_hand
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
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2007-11-05 19:37:48.142034448 -0800
+++ linux-2.6/include/linux/mm.h	2007-11-05 19:37:52.171534088 -0800
@@ -931,11 +931,7 @@ extern void show_mem(void);
 extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
-#ifdef CONFIG_NUMA
 extern void setup_per_cpu_pageset(void);
-#else
-static inline void setup_per_cpu_pageset(void) {}
-#endif
 
 /* prio_tree.c */
 void vma_prio_tree_add(struct vm_area_struct *, struct vm_area_struct *old);
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2007-11-05 19:37:48.142034448 -0800
+++ linux-2.6/mm/vmstat.c	2007-11-05 19:39:08.322033649 -0800
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
+#include <linux/cpu_alloc.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
@@ -147,7 +148,8 @@ static void refresh_zone_stat_thresholds
 		threshold = calculate_threshold(zone);
 
 		for_each_online_cpu(cpu)
-			zone_pcp(zone, cpu)->stat_threshold = threshold;
+			CPU_PTR(zone->pageset, cpu)->stat_threshold
+							= threshold;
 	}
 }
 
@@ -157,7 +159,8 @@ static void refresh_zone_stat_thresholds
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 				int delta)
 {
-	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	struct per_cpu_pageset *pcp = THIS_CPU(zone->pageset);
+
 	s8 *p = pcp->vm_stat_diff + item;
 	long x;
 
@@ -210,7 +213,7 @@ EXPORT_SYMBOL(mod_zone_page_state);
  */
 void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	struct per_cpu_pageset *pcp = THIS_CPU(zone->pageset);
 	s8 *p = pcp->vm_stat_diff + item;
 
 	(*p)++;
@@ -231,7 +234,7 @@ EXPORT_SYMBOL(__inc_zone_page_state);
 
 void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
-	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	struct per_cpu_pageset *pcp = THIS_CPU(zone->pageset);
 	s8 *p = pcp->vm_stat_diff + item;
 
 	(*p)--;
@@ -307,7 +310,7 @@ void refresh_cpu_vm_stats(int cpu)
 		if (!populated_zone(zone))
 			continue;
 
-		p = zone_pcp(zone, cpu);
+		p = CPU_PTR(zone->pageset, cpu);
 
 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 			if (p->vm_stat_diff[i]) {
@@ -684,7 +687,7 @@ static void zoneinfo_show_print(struct s
 		struct per_cpu_pageset *pageset;
 		int j;
 
-		pageset = zone_pcp(zone, i);
+		pageset = CPU_PTR(zone->pageset, i);
 		for (j = 0; j < ARRAY_SIZE(pageset->pcp); j++) {
 			seq_printf(m,
 				   "\n    cpu: %i pcp: %i"

-- 
