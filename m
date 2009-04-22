Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbZDVN4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbZDVN4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZDVNxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:53:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43823 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbZDVNxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:53:36 -0400
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
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/22] Remove a branch by assuming __GFP_HIGH == ALLOC_HIGH
Date: Wed, 22 Apr 2009 14:53:15 +0100
Message-Id: <1240408407-21848-11-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocations that specify __GFP_HIGH get the ALLOC_HIGH flag. If these
flags are equal to each other, we can eliminate a branch.

[akpm@linux-foundation.org: Suggested the hack]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/page_alloc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0d23795..4f9cdaa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1619,14 +1619,16 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 
+	/* __GFP_HIGH is assumed to be the same as ALLOC_HIGH to save a branch. */
+	BUILD_BUG_ON(__GFP_HIGH != ALLOC_HIGH);
+
 	/*
 	 * The caller may dip into page reserves a bit more if the caller
 	 * cannot run direct reclaim, or if the caller has realtime scheduling
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
 	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
 	 */
-	if (gfp_mask & __GFP_HIGH)
-		alloc_flags |= ALLOC_HIGH;
+	alloc_flags |= (gfp_mask & __GFP_HIGH);
 
 	if (!wait) {
 		alloc_flags |= ALLOC_HARDER;
-- 
1.5.6.5

