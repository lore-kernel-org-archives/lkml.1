Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZHJPmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZHJPmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZHJPmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:42:02 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51388 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbZHJPl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:41:58 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: riel@redhat.com, Peter Zijlstra <peterz@infradead.org>,
       Li Ming Chun <macli@brc.ubc.ca>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/6] tracing, page-allocator: Add trace event for page traffic related to the buddy lists
Date: Mon, 10 Aug 2009 16:41:52 +0100
Message-Id: <1249918915-16061-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249918915-16061-1-git-send-email-mel@csn.ul.ie>
References: <1249918915-16061-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page allocation trace event reports that a page was successfully allocated
but it does not specify where it came from. When analysing performance,
it can be important to distinguish between pages coming from the per-cpu
allocator and pages coming from the buddy lists as the latter requires the
zone lock to the taken and more data structures to be examined.

This patch adds a trace event for __rmqueue reporting when a page is being
allocated from the buddy lists. It distinguishes between being called
to refill the per-cpu lists or whether it is a high-order allocation.
Similarly, this patch adds an event to catch when the PCP lists are being
drained a little and pages are going back to the buddy lists.

This is trickier to draw conclusions from but high activity on those
events could explain why there were a large number of cache misses on a
page-allocator-intensive workload. The coalescing and splitting of buddies
involves a lot of writing of page metadata and cache line bounces not to
mention the acquisition of an interrupt-safe lock necessary to enter this
path.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
---
 include/trace/events/kmem.h |   51 +++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    2 +
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index aae16ee..eaf46bd 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -299,6 +299,57 @@ TRACE_EVENT(mm_page_alloc,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
+TRACE_EVENT(mm_page_alloc_zone_locked,
+
+	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype),
+
+	TP_STRUCT__entry(
+		__field(	struct page *,	page		)
+		__field(	unsigned int,	order		)
+		__field(	int,		migratetype	)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->order		= order;
+		__entry->migratetype	= migratetype;
+	),
+
+	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->order,
+		__entry->migratetype,
+		__entry->order == 0)
+);
+
+TRACE_EVENT(mm_page_pcpu_drain,
+
+	TP_PROTO(struct page *page, int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype),
+
+	TP_STRUCT__entry(
+		__field(	struct page *,	page		)
+		__field(	int,		order		)
+		__field(	int,		migratetype	)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->order		= order;
+		__entry->migratetype	= migratetype;
+	),
+
+	TP_printk("page=%p pfn=%lu order=%d migratetype=%d",
+		__entry->page,
+		page_to_pfn(__entry->page),
+		__entry->order,
+		__entry->migratetype)
+);
+
 TRACE_EVENT(mm_page_alloc_extfrag,
 
 	TP_PROTO(struct page *page,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4c20bfa..bbd7de8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -535,6 +535,7 @@ static void free_pages_bulk(struct zone *zone, int count,
 		page = list_entry(list->prev, struct page, lru);
 		/* have to delete it as __free_one_page list manipulates */
 		list_del(&page->lru);
+		trace_mm_page_pcpu_drain(page, order, page_private(page));
 		__free_one_page(page, zone, order, page_private(page));
 	}
 	spin_unlock(&zone->lock);
@@ -876,6 +877,7 @@ retry_reserve:
 		}
 	}
 
+	trace_mm_page_alloc_zone_locked(page, order, migratetype);
 	return page;
 }
 
-- 
1.6.3.3

