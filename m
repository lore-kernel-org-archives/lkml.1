Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbZAHPjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbZAHPjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 10:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZAHPjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 10:39:12 -0500
Received: from smtp.nokia.com ([192.100.105.134]:46090 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZAHPjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:39:11 -0500
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind@infradead.org>
Date: Thu, 08 Jan 2009 19:38:13 +0200
Message-Id: <20090108173813.2387.74190.sendpatchset@localhost.localdomain>
In-Reply-To: <20090108173807.2387.93418.sendpatchset@localhost.localdomain>
References: <20090108173807.2387.93418.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/2] rbtree: add const qualifier to some functions
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Jan 2009 15:38:38.0755 (UTC) FILETIME=[2D238730:01C971A7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From af4d3261cca8da5419f8e2e148a973ae31483a03 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date: Thu, 8 Jan 2009 11:18:23 +0200
Subject: [PATCH] rbtree: add const qualifier to some functions
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

The 'rb_first()', 'rb_last()', 'rb_next()' and 'rb_prev()' calls
take a pointer to an RB node or RB root. They do not change the
pointed objects, so add a 'const' qualifier in order to make life
of the users of these functions easier.

Indeed, if I have my own constant pointer &const struct my_type *p,
and I call 'rb_next(&p->rb)', I get a GCC warning:

warning: passing argument 1 of ‘rb_next’ discards qualifiers from pointer target type

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 include/linux/rbtree.h |    8 ++++----
 lib/rbtree.c           |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 344bc34..9c29541 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -140,10 +140,10 @@ extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
 
 /* Find logical next and previous nodes in a tree */
-extern struct rb_node *rb_next(struct rb_node *);
-extern struct rb_node *rb_prev(struct rb_node *);
-extern struct rb_node *rb_first(struct rb_root *);
-extern struct rb_node *rb_last(struct rb_root *);
+extern struct rb_node *rb_next(const struct rb_node *);
+extern struct rb_node *rb_prev(const struct rb_node *);
+extern struct rb_node *rb_first(const struct rb_root *);
+extern struct rb_node *rb_last(const struct rb_root *);
 
 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
 extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
diff --git a/lib/rbtree.c b/lib/rbtree.c
index 48499c2..9956b99 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -292,7 +292,7 @@ EXPORT_SYMBOL(rb_erase);
 /*
  * This function returns the first node (in sort order) of the tree.
  */
-struct rb_node *rb_first(struct rb_root *root)
+struct rb_node *rb_first(const struct rb_root *root)
 {
 	struct rb_node	*n;
 
@@ -305,7 +305,7 @@ struct rb_node *rb_first(struct rb_root *root)
 }
 EXPORT_SYMBOL(rb_first);
 
-struct rb_node *rb_last(struct rb_root *root)
+struct rb_node *rb_last(const struct rb_root *root)
 {
 	struct rb_node	*n;
 
@@ -318,7 +318,7 @@ struct rb_node *rb_last(struct rb_root *root)
 }
 EXPORT_SYMBOL(rb_last);
 
-struct rb_node *rb_next(struct rb_node *node)
+struct rb_node *rb_next(const struct rb_node *node)
 {
 	struct rb_node *parent;
 
@@ -331,7 +331,7 @@ struct rb_node *rb_next(struct rb_node *node)
 		node = node->rb_right; 
 		while (node->rb_left)
 			node=node->rb_left;
-		return node;
+		return (struct rb_node *)node;
 	}
 
 	/* No right-hand children.  Everything down and left is
@@ -347,7 +347,7 @@ struct rb_node *rb_next(struct rb_node *node)
 }
 EXPORT_SYMBOL(rb_next);
 
-struct rb_node *rb_prev(struct rb_node *node)
+struct rb_node *rb_prev(const struct rb_node *node)
 {
 	struct rb_node *parent;
 
@@ -360,7 +360,7 @@ struct rb_node *rb_prev(struct rb_node *node)
 		node = node->rb_left; 
 		while (node->rb_right)
 			node=node->rb_right;
-		return node;
+		return (struct rb_node *)node;
 	}
 
 	/* No left-hand children. Go up till we find an ancestor which
-- 
1.6.0.6

