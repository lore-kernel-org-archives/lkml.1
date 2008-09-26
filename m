Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbYIZMzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbYIZMzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbYIZMy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbYIZMyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:23 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/12] GFS2: rm on multiple nodes causes panic
Date: Fri, 26 Sep 2008 13:00:46 +0100
Message-Id: <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes a problem whereby simultaneous unlink, rmdir,
rename and link operations (e.g. rm -fR *) from multiple nodes
on the same GFS2 file system can cause kernel panics, hangs,
and/or memory corruption.  It also gets rid of all the non-rgrp
calls to gfs2_glock_nq_m.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index e2c62f7..35f6f03 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -159,9 +159,13 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	gfs2_holder_init(dip->i_gl, LM_ST_EXCLUSIVE, 0, ghs);
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, ghs + 1);
 
-	error = gfs2_glock_nq_m(2, ghs);
+	error = gfs2_glock_nq(ghs); /* parent */
 	if (error)
-		goto out;
+		goto out_parent;
+
+	error = gfs2_glock_nq(ghs + 1); /* child */
+	if (error)
+		goto out_child;
 
 	error = gfs2_permission(dir, MAY_WRITE | MAY_EXEC);
 	if (error)
@@ -245,8 +249,10 @@ out_alloc:
 	if (alloc_required)
 		gfs2_alloc_put(dip);
 out_gunlock:
-	gfs2_glock_dq_m(2, ghs);
-out:
+	gfs2_glock_dq(ghs + 1);
+out_child:
+	gfs2_glock_dq(ghs);
+out_parent:
 	gfs2_holder_uninit(ghs);
 	gfs2_holder_uninit(ghs + 1);
 	if (!error) {
@@ -302,7 +308,7 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 
 	error = gfs2_unlink_ok(dip, &dentry->d_name, ip);
 	if (error)
-		goto out_rgrp;
+		goto out_gunlock;
 
 	error = gfs2_trans_begin(sdp, 2*RES_DINODE + RES_LEAF + RES_RG_BIT, 0);
 	if (error)
@@ -316,6 +322,7 @@ static int gfs2_unlink(struct inode *dir, struct dentry *dentry)
 
 out_end_trans:
 	gfs2_trans_end(sdp);
+out_gunlock:
 	gfs2_glock_dq(ghs + 2);
 out_rgrp:
 	gfs2_holder_uninit(ghs + 2);
@@ -485,7 +492,6 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	struct gfs2_holder ri_gh;
 	int error;
 
-
 	error = gfs2_rindex_hold(sdp, &ri_gh);
 	if (error)
 		return error;
@@ -495,9 +501,17 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr);
 	gfs2_holder_init(rgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + 2);
 
-	error = gfs2_glock_nq_m(3, ghs);
+	error = gfs2_glock_nq(ghs); /* parent */
 	if (error)
-		goto out;
+		goto out_parent;
+
+	error = gfs2_glock_nq(ghs + 1); /* child */
+	if (error)
+		goto out_child;
+
+	error = gfs2_glock_nq(ghs + 2); /* rgrp */
+	if (error)
+		goto out_rgrp;
 
 	error = gfs2_unlink_ok(dip, &dentry->d_name, ip);
 	if (error)
@@ -523,11 +537,15 @@ static int gfs2_rmdir(struct inode *dir, struct dentry *dentry)
 	gfs2_trans_end(sdp);
 
 out_gunlock:
-	gfs2_glock_dq_m(3, ghs);
-out:
-	gfs2_holder_uninit(ghs);
-	gfs2_holder_uninit(ghs + 1);
+	gfs2_glock_dq(ghs + 2);
+out_rgrp:
 	gfs2_holder_uninit(ghs + 2);
+	gfs2_glock_dq(ghs + 1);
+out_child:
+	gfs2_holder_uninit(ghs + 1);
+	gfs2_glock_dq(ghs);
+out_parent:
+	gfs2_holder_uninit(ghs);
 	gfs2_glock_dq_uninit(&ri_gh);
 	return error;
 }
@@ -639,9 +657,11 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			gfs2_holder_init(nrgd->rd_gl, LM_ST_EXCLUSIVE, 0, ghs + num_gh++);
 	}
 
-	error = gfs2_glock_nq_m(num_gh, ghs);
-	if (error)
-		goto out_uninit;
+	for (x = 0; x < num_gh; x++) {
+		error = gfs2_glock_nq(ghs + x);
+		if (error)
+			goto out_gunlock;
+	}
 
 	/* Check out the old directory */
 
@@ -804,10 +824,10 @@ out_alloc:
 	if (alloc_required)
 		gfs2_alloc_put(ndip);
 out_gunlock:
-	gfs2_glock_dq_m(num_gh, ghs);
-out_uninit:
-	for (x = 0; x < num_gh; x++)
+	while (x--) {
+		gfs2_glock_dq(ghs + x);
 		gfs2_holder_uninit(ghs + x);
+	}
 out_gunlock_r:
 	if (dir_rename)
 		gfs2_glock_dq_uninit(&r_gh);
-- 
1.5.5.1

