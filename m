Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbXJISJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbXJISJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXJISHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:07:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:35889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbXJISHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:07:42 -0400
Message-Id: <20071009180513.512627357@X40.localnet>
References: <20071009180503.075306583@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Tue, 09 Oct 2007 20:05:10 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: [patch 07/10] Use path_put() in a few places instead of {mnt,d}put()
Content-Disposition: inline; filename=vfs/nameidata-path-4.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use path_put() in a few places instead of {mnt,d}put()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Acked-by: Christoph Hellwig <hch@lst.de>
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
@@ -626,8 +626,7 @@ static __always_inline int __do_follow_l
 		if (dentry->d_inode->i_op->put_link)
 			dentry->d_inode->i_op->put_link(dentry, nd, cookie);
 	}
-	dput(dentry);
-	mntput(path->mnt);
+	path_put(path);
 
 	return error;
 }
@@ -1034,8 +1033,7 @@ static int fastcall link_path_walk(const
 		result = __link_path_walk(name, nd);
 	}
 
-	dput(save.path.dentry);
-	mntput(save.path.mnt);
+	path_put(&save.path);
 
 	return result;
 }
@@ -1057,8 +1055,7 @@ static int __emul_lookup_dentry(const ch
 
 	if (!nd->path.dentry->d_inode ||
 	    S_ISDIR(nd->path.dentry->d_inode->i_mode)) {
-		struct dentry *old_dentry = nd->path.dentry;
-		struct vfsmount *old_mnt = nd->path.mnt;
+		struct path old_path = nd->path;
 		struct qstr last = nd->last;
 		int last_type = nd->last_type;
 		struct fs_struct *fs = current->fs;
@@ -1074,14 +1071,12 @@ static int __emul_lookup_dentry(const ch
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

