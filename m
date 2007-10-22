Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXJVHAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXJVHAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXJVG76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:59:58 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:36180 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbXJVG74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:59:56 -0400
Date: Mon, 22 Oct 2007 12:29:53 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Blunck <jblunck@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: [PATCH 07/13] Use path_put() in a few places instead of {mnt,d}put()
Message-ID: <20071022065953.GH6489@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071022065352.GA6489@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065352.GA6489@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Use path_put() in a few places instead of {mnt,d}put()

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Acked-by: Christoph Hellwig <hch@lst.de>
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
-		dput(nd->path.dentry);
-		mntput(nd->path.mnt);
+		path_put(&nd->path);
 		nd->path.mnt = newmnt;
 		nd->path.dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
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
