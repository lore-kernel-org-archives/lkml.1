Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbYFKStm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbYFKStm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYFKSrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896AbYFKSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:18 -0400
Message-Id: <20080611184340.173391769@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:35 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 21/24] vmstat: unevictable and mlocked pages vm events
Content-Disposition: inline; filename=vmscan-noreclaim-and-mlocked-pages-vm-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Lee Schermerhorn <lee.schermerhorn@hp.com>

Add some event counters to vmstats for testing unevictable/mlock.  
Some of these might be interesting enough to keep around.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---
 include/linux/vmstat.h |    9 +++++++++
 mm/internal.h          |    4 +++-
 mm/mlock.c             |   33 +++++++++++++++++++++++++--------
 mm/vmscan.c            |   16 +++++++++++++++-
 mm/vmstat.c            |   10 ++++++++++
 5 files changed, 62 insertions(+), 10 deletions(-)

Index: linux-2.6.26-rc5-mm2/include/linux/vmstat.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/vmstat.h	2008-06-10 22:23:56.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/vmstat.h	2008-06-10 22:25:48.000000000 -0400
@@ -41,6 +41,15 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_HUGETLB_PAGE
 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
 #endif
+#ifdef CONFIG_UNEVICTABLE_LRU
+		NORECL_PGCULLED,	/* culled to noreclaim list */
+		NORECL_PGSCANNED,	/* scanned for reclaimability */
+		NORECL_PGRESCUED,	/* rescued from noreclaim list */
+		NORECL_PGMLOCKED,
+		NORECL_PGMUNLOCKED,
+		NORECL_PGCLEARED,
+		NORECL_PGSTRANDED,	/* unable to isolate on unlock */
+#endif
 		NR_VM_EVENT_ITEMS
 };
 
Index: linux-2.6.26-rc5-mm2/mm/vmscan.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmscan.c	2008-06-10 22:23:56.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmscan.c	2008-06-10 22:25:49.000000000 -0400
@@ -468,12 +468,13 @@ int putback_lru_page(struct page *page)
 {
 	int lru;
 	int ret = 1;
+	int was_unevictable;
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageLRU(page));
 
 	lru = !!TestClearPageActive(page);
-	ClearPageUnevictable(page);	/* for page_evictable() */
+	was_unevictable = TestClearPageUnevictable(page); /* for page_evictable() */
 
 	if (unlikely(!page->mapping)) {
 		/*
@@ -493,6 +494,10 @@ int putback_lru_page(struct page *page)
 		lru += page_is_file_cache(page);
 		lru_cache_add_lru(page, lru);
 		mem_cgroup_move_lists(page, lru);
+#ifdef CONFIG_UNEVICTABLE_LRU
+		if (was_unevictable)
+			count_vm_event(NORECL_PGRESCUED);
+#endif
 	} else {
 		/*
 		 * Put unevictable pages directly on zone's unevictable
@@ -500,6 +505,10 @@ int putback_lru_page(struct page *page)
 		 */
 		add_page_to_unevictable_list(page);
 		mem_cgroup_move_lists(page, LRU_UNEVICTABLE);
+#ifdef CONFIG_UNEVICTABLE_LRU
+		if (!was_unevictable)
+			count_vm_event(NORECL_PGCULLED);
+#endif
 	}
 
 	put_page(page);		/* drop ref from isolate */
