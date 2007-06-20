Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbXFTSgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbXFTSgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbXFTSa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:30:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54795 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757737AbXFTSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:30:13 -0400
Message-Id: <20070620183012.040849069@sgi.com>
References: <20070620182907.506775016@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 20 Jun 2007 11:29:33 -0700
From: clameter@sgi.com
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [26/37] compound pages: Use new compound vmstat functions in SLUB
Content-Disposition: inline; filename=compound_vmstat_slub
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new dec/inc functions to simplify SLUB's accounting
of pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

Index: linux-2.6.22-rc4-mm2/mm/slub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/mm/slub.c	2007-06-18 18:42:45.000000000 -0700
+++ linux-2.6.22-rc4-mm2/mm/slub.c	2007-06-18 19:13:26.000000000 -0700
@@ -1052,7 +1052,6 @@ static inline void kmem_cache_open_debug
 static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	struct page * page;
-	int pages = 1 << s->order;
 
 	if (s->order)
 		flags |= __GFP_COMP;
@@ -1071,10 +1070,9 @@ static struct page *allocate_slab(struct
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
@@ -1149,8 +1147,6 @@ static struct page *new_slab(struct kmem
 
 static void __free_slab(struct kmem_cache *s, struct page *page)
 {
-	int pages = 1 << s->order;
-
 	if (unlikely(SlabDebug(page))) {
 		void *p;
 
@@ -1159,10 +1155,9 @@ static void __free_slab(struct kmem_cach
 			check_object(s, page, p, 0);
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
