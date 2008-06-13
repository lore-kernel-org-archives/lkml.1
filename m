Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbYFMLd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbYFMLd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 07:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbYFMLdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 07:33:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46872 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbYFMLdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 07:33:50 -0400
Date: Fri, 13 Jun 2008 13:33:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: # x86/mpparse: cc1a9d8: mm, x86: shrink_active_range() should
	check all
Message-ID: <20080613113321.GA6651@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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


Andrew,

this is a FYI about ongoing work on 32-bit NUMA loose ends by Yinghai Lu 
(which has been sub-par for an eternity). The commits below are in 
tip/x86/mpparse and they touch mm/page_alloc.c's shrink_active_range() 
function.

This is an API that is only used by x86 - we could move it to arch/x86 
but i think it makes general sense so it's fine in mm/page_alloc.c. It 
should not impact any other MM work in a material way. Would be nice to 
carry these changes in x86/mpparse - they are still being tested.

Can you see any problem with these commits and the approach?

	Ingo

--------------------->

# x86/mpparse: e8c27ac: x86, numa, 32-bit: print out debug info on all kvas

>From e8c27ac9191ab9e6506ae5cbe70d87ac50f8e960 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Sun, 1 Jun 2008 13:15:22 -0700
Subject: [PATCH] x86, numa, 32-bit: print out debug info on all kvas

also fix the print out of node_remap_end_vaddr

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6383557..502223c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3486,6 +3486,11 @@ void __paginginit free_area_init_node(int nid, struct pglist_data *pgdat,
 	calculate_node_totalpages(pgdat, zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
+	printk(KERN_DEBUG "free_area_init_node: node %d, pgdat %08lx, node_mem_map %08lx\n",
+		nid, (unsigned long)pgdat,
+		(unsigned long)pgdat->node_mem_map);
+#endif
 
 	free_area_init_core(pgdat, zones_size, zholes_size);
 }

# x86/mpparse: cc1a9d8: mm, x86: shrink_active_range() should check all

>From cc1a9d86ce989083703c4bdc11b75a87e1cc404a Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Sun, 8 Jun 2008 19:39:16 -0700
Subject: [PATCH] mm, x86: shrink_active_range() should check all

Now we are using register_e820_active_regions() instead of
add_active_range() directly. So end_pfn could be different between the
value in early_node_map to node_end_pfn.

So we need to make shrink_active_range() smarter.

shrink_active_range() is a generic MM function in mm/page_alloc.c but
it is only used on 32-bit x86. Should we move it back to some file in
arch/x86?

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 502223c..2154086 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3579,25 +3579,49 @@ void __init add_active_range(unsigned int nid, unsigned long start_pfn,
 /**
  * shrink_active_range - Shrink an existing registered range of PFNs
  * @nid: The node id the range is on that should be shrunk
- * @old_end_pfn: The old end PFN of the range
  * @new_end_pfn: The new PFN of the range
  *
  * i386 with NUMA use alloc_remap() to store a node_mem_map on a local node.
- * The map is kept at the end physical page range that has already been
- * registered with add_active_range(). This function allows an arch to shrink
- * an existing registered range.
+ * The map is kept near the end physical page range that has already been
+ * registered. This function allows an arch to shrink an existing registered
+ * range.
  */
-void __init shrink_active_range(unsigned int nid, unsigned long old_end_pfn,
-						unsigned long new_end_pfn)
+void __init shrink_active_range(unsigned int nid, unsigned long new_end_pfn)
 {
-	int i;
+	int i, j;
+	int removed = 0;
 
 	/* Find the old active region end and shrink */
-	for_each_active_range_index_in_nid(i, nid)
-		if (early_node_map[i].end_pfn == old_end_pfn) {
+	for_each_active_range_index_in_nid(i, nid) {
+		if (early_node_map[i].start_pfn >= new_end_pfn) {
+			/* clear it */
+			early_node_map[i].end_pfn = 0;
+			removed = 1;
+			continue;
+		}
+		if (early_node_map[i].end_pfn > new_end_pfn) {
 			early_node_map[i].end_pfn = new_end_pfn;
-			break;
+			continue;
 		}
+	}
+
+	if (!removed)
+		return;
+
+	/* remove the blank ones */
+	for (i = nr_nodemap_entries - 1; i > 0; i--) {
+		if (early_node_map[i].nid != nid)
+			continue;
+		if (early_node_map[i].end_pfn)
+			continue;
+		/* we found it, get rid of it */
+		for (j = i; j < nr_nodemap_entries - 1; j++)
+			memcpy(&early_node_map[j], &early_node_map[j+1],
+				sizeof(early_node_map[j]));
+		j = nr_nodemap_entries - 1;
+		memset(&early_node_map[j], 0, sizeof(early_node_map[j]));
+		nr_nodemap_entries--;
+	}
 }
 
 /**

# x86/mpparse: 4937fa9: x86: replace shrink pages with remove_active_ranges

>From 4937fa962cb6eed0909de0ee5dbf41396e8b8ca6 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Thu, 12 Jun 2008 13:05:38 -0700
Subject: [PATCH] x86: replace shrink pages with remove_active_ranges

in case we have kva before ramdisk on node, we still need to use
those ranges.

This fixes 32-bit NUMA crashes with less than 960 MB of RAM.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2154086..e35ad52 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3577,30 +3577,44 @@ void __init add_active_range(unsigned int nid, unsigned long start_pfn,
 }
 
 /**
- * shrink_active_range - Shrink an existing registered range of PFNs
+ * remove_active_range - Shrink an existing registered range of PFNs
  * @nid: The node id the range is on that should be shrunk
- * @new_end_pfn: The new PFN of the range
+ * @start_pfn: The new PFN of the range
+ * @end_pfn: The new PFN of the range
  *
  * i386 with NUMA use alloc_remap() to store a node_mem_map on a local node.
  * The map is kept near the end physical page range that has already been
  * registered. This function allows an arch to shrink an existing registered
  * range.
  */
-void __init shrink_active_range(unsigned int nid, unsigned long new_end_pfn)
+void __init remove_active_range(unsigned int nid, unsigned long start_pfn,
+				unsigned long end_pfn)
 {
 	int i, j;
 	int removed = 0;
 
 	/* Find the old active region end and shrink */
 	for_each_active_range_index_in_nid(i, nid) {
-		if (early_node_map[i].start_pfn >= new_end_pfn) {
+		if (early_node_map[i].start_pfn >= start_pfn &&
+		    early_node_map[i].end_pfn <= end_pfn) {
 			/* clear it */
+			early_node_map[i].start_pfn = 0;
 			early_node_map[i].end_pfn = 0;
 			removed = 1;
 			continue;
 		}
-		if (early_node_map[i].end_pfn > new_end_pfn) {
-			early_node_map[i].end_pfn = new_end_pfn;
+		if (early_node_map[i].start_pfn < start_pfn &&
+		    early_node_map[i].end_pfn > start_pfn) {
+			unsigned long temp_end_pfn = early_node_map[i].end_pfn;
+			early_node_map[i].end_pfn = start_pfn;
+			if (temp_end_pfn > end_pfn)
+				add_active_range(nid, end_pfn, temp_end_pfn);
+			continue;
+		}
+		if (early_node_map[i].start_pfn >= start_pfn &&
+		    early_node_map[i].end_pfn > end_pfn &&
+		    early_node_map[i].start_pfn < end_pfn) {
+			early_node_map[i].start_pfn = end_pfn;
 			continue;
 		}
 	}