@@ -2373,6 +2382,7 @@ static void check_move_unevictable_page(
 		__dec_zone_state(zone, NR_UNEVICTABLE);
 		list_move(&page->lru, &zone->lru[l].list);
 		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
+		__count_vm_event(NORECL_PGRESCUED);
 	} else {
 		/*
 		 * rotate unevictable list
@@ -2404,6 +2414,7 @@ void scan_mapping_unevictable_pages(stru
 	while (next < end &&
 		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
 		int i;
+		int pg_scanned = 0;
 
 		zone = NULL;
 
@@ -2412,6 +2423,7 @@ void scan_mapping_unevictable_pages(stru
 			pgoff_t page_index = page->index;
 			struct zone *pagezone = page_zone(page);
 
+			pg_scanned++;
 			if (page_index > next)
 				next = page_index;
 			next++;
@@ -2442,6 +2454,8 @@ void scan_mapping_unevictable_pages(stru
 		if (zone)
 			spin_unlock_irq(&zone->lru_lock);
 		pagevec_release(&pvec);
+
+		count_vm_events(NORECL_PGSCANNED, pg_scanned);
 	}
 
 }
Index: linux-2.6.26-rc5-mm2/mm/vmstat.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmstat.c	2008-06-10 22:23:56.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmstat.c	2008-06-10 22:25:48.000000000 -0400
@@ -664,6 +664,16 @@ static const char * const vmstat_text[] 
 	"htlb_buddy_alloc_success",
 	"htlb_buddy_alloc_fail",
 #endif
+
+#ifdef CONFIG_UNEVICTABLE_LRU
+	"noreclaim_pgs_culled",
+	"noreclaim_pgs_scanned",
+	"noreclaim_pgs_rescued",
+	"noreclaim_pgs_mlocked",
+	"noreclaim_pgs_munlocked",
+	"noreclaim_pgs_cleared",
+	"noreclaim_pgs_stranded",
+#endif
 #endif
 };
 
Index: linux-2.6.26-rc5-mm2/mm/mlock.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/mlock.c	2008-06-10 22:23:56.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/mlock.c	2008-06-10 22:25:56.000000000 -0400
@@ -18,6 +18,7 @@
 #include <linux/rmap.h>
 #include <linux/mmzone.h>
 #include <linux/hugetlb.h>
+#include <linux/vmstat.h>
 
 #include "internal.h"
 
@@ -57,6 +58,7 @@ void __clear_page_mlock(struct page *pag
 	VM_BUG_ON(!PageLocked(page));	/* for LRU isolate/putback */
 
 	dec_zone_page_state(page, NR_MLOCK);
+	count_vm_event(NORECL_PGCLEARED);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
 	} else {
@@ -66,6 +68,8 @@ void __clear_page_mlock(struct page *pag
 		lru_add_drain_all();
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
+		else if (PageUnevictable(page))
+			count_vm_event(NORECL_PGSTRANDED);
 	}
 }
 
@@ -79,6 +83,7 @@ void mlock_vma_page(struct page *page)
 
 	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
+		count_vm_event(NORECL_PGMLOCKED);
 		if (!isolate_lru_page(page))
 			putback_lru_page(page);
 	}
@@ -109,16 +114,28 @@ static void munlock_vma_page(struct page
 	if (TestClearPageMlocked(page)) {
 		dec_zone_page_state(page, NR_MLOCK);
 		if (!isolate_lru_page(page)) {
-			try_to_munlock(page);	/* maybe relock the page */
+			int ret = try_to_munlock(page);
+			/*
+			 * did try_to_unlock() succeed or punt?
+			 */
+			if (ret == SWAP_SUCCESS || ret == SWAP_AGAIN)
+				count_vm_event(NORECL_PGMUNLOCKED);
+
 			putback_lru_page(page);
+		} else {
+			/*
+			 * We lost the race.  let try_to_unmap() deal
+			 * with it.  At least we get the page state and
+			 * mlock stats right.  However, page is still on
+			 * the noreclaim list.  We'll fix that up when
+			 * the page is eventually freed or we scan the
+			 * noreclaim list.
+			 */
+			if (PageUnevictable(page))
+				count_vm_event(NORECL_PGSTRANDED);
+			else
+				count_vm_event(NORECL_PGMUNLOCKED);
 		}
-		/*
-		 * Else we lost the race.  let try_to_unmap() deal with it.
-		 * At least we get the page state and mlock stats right.
-		 * However, page is still on the noreclaim list.  We'll fix
-		 * that up when the page is eventually freed or we scan the
-		 * noreclaim list.
-		 */
 	}
 }
 
Index: linux-2.6.26-rc5-mm2/mm/internal.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/internal.h	2008-06-10 22:23:56.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/internal.h	2008-06-10 22:25:48.000000000 -0400
@@ -101,8 +101,10 @@ static inline int is_mlocked_vma(struct 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
 
-	if (!TestSetPageMlocked(page))
+	if (!TestSetPageMlocked(page)) {
 		inc_zone_page_state(page, NR_MLOCK);
+		count_vm_event(NORECL_PGMLOCKED);
+	}
 	return 1;
 }
 

-- 
All Rights Reversed

