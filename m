Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbXIABmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbXIABmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbXIABmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:42:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51583 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083AbXIABmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:42:21 -0400
Message-Id: <20070901014219.759177433@sgi.com>
References: <20070901014107.719506437@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 31 Aug 2007 18:41:09 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: David Chinner <dgc@sgi.com>
Subject: [RFC 02/26] SLUB: Move count_partial()
Content-Disposition: inline; filename=0002-slab_defrag_move_count_partial.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the counting function for objects in partial slabs so that it is placed
before kmem_cache_shrink. We will need to use it to establish the
fragmentation ratio of per node slab lists.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 45c76fe..aad6f83 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2595,6 +2595,19 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+static unsigned long count_partial(struct kmem_cache_node *n)
+{
+	unsigned long flags;
+	unsigned long x = 0;
+	struct page *page;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+	list_for_each_entry(page, &n->partial, lru)
+		x += page->inuse;
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return x;
+}
+
 /*
  * kmem_cache_shrink removes empty slabs from the partial lists and sorts
  * the remaining slabs by the number of items in use. The slabs with the
@@ -3331,19 +3344,6 @@ static int list_locations(struct kmem_cache *s, char *buf,
 	return n;
 }
 
-static unsigned long count_partial(struct kmem_cache_node *n)
-{
-	unsigned long flags;
-	unsigned long x = 0;
-	struct page *page;
-
-	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, lru)
-		x += page->inuse;
-	spin_unlock_irqrestore(&n->list_lock, flags);
-	return x;
-}
-
 enum slab_stat_type {
 	SL_FULL,
 	SL_PARTIAL,
-- 
1.5.2.4

-- 
