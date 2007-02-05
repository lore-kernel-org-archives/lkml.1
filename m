Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbXBEOj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbXBEOj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932934AbXBEOj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:39:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbXBEOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:39:57 -0500
Subject: [GFS2] Fix unlink deadlocks [51/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Russell Cattelan <cattelan@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:47:56 +0000
Message-Id: <1170686876.11001.373.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 69a3a75c929f5c38cdc2dea773692aca02bbdb58 Mon Sep 17 00:00:00 2001
From: Russell Cattelan <cattelan@redhat.com>
Date: Mon, 29 Jan 2007 17:13:44 -0600
Subject: [PATCH] [GFS2] Fix unlink deadlocks

Move the glock acquisition to outside of the transactions.

Lock odering must be preserved in order to prevent ABBA
deadlocks. The current gfs2_change_nlink code would tries
to grab the glock after having started a transaction and thus is holding
the log lock. This is inconsistent with other code paths in
gfs that grab the resource group glock prior to staring
a tranactions.

One problem with this fix is that the resource group
lock is always grabbed now even if the inode still has
ref count and can not be marked for unlink.

Signed-off-by: Russell Cattelan <cattelan@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 88fcfb4..0d6831a 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -280,50 +280,6 @@ out:
 	return error;
 }
 
-static int gfs2_change_nlink_i(struct gfs2_inode *ip)
-{
-	struct gfs2_sbd *sdp = ip->i_inode.i_sb->s_fs_info;
-	struct gfs2_inode *rindex = GFS2_I(sdp->sd_rindex);
-	struct gfs2_glock *ri_gl = rindex->i_gl;
-	struct gfs2_rgrpd *rgd;
-	struct gfs2_holder ri_gh, rg_gh;
-	int existing, error;
-
-	/* if we come from rename path, we could have the lock already */
-	existing = gfs2_glock_is_locked_by_me(ri_gl);
-	if (!existing) {
-		error = gfs2_rindex_hold(sdp, &ri_gh);
-		if (error)
-			goto out;
-	}
-
-	/* find the matching rgd */
-	error = -EIO;
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
-	if (!rgd)
-		goto out_norgrp;
-
-	/*
-	 * Eventually we may want to move rgd(s) to a linked list
-	 * and piggyback the free logic into one of gfs2 daemons
-	 * to gain some performance.
-	 */
-	if (!rgd->rd_gl || !gfs2_glock_is_locked_by_me(rgd->rd_gl)) {
-		error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, &rg_gh);
-		if (error)
-			goto out_norgrp;
-
-		gfs2_unlink_di(&ip->i_inode); /* mark inode unlinked */
-		gfs2_glock_dq_uninit(&rg_gh);
-	}
-
-out_norgrp:
-	if (!existing)
-		gfs2_glock_dq_uninit(&ri_gh);
-out:
-	return error;
-}
-
 /**
  * gfs2_change_nlink - Change nlink count on inode
  * @ip: The GFS2 inode
@@ -365,7 +321,7 @@ int gfs2_change_nlink(struct gfs2_inode *ip, int diff)
 	mark_inode_dirty(&ip->i_inode);
 
 	if (ip->i_inode.i_nlink == 0)
-		error = gfs2_change_nlink_i(ip);
+		gfs2_unlink_di(&ip->i_inode); /* mark inode unlinked */
 
 	return error;
 }
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 5591f89..f40a848 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -264,13 +264,23 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
 	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
-	struct gfs2_holder ghs[2];
+	struct gfs2_holder ghs[3];
+	struct gfs2_rgrpd *rgd;
+	struct gfs2_holder ri_gh;
 	int error;
 
+	error = gfs2_rindex_hold(sdp, &ri_gh);
+	if (error)
+		return error;
+
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, ghs + 1);
+	gfs2_holder_init(ip->i_gl,  LM_ST_EXCLUSIVE, 0, ghs + 1);
 
-	error = gfs2_glock_nq_m(2, ghs);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
+	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
+
+
+	error = gfs2_glock_nq_m(3, ghs);
 	if (error)
 		goto out;
 
@@ -291,10 +301,12 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 out_end_trans:
 	gfs2_trans_end(sdp);
 out_gunlock:
-	gfs2_glock_dq_m(2, ghs);
+	gfs2_glock_dq_m(3, ghs);
 out:
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
+	gfs2_holder_uninit(ghs + 2);
+	gfs2_glock_dq_uninit(&ri_gh);
 	return error;
 }
 
@@ -449,13 +461,22 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
 	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
-	struct gfs2_holder ghs[2];
+	struct gfs2_holder ghs[3];
+	struct gfs2_rgrpd *rgd;
+	struct gfs2_holder ri_gh;
 	int error;
 
+
+	error = gfs2_rindex_hold(sdp, &ri_gh);
+	if (error)
+		return error;
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, ghs + 1);
 
-	error = gfs2_glock_nq_m(2, ghs);
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_num.no_addr);
+	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
+
+	error = gfs2_glock_nq_m(3, ghs);
 	if (error)
 		goto out;
 
@@ -483,10 +504,12 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	gfs2_trans_end(sdp);
 
 out_gunlock:
-	gfs2_glock_dq_m(2, ghs);
+	gfs2_glock_dq_m(3, ghs);
 out:
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
+	gfs2_holder_uninit(ghs + 2);
+	gfs2_glock_dq_uninit(&ri_gh);
 	return error;
 }
 
@@ -547,7 +570,8 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	struct gfs2_inode *ip = GFS2_I(odentry->d_inode);
 	struct gfs2_inode *nip = NULL;
 	struct gfs2_sbd *sdp = GFS2_SB(odir);
-	struct gfs2_holder ghs[4], r_gh;
+	struct gfs2_holder ghs[5], r_gh;
+	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
 	int alloc_required;
@@ -587,6 +611,13 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	if (nip) {
 		gfs2_holder_init(nip->i_gl, LM_ST_EXCLUSIVE, 0, ghs + num_gh);
 		num_gh++;
+		/* grab the resource lock for unlink flag twiddling 
+		 * this is the case of the target file already existing
+		 * so we unlink before doing the rename
+		 */
+		nrgd = gfs2_blk2rgrpd(sdp, nip->i_num.no_addr);
+		if (nrgd)
+			gfs2_holder_init(nrgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + num_gh++);
 	}
 
 	error = gfs2_glock_nq_m(num_gh, ghs);
-- 
1.4.4.2



