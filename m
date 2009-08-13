Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZHMTxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZHMTxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZHMTxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:53:11 -0400
Received: from kroah.org ([198.145.64.141]:36709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbZHMTrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:36 2009
Message-Id: <20090813194336.304160624@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [patch 06/28] page-allocator: preserve PFN ordering when __GFP_COLD is set
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mel Gorman <mel@csn.ul.ie>

commit e084b2d95e48b31aa45f9c49ffc6cdae8bdb21d4 upstream.

Fix a post-2.6.24 performace regression caused by
3dfa5721f12c3d5a441448086bee156887daa961 ("page-allocator: preserve PFN
ordering when __GFP_COLD is set").

Narayanan reports "The regression is around 15%.  There is no disk controller
as our setup is based on Samsung OneNAND used as a memory mapped device on a
OMAP2430 based board."

The page allocator tries to preserve contiguous PFN ordering when returning
pages such that repeated callers to the allocator have a strong chance of
getting physically contiguous pages, particularly when external fragmentation
is low.  However, of the bulk of the allocations have __GFP_COLD set as they
are due to aio_read() for example, then the PFNs are in reverse PFN order.
This can cause performance degration when used with IO controllers that could
have merged the requests.

This patch attempts to preserve the contiguous ordering of PFNs for users of
__GFP_COLD.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reported-by: Narayananu Gopalakrishnan <narayanan.g@samsung.com>
Tested-by: Narayanan Gopalakrishnan <narayanan.g@samsung.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -846,7 +846,7 @@ static struct page *__rmqueue(struct zon
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order, 
 			unsigned long count, struct list_head *list,
-			int migratetype)
+			int migratetype, int cold)
 {
 	int i;
 	
@@ -865,7 +865,10 @@ static int rmqueue_bulk(struct zone *zon
 		 * merge IO requests if the physical pages are ordered
 		 * properly.
 		 */
-		list_add(&page->lru, list);
+		if (likely(cold == 0))
+			list_add(&page->lru, list);
+		else
+			list_add_tail(&page->lru, list);
 		set_page_private(page, migratetype);
 		list = &page->lru;
 	}
@@ -1068,7 +1071,8 @@ again:
 		local_irq_save(flags);
 		if (!pcp->count) {
 			pcp->count = rmqueue_bulk(zone, 0,
-					pcp->batch, &pcp->list, migratetype);
+					pcp->batch, &pcp->list,
+					migratetype, cold);
 			if (unlikely(!pcp->count))
 				goto failed;
 		}
@@ -1087,7 +1091,8 @@ again:
 		/* Allocate more to the pcp list if necessary */
 		if (unlikely(&page->lru == &pcp->list)) {
 			pcp->count += rmqueue_bulk(zone, 0,
-					pcp->batch, &pcp->list, migratetype);
+					pcp->batch, &pcp->list,
+					migratetype, cold);
 			page = list_entry(pcp->list.next, struct page, lru);
 		}
 


