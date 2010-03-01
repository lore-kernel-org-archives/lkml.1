Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0CAFip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 00:38:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:31395 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0CAFh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 00:37:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,557,1262592000"; 
   d="scan'208";a="249208737"
Message-Id: <20100301053622.230510083@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 01 Mar 2010 13:27:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Clemens Ladisch <clemens@ladisch.de>
CC: Olivier Galibert <galibert@pobox.com>
cc: Vivek Goyal <vgoyal@redhat.com>
cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
cc: Matt Mackall <mpm@selenic.com>
CC: Nick Piggin <npiggin@suse.de>
cc: Linux Memory Management List <linux-mm@kvack.org>
CC: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/16] radixtree: speed up the search for hole
References: <20100301052651.857984880@intel.com>
Content-Disposition: inline; filename=radixtree-scan-hole-fast.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the hole scan functions with more fast versions:
	- radix_tree_next_hole(root, index, max_scan)
	- radix_tree_prev_hole(root, index, max_scan)

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 lib/radix-tree.c |   67 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 56 insertions(+), 11 deletions(-)

--- linux.orig/lib/radix-tree.c	2010-02-28 13:10:10.000000000 +0800
+++ linux/lib/radix-tree.c	2010-02-28 13:10:21.000000000 +0800
@@ -649,18 +649,41 @@ EXPORT_SYMBOL(radix_tree_tag_get);
  *	under rcu_read_lock.
  */
 unsigned long radix_tree_next_hole(struct radix_tree_root *root,
-				unsigned long index, unsigned long max_scan)
+				   unsigned long index, unsigned long max_scan)
 {
-	unsigned long i;
+	struct radix_tree_node *node;
+	unsigned long origin = index;
+	int i;
+
+	node = rcu_dereference(root->rnode);
+	if (node == NULL)
+		return index;
+
+	if (!radix_tree_is_indirect_ptr(node))
+		return index ? index : 1;
 
-	for (i = 0; i < max_scan; i++) {
-		if (!radix_tree_lookup(root, index))
+	while (index - origin < max_scan) {
+		node = radix_tree_lookup_leaf_node(root, index);
+		if (!node)
 			break;
-		index++;
-		if (index == 0)
+
+		if (node->count == RADIX_TREE_MAP_SIZE) {
+			index = (index | RADIX_TREE_MAP_MASK) + 1;
+			goto check_overflow;
+		}
+
+		for (i = index & RADIX_TREE_MAP_MASK;
+		     i < RADIX_TREE_MAP_SIZE;
+		     i++, index++)
+			if (rcu_dereference(node->slots[i]) == NULL)
+				goto out;
+
+check_overflow:
+		if (unlikely(index == 0))
 			break;
 	}
 
+out:
 	return index;
 }
 EXPORT_SYMBOL(radix_tree_next_hole);
@@ -688,16 +711,38 @@ EXPORT_SYMBOL(radix_tree_next_hole);
 unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
 				   unsigned long index, unsigned long max_scan)
 {
-	unsigned long i;
+	struct radix_tree_node *node;
+	unsigned long origin = index;
+	int i;
+
+	node = rcu_dereference(root->rnode);
+	if (node == NULL)
+		return index;
+
+	if (!radix_tree_is_indirect_ptr(node))
+		return index ? index : ULONG_MAX;
 
-	for (i = 0; i < max_scan; i++) {
-		if (!radix_tree_lookup(root, index))
+	while (origin - index < max_scan) {
+		node = radix_tree_lookup_leaf_node(root, index);
+		if (!node)
 			break;
-		index--;
-		if (index == LONG_MAX)
+
+		if (node->count == RADIX_TREE_MAP_SIZE) {
+			index = (index - RADIX_TREE_MAP_SIZE) |
+					 RADIX_TREE_MAP_MASK;
+			goto check_underflow;
+		}
+
+		for (i = index & RADIX_TREE_MAP_MASK; i >= 0; i--, index--)
+			if (rcu_dereference(node->slots[i]) == NULL)
+				goto out;
+
+check_underflow:
+		if (unlikely(index == ULONG_MAX))
 			break;
 	}
 
+out:
 	return index;
 }
 EXPORT_SYMBOL(radix_tree_prev_hole);


