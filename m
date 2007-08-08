Return-Path: <linux-kernel-owner+w=401wt.eu-S937479AbXHHRVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937479AbXHHRVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937329AbXHHRTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:19:14 -0400
Received: from mail.suse.de ([195.135.220.2]:38760 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933936AbXHHRTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:19:03 -0400
Message-Id: <20070808171643.662840630@suse.de>
References: <20070808171622.632749741@suse.de>
User-Agent: quilt/0.46-1
Date: Wed, 08 Aug 2007 19:16:24 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <jjohansen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [RFC 02/10] Switch from nd->{mnt,dentry} to nd->lookup.path.{mnt,dentry}
Content-Disposition: inline; filename=nameidata-split-2.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Switch from nd->{mnt,dentry} to nd->lookup.path.{mnt,dentry}, and from
nd->{flags,intent} to nd->lookup.{flags,intent} in the vfs and in file
systems to match the new nameidata layout.

The code generated should still be the same.

Signed-off-by: Andreas Gruenbacher <ag@bestbits.at>

---
 drivers/md/dm-table.c        |    2 
 drivers/mtd/mtdsuper.c       |   10 -
 fs/9p/vfs_inode.c            |    6 
 fs/afs/mntpt.c               |   22 +--
 fs/autofs4/root.c            |   12 -
 fs/block_dev.c               |    4 
 fs/cifs/dir.c                |    6 
 fs/coda/pioctl.c             |    2 
 fs/compat.c                  |    4 
 fs/configfs/symlink.c        |    4 
 fs/dquot.c                   |    6 
 fs/ecryptfs/dentry.c         |   12 -
 fs/ecryptfs/inode.c          |   26 ++--
 fs/ecryptfs/main.c           |    4 
 fs/exec.c                    |    8 -
 fs/ext3/super.c              |    4 
 fs/ext4/super.c              |    4 
 fs/fuse/dir.c                |    6 
 fs/gfs2/ops_fstype.c         |    4 
 fs/gfs2/ops_inode.c          |    2 
 fs/inotify_user.c            |    2 
 fs/namei.c                   |  270 +++++++++++++++++++++----------------------
 fs/namespace.c               |  168 +++++++++++++-------------
 fs/nfs/dir.c                 |   28 ++--
 fs/nfs/namespace.c           |   24 +--
 fs/nfs/nfs4proc.c            |   22 +--
 fs/nfsctl.c                  |    2 
 fs/nfsd/export.c             |   34 ++---
 fs/nfsd/nfs4recover.c        |   32 ++---
 fs/nfsd/nfs4state.c          |    2 
 fs/open.c                    |   44 +++----
 fs/proc/base.c               |    2 
 fs/proc/proc_sysctl.c        |    2 
 fs/reiserfs/super.c          |    6 
 fs/stat.c                    |   12 -
 fs/utimes.c                  |    2 
 fs/vfat/namei.c              |    2 
 fs/xattr.c                   |   16 +-
 fs/xfs/linux-2.6/xfs_ioctl.c |    6 
 kernel/auditfilter.c         |    8 -
 net/sunrpc/rpc_pipe.c        |    4 
 net/unix/af_unix.c           |   20 +--
 security/selinux/hooks.c     |    4 
 43 files changed, 430 insertions(+), 430 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -356,7 +356,7 @@ static int lookup_device(const char *pat
 	if ((r = path_lookup(path, LOOKUP_FOLLOW, &nd)))
 		return r;
 
-	inode = nd.dentry->d_inode;
+	inode = nd.lookup.path.dentry->d_inode;
 	if (!inode) {
 		r = -ENOENT;
 		goto out;
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -182,25 +182,25 @@ int get_sb_mtd(struct file_system_type *
 	ret = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
 
 	DEBUG(1, "MTDSB: path_lookup() returned %d, inode %p\n",
-	      ret, nd.dentry ? nd.dentry->d_inode : NULL);
+	      ret, nd.lookup.path.dentry ? nd.lookup.path.dentry->d_inode : NULL);
 
 	if (ret)
 		return ret;
 
 	ret = -EINVAL;
 
-	if (!S_ISBLK(nd.dentry->d_inode->i_mode))
+	if (!S_ISBLK(nd.lookup.path.dentry->d_inode->i_mode))
 		goto out;
 
-	if (nd.mnt->mnt_flags & MNT_NODEV) {
+	if (nd.lookup.path.mnt->mnt_flags & MNT_NODEV) {
 		ret = -EACCES;
 		goto out;
 	}
 
-	if (imajor(nd.dentry->d_inode) != MTD_BLOCK_MAJOR)
+	if (imajor(nd.lookup.path.dentry->d_inode) != MTD_BLOCK_MAJOR)
 		goto not_an_MTD_device;
 
-	mtdnr = iminor(nd.dentry->d_inode);
+	mtdnr = iminor(nd.lookup.path.dentry->d_inode);
 	path_release(&nd);
 
 	return get_sb_mtd_nr(fs_type, flags, dev_name, data, mtdnr, fill_super,
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -478,8 +478,8 @@ v9fs_vfs_create(struct inode *dir, struc
 	fid = NULL;
 	v9ses = v9fs_inode2v9ses(dir);
 	perm = unixmode2p9mode(v9ses, mode);
-	if (nd && nd->flags & LOOKUP_OPEN)
-		flags = nd->intent.open.flags - 1;
+	if (nd && nd->lookup.flags & LOOKUP_OPEN)
+		flags = nd->lookup.intent.open.flags - 1;
 	else
 		flags = O_RDWR;
 
@@ -492,7 +492,7 @@ v9fs_vfs_create(struct inode *dir, struc
 	}
 
 	/* if we are opening a file, assign the open fid to the file */
-	if (nd && nd->flags & LOOKUP_OPEN) {
+	if (nd && nd->lookup.flags & LOOKUP_OPEN) {
 		filp = lookup_instantiate_filp(nd, dentry, v9fs_open_created);
 		if (IS_ERR(filp)) {
 			err = PTR_ERR(filp);
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -218,14 +218,14 @@ static void *afs_mntpt_follow_link(struc
 	_enter("%p{%s},{%s:%p{%s},}",
 	       dentry,
 	       dentry->d_name.name,
-	       nd->mnt->mnt_devname,
+	       nd->lookup.path.mnt->mnt_devname,
 	       dentry,
-	       nd->dentry->d_name.name);
+	       nd->lookup.path.dentry->d_name.name);
 
-	dput(nd->dentry);
-	nd->dentry = dget(dentry);
+	dput(nd->lookup.path.dentry);
+	nd->lookup.path.dentry = dget(dentry);
 
-	newmnt = afs_mntpt_do_automount(nd->dentry);
+	newmnt = afs_mntpt_do_automount(nd->lookup.path.dentry);
 	if (IS_ERR(newmnt)) {
 		path_release(nd);
 		return (void *)newmnt;
@@ -235,17 +235,17 @@ static void *afs_mntpt_follow_link(struc
 	err = do_add_mount(newmnt, nd, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		mntput(nd->mnt);
-		dput(nd->dentry);
-		nd->mnt = newmnt;
-		nd->dentry = dget(newmnt->mnt_root);
+		mntput(nd->lookup.path.mnt);
+		dput(nd->lookup.path.dentry);
+		nd->lookup.path.mnt = newmnt;
+		nd->lookup.path.dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
 				      afs_mntpt_expiry_timeout * HZ);
 		break;
 	case -EBUSY:
 		/* someone else made a mount here whilst we were busy */
-		while (d_mountpoint(nd->dentry) &&
-		       follow_down(&nd->mnt, &nd->dentry))
+		while (d_mountpoint(nd->lookup.path.dentry) &&
+		       follow_down(&nd->lookup.path.mnt, &nd->lookup.path.dentry))
 			;
 		err = 0;
 	default:
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -133,7 +133,7 @@ static int autofs4_dir_open(struct inode
 		if (!empty)
 			d_invalidate(dentry);
 
-		nd.flags = LOOKUP_DIRECTORY;
+		nd.lookup.flags = LOOKUP_DIRECTORY;
 		ret = (dentry->d_op->d_revalidate)(dentry, &nd);
 
 		if (ret <= 0) {
@@ -330,12 +330,12 @@ static void *autofs4_follow_link(struct 
 	unsigned int lookup_type;
 	int status;
 
-	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
+	DPRINTK("dentry=%p %.*s oz_mode=%d nd->lookup.flags=%d",
 		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
-		nd->flags);
+		nd->lookup.flags);
 
 	/* If it's our master or we shouldn't trigger a mount we're done */
-	lookup_type = nd->flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY);
+	lookup_type = nd->lookup.flags & (LOOKUP_CONTINUE | LOOKUP_DIRECTORY);
 	if (oz_mode || !lookup_type)
 		goto done;
 
@@ -368,7 +368,7 @@ static void *autofs4_follow_link(struct 
 		 * so we don't need to follow the mount.
 		 */
 		if (d_mountpoint(dentry)) {
-			if (!autofs4_follow_mount(&nd->mnt, &nd->dentry)) {
+			if (!autofs4_follow_mount(&nd->lookup.path.mnt, &nd->lookup.path.dentry)) {
 				status = -ENOENT;
 				goto out_error;
 			}
@@ -397,7 +397,7 @@ static int autofs4_revalidate(struct den
 	struct inode *dir = dentry->d_parent->d_inode;
 	struct autofs_sb_info *sbi = autofs4_sbi(dir->i_sb);
 	int oz_mode = autofs4_oz_mode(sbi);
-	int flags = nd ? nd->flags : 0;
+	int flags = nd ? nd->lookup.flags : 0;
 	int status = 1;
 
 	/* Pending dentry */
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1386,12 +1386,12 @@ struct block_device *lookup_bdev(const c
 	if (error)
 		return ERR_PTR(error);
 
-	inode = nd.dentry->d_inode;
+	inode = nd.lookup.path.dentry->d_inode;
 	error = -ENOTBLK;
 	if (!S_ISBLK(inode->i_mode))
 		goto fail;
 	error = -EACCES;
-	if (nd.mnt->mnt_flags & MNT_NODEV)
+	if (nd.lookup.path.mnt->mnt_flags & MNT_NODEV)
 		goto fail;
 	error = -ENOMEM;
 	bdev = bd_acquire(inode);
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -153,8 +153,8 @@ cifs_create(struct inode *inode, struct 
 		return -ENOMEM;
 	}
 
-	if (nd && (nd->flags & LOOKUP_OPEN)) {
-		int oflags = nd->intent.open.flags;
+	if (nd && (nd->lookup.flags & LOOKUP_OPEN)) {
+		int oflags = nd->lookup.intent.open.flags;
 
 		desiredAccess = 0;
 		if (oflags & FMODE_READ)
@@ -264,7 +264,7 @@ cifs_create(struct inode *inode, struct 
 			d_instantiate(direntry, newinode);
 		}
 		if ((nd == NULL /* nfsd case - nfs srv does not set nd */) ||
-			((nd->flags & LOOKUP_OPEN) == FALSE)) {
+			((nd->lookup.flags & LOOKUP_OPEN) == FALSE)) {
 			/* mknod case - do not leave file open */
 			CIFSSMBClose(xid, pTcon, fileHandle);
 		} else if (newinode) {
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -75,7 +75,7 @@ static int coda_pioctl(struct inode * in
 	if ( error ) {
 		return error;
         } else {
-	        target_inode = nd.dentry->d_inode;
+	        target_inode = nd.lookup.path.dentry->d_inode;
 	}
 	
 	/* return if it is not a Coda inode */
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -241,7 +241,7 @@ asmlinkage long compat_sys_statfs(const 
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct kstatfs tmp;
-		error = vfs_statfs(nd.dentry, &tmp);
+		error = vfs_statfs(nd.lookup.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs(buf, &tmp);
 		path_release(&nd);
@@ -309,7 +309,7 @@ asmlinkage long compat_sys_statfs64(cons
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct kstatfs tmp;
-		error = vfs_statfs(nd.dentry, &tmp);
+		error = vfs_statfs(nd.lookup.path.dentry, &tmp);
 		if (!error)
 			error = put_compat_statfs64(buf, &tmp);
 		path_release(&nd);
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -99,8 +99,8 @@ static int get_target(const char *symnam
 
 	ret = path_lookup(symname, LOOKUP_FOLLOW|LOOKUP_DIRECTORY, nd);
 	if (!ret) {
-		if (nd->dentry->d_sb == configfs_sb) {
-			*target = configfs_get_config_item(nd->dentry);
+		if (nd->lookup.path.dentry->d_sb == configfs_sb) {
+			*target = configfs_get_config_item(nd->lookup.path.dentry);
 			if (!*target) {
 				ret = -ENOENT;
 				path_release(nd);
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -1543,14 +1543,14 @@ int vfs_quota_on(struct super_block *sb,
 	error = path_lookup(path, LOOKUP_FOLLOW, &nd);
 	if (error < 0)
 		return error;
-	error = security_quota_on(nd.dentry);
+	error = security_quota_on(nd.lookup.path.dentry);
 	if (error)
 		goto out_path;
 	/* Quota file not on the same filesystem? */
-	if (nd.mnt->mnt_sb != sb)
+	if (nd.lookup.path.mnt->mnt_sb != sb)
 		error = -EXDEV;
 	else
-		error = vfs_quota_on_inode(nd.dentry->d_inode, type, format_id);
+		error = vfs_quota_on_inode(nd.lookup.path.dentry->d_inode, type, format_id);
 out_path:
 	path_release(&nd);
 	return error;
--- a/fs/ecryptfs/dentry.c
+++ b/fs/ecryptfs/dentry.c
@@ -51,13 +51,13 @@ static int ecryptfs_d_revalidate(struct 
 
 	if (!lower_dentry->d_op || !lower_dentry->d_op->d_revalidate)
 		goto out;
-	dentry_save = nd->dentry;
-	vfsmount_save = nd->mnt;
-	nd->dentry = lower_dentry;
-	nd->mnt = lower_mnt;
+	dentry_save = nd->lookup.path.dentry;
+	vfsmount_save = nd->lookup.path.mnt;
+	nd->lookup.path.dentry = lower_dentry;
+	nd->lookup.path.mnt = lower_mnt;
 	rc = lower_dentry->d_op->d_revalidate(lower_dentry, nd);
-	nd->dentry = dentry_save;
-	nd->mnt = vfsmount_save;
+	nd->lookup.path.dentry = dentry_save;
+	nd->lookup.path.mnt = vfsmount_save;
 	if (dentry->d_inode) {
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -77,13 +77,13 @@ ecryptfs_create_underlying_file(struct i
 	struct vfsmount *vfsmount_save;
 	int rc;
 
-	dentry_save = nd->dentry;
-	vfsmount_save = nd->mnt;
-	nd->dentry = lower_dentry;
-	nd->mnt = lower_mnt;
+	dentry_save = nd->lookup.path.dentry;
+	vfsmount_save = nd->lookup.path.mnt;
+	nd->lookup.path.dentry = lower_dentry;
+	nd->lookup.path.mnt = lower_mnt;
 	rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
-	nd->dentry = dentry_save;
-	nd->mnt = vfsmount_save;
+	nd->lookup.path.dentry = dentry_save;
+	nd->lookup.path.mnt = vfsmount_save;
 	return rc;
 }
 
@@ -371,7 +371,7 @@ static struct dentry *ecryptfs_lookup(st
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
 		ecryptfs_set_default_sizes(crypt_stat);
 	rc = ecryptfs_read_and_validate_header_region(page_virt, lower_dentry,
-						      nd->mnt);
+						      nd->lookup.path.mnt);
 	if (rc) {
 		rc = ecryptfs_read_and_validate_xattr_region(page_virt, dentry);
 		if (rc) {
@@ -860,14 +860,14 @@ ecryptfs_permission(struct inode *inode,
 	int rc;
 
         if (nd) {
-		struct vfsmount *vfsmnt_save = nd->mnt;
-		struct dentry *dentry_save = nd->dentry;
+		struct vfsmount *vfsmnt_save = nd->lookup.path.mnt;
+		struct dentry *dentry_save = nd->lookup.path.dentry;
 
-		nd->mnt = ecryptfs_dentry_to_lower_mnt(nd->dentry);
-		nd->dentry = ecryptfs_dentry_to_lower(nd->dentry);
+		nd->lookup.path.mnt = ecryptfs_dentry_to_lower_mnt(nd->lookup.path.dentry);
+		nd->lookup.path.dentry = ecryptfs_dentry_to_lower(nd->lookup.path.dentry);
 		rc = permission(ecryptfs_inode_to_lower(inode), mask, nd);
-		nd->mnt = vfsmnt_save;
-		nd->dentry = dentry_save;
+		nd->lookup.path.mnt = vfsmnt_save;
+		nd->lookup.path.dentry = dentry_save;
         } else
 		rc = permission(ecryptfs_inode_to_lower(inode), mask, NULL);
         return rc;
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -489,8 +489,8 @@ static int ecryptfs_read_super(struct su
 		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
 		goto out;
 	}
-	lower_root = nd.dentry;
-	lower_mnt = nd.mnt;
+	lower_root = nd.lookup.path.dentry;
+	lower_mnt = nd.lookup.path.mnt;
 	ecryptfs_set_superblock_lower(sb, lower_root->d_sb);
 	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;
 	ecryptfs_set_dentry_lower(sb->s_root, lower_root);
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -136,10 +136,10 @@ asmlinkage long sys_uselib(const char __
 		goto out;
 
 	error = -EACCES;
-	if (nd.mnt->mnt_flags & MNT_NOEXEC)
+	if (nd.lookup.path.mnt->mnt_flags & MNT_NOEXEC)
 		goto exit;
 	error = -EINVAL;
-	if (!S_ISREG(nd.dentry->d_inode->i_mode))
+	if (!S_ISREG(nd.lookup.path.dentry->d_inode->i_mode))
 		goto exit;
 
 	error = vfs_permission(&nd, MAY_READ | MAY_EXEC);
@@ -679,9 +679,9 @@ struct file *open_exec(const char *name)
 	file = ERR_PTR(err);
 
 	if (!err) {
-		struct inode *inode = nd.dentry->d_inode;
+		struct inode *inode = nd.lookup.path.dentry->d_inode;
 		file = ERR_PTR(-EACCES);
-		if (!(nd.mnt->mnt_flags & MNT_NOEXEC) &&
+		if (!(nd.lookup.path.mnt->mnt_flags & MNT_NOEXEC) &&
 		    S_ISREG(inode->i_mode)) {
 			int err = vfs_permission(&nd, MAY_EXEC);
 			file = ERR_PTR(err);
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2644,12 +2644,12 @@ static int ext3_quota_on(struct super_bl
 	if (err)
 		return err;
 	/* Quotafile not on the same filesystem? */
-	if (nd.mnt->mnt_sb != sb) {
+	if (nd.lookup.path.mnt->mnt_sb != sb) {
 		path_release(&nd);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
-	if (nd.dentry->d_parent->d_inode != sb->s_root->d_inode)
+	if (nd.lookup.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
 		printk(KERN_WARNING
 			"EXT3-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2764,12 +2764,12 @@ static int ext4_quota_on(struct super_bl
 	if (err)
 		return err;
 	/* Quotafile not on the same filesystem? */
-	if (nd.mnt->mnt_sb != sb) {
+	if (nd.lookup.path.mnt->mnt_sb != sb) {
 		path_release(&nd);
 		return -EXDEV;
 	}
 	/* Quotafile not of fs root? */
-	if (nd.dentry->d_parent->d_inode != sb->s_root->d_inode)
+	if (nd.lookup.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
 		printk(KERN_WARNING
 			"EXT4-fs: Quota file not on filesystem root. "
 			"Journalled quota will not work.\n");
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -315,7 +315,7 @@ static int fuse_create_open(struct inode
 	struct fuse_entry_out outentry;
 	struct fuse_file *ff;
 	struct file *file;
-	int flags = nd->intent.open.flags - 1;
+	int flags = nd->lookup.intent.open.flags - 1;
 
 	if (fc->no_create)
 		return -ENOSYS;
@@ -485,7 +485,7 @@ static int fuse_mknod(struct inode *dir,
 static int fuse_create(struct inode *dir, struct dentry *entry, int mode,
 		       struct nameidata *nd)
 {
-	if (nd && (nd->flags & LOOKUP_OPEN)) {
+	if (nd && (nd->lookup.flags & LOOKUP_OPEN)) {
 		int err = fuse_create_open(dir, entry, mode, nd);
 		if (err != -ENOSYS)
 			return err;
@@ -821,7 +821,7 @@ static int fuse_permission(struct inode 
 		if ((mask & MAY_EXEC) && !S_ISDIR(mode) && !(mode & S_IXUGO))
 			return -EACCES;
 
-		if (nd && (nd->flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)))
+		if (nd && (nd->lookup.flags & (LOOKUP_ACCESS | LOOKUP_CHDIR)))
 			return fuse_access(inode, mask);
 		return 0;
 	}
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -827,13 +827,13 @@ static struct super_block* get_gfs2_sb(c
 		       dev_name);
 		goto out;
 	}
-	error = vfs_getattr(nd.mnt, nd.dentry, &stat);
+	error = vfs_getattr(nd.lookup.path.mnt, nd.lookup.path.dentry, &stat);
 
 	fstype = get_fs_type("gfs2");
 	list_for_each(l, &fstype->fs_supers) {
 		s = list_entry(l, struct super_block, s_instances);
 		if ((S_ISBLK(stat.mode) && s->s_dev == stat.rdev) ||
-		    (S_ISDIR(stat.mode) && s == nd.dentry->d_inode->i_sb)) {
+		    (S_ISDIR(stat.mode) && s == nd.lookup.path.dentry->d_inode->i_sb)) {
 			sb = s;
 			goto free_nd;
 		}
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -69,7 +69,7 @@ static int gfs2_create(struct inode *dir
 			mark_inode_dirty(inode);
 			break;
 		} else if (PTR_ERR(inode) != -EEXIST ||
-			   (nd->intent.open.flags & O_EXCL)) {
+			   (nd->lookup.intent.open.flags & O_EXCL)) {
 			gfs2_holder_uninit(ghs);
 			return PTR_ERR(inode);
 		}
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -639,7 +639,7 @@ asmlinkage long sys_inotify_add_watch(in
 		goto fput_and_out;
 
 	/* inode held in place by reference to nd; dev by fget on fd */
-	inode = nd.dentry->d_inode;
+	inode = nd.lookup.path.dentry->d_inode;
 	dev = filp->private_data;
 
 	mutex_lock(&dev->up_mutex);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -254,7 +254,7 @@ int permission(struct inode *inode, int 
 	 * the fs is mounted with the "noexec" flag.
 	 */
 	if ((mask & MAY_EXEC) && S_ISREG(mode) && (!(mode & S_IXUGO) ||
-			(nd && nd->mnt && (nd->mnt->mnt_flags & MNT_NOEXEC))))
+			(nd && nd->lookup.path.mnt && (nd->lookup.path.mnt->mnt_flags & MNT_NOEXEC))))
 		return -EACCES;
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
@@ -281,7 +281,7 @@ int permission(struct inode *inode, int 
  */
 int vfs_permission(struct nameidata *nd, int mask)
 {
-	return permission(nd->dentry->d_inode, mask, nd);
+	return permission(nd->lookup.path.dentry->d_inode, mask, nd);
 }
 
 /**
@@ -349,8 +349,8 @@ int deny_write_access(struct file * file
 
 void path_release(struct nameidata *nd)
 {
-	dput(nd->dentry);
-	mntput(nd->mnt);
+	dput(nd->lookup.path.dentry);
+	mntput(nd->lookup.path.mnt);
 }
 
 /*
@@ -359,8 +359,8 @@ void path_release(struct nameidata *nd)
  */
 void path_release_on_umount(struct nameidata *nd)
 {
-	dput(nd->dentry);
-	mntput_no_expire(nd->mnt);
+	dput(nd->lookup.path.dentry);
+	mntput_no_expire(nd->lookup.path.mnt);
 }
 
 /**
@@ -369,10 +369,10 @@ void path_release_on_umount(struct namei
  */
 void release_open_intent(struct nameidata *nd)
 {
-	if (nd->intent.open.file->f_path.dentry == NULL)
-		put_filp(nd->intent.open.file);
+	if (nd->lookup.intent.open.file->f_path.dentry == NULL)
+		put_filp(nd->lookup.intent.open.file);
 	else
-		fput(nd->intent.open.file);
+		fput(nd->lookup.intent.open.file);
 }
 
 static inline struct dentry *
@@ -524,16 +524,16 @@ walk_init_root(const char *name, struct 
 	struct fs_struct *fs = current->fs;
 
 	read_lock(&fs->lock);
-	if (fs->altroot && !(nd->flags & LOOKUP_NOALT)) {
-		nd->mnt = mntget(fs->altrootmnt);
-		nd->dentry = dget(fs->altroot);
+	if (fs->altroot && !(nd->lookup.flags & LOOKUP_NOALT)) {
+		nd->lookup.path.mnt = mntget(fs->altrootmnt);
+		nd->lookup.path.dentry = dget(fs->altroot);
 		read_unlock(&fs->lock);
 		if (__emul_lookup_dentry(name,nd))
 			return 0;
 		read_lock(&fs->lock);
 	}
-	nd->mnt = mntget(fs->rootmnt);
-	nd->dentry = dget(fs->root);
+	nd->lookup.path.mnt = mntget(fs->rootmnt);
+	nd->lookup.path.dentry = dget(fs->root);
 	read_unlock(&fs->lock);
 	return 1;
 }
@@ -576,17 +576,17 @@ fail:
 static inline void dput_path(struct path *path, struct nameidata *nd)
 {
 	dput(path->dentry);
-	if (path->mnt != nd->mnt)
+	if (path->mnt != nd->lookup.path.mnt)
 		mntput(path->mnt);
 }
 
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 {
-	dput(nd->dentry);
-	if (nd->mnt != path->mnt)
-		mntput(nd->mnt);
-	nd->mnt = path->mnt;
-	nd->dentry = path->dentry;
+	dput(nd->lookup.path.dentry);
+	if (nd->lookup.path.mnt != path->mnt)
+		mntput(nd->lookup.path.mnt);
+	nd->lookup.path.mnt = path->mnt;
+	nd->lookup.path.dentry = path->dentry;
 }
 
 static __always_inline int __do_follow_link(struct path *path, struct nameidata *nd)
@@ -598,7 +598,7 @@ static __always_inline int __do_follow_l
 	touch_atime(path->mnt, dentry);
 	nd_set_link(nd, NULL);
 
-	if (path->mnt != nd->mnt) {
+	if (path->mnt != nd->lookup.path.mnt) {
 		path_to_nameidata(path, nd);
 		dget(dentry);
 	}
@@ -728,37 +728,37 @@ static __always_inline void follow_dotdo
 
 	while(1) {
 		struct vfsmount *parent;
-		struct dentry *old = nd->dentry;
+		struct dentry *old = nd->lookup.path.dentry;
 
                 read_lock(&fs->lock);
-		if (nd->dentry == fs->root &&
-		    nd->mnt == fs->rootmnt) {
+		if (nd->lookup.path.dentry == fs->root &&
+		    nd->lookup.path.mnt == fs->rootmnt) {
                         read_unlock(&fs->lock);
 			break;
 		}
                 read_unlock(&fs->lock);
 		spin_lock(&dcache_lock);
-		if (nd->dentry != nd->mnt->mnt_root) {
-			nd->dentry = dget(nd->dentry->d_parent);
+		if (nd->lookup.path.dentry != nd->lookup.path.mnt->mnt_root) {
+			nd->lookup.path.dentry = dget(nd->lookup.path.dentry->d_parent);
 			spin_unlock(&dcache_lock);
 			dput(old);
 			break;
 		}
 		spin_unlock(&dcache_lock);
 		spin_lock(&vfsmount_lock);
-		parent = nd->mnt->mnt_parent;
-		if (parent == nd->mnt) {
+		parent = nd->lookup.path.mnt->mnt_parent;
+		if (parent == nd->lookup.path.mnt) {
 			spin_unlock(&vfsmount_lock);
 			break;
 		}
 		mntget(parent);
-		nd->dentry = dget(nd->mnt->mnt_mountpoint);
+		nd->lookup.path.dentry = dget(nd->lookup.path.mnt->mnt_mountpoint);
 		spin_unlock(&vfsmount_lock);
 		dput(old);
-		mntput(nd->mnt);
-		nd->mnt = parent;
+		mntput(nd->lookup.path.mnt);
+		nd->lookup.path.mnt = parent;
 	}
-	follow_mount(&nd->mnt, &nd->dentry);
+	follow_mount(&nd->lookup.path.mnt, &nd->lookup.path.dentry);
 }
 
 /*
@@ -769,8 +769,8 @@ static __always_inline void follow_dotdo
 static int do_lookup(struct nameidata *nd, struct qstr *name,
 		     struct path *path)
 {
-	struct vfsmount *mnt = nd->mnt;
-	struct dentry *dentry = __d_lookup(nd->dentry, name);
+	struct vfsmount *mnt = nd->lookup.path.mnt;
+	struct dentry *dentry = __d_lookup(nd->lookup.path.dentry, name);
 
 	if (!dentry)
 		goto need_lookup;
@@ -783,7 +783,7 @@ done:
 	return 0;
 
 need_lookup:
-	dentry = real_lookup(nd->dentry, name, nd);
+	dentry = real_lookup(nd->lookup.path.dentry, name, nd);
 	if (IS_ERR(dentry))
 		goto fail;
 	goto done;
@@ -813,16 +813,16 @@ static fastcall int __link_path_walk(con
 	struct path next;
 	struct inode *inode;
 	int err;
-	unsigned int lookup_flags = nd->flags;
+	unsigned int lookup_flags = nd->lookup.flags;
 	
 	while (*name=='/')
 		name++;
 	if (!*name)
 		goto return_reval;
 
-	inode = nd->dentry->d_inode;
+	inode = nd->lookup.path.dentry->d_inode;
 	if (nd->depth)
-		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
+		lookup_flags = LOOKUP_FOLLOW | (nd->lookup.flags & LOOKUP_CONTINUE);
 
 	/* At this point we know we have a real path component. */
 	for(;;) {
@@ -830,7 +830,7 @@ static fastcall int __link_path_walk(con
 		struct qstr this;
 		unsigned int c;
 
-		nd->flags |= LOOKUP_CONTINUE;
+		nd->lookup.flags |= LOOKUP_CONTINUE;
 		err = exec_permission_lite(inode, nd);
 		if (err == -EAGAIN)
 			err = vfs_permission(nd, MAY_EXEC);
@@ -868,7 +868,7 @@ static fastcall int __link_path_walk(con
 				if (this.name[1] != '.')
 					break;
 				follow_dotdot(nd);
-				inode = nd->dentry->d_inode;
+				inode = nd->lookup.path.dentry->d_inode;
 				/* fallthrough */
 			case 1:
 				continue;
@@ -877,8 +877,8 @@ static fastcall int __link_path_walk(con
 		 * See if the low-level filesystem might want
 		 * to use its own hash..
 		 */
-		if (nd->dentry->d_op && nd->dentry->d_op->d_hash) {
-			err = nd->dentry->d_op->d_hash(nd->dentry, &this);
+		if (nd->lookup.path.dentry->d_op && nd->lookup.path.dentry->d_op->d_hash) {
+			err = nd->lookup.path.dentry->d_op->d_hash(nd->lookup.path.dentry, &this);
 			if (err < 0)
 				break;
 		}
@@ -900,7 +900,7 @@ static fastcall int __link_path_walk(con
 			if (err)
 				goto return_err;
 			err = -ENOENT;
-			inode = nd->dentry->d_inode;
+			inode = nd->lookup.path.dentry->d_inode;
 			if (!inode)
 				break;
 			err = -ENOTDIR; 
@@ -918,7 +918,7 @@ last_with_slashes:
 		lookup_flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 last_component:
 		/* Clear LOOKUP_CONTINUE iff it was previously unset */
-		nd->flags &= lookup_flags | ~LOOKUP_CONTINUE;
+		nd->lookup.flags &= lookup_flags | ~LOOKUP_CONTINUE;
 		if (lookup_flags & LOOKUP_PARENT)
 			goto lookup_parent;
 		if (this.name[0] == '.') switch (this.len) {
@@ -928,13 +928,13 @@ last_component:
 				if (this.name[1] != '.')
 					break;
 				follow_dotdot(nd);
-				inode = nd->dentry->d_inode;
+				inode = nd->lookup.path.dentry->d_inode;
 				/* fallthrough */
 			case 1:
 				goto return_reval;
 		}
-		if (nd->dentry->d_op && nd->dentry->d_op->d_hash) {
-			err = nd->dentry->d_op->d_hash(nd->dentry, &this);
+		if (nd->lookup.path.dentry->d_op && nd->lookup.path.dentry->d_op->d_hash) {
+			err = nd->lookup.path.dentry->d_op->d_hash(nd->lookup.path.dentry, &this);
 			if (err < 0)
 				break;
 		}
@@ -947,7 +947,7 @@ last_component:
 			err = do_follow_link(&next, nd);
 			if (err)
 				goto return_err;
-			inode = nd->dentry->d_inode;
+			inode = nd->lookup.path.dentry->d_inode;
 		} else
 			path_to_nameidata(&next, nd);
 		err = -ENOENT;
@@ -975,11 +975,11 @@ return_reval:
 		 * We bypassed the ordinary revalidation routines.
 		 * We may need to check the cached dentry for staleness.
 		 */
-		if (nd->dentry && nd->dentry->d_sb &&
-		    (nd->dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
+		if (nd->lookup.path.dentry && nd->lookup.path.dentry->d_sb &&
+		    (nd->lookup.path.dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT)) {
 			err = -ESTALE;
 			/* Note: we do not d_invalidate() */
-			if (!nd->dentry->d_op->d_revalidate(nd->dentry, nd))
+			if (!nd->lookup.path.dentry->d_op->d_revalidate(nd->lookup.path.dentry, nd))
 				break;
 		}
 return_base:
@@ -1006,20 +1006,20 @@ static int fastcall link_path_walk(const
 	int result;
 
 	/* make sure the stuff we saved doesn't go away */
-	dget(save.dentry);
-	mntget(save.mnt);
+	dget(save.lookup.path.dentry);
+	mntget(save.lookup.path.mnt);
 
 	result = __link_path_walk(name, nd);
 	if (result == -ESTALE) {
 		*nd = save;
-		dget(nd->dentry);
-		mntget(nd->mnt);
-		nd->flags |= LOOKUP_REVAL;
+		dget(nd->lookup.path.dentry);
+		mntget(nd->lookup.path.mnt);
+		nd->lookup.flags |= LOOKUP_REVAL;
 		result = __link_path_walk(name, nd);
 	}
 
-	dput(save.dentry);
-	mntput(save.mnt);
+	dput(save.lookup.path.dentry);
+	mntput(save.lookup.path.mnt);
 
 	return result;
 }
@@ -1039,9 +1039,9 @@ static int __emul_lookup_dentry(const ch
 	if (path_walk(name, nd))
 		return 0;		/* something went wrong... */
 
-	if (!nd->dentry->d_inode || S_ISDIR(nd->dentry->d_inode->i_mode)) {
-		struct dentry *old_dentry = nd->dentry;
-		struct vfsmount *old_mnt = nd->mnt;
+	if (!nd->lookup.path.dentry->d_inode || S_ISDIR(nd->lookup.path.dentry->d_inode->i_mode)) {
+		struct dentry *old_dentry = nd->lookup.path.dentry;
+		struct vfsmount *old_mnt = nd->lookup.path.mnt;
 		struct qstr last = nd->last;
 		int last_type = nd->last_type;
 		struct fs_struct *fs = current->fs;
@@ -1052,19 +1052,19 @@ static int __emul_lookup_dentry(const ch
 		 */
 		nd->last_type = LAST_ROOT;
 		read_lock(&fs->lock);
-		nd->mnt = mntget(fs->rootmnt);
-		nd->dentry = dget(fs->root);
+		nd->lookup.path.mnt = mntget(fs->rootmnt);
+		nd->lookup.path.dentry = dget(fs->root);
 		read_unlock(&fs->lock);
 		if (path_walk(name, nd) == 0) {
-			if (nd->dentry->d_inode) {
+			if (nd->lookup.path.dentry->d_inode) {
 				dput(old_dentry);
 				mntput(old_mnt);
 				return 1;
 			}
 			path_release(nd);
 		}
-		nd->dentry = old_dentry;
-		nd->mnt = old_mnt;
+		nd->lookup.path.dentry = old_dentry;
+		nd->lookup.path.mnt = old_mnt;
 		nd->last = last;
 		nd->last_type = last_type;
 	}
@@ -1084,8 +1084,8 @@ void set_fs_altroot(void)
 		goto set_it;
 	err = path_lookup(emul, LOOKUP_FOLLOW|LOOKUP_DIRECTORY|LOOKUP_NOALT, &nd);
 	if (!err) {
-		mnt = nd.mnt;
-		dentry = nd.dentry;
+		mnt = nd.lookup.path.mnt;
+		dentry = nd.lookup.path.dentry;
 	}
 set_it:
 	write_lock(&fs->lock);
@@ -1110,26 +1110,26 @@ static int fastcall do_path_lookup(int d
 	struct fs_struct *fs = current->fs;
 
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
-	nd->flags = flags;
+	nd->lookup.flags = flags;
 	nd->depth = 0;
 
 	if (*name=='/') {
 		read_lock(&fs->lock);
-		if (fs->altroot && !(nd->flags & LOOKUP_NOALT)) {
-			nd->mnt = mntget(fs->altrootmnt);
-			nd->dentry = dget(fs->altroot);
+		if (fs->altroot && !(nd->lookup.flags & LOOKUP_NOALT)) {
+			nd->lookup.path.mnt = mntget(fs->altrootmnt);
+			nd->lookup.path.dentry = dget(fs->altroot);
 			read_unlock(&fs->lock);
 			if (__emul_lookup_dentry(name,nd))
 				goto out; /* found in altroot */
 			read_lock(&fs->lock);
 		}
-		nd->mnt = mntget(fs->rootmnt);
-		nd->dentry = dget(fs->root);
+		nd->lookup.path.mnt = mntget(fs->rootmnt);
+		nd->lookup.path.dentry = dget(fs->root);
 		read_unlock(&fs->lock);
 	} else if (dfd == AT_FDCWD) {
 		read_lock(&fs->lock);
-		nd->mnt = mntget(fs->pwdmnt);
-		nd->dentry = dget(fs->pwd);
+		nd->lookup.path.mnt = mntget(fs->pwdmnt);
+		nd->lookup.path.dentry = dget(fs->pwd);
 		read_unlock(&fs->lock);
 	} else {
 		struct dentry *dentry;
@@ -1149,17 +1149,17 @@ static int fastcall do_path_lookup(int d
 		if (retval)
 			goto fput_fail;
 
-		nd->mnt = mntget(file->f_path.mnt);
-		nd->dentry = dget(dentry);
+		nd->lookup.path.mnt = mntget(file->f_path.mnt);
+		nd->lookup.path.dentry = dget(dentry);
 
 		fput_light(file, fput_needed);
 	}
 
 	retval = path_walk(name, nd);
 out:
-	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
-				nd->dentry->d_inode))
-		audit_inode(name, nd->dentry->d_inode);
+	if (unlikely(!retval && !audit_dummy_context() && nd->lookup.path.dentry &&
+				nd->lookup.path.dentry->d_inode))
+		audit_inode(name, nd->lookup.path.dentry->d_inode);
 out_fail:
 	return retval;
 
@@ -1190,16 +1190,16 @@ int vfs_path_lookup(struct dentry *dentr
 
 	/* same as do_path_lookup */
 	nd->last_type = LAST_ROOT;
-	nd->flags = flags;
+	nd->lookup.flags = flags;
 	nd->depth = 0;
 
-	nd->mnt = mntget(mnt);
-	nd->dentry = dget(dentry);
+	nd->lookup.path.mnt = mntget(mnt);
+	nd->lookup.path.dentry = dget(dentry);
 
 	retval = path_walk(name, nd);
-	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
-				nd->dentry->d_inode))
-		audit_inode(name, nd->dentry->d_inode);
+	if (unlikely(!retval && !audit_dummy_context() && nd->lookup.path.dentry &&
+				nd->lookup.path.dentry->d_inode))
+		audit_inode(name, nd->lookup.path.dentry->d_inode);
 
 	return retval;
 
@@ -1214,13 +1214,13 @@ static int __path_lookup_intent_open(int
 
 	if (filp == NULL)
 		return -ENFILE;
-	nd->intent.open.file = filp;
-	nd->intent.open.flags = open_flags;
-	nd->intent.open.create_mode = create_mode;
+	nd->lookup.intent.open.file = filp;
+	nd->lookup.intent.open.flags = open_flags;
+	nd->lookup.intent.open.create_mode = create_mode;
 	err = do_path_lookup(dfd, name, lookup_flags|LOOKUP_OPEN, nd);
-	if (IS_ERR(nd->intent.open.file)) {
+	if (IS_ERR(nd->lookup.intent.open.file)) {
 		if (err == 0) {
-			err = PTR_ERR(nd->intent.open.file);
+			err = PTR_ERR(nd->lookup.intent.open.file);
 			path_release(nd);
 		}
 	} else if (err != 0)
@@ -1333,7 +1333,7 @@ out:
 
 static struct dentry *lookup_hash(struct nameidata *nd)
 {
-	return __lookup_hash(&nd->last, nd->dentry, nd);
+	return __lookup_hash(&nd->last, nd->lookup.path.dentry, nd);
 }
 
 /* SMP-safe */
@@ -1566,7 +1566,7 @@ int vfs_create(struct inode *dir, struct
 
 int may_open(struct nameidata *nd, int acc_mode, int flag)
 {
-	struct dentry *dentry = nd->dentry;
+	struct dentry *dentry = nd->lookup.path.dentry;
 	struct inode *inode = dentry->d_inode;
 	int error;
 
@@ -1591,7 +1591,7 @@ int may_open(struct nameidata *nd, int a
 	if (S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 	    	flag &= ~O_TRUNC;
 	} else if (S_ISBLK(inode->i_mode) || S_ISCHR(inode->i_mode)) {
-		if (nd->mnt->mnt_flags & MNT_NODEV)
+		if (nd->lookup.path.mnt->mnt_flags & MNT_NODEV)
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
@@ -1647,14 +1647,14 @@ static int open_namei_create(struct name
 				int flag, int mode)
 {
 	int error;
-	struct dentry *dir = nd->dentry;
+	struct dentry *dir = nd->lookup.path.dentry;
 
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
 	error = vfs_create(dir->d_inode, path->dentry, mode, nd);
 	mutex_unlock(&dir->d_inode->i_mutex);
-	dput(nd->dentry);
-	nd->dentry = path->dentry;
+	dput(nd->lookup.path.dentry);
+	nd->lookup.path.dentry = path->dentry;
 	if (error)
 		return error;
 	/* Don't check for write permission, don't truncate */
@@ -1721,11 +1721,11 @@ int open_namei(int dfd, const char *path
 	if (nd->last_type != LAST_NORM || nd->last.name[nd->last.len])
 		goto exit;
 
-	dir = nd->dentry;
-	nd->flags &= ~LOOKUP_PARENT;
+	dir = nd->lookup.path.dentry;
+	nd->lookup.flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
 	path.dentry = lookup_hash(nd);
-	path.mnt = nd->mnt;
+	path.mnt = nd->lookup.path.mnt;
 
 do_last:
 	error = PTR_ERR(path.dentry);
@@ -1734,9 +1734,9 @@ do_last:
 		goto exit;
 	}
 
-	if (IS_ERR(nd->intent.open.file)) {
+	if (IS_ERR(nd->lookup.intent.open.file)) {
 		mutex_unlock(&dir->d_inode->i_mutex);
-		error = PTR_ERR(nd->intent.open.file);
+		error = PTR_ERR(nd->lookup.intent.open.file);
 		goto exit_dput;
 	}
 
@@ -1783,7 +1783,7 @@ ok:
 exit_dput:
 	dput_path(&path, nd);
 exit:
-	if (!IS_ERR(nd->intent.open.file))
+	if (!IS_ERR(nd->lookup.intent.open.file))
 		release_open_intent(nd);
 	path_release(nd);
 	return error;
@@ -1802,7 +1802,7 @@ do_link:
 	 * stored in nd->last.name and we will have to putname() it when we
 	 * are done. Procfs-like symlinks just set LAST_BIND.
 	 */
-	nd->flags |= LOOKUP_PARENT;
+	nd->lookup.flags |= LOOKUP_PARENT;
 	error = security_inode_follow_link(path.dentry, nd);
 	if (error)
 		goto exit_dput;
@@ -1815,7 +1815,7 @@ do_link:
 		release_open_intent(nd);
 		return error;
 	}
-	nd->flags &= ~LOOKUP_PARENT;
+	nd->lookup.flags &= ~LOOKUP_PARENT;
 	if (nd->last_type == LAST_BIND)
 		goto ok;
 	error = -EISDIR;
@@ -1830,10 +1830,10 @@ do_link:
 		__putname(nd->last.name);
 		goto exit;
 	}
-	dir = nd->dentry;
+	dir = nd->lookup.path.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
 	path.dentry = lookup_hash(nd);
-	path.mnt = nd->mnt;
+	path.mnt = nd->lookup.path.mnt;
 	__putname(nd->last.name);
 	goto do_last;
 }
@@ -1846,22 +1846,22 @@ do_link:
  * Simple function to lookup and return a dentry and create it
  * if it doesn't exist.  Is SMP-safe.
  *
- * Returns with nd->dentry->d_inode->i_mutex locked.
+ * Returns with nd->lookup.path.dentry->d_inode->i_mutex locked.
  */
 struct dentry *lookup_create(struct nameidata *nd, int is_dir)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
 
-	mutex_lock_nested(&nd->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&nd->lookup.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	/*
 	 * Yucky last component or no last component at all?
 	 * (foo/., foo/.., /////)
 	 */
 	if (nd->last_type != LAST_NORM)
 		goto fail;
-	nd->flags &= ~LOOKUP_PARENT;
-	nd->flags |= LOOKUP_CREATE;
-	nd->intent.open.flags = O_EXCL;
+	nd->lookup.flags &= ~LOOKUP_PARENT;
+	nd->lookup.flags |= LOOKUP_CREATE;
+	nd->lookup.intent.open.flags = O_EXCL;
 
 	/*
 	 * Do the final lookup.
@@ -1931,19 +1931,19 @@ asmlinkage long sys_mknodat(int dfd, con
 	dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(nd.dentry->d_inode))
+	if (!IS_POSIXACL(nd.lookup.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
 	if (!IS_ERR(dentry)) {
 		switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
-			error = vfs_create(nd.dentry->d_inode,dentry,mode,&nd);
+			error = vfs_create(nd.lookup.path.dentry->d_inode,dentry,mode,&nd);
 			break;
 		case S_IFCHR: case S_IFBLK:
-			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,
+			error = vfs_mknod(nd.lookup.path.dentry->d_inode,dentry,mode,
 					new_decode_dev(dev));
 			break;
 		case S_IFIFO: case S_IFSOCK:
-			error = vfs_mknod(nd.dentry->d_inode,dentry,mode,0);
+			error = vfs_mknod(nd.lookup.path.dentry->d_inode,dentry,mode,0);
 			break;
 		case S_IFDIR:
 			error = -EPERM;
@@ -1953,7 +1953,7 @@ asmlinkage long sys_mknodat(int dfd, con
 		}
 		dput(dentry);
 	}
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
 	putname(tmp);
@@ -2008,12 +2008,12 @@ asmlinkage long sys_mkdirat(int dfd, con
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	if (!IS_POSIXACL(nd.dentry->d_inode))
+	if (!IS_POSIXACL(nd.lookup.path.dentry->d_inode))
 		mode &= ~current->fs->umask;
-	error = vfs_mkdir(nd.dentry->d_inode, dentry, mode);
+	error = vfs_mkdir(nd.lookup.path.dentry->d_inode, dentry, mode);
 	dput(dentry);
 out_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
 	putname(tmp);
@@ -2112,15 +2112,15 @@ static long do_rmdir(int dfd, const char
 			error = -EBUSY;
 			goto exit1;
 	}
-	mutex_lock_nested(&nd.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&nd.lookup.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
-	error = vfs_rmdir(nd.dentry->d_inode, dentry);
+	error = vfs_rmdir(nd.lookup.path.dentry->d_inode, dentry);
 	dput(dentry);
 exit2:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 exit1:
 	path_release(&nd);
 exit:
@@ -2187,7 +2187,7 @@ static long do_unlinkat(int dfd, const c
 	error = -EISDIR;
 	if (nd.last_type != LAST_NORM)
 		goto exit1;
-	mutex_lock_nested(&nd.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&nd.lookup.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	dentry = lookup_hash(&nd);
 	error = PTR_ERR(dentry);
 	if (!IS_ERR(dentry)) {
@@ -2197,11 +2197,11 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
-		error = vfs_unlink(nd.dentry->d_inode, dentry);
+		error = vfs_unlink(nd.lookup.path.dentry->d_inode, dentry);
 	exit2:
 		dput(dentry);
 	}
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 	if (inode)
 		iput(inode);	/* truncate the inode here */
 exit1:
@@ -2278,10 +2278,10 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
-	error = vfs_symlink(nd.dentry->d_inode, dentry, from, S_IALLUGO);
+	error = vfs_symlink(nd.lookup.path.dentry->d_inode, dentry, from, S_IALLUGO);
 	dput(dentry);
 out_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out:
 	putname(to);
@@ -2367,16 +2367,16 @@ asmlinkage long sys_linkat(int olddfd, c
 	if (error)
 		goto out;
 	error = -EXDEV;
-	if (old_nd.mnt != nd.mnt)
+	if (old_nd.lookup.path.mnt != nd.lookup.path.mnt)
 		goto out_release;
 	new_dentry = lookup_create(&nd, 0);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
-	error = vfs_link(old_nd.dentry, nd.dentry->d_inode, new_dentry);
+	error = vfs_link(old_nd.lookup.path.dentry, nd.lookup.path.dentry->d_inode, new_dentry);
 	dput(new_dentry);
 out_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 out_release:
 	path_release(&nd);
 out:
@@ -2556,15 +2556,15 @@ static int do_rename(int olddfd, const c
 		goto exit1;
 
 	error = -EXDEV;
-	if (oldnd.mnt != newnd.mnt)
+	if (oldnd.lookup.path.mnt != newnd.lookup.path.mnt)
 		goto exit2;
 
-	old_dir = oldnd.dentry;
+	old_dir = oldnd.lookup.path.dentry;
 	error = -EBUSY;
 	if (oldnd.last_type != LAST_NORM)
 		goto exit2;
 
-	new_dir = newnd.dentry;
+	new_dir = newnd.lookup.path.dentry;
 	if (newnd.last_type != LAST_NORM)
 		goto exit2;
 
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -154,13 +154,13 @@ static void __touch_mnt_namespace(struct
 
 static void detach_mnt(struct vfsmount *mnt, struct nameidata *old_nd)
 {
-	old_nd->dentry = mnt->mnt_mountpoint;
-	old_nd->mnt = mnt->mnt_parent;
+	old_nd->lookup.path.dentry = mnt->mnt_mountpoint;
+	old_nd->lookup.path.mnt = mnt->mnt_parent;
 	mnt->mnt_parent = mnt;
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	list_del_init(&mnt->mnt_child);
 	list_del_init(&mnt->mnt_hash);
-	old_nd->dentry->d_mounted--;
+	old_nd->lookup.path.dentry->d_mounted--;
 }
 
 void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
@@ -173,10 +173,10 @@ void mnt_set_mountpoint(struct vfsmount 
 
 static void attach_mnt(struct vfsmount *mnt, struct nameidata *nd)
 {
-	mnt_set_mountpoint(nd->mnt, nd->dentry, mnt);
+	mnt_set_mountpoint(nd->lookup.path.mnt, nd->lookup.path.dentry, mnt);
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
-			hash(nd->mnt, nd->dentry));
-	list_add_tail(&mnt->mnt_child, &nd->mnt->mnt_mounts);
+			hash(nd->lookup.path.mnt, nd->lookup.path.dentry));
+	list_add_tail(&mnt->mnt_child, &nd->lookup.path.mnt->mnt_mounts);
 }
 
 /*
@@ -637,16 +637,16 @@ asmlinkage long sys_umount(char __user *
 	if (retval)
 		goto out;
 	retval = -EINVAL;
-	if (nd.dentry != nd.mnt->mnt_root)
+	if (nd.lookup.path.dentry != nd.lookup.path.mnt->mnt_root)
 		goto dput_and_out;
-	if (!check_mnt(nd.mnt))
+	if (!check_mnt(nd.lookup.path.mnt))
 		goto dput_and_out;
 
 	retval = -EPERM;
 	if (!capable(CAP_SYS_ADMIN))
 		goto dput_and_out;
 
-	retval = do_umount(nd.mnt, flags);
+	retval = do_umount(nd.lookup.path.mnt, flags);
 dput_and_out:
 	path_release_on_umount(&nd);
 out:
@@ -671,10 +671,10 @@ static int mount_is_safe(struct nameidat
 		return 0;
 	return -EPERM;
 #ifdef notyet
-	if (S_ISLNK(nd->dentry->d_inode->i_mode))
+	if (S_ISLNK(nd->lookup.path.dentry->d_inode->i_mode))
 		return -EPERM;
-	if (nd->dentry->d_inode->i_mode & S_ISVTX) {
-		if (current->uid != nd->dentry->d_inode->i_uid)
+	if (nd->lookup.path.dentry->d_inode->i_mode & S_ISVTX) {
+		if (current->uid != nd->lookup.path.dentry->d_inode->i_uid)
 			return -EPERM;
 	}
 	if (vfs_permission(nd, MAY_WRITE))
@@ -723,8 +723,8 @@ struct vfsmount *copy_tree(struct vfsmou
 				q = q->mnt_parent;
 			}
 			p = s;
-			nd.mnt = q;
-			nd.dentry = p->mnt_mountpoint;
+			nd.lookup.path.mnt = q;
+			nd.lookup.path.dentry = p->mnt_mountpoint;
 			q = clone_mnt(p, p->mnt_root, flag);
 			if (!q)
 				goto Enomem;
@@ -813,8 +813,8 @@ static int attach_recursive_mnt(struct v
 			struct nameidata *nd, struct nameidata *parent_nd)
 {
 	LIST_HEAD(tree_list);
-	struct vfsmount *dest_mnt = nd->mnt;
-	struct dentry *dest_dentry = nd->dentry;
+	struct vfsmount *dest_mnt = nd->lookup.path.mnt;
+	struct dentry *dest_dentry = nd->lookup.path.dentry;
 	struct vfsmount *child, *p;
 
 	if (propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list))
@@ -849,13 +849,13 @@ static int graft_tree(struct vfsmount *m
 	if (mnt->mnt_sb->s_flags & MS_NOUSER)
 		return -EINVAL;
 
-	if (S_ISDIR(nd->dentry->d_inode->i_mode) !=
+	if (S_ISDIR(nd->lookup.path.dentry->d_inode->i_mode) !=
 	      S_ISDIR(mnt->mnt_root->d_inode->i_mode))
 		return -ENOTDIR;
 
 	err = -ENOENT;
-	mutex_lock(&nd->dentry->d_inode->i_mutex);
-	if (IS_DEADDIR(nd->dentry->d_inode))
+	mutex_lock(&nd->lookup.path.dentry->d_inode->i_mutex);
+	if (IS_DEADDIR(nd->lookup.path.dentry->d_inode))
 		goto out_unlock;
 
 	err = security_sb_check_sb(mnt, nd);
@@ -863,10 +863,10 @@ static int graft_tree(struct vfsmount *m
 		goto out_unlock;
 
 	err = -ENOENT;
-	if (IS_ROOT(nd->dentry) || !d_unhashed(nd->dentry))
+	if (IS_ROOT(nd->lookup.path.dentry) || !d_unhashed(nd->lookup.path.dentry))
 		err = attach_recursive_mnt(mnt, nd, NULL);
 out_unlock:
-	mutex_unlock(&nd->dentry->d_inode->i_mutex);
+	mutex_unlock(&nd->lookup.path.dentry->d_inode->i_mutex);
 	if (!err)
 		security_sb_post_addmount(mnt, nd);
 	return err;
@@ -877,14 +877,14 @@ out_unlock:
  */
 static int do_change_type(struct nameidata *nd, int flag)
 {
-	struct vfsmount *m, *mnt = nd->mnt;
+	struct vfsmount *m, *mnt = nd->lookup.path.mnt;
 	int recurse = flag & MS_REC;
 	int type = flag & ~MS_REC;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (nd->dentry != nd->mnt->mnt_root)
+	if (nd->lookup.path.dentry != nd->lookup.path.mnt->mnt_root)
 		return -EINVAL;
 
 	down_write(&namespace_sem);
@@ -914,17 +914,17 @@ static int do_loopback(struct nameidata 
 
 	down_write(&namespace_sem);
 	err = -EINVAL;
-	if (IS_MNT_UNBINDABLE(old_nd.mnt))
+	if (IS_MNT_UNBINDABLE(old_nd.lookup.path.mnt))
  		goto out;
 
-	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
+	if (!check_mnt(nd->lookup.path.mnt) || !check_mnt(old_nd.lookup.path.mnt))
 		goto out;
 
 	err = -ENOMEM;
 	if (recurse)
-		mnt = copy_tree(old_nd.mnt, old_nd.dentry, 0);
+		mnt = copy_tree(old_nd.lookup.path.mnt, old_nd.lookup.path.dentry, 0);
 	else
-		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, 0);
+		mnt = clone_mnt(old_nd.lookup.path.mnt, old_nd.lookup.path.dentry, 0);
 
 	if (!mnt)
 		goto out;
@@ -953,24 +953,24 @@ static int do_remount(struct nameidata *
 		      void *data)
 {
 	int err;
-	struct super_block *sb = nd->mnt->mnt_sb;
+	struct super_block *sb = nd->lookup.path.mnt->mnt_sb;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!check_mnt(nd->mnt))
+	if (!check_mnt(nd->lookup.path.mnt))
 		return -EINVAL;
 
-	if (nd->dentry != nd->mnt->mnt_root)
+	if (nd->lookup.path.dentry != nd->lookup.path.mnt->mnt_root)
 		return -EINVAL;
 
 	down_write(&sb->s_umount);
 	err = do_remount_sb(sb, flags, data, 0);
 	if (!err)
-		nd->mnt->mnt_flags = mnt_flags;
+		nd->lookup.path.mnt->mnt_flags = mnt_flags;
 	up_write(&sb->s_umount);
 	if (!err)
-		security_sb_post_remount(nd->mnt, flags, data);
+		security_sb_post_remount(nd->lookup.path.mnt, flags, data);
 	return err;
 }
 
@@ -998,56 +998,56 @@ static int do_move_mount(struct nameidat
 		return err;
 
 	down_write(&namespace_sem);
-	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
+	while (d_mountpoint(nd->lookup.path.dentry) && follow_down(&nd->lookup.path.mnt, &nd->lookup.path.dentry))
 		;
 	err = -EINVAL;
-	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
+	if (!check_mnt(nd->lookup.path.mnt) || !check_mnt(old_nd.lookup.path.mnt))
 		goto out;
 
 	err = -ENOENT;
-	mutex_lock(&nd->dentry->d_inode->i_mutex);
-	if (IS_DEADDIR(nd->dentry->d_inode))
+	mutex_lock(&nd->lookup.path.dentry->d_inode->i_mutex);
+	if (IS_DEADDIR(nd->lookup.path.dentry->d_inode))
 		goto out1;
 
-	if (!IS_ROOT(nd->dentry) && d_unhashed(nd->dentry))
+	if (!IS_ROOT(nd->lookup.path.dentry) && d_unhashed(nd->lookup.path.dentry))
 		goto out1;
 
 	err = -EINVAL;
-	if (old_nd.dentry != old_nd.mnt->mnt_root)
+	if (old_nd.lookup.path.dentry != old_nd.lookup.path.mnt->mnt_root)
 		goto out1;
 
-	if (old_nd.mnt == old_nd.mnt->mnt_parent)
+	if (old_nd.lookup.path.mnt == old_nd.lookup.path.mnt->mnt_parent)
 		goto out1;
 
-	if (S_ISDIR(nd->dentry->d_inode->i_mode) !=
-	      S_ISDIR(old_nd.dentry->d_inode->i_mode))
+	if (S_ISDIR(nd->lookup.path.dentry->d_inode->i_mode) !=
+	      S_ISDIR(old_nd.lookup.path.dentry->d_inode->i_mode))
 		goto out1;
 	/*
 	 * Don't move a mount residing in a shared parent.
 	 */
-	if (old_nd.mnt->mnt_parent && IS_MNT_SHARED(old_nd.mnt->mnt_parent))
+	if (old_nd.lookup.path.mnt->mnt_parent && IS_MNT_SHARED(old_nd.lookup.path.mnt->mnt_parent))
 		goto out1;
 	/*
 	 * Don't move a mount tree containing unbindable mounts to a destination
 	 * mount which is shared.
 	 */
-	if (IS_MNT_SHARED(nd->mnt) && tree_contains_unbindable(old_nd.mnt))
+	if (IS_MNT_SHARED(nd->lookup.path.mnt) && tree_contains_unbindable(old_nd.lookup.path.mnt))
 		goto out1;
 	err = -ELOOP;
-	for (p = nd->mnt; p->mnt_parent != p; p = p->mnt_parent)
-		if (p == old_nd.mnt)
+	for (p = nd->lookup.path.mnt; p->mnt_parent != p; p = p->mnt_parent)
+		if (p == old_nd.lookup.path.mnt)
 			goto out1;
 
-	if ((err = attach_recursive_mnt(old_nd.mnt, nd, &parent_nd)))
+	if ((err = attach_recursive_mnt(old_nd.lookup.path.mnt, nd, &parent_nd)))
 		goto out1;
 
 	spin_lock(&vfsmount_lock);
 	/* if the mount is moved, it should no longer be expire
 	 * automatically */
-	list_del_init(&old_nd.mnt->mnt_expire);
+	list_del_init(&old_nd.lookup.path.mnt->mnt_expire);
 	spin_unlock(&vfsmount_lock);
 out1:
-	mutex_unlock(&nd->dentry->d_inode->i_mutex);
+	mutex_unlock(&nd->lookup.path.dentry->d_inode->i_mutex);
 out:
 	up_write(&namespace_sem);
 	if (!err)
@@ -1090,16 +1090,16 @@ int do_add_mount(struct vfsmount *newmnt
 
 	down_write(&namespace_sem);
 	/* Something was mounted here while we slept */
-	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
+	while (d_mountpoint(nd->lookup.path.dentry) && follow_down(&nd->lookup.path.mnt, &nd->lookup.path.dentry))
 		;
 	err = -EINVAL;
-	if (!check_mnt(nd->mnt))
+	if (!check_mnt(nd->lookup.path.mnt))
 		goto unlock;
 
 	/* Refuse the same filesystem on the same mount point */
 	err = -EBUSY;
-	if (nd->mnt->mnt_sb == newmnt->mnt_sb &&
-	    nd->mnt->mnt_root == nd->dentry)
+	if (nd->lookup.path.mnt->mnt_sb == newmnt->mnt_sb &&
+	    nd->lookup.path.mnt->mnt_root == nd->lookup.path.dentry)
 		goto unlock;
 
 	err = -EINVAL;
@@ -1625,12 +1625,12 @@ static void chroot_fs_refs(struct nameid
 		if (fs) {
 			atomic_inc(&fs->count);
 			task_unlock(p);
-			if (fs->root == old_nd->dentry
-			    && fs->rootmnt == old_nd->mnt)
-				set_fs_root(fs, new_nd->mnt, new_nd->dentry);
-			if (fs->pwd == old_nd->dentry
-			    && fs->pwdmnt == old_nd->mnt)
-				set_fs_pwd(fs, new_nd->mnt, new_nd->dentry);
+			if (fs->root == old_nd->lookup.path.dentry
+			    && fs->rootmnt == old_nd->lookup.path.mnt)
+				set_fs_root(fs, new_nd->lookup.path.mnt, new_nd->lookup.path.dentry);
+			if (fs->pwd == old_nd->lookup.path.dentry
+			    && fs->pwdmnt == old_nd->lookup.path.mnt)
+				set_fs_pwd(fs, new_nd->lookup.path.mnt, new_nd->lookup.path.dentry);
 			put_fs_struct(fs);
 		} else
 			task_unlock(p);
@@ -1680,7 +1680,7 @@ asmlinkage long sys_pivot_root(const cha
 	if (error)
 		goto out0;
 	error = -EINVAL;
-	if (!check_mnt(new_nd.mnt))
+	if (!check_mnt(new_nd.lookup.path.mnt))
 		goto out1;
 
 	error = __user_walk(put_old, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &old_nd);
@@ -1694,55 +1694,55 @@ asmlinkage long sys_pivot_root(const cha
 	}
 
 	read_lock(&current->fs->lock);
-	user_nd.mnt = mntget(current->fs->rootmnt);
-	user_nd.dentry = dget(current->fs->root);
+	user_nd.lookup.path.mnt = mntget(current->fs->rootmnt);
+	user_nd.lookup.path.dentry = dget(current->fs->root);
 	read_unlock(&current->fs->lock);
 	down_write(&namespace_sem);
-	mutex_lock(&old_nd.dentry->d_inode->i_mutex);
+	mutex_lock(&old_nd.lookup.path.dentry->d_inode->i_mutex);
 	error = -EINVAL;
-	if (IS_MNT_SHARED(old_nd.mnt) ||
-		IS_MNT_SHARED(new_nd.mnt->mnt_parent) ||
-		IS_MNT_SHARED(user_nd.mnt->mnt_parent))
+	if (IS_MNT_SHARED(old_nd.lookup.path.mnt) ||
+		IS_MNT_SHARED(new_nd.lookup.path.mnt->mnt_parent) ||
+		IS_MNT_SHARED(user_nd.lookup.path.mnt->mnt_parent))
 		goto out2;
-	if (!check_mnt(user_nd.mnt))
+	if (!check_mnt(user_nd.lookup.path.mnt))
 		goto out2;
 	error = -ENOENT;
-	if (IS_DEADDIR(new_nd.dentry->d_inode))
+	if (IS_DEADDIR(new_nd.lookup.path.dentry->d_inode))
 		goto out2;
-	if (d_unhashed(new_nd.dentry) && !IS_ROOT(new_nd.dentry))
+	if (d_unhashed(new_nd.lookup.path.dentry) && !IS_ROOT(new_nd.lookup.path.dentry))
 		goto out2;
-	if (d_unhashed(old_nd.dentry) && !IS_ROOT(old_nd.dentry))
+	if (d_unhashed(old_nd.lookup.path.dentry) && !IS_ROOT(old_nd.lookup.path.dentry))
 		goto out2;
 	error = -EBUSY;
-	if (new_nd.mnt == user_nd.mnt || old_nd.mnt == user_nd.mnt)
+	if (new_nd.lookup.path.mnt == user_nd.lookup.path.mnt || old_nd.lookup.path.mnt == user_nd.lookup.path.mnt)
 		goto out2; /* loop, on the same file system  */
 	error = -EINVAL;
-	if (user_nd.mnt->mnt_root != user_nd.dentry)
+	if (user_nd.lookup.path.mnt->mnt_root != user_nd.lookup.path.dentry)
 		goto out2; /* not a mountpoint */
-	if (user_nd.mnt->mnt_parent == user_nd.mnt)
+	if (user_nd.lookup.path.mnt->mnt_parent == user_nd.lookup.path.mnt)
 		goto out2; /* not attached */
-	if (new_nd.mnt->mnt_root != new_nd.dentry)
+	if (new_nd.lookup.path.mnt->mnt_root != new_nd.lookup.path.dentry)
 		goto out2; /* not a mountpoint */
-	if (new_nd.mnt->mnt_parent == new_nd.mnt)
+	if (new_nd.lookup.path.mnt->mnt_parent == new_nd.lookup.path.mnt)
 		goto out2; /* not attached */
-	tmp = old_nd.mnt; /* make sure we can reach put_old from new_root */
+	tmp = old_nd.lookup.path.mnt; /* make sure we can reach put_old from new_root */
 	spin_lock(&vfsmount_lock);
-	if (tmp != new_nd.mnt) {
+	if (tmp != new_nd.lookup.path.mnt) {
 		for (;;) {
 			if (tmp->mnt_parent == tmp)
 				goto out3; /* already mounted on put_old */
-			if (tmp->mnt_parent == new_nd.mnt)
+			if (tmp->mnt_parent == new_nd.lookup.path.mnt)
 				break;
 			tmp = tmp->mnt_parent;
 		}
-		if (!is_subdir(tmp->mnt_mountpoint, new_nd.dentry))
+		if (!is_subdir(tmp->mnt_mountpoint, new_nd.lookup.path.dentry))
 			goto out3;
-	} else if (!is_subdir(old_nd.dentry, new_nd.dentry))
+	} else if (!is_subdir(old_nd.lookup.path.dentry, new_nd.lookup.path.dentry))
 		goto out3;
-	detach_mnt(new_nd.mnt, &parent_nd);
-	detach_mnt(user_nd.mnt, &root_parent);
-	attach_mnt(user_nd.mnt, &old_nd);     /* mount old root on put_old */
-	attach_mnt(new_nd.mnt, &root_parent); /* mount new_root on / */
+	detach_mnt(new_nd.lookup.path.mnt, &parent_nd);
+	detach_mnt(user_nd.lookup.path.mnt, &root_parent);
+	attach_mnt(user_nd.lookup.path.mnt, &old_nd);     /* mount old root on put_old */
+	attach_mnt(new_nd.lookup.path.mnt, &root_parent); /* mount new_root on / */
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
 	spin_unlock(&vfsmount_lock);
 	chroot_fs_refs(&user_nd, &new_nd);
@@ -1751,7 +1751,7 @@ asmlinkage long sys_pivot_root(const cha
 	path_release(&root_parent);
 	path_release(&parent_nd);
 out2:
-	mutex_unlock(&old_nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&old_nd.lookup.path.dentry->d_inode->i_mutex);
 	up_write(&namespace_sem);
 	path_release(&user_nd);
 	path_release(&old_nd);
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -689,9 +689,9 @@ static inline void nfs_renew_times(struc
  */
 static inline unsigned int nfs_lookup_check_intent(struct nameidata *nd, unsigned int mask)
 {
-	if (nd->flags & (LOOKUP_CONTINUE|LOOKUP_PARENT))
+	if (nd->lookup.flags & (LOOKUP_CONTINUE|LOOKUP_PARENT))
 		return 0;
-	return nd->flags & mask;
+	return nd->lookup.flags & mask;
 }
 
 /*
@@ -709,7 +709,7 @@ int nfs_lookup_verify_inode(struct inode
 
 	if (nd != NULL) {
 		/* VFS wants an on-the-wire revalidation */
-		if (nd->flags & LOOKUP_REVAL)
+		if (nd->lookup.flags & LOOKUP_REVAL)
 			goto out_force;
 		/* This is an open(2) */
 		if (nfs_lookup_check_intent(nd, LOOKUP_OPEN) != 0 &&
@@ -894,7 +894,7 @@ int nfs_is_exclusive_create(struct inode
 		return 0;
 	if (nd == NULL || nfs_lookup_check_intent(nd, LOOKUP_CREATE) == 0)
 		return 0;
-	return (nd->intent.open.flags & O_EXCL) != 0;
+	return (nd->lookup.intent.open.flags & O_EXCL) != 0;
 }
 
 static inline int nfs_reval_fsid(struct inode *dir, const struct nfs_fattr *fattr)
@@ -994,10 +994,10 @@ static int is_atomic_open(struct inode *
 	if (nd == NULL || nfs_lookup_check_intent(nd, LOOKUP_OPEN) == 0)
 		return 0;
 	/* NFS does not (yet) have a stateful open for directories */
-	if (nd->flags & LOOKUP_DIRECTORY)
+	if (nd->lookup.flags & LOOKUP_DIRECTORY)
 		return 0;
 	/* Are we trying to write to a read only partition? */
-	if (IS_RDONLY(dir) && (nd->intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
+	if (IS_RDONLY(dir) && (nd->lookup.intent.open.flags & (O_CREAT|O_TRUNC|FMODE_WRITE)))
 		return 0;
 	return 1;
 }
@@ -1021,7 +1021,7 @@ static struct dentry *nfs_atomic_lookup(
 	dentry->d_op = NFS_PROTO(dir)->dentry_ops;
 
 	/* Let vfs_create() deal with O_EXCL */
-	if (nd->intent.open.flags & O_EXCL) {
+	if (nd->lookup.intent.open.flags & O_EXCL) {
 		d_add(dentry, NULL);
 		goto out;
 	}
@@ -1036,7 +1036,7 @@ static struct dentry *nfs_atomic_lookup(
 		goto out;
 	}
 
-	if (nd->intent.open.flags & O_CREAT) {
+	if (nd->lookup.intent.open.flags & O_CREAT) {
 		nfs_begin_data_update(dir);
 		res = nfs4_atomic_open(dir, dentry, nd);
 		nfs_end_data_update(dir);
@@ -1055,7 +1055,7 @@ static struct dentry *nfs_atomic_lookup(
 			case -ENOTDIR:
 				goto no_open;
 			case -ELOOP:
-				if (!(nd->intent.open.flags & O_NOFOLLOW))
+				if (!(nd->lookup.intent.open.flags & O_NOFOLLOW))
 					goto no_open;
 			/* case -EINVAL: */
 			default:
@@ -1091,7 +1091,7 @@ static int nfs_open_revalidate(struct de
 	/* NFS only supports OPEN on regular files */
 	if (!S_ISREG(inode->i_mode))
 		goto no_open;
-	openflags = nd->intent.open.flags;
+	openflags = nd->lookup.intent.open.flags;
 	/* We cannot do exclusive creation on a positive dentry */
 	if ((openflags & (O_CREAT|O_EXCL)) == (O_CREAT|O_EXCL))
 		goto no_open;
@@ -1243,8 +1243,8 @@ static int nfs_create(struct inode *dir,
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
-	if ((nd->flags & LOOKUP_CREATE) != 0)
-		open_flags = nd->intent.open.flags;
+	if ((nd->lookup.flags & LOOKUP_CREATE) != 0)
+		open_flags = nd->lookup.intent.open.flags;
 
 	lock_kernel();
 	nfs_begin_data_update(dir);
@@ -1965,7 +1965,7 @@ int nfs_permission(struct inode *inode, 
 	if (mask == 0)
 		goto out;
 	/* Is this sys_access() ? */
-	if (nd != NULL && (nd->flags & LOOKUP_ACCESS))
+	if (nd != NULL && (nd->lookup.flags & LOOKUP_ACCESS))
 		goto force_lookup;
 
 	switch (inode->i_mode & S_IFMT) {
@@ -1975,7 +1975,7 @@ int nfs_permission(struct inode *inode, 
 			/* NFSv4 has atomic_open... */
 			if (nfs_server_capable(inode, NFS_CAP_ATOMIC_OPEN)
 					&& nd != NULL
-					&& (nd->flags & LOOKUP_OPEN))
+					&& (nd->lookup.flags & LOOKUP_OPEN))
 				goto out;
 			break;
 		case S_IFDIR:
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -107,38 +107,38 @@ static void * nfs_follow_mountpoint(stru
 
 	BUG_ON(IS_ROOT(dentry));
 	dprintk("%s: enter\n", __FUNCTION__);
-	dput(nd->dentry);
-	nd->dentry = dget(dentry);
+	dput(nd->lookup.path.dentry);
+	nd->lookup.path.dentry = dget(dentry);
 
 	/* Look it up again */
-	parent = dget_parent(nd->dentry);
+	parent = dget_parent(nd->lookup.path.dentry);
 	err = server->nfs_client->rpc_ops->lookup(parent->d_inode,
-						  &nd->dentry->d_name,
+						  &nd->lookup.path.dentry->d_name,
 						  &fh, &fattr);
 	dput(parent);
 	if (err != 0)
 		goto out_err;
 
 	if (fattr.valid & NFS_ATTR_FATTR_V4_REFERRAL)
-		mnt = nfs_do_refmount(nd->mnt, nd->dentry);
+		mnt = nfs_do_refmount(nd->lookup.path.mnt, nd->lookup.path.dentry);
 	else
-		mnt = nfs_do_submount(nd->mnt, nd->dentry, &fh, &fattr);
+		mnt = nfs_do_submount(nd->lookup.path.mnt, nd->lookup.path.dentry, &fh, &fattr);
 	err = PTR_ERR(mnt);
 	if (IS_ERR(mnt))
 		goto out_err;
 
 	mntget(mnt);
-	err = do_add_mount(mnt, nd, nd->mnt->mnt_flags|MNT_SHRINKABLE, &nfs_automount_list);
+	err = do_add_mount(mnt, nd, nd->lookup.path.mnt->mnt_flags|MNT_SHRINKABLE, &nfs_automount_list);
 	if (err < 0) {
 		mntput(mnt);
 		if (err == -EBUSY)
 			goto out_follow;
 		goto out_err;
 	}
-	mntput(nd->mnt);
-	dput(nd->dentry);
-	nd->mnt = mnt;
-	nd->dentry = dget(mnt->mnt_root);
+	mntput(nd->lookup.path.mnt);
+	dput(nd->lookup.path.dentry);
+	nd->lookup.path.mnt = mnt;
+	nd->lookup.path.dentry = dget(mnt->mnt_root);
 	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
 out:
 	dprintk("%s: done, returned %d\n", __FUNCTION__, err);
@@ -149,7 +149,7 @@ out_err:
 	path_release(nd);
 	goto out;
 out_follow:
-	while(d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
+	while(d_mountpoint(nd->lookup.path.dentry) && follow_down(&nd->lookup.path.mnt, &nd->lookup.path.dentry))
 		;
 	err = 0;
 	goto out;
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1382,10 +1382,10 @@ static int nfs4_intent_set_file(struct n
 	int ret;
 
 	/* If the open_intent is for execute, we have an extra check to make */
-	if (nd->intent.open.flags & FMODE_EXEC) {
+	if (nd->lookup.intent.open.flags & FMODE_EXEC) {
 		ret = _nfs4_do_access(state->inode,
 				state->owner->so_cred,
-				nd->intent.open.flags);
+				nd->lookup.intent.open.flags);
 		if (ret < 0)
 			goto out_close;
 	}
@@ -1398,7 +1398,7 @@ static int nfs4_intent_set_file(struct n
 	}
 	ret = PTR_ERR(filp);
 out_close:
-	nfs4_close_state(path, state, nd->intent.open.flags);
+	nfs4_close_state(path, state, nd->lookup.intent.open.flags);
 	return ret;
 }
 
@@ -1406,7 +1406,7 @@ struct dentry *
 nfs4_atomic_open(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
 	struct path path = {
-		.mnt = nd->mnt,
+		.mnt = nd->lookup.path.mnt,
 		.dentry = dentry,
 	};
 	struct iattr attr;
@@ -1414,20 +1414,20 @@ nfs4_atomic_open(struct inode *dir, stru
 	struct nfs4_state *state;
 	struct dentry *res;
 
-	if (nd->flags & LOOKUP_CREATE) {
-		attr.ia_mode = nd->intent.open.create_mode;
+	if (nd->lookup.flags & LOOKUP_CREATE) {
+		attr.ia_mode = nd->lookup.intent.open.create_mode;
 		attr.ia_valid = ATTR_MODE;
 		if (!IS_POSIXACL(dir))
 			attr.ia_mode &= ~current->fs->umask;
 	} else {
 		attr.ia_valid = 0;
-		BUG_ON(nd->intent.open.flags & O_CREAT);
+		BUG_ON(nd->lookup.intent.open.flags & O_CREAT);
 	}
 
 	cred = rpcauth_lookupcred(NFS_CLIENT(dir)->cl_auth, 0);
 	if (IS_ERR(cred))
 		return (struct dentry *)cred;
-	state = nfs4_do_open(dir, &path, nd->intent.open.flags, &attr, cred);
+	state = nfs4_do_open(dir, &path, nd->lookup.intent.open.flags, &attr, cred);
 	put_rpccred(cred);
 	if (IS_ERR(state)) {
 		if (PTR_ERR(state) == -ENOENT)
@@ -1445,7 +1445,7 @@ int
 nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, struct nameidata *nd)
 {
 	struct path path = {
-		.mnt = nd->mnt,
+		.mnt = nd->lookup.path.mnt,
 		.dentry = dentry,
 	};
 	struct rpc_cred *cred;
@@ -1888,7 +1888,7 @@ nfs4_proc_create(struct inode *dir, stru
                  int flags, struct nameidata *nd)
 {
 	struct path path = {
-		.mnt = nd->mnt,
+		.mnt = nd->lookup.path.mnt,
 		.dentry = dentry,
 	};
 	struct nfs4_state *state;
@@ -1914,7 +1914,7 @@ nfs4_proc_create(struct inode *dir, stru
 			nfs_setattr_update_inode(state->inode, sattr);
 		nfs_post_op_update_inode(state->inode, &fattr);
 	}
-	if (status == 0 && (nd->flags & LOOKUP_OPEN) != 0)
+	if (status == 0 && (nd->lookup.flags & LOOKUP_OPEN) != 0)
 		status = nfs4_intent_set_file(nd, &path, state);
 	else
 		nfs4_close_state(&path, state, flags);
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -41,7 +41,7 @@ static struct file *do_open(char *name, 
 		error = may_open(&nd, MAY_WRITE, FMODE_WRITE);
 
 	if (!error)
-		return dentry_open(nd.dentry, nd.mnt, flags);
+		return dentry_open(nd.lookup.path.dentry, nd.lookup.path.mnt, flags);
 
 	path_release(&nd);
 	return ERR_PTR(error);
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -169,8 +169,8 @@ static int expkey_parse(struct cache_det
 			goto out;
 
 		dprintk("Found the path %s\n", buf);
-		key.ek_mnt = nd.mnt;
-		key.ek_dentry = nd.dentry;
+		key.ek_mnt = nd.lookup.path.mnt;
+		key.ek_dentry = nd.lookup.path.dentry;
 		
 		ek = svc_expkey_update(&key, ek);
 		if (ek)
@@ -509,7 +509,7 @@ static int svc_export_parse(struct cache
 	struct svc_export exp, *expp;
 	int an_int;
 
-	nd.dentry = NULL;
+	nd.lookup.path.dentry = NULL;
 	exp.ex_path = NULL;
 
 	/* fs locations */
@@ -549,8 +549,8 @@ static int svc_export_parse(struct cache
 
 	exp.h.flags = 0;
 	exp.ex_client = dom;
-	exp.ex_mnt = nd.mnt;
-	exp.ex_dentry = nd.dentry;
+	exp.ex_mnt = nd.lookup.path.mnt;
+	exp.ex_dentry = nd.lookup.path.dentry;
 	exp.ex_path = kstrdup(buf, GFP_KERNEL);
 	err = -ENOMEM;
 	if (!exp.ex_path)
@@ -612,7 +612,7 @@ static int svc_export_parse(struct cache
 				goto out;
 		}
 
-		err = check_export(nd.dentry->d_inode, exp.ex_flags,
+		err = check_export(nd.lookup.path.dentry->d_inode, exp.ex_flags,
 				   exp.ex_uuid);
 		if (err) goto out;
 	}
@@ -631,7 +631,7 @@ static int svc_export_parse(struct cache
 	nfsd4_fslocs_free(&exp.ex_fslocs);
 	kfree(exp.ex_uuid);
  	kfree(exp.ex_path);
-	if (nd.dentry)
+	if (nd.lookup.path.dentry)
 		path_release(&nd);
  out_no_path:
 	if (dom)
@@ -1032,7 +1032,7 @@ exp_export(struct nfsctl_export *nxp)
 		goto out_unlock;
 	err = -EINVAL;
 
-	exp = exp_get_by_name(clp, nd.mnt, nd.dentry, NULL);
+	exp = exp_get_by_name(clp, nd.lookup.path.mnt, nd.lookup.path.dentry, NULL);
 
 	memset(&new, 0, sizeof(new));
 
@@ -1040,7 +1040,7 @@ exp_export(struct nfsctl_export *nxp)
 	if ((nxp->ex_flags & NFSEXP_FSID) &&
 	    (!IS_ERR(fsid_key = exp_get_fsid_key(clp, nxp->ex_dev))) &&
 	    fsid_key->ek_mnt &&
-	    (fsid_key->ek_mnt != nd.mnt || fsid_key->ek_dentry != nd.dentry) )
+	    (fsid_key->ek_mnt != nd.lookup.path.mnt || fsid_key->ek_dentry != nd.lookup.path.dentry) )
 		goto finish;
 
 	if (!IS_ERR(exp)) {
@@ -1056,7 +1056,7 @@ exp_export(struct nfsctl_export *nxp)
 		goto finish;
 	}
 
-	err = check_export(nd.dentry->d_inode, nxp->ex_flags, NULL);
+	err = check_export(nd.lookup.path.dentry->d_inode, nxp->ex_flags, NULL);
 	if (err) goto finish;
 
 	err = -ENOMEM;
@@ -1069,8 +1069,8 @@ exp_export(struct nfsctl_export *nxp)
 	if (!new.ex_path)
 		goto finish;
 	new.ex_client = clp;
-	new.ex_mnt = nd.mnt;
-	new.ex_dentry = nd.dentry;
+	new.ex_mnt = nd.lookup.path.mnt;
+	new.ex_dentry = nd.lookup.path.dentry;
 	new.ex_flags = nxp->ex_flags;
 	new.ex_anon_uid = nxp->ex_anon_uid;
 	new.ex_anon_gid = nxp->ex_anon_gid;
@@ -1150,7 +1150,7 @@ exp_unexport(struct nfsctl_export *nxp)
 		goto out_domain;
 
 	err = -EINVAL;
-	exp = exp_get_by_name(dom, nd.mnt, nd.dentry, NULL);
+	exp = exp_get_by_name(dom, nd.lookup.path.mnt, nd.lookup.path.dentry, NULL);
 	path_release(&nd);
 	if (IS_ERR(exp))
 		goto out_domain;
@@ -1187,12 +1187,12 @@ exp_rootfh(svc_client *clp, char *path, 
 		printk("nfsd: exp_rootfh path not found %s", path);
 		return err;
 	}
-	inode = nd.dentry->d_inode;
+	inode = nd.lookup.path.dentry->d_inode;
 
 	dprintk("nfsd: exp_rootfh(%s [%p] %s:%s/%ld)\n",
-		 path, nd.dentry, clp->name,
+		 path, nd.lookup.path.dentry, clp->name,
 		 inode->i_sb->s_id, inode->i_ino);
-	exp = exp_parent(clp, nd.mnt, nd.dentry, NULL);
+	exp = exp_parent(clp, nd.lookup.path.mnt, nd.lookup.path.dentry, NULL);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
 		goto out;
@@ -1202,7 +1202,7 @@ exp_rootfh(svc_client *clp, char *path, 
 	 * fh must be initialized before calling fh_compose
 	 */
 	fh_init(&fh, maxsize);
-	if (fh_compose(&fh, exp, nd.dentry, NULL))
+	if (fh_compose(&fh, exp, nd.lookup.path.dentry, NULL))
 		err = -EINVAL;
 	else
 		err = 0;
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -122,9 +122,9 @@ out_no_tfm:
 static void
 nfsd4_sync_rec_dir(void)
 {
-	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
-	nfsd_sync_dir(rec_dir.dentry);
-	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_lock(&rec_dir.lookup.path.dentry->d_inode->i_mutex);
+	nfsd_sync_dir(rec_dir.lookup.path.dentry);
+	mutex_unlock(&rec_dir.lookup.path.dentry->d_inode->i_mutex);
 }
 
 int
@@ -144,9 +144,9 @@ nfsd4_create_clid_dir(struct nfs4_client
 	nfs4_save_user(&uid, &gid);
 
 	/* lock the parent */
-	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_lock(&rec_dir.lookup.path.dentry->d_inode->i_mutex);
 
-	dentry = lookup_one_len(dname, rec_dir.dentry, HEXDIR_LEN-1);
+	dentry = lookup_one_len(dname, rec_dir.lookup.path.dentry, HEXDIR_LEN-1);
 	if (IS_ERR(dentry)) {
 		status = PTR_ERR(dentry);
 		goto out_unlock;
@@ -156,11 +156,11 @@ nfsd4_create_clid_dir(struct nfs4_client
 		dprintk("NFSD: nfsd4_create_clid_dir: DIRECTORY EXISTS\n");
 		goto out_put;
 	}
-	status = vfs_mkdir(rec_dir.dentry->d_inode, dentry, S_IRWXU);
+	status = vfs_mkdir(rec_dir.lookup.path.dentry->d_inode, dentry, S_IRWXU);
 out_put:
 	dput(dentry);
 out_unlock:
-	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_unlock(&rec_dir.lookup.path.dentry->d_inode->i_mutex);
 	if (status == 0) {
 		clp->cl_firststate = 1;
 		nfsd4_sync_rec_dir();
@@ -223,7 +223,7 @@ nfsd4_list_rec_dir(struct dentry *dir, r
 
 	nfs4_save_user(&uid, &gid);
 
-	filp = dentry_open(dget(dir), mntget(rec_dir.mnt), O_RDONLY);
+	filp = dentry_open(dget(dir), mntget(rec_dir.lookup.path.mnt), O_RDONLY);
 	status = PTR_ERR(filp);
 	if (IS_ERR(filp))
 		goto out;
@@ -288,9 +288,9 @@ nfsd4_unlink_clid_dir(char *name, int na
 
 	dprintk("NFSD: nfsd4_unlink_clid_dir. name %.*s\n", namlen, name);
 
-	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
-	dentry = lookup_one_len(name, rec_dir.dentry, namlen);
-	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
+	mutex_lock(&rec_dir.lookup.path.dentry->d_inode->i_mutex);
+	dentry = lookup_one_len(name, rec_dir.lookup.path.dentry, namlen);
+	mutex_unlock(&rec_dir.lookup.path.dentry->d_inode->i_mutex);
 	if (IS_ERR(dentry)) {
 		status = PTR_ERR(dentry);
 		return status;
@@ -299,7 +299,7 @@ nfsd4_unlink_clid_dir(char *name, int na
 	if (!dentry->d_inode)
 		goto out;
 
-	status = nfsd4_clear_clid_dir(rec_dir.dentry, dentry);
+	status = nfsd4_clear_clid_dir(rec_dir.lookup.path.dentry, dentry);
 out:
 	dput(dentry);
 	return status;
@@ -349,12 +349,12 @@ nfsd4_recdir_purge_old(void) {
 
 	if (!rec_dir_init)
 		return;
-	status = nfsd4_list_rec_dir(rec_dir.dentry, purge_old);
+	status = nfsd4_list_rec_dir(rec_dir.lookup.path.dentry, purge_old);
 	if (status == 0)
 		nfsd4_sync_rec_dir();
 	if (status)
 		printk("nfsd4: failed to purge old clients from recovery"
-			" directory %s\n", rec_dir.dentry->d_name.name);
+			" directory %s\n", rec_dir.lookup.path.dentry->d_name.name);
 	return;
 }
 
@@ -375,10 +375,10 @@ int
 nfsd4_recdir_load(void) {
 	int status;
 
-	status = nfsd4_list_rec_dir(rec_dir.dentry, load_recdir);
+	status = nfsd4_list_rec_dir(rec_dir.lookup.path.dentry, load_recdir);
 	if (status)
 		printk("nfsd4: failed loading clients from recovery"
-			" directory %s\n", rec_dir.dentry->d_name.name);
+			" directory %s\n", rec_dir.lookup.path.dentry->d_name.name);
 	return status;
 }
 
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3338,7 +3338,7 @@ nfs4_reset_recoverydir(char *recdir)
 	if (status)
 		return status;
 	status = -ENOTDIR;
-	if (S_ISDIR(nd.dentry->d_inode->i_mode)) {
+	if (S_ISDIR(nd.lookup.path.dentry->d_inode->i_mode)) {
 		nfs4_set_recdir(recdir);
 		status = 0;
 	}
--- a/fs/open.c
+++ b/fs/open.c
@@ -127,7 +127,7 @@ asmlinkage long sys_statfs(const char __
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct statfs tmp;
-		error = vfs_statfs_native(nd.dentry, &tmp);
+		error = vfs_statfs_native(nd.lookup.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
 		path_release(&nd);
@@ -146,7 +146,7 @@ asmlinkage long sys_statfs64(const char 
 	error = user_path_walk(path, &nd);
 	if (!error) {
 		struct statfs64 tmp;
-		error = vfs_statfs64(nd.dentry, &tmp);
+		error = vfs_statfs64(nd.lookup.path.dentry, &tmp);
 		if (!error && copy_to_user(buf, &tmp, sizeof(tmp)))
 			error = -EFAULT;
 		path_release(&nd);
@@ -233,7 +233,7 @@ static long do_sys_truncate(const char _
 	error = user_path_walk(path, &nd);
 	if (error)
 		goto out;
-	inode = nd.dentry->d_inode;
+	inode = nd.lookup.path.dentry->d_inode;
 
 	/* For directories it's -EISDIR, for other non-regulars - -EINVAL */
 	error = -EISDIR;
@@ -271,7 +271,7 @@ static long do_sys_truncate(const char _
 	error = locks_verify_truncate(inode, NULL, length);
 	if (!error) {
 		DQUOT_INIT(inode);
-		error = do_truncate(nd.dentry, length, 0, NULL);
+		error = do_truncate(nd.lookup.path.dentry, length, 0, NULL);
 	}
 
 put_write_and_out:
@@ -455,10 +455,10 @@ asmlinkage long sys_faccessat(int dfd, c
 	res = vfs_permission(&nd, mode);
 	/* SuS v2 requires we report a read only fs too */
 	if(res || !(mode & S_IWOTH) ||
-	   special_file(nd.dentry->d_inode->i_mode))
+	   special_file(nd.lookup.path.dentry->d_inode->i_mode))
 		goto out_path_release;
 
-	if(IS_RDONLY(nd.dentry->d_inode))
+	if(IS_RDONLY(nd.lookup.path.dentry->d_inode))
 		res = -EROFS;
 
 out_path_release:
@@ -490,7 +490,7 @@ asmlinkage long sys_chdir(const char __u
 	if (error)
 		goto dput_and_out;
 
-	set_fs_pwd(current->fs, nd.mnt, nd.dentry);
+	set_fs_pwd(current->fs, nd.lookup.path.mnt, nd.lookup.path.dentry);
 
 dput_and_out:
 	path_release(&nd);
@@ -545,7 +545,7 @@ asmlinkage long sys_chroot(const char __
 	if (!capable(CAP_SYS_CHROOT))
 		goto dput_and_out;
 
-	set_fs_root(current->fs, nd.mnt, nd.dentry);
+	set_fs_root(current->fs, nd.lookup.path.mnt, nd.lookup.path.dentry);
 	set_fs_altroot();
 	error = 0;
 dput_and_out:
@@ -602,7 +602,7 @@ asmlinkage long sys_fchmodat(int dfd, co
 	error = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW, &nd);
 	if (error)
 		goto out;
-	inode = nd.dentry->d_inode;
+	inode = nd.lookup.path.dentry->d_inode;
 
 	error = -EROFS;
 	if (IS_RDONLY(inode))
@@ -617,7 +617,7 @@ asmlinkage long sys_fchmodat(int dfd, co
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	error = notify_change(nd.dentry, &newattrs);
+	error = notify_change(nd.lookup.path.dentry, &newattrs);
 	mutex_unlock(&inode->i_mutex);
 
 dput_and_out:
@@ -674,7 +674,7 @@ asmlinkage long sys_chown(const char __u
 	error = user_path_walk(filename, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.lookup.path.dentry, user, group);
 	path_release(&nd);
 out:
 	return error;
@@ -694,7 +694,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = __user_walk_fd(dfd, filename, follow, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.lookup.path.dentry, user, group);
 	path_release(&nd);
 out:
 	return error;
@@ -708,7 +708,7 @@ asmlinkage long sys_lchown(const char __
 	error = user_path_walk_link(filename, &nd);
 	if (error)
 		goto out;
-	error = chown_common(nd.dentry, user, group);
+	error = chown_common(nd.lookup.path.dentry, user, group);
 	path_release(&nd);
 out:
 	return error;
@@ -846,7 +846,7 @@ EXPORT_SYMBOL(filp_open);
  * (e.g. in fifo_open), leaving you with parent locked (and in case of fifo,
  * leading to a deadlock, as nobody can open that fifo anymore, because
  * another process to open fifo will block on locked parent when doing lookup).
- * Note that in case of error, nd->intent.open.file is destroyed, but the
+ * Note that in case of error, nd->lookup.intent.open.file is destroyed, but the
  * path information remains valid.
  * If the open callback is set to NULL, then the standard f_op->open()
  * filesystem callback is substituted.
@@ -854,19 +854,19 @@ EXPORT_SYMBOL(filp_open);
 struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
 		int (*open)(struct inode *, struct file *))
 {
-	if (IS_ERR(nd->intent.open.file))
+	if (IS_ERR(nd->lookup.intent.open.file))
 		goto out;
 	if (IS_ERR(dentry))
 		goto out_err;
-	nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->mnt),
-					     nd->intent.open.flags - 1,
-					     nd->intent.open.file,
+	nd->lookup.intent.open.file = __dentry_open(dget(dentry), mntget(nd->lookup.path.mnt),
+					     nd->lookup.intent.open.flags - 1,
+					     nd->lookup.intent.open.file,
 					     open);
 out:
-	return nd->intent.open.file;
+	return nd->lookup.intent.open.file;
 out_err:
 	release_open_intent(nd);
-	nd->intent.open.file = (struct file *)dentry;
+	nd->lookup.intent.open.file = (struct file *)dentry;
 	goto out;
 }
 EXPORT_SYMBOL_GPL(lookup_instantiate_filp);
@@ -883,10 +883,10 @@ struct file *nameidata_to_filp(struct na
 	struct file *filp;
 
 	/* Pick up the filp from the open intent */
-	filp = nd->intent.open.file;
+	filp = nd->lookup.intent.open.file;
 	/* Has the filesystem initialised the file for us? */
 	if (filp->f_path.dentry == NULL)
-		filp = __dentry_open(nd->dentry, nd->mnt, flags, filp, NULL);
+		filp = __dentry_open(nd->lookup.path.dentry, nd->lookup.path.mnt, flags, filp, NULL);
 	else
 		path_release(nd);
 	return filp;
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -944,7 +944,7 @@ static void *proc_pid_follow_link(struct
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(inode, &nd->dentry, &nd->mnt);
+	error = PROC_I(inode)->op.proc_get_link(inode, &nd->lookup.path.dentry, &nd->lookup.path.mnt);
 	nd->last_type = LAST_BIND;
 out:
 	return ERR_PTR(error);
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -405,7 +405,7 @@ static int proc_sys_permission(struct in
 	if (!nd || !depth)
 		goto out;
 
-	dentry = nd->dentry;
+	dentry = nd->lookup.path.dentry;
 	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
 
 	/* If the entry does not exist deny permission */
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1982,12 +1982,12 @@ static int reiserfs_quota_on(struct supe
 	if (err)
 		return err;
 	/* Quotafile not on the same filesystem? */
-	if (nd.mnt->mnt_sb != sb) {
+	if (nd.lookup.path.mnt->mnt_sb != sb) {
 		path_release(&nd);
 		return -EXDEV;
 	}
 	/* We must not pack tails for quota files on reiserfs for quota IO to work */
-	if (!REISERFS_I(nd.dentry->d_inode)->i_flags & i_nopack_mask) {
+	if (!REISERFS_I(nd.lookup.path.dentry->d_inode)->i_flags & i_nopack_mask) {
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file must have tail packing disabled.");
 		path_release(&nd);
@@ -2000,7 +2000,7 @@ static int reiserfs_quota_on(struct supe
 		return vfs_quota_on(sb, type, format_id, path);
 	}
 	/* Quotafile not of fs root? */
-	if (nd.dentry->d_parent->d_inode != sb->s_root->d_inode)
+	if (nd.lookup.path.dentry->d_parent->d_inode != sb->s_root->d_inode)
 		reiserfs_warning(sb,
 				 "reiserfs: Quota file not on filesystem root. "
 				 "Journalled quota will not work.");
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -62,7 +62,7 @@ int vfs_stat_fd(int dfd, char __user *na
 
 	error = __user_walk_fd(dfd, name, LOOKUP_FOLLOW, &nd);
 	if (!error) {
-		error = vfs_getattr(nd.mnt, nd.dentry, stat);
+		error = vfs_getattr(nd.lookup.path.mnt, nd.lookup.path.dentry, stat);
 		path_release(&nd);
 	}
 	return error;
@@ -82,7 +82,7 @@ int vfs_lstat_fd(int dfd, char __user *n
 
 	error = __user_walk_fd(dfd, name, 0, &nd);
 	if (!error) {
-		error = vfs_getattr(nd.mnt, nd.dentry, stat);
+		error = vfs_getattr(nd.lookup.path.mnt, nd.lookup.path.dentry, stat);
 		path_release(&nd);
 	}
 	return error;
@@ -302,14 +302,14 @@ asmlinkage long sys_readlinkat(int dfd, 
 
 	error = __user_walk_fd(dfd, path, 0, &nd);
 	if (!error) {
-		struct inode * inode = nd.dentry->d_inode;
+		struct inode * inode = nd.lookup.path.dentry->d_inode;
 
 		error = -EINVAL;
 		if (inode->i_op && inode->i_op->readlink) {
-			error = security_inode_readlink(nd.dentry);
+			error = security_inode_readlink(nd.lookup.path.dentry);
 			if (!error) {
-				touch_atime(nd.mnt, nd.dentry);
-				error = inode->i_op->readlink(nd.dentry, buf, bufsiz);
+				touch_atime(nd.lookup.path.mnt, nd.lookup.path.dentry);
+				error = inode->i_op->readlink(nd.lookup.path.dentry, buf, bufsiz);
 			}
 		}
 		path_release(&nd);
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -70,7 +70,7 @@ long do_utimes(int dfd, char __user *fil
 		if (error)
 			goto out;
 
-		dentry = nd.dentry;
+		dentry = nd.lookup.path.dentry;
 	}
 
 	inode = dentry->d_inode;
--- a/fs/vfat/namei.c
+++ b/fs/vfat/namei.c
@@ -30,7 +30,7 @@ static int vfat_revalidate(struct dentry
 	int ret = 1;
 
 	if (!dentry->d_inode &&
-	    nd && !(nd->flags & LOOKUP_CONTINUE) && (nd->flags & LOOKUP_CREATE))
+	    nd && !(nd->lookup.flags & LOOKUP_CONTINUE) && (nd->lookup.flags & LOOKUP_CREATE))
 		/*
 		 * negative dentry is dropped, in order to make sure
 		 * to use the name which a user desires if this is
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -235,7 +235,7 @@ sys_setxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
+	error = setxattr(nd.lookup.path.dentry, name, value, size, flags);
 	path_release(&nd);
 	return error;
 }
@@ -250,7 +250,7 @@ sys_lsetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = setxattr(nd.dentry, name, value, size, flags);
+	error = setxattr(nd.lookup.path.dentry, name, value, size, flags);
 	path_release(&nd);
 	return error;
 }
@@ -320,7 +320,7 @@ sys_getxattr(char __user *path, char __u
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.lookup.path.dentry, name, value, size);
 	path_release(&nd);
 	return error;
 }
@@ -335,7 +335,7 @@ sys_lgetxattr(char __user *path, char __
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = getxattr(nd.dentry, name, value, size);
+	error = getxattr(nd.lookup.path.dentry, name, value, size);
 	path_release(&nd);
 	return error;
 }
@@ -394,7 +394,7 @@ sys_listxattr(char __user *path, char __
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.dentry, list, size);
+	error = listxattr(nd.lookup.path.dentry, list, size);
 	path_release(&nd);
 	return error;
 }
@@ -408,7 +408,7 @@ sys_llistxattr(char __user *path, char _
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = listxattr(nd.dentry, list, size);
+	error = listxattr(nd.lookup.path.dentry, list, size);
 	path_release(&nd);
 	return error;
 }
@@ -455,7 +455,7 @@ sys_removexattr(char __user *path, char 
 	error = user_path_walk(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.lookup.path.dentry, name);
 	path_release(&nd);
 	return error;
 }
@@ -469,7 +469,7 @@ sys_lremovexattr(char __user *path, char
 	error = user_path_walk_link(path, &nd);
 	if (error)
 		return error;
-	error = removexattr(nd.dentry, name);
+	error = removexattr(nd.lookup.path.dentry, name);
 	path_release(&nd);
 	return error;
 }
--- a/fs/xfs/linux-2.6/xfs_ioctl.c
+++ b/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -91,9 +91,9 @@ xfs_find_handle(
 		if (error)
 			return error;
 
-		ASSERT(nd.dentry);
-		ASSERT(nd.dentry->d_inode);
-		inode = igrab(nd.dentry->d_inode);
+		ASSERT(nd.lookup.path.dentry);
+		ASSERT(nd.lookup.path.dentry->d_inode);
+		inode = igrab(nd.lookup.path.dentry->d_inode);
 		path_release(&nd);
 		break;
 	}
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -167,7 +167,7 @@ static struct audit_parent *audit_init_p
 	inotify_init_watch(&parent->wdata);
 	/* grab a ref so inotify watch hangs around until we take audit_filter_mutex */
 	get_inotify_watch(&parent->wdata);
-	wd = inotify_add_watch(audit_ih, &parent->wdata, ndp->dentry->d_inode,
+	wd = inotify_add_watch(audit_ih, &parent->wdata, ndp->lookup.path.dentry->d_inode,
 			       AUDIT_IN_WATCH);
 	if (wd < 0) {
 		audit_free_parent(&parent->wdata);
@@ -1176,8 +1176,8 @@ static int audit_add_watch(struct audit_
 
 	/* update watch filter fields */
 	if (ndw) {
-		watch->dev = ndw->dentry->d_inode->i_sb->s_dev;
-		watch->ino = ndw->dentry->d_inode->i_ino;
+		watch->dev = ndw->lookup.path.dentry->d_inode->i_sb->s_dev;
+		watch->ino = ndw->lookup.path.dentry->d_inode->i_ino;
 	}
 
 	/* The audit_filter_mutex must not be held during inotify calls because
@@ -1187,7 +1187,7 @@ static int audit_add_watch(struct audit_
 	 */
 	mutex_unlock(&audit_filter_mutex);
 
-	if (inotify_find_watch(audit_ih, ndp->dentry->d_inode, &i_watch) < 0) {
+	if (inotify_find_watch(audit_ih, ndp->lookup.path.dentry->d_inode, &i_watch) < 0) {
 		parent = audit_init_parent(ndp);
 		if (IS_ERR(parent)) {
 			/* caller expects mutex locked */
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -656,7 +656,7 @@ rpc_lookup_negative(char *path, struct n
 
 	if ((error = rpc_lookup_parent(path, nd)) != 0)
 		return ERR_PTR(error);
-	dentry = rpc_lookup_create(nd->dentry, nd->last.name, nd->last.len, 1);
+	dentry = rpc_lookup_create(nd->lookup.path.dentry, nd->last.name, nd->last.len, 1);
 	if (IS_ERR(dentry))
 		rpc_release_path(nd);
 	return dentry;
@@ -674,7 +674,7 @@ rpc_mkdir(char *path, struct rpc_clnt *r
 	dentry = rpc_lookup_negative(path, &nd);
 	if (IS_ERR(dentry))
 		return dentry;
-	dir = nd.dentry->d_inode;
+	dir = nd.lookup.path.dentry->d_inode;
 	if ((error = __rpc_mkdir(dir, dentry)) != 0)
 		goto err_dput;
 	RPC_I(dentry->d_inode)->private = rpc_client;
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -734,14 +734,14 @@ static struct sock *unix_find_other(stru
 			goto put_fail;
 
 		err = -ECONNREFUSED;
-		if (!S_ISSOCK(nd.dentry->d_inode->i_mode))
+		if (!S_ISSOCK(nd.lookup.path.dentry->d_inode->i_mode))
 			goto put_fail;
-		u=unix_find_socket_byinode(nd.dentry->d_inode);
+		u=unix_find_socket_byinode(nd.lookup.path.dentry->d_inode);
 		if (!u)
 			goto put_fail;
 
 		if (u->sk_type == type)
-			touch_atime(nd.mnt, nd.dentry);
+			touch_atime(nd.lookup.path.mnt, nd.lookup.path.dentry);
 
 		path_release(&nd);
 
@@ -834,12 +834,12 @@ static int unix_bind(struct socket *sock
 		 */
 		mode = S_IFSOCK |
 		       (SOCK_INODE(sock)->i_mode & ~current->fs->umask);
-		err = vfs_mknod(nd.dentry->d_inode, dentry, mode, 0);
+		err = vfs_mknod(nd.lookup.path.dentry->d_inode, dentry, mode, 0);
 		if (err)
 			goto out_mknod_dput;
-		mutex_unlock(&nd.dentry->d_inode->i_mutex);
-		dput(nd.dentry);
-		nd.dentry = dentry;
+		mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
+		dput(nd.lookup.path.dentry);
+		nd.lookup.path.dentry = dentry;
 
 		addr->hash = UNIX_HASH_SIZE;
 	}
@@ -857,8 +857,8 @@ static int unix_bind(struct socket *sock
 		list = &unix_socket_table[addr->hash];
 	} else {
 		list = &unix_socket_table[dentry->d_inode->i_ino & (UNIX_HASH_SIZE-1)];
-		u->dentry = nd.dentry;
-		u->mnt    = nd.mnt;
+		u->dentry = nd.lookup.path.dentry;
+		u->mnt    = nd.lookup.path.mnt;
 	}
 
 	err = 0;
@@ -876,7 +876,7 @@ out:
 out_mknod_dput:
 	dput(dentry);
 out_mknod_unlock:
-	mutex_unlock(&nd.dentry->d_inode->i_mutex);
+	mutex_unlock(&nd.lookup.path.dentry->d_inode->i_mutex);
 	path_release(&nd);
 out_mknod_parent:
 	if (err==-EEXIST)
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2084,10 +2084,10 @@ static int selinux_mount(char * dev_name
 		return rc;
 
 	if (flags & MS_REMOUNT)
-		return superblock_has_perm(current, nd->mnt->mnt_sb,
+		return superblock_has_perm(current, nd->lookup.path.mnt->mnt_sb,
 		                           FILESYSTEM__REMOUNT, NULL);
 	else
-		return dentry_has_perm(current, nd->mnt, nd->dentry,
+		return dentry_has_perm(current, nd->lookup.path.mnt, nd->lookup.path.dentry,
 		                       FILE__MOUNTON);
 }
 

