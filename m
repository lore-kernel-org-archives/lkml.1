Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZFBBbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZFBBbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 21:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbZFBBbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 21:31:17 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbZFBBbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 21:31:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Zgrr8p2h6ojnGhqw1DMDqQeDFG46/uxY7W0zGpKQobD68ratQgun//g8mMsTMKGYP
	GVBz1TwWNg3GpLQKtueSg==
Date: Mon, 1 Jun 2009 18:31:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/3 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0906011830490.6936@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906011828040.6936@chino.kir.corp.google.com>
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

Cc: Nick Piggin <npiggin@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/page_alloc.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

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
@@ -1765,11 +1765,13 @@ rebalance:
 				goto got_pg;
 
 			/*
-			 * The OOM killer does not trigger for high-order allocations
-			 * but if no progress is being made, there are no other
-			 * options and retrying is unlikely to help
+			 * The OOM killer does not trigger for high-order
+			 * ~__GFP_NOFAIL allocations so if no progress is being
+			 * made, there are no other options and retrying is
+			 * unlikely to help.
 			 */
-			if (order > PAGE_ALLOC_COSTLY_ORDER)
+			if (order > PAGE_ALLOC_COSTLY_ORDER &&
+						!(gfp_mask & __GFP_NOFAIL))
 				goto nopage;
 
 			goto restart;
