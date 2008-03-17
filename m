Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbYCQB7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbYCQB7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbYCQB6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:24 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:18066 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967AbYCQB6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:21 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [5/18] Expand the hugetlbfs sysctls to handle arrays for all hstates
Message-Id: <20080317015818.E30041B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:18 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:44.0611 (UTC) FILETIME=[741E3330:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- I didn't bother with hugetlb_shm_group and treat_as_movable,
these are still single global.
- Also improve error propagation for the sysctl handlers a bit


Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/hugetlb.h |    5 +++--
 kernel/sysctl.c         |    2 +-
 mm/hugetlb.c            |   43 +++++++++++++++++++++++++++++++------------
 3 files changed, 35 insertions(+), 15 deletions(-)

Index: linux/include/linux/hugetlb.h
===================================================================
--- linux.orig/include/linux/hugetlb.h
+++ linux/include/linux/hugetlb.h
@@ -32,8 +32,6 @@ int hugetlb_fault(struct mm_struct *mm, 
 int hugetlb_reserve_pages(struct inode *inode, long from, long to);
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed);
 
-extern unsigned long max_huge_pages;
-extern unsigned long sysctl_overcommit_huge_pages;
 extern unsigned long hugepages_treat_as_movable;
 extern const unsigned long hugetlb_zero, hugetlb_infinity;
 extern int sysctl_hugetlb_shm_group;
@@ -258,6 +256,9 @@ static inline unsigned huge_page_shift(s
 	return h->order + PAGE_SHIFT;
 }
 
+extern unsigned long max_huge_pages[HUGE_MAX_HSTATE];
+extern unsigned long sysctl_overcommit_huge_pages[HUGE_MAX_HSTATE];
+
 #else
 struct hstate {};
 #define hstate_file(f) NULL
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -935,7 +935,7 @@ static struct ctl_table vm_table[] = {
 	 {
 		.procname	= "nr_hugepages",
 		.data		= &max_huge_pages,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen 	= sizeof(max_huge_pages),
 		.mode		= 0644,
 		.proc_handler	= &hugetlb_sysctl_handler,
 		.extra1		= (void *)&hugetlb_zero,
Index: linux/mm/hugetlb.c
===================================================================
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -22,8 +22,8 @@
 #include "internal.h"
 
 const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
-unsigned long max_huge_pages;
-unsigned long sysctl_overcommit_huge_pages;
+unsigned long max_huge_pages[HUGE_MAX_HSTATE];
+unsigned long sysctl_overcommit_huge_pages[HUGE_MAX_HSTATE];
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
@@ -496,11 +496,11 @@ static int __init hugetlb_init_hstate(st
 
 	h->hugetlb_next_nid = first_node(node_online_map);
 
-	for (i = 0; i < max_huge_pages; ++i) {
+	for (i = 0; i < max_huge_pages[h - hstates]; ++i) {
 		if (!alloc_fresh_huge_page(h))
 			break;
 	}
-	max_huge_pages = h->free_huge_pages = h->nr_huge_pages = i;
+	max_huge_pages[h - hstates] = h->free_huge_pages = h->nr_huge_pages = i;
 
 	printk(KERN_INFO "Total HugeTLB memory allocated, %ld %dMB pages\n",
 			h->free_huge_pages,
@@ -531,8 +531,9 @@ void __init huge_add_hstate(unsigned ord
 
 static int __init hugetlb_setup(char *s)
 {
-	if (sscanf(s, "%lu", &max_huge_pages) <= 0)
-		max_huge_pages = 0;
+	unsigned long *mhp = &max_huge_pages[parsed_hstate - hstates];
+	if (sscanf(s, "%lu", mhp) <= 0)
+		*mhp = 0;
 	return 1;
 }
 __setup("hugepages=", hugetlb_setup);
@@ -584,10 +585,12 @@ static inline void try_to_free_low(unsig
 #endif
 
 #define persistent_huge_pages(h) (h->nr_huge_pages - h->surplus_huge_pages)
-static unsigned long set_max_huge_pages(unsigned long count)
+static unsigned long
+set_max_huge_pages(struct hstate *h, unsigned long count, int *err)
 {
 	unsigned long min_count, ret;
-	struct hstate *h = &global_hstate;
+
+	*err = 0;
 
 	/*
 	 * Increase the pool size
@@ -659,8 +662,20 @@ int hugetlb_sysctl_handler(struct ctl_ta
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)
 {
-	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
-	max_huge_pages = set_max_huge_pages(max_huge_pages);
+	int err = 0;
+	struct hstate *h;
+	int i;
+	err = proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
+	if (err)
+		return err;
+	i = 0;
+	for_each_hstate (h) {
+		max_huge_pages[i] = set_max_huge_pages(h, max_huge_pages[i],
+							&err);
+		if (err)
+			return err;
+		i++;
+	}
 	return 0;
 }
 
@@ -680,10 +695,14 @@ int hugetlb_overcommit_handler(struct ct
 			struct file *file, void __user *buffer,
 			size_t *length, loff_t *ppos)
 {
-	struct hstate *h = &global_hstate;
+	struct hstate *h;
+	int i = 0;
 	proc_doulongvec_minmax(table, write, file, buffer, length, ppos);
 	spin_lock(&hugetlb_lock);
-	h->nr_overcommit_huge_pages = sysctl_overcommit_huge_pages;
+	for_each_hstate (h) {
+		h->nr_overcommit_huge_pages = sysctl_overcommit_huge_pages[i];
+		i++;
+	}
 	spin_unlock(&hugetlb_lock);
 	return 0;
 }
