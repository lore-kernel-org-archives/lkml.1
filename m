Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbZBJQwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbZBJQwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 11:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZBJQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 11:52:06 -0500
Received: from cmpxchg.org ([85.214.51.133]:39708 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbZBJQwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:52:05 -0500
Date: Tue, 10 Feb 2009 17:51:35 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch] vmscan: initialize sc.order in indirect shrink_list() users
Message-ID: <20090210165134.GA2457@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_all_memory() and __zone_reclaim() currently don't initialize
the .order field of their scan control.

Both of them call into functions which use that field and make certain
decisions based on a random value.

The functions depending on the .order field are marked with a star,
the faulty entry points are marked with a percentage sign:

* shrink_page_list()
  * shrink_inactive_list()
  * shrink_active_list()
    shrink_list()
      shrink_all_zones()
        % shrink_all_memory()
      shrink_zone()
        % __zone_reclaim()

Initialize .order to zero in shrink_all_memory().  Initialize .order
to the order parameter in __zone_reclaim().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4422301..9ce85ea 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2112,6 +2112,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 		.may_unmap = 0,
 		.swap_cluster_max = nr_pages,
 		.may_writepage = 1,
+		.order = 0,
 		.isolate_pages = isolate_pages_global,
 	};
 
@@ -2294,6 +2295,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
+		.order = order,
 		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
-- 
1.6.0.3

