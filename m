Return-Path: <linux-kernel-owner+w=401wt.eu-S937846AbXHHRYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937846AbXHHRYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937257AbXHHRTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:22 -0400
Received: from ns.suse.de ([195.135.220.2]:38775 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935869AbXHHRTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:07 -0400
Message-Id: <20070808171644.669232809@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:32 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 10/10] Pass no unnecessary information to iop->lookup
Content-Disposition: inline; filename=lookup-args.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

iop->lookup does not need a full nameidata. Pass a struct vfs_lookup
instead.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 fs/9p/vfs_inode.c           |    6 +++---
 fs/adfs/dir.c               |    2 +-
 fs/affs/affs.h              |    2 +-
 fs/affs/namei.c             |    2 +-
 fs/afs/dir.c                |    4 ++--
 fs/afs/mntpt.c              |    4 ++--
 fs/autofs/root.c            |    6 +++---
 fs/autofs4/root.c           |    6 +++---
 fs/bad_inode.c              |    2 +-
 fs/befs/linuxvfs.c          |    4 ++--
 fs/bfs/dir.c                |    2 +-
 fs/cifs/cifsfs.h            |    2 +-
 fs/cifs/dir.c               |    2 +-
 fs/coda/dir.c               |    4 ++--
 fs/configfs/dir.c           |    4 ++--
 fs/cramfs/inode.c           |    3 ++-
 fs/ecryptfs/inode.c         |   10 +++++-----
 fs/efs/namei.c              |    2 +-
 fs/ext2/namei.c             |    2 +-
 fs/ext3/namei.c             |    2 +-
 fs/ext4/namei.c             |    2 +-
 fs/freevxfs/vxfs_lookup.c   |    4 ++--
 fs/fuse/dir.c               |    2 +-
 fs/gfs2/ops_inode.c         |    6 +++---
 fs/hfs/dir.c                |    2 +-
 fs/hfs/inode.c              |    2 +-
 fs/hfsplus/dir.c            |    2 +-
 fs/hfsplus/inode.c          |    2 +-
 fs/hpfs/dir.c               |    3 ++-
 fs/hpfs/hpfs_fn.h           |    2 +-
 fs/isofs/isofs.h            |    2 +-
 fs/isofs/namei.c            |    2 +-
 fs/jffs2/dir.c              |    4 ++--
 fs/jfs/namei.c              |    2 +-
 fs/libfs.c                  |    2 +-
 fs/minix/namei.c            |    2 +-
 fs/msdos/namei.c            |    2 +-
 fs/namei.c                  |    4 ++--
 fs/ncpfs/dir.c              |    4 ++--
 fs/nfs/dir.c                |   24 ++++++++++++------------
 fs/nfs/nfs4_fs.h            |    2 +-
 fs/nfs/nfs4proc.c           |   16 +++++++++-------
 fs/ntfs/namei.c             |    4 ++--
 fs/ocfs2/namei.c            |    2 +-
 fs/proc/base.c              |   15 ++++++++-------
 fs/proc/generic.c           |    2 +-
 fs/proc/proc_sysctl.c       |    2 +-
 fs/proc/root.c              |    6 +++---
 fs/qnx4/namei.c             |    2 +-
 fs/reiserfs/namei.c         |    2 +-
 fs/romfs/inode.c            |    3 ++-
 fs/smbfs/dir.c              |    4 ++--
 fs/sysfs/dir.c              |    2 +-
 fs/sysv/namei.c             |    2 +-
 fs/udf/namei.c              |    2 +-
 fs/ufs/namei.c              |    2 +-
 fs/vfat/namei.c             |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c |    2 +-
 include/linux/efs_fs.h      |    2 +-
 include/linux/fs.h          |    4 ++--
 include/linux/proc_fs.h     |    4 ++--
 include/linux/qnx4_fs.h     |    2 +-
 62 files changed, 118 insertions(+), 112 deletions(-)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -553,7 +553,7 @@ static int v9fs_vfs_mkdir(struct inode *
  */
 
 static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nameidata)
+				      struct vfs_lookup *lookup)
 {
 	struct super_block *sb;
 	struct v9fs_session_info *v9ses;
@@ -562,8 +562,8 @@ static struct dentry *v9fs_vfs_lookup(st
 	char *name;
 	int result = 0;
 
-	P9_DPRINTK(P9_DEBUG_VFS, "dir: %p dentry: (%s) %p nameidata: %p\n",
-		dir, dentry->d_name.name, dentry, nameidata);
+	P9_DPRINTK(P9_DEBUG_VFS, "dir: %p dentry: (%s) %p lookup: %p\n",
+		dir, dentry->d_name.name, dentry, lookup);
 
 	sb = dir->i_sb;
 	v9ses = v9fs_inode2v9ses(dir);
--- a/fs/adfs/dir.c
+++ b/fs/adfs/dir.c
@@ -268,7 +268,7 @@ struct dentry_operations adfs_dentry_ope
 };
 
 static struct dentry *
-adfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+adfs_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode *inode = NULL;
 	struct object_info obj;
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -153,7 +153,7 @@ extern void	affs_free_bitmap(struct supe
 /* namei.c */
 
 extern int	affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len);
-extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *);
+extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *);
 extern int	affs_unlink(struct inode *dir, struct dentry *dentry);
 extern int	affs_create(struct inode *dir, struct dentry *dentry, int mode, struct vfs_lookup *);
 extern int	affs_mkdir(struct inode *dir, struct dentry *dentry, int mode);
