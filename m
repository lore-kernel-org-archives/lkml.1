Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbYFIQTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbYFIQTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYFIQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:18:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43424 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756724AbYFIQSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:18:46 -0400
Date: Mon, 9 Jun 2008 11:18:45 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/3] mm: Minor clean-up of page flags in mm/page_alloc.c v6
Message-ID: <20080609161845.GB14939@sgi.com>
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
 include/linux/page-flags.h |   24 ++++++++++++++++++++++++
 mm/page_alloc.c            |   34 +++-------------------------------
 2 files changed, 27 insertions(+), 31 deletions(-)

Index: linux-next/mm/page_alloc.c
===================================================================
--- linux-next.orig/mm/page_alloc.c	2008-06-09 09:26:47.542997555 -0500
+++ linux-next/mm/page_alloc.c	2008-06-09 09:26:52.203578218 -0500
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
Index: linux-next/include/linux/page-flags.h
===================================================================
--- linux-next.orig/include/linux/page-flags.h	2008-06-09 09:26:47.546998054 -0500
+++ linux-next/include/linux/page-flags.h	2008-06-09 09:26:52.223580710 -0500
@@ -307,5 +307,29 @@ static inline void __ClearPageTail(struc
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
+ * Flags checked when a page is prepped for return by the page allocator.
+ * Pages being prepped should not have these flags set.  It they are, there
+ * is a problem.
+ */
+#define PAGE_FLAGS_CHECK_AT_PREP (PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
+
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
