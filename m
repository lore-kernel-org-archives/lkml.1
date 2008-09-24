Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbYIXWKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbYIXWKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYIXWBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:01:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbYIXWAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:00:42 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: joel.becker@oracle.com, ocfs2-devel@oss.oracle.com,
       linux-fsdevel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 32/39] ocfs2: Comment struct ocfs2_extent_tree_operations.
Date: Wed, 24 Sep 2008 15:01:13 -0700
Message-Id: <1222293680-15451-33-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

struct ocfs2_extent_tree_operations provides methods for the different
on-disk btrees in ocfs2.  Describing what those methods do is probably a
good idea.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/alloc.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index d196d40..51c3183 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -50,21 +50,62 @@
 #include "buffer_head_io.h"
 
 
+/*
+ * Operations for a specific extent tree type.
+ *
+ * To implement an on-disk btree (extent tree) type in ocfs2, add
+ * an ocfs2_extent_tree_operations structure and the matching
+ * ocfs2_get_<thingy>_extent_tree() function.  That's pretty much it
+ * for the allocation portion of the extent tree.
+ */
 struct ocfs2_extent_tree_operations {
+	/*
+	 * last_eb_blk is the block number of the right most leaf extent
+	 * block.  Most on-disk structures containing an extent tree store
+	 * this value for fast access.  The ->eo_set_last_eb_blk() and
+	 * ->eo_get_last_eb_blk() operations access this value.  They are
+	 *  both required.
+	 */
 	void (*eo_set_last_eb_blk)(struct ocfs2_extent_tree *et,
 				   u64 blkno);
 	u64 (*eo_get_last_eb_blk)(struct ocfs2_extent_tree *et);
+
+	/*
+	 * The on-disk structure usually keeps track of how many total
+	 * clusters are stored in this extent tree.  This function updates
+	 * that value.  new_clusters is the delta, and must be
+	 * added to the total.  Required.
+	 */
 	void (*eo_update_clusters)(struct inode *inode,
 				   struct ocfs2_extent_tree *et,
 				   u32 new_clusters);
+
+	/*
+	 * If ->eo_insert_check() exists, it is called before rec is
+	 * inserted into the extent tree.  It is optional.
+	 */
 	int (*eo_insert_check)(struct inode *inode,
 			       struct ocfs2_extent_tree *et,
 			       struct ocfs2_extent_rec *rec);
 	int (*eo_sanity_check)(struct inode *inode, struct ocfs2_extent_tree *et);
 
-	/* These are internal to ocfs2_extent_tree and don't have
-	 * accessor functions */
+	/*
+	 * --------------------------------------------------------------
+	 * The remaining are internal to ocfs2_extent_tree and don't have
+	 * accessor functions
+	 */
+
+	/*
+	 * ->eo_fill_root_el() takes et->et_object and sets et->et_root_el.
+	 * It is required.
+	 */
 	void (*eo_fill_root_el)(struct ocfs2_extent_tree *et);
+
+	/*
+	 * ->eo_fill_max_leaf_clusters sets et->et_max_leaf_clusters if
+	 * it exists.  If it does not, et->et_max_leaf_clusters is set
+	 * to 0 (unlimited).  Optional.
+	 */
 	void (*eo_fill_max_leaf_clusters)(struct inode *inode,
 					  struct ocfs2_extent_tree *et);
 };
-- 
1.5.4.5

