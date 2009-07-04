Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbZGDCMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbZGDCMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbZGDCML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:12:11 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:46599 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115AbZGDCMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:12:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=l8UjmnyGbhsrXxgju5+gv+bttN/Tjb08B6QvLoxC4WR6vmsrGckCuIweDh6whakxmQ
         2JEdZumOAO9R0W47ddRI/pLJsbmLf44WLA48TO0ggEQsXM4bM7pz07OqODM1DsnPXqwl
         3/Wz75O9Nt0kofx2XcvHscGb7oU1KBmthI6yk=
Date: Sat, 4 Jul 2009 11:09:50 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] mm: add gfp mask checking for __get_free_pages()
Message-ID: <20090704020949.GA3047@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_free_pages() with __GFP_HIGHMEM is not safe because the return
address cannot represent a highmem page. get_zeroed_page() already has
such a debug checking.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/page_alloc.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e0f2cdf..4a1a374 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1903,31 +1903,25 @@ EXPORT_SYMBOL(__alloc_pages_nodemask);
  */
 unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
 {
-	struct page * page;
+	struct page *page;
+
+	/*
+	 * __get_free_pages() returns a 32-bit address, which cannot represent
+	 * a highmem page
+	 */
+	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
+
 	page = alloc_pages(gfp_mask, order);
 	if (!page)
 		return 0;
 	return (unsigned long) page_address(page);
 }
-
 EXPORT_SYMBOL(__get_free_pages);
 
 unsigned long get_zeroed_page(gfp_t gfp_mask)
 {
-	struct page * page;
-
-	/*
-	 * get_zeroed_page() returns a 32-bit address, which cannot represent
-	 * a highmem page
-	 */
-	VM_BUG_ON((gfp_mask & __GFP_HIGHMEM) != 0);
-
-	page = alloc_pages(gfp_mask | __GFP_ZERO, 0);
-	if (page)
-		return (unsigned long) page_address(page);
-	return 0;
+	return __get_free_pages(gfp_mask | __GFP_ZERO, 0);
 }
-
 EXPORT_SYMBOL(get_zeroed_page);
 
 void __pagevec_free(struct pagevec *pvec)
-- 
1.6.0.6

