Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbYEPTW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbYEPTW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 15:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYEPTWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 15:22:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52473 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754023AbYEPTWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 15:22:46 -0400
Date: Fri, 16 May 2008 14:22:45 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/3] mm: Minor clean-up of page flags in mm/page_alloc.c v5
Message-ID: <20080516192244.GD7885@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor source code cleanup of page flags in mm/page_alloc.c.  
Move the definition of the groups of bits to page-flags.h.

The purpose of this clean up is that the next patch will
conditionally add a page flag to the groups.  Doing that
in a header file is cleaner than adding #ifdefs to the
C code.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 include/linux/page-flags.h |   23 +++++++++++++++++++++++
 mm/page_alloc.c            |   34 +++-------------------------------
 2 files changed, 26 insertions(+), 31 deletions(-)

Index: linus/mm/page_alloc.c
===================================================================
--- linus.orig/mm/page_alloc.c	2008-05-15 12:58:58.429776893 -0500
+++ linus/mm/page_alloc.c	2008-05-16 12:25:20.494096186 -0500
@@ -237,16 +237,7 @@ static void bad_page(struct page *page)
 	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n"
 		KERN_EMERG "Backtrace:\n");
 	dump_stack();
-	page->flags &= ~(1 << PG_lru	|
-			1 << PG_private |
-			1 << PG_locked	|
-			1 << PG_active	|
-			1 << PG_dirty	|
-			1 << PG_reclaim |
-			1 << PG_slab    |
-			1 << PG_swapcache |
-			1 << PG_writeback |
-			1 << PG_buddy );
+	page->flags &= ~PAGE_FLAGS_CLEAR_WHEN_BAD;
 	set_page_count(page, 0);
 	reset_page_mapcount(page);
 	page->mapping = NULL;
@@ -463,16 +454,7 @@ static inline int free_pages_check(struc
 		(page->mapping != NULL)  |
 		(page_get_page_cgroup(page) != NULL) |
 		(page_count(page) != 0)  |
-		(page->flags & (
-			1 << PG_lru	|
-			1 << PG_private |
-			1 << PG_locked	|
-			1 << PG_active	|
-			1 << PG_slab	|
-			1 << PG_swapcache |
-			1 << PG_writeback |
-			1 << PG_reserved |
-			1 << PG_buddy ))))
+		(page->flags & PAGE_FLAGS_CHECK_AT_FREE)))
 		bad_page(page);
 	if (PageDirty(page))
 		__ClearPageDirty(page);
@@ -616,17 +598,7 @@ static int prep_new_page(struct page *pa
 		(page->mapping != NULL)  |
 		(page_get_page_cgroup(page) != NULL) |
 		(page_count(page) != 0)  |
-		(page->flags & (
-			1 << PG_lru	|
-			1 << PG_private	|
-			1 << PG_locked	|
-			1 << PG_active	|
-			1 << PG_dirty	|
-			1 << PG_slab    |
-			1 << PG_swapcache |
-			1 << PG_writeback |
-			1 << PG_reserved |
-			1 << PG_buddy ))))
+		(page->flags & PAGE_FLAGS_CHECK_AT_PREP)))
 		bad_page(page);
 
 	/*
Index: linus/include/linux/page-flags.h
===================================================================
--- linus.orig/include/linux/page-flags.h	2008-05-15 12:58:26.265815299 -0500
+++ linus/include/linux/page-flags.h	2008-05-16 12:25:20.494096186 -0500
@@ -306,5 +306,28 @@ static inline void __ClearPageTail(struc
 }
 
 #endif /* !PAGEFLAGS_EXTENDED */
+
+#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
+			 1 << PG_buddy | 1 << PG_writeback | \
+			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
+
+/*
+ * Flags checked in bad_page().  Pages on the free list should not have
+ * these flags set.  It they are, there is a problem.
+ */
+#define PAGE_FLAGS_CLEAR_WHEN_BAD (PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
+
+/*
+ * Flags checked when a page is freed.  Pages being freed should not have
+ * these flags set.  It they are, there is a problem.
+ */
+#define PAGE_FLAGS_CHECK_AT_FREE (PAGE_FLAGS | 1 << PG_reserved)
+
+/*
+ * Flags checked when a page is freed.  Pages being freed should not have
+ * these flags set.  It they are, there is a problem.
+ */
+#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
+
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
