Return-Path: <linux-kernel-owner+w=401wt.eu-S1765126AbYEHRoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765126AbYEHRoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760642AbYEHRnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963AbYEHRnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:09 -0400
Date: Thu, 8 May 2008 10:41:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hugh@veritas.com>,
       Shi Weihua <shiwh@cn.fujitsu.com>, Balbir Singh <balbir@in.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: [patch 02/16] mm: fix usemap initialization
Message-ID: <20080508174158.GC855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-fix-usemap-initialization.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit: 86051ca5eaf5e560113ec7673462804c54284456 upstream

usemap must be initialized only when pfn is within zone.  If not, it corrupts
memory.

And this patch also reduces the number of calls to set_pageblock_migratetype()
from
	(pfn & (pageblock_nr_pages -1)
to
	!(pfn & (pageblock_nr_pages-1)
it should be called once per pageblock.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2518,7 +2518,9 @@ void __meminit memmap_init_zone(unsigned
 	struct page *page;
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
+	struct zone *z;
 
+	z = &NODE_DATA(nid)->node_zones[zone];
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
 		 * There can be holes in boot-time mem_map[]s
@@ -2536,7 +2538,6 @@ void __meminit memmap_init_zone(unsigned
 		init_page_count(page);
 		reset_page_mapcount(page);
 		SetPageReserved(page);
-
 		/*
 		 * Mark the block movable so that blocks are reserved for
 		 * movable at startup. This will force kernel allocations
@@ -2545,8 +2546,15 @@ void __meminit memmap_init_zone(unsigned
 		 * kernel allocations are made. Later some blocks near
 		 * the start are marked MIGRATE_RESERVE by
 		 * setup_zone_migrate_reserve()
+		 *
+		 * bitmap is created for zone's valid pfn range. but memmap
+		 * can be created for invalid pages (for alignment)
+		 * check here not to call set_pageblock_migratetype() against
+		 * pfn out of zone.
 		 */
-		if ((pfn & (pageblock_nr_pages-1)))
+		if ((z->zone_start_pfn <= pfn)
+		    && (pfn < z->zone_start_pfn + z->spanned_pages)
+		    && !(pfn & (pageblock_nr_pages - 1)))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 
 		INIT_LIST_HEAD(&page->lru);
@@ -4460,6 +4468,8 @@ void set_pageblock_flags_group(struct pa
 	pfn = page_to_pfn(page);
 	bitmap = get_pageblock_bitmap(zone, pfn);
 	bitidx = pfn_to_bitidx(zone, pfn);
+	VM_BUG_ON(pfn < zone->zone_start_pfn);
+	VM_BUG_ON(pfn >= zone->zone_start_pfn + zone->spanned_pages);
 
 	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
 		if (flags & value)

-- 
