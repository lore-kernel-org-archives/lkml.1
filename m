Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYBSEL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYBSEL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYBSELm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:11:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:58520 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYBSELj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:11:39 -0500
Message-Id: <20080219040828.690045213@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:37 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 02/11] introduce simple_fs_type
Content-Disposition: inline; filename=libfs-super.diff
X-Provags-ID: V01U2FsdGVkX18GtdxEZ3ikldOYYTH512GdSzMfAtSoxV5ZSYP
 tVGYxqUXxEo1gwGxYkydJKR7xdv87VzpGNQPSkd01zc9VzAJ9p
 9YXrqHcL5Qj+Y7xHeslIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a number of pseudo file systems in the kernel
that are basically copies of debugfs, all implementing the
same boilerplate code, just with different bugs.

This adds yet another copy to the kernel in the libfs directory,
with generalized helpers that can be used by any of them.

The most interesting function here is the new "struct dentry *
simple_register_filesystem(struct simple_fs_type *type)", which
returns the root directory of a new file system that can then
be passed to simple_create_file() and similar functions as a
parent.

Signed-off-by: Arnd Bergman <arnd@arndb.de>
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -263,11 +263,6 @@ int simple_link(struct dentry *old_dentr
 	return 0;
 }
 
-static inline int simple_positive(struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
 int simple_empty(struct dentry *dentry)
 {
 	struct dentry *child;
@@ -409,109 +404,6 @@ int simple_write_end(struct file *file, 
 	return copied;
 }
 
-/*
- * the inodes created here are not hashed. If you use iunique to generate
- * unique inode values later for this filesystem, then you must take care
- * to pass it an appropriate max_reserved value to avoid collisions.
- */
-int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files)
-{
-	struct inode *inode;
-	struct dentry *root;
-	struct dentry *dentry;
-	int i;
-
-	s->s_blocksize = PAGE_CACHE_SIZE;
-	s->s_blocksize_bits = PAGE_CACHE_SHIFT;
-	s->s_magic = magic;
-	s->s_op = &simple_super_operations;
-	s->s_time_gran = 1;
-
-	inode = new_inode(s);
-	if (!inode)
-		return -ENOMEM;
-	/*
-	 * because the root inode is 1, the files array must not contain an
-	 * entry at index 1
-	 */
-	inode->i_ino = 1;
-	inode->i_mode = S_IFDIR | 0755;
-	inode->i_uid = inode->i_gid = 0;
-	inode->i_blocks = 0;
-	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	inode->i_op = &simple_dir_inode_operations;
-	inode->i_fop = &simple_dir_operations;
-	inode->i_nlink = 2;
-	root = d_alloc_root(inode);
-	if (!root) {
-		iput(inode);
-		return -ENOMEM;
-	}
-	for (i = 0; !files->name || files->name[0]; i++, files++) {
-		if (!files->name)
-			continue;
-
-		/* warn if it tries to conflict with the root inode */
-		if (unlikely(i == 1))
-			printk(KERN_WARNING "%s: %s passed in a files array"
-				"with an index of 1!\n", __func__,
-				s->s_type->name);
-
-		dentry = d_alloc_name(root, files->name);
-		if (!dentry)
-			goto out;
-		inode = new_inode(s);
-		if (!inode)
-			goto out;
-		inode->i_mode = S_IFREG | files->mode;
-		inode->i_uid = inode->i_gid = 0;
-		inode->i_blocks = 0;
-		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		inode->i_fop = files->ops;
-		inode->i_ino = i;
-		d_add(dentry, inode);
-	}
-	s->s_root = root;
-	return 0;
-out:
-	d_genocide(root);
-	dput(root);
-	return -ENOMEM;
-}
-
-static DEFINE_SPINLOCK(pin_fs_lock);
-
-int simple_pin_fs(struct file_system_type *type, struct vfsmount **mount, int *count)
-{
-	struct vfsmount *mnt = NULL;
-	spin_lock(&pin_fs_lock);
-	if (unlikely(!*mount)) {
-		spin_unlock(&pin_fs_lock);
-		mnt = vfs_kern_mount(type, 0, type->name, NULL);
-		if (IS_ERR(mnt))
-			return PTR_ERR(mnt);
-		spin_lock(&pin_fs_lock);
-		if (!*mount)
-			*mount = mnt;
-	}
-	mntget(*mount);
-	++*count;
-	spin_unlock(&pin_fs_lock);
-	mntput(mnt);
-	return 0;
-}
-
-void simple_release_fs(struct vfsmount **mount, int *count)
-{
-	struct vfsmount *mnt;
-	spin_lock(&pin_fs_lock);
-	mnt = *mount;
-	if (!--*count)
-		*mount = NULL;
-	spin_unlock(&pin_fs_lock);
-	mntput(mnt);
-}
-
 ssize_t simple_read_from_buffer(void __user *to, size_t count, loff_t *ppos,
 				const void *from, size_t available)
 {
@@ -786,14 +678,11 @@ EXPORT_SYMBOL(simple_dir_inode_operation
 EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);
 EXPORT_SYMBOL(d_alloc_name);
-EXPORT_SYMBOL(simple_fill_super);
 EXPORT_SYMBOL(simple_getattr);
 EXPORT_SYMBOL(simple_link);
 EXPORT_SYMBOL(simple_lookup);
-EXPORT_SYMBOL(simple_pin_fs);
 EXPORT_SYMBOL(simple_prepare_write);
 EXPORT_SYMBOL(simple_readpage);
-EXPORT_SYMBOL(simple_release_fs);
 EXPORT_SYMBOL(simple_rename);
 EXPORT_SYMBOL(simple_rmdir);
 EXPORT_SYMBOL(simple_statfs);
Index: linux-2.6/fs/libfs/super.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/libfs/super.c
@@ -0,0 +1,179 @@
+/*
+ *	fs/libfs/super.c
+ *	Library for filesystems writers -- superblock operations
+ */
+
+#include <linux/libfs.h>
+#include <linux/fsnotify.h>
+#include <linux/module.h>
+#include <linux/pagemap.h>
+#include <linux/mount.h>
+#include <linux/vfs.h>
+#include <linux/mutex.h>
+#include <linux/exportfs.h>
+
+#include <asm/uaccess.h>
+
+static DEFINE_SPINLOCK(pin_fs_lock);
+
+int simple_pin_fs(struct file_system_type *type, struct vfsmount **mount, int *count)
+{
+	struct vfsmount *mnt = NULL;
+	spin_lock(&pin_fs_lock);
+	if (unlikely(!*mount)) {
+		spin_unlock(&pin_fs_lock);
+		mnt = vfs_kern_mount(type, 0, type->name, NULL);
+		if (IS_ERR(mnt))
+			return PTR_ERR(mnt);
+		spin_lock(&pin_fs_lock);
+		if (!*mount)
+			*mount = mnt;
+	}
+	mntget(*mount);
+	++*count;
+	spin_unlock(&pin_fs_lock);
+	mntput(mnt);
+	return 0;
+}
+EXPORT_SYMBOL(simple_pin_fs);
+
+void simple_release_fs(struct vfsmount **mount, int *count)
+{
+	struct vfsmount *mnt;
+	spin_lock(&pin_fs_lock);
+	mnt = *mount;
+	if (!--*count)
+		*mount = NULL;
+	spin_unlock(&pin_fs_lock);
+	mntput(mnt);
+}
+EXPORT_SYMBOL(simple_release_fs);
+
+static const struct super_operations simple_super_operations = {
+	.statfs		= simple_statfs,
+};
+
+/*
+ * the inodes created here are not hashed. If you use iunique to generate
+ * unique inode values later for this filesystem, then you must take care
+ * to pass it an appropriate max_reserved value to avoid collisions.
+ */
+int simple_fill_super(struct super_block *s, int magic, const struct tree_descr *files)
+{
+	struct inode *inode;
+	struct dentry *root;
+	struct dentry *dentry;
+	int i;
+
+	s->s_blocksize = PAGE_CACHE_SIZE;
+	s->s_blocksize_bits = PAGE_CACHE_SHIFT;
+	s->s_magic = magic;
+	if (!s->s_op)
+		s->s_op = &simple_super_operations;
+	s->s_time_gran = 1;
+
+	inode = new_inode(s);
+	if (!inode)
+		return -ENOMEM;
+	/*
+	 * because the root inode is 1, the files array must not contain an
+	 * entry at index 1
+	 */
+	inode->i_ino = 1;
+	inode->i_mode = S_IFDIR | 0755;
+	inode->i_uid = inode->i_gid = 0;
+	inode->i_blocks = 0;
+	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_op = &simple_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+	inode->i_nlink = 2;
+	root = d_alloc_root(inode);
+	if (!root) {
+		iput(inode);
+		return -ENOMEM;
+	}
+	for (i = 0; !files->name || files->name[0]; i++, files++) {
+		if (!files->name)
+			continue;
+
+		/* warn if it tries to conflict with the root inode */
+		if (unlikely(i == 1))
+			printk(KERN_WARNING "%s: %s passed in a files array"
+				"with an index of 1!\n", __func__,
+				s->s_type->name);
+
+		dentry = d_alloc_name(root, files->name);
+		if (!dentry)
+			goto out;
+		inode = new_inode(s);
+		if (!inode)
+			goto out;
+		inode->i_mode = S_IFREG | files->mode;
+		inode->i_uid = inode->i_gid = 0;
+		inode->i_blocks = 0;
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		inode->i_fop = files->ops;
+		inode->i_ino = i;
+		d_add(dentry, inode);
+	}
+	s->s_root = root;
+	return 0;
+out:
+	d_genocide(root);
+	dput(root);
+	return -ENOMEM;
+}
+EXPORT_SYMBOL(simple_fill_super);
+
+static int __simple_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct simple_fs_type *type;
+	static struct tree_descr simple_files[] = { { "" } };
+	struct tree_descr *files = simple_files;
+
+	type = container_of(sb->s_type, struct simple_fs_type, fstype);
+	if (type->super_ops)
+		sb->s_op = type->super_ops;
+	if (type->files)
+		files = type->files;
+
+	return simple_fill_super(sb, type->magic, files);
+}
+
+static int simple_get_sb(struct file_system_type *fs_type,
+			int flags, const char *dev_name,
+			void *data, struct vfsmount *mnt)
+{
+	return get_sb_single(fs_type, flags, data, __simple_fill_super, mnt);
+}
+
+struct dentry *simple_register_filesystem(struct simple_fs_type *type)
+{
+	int retval;
+
+	type->fstype.get_sb = simple_get_sb;
+	type->fstype.kill_sb = kill_litter_super,
+
+	retval = register_filesystem(&type->fstype);
+	if (retval)
+		goto out;
+
+	retval = simple_pin_fs(&type->fstype, &type->mount,
+			       &type->mount_count);
+	if (retval)
+		goto unregister;
+	return type->mount->mnt_root;
+
+unregister:
+	unregister_filesystem(&type->fstype);
+out:
+	return ERR_PTR(retval);
+}
+EXPORT_SYMBOL_GPL(simple_register_filesystem);
+
+void simple_unregister_filesystem(struct simple_fs_type *type)
+{
+	simple_release_fs(&type->mount, &type->mount_count);
+	unregister_filesystem(&type->fstype);
+}
+EXPORT_SYMBOL_GPL(simple_unregister_filesystem);
Index: linux-2.6/fs/libfs/inode.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/libfs/inode.c
@@ -0,0 +1,420 @@
+/*
+ *	fs/libfs/inode.c
+ *	Library for filesystems writers -- inode operations
+ */
+
+#include <linux/libfs.h>
+#include <linux/fsnotify.h>
+#include <linux/module.h>
+#include <linux/pagemap.h>
+#include <linux/mount.h>
+#include <linux/vfs.h>
+#include <linux/mutex.h>
+#include <linux/exportfs.h>
+
+#include <asm/uaccess.h>
+
+static inline struct simple_fs_type *to_simple_fs(struct dentry *dentry)
+{
+	return container_of(dentry->d_sb->s_type,
+				struct simple_fs_type, fstype);
+}
+
+static ssize_t simple_read_file(struct file *file, char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t simple_write_file(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	return count;
+}
+
+int simple_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(simple_open);
+
+const struct file_operations simple_file_operations = {
+	.read =		simple_read_file,
+	.write =	simple_write_file,
+	.open =		simple_open,
+};
+
+static void *simple_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	nd_set_link(nd, dentry->d_inode->i_private);
+	return NULL;
+}
+
+const struct inode_operations simple_link_operations = {
+	.readlink       = generic_readlink,
+	.follow_link    = simple_follow_link,
+};
+
+static struct inode *simple_get_inode(struct super_block *sb, int mode, dev_t dev)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (inode) {
+		inode->i_mode = mode;
+		inode->i_uid = 0;
+		inode->i_gid = 0;
+		inode->i_blocks = 0;
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		switch (mode & S_IFMT) {
+		default:
+			init_special_inode(inode, mode, dev);
+			break;
+		case S_IFREG:
+			inode->i_fop = &simple_file_operations;
+			break;
+		case S_IFLNK:
+			inode->i_op = &simple_link_operations;
+			break;
+		case S_IFDIR:
+			inode->i_op = &simple_dir_inode_operations;
+			inode->i_fop = &simple_dir_operations;
+
+			/* directory inodes start off with i_nlink == 2
+			 * (for "." entry) */
+			inc_nlink(inode);
+			break;
+		}
+	}
+	return inode;
+}
+
+/* SMP-safe */
+static int simple_mknod(struct inode *dir, struct dentry *dentry,
+			 int mode, dev_t dev)
+{
+	struct inode *inode;
+	int error = -EPERM;
+
+	if (dentry->d_inode)
+		return -EEXIST;
+
+	inode = simple_get_inode(dir->i_sb, mode, dev);
+	if (inode) {
+		d_instantiate(dentry, inode);
+		dget(dentry);
+		error = 0;
+	}
+	return error;
+}
+
+static int simple_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+{
+	int res;
+
+	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
+	res = simple_mknod(dir, dentry, mode, 0);
+	if (!res) {
+		inc_nlink(dir);
+		fsnotify_mkdir(dir, dentry);
+	}
+	return res;
+}
+
+static int simple_symlink(struct inode *dir, struct dentry *dentry, int mode)
+{
+	mode = (mode & S_IALLUGO) | S_IFLNK;
+	return simple_mknod(dir, dentry, mode, 0);
+}
+
+static int simple_create(struct inode *dir, struct dentry *dentry, int mode)
+{
+	int res;
+
+	mode = (mode & S_IALLUGO) | S_IFREG;
+	res = simple_mknod(dir, dentry, mode, 0);
+	if (!res)
+		fsnotify_create(dir, dentry);
+	return res;
+}
+
+static int simple_create_by_name(const char *name, mode_t mode,
+				  struct dentry *parent,
+				  struct dentry **dentry)
+{
+	int error = 0;
+
+	*dentry = NULL;
+	mutex_lock(&parent->d_inode->i_mutex);
+	*dentry = lookup_one_len(name, parent, strlen(name));
+	if (!IS_ERR(*dentry)) {
+		switch (mode & S_IFMT) {
+		case S_IFDIR:
+			error = simple_mkdir(parent->d_inode, *dentry, mode);
+			break;
+		case S_IFLNK:
+			error = simple_symlink(parent->d_inode, *dentry, mode);
+			break;
+		default:
+			error = simple_create(parent->d_inode, *dentry, mode);
+			break;
+		}
+		dput(*dentry);
+	} else
+		error = PTR_ERR(*dentry);
+	mutex_unlock(&parent->d_inode->i_mutex);
+
+	return error;
+}
+
+/**
+ * simple_create_file - create a file in the debugfs filesystem
+ * @name: a pointer to a string containing the name of the file to create.
+ * @mode: the permission that the file should have
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this paramater is NULL, then the
+ *          file will be created in the root of the debugfs filesystem.
+ * @data: a pointer to something that the caller will want to get to later
+ *        on.  The inode.i_private pointer will point to this value on
+ *        the open() call.
+ * @fops: a pointer to a struct file_operations that should be used for
+ *        this file.
+ *
+ * This is the basic "create a file" function for debugfs.  It allows for a
+ * wide range of flexibility in createing a file, or a directory (if you
+ * want to create a directory, the debugfs_create_dir() function is
+ * recommended to be used instead.)
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the simple_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *simple_create_file(const char *name, mode_t mode,
+				   struct dentry *parent, void *data,
+				   const struct file_operations *fops)
+{
+	struct dentry *dentry = NULL;
+	struct simple_fs_type *type;
+	int error;
+
+	pr_debug("debugfs: creating file '%s'\n", name);
+
+	if (!parent) {
+		pr_debug("debugfs: Ah! can not find a parent!\n");
+		goto exit;
+	}
+
+	type = to_simple_fs(parent);
+	error = simple_pin_fs(&type->fstype, &type->mount,
+			      &type->mount_count);
+	if (error)
+		goto exit;
+
+	error = simple_create_by_name(name, mode, parent, &dentry);
+	if (error) {
+		struct simple_fs_type *type = to_simple_fs(parent);
+		dentry = NULL;
+		simple_release_fs(&type->mount, &type->mount_count);
+		goto exit;
+	}
+
+	if (dentry->d_inode) {
+		if (data)
+			dentry->d_inode->i_private = data;
+		if (fops)
+			dentry->d_inode->i_fop = fops;
+	}
+exit:
+	return dentry;
+}
+EXPORT_SYMBOL_GPL(simple_create_file);
+
+/**
+ * simple_create_dir - create a directory in the debugfs filesystem
+ * @name: a pointer to a string containing the name of the directory to
+ *        create.
+ * @parent: a pointer to the parent dentry for this file.  This should be a
+ *          directory dentry if set.  If this paramater is NULL, then the
+ *          directory will be created in the root of the debugfs filesystem.
+ *
+ * This function creates a directory in debugfs with the given name.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the file is
+ * to be removed (no automatic cleanup happens if your module is unloaded,
+ * you are responsible here.)  If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *simple_create_dir(const char *name, struct dentry *parent)
+{
+	return simple_create_file(name,
+				   S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
+				   parent, NULL, NULL);
+}
+EXPORT_SYMBOL_GPL(simple_create_dir);
+
+/**
+ * simple_create_symlink- create a symbolic link in the debugfs filesystem
+ * @name: a pointer to a string containing the name of the symbolic link to
+ *        create.
+ * @parent: a pointer to the parent dentry for this symbolic link.  This
+ *          should be a directory dentry if set.  If this paramater is NULL,
+ *          then the symbolic link will be created in the root of the debugfs
+ *          filesystem.
+ * @target: a pointer to a string containing the path to the target of the
+ *          symbolic link.
+ *
+ * This function creates a symbolic link with the given name in debugfs that
+ * links to the given target path.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the symbolic
+ * link is to be removed (no automatic cleanup happens if your module is
+ * unloaded, you are responsible here.)  If an error occurs, %NULL will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *simple_create_symlink(const char *name, struct dentry *parent,
+				      const char *target)
+{
+	struct dentry *result;
+	char *link;
+
+	link = kstrdup(target, GFP_KERNEL);
+	if (!link)
+		return NULL;
+
+	result = simple_create_file(name, S_IFLNK | S_IRWXUGO, parent, link,
+				     NULL);
+	if (!result)
+		kfree(link);
+	return result;
+}
+EXPORT_SYMBOL_GPL(simple_create_symlink);
+
+/**
+ * simple_remove - removes a file or directory from the debugfs filesystem
+ * @dentry: a pointer to a the dentry of the file or directory to be
+ *          removed.
+ *
+ * This function removes a file or directory in debugfs that was previously
+ * created with a call to another debugfs function (like
+ * debugfs_create_file() or variants thereof.)
+ *
+ * This function is required to be called in order for the file to be
+ * removed, no automatic cleanup of files will happen when a module is
+ * removed, you are responsible here.
+ */
+void simple_remove(struct dentry *dentry)
+{
+	struct dentry *parent;
+	int ret = 0;
+	struct simple_fs_type *type = to_simple_fs(dentry);
+
+	if (!dentry)
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	mutex_lock(&parent->d_inode->i_mutex);
+	if (simple_positive(dentry)) {
+		if (dentry->d_inode) {
+			dget(dentry);
+			switch (dentry->d_inode->i_mode & S_IFMT) {
+			case S_IFDIR:
+				ret = simple_rmdir(parent->d_inode, dentry);
+				break;
+			case S_IFLNK:
+				kfree(dentry->d_inode->i_private);
+				/* fall through */
+			default:
+				simple_unlink(parent->d_inode, dentry);
+				break;
+			}
+			if (!ret)
+				d_delete(dentry);
+			dput(dentry);
+		}
+	}
+	mutex_unlock(&parent->d_inode->i_mutex);
+	simple_release_fs(&type->mount, &type->mount_count);
+}
+EXPORT_SYMBOL_GPL(simple_remove);
+
+/**
+ * simple_rename - rename a file/directory in the debugfs filesystem
+ * @old_dir: a pointer to the parent dentry for the renamed object. This
+ *          should be a directory dentry.
+ * @old_dentry: dentry of an object to be renamed.
+ * @new_dir: a pointer to the parent dentry where the object should be
+ *          moved. This should be a directory dentry.
+ * @new_name: a pointer to a string containing the target name.
+ *
+ * This function renames a file/directory in debugfs.  The target must not
+ * exist for rename to succeed.
+ *
+ * This function will return a pointer to old_dentry (which is updated to
+ * reflect renaming) if it succeeds. If an error occurs, %NULL will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *simple_rename_named(struct dentry *old_dir,
+		struct dentry *old_dentry, struct dentry *new_dir,
+		const char *new_name)
+{
+	int error;
+	struct dentry *dentry = NULL, *trap;
+	const char *old_name;
+
+	trap = lock_rename(new_dir, old_dir);
+	/* Source or destination directories don't exist? */
+	if (!old_dir->d_inode || !new_dir->d_inode)
+		goto exit;
+	/* Source does not exist, cyclic rename, or mountpoint? */
+	if (!old_dentry->d_inode || old_dentry == trap ||
+	    d_mountpoint(old_dentry))
+		goto exit;
+	dentry = lookup_one_len(new_name, new_dir, strlen(new_name));
+	/* Lookup failed, cyclic rename or target exists? */
+	if (IS_ERR(dentry) || dentry == trap || dentry->d_inode)
+		goto exit;
+
+	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
+
+	error = simple_rename(old_dir->d_inode, old_dentry, new_dir->d_inode,
+		dentry);
+	if (error) {
+		fsnotify_oldname_free(old_name);
+		goto exit;
+	}
+	d_move(old_dentry, dentry);
+	fsnotify_move(old_dir->d_inode, new_dir->d_inode, old_name,
+		old_dentry->d_name.name, S_ISDIR(old_dentry->d_inode->i_mode),
+		NULL, old_dentry);
+	fsnotify_oldname_free(old_name);
+	unlock_rename(new_dir, old_dir);
+	dput(dentry);
+	return old_dentry;
+exit:
+	if (dentry && !IS_ERR(dentry))
+		dput(dentry);
+	unlock_rename(new_dir, old_dir);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(simple_rename_named);
+
+
Index: linux-2.6/include/linux/libfs.h
===================================================================
--- linux-2.6.orig/include/linux/libfs.h
+++ linux-2.6/include/linux/libfs.h
@@ -3,6 +3,29 @@
 
 #include <linux/fs.h>
 
