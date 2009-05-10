Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbZEJWKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbZEJWKu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 18:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756751AbZEJWHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 18:07:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbZEJWHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 18:07:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UPpW7Xejudcs++AzxnP0SgpbJrKst+bYbNSJx7PUv+fT3lL4Atl1CBAz3WKw+zxyQ
	KJ3RsBwpJ+3WEUcqMUG0g==
Date: Sun, 10 May 2009 15:07:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 11/11 -mmotm] oom: fail allocations if oom killer can't free
 memory
In-Reply-To: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oom killer now reports the potential number of pages that will be
freed when an oom kill task finally exits.  If the oom killer can't make
any progress in freeing memory, however, there is no reason to continue
looping endlessly in the page allocator.  Instead, the allocation is
failed if it is not __GFP_NOFAIL.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1524,7 +1524,7 @@ static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int migratetype)
+	int migratetype, unsigned long *did_some_progress)
 {
 	struct page *page;
 
@@ -1551,7 +1551,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 		goto out;
 
 	/* Exhausted what can be done so it's blamo time */
-	out_of_memory(zonelist, gfp_mask, order);
+	*did_some_progress += out_of_memory(zonelist, gfp_mask, order);
 
 out:
 	clear_zonelist_oom(zonelist, gfp_mask);
@@ -1716,7 +1716,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
-restart:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -1760,21 +1759,27 @@ rebalance:
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
-					migratetype);
+					migratetype, &did_some_progress);
 			if (page)
 				goto got_pg;
 
-			/*
-			 * The OOM killer does not trigger for high-order
-			 * ~__GFP_NOFAIL allocations so if no progress is being
-			 * made, there are no other options and retrying is
-			 * unlikely to help.
-			 */
-			if (order > PAGE_ALLOC_COSTLY_ORDER &&
-						!(gfp_mask & __GFP_NOFAIL))
-				goto nopage;
-
-			goto restart;
+			if (!(gfp_mask & __GFP_NOFAIL)) {
+				/*
+				 * The OOM killer does not trigger for
+				 * high-order allocations so if no progress is
+				 * being made, there are no other options and
+				 * retrying is unlikely to help.
+				 */
+				if (order > PAGE_ALLOC_COSTLY_ORDER)
+					goto nopage;
+
+				/*
+				 * If the oom killer could not free any memory,
+				 * there is no reason to endlessly loop.
+				 */
+				if (!did_some_progress)
+					goto nopage;
+			}
 		}
 	}
 
