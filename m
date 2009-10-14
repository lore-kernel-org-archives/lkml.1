Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbZJNX5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbZJNX5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762183AbZJNX5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:57:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34710 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762175AbZJNX5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:57:09 -0400
Date: Thu, 15 Oct 2009 00:56:36 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>
Cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091014235636.GF5027@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910141510.11059.elendil@planet.nl> <20091014154026.GC5027@csn.ul.ie> <200910142034.58826.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200910142034.58826.elendil@planet.nl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 08:34:56PM +0200, Frans Pop wrote:
> Some initial results; all negative I'm afraid.
> 

These are highly unlikely candidates. I say highly unlikely because they
are before the page allocator patches when your analysis indicated
things were ok.

Commit 70ac23c readahead: sequential mmap readahead
	This affects readahead for mmap() and could have an impact on the
	number of allocations made by the streaming IO. This might be
	generating more bursty network traffic in 2.6.31 than 2.6.30 and
	affecting the allocation apttern enough to cause problems

Commit 2fad6f5 readahead: enforce full readahead size on async mmap readahead
	Another readahead change that may affect the rate of network
	traffic being generated when streaming IO over the network

Commit 10be0b3 readahead: introduce context readahead algorithm
	By using readahead in more situations, it again may be affecting
	the burst rate of network traffic and the rate of GFP_ATOMIC arrivals

Commit 78dc583 vmscan: low order lumpy reclaim also should use PAGEOUT_IO_SYNC
	Very low probability that this is a problem, but it affects
	lumpy reclaim and so has to be considered. It's an awkward
	revert but I think the most important part is just to revert the
	condition that checks if congestion_wait() should be called or not

I relooked at the page allocator patches themselves just in case. Of the
patches in there, I came up with

Commit 11e33f6 page allocator: break up the allocator entry point into fast and slow paths
	This is possibly the most disruptive patch in the set. It should
	not have affected behaviour but the complexity of the patch is
	quite high. I did spot an oddity whereby a process exiting making
	a __GFP_NOFAIL allocation can ignore watermarks. It's unlikely
	this is the problem but as the journal layer uses __GFP_NOFAIL,
	you never know - it might be pushing things down low enough for
	other watermark checks to fail. Patch is below. This is also the
	patch that cause kswapd to wake up less. I sent a patch for that
	problem but I still don't know if it reduced the number of
	failures for you or not.

Commit f2260e6 page allocator: update NR_FREE_PAGES only as necessary
	This patch affects the timing of when NR_FREE_PAGES is updated.
	The reclaim algorithm makes decisions based on this NR_FREE_PAGES
	value.	Crucially, the value can determine if the anon list is force
	scanned or not. The window during which this can make a difference
	should be extremely small but maybe it's enough to make a difference.

Outside the range of commits suspected of causing problems was the
following. It's extremely low probability

Commit 8aa7e84 Fix congestion_wait() sync/async vs read/write confusion
	This patch alters the call to congestion_wait() in the page
	allocator. Frankly, I don't get the change but it might worth
	checking if replacing BLK_RW_ASYNC with WRITE on top of 2.6.31
	makes any difference

After a lot more eyeballing, the best next candidate within mm is the
following patch. Should be tested on it's own and in combination with
the wakeup-kswapd patch sent before.

====

>From 4e8b5217f51a00caee527e4e8d8e46fe9f82b482 Mon Sep 17 00:00:00 2001
From: Mel Gorman <mel@csn.ul.ie>
Date: Thu, 15 Oct 2009 00:17:05 +0100
Subject: [PATCH] page allocator: Direct reclaim should always obey watermarks

ALLOC_NO_WATERMARKS should be cleared when trying to allocate from the
free-lists after a direct reclaim.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3694609..619933d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1920,7 +1920,8 @@ rebalance:
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask,
-					alloc_flags, preferred_zone,
+					alloc_flags & ~ALLOC_NO_WATERMARKS,
+					preferred_zone,
 					migratetype, &did_some_progress);
 	if (page)
 		goto got_pg;
