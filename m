Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbXLTORz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbXLTORz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932898AbXLTOLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:11:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:56618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880AbXLTOLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:11:32 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:43 2007
Message-Id: <20071220140943.444518117@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:24 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 14/47] Add a struct vfsmount parameter to vfs_rmdir()
Content-Disposition: inline; filename=vfs-rmdir.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c   |    4 +++-
 fs/namei.c            |    4 ++--
 fs/nfsd/nfs4recover.c |    2 +-
 fs/nfsd/vfs.c         |    8 +++++---
 fs/reiserfs/xattr.c   |    2 +-
 fs/unionfs/unlink.c   |    5 ++++-
 include/linux/fs.h    |    2 +-
 7 files changed, 17 insertions(+), 10 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -532,14 +532,16 @@ out:
 static int ecryptfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 	int rc;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	dget(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
 	dget(lower_dentry);
-	rc = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
+	rc = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry, lower_mnt);
 	dput(lower_dentry);
 	if (!rc)
 		d_delete(lower_dentry);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2202,7 +2202,7 @@ void dentry_unhash(struct dentry *dentry
 	spin_unlock(&dcache_lock);
 }
 
-int vfs_rmdir(struct inode *dir, struct dentry *dentry)
+int vfs_rmdir(struct inode *dir, struct dentry *dentry,struct vfsmount *mnt)
 {
 	int error = may_delete(dir, dentry, 1);
 
@@ -2269,7 +2269,7 @@ static long do_rmdir(int dfd, const char
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
-	error = vfs_rmdir(nd.path.dentry->d_inode, dentry);
+	error = vfs_rmdir(nd.path.dentry->d_inode, dentry, nd.path.mnt);
 	mnt_drop_write(nd.path.mnt);
 exit3:
 	dput(dentry);
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -279,7 +279,7 @@ nfsd4_clear_clid_dir(struct dentry *dir,
 	 * a kernel from the future.... */
 	nfsd4_list_rec_dir(dentry, nfsd4_remove_clid_file);
 	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
-	status = vfs_rmdir(dir->d_inode, dentry);
+	status = vfs_rmdir(dir->d_inode, dentry, rec_dir.path.mnt);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	return status;
 }
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1734,6 +1734,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 				char *fname, int flen)
 {
 	struct dentry	*dentry, *rdentry;
+	struct svc_export *exp;
 	struct inode	*dirp;
 	__be32		err;
 	int		host_err;
@@ -1748,6 +1749,7 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 	fh_lock_nested(fhp, I_MUTEX_PARENT);
 	dentry = fhp->fh_dentry;
 	dirp = dentry->d_inode;
+	exp = fhp->fh_export;
 
 	rdentry = lookup_one_len(fname, dentry, flen);
 	host_err = PTR_ERR(rdentry);
@@ -1765,21 +1767,21 @@ nfsd_unlink(struct svc_rqst *rqstp, stru
 
 	if (type != S_IFDIR) { /* It's UNLINK */
 #ifdef MSNFS
-		if ((fhp->fh_export->ex_flags & NFSEXP_MSNFS) &&
+		if ((exp->ex_flags & NFSEXP_MSNFS) &&
 			(atomic_read(&rdentry->d_count) > 1)) {
 			host_err = -EPERM;
 		} else
 #endif
 		host_err = vfs_unlink(dirp, rdentry);
 	} else { /* It's RMDIR */
-		host_err = vfs_rmdir(dirp, rdentry);
+		host_err = vfs_rmdir(dirp, rdentry, exp->ex_path.mnt);
 	}
 
 	dput(rdentry);
 
 	if (host_err)
 		goto out_nfserr;
-	if (EX_ISSYNC(fhp->fh_export))
+	if (EX_ISSYNC(exp))
 		host_err = nfsd_sync_dir(dentry);
 
 out_nfserr:
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -747,7 +747,7 @@ int reiserfs_delete_xattrs(struct inode 
 	if (dir->d_inode->i_nlink <= 2) {
 		root = get_xa_root(inode->i_sb, XATTR_REPLACE);
 		reiserfs_write_lock_xattrs(inode->i_sb);
-		err = vfs_rmdir(root->d_inode, dir);
+		err = vfs_rmdir(root->d_inode, dir, NULL);
 		reiserfs_write_unlock_xattrs(inode->i_sb);
 		dput(root);
 	} else {
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -125,6 +125,7 @@ static int unionfs_rmdir_first(struct in
 {
 	int err;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry = NULL;
 
 	/* Here we need to remove whiteout entries. */
@@ -133,6 +134,7 @@ static int unionfs_rmdir_first(struct in
 		goto out;
 
 	lower_dentry = unionfs_lower_dentry(dentry);
+	lower_mnt = unionfs_lower_mnt(dentry);
 
 	lower_dir_dentry = lock_parent(lower_dentry);
 
@@ -140,7 +142,8 @@ static int unionfs_rmdir_first(struct in
 	dget(lower_dentry);
 	err = is_robranch(dentry);
 	if (!err)
-		err = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry);
+		err = vfs_rmdir(lower_dir_dentry->d_inode, lower_dentry,
+				lower_mnt);
 	dput(lower_dentry);
 
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1074,7 +1074,7 @@ extern int vfs_mkdir(struct inode *, str
 extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, struct vfsmount *, const char *, int);
 extern int vfs_link(struct dentry *, struct vfsmount *, struct inode *, struct dentry *, struct vfsmount *);
-extern int vfs_rmdir(struct inode *, struct dentry *);
+extern int vfs_rmdir(struct inode *, struct dentry *, struct vfsmount *);
 extern int vfs_unlink(struct inode *, struct dentry *);
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *);
 

-- 

