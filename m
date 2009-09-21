Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbZIUMnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbZIUMnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZIUMnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:43:16 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:2646 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbZIUMnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:43:15 -0400
X-Trace: 260589862/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.32.164/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.32.164
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcFAHcRt0pQKSCk/2dsb2JhbACBU44nAcB8hBsFgVg
X-IronPort-AV: E=Sophos;i="4.44,424,1249254000"; 
   d="scan'208";a="260589862"
Date: Mon, 21 Sep 2009 13:43:15 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] ksm: fix rare page leak
Message-ID: <Pine.LNX.4.64.0909211336300.4809@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the rare case when stable_tree_insert() finds a match when the prior
stable_tree_search() did not, it forgot to free the page reference (the
omission looks intentional, but I think that's because something else
used to be done there).

Fix that by one put_page() for all three cases, call it tree_page
rather than page2[0], clarify the comment on this exceptional case,
and remove the comment in stable_tree_search() which contradicts it!

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/ksm.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

--- mmotm/mm/ksm.c	2009-09-14 16:34:37.000000000 +0100
+++ linux/mm/ksm.c	2009-09-21 13:12:07.000000000 +0100
@@ -904,10 +904,6 @@ static struct rmap_item *stable_tree_sea
 		if (!tree_rmap_item)
 			return NULL;
 
-		/*
-		 * We can trust the value of the memcmp as we know the pages
-		 * are write protected.
-		 */
 		ret = memcmp_pages(page, page2[0]);
 
 		if (ret < 0) {
@@ -939,18 +935,18 @@ static struct rmap_item *stable_tree_ins
 {
 	struct rb_node **new = &root_stable_tree.rb_node;
 	struct rb_node *parent = NULL;
-	struct page *page2[1];
 
 	while (*new) {
 		struct rmap_item *tree_rmap_item, *next_rmap_item;
+		struct page *tree_page;
 		int ret;
 
 		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
 		while (tree_rmap_item) {
 			BUG_ON(!in_stable_tree(tree_rmap_item));
 			cond_resched();
-			page2[0] = get_ksm_page(tree_rmap_item);
-			if (page2[0])
+			tree_page = get_ksm_page(tree_rmap_item);
+			if (tree_page)
 				break;
 			next_rmap_item = tree_rmap_item->next;
 			remove_rmap_item_from_tree(tree_rmap_item);
@@ -959,22 +955,19 @@ static struct rmap_item *stable_tree_ins
 		if (!tree_rmap_item)
 			return NULL;
 
-		ret = memcmp_pages(page, page2[0]);
+		ret = memcmp_pages(page, tree_page);
+		put_page(tree_page);
 
 		parent = *new;
-		if (ret < 0) {
-			put_page(page2[0]);
+		if (ret < 0)
 			new = &parent->rb_left;
-		} else if (ret > 0) {
-			put_page(page2[0]);
+		else if (ret > 0)
 			new = &parent->rb_right;
-		} else {
+		else {
 			/*
-			 * It is not a bug when we come here (the fact that
-			 * we didn't find the page inside the stable tree):
-			 * because when we searched for the page inside the
-			 * stable tree it was still not write-protected,
-			 * so therefore it could have changed later.
+			 * It is not a bug that stable_tree_search() didn't
+			 * find this node: because at that time our page was
+			 * not yet write-protected, so may have changed since.
 			 */
 			return NULL;
 		}
