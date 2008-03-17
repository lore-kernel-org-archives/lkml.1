Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYCQCBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYCQCBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYCQB62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:28 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:45382 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbYCQB6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:25 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [10/18] Factor out new huge page preparation code into separate function
Message-Id: <20080317015824.074A31B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:24 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:49.0752 (UTC) FILETIME=[772EA780:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Needed to avoid code duplication in follow up patches.

This happens to fix a minor bug. When alloc_bootmem_node returns
a fallback node on a different node than passed the old code
would have put it into the free lists of the wrong node.
Now it would end up in the freelist of the correct node.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 mm/hugetlb.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

Index: linux/mm/hugetlb.c
===================================================================
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -200,6 +200,17 @@ static int adjust_pool_surplus(struct hs
 	return ret;
 }
 
+static void huge_new_page(struct hstate *h, struct page *page)
+{
+	unsigned nid = pfn_to_nid(page_to_pfn(page));
+	set_compound_page_dtor(page, free_huge_page);
+	spin_lock(&hugetlb_lock);
+	h->nr_huge_pages++;
+	h->nr_huge_pages_node[nid]++;
+	spin_unlock(&hugetlb_lock);
+	put_page(page); /* free it into the hugepage allocator */
+}
+
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 {
 	struct page *page;
@@ -207,14 +218,8 @@ static struct page *alloc_fresh_huge_pag
 	page = alloc_pages_node(nid,
 		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|__GFP_NOWARN,
 			huge_page_order(h));
-	if (page) {
-		set_compound_page_dtor(page, free_huge_page);
-		spin_lock(&hugetlb_lock);
-		h->nr_huge_pages++;
-		h->nr_huge_pages_node[nid]++;
-		spin_unlock(&hugetlb_lock);
-		put_page(page); /* free it into the hugepage allocator */
-	}
+	if (page)
+		huge_new_page(h, page);
 
 	return page;
 }
