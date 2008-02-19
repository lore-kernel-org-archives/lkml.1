Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYBSEMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYBSEMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYBSELu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:11:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:55170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYBSELr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:11:47 -0500
Message-Id: <20080219040828.954859181@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:39 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 04/11] slim down securityfs
Content-Disposition: inline; filename=slim-down-securityfs.diff
X-Provags-ID: V01U2FsdGVkX186sJrlot7UvwkMdHNDNYvvVHttyt3zxFZKAh0
 IXnY5PT/oApBRJLD9037zbRKSK2tRnjv7eE67fjQBsgj0fqkkX
 1oxKcyKJafdY8NkWr6+Hw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new simple_fs_type in place, securityfs practically
becomes a nop and we just need to leave code around to manage
its mount point.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/security/inode.c
===================================================================
--- linux-2.6.orig/security/inode.c
+++ linux-2.6/security/inode.c
@@ -13,176 +13,14 @@
  */
 
 /* #define DEBUG */
+
 #include <linux/module.h>
-#include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/pagemap.h>
 #include <linux/init.h>
-#include <linux/namei.h>
 #include <linux/security.h>
 
 #define SECURITYFS_MAGIC	0x73636673
 
-static struct vfsmount *mount;
-static int mount_count;
-
-/*
- * TODO:
- *   I think I can get rid of these default_file_ops, but not quite sure...
- */
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
-static const struct file_operations default_file_ops = {
-	.read =		default_read_file,
-	.write =	default_write_file,
-	.open =		default_open,
-};
-
-static struct inode *get_inode(struct super_block *sb, int mode, dev_t dev)
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
-			inode->i_fop = &default_file_ops;
-			break;
-		case S_IFDIR:
-			inode->i_op = &simple_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
-
-			/* directory inodes start off with i_nlink == 2 (for "." entry) */
-			inc_nlink(inode);
-			break;
-		}
-	}
-	return inode;
-}
-
-/* SMP-safe */
-static int mknod(struct inode *dir, struct dentry *dentry,
-			 int mode, dev_t dev)
-{
-	struct inode *inode;
-	int error = -EPERM;
-
-	if (dentry->d_inode)
-		return -EEXIST;
-
-	inode = get_inode(dir->i_sb, mode, dev);
-	if (inode) {
-		d_instantiate(dentry, inode);
-		dget(dentry);
-		error = 0;
-	}
-	return error;
-}
-
-static int mkdir(struct inode *dir, struct dentry *dentry, int mode)
-{
-	int res;
-
-	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
-	res = mknod(dir, dentry, mode, 0);
-	if (!res)
-		inc_nlink(dir);
-	return res;
-}
-
-static int create(struct inode *dir, struct dentry *dentry, int mode)
-{
-	mode = (mode & S_IALLUGO) | S_IFREG;
-	return mknod(dir, dentry, mode, 0);
-}
-
-static inline int positive(struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
-static int fill_super(struct super_block *sb, void *data, int silent)
-{
-	static struct tree_descr files[] = {{""}};
-
-	return simple_fill_super(sb, SECURITYFS_MAGIC, files);
-}
-
-static int get_sb(struct file_system_type *fs_type,
-		  int flags, const char *dev_name,
-		  void *data, struct vfsmount *mnt)
-{
-	return get_sb_single(fs_type, flags, data, fill_super, mnt);
-}
-
-static struct file_system_type fs_type = {
-	.owner =	THIS_MODULE,
-	.name =		"securityfs",
-	.get_sb =	get_sb,
-	.kill_sb =	kill_litter_super,
-};
-
-static int create_by_name(const char *name, mode_t mode,
-			  struct dentry *parent,
-			  struct dentry **dentry)
-{
-	int error = 0;
-
-	*dentry = NULL;
-
-	/* If the parent is not specified, we create it in the root.
-	 * We need the root dentry to do this, which is in the super
-	 * block. A pointer to that is in the struct vfsmount that we
-	 * have around.
-	 */
-	if (!parent ) {
-		if (mount && mount->mnt_sb) {
-			parent = mount->mnt_sb->s_root;
-		}
-	}
-	if (!parent) {
-		pr_debug("securityfs: Ah! can not find a parent!\n");
-		return -EFAULT;
-	}
-
-	mutex_lock(&parent->d_inode->i_mutex);
-	*dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry)) {
-		if ((mode & S_IFMT) == S_IFDIR)
-			error = mkdir(parent->d_inode, *dentry, mode);
-		else
-			error = create(parent->d_inode, *dentry, mode);
-	} else
-		error = PTR_ERR(dentry);
-	mutex_unlock(&parent->d_inode->i_mutex);
-
-	return error;
-}
+static struct dentry *securityfs_root;
 
 /**
  * securityfs_create_file - create a file in the securityfs filesystem
@@ -217,32 +55,12 @@ struct dentry *securityfs_create_file(co
 				   struct dentry *parent, void *data,
 				   const struct file_operations *fops)
 {
-	struct dentry *dentry = NULL;
-	int error;
+	if (!parent)
+		parent = securityfs_root;
 
 	pr_debug("securityfs: creating file '%s'\n",name);
 
-	error = simple_pin_fs(&fs_type, &mount, &mount_count);
-	if (error) {
-		dentry = ERR_PTR(error);
-		goto exit;
-	}
-
-	error = create_by_name(name, mode, parent, &dentry);
-	if (error) {
-		dentry = ERR_PTR(error);
-		simple_release_fs(&mount, &mount_count);
-		goto exit;
-	}
-
-	if (dentry->d_inode) {
-		if (fops)
-			dentry->d_inode->i_fop = fops;
-		if (data)
-			dentry->d_inode->i_private = data;
-	}
-exit:
-	return dentry;
+	return simple_create_file(name, mode, parent, data, fops);
 }
 EXPORT_SYMBOL_GPL(securityfs_create_file);
 
@@ -291,31 +109,12 @@ EXPORT_SYMBOL_GPL(securityfs_create_dir)
  */
 void securityfs_remove(struct dentry *dentry)
 {
-	struct dentry *parent;
-
-	if (!dentry)
-		return;
-
-	parent = dentry->d_parent;
-	if (!parent || !parent->d_inode)
-		return;
-
-	mutex_lock(&parent->d_inode->i_mutex);
-	if (positive(dentry)) {
-		if (dentry->d_inode) {
-			if (S_ISDIR(dentry->d_inode->i_mode))
-				simple_rmdir(parent->d_inode, dentry);
-			else
-				simple_unlink(parent->d_inode, dentry);
-			dput(dentry);
-		}
-	}
-	mutex_unlock(&parent->d_inode->i_mutex);
-	simple_release_fs(&mount, &mount_count);
+	return simple_remove(dentry);
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
 static struct kobject *security_kobj;
+static DEFINE_SIMPLE_FS(fs_type, "securityfs", NULL, SECURITYFS_MAGIC);
 
 static int __init securityfs_init(void)
 {
@@ -325,12 +124,14 @@ static int __init securityfs_init(void)
 	if (!security_kobj)
 		return -EINVAL;
 
-	retval = register_filesystem(&fs_type);
-	if (retval)
+	retval = 0;
+	securityfs_root = simple_register_filesystem(&fs_type);
+	if (IS_ERR(securityfs_root)) {
 		kobject_put(security_kobj);
+		retval = PTR_ERR(securityfs_root);
+	}
 	return retval;
 }
 
 core_initcall(securityfs_init);
 MODULE_LICENSE("GPL");
-

-- 

