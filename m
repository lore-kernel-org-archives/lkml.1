Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab0BJVeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:34:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:44197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479Ab0BJVeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:34:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,446,1262592000"; 
   d="scan'208";a="594868398"
Message-Id: <20100210195909.648914000@intel.com>
References: <20100210195704.434039000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 10 Feb 2010 11:57:05 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Wolfram Strepp <wstrepp@gmx.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/3] rbtree: Add support for augmented rbtrees
Content-Disposition: inline; filename=0001-rbtree-Add-support-for-augmented-rbtrees.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for augmented rbtrees in core rbtree code.

This will be used in subsequent patches, in x86 PAT code, which needs
interval trees to efficiently keep track of PAT ranges.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 Documentation/rbtree.txt |   19 ++++++++++++++++++
 include/linux/rbtree.h   |    5 +++-
 lib/rbtree.c             |   48 ++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index aae8355..b2bae0a 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -190,3 +190,22 @@ Example:
   for (node = rb_first(&mytree); node; node = rb_next(node))
 	printk("key=%s\n", rb_entry(node, struct mytype, node)->keystring);
 
+Support for Augmented rbtrees
+-----------------------------
+
+Augmented rbtree is an rbtree with "some" additional data stored in each node.
+This data can be used to augment some new functionality to rbtree.
+Augmented rbtree is an optional feature built on top of basic rbtree
+infrastructure. rbtree user who wants this feature will have an augment
+callback function in rb_root initialized.
+
+Interval tree is an example of augmented rb tree. Reference -
+"Introduction to Algorithms" by Cormen, Leiserson, Rivest and Stein.
+
+This callback function will be called from rbtree core routines whenever
+a node has a change in one or both of its children. It is the responsibility
+of the callback function to recalculate the additional data that is in the
+rb node using new children information. Note that if this new additional
+data affects the parent node's additional data, then callback function has
+to handle it and do the recursive updates.
+
diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 9c29541..8e33a25 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -110,6 +110,7 @@ struct rb_node
 struct rb_root
 {
 	struct rb_node *rb_node;
+	void (*augment_cb)(struct rb_node *node);
 };
 
 
@@ -129,7 +130,9 @@ static inline void rb_set_color(struct rb_node *rb, int color)
 	rb->rb_parent_color = (rb->rb_parent_color & ~1) | color;
 }
 
-#define RB_ROOT	(struct rb_root) { NULL, }
+#define RB_ROOT	(struct rb_root) { NULL, NULL, }
+#define RB_AUGMENT_ROOT(x)	(struct rb_root) { NULL, x}
+
 #define	rb_entry(ptr, type, member) container_of(ptr, type, member)
 
 #define RB_EMPTY_ROOT(root)	((root)->rb_node == NULL)
diff --git a/lib/rbtree.c b/lib/rbtree.c
index e2aa3be..15e10b1 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -44,6 +44,11 @@ static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 	else
 		root->rb_node = right;
 	rb_set_parent(node, right);
+
+	if (root->augment_cb) {
+		root->augment_cb(node);
+		root->augment_cb(right);
+	}
 }
 
 static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
@@ -67,12 +72,20 @@ static void __rb_rotate_right(struct rb_node *node, struct rb_root *root)
 	else
 		root->rb_node = left;
 	rb_set_parent(node, left);
+
+	if (root->augment_cb) {
+		root->augment_cb(node);
+		root->augment_cb(left);
+	}
 }
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *parent, *gparent;
 
+	if (root->augment_cb)
+		root->augment_cb(node);
+
 	while ((parent = rb_parent(node)) && rb_is_red(parent))
 	{
 		gparent = rb_parent(parent);
@@ -227,12 +240,15 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 	else
 	{
 		struct rb_node *old = node, *left;
+		int old_parent_cb = 0;
+		int successor_parent_cb = 0;
 
 		node = node->rb_right;
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
 		if (rb_parent(old)) {
+			old_parent_cb = 1;
 			if (rb_parent(old)->rb_left == old)
 				rb_parent(old)->rb_left = node;
 			else
@@ -247,8 +263,10 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		if (parent == old) {
 			parent = node;
 		} else {
+			successor_parent_cb = 1;
 			if (child)
 				rb_set_parent(child, parent);
+
 			parent->rb_left = child;
 
 			node->rb_right = old->rb_right;
@@ -259,6 +277,24 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 		node->rb_left = old->rb_left;
 		rb_set_parent(old->rb_left, node);
 
+		if (root->augment_cb) {
+			/*
+			 * Here, three different nodes can have new children.
+			 * The parent of the successor node that was selected
+			 * to replace the node to be erased.
+			 * The node that is getting erased and is now replaced
+			 * by its successor.
+			 * The parent of the node getting erased-replaced.
+			 */
+			if (successor_parent_cb)
+				root->augment_cb(parent);
+
+			root->augment_cb(node);
+
+			if (old_parent_cb)
+				root->augment_cb(rb_parent(old));
+		}
+
 		goto color;
 	}
 
@@ -267,15 +303,19 @@ void rb_erase(struct rb_node *node, struct rb_root *root)
 
 	if (child)
 		rb_set_parent(child, parent);
-	if (parent)
-	{
+
+	if (parent) {
 		if (parent->rb_left == node)
 			parent->rb_left = child;
 		else
 			parent->rb_right = child;
-	}
-	else
+
+		if (root->augment_cb)
+			root->augment_cb(parent);
+
+	} else {
 		root->rb_node = child;
+	}
 
  color:
 	if (color == RB_BLACK)
-- 
1.6.0.6

-- 

