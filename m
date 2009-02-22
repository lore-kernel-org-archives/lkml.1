Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbZBVXSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbZBVXSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbZBVXQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:16:27 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39466 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbZBVXQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:16:23 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: [PATCH 05/20] Check only once if the zonelist is suitable for the allocation
Date: Sun, 22 Feb 2009 23:17:14 +0000
Message-Id: <1235344649-18265-6-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible with __GFP_THISNODE that no zones are suitable. This
patch makes sure the check is only made once.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7cc4932..99fd538 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1487,9 +1487,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	if (should_fail_alloc_page(gfp_mask, order))
 		return NULL;
 
-restart:
-	z = zonelist->_zonerefs;  /* the list of zones suitable for gfp_mask */
-
+	/* the list of zones suitable for gfp_mask */
+	z = zonelist->_zonerefs;
 	if (unlikely(!z->zone)) {
 		/*
 		 * Happens if we have an empty zonelist as a result of
@@ -1498,6 +1497,7 @@ restart:
 		return NULL;
 	}
 
+restart:
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
 	if (page)
-- 
1.5.6.5

