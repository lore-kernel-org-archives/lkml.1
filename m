Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbZCPJvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbZCPJvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 05:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZCPJog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 05:44:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49696 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbZCPJob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 05:44:31 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 21/35] Do not check for compound pages during the page allocator sanity checks
Date: Mon, 16 Mar 2009 09:46:16 +0000
Message-Id: <1237196790-7268-22-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237196790-7268-1-git-send-email-mel@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of sanity checks are made on each page allocation and free
including that the page count is zero. page_count() checks for
compound pages and checks the count of the head page if true. However,
in these paths, we do not care if the page is compound or not as the
count of each tail page should also be zero.

This patch makes two changes to the use of page_count() in the free path. It
converts one check of page_count() to a VM_BUG_ON() as the count should
have been unconditionally checked earlier in the free path. It also avoids
checking for compound pages.

[mel@csn.ul.ie: Wrote changelog]
Signed-off-by: Nick Piggin <nickpiggin@yahoo.com.au>
---
 mm/page_alloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d297780..2704092 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -425,7 +425,7 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
 		return 0;
 
 	if (PageBuddy(buddy) && page_order(buddy) == order) {
-		BUG_ON(page_count(buddy) != 0);
+		VM_BUG_ON(page_count(buddy) != 0);
 		return 1;
 	}
 	return 0;
@@ -501,7 +501,7 @@ static inline int free_pages_check(struct page *page)
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
-		(page_count(page) != 0)  |
+		(atomic_read(&page->_count) != 0) |
 		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
 		bad_page(page);
 		return 1;
@@ -646,7 +646,7 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
 {
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
-		(page_count(page) != 0)  |
+		(atomic_read(&page->_count) != 0)  |
 		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
 		bad_page(page);
 		return 1;
-- 
1.5.6.5

