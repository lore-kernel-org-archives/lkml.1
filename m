Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXHFKpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXHFKpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932275AbXHFKof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:44:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbXHFKod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:44:33 -0400
Message-Id: <20070806103658.869977000@chello.nl>
References: <20070806102922.907530000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 06 Aug 2007 12:29:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: [PATCH 05/10] mm: allow mempool to fall back to memalloc reserves
Content-Disposition: inline; filename=mm-mempool_fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the mempool to use the memalloc reserves when all else fails and
the allocation context would otherwise allow it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/mempool.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6-2/mm/mempool.c
===================================================================
--- linux-2.6-2.orig/mm/mempool.c
+++ linux-2.6-2/mm/mempool.c
@@ -14,6 +14,7 @@
 #include <linux/mempool.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include "internal.h"
 
 static void add_element(mempool_t *pool, void *element)
 {
@@ -204,7 +205,7 @@ void * mempool_alloc(mempool_t *pool, gf
 	void *element;
 	unsigned long flags;
 	wait_queue_t wait;
-	gfp_t gfp_temp;
+	gfp_t gfp_temp, gfp_orig = gfp_mask;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
@@ -228,6 +229,15 @@ repeat_alloc:
 	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
+	/* if we really had right to the emergency reserves try those */
+	if (gfp_to_alloc_flags(gfp_orig) & ALLOC_NO_WATERMARKS) {
+		if (gfp_temp & __GFP_NOMEMALLOC) {
+			gfp_temp &= ~(__GFP_NOMEMALLOC|__GFP_NOWARN);
+			goto repeat_alloc;
+		} else
+			gfp_temp |= __GFP_NOMEMALLOC|__GFP_NOWARN;
+	}
+
 	/* We must not sleep in the GFP_ATOMIC case */
 	if (!(gfp_mask & __GFP_WAIT))
 		return NULL;

--

