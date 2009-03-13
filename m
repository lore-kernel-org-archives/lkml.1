Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbZCMRij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbZCMRij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZCMRiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:38:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36585 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbZCMRiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:38:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] NOMMU: There is no mlock() for NOMMU,
	so don't provide the bits
To: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, peterz@infradead.org,
       nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com, lee.schermerhorn@hp.com
Date: Fri, 13 Mar 2009 17:33:48 +0000
Message-ID: <20090313173348.10169.31420.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
References: <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mlock() facility does not exist for NOMMU since all mappings are
effectively locked anyway, so we don't make the bits available when they're
not useful.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/page-flags.h |   20 +++++++++++++-------
 mm/Kconfig                 |    8 ++++++++
 mm/internal.h              |    8 +++++---
 3 files changed, 26 insertions(+), 10 deletions(-)


diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 219a523..61df177 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -96,6 +96,8 @@ enum pageflags {
 	PG_swapbacked,		/* Page is backed by RAM/swap */
 #ifdef CONFIG_UNEVICTABLE_LRU
 	PG_unevictable,		/* Page is "unevictable"  */
+#endif
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 	PG_mlocked,		/* Page is vma mlocked */
 #endif
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
@@ -234,20 +236,20 @@ PAGEFLAG_FALSE(SwapCache)
 #ifdef CONFIG_UNEVICTABLE_LRU
 PAGEFLAG(Unevictable, unevictable) __CLEARPAGEFLAG(Unevictable, unevictable)
 	TESTCLEARFLAG(Unevictable, unevictable)
+#else
+PAGEFLAG_FALSE(Unevictable) TESTCLEARFLAG_FALSE(Unevictable)
+	SETPAGEFLAG_NOOP(Unevictable) CLEARPAGEFLAG_NOOP(Unevictable)
+	__CLEARPAGEFLAG_NOOP(Unevictable)
+#endif
 
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 #define MLOCK_PAGES 1
 PAGEFLAG(Mlocked, mlocked) __CLEARPAGEFLAG(Mlocked, mlocked)
 	TESTSCFLAG(Mlocked, mlocked)
-
 #else
-
 #define MLOCK_PAGES 0
 PAGEFLAG_FALSE(Mlocked)
 	SETPAGEFLAG_NOOP(Mlocked) TESTCLEARFLAG_FALSE(Mlocked)
-
-PAGEFLAG_FALSE(Unevictable) TESTCLEARFLAG_FALSE(Unevictable)
-	SETPAGEFLAG_NOOP(Unevictable) CLEARPAGEFLAG_NOOP(Unevictable)
-	__CLEARPAGEFLAG_NOOP(Unevictable)
 #endif
 
 #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
@@ -367,9 +369,13 @@ static inline void __ClearPageTail(struct page *page)
 
 #ifdef CONFIG_UNEVICTABLE_LRU
 #define __PG_UNEVICTABLE	(1 << PG_unevictable)
-#define __PG_MLOCKED		(1 << PG_mlocked)
 #else
 #define __PG_UNEVICTABLE	0
+#endif
+
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
+#define __PG_MLOCKED		(1 << PG_mlocked)
+#else
 #define __PG_MLOCKED		0
 #endif
 
diff --git a/mm/Kconfig b/mm/Kconfig
index a5b7781..8c89597 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -214,5 +214,13 @@ config UNEVICTABLE_LRU
 	  will use one page flag and increase the code size a little,
 	  say Y unless you know what you are doing.
 
+config HAVE_MLOCK
+	bool
+	default y if MMU=y
+
+config HAVE_MLOCKED_PAGE_BIT
+	bool
+	default y if HAVE_MLOCK=y && UNEVICTABLE_LRU=y
+
 config MMU_NOTIFIER
 	bool
diff --git a/mm/internal.h b/mm/internal.h
index 478223b..987bb03 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -63,6 +63,7 @@ static inline unsigned long page_order(struct page *page)
 	return page_private(page);
 }
 
+#ifdef CONFIG_HAVE_MLOCK
 extern long mlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
@@ -71,6 +72,7 @@ static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
 {
 	munlock_vma_pages_range(vma, vma->vm_start, vma->vm_end);
 }
+#endif
 
 #ifdef CONFIG_UNEVICTABLE_LRU
 /*
@@ -90,7 +92,7 @@ static inline void unevictable_migrate_page(struct page *new, struct page *old)
 }
 #endif
 
-#ifdef CONFIG_UNEVICTABLE_LRU
+#ifdef CONFIG_HAVE_MLOCKED_PAGE_BIT
 /*
  * Called only in fault path via page_evictable() for a new page
  * to determine if it's being mapped into a LOCKED vma.
@@ -165,7 +167,7 @@ static inline void free_page_mlock(struct page *page)
 	}
 }
 
-#else /* CONFIG_UNEVICTABLE_LRU */
+#else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
 {
 	return 0;
@@ -175,7 +177,7 @@ static inline void mlock_vma_page(struct page *page) { }
 static inline void mlock_migrate_page(struct page *new, struct page *old) { }
 static inline void free_page_mlock(struct page *page) { }
 
-#endif /* CONFIG_UNEVICTABLE_LRU */
+#endif /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
 
 /*
  * Return the mem_map entry representing the 'offset' subpage within

