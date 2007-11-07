Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXKGWNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXKGWNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbXKGWNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:13:36 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36668 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753082AbXKGWNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:13:35 -0500
Date: Wed, 7 Nov 2007 14:13:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 11/23] SLUB: Slab defrag core
In-Reply-To: <20071107011229.197917117@sgi.com>
Message-ID: <Pine.LNX.4.64.0711071412400.4000@schroedinger.engr.sgi.com>
References: <20071107011130.382244340@sgi.com> <20071107011229.197917117@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This was so far only in the slab defrag git tree.

>From 8cc487b646e45da0644f432d7489ad8791164b5f Mon Sep 17 00:00:00 2001
From: Christoph Lameter <christoph@graphe.net>
Date: Tue, 6 Nov 2007 23:19:40 -0800
Subject: [PATCH] Fix two issues

1. Check inverted in kmem_cache_create

2. partial counter not decremented in __kmem_cache_shrink

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 06fa4ed..de0557d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2789,7 +2789,7 @@ static int kmem_cache_vacate(struct page *page, void *scratch)
 	BUG_ON(!PageSlab(page));
 	local_irq_save(flags);
 	state = slab_lock(page);
-	BUG_ON(state & FROZEN);
+	BUG_ON(!(state & FROZEN));
 
 	s = page->slab;
 	map = scratch + max_defrag_slab_objects * sizeof(void **);
@@ -2902,6 +2902,7 @@ static unsigned long __kmem_cache_shrink(struct kmem_cache *s,
 
 		} else {
 			list_del(&page->lru);
+			n->nr_partial--;
 			slab_unlock(page, state);
 			discard_slab(s, page);
 			freed++;
-- 
1.5.3.4


