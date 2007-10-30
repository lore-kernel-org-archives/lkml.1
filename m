Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXJ3QRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXJ3QRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbXJ3QOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:14:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635AbXJ3QOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:14:06 -0400
Message-Id: <20071030160910.537350000@chello.nl>
References: <20071030160401.296770000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 30 Oct 2007 17:04:03 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/33] mm: tag reseve pages
Content-Disposition: inline; filename=page_alloc-reserve.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tag pages allocated from the reserves with a non-zero page->reserve.
This allows us to distinguish and account reserve pages.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mm_types.h |    1 +
 mm/page_alloc.c          |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/mm_types.h
===================================================================
--- linux-2.6.orig/include/linux/mm_types.h
+++ linux-2.6/include/linux/mm_types.h
@@ -70,6 +70,7 @@ struct page {
 	union {
 		pgoff_t index;		/* Our offset within mapping. */
 		void *freelist;		/* SLUB: freelist req. slab lock */
+		int reserve;		/* page_alloc: page is a reserve page */
 	};
 	struct list_head lru;		/* Pageout list, eg. active_list
 					 * protected by zone->lru_lock !
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -1448,8 +1448,10 @@ zonelist_scan:
 		}
 
 		page = buffered_rmqueue(zonelist, zone, order, gfp_mask);
-		if (page)
+		if (page) {
+			page->reserve = !!(alloc_flags & ALLOC_NO_WATERMARKS);
 			break;
+		}
 this_zone_full:
 		if (NUMA_BUILD)
 			zlc_mark_zone_full(zonelist, z);

--

