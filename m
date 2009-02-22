Return-Path: <linux-kernel-owner+w=401wt.eu-S1758503AbZBVXWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbZBVXWl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZBVXQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:16:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39466 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbZBVXQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:16:31 -0500
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
Subject: [PATCH 17/20] Do not double sanity check page attributes during allocation
Date: Sun, 22 Feb 2009 23:17:26 +0000
Message-Id: <1235344649-18265-18-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On every page free, free_pages_check() sanity checks the page details,
including some atomic operations. On page allocation, the same checks
are been made. This is excessively paranoid as it will only catch severe
memory corruption bugs that are going to manifest in a variety of fun
and entertaining ways with or without this check. This patch removes the
overhead of double checking the page state on every allocation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9e16aec..452f708 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -646,14 +646,6 @@ static inline void expand(struct zone *zone, struct page *page,
  */
 static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
 {
-	if (unlikely(page_mapcount(page) |
-		(page->mapping != NULL)  |
-		(page_count(page) != 0)  |
-		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
-		bad_page(page);
-		return 1;
-	}
-
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
-- 
1.5.6.5

