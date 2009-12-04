Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZLDIle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZLDIle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbZLDIlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:41:32 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41776 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbZLDIlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:41:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] Replace page_mapping_inuse() with page_mapped()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091204173233.5891.A69D9226@jp.fujitsu.com>
References: <20091204173233.5891.A69D9226@jp.fujitsu.com>
Message-Id: <20091204174016.5894.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  4 Dec 2009 17:41:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c0cd3ee2bb13567a36728600a86f43abac3125b5 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 2 Dec 2009 12:05:26 +0900
Subject: [PATCH 1/7] Replace page_mapping_inuse() with page_mapped()

page reclaim logic need to distingish mapped and unmapped pages.
However page_mapping_inuse() don't provide proper test way. it test
the address space (i.e. file) is mmpad(). Why `page' reclaim need
care unrelated page's mapped state? it's unrelated.

Thus, This patch replace page_mapping_inuse() with page_mapped()

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |   25 ++-----------------------
 1 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index da6cf42..4ba08da 100644
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
@@ -649,7 +628,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * try_to_unmap moves it to unevictable list
 		 */
 		if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
-					referenced && page_mapping_inuse(page)
+					referenced && page_mapped(page)
 					&& !(vm_flags & VM_LOCKED))
 			goto activate_locked;
 
@@ -1356,7 +1335,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 		}
 
 		/* page_referenced clears PageReferenced */
-		if (page_mapping_inuse(page) &&
+		if (page_mapped(page) &&
 		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			nr_rotated++;
 			/*
-- 
1.6.5.2



