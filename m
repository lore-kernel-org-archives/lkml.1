Return-Path: <linux-kernel-owner+w=401wt.eu-S1761736AbYFKSyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761736AbYFKSyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbYFKSrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:47:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193AbYFKSrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:47:47 -0400
Message-Id: <20080611184340.327741116@redhat.com>
References: <20080611184214.605110868@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 14:42:37 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH -mm 23/24] mlock: count attempts to free mlocked page
Content-Disposition: inline; filename=vmscan-mlocked-pages-count-attempts-to-free-mlocked-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Allow free of mlock()ed pages.  This shouldn't happen, but during
developement, it occasionally did.

This patch allows us to survive that condition, while keeping the
statistics and events correct for debug.


Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---

 include/linux/vmstat.h |    1 +
 mm/internal.h          |   17 +++++++++++++++++
 mm/page_alloc.c        |    1 +
 mm/vmstat.c            |    1 +
 4 files changed, 20 insertions(+)

Index: linux-2.6.26-rc5-mm2/mm/internal.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/internal.h	2008-06-10 21:40:05.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/internal.h	2008-06-10 21:55:28.000000000 -0400
@@ -146,6 +146,22 @@ static inline void mlock_migrate_page(st
 	}
 }
 
+/*
+ * free_page_mlock() -- clean up attempts to free and mlocked() page.
+ * Page should not be on lru, so no need to fix that up.
+ * free_pages_check() will verify...
+ */
+static inline void free_page_mlock(struct page *page)
+{
+	if (unlikely(TestClearPageMlocked(page))) {
+		unsigned long flags;
+
+		local_irq_save(flags);
+		__dec_zone_page_state(page, NR_MLOCK);
+		__count_vm_event(NORECL_MLOCKFREED);
+		local_irq_restore(flags);
+	}
+}
 
 #else /* CONFIG_UNEVICTABLE_LRU */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
@@ -155,6 +171,7 @@ static inline int is_mlocked_vma(struct 
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
+static inline void free_page_mlock(struct page *page) { }
 
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
Index: linux-2.6.26-rc5-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/page_alloc.c	2008-06-10 21:21:44.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/page_alloc.c	2008-06-10 21:55:28.000000000 -0400
@@ -465,6 +465,7 @@ static inline void __free_one_page(struc
 
 static inline int free_pages_check(struct page *page)
 {
+	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_get_page_cgroup(page) != NULL) |
Index: linux-2.6.26-rc5-mm2/include/linux/vmstat.h
===================================================================
--- linux-2.6.26-rc5-mm2.orig/include/linux/vmstat.h	2008-06-10 21:40:05.000000000 -0400
+++ linux-2.6.26-rc5-mm2/include/linux/vmstat.h	2008-06-10 21:55:28.000000000 -0400
@@ -49,6 +49,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NORECL_PGMUNLOCKED,
 		NORECL_PGCLEARED,
 		NORECL_PGSTRANDED,	/* unable to isolate on unlock */
+		NORECL_MLOCKFREED,
 #endif
 		NR_VM_EVENT_ITEMS
 };
Index: linux-2.6.26-rc5-mm2/mm/vmstat.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/vmstat.c	2008-06-10 21:40:05.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/vmstat.c	2008-06-10 21:55:28.000000000 -0400
@@ -673,6 +673,7 @@ static const char * const vmstat_text[] 
 	"noreclaim_pgs_munlocked",
 	"noreclaim_pgs_cleared",
 	"noreclaim_pgs_stranded",
+	"noreclaim_pgs_mlockfreed",
 #endif
 #endif
 };

-- 
All Rights Reversed

