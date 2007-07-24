Return-Path: <linux-kernel-owner+w=401wt.eu-S1759240AbXGXPfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240AbXGXPfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXGXPfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:35:36 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:59980 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXGXPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:35:35 -0400
Date: Tue, 24 Jul 2007 16:35:31 +0100
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] Do not trigger OOM-killer for high-order allocation failures
Message-ID: <20070724153531.GA30585@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

out_of_memory() may be called when an allocation is failing and the direct
reclaim is not making any progress. This does not take into account the
requested order of the allocation. If the request if for an order larger
than PAGE_ALLOC_COSTLY_ORDER, it is reasonable to fail the allocation
because the kernel makes no guarantees about those allocations succeeding.

This false OOM situation can occur if a user is trying to grow the hugepage
pool in a script like;

#!/bin/bash
REQUIRED=$1
echo 1 > /proc/sys/vm/hugepages_treat_as_movable
echo $REQUIRED > /proc/sys/vm/nr_hugepages
ACTUAL=`cat /proc/sys/vm/nr_hugepages`
while [ $REQUIRED -ne $ACTUAL ]; do
	echo Huge page pool at $ACTUAL growing to $REQUIRED
	echo $REQUIRED > /proc/sys/vm/nr_hugepages
	ACTUAL=`cat /proc/sys/vm/nr_hugepages`
	sleep 1
done

This is a reasonable scenario when ZONE_MOVABLE is in use but triggers OOM
easily on 2.6.23-rc1. This patch will fail an allocation for an order above
PAGE_ALLOC_COSTLY_ORDER instead of killing processes and retrying.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>

---
 page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 40954fb..da57173 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1350,6 +1350,10 @@ nofail_alloc:
 		if (page)
 			goto got_pg;
 
+		/* The OOM killer will not help higher order allocs so fail */
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			goto nopage;
+
 		out_of_memory(zonelist, gfp_mask, order);
 		goto restart;
 	}
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
