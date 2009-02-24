Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZBXMWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZBXMWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 07:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZBXMRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 07:17:25 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39084 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZBXMRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 07:17:21 -0500
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
Subject: [PATCH 16/19] Do not disable interrupts in free_page_mlock()
Date: Tue, 24 Feb 2009 12:17:12 +0000
Message-Id: <1235477835-14500-17-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_page_mlock() tests and clears PG_mlocked using locked versions of the
bit operations. If set, it disables interrupts to update counters and this
happens on every page free even though interrupts are disabled very shortly
afterwards a second time.  This is wasteful.

This patch splits what free_page_mlock() does. The bit check is still
made. However, the update of counters is delayed until the interrupts are
disabled and the non-lock version for clearing the bit is used. One potential
weirdness with this split is that the counters do not get updated if the
bad_page() check is triggered but a system showing bad pages is getting
screwed already.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/internal.h   |   11 +++--------
 mm/page_alloc.c |    8 +++++++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 478223b..7f775a1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -155,14 +155,9 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
  */
 static inline void free_page_mlock(struct page *page)
 {
-	if (unlikely(TestClearPageMlocked(page))) {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		__dec_zone_page_state(page, NR_MLOCK);
-		__count_vm_event(UNEVICTABLE_MLOCKFREED);
-		local_irq_restore(flags);
-	}
+	__ClearPageMlocked(page);
+	__dec_zone_page_state(page, NR_MLOCK);
+	__count_vm_event(UNEVICTABLE_MLOCKFREED);
 }
 
 #else /* CONFIG_UNEVICTABLE_LRU */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1aeb5b0..73cf205 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -501,7 +501,6 @@ static inline void __free_one_page(struct page *page,
 
 static inline int free_pages_check(struct page *page)
 {
-	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_count(page) != 0)  |
@@ -559,6 +558,7 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	unsigned long flags;
 	int i;
 	int bad = 0;
+	int clearMlocked = PageMlocked(page);
 
 	for (i = 0 ; i < (1 << order) ; ++i)
 		bad += free_pages_check(page + i);
@@ -574,6 +574,8 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 	kernel_map_pages(page, 1 << order, 0);
 
 	local_irq_save(flags);
+	if (clearMlocked)
+		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
 	free_one_page(page_zone(page), page, order, migratetype);
 	local_irq_restore(flags);
@@ -1023,6 +1025,7 @@ static void free_hot_cold_page(struct page *page, int cold)
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
+	int clearMlocked = PageMlocked(page);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
@@ -1039,6 +1042,9 @@ static void free_hot_cold_page(struct page *page, int cold)
 	pcp = &zone_pcp(zone, get_cpu())->pcp;
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
+	if (clearMlocked)
+		free_page_mlock(page);
+
 	if (cold)
 		list_add_tail(&page->lru, &pcp->list);
 	else
-- 
1.5.6.5

