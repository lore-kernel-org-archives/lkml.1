Return-Path: <linux-kernel-owner+w=401wt.eu-S2993258AbXEDKf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993258AbXEDKf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993248AbXEDKf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:35:28 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:3389 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S2993214AbXEDKey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:34:54 -0400
Message-Id: <20070504103156.997011750@chello.nl>
References: <20070504102651.923946304@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 04 May 2007 12:26:58 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
Subject: [PATCH 07/40] mm: allow mempool to fall back to memalloc reserves
Content-Disposition: inline; filename=mm-mempool_fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the mempool to use the memalloc reserves when all else fails and
the allocation context would otherwise allow it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/mempool.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6-git/mm/mempool.c
===================================================================
--- linux-2.6-git.orig/mm/mempool.c	2007-01-12 08:03:44.000000000 +0100
+++ linux-2.6-git/mm/mempool.c	2007-01-12 10:38:57.000000000 +0100
@@ -14,6 +14,7 @@
 #include <linux/mempool.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include "internal.h"
 
 static void add_element(mempool_t *pool, void *element)
 {
@@ -229,6 +230,15 @@ repeat_alloc:
 	}
 	spin_unlock_irqrestore(&pool->lock, flags);
 
+	/* if we really had right to the emergency reserves try those */
+	if (gfp_to_alloc_flags(gfp_mask) & ALLOC_NO_WATERMARKS) {
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

