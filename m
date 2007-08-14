Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbXHNPf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbXHNPf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760636AbXHNPfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:35:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40794 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755694AbXHNPfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:35:05 -0400
Message-Id: <20070814153502.753854133@sgi.com>
References: <20070814153021.446917377@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Aug 2007 08:30:29 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 8/9] Reclaim on an atomic allocation if necessary
Content-Disposition: inline; filename=reclaim_on_atomic_alloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simply call reclaim if we get to a point where we cannot perform
the desired atomic allocation. If the reclaim is successful then
restart the allocation.

This will allow atomic allocs to not run out of memory. We reclaim clean
pages instead. If we are in an interrupt then the interrupt holdoff
will be long since reclaim processing is intensive. However, we will
no longer OOM.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-08-14 07:42:09.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-08-14 07:53:34.000000000 -0700
@@ -1326,8 +1326,12 @@ nofail_alloc:
 	}
 
 	/* Atomic allocations - we can't balance anything */
-	if (!wait)
+	if (!wait) {
+		if (try_to_free_pages(zonelist->zones, order, gfp_mask
+							| __GFP_NOMEMALLOC))
+			goto restart;
 		goto nopage;
+	}
 
 	cond_resched();
 

-- 
