Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYDQJn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYDQJn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbYDQJ0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:26:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933679AbYDQJ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:26:06 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 24/48] [GFS2] Merge gfs2_alloc_meta and gfs2_alloc_data
Date: Thu, 17 Apr 2008 09:39:00 +0100
Message-Id: <12084216182363-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1208421617421-git-send-email-swhiteho@redhat.com>
References: 12084214272083-git-send-email-swhiteho@redhat.com
 <12084215642582-git-send-email-swhiteho@redhat.com>
 <1208421571478-git-send-email-swhiteho@redhat.com>
 <12084215742081-git-send-email-swhiteho@redhat.com>
 <12084215763647-git-send-email-swhiteho@redhat.com>
 <12084215781246-git-send-email-swhiteho@redhat.com>
 <12084215802470-git-send-email-swhiteho@redhat.com>
 <12084215833555-git-send-email-swhiteho@redhat.com>
 <12084215851158-git-send-email-swhiteho@redhat.com>
 <120842158797-git-send-email-swhiteho@redhat.com>
 <12084215891940-git-send-email-swhiteho@redhat.com>
 <12084215913125-git-send-email-swhiteho@redhat.com>
 <12084215931509-git-send-email-swhiteho@redhat.com>
 <12084215961690-git-send-email-swhiteho@redhat.com>
 <1208421597980-git-send-email-swhiteho@redhat.com>
 <12084216003676-git-send-email-swhiteho@redhat.com>
 <12084216023999-git-send-email-swhiteho@redhat.com>
 <12084216044123-git-send-email-swhiteho@redhat.com>
 <12084216061172-git-send-email-swhiteho@redhat.com>
 <12084216082638-git-send-email-swhiteho@redhat.com>
 <12084216101961-git-send-email-swhiteho@redhat.com>
 <12084216121811-git-send-email-swhiteho@redhat.com>
 <12084216153016-git-send-email-swhiteho@redhat.com>
 <1208421617421-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Thanks to the preceeding patches, the only difference between
these two functions is their name. We can thus merge them
and call the new function gfs2_alloc_block to reflect the
fact that it can allocate either kind of block.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 651e532..e3a75a2 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -137,7 +137,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 		   and write it out to disk */
 
 		if (isdir) {
-			block = gfs2_alloc_meta(ip);
+			block = gfs2_alloc_block(ip);
 			gfs2_trans_add_unrevoke(GFS2_SB(&ip->i_inode), block, 1);
 			error = gfs2_dir_get_new_buffer(ip, block, &bh);
 			if (error)
@@ -146,7 +146,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 					      dibh, sizeof(struct gfs2_dinode));
 			brelse(bh);
 		} else {
-			block = gfs2_alloc_data(ip);
+			block = gfs2_alloc_block(ip);
 
 			error = gfs2_unstuffer_page(ip, dibh, block, page);
 			if (error)
@@ -205,7 +205,7 @@ static int build_height(struct inode *inode, struct metapath *mp, unsigned heigh
 		return error;
 
 	for(n = 0; n < new_height; n++) {
-		bn = gfs2_alloc_meta(ip);
+		bn = gfs2_alloc_block(ip);
 		gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, 1);
 		mp->mp_bh[n] = gfs2_meta_new(ip->i_gl, bn);
 		gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[n], 1);
@@ -369,12 +369,9 @@ static int lookup_block(struct gfs2_inode *ip, unsigned int height,
 	if (!create)
 		return 0;
 
-	if (height == ip->i_height - 1 && !gfs2_is_dir(ip))
-		*block = gfs2_alloc_data(ip);
-	else {
-		*block = gfs2_alloc_meta(ip);
+	*block = gfs2_alloc_block(ip);
+	if (height != ip->i_height - 1 || gfs2_is_dir(ip))
 		gfs2_trans_add_unrevoke(GFS2_SB(&ip->i_inode), *block, 1);
-	}
 
 	gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[height], 1);
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 55514ee..fbdf319 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -803,7 +803,7 @@ got_dent:
 static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh, u16 depth)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
