Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbYEDQSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbYEDQSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYEDQSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:18:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56893 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYEDQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:18:33 -0400
Date: Mon, 05 May 2008 01:17:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <lee.schermerhorn@hp.com>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [-mm][PATCH] make inlining to __alloc_pages()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080505011158.8F6E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two zonelist patch series rewriten __page_alloc() largely.
Now, it is just wrapper function.

thus, that change inline function is better.



CC: Lee Schermerhorn <lee.schermerhorn@hp.com>
CC: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/gfp.h |   21 +++++++++++++++++----
 mm/page_alloc.c     |   18 +-----------------
 2 files changed, 18 insertions(+), 21 deletions(-)

Index: b/include/linux/gfp.h
===================================================================
--- a/include/linux/gfp.h	2008-05-05 01:32:00.000000000 +0900
+++ b/include/linux/gfp.h	2008-05-05 01:38:35.000000000 +0900
@@ -173,11 +173,24 @@ static inline void arch_free_page(struct
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-extern struct page *__alloc_pages(gfp_t, unsigned int, struct zonelist *);
+struct page *
+__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+		       struct zonelist *zonelist, nodemask_t *nodemask);
+
+static inline struct page *
+__alloc_pages(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist)
+{
+	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
+}
+
+static inline struct page *
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
+		struct zonelist *zonelist, nodemask_t *nodemask)
+{
+	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
+}
 
-extern struct page *
-__alloc_pages_nodemask(gfp_t, unsigned int,
-				struct zonelist *, nodemask_t *nodemask);
 
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2008-05-05 01:32:28.000000000 +0900
+++ b/mm/page_alloc.c	2008-05-05 01:38:22.000000000 +0900
@@ -1528,7 +1528,7 @@ static void set_page_owner(struct page *
 /*
  * This is the 'heart' of the zoned buddy allocator.
  */
-static struct page *
+struct page *
 __alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
@@ -1736,22 +1736,6 @@ got_pg:
 	return page;
 }
 
-struct page *
-__alloc_pages(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist)
-{
-	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
-}
-
-struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist, nodemask_t *nodemask)
-{
-	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
-}
-
-EXPORT_SYMBOL(__alloc_pages);
-
 /*
  * Common helper functions.
  */


