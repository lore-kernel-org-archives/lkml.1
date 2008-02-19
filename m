Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbYBSEOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbYBSEOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbYBSEM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:12:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:49201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbYBSEMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:12:23 -0500
Message-Id: <20080219040828.823685054@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:38 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 03/11] slim down debugfs
Content-Disposition: inline; filename=slim-down-debugfs.diff
X-Provags-ID: V01U2FsdGVkX1/1SHbtnQfdCeINx/ktgZveGZkm6/0IKFy6MSk
 6+qOV57T22XCk+CQUWkl4EITHYRDoAt2qI2k5WHJ6G+f7vdlbM
 tueORGn5qQjjDJ520qBRg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With most of debugfs now copied to generic code in libfs,
we can remove the original copy and replace it with thin
wrappers around libfs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/fs/Kconfig
===================================================================
--- linux-2.6.orig/fs/Kconfig
+++ linux-2.6/fs/Kconfig
@@ -1001,6 +1001,14 @@ config CONFIGFS_FS
 	  Both sysfs and configfs can and should exist together on the
 	  same system. One is not a replacement for the other.
 
+config LIBFS
+	tristate
+	default m
+	help
+	  libfs is a helper library used by many of the simpler file
+	  systems. Parts of libfs can be modular when all of its users
+	  are modules as well, and the users should select this symbol.
+
 endmenu
 
 menu "Miscellaneous filesystems"
Index: linux-2.6/fs/debugfs/file.c
===================================================================
--- linux-2.6.orig/fs/debugfs/file.c
+++ linux-2.6/fs/debugfs/file.c
@@ -19,55 +19,6 @@
 #include <linux/namei.h>
 #include <linux/debugfs.h>
 
