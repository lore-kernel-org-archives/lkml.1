Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbZCTKES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbZCTKES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbZCTKCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:02:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55060 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZCTKCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:02:37 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/25] Check only once if the zonelist is suitable for the allocation
Date: Fri, 20 Mar 2009 10:02:51 +0000
Message-Id: <1237543392-11797-5-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
References: <1237543392-11797-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible with __GFP_THISNODE that no zones are suitable. This
patch makes sure the check is only made once.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 mm/page_alloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd87dad..8024abc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1486,9 +1486,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
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
@@ -1497,6 +1496,7 @@ restart:
 		return NULL;
 	}
 
+restart:
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET);
 	if (page)
-- 
1.5.6.5

