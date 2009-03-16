Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbZCPR47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbZCPR47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758109AbZCPRvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:51:37 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51205 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982AbZCPRve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:51:34 -0400
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
Subject: [PATCH 16/27] Save text by reducing call sites of __rmqueue()
Date: Mon, 16 Mar 2009 17:53:30 +0000
Message-Id: <1237226020-14057-17-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__rmqueue is inlined in the fast path but it has two call sites, the low
order and high order paths. However, a slight modification to the
high-order path reduces the call sites of __rmqueue. This reduces text
at the slight increase of complexity of the high-order allocation path.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ba9e4f..795cfc5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1123,11 +1123,14 @@ again:
 		list_del(&page->lru);
 		pcp->count--;
 	} else {
-		spin_lock_irqsave(&zone->lock, flags);
-		page = __rmqueue(zone, order, migratetype);
-		spin_unlock(&zone->lock);
-		if (!page)
+		LIST_HEAD(list);
+		local_irq_save(flags);
+
+		/* Calling __rmqueue would bloat text, hence this */
+		if (!rmqueue_bulk(zone, order, 1, &list, migratetype))
 			goto failed;
+		page = list_entry(list.next, struct page, lru);
+		list_del(&page->lru);
 	}
 
 	__count_zone_vm_events(PGALLOC, zone, 1 << order);
-- 
1.5.6.5

