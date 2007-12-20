Return-Path: <linux-kernel-owner+w=401wt.eu-S964848AbXLTO1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbXLTO1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933125AbXLTOM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:12:56 -0500
Received: from ns.suse.de ([195.135.220.2]:40933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933073AbXLTOMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:12:49 -0500
X-Mailbox-Line: From jjohansen@suse.de Thu Dec 20 06:09:46 2007
Message-Id: <20071220140946.479962131@suse.de>
References: <20071220140910.934607826@suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 20 Dec 2007 06:09:43 -0800
From: John@suse.de, Johansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 33/47] VFS: new fsetattr() file operation
Content-Disposition: inline; filename=fsetattr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new file operation: f_op->fsetattr(), that is invoked by
ftruncate, fchmod, fchown and utimensat.  Fall back to i_op->setattr()
if it is not defined.

For the reasons why we need this, see patch adding fgetattr().

ftruncate() already passed the open file to the filesystem via the
ia_file member of struct iattr.  However it is cleaner to have a
separate file operation for this, so remove ia_file and convert
existing users: fuse, AFS, and reiserfs4.  Use ATTR_FILE to allow
LSMs to distinguish file descriptor based operations.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/afs/dir.c                             |    1 +
 fs/afs/file.c                            |    1 +
 fs/afs/inode.c                           |   19 +++++++++++++++----
 fs/afs/internal.h                        |    1 +
 fs/attr.c                                |   18 ++++++++++++++----
 fs/fuse/dir.c                            |   20 +++++++++-----------
 fs/fuse/file.c                           |    7 +++++++
 fs/fuse/fuse_i.h                         |    4 ++++
 fs/open.c                                |   25 +++++++++++++------------
 fs/reiser4/plugin/file/cryptcompress.c   |   12 +++++++++++-
 fs/reiser4/plugin/file/file.c            |   27 ++++++++++++++++++++-------
 fs/reiser4/plugin/file/file.h            |    3 +++
 fs/reiser4/plugin/file/file_conversion.c |    7 +++++++
 fs/reiser4/plugin/object.c               |    5 ++++-
 fs/reiser4/plugin/plugin.h               |    1 +
 fs/utimes.c                              |    2 +-
 include/linux/fs.h                       |    9 ++-------
 17 files changed, 114 insertions(+), 48 deletions(-)

--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -45,6 +45,7 @@ const struct file_operations afs_dir_fil
 	.release	= afs_release,
 	.readdir	= afs_readdir,
 	.lock		= afs_lock,
