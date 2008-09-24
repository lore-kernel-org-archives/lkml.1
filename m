Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbYIXWLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbYIXWLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYIXWBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:01:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbYIXWAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:00:40 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 29/39] ocfs2: Create specific get_extent_tree functions.
Date: Wed, 24 Sep 2008 15:01:10 -0700
Message-Id: <1222293680-15451-30-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

A caller knows what kind of extent tree they have.  There's no reason
they have to call ocfs2_get_extent_tree() with a NULL when they could
just as easily call a specific function to their type of extent tree.

Introduce ocfs2_dinode_get_extent_tree(),
ocfs2_xattr_tree_get_extent_tree(), and
ocfs2_xattr_value_get_extent_tree().  They only take the necessary
arguments, calling into the underlying __ocfs2_get_extent_tree() to do
the real work.

__ocfs2_get_extent_tree() is the old ocfs2_get_extent_tree(), but
without needing any switch-by-type logic.

ocfs2_get_extent_tree() is now a wrapper around the specific calls.  It
exists because a couple alloc.c functions can take et_type.  This will
go later.

Another benefit is that ocfs2_xattr_value_get_extent_tree() can take a
struct ocfs2_xattr_value_root* instead of void*.  This gives us
typechecking where we didn't have it before.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c |   76 +++++++++++++++++++++++++++++++++++++++---------------
 fs/ocfs2/alloc.h |    2 +-
 2 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 7c0721d..243bacf 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -192,7 +192,7 @@ static int ocfs2_xattr_value_sanity_check(struct inode *inode,
 	return 0;
 }
 
-static struct ocfs2_extent_tree_operations ocfs2_xattr_et_ops = {
+static struct ocfs2_extent_tree_operations ocfs2_xattr_value_et_ops = {
 	.eo_set_last_eb_blk	= ocfs2_xattr_value_set_last_eb_blk,
 	.eo_get_last_eb_blk	= ocfs2_xattr_value_get_last_eb_blk,
 	.eo_update_clusters	= ocfs2_xattr_value_update_clusters,
@@ -256,27 +256,21 @@ static struct ocfs2_extent_tree_operations ocfs2_xattr_tree_et_ops = {
 	.eo_fill_max_leaf_clusters = ocfs2_xattr_tree_fill_max_leaf_clusters,
 };
 
-static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
-				  struct inode *inode,
-				  struct buffer_head *bh,
-				  enum ocfs2_extent_tree_type et_type,
-				  void *obj)
+static void __ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
+				    struct inode *inode,
+				    struct buffer_head *bh,
+				    void *obj,
+				    enum ocfs2_extent_tree_type et_type,
+				    struct ocfs2_extent_tree_operations *ops)
 {
 	et->et_type = et_type;
+	et->et_ops = ops;
 	get_bh(bh);
 	et->et_root_bh = bh;
 	if (!obj)
 		obj = (void *)bh->b_data;
 	et->et_object = obj;
 
-	if (et_type == OCFS2_DINODE_EXTENT) {
-		et->et_ops = &ocfs2_dinode_et_ops;
-	} else if (et_type == OCFS2_XATTR_VALUE_EXTENT) {
-		et->et_ops = &ocfs2_xattr_et_ops;
-	} else if (et_type == OCFS2_XATTR_TREE_EXTENT) {
-		et->et_ops = &ocfs2_xattr_tree_et_ops;
-	}
-
 	et->et_ops->eo_fill_root_el(et);
 	if (!et->et_ops->eo_fill_max_leaf_clusters)
 		et->et_max_leaf_clusters = 0;
@@ -284,6 +278,49 @@ static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
 		et->et_ops->eo_fill_max_leaf_clusters(inode, et);
 }
 
