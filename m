Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZIJKaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZIJKaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZIJKaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbZIJKaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:30:05 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 14/15] GFS2: Be extra careful about deallocating inodes
Date: Thu, 10 Sep 2009 12:28:06 +0100
Message-Id: <1252582087-10007-15-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-14-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-9-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-10-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-11-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-12-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-13-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-14-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential race in the inode deallocation code if two
nodes try to deallocate the same inode at the same time. Most of
the issue is solved by the iopen locking. There is still a small
window which is not covered by the iopen lock. This patches fixes
that and also makes the deallocation code more robust in the face of
any errors in the rgrp bitmaps, or erroneous iopen callbacks from
other nodes.

This does introduce one extra disk read, but that is generally not
an issue since its the same block that must be written to later
in the deallocation process. The total disk accesses therefore stay
the same,

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/export.c |   36 ++++--------------------------------
 fs/gfs2/rgrp.c   |   42 +++++++++++++++++++++++++++++++++++++++++-
 fs/gfs2/rgrp.h   |    4 ++--
 fs/gfs2/super.c  |    4 ++++
 4 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index 9200ef2..d15876e 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -143,17 +143,14 @@ static struct dentry *gfs2_get_parent(struct dentry *child)
 }
 
 static struct dentry *gfs2_get_dentry(struct super_block *sb,
-		struct gfs2_inum_host *inum)
+				      struct gfs2_inum_host *inum)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
-	struct gfs2_holder i_gh, ri_gh, rgd_gh;
-	struct gfs2_rgrpd *rgd;
+	struct gfs2_holder i_gh;
 	struct inode *inode;
 	struct dentry *dentry;
 	int error;
 
-	/* System files? */
-
 	inode = gfs2_ilookup(sb, inum->no_addr);
 	if (inode) {
 		if (GFS2_I(inode)->i_no_formal_ino != inum->no_formal_ino) {
@@ -168,29 +165,11 @@ static struct dentry *gfs2_get_dentry(struct super_block *sb,
 	if (error)
 		return ERR_PTR(error);
 
-	error = gfs2_rindex_hold(sdp, &ri_gh);
+	error = gfs2_check_blk_type(sdp, inum->no_addr, GFS2_BLKST_DINODE);
 	if (error)
 		goto fail;
 
-	error = -EINVAL;
-	rgd = gfs2_blk2rgrpd(sdp, inum->no_addr);
-	if (!rgd)
-		goto fail_rindex;
-
-	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_SHARED, 0, &rgd_gh);
-	if (error)
-		goto fail_rindex;
-
-	error = -ESTALE;
-	if (gfs2_get_block_type(rgd, inum->no_addr) != GFS2_BLKST_DINODE)
-		goto fail_rgd;
-
-	gfs2_glock_dq_uninit(&rgd_gh);
-	gfs2_glock_dq_uninit(&ri_gh);
-
-	inode = gfs2_inode_lookup(sb, DT_UNKNOWN,
-					inum->no_addr,
-					0, 0);
+	inode = gfs2_inode_lookup(sb, DT_UNKNOWN, inum->no_addr, 0, 0);
 	if (IS_ERR(inode)) {
 		error = PTR_ERR(inode);
 		goto fail;
@@ -224,13 +203,6 @@ out_inode:
 	if (!IS_ERR(dentry))
 		dentry->d_op = &gfs2_dops;
 	return dentry;
-
-fail_rgd:
-	gfs2_glock_dq_uninit(&rgd_gh);
-
-fail_rindex:
-	gfs2_glock_dq_uninit(&ri_gh);
-
 fail:
 	gfs2_glock_dq_uninit(&i_gh);
 	return ERR_PTR(error);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 388a61d..caaa665 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1256,7 +1256,7 @@ void gfs2_inplace_release(struct gfs2_inode *ip)
  * Returns: The block type (GFS2_BLKST_*)
  */
 
-unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
+static unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
 {
 	struct gfs2_bitmap *bi = NULL;
 	u32 length, rgrp_block, buf_block;
@@ -1694,6 +1694,46 @@ void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip)
 }
 
 /**
+ * gfs2_check_blk_type - Check the type of a block
+ * @sdp: The superblock
+ * @no_addr: The block number to check
+ * @type: The block type we are looking for
+ *
+ * Returns: 0 if the block type matches the expected type
+ *          -ESTALE if it doesn't match
+ *          or -ve errno if something went wrong while checking
+ */
+
+int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr, unsigned int type)
+{
+	struct gfs2_rgrpd *rgd;
+	struct gfs2_holder ri_gh, rgd_gh;
+	int error;
+
+	error = gfs2_rindex_hold(sdp, &ri_gh);
+	if (error)
+		goto fail;
+
+	error = -EINVAL;
+	rgd = gfs2_blk2rgrpd(sdp, no_addr);
+	if (!rgd)
+		goto fail_rindex;
+
+	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_SHARED, 0, &rgd_gh);
+	if (error)
+		goto fail_rindex;
+
+	if (gfs2_get_block_type(rgd, no_addr) != type)
+		error = -ESTALE;
+
+	gfs2_glock_dq_uninit(&rgd_gh);
+fail_rindex:
+	gfs2_glock_dq_uninit(&ri_gh);
+fail:
+	return error;
+}
+
+/**
  * gfs2_rlist_add - add a RG to a list of RGs
  * @sdp: the filesystem
  * @rlist: the list of resource groups
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index a8dedd7..b4106dd 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -44,8 +44,6 @@ gfs2_inplace_reserve_i((ip), __FILE__, __LINE__)
 
 extern void gfs2_inplace_release(struct gfs2_inode *ip);
 
-extern unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block);
-
 extern int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n);
 extern int gfs2_alloc_di(struct gfs2_inode *ip, u64 *bn, u64 *generation);
 
@@ -53,6 +51,8 @@ extern void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
 extern void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip);
 extern void gfs2_unlink_di(struct inode *inode);
+extern int gfs2_check_blk_type(struct gfs2_sbd *sdp, u64 no_addr,
+			       unsigned int type);
 
 struct gfs2_rgrp_list {
 	unsigned int rl_rgrps;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d95cf77..0ec3ec6 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1286,6 +1286,10 @@ static void gfs2_delete_inode(struct inode *inode)
 		goto out;
 	}
 
+	error = gfs2_check_blk_type(sdp, ip->i_no_addr, GFS2_BLKST_UNLINKED);
+	if (error)
+		goto out_truncate;
+
 	gfs2_glock_dq_wait(&ip->i_iopen_gh);
 	gfs2_holder_reinit(LM_ST_EXCLUSIVE, LM_FLAG_TRY_1CB | GL_NOCACHE, &ip->i_iopen_gh);
 	error = gfs2_glock_nq(&ip->i_iopen_gh);
-- 
1.6.2.5

