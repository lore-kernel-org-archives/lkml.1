Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0BVTtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:49:45 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:50061 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab0BVTtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:49:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 2/3] vmscan: drop page_mapping_inuse()
Date: Mon, 22 Feb 2010 20:49:09 +0100
Message-Id: <1266868150-25984-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org>
References: <1266868150-25984-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_mapping_inuse() is a historic predicate function for pages that
are about to be reclaimed or deactivated.

According to it, a page is in use when it is mapped into page tables
OR part of swap cache OR backing an mmapped file.

This function is used in combination with page_referenced(), which
checks for young bits in ptes and the page descriptor itself for the
PG_referenced bit.  Thus, checking for unmapped swap cache pages is
meaningless as PG_referenced is not set for anonymous pages and
unmapped pages do not have young ptes.  The test makes no difference.

Protecting file pages that are not by themselves mapped but are part
of a mapped file is also a historic leftover for short-lived things
like the exec() code in libc.  However, the VM now does reference
accounting and activation of pages at unmap time and thus the special
treatment on reclaim is obsolete.

This patch drops page_mapping_inuse() and switches the two callsites
to use page_mapped() directly.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c |   25 ++-----------------------
 1 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c2db55b..a8e4cbe 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -262,27 +262,6 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 	return ret;
 }
 
-/* Called without lock on whether page is mapped, so answer is unstable */
-static inline int page_mapping_inuse(struct page *page)
-{
-	struct address_space *mapping;
-
-	/* Page is in somebody's page tables. */
-	if (page_mapped(page))
-		return 1;
-
-	/* Be more reluctant to reclaim swapcache than pagecache */
-	if (PageSwapCache(page))
-		return 1;
-
-	mapping = page_mapping(page);
-	if (!mapping)
-		return 0;
-
-	/* File is mmap'd by somebody? */
-	return mapping_mapped(mapping);
-}
-
 static inline int is_page_cache_freeable(struct page *page)
 {
 	/*
@@ -603,7 +582,7 @@ static enum page_references page_check_references(struct page *page,
 	if (vm_flags & VM_LOCKED)
 		return PAGEREF_RECLAIM;
 
-	if (page_mapping_inuse(page))
+	if (page_mapped(page))
 		return PAGEREF_ACTIVATE;
 
 	/* Reclaim if clean, defer dirty pages to writeback */
@@ -1378,7 +1357,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 		}
 
 		/* page_referenced clears PageReferenced */
-		if (page_mapping_inuse(page) &&
+		if (page_mapped(page) &&
 		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			nr_rotated++;
 			/*
-- 
1.6.6.1

