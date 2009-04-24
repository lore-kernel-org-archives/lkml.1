Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZDXAeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZDXAeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZDXAdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:33:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53842 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZDXAdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:33:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 15/22] Do not disable interrupts in free_page_mlock()
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, cl@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org, ming.m.lin@intel.com,
       yanmin_zhang@linux.intel.com, peterz@infradead.org,
       penberg@cs.helsinki.fi, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <20090423155951.6778bdd3.akpm@linux-foundation.org>
References: <1240408407-21848-16-git-send-email-mel@csn.ul.ie> <20090423155951.6778bdd3.akpm@linux-foundation.org>
Message-Id: <20090424090721.1047.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 24 Apr 2009 09:33:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -157,14 +157,9 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
> >   */
> >  static inline void free_page_mlock(struct page *page)
> >  {
> > -	if (unlikely(TestClearPageMlocked(page))) {
> > -		unsigned long flags;
> > -
> > -		local_irq_save(flags);
> > -		__dec_zone_page_state(page, NR_MLOCK);
> > -		__count_vm_event(UNEVICTABLE_MLOCKFREED);
> > -		local_irq_restore(flags);
> > -	}
> > +	__ClearPageMlocked(page);
> > +	__dec_zone_page_state(page, NR_MLOCK);
> > +	__count_vm_event(UNEVICTABLE_MLOCKFREED);
> >  }
> 
> The conscientuous reviewer runs around and checks for free_page_mlock()
> callers in other .c files which might be affected.
> 
> Only there are no such callers.
> 
> The reviewer's job would be reduced if free_page_mlock() wasn't
> needlessly placed in a header file!

very sorry.

How about this?

=============================================
Subject: [PATCH] move free_page_mlock() to page_alloc.c

Currently, free_page_mlock() is only called from page_alloc.c.
Thus, we can move it to page_alloc.c.

Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/internal.h   |   18 ------------------
 mm/page_alloc.c |   21 +++++++++++++++++++++
 2 files changed, 21 insertions(+), 18 deletions(-)

Index: b/mm/internal.h
===================================================================
--- a/mm/internal.h	2009-04-24 09:12:03.000000000 +0900
+++ b/mm/internal.h	2009-04-24 09:12:10.000000000 +0900
@@ -150,23 +150,6 @@ static inline void mlock_migrate_page(st
 	}
 }
 
-/*
- * free_page_mlock() -- clean up attempts to free and mlocked() page.
- * Page should not be on lru, so no need to fix that up.
- * free_pages_check() will verify...
- */
-static inline void free_page_mlock(struct page *page)
-{
-	if (unlikely(TestClearPageMlocked(page))) {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		__dec_zone_page_state(page, NR_MLOCK);
-		__count_vm_event(UNEVICTABLE_MLOCKFREED);
-		local_irq_restore(flags);
-	}
-}
-
 #else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
 {
@@ -175,7 +158,6 @@ static inline int is_mlocked_vma(struct 
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
-static inline void free_page_mlock(struct page *page) { }
 
 #endif /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2009-04-24 09:12:03.000000000 +0900
+++ b/mm/page_alloc.c	2009-04-24 09:13:25.000000000 +0900
@@ -491,6 +491,27 @@ static inline void __free_one_page(struc
 	zone->free_area[order].nr_free++;
 }
 
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
+/*
+ * free_page_mlock() -- clean up attempts to free and mlocked() page.
+ * Page should not be on lru, so no need to fix that up.
+ * free_pages_check() will verify...
+ */
+static void free_page_mlock(struct page *page)
+{
+	if (unlikely(TestClearPageMlocked(page))) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		__dec_zone_page_state(page, NR_MLOCK);
+		__count_vm_event(UNEVICTABLE_MLOCKFREED);
+		local_irq_restore(flags);
+	}
+}
+#else
+static void free_page_mlock(struct page *page) { }
+#endif
+
 static inline int free_pages_check(struct page *page)
 {
 	free_page_mlock(page);


