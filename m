Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZIJKcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZIJKcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZIJK3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:29:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbZIJK3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:43 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/15] GFS2: Improve error handling in inode allocation
Date: Thu, 10 Sep 2009 12:27:55 +0100
Message-Id: <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little while back, block allocation was given some improved
error handling which meant that -EIO was returned in the case
of there being a problem in the resource group data. In addition
a message is printed explaning what went wrong and how to fix it.
This extends that error handling so that it also covers inode
allocation too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/inode.c |    2 +-
 fs/gfs2/rgrp.c  |   36 +++++++++++++++++++++++++-----------
 fs/gfs2/rgrp.h  |    2 +-
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 2f94bd7..f9b4fe8 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -731,7 +731,7 @@ static int alloc_dinode(struct gfs2_inode *dip, u64 *no_addr, u64 *generation)
 	if (error)
 		goto out_ipreserv;
 
-	*no_addr = gfs2_alloc_di(dip, generation);
+	error = gfs2_alloc_di(dip, no_addr, generation);
 
 	gfs2_trans_end(sdp);
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index fba7957..3d0193a 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1459,6 +1459,16 @@ int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 	return 0;
 }
 
+static void gfs2_rgrp_error(struct gfs2_rgrpd *rgd)
+{
+	struct gfs2_sbd *sdp = rgd->rd_sbd;
+	fs_warn(sdp, "rgrp %llu has an error, marking it readonly until umount\n",
+	        (unsigned long long)rgd->rd_addr);
+	fs_warn(sdp, "umount on all nodes and run fsck.gfs2 to fix the error\n");
+	gfs2_rgrp_dump(NULL, rgd->rd_gl);
+	rgd->rd_flags |= GFS2_RDF_ERROR;
+}
+
 /**
  * gfs2_alloc_block - Allocate one or more blocks
  * @ip: the inode to allocate the block for
@@ -1520,22 +1530,20 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 	return 0;
 
 rgrp_error:
-	fs_warn(sdp, "rgrp %llu has an error, marking it readonly until umount\n",
-	        (unsigned long long)rgd->rd_addr);
-	fs_warn(sdp, "umount on all nodes and run fsck.gfs2 to fix the error\n");
-	gfs2_rgrp_dump(NULL, rgd->rd_gl);
-	rgd->rd_flags |= GFS2_RDF_ERROR;
+	gfs2_rgrp_error(rgd);
 	return -EIO;
 }
 
 /**
  * gfs2_alloc_di - Allocate a dinode
  * @dip: the directory that the inode is going in
+ * @bn: the block number which is allocated
+ * @generation: the generation number of the inode
  *
- * Returns: the block allocated
+ * Returns: 0 on success or error
  */
 
-u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
+int gfs2_alloc_di(struct gfs2_inode *dip, u64 *bn, u64 *generation)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_alloc *al = dip->i_alloc;
@@ -1546,12 +1554,13 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 
 	blk = rgblk_search(rgd, rgd->rd_last_alloc,
 			   GFS2_BLKST_FREE, GFS2_BLKST_DINODE, &n);
-	BUG_ON(blk == BFITNOENT);
 
-	rgd->rd_last_alloc = blk;
+	/* Since all blocks are reserved in advance, this shouldn't happen */
+	if (blk == BFITNOENT)
+		goto rgrp_error;
 
+	rgd->rd_last_alloc = blk;
 	block = rgd->rd_data0 + blk;
-
 	gfs2_assert_withdraw(sdp, rgd->rd_free);
 	rgd->rd_free--;
 	rgd->rd_dinodes++;
@@ -1568,7 +1577,12 @@ u64 gfs2_alloc_di(struct gfs2_inode *dip, u64 *generation)
 	rgd->rd_free_clone--;
 	spin_unlock(&sdp->sd_rindex_spin);
 	trace_gfs2_block_alloc(dip, block, 1, GFS2_BLKST_DINODE);
-	return block;
+	*bn = block;
+	return 0;
+
+rgrp_error:
+	gfs2_rgrp_error(rgd);
+	return -EIO;
 }
 
 /**
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 1e76ff0..a8dedd7 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -47,7 +47,7 @@ extern void gfs2_inplace_release(struct gfs2_inode *ip);
 extern unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block);
 
 extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
-extern u64 gfs2_alloc_di(struct gfs2_inode *ip, u64 *generation);
+extern int gfs2_alloc_di(struct gfs2_inode *ip, u64 *bn, u64 *generation);
 
 extern void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
-- 
1.6.2.5

