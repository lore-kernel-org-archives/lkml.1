Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbYFFUjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbYFFUjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932538AbYFFUbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:31:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761897AbYFFUbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:31:04 -0400
Message-Id: <20080606202859.942321337@redhat.com>
References: <20080606202838.390050172@redhat.com>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 16:29:02 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
From: Rik van Riel <riel@redhat.com>
Subject: [PATCH -mm 24/25] Mlocked Pages: count attempts to free mlocked page
Content-Disposition: inline; filename=rvr-24-lts-count-free-mlocked-pages.patch
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

Index: linux-2.6.26-rc2-mm1/mm/internal.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/internal.h	2008-06-06 16:06:48.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/internal.h	2008-06-06 16:06:56.000000000 -0400
@@ -152,6 +152,22 @@ static inline void mlock_migrate_page(st
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
 
 #else /* CONFIG_NORECLAIM_MLOCK */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
@@ -161,6 +177,7 @@ static inline int is_mlocked_vma(struct 
 static inline void clear_page_mlock(struct page *page) { }
 static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
+static inline void free_page_mlock(struct page *page) { }
 
 #endif /* CONFIG_NORECLAIM_MLOCK */
 
Index: linux-2.6.26-rc2-mm1/mm/page_alloc.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/page_alloc.c	2008-06-06 16:06:28.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/page_alloc.c	2008-06-06 16:06:56.000000000 -0400
@@ -484,6 +484,7 @@ static inline void __free_one_page(struc
 
 static inline int free_pages_check(struct page *page)
 {
+	free_page_mlock(page);
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(page_get_page_cgroup(page) != NULL) |
Index: linux-2.6.26-rc2-mm1/include/linux/vmstat.h
===================================================================
--- linux-2.6.26-rc2-mm1.orig/include/linux/vmstat.h	2008-06-06 16:06:48.000000000 -0400
+++ linux-2.6.26-rc2-mm1/include/linux/vmstat.h	2008-06-06 16:06:56.000000000 -0400
@@ -50,6 +50,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		NORECL_PGMUNLOCKED,
 		NORECL_PGCLEARED,
 		NORECL_PGSTRANDED,	/* unable to isolate on unlock */
+		NORECL_MLOCKFREED,
 #endif
 #endif
 		NR_VM_EVENT_ITEMS
Index: linux-2.6.26-rc2-mm1/mm/vmstat.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/mm/vmstat.c	2008-06-06 16:06:48.000000000 -0400
+++ linux-2.6.26-rc2-mm1/mm/vmstat.c	2008-06-06 16:06:56.000000000 -0400
@@ -769,6 +769,7 @@ static const char * const vmstat_text[] 
 	"noreclaim_pgs_munlocked",
 	"noreclaim_pgs_cleared",
 	"noreclaim_pgs_stranded",
+	"noreclaim_pgs_mlockfreed",
 #endif
 #endif
 #endif

-- 
All Rights Reversed

