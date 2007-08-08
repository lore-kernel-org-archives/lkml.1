Return-Path: <linux-kernel-owner+w=401wt.eu-S937783AbXHHRXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937783AbXHHRXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937392AbXHHRTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764641AbXHHRTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:06 -0400
Message-Id: <20070808171644.286775287@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:29 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 07/10] Pass no unnecessary information to iop->create
Content-Disposition: inline; filename=create-args.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vfs_create() and the create inode operation do not need a full nameidata.
Pass a struct vfs_lookup instead.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 fs/9p/vfs_inode.c           |   13 +++++++------
 fs/affs/affs.h              |    2 +-
 fs/affs/namei.c             |    2 +-
 fs/afs/dir.c                |    4 ++--
 fs/bad_inode.c              |    2 +-
 fs/bfs/dir.c                |    2 +-
 fs/cifs/cifsfs.h            |    2 +-
 fs/cifs/dir.c               |   10 +++++-----
 fs/coda/dir.c               |    4 ++--
 fs/ecryptfs/inode.c         |   24 ++++++++++++------------
 fs/exec.c                   |    4 ++--
 fs/ext2/namei.c             |    2 +-
 fs/ext3/namei.c             |    2 +-
 fs/ext4/namei.c             |    2 +-
 fs/fuse/dir.c               |   12 ++++++------
 fs/gfs2/inode.c             |    2 +-
 fs/gfs2/inode.h             |    2 +-
 fs/gfs2/ops_inode.c         |    8 ++++----
 fs/hfs/dir.c                |    2 +-
 fs/hfsplus/dir.c            |    2 +-
 fs/hpfs/namei.c             |    2 +-
 fs/hugetlbfs/inode.c        |    2 +-
 fs/inotify_user.c           |    2 +-
 fs/jffs2/dir.c              |    4 ++--
 fs/jfs/namei.c              |    2 +-
 fs/minix/namei.c            |    2 +-
 fs/msdos/namei.c            |    2 +-
 fs/namei.c                  |   27 +++++++++++++++------------
 fs/ncpfs/dir.c              |    4 ++--
 fs/nfs/dir.c                |   30 +++++++++++++++---------------
 fs/nfs/nfs3proc.c           |    2 +-
 fs/nfs/nfs4proc.c           |   24 ++++++++++++------------
 fs/nfs/proc.c               |    2 +-
 fs/ocfs2/dlm/dlmfs.c        |    2 +-
 fs/ocfs2/namei.c            |    2 +-
 fs/open.c                   |   22 ++++++++++++----------
 fs/qnx4/namei.c             |    2 +-
 fs/ramfs/inode.c            |    2 +-
 fs/reiserfs/namei.c         |    2 +-
 fs/smbfs/dir.c              |    4 ++--
 fs/sysv/namei.c             |    2 +-
 fs/udf/namei.c              |    2 +-
 fs/ufs/namei.c              |    2 +-
 fs/vfat/namei.c             |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c |    2 +-
 include/linux/fs.h          |    4 ++--
 include/linux/namei.h       |    5 +++--
 include/linux/nfs_xdr.h     |    2 +-
 include/linux/qnx4_fs.h     |    2 +-
 ipc/mqueue.c                |    2 +-
 mm/shmem.c                  |    2 +-
 51 files changed, 139 insertions(+), 132 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -459,13 +459,13 @@ error:
  * @inode: directory inode that is being created
  * @dentry:  dentry that is being deleted
  * @mode: create permissions
- * @nd: path information
+ * @lookup: path information
  *
  */
 
 static int
 v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	int err;
 	u32 perm;
