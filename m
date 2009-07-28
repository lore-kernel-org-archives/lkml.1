Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZG1WXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZG1WXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZG1WXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:23:42 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40443 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbZG1WXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:23:41 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 1/3] tracing, page-allocator: Add trace events for page allocation and page freeing
Date: Tue, 28 Jul 2009 23:23:37 +0100
Message-Id: <1248819819-14931-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248819819-14931-1-git-send-email-mel@csn.ul.ie>
References: <1248819819-14931-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds trace events for the allocation and freeing of pages.
Using the events, it will be known what struct page and pfns are being
allocated and freed and what the call site was in many cases.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/trace/events/kmem.h |   58 +++++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    3 ++
 2 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 1493c54..ad07ffa 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -225,6 +225,64 @@ TRACE_EVENT(kmem_cache_free,
 
 	TP_printk("call_site=%lx ptr=%p", __entry->call_site, __entry->ptr)
 );
+
+TRACE_EVENT(__free_pages,
+
+	TP_PROTO(unsigned long call_site, const void *page, unsigned int order),
+
+	TP_ARGS(call_site, page, order),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	page		)
+		__field(	unsigned int,	order		)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->page		= page;
+		__entry->order		= order;
+	),
+
+	TP_printk("call_site=%lx page=%p pfn=%lu order=%d",
+			__entry->call_site,
+			__entry->page,
+			page_to_pfn((struct page *)__entry->page),
+			__entry->order)
+);
+
+TRACE_EVENT(__alloc_pages_nodemask,
+
+	TP_PROTO(unsigned long call_site, const void *page, unsigned int order,
+			gfp_t gfp_flags, int migratetype),
+
+	TP_ARGS(call_site, page, order, gfp_flags, migratetype),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	call_site	)
+		__field(	const void *,	page		)
+		__field(	unsigned int,	order		)
+		__field(	gfp_t,		gfp_flags	)
+		__field(	int,		migratetype	)
+	),
+
+	TP_fast_assign(
+		__entry->call_site	= call_site;
+		__entry->page		= page;
+		__entry->order		= order;
+		__entry->gfp_flags	= gfp_flags;
+		__entry->migratetype	= migratetype;
+	),
+
+	TP_printk("call_site=%lx page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
+		__entry->call_site,
+		__entry->page,
+		page_to_pfn((struct page *)__entry->page),
+		__entry->order,
+		__entry->migratetype,
+		show_gfp_flags(__entry->gfp_flags))
+);
+
 #endif /* _TRACE_KMEM_H */
 
 /* This part must be outside protection */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index caa9268..5601dc6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1894,6 +1894,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
 
+	trace___alloc_pages_nodemask(_RET_IP_, page, order, gfp_mask,
+								migratetype);
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
@@ -1940,6 +1942,7 @@ void __pagevec_free(struct pagevec *pvec)
 
 void __free_pages(struct page *page, unsigned int order)
 {
+	trace___free_pages(_RET_IP_, page, order);
 	if (put_page_testzero(page)) {
 		if (order == 0)
 			free_hot_page(page);
-- 
1.6.3.3

