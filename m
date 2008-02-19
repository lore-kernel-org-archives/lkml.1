Return-Path: <linux-kernel-owner+w=401wt.eu-S1761861AbYBSENP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761861AbYBSENP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYBSELz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:11:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:55962 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYBSELt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:11:49 -0500
Message-Id: <20080219040829.085901516@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:40 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 05/11] slim down usbfs
Content-Disposition: inline; filename=slim-down-usbfs.diff
X-Provags-ID: V01U2FsdGVkX19xfs2bFRMK4PDmFw/0cQiFIVbqeNHQDIbWZp6
 9y5jrBGszEnur0OMKuHgly6BHPt8rHa5v7+qhCGk+tiQ5jlb02
 1ZfxJv1NfnmtnifdLcCAQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Half of the usbfs code is the same as debugfs, so we can
replace it now with calls to the generic libfs versions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c
+++ linux-2.6/drivers/usb/core/inode.c
@@ -47,11 +47,10 @@
 #define USBFS_DEFAULT_BUSMODE (S_IXUGO | S_IRUGO)
 #define USBFS_DEFAULT_LISTMODE S_IRUGO
 
-static struct super_operations usbfs_ops;
-static const struct file_operations default_file_operations;
-static struct vfsmount *usbfs_mount;
-static int usbfs_mount_count;	/* = 0 */
-static int ignore_mount = 0;
+static DEFINE_SIMPLE_FS(usb_fs_type, "usbfs", NULL, USBDEVICE_SUPER_MAGIC);
+static struct dentry *usbfs_root;
+
+static int ignore_mount = 1;
 
 static struct dentry *devices_usbfs_dentry;
 static int num_buses;	/* = 0 */
@@ -263,186 +262,11 @@ static int remount(struct super_block *s
 		return -EINVAL;
 	}
 
