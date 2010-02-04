Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592Ab0BDRcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:32:55 -0500
Received: from kroah.org ([198.145.64.141]:34700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab0BDRVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:50 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:04 2010
Message-Id: <20100204171504.319037841@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [28/74] mm: fix migratetype bug which slowed swapping
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

commit a7016235a61d520e6806f38129001d935c4b6661 upstream.

After memory pressure has forced it to dip into the reserves, 2.6.32's
5f8dcc21211a3d4e3a7a5ca366b469fb88117f61 "page-allocator: split per-cpu
list into one-list-per-migrate-type" has been returning MIGRATE_RESERVE
pages to the MIGRATE_MOVABLE free_list: in some sense depleting reserves.

Fix that in the most straightforward way (which, considering the overheads
of alternative approaches, is Mel's preference): the right migratetype is
already in page_private(page), but free_pcppages_bulk() wasn't using it.

How did this bug show up?  As a 20% slowdown in my tmpfs loop kbuild
swapping tests, on PowerMac G5 with SLUB allocator.  Bisecting to that
commit was easy, but explaining the magnitude of the slowdown not easy.

The same effect appears, but much less markedly, with SLAB, and even
less markedly on other machines (the PowerMac divides into fewer zones
than x86, I think that may be a factor).  We guess that lumpy reclaim
of short-lived high-order pages is implicated in some way, and probably
this bug has been tickling a poor decision somewhere in page reclaim.

But instrumentation hasn't told me much, I've run out of time and
imagination to determine exactly what's going on, and shouldn't hold up
the fix any longer: it's valid, and might even fix other misbehaviours.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -559,8 +559,9 @@ static void free_pcppages_bulk(struct zo
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
-			__free_one_page(page, zone, 0, migratetype);
-			trace_mm_page_pcpu_drain(page, 0, migratetype);
+			/* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
+			__free_one_page(page, zone, 0, page_private(page));
+			trace_mm_page_pcpu_drain(page, 0, page_private(page));
 		} while (--count && --batch_free && !list_empty(list));
 	}
 	spin_unlock(&zone->lock);