+/* simple_fs interface */
+struct simple_fs_type {
+	struct file_system_type fstype;
+	struct tree_descr *files;
+	unsigned long magic;
+	struct vfsmount *mount;
+	int mount_count;
+	struct super_operations *super_ops;
+};
+
+#define DEFINE_SIMPLE_FS(_type, _name, _files, _magic)	\
+struct simple_fs_type _type = {		\
+	.fstype = {			\
+		.owner = THIS_MODULE,	\
+		.name  = (_name),	\
+	},				\
+	.files = (_files),		\
+	.magic = (_magic),		\
+};
+
+extern struct dentry *simple_register_filesystem(struct simple_fs_type *type);
+extern void simple_unregister_filesystem(struct simple_fs_type *type);
+
 extern const struct file_operations simple_fops_u8;
 extern const struct file_operations simple_fops_x8;
 extern const struct file_operations simple_fops_u16;
@@ -18,4 +41,26 @@ struct simple_blob_wrapper {
 	unsigned long size;
 };
 
+/* high-level dentry management */
+struct dentry *simple_create_file(const char *name, mode_t mode,
+				  struct dentry *parent, void *data,
+				  const struct file_operations *fops);
+struct dentry *simple_create_dir(const char *name,
+				 struct dentry *parent);
+struct dentry *simple_create_symlink(const char *name, struct dentry *parent,
+				     const char *target);
+void simple_remove(struct dentry *dentry);
+struct dentry *simple_rename_named(struct dentry *old_dir,
+				   struct dentry *old_dentry,
+				   struct dentry *new_dir,
+				   const char *new_name);
+
+int simple_open(struct inode *, struct file *);
+
+static inline int simple_positive(struct dentry *dentry)
+{
+	return dentry->d_inode && !d_unhashed(dentry);
+}
+
+
 #endif /* __LIBFS_H__ */