-	if (usbfs_mount && usbfs_mount->mnt_sb)
-		update_sb(usbfs_mount->mnt_sb);
-
-	return 0;
-}
-
-static struct inode *usbfs_get_inode (struct super_block *sb, int mode, dev_t dev)
-{
-	struct inode *inode = new_inode(sb);
-
-	if (inode) {
-		inode->i_mode = mode;
-		inode->i_uid = current->fsuid;
-		inode->i_gid = current->fsgid;
-		inode->i_blocks = 0;
-		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		switch (mode & S_IFMT) {
-		default:
-			init_special_inode(inode, mode, dev);
-			break;
-		case S_IFREG:
-			inode->i_fop = &default_file_operations;
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
-static int usbfs_mknod (struct inode *dir, struct dentry *dentry, int mode,
-			dev_t dev)
-{
-	struct inode *inode = usbfs_get_inode(dir->i_sb, mode, dev);
-	int error = -EPERM;
-
-	if (dentry->d_inode)
-		return -EEXIST;
-
-	if (inode) {
-		d_instantiate(dentry, inode);
-		dget(dentry);
-		error = 0;
-	}
-	return error;
-}
-
-static int usbfs_mkdir (struct inode *dir, struct dentry *dentry, int mode)
-{
-	int res;
-
-	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
-	res = usbfs_mknod (dir, dentry, mode, 0);
-	if (!res)
-		inc_nlink(dir);
-	return res;
-}
-
-static int usbfs_create (struct inode *dir, struct dentry *dentry, int mode)
-{
-	mode = (mode & S_IALLUGO) | S_IFREG;
-	return usbfs_mknod (dir, dentry, mode, 0);
-}
-
-static inline int usbfs_positive (struct dentry *dentry)
-{
-	return dentry->d_inode && !d_unhashed(dentry);
-}
-
-static int usbfs_empty (struct dentry *dentry)
-{
-	struct list_head *list;
-
-	spin_lock(&dcache_lock);
-
-	list_for_each(list, &dentry->d_subdirs) {
-		struct dentry *de = list_entry(list, struct dentry, d_u.d_child);
-		if (usbfs_positive(de)) {
-			spin_unlock(&dcache_lock);
-			return 0;
-		}
-	}
-
-	spin_unlock(&dcache_lock);
-	return 1;
-}
-
-static int usbfs_unlink (struct inode *dir, struct dentry *dentry)
-{
-	struct inode *inode = dentry->d_inode;
-	mutex_lock(&inode->i_mutex);
-	drop_nlink(dentry->d_inode);
-	dput(dentry);
-	mutex_unlock(&inode->i_mutex);
-	d_delete(dentry);
-	return 0;
-}
-
-static int usbfs_rmdir(struct inode *dir, struct dentry *dentry)
-{
-	int error = -ENOTEMPTY;
-	struct inode * inode = dentry->d_inode;
-
-	mutex_lock(&inode->i_mutex);
-	dentry_unhash(dentry);
-	if (usbfs_empty(dentry)) {
-		drop_nlink(dentry->d_inode);
-		drop_nlink(dentry->d_inode);
-		dput(dentry);
-		inode->i_flags |= S_DEAD;
-		drop_nlink(dir);
-		error = 0;
-	}
-	mutex_unlock(&inode->i_mutex);
-	if (!error)
-		d_delete(dentry);
-	dput(dentry);
-	return error;
-}
-
-
-/* default file operations */
-static ssize_t default_read_file (struct file *file, char __user *buf,
-				  size_t count, loff_t *ppos)
-{
-	return 0;
-}
-
-static ssize_t default_write_file (struct file *file, const char __user *buf,
-				   size_t count, loff_t *ppos)
-{
-	return count;
-}
-
-static loff_t default_file_lseek (struct file *file, loff_t offset, int orig)
-{
-	loff_t retval = -EINVAL;
-
-	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
-	switch(orig) {
-	case 0:
-		if (offset > 0) {
-			file->f_pos = offset;
-			retval = file->f_pos;
-		} 
-		break;
-	case 1:
-		if ((offset + file->f_pos) > 0) {
-			file->f_pos += offset;
-			retval = file->f_pos;
-		} 
-		break;
-	default:
-		break;
-	}
-	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
-	return retval;
-}
-
-static int default_open (struct inode *inode, struct file *file)
-{
-	if (inode->i_private)
-		file->private_data = inode->i_private;
+	update_sb(usb_fs_type.mount->mnt_sb);
 
 	return 0;
 }
 
-static const struct file_operations default_file_operations = {
-	.read =		default_read_file,
-	.write =	default_write_file,
-	.open =		default_open,
-	.llseek =	default_file_lseek,
-};
-
 static struct super_operations usbfs_ops = {
 	.statfs =	simple_statfs,
 	.drop_inode =	generic_delete_inode,
@@ -450,145 +274,32 @@ static struct super_operations usbfs_ops
 	.show_options = usbfs_show_options,
 };
 
-static int usbfs_fill_super(struct super_block *sb, void *data, int silent)
-{
-	struct inode *inode;
-	struct dentry *root;
-
-	sb->s_blocksize = PAGE_CACHE_SIZE;
-	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
-	sb->s_magic = USBDEVICE_SUPER_MAGIC;
-	sb->s_op = &usbfs_ops;
-	sb->s_time_gran = 1;
-	inode = usbfs_get_inode(sb, S_IFDIR | 0755, 0);
-
-	if (!inode) {
-		dbg("%s: could not get inode!",__FUNCTION__);
-		return -ENOMEM;
-	}
-
-	root = d_alloc_root(inode);
-	if (!root) {
-		dbg("%s: could not get root dentry!",__FUNCTION__);
-		iput(inode);
-		return -ENOMEM;
-	}
-	sb->s_root = root;
-	return 0;
-}
-
-/*
- * fs_create_by_name - create a file, given a name
- * @name:	name of file
- * @mode:	type of file
- * @parent:	dentry of directory to create it in
- * @dentry:	resulting dentry of file
- *
- * This function handles both regular files and directories.
- */
-static int fs_create_by_name (const char *name, mode_t mode,
-			      struct dentry *parent, struct dentry **dentry)
-{
-	int error = 0;
-
-	/* If the parent is not specified, we create it in the root.
-	 * We need the root dentry to do this, which is in the super 
-	 * block. A pointer to that is in the struct vfsmount that we
-	 * have around.
-	 */
-	if (!parent ) {
-		if (usbfs_mount && usbfs_mount->mnt_sb) {
-			parent = usbfs_mount->mnt_sb->s_root;
-		}
-	}
-
-	if (!parent) {
-		dbg("Ah! can not find a parent!");
-		return -EFAULT;
-	}
-
-	*dentry = NULL;
-	mutex_lock(&parent->d_inode->i_mutex);
-	*dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry)) {
-		if ((mode & S_IFMT) == S_IFDIR)
-			error = usbfs_mkdir (parent->d_inode, *dentry, mode);
-		else 
-			error = usbfs_create (parent->d_inode, *dentry, mode);
-	} else
-		error = PTR_ERR(dentry);
-	mutex_unlock(&parent->d_inode->i_mutex);
-
-	return error;
-}
-
 static struct dentry *fs_create_file (const char *name, mode_t mode,
 				      struct dentry *parent, void *data,
 				      const struct file_operations *fops,
 				      uid_t uid, gid_t gid)
 {
 	struct dentry *dentry;
-	int error;
 
 	dbg("creating file '%s'",name);
 
-	error = fs_create_by_name (name, mode, parent, &dentry);
-	if (error) {
-		dentry = NULL;
-	} else {
-		if (dentry->d_inode) {
-			if (data)
-				dentry->d_inode->i_private = data;
-			if (fops)
-				dentry->d_inode->i_fop = fops;
-			dentry->d_inode->i_uid = uid;
-			dentry->d_inode->i_gid = gid;
-		}
+	/* If the parent is not specified, we create it in the root.  */
+	if (!parent)
+		parent = usbfs_root;
+
+	dentry = simple_create_file(name, mode, parent, data, fops);
+	if (dentry && dentry->d_inode) {
+		dentry->d_inode->i_uid = uid;
+		dentry->d_inode->i_gid = gid;
 	}
 
 	return dentry;
 }
 
-static void fs_remove_file (struct dentry *dentry)
-{
-	struct dentry *parent = dentry->d_parent;
-	
-	if (!parent || !parent->d_inode)
-		return;
-
-	mutex_lock_nested(&parent->d_inode->i_mutex, I_MUTEX_PARENT);
-	if (usbfs_positive(dentry)) {
-		if (dentry->d_inode) {
-			if (S_ISDIR(dentry->d_inode->i_mode))
-				usbfs_rmdir(parent->d_inode, dentry);
-			else
-				usbfs_unlink(parent->d_inode, dentry);
-		dput(dentry);
-		}
-	}
-	mutex_unlock(&parent->d_inode->i_mutex);
-}
-
-/* --------------------------------------------------------------------- */
-
-static int usb_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	return get_sb_single(fs_type, flags, data, usbfs_fill_super, mnt);
-}
-
-static struct file_system_type usb_fs_type = {
-	.owner =	THIS_MODULE,
-	.name =		"usbfs",
-	.get_sb =	usb_get_sb,
-	.kill_sb =	kill_litter_super,
-};
-
 /* --------------------------------------------------------------------- */
 
 static int create_special_files (void)
 {
-	struct dentry *parent;
 	int retval;
 
 	/* the simple_pin_fs calls will call remount with no options
@@ -596,8 +307,7 @@ static int create_special_files (void)
 	 */
 	ignore_mount = 1;
 
-	/* create the devices special file */
-	retval = simple_pin_fs(&usb_fs_type, &usbfs_mount, &usbfs_mount_count);
+	retval = simple_pin_fs(&usb_fs_type.fstype, &usb_fs_type.mount, &usb_fs_type.mount_count);
 	if (retval) {
 		err ("Unable to get usbfs mount");
 		goto exit;
@@ -605,9 +315,8 @@ static int create_special_files (void)
 
 	ignore_mount = 0;
 
-	parent = usbfs_mount->mnt_sb->s_root;
 	devices_usbfs_dentry = fs_create_file ("devices",
-					       listmode | S_IFREG, parent,
+					       listmode | S_IFREG, usbfs_root,
 					       NULL, &usbfs_devices_fops,
 					       listuid, listgid);
 	if (devices_usbfs_dentry == NULL) {
@@ -617,9 +326,9 @@ static int create_special_files (void)
 	}
 
 	goto exit;
-	
+
 error_clean_mounts:
-	simple_release_fs(&usbfs_mount, &usbfs_mount_count);
+	simple_release_fs(&usb_fs_type.mount, &usb_fs_type.mount_count);
 exit:
 	return retval;
 }
@@ -627,9 +336,8 @@ exit:
 static void remove_special_files (void)
 {
 	if (devices_usbfs_dentry)
-		fs_remove_file (devices_usbfs_dentry);
+		simple_remove(devices_usbfs_dentry);
 	devices_usbfs_dentry = NULL;
-	simple_release_fs(&usbfs_mount, &usbfs_mount_count);
 }
 
 void usbfs_update_special (void)
@@ -659,7 +367,7 @@ static void usbfs_add_bus(struct usb_bus
 
 	sprintf (name, "%03d", bus->busnum);
 
-	parent = usbfs_mount->mnt_sb->s_root;
+	parent = usbfs_root;
 	bus->usbfs_dentry = fs_create_file (name, busmode | S_IFDIR, parent,
 					    bus, NULL, busuid, busgid);
 	if (bus->usbfs_dentry == NULL) {
@@ -671,7 +379,7 @@ static void usbfs_add_bus(struct usb_bus
 static void usbfs_remove_bus(struct usb_bus *bus)
 {
 	if (bus->usbfs_dentry) {
-		fs_remove_file (bus->usbfs_dentry);
+		simple_remove(bus->usbfs_dentry);
 		bus->usbfs_dentry = NULL;
 	}
 
@@ -716,7 +424,7 @@ static void usbfs_remove_device(struct u
 	struct siginfo sinfo;
 
 	if (dev->usbfs_dentry) {
-		fs_remove_file (dev->usbfs_dentry);
+		simple_remove(dev->usbfs_dentry);
 		dev->usbfs_dentry = NULL;
 	}
 	while (!list_empty(&dev->filelist)) {
@@ -764,11 +472,11 @@ static struct proc_dir_entry *usbdir = N
 
 int __init usbfs_init(void)
 {
-	int retval;
-
-	retval = register_filesystem(&usb_fs_type);
-	if (retval)
-		return retval;
+	usb_fs_type.super_ops = &usbfs_ops;
+	usbfs_root = simple_register_filesystem(&usb_fs_type);
+	if (IS_ERR(usbfs_root))
+		return PTR_ERR(usbfs_root);
+	ignore_mount = 0;
 
 	usb_register_notify(&usbfs_nb);
 
@@ -781,7 +489,7 @@ int __init usbfs_init(void)
 void usbfs_cleanup(void)
 {
 	usb_unregister_notify(&usbfs_nb);
-	unregister_filesystem(&usb_fs_type);
+	simple_unregister_filesystem(&usb_fs_type);
 	if (usbdir)
 		remove_proc_entry("usb", proc_bus);
 }

-- 

