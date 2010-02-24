Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0BXDMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 22:12:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:2806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab0BXDMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 22:12:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,529,1262592000"; 
   d="scan'208";a="775369724"
Message-Id: <20100224031055.316558127@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 24 Feb 2010 11:10:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Wu Fengguang <fengguang.wu@intel.com>
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
Subject: [PATCH 12/15] radixtree: introduce radix_tree_lookup_leaf_node()
References: <20100224031001.026464755@intel.com>
Content-Disposition: inline; filename=radixtree-radix_tree_lookup_leaf_node.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will be used by the pagecache context based read-ahead/read-around
heuristic to quickly check one pagecache range:
- if there is any hole
- if there is any pages

Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/radix-tree.h |    2 ++
 lib/radix-tree.c           |   27 ++++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

--- linux.orig/lib/radix-tree.c	2010-02-24 10:44:23.000000000 +0800
+++ linux/lib/radix-tree.c	2010-02-24 10:44:49.000000000 +0800
@@ -359,7 +359,7 @@ EXPORT_SYMBOL(radix_tree_insert);
  * is_slot == 0 : search for the node.
  */
 static void *radix_tree_lookup_element(struct radix_tree_root *root,
-				unsigned long index, int is_slot)
+				unsigned long index, int is_slot, int level)
 {
 	unsigned int height, shift;
 	struct radix_tree_node *node, **slot;
@@ -369,7 +369,7 @@ static void *radix_tree_lookup_element(s
 		return NULL;
 
 	if (!radix_tree_is_indirect_ptr(node)) {
-		if (index > 0)
+		if (index > 0 || level > 0)
 			return NULL;
 		return is_slot ? (void *)&root->rnode : node;
 	}
@@ -390,7 +390,7 @@ static void *radix_tree_lookup_element(s
 
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
-	} while (height > 0);
+	} while (height > level);
 
 	return is_slot ? (void *)slot:node;
 }
@@ -410,7 +410,7 @@ static void *radix_tree_lookup_element(s
  */
 void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
 {
-	return (void **)radix_tree_lookup_element(root, index, 1);
+	return (void **)radix_tree_lookup_element(root, index, 1, 0);
 }
 EXPORT_SYMBOL(radix_tree_lookup_slot);
 
@@ -428,11 +428,28 @@ EXPORT_SYMBOL(radix_tree_lookup_slot);
  */
 void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index)
 {
-	return radix_tree_lookup_element(root, index, 0);
+	return radix_tree_lookup_element(root, index, 0, 0);
 }
 EXPORT_SYMBOL(radix_tree_lookup);
 
 /**
+ *	radix_tree_lookup_leaf_node    -    lookup leaf node on a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Lookup the leaf node that covers @index in the radix tree @root.
+ *	Return NULL if the node does not exist, or is the special root node.
+ *
+ *	The typical usage is to check the value of node->count, which shall be
+ *	performed inside rcu_read_lock to prevent the node from being freed.
+ */
+struct radix_tree_node *
+radix_tree_lookup_leaf_node(struct radix_tree_root *root, unsigned long index)
+{
+	return radix_tree_lookup_element(root, index, 0, 1);
+}
+
+/**
  *	radix_tree_tag_set - set a tag on a radix tree node
  *	@root:		radix tree root
  *	@index:		index key
--- linux.orig/include/linux/radix-tree.h	2010-02-24 10:44:23.000000000 +0800
+++ linux/include/linux/radix-tree.h	2010-02-24 10:44:49.000000000 +0800
@@ -158,6 +158,8 @@ static inline void radix_tree_replace_sl
 int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
 void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
+struct radix_tree_node *
+radix_tree_lookup_leaf_node(struct radix_tree_root *root, unsigned long index);
 void *radix_tree_delete(struct radix_tree_root *, unsigned long);
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,


