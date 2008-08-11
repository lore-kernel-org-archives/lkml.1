Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYHKPYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYHKPYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYHKPYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:24:13 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:6390 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYHKPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:24:12 -0400
Message-Id: <20080811150657.145413800@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:25 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 09/19] slub: Trigger defragmentation from memory reclaim
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
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 Documentation/sysctl/vm.txt |   12 ++++++++
 fs/drop_caches.c            |    2 -
 include/linux/mm.h          |    3 --
 include/linux/mmzone.h      |    1 
 include/linux/swap.h        |    3 ++
 kernel/sysctl.c             |   20 +++++++++++++
 mm/vmscan.c                 |   64 +++++++++++++++++++++++++++++++++++++++-----
 mm/vmstat.c                 |    4 ++
 8 files changed, 98 insertions(+), 11 deletions(-)

Index: linux-next/fs/drop_caches.c
===================================================================
--- linux-next.orig/fs/drop_caches.c	2008-08-11 07:42:10.122359386 -0700
+++ linux-next/fs/drop_caches.c	2008-08-11 07:47:01.952350081 -0700
@@ -58,7 +58,7 @@ static void drop_slab(void)
 	int nr_objects;
 
 	do {
-		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000);
+		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000, NULL);
 	} while (nr_objects > 10);
 }
 
Index: linux-next/include/linux/mm.h
===================================================================
--- linux-next.orig/include/linux/mm.h	2008-08-11 07:42:31.392357922 -0700
+++ linux-next/include/linux/mm.h	2008-08-11 07:47:02.002358245 -0700
@@ -1263,8 +1263,7 @@ int in_gate_area_no_task(unsigned long a
 int drop_caches_sysctl_handler(struct ctl_table *, int, struct file *,
 					void __user *, size_t *, loff_t *);
 unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
-			unsigned long lru_pages);
-
+				unsigned long lru_pages, struct zone *z);
 #ifndef CONFIG_MMU
 #define randomize_va_space 0
 #else
Index: linux-next/mm/vmscan.c
===================================================================
--- linux-next.orig/mm/vmscan.c	2008-08-11 07:42:34.492359354 -0700
+++ linux-next/mm/vmscan.c	2008-08-11 07:47:02.042358614 -0700
@@ -150,6 +150,14 @@ void unregister_shrinker(struct shrinker
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
@@ -167,10 +175,18 @@ EXPORT_SYMBOL(unregister_shrinker);
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
@@ -227,6 +243,39 @@ unsigned long shrink_slab(unsigned long 
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
 
@@ -1379,7 +1428,7 @@ static unsigned long do_try_to_free_page
 		 * over limit cgroups
 		 */
 		if (scan_global_lru(sc)) {
-			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
+			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages, NULL);
 			if (reclaim_state) {
 				nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -1606,7 +1655,7 @@ loop_again:
 				nr_reclaimed += shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
-						lru_pages);
+						lru_pages, zone);
 			nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 			if (zone_is_all_unreclaimable(zone))
@@ -1845,7 +1894,7 @@ unsigned long shrink_all_memory(unsigned
 	/* If slab caches are huge, it's better to hit them first */
 	while (nr_slab >= lru_pages) {
 		reclaim_state.reclaimed_slab = 0;
-		shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
+		shrink_slab(nr_pages, sc.gfp_mask, lru_pages, NULL);
 		if (!reclaim_state.reclaimed_slab)
 			break;
 
@@ -1883,7 +1932,7 @@ unsigned long shrink_all_memory(unsigned
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-					count_lru_pages());
+					count_lru_pages(), NULL);
 			ret += reclaim_state.reclaimed_slab;
 			if (ret >= nr_pages)
 				goto out;
@@ -1900,7 +1949,7 @@ unsigned long shrink_all_memory(unsigned
 	if (!ret) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask, count_lru_pages());
+			shrink_slab(nr_pages, sc.gfp_mask, count_lru_pages(), NULL);
 			ret += reclaim_state.reclaimed_slab;
 		} while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
 	}
@@ -2062,7 +2111,8 @@ static int __zone_reclaim(struct zone *z
 		 * Note that shrink_slab will free memory on all zones and may
 		 * take a long time.
 		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
+		while (shrink_slab(sc.nr_scanned, gfp_mask, order,
+						zone) &&
 			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
 				slab_reclaimable - nr_pages)
 			;
Index: linux-next/include/linux/mmzone.h
===================================================================
--- linux-next.orig/include/linux/mmzone.h	2008-08-11 07:42:31.432357916 -0700
+++ linux-next/include/linux/mmzone.h	2008-08-11 07:47:02.122357983 -0700
@@ -256,6 +256,7 @@ struct zone {
 	unsigned long		nr_scan_active;
 	unsigned long		nr_scan_inactive;
 	unsigned long		pages_scanned;	   /* since last reclaim */
+	unsigned long		slab_defrag_counter; /* since last defrag */
 	unsigned long		flags;		   /* zone flags, see below */
 
 	/* Zone statistics */
Index: linux-next/include/linux/swap.h
===================================================================
--- linux-next.orig/include/linux/swap.h	2008-08-11 07:42:32.602094688 -0700
+++ linux-next/include/linux/swap.h	2008-08-11 07:47:02.182346970 -0700
@@ -188,6 +188,9 @@ extern unsigned long try_to_free_mem_cgr
 extern int __isolate_lru_page(struct page *page, int mode);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
+extern int slab_defrag_limit;
+extern int slab_defrag_counter;
+
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern long vm_total_pages;
 
Index: linux-next/kernel/sysctl.c
===================================================================
--- linux-next.orig/kernel/sysctl.c	2008-08-11 07:42:34.022358796 -0700
+++ linux-next/kernel/sysctl.c	2008-08-11 07:47:02.242347675 -0700
@@ -1073,6 +1073,26 @@ static struct ctl_table vm_table[] = {
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
Index: linux-next/Documentation/sysctl/vm.txt
===================================================================
--- linux-next.orig/Documentation/sysctl/vm.txt	2008-08-11 07:40:41.632346812 -0700
+++ linux-next/Documentation/sysctl/vm.txt	2008-08-11 07:47:02.302358085 -0700
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
Index: linux-next/mm/vmstat.c
===================================================================
--- linux-next.orig/mm/vmstat.c	2008-08-11 07:42:34.492359354 -0700
+++ linux-next/mm/vmstat.c	2008-08-11 07:47:04.222357891 -0700
@@ -714,10 +714,12 @@ static void zoneinfo_show_print(struct s
 #endif
 	}
 	seq_printf(m,
+		   "\n  slab_defrag_count: %lu"
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
 		   "\n  start_pfn:         %lu",
-			   zone_is_all_unreclaimable(zone),
+			zone->slab_defrag_counter,
+			zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
 		   zone->zone_start_pfn);
 	seq_putc(m, '\n');

-- 
