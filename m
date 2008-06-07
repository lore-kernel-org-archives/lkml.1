Return-Path: <linux-kernel-owner+w=401wt.eu-S1764982AbYFGBaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764982AbYFGBaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758716AbYFGBLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:11:04 -0400
Received: from sous-sol.org ([216.99.217.87]:42603 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761467AbYFGBLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:11:01 -0400
Message-Id: <20080607010556.884011697@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, Dave Hansen <haveblue@us.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 11/50] memory_hotplug: always initialize pageblock bitmap
Content-Disposition: inline; filename=memory_hotplug-always-initialize-pageblock-bitmap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 76cdd58e558669366adfaded436fda01b30cce3e upstream

Trying to online a new memory section that was added via memory hotplug
sometimes results in crashes when the new pages are added via __free_page.
 Reason for that is that the pageblock bitmap isn't initialized and hence
contains random stuff.  That means that get_pageblock_migratetype()
returns also random stuff and therefore

	list_add(&page->lru,
		&zone->free_area[order].free_list[migratetype]);

in __free_one_page() tries to do a list_add to something that isn't even
necessarily a list.

This happens since 86051ca5eaf5e560113ec7673462804c54284456 ("mm: fix
usemap initialization") which makes sure that the pageblock bitmap gets
only initialized for pages present in a zone.  Unfortunately for hot-added
memory the zones "grow" after the memmap and the pageblock memmap have
been initialized.  Which means that the new pages have an unitialized
bitmap.  To solve this the calls to grow_zone_span() and grow_pgdat_span()
are moved to __add_zone() just before the initialization happens.

The patch also moves the two functions since __add_zone() is the only
caller and I didn't want to add a forward declaration.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 mm/memory_hotplug.c |   78 ++++++++++++++++++++++++++--------------------------
 mm/page_alloc.c     |    3 --
 2 files changed, 40 insertions(+), 41 deletions(-)

--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -58,23 +58,59 @@ static void release_memory_resource(stru
 	return;
 }
 
-
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
+static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
+			   unsigned long end_pfn)
+{
+	unsigned long old_zone_end_pfn;
+
+	zone_span_writelock(zone);
+
+	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	if (start_pfn < zone->zone_start_pfn)
+		zone->zone_start_pfn = start_pfn;
+
+	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
+				zone->zone_start_pfn;
+
+	zone_span_writeunlock(zone);
+}
+
+static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
+			    unsigned long end_pfn)
+{
+	unsigned long old_pgdat_end_pfn =
+		pgdat->node_start_pfn + pgdat->node_spanned_pages;
+
+	if (start_pfn < pgdat->node_start_pfn)
+		pgdat->node_start_pfn = start_pfn;
+
+	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
+					pgdat->node_start_pfn;
+}
+
 static int __add_zone(struct zone *zone, unsigned long phys_start_pfn)
 {
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nr_pages = PAGES_PER_SECTION;
 	int nid = pgdat->node_id;
 	int zone_type;
+	unsigned long flags;
 
 	zone_type = zone - pgdat->node_zones;
 	if (!zone->wait_table) {
-		int ret = 0;
+		int ret;
+
 		ret = init_currently_empty_zone(zone, phys_start_pfn,
 						nr_pages, MEMMAP_HOTPLUG);
-		if (ret < 0)
+		if (ret)
 			return ret;
 	}
+	pgdat_resize_lock(zone->zone_pgdat, &flags);
+	grow_zone_span(zone, phys_start_pfn, phys_start_pfn + nr_pages);
+	grow_pgdat_span(zone->zone_pgdat, phys_start_pfn,
+			phys_start_pfn + nr_pages);
+	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 	memmap_init_zone(nr_pages, nid, zone_type,
 			 phys_start_pfn, MEMMAP_HOTPLUG);
 	return 0;
@@ -134,36 +170,6 @@ int __add_pages(struct zone *zone, unsig
 }
 EXPORT_SYMBOL_GPL(__add_pages);
 
-static void grow_zone_span(struct zone *zone,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long old_zone_end_pfn;
-
-	zone_span_writelock(zone);
-
-	old_zone_end_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	if (start_pfn < zone->zone_start_pfn)
-		zone->zone_start_pfn = start_pfn;
-
-	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
-				zone->zone_start_pfn;
-
-	zone_span_writeunlock(zone);
-}
-
-static void grow_pgdat_span(struct pglist_data *pgdat,
-		unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long old_pgdat_end_pfn =
-		pgdat->node_start_pfn + pgdat->node_spanned_pages;
-
-	if (start_pfn < pgdat->node_start_pfn)
-		pgdat->node_start_pfn = start_pfn;
-
-	pgdat->node_spanned_pages = max(old_pgdat_end_pfn, end_pfn) -
-					pgdat->node_start_pfn;
-}
-
 static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
 			void *arg)
 {
@@ -183,7 +189,6 @@ static int online_pages_range(unsigned l
 
 int online_pages(unsigned long pfn, unsigned long nr_pages)
 {
-	unsigned long flags;
 	unsigned long onlined_pages = 0;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
@@ -211,11 +216,6 @@ int online_pages(unsigned long pfn, unsi
 	 * memory_block->state_sem.
 	 */
 	zone = page_zone(pfn_to_page(pfn));
-	pgdat_resize_lock(zone->zone_pgdat, &flags);
-	grow_zone_span(zone, pfn, pfn + nr_pages);
-	grow_pgdat_span(zone->zone_pgdat, pfn, pfn + nr_pages);
-	pgdat_resize_unlock(zone->zone_pgdat, &flags);
-
 	/*
 	 * If this zone is not populated, then it is not in zonelist.
 	 * This means the page allocator ignores this zone.
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2837,8 +2837,6 @@ __meminit int init_currently_empty_zone(
 
 	zone->zone_start_pfn = zone_start_pfn;
 
-	memmap_init(size, pgdat->node_id, zone_idx(zone), zone_start_pfn);
-
 	zone_init_free_lists(zone);
 
 	return 0;
@@ -3408,6 +3406,7 @@ static void __paginginit free_area_init_
 		ret = init_currently_empty_zone(zone, zone_start_pfn,
 						size, MEMMAP_EARLY);
 		BUG_ON(ret);
+		memmap_init(size, nid, j, zone_start_pfn);
 		zone_start_pfn += size;
 	}
 }

-- 
