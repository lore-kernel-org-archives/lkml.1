Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZG1WXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZG1WXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbZG1WXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:23:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40462 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbZG1WXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:23:42 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/3] tracing, page-allocator: Add trace event for page traffic related to the buddy lists
Date: Tue, 28 Jul 2009 23:23:39 +0100
Message-Id: <1248819819-14931-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248819819-14931-1-git-send-email-mel@csn.ul.ie>
References: <1248819819-14931-1-git-send-email-mel@csn.ul.ie>
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
drained a little and pages are going back to the buddy lists.  These two
events can be used as an indicator of how often the zone lock is being taken.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/trace/events/kmem.h |   54 +++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    2 +
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 91a057c..fbc3779 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -283,6 +283,60 @@ TRACE_EVENT(__alloc_pages_nodemask,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
+TRACE_EVENT(__rmqueue,
+
+	TP_PROTO(const void *page, unsigned int order,
+				int migratetype, int percpu_refill),
+
+	TP_ARGS(page, order, migratetype, percpu_refill),
+
+	TP_STRUCT__entry(
+		__field(	const void *,	page		)
+		__field(	unsigned int,	order		)
+		__field(	int,		migratetype	)
+		__field(	int,		percpu_refill	)
+	),
+
+	TP_fast_assign(
+		__entry->page		= page;
+		__entry->order		= order;
+		__entry->migratetype	= migratetype;
+		__entry->percpu_refill	= percpu_refill;
+	),
+
+	TP_printk("page = %p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
+		__entry->page,
+		page_to_pfn((struct page *)__entry->page),
+		__entry->order,
+		__entry->migratetype,
+		__entry->percpu_refill)
+);
+
+TRACE_EVENT(free_pages_bulk,
+
+	TP_PROTO(const void *page, int order, int migratetype),
+
+	TP_ARGS(page, order, migratetype),
+
+	TP_STRUCT__entry(
+		__field(	const void *,	page		)
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
+		page_to_pfn((struct page *)__entry->page),
+		__entry->order,
+		__entry->migratetype)
+);
+
 TRACE_EVENT(__rmqueue_fallback,
 
 	TP_PROTO(const void *page,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3fc9f09..f96bf2c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -535,6 +535,7 @@ static void free_pages_bulk(struct zone *zone, int count,
 		page = list_entry(list->prev, struct page, lru);
 		/* have to delete it as __free_one_page list manipulates */
 		list_del(&page->lru);
+		trace_free_pages_bulk(page, order, page_private(page));
 		__free_one_page(page, zone, order, page_private(page));
 	}
 	spin_unlock(&zone->lock);
@@ -878,6 +879,7 @@ retry_reserve:
 		}
 	}
 
+	trace___rmqueue(page, order, migratetype, order == 0);
 	return page;
 }
 
-- 
1.6.3.3