+	.fsetattr	= afs_fsetattr,
 };
 
 const struct inode_operations afs_dir_inode_operations = {
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -36,6 +36,7 @@ const struct file_operations afs_file_op
 	.fsync		= afs_fsync,
 	.lock		= afs_lock,
 	.flock		= afs_flock,
+	.fsetattr	= afs_fsetattr,
 };
 
 const struct inode_operations afs_file_inode_operations = {
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -358,7 +358,8 @@ void afs_clear_inode(struct inode *inode
 /*
  * set the attributes of an inode
  */
-int afs_setattr(struct dentry *dentry, struct iattr *attr)
+static int afs_do_setattr(struct dentry *dentry, struct iattr *attr,
+		   struct file *file)
 {
 	struct afs_vnode *vnode = AFS_FS_I(dentry->d_inode);
 	struct key *key;
@@ -380,8 +381,8 @@ int afs_setattr(struct dentry *dentry, s
 		afs_writeback_all(vnode);
 	}
 
-	if (attr->ia_valid & ATTR_FILE) {
-		key = attr->ia_file->private_data;
+	if (file) {
+		key = file->private_data;
 	} else {
 		key = afs_request_key(vnode->volume->cell);
 		if (IS_ERR(key)) {
@@ -391,10 +392,20 @@ int afs_setattr(struct dentry *dentry, s
 	}
 
 	ret = afs_vnode_setattr(vnode, key, attr);
-	if (!(attr->ia_valid & ATTR_FILE))
+	if (!file)
 		key_put(key);
 
 error:
 	_leave(" = %d", ret);
 	return ret;
 }
+
+int afs_setattr(struct dentry *dentry, struct iattr *attr)
+{
+	return afs_do_setattr(dentry, attr, NULL);
+}
+
+int afs_fsetattr(struct file *file, struct iattr *attr)
+{
+	return afs_do_setattr(file->f_path.dentry, attr, file);
+}
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -550,6 +550,7 @@ extern void afs_zap_data(struct afs_vnod
 extern int afs_validate(struct afs_vnode *, struct key *);
 extern int afs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int afs_setattr(struct dentry *, struct iattr *);
+extern int afs_fsetattr(struct file *, struct iattr *);
 extern void afs_clear_inode(struct inode *);
 
 /*
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -100,8 +100,8 @@ int inode_setattr(struct inode * inode, 
 }
 EXPORT_SYMBOL(inode_setattr);
 
-int notify_change(struct dentry *dentry, struct vfsmount *mnt,
-		  struct iattr *attr)
+int fnotify_change(struct dentry *dentry, struct vfsmount *mnt,
+		   struct iattr *attr, struct file *file)
 {
 	struct inode *inode = dentry->d_inode;
 	mode_t mode = inode->i_mode;
@@ -160,8 +160,12 @@ int notify_change(struct dentry *dentry,
 
 	if (inode->i_op && inode->i_op->setattr) {
 		error = security_inode_setattr(dentry, mnt, attr);
-		if (!error)
-			error = inode->i_op->setattr(dentry, attr);
+		if (!error) {
+			if (file && file->f_op && file->f_op->fsetattr)
+				error = file->f_op->fsetattr(file, attr);
+			else
+				error = inode->i_op->setattr(dentry, attr);
+		}
 	} else {
 		error = inode_change_ok(inode, attr);
 		if (!error)
@@ -184,4 +188,10 @@ int notify_change(struct dentry *dentry,
 	return error;
 }
 
+int notify_change(struct dentry *dentry, struct vfsmount *mnt,
+		  struct iattr *attr)
+{
+	return fnotify_change(dentry, mnt, attr, NULL);
+}
+
 EXPORT_SYMBOL(notify_change);
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1063,21 +1063,22 @@ static int fuse_dir_fsync(struct file *f
 	return file ? fuse_fsync_common(file, de, datasync, 1) : 0;
 }
 
-static bool update_mtime(unsigned ivalid)
+static bool update_mtime(unsigned ivalid, bool have_file)
 {
 	/* Always update if mtime is explicitly set  */
 	if (ivalid & ATTR_MTIME_SET)
 		return true;
 
 	/* If it's an open(O_TRUNC) or an ftruncate(), don't update */
-	if ((ivalid & ATTR_SIZE) && (ivalid & (ATTR_OPEN | ATTR_FILE)))
+	if ((ivalid & ATTR_SIZE) && ((ivalid & ATTR_OPEN) || have_file))
 		return false;
 
 	/* In all other cases update */
 	return true;
 }
 
-static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg)
+static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg,
+			   bool have_file)
 {
 	unsigned ivalid = iattr->ia_valid;
 
@@ -1096,7 +1097,7 @@ static void iattr_to_fattr(struct iattr 
 		if (!(ivalid & ATTR_ATIME_SET))
 			arg->valid |= FATTR_ATIME_NOW;
 	}
-	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid)) {
+	if ((ivalid & ATTR_MTIME) && update_mtime(ivalid, have_file)) {
 		arg->valid |= FATTR_MTIME;
 		arg->mtime = iattr->ia_mtime.tv_sec;
 		arg->mtimensec = iattr->ia_mtime.tv_nsec;
@@ -1113,8 +1114,8 @@ static void iattr_to_fattr(struct iattr 
  * vmtruncate() doesn't allow for this case, so do the rlimit checking
  * and the actual truncation by hand.
  */
-static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
-			   struct file *file)
+int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
+		    struct file *file)
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1152,7 +1153,7 @@ static int fuse_do_setattr(struct dentry
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
-	iattr_to_fattr(attr, &inarg);
+	iattr_to_fattr(attr, &inarg, file != NULL);
 	if (file) {
 		struct fuse_file *ff = file->private_data;
 		inarg.valid |= FATTR_FH;
@@ -1194,10 +1195,7 @@ static int fuse_do_setattr(struct dentry
 
 static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 {
-	if (attr->ia_valid & ATTR_FILE)
-		return fuse_do_setattr(entry, attr, attr->ia_file);
-	else
-		return fuse_do_setattr(entry, attr, NULL);
+	return fuse_do_setattr(entry, attr, NULL);
 }
 
 static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -918,6 +918,11 @@ static sector_t fuse_bmap(struct address
 	return err ? 0 : outarg.block;
 }
 
+static int fuse_fsetattr(struct file *file, struct iattr *attr)
+{
+	return fuse_do_setattr(file->f_path.dentry, attr, file);
+}
+
 static const struct file_operations fuse_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -932,6 +937,7 @@ static const struct file_operations fuse
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
 	.fgetattr	= fuse_file_fgetattr,
+	.fsetattr	= fuse_fsetattr,
 	.splice_read	= generic_file_splice_read,
 };
 
@@ -946,6 +952,7 @@ static const struct file_operations fuse
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
 	.fgetattr	= fuse_file_fgetattr,
+	.fsetattr	= fuse_fsetattr,
 	/* no mmap and splice_read */
 };
 
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -505,6 +505,10 @@ void fuse_change_attributes(struct inode
  */
 int fuse_dev_init(void);
 
+
+int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
+		    struct file *file);
+
 /**
  * Cleanup the client device
  */
--- a/fs/open.c
+++ b/fs/open.c
@@ -206,16 +206,15 @@ int do_truncate(struct dentry *dentry, s
 
 	newattrs.ia_size = length;
 	newattrs.ia_valid = ATTR_SIZE | time_attrs;
-	if (filp) {
-		newattrs.ia_file = filp;
+
+	if (filp)
 		newattrs.ia_valid |= ATTR_FILE;
-	}
 
 	/* Remove suid/sgid on truncate too */
 	newattrs.ia_valid |= should_remove_suid(dentry);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	err = notify_change(dentry, mnt, &newattrs);
+	err = fnotify_change(dentry, mnt, &newattrs, filp);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return err;
 }
@@ -590,8 +589,8 @@ asmlinkage long sys_fchmod(unsigned int 
 	if (mode == (mode_t) -1)
 		mode = inode->i_mode;
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
-	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	err = notify_change(dentry, file->f_path.mnt, &newattrs);
+	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME | ATTR_FILE;
+	err = fnotify_change(dentry, file->f_path.mnt, &newattrs, file);
 	mutex_unlock(&inode->i_mutex);
 
 out_drop_write:
@@ -645,7 +644,7 @@ asmlinkage long sys_chmod(const char __u
 }
 
 static int chown_common(struct dentry * dentry, struct vfsmount *mnt,
-			uid_t user, gid_t group)
+			uid_t user, gid_t group, struct file *file)
 {
 	struct inode * inode;
 	int error;
@@ -671,8 +670,10 @@ static int chown_common(struct dentry * 
 	if (!S_ISDIR(inode->i_mode))
 		newattrs.ia_valid |=
 			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
+	if (file)
+		newattrs.ia_valid |= ATTR_FILE;
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(dentry, mnt, &newattrs);
+	error = fnotify_change(dentry, mnt, &newattrs, file);
 	mutex_unlock(&inode->i_mutex);
 out:
 	return error;
@@ -689,7 +690,7 @@ asmlinkage long sys_chown(const char __u
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.path.dentry, nd.path.mnt, user, group);
+	error = chown_common(nd.path.dentry, nd.path.mnt, user, group, NULL);
 	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_put(&nd.path);
@@ -714,7 +715,7 @@ asmlinkage long sys_fchownat(int dfd, co
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.path.dentry, nd.path.mnt, user, group);
+	error = chown_common(nd.path.dentry, nd.path.mnt, user, group, NULL);
 	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_put(&nd.path);
@@ -733,7 +734,7 @@ asmlinkage long sys_lchown(const char __
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto out_release;
-	error = chown_common(nd.path.dentry, nd.path.mnt, user, group);
+	error = chown_common(nd.path.dentry, nd.path.mnt, user, group, NULL);
 	mnt_drop_write(nd.path.mnt);
 out_release:
 	path_put(&nd.path);
@@ -757,7 +758,7 @@ asmlinkage long sys_fchown(unsigned int 
 		goto out_fput;
 	dentry = file->f_path.dentry;
 	audit_inode(NULL, dentry);
-	error = chown_common(dentry, file->f_path.mnt, user, group);
+	error = chown_common(dentry, file->f_path.mnt, user, group, file);
 	mnt_drop_write(file->f_vfsmnt);
 out_fput:
 	fput(file);
--- a/fs/reiser4/plugin/file/cryptcompress.c
+++ b/fs/reiser4/plugin/file/cryptcompress.c
@@ -3688,7 +3688,7 @@ int delete_object_cryptcompress(struct i
  * plugin->setattr
  * This implements actual truncate (see comments in reiser4/page_cache.c)
  */
-int setattr_cryptcompress(struct dentry *dentry, struct iattr *attr)
+static int do_setattr_cryptcompress(struct dentry *dentry, struct iattr *attr)
 {
 	int result;
 	struct inode *inode;
@@ -3731,6 +3731,16 @@ int setattr_cryptcompress(struct dentry 
 	return result;
 }
 
+int setattr_cryptcompress(struct dentry *dentry, struct iattr *attr)
+{
+	return do_setattr_cryptcompress(dentry, attr);
+}
+
+int fsetattr_cryptcompress(struct file *file, struct iattr *attr)
+{
+	return do_setattr_cryptcompress(file->f_path.dentry, attr);
+}
+
 /* plugin->release */
 int release_cryptcompress(struct inode *inode, struct file *file)
 {
--- a/fs/reiser4/plugin/file/file.c
+++ b/fs/reiser4/plugin/file/file.c
@@ -561,19 +561,20 @@ static int should_have_notail(const stru
  * truncate_file_body - change length of file
  * @inode: inode of file
  * @new_size: new file length
+ * @file: open file being truncated through foperation
  *
  * Adjusts items file @inode is built of to match @new_size. It may either cut
  * items or add them to represent a hole at the end of file. The caller has to
  * obtain exclusive access to the file.
  */
-static int truncate_file_body(struct inode *inode, struct iattr *attr)
+static int truncate_file_body(struct inode *inode, struct iattr *attr,
+			      struct file *file)
 {
 	int result;
 	loff_t new_size = attr->ia_size;
 
 	if (inode->i_size < new_size) {
 		/* expanding truncate */
-		struct file * file = attr->ia_file;
 		struct unix_file_info *uf_info = unix_file_inode_data(inode);
 
 		assert("edward-1532", attr->ia_valid & ATTR_FILE);
@@ -2581,7 +2582,8 @@ owns_item_unix_file(const struct inode *
 	return 1;
 }
 
-static int setattr_truncate(struct inode *inode, struct iattr *attr)
+static int setattr_truncate(struct inode *inode, struct iattr *attr,
+			    struct file *file)
 {
 	int result;
 	int s_result;
@@ -2597,7 +2599,7 @@ static int setattr_truncate(struct inode
 	if (result == 0)
 		result = safe_link_add(inode, SAFE_TRUNCATE);
 	if (result == 0)
-		result = truncate_file_body(inode, attr);
+		result = truncate_file_body(inode, attr, file);
 	if (result)
 		warning("vs-1588", "truncate_file failed: oid %lli, "
 			"old size %lld, new size %lld, retval %d",
@@ -2619,8 +2621,9 @@ static int setattr_truncate(struct inode
 /* plugin->u.file.setattr method */
 /* This calls inode_setattr and if truncate is in effect it also takes
    exclusive inode access to avoid races */
-int setattr_unix_file(struct dentry *dentry,	/* Object to change attributes */
-		      struct iattr *attr /* change description */ )
+static int do_setattr_unix_file(struct dentry *dentry,	/* Object to change attributes */
+				struct iattr *attr, /* change description */
+				struct file *file)
 {
 	int result;
 
@@ -2636,7 +2639,7 @@ int setattr_unix_file(struct dentry *den
 
 		uf_info = unix_file_inode_data(dentry->d_inode);
 		get_exclusive_access_careful(uf_info, dentry->d_inode);
-		result = setattr_truncate(dentry->d_inode, attr);
+		result = setattr_truncate(dentry->d_inode, attr, file);
 		drop_exclusive_access(uf_info);
 		context_set_commit_async(ctx);
 		reiser4_exit_context(ctx);
@@ -2646,6 +2649,16 @@ int setattr_unix_file(struct dentry *den
 	return result;
 }
 
+int setattr_unix_file(struct dentry *dentry, struct iattr *attr)
+{
+	return do_setattr_unix_file(dentry, attr, NULL);
+}
+
+int fsetattr_unix_file(struct file *file, struct iattr *attr)
+{
+	return do_setattr_unix_file(file->f_path.dentry, attr, file);
+}
+
 /* plugin->u.file.init_inode_data */
 void
 init_inode_data_unix_file(struct inode *inode,
--- a/fs/reiser4/plugin/file/file.h
+++ b/fs/reiser4/plugin/file/file.h
@@ -39,6 +39,7 @@ int reiser4_mmap_careful(struct file *, 
 int reiser4_open_careful(struct inode *inode, struct file *file);
 int reiser4_release_careful(struct inode *, struct file *);
 int reiser4_sync_file_common(struct file *, struct dentry *, int datasync);
+int reiser4_fsetattr_careful(struct file *file, struct iattr *attr);
 
 /* address space operations */
 int reiser4_readpage(struct file *, struct page *);
@@ -70,6 +71,7 @@ int ioctl_unix_file(struct inode *, stru
 int mmap_unix_file(struct file *, struct vm_area_struct *);
 int open_unix_file(struct inode *, struct file *);
 int release_unix_file(struct inode *, struct file *);
+int fsetattr_unix_file(struct file *, struct iattr *);
 
 /* private address space operations */
 int readpage_unix_file(struct file *, struct page *);
@@ -107,6 +109,7 @@ int ioctl_cryptcompress(struct inode *, 
 int mmap_cryptcompress(struct file *, struct vm_area_struct *);
 int open_cryptcompress(struct inode *, struct file *);
 int release_cryptcompress(struct inode *, struct file *);
+int fsetattr_cryptcompress(struct file *file, struct iattr *attr);
 
 /* private address space operations */
 int readpage_cryptcompress(struct file *, struct page *);
--- a/fs/reiser4/plugin/file/file_conversion.c
+++ b/fs/reiser4/plugin/file/file_conversion.c
@@ -602,6 +602,13 @@ int reiser4_setattr_careful(struct dentr
 			   setattr_conversion_hook(inode, attr));
 }
 
+int reiser4_fsetattr_careful(struct file *file, struct iattr *attr)
+{
+	struct inode * inode = file->f_path.dentry->d_inode;
+	return PROT_ACTIVE(int, fsetattr, (file, attr),
+			   setattr_conversion_hook(inode, attr));
+}
+
 /* Wrappers with passive protection for:
  *
  * ->open();
--- a/fs/reiser4/plugin/object.c
+++ b/fs/reiser4/plugin/object.c
@@ -105,7 +105,8 @@ static struct file_operations regular_fi
 	.release = reiser4_release_careful,
 	.fsync = reiser4_sync_file_common,
 	.splice_read = generic_file_splice_read,
-	.splice_write = generic_file_splice_write
+	.splice_write = generic_file_splice_write,
+	.fsetattr = reiser4_fsetattr_careful
 };
 static struct address_space_operations regular_file_a_ops = {
 	.writepage = reiser4_writepage,
@@ -211,6 +212,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.writepages = writepages_unix_file,
 		.prepare_write = prepare_write_unix_file,
 		.commit_write = commit_write_unix_file,
+		.fsetattr = fsetattr_unix_file,
 		/*
 		 * private a_ops
 		 */
@@ -405,6 +407,7 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 		.writepages = writepages_cryptcompress,
 		.prepare_write = prepare_write_cryptcompress,
 		.commit_write = commit_write_cryptcompress,
+		.fsetattr = fsetattr_cryptcompress,
 
 		.bmap = bmap_cryptcompress,
 
--- a/fs/reiser4/plugin/plugin.h
+++ b/fs/reiser4/plugin/plugin.h
@@ -237,6 +237,7 @@ typedef struct file_plugin {
 		      unsigned int cmd, unsigned long arg);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*release) (struct inode *, struct file *);
+	int (*fsetattr)(struct file *, struct iattr *);
 	/*
 	 * private a_ops
 	 */
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -135,7 +135,7 @@ long do_utimes(int dfd, char __user *fil
 		}
 	}
 	mutex_lock(&inode->i_mutex);
-	error = notify_change(path.dentry, path.mnt, &newattrs);
+	error = fnotify_change(path.dentry, path.mnt, &newattrs, f);
 	mutex_unlock(&inode->i_mutex);
 mnt_drop_write_and_out:
 	mnt_drop_write(path.mnt);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -351,13 +351,6 @@ struct iattr {
 	struct timespec	ia_atime;
 	struct timespec	ia_mtime;
 	struct timespec	ia_ctime;
-
-	/*
-	 * Not an attribute, but an auxilary info for filesystems wanting to
-	 * implement an ftruncate() like method.  NOTE: filesystem should
-	 * check for (ia_valid & ATTR_FILE), and not for (ia_file != NULL).
-	 */
-	struct file	*ia_file;
 };
 
 /*
@@ -1191,6 +1184,7 @@ struct file_operations {
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **);
 	int (*fgetattr)(struct file *, struct kstat *);
+	int (*fsetattr)(struct file *, struct iattr *);
 };
 
 struct inode_operations {
@@ -1697,6 +1691,7 @@ extern int do_remount_sb(struct super_bl
 extern sector_t bmap(struct inode *, sector_t);
 #endif
 extern int notify_change(struct dentry *, struct vfsmount *, struct iattr *);
+extern int fnotify_change(struct dentry *, struct vfsmount *, struct iattr *, struct file *);
 extern int permission(struct inode *, int, struct nameidata *);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));

-- 

