Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYCQCAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYCQCAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbYCQB60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:26 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:23309 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYCQB6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:23 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [7/18] Abstract out the NUMA node round robin code into a separate function
Message-Id: <20080317015820.ECC861B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:20 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:46.0689 (UTC) FILETIME=[755B4710:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Need this as a separate function for a future patch.

No behaviour change.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 mm/hugetlb.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

Index: linux/mm/hugetlb.c
===================================================================
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -219,6 +219,27 @@ static struct page *alloc_fresh_huge_pag
 	return page;
 }
 
+/*
+ * Use a helper variable to find the next node and then
+ * copy it back to hugetlb_next_nid afterwards:
+ * otherwise there's a window in which a racer might
+ * pass invalid nid MAX_NUMNODES to alloc_pages_node.
+ * But we don't need to use a spin_lock here: it really
+ * doesn't matter if occasionally a racer chooses the
+ * same nid as we do.  Move nid forward in the mask even
+ * if we just successfully allocated a hugepage so that
+ * the next caller gets hugepages on the next node.
+ */
+static int huge_next_node(struct hstate *h)
+{
+	int next_nid;
+	next_nid = next_node(h->hugetlb_next_nid, node_online_map);
+	if (next_nid == MAX_NUMNODES)
+		next_nid = first_node(node_online_map);
+	h->hugetlb_next_nid = next_nid;
+	return next_nid;
+}
+
 static int alloc_fresh_huge_page(struct hstate *h)
 {
 	struct page *page;
@@ -232,21 +253,7 @@ static int alloc_fresh_huge_page(struct 
 		page = alloc_fresh_huge_page_node(h, h->hugetlb_next_nid);
 		if (page)
 			ret = 1;
-		/*
-		 * Use a helper variable to find the next node and then
-		 * copy it back to hugetlb_next_nid afterwards:
-		 * otherwise there's a window in which a racer might
-		 * pass invalid nid MAX_NUMNODES to alloc_pages_node.
-		 * But we don't need to use a spin_lock here: it really
-		 * doesn't matter if occasionally a racer chooses the
-		 * same nid as we do.  Move nid forward in the mask even
-		 * if we just successfully allocated a hugepage so that
-		 * the next caller gets hugepages on the next node.
-		 */
-		next_nid = next_node(h->hugetlb_next_nid, node_online_map);
-		if (next_nid == MAX_NUMNODES)
-			next_nid = first_node(node_online_map);
-		h->hugetlb_next_nid = next_nid;
+		next_nid = huge_next_node(h);
 	} while (!page && h->hugetlb_next_nid != start_nid);
 
 	return ret;
