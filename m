Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbZGOKtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbZGOKtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZGOKtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:49:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43665 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbZGOKtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:49:46 -0400
Date: Wed, 15 Jul 2009 11:49:45 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] page-allocator: Ensure that processes that have been OOM
	killed exit the page allocator (resend)
Message-ID: <20090715104944.GC9267@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Processes that have been OOM killed set the thread flag TIF_MEMDIE. A process
such as this is expected to exit the page allocator but potentially, it
loops forever. This patch checks TIF_MEMDIE when deciding whether to loop
again in the page allocator. If set, and __GFP_NOFAIL is not specified
then the loop will exit on the assumption it's no longer important for the
process to make forward progress. Note that a process that has just been
OOM-killed will still loop at least one more time retrying the allocation
before the thread flag is checked.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 mm/page_alloc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f8902e7..5c98d02 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1547,6 +1547,14 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
 	if (gfp_mask & __GFP_NORETRY)
 		return 0;
 
+	/* Do not loop if OOM-killed unless __GFP_NOFAIL is specified */
+	if (test_thread_flag(TIF_MEMDIE)) {
+		if (gfp_mask & __GFP_NOFAIL)
+			WARN(1, "Potential infinite loop with __GFP_NOFAIL");
+		else
+			return 0;
+	}
+
 	/*
 	 * In this implementation, order <= PAGE_ALLOC_COSTLY_ORDER
 	 * means __GFP_NOFAIL, but that may not be true in other