--- a/fs/affs/namei.c
+++ b/fs/affs/namei.c
@@ -197,7 +197,7 @@ affs_find_entry(struct inode *dir, struc
 }
 
 struct dentry *
-affs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+affs_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct super_block *sb = dir->i_sb;
 	struct buffer_head *bh;
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -20,7 +20,7 @@
 #include "internal.h"
 
 static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd);
+				 struct vfs_lookup *lookup);
 static int afs_dir_open(struct inode *inode, struct file *file);
 static int afs_readdir(struct file *file, void *dirent, filldir_t filldir);
 static int afs_d_revalidate(struct dentry *dentry, struct vfs_lookup *lookup);
@@ -484,7 +484,7 @@ static int afs_do_lookup(struct inode *d
  * look up an entry in a directory
  */
 static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd)
+				 struct vfs_lookup *lookup)
 {
 	struct afs_vnode *vnode;
 	struct afs_fid fid;
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -23,7 +23,7 @@
 
 static struct dentry *afs_mntpt_lookup(struct inode *dir,
 				       struct dentry *dentry,
-				       struct nameidata *nd);
+				       struct vfs_lookup *lookup);
 static int afs_mntpt_open(struct inode *inode, struct file *file);
 static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd);
 static void afs_mntpt_expiry_timed_out(struct work_struct *work);
