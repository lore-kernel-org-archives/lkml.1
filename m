Return-Path: <linux-kernel-owner+w=401wt.eu-S939193AbXHJOon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939193AbXHJOon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764448AbXHJOnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:43:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:54772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760908AbXHJOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:43:43 -0400
Message-Id: <20070810143846.930027497@suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 16:22:10 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [patch 2/4] Use pathput in a few more places
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de>
 <20070808193209.GA31354@infradead.org>
 <20070810142208.827949199@suse.de>
Content-Disposition: inline; filename=more-pathput.diff
Replace-Subject: Use pathput in a few more places
Recipient-Cc: Jan Blunck <jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

afs_mntpt_follow_link() actually does mntput before dput, which is wrong.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 fs/afs/mntpt.c |    3 +--
 fs/namei.c     |   15 +++++----------
 2 files changed, 6 insertions(+), 12 deletions(-)

--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -235,8 +235,7 @@ static void *afs_mntpt_follow_link(struc
 	err = do_add_mount(newmnt, nd, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		mntput(nd->lookup.path.mnt);
-		dput(nd->lookup.path.dentry);
+		pathput(&nd->lookup.path);
 		nd->lookup.path.mnt = newmnt;
 		nd->lookup.path.dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -610,8 +610,7 @@ static __always_inline int __do_follow_l
 		if (dentry->d_inode->i_op->put_link)
 			dentry->d_inode->i_op->put_link(dentry, nd, cookie);
 	}
-	dput(dentry);
-	mntput(path->mnt);
+	pathput(path);
 
 	return error;
 }
@@ -1016,8 +1015,7 @@ static int fastcall link_path_walk(const
 		result = __link_path_walk(name, nd);
 	}
 
-	dput(save.lookup.path.dentry);
-	mntput(save.lookup.path.mnt);
+	pathput(&save.lookup.path);
 
 	return result;
 }
@@ -1038,8 +1036,7 @@ static int __emul_lookup_dentry(const ch
 		return 0;		/* something went wrong... */
 
 	if (!nd->lookup.path.dentry->d_inode || S_ISDIR(nd->lookup.path.dentry->d_inode->i_mode)) {
-		struct dentry *old_dentry = nd->lookup.path.dentry;
-		struct vfsmount *old_mnt = nd->lookup.path.mnt;
+		struct path old_path = nd->lookup.path;
 		struct qstr last = nd->last;
 		int last_type = nd->last_type;
 		struct fs_struct *fs = current->fs;
@@ -1055,14 +1052,12 @@ static int __emul_lookup_dentry(const ch
 		read_unlock(&fs->lock);
 		if (path_walk(name, nd) == 0) {
 			if (nd->lookup.path.dentry->d_inode) {
-				dput(old_dentry);
-				mntput(old_mnt);
+				pathput(&old_path);
 				return 1;
 			}
 			pathput(&nd->lookup.path);
 		}
-		nd->lookup.path.dentry = old_dentry;
-		nd->lookup.path.mnt = old_mnt;
+		nd->lookup.path = old_path;
 		nd->last = last;
 		nd->last_type = last_type;
 	}

