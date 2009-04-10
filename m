Return-Path: <linux-kernel-owner+w=401wt.eu-S937820AbZDJNTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937820AbZDJNTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935615AbZDJNTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:19:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:31389 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937367AbZDJNTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:19:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,166,1239001200"; 
   d="scan'208";a="130105407"
Message-Id: <20090410131358.730461070@intel.com>
References: <20090410131247.764370473@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 10 Apr 2009 21:12:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] radix-tree: add radix_tree_next_hole()
Content-Disposition: inline; filename=radixtree-prev-hole.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The counterpart of radix_tree_prev_hole(). To be used by context readahead.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
---
 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   37 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

--- mm.orig/lib/radix-tree.c
+++ mm/lib/radix-tree.c
@@ -666,6 +666,43 @@ unsigned long radix_tree_next_hole(struc
 }
 EXPORT_SYMBOL(radix_tree_next_hole);
 
+/**
+ *	radix_tree_prev_hole    -    find the prev hole (not-present entry)
+ *	@root:		tree root
+ *	@index:		index key
+ *	@max_scan:	maximum range to search
+ *
+ *	Search backwards in the range [max(index-max_scan+1, 0), index]
+ *	for the first hole.
+ *
+ *	Returns: the index of the hole if found, otherwise returns an index
+ *	outside of the set specified (in which case 'index - return >= max_scan'
+ *	will be true). In rare cases of wrap-around, LONG_MAX will be returned.
+ *
+ *	radix_tree_next_hole may be called under rcu_read_lock. However, like
+ *	radix_tree_gang_lookup, this will not atomically search a snapshot of
+ *	the tree at a single point in time. For example, if a hole is created
+ *	at index 10, then subsequently a hole is created at index 5,
+ *	radix_tree_prev_hole covering both indexes may return 5 if called under
+ *	rcu_read_lock.
+ */
+unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
+				   unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(root, index))
+			break;
+		index--;
+		if (index == LONG_MAX)
+			break;
+	}
+
+	return index;
+}
+EXPORT_SYMBOL(radix_tree_prev_hole);
+
 static unsigned int
 __lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)
--- mm.orig/include/linux/radix-tree.h
+++ mm/include/linux/radix-tree.h
@@ -167,6 +167,8 @@ radix_tree_gang_lookup_slot(struct radix
 			unsigned long first_index, unsigned int max_items);
 unsigned long radix_tree_next_hole(struct radix_tree_root *root,
 				unsigned long index, unsigned long max_scan);
+unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,

-- 

