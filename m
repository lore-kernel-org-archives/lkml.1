Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbXKGBM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbXKGBM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbXKGBM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:12:29 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33722 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755110AbXKGBM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:12:27 -0500
Message-Id: <20071107011226.617922306@sgi.com>
References: <20071107011130.382244340@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 17:11:31 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundatin.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 01/23] SLUB: Move count_partial()
Content-Disposition: inline; filename=0002-slab_defrag_move_count_partial.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the counting function for objects in partial slabs so that it is placed
before kmem_cache_shrink. We will need to use it to establish the
fragmentation ratio of per node slab lists.

[This patch is already in mm]

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-06 12:34:13.000000000 -0800
+++ linux-2.6/mm/slub.c	2007-11-06 12:35:37.000000000 -0800
@@ -2758,6 +2758,19 @@ void kfree(const void *x)
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
@@ -3615,19 +3628,6 @@ static int list_locations(struct kmem_ca
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
