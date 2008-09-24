Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbYIXWMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbYIXWMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYIXWBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:01:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:52244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbYIXWAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:00:38 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 27/39] ocfs2: Use struct ocfs2_extent_tree in ocfs2_num_free_extents().
Date: Wed, 24 Sep 2008 15:01:08 -0700
Message-Id: <1222293680-15451-28-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

ocfs2_num_free_extents() re-implements the logic of
ocfs2_get_extent_tree().  Now that ocfs2_get_extent_tree() does not
allocate, let's use it in ocfs2_num_free_extents() to simplify the code.

The inode validation code in ocfs2_num_free_extents() is not needed.
All callers are passing in pre-validated inodes.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c |   30 +++++-------------------------
 1 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index fb6ae67..0b900f6 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -618,34 +618,13 @@ int ocfs2_num_free_extents(struct ocfs2_super *osb,
 	struct ocfs2_extent_block *eb;
 	struct buffer_head *eb_bh = NULL;
 	u64 last_eb_blk = 0;
+	struct ocfs2_extent_tree et;
 
 	mlog_entry_void();
 
-	if (type == OCFS2_DINODE_EXTENT) {
-		struct ocfs2_dinode *fe =
-				(struct ocfs2_dinode *)root_bh->b_data;
-		if (!OCFS2_IS_VALID_DINODE(fe)) {
-			OCFS2_RO_ON_INVALID_DINODE(inode->i_sb, fe);
-			retval = -EIO;
-			goto bail;
-		}
-
-		if (fe->i_last_eb_blk)
-			last_eb_blk = le64_to_cpu(fe->i_last_eb_blk);
-		el = &fe->id2.i_list;
-	} else if (type == OCFS2_XATTR_VALUE_EXTENT) {
-		struct ocfs2_xattr_value_root *xv =
-			(struct ocfs2_xattr_value_root *) obj;
-
-		last_eb_blk = le64_to_cpu(xv->xr_last_eb_blk);
-		el = &xv->xr_list;
-	} else if (type == OCFS2_XATTR_TREE_EXTENT) {
-		struct ocfs2_xattr_block *xb =
-			(struct ocfs2_xattr_block *)root_bh->b_data;
-
-		last_eb_blk = le64_to_cpu(xb->xb_attrs.xb_root.xt_last_eb_blk);
-		el = &xb->xb_attrs.xb_root.xt_list;
-	}
+	ocfs2_get_extent_tree(&et, inode, root_bh, type, obj);
+	el = et.et_root_el;
+	last_eb_blk = ocfs2_et_get_last_eb_blk(&et);
 
 	if (last_eb_blk) {
 		retval = ocfs2_read_block(osb, last_eb_blk,
@@ -665,6 +644,7 @@ bail:
 	if (eb_bh)
 		brelse(eb_bh);
 
+	ocfs2_put_extent_tree(&et);
 	mlog_exit(retval);
 	return retval;
 }
-- 
1.5.4.5

