Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbXH1TNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbXH1TNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761196AbXH1TIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:08:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58367 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756814AbXH1THh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:07:37 -0400
Message-Id: <20070828190733.644383542@sgi.com>
References: <20070828190551.415127746@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 12:06:15 -0700
From: clameter@sgi.com
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: joern@lazybastard.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [24/36] compound pages: Use new compound vmstat functions in SLUB
Content-Disposition: inline; filename=0024-compound-pages-Use-new-compound-vmstat-functions-in.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new dec/inc functions to simplify SLUB's accounting
of pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-08-27 19:22:13.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-08-27 21:02:51.000000000 -0700
@@ -1038,7 +1038,6 @@ static inline void kmem_cache_open_debug
 static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct page * page;
-	int pages = 1 << s->order;
 
 	if (s->order)
 		flags |= __GFP_COMP;
@@ -1054,10 +1053,9 @@ static struct page *allocate_slab(struct
 	if (!page)
 		return NULL;
 
-	mod_zone_page_state(page_zone(page),
+	inc_zone_page_state(page,
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		pages);
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE);
 
 	return page;
 }
@@ -1124,8 +1122,6 @@ out:
 
 static void __free_slab(struct kmem_cache *s, struct page *page)
 {
-	int pages = 1 << s->order;
-
 	if (unlikely(SlabDebug(page))) {
 		void *p;
 
@@ -1135,10 +1131,9 @@ static void __free_slab(struct kmem_cach
 		ClearSlabDebug(page);
 	}
 
-	mod_zone_page_state(page_zone(page),
+	dec_zone_page_state(page,
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		- pages);
+		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE);
 
 	page->mapping = NULL;
 	__free_pages(page, s->order);

-- 
