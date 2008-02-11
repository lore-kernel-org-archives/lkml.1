Return-Path: <linux-kernel-owner+w=401wt.eu-S1760870AbYBKVxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbYBKVxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbYBKVxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:53:17 -0500
Received: from mga05.intel.com ([192.55.52.89]:54544 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759990AbYBKVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:53:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,335,1199692800"; 
   d="scan'208";a="516806658"
Date: Mon, 11 Feb 2008 13:56:51 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: iova RB tree setup tweak.
Message-ID: <20080211215651.GA24412@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch merges two functions into one allowing for a 3%
reduction in overhead in locating, allocating and inserting pages for
use in IOMMU operations.

Its a bit of a eye-crosser so I welcome any RB-tree / MM experts to take
a look.  It works by re-using some of the information gathered in the
search for the pages to use in setting up the IOTLB's in the insertion
of the iova structure into the RB tree.

--mgross

Singed-off-by: <mgross@linux.intel.com>


Index: linux-2.6.24-mm1/drivers/pci/iova.c
===================================================================
--- linux-2.6.24-mm1.orig/drivers/pci/iova.c	2008-02-07 11:05:44.000000000 -0800
+++ linux-2.6.24-mm1/drivers/pci/iova.c	2008-02-07 13:05:03.000000000 -0800
@@ -72,20 +72,25 @@
 	return pad_size;
 }
 
-static int __alloc_iova_range(struct iova_domain *iovad, unsigned long size,
-		unsigned long limit_pfn, struct iova *new, bool size_aligned)
+static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
+		unsigned long size, unsigned long limit_pfn,
+			struct iova *new, bool size_aligned)
 {
-	struct rb_node *curr = NULL;
+	struct rb_node *prev, *curr = NULL;
 	unsigned long flags;
 	unsigned long saved_pfn;
 	unsigned int pad_size = 0;
 
 	/* Walk the tree backwards */
 	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
 	saved_pfn = limit_pfn;
 	curr = __get_cached_rbnode(iovad, &limit_pfn);
+	prev = curr;
 	while (curr) {
 		struct iova *curr_iova = container_of(curr, struct iova, node);
+
 		if (limit_pfn < curr_iova->pfn_lo)
 			goto move_left;
 		else if (limit_pfn < curr_iova->pfn_hi)
@@ -99,6 +104,7 @@
 adjust_limit_pfn:
 		limit_pfn = curr_iova->pfn_lo - 1;
 move_left:
+		prev = curr;
 		curr = rb_prev(curr);
 	}
 
@@ -115,7 +121,33 @@
 	new->pfn_lo = limit_pfn - (size + pad_size) + 1;
 	new->pfn_hi = new->pfn_lo + size - 1;
 
+	/* Insert the new_iova into domain rbtree by holding writer lock */
+	/* Add new node and rebalance tree. */
+	{
+		struct rb_node **entry = &((prev)), *parent = NULL;
+		/* Figure out where to put new node */
+		while (*entry) {
+			struct iova *this = container_of(*entry,
+							struct iova, node);
+			parent = *entry;
+
+			if (new->pfn_lo < this->pfn_lo)
+				entry = &((*entry)->rb_left);
+			else if (new->pfn_lo > this->pfn_lo)
+				entry = &((*entry)->rb_right);
+			else
+				BUG(); /* this should not happen */
+		}
+
+		/* Add new node and rebalance tree. */
+		rb_link_node(&new->node, parent, entry);
+		rb_insert_color(&new->node, &iovad->rbroot);
+	}
+	__cached_rbnode_insert_update(iovad, saved_pfn, new);
+
 	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+
+
 	return 0;
 }
 
@@ -171,23 +203,15 @@
 		size = __roundup_pow_of_two(size);
 
 	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
-	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova,
-			size_aligned);
+	ret = __alloc_and_insert_iova_range(iovad, size, limit_pfn,
+			new_iova, size_aligned);
 
+	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
 	if (ret) {
-		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
 		free_iova_mem(new_iova);
 		return NULL;
 	}
 
-	/* Insert the new_iova into domain rbtree by holding writer lock */
-	spin_lock(&iovad->iova_rbtree_lock);
-	iova_insert_rbtree(&iovad->rbroot, new_iova);
-	__cached_rbnode_insert_update(iovad, limit_pfn, new_iova);
-	spin_unlock(&iovad->iova_rbtree_lock);
-
-	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
-
 	return new_iova;
 }
 
