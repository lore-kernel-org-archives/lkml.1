Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZDVNyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZDVNyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZDVNxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:53:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43781 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbZDVNxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:53:31 -0400
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
Subject: [PATCH 01/22] Replace __alloc_pages_internal() with __alloc_pages_nodemask()
Date: Wed, 22 Apr 2009 14:53:06 +0100
Message-Id: <1240408407-21848-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_pages_internal is the core page allocator function but
essentially it is an alias of __alloc_pages_nodemask. Naming a publicly
available and exported function "internal" is also a big ugly. This
patch renames __alloc_pages_internal() to __alloc_pages_nodemask() and
deletes the old nodemask function.

Warning - This patch renames an exported symbol. No kernel driver is
affected by external drivers calling __alloc_pages_internal() should
change the call to __alloc_pages_nodemask() without any alteration of
parameters.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/gfp.h |   12 ++----------
 mm/page_alloc.c     |    4 ++--
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 0bbc15f..556c840 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -169,24 +169,16 @@ static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
 struct page *
-__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 		       struct zonelist *zonelist, nodemask_t *nodemask);
 
 static inline struct page *
 __alloc_pages(gfp_t gfp_mask, unsigned int order,
 		struct zonelist *zonelist)
 {
-	return __alloc_pages_internal(gfp_mask, order, zonelist, NULL);
+	return __alloc_pages_nodemask(gfp_mask, order, zonelist, NULL);
 }
 
-static inline struct page *
-__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
-		struct zonelist *zonelist, nodemask_t *nodemask)
-{
-	return __alloc_pages_internal(gfp_mask, order, zonelist, nodemask);
-}
-
-
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4ea469..dcc4f05 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1462,7 +1462,7 @@ try_next_zone:
  * This is the 'heart' of the zoned buddy allocator.
  */
 struct page *
-__alloc_pages_internal(gfp_t gfp_mask, unsigned int order,
+__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 			struct zonelist *zonelist, nodemask_t *nodemask)
 {
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
@@ -1671,7 +1671,7 @@ nopage:
 got_pg:
 	return page;
 }
-EXPORT_SYMBOL(__alloc_pages_internal);
+EXPORT_SYMBOL(__alloc_pages_nodemask);
 
 /*
  * Common helper functions.
-- 
1.5.6.5

