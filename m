Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbZCPRwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbZCPRwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbZCPRv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:51:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51157 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbZCPRvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:51:25 -0400
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
Subject: [PATCH 02/27] Do not sanity check order in the fast path
Date: Mon, 16 Mar 2009 17:53:16 +0000
Message-Id: <1237226020-14057-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No user of the allocator API should be passing in an order >= MAX_ORDER
but we check for it on each and every allocation. Delete this check and
make it a VM_BUG_ON check further down the call path.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 include/linux/gfp.h |    6 ------
 mm/page_alloc.c     |    2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index dcf0ab8..8736047 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -181,9 +181,6 @@ __alloc_pages(gfp_t gfp_mask, unsigned int order,
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
 {
-	if (unlikely(order >= MAX_ORDER))
-		return NULL;
-
 	/* Unknown node is current node */
 	if (nid < 0)
 		nid = numa_node_id();
@@ -197,9 +194,6 @@ extern struct page *alloc_pages_current(gfp_t gfp_mask, unsigned order);
 static inline struct page *
 alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
-	if (unlikely(order >= MAX_ORDER))
-		return NULL;
-
 	return alloc_pages_current(gfp_mask, order);
 }
 extern struct page *alloc_page_vma(gfp_t gfp_mask,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0671b3f..dd87dad 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1407,6 +1407,8 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 
 	classzone_idx = zone_idx(preferred_zone);
 
+	VM_BUG_ON(order >= MAX_ORDER);
+
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-- 
1.5.6.5

