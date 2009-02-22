Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZBVXUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZBVXUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbZBVXQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:16:33 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39466 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbZBVXQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:16:27 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: [PATCH 12/20] Inline __rmqueue_smallest()
Date: Sun, 22 Feb 2009 23:17:21 +0000
Message-Id: <1235344649-18265-13-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
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
index 36d30f3..d8a6828 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -665,7 +665,8 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
  * Go through the free lists for the given migratetype and remove
  * the smallest available page from the freelists
  */
-static struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
+static inline
+struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 						int migratetype)
 {
 	unsigned int current_order;
@@ -835,24 +836,36 @@ static struct page *__rmqueue_fallback(struct zone *zone, int order,
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

