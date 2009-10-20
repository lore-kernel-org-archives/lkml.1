Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZJTUCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZJTUCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZJTUCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:02:02 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44901 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZJTUCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:02:01 -0400
Date: Tue, 20 Oct 2009 21:02:08 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Kernel crash on 2.6.31.x (kcryptd: page allocation failure..)
Message-ID: <20091020200208.GI11778@csn.ul.ie>
References: <hbd4dk$5ac$1@ultimate100.geggus.net> <200910172230.13162.elendil@planet.nl> <hbd9v8$7rf$1@ultimate100.geggus.net> <200910190141.50752.elendil@planet.nl> <20091020191656.GA11718@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091020191656.GA11718@geggus.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 09:16:57PM +0200, Sven Geggus wrote:
> Frans Pop schrieb am Montag, den 19. Oktober um 01:41 Uhr:
> 
> > In the mean time I've been able to trace the culprit. Could you please try 
> > if reverting 373c0a7e + 8aa7e847 [1] on top of 2.6.31 fixes the issue for 
> > you?
> 
> Unfortunately not :(
> 
> Starting from 2.6.31.4 I did
> git revert 373c0a7e
> git revert 8aa7e847 and build a new kernel.
> 
> The problem persists. The Kernel crashed again, this
> time in "swapper".
> 

Can you please try with this patch also applied? i.e. this patch with
the two reverts. I'm looking for either allocation failures or the
WARN_ON triggering.

Thanks

==== CUT HERE ====
page-allocator: Always wake kswapd when restarting an allocation attempt after direct reclaim failed

If a direct reclaim makes no forward progress, it considers whether it
should go OOM or not. Whether OOM is triggered or not, it may retry the
application afterwards. In times past, this would always wake kswapd as well
but currently, kswapd is not woken up after direct reclaim fails. For order-0
allocations, this makes little difference but if there is a heavy mix of
higher-order allocations that direct reclaim is failing for, it might mean
that kswapd is not rewoken for higher orders as much as it did previously.

This patch wakes up kswapd when an allocation is being retried after a direct
reclaim failure. It would be expected that kswapd is already awake, but
this has the effect of telling kswapd to reclaim at the higher order as well.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 mm/page_alloc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0b3c6cb..e07b2f2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1763,16 +1763,17 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
-	wake_all_kswapd(order, zonelist, high_zoneidx);
-
 	/*
-	 * OK, we're below the kswapd watermark and have kicked background
-	 * reclaim. Now things get more complex, so set up alloc_flags according
-	 * to how we want to proceed.
+	 * OK, we're below the kswapd watermark and now things get more
+	 * complex, so set up alloc_flags according to how we want to
+	 * proceed.
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
 restart:
+	/* Kick background reclaim */
+	wake_all_kswapd(order, zonelist, high_zoneidx);
+
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,
@@ -1802,6 +1803,9 @@ rebalance:
 	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
 		goto nopage;
 
+	/* This shouldn't be possible but needs to be eliminated */
+	WARN_ON_ONCE(alloc_flags & ALLOC_NO_WATERMARKS);
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