@@ -103,7 +103,7 @@ out:
  */
 static struct dentry *afs_mntpt_lookup(struct inode *dir,
 				       struct dentry *dentry,
-				       struct nameidata *nd)
+				       struct vfs_lookup *lookup)
 {
 	_enter("%p,%p{%p{%s},%s}",
 	       dir,
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -19,7 +19,7 @@
 #include "autofs_i.h"
 
 static int autofs_root_readdir(struct file *,void *,filldir_t);
-static struct dentry *autofs_root_lookup(struct inode *,struct dentry *, struct nameidata *);
+static struct dentry *autofs_root_lookup(struct inode *,struct dentry *, struct vfs_lookup *);
 static int autofs_root_symlink(struct inode *,struct dentry *,const char *);
 static int autofs_root_unlink(struct inode *,struct dentry *);
 static int autofs_root_rmdir(struct inode *,struct dentry *);
@@ -196,7 +196,7 @@ static struct dentry_operations autofs_d
 	.d_revalidate	= autofs_revalidate,
 };
 
-static struct dentry *autofs_root_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *autofs_root_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct autofs_sb_info *sbi;
 	int oz_mode;
@@ -233,7 +233,7 @@ static struct dentry *autofs_root_lookup
 	d_add(dentry, NULL);
 
 	mutex_unlock(&dir->i_mutex);
-	autofs_revalidate(dentry, &nd->lookup);
+	autofs_revalidate(dentry, lookup);
 	mutex_lock(&dir->i_mutex);
 
 	/*
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -28,7 +28,7 @@ static int autofs4_dir_open(struct inode
 static int autofs4_dir_close(struct inode *inode, struct file *file);
 static int autofs4_dir_readdir(struct file * filp, void * dirent, filldir_t filldir);
 static int autofs4_root_readdir(struct file * filp, void * dirent, filldir_t filldir);
-static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
+static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct vfs_lookup *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
 
 const struct file_operations autofs4_root_operations = {
@@ -565,7 +565,7 @@ next:
 }
 
 /* Lookups in the root directory */
-static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct autofs_sb_info *sbi;
 	struct dentry *unhashed;
@@ -627,7 +627,7 @@ static struct dentry *autofs4_lookup(str
 
 	if (dentry->d_op && dentry->d_op->d_revalidate) {
 		mutex_unlock(&dir->i_mutex);
-		(dentry->d_op->d_revalidate)(dentry, &nd->lookup);
+		(dentry->d_op->d_revalidate)(dentry, lookup);
 		mutex_lock(&dir->i_mutex);
 	}
 
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -192,7 +192,7 @@ static int bad_inode_create (struct inod
 }
 
 static struct dentry *bad_inode_lookup(struct inode *dir,
-			struct dentry *dentry, struct nameidata *nd)
+			struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	return ERR_PTR(-EIO);
 }
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -34,7 +34,7 @@ static int befs_readdir(struct file *, v
 static int befs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 static int befs_readpage(struct file *file, struct page *page);
 static sector_t befs_bmap(struct address_space *mapping, sector_t block);
-static struct dentry *befs_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *befs_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 static void befs_read_inode(struct inode *ino);
 static struct inode *befs_alloc_inode(struct super_block *sb);
 static void befs_destroy_inode(struct inode *inode);
@@ -159,7 +159,7 @@ befs_get_block(struct inode *inode, sect
 }
 
 static struct dentry *
-befs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+befs_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode *inode = NULL;
 	struct super_block *sb = dir->i_sb;
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -127,7 +127,7 @@ static int bfs_create(struct inode * dir
 	return 0;
 }
 
-static struct dentry * bfs_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry * bfs_lookup(struct inode * dir, struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	struct inode * inode = NULL;
 	struct buffer_head * bh;
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -46,7 +46,7 @@ extern const struct inode_operations cif
 extern int cifs_create(struct inode *, struct dentry *, int,
 		       struct vfs_lookup *);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
-				  struct nameidata *);
+				  struct vfs_lookup *);
 extern int cifs_unlink(struct inode *, struct dentry *);
 extern int cifs_hardlink(struct dentry *, struct inode *, struct dentry *);
 extern int cifs_mknod(struct inode *, struct dentry *, int, dev_t);
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -438,7 +438,7 @@ int cifs_mknod(struct inode *inode, stru
 
 struct dentry *
 cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
-	    struct nameidata *nd)
+	    struct vfs_lookup *lookup)
 {
 	int xid;
 	int rc = 0; /* to get around spurious gcc warning, set to zero here */
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -30,7 +30,7 @@
 
 /* dir inode-ops */
 static int coda_create(struct inode *dir, struct dentry *new, int mode, struct vfs_lookup *lookup);
-static struct dentry *coda_lookup(struct inode *dir, struct dentry *target, struct nameidata *nd);
+static struct dentry *coda_lookup(struct inode *dir, struct dentry *target, struct vfs_lookup *lookup);
 static int coda_link(struct dentry *old_dentry, struct inode *dir_inode, 
 		     struct dentry *entry);
 static int coda_unlink(struct inode *dir_inode, struct dentry *entry);
@@ -93,7 +93,7 @@ const struct file_operations coda_dir_op
 
 /* inode operations for directories */
 /* access routines: lookup, readlink, permission */
-static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, struct nameidata *nd)
+static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, struct vfs_lookup *lookup)
 {
 	struct inode *inode = NULL;
 	struct CodaFid resfid = { { 0, } };
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -297,7 +297,7 @@ static int configfs_attach_attr(struct c
 
 static struct dentry * configfs_lookup(struct inode *dir,
 				       struct dentry *dentry,
-				       struct nameidata *nd)
+				       struct vfs_lookup *lookup)
 {
 	struct configfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct configfs_dirent * sd;
@@ -322,7 +322,7 @@ static struct dentry * configfs_lookup(s
 		 * If it doesn't exist and it isn't a NOT_PINNED item,
 		 * it must be negative.
 		 */
-		return simple_lookup(dir, dentry, nd);
+		return simple_lookup(dir, dentry, lookup);
 	}
 
 	return ERR_PTR(err);
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -405,7 +405,8 @@ static int cramfs_readdir(struct file *f
 /*
  * Lookup and fill in the inode data..
  */
-static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry,
+				     struct vfs_lookup *lookup)
 {
 	unsigned int offset = 0;
 	int sorted;
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -275,7 +275,7 @@ out:
  * dentry cache and continue on to read it from the disk.
  */
 static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nd)
+				      struct vfs_lookup *lookup)
 {
 	int rc = 0;
 	struct dentry *lower_dir_dentry;
@@ -353,9 +353,9 @@ static struct dentry *ecryptfs_lookup(st
 		ecryptfs_printk(KERN_DEBUG, "Is a symlink; returning\n");
 		goto out;
 	}
-	if (!nd) {
-		ecryptfs_printk(KERN_DEBUG, "We have a NULL nd, just leave"
-				"as we *think* we are about to unlink\n");
+	if (!lookup) {
+		ecryptfs_printk(KERN_DEBUG, "We have a NULL vfs_lookup, just "
+				"leave as we *think* we are about to unlink\n");
 		goto out;
 	}
 	/* Released in this function */
@@ -371,7 +371,7 @@ static struct dentry *ecryptfs_lookup(st
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
 		ecryptfs_set_default_sizes(crypt_stat);
 	rc = ecryptfs_read_and_validate_header_region(page_virt, lower_dentry,
-						      nd->lookup.path.mnt);
+						      lookup->path.mnt);
 	if (rc) {
 		rc = ecryptfs_read_and_validate_xattr_region(page_virt, dentry);
 		if (rc) {
--- a/fs/efs/namei.c
+++ b/fs/efs/namei.c
@@ -57,7 +57,7 @@ static efs_ino_t efs_find_entry(struct i
 	return(0);
 }
 
-struct dentry *efs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd) {
+struct dentry *efs_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup) {
 	efs_ino_t inodenum;
 	struct inode * inode = NULL;
 
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -52,7 +52,7 @@ static inline int ext2_add_nondir(struct
  * Methods themselves.
  */
 
-static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext2_lookup(struct inode * dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode * inode;
 	ino_t ino;
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -996,7 +996,7 @@ errout:
 }
 #endif
 
-static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode * inode;
 	struct ext3_dir_entry_2 * de;
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -994,7 +994,7 @@ errout:
 }
 #endif
 
-static struct dentry *ext4_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ext4_lookup(struct inode * dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode * inode;
 	struct ext4_dir_entry_2 * de;
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -49,7 +49,7 @@
 #define VXFS_BLOCK_PER_PAGE(sbp)  ((PAGE_CACHE_SIZE / (sbp)->s_blocksize))
 
 
-static struct dentry *	vxfs_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *	vxfs_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 static int		vxfs_readdir(struct file *, void *, filldir_t);
 
 const struct inode_operations vxfs_dir_inode_ops = {
@@ -202,7 +202,7 @@ vxfs_inode_by_name(struct inode *dip, st
  *   in the return pointer.
  */
 static struct dentry *
-vxfs_lookup(struct inode *dip, struct dentry *dp, struct nameidata *nd)
+vxfs_lookup(struct inode *dip, struct dentry *dp, struct vfs_lookup *lookup)
 {
 	struct inode		*ip = NULL;
 	ino_t			ino;
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -221,7 +221,7 @@ static int fuse_d_add_directory(struct d
 }
 
 static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
-				  struct nameidata *nd)
+				  struct vfs_lookup *lookup)
 {
 	int err;
 	struct fuse_entry_out outarg;
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -95,7 +95,7 @@ static int gfs2_create(struct inode *dir
  * gfs2_lookup - Look up a filename in a directory and return its inode
  * @dir: The directory inode
  * @dentry: The dentry of the new inode
- * @nd: passed from Linux VFS, ignored by us
+ * @lookup: passed from Linux VFS, ignored by us
  *
  * Called by the VFS layer. Lock dir and call gfs2_lookupi()
  *
@@ -103,13 +103,13 @@ static int gfs2_create(struct inode *dir
  */
 
 static struct dentry *gfs2_lookup(struct inode *dir, struct dentry *dentry,
-				  struct nameidata *nd)
+				  struct vfs_lookup *lookup)
 {
 	struct inode *inode = NULL;
 
 	dentry->d_op = &gfs2_dops;
 
-	inode = gfs2_lookupi(dir, &dentry->d_name, 0, &nd->lookup);
+	inode = gfs2_lookupi(dir, &dentry->d_name, 0, lookup);
 	if (inode && IS_ERR(inode))
 		return ERR_PTR(PTR_ERR(inode));
 
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -18,7 +18,7 @@
  * hfs_lookup()
  */
 static struct dentry *hfs_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd)
+				 struct vfs_lookup *lookup)
 {
 	hfs_cat_rec rec;
 	struct hfs_find_data fd;
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -459,7 +459,7 @@ out:
 }
 
 static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nd)
+				      struct vfs_lookup *lookup)
 {
 	struct inode *inode = NULL;
 	hfs_cat_rec rec;
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -25,7 +25,7 @@ static inline void hfsplus_instantiate(s
 
 /* Find the entry inside dir named dentry->d_name */
 static struct dentry *hfsplus_lookup(struct inode *dir, struct dentry *dentry,
-				     struct nameidata *nd)
+				     struct vfs_lookup *lookup)
 {
 	struct inode *inode = NULL;
 	struct hfs_find_data fd;
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -137,7 +137,7 @@ struct dentry_operations hfsplus_dentry_
 };
 
 static struct dentry *hfsplus_file_lookup(struct inode *dir, struct dentry *dentry,
-					  struct nameidata *nd)
+					  struct vfs_lookup *lookup)
 {
 	struct hfs_find_data fd;
 	struct super_block *sb = dir->i_sb;
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -184,7 +184,8 @@ out:
  *	      to tell read_inode to read fnode or not.
  */
 
-struct dentry *hpfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *hpfs_lookup(struct inode *dir, struct dentry *dentry,
+			   struct vfs_lookup *lookup)
 {
 	const char *name = dentry->d_name.name;
 	unsigned len = dentry->d_name.len;
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -238,7 +238,7 @@ void hpfs_set_dentry_operations(struct d
 
 /* dir.c */
 
-struct dentry *hpfs_lookup(struct inode *, struct dentry *, struct nameidata *);
+struct dentry *hpfs_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 extern const struct file_operations hpfs_dir_ops;
 
 /* dnode.c */
--- a/fs/isofs/isofs.h
+++ b/fs/isofs/isofs.h
@@ -112,7 +112,7 @@ extern int isofs_name_translate(struct i
 int get_joliet_filename(struct iso_directory_record *, unsigned char *, struct inode *);
 int get_acorn_filename(struct iso_directory_record *, char *, struct inode *);
 
-extern struct dentry *isofs_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *isofs_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 extern struct buffer_head *isofs_bread(struct inode *, sector_t);
 extern int isofs_get_blocks(struct inode *, sector_t, struct buffer_head **, unsigned long);
 
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -155,7 +155,7 @@ isofs_find_entry(struct inode *dir, stru
 	return 0;
 }
 
-struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	int found;
 	unsigned long block, offset;
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -24,7 +24,7 @@ static int jffs2_readdir (struct file *,
 static int jffs2_create (struct inode *,struct dentry *,int,
 			 struct vfs_lookup *);
 static struct dentry *jffs2_lookup (struct inode *,struct dentry *,
-				    struct nameidata *);
+				    struct vfs_lookup *);
 static int jffs2_link (struct dentry *,struct inode *,struct dentry *);
 static int jffs2_unlink (struct inode *,struct dentry *);
 static int jffs2_symlink (struct inode *,struct dentry *,const char *);
@@ -70,7 +70,7 @@ const struct inode_operations jffs2_dir_
    nice and simple
 */
 static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
-				   struct nameidata *nd)
+				   struct vfs_lookup *lookup)
 {
 	struct jffs2_inode_info *dir_f;
 	struct jffs2_sb_info *c;
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1428,7 +1428,7 @@ static int jfs_mknod(struct inode *dir, 
 	return rc;
 }
 
-static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct btstack btstack;
 	ino_t inum;
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -41,7 +41,7 @@ static int simple_delete_dentry(struct d
  * Lookup the data. This is trivial - if the dentry didn't already
  * exist, we know it is negative.  Set d_op to delete negative dentries.
  */
-struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	static struct dentry_operations simple_dentry_operations = {
 		.d_delete = simple_delete_dentry,
--- a/fs/minix/namei.c
+++ b/fs/minix/namei.c
@@ -42,7 +42,7 @@ struct dentry_operations minix_dentry_op
 	.d_hash		= minix_hash,
 };
 
-static struct dentry *minix_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *minix_lookup(struct inode * dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode * inode = NULL;
 	ino_t ino;
--- a/fs/msdos/namei.c
+++ b/fs/msdos/namei.c
@@ -205,7 +205,7 @@ static struct dentry_operations msdos_de
 
 /***** Get inode using directory and name */
 static struct dentry *msdos_lookup(struct inode *dir, struct dentry *dentry,
-				   struct nameidata *nd)
+				   struct vfs_lookup *lookup)
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -495,7 +495,7 @@ static struct dentry * real_lookup(struc
 		struct dentry * dentry = d_alloc(parent, name);
 		result = ERR_PTR(-ENOMEM);
 		if (dentry) {
-			result = dir->i_op->lookup(dir, dentry, nd);
+			result = dir->i_op->lookup(dir, dentry, &nd->lookup);
 			if (result)
 				dput(dentry);
 			else
@@ -1300,7 +1300,7 @@ static inline struct dentry *__lookup_ha
 		dentry = ERR_PTR(-ENOMEM);
 		if (!new)
 			goto out;
-		dentry = inode->i_op->lookup(inode, new, nd);
+		dentry = inode->i_op->lookup(inode, new, &nd->lookup);
 		if (!dentry)
 			dentry = new;
 		else
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -34,7 +34,7 @@ static void ncp_do_readdir(struct file *
 static int ncp_readdir(struct file *, void *, filldir_t);
 
 static int ncp_create(struct inode *, struct dentry *, int, struct vfs_lookup *);
-static struct dentry *ncp_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *ncp_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 static int ncp_unlink(struct inode *, struct dentry *);
 static int ncp_mkdir(struct inode *, struct dentry *, int);
 static int ncp_rmdir(struct inode *, struct dentry *);
@@ -791,7 +791,7 @@ out:
 	return result;
 }
 
-static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ncp_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct ncp_server *server = NCP_SERVER(dir);
 	struct inode *inode = NULL;
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -43,7 +43,7 @@
 
 static int nfs_opendir(struct inode *, struct file *);
 static int nfs_readdir(struct file *, void *, filldir_t);
-static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *nfs_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 static int nfs_create(struct inode *, struct dentry *, int, struct vfs_lookup *);
 static int nfs_mkdir(struct inode *, struct dentry *, int);
 static int nfs_rmdir(struct inode *, struct dentry *);
@@ -103,7 +103,7 @@ const struct inode_operations nfs3_dir_i
 
 #ifdef CONFIG_NFS_V4
 
-static struct dentry *nfs_atomic_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *nfs_atomic_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 const struct inode_operations nfs4_dir_inode_operations = {
 	.create		= nfs_create,
 	.lookup		= nfs_atomic_lookup,
@@ -908,7 +908,7 @@ static inline int nfs_reval_fsid(struct 
 	return 0;
 }
 
-static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *nfs_lookup(struct inode *dir, struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	struct dentry *res;
 	struct inode *inode = NULL;
@@ -933,7 +933,7 @@ static struct dentry *nfs_lookup(struct 
 	 * If we're doing an exclusive create, optimize away the lookup
 	 * but don't hash the dentry.
 	 */
-	if (nfs_is_exclusive_create(dir, &nd->lookup)) {
+	if (nfs_is_exclusive_create(dir, lookup)) {
 		d_instantiate(dentry, NULL);
 		res = NULL;
 		goto out_unlock;
@@ -1004,7 +1004,7 @@ static int is_atomic_open(struct inode *
 	return 1;
 }
 
-static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct dentry *res = NULL;
 	int error;
@@ -1013,7 +1013,7 @@ static struct dentry *nfs_atomic_lookup(
 			dir->i_sb->s_id, dir->i_ino, dentry->d_name.name);
 
 	/* Check that we are indeed trying to open this file */
-	if (!is_atomic_open(dir, &nd->lookup))
+	if (!is_atomic_open(dir, lookup))
 		goto no_open;
 
 	if (dentry->d_name.len > NFS_SERVER(dir)->namelen) {
@@ -1023,7 +1023,7 @@ static struct dentry *nfs_atomic_lookup(
 	dentry->d_op = NFS_PROTO(dir)->dentry_ops;
 
 	/* Let vfs_create() deal with O_EXCL */
-	if (nd->lookup.intent.open.flags & O_EXCL) {
+	if (lookup->intent.open.flags & O_EXCL) {
 		d_add(dentry, NULL);
 		goto out;
 	}
@@ -1038,12 +1038,12 @@ static struct dentry *nfs_atomic_lookup(
 		goto out;
 	}
 
-	if (nd->lookup.intent.open.flags & O_CREAT) {
+	if (lookup->intent.open.flags & O_CREAT) {
 		nfs_begin_data_update(dir);
-		res = nfs4_atomic_open(dir, dentry, nd);
+		res = nfs4_atomic_open(dir, dentry, lookup);
 		nfs_end_data_update(dir);
 	} else
-		res = nfs4_atomic_open(dir, dentry, nd);
+		res = nfs4_atomic_open(dir, dentry, lookup);
 	unlock_kernel();
 	if (IS_ERR(res)) {
 		error = PTR_ERR(res);
@@ -1057,7 +1057,7 @@ static struct dentry *nfs_atomic_lookup(
 			case -ENOTDIR:
 				goto no_open;
 			case -ELOOP:
-				if (!(nd->lookup.intent.open.flags & O_NOFOLLOW))
+				if (!(lookup->intent.open.flags & O_NOFOLLOW))
 					goto no_open;
 			/* case -EINVAL: */
 			default:
@@ -1070,7 +1070,7 @@ static struct dentry *nfs_atomic_lookup(
 out:
 	return res;
 no_open:
-	return nfs_lookup(dir, dentry, nd);
+	return nfs_lookup(dir, dentry, lookup);
 }
 
 static int nfs_open_revalidate(struct dentry *dentry, struct vfs_lookup *lookup)
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -179,7 +179,7 @@ extern int nfs4_proc_setclientid_confirm
 extern int nfs4_proc_async_renew(struct nfs_client *, struct rpc_cred *);
 extern int nfs4_proc_renew(struct nfs_client *, struct rpc_cred *);
 extern int nfs4_do_close(struct path *path, struct nfs4_state *state);
-extern struct dentry *nfs4_atomic_open(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *nfs4_atomic_open(struct inode *, struct dentry *, struct vfs_lookup *);
 extern int nfs4_open_revalidate(struct inode *, struct dentry *, int, struct vfs_lookup *);
 extern int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle);
 extern int nfs4_proc_fs_locations(struct inode *dir, const struct qstr *name,
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1403,10 +1403,11 @@ out_close:
 }
 
 struct dentry *
-nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+nfs4_atomic_open(struct inode *dir, struct dentry *dentry,
+		 struct vfs_lookup *lookup)
 {
 	struct path path = {
-		.mnt = nd->lookup.path.mnt,
+		.mnt = lookup->path.mnt,
 		.dentry = dentry,
 	};
 	struct iattr attr;
@@ -1414,20 +1415,21 @@ nfs4_atomic_open(struct inode *dir, stru
 	struct nfs4_state *state;
 	struct dentry *res;
 
-	if (nd->lookup.flags & LOOKUP_CREATE) {
-		attr.ia_mode = nd->lookup.intent.open.create_mode;
+	if (lookup->flags & LOOKUP_CREATE) {
+		attr.ia_mode = lookup->intent.open.create_mode;
 		attr.ia_valid = ATTR_MODE;
 		if (!IS_POSIXACL(dir))
 			attr.ia_mode &= ~current->fs->umask;
 	} else {
 		attr.ia_valid = 0;
-		BUG_ON(nd->lookup.intent.open.flags & O_CREAT);
+		BUG_ON(lookup->intent.open.flags & O_CREAT);
 	}
 
 	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
 	if (IS_ERR(cred))
 		return (struct dentry *)cred;
-	state = nfs4_do_open(dir, &path, nd->lookup.intent.open.flags, &attr, cred);
+	state = nfs4_do_open(dir, &path, lookup->intent.open.flags, &attr,
+			     cred);
 	put_rpccred(cred);
 	if (IS_ERR(state)) {
 		if (PTR_ERR(state) == -ENOENT)
@@ -1437,7 +1439,7 @@ nfs4_atomic_open(struct inode *dir, stru
 	res = d_add_unique(dentry, igrab(state->inode));
 	if (res != NULL)
 		dentry = res;
-	nfs4_intent_set_file(&nd->lookup, &path, state);
+	nfs4_intent_set_file(lookup, &path, state);
 	return res;
 }
 
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -34,7 +34,7 @@
  * ntfs_lookup - find the inode represented by a dentry in a directory inode
  * @dir_ino:	directory inode in which to look for the inode
  * @dent:	dentry representing the inode to look for
- * @nd:		lookup nameidata
+ * @lookup:		lookup nameidata
  *
  * In short, ntfs_lookup() looks for the inode represented by the dentry @dent
  * in the directory inode @dir_ino and if found attaches the inode to the
@@ -100,7 +100,7 @@
  * Locking: Caller must hold i_mutex on the directory.
  */
 static struct dentry *ntfs_lookup(struct inode *dir_ino, struct dentry *dent,
-		struct nameidata *nd)
+		struct vfs_lookup *lookup)
 {
 	ntfs_volume *vol = NTFS_SB(dir_ino->i_sb);
 	struct inode *dent_inode;
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -138,7 +138,7 @@ static inline int ocfs2_add_entry(handle
 #define OCFS2_ORPHAN_NAMELEN ((int)(2 * sizeof(u64)))
 
 static struct dentry *ocfs2_lookup(struct inode *dir, struct dentry *dentry,
-				   struct nameidata *nd)
+				   struct vfs_lookup *lookup)
 {
 	int status;
 	u64 blkno;
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1444,7 +1444,7 @@ out_no_task:
 }
 
 static struct dentry *proc_lookupfd(struct inode *dir, struct dentry *dentry,
-				    struct nameidata *nd)
+				    struct vfs_lookup *lookup)
 {
 	return proc_lookupfd_common(dir, dentry, proc_fd_instantiate);
 }
@@ -1527,7 +1527,7 @@ static struct dentry *proc_fdinfo_instan
 
 static struct dentry *proc_lookupfdinfo(struct inode *dir,
 					struct dentry *dentry,
-					struct nameidata *nd)
+					struct vfs_lookup *lookup)
 {
 	return proc_lookupfd_common(dir, dentry, proc_fdinfo_instantiate);
 }
@@ -1772,7 +1772,8 @@ static const struct file_operations proc
 };
 
 static struct dentry *proc_attr_dir_lookup(struct inode *dir,
-				struct dentry *dentry, struct nameidata *nd)
+				struct dentry *dentry,
+				struct vfs_lookup *lookup)
 {
 	return proc_pident_lookup(dir, dentry,
 				  attr_dir_stuff, ARRAY_SIZE(attr_dir_stuff));
@@ -2112,7 +2113,7 @@ static const struct file_operations proc
 	.readdir	= proc_tgid_base_readdir,
 };
 
-static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){
+static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup){
 	return proc_pident_lookup(dir, dentry,
 				  tgid_base_stuff, ARRAY_SIZE(tgid_base_stuff));
 }
@@ -2220,7 +2221,7 @@ out:
 	return error;
 }
 
-struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	struct dentry *result = ERR_PTR(-ENOENT);
 	struct task_struct *task;
@@ -2387,7 +2388,7 @@ static int proc_tid_base_readdir(struct 
 				   tid_base_stuff,ARRAY_SIZE(tid_base_stuff));
 }
 
-static struct dentry *proc_tid_base_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd){
+static struct dentry *proc_tid_base_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup){
 	return proc_pident_lookup(dir, dentry,
 				  tid_base_stuff, ARRAY_SIZE(tid_base_stuff));
 }
@@ -2431,7 +2432,7 @@ out:
 	return error;
 }
 
-static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *proc_task_lookup(struct inode *dir, struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	struct dentry *result = ERR_PTR(-ENOENT);
 	struct task_struct *task;
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -383,7 +383,7 @@ static struct dentry_operations proc_den
  * Don't create negative dentries here, return -ENOENT by hand
  * instead.
  */
-struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry *proc_lookup(struct inode * dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode *inode = NULL;
 	struct proc_dir_entry * de;
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -139,7 +139,7 @@ static struct ctl_table *do_proc_sys_loo
 }
 
 static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
-					struct nameidata *nd)
+					struct vfs_lookup *lookup)
 {
 	struct ctl_table_header *head;
 	struct inode *inode;
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -90,13 +90,13 @@ static int proc_root_getattr(struct vfsm
 	return 0;
 }
 
-static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *proc_root_lookup(struct inode * dir, struct dentry * dentry, struct vfs_lookup *lookup)
 {
-	if (!proc_lookup(dir, dentry, nd)) {
+	if (!proc_lookup(dir, dentry, lookup)) {
 		return NULL;
 	}
 	
-	return proc_pid_lookup(dir, dentry, nd);
+	return proc_pid_lookup(dir, dentry, lookup);
 }
 
 static int proc_root_readdir(struct file * filp,
--- a/fs/qnx4/namei.c
+++ b/fs/qnx4/namei.c
@@ -106,7 +106,7 @@ static struct buffer_head *qnx4_find_ent
 	return NULL;
 }
 
-struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	int ino;
 	struct qnx4_inode_entry *de;
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -324,7 +324,7 @@ static int reiserfs_find_entry(struct in
 }
 
 static struct dentry *reiserfs_lookup(struct inode *dir, struct dentry *dentry,
-				      struct nameidata *nd)
+				      struct vfs_lookup *lookup)
 {
 	int retval;
 	struct inode *inode = NULL;
--- a/fs/romfs/inode.c
+++ b/fs/romfs/inode.c
@@ -332,7 +332,8 @@ out:
 }
 
 static struct dentry *
-romfs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+romfs_lookup(struct inode *dir, struct dentry *dentry,
+	     struct vfs_lookup *lookup)
 {
 	unsigned long offset, maxoff;
 	int fslen, res;
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -25,7 +25,7 @@
 static int smb_readdir(struct file *, void *, filldir_t);
 static int smb_dir_open(struct inode *, struct file *);
 
-static struct dentry *smb_lookup(struct inode *, struct dentry *, struct nameidata *);
+static struct dentry *smb_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 static int smb_create(struct inode *, struct dentry *, int, struct vfs_lookup *);
 static int smb_mkdir(struct inode *, struct dentry *, int);
 static int smb_rmdir(struct inode *, struct dentry *);
@@ -424,7 +424,7 @@ smb_renew_times(struct dentry * dentry)
 }
 
 static struct dentry *
-smb_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+smb_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct smb_fattr finfo;
 	struct inode *inode;
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -760,7 +760,7 @@ static int sysfs_count_nlink(struct sysf
 }
 
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
-				struct nameidata *nd)
+				struct vfs_lookup *lookup)
 {
 	struct sysfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct sysfs_dirent * sd;
--- a/fs/sysv/namei.c
+++ b/fs/sysv/namei.c
@@ -42,7 +42,7 @@ struct dentry_operations sysv_dentry_ope
 	.d_hash		= sysv_hash,
 };
 
-static struct dentry *sysv_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *sysv_lookup(struct inode * dir, struct dentry * dentry, struct vfs_lookup *lookup)
 {
 	struct inode * inode = NULL;
 	ino_t ino;
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -276,7 +276,7 @@ static struct fileIdentDesc *udf_find_en
  */
 
 static struct dentry *udf_lookup(struct inode *dir, struct dentry *dentry,
-				 struct nameidata *nd)
+				 struct vfs_lookup *lookup)
 {
 	struct inode *inode = NULL;
 	struct fileIdentDesc cfi;
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -46,7 +46,7 @@ static inline int ufs_add_nondir(struct 
 	return err;
 }
 
-static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
+static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, struct vfs_lookup *lookup)
 {
 	struct inode * inode = NULL;
 	ino_t ino;
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -684,7 +684,7 @@ static int vfat_find(struct inode *dir, 
 }
 
 static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
-				  struct nameidata *nd)
+				  struct vfs_lookup *lookup)
 {
 	struct super_block *sb = dir->i_sb;
 	struct fat_slot_info sinfo;
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -385,7 +385,7 @@ STATIC struct dentry *
 xfs_vn_lookup(
 	struct inode	*dir,
 	struct dentry	*dentry,
-	struct nameidata *nd)
+	struct vfs_lookup *lookup)
 {
 	bhv_vnode_t	*vp = vn_from_inode(dir), *cvp;
 	int		error;
--- a/include/linux/efs_fs.h
+++ b/include/linux/efs_fs.h
@@ -44,7 +44,7 @@ extern void efs_read_inode(struct inode 
 extern efs_block_t efs_map_block(struct inode *, efs_block_t);
 extern int efs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
-extern struct dentry *efs_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *efs_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 extern struct dentry *efs_get_dentry(struct super_block *sb, void *vobjp);
 extern struct dentry *efs_get_parent(struct dentry *);
 extern int efs_bmap(struct inode *, int);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1134,7 +1134,7 @@ struct file_operations {
 
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *,int, struct vfs_lookup *);
-	struct dentry * (*lookup) (struct inode *,struct dentry *, struct nameidata *);
+	struct dentry * (*lookup) (struct inode *,struct dentry *, struct vfs_lookup *);
 	int (*link) (struct dentry *,struct inode *,struct dentry *);
 	int (*unlink) (struct inode *,struct dentry *);
 	int (*symlink) (struct inode *,struct dentry *,const char *);
@@ -1817,7 +1817,7 @@ extern int simple_prepare_write(struct f
 extern int simple_commit_write(struct file *file, struct page *page,
 				unsigned offset, unsigned to);
 
-extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *simple_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 extern ssize_t generic_read_dir(struct file *, char __user *, size_t, loff_t *);
 extern const struct file_operations simple_dir_operations;
 extern const struct inode_operations simple_dir_inode_operations;
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -112,7 +112,7 @@ extern void proc_misc_init(void);
 struct mm_struct;
 
 void proc_flush_task(struct task_struct *task);
-struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
+struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct vfs_lookup *);
 int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
 unsigned long task_vsize(struct mm_struct *);
 int task_statm(struct mm_struct *, int *, int *, int *, int *);
@@ -138,7 +138,7 @@ extern struct inode *proc_get_inode(stru
  * of the /proc/<pid> subdirectories.
  */
 extern int proc_readdir(struct file *, void *, filldir_t);
-extern struct dentry *proc_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *proc_lookup(struct inode *, struct dentry *, struct vfs_lookup *);
 
 extern const struct file_operations proc_kcore_operations;
 extern const struct file_operations proc_kmsg_operations;
--- a/include/linux/qnx4_fs.h
+++ b/include/linux/qnx4_fs.h
@@ -110,7 +110,7 @@ struct qnx4_inode_info {
 	struct inode vfs_inode;
 };
 
-extern struct dentry *qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd);
+extern struct dentry *qnx4_lookup(struct inode *dir, struct dentry *dentry, struct vfs_lookup *lookup);
 extern unsigned long qnx4_count_free_blocks(struct super_block *sb);
 extern unsigned long qnx4_block_map(struct inode *inode, long iblock);
 

