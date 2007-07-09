Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbXGIQe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbXGIQe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758384AbXGIQYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:24:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758259AbXGIQYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:24:13 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [GFS2] Recovery for lost unlinked inodes
Date: Mon,  9 Jul 2007 17:02:41 +0100
Message-Id: <11839970591207-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11839970573954-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
 <11839969911617-git-send-email-swhiteho@redhat.com>
 <1183996996300-git-send-email-swhiteho@redhat.com>
 <11839969982134-git-send-email-swhiteho@redhat.com>
 <11839970003764-git-send-email-swhiteho@redhat.com>
 <11839970032102-git-send-email-swhiteho@redhat.com>
 <11839970052865-git-send-email-swhiteho@redhat.com>
 <11839970061096-git-send-email-swhiteho@redhat.com>
 <1183997008395-git-send-email-swhiteho@redhat.com>
 <11839970101065-git-send-email-swhiteho@redhat.com>
 <11839970122624-git-send-email-swhiteho@redhat.com>
 <11839970143164-git-send-email-swhiteho@redhat.com>
 <11839970162125-git-send-email-swhiteho@redhat.com>
 <11839970182635-git-send-email-swhiteho@redhat.com>
 <11839970204036-git-send-email-swhiteho@redhat.com>
 <11839970222606-git-send-email-swhiteho@redhat.com>
 <11839970241526-git-send-email-swhiteho@redhat.com>
 <1183997026104-git-send-email-swhiteho@redhat.com>
 <11839970282009-git-send-email-swhiteho@redhat.com>
 <11839970302426-git-send-email-swhiteho@redhat.com>
 <11839970324005-git-send-email-swhiteho@redhat.com>
 <1183997034982-git-send-email-swhiteho@redhat.com>
 <1183997036270-git-send-email-swhiteho@redhat.com>
 <11839970383020-git-send-email-swhiteho@redhat.com>
 <11839970403929-git-send-email-swhiteho@redhat.com>
 <11839970421091-git-send-email-swhiteho@redhat.com>
 <11839970442448-git-send-email-swhiteho@redhat.com>
 <11839970463325-git-send-email-swhiteho@redhat.com>
 <11839970481383-git-send-email-swhiteho@redhat.com>
 <1183997050365-git-send-email-swhiteho@redhat.com>
 <11839970521835-git-send-email-swhiteho@redhat.com>
 <11839970542719-git-send-email-swhiteho@redhat.com>
 <1183997056121-git-send-email-swhiteho@redhat.com>
 <11839970573954-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Under certain circumstances its possible (though rather unlikely) that
inodes which were unlinked by one node while still open on another might
get "lost" in the sense that they don't get deallocated if the node
which held the inode open crashed before it was unlinked.

This patch adds the recovery code which allows automatic deallocation of
the inode if its found during block allocation (the sensible time to
look for such inodes since we are scanning the rgrp's bitmaps anyway at
this time, so it adds no overhead to do this).

Since the inode will have had its i_nlink set to zero, all we need to
trigger recovery is a lookup and an iput(), and the normal deallocation
code takes care of the rest.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index e5069b9..c7c6ec0 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -95,6 +95,8 @@ struct gfs2_rgrpd {
 	u32 rd_last_alloc_data;
 	u32 rd_last_alloc_meta;
 	struct gfs2_sbd *rd_sbd;
+	unsigned long rd_flags;
+#define GFS2_RDF_CHECK        0x0001          /* Need to check for unlinked inodes */
 };
 
 enum gfs2_state_bits {
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 87505f7..cacdb0d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -98,22 +98,8 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, u64 no_addr, unsigned in
 
 	if (inode->i_state & I_NEW) {
 		struct gfs2_sbd *sdp = GFS2_SB(inode);
-		umode_t mode = DT2IF(type);
+		umode_t mode;
 		inode->i_private = ip;
-		inode->i_mode = mode;
-
-		if (S_ISREG(mode)) {
-			inode->i_op = &gfs2_file_iops;
-			inode->i_fop = &gfs2_file_fops;
-			inode->i_mapping->a_ops = &gfs2_file_aops;
-		} else if (S_ISDIR(mode)) {
-			inode->i_op = &gfs2_dir_iops;
-			inode->i_fop = &gfs2_dir_fops;
-		} else if (S_ISLNK(mode)) {
-			inode->i_op = &gfs2_symlink_iops;
-		} else {
-			inode->i_op = &gfs2_dev_iops;
-		}
 
 		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE, &ip->i_gl);
 		if (unlikely(error))
@@ -130,10 +116,44 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, u64 no_addr, unsigned in
 			goto fail_iopen;
 
 		gfs2_glock_put(io_gl);
+
+		/*
+		 * We must read the inode in order to work out its type in
+		 * this case. Note that this doesn't happen often as we normally
+		 * know the type beforehand. This code path only occurs during
+		 * unlinked inode recovery (where it is safe to do this glock,
+		 * which is not true in the general case).
+		 */
+		inode->i_mode = mode = DT2IF(type);
+		if (type == DT_UNKNOWN) {
+			struct gfs2_holder gh;
+			error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+			if (unlikely(error))
+				goto fail_glock;
+			/* Inode is now uptodate */
+			mode = inode->i_mode;
+			gfs2_glock_dq_uninit(&gh);
+		}
+
+		if (S_ISREG(mode)) {
+			inode->i_op = &gfs2_file_iops;
+			inode->i_fop = &gfs2_file_fops;
+			inode->i_mapping->a_ops = &gfs2_file_aops;
+		} else if (S_ISDIR(mode)) {
+			inode->i_op = &gfs2_dir_iops;
+			inode->i_fop = &gfs2_dir_fops;
+		} else if (S_ISLNK(mode)) {
+			inode->i_op = &gfs2_symlink_iops;
+		} else {
+			inode->i_op = &gfs2_dev_iops;
+		}
+
 		unlock_new_inode(inode);
 	}
 
 	return inode;