-static ssize_t default_read_file(struct file *file, char __user *buf,
-				 size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static ssize_t default_write_file(struct file *file, const char __user *buf,
-				   size_t count, loff_t *ppos)
-{
-	return count;
-}
-
-static int default_open(struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
-
-	return 0;
-}
-
-const struct file_operations debugfs_file_operations = {
-	.read =		default_read_file,
-	.write =	default_write_file,
-	.open =		default_open,
-};
-
-static void *debugfs_follow_link(struct dentry *dentry, struct nameidata *nd)
-{
-	nd_set_link(nd, dentry->d_inode->i_private);
-	return NULL;
-}
-
-const struct inode_operations debugfs_link_operations = {
-	.readlink       = generic_readlink,
-	.follow_link    = debugfs_follow_link,
-};
-
-static int debugfs_u8_set(void *data, u64 val)
-{
-	*(u8 *)data = val;
-	return 0;
-}
-static int debugfs_u8_get(void *data, u64 *val)
-{
-	*val = *(u8 *)data;
-	return 0;
-}
-DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs_u8_get, debugfs_u8_set, "%llu\n");
-
 /**
  * debugfs_create_u8 - create a debugfs file that is used to read and write an unsigned 8-bit value
  * @name: a pointer to a string containing the name of the file to create.
@@ -95,22 +46,10 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u8, debugfs
 struct dentry *debugfs_create_u8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value)
 {
-	return debugfs_create_file(name, mode, parent, value, &fops_u8);
+	return debugfs_create_file(name, mode, parent, value, &simple_fops_u8);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u8);
 
-static int debugfs_u16_set(void *data, u64 val)
-{
-	*(u16 *)data = val;
-	return 0;
-}
-static int debugfs_u16_get(void *data, u64 *val)
-{
-	*val = *(u16 *)data;
-	return 0;
-}
-DEFINE_SIMPLE_ATTRIBUTE(fops_u16, debugfs_u16_get, debugfs_u16_set, "%llu\n");
-
 /**
  * debugfs_create_u16 - create a debugfs file that is used to read and write an unsigned 16-bit value
  * @name: a pointer to a string containing the name of the file to create.
@@ -138,22 +77,10 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u16, debugf
 struct dentry *debugfs_create_u16(const char *name, mode_t mode,
 				  struct dentry *parent, u16 *value)
 {
-	return debugfs_create_file(name, mode, parent, value, &fops_u16);
+	return debugfs_create_file(name, mode, parent, value, &simple_fops_u16);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u16);
 
-static int debugfs_u32_set(void *data, u64 val)
-{
-	*(u32 *)data = val;
-	return 0;
-}
-static int debugfs_u32_get(void *data, u64 *val)
-{
-	*val = *(u32 *)data;
-	return 0;
-}
-DEFINE_SIMPLE_ATTRIBUTE(fops_u32, debugfs_u32_get, debugfs_u32_set, "%llu\n");
-
 /**
  * debugfs_create_u32 - create a debugfs file that is used to read and write an unsigned 32-bit value
  * @name: a pointer to a string containing the name of the file to create.
@@ -181,23 +108,10 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u32, debugf
 struct dentry *debugfs_create_u32(const char *name, mode_t mode,
 				 struct dentry *parent, u32 *value)
 {
-	return debugfs_create_file(name, mode, parent, value, &fops_u32);
+	return debugfs_create_file(name, mode, parent, value, &simple_fops_u32);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
-static int debugfs_u64_set(void *data, u64 val)
-{
-	*(u64 *)data = val;
-	return 0;
-}
-
-static int debugfs_u64_get(void *data, u64 *val)
-{
-	*val = *(u64 *)data;
-	return 0;
-}
-DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugfs_u64_get, debugfs_u64_set, "%llu\n");
-
 /**
  * debugfs_create_u64 - create a debugfs file that is used to read and write an unsigned 64-bit value
  * @name: a pointer to a string containing the name of the file to create.
@@ -225,16 +139,10 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_u64, debugf
 struct dentry *debugfs_create_u64(const char *name, mode_t mode,
 				 struct dentry *parent, u64 *value)
 {
-	return debugfs_create_file(name, mode, parent, value, &fops_u64);
+	return debugfs_create_file(name, mode, parent, value, &simple_fops_u64);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u64);
 
-DEFINE_SIMPLE_ATTRIBUTE(fops_x8, debugfs_u8_get, debugfs_u8_set, "0x%02llx\n");
-
-DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");
-
-DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");
-
 /*
  * debugfs_create_x{8,16,32} - create a debugfs file that is used to read and write an unsigned {8,16,32}-bit value
  *
@@ -256,7 +164,7 @@ DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugf
 struct dentry *debugfs_create_x8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value)
 {
-	return debugfs_create_file(name, mode, parent, value, &fops_x8);
+	return debugfs_create_file(name, mode, parent, value, &simple_fops_x8);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x8);
 
@@ -273,7 +181,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_x8);
 struct dentry *debugfs_create_x16(const char *name, mode_t mode,
 				 struct dentry *parent, u16 *value)
 {
-	return debugfs_create_file(name, mode, parent, value, &fops_x16);
+	return debugfs_create_file(name, mode, parent, value, &simple_fops_x16);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x16);
 
@@ -290,58 +198,10 @@ EXPORT_SYMBOL_GPL(debugfs_create_x16);
 struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 				 struct dentry *parent, u32 *value)
 {
-	return debugfs_create_file(name, mode, parent, value, &fops_x32);
+	return debugfs_create_file(name, mode, parent, value, &simple_fops_x32);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_x32);
 
-static ssize_t read_file_bool(struct file *file, char __user *user_buf,
-			      size_t count, loff_t *ppos)
-{
-	char buf[3];
-	u32 *val = file->private_data;
-	
-	if (*val)
-		buf[0] = 'Y';
-	else
-		buf[0] = 'N';
-	buf[1] = '\n';
-	buf[2] = 0x00;
-	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
-}
-
-static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
-			       size_t count, loff_t *ppos)
-{
-	char buf[32];
-	int buf_size;
-	u32 *val = file->private_data;
-
-	buf_size = min(count, (sizeof(buf)-1));
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-
-	switch (buf[0]) {
-	case 'y':
-	case 'Y':
-	case '1':
-		*val = 1;
-		break;
-	case 'n':
-	case 'N':
-	case '0':
-		*val = 0;
-		break;
-	}
-	
-	return count;
-}
-
-static const struct file_operations fops_bool = {
-	.read =		read_file_bool,
-	.write =	write_file_bool,
-	.open =		default_open,
-};
-
 /**
  * debugfs_create_bool - create a debugfs file that is used to read and write a boolean value
  * @name: a pointer to a string containing the name of the file to create.
@@ -369,23 +229,10 @@ static const struct file_operations fops
 struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 				   struct dentry *parent, u32 *value)
 {
-	return debugfs_create_file(name, mode, parent, value, &fops_bool);
+	return debugfs_create_file(name, mode, parent, value, &simple_fops_bool);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_bool);
 
-static ssize_t read_file_blob(struct file *file, char __user *user_buf,
-			      size_t count, loff_t *ppos)
-{
-	struct debugfs_blob_wrapper *blob = file->private_data;
-	return simple_read_from_buffer(user_buf, count, ppos, blob->data,
-			blob->size);
-}
-
-static const struct file_operations fops_blob = {
-	.read =		read_file_blob,
-	.open =		default_open,
-};
-
 /**
  * debugfs_create_blob - create a debugfs file that is used to read and write a binary blob
  * @name: a pointer to a string containing the name of the file to create.
@@ -412,8 +259,8 @@ static const struct file_operations fops
  */
 struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				   struct dentry *parent,
