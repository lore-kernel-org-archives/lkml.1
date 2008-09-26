Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYIZM4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYIZM4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYIZMy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:54:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57602 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbYIZMyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:54:25 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
       Peter Staubach <staubach@redhat.com>
Subject: [PATCH 04/12] GFS2: Fix & clean up GFS2 rename
Date: Fri, 26 Sep 2008 13:00:47 +0100
Message-Id: <1222430455-4632-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
References: <1222430455-4632-1-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-2-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-3-git-send-email-swhiteho@redhat.com>
 <1222430455-4632-4-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a locking issue in the rename code by ensuring that we hold
the per sb rename lock over both directory and "other" renames which involve
different parent directories.

At the same time, this moved the (only called from one place) function
gfs2_ok_to_move into the file that its called from, so we can mark it
static. This should make a code a bit easier to follow.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Peter Staubach <staubach@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8b0806a..8752552 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1140,54 +1140,6 @@ int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 	return 0;
 }
 
-/*
- * gfs2_ok_to_move - check if it's ok to move a directory to another directory
- * @this: move this
- * @to: to here
- *
- * Follow @to back to the root and make sure we don't encounter @this
- * Assumes we already hold the rename lock.
- *
- * Returns: errno
- */
-
-int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to)
-{
-	struct inode *dir = &to->i_inode;
-	struct super_block *sb = dir->i_sb;
-	struct inode *tmp;
-	struct qstr dotdot;
-	int error = 0;
-
-	gfs2_str2qstr(&dotdot, "..");
-
-	igrab(dir);
-
-	for (;;) {
-		if (dir == &this->i_inode) {
-			error = -EINVAL;
-			break;
-		}
-		if (dir == sb->s_root->d_inode) {
-			error = 0;
-			break;
-		}
-
-		tmp = gfs2_lookupi(dir, &dotdot, 1);
-		if (IS_ERR(tmp)) {
-			error = PTR_ERR(tmp);
-			break;
-		}
-
-		iput(dir);
-		dir = tmp;
-	}
-
-	iput(dir);
-
-	return error;
-}
-
 /**
  * gfs2_readlinki - return the contents of a symlink
  * @ip: the symlink's inode
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 58f9607..bfd2afc 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -91,7 +91,6 @@ int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
 int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
 		   const struct gfs2_inode *ip);
 int gfs2_permission(struct inode *inode, int mask);
-int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to);
 int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
 int gfs2_glock_nq_atime(struct gfs2_holder *gh);
 int gfs2_setattr_simple(struct gfs2_inode *ip, struct iattr *attr);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 35f6f03..534e1e2 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -589,6 +589,54 @@ static int gfs2_mknod(struct inode *dir, struct dentry *dentry, int mode,
 	return 0;
 }
 
+/*
+ * gfs2_ok_to_move - check if it's ok to move a directory to another directory
+ * @this: move this
+ * @to: to here
+ *
+ * Follow @to back to the root and make sure we don't encounter @this
+ * Assumes we already hold the rename lock.
+ *
+ * Returns: errno
+ */
+
+static int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to)
+{
+	struct inode *dir = &to->i_inode;
+	struct super_block *sb = dir->i_sb;
+	struct inode *tmp;
+	struct qstr dotdot;
+	int error = 0;
+
+	gfs2_str2qstr(&dotdot, "..");
+
+	igrab(dir);
+
+	for (;;) {
+		if (dir == &this->i_inode) {
+			error = -EINVAL;
+			break;
+		}
+		if (dir == sb->s_root->d_inode) {
+			error = 0;
+			break;
+		}
+
+		tmp = gfs2_lookupi(dir, &dotdot, 1);
+		if (IS_ERR(tmp)) {
+			error = PTR_ERR(tmp);
+			break;
+		}
+
+		iput(dir);
+		dir = tmp;
+	}
+
+	iput(dir);
+
+	return error;
+}
+
 /**
  * gfs2_rename - Rename a file
  * @odir: Parent directory of old file name
@@ -607,7 +655,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 	struct gfs2_inode *ip = GFS2_I(odentry->d_inode);
 	struct gfs2_inode *nip = NULL;
 	struct gfs2_sbd *sdp = GFS2_SB(odir);
-	struct gfs2_holder ghs[5], r_gh;
+	struct gfs2_holder ghs[5], r_gh = { .gh_gl = NULL, };
 	struct gfs2_rgrpd *nrgd;
 	unsigned int num_gh;
 	int dir_rename = 0;
@@ -621,19 +669,20 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 			return 0;
 	}
 
-	/* Make sure we aren't trying to move a dirctory into it's subdir */
 
-	if (S_ISDIR(ip->i_inode.i_mode) && odip != ndip) {
-		dir_rename = 1;
-
-		error = gfs2_glock_nq_init(sdp->sd_rename_gl, LM_ST_EXCLUSIVE, 0,
-					   &r_gh);
+	if (odip != ndip) {
+		error = gfs2_glock_nq_init(sdp->sd_rename_gl, LM_ST_EXCLUSIVE,
+					   0, &r_gh);
 		if (error)
 			goto out;
 
-		error = gfs2_ok_to_move(ip, ndip);
-		if (error)
-			goto out_gunlock_r;
+		if (S_ISDIR(ip->i_inode.i_mode)) {
+			dir_rename = 1;
+			/* don't move a dirctory into it's subdir */
+			error = gfs2_ok_to_move(ip, ndip);
+			if (error)
+				goto out_gunlock_r;
+		}
 	}
 
 	num_gh = 1;
@@ -829,7 +878,7 @@ out_gunlock:
 		gfs2_holder_uninit(ghs + x);
 	}
 out_gunlock_r:
-	if (dir_rename)
+	if (r_gh.gh_gl)
 		gfs2_glock_dq_uninit(&r_gh);
 out:
 	return error;
-- 
1.5.5.1

