Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXIJLXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXIJLXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 07:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXIJLWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 07:22:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44679 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932901AbXIJLWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 07:22:33 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Message-Id: <20070910112231.3097.53548.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 7/13] Drain per-cpu lists when high-order allocations fail
Date: Mon, 10 Sep 2007 12:22:32 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Drain per-cpu lists when high-order allocations fail

Per-cpu pages can accidentally cause fragmentation because they are free, but
pinned pages in an otherwise contiguous block.  When this patch is applied,
the per-cpu caches are drained after the direct-reclaim is entered if the
requested order is greater than 0.  It simply reuses the code used by suspend
and hotplug.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc5-006-group-short-lived-and-reclaimable-kernel-allocations/mm/page_alloc.c linux-2.6.23-rc5-007-drain-per-cpu-lists-when-high-order-allocations-fail/mm/page_alloc.c
--- linux-2.6.23-rc5-006-group-short-lived-and-reclaimable-kernel-allocations/mm/page_alloc.c	2007-09-02 16:20:31.000000000 +0100
+++ linux-2.6.23-rc5-007-drain-per-cpu-lists-when-high-order-allocations-fail/mm/page_alloc.c	2007-09-02 16:20:48.000000000 +0100
@@ -852,6 +852,7 @@ void mark_free_pages(struct zone *zone)
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
+#endif /* CONFIG_PM */
 
 /*
  * Spill all of this CPU's per-cpu pages back into the buddy allocator.
@@ -864,7 +865,25 @@ void drain_local_pages(void)
 	__drain_pages(smp_processor_id());
 	local_irq_restore(flags);	
 }
-#endif /* CONFIG_HIBERNATION */
+
+void smp_drain_local_pages(void *arg)
+{
+	drain_local_pages();
+}
+
+/*
+ * Spill all the per-cpu pages from all CPUs back into the buddy allocator
+ */
+void drain_all_local_pages(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__drain_pages(smp_processor_id());
+	local_irq_restore(flags);
+
+	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
+}
 
 /*
  * Free a 0-order page
@@ -1452,6 +1471,9 @@ nofail_alloc:
 
 	cond_resched();
 
+	if (order != 0)
+		drain_all_local_pages();
+
 	if (likely(did_some_progress)) {
 		page = get_page_from_freelist(gfp_mask, order,
 						zonelist, alloc_flags);