-				   struct debugfs_blob_wrapper *blob)
+				   struct simple_blob_wrapper *blob)
 {
-	return debugfs_create_file(name, mode, parent, blob, &fops_blob);
+	return debugfs_create_file(name, mode, parent, blob, &simple_fops_blob);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_blob);
Index: linux-2.6/fs/debugfs/inode.c
===================================================================
--- linux-2.6.orig/fs/debugfs/inode.c
+++ linux-2.6/fs/debugfs/inode.c
@@ -29,164 +29,7 @@
 
 #define DEBUGFS_MAGIC	0x64626720
 
-/* declared over in file.c */
-extern struct file_operations debugfs_file_operations;
-extern struct inode_operations debugfs_link_operations;
-
-static struct vfsmount *debugfs_mount;
-static int debugfs_mount_count;
-
-static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev)
-{
-	struct inode *inode = new_inode(sb);
-
-	if (inode) {
-		inode->i_mode = mode;
-		inode->i_uid = 0;
-		inode->i_gid = 0;
-		inode->i_blocks = 0;
-		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		switch (mode & S_IFMT) {
-		default:
-			init_special_inode(inode, mode, dev);
-			break;
-		case S_IFREG:
-			inode->i_fop = &debugfs_file_operations;
-			break;
-		case S_IFLNK:
-			inode->i_op = &debugfs_link_operations;
-			break;
-		case S_IFDIR:
-			inode->i_op = &simple_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
-
-			/* directory inodes start off with i_nlink == 2
-			 * (for "." entry) */
-			inc_nlink(inode);
-			break;
-		}
-	}
-	return inode; 
-}
-
-/* SMP-safe */
-static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
-			 int mode, dev_t dev)
-{
-	struct inode *inode;
-	int error = -EPERM;
-
-	if (dentry->d_inode)
-		return -EEXIST;
-
-	inode = debugfs_get_inode(dir->i_sb, mode, dev);
-	if (inode) {
-		d_instantiate(dentry, inode);
-		dget(dentry);
-		error = 0;
-	}
-	return error;
-}
-
-static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
-{
-	int res;
-
-	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
-	res = debugfs_mknod(dir, dentry, mode, 0);
-	if (!res) {
-		inc_nlink(dir);
-		fsnotify_mkdir(dir, dentry);
-	}
-	return res;
-}
-
-static int debugfs_link(struct inode *dir, struct dentry *dentry, int mode)
-{
-	mode = (mode & S_IALLUGO) | S_IFLNK;
-	return debugfs_mknod(dir, dentry, mode, 0);
-}
-
-static int debugfs_create(struct inode *dir, struct dentry *dentry, int mode)
-{
-	int res;
-
-	mode = (mode & S_IALLUGO) | S_IFREG;
-	res = debugfs_mknod(dir, dentry, mode, 0);
-	if (!res)
-		fsnotify_create(dir, dentry);
-	return res;
-}
-
-static inline int debugfs_positive(struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
-static int debug_fill_super(struct super_block *sb, void *data, int silent)
-{
-	static struct tree_descr debug_files[] = {{""}};
-
-	return simple_fill_super(sb, DEBUGFS_MAGIC, debug_files);
-}
-
-static int debug_get_sb(struct file_system_type *fs_type,
-			int flags, const char *dev_name,
-			void *data, struct vfsmount *mnt)
-{
-	return get_sb_single(fs_type, flags, data, debug_fill_super, mnt);
-}
-
-static struct file_system_type debug_fs_type = {
-	.owner =	THIS_MODULE,
-	.name =		"debugfs",
-	.get_sb =	debug_get_sb,
-	.kill_sb =	kill_litter_super,
-};
-
-static int debugfs_create_by_name(const char *name, mode_t mode,
-				  struct dentry *parent,
-				  struct dentry **dentry)
-{
-	int error = 0;
-
-	/* If the parent is not specified, we create it in the root.
-	 * We need the root dentry to do this, which is in the super 
-	 * block. A pointer to that is in the struct vfsmount that we
-	 * have around.
-	 */
-	if (!parent) {
-		if (debugfs_mount && debugfs_mount->mnt_sb) {
-			parent = debugfs_mount->mnt_sb->s_root;
-		}
-	}
-	if (!parent) {
-		pr_debug("debugfs: Ah! can not find a parent!\n");
-		return -EFAULT;
-	}
-
-	*dentry = NULL;
-	mutex_lock(&parent->d_inode->i_mutex);
-	*dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(*dentry)) {
-		switch (mode & S_IFMT) {
-		case S_IFDIR:
-			error = debugfs_mkdir(parent->d_inode, *dentry, mode);
-			break;
-		case S_IFLNK:
-			error = debugfs_link(parent->d_inode, *dentry, mode);
-			break;
-		default:
-			error = debugfs_create(parent->d_inode, *dentry, mode);
-			break;
-		}
-		dput(*dentry);
-	} else
-		error = PTR_ERR(*dentry);
-	mutex_unlock(&parent->d_inode->i_mutex);
-
-	return error;
-}
+static struct dentry *debugfs_root;
 
 /**
  * debugfs_create_file - create a file in the debugfs filesystem
@@ -219,28 +62,20 @@ struct dentry *debugfs_create_file(const
 				   const struct file_operations *fops)
 {
 	struct dentry *dentry = NULL;
-	int error;
 
 	pr_debug("debugfs: creating file '%s'\n",name);
 
-	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
-			      &debugfs_mount_count);
-	if (error)
-		goto exit;
+	/* If the parent is not specified, we create it in the root.
+	 * of the standard debugfs */
+	if (!parent)
+		parent = debugfs_root;
 
