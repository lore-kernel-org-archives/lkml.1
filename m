Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZLBD2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZLBD2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZLBD2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:28:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39047 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZLBD2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:28:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH] Replace page_mapping_inuse() with page_mapped()
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <4B15D9F8.9090800@redhat.com>
References: <20091202115358.5C4F.A69D9226@jp.fujitsu.com> <4B15D9F8.9090800@redhat.com>
Message-Id: <20091202121152.5C52.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Dec 2009 12:28:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/01/2009 09:55 PM, KOSAKI Motohiro wrote:
> >> btw, current shrink_active_list() have unnecessary page_mapping_inuse() call.
> >> it prevent to drop page reference bit from unmapped cache page. it mean
> >> we protect unmapped cache page than mapped page. it is strange.
> >>      
> > How about this?
> >
> > ---------------------------------
> > SplitLRU VM replacement algorithm assume shrink_active_list() clear
> > the page's reference bit. but unnecessary page_mapping_inuse() test
> > prevent it.
> >
> > This patch remove it.
> >    
> Shrink_page_list ignores the referenced bit on pages
> that are !page_mapping_inuse().
> 
>                  if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
>                                          referenced && 
> page_mapping_inuse(page)
> && !(vm_flags & VM_LOCKED))
>                          goto activate_locked;
> 
> The reason we leave the referenced bit on unmapped
> pages is that we want the next reference to a deactivated
> page cache page to move that page back to the active
> list.  We do not want to require that such a page gets
> accessed twice before being reactivated while on the
> inactive list, because (1) we know it was a frequently
> accessed page already and (2) ongoing streaming IO
> might evict it from the inactive list before it gets accessed
> twice.
> 
> Arguably, we should just replace the page_mapping_inuse()
> in both places with page_mapped() to simplify things.

Ah, yes. /me was slept. thanks correct me.


>From 61340720e6e66b645db8d5410e89fd3b67eda907 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 2 Dec 2009 12:05:26 +0900
Subject: [PATCH] Replace page_mapping_inuse() with page_mapped()

page reclaim logic need to distingish mapped and unmapped pages.
However page_mapping_inuse() don't provide proper test way. it test
the address space (i.e. file) is mmpad(). Why `page' reclaim need
care unrelated page's mapped state? it's unrelated.

Thus, This patch replace page_mapping_inuse() with page_mapped()

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   25 ++-----------------------
 1 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 00156f2..350b9cc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -277,27 +277,6 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
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
@@ -663,7 +642,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * try_to_unmap moves it to unevictable list
 		 */
 		if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
-					referenced && page_mapping_inuse(page)
+					referenced && page_mapped(page)
 					&& !(vm_flags & VM_LOCKED))
 			goto activate_locked;
 
@@ -1347,7 +1326,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 		}
 
 		/* page_referenced clears PageReferenced */
-		if (page_mapping_inuse(page) &&
+		if (page_mapped(page) &&
 		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
 			nr_rotated++;
 			/*
-- 
1.6.5.2





