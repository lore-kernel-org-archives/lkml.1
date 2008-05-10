Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbYEJDOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbYEJDOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYEJDJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:09:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54134 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751649AbYEJDJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:09:17 -0400
Message-Id: <20080510030916.706550694@sgi.com>
References: <20080510030831.796641881@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 20:08:40 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Subject: [patch 09/21] slub: Trigger defragmentation from memory reclaim
Content-Disposition: inline; filename=0009-SLUB-Trigger-defragmentation-from-memory-reclaim.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch triggers slab defragmentation from memory reclaim. The logical
point for this is after slab shrinking was performed in vmscan.c. At that point
the fragmentation ratio of a slab was increased because objects were freed via
the LRU lists maitained for various slab caches.
So we call kmem_cache_defrag() from there.

shrink_slab() is called in some contexts to do global shrinking
of slabs and in others to do shrinking for a particular zone. Pass the zone to
shrink_slab(), so that slab_shrink() can call kmem_cache_defrag() and restrict
the defragmentation to the node that is under memory pressure.

The callback frequency into slab reclaim can be controlled by a new field
/proc/sys/vm/slab_defrag_limit.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 Documentation/sysctl/vm.txt |   12 ++++++++
 fs/drop_caches.c            |    2 -
 include/linux/mm.h          |    3 --
 include/linux/mmzone.h      |    1 
 include/linux/swap.h        |    3 ++
 kernel/sysctl.c             |   20 +++++++++++++
 mm/vmscan.c                 |   65 +++++++++++++++++++++++++++++++++++++++-----
 mm/vmstat.c                 |    2 +
 8 files changed, 98 insertions(+), 10 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2008-05-08 17:24:44.000000000 -0700
+++ linux-2.6/fs/drop_caches.c	2008-05-09 15:13:31.000000000 -0700
@@ -58,7 +58,7 @@ static void drop_slab(void)
 	int nr_objects;
 
 	do {
-		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000);
+		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000, NULL);
 	} while (nr_objects > 10);
 }
 
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-05-08 17:27:30.000000000 -0700
+++ linux-2.6/include/linux/mm.h	2008-05-09 15:13:31.000000000 -0700
@@ -1242,8 +1242,7 @@ int in_gate_area_no_task(unsigned long a
 int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-			unsigned long lru_pages);
-
+				unsigned long lru_pages, struct zone *z);
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
 #else
Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2008-05-08 17:24:45.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2008-05-09 15:13:32.000000000 -0700
@@ -149,6 +149,14 @@ void unregister_shrinker(struct shrinker
 EXPORT_SYMBOL(unregister_shrinker);
 
 #define SHRINK_BATCH 128
+
+/*
+ * Trigger a call into slab defrag if the sum of the returns from
+ * shrinkers cross this value.
+ */
+int slab_defrag_limit = 1000;
+int slab_defrag_counter;
+
 /*
  * Call the shrink functions to age shrinkable caches
  *
@@ -166,10 +174,18 @@ EXPORT_SYMBOL(unregister_shrinker);
  * are eligible for the caller's allocation attempt.  It is used for balancing
  * slab reclaim versus page reclaim.
  *
+ * zone is the zone for which we are shrinking the slabs. If the intent
+ * is to do a global shrink then zone may be NULL. Specification of a
+ * zone is currently only used to limit slab defragmentation to a NUMA node.
+ * The performace of shrink_slab would be better (in particular under NUMA)
+ * if it could be targeted as a whole to the zone that is under memory
+ * pressure but the VFS infrastructure does not allow that at the present
+ * time.
+ *
  * Returns the number of slab objects which we shrunk.
  */
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-			unsigned long lru_pages)
+			unsigned long lru_pages, struct zone *zone)
 {
 	struct shrinker *shrinker;
 	unsigned long ret = 0;
@@ -226,6 +242,39 @@ unsigned long shrink_slab(unsigned long 
 		shrinker->nr += total_scan;
 	}
 	up_read(&shrinker_rwsem);
+
+
+	/* Avoid dirtying cachelines */
+	if (!ret)
+		return 0;
+
+	/*
+	 * "ret" doesnt really contain the freed object count. The shrinkers
+	 * fake it. Gotta go with what we are getting though.
+	 *
+	 * Handling of the defrag_counter is also racy. If we get the
+	 * wrong counts then we may unnecessarily do a defrag pass or defer
+	 * one. "ret" is already faked. So this is just increasing
+	 * the already existing fuzziness to get some notion as to when
+	 * to initiate slab defrag which will hopefully be okay.
+	 */
+	if (zone) {
+		/* balance_pgdat running on a zone so we only scan one node */
+		zone->slab_defrag_counter += ret;
+		if (zone->slab_defrag_counter > slab_defrag_limit &&
+						(gfp_mask & __GFP_FS)) {
+			zone->slab_defrag_counter = 0;
+			kmem_cache_defrag(zone_to_nid(zone));
+		}
+	} else {
+		/* Direct (and thus global) reclaim. Scan all nodes */
+		slab_defrag_counter += ret;
+		if (slab_defrag_counter > slab_defrag_limit &&
+						(gfp_mask & __GFP_FS)) {
+			slab_defrag_counter = 0;
+			kmem_cache_defrag(-1);
+		}
+	}
 	return ret;
 }
 
