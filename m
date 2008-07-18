Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbYGRUgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbYGRUgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbYGRUgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:36:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34318 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753479AbYGRUgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:36:08 -0400
Date: Fri, 18 Jul 2008 15:36:06 -0500
From: Russ Anderson <rja@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/2] mm: Avoid putting a bad page back on the LRU v7
Message-ID: <20080718203606.GE29621@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] mm: Avoid putting a bad page back on the LRU v7

Prevent a page with a physical memory error from being placed back
on the LRU.  A new page flag (PG_memerror) is added if
CONFIG_PAGEFLAGS_EXTENDED is defined.

Signed-off-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/page-flags.h |   18 ++++++++++++++++--
 mm/migrate.c               |   31 ++++++++++++++++++++++++++++++-
 mm/page_alloc.c            |   13 ++++++++-----
 3 files changed, 54 insertions(+), 8 deletions(-)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2008-07-18 15:15:48.000000000 -0500
+++ linux/mm/page_alloc.c	2008-07-18 15:16:09.000000000 -0500
@@ -602,10 +602,10 @@ static int prep_new_page(struct page *pa
 		bad_page(page);
 
 	/*
-	 * For now, we report if PG_reserved was found set, but do not
-	 * clear it, and do not allocate the page: as a safety net.
+	 * For now, we report if PG_reserved or PG_memerror was found set, but
+	 * do not clear it, and do not allocate the page: as a safety net.
 	 */
-	if (PageReserved(page))
+	if (PageReserved(page) || PageMemError(page))
 		return 1;
 
 	page->flags &= ~(1 << PG_uptodate | 1 << PG_error | 1 << PG_reclaim |
@@ -2475,8 +2475,11 @@ static void setup_zone_migrate_reserve(s
 			continue;
 		page = pfn_to_page(pfn);
 
-		/* Blocks with reserved pages will never free, skip them. */
-		if (PageReserved(page))
+		/*
+		 * Blocks with reserved pages or memory errors will never
+		 * free, skip them.
+		 */
+		if (PageReserved(page) || PageMemError(page))
 			continue;
 
 		block_migratetype = get_pageblock_migratetype(page);
Index: linux/mm/migrate.c
===================================================================
--- linux.orig/mm/migrate.c	2008-07-18 15:15:48.000000000 -0500
+++ linux/mm/migrate.c	2008-07-18 15:16:09.000000000 -0500
@@ -720,7 +720,25 @@ unlock:
  		 * restored.
  		 */
  		list_del(&page->lru);
- 		move_to_lru(page);
+		if (PageMemError(page))
+			if (rc == 0)
+				/*
+				 * A page with a memory error that has
+				 * been migrated will not be moved to
+				 * the LRU.
+				 */
+				goto move_newpage;
+			else
+				/*
+				 * The page failed to migrate and will not
+				 * be added to the bad page list.  Clearing
+				 * the error bit will allow another attempt
+				 * to migrate if it gets another correctable
+				 * error.
+				 */
+				ClearPageMemError(page);
+
+		move_to_lru(page);
 	}
 
 move_newpage:
@@ -790,6 +808,17 @@ int migrate_pages(struct list_head *from
 			}
 		}
 	}
+
+	if (rc != 0)
+		list_for_each_entry_safe(page, page2, from, lru)
+			if (PageMemError(page))
+				/*
+				 * The page failed to migrate.  Clearing
+				 * the error bit will allow another attempt
+				 * to migrate if it gets another correctable
+				 * error.
+				 */
+				ClearPageMemError(page);
 	rc = 0;
 out:
 	if (!swapwrite)
Index: linux/include/linux/page-flags.h
===================================================================
--- linux.orig/include/linux/page-flags.h	2008-07-18 15:15:48.000000000 -0500
+++ linux/include/linux/page-flags.h	2008-07-18 15:16:09.000000000 -0500
@@ -84,6 +84,7 @@ enum pageflags {
 	PG_private,		/* If pagecache, has fs-private data */
 	PG_writeback,		/* Page is under writeback */
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
+	PG_memerror,		/* Page has a physical memory error */
 	PG_head,		/* A head page */
 	PG_tail,		/* A tail page */
 #else
@@ -132,15 +133,21 @@ static inline int TestSetPage##uname(str
 static inline int TestClearPage##uname(struct page *page)		\
 		{ return test_and_clear_bit(PG_##lname, &page->flags); }
 
+#define PAGEFLAGMASK(uname, lname)					\
+static inline int PAGEMASK_##uname(void)				\
+		{ return (1 << PG_##lname); }
 
 #define PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
-	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)
+	SETPAGEFLAG(uname, lname) CLEARPAGEFLAG(uname, lname)		\
+	PAGEFLAGMASK(uname, lname)
 
 #define __PAGEFLAG(uname, lname) TESTPAGEFLAG(uname, lname)		\
 	__SETPAGEFLAG(uname, lname)  __CLEARPAGEFLAG(uname, lname)
 
 #define PAGEFLAG_FALSE(uname) 						\
 static inline int Page##uname(struct page *page) 			\
+			{ return 0; }					\
+static inline int PAGEMASK_##uname(void)				\
 			{ return 0; }
 
 #define TESTSCFLAG(uname, lname)					\
@@ -308,9 +315,16 @@ static inline void __ClearPageTail(struc
 
 #endif /* !PAGEFLAGS_EXTENDED */
 
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+PAGEFLAG(MemError, memerror)
+#else
+PAGEFLAG_FALSE(MemError)
+#endif
+
 #define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
 			 1 << PG_buddy | 1 << PG_writeback | \
-			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
+			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active) |\
+			 PAGEMASK_MemError()
 
 /*
  * Flags checked in bad_page().  Pages on the free list should not have
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
