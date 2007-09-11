Return-Path: <linux-kernel-owner+w=401wt.eu-S1764791AbXIKVap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764791AbXIKVap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760263AbXIKVad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:30:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42005 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966501AbXIKVab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:30:31 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, ak@suse.de,
       clameter@sgi.com
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070911213026.23507.56698.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070911213006.23507.19569.sendpatchset@skynet.skynet.ie>
References: <20070911213006.23507.19569.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 1/6] Use zonelists instead of zones when direct reclaiming pages
Date: Tue, 11 Sep 2007 22:30:26 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The allocator deals with zonelists which indicate the order in which zones
should be targeted for an allocation. Similarly, direct reclaim of pages
iterates over an array of zones. For consistency, this patch converts direct
reclaim to use a zonelist. No functionality is changed by this patch. This
simplifies zonelist iterators in the next patch.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <clameter@sgi.com>
---

 include/linux/swap.h |    2 +-
 mm/page_alloc.c      |    2 +-
 mm/vmscan.c          |   13 ++++++++-----
 3 files changed, 10 insertions(+), 7 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc4-mm1-fix-pcnet32/include/linux/swap.h linux-2.6.23-rc4-mm1-005_freepages_zonelist/include/linux/swap.h
--- linux-2.6.23-rc4-mm1-fix-pcnet32/include/linux/swap.h	2007-09-10 09:29:14.000000000 +0100
+++ linux-2.6.23-rc4-mm1-005_freepages_zonelist/include/linux/swap.h	2007-09-10 16:06:06.000000000 +0100
@@ -189,7 +189,7 @@ extern int rotate_reclaimable_page(struc
 extern void swap_setup(void);
 
 /* linux/mm/vmscan.c */
-extern unsigned long try_to_free_pages(struct zone **zones, int order,
+extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask);
 extern unsigned long try_to_free_mem_container_pages(struct mem_container *mem);
 extern int __isolate_lru_page(struct page *page, int mode);
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc4-mm1-fix-pcnet32/mm/page_alloc.c linux-2.6.23-rc4-mm1-005_freepages_zonelist/mm/page_alloc.c
--- linux-2.6.23-rc4-mm1-fix-pcnet32/mm/page_alloc.c	2007-09-10 09:29:14.000000000 +0100
+++ linux-2.6.23-rc4-mm1-005_freepages_zonelist/mm/page_alloc.c	2007-09-10 16:06:06.000000000 +0100
@@ -1667,7 +1667,7 @@ nofail_alloc:
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	did_some_progress = try_to_free_pages(zonelist->zones, order, gfp_mask);
+	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
 
 	p->reclaim_state = NULL;
 	p->flags &= ~PF_MEMALLOC;
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc4-mm1-fix-pcnet32/mm/vmscan.c linux-2.6.23-rc4-mm1-005_freepages_zonelist/mm/vmscan.c
--- linux-2.6.23-rc4-mm1-fix-pcnet32/mm/vmscan.c	2007-09-10 09:29:14.000000000 +0100
+++ linux-2.6.23-rc4-mm1-005_freepages_zonelist/mm/vmscan.c	2007-09-10 16:06:06.000000000 +0100
@@ -1207,10 +1207,11 @@ static unsigned long shrink_zone(int pri
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
  */
-static unsigned long shrink_zones(int priority, struct zone **zones,
+static unsigned long shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	unsigned long nr_reclaimed = 0;
+	struct zone **zones = zonelist->zones;
 	int i;
 
 	sc->all_unreclaimable = 1;
@@ -1248,7 +1249,7 @@ static unsigned long shrink_zones(int pr
  * holds filesystem locks which prevent writeout this might not work, and the
  * allocation attempt will fail.
  */
-unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
+unsigned long do_try_to_free_pages(struct zonelist *zonelist, gfp_t gfp_mask,
 					struct scan_control *sc)
 {
 	int priority;
@@ -1257,6 +1258,7 @@ unsigned long do_try_to_free_pages(struc
 	unsigned long nr_reclaimed = 0;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long lru_pages = 0;
+	struct zone **zones = zonelist->zones;
 	int i;
 
 	count_vm_event(ALLOCSTALL);
@@ -1275,7 +1277,7 @@ unsigned long do_try_to_free_pages(struc
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		nr_reclaimed += shrink_zones(priority, zones, sc);
+		nr_reclaimed += shrink_zones(priority, zonelist, sc);
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit containers
@@ -1333,7 +1335,8 @@ out:
 	return ret;
 }
 
-unsigned long try_to_free_pages(struct zone **zones, int order, gfp_t gfp_mask)
+unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
+								gfp_t gfp_mask)
 {
 	struct scan_control sc = {
 		.gfp_mask = gfp_mask,
@@ -1346,7 +1349,7 @@ unsigned long try_to_free_pages(struct z
 		.isolate_pages = isolate_pages_global,
 	};
 
-	return do_try_to_free_pages(zones, gfp_mask, &sc);
+	return do_try_to_free_pages(zonelist, gfp_mask, &sc);
 }
 
 #ifdef CONFIG_CONTAINER_MEM_CONT
