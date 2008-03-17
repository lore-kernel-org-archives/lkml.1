Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYCQB7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYCQB7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYCQB6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:58:24 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:45309 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbYCQB6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:58:21 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080317258.659191058@firstfloor.org>
In-Reply-To: <20080317258.659191058@firstfloor.org>
To: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: [PATCH] [4/18] Add basic support for more than one hstate in hugetlbfs
Message-Id: <20080317015817.DE00E1B41E0@basil.firstfloor.org>
Date: Mon, 17 Mar 2008 02:58:17 +0100 (CET)
X-OriginalArrivalTime: 17 Mar 2008 01:51:43.0595 (UTC) FILETIME=[73832BB0:01C887D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 mm/hugetlb.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux/mm/hugetlb.c
===================================================================
--- linux.orig/mm/hugetlb.c
+++ linux/mm/hugetlb.c
@@ -550,26 +550,33 @@ static unsigned int cpuset_mems_nr(unsig
 
 #ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
-static void try_to_free_low(unsigned long count)
+static void do_try_to_free_low(struct hstate *h, unsigned long count)
 {
-	struct hstate *h = &global_hstate;
 	int i;
 
 	for (i = 0; i < MAX_NUMNODES; ++i) {
 		struct page *page, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(page, next, freel, lru) {
-			if (count >= nr_huge_pages)
+			if (count >= h->nr_huge_pages)
 				return;
 			if (PageHighMem(page))
 				continue;
 			list_del(&page->lru);
-			update_and_free_page(page);
+			update_and_free_page(h, page);
 			h->free_huge_pages--;
 			h->free_huge_pages_node[page_to_nid(page)]--;
 		}
 	}
 }
+
+static void try_to_free_low(unsigned long count)
+{
+	struct hstate *h;
+	for_each_hstate (h) {
+		do_try_to_free_low(h, count);
+	}
+}
 #else
 static inline void try_to_free_low(unsigned long count)
 {
