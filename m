Return-Path: <linux-kernel-owner+w=401wt.eu-S1762484AbYEIPKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762484AbYEIPKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYEIPKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:10:21 -0400
Received: from relay1.sgi.com ([192.48.171.29]:32770 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750978AbYEIPKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:10:19 -0400
Date: Fri, 9 May 2008 10:10:17 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>,
       Russ Anderson <rja@sgi.com>
Subject: [PATCH 1/3] mm: Minor clean-up of page flags in mm/page_alloc.c v3
Message-ID: <20080509151017.GB16523@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor source code cleanup of page flags in mm/page_alloc.c.  
There is no functional change.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 include/linux/page-flags.h |    9 +++++++++
 mm/page_alloc.c            |   34 +++-------------------------------
 2 files changed, 12 insertions(+), 31 deletions(-)

Index: linus/mm/page_alloc.c
===================================================================
--- linus.orig/mm/page_alloc.c	2008-05-09 09:19:41.251081524 -0500
+++ linus/mm/page_alloc.c	2008-05-09 09:20:04.389938802 -0500
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
+	page->flags &= ~(PAGE_FLAGS_RECLAIM);
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
+		(page->flags & (PAGE_FLAGS_RESERVE))))
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
+		(page->flags & (PAGE_FLAGS_DIRTY))))
 		bad_page(page);
 
 	/*
Index: linus/include/linux/page-flags.h
===================================================================
--- linus.orig/include/linux/page-flags.h	2008-05-09 09:19:41.251081524 -0500
+++ linus/include/linux/page-flags.h	2008-05-09 09:20:04.401940277 -0500
@@ -306,5 +306,14 @@ static inline void __ClearPageTail(struc
 }
 
 #endif /* !PAGEFLAGS_EXTENDED */
+
+#define PAGE_FLAGS	(1 << PG_lru   | 1 << PG_private   | 1 << PG_locked | \
+			 1 << PG_buddy | 1 << PG_writeback | \
+			 1 << PG_slab  | 1 << PG_swapcache | 1 << PG_active)
+
+#define PAGE_FLAGS_RECLAIM	(PAGE_FLAGS | 1 << PG_reclaim | 1 << PG_dirty)
+#define PAGE_FLAGS_RESERVE	(PAGE_FLAGS | 1 << PG_reserved)
+#define PAGE_FLAGS_DIRTY	(PAGE_FLAGS | 1 << PG_reserved | 1 << PG_dirty)
+
 #endif /* !__GENERATING_BOUNDS_H */
 #endif	/* PAGE_FLAGS_H */
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
