Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZFVPoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZFVPoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbZFVPnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:43:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35171 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbZFVPng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:43:36 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Heinz Diehl <htd@fancy-poultry.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 1/3] page-allocator: Allow too high-order warning messages to be suppressed with __GFP_NOWARN
Date: Mon, 22 Jun 2009 16:43:32 +0100
Message-Id: <1245685414-8979-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245685414-8979-1-git-send-email-mel@csn.ul.ie>
References: <1245685414-8979-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The page allocator warns once when an order >= MAX_ORDER is specified.
This is to catch callers of the allocator that are always falling back
to their worst-case when it was not expected. However, there are cases
where the caller is behaving correctly but cannot suppress the warning.
This patch allows the warning to be suppressed by the callers by
specifying __GFP_NOWARN.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a5f3c27..005b32d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1740,8 +1740,10 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	 * be using allocators in order of preference for an area that is
 	 * too large.
 	 */
-	if (WARN_ON_ONCE(order >= MAX_ORDER))
+	if (order >= MAX_ORDER) {
+		WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
 		return NULL;
+	}
 
 	/*
 	 * GFP_THISNODE (meaning __GFP_THISNODE, __GFP_NORETRY and
-- 
1.5.6.5