+fail_glock:
+	gfs2_glock_dq(&ip->i_iopen_gh);
 fail_iopen:
 	gfs2_glock_put(io_gl);
 fail_put:
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 027f6ec..fd3fd90 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -28,6 +28,7 @@
 #include "ops_file.h"
 #include "util.h"
 #include "log.h"
+#include "inode.h"
 
 #define BFITNOENT ((u32)~0)
 
@@ -50,6 +51,9 @@ static const char valid_change[16] = {
 	        1, 0, 0, 0
 };
 
+static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
+                        unsigned char old_state, unsigned char new_state);
+
 /**
  * gfs2_setbit - Set a bit in the bitmaps
  * @buffer: the buffer that holds the bitmaps
@@ -531,6 +535,7 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 
 	rgd->rd_gl->gl_object = rgd;
 	rgd->rd_rg_vn = rgd->rd_gl->gl_vn - 1;
+	rgd->rd_flags |= GFS2_RDF_CHECK;
 	return error;
 }
 
@@ -846,6 +851,37 @@ static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
 }
 
 /**
+ * try_rgrp_unlink - Look for any unlinked, allocated, but unused inodes
+ * @rgd: The rgrp
+ *
+ * Returns: The inode, if one has been found
+ */
+
+static struct inode *try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked)
+{
+	struct inode *inode;
+	u32 goal = 0;
+	u64 ino;
+
+	for(;;) {
+		goal = rgblk_search(rgd, goal, GFS2_BLKST_UNLINKED,
+				    GFS2_BLKST_UNLINKED);
+		if (goal == 0)
+			return 0;
+		ino = goal + rgd->rd_data0;
+		if (ino <= *last_unlinked)
+			continue;
+		*last_unlinked = ino;
+		inode = gfs2_inode_lookup(rgd->rd_sbd->sd_vfs, ino, DT_UNKNOWN);
+		if (!IS_ERR(inode))
+			return inode;
+	}
+
+	rgd->rd_flags &= ~GFS2_RDF_CHECK;
+	return NULL;
+}
+
+/**
  * recent_rgrp_first - get first RG from "recent" list
  * @sdp: The GFS2 superblock
  * @rglast: address of the rgrp used last
@@ -1006,8 +1042,9 @@ static void forward_rgrp_set(struct gfs2_sbd *sdp, struct gfs2_rgrpd *rgd)
  * Returns: errno
  */
 
-static int get_local_rgrp(struct gfs2_inode *ip)
+static struct inode *get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 {
+	struct inode *inode = NULL;
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd, *begin = NULL;
 	struct gfs2_alloc *al = &ip->i_alloc;
@@ -1027,7 +1064,11 @@ static int get_local_rgrp(struct gfs2_inode *ip)
 		case 0:
 			if (try_rgrp_fit(rgd, al))
 				goto out;
+			if (rgd->rd_flags & GFS2_RDF_CHECK)
+				inode = try_rgrp_unlink(rgd, last_unlinked);
 			gfs2_glock_dq_uninit(&al->al_rgd_gh);
+			if (inode)
+				return inode;
 			rgd = recent_rgrp_next(rgd, 1);
 			break;
 
@@ -1036,7 +1077,7 @@ static int get_local_rgrp(struct gfs2_inode *ip)
 			break;
 
 		default:
-			return error;
+			return ERR_PTR(error);
 		}
 	}
 
