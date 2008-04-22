Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbYDVBjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbYDVBjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760809AbYDVBiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:38:10 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53534 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762062AbYDVBiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:38:07 -0400
Date: Tue, 22 Apr 2008 10:40:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: akpm@linux-foundation.org
Cc: Hugh Dickins <hugh@veritas.com>, Mel Gorman <mel@csn.ul.ie>,
       Shi Weihua <shiwh@cn.fujitsu.com>, balbir@linux.vnet.ibm.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [BUGFIX][PATCH] Fix usemap initialization v2
Message-Id: <20080422104043.215c7dc4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0804211250000.16476@blonde.site>
References: <20080418161522.GB9147@csn.ul.ie>
	<48080706.50305@cn.fujitsu.com>
	<48080930.5090905@cn.fujitsu.com>
	<48080B86.7040200@cn.fujitsu.com>
	<20080418211214.299f91cd.kamezawa.hiroyu@jp.fujitsu.com>
	<21878461.1208539556838.kamezawa.hiroyu@jp.fujitsu.com>
	<20080421112048.78f0ec76.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0804211250000.16476@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on ia64/2.6.25
   DISCONTIGMEM + 16KB/64KB pages
   SPARSEMEM    + 16KB/64KB pages
seems no troubles.

Thanks,
-Kame

=
usemap must be initialized only when pfn is within zone.
If not, it corrupts memory.

And this patch also reduces the number of calls to set_pageblock_migratetype()
from
	(pfn & (pageblock_nr_pages -1)
to
	!(pfn & (pageblock_nr_pages-1)
it should be called once per pageblock.

Changelog v1->v2
 - Fixed boundary check.
 - Move calculation of pointer for zone to out of loop.


Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/page_alloc.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6.25/mm/page_alloc.c
===================================================================
--- linux-2.6.25.orig/mm/page_alloc.c
+++ linux-2.6.25/mm/page_alloc.c
@@ -2518,7 +2518,9 @@ void __meminit memmap_init_zone(unsigned
 	struct page *page;
 	unsigned long end_pfn = start_pfn + size;
 	unsigned long pfn;
+	struct zone *z;
 
+	z = &NODE_DATA(nid)->node_zones[zid];
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
+		 * bitmap is creted for zone's valid pfn range. but memmap
+		 * can be created for invalid pages (for alignment)
+		 * check here not to call set_pageblock_migratetpye() against
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

