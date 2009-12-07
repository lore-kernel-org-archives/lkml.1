Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbZLGANJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbZLGANJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758452AbZLGANF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:05 -0500
Received: from kroah.org ([198.145.64.141]:34337 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403AbZLGAM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:57 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:46 2009
Message-Id: <20091207000646.474598476@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mel Gorman <mel@csn.ul.ie>
Subject: [038/119] page allocator: always wake kswapd when restarting an allocation attempt after direct reclaim failed
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mel Gorman <mel@csn.ul.ie>

commit cc4a6851466039a8a688c843962a05689059ff3b upstream.

If a direct reclaim makes no forward progress, it considers whether it
should go OOM or not.  Whether OOM is triggered or not, it may retry the
allocation afterwards.  In times past, this would always wake kswapd as
well but currently, kswapd is not woken up after direct reclaim fails.
For order-0 allocations, this makes little difference but if there is a
heavy mix of higher-order allocations that direct reclaim is failing for,
it might mean that kswapd is not rewoken for higher orders as much as it
did previously.

This patch wakes up kswapd when an allocation is being retried after a
direct reclaim failure.  It would be expected that kswapd is already
awake, but this has the effect of telling kswapd to reclaim at the higher
order as well.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1763,6 +1763,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
+restart:
 	wake_all_kswapd(order, zonelist, high_zoneidx);
 
 	/*
@@ -1772,7 +1773,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	 */
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
-restart:
 	/* This is the last chance, in general, before the goto nopage. */
 	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
 			high_zoneidx, alloc_flags & ~ALLOC_NO_WATERMARKS,


