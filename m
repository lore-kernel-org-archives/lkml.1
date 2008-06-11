Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYFKSt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYFKSt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886AbYFKSrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895AbYFKSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:18 -0400
Message-Id: <20080611184340.032624781@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:33 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH -mm 19/24] vmstat: mlocked pages statistics
Content-Disposition: inline; filename=vmscan-mlocked-pages-statistics.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Add NR_MLOCK zone page state, which provides a (conservative) count of
mlocked pages (actually, the number of mlocked pages moved off the LRU).

Reworked by lts to fit in with the modified mlock page support in the
Reclaim Scalability series.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---

V2 -> V3:
+ rebase to 23-mm1 atop RvR's split lru series
+ fix definitions of NR_MLOCK to fix build errors when not configured.

V1 -> V2:
+  new in V2 -- pulled in & reworked from Nick's previous series


 drivers/base/node.c    |   22 ++++++++++++----------
 fs/proc/proc_misc.c    |    2 ++
 include/linux/mmzone.h |    2 ++
 mm/internal.h          |   14 +++++++++++---
 mm/mlock.c             |   24 +++++++++++++++++++-----
 mm/vmstat.c            |    1 +
 6 files changed, 47 insertions(+), 18 deletions(-)

Index: linux-2.6.26-rc5-mm2/drivers/base/node.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/drivers/base/node.c	2008-06-10 22:37:14.000000000 -0400
+++ linux-2.6.26-rc5-mm2/drivers/base/node.c	2008-06-10 22:38:44.000000000 -0400
@@ -68,7 +68,8 @@ static ssize_t node_read_meminfo(struct 
 		       "Node %d Active(file):   %8lu kB\n"
 		       "Node %d Inactive(file): %8lu kB\n"
 #ifdef CONFIG_UNEVICTABLE_LRU
-		       "Node %d Noreclaim:      %8lu kB\n"
+		       "Node %d Unevictable:    %8lu kB\n"
+		       "Node %d Mlocked:        %8lu kB\n"
 #endif
 #ifdef CONFIG_HIGHMEM
 		       "Node %d HighTotal:      %8lu kB\n"
@@ -91,16 +92,17 @@ static ssize_t node_read_meminfo(struct 
 		       nid, K(i.totalram),
 		       nid, K(i.freeram),
 		       nid, K(i.totalram - i.freeram),
-		       nid, node_page_state(nid, NR_ACTIVE_ANON) +
-				node_page_state(nid, NR_ACTIVE_FILE),
-		       nid, node_page_state(nid, NR_INACTIVE_ANON) +
-				node_page_state(nid, NR_INACTIVE_FILE),
-		       nid, node_page_state(nid, NR_ACTIVE_ANON),
-		       nid, node_page_state(nid, NR_INACTIVE_ANON),
-		       nid, node_page_state(nid, NR_ACTIVE_FILE),
-		       nid, node_page_state(nid, NR_INACTIVE_FILE),
+		       nid, K(node_page_state(nid, NR_ACTIVE_ANON) +
+				node_page_state(nid, NR_ACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_ANON) +
+				node_page_state(nid, NR_INACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_ACTIVE_ANON)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_ANON)),
+		       nid, K(node_page_state(nid, NR_ACTIVE_FILE)),
+		       nid, K(node_page_state(nid, NR_INACTIVE_FILE)),
 #ifdef CONFIG_UNEVICTABLE_LRU
-		       nid, node_page_state(nid, NR_UNEVICTABLE),
+		       nid, K(node_page_state(nid, NR_UNEVICTABLE)),
+		       nid, K(node_page_state(nid, NR_MLOCK)),
 #endif
 #ifdef CONFIG_HIGHMEM
 		       nid, K(i.totalhigh),
Index: linux-2.6.26-rc5-mm2/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/fs/proc/proc_misc.c	2008-06-10 22:36:56.000000000 -0400
+++ linux-2.6.26-rc5-mm2/fs/proc/proc_misc.c	2008-06-10 22:37:34.000000000 -0400
@@ -177,6 +177,7 @@ static int meminfo_read_proc(char *page,
 		"Inactive(file): %8lu kB\n"
 #ifdef CONFIG_UNEVICTABLE_LRU
 		"Unevictable:    %8lu kB\n"
+		"Mlocked:        %8lu kB\n"
 #endif
 #ifdef CONFIG_HIGHMEM
 		"HighTotal:      %8lu kB\n"
@@ -215,6 +216,7 @@ static int meminfo_read_proc(char *page,
 		K(pages[LRU_INACTIVE_FILE]),
 #ifdef CONFIG_UNEVICTABLE_LRU
 		K(pages[LRU_UNEVICTABLE]),
+		K(pages[NR_MLOCK]),
 #endif
 #ifdef CONFIG_HIGHMEM
 		K(i.totalhigh),
Index: linux-2.6.26-rc5-mm2/include/linux/mmzone.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/mmzone.h	2008-06-10 22:36:56.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/mmzone.h	2008-06-10 22:37:34.000000000 -0400
@@ -88,8 +88,10 @@ enum zone_stat_item {
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 #ifdef CONFIG_UNEVICTABLE_LRU
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
+	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 #else
 	NR_UNEVICTABLE = NR_ACTIVE_FILE, /* avoid compiler errors in dead code */
+	NR_MLOCK = NR_ACTIVE_FILE,
 #endif
 	NR_ANON_PAGES,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
Index: linux-2.6.26-rc5-mm2/mm/mlock.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/mlock.c	2008-06-10 22:37:26.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/mlock.c	2008-06-10 22:37:34.000000000 -0400
@@ -56,6 +56,7 @@ void __clear_page_mlock(struct page *pag
 {
 	VM_BUG_ON(!PageLocked(page));	/* for LRU isolate/putback */
 
+	dec_zone_page_state(page, NR_MLOCK);
 	if (!isolate_lru_page(page)) {
 		putback_lru_page(page);
 	} else {
@@ -76,8 +77,11 @@ void mlock_vma_page(struct page *page)
 {
 	BUG_ON(!PageLocked(page));
 
-	if (!TestSetPageMlocked(page) && !isolate_lru_page(page))
-		putback_lru_page(page);
+	if (!TestSetPageMlocked(page)) {
+		inc_zone_page_state(page, NR_MLOCK);
+		if (!isolate_lru_page(page))
+			putback_lru_page(page);
+	}
 }
 
 /*
@@ -102,9 +106,19 @@ static void munlock_vma_page(struct page
 {
 	BUG_ON(!PageLocked(page));
 
-	if (TestClearPageMlocked(page) && !isolate_lru_page(page)) {
-		try_to_munlock(page);
-		putback_lru_page(page);
+	if (TestClearPageMlocked(page)) {
+		dec_zone_page_state(page, NR_MLOCK);
+		if (!isolate_lru_page(page)) {
+			try_to_munlock(page);	/* maybe relock the page */
+			putback_lru_page(page);
+		}
+		/*
+		 * Else we lost the race.  let try_to_unmap() deal with it.
+		 * At least we get the page state and mlock stats right.
+		 * However, page is still on the noreclaim list.  We'll fix
+		 * that up when the page is eventually freed or we scan the
+		 * noreclaim list.
+		 */
 	}
 }
 
Index: linux-2.6.26-rc5-mm2/mm/vmstat.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmstat.c	2008-06-10 22:36:56.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmstat.c	2008-06-10 22:37:34.000000000 -0400
@@ -608,6 +608,7 @@ static const char * const vmstat_text[] 
 	"nr_active_file",
 #ifdef CONFIG_UNEVICTABLE_LRU
 	"nr_unevictable",
+	"nr_mlock",
 #endif
 	"nr_anon_pages",
 	"nr_mapped",
Index: linux-2.6.26-rc5-mm2/mm/internal.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/internal.h	2008-06-10 22:37:26.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/internal.h	2008-06-10 22:37:34.000000000 -0400
@@ -101,7 +101,8 @@ static inline int is_mlocked_vma(struct 
 	if (likely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) != VM_LOCKED))
 		return 0;
 
-	SetPageMlocked(page);
+	if (!TestSetPageMlocked(page))
+		inc_zone_page_state(page, NR_MLOCK);
 	return 1;
 }
 
@@ -128,12 +129,19 @@ static inline void clear_page_mlock(stru
 
 /*
  * mlock_migrate_page - called only from migrate_page_copy() to
- * migrate the Mlocked page flag
+ * migrate the Mlocked page flag; update statistics.
  */
 static inline void mlock_migrate_page(struct page *newpage, struct page *page)
 {
-	if (TestClearPageMlocked(page))
+	if (TestClearPageMlocked(page)) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		__dec_zone_page_state(page, NR_MLOCK);
 		SetPageMlocked(newpage);
+		__inc_zone_page_state(newpage, NR_MLOCK);
+		local_irq_restore(flags);
+	}
 }
 
 

-- 
All Rights Reversed

