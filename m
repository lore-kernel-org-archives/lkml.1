Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZJVOWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZJVOWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZJVOWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:22:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50068 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbZJVOWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:22:38 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 1/5] page allocator: Always wake kswapd when restarting an allocation attempt after direct reclaim failed
Date: Thu, 22 Oct 2009 15:22:32 +0100
Message-Id: <1256221356-26049-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bf72055..dfa4362 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1817,9 +1817,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
 		goto nopage;
 
+restart:
 	wake_all_kswapd(order, zonelist, high_zoneidx);
 
-restart:
 	/*
 	 * OK, we're below the kswapd watermark and have kicked background
 	 * reclaim. Now things get more complex, so set up alloc_flags according
-- 
1.6.3.3

