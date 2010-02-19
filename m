Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0BSA0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 19:26:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:35941 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab0BSAWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 19:22:11 -0500
Date: Fri, 19 Feb 2010 00:21:47 GMT
From: "tip-bot for Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
In-Reply-To: <20100210232343.GA11465@linux-os.sc.intel.com>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] rbtree: Add support for augmented rbtrees
Message-ID: <tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
Git-Commit-ID: 17d9ddc72fb8bba0d4f67868c9c612e472a594a9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Feb 2010 00:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  17d9ddc72fb8bba0d4f67868c9c612e472a594a9
Gitweb:     http://git.kernel.org/tip/17d9ddc72fb8bba0d4f67868c9c612e472a594a9
Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
AuthorDate: Wed, 10 Feb 2010 15:23:44 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Feb 2010 15:40:56 -0800

rbtree: Add support for augmented rbtrees

Add support for augmented rbtrees in core rbtree code.

This will be used in subsequent patches, in x86 PAT code, which needs
interval trees to efficiently keep track of PAT ranges.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
LKML-Reference: <20100210232343.GA11465@linux-os.sc.intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/rbtree.txt |   58 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rbtree.h   |    5 +++-
 lib/rbtree.c             |   48 ++++++++++++++++++++++++++++++++++---
 3 files changed, 106 insertions(+), 5 deletions(-)

diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
index aae8355..221f38b 100644
--- a/Documentation/rbtree.txt
+++ b/Documentation/rbtree.txt
@@ -190,3 +190,61 @@ Example:
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
+This callback function will be called from rbtree core routines whenever
+a node has a change in one or both of its children. It is the responsibility
+of the callback function to recalculate the additional data that is in the
+rb node using new children information. Note that if this new additional
+data affects the parent node's additional data, then callback function has
+to handle it and do the recursive updates.
+
+
+Interval tree is an example of augmented rb tree. Reference -
+"Introduction to Algorithms" by Cormen, Leiserson, Rivest and Stein.
+More details about interval trees:
+
+Classical rbtree has a single key and it cannot be directly used to store
+interval ranges like [lo:hi] and do a quick lookup for any overlap with a new
+lo:hi or to find whether there is an exact match for a new lo:hi.
+
+However, rbtree can be augmented to store such interval ranges in a structured
+way making it possible to do efficient lookup and exact match.
+
+This "extra information" stored in each node is the maximum hi
+(max_hi) value among all the nodes that are its descendents. This
+information can be maintained at each node just be looking at the node
+and its immediate children. And this will be used in O(log n) lookup
+for lowest match (lowest start address among all possible matches)
+with something like:
+
+find_lowest_match(lo, hi, node)
+{
+	lowest_match = NULL;
+	while (node) {
+		if (max_hi(node->left) > lo) {
+			// Lowest overlap if any must be on left side
+			node = node->left;
+		} else if (overlap(lo, hi, node)) {
+			lowest_match = node;
+			break;
+		} else if (lo > node->lo) {
+			// Lowest overlap if any must be on right side
+			node = node->right;
+		} else {
+			break;
+		}
+	}
+	return lowest_match;
+}
+
+Finding exact match will be to first find lowest match and then to follow
+successor nodes looking for exact match, until the start of a node is beyond
+the hi value we are looking for.
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
