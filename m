Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYCQB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYCQB7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbYCQB6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:23 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:45309 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940AbYCQB6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:20 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [2/18] Add basic support for more than one hstate in hugetlbfs
Message-Id: <20080317015815.D43991B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:15 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:41.0548 (UTC) FILETIME=[724AD2C0:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Convert hstates to an array
- Add a first default entry covering the standard huge page size
- Add functions for architectures to register new hstates
- Add basic iterators over hstates

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/hugetlb.h |   10 +++++++++-
 mm/hugetlb.c            |   46 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 46 insertions(+), 10 deletions(-)

Index: linux/mm/hugetlb.c
===================================================================
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -27,7 +27,15 @@ unsigned long sysctl_overcommit_huge_pag
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-struct hstate global_hstate;
+static int max_hstate = 1;
+
+struct hstate hstates[HUGE_MAX_HSTATE];
+
+/* for command line parsing */
+struct hstate *parsed_hstate __initdata = &global_hstate;
+
+#define for_each_hstate(h) \
+	for ((h) = hstates; (h) < &hstates[max_hstate]; (h)++)
 
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
@@ -474,15 +482,11 @@ static struct page *alloc_huge_page(stru
 	return page;
 }
 
-static int __init hugetlb_init(void)
+static int __init hugetlb_init_hstate(struct hstate *h)
 {
 	unsigned long i;
-	struct hstate *h = &global_hstate;
 
-	if (HPAGE_SHIFT == 0)
-		return 0;
-
-	if (!h->order) {
+	if (h == &global_hstate && !h->order) {
 		h->order = HPAGE_SHIFT - PAGE_SHIFT;
 		h->mask = HPAGE_MASK;
 	}
@@ -497,11 +501,34 @@ static int __init hugetlb_init(void)
 			break;
 	}
 	max_huge_pages = h->free_huge_pages = h->nr_huge_pages = i;
-	printk("Total HugeTLB memory allocated, %ld\n", h->free_huge_pages);
+
+	printk(KERN_INFO "Total HugeTLB memory allocated, %ld %dMB pages\n",
+			h->free_huge_pages,
+			1 << (h->order + PAGE_SHIFT - 20));
 	return 0;
 }
+
+static int __init hugetlb_init(void)
+{
+	if (HPAGE_SHIFT == 0)
+		return 0;
+	return hugetlb_init_hstate(&global_hstate);
+}
 module_init(hugetlb_init);
 
+/* Should be called on processing a hugepagesz=... option */
+void __init huge_add_hstate(unsigned order)
+{
+	struct hstate *h;
+	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
+	BUG_ON(order <= HPAGE_SHIFT - PAGE_SHIFT);
+	h = &hstates[max_hstate++];
+	h->order = order;
+	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
+	hugetlb_init_hstate(h);
+	parsed_hstate = h;
+}
+
 static int __init hugetlb_setup(char *s)
 {
 	if (sscanf(s, "%lu", &max_huge_pages) <= 0)
Index: linux/include/linux/hugetlb.h
===================================================================
--- linux.orig/include/linux/hugetlb.h
+++ linux/include/linux/hugetlb.h
@@ -213,7 +213,15 @@ struct hstate {
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
 };
 
-extern struct hstate global_hstate;
+void __init huge_add_hstate(unsigned order);
+
+#ifndef HUGE_MAX_HSTATE
+#define HUGE_MAX_HSTATE 1
+#endif
+
+extern struct hstate hstates[HUGE_MAX_HSTATE];
+
+#define global_hstate (hstates[0])
 
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
 {
