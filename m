Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbZCBJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbZCBJdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbZCBJdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:33:09 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:28833 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918AbZCBJdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=OQomYc1BumGEvJYzcO7YVQAFaHsYjr6F/Eu3nKyXU7Gqc6TC8NL61CLpGLlGHtQU3L
         h+Wv1pzZ+yQHQqQFFtmlx3q73CoJl3PtWNwQzrQAcvv63dmVITpcfPocP5piarB7yCbX
         7HJyLQCRpXnaILk71o5eCPTsgYGozPRpZ1Qqw=
Date: Mon, 2 Mar 2009 18:31:48 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mmtom :  add VM_BUG_ON in __get_free_pages
Message-Id: <20090302183148.a4dfcc22.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The __get_free_pages is used in many place. 
Also, driver developers can use it freely due to export function.
Some developers might use it to allocate high pages by mistake. 

The __get_free_pages can allocate high page using alloc_pages, 
but it can't return linear address for high page.

Even worse, in this csse, caller can't free page which are there in high zone. 
So, It would be better to add VM_BUG_ON. 

It's based on mmtom 2009-02-27-13-54.
 
Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
---
 mm/page_alloc.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8294107..381056b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1681,6 +1681,13 @@ EXPORT_SYMBOL(__alloc_pages_internal);
 unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order)
 {
 	struct page * page;
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
-- 
1.5.4.3


-- 
Kinds Regards
MinChan Kim
