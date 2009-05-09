Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZEIWqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZEIWqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 18:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZEIWqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 18:46:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27397 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbZEIWqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 18:46:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=YPM+CylZPbNJ/MLapNKUNIgDweUVLHRfR7uHo2LMlC2i6aD1DCV0vgGGuzRFZY/Ny
	2p5LiSIolbst/mxMMYmxA==
Date: Sat, 9 May 2009 15:46:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch -mmotm] mm: invoke oom killer for __GFP_NOFAIL
Message-ID: <alpine.DEB.2.00.0905091544470.6884@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The oom killer must be invoked regardless of the order if the allocation
is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
free some memory.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1547,7 +1547,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 		goto out;
 
 	/* The OOM killer will not help higher order allocs */
-	if (order > PAGE_ALLOC_COSTLY_ORDER)
+	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
 		goto out;
 
 	/* Exhausted what can be done so it's blamo time */
@@ -1763,16 +1763,12 @@ rebalance:
 					migratetype);
 			if (page)
 				goto got_pg;
+			if ((gfp_mask & __GFP_NOFAIL) ||
+					order <= PAGE_ALLOC_COSTLY_ORDER)
+				goto restart;
 
-			/*
-			 * The OOM killer does not trigger for high-order allocations
-			 * but if no progress is being made, there are no other
-			 * options and retrying is unlikely to help
-			 */
-			if (order > PAGE_ALLOC_COSTLY_ORDER)
-				goto nopage;
-
-			goto restart;
+			/* No freeing is possible so just fail */
+			goto nopage;
 		}
 	}
 
