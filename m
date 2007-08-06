Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbXHFKrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbXHFKrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530AbXHFKpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:45:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbXHFKo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:44:58 -0400
Message-Id: <20070806103658.356795000@chello.nl>
References: <20070806102922.907530000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 06 Aug 2007 12:29:25 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: [PATCH 03/10] mm: tag reseve pages
Content-Disposition: inline; filename=page_alloc-reserve.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tag pages allocated from the reserves with a non-zero page->reserve.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mm_types.h |    1 +
 mm/page_alloc.c          |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-2/include/linux/mm_types.h
===================================================================
--- linux-2.6-2.orig/include/linux/mm_types.h
+++ linux-2.6-2/include/linux/mm_types.h
@@ -60,6 +60,7 @@ struct page {
 	union {
 		pgoff_t index;		/* Our offset within mapping. */
 		void *freelist;		/* SLUB: freelist req. slab lock */
+		int reserve;		/* page_alloc: page is a reserve page */
 	};
 	struct list_head lru;		/* Pageout list, eg. active_list
 					 * protected by zone->lru_lock !
Index: linux-2.6-2/mm/page_alloc.c
===================================================================
--- linux-2.6-2.orig/mm/page_alloc.c
+++ linux-2.6-2/mm/page_alloc.c
@@ -1186,8 +1186,10 @@ zonelist_scan:
 		}
 
 		page = buffered_rmqueue(zonelist, zone, order, gfp_mask);
-		if (page)
+		if (page) {
+			page->reserve = (alloc_flags & ALLOC_NO_WATERMARKS);
 			break;
+		}
 this_zone_full:
 		if (NUMA_BUILD)
 			zlc_mark_zone_full(zonelist, z);

--

