Return-Path: <linux-kernel-owner+w=401wt.eu-S1161399AbXDWSgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161399AbXDWSgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161390AbXDWSgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:36:43 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:57922 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161371AbXDWSgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:36:40 -0400
Date: Mon, 23 Apr 2007 19:36:38 +0100
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tony.luck@intel.com,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix parsing kernelcore boot option for ia64
Message-ID: <20070423183637.GA11982@skynet.ie>
References: <20070413140533.A239.Y-GOTO@jp.fujitsu.com> <20070421232248.431ef2da.akpm@linux-foundation.org> <20070423203837.23AD.Y-GOTO@jp.fujitsu.com> <20070423183246.GA11841@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070423183246.GA11841@skynet.ie>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (23/04/07 19:32), Mel Gorman didst pronounce:
> There
> was a second problem that showed up while testing this in relation to the
> bootmem allocator assumptions about zone boundary alignment. I'll follow up
> this mail with the patch in case you are seeing that problem.
> 

Tony Luck added to cc list as I believe he had a lot to do with the speed
improvements within the bootmem allocator and might suggest a better fix.



Subject: Check zone boundaries when freeing bootmem
Zone boundaries do not have to be aligned to MAX_ORDER_NR_PAGES. However,
during boot, there is an implicit assumption that they are aligned to a
BITS_PER_LONG boundary when freeing pages as quickly as possible. This
patch checks the zone boundaries when freeing pages from the bootmem allocator.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.21-rc6-mm1-002_ia64cmdline/mm/bootmem.c linux-2.6.21-rc6-mm1-003_bootmem_zonecheck/mm/bootmem.c
--- linux-2.6.21-rc6-mm1-002_ia64cmdline/mm/bootmem.c	2007-04-06 03:36:56.000000000 +0100
+++ linux-2.6.21-rc6-mm1-003_bootmem_zonecheck/mm/bootmem.c	2007-04-23 18:58:10.000000000 +0100
@@ -302,13 +302,15 @@ found:
 
 static unsigned long __init free_all_bootmem_core(pg_data_t *pgdat)
 {
-	struct page *page;
+	struct page *page = NULL, *end_page = NULL;
 	unsigned long pfn;
 	bootmem_data_t *bdata = pgdat->bdata;
 	unsigned long i, count, total = 0;
 	unsigned long idx;
 	unsigned long *map; 
 	int gofast = 0;
+	int gofast_order = ffs(BITS_PER_LONG) - 1;
+	int gofast_size = 1 << gofast_order;
 
 	BUG_ON(!bdata->node_bootmem_map);
 
@@ -324,19 +326,21 @@ static unsigned long __init free_all_boo
 	for (i = 0; i < idx; ) {
 		unsigned long v = ~map[i / BITS_PER_LONG];
 
-		if (gofast && v == ~0UL) {
-			int order;
-
+		if (v) {
 			page = pfn_to_page(pfn);
+			end_page = page + gofast_size - 1;
+		}
+
+		/* Do not cross zone boundaries when fast freeing */
+		if (gofast && v == ~0UL &&
+				page_zone_id(page) == page_zone_id(end_page)) {
 			count += BITS_PER_LONG;
-			order = ffs(BITS_PER_LONG) - 1;
-			__free_pages_bootmem(page, order);
+			__free_pages_bootmem(page, gofast_order);
 			i += BITS_PER_LONG;
 			page += BITS_PER_LONG;
 		} else if (v) {
 			unsigned long m;
 
-			page = pfn_to_page(pfn);
 			for (m = 1; m && i < idx; m<<=1, page++, i++) {
 				if (v & m) {
 					count++;
