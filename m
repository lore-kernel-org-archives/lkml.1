Return-Path: <linux-kernel-owner+w=401wt.eu-S966480AbXLTPmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966480AbXLTPmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964806AbXLTPWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:22:44 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:35049 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933355AbXLTPVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:21:09 -0500
Message-Id: <20071220152107.106861374@de.ibm.com>
References: <20071220151925.405881218@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 16:19:44 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 19/47] Optimize reference bit handling.
Content-Disposition: inline; filename=118-mm-referenced.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

page_referenced always tests and clears the reference bit in the
storage key, even if the page is not mapped. For a page that is
only accessed with sys_read this has a negative side effect.
A page that is only read once makes two trips over the inactive
list before it is removed from the page cache. When the page is
added to the page cache it is added to the start of the inactive
list. After it went through the inactive list the reference bit
is checked with a call to page_referenced which will find the
referenced bit in the storage key set because the copy_to_user
operation will set the bit. This causes the page to be added to
the start of the inactive list again. This wastes cpu cycles in
vmscan.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 mm/rmap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: quilt-2.6/mm/rmap.c
===================================================================
--- quilt-2.6.orig/mm/rmap.c
+++ quilt-2.6/mm/rmap.c
@@ -391,9 +391,6 @@ int page_referenced(struct page *page, i
 {
 	int referenced = 0;
 
-	if (page_test_and_clear_young(page))
-		referenced++;
-
 	if (TestClearPageReferenced(page))
 		referenced++;
 
@@ -409,6 +406,8 @@ int page_referenced(struct page *page, i
 				referenced += page_referenced_file(page);
 			unlock_page(page);
 		}
+		if (page_test_and_clear_young(page))
+			referenced++;
 	}
 	return referenced;
 }
@@ -640,6 +639,8 @@ void page_remove_rmap(struct page *page,
 		 * Leaving it set also helps swapoff to reinstate ptes
 		 * faster for those pages still in swapcache.
 		 */
+		if (page_test_and_clear_young(page))
+			SetPageReferenced(page);
 		if (page_test_dirty(page)) {
 			page_clear_dirty(page);
 			set_page_dirty(page);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

