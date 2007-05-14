Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbXENNiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbXENNiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXENNg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:36:58 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:8629 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755479AbXENNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:36:56 -0400
Message-Id: <20070514133213.055112007@chello.nl>
References: <20070514131904.440041502@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 14 May 2007 15:19:09 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 5/5] mm: allow mempool to fall back to memalloc reserves
Content-Disposition: inline; filename=mm-mempool_fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the mempool to use the memalloc reserves when all else fails and
the allocation context would otherwise allow it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/mempool.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6-git/mm/mempool.c
===================================================================
--- linux-2.6-git.orig/mm/mempool.c
+++ linux-2.6-git/mm/mempool.c
@@ -14,6 +14,7 @@
 #include <linux/mempool.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include "internal.h"
 
 static void add_element(mempool_t *pool, void *element)
 {
@@ -205,7 +206,7 @@ void * mempool_alloc(mempool_t *pool, gf
 	void *element;
 	unsigned long flags;
 	wait_queue_t wait;
-	gfp_t gfp_temp;
+	gfp_t gfp_temp, gfp_orig = gfp_mask;
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
 
@@ -229,6 +230,15 @@ repeat_alloc:
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

