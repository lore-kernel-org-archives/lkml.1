Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZG1WXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZG1WXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZG1WXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:23:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40455 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755808AbZG1WXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:23:42 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/3] tracing, mm: Add trace events for anti-fragmentation falling back to other migratetypes
Date: Tue, 28 Jul 2009 23:23:38 +0100
Message-Id: <1248819819-14931-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248819819-14931-1-git-send-email-mel@csn.ul.ie>
References: <1248819819-14931-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fragmentation avoidance depends on being able to use free pages from
lists of the appropriate migrate type. In the event this is not
possible, __rmqueue_fallback() selects a different list and in some
circumstances change the migratetype of the pageblock. Simplistically,
the more times this event occurs, the more likely that fragmentation
will be a problem later for hugepage allocation at least but there are
other considerations such as the order of page being split to satisfy
the allocation.

This patch adds a trace event for __rmqueue_fallback() that reports what
page is being used for the fallback, the orders of relevant pages, the
desired migratetype and the migratetype of the lists being used, whether
the pageblock changed type and whether this event is important with
respect to fragmentation avoidance or not. This information can be used
to help analyse fragmentation avoidance and help decide whether
min_free_kbytes should be increased or not.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/trace/events/kmem.h |   44 +++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    6 +++++
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index ad07ffa..91a057c 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -283,6 +283,50 @@ TRACE_EVENT(__alloc_pages_nodemask,
 		show_gfp_flags(__entry->gfp_flags))
 );
 
+TRACE_EVENT(__rmqueue_fallback,
+
+	TP_PROTO(const void *page,
+			int alloc_order, int fallback_order,
+			int alloc_migratetype, int fallback_migratetype,
+			int fragmenting, int change_ownership),
+
+	TP_ARGS(page,
+		alloc_order, fallback_order,
+		alloc_migratetype, fallback_migratetype,
+		fragmenting, change_ownership),
+
+	TP_STRUCT__entry(
+		__field(	const void *,	page			)
+		__field(	int,		alloc_order		)
+		__field(	int,		fallback_order		)
+		__field(	int,		alloc_migratetype	)
+		__field(	int,		fallback_migratetype	)
+		__field(	int,		fragmenting		)
+		__field(	int,		change_ownership	)
+	),
+
+	TP_fast_assign(
+		__entry->page			= page;
+		__entry->alloc_order		= alloc_order;
+		__entry->fallback_order		= fallback_order;
+		__entry->alloc_migratetype	= alloc_migratetype;
+		__entry->fallback_migratetype	= fallback_migratetype;
+		__entry->fragmenting		= fragmenting;
+		__entry->change_ownership	= change_ownership;
+	),
+
+	TP_printk("page=%p pfn=%lu alloc_order=%d fallback_order=%d pageblock_order=%d alloc_migratetype=%d fallback_migratetype=%d fragmenting=%d change_ownership=%d",
+		__entry->page,
+		page_to_pfn((struct page *)__entry->page),
+		__entry->alloc_order,
+		__entry->fallback_order,
+		pageblock_order,
+		__entry->alloc_migratetype,
+		__entry->fallback_migratetype,
+		__entry->fragmenting,
+		__entry->change_ownership)
+);
+
 #endif /* _TRACE_KMEM_H */
 
 /* This part must be outside protection */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5601dc6..3fc9f09 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -839,6 +839,12 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 							start_migratetype);
 
 			expand(zone, page, order, current_order, area, migratetype);
+
+			trace___rmqueue_fallback(page, order, current_order,
+				start_migratetype, migratetype,
+				current_order < pageblock_order,
+				migratetype == start_migratetype);
+
 			return page;
 		}
 	}
-- 
1.6.3.3

