Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbXFZXOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbXFZXOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbXFZXKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:10:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:42893 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759356AbXFZXKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:10:10 -0400
Message-Id: <20070626230920.538876453@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:03 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 07/44] Add a struct vfsmount parameter to vfs_mknod()
Content-Disposition: inline; filename=vfs-mknod.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The vfsmount will be passed down to the LSM hook so that LSMs can compute
pathnames.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/ecryptfs/inode.c |    5 ++++-
 fs/namei.c          |   10 ++++++----
 fs/nfsd/vfs.c       |    3 ++-
 include/linux/fs.h  |    2 +-
 net/unix/af_unix.c  |    2 +-
 5 files changed, 14 insertions(+), 8 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -560,11 +560,14 @@ ecryptfs_mknod(struct inode *dir, struct
 {
 	int rc;
 	struct dentry *lower_dentry;
+	struct vfsmount *lower_mnt;
 	struct dentry *lower_dir_dentry;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
+	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	lower_dir_dentry = lock_parent(lower_dentry);
-	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, mode, dev);
+	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, lower_mnt, mode,
+		       dev);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1855,7 +1855,8 @@ fail:
 }
 EXPORT_SYMBOL_GPL(lookup_create);
 
-int vfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
+int vfs_mknod(struct inode *dir, struct dentry *dentry, struct vfsmount *mnt,
+	      int mode, dev_t dev)
 {
 	int error = may_create(dir, dentry, NULL);
 
@@ -1907,11 +1908,12 @@ asmlinkage long sys_mknodat(int dfd, con
 			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
 			break;
 		case S_IFCHR: case S_IFBLK:
-			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,
-					new_decode_dev(dev));
+			error = vfs_mknod(nd.dentry->d_inode, dentry, nd.mnt,
+					  mode, new_decode_dev(dev));
 			break;
 		case S_IFIFO: case S_IFSOCK:
-			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
+			error = vfs_mknod(nd.dentry->d_inode, dentry, nd.mnt,
+					  mode, 0);
 			break;
 		case S_IFDIR:
 			error = -EPERM;
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1194,7 +1194,8 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
-		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
+		host_err = vfs_mknod(dirp, dchild, exp->ex_mnt, iap->ia_mode,
+				     rdev);
 		break;
 	default:
 	        printk("nfsd: bad file type %o in nfsd_create\n", type);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -994,7 +994,7 @@ extern void unlock_super(struct super_bl
 extern int vfs_permission(struct nameidata *, int);
 extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
 extern int vfs_mkdir(struct inode *, struct dentry *, struct vfsmount *, int);
-extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);
+extern int vfs_mknod(struct inode *, struct dentry *, struct vfsmount *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *);
 extern int vfs_rmdir(struct inode *, struct dentry *);
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -807,7 +807,7 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
-		err = vfs_mknod(nd.dentry->d_inode, dentry, mode, 0);
+		err = vfs_mknod(nd.dentry->d_inode, dentry, nd.mnt, mode, 0);
 		if (err)
 			goto out_mknod_dput;
 		mutex_unlock(&nd.dentry->d_inode->i_mutex);

-- 
