Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbXLTOQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbXLTOQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760749AbXLTOL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760621AbXLTOLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:23 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:43 2007
Message-Id: <20071220140943.151286627@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:22 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 12/47] Add struct vfsmount parameters to vfs_link()
Content-Disposition: inline; filename=vfs-link.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c |    9 +++++++--
 fs/namei.c          |    5 +++--
 fs/nfsd/vfs.c       |    3 ++-
 fs/unionfs/inode.c  |   14 +++++++++++---
 include/linux/fs.h  |    2 +-
 5 files changed, 24 insertions(+), 9 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -401,19 +401,24 @@ static int ecryptfs_link(struct dentry *
 			 struct dentry *new_dentry)
 {
 	struct dentry *lower_old_dentry;
+	struct vfsmount *lower_old_mnt;
 	struct dentry *lower_new_dentry;
+	struct vfsmount *lower_new_mnt;
 	struct dentry *lower_dir_dentry;
 	u64 file_size_save;
 	int rc;
 
 	file_size_save = i_size_read(old_dentry->d_inode);
 	lower_old_dentry = ecryptfs_dentry_to_lower(old_dentry);
+	lower_old_mnt = ecryptfs_dentry_to_lower_mnt(old_dentry);
 	lower_new_dentry = ecryptfs_dentry_to_lower(new_dentry);
+	lower_new_mnt = ecryptfs_dentry_to_lower_mnt(new_dentry);
 	dget(lower_old_dentry);
 	dget(lower_new_dentry);
 	lower_dir_dentry = lock_parent(lower_new_dentry);
-	rc = vfs_link(lower_old_dentry, lower_dir_dentry->d_inode,
-		      lower_new_dentry);
+	rc = vfs_link(lower_old_dentry, lower_old_mnt,
+		      lower_dir_dentry->d_inode, lower_new_dentry,
+		      lower_new_mnt);
 	if (rc || !lower_new_dentry->d_inode)
 		goto out_lock;
 	rc = ecryptfs_interpose(lower_new_dentry, new_dentry, dir->i_sb, 0);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2461,7 +2461,7 @@ asmlinkage long sys_symlink(const char _
 	return sys_symlinkat(oldname, AT_FDCWD, newname);
 }
 
-int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
+int vfs_link(struct dentry *old_dentry, struct vfsmount *old_mnt, struct inode *dir, struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int error;
@@ -2542,7 +2542,8 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_dput;
-	error = vfs_link(old_nd.path.dentry, nd.path.dentry->d_inode, new_dentry);
+	error = vfs_link(old_nd.path.dentry, old_nd.path.mnt,
+			 nd.path.dentry->d_inode, new_dentry, nd.path.mnt);
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	dput(new_dentry);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1596,7 +1596,8 @@ nfsd_link(struct svc_rqst *rqstp, struct
 	dold = tfhp->fh_dentry;
 	dest = dold->d_inode;
 
-	host_err = vfs_link(dold, dirp, dnew);
+	host_err = vfs_link(dold, tfhp->fh_export->ex_path.mnt, dirp,
+			    dnew, ffhp->fh_export->ex_path.mnt);
 	if (!host_err) {
 		if (EX_ISSYNC(ffhp->fh_export)) {
 			err = nfserrno(nfsd_sync_dir(ddir));
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -222,6 +222,7 @@ static int unionfs_link(struct dentry *o
 {
 	int err = 0;
 	struct dentry *lower_old_dentry = NULL;
+	struct vfsmount *lower_old_mnt = NULL;
 	struct dentry *lower_new_dentry = NULL;
 	struct vfsmount *lower_new_mnt = NULL;
 	struct dentry *lower_dir_dentry = NULL;
@@ -293,14 +294,17 @@ static int unionfs_link(struct dentry *o
 			goto out;
 	}
 	lower_new_dentry = unionfs_lower_dentry(new_dentry);
+	lower_new_mnt = unionfs_lower_mnt(new_dentry);
 	lower_old_dentry = unionfs_lower_dentry(old_dentry);
+	lower_old_mnt = unionfs_lower_mnt(old_dentry);
 
 	BUG_ON(dbstart(old_dentry) != dbstart(new_dentry));
 	lower_dir_dentry = lock_parent(lower_new_dentry);
 	err = is_robranch(old_dentry);
 	if (!err)
-		err = vfs_link(lower_old_dentry, lower_dir_dentry->d_inode,
-			       lower_new_dentry);
+		err = vfs_link(lower_old_dentry, lower_old_mnt,
+			       lower_dir_dentry->d_inode,
+			       lower_new_dentry, lower_new_mnt);
 	unlock_dir(lower_dir_dentry);
 
 docopyup:
@@ -321,12 +325,16 @@ docopyup:
 						       bindex, &lower_new_mnt);
 				lower_old_dentry =
 					unionfs_lower_dentry(old_dentry);
+				lower_old_mnt =
+					unionfs_lower_mnt(old_dentry);
 				lower_dir_dentry =
 					lock_parent(lower_new_dentry);
 				/* do vfs_link */
 				err = vfs_link(lower_old_dentry,
+					       lower_old_mnt,
 					       lower_dir_dentry->d_inode,
-					       lower_new_dentry);
+					       lower_new_dentry,
+					       lower_new_mnt);
 				unlock_dir(lower_dir_dentry);
 				goto check_link;
 			}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1073,7 +1073,7 @@ extern int vfs_create(struct inode *, st
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
-extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
+extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);

-- 