@@ -1342,7 +1391,7 @@ static unsigned long do_try_to_free_page
 		 * over limit cgroups
 		 */
 		if (scan_global_lru(sc)) {
-			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
+			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages, NULL);
 			if (reclaim_state) {
 				nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -1567,7 +1616,7 @@ loop_again:
 				nr_reclaimed += shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
-						lru_pages);
+						lru_pages, zone);
 			nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 			if (zone_is_all_unreclaimable(zone))
@@ -1806,7 +1855,7 @@ unsigned long shrink_all_memory(unsigned
 	/* If slab caches are huge, it's better to hit them first */
 	while (nr_slab >= lru_pages) {
 		reclaim_state.reclaimed_slab = 0;
-		shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
+		shrink_slab(nr_pages, sc.gfp_mask, lru_pages, NULL);
 		if (!reclaim_state.reclaimed_slab)
 			break;
 
@@ -1844,7 +1893,7 @@ unsigned long shrink_all_memory(unsigned
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-					count_lru_pages());
+					count_lru_pages(), NULL);
 			ret += reclaim_state.reclaimed_slab;
 			if (ret >= nr_pages)
 				goto out;
@@ -1861,7 +1910,8 @@ unsigned long shrink_all_memory(unsigned
 	if (!ret) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask, count_lru_pages());
+			shrink_slab(nr_pages, sc.gfp_mask,
+					count_lru_pages(), NULL);
 			ret += reclaim_state.reclaimed_slab;
 		} while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
 	}
@@ -2023,7 +2073,8 @@ static int __zone_reclaim(struct zone *z
 		 * Note that shrink_slab will free memory on all zones and may
 		 * take a long time.
 		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
+		while (shrink_slab(sc.nr_scanned, gfp_mask, order,
+						zone) &&
 			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
 				slab_reclaimable - nr_pages)
 			;
Index: linux-2.6/include/linux/mmzone.h
===================================================================
--- linux-2.6.orig/include/linux/mmzone.h	2008-05-08 17:24:44.000000000 -0700
+++ linux-2.6/include/linux/mmzone.h	2008-05-09 15:13:32.000000000 -0700
@@ -256,6 +256,7 @@ struct zone {
 	unsigned long		nr_scan_active;
 	unsigned long		nr_scan_inactive;
 	unsigned long		pages_scanned;	   /* since last reclaim */
+	unsigned long		slab_defrag_counter; /* since last defrag */
 	unsigned long		flags;		   /* zone flags, see below */
 
 	/* Zone statistics */
Index: linux-2.6/include/linux/swap.h
===================================================================
--- linux-2.6.orig/include/linux/swap.h	2008-05-08 17:24:44.000000000 -0700
+++ linux-2.6/include/linux/swap.h	2008-05-09 15:13:32.000000000 -0700
@@ -188,6 +188,9 @@ extern unsigned long try_to_free_mem_cgr
 extern int __isolate_lru_page(struct page *page, int mode);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
+extern int slab_defrag_limit;
+extern int slab_defrag_counter;
+
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern long vm_total_pages;
 
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2008-05-08 17:24:45.000000000 -0700
+++ linux-2.6/kernel/sysctl.c	2008-05-09 15:13:32.000000000 -0700
@@ -1035,6 +1035,26 @@ static struct ctl_table vm_table[] = {
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "slab_defrag_limit",
+		.data		= &slab_defrag_limit,
+		.maxlen		= sizeof(slab_defrag_limit),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one_hundred,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "slab_defrag_count",
+		.data		= &slab_defrag_counter,
+		.maxlen		= sizeof(slab_defrag_counter),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 	{
 		.ctl_name	= VM_LEGACY_VA_LAYOUT,
Index: linux-2.6/Documentation/sysctl/vm.txt
===================================================================
--- linux-2.6.orig/Documentation/sysctl/vm.txt	2008-05-08 17:24:44.000000000 -0700
+++ linux-2.6/Documentation/sysctl/vm.txt	2008-05-09 15:13:32.000000000 -0700
@@ -38,6 +38,7 @@ Currently, these files are in /proc/sys/
 - numa_zonelist_order
 - nr_hugepages
 - nr_overcommit_hugepages
+- slab_defrag_limit
 
 ==============================================================
 
@@ -347,3 +348,14 @@ Change the maximum size of the hugepage 
 nr_hugepages + nr_overcommit_hugepages.
 
 See Documentation/vm/hugetlbpage.txt
+
+==============================================================
+
+slab_defrag_limit
+
+Determines the frequency of calls from reclaim into slab defragmentation.
+Slab defrag reclaims objects from sparsely populates slab pages.
+The default is 1000. Increase if slab defragmentation occurs
+too frequently. Decrease if more slab defragmentation passes
+are needed. The slabinfo tool can report on the frequency of the callbacks.
+
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2008-05-08 17:24:45.000000000 -0700
+++ linux-2.6/mm/vmstat.c	2008-05-09 15:15:10.000000000 -0700
@@ -711,9 +711,11 @@ static void zoneinfo_show_print(struct s
 #endif
 	}
 	seq_printf(m,
+		   "\n  slab_defrag_count: %lu"
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu",
+		   	   zone->slab_defrag_counter,
 			   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
 		   zone->zone_start_pfn);

-- 