@@ -1051,7 +1092,11 @@ static int get_local_rgrp(struct gfs2_inode *ip)
 		case 0:
 			if (try_rgrp_fit(rgd, al))
 				goto out;
+			if (rgd->rd_flags & GFS2_RDF_CHECK)
+				inode = try_rgrp_unlink(rgd, last_unlinked);
 			gfs2_glock_dq_uninit(&al->al_rgd_gh);
+			if (inode)
+				return inode;
 			break;
 
 		case GLR_TRYFAILED:
@@ -1059,7 +1104,7 @@ static int get_local_rgrp(struct gfs2_inode *ip)
 			break;
 
 		default:
-			return error;
+			return ERR_PTR(error);
 		}
 
 		rgd = gfs2_rgrpd_get_next(rgd);
@@ -1068,7 +1113,7 @@ static int get_local_rgrp(struct gfs2_inode *ip)
 
 		if (rgd == begin) {
 			if (++loops >= 3)
-				return -ENOSPC;
+				return ERR_PTR(-ENOSPC);
 			if (!skipped)
 				loops++;
 			flags = 0;
@@ -1088,7 +1133,7 @@ out:
 		forward_rgrp_set(sdp, rgd);
 	}
 
-	return 0;
+	return NULL;
 }
 
 /**
@@ -1102,11 +1147,14 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = &ip->i_alloc;
+	struct inode *inode;
 	int error = 0;
+	u64 last_unlinked = 0;
 
 	if (gfs2_assert_warn(sdp, al->al_requested))
 		return -EINVAL;
 
+try_again:
 	/* We need to hold the rindex unless the inode we're using is
 	   the rindex itself, in which case it's already held. */
 	if (ip != GFS2_I(sdp->sd_rindex))
@@ -1117,11 +1165,15 @@ int gfs2_inplace_reserve_i(struct gfs2_inode *ip, char *file, unsigned int line)
 	if (error)
 		return error;
 
-	error = get_local_rgrp(ip);
-	if (error) {
+	inode = get_local_rgrp(ip, &last_unlinked);
+	if (inode) {
 		if (ip != GFS2_I(sdp->sd_rindex))
 			gfs2_glock_dq_uninit(&al->al_ri_gh);
-		return error;
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
+		iput(inode);
+		gfs2_log_flush(sdp, NULL);
+		goto try_again;
 	}
 
 	al->al_file = file;
@@ -1209,7 +1261,7 @@ unsigned char gfs2_get_block_type(struct gfs2_rgrpd *rgd, u64 block)
  */
 
 static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
-			     unsigned char old_state, unsigned char new_state)
+			unsigned char old_state, unsigned char new_state)
 {
 	struct gfs2_bitmap *bi = NULL;
 	u32 length = rgd->rd_length;
@@ -1250,17 +1302,18 @@ static u32 rgblk_search(struct gfs2_rgrpd *rgd, u32 goal,
 		goal = 0;
 	}
 
-	if (gfs2_assert_withdraw(rgd->rd_sbd, x <= length))
-		blk = 0;
+	if (old_state != new_state) {
+		gfs2_assert_withdraw(rgd->rd_sbd, blk != BFITNOENT);
 
-	gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
-	gfs2_setbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
-		    bi->bi_len, blk, new_state);
-	if (bi->bi_clone)
-		gfs2_setbit(rgd, bi->bi_clone + bi->bi_offset,
+		gfs2_trans_add_bh(rgd->rd_gl, bi->bi_bh, 1);
+		gfs2_setbit(rgd, bi->bi_bh->b_data + bi->bi_offset,
 			    bi->bi_len, blk, new_state);
+		if (bi->bi_clone)
+			gfs2_setbit(rgd, bi->bi_clone + bi->bi_offset,
+				    bi->bi_len, blk, new_state);
+	}
 
-	return bi->bi_start * GFS2_NBBY + blk;
+	return (blk == BFITNOENT) ? 0 : (bi->bi_start * GFS2_NBBY) + blk;
 }
 
 /**
-- 
1.5.1.2