@@ -478,8 +478,8 @@ v9fs_vfs_create(struct inode *dir, struc
 	fid = NULL;
 	v9ses = v9fs_inode2v9ses(dir);
 	perm = unixmode2p9mode(v9ses, mode);
-	if (nd && nd->lookup.flags & LOOKUP_OPEN)
-		flags = nd->lookup.intent.open.flags - 1;
+	if (lookup && lookup->flags & LOOKUP_OPEN)
+		flags = lookup->intent.open.flags - 1;
 	else
 		flags = O_RDWR;
 
@@ -492,8 +492,9 @@ v9fs_vfs_create(struct inode *dir, struc
 	}
 
 	/* if we are opening a file, assign the open fid to the file */
-	if (nd && nd->lookup.flags & LOOKUP_OPEN) {
-		filp = lookup_instantiate_filp(nd, dentry, v9fs_open_created);
+	if (lookup && lookup->flags & LOOKUP_OPEN) {
+		filp = lookup_instantiate_filp(lookup, dentry,
+					       v9fs_open_created);
 		if (IS_ERR(filp)) {
 			err = PTR_ERR(filp);
 			goto error;
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -155,7 +155,7 @@ extern void	affs_free_bitmap(struct supe
 extern int	affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len);
 extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *);
 extern int	affs_unlink(struct inode *dir, struct dentry *dentry);
-extern int	affs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *);
+extern int	affs_create(struct inode *dir, struct dentry *dentry, int mode, struct vfs_lookup *);
 extern int	affs_mkdir(struct inode *dir, struct dentry *dentry, int mode);
 extern int	affs_rmdir(struct inode *dir, struct dentry *dentry);
 extern int	affs_link(struct dentry *olddentry, struct inode *dir,
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -243,7 +243,7 @@ affs_unlink(struct inode *dir, struct de
 }
 
 int
-affs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+affs_create(struct inode *dir, struct dentry *dentry, int mode, struct vfs_lookup *lookup)
 {
 	struct super_block *sb = dir->i_sb;
 	struct inode	*inode;
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -29,7 +29,7 @@ static void afs_d_release(struct dentry 
 static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
 				  loff_t fpos, u64 ino, unsigned dtype);
 static int afs_create(struct inode *dir, struct dentry *dentry, int mode,
-		      struct nameidata *nd);
+		      struct vfs_lookup *lookup);
 static int afs_mkdir(struct inode *dir, struct dentry *dentry, int mode);
 static int afs_rmdir(struct inode *dir, struct dentry *dentry);
 static int afs_unlink(struct inode *dir, struct dentry *dentry);
@@ -906,7 +906,7 @@ error:
  * create a regular file on an AFS filesystem
  */
 static int afs_create(struct inode *dir, struct dentry *dentry, int mode,
-		      struct nameidata *nd)
+		      struct vfs_lookup *lookup)
 {
 	struct afs_file_status status;
 	struct afs_callback cb;
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -186,7 +186,7 @@ static const struct file_operations bad_
 };
 
 static int bad_inode_create (struct inode *dir, struct dentry *dentry,
-		int mode, struct nameidata *nd)
+		int mode, struct vfs_lookup *lookup)
 {
 	return -EIO;
 }
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -79,7 +79,7 @@ const struct file_operations bfs_dir_ope
 extern void dump_imap(const char *, struct super_block *);
 
 static int bfs_create(struct inode * dir, struct dentry * dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	int err;
 	struct inode * inode;
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -44,7 +44,7 @@ extern void cifs_read_inode(struct inode
 /* Functions related to inodes */
 extern const struct inode_operations cifs_dir_inode_ops;
 extern int cifs_create(struct inode *, struct dentry *, int,
-		       struct nameidata *);
+		       struct vfs_lookup *);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
 				  struct nameidata *);
 extern int cifs_unlink(struct inode *, struct dentry *);
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -125,7 +125,7 @@ BB remove above eight lines BB */
 
 int
 cifs_create(struct inode *inode, struct dentry *direntry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	int rc = -ENOENT;
 	int xid;
@@ -153,8 +153,8 @@ cifs_create(struct inode *inode, struct 
 		return -ENOMEM;
 	}
 
-	if (nd && (nd->lookup.flags & LOOKUP_OPEN)) {
-		int oflags = nd->lookup.intent.open.flags;
+	if (lookup && (lookup->flags & LOOKUP_OPEN)) {
+		int oflags = lookup->intent.open.flags;
 
 		desiredAccess = 0;
 		if (oflags & FMODE_READ)
@@ -263,8 +263,8 @@ cifs_create(struct inode *inode, struct 
 				direntry->d_op = &cifs_dentry_ops;
 			d_instantiate(direntry, newinode);
 		}
-		if ((nd == NULL /* nfsd case - nfs srv does not set nd */) ||
-			((nd->lookup.flags & LOOKUP_OPEN) == FALSE)) {
+		if ((!lookup /* nfsd case - nfs srv does not set lookup */) ||
+			((lookup->flags & LOOKUP_OPEN) == FALSE)) {
 			/* mknod case - do not leave file open */
 			CIFSSMBClose(xid, pTcon, fileHandle);
 		} else if (newinode) {
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -29,7 +29,7 @@
 #include "coda_int.h"
 
 /* dir inode-ops */
-static int coda_create(struct inode *dir, struct dentry *new, int mode, struct nameidata *nd);
+static int coda_create(struct inode *dir, struct dentry *new, int mode, struct vfs_lookup *lookup);
 static struct dentry *coda_lookup(struct inode *dir, struct dentry *target, struct nameidata *nd);
 static int coda_link(struct dentry *old_dentry, struct inode *dir_inode, 
 		     struct dentry *entry);
@@ -192,7 +192,7 @@ static inline void coda_dir_drop_nlink(s
 }
 
 /* creation routines: create, mknod, mkdir, link, symlink */
-static int coda_create(struct inode *dir, struct dentry *de, int mode, struct nameidata *nd)
+static int coda_create(struct inode *dir, struct dentry *de, int mode, struct vfs_lookup *lookup)
 {
         int error=0;
 	const char *name=de->d_name.name;
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -69,7 +69,7 @@ static void unlock_dir(struct dentry *di
 static int
 ecryptfs_create_underlying_file(struct inode *lower_dir_inode,
 				struct dentry *dentry, int mode,
-				struct nameidata *nd)
+				struct vfs_lookup *lookup)
 {
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
@@ -77,13 +77,13 @@ ecryptfs_create_underlying_file(struct i
 	struct vfsmount *vfsmount_save;
 	int rc;
 
-	dentry_save = nd->lookup.path.dentry;
-	vfsmount_save = nd->lookup.path.mnt;
-	nd->lookup.path.dentry = lower_dentry;
-	nd->lookup.path.mnt = lower_mnt;
-	rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
-	nd->lookup.path.dentry = dentry_save;
-	nd->lookup.path.mnt = vfsmount_save;
+	dentry_save = lookup->path.dentry;
+	vfsmount_save = lookup->path.mnt;
+	lookup->path.dentry = lower_dentry;
+	lookup->path.mnt = lower_mnt;
+	rc = vfs_create(lower_dir_inode, lower_dentry, mode, lookup);
+	lookup->path.dentry = dentry_save;
+	lookup->path.mnt = vfsmount_save;
 	return rc;
 }
 
@@ -103,7 +103,7 @@ ecryptfs_create_underlying_file(struct i
 static int
 ecryptfs_do_create(struct inode *directory_inode,
 		   struct dentry *ecryptfs_dentry, int mode,
-		   struct nameidata *nd)
+		   struct vfs_lookup *lookup)
 {
 	int rc;
 	struct dentry *lower_dentry;
@@ -118,7 +118,7 @@ ecryptfs_do_create(struct inode *directo
 		goto out;
 	}
 	rc = ecryptfs_create_underlying_file(lower_dir_dentry->d_inode,
-					     ecryptfs_dentry, mode, nd);
+					     ecryptfs_dentry, mode, lookup);
 	if (unlikely(rc)) {
 		ecryptfs_printk(KERN_ERR,
 				"Failure to create underlying file\n");
@@ -248,11 +248,11 @@ out:
  */
 static int
 ecryptfs_create(struct inode *directory_inode, struct dentry *ecryptfs_dentry,
-		int mode, struct nameidata *nd)
+		int mode, struct vfs_lookup *lookup)
 {
 	int rc;
 
-	rc = ecryptfs_do_create(directory_inode, ecryptfs_dentry, mode, nd);
+	rc = ecryptfs_do_create(directory_inode, ecryptfs_dentry, mode, lookup);
 	if (unlikely(rc)) {
 		ecryptfs_printk(KERN_WARNING, "Failed to create file in"
 				"lower filesystem\n");
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -174,7 +174,7 @@ asmlinkage long sys_uselib(const char __
 out:
   	return error;
 exit:
-	release_open_intent(&nd);
+	release_open_intent(&nd.lookup.intent.open);
 	path_release(&nd);
 	goto out;
 }
@@ -698,7 +698,7 @@ out:
 				return file;
 			}
 		}
-		release_open_intent(&nd);
+		release_open_intent(&nd.lookup.intent.open);
 		path_release(&nd);
 	}
 	goto out;
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -103,7 +103,7 @@ struct dentry *ext2_get_parent(struct de
  * If the create succeeds, we fill in the inode information
  * with d_instantiate(). 
  */
-static int ext2_create (struct inode * dir, struct dentry * dentry, int mode, struct nameidata *nd)
+static int ext2_create (struct inode * dir, struct dentry * dentry, int mode, struct vfs_lookup *lookup)
 {
 	struct inode * inode = ext2_new_inode (dir, mode);
 	int err = PTR_ERR(inode);
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1654,7 +1654,7 @@ static int ext3_add_nondir(handle_t *han
  * with d_instantiate().
  */
 static int ext3_create (struct inode * dir, struct dentry * dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	handle_t *handle;
 	struct inode * inode;
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1681,7 +1681,7 @@ static int ext4_add_nondir(handle_t *han
  * with d_instantiate().
  */
 static int ext4_create (struct inode * dir, struct dentry * dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	handle_t *handle;
 	struct inode * inode;
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -303,7 +303,7 @@ static void fuse_sync_release(struct fus
  * 'mknod' + 'open' requests.
  */
 static int fuse_create_open(struct inode *dir, struct dentry *entry, int mode,
-			    struct nameidata *nd)
+			    struct vfs_lookup *lookup)
 {
 	int err;
 	struct inode *inode;
@@ -315,7 +315,7 @@ static int fuse_create_open(struct inode
 	struct fuse_entry_out outentry;
 	struct fuse_file *ff;
 	struct file *file;
-	int flags = nd->lookup.intent.open.flags - 1;
+	int flags = lookup->intent.open.flags - 1;
 
 	if (fc->no_create)
 		return -ENOSYS;
@@ -375,7 +375,7 @@ static int fuse_create_open(struct inode
 	fuse_put_request(fc, forget_req);
 	d_instantiate(entry, inode);
 	fuse_change_timeout(entry, &outentry);
-	file = lookup_instantiate_filp(nd, entry, generic_file_open);
+	file = lookup_instantiate_filp(lookup, entry, generic_file_open);
 	if (IS_ERR(file)) {
 		ff->fh = outopen.fh;
 		fuse_sync_release(fc, ff, outentry.nodeid, flags);
@@ -483,10 +483,10 @@ static int fuse_mknod(struct inode *dir,
 }
 
 static int fuse_create(struct inode *dir, struct dentry *entry, int mode,
-		       struct nameidata *nd)
+		       struct vfs_lookup *lookup)
 {
-	if (nd && (nd->lookup.flags & LOOKUP_OPEN)) {
-		int err = fuse_create_open(dir, entry, mode, nd);
+	if (lookup && (lookup->flags & LOOKUP_OPEN)) {
+		int err = fuse_create_open(dir, entry, mode, lookup);
 		if (err != -ENOSYS)
 			return err;
 		/* Fall back on mknod */
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -409,7 +409,7 @@ struct inode *gfs2_lookup_simple(struct 
  */
 
 struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
-			   int is_root, struct nameidata *nd)
+			   int is_root, struct vfs_lookup *lookup)
 {
 	struct super_block *sb = dir->i_sb;
 	struct gfs2_inode *dip = GFS2_I(dir);
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -57,7 +57,7 @@ int gfs2_inode_refresh(struct gfs2_inode
 int gfs2_dinode_dealloc(struct gfs2_inode *inode);
 int gfs2_change_nlink(struct gfs2_inode *ip, int diff);
 struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
-			   int is_root, struct nameidata *nd);
+			   int is_root, struct vfs_lookup *lookup);
 struct inode *gfs2_createi(struct gfs2_holder *ghs, const struct qstr *name,
 			   unsigned int mode, dev_t dev);
 int gfs2_rmdiri(struct gfs2_inode *dip, const struct qstr *name,
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -48,7 +48,7 @@
  */
 
 static int gfs2_create(struct inode *dir, struct dentry *dentry,
-		       int mode, struct nameidata *nd)
+		       int mode, struct vfs_lookup *lookup)
 {
 	struct gfs2_inode *dip = GFS2_I(dir);
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
@@ -69,12 +69,12 @@ static int gfs2_create(struct inode *dir
 			mark_inode_dirty(inode);
 			break;
 		} else if (PTR_ERR(inode) != -EEXIST ||
-			   (nd->lookup.intent.open.flags & O_EXCL)) {
+			   (lookup->intent.open.flags & O_EXCL)) {
 			gfs2_holder_uninit(ghs);
 			return PTR_ERR(inode);
 		}
 
-		inode = gfs2_lookupi(dir, &dentry->d_name, 0, nd);
+		inode = gfs2_lookupi(dir, &dentry->d_name, 0, lookup);
 		if (inode) {
 			if (!IS_ERR(inode)) {
 				gfs2_holder_uninit(ghs);
@@ -109,7 +109,7 @@ static struct dentry *gfs2_lookup(struct
 
 	dentry->d_op = &gfs2_dops;
 
-	inode = gfs2_lookupi(dir, &dentry->d_name, 0, nd);
+	inode = gfs2_lookupi(dir, &dentry->d_name, 0, &nd->lookup);
 	if (inode && IS_ERR(inode))
 		return ERR_PTR(PTR_ERR(inode));
 
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -178,7 +178,7 @@ static int hfs_dir_release(struct inode 
  * the directory and the name (and its length) of the new file.
  */
 static int hfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		      struct nameidata *nd)
+		      struct vfs_lookup *lookup)
 {
 	struct inode *inode;
 	int res;
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -236,7 +236,7 @@ static int hfsplus_dir_release(struct in
 }
 
 static int hfsplus_create(struct inode *dir, struct dentry *dentry, int mode,
-			  struct nameidata *nd)
+			  struct vfs_lookup *lookup)
 {
 	struct inode *inode;
 	int res;
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -118,7 +118,7 @@ bail:
 	return err;
 }
 
-static int hpfs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+static int hpfs_create(struct inode *dir, struct dentry *dentry, int mode, struct vfs_lookup *lookup)
 {
 	const char *name = dentry->d_name.name;
 	unsigned len = dentry->d_name.len;
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -437,7 +437,7 @@ static int hugetlbfs_mkdir(struct inode 
 	return retval;
 }
 
-static int hugetlbfs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+static int hugetlbfs_create(struct inode *dir, struct dentry *dentry, int mode, struct vfs_lookup *lookup)
 {
 	return hugetlbfs_mknod(dir, dentry, mode | S_IFREG, 0);
 }
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -349,7 +349,7 @@ static int find_inode(const char __user 
 	if (error)
 		return error;
 	/* you can only watch an inode if you have read permissions on it */
-	error = vfs_permission(nd.lookup, MAY_READ);
+	error = vfs_permission(&nd->lookup, MAY_READ);
 	if (error)
 		path_release(nd);
 	return error;
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -22,7 +22,7 @@
 static int jffs2_readdir (struct file *, void *, filldir_t);
 
 static int jffs2_create (struct inode *,struct dentry *,int,
-			 struct nameidata *);
+			 struct vfs_lookup *);
 static struct dentry *jffs2_lookup (struct inode *,struct dentry *,
 				    struct nameidata *);
 static int jffs2_link (struct dentry *,struct inode *,struct dentry *);
@@ -176,7 +176,7 @@ static int jffs2_readdir(struct file *fi
 
 
 static int jffs2_create(struct inode *dir_i, struct dentry *dentry, int mode,
-			struct nameidata *nd)
+			struct vfs_lookup *lookup)
 {
 	struct jffs2_raw_inode *ri;
 	struct jffs2_inode_info *f, *dir_f;
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -71,7 +71,7 @@ static inline void free_ea_wmap(struct i
  *
  */
 static int jfs_create(struct inode *dip, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	int rc = 0;
 	tid_t tid;		/* transaction id */
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -83,7 +83,7 @@ static int minix_mknod(struct inode * di
 }
 
 static int minix_create(struct inode * dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	return minix_mknod(dir, dentry, mode, 0);
 }
--- a/fs/msdos/namei.c
+++ b/fs/msdos/namei.c
@@ -277,7 +277,7 @@ static int msdos_add_entry(struct inode 
 
 /***** Create a file */
 static int msdos_create(struct inode *dir, struct dentry *dentry, int mode,
-			struct nameidata *nd)
+			struct vfs_lookup *lookup)
 {
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode = NULL;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -369,12 +369,14 @@ void path_release_on_umount(struct namei
  * release_open_intent - free up open intent resources
  * @nd: pointer to nameidata
  */
-void release_open_intent(struct nameidata *nd)
+void release_open_intent(struct open_intent *intent)
 {
-	if (nd->lookup.intent.open.file->f_path.dentry == NULL)
-		put_filp(nd->lookup.intent.open.file);
+	struct file *file = intent->file;
+
+	if (file->f_path.dentry == NULL)
+		put_filp(file);
 	else
-		fput(nd->lookup.intent.open.file);
+		fput(file);
 }
 
 static inline struct dentry *
@@ -1223,7 +1225,7 @@ static int __path_lookup_intent_open(int
 			path_release(nd);
 		}
 	} else if (err != 0)
-		release_open_intent(nd);
+		release_open_intent(&nd->lookup.intent.open);
 	return err;
 }
 
@@ -1542,9 +1544,9 @@ void unlock_rename(struct dentry *p1, st
 }
 
 int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+	       struct vfs_lookup *lookup)
 {
-	int error = may_create(dir, dentry, &nd->lookup);
+	int error = may_create(dir, dentry, lookup);
 
 	if (error)
 		return error;
@@ -1557,7 +1559,7 @@ int vfs_create(struct inode *dir, struct
 	if (error)
 		return error;
 	DQUOT_INIT(dir);
-	error = dir->i_op->create(dir, dentry, mode, nd);
+	error = dir->i_op->create(dir, dentry, mode, lookup);
 	if (!error)
 		fsnotify_create(dir, dentry);
 	return error;
@@ -1650,7 +1652,7 @@ static int open_namei_create(struct name
 
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
-	error = vfs_create(dir->d_inode, path->dentry, mode, nd);
+	error = vfs_create(dir->d_inode, path->dentry, mode, &nd->lookup);
 	mutex_unlock(&dir->d_inode->i_mutex);
 	dput(nd->lookup.path.dentry);
 	nd->lookup.path.dentry = path->dentry;
@@ -1783,7 +1785,7 @@ exit_dput:
 	dput_path(&path, nd);
 exit:
 	if (!IS_ERR(nd->lookup.intent.open.file))
-		release_open_intent(nd);
+		release_open_intent(&nd->lookup.intent.open);
 	path_release(nd);
 	return error;
 
@@ -1811,7 +1813,7 @@ do_link:
 		 * me so stupid? Anathema to whoever designed this non-sense
 		 * with "intent.open".
 		 */
-		release_open_intent(nd);
+		release_open_intent(&nd->lookup.intent.open);
 		return error;
 	}
 	nd->lookup.flags &= ~LOOKUP_PARENT;
@@ -1935,7 +1937,8 @@ asmlinkage long sys_mknodat(int dfd, con
 	if (!IS_ERR(dentry)) {
 		switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
-			error = vfs_create(nd.lookup.path.dentry->d_inode,dentry,mode,&nd);
+			error = vfs_create(nd.lookup.path.dentry->d_inode,
+					   dentry, mode, &nd.lookup);
 			break;
 		case S_IFCHR: case S_IFBLK:
 			error = vfs_mknod(nd.lookup.path.dentry->d_inode,dentry,mode,
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -33,7 +33,7 @@ static void ncp_do_readdir(struct file *
 
 static int ncp_readdir(struct file *, void *, filldir_t);
 
-static int ncp_create(struct inode *, struct dentry *, int, struct nameidata *);
+static int ncp_create(struct inode *, struct dentry *, int, struct vfs_lookup *);
 static struct dentry *ncp_lookup(struct inode *, struct dentry *, struct nameidata *);
 static int ncp_unlink(struct inode *, struct dentry *);
 static int ncp_mkdir(struct inode *, struct dentry *, int);
@@ -940,7 +940,7 @@ out:
 }
 
 static int ncp_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	return ncp_create_new(dir, dentry, mode, 0, 0);
 }
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -44,7 +44,7 @@
 static int nfs_opendir(struct inode *, struct file *);
 static int nfs_readdir(struct file *, void *, filldir_t);
 static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct nameidata *);
-static int nfs_create(struct inode *, struct dentry *, int, struct nameidata *);
+static int nfs_create(struct inode *, struct dentry *, int, struct vfs_lookup *);
 static int nfs_mkdir(struct inode *, struct dentry *, int);
 static int nfs_rmdir(struct inode *, struct dentry *);
 static int nfs_unlink(struct inode *, struct dentry *);
@@ -687,11 +687,11 @@ static inline void nfs_renew_times(struc
  * component of the path.
  * We check for this using LOOKUP_CONTINUE and LOOKUP_PARENT.
  */
-static inline unsigned int nfs_lookup_check_intent(struct nameidata *nd, unsigned int mask)
+static inline unsigned int nfs_lookup_check_intent(struct vfs_lookup *lookup, unsigned int mask)
 {
-	if (nd->lookup.flags & (LOOKUP_CONTINUE|LOOKUP_PARENT))
+	if (lookup->flags & (LOOKUP_CONTINUE|LOOKUP_PARENT))
 		return 0;
-	return nd->lookup.flags & mask;
+	return lookup->flags & mask;
 }
 
 /*
@@ -712,7 +712,7 @@ int nfs_lookup_verify_inode(struct inode
 		if (nd->lookup.flags & LOOKUP_REVAL)
 			goto out_force;
 		/* This is an open(2) */
-		if (nfs_lookup_check_intent(nd, LOOKUP_OPEN) != 0 &&
+		if (nfs_lookup_check_intent(&nd->lookup, LOOKUP_OPEN) != 0 &&
 				!(server->flags & NFS_MOUNT_NOCTO) &&
 				(S_ISREG(inode->i_mode) ||
 				 S_ISDIR(inode->i_mode)))
@@ -735,7 +735,7 @@ int nfs_neg_need_reval(struct inode *dir
 		       struct nameidata *nd)
 {
 	/* Don't revalidate a negative dentry if we're creating a new file */
-	if (nd != NULL && nfs_lookup_check_intent(nd, LOOKUP_CREATE) != 0)
+	if (nd != NULL && nfs_lookup_check_intent(&nd->lookup, LOOKUP_CREATE) != 0)
 		return 0;
 	return !nfs_check_verifier(dir, dentry);
 }
@@ -888,13 +888,13 @@ struct dentry_operations nfs_dentry_oper
  * an O_EXCL create using this path component.
  */
 static inline
-int nfs_is_exclusive_create(struct inode *dir, struct nameidata *nd)
+int nfs_is_exclusive_create(struct inode *dir, struct vfs_lookup *lookup)
 {
 	if (NFS_PROTO(dir)->version == 2)
 		return 0;
-	if (nd == NULL || nfs_lookup_check_intent(nd, LOOKUP_CREATE) == 0)
+	if (!lookup || nfs_lookup_check_intent(lookup, LOOKUP_CREATE) == 0)
 		return 0;
-	return (nd->lookup.intent.open.flags & O_EXCL) != 0;
+	return (lookup->intent.open.flags & O_EXCL) != 0;
 }
 
 static inline int nfs_reval_fsid(struct inode *dir, const struct nfs_fattr *fattr)
@@ -932,7 +932,7 @@ static struct dentry *nfs_lookup(struct 
 	 * If we're doing an exclusive create, optimize away the lookup
 	 * but don't hash the dentry.
 	 */
-	if (nfs_is_exclusive_create(dir, nd)) {
+	if (nfs_is_exclusive_create(dir, &nd->lookup)) {
 		d_instantiate(dentry, NULL);
 		res = NULL;
 		goto out_unlock;
@@ -991,7 +991,7 @@ struct dentry_operations nfs4_dentry_ope
  */
 static int is_atomic_open(struct inode *dir, struct nameidata *nd)
 {
-	if (nd == NULL || nfs_lookup_check_intent(nd, LOOKUP_OPEN) == 0)
+	if (nd == NULL || nfs_lookup_check_intent(&nd->lookup, LOOKUP_OPEN) == 0)
 		return 0;
 	/* NFS does not (yet) have a stateful open for directories */
 	if (nd->lookup.flags & LOOKUP_DIRECTORY)
@@ -1231,7 +1231,7 @@ int nfs_instantiate(struct dentry *dentr
  * reply path made it appear to have failed.
  */
 static int nfs_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	struct iattr attr;
 	int error;
@@ -1243,12 +1243,12 @@ static int nfs_create(struct inode *dir,
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
-	if ((nd->lookup.flags & LOOKUP_CREATE) != 0)
-		open_flags = nd->lookup.intent.open.flags;
+	if ((lookup->flags & LOOKUP_CREATE) != 0)
+		open_flags = lookup->intent.open.flags;
 
 	lock_kernel();
 	nfs_begin_data_update(dir);
-	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, nd);
+	error = NFS_PROTO(dir)->create(dir, dentry, &attr, open_flags, lookup);
 	nfs_end_data_update(dir);
 	if (error != 0)
 		goto out_err;
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -258,7 +258,7 @@ static int nfs3_proc_readlink(struct ino
  */
 static int
 nfs3_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-		 int flags, struct nameidata *nd)
+		 int flags, struct vfs_lookup *lookup)
 {
 	struct nfs_fh		fhandle;
 	struct nfs_fattr	fattr;
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1376,20 +1376,20 @@ out:
 	return status;
 }
 
-static int nfs4_intent_set_file(struct nameidata *nd, struct path *path, struct nfs4_state *state)
+static int nfs4_intent_set_file(struct vfs_lookup *lookup, struct path *path, struct nfs4_state *state)
 {
 	struct file *filp;
 	int ret;
 
 	/* If the open_intent is for execute, we have an extra check to make */
-	if (nd->lookup.intent.open.flags & FMODE_EXEC) {
+	if (lookup->intent.open.flags & FMODE_EXEC) {
 		ret = _nfs4_do_access(state->inode,
 				state->owner->so_cred,
-				nd->lookup.intent.open.flags);
+				lookup->intent.open.flags);
 		if (ret < 0)
 			goto out_close;
 	}
-	filp = lookup_instantiate_filp(nd, path->dentry, NULL);
+	filp = lookup_instantiate_filp(lookup, path->dentry, NULL);
 	if (!IS_ERR(filp)) {
 		struct nfs_open_context *ctx;
 		ctx = (struct nfs_open_context *)filp->private_data;
@@ -1398,7 +1398,7 @@ static int nfs4_intent_set_file(struct n
 	}
 	ret = PTR_ERR(filp);
 out_close:
-	nfs4_close_state(path, state, nd->lookup.intent.open.flags);
+	nfs4_close_state(path, state, lookup->intent.open.flags);
 	return ret;
 }
 
@@ -1437,7 +1437,7 @@ nfs4_atomic_open(struct inode *dir, stru
 	res = d_add_unique(dentry, igrab(state->inode));
 	if (res != NULL)
 		dentry = res;
-	nfs4_intent_set_file(nd, &path, state);
+	nfs4_intent_set_file(&nd->lookup, &path, state);
 	return res;
 }
 
@@ -1463,14 +1463,14 @@ nfs4_open_revalidate(struct inode *dir, 
 			case -EDQUOT:
 			case -ENOSPC:
 			case -EROFS:
-				lookup_instantiate_filp(nd, (struct dentry *)state, NULL);
+				lookup_instantiate_filp(&nd->lookup, (struct dentry *)state, NULL);
 				return 1;
 			default:
 				goto out_drop;
 		}
 	}
 	if (state->inode == dentry->d_inode) {
-		nfs4_intent_set_file(nd, &path, state);
+		nfs4_intent_set_file(&nd->lookup, &path, state);
 		return 1;
 	}
 	nfs4_close_state(&path, state, openflags);
@@ -1885,10 +1885,10 @@ static int nfs4_proc_readlink(struct ino
 
 static int
 nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-                 int flags, struct nameidata *nd)
+                 int flags, struct vfs_lookup *lookup)
 {
 	struct path path = {
-		.mnt = nd->lookup.path.mnt,
+		.mnt = lookup->path.mnt,
 		.dentry = dentry,
 	};
 	struct nfs4_state *state;
@@ -1914,8 +1914,8 @@ nfs4_proc_create(struct inode *dir, stru
 			nfs_setattr_update_inode(state->inode, sattr);
 		nfs_post_op_update_inode(state->inode, &fattr);
 	}
-	if (status == 0 && (nd->lookup.flags & LOOKUP_OPEN) != 0)
-		status = nfs4_intent_set_file(nd, &path, state);
+	if (status == 0 && (lookup->flags & LOOKUP_OPEN) != 0)
+		status = nfs4_intent_set_file(lookup, &path, state);
 	else
 		nfs4_close_state(&path, state, flags);
 out:
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -187,7 +187,7 @@ static int nfs_proc_readlink(struct inod
 
 static int
 nfs_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
-		int flags, struct nameidata *nd)
+		int flags, struct vfs_lookup *lookup)
 {
 	struct nfs_fh		fhandle;
 	struct nfs_fattr	fattr;
--- a/fs/ocfs2/dlm/dlmfs.c
+++ b/fs/ocfs2/dlm/dlmfs.c
@@ -459,7 +459,7 @@ bail:
 static int dlmfs_create(struct inode *dir,
 			struct dentry *dentry,
 			int mode,
-			struct nameidata *nd)
+			struct vfs_lookup *lookup)
 {
 	int status = 0;
 	struct inode *inode;
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -626,7 +626,7 @@ static int ocfs2_mkdir(struct inode *dir
 static int ocfs2_create(struct inode *dir,
 			struct dentry *dentry,
 			int mode,
-			struct nameidata *nd)
+			struct vfs_lookup *lookup)
 {
 	int ret;
 
--- a/fs/open.c
+++ b/fs/open.c
@@ -831,7 +831,7 @@ EXPORT_SYMBOL(filp_open);
 
 /**
  * lookup_instantiate_filp - instantiates the open intent filp
- * @nd: pointer to nameidata
+ * @lookup: pointer to vfs_lookup
  * @dentry: pointer to dentry
  * @open: open callback
  *
@@ -848,22 +848,24 @@ EXPORT_SYMBOL(filp_open);
  * If the open callback is set to NULL, then the standard f_op->open()
  * filesystem callback is substituted.
  */
-struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
+struct file *lookup_instantiate_filp(struct vfs_lookup *lookup,
+		struct dentry *dentry,
 		int (*open)(struct inode *, struct file *))
 {
-	if (IS_ERR(nd->lookup.intent.open.file))
+	if (IS_ERR(lookup->intent.open.file))
 		goto out;
 	if (IS_ERR(dentry))
 		goto out_err;
-	nd->lookup.intent.open.file = __dentry_open(dget(dentry), mntget(nd->lookup.path.mnt),
-					     nd->lookup.intent.open.flags - 1,
-					     nd->lookup.intent.open.file,
-					     open);
+	lookup->intent.open.file = __dentry_open(dget(dentry),
+						 mntget(lookup->path.mnt),
+						 lookup->intent.open.flags - 1,
+						 lookup->intent.open.file,
+						 open);
 out:
-	return nd->lookup.intent.open.file;
+	return lookup->intent.open.file;
 out_err:
-	release_open_intent(nd);
-	nd->lookup.intent.open.file = (struct file *)dentry;
+	release_open_intent(&lookup->intent.open);
+	lookup->intent.open.file = (struct file *)dentry;
 	goto out;
 }
 EXPORT_SYMBOL_GPL(lookup_instantiate_filp);
--- a/fs/qnx4/namei.c
+++ b/fs/qnx4/namei.c
@@ -142,7 +142,7 @@ out:
 
 #ifdef CONFIG_QNX4FS_RW
 int qnx4_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	QNX4DEBUG(("qnx4: qnx4_create\n"));
 	if (dir == NULL) {
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -117,7 +117,7 @@ static int ramfs_mkdir(struct inode * di
 	return retval;
 }
 
-static int ramfs_create(struct inode *dir, struct dentry *dentry, int mode, struct nameidata *nd)
+static int ramfs_create(struct inode *dir, struct dentry *dentry, int mode, struct vfs_lookup *lookup)
 {
 	return ramfs_mknod(dir, dentry, mode | S_IFREG, 0);
 }
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -600,7 +600,7 @@ static int new_inode_init(struct inode *
 }
 
 static int reiserfs_create(struct inode *dir, struct dentry *dentry, int mode,
-			   struct nameidata *nd)
+			   struct vfs_lookup *lookup)
 {
 	int retval;
 	struct inode *inode;
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -26,7 +26,7 @@ static int smb_readdir(struct file *, vo
 static int smb_dir_open(struct inode *, struct file *);
 
 static struct dentry *smb_lookup(struct inode *, struct dentry *, struct nameidata *);
-static int smb_create(struct inode *, struct dentry *, int, struct nameidata *);
+static int smb_create(struct inode *, struct dentry *, int, struct vfs_lookup *);
 static int smb_mkdir(struct inode *, struct dentry *, int);
 static int smb_rmdir(struct inode *, struct dentry *);
 static int smb_unlink(struct inode *, struct dentry *);
@@ -520,7 +520,7 @@ out_close:
 /* N.B. How should the mode argument be used? */
 static int
 smb_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	struct smb_sb_info *server = server_from_dentry(dentry);
 	__u16 fileid;
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -80,7 +80,7 @@ static int sysv_mknod(struct inode * dir
 	return err;
 }
 
-static int sysv_create(struct inode * dir, struct dentry * dentry, int mode, struct nameidata *nd)
+static int sysv_create(struct inode * dir, struct dentry * dentry, int mode, struct vfs_lookup *lookup)
 {
 	return sysv_mknod(dir, dentry, mode, 0);
 }
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -572,7 +572,7 @@ static int udf_delete_entry(struct inode
 }
 
 static int udf_create(struct inode *dir, struct dentry *dentry, int mode,
-		      struct nameidata *nd)
+		      struct vfs_lookup *lookup)
 {
 	struct udf_fileident_bh fibh;
 	struct inode *inode;
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -77,7 +77,7 @@ static struct dentry *ufs_lookup(struct 
  * with d_instantiate(). 
  */
 static int ufs_create (struct inode * dir, struct dentry * dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	struct inode *inode;
 	int err;
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -731,7 +731,7 @@ error:
 }
 
 static int vfat_create(struct inode *dir, struct dentry *dentry, int mode,
-		       struct nameidata *nd)
+		       struct vfs_lookup *lookup)
 {
 	struct super_block *sb = dir->i_sb;
 	struct inode *inode;
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -367,7 +367,7 @@ xfs_vn_create(
 	struct inode	*dir,
 	struct dentry	*dentry,
 	int		mode,
-	struct nameidata *nd)
+	struct vfs_lookup *lookup)
 {
 	return xfs_vn_mknod(dir, dentry, mode, 0);
 }
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1009,7 +1009,7 @@ extern void unlock_super(struct super_bl
  * VFS helper functions..
  */
 extern int vfs_permission(struct vfs_lookup *, int);
-extern int vfs_create(struct inode *, struct dentry *, int, struct nameidata *);
+extern int vfs_create(struct inode *, struct dentry *, int, struct vfs_lookup *);
 extern int vfs_mkdir(struct inode *, struct dentry *, int);
 extern int vfs_mknod(struct inode *, struct dentry *, int, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *, int);
@@ -1133,7 +1133,7 @@ struct file_operations {
 };
 
 struct inode_operations {
-	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
+	int (*create) (struct inode *,struct dentry *,int, struct vfs_lookup *);
 	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -79,10 +79,11 @@ extern void path_release_on_umount(struc
 
 extern int __user_path_lookup_open(const char __user *, unsigned lookup_flags, struct nameidata *nd, int open_flags);
 extern int path_lookup_open(int dfd, const char *name, unsigned lookup_flags, struct nameidata *, int open_flags);
-extern struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
+extern struct file *lookup_instantiate_filp(struct vfs_lookup *lookup,
+		struct dentry *dentry,
 		int (*open)(struct inode *, struct file *));
 extern struct file *nameidata_to_filp(struct nameidata *nd, int flags);
-extern void release_open_intent(struct nameidata *);
+extern void release_open_intent(struct open_intent *);
 
 extern struct dentry * lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_len_kern(const char *, struct dentry *, int);
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -789,7 +789,7 @@ struct nfs_rpc_ops {
 	int	(*readlink)(struct inode *, struct page *, unsigned int,
 			    unsigned int);
 	int	(*create)  (struct inode *, struct dentry *,
-			    struct iattr *, int, struct nameidata *);
+			    struct iattr *, int, struct vfs_lookup *);
 	int	(*remove)  (struct inode *, struct qstr *);
 	void	(*unlink_setup)  (struct rpc_message *, struct inode *dir);
 	int	(*unlink_done) (struct rpc_task *, struct inode *);
--- a/include/linux/qnx4_fs.h
+++ b/include/linux/qnx4_fs.h
@@ -122,7 +122,7 @@ extern const struct file_operations qnx4
 extern const struct file_operations qnx4_dir_operations;
 extern int qnx4_is_free(struct super_block *sb, long block);
 extern int qnx4_set_bitmap(struct super_block *sb, long block, int busy);
-extern int qnx4_create(struct inode *inode, struct dentry *dentry, int mode, struct nameidata *nd);
+extern int qnx4_create(struct inode *inode, struct dentry *dentry, int mode, struct vfs_lookup *lookup);
 extern void qnx4_truncate(struct inode *inode);
 extern void qnx4_free_inode(struct inode *inode);
 extern int qnx4_unlink(struct inode *dir, struct dentry *dentry);
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -266,7 +266,7 @@ static void mqueue_delete_inode(struct i
 }
 
 static int mqueue_create(struct inode *dir, struct dentry *dentry,
-				int mode, struct nameidata *nd)
+				int mode, struct vfs_lookup *lookup)
 {
 	struct inode *inode;
 	struct mq_attr *attr = dentry->d_fsdata;
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1749,7 +1749,7 @@ static int shmem_mkdir(struct inode *dir
 }
 
 static int shmem_create(struct inode *dir, struct dentry *dentry, int mode,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	return shmem_mknod(dir, dentry, mode | S_IFREG, 0);
 }

