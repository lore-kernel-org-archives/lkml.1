Return-Path: <linux-kernel-owner+w=401wt.eu-S1031394AbXENLi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031394AbXENLi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030371AbXENLdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:33:06 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27933 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759310AbXENLce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:34 -0400
Message-Id: <20070514110612.337329969@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:19 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 12/45] Add struct vfsmount parameters to vfs_link()
Content-Disposition: inline; filename=vfs-link.diff
Sender: linux-kernel-owner@vger.kernel.org
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
 include/linux/fs.h  |    2 +-
 4 files changed, 13 insertions(+), 6 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -411,19 +411,24 @@ static int ecryptfs_link(struct dentry *
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
@@ -2268,7 +2268,7 @@ asmlinkage long sys_symlink(const char _
 	return sys_symlinkat(oldname, AT_FDCWD, newname);
 }
 
-int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_dentry)
+int vfs_link(struct dentry *old_dentry, struct vfsmount *old_mnt, struct inode *dir, struct dentry *new_dentry, struct vfsmount *new_mnt)
 {
 	struct inode *inode = old_dentry->d_inode;
 	int error;
@@ -2346,7 +2346,8 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
-	error = vfs_link(old_nd.dentry, nd.dentry->d_inode, new_dentry);
+	error = vfs_link(old_nd.dentry, old_nd.mnt, nd.dentry->d_inode,
+			 new_dentry, nd.mnt);
 	dput(new_dentry);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1536,7 +1536,8 @@ nfsd_link(struct svc_rqst *rqstp, struct
 	dold = tfhp->fh_dentry;
 	dest = dold->d_inode;
 
-	host_err = vfs_link(dold, dirp, dnew);
+	host_err = vfs_link(dold, tfhp->fh_export->ex_mnt, dirp,
+			    dnew, ffhp->fh_export->ex_mnt);
 	if (!host_err) {
 		if (EX_ISSYNC(ffhp->fh_export)) {
 			err = nfserrno(nfsd_sync_dir(ddir));
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -995,7 +995,7 @@ extern int vfs_create(struct inode *, st
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
-extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
+extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);

-- 
