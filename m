Return-Path: <linux-kernel-owner+w=401wt.eu-S1758672AbZDTWY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbZDTWY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757723AbZDTWU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:20:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37290 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757661AbZDTWUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:20:22 -0400
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
Subject: [PATCH 12/25] Remove a branch by assuming __GFP_HIGH == ALLOC_HIGH
Date: Mon, 20 Apr 2009 23:19:58 +0100
Message-Id: <1240266011-11140-13-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocations that specify __GFP_HIGH get the ALLOC_HIGH flag. If these
flags are equal to each other, we can eliminate a branch.

[akpm@linux-foundation.org: Suggested the hack]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 51e1ded..b13fc29 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1639,8 +1639,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	 * policy or is asking for __GFP_HIGH memory.  GFP_ATOMIC requests will
 	 * set both ALLOC_HARDER (!wait) and ALLOC_HIGH (__GFP_HIGH).
 	 */
-	if (gfp_mask & __GFP_HIGH)
-		alloc_flags |= ALLOC_HIGH;
+	VM_BUG_ON(__GFP_HIGH != ALLOC_HIGH);
+	alloc_flags |= (gfp_mask & __GFP_HIGH);
 
 	if (!wait) {
 		alloc_flags |= ALLOC_HARDER;
-- 
1.5.6.5

