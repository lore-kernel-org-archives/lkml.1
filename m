Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429Ab0A2Uwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab0A2Uwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280Ab0A2Uwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:52:31 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42796 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab0A2UvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:21 -0500
Message-Id: <20100129205003.209111052@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:40 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: slub: Trigger defragmentation from memory reclaim
Content-Disposition: inline; filename=slub_vmscan_trigger
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
 Documentation/sysctl/vm.txt |   10 +++++++
 fs/drop_caches.c            |    2 -
 include/linux/mm.h          |    3 --
 include/linux/mmzone.h      |    1 
 include/linux/swap.h        |    3 ++
 kernel/sysctl.c             |   20 +++++++++++++++
 mm/vmscan.c                 |   58 ++++++++++++++++++++++++++++++++++++++++----
 7 files changed, 90 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/drop_caches.c
===================================================================
--- linux-2.6.orig/fs/drop_caches.c	2009-11-13 09:34:25.000000000 -0600
+++ linux-2.6/fs/drop_caches.c	2010-01-29 10:27:32.000000000 -0600
@@ -58,7 +58,7 @@ static void drop_slab(void)
 	int nr_objects;
 
 	do {
-		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000);
+		nr_objects = shrink_slab(1000, GFP_KERNEL, 1000, NULL);
 	} while (nr_objects > 10);
 }
 
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2010-01-20 11:39:58.000000000 -0600
+++ linux-2.6/include/linux/mm.h	2010-01-29 10:27:32.000000000 -0600
@@ -1308,8 +1308,7 @@ int in_gate_area_no_task(unsigned long a
 int drop_caches_sysctl_handler(struct ctl_table *, int,
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
--- linux-2.6.orig/mm/vmscan.c	2010-01-19 12:38:15.000000000 -0600
+++ linux-2.6/mm/vmscan.c	2010-01-29 10:27:32.000000000 -0600
@@ -181,6 +181,14 @@ void unregister_shrinker(struct shrinker
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
@@ -198,10 +206,18 @@ EXPORT_SYMBOL(unregister_shrinker);
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
@@ -259,6 +275,39 @@ unsigned long shrink_slab(unsigned long 
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
 
@@ -1768,7 +1817,7 @@ static unsigned long do_try_to_free_page
 		 * over limit cgroups
 		 */
 		if (scanning_global_lru(sc)) {
-			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages);
+			shrink_slab(sc->nr_scanned, sc->gfp_mask, lru_pages, NULL);
 			if (reclaim_state) {
 				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 				reclaim_state->reclaimed_slab = 0;
@@ -2084,7 +2133,7 @@ loop_again:
 				shrink_zone(priority, zone, &sc);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
-						lru_pages);
+						lru_pages, zone);
 			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
 			total_scanned += sc.nr_scanned;
 			if (zone_is_all_unreclaimable(zone))
@@ -2578,7 +2627,8 @@ static int __zone_reclaim(struct zone *z
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
--- linux-2.6.orig/include/linux/mmzone.h	2010-01-20 11:39:58.000000000 -0600
+++ linux-2.6/include/linux/mmzone.h	2010-01-29 10:27:32.000000000 -0600
@@ -340,6 +340,7 @@ struct zone {
 	struct zone_reclaim_stat reclaim_stat;
 
 	unsigned long		pages_scanned;	   /* since last reclaim */
+	unsigned long		slab_defrag_counter; /* since last defrag */
 	unsigned long		flags;		   /* zone flags, see below */
 
 	/* Zone statistics */
Index: linux-2.6/include/linux/swap.h
===================================================================
--- linux-2.6.orig/include/linux/swap.h	2009-12-18 13:13:24.000000000 -0600
+++ linux-2.6/include/linux/swap.h	2010-01-29 10:27:32.000000000 -0600
@@ -252,6 +252,9 @@ extern unsigned long mem_cgroup_shrink_n
 extern int __isolate_lru_page(struct page *page, int mode, int file);
 extern unsigned long shrink_all_memory(unsigned long nr_pages);
 extern int vm_swappiness;
+extern int slab_defrag_limit;
+extern int slab_defrag_counter;
+
 extern int remove_mapping(struct address_space *mapping, struct page *page);
 extern long vm_total_pages;
 
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c	2009-12-18 13:13:24.000000000 -0600
+++ linux-2.6/kernel/sysctl.c	2010-01-29 10:27:32.000000000 -0600
@@ -1167,6 +1167,26 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= proc_dointvec,
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
 		.procname	= "legacy_va_layout",
Index: linux-2.6/Documentation/sysctl/vm.txt
===================================================================
--- linux-2.6.orig/Documentation/sysctl/vm.txt	2009-12-10 12:18:32.000000000 -0600
+++ linux-2.6/Documentation/sysctl/vm.txt	2010-01-29 10:27:32.000000000 -0600
@@ -50,6 +50,7 @@ Currently, these files are in /proc/sys/
 - page-cluster
 - panic_on_oom
 - percpu_pagelist_fraction
+- slab_defrag_limit
 - stat_interval
 - swappiness
 - vfs_cache_pressure
@@ -597,6 +598,15 @@ The initial value is zero.  Kernel does 
 the high water marks for each per cpu page list.
 
 ==============================================================
+slab_defrag_limit
+
+Determines the frequency of calls from reclaim into slab defragmentation.
+Slab defrag reclaims objects from sparsely populates slab pages.
+The default is 1000. Increase if slab defragmentation occurs
+too frequently. Decrease if more slab defragmentation passes
+are needed. The slabinfo tool can report on the frequency of the callbacks.
+
+==============================================================
 
 stat_interval
 

-- 
