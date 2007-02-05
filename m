Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbXBEOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbXBEOeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXBEOd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:33:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905AbXBEOd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:33:58 -0500
Subject: [GFS2] Fix recursive locking attempt with NFS [43/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:41:58 +0000
Message-Id: <1170686518.11001.357.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 57c070ec9322815caaa33f4a669b86fac9002075 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Thu, 25 Jan 2007 17:14:59 +0000
Subject: [PATCH] [GFS2] Fix recursive locking attempt with NFS

In certain cases, its possible for NFS to call the lookup code while
holding the glock (when doing a readdirplus operation) so we need to
check for that and not try and lock the glock twice. This also fixes a
typo in a previous NFS related GFS2 patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index f7c8d31..88fcfb4 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -395,8 +395,10 @@ struct inode *gfs2_lookup_simple(struct inode *dip, const char *name)
  * @is_root: If 1, ignore the caller's permissions
  * @i_gh: An uninitialized holder for the new inode glock
  *
- * There will always be a vnode (Linux VFS inode) for the d_gh inode unless
- * @is_root is true.
+ * This can be called via the VFS filldir function when NFS is doing
+ * a readdirplus and the inode which its intending to stat isn't
+ * already in cache. In this case we must not take the directory glock
+ * again, since the readdir call will have already taken that lock.
  *
  * Returns: errno
  */
@@ -409,8 +411,9 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 	struct gfs2_holder d_gh;
 	struct gfs2_inum_host inum;
 	unsigned int type;
-	int error = 0;
+	int error;
 	struct inode *inode = NULL;
+	int unlock = 0;
 
 	if (!name->len || name->len > GFS2_FNAMESIZE)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -422,9 +425,12 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 		return dir;
 	}
 
-	error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
-	if (error)
-		return ERR_PTR(error);
+	if (gfs2_glock_is_locked_by_me(dip->i_gl) == 0) {
+		error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0, &d_gh);
+		if (error)
+			return ERR_PTR(error);
+		unlock = 1;
+	}
 
 	if (!is_root) {
 		error = permission(dir, MAY_EXEC, NULL);
@@ -439,10 +445,11 @@ struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 	inode = gfs2_inode_lookup(sb, &inum, type);
 
 out:
-	gfs2_glock_dq_uninit(&d_gh);
+	if (unlock)
+		gfs2_glock_dq_uninit(&d_gh);
 	if (error == -ENOENT)
 		return NULL;
-	return inode;
+	return inode ? inode : ERR_PTR(error);
 }
 
 static int pick_formal_ino_1(struct gfs2_sbd *sdp, u64 *formal_ino)
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 747c731..5591f89 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -1018,7 +1018,7 @@ static int gfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	}
 
 	generic_fillattr(inode, stat);
-	if (unlock);
+	if (unlock)
 		gfs2_glock_dq_uninit(&gh);
 
 	return 0;
-- 
1.4.4.2



