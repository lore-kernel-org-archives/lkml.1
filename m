Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYCQCCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYCQCCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 22:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYCQB6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:30 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:23330 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbYCQB63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:29 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [13/18] Add support to allocate hugepages of different size with hugepages=...
Message-Id: <20080317015827.15E811B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:27 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:52.0814 (UTC) FILETIME=[7901E0E0:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |   23 ++++++++++++++++++-----
 2 files changed, 19 insertions(+), 5 deletions(-)

Index: linux/mm/hugetlb.c
===================================================================
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -552,19 +552,23 @@ static int __init hugetlb_init_hstate(st
 {
 	unsigned long i;
 
-	for (i = 0; i < MAX_NUMNODES; ++i)
-		INIT_LIST_HEAD(&h->hugepage_freelists[i]);
+	/* Don't reinitialize lists if they have been already init'ed */
+	if (!h->hugepage_freelists[0].next) {
+		for (i = 0; i < MAX_NUMNODES; ++i)
+			INIT_LIST_HEAD(&h->hugepage_freelists[i]);
 
-	h->hugetlb_next_nid = first_node(node_online_map);
+		h->hugetlb_next_nid = first_node(node_online_map);
+	}
 
-	for (i = 0; i < max_huge_pages[h - hstates]; ++i) {
+	while (h->parsed_hugepages < max_huge_pages[h - hstates]) {
 		if (h->order > MAX_ORDER) {
 			if (!alloc_bm_huge_page(h))
 				break;
 		} else if (!alloc_fresh_huge_page(h))
 			break;
+		h->parsed_hugepages++;
 	}
-	max_huge_pages[h - hstates] = h->free_huge_pages = h->nr_huge_pages = i;
+	max_huge_pages[h - hstates] = h->parsed_hugepages;
 
 	printk(KERN_INFO "Total HugeTLB memory allocated, %ld %dMB pages\n",
 			h->free_huge_pages,
@@ -602,6 +606,15 @@ static int __init hugetlb_setup(char *s)
 	unsigned long *mhp = &max_huge_pages[parsed_hstate - hstates];
 	if (sscanf(s, "%lu", mhp) <= 0)
 		*mhp = 0;
+	/*
+	 * Global state is always initialized later in hugetlb_init.
+	 * But we need to allocate > MAX_ORDER hstates here early to still
+	 * use the bootmem allocator.
+	 * If you add additional hstates <= MAX_ORDER you'll need
+	 * to fix that.
+	 */
+	if (parsed_hstate != &global_hstate)
+		hugetlb_init_hstate(parsed_hstate);
 	return 1;
 }
 __setup("hugepages=", hugetlb_setup);
Index: linux/include/linux/hugetlb.h
===================================================================
--- linux.orig/include/linux/hugetlb.h
+++ linux/include/linux/hugetlb.h
@@ -212,6 +212,7 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+	unsigned long parsed_hugepages;
 };
 
 void __init huge_add_hstate(unsigned order);