Index: linux-2.6/fs/autofs4/autofs_i.h
===================================================================
--- linux-2.6.orig/fs/autofs4/autofs_i.h
+++ linux-2.6/fs/autofs4/autofs_i.h
@@ -214,11 +214,6 @@ static inline u64 autofs4_get_ino(struct
 	return sbi->sb->s_root->d_inode->i_ino;
 }
 
-static inline int simple_positive(struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
 static inline int __simple_empty(struct dentry *dentry)
 {
 	struct dentry *child;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -1959,7 +1959,7 @@ extern const struct file_operations simp
 extern const struct inode_operations simple_dir_inode_operations;
 struct tree_descr { char *name; const struct file_operations *ops; int mode; };
 struct dentry *d_alloc_name(struct dentry *, const char *);
-extern int simple_fill_super(struct super_block *, int, struct tree_descr *);
+extern int simple_fill_super(struct super_block *, int, const struct tree_descr *);
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 
Index: linux-2.6/fs/libfs/Makefile
===================================================================
--- linux-2.6.orig/fs/libfs/Makefile
+++ linux-2.6/fs/libfs/Makefile
@@ -1,3 +1,3 @@
 libfs-y += file.o
 
-obj-$(CONFIG_LIBFS) += libfs.o
+obj-$(CONFIG_LIBFS) += libfs.o inode.o super.o

-- 

