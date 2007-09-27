Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbXI0OLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbXI0OLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbXI0OJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:09:49 -0400
Received: from ns2.suse.de ([195.135.220.15]:55084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbXI0OJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:09:44 -0400
Message-Id: <20070927141228.602149616@X40.localnet>
References: <20070927141200.820970144@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Thu, 27 Sep 2007 16:12:07 +0200
From: jblunck@suse.de
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@lst.de, agruen@suse.de, tiwai@suse.de
Subject: [patch 07/10] Use path_put() in a few places instead of {mnt,d}put()
Content-Disposition: inline; filename=nameidata-path-4.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use path_put() in a few places instead of {mnt,d}put()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
---
 fs/afs/mntpt.c |    3 +--
 fs/namei.c     |   15 +++++----------
 2 files changed, 6 insertions(+), 12 deletions(-)

Index: b/fs/afs/mntpt.c
===================================================================
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -235,8 +235,7 @@ static void *afs_mntpt_follow_link(struc
 	err = do_add_mount(newmnt, nd, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		dput(nd->path.dentry);
-		mntput(nd->path.mnt);
+		path_put(&nd->path);
 		nd->path.mnt = newmnt;
 		nd->path.dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
Index: b/fs/namei.c
===================================================================
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -610,8 +610,7 @@ static __always_inline int __do_follow_l
 		if (dentry->d_inode->i_op->put_link)
 			dentry->d_inode->i_op->put_link(dentry, nd, cookie);
 	}
-	dput(dentry);
-	mntput(path->mnt);
+	path_put(path);
 
 	return error;
 }
@@ -1018,8 +1017,7 @@ static int fastcall link_path_walk(const
 		result = __link_path_walk(name, nd);
 	}
 
-	dput(save.path.dentry);
-	mntput(save.path.mnt);
+	path_put(&save.path);
 
 	return result;
 }
@@ -1041,8 +1039,7 @@ static int __emul_lookup_dentry(const ch
 
 	if (!nd->path.dentry->d_inode ||
 	    S_ISDIR(nd->path.dentry->d_inode->i_mode)) {
-		struct dentry *old_dentry = nd->path.dentry;
-		struct vfsmount *old_mnt = nd->path.mnt;
+		struct path old_path = nd->path;
 		struct qstr last = nd->last;
 		int last_type = nd->last_type;
 		struct fs_struct *fs = current->fs;
@@ -1058,14 +1055,12 @@ static int __emul_lookup_dentry(const ch
 		read_unlock(&fs->lock);
 		if (path_walk(name, nd) == 0) {
 			if (nd->path.dentry->d_inode) {
-				dput(old_dentry);
-				mntput(old_mnt);
+				path_put(&old_path);
 				return 1;
 			}
 			path_put(&nd->path);
 		}
-		nd->path.dentry = old_dentry;
-		nd->path.mnt = old_mnt;
+		nd->path = old_path;
 		nd->last = last;
 		nd->last_type = last_type;
 	}

-- 

