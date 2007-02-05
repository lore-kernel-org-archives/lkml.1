Return-Path: <linux-kernel-owner+w=401wt.eu-S932740AbXBEOOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbXBEOOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbXBEOOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:14:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740AbXBEON6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:13:58 -0500
Subject: [GFS2] Fix gfs2_rename deadlock [16/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "S. Wendy Cheng" <wcheng@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:22:02 +0000
Message-Id: <1170685322.11001.302.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 10728f781249cf02a1e3de8699744c7b48ae544f Mon Sep 17 00:00:00 2001
From: S. Wendy Cheng <wcheng@redhat.com>
Date: Thu, 18 Jan 2007 16:07:03 -0500
Subject: [PATCH] [GFS2] Fix gfs2_rename deadlock

Second round of gfs2_rename lock re-ordering to allow Anaconda adding
root partition on top of gfs2. Previous to this patch the recursive
lock detector in glock.c can be triggered due to attempting to lock
the rgrp twice. This fixes it by checking to see whether the rgrp
is already locked.

This fixes Red Hat bugzilla #221237

Signed-off-by: S. Wendy Cheng <wcheng@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index bab338f..58c2ce7 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -281,13 +281,13 @@ out:
 }
 
 /**
- * gfs2_change_nlink_i - Change nlink count on inode
+ * gfs2_change_nlink - Change nlink count on inode
  * @ip: The GFS2 inode
  * @diff: The change in the nlink count required
  *
  * Returns: errno
  */
-int gfs2_change_nlink_i(struct gfs2_inode *ip, int diff)
+int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
 {
 	struct buffer_head *dibh;
 	u32 nlink;
@@ -320,40 +320,52 @@ int gfs2_change_nlink_i(struct gfs2_inode *ip, int diff)
 	brelse(dibh);
 	mark_inode_dirty(&ip->i_inode);
 
+	if (ip->i_inode.i_nlink == 0)
+		error = gfs2_change_nlink_i(ip);
+
 	return error;
 }
 
-int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
+int gfs2_change_nlink_i(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = ip->i_inode.i_sb->s_fs_info;
-	int error;
-
-	/* update the nlink */
-	error = gfs2_change_nlink_i(ip, diff);
-	if (error)
-		return error;
-
-	/* return meta data block back to rg */
-	if (ip->i_inode.i_nlink == 0) {
-		struct gfs2_rgrpd *rgd;
-		struct gfs2_holder ri_gh, rg_gh;
+	struct gfs2_inode *rindex = GFS2_I(sdp->sd_rindex);
+	struct gfs2_glock *ri_gl = rindex->i_gl;
+	struct gfs2_rgrpd *rgd;
+	struct gfs2_holder ri_gh, rg_gh;
+	int existing, error;
 
+	/* if we come from rename path, we could have the lock already */
+	existing = gfs2_glock_is_locked_by_me(ri_gl);
+	if (!existing) {
 		error = gfs2_rindex_hold(sdp, &ri_gh);
 		if (error)
 			goto out;
-		error = -EIO;
-		rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
-		if (!rgd)
-			goto out_norgrp;
+	}
+
+	/* find the matching rgd */
+	error = -EIO;
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
+	if (!rgd)
+		goto out_norgrp;
+
+	/*
+	 * Eventually we may want to move rgd(s) to a linked list
+	 * and piggyback the free logic into one of gfs2 daemons
+	 * to gain some performance.
+	 */
+	if (!rgd->rd_gl || !gfs2_glock_is_locked_by_me(rgd->rd_gl)) {
 		error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, &rg_gh);
 		if (error)
 			goto out_norgrp;
 
 		gfs2_unlink_di(&ip->i_inode); /* mark inode unlinked */
 		gfs2_glock_dq_uninit(&rg_gh);
+	}
+
 out_norgrp:
+	if (!existing)
 		gfs2_glock_dq_uninit(&ri_gh);
-	}
 out:
 	return error;
 }
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 85c67cb..cee281b 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -40,7 +40,7 @@ int gfs2_inode_refresh(struct gfs2_inode *ip);
 
 int gfs2_dinode_dealloc(struct gfs2_inode *inode);
 int gfs2_change_nlink(struct gfs2_inode *ip, int diff);
-int gfs2_change_nlink_i(struct gfs2_inode *ip, int diff);
+int gfs2_change_nlink_i(struct gfs2_inode *ip);
 struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 			   int is_root, struct nameidata *nd);
 struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 919e894..b2a12f4 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -553,7 +553,6 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	int alloc_required;
 	unsigned int x;
 	int error;
-	struct gfs2_rgrpd *rgd;
 
 	if (ndentry->d_inode) {
 		nip = GFS2_I(ndentry->d_inode);
@@ -685,12 +684,12 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		error = gfs2_trans_begin(sdp, sdp->sd_max_dirres +
 					 al->al_rgd->rd_ri.ri_length +
 					 4 * RES_DINODE + 4 * RES_LEAF +
-					 RES_STATFS + RES_QUOTA + 1, 0);
+					 RES_STATFS + RES_QUOTA + 4, 0);
 		if (error)
 			goto out_ipreserv;
 	} else {
 		error = gfs2_trans_begin(sdp, 4 * RES_DINODE +
-					 5 * RES_LEAF + 1, 0);
+					 5 * RES_LEAF + 4, 0);
 		if (error)
 			goto out_gunlock;
 	}
@@ -704,25 +703,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			error = gfs2_dir_del(ndip, &ndentry->d_name);
 			if (error)
 				goto out_end_trans;
-			error = gfs2_change_nlink_i(nip, -1);
-			if ((!error) && (nip->i_inode.i_nlink == 0)) {
-				error = -EIO;
-				rgd = gfs2_blk2rgrpd(sdp, nip->i_num.no_addr);
-				if (rgd) {
-					struct gfs2_holder nlink_rg_gh;
-					if (rgd != nip->i_alloc.al_rgd)
-						error = gfs2_glock_nq_init(
-						rgd->rd_gl, LM_ST_EXCLUSIVE,
-						0, &nlink_rg_gh);
-					else
-						error = 0;
-                			if (!error) {
-						gfs2_unlink_di(&nip->i_inode);
-						if (rgd != nip->i_alloc.al_rgd)
-							gfs2_glock_dq_uninit(&nlink_rg_gh);
-					}
-				}
-			}
+			error = gfs2_change_nlink(nip, -1);
 		}
 		if (error)
 			goto out_end_trans;
-- 
1.4.4.2



