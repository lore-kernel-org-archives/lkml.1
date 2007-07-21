Return-Path: <linux-kernel-owner+w=401wt.eu-S1764142AbXGUTCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764142AbXGUTCi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763182AbXGUTB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:01:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42892 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763020AbXGUTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:01:55 -0400
Message-Id: <20070721210051.975382000@chello.nl>
References: <20070721210005.000228000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 23:00:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] readahead: drop behind
Content-Disposition: inline; filename=readahead-useonce.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the read-ahead code to provide hints to page reclaim.

This patch has the potential to solve the streaming-IO trashes my
desktop problem.

It tries to aggressively reclaim pages that were loaded in a strong
sequential pattern and have been consumed. Thereby limiting the damage
to the current resident set.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/swap.h |    1 +
 mm/readahead.c       |   39 ++++++++++++++++++++++++++++++++++++++-
 mm/swap.c            |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c
+++ linux-2.6/mm/swap.c
@@ -30,6 +30,7 @@
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/init.h>
+#include <linux/rmap.h>
 
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
@@ -176,6 +177,7 @@ EXPORT_SYMBOL(mark_page_accessed);
  */
 static DEFINE_PER_CPU(struct pagevec, lru_add_pvecs) = { 0, };
 static DEFINE_PER_CPU(struct pagevec, lru_add_active_pvecs) = { 0, };
+static DEFINE_PER_CPU(struct pagevec, lru_demote_pvecs) = { 0, };
 
 void fastcall lru_cache_add(struct page *page)
 {
@@ -197,6 +199,37 @@ void fastcall lru_cache_add_active(struc
 	put_cpu_var(lru_add_active_pvecs);
 }
 
+static void __pagevec_lru_demote(struct pagevec *pvec)
+{
+	int i;
+	struct zone *zone = NULL;
+
+	for (i = 0; i < pagevec_count(pvec); i++) {
+		struct page *page = pvec->pages[i];
+		struct zone *pagezone = page_zone(page);
+
+		if (pagezone != zone) {
+			if (zone)
+				spin_unlock_irq(&zone->lru_lock);
+			zone = pagezone;
+			spin_lock_irq(&zone->lru_lock);
+		}
+		if (PageLRU(page)) {
+			page_referenced(page, 0);
+			if (PageActive(page)) {
+				ClearPageActive(page);
+				__dec_zone_state(zone, NR_ACTIVE);
+				__inc_zone_state(zone, NR_INACTIVE);
+			}
+			list_move_tail(&page->lru, &zone->inactive_list);
+		}
+	}
+	if (zone)
+		spin_unlock_irq(&zone->lru_lock);
+	release_pages(pvec->pages, pvec->nr, pvec->cold);
+	pagevec_reinit(pvec);
+}
+
 static void __lru_add_drain(int cpu)
 {
 	struct pagevec *pvec = &per_cpu(lru_add_pvecs, cpu);
@@ -207,6 +240,9 @@ static void __lru_add_drain(int cpu)
 	pvec = &per_cpu(lru_add_active_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_add_active(pvec);
+	pvec = &per_cpu(lru_demote_pvecs, cpu);
+	if (pagevec_count(pvec))
+		__pagevec_lru_demote(pvec);
 }
 
 void lru_add_drain(void)
@@ -403,6 +439,21 @@ void __pagevec_lru_add_active(struct pag
 }
 
 /*
+ * Function used to forcefully demote a page to the tail of the inactive
+ * list.
+ */
+void fastcall lru_demote(struct page *page)
+{
+	if (likely(get_page_unless_zero(page))) {
+		struct pagevec *pvec = &get_cpu_var(lru_demote_pvecs);
+
+		if (!pagevec_add(pvec, page))
+			__pagevec_lru_demote(pvec);
+		put_cpu_var(lru_demote_pvecs);
+	}
+}
+
+/*
  * Try to drop buffers from the pages in a pagevec
  */
 void pagevec_strip(struct pagevec *pvec)
Index: linux-2.6/include/linux/swap.h
===================================================================
--- linux-2.6.orig/include/linux/swap.h
+++ linux-2.6/include/linux/swap.h
@@ -180,6 +180,7 @@ extern unsigned int nr_free_pagecache_pa
 /* linux/mm/swap.c */
 extern void FASTCALL(lru_cache_add(struct page *));
 extern void FASTCALL(lru_cache_add_active(struct page *));
+extern void FASTCALL(lru_demote(struct page *));
 extern void FASTCALL(activate_page(struct page *));
 extern void FASTCALL(mark_page_accessed(struct page *));
 extern void lru_add_drain(void);
Index: linux-2.6/mm/readahead.c
===================================================================
--- linux-2.6.orig/mm/readahead.c
+++ linux-2.6/mm/readahead.c
@@ -15,6 +15,7 @@
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
+#include <linux/swap.h>
 
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page)
 {
@@ -448,13 +449,19 @@ EXPORT_SYMBOL_GPL(page_cache_sync_readah
  * page_cache_async_ondemand() should be called when a page is used which
  * has the PG_readahead flag: this is a marker to suggest that the application
  * has used up enough of the readahead window that we should start pulling in
- * more pages. */
+ * more pages.
+ */
 void
 page_cache_async_readahead(struct address_space *mapping,
 			   struct file_ra_state *ra, struct file *filp,
 			   struct page *page, pgoff_t offset,
 			   unsigned long req_size)
 {
+	pgoff_t demote_idx = offset - min_t(pgoff_t, offset, ra->size);
+	struct page *pages[16];
+	unsigned nr_pages;
+	unsigned i;
+
 	/* no read-ahead */
 	if (!ra->ra_pages)
 		return;
@@ -473,6 +480,36 @@ page_cache_async_readahead(struct addres
 	if (bdi_read_congested(mapping->backing_dev_info))
 		return;
 
+	/*
+	 * Read-ahead use once: when the ra window is maximal this is a good
+	 * hint that there is sequential IO, which implies that the pages that
+	 * have been used thus far can be reclaimed
+	 */
+	if (ra->size == ra->ra_pages) do {
+		nr_pages = find_get_pages(mapping,
+				demote_idx, ARRAY_SIZE(pages), pages);
+
+		for (i = 0; i < nr_pages; i++) {
+			page = pages[i];
+			demote_idx = page_index(page);
+
+			/*
+			 * The page is active. This means there are other
+			 * users. We should not take away somebody else's
+			 * pages, so do not drop behind beyond this point.
+			 */
+			if (demote_idx < offset && !PageActive(page)) {
+				lru_demote(page);
+			} else {
+				demote_idx = offset;
+				break;
+			}
+		}
+		demote_idx++;
+
+		release_pages(pages, nr_pages, 0);
+	} while (demote_idx < offset);
+
 	/* do read-ahead */
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
 }

--