-	error = debugfs_create_by_name(name, mode, parent, &dentry);
-	if (error) {
-		dentry = NULL;
-		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+	if (!parent) {
+		pr_debug("debugfs: Ah! can not find a parent!\n");
 		goto exit;
 	}
 
-	if (dentry->d_inode) {
-		if (data)
-			dentry->d_inode->i_private = data;
-		if (fops)
-			dentry->d_inode->i_fop = fops;
-	}
+	dentry = simple_create_file(name, mode, parent, data, fops);
 exit:
 	return dentry;
 }
@@ -266,7 +101,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_file);
  */
 struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 {
-	return debugfs_create_file(name, 
+	return debugfs_create_file(name,
 				   S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
 				   parent, NULL, NULL);
 }
@@ -328,38 +163,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_symlink
  */
 void debugfs_remove(struct dentry *dentry)
 {
-	struct dentry *parent;
-	int ret = 0;
-	
-	if (!dentry)
-		return;
-
-	parent = dentry->d_parent;
-	if (!parent || !parent->d_inode)
-		return;
-
-	mutex_lock(&parent->d_inode->i_mutex);
-	if (debugfs_positive(dentry)) {
-		if (dentry->d_inode) {
-			dget(dentry);
-			switch (dentry->d_inode->i_mode & S_IFMT) {
-			case S_IFDIR:
-				ret = simple_rmdir(parent->d_inode, dentry);
-				break;
-			case S_IFLNK:
-				kfree(dentry->d_inode->i_private);
-				/* fall through */
-			default:
-				simple_unlink(parent->d_inode, dentry);
-				break;
-			}
-			if (!ret)
-				d_delete(dentry);
-			dput(dentry);
-		}
-	}
-	mutex_unlock(&parent->d_inode->i_mutex);
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+	return simple_remove(dentry);
 }
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
@@ -385,48 +189,12 @@ EXPORT_SYMBOL_GPL(debugfs_remove);
 struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
 		struct dentry *new_dir, const char *new_name)
 {
-	int error;
-	struct dentry *dentry = NULL, *trap;
-	const char *old_name;
-
-	trap = lock_rename(new_dir, old_dir);
-	/* Source or destination directories don't exist? */
-	if (!old_dir->d_inode || !new_dir->d_inode)
-		goto exit;
-	/* Source does not exist, cyclic rename, or mountpoint? */
-	if (!old_dentry->d_inode || old_dentry == trap ||
-	    d_mountpoint(old_dentry))
-		goto exit;
-	dentry = lookup_one_len(new_name, new_dir, strlen(new_name));
-	/* Lookup failed, cyclic rename or target exists? */
-	if (IS_ERR(dentry) || dentry == trap || dentry->d_inode)
-		goto exit;
-
-	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
-
-	error = simple_rename(old_dir->d_inode, old_dentry, new_dir->d_inode,
-		dentry);
-	if (error) {
-		fsnotify_oldname_free(old_name);
-		goto exit;
-	}
-	d_move(old_dentry, dentry);
-	fsnotify_move(old_dir->d_inode, new_dir->d_inode, old_name,
-		old_dentry->d_name.name, S_ISDIR(old_dentry->d_inode->i_mode),
-		NULL, old_dentry);
-	fsnotify_oldname_free(old_name);
-	unlock_rename(new_dir, old_dir);
-	dput(dentry);
-	return old_dentry;
-exit:
-	if (dentry && !IS_ERR(dentry))
-		dput(dentry);
-	unlock_rename(new_dir, old_dir);
-	return NULL;
+	return simple_rename_named(old_dir, old_dentry, new_dir, new_name);
 }
 EXPORT_SYMBOL_GPL(debugfs_rename);
 
 static struct kobject *debug_kobj;