+static void ocfs2_get_dinode_extent_tree(struct ocfs2_extent_tree *et,
+					 struct inode *inode,
+					 struct buffer_head *bh)
+{
+	__ocfs2_get_extent_tree(et, inode, bh, NULL, OCFS2_DINODE_EXTENT,
+				&ocfs2_dinode_et_ops);
+}
+
+static void ocfs2_get_xattr_tree_extent_tree(struct ocfs2_extent_tree *et,
+					     struct inode *inode,
+					     struct buffer_head *bh)
+{
+	__ocfs2_get_extent_tree(et, inode, bh, NULL,
+				OCFS2_XATTR_TREE_EXTENT,
+				&ocfs2_xattr_tree_et_ops);
+}
+
+static void ocfs2_get_xattr_value_extent_tree(struct ocfs2_extent_tree *et,
+					     struct inode *inode,
+					     struct buffer_head *bh,
+					     struct ocfs2_xattr_value_root *xv)
+{
+	__ocfs2_get_extent_tree(et, inode, bh, xv,
+				OCFS2_XATTR_VALUE_EXTENT,
+				&ocfs2_xattr_value_et_ops);
+}
+
+static void ocfs2_get_extent_tree(struct ocfs2_extent_tree *et,
+				  struct inode *inode,
+				  struct buffer_head *bh,
+				  enum ocfs2_extent_tree_type et_type,
+				  void *obj)
+{
+	if (et_type == OCFS2_DINODE_EXTENT)
+		ocfs2_get_dinode_extent_tree(et, inode, bh);
+	else if (et_type == OCFS2_XATTR_VALUE_EXTENT)
+		ocfs2_get_xattr_tree_extent_tree(et, inode, bh);
+	else if (et_type == OCFS2_XATTR_TREE_EXTENT)
+		ocfs2_get_xattr_value_extent_tree(et, inode, bh, obj);
+	else
+		BUG();
+}
+
 static void ocfs2_put_extent_tree(struct ocfs2_extent_tree *et)
 {
 	brelse(et->et_root_bh);
@@ -4441,8 +4478,7 @@ int ocfs2_dinode_insert_extent(struct ocfs2_super *osb,
 	int status;
 	struct ocfs2_extent_tree et;
 
-	ocfs2_get_extent_tree(&et, inode, root_bh, OCFS2_DINODE_EXTENT,
-			      NULL);
+	ocfs2_get_dinode_extent_tree(&et, inode, root_bh);
 	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
 				     cpos, start_blk, new_clusters,
 				     flags, meta_ac, &et);
@@ -4460,13 +4496,12 @@ int ocfs2_xattr_value_insert_extent(struct ocfs2_super *osb,
 				    u32 new_clusters,
 				    u8 flags,
 				    struct ocfs2_alloc_context *meta_ac,
-				    void *obj)
+				    struct ocfs2_xattr_value_root *xv)
 {
 	int status;
 	struct ocfs2_extent_tree et;
 
-	ocfs2_get_extent_tree(&et, inode, root_bh,
-			      OCFS2_XATTR_VALUE_EXTENT, obj);
+	ocfs2_get_xattr_value_extent_tree(&et, inode, root_bh, xv);
 	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
 				     cpos, start_blk, new_clusters,
 				     flags, meta_ac, &et);
@@ -4488,8 +4523,7 @@ int ocfs2_xattr_tree_insert_extent(struct ocfs2_super *osb,
 	int status;
 	struct ocfs2_extent_tree et;
 
-	ocfs2_get_extent_tree(&et, inode, root_bh, OCFS2_XATTR_TREE_EXTENT,
-			      NULL);
+	ocfs2_get_xattr_tree_extent_tree(&et, inode, root_bh);
 	status = ocfs2_insert_extent(osb, handle, inode, root_bh,
 				     cpos, start_blk, new_clusters,
 				     flags, meta_ac, &et);
diff --git a/fs/ocfs2/alloc.h b/fs/ocfs2/alloc.h
index ff40c8f..04a551f 100644
--- a/fs/ocfs2/alloc.h
+++ b/fs/ocfs2/alloc.h
@@ -56,7 +56,7 @@ int ocfs2_xattr_value_insert_extent(struct ocfs2_super *osb,
 				    u32 new_clusters,
 				    u8 flags,
 				    struct ocfs2_alloc_context *meta_ac,
-				    void *private);
+				    struct ocfs2_xattr_value_root *xv);
 int ocfs2_xattr_tree_insert_extent(struct ocfs2_super *osb,
 				   handle_t *handle,
 				   struct inode *inode,
-- 
1.5.4.5

