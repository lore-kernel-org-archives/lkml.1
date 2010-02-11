Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0BKXHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:07:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab0BKXGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:06:32 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       fengguang.wu@intel.com, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] radix-tree: Implement function radix_tree_gang_tag_if_tagged
Date: Fri, 12 Feb 2010 00:06:22 +0100
Message-Id: <1265929584-5080-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1265929584-5080-1-git-send-email-jack@suse.cz>
References: <1265929584-5080-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement function for setting one tag if another tag is set
for each item in given range.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/radix-tree.h |    3 ++
 lib/radix-tree.c           |   82 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index c5da749..41fa087 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -185,6 +185,9 @@ unsigned int
 radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
 		unsigned long first_index, unsigned int max_items,
 		unsigned int tag);
+unsigned long radix_tree_gang_tag_if_tagged(struct radix_tree_root *root,
+		unsigned long first_index, unsigned long last_index,
+		unsigned int fromtag, unsigned int totag);
 int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
 
 static inline void radix_tree_preload_end(void)
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 92cdd99..d821a17 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -610,6 +610,88 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 EXPORT_SYMBOL(radix_tree_tag_get);
 
 /**
+ * radix_tree_gang_tag_if_tagged - for each item in given range set given
+ *				   tag if item has another tag set
+ * @root:		radix tree root
+ * @first_index:	starting index of a range to scan
+ * @last_index:		last index of a range to scan
+ * @iftag: 		tag index to test
+ * @settag:		tag index to set if tested tag is set
+ *
+ * This function scans range of radix tree from first_index to last_index.
+ * For each item in the range if iftag is set, the function sets also
+ * settag.
+ *
+ * The function returns number of leaves where the tag was set.
+ */
+unsigned long radix_tree_gang_tag_if_tagged(struct radix_tree_root *root,
+                unsigned long first_index, unsigned long last_index,
+                unsigned int iftag, unsigned int settag)
+{
+	unsigned int height = root->height, shift;
+	unsigned long tagged = 0, index = first_index;
+	struct radix_tree_node *open_slots[height], *slot;
+
+	last_index = min(last_index, radix_tree_maxindex(height));
+	if (first_index > last_index)
+		return 0;
+	if (!root_tag_get(root, iftag))
+		return 0;
+	if (height == 0) {
+		root_tag_set(root, settag);
+		return 1;
+	}
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	slot = radix_tree_indirect_to_ptr(root->rnode);
+
+	for (;;) {
+		int offset;
+
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		if (!slot->slots[offset])
+			goto next;
+		if (!tag_get(slot, iftag, offset))
+			goto next;
+		tag_set(slot, settag, offset);
+		if (height == 1) {
+			tagged++;
+			goto next;
+		}
+		/* Go down one level */
+		height--;
+		shift -= RADIX_TREE_MAP_SHIFT;
+		open_slots[height] = slot;
+		slot = slot->slots[offset];
+		continue;
+next:
+		/* Go to next item at level determined by 'shift' */
+		index = ((index >> shift) + 1) << shift;
+		if (index > last_index)
+			break;
+		while (((index >> shift) & RADIX_TREE_MAP_MASK) == 0) {
+			/*
+			 * We've fully scanned this node. Go up. Because
+			 * last_index is guaranteed to be in the tree, what
+			 * we do below cannot wander astray.
+			 */
+			slot = open_slots[height];
+			height++;
+			shift += RADIX_TREE_MAP_SHIFT;
+		}
+	}
+	/*
+	 * The iftag must have been set somewhere because otherwise
+	 * we would return immediated at the beginning of the function
+	 */
+	root_tag_set(root, settag);
+
+	return tagged;
+}
+EXPORT_SYMBOL(radix_tree_gang_tag_if_tagged);
+
+
+/**
  *	radix_tree_next_hole    -    find the next hole (not-present entry)
  *	@root:		tree root
  *	@index:		index key
-- 
1.6.4.2

