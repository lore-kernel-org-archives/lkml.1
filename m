Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYIXWJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYIXWJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYIXWBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:01:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:52246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYIXWAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:00:39 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 28/39] ocfs2: Determine an extent tree's max_leaf_clusters in an et_op.
Date: Wed, 24 Sep 2008 15:01:09 -0700
Message-Id: <1222293680-15451-29-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

Provide an optional extent_tree_operation to specify the
max_leaf_clusters of an ocfs2_extent_tree.  If not provided, the value
is 0 (unlimited).

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c |   18 +++++++++++++++---
 1 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 0b900f6..7c0721d 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -76,6 +76,8 @@ struct ocfs2_extent_tree_operations {
 	/* These are internal to ocfs2_extent_tree and don't have
 	 * accessor functions */
 	void (*eo_fill_root_el)(struct ocfs2_extent_tree *et);
+	void (*eo_fill_max_leaf_clusters)(struct inode *inode,
+					  struct ocfs2_extent_tree *et);
 };
 
 struct ocfs2_extent_tree {
@@ -205,6 +207,14 @@ static void ocfs2_xattr_tree_fill_root_el(struct ocfs2_extent_tree *et)
 	et->et_root_el = &xb->xb_attrs.xb_root.xt_list;
 }
 
+static void ocfs2_xattr_tree_fill_max_leaf_clusters(struct inode *inode,
+						    struct ocfs2_extent_tree *et)
+{
+	et->et_max_leaf_clusters =
+		ocfs2_clusters_for_bytes(inode->i_sb,
+					 OCFS2_MAX_XATTR_TREE_LEAF_SIZE);
+}
+
 static void ocfs2_xattr_tree_set_last_eb_blk(struct ocfs2_extent_tree *et,
 					     u64 blkno)
 {
@@ -243,6 +253,7 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 	.eo_update_clusters	= ocfs2_xattr_tree_update_clusters,
 	.eo_sanity_check	= ocfs2_xattr_tree_sanity_check,
 	.eo_fill_root_el	= ocfs2_xattr_tree_fill_root_el,
+	.eo_fill_max_leaf_clusters = ocfs2_xattr_tree_fill_max_leaf_clusters,
 };
 
 static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
@@ -254,7 +265,6 @@ static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
 	et->et_type = et_type;
 	get_bh(bh);
 	et->et_root_bh = bh;
-	et->et_max_leaf_clusters = 0;
 	if (!obj)
 		obj = (void *)bh->b_data;
 	et->et_object = obj;
@@ -265,11 +275,13 @@ static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
 		et->et_ops = &ocfs2_xattr_et_ops;
 	} else if (et_type == OCFS2_XATTR_TREE_EXTENT) {
 		et->et_ops = &ocfs2_xattr_tree_et_ops;
-		et->et_max_leaf_clusters = ocfs2_clusters_for_bytes(inode->i_sb,
-						OCFS2_MAX_XATTR_TREE_LEAF_SIZE);
 	}
 
 	et->et_ops->eo_fill_root_el(et);
+	if (!et->et_ops->eo_fill_max_leaf_clusters)
+		et->et_max_leaf_clusters = 0;
+	else
+		et->et_ops->eo_fill_max_leaf_clusters(inode, et);
 }
 
 static void ocfs2_put_extent_tree(struct ocfs2_extent_tree *et)
-- 
1.5.4.5

