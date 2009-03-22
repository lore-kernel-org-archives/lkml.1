Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbZCVUOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbZCVUOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbZCVUOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:14:16 -0400
Received: from cmpxchg.org ([85.214.51.133]:52656 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbZCVUOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:14:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Howells <dhowells@redhat.com>, Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [patch 1/3] mm: decouple unevictable lru from mmu
Date: Sun, 22 Mar 2009 21:13:02 +0100
Message-Id: <1237752784-1989-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.2.1.135.gde769
In-Reply-To: <20090321102044.GA3427@cmpxchg.org>
References: <20090321102044.GA3427@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mlock is only one source of unevictable pages but with the unevictable
lru enabled, mlock code is referenced unconditionally.

Decouple the two so that the unevictable lru can work without mlock
and thus on nommu setups where we still have unevictable pages from
e.g. ramfs.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.com>
Cc: MinChan Kim <minchan.kim@gmail.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
---
 mm/Kconfig    |    1 -
 mm/internal.h |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index a5b7781..fbb190e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -206,7 +206,6 @@ config VIRT_TO_BUS
 config UNEVICTABLE_LRU
 	bool "Add LRU list to track non-evictable pages"
 	default y
-	depends on MMU
 	help
 	  Keeps unevictable pages off of the active and inactive pageout
 	  lists, so kswapd will not waste CPU time or have its balancing
diff --git a/mm/internal.h b/mm/internal.h
index 478223b..ceaa629 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -90,7 +90,7 @@ static inline void unevictable_migrate_page(struct page *new, struct page *old)
 }
 #endif
 
-#ifdef CONFIG_UNEVICTABLE_LRU
+#if defined(CONFIG_UNEVICTABLE_LRU) && defined(CONFIG_MMU)
 /*
  * Called only in fault path via page_evictable() for a new page
  * to determine if it's being mapped into a LOCKED vma.
@@ -165,7 +165,7 @@ static inline void free_page_mlock(struct page *page)
 	}
 }
 
-#else /* CONFIG_UNEVICTABLE_LRU */
+#else /* CONFIG_UNEVICTABLE_LRU && CONFIG_MMU */
 static inline int is_mlocked_vma(struct vm_area_struct *v, struct page *p)
 {
 	return 0;
-- 
1.6.2.1.135.gde769

