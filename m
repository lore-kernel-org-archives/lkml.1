Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbZCPRz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbZCPRz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757972AbZCPRvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:51:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51205 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbZCPRvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:51:32 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 13/27] Inline __rmqueue_smallest()
Date: Mon, 16 Mar 2009 17:53:27 +0000
Message-Id: <1237226020-14057-14-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline __rmqueue_smallest by altering flow very slightly so that there
is only one call site. This allows the function to be inlined without
additional text bloat.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1e8b4b6..a3ca80d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -664,7 +664,8 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
  * Go through the free lists for the given migratetype and remove
  * the smallest available page from the freelists
  */
-static struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
+static inline
+struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						int migratetype)
 {
 	unsigned int current_order;
@@ -834,24 +835,36 @@ static struct page *__rmqueue_fallback(struct zone *zone, int order,
 		}
 	}
 
-	/* Use MIGRATE_RESERVE rather than fail an allocation */
-	return __rmqueue_smallest(zone, order, MIGRATE_RESERVE);
+	return NULL;
 }
 
 /*
  * Do the hard work of removing an element from the buddy allocator.
  * Call me with the zone->lock already held.
  */
-static struct page *__rmqueue(struct zone *zone, unsigned int order,
+static inline
+struct page *__rmqueue(struct zone *zone, unsigned int order,
 						int migratetype)
 {
 	struct page *page;
 
+retry_reserve:
 	page = __rmqueue_smallest(zone, order, migratetype);
 
-	if (unlikely(!page))
+	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
 		page = __rmqueue_fallback(zone, order, migratetype);
 
+		/*
+		 * Use MIGRATE_RESERVE rather than fail an allocation. goto
+		 * is used because __rmqueue_smallest is an inline function
+		 * and we want just one call site
+		 */
+		if (!page) {
+			migratetype = MIGRATE_RESERVE;
+			goto retry_reserve;
+		}
+	}
+
 	return page;
 }
 
-- 
1.5.6.5