-	u64 bn = gfs2_alloc_meta(ip);
+	u64 bn = gfs2_alloc_block(ip);
 	struct buffer_head *bh = gfs2_meta_new(ip->i_gl, bn);
 	struct gfs2_leaf *leaf;
 	struct gfs2_dirent *dent;
diff --git a/fs/gfs2/eattr.c b/fs/gfs2/eattr.c
index c7fa0a8..f9f63bc 100644
--- a/fs/gfs2/eattr.c
+++ b/fs/gfs2/eattr.c
@@ -584,7 +584,7 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 	struct gfs2_ea_header *ea;
 	u64 block;
 
-	block = gfs2_alloc_meta(ip);
+	block = gfs2_alloc_block(ip);
 	gfs2_trans_add_unrevoke(sdp, block, 1);
 	*bhp = gfs2_meta_new(ip->i_gl, block);
 	gfs2_trans_add_bh(ip->i_gl, *bhp, 1);
@@ -643,7 +643,7 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 			u64 block;
 			int mh_size = sizeof(struct gfs2_meta_header);
 
-			block = gfs2_alloc_meta(ip);
+			block = gfs2_alloc_block(ip);
 			gfs2_trans_add_unrevoke(sdp, block, 1);
 			bh = gfs2_meta_new(ip->i_gl, block);
 			gfs2_trans_add_bh(ip->i_gl, bh, 1);
@@ -967,7 +967,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	} else {
 		u64 blk;
 
-		blk = gfs2_alloc_meta(ip);
+		blk = gfs2_alloc_block(ip);
 		gfs2_trans_add_unrevoke(sdp, blk, 1);
 		indbh = gfs2_meta_new(ip->i_gl, blk);
 		gfs2_trans_add_bh(ip->i_gl, indbh, 1);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 9f28463..274a2df 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1405,58 +1405,13 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 }
 
 /**
- * gfs2_alloc_data - Allocate a data block
- * @ip: the inode to allocate the data block for
+ * gfs2_alloc_block - Allocate a block
+ * @ip: the inode to allocate the block for
  *
  * Returns: the allocated block
  */
 
-u64 gfs2_alloc_data(struct gfs2_inode *ip)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_alloc *al = ip->i_alloc;
-	struct gfs2_rgrpd *rgd = al->al_rgd;
-	u32 goal, blk;
-	u64 block;
-
-	if (rgrp_contains_block(rgd, ip->i_goal))
-		goal = ip->i_goal - rgd->rd_data0;
-	else
-		goal = rgd->rd_last_alloc;
-
-	blk = rgblk_search(rgd, goal, GFS2_BLKST_FREE, GFS2_BLKST_USED);
-	BUG_ON(blk == BFITNOENT);
-	rgd->rd_last_alloc = blk;
-
-	block = rgd->rd_data0 + blk;
-	ip->i_goal = block;
-
-	gfs2_assert_withdraw(sdp, rgd->rd_rg.rg_free);
-	rgd->rd_rg.rg_free--;
-
-	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
-	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
-
-	al->al_alloced++;
-
-	gfs2_statfs_change(sdp, 0, -1, 0);
-	gfs2_quota_change(ip, +1, ip->i_inode.i_uid, ip->i_inode.i_gid);
-
-	spin_lock(&sdp->sd_rindex_spin);
-	rgd->rd_free_clone--;
-	spin_unlock(&sdp->sd_rindex_spin);
-
-	return block;
-}
-
-/**
- * gfs2_alloc_meta - Allocate a metadata block
- * @ip: the inode to allocate the metadata block for
- *
- * Returns: the allocated block
- */
-
-u64 gfs2_alloc_meta(struct gfs2_inode *ip)
+u64 gfs2_alloc_block(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = ip->i_alloc;
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 5683605..5e66613 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -46,8 +46,7 @@ void gfs2_inplace_release(struct gfs2_inode *ip);
 
 unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block);
 
-u64 gfs2_alloc_data(struct gfs2_inode *ip);
-u64 gfs2_alloc_meta(struct gfs2_inode *ip);
+u64 gfs2_alloc_block(struct gfs2_inode *ip);
 u64 gfs2_alloc_di(struct gfs2_inode *ip, u64 *generation);
 
 void gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen);
-- 
1.5.1.2

