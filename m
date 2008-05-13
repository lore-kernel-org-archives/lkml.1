Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbYEMXDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbYEMXDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 19:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756654AbYEMXDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 19:03:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37693 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756287AbYEMXDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 19:03:13 -0400
Date: Tue, 13 May 2008 18:03:12 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 2/3] mm: Avoid putting a bad page back on the LRU v4
Message-ID: <20080513230312.GC26722@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent a page with a physical memory error from being placed back
on the LRU.  A new page flag (PG_memerror) is added on 64 bit
architectures.  

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 include/linux/migrate.h    |    1 +
 include/linux/page-flags.h |   11 ++++++++++-
 mm/migrate.c               |   12 ++++++++++--
 mm/page_alloc.c            |    8 ++++----
 4 files changed, 25 insertions(+), 7 deletions(-)

Index: linus/mm/page_alloc.c
===================================================================
--- linus.orig/mm/page_alloc.c	2008-05-13 15:27:32.308804354 -0500
+++ linus/mm/page_alloc.c	2008-05-13 15:35:57.071584039 -0500
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
@@ -2474,7 +2474,7 @@ static void setup_zone_migrate_reserve(s
 		page = pfn_to_page(pfn);
 
 		/* Blocks with reserved pages will never free, skip them. */
-		if (PageReserved(page))
+		if (PageReserved(page) || PageMemError(page))
 			continue;
 
 		block_migratetype = get_pageblock_migratetype(page);
Index: linus/mm/migrate.c
===================================================================
--- linus.orig/mm/migrate.c	2008-05-13 15:27:32.308804354 -0500
+++ linus/mm/migrate.c	2008-05-13 16:14:04.695801820 -0500
@@ -35,6 +35,8 @@
 
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
 
+unsigned int totalbad_pages;
+
 /*
  * Isolate one page from the LRU lists. If successful put it onto
  * the indicated list with elevated page count.
@@ -110,6 +112,8 @@ int putback_lru_pages(struct list_head *
 
 	list_for_each_entry_safe(page, page2, l, lru) {
 		list_del(&page->lru);
+		if (unlikely(PageMemError(page)))
+			continue;
 		move_to_lru(page);
 		count++;
 	}
@@ -717,10 +721,14 @@ unlock:
  		 * A page that has been migrated has all references
  		 * removed and will be freed. A page that has not been
  		 * migrated will have kepts its references and be
- 		 * restored.
+		 * restored.  A page with a memory error will not
+		 * be moved to the LRU.
  		 */
  		list_del(&page->lru);
- 		move_to_lru(page);
+		if (PageMemError(page))
+			totalbad_pages++;
+		else
+			move_to_lru(page);
 	}
 
 move_newpage:
Index: linus/include/linux/page-flags.h
===================================================================
--- linus.orig/include/linux/page-flags.h	2008-05-13 15:27:32.308804354 -0500
+++ linus/include/linux/page-flags.h	2008-05-13 15:28:06.589058491 -0500
@@ -84,6 +84,7 @@ enum pageflags {
 	PG_private,		/* If pagecache, has fs-private data */
 	PG_writeback,		/* Page is under writeback */
 #ifdef CONFIG_PAGEFLAGS_EXTENDED
+	PG_memerror,		/* Page has a physical memory error */
 	PG_head,		/* A head page */
 	PG_tail,		/* A tail page */
 #else
@@ -307,9 +308,17 @@ static inline void __ClearPageTail(struc
 
 #endif /* !PAGEFLAGS_EXTENDED */
 
-#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
+#define PAGE_FLAGS_BASE	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
 			 1 << PG_buddy | 1 << PG_writeback | \
 			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
+
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+PAGEFLAG(MemError, memerror)
+#define	PAGE_FLAGS	(PAGE_FLAGS_BASE | 1UL << PG_memerror)
+#else
+PAGEFLAG_FALSE(MemError)
+#define	PAGE_FLAGS	(PAGE_FLAGS_BASE)
+#endif
 
 #define PAGE_FLAGS_RECLAIM	(PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
 #define PAGE_FLAGS_RESERVE	(PAGE_FLAGS | 1 << PG_reserved)
Index: linus/include/linux/migrate.h
===================================================================
--- linus.orig/include/linux/migrate.h	2008-05-13 15:27:32.308804354 -0500
+++ linus/include/linux/migrate.h	2008-05-13 15:28:06.605060477 -0500
@@ -38,6 +38,7 @@ extern int migrate_prep(void);
 extern int migrate_vmas(struct mm_struct *mm,
 		const nodemask_t *from, const nodemask_t *to,
 		unsigned long flags);
+extern unsigned int totalbad_pages;
 #else
 static inline int vma_migratable(struct vm_area_struct *vma)
 					{ return 0; }
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
