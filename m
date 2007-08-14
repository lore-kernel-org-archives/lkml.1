Return-Path: <linux-kernel-owner+w=401wt.eu-S1763369AbXHNPhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763369AbXHNPhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 11:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761925AbXHNPfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 11:35:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52195 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758637AbXHNPfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 11:35:05 -0400
Message-Id: <20070814153501.305923060@sgi.com>
References: <20070814153021.446917377@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Aug 2007 08:30:23 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 2/9] Use NOMEMALLOC reclaim to allow reclaim if PF_MEMALLOC is set
Content-Disposition: inline; filename=reclaim_nomemalloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we exhaust the reserves in the page allocator when PF_MEMALLOC is set
then no longer give up but call into reclaim with PF_MEMALLOC set.

This is in essence a recursive call back into page reclaim with another
page flag (__GFP_NOMEMALLOC) set. The recursion is bounded since potential
allocations with __PF_NOMEMALLOC set will not enter that branch again.

This means that allocation under PF_MEMALLOC will no longer run out of
memory. Allocations under PF_MEMALLOC will do a limited form of reclaim
instead.

The reclaim is of particular important to stacked filesystems that may
do a lot of allocations in the write path. Reclaim will be working
as long as there are clean file backed pages to reclaim.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/page_alloc.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c	2007-08-13 23:50:01.000000000 -0700
+++ linux-2.6/mm/page_alloc.c	2007-08-13 23:58:43.000000000 -0700
@@ -1306,6 +1306,17 @@ nofail_alloc:
 				zonelist, ALLOC_NO_WATERMARKS);
 			if (page)
 				goto got_pg;
+			/*
+			 * If we are already in reclaim then the environment
+			 * is already setup. We can simply call
+			 * try_to_get_free_pages(). Just make sure that
+			 * we do not allocate anything.
+			 */
+			if (p->flags & PF_MEMALLOC && wait &&
+				try_to_free_pages(zonelist->zones, order,
+						gfp_mask | __GFP_NOMEMALLOC))
+				goto restart;
+
 			if (gfp_mask & __GFP_NOFAIL) {
 				congestion_wait(WRITE, HZ/50);
 				goto nofail_alloc;

-- 