+static DEFINE_SIMPLE_FS(debug_fs_type, "debugfs", NULL, DEBUGFS_MAGIC);
 
 static int __init debugfs_init(void)
 {
@@ -436,16 +204,18 @@ static int __init debugfs_init(void)
 	if (!debug_kobj)
 		return -EINVAL;
 
-	retval = register_filesystem(&debug_fs_type);
-	if (retval)
+	retval = 0;
+	debugfs_root = simple_register_filesystem(&debug_fs_type);
+	if (IS_ERR(debugfs_root)) {
 		kobject_put(debug_kobj);
+		retval = PTR_ERR(debugfs_root);
+	}
 	return retval;
 }
 
 static void __exit debugfs_exit(void)
 {
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
-	unregister_filesystem(&debug_fs_type);
+	simple_unregister_filesystem(&debug_fs_type);
 	kobject_put(debug_kobj);
 }
 
Index: linux-2.6/include/linux/debugfs.h
===================================================================
--- linux-2.6.orig/include/linux/debugfs.h
+++ linux-2.6/include/linux/debugfs.h
@@ -15,18 +15,14 @@
 #ifndef _DEBUGFS_H_
 #define _DEBUGFS_H_
 
+#include <linux/libfs.h>
 #include <linux/fs.h>
 
 #include <linux/types.h>
 
 struct file_operations;
 
-struct debugfs_blob_wrapper {
-	void *data;
-	unsigned long size;
-};
-
-#if defined(CONFIG_DEBUG_FS)
+#if defined(CONFIG_DEBUG_FS) || defined(CONFIG_DEBUG_FS_MODULE)
 struct dentry *debugfs_create_file(const char *name, mode_t mode,
 				   struct dentry *parent, void *data,
 				   const struct file_operations *fops);
@@ -60,7 +56,7 @@ struct dentry *debugfs_create_bool(const
 
 struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				  struct dentry *parent,
-				  struct debugfs_blob_wrapper *blob);
+				  struct simple_blob_wrapper *blob);
 #else
 
 #include <linux/err.h>
@@ -158,7 +154,7 @@ static inline struct dentry *debugfs_cre
 
 static inline struct dentry *debugfs_create_blob(const char *name, mode_t mode,
 				  struct dentry *parent,
-				  struct debugfs_blob_wrapper *blob)
+				  struct simple_blob_wrapper *blob)
 {
 	return ERR_PTR(-ENODEV);
 }
Index: linux-2.6/drivers/net/wireless/rt2x00/rt2x00debug.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ linux-2.6/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -100,8 +100,8 @@ struct rt2x00debug_intf {
 	 * that has been created in advance. This will simplify
 	 * the code since we can use the debugfs functions.
 	 */
-	struct debugfs_blob_wrapper driver_blob;
-	struct debugfs_blob_wrapper chipset_blob;
+	struct simple_blob_wrapper driver_blob;
+	struct simple_blob_wrapper chipset_blob;
 
 	/*
 	 * Requested offset for each register type.
@@ -381,7 +381,7 @@ static const struct file_operations rt2x
 static struct dentry *rt2x00debug_create_file_driver(const char *name,
 						     struct rt2x00debug_intf
 						     *intf,
-						     struct debugfs_blob_wrapper
+						     struct simple_blob_wrapper
 						     *blob)
 {
 	char *data;
@@ -403,7 +403,7 @@ static struct dentry *rt2x00debug_create
 						      struct rt2x00debug_intf
 						      *intf,
 						      struct
-						      debugfs_blob_wrapper
+						      simple_blob_wrapper
 						      *blob)
 {
 	const struct rt2x00debug *debug = intf->debug;

-- 

