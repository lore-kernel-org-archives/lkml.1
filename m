Return-Path: <linux-kernel-owner+w=401wt.eu-S1762645AbYBSENs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762645AbYBSENs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 23:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYBSEMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 23:12:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYBSELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 23:11:54 -0500
Message-Id: <20080219040829.479870398@arndb.de>
References: <20080219040435.825494460@arndb.de>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 05:04:43 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@suse.de>,
       David Howells <dhowells@redhat.com>
Subject: [RFC 08/11] split out libfs/dentry.c from libfs.c
Content-Disposition: inline; filename=libfs-dentry.diff
X-Provags-ID: V01U2FsdGVkX19JkOZv0AhvfMYUuK46auwnRmKba3zwZMGhFCl
 FJRXaiB4KDHrf0rfobqvhCFGBrSi+SAMsjbYRL7BIvbwNa0oUb
 CPNHRIxUgPSXTZmWGVsjQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consolidate all dentry manipulation code in libfs in a single
source file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -12,188 +12,6 @@
 
 #include <asm/uaccess.h>
 
-int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		   struct kstat *stat)
-{
-	struct inode *inode = dentry->d_inode;
-	generic_fillattr(inode, stat);
-	stat->blocks = inode->i_mapping->nrpages << (PAGE_CACHE_SHIFT - 9);
-	return 0;
-}
-
-int simple_statfs(struct dentry *dentry, struct kstatfs *buf)
-{
-	buf->f_type = dentry->d_sb->s_magic;
-	buf->f_bsize = PAGE_CACHE_SIZE;
-	buf->f_namelen = NAME_MAX;
-	return 0;
-}
-
-/*
- * Retaining negative dentries for an in-memory filesystem just wastes
- * memory and lookup time: arrange for them to be deleted immediately.
- */
-static int simple_delete_dentry(struct dentry *dentry)
-{
-	return 1;
-}
-
-/*
- * Lookup the data. This is trivial - if the dentry didn't already
- * exist, we know it is negative.  Set d_op to delete negative dentries.
- */
-struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
-{
-	static struct dentry_operations simple_dentry_operations = {
-		.d_delete = simple_delete_dentry,
-	};
-
-	if (dentry->d_name.len > NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
-	dentry->d_op = &simple_dentry_operations;
-	d_add(dentry, NULL);
-	return NULL;
-}
-
-int simple_sync_file(struct file * file, struct dentry *dentry, int datasync)
-{
-	return 0;
-}
- 
-int dcache_dir_open(struct inode *inode, struct file *file)
-{
-	static struct qstr cursor_name = {.len = 1, .name = "."};
-
-	file->private_data = d_alloc(file->f_path.dentry, &cursor_name);
-
-	return file->private_data ? 0 : -ENOMEM;
-}
-
-int dcache_dir_close(struct inode *inode, struct file *file)
-{
-	dput(file->private_data);
-	return 0;
-}
-
-loff_t dcache_dir_lseek(struct file *file, loff_t offset, int origin)
-{
-	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
-	switch (origin) {
-		case 1:
-			offset += file->f_pos;
-		case 0:
-			if (offset >= 0)
-				break;
-		default:
-			mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
-			return -EINVAL;
-	}
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
-		if (file->f_pos >= 2) {
-			struct list_head *p;
-			struct dentry *cursor = file->private_data;
-			loff_t n = file->f_pos - 2;
-
-			spin_lock(&dcache_lock);
-			list_del(&cursor->d_u.d_child);
-			p = file->f_path.dentry->d_subdirs.next;
-			while (n && p != &file->f_path.dentry->d_subdirs) {
-				struct dentry *next;
-				next = list_entry(p, struct dentry, d_u.d_child);
-				if (!d_unhashed(next) && next->d_inode)
-					n--;
-				p = p->next;
-			}
-			list_add_tail(&cursor->d_u.d_child, p);
-			spin_unlock(&dcache_lock);
-		}
-	}
-	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
-	return offset;
-}
-
-/* Relationship between i_mode and the DT_xxx types */
-static inline unsigned char dt_type(struct inode *inode)
-{
-	return (inode->i_mode >> 12) & 15;
-}
-
-/*
- * Directory is locked and all positive dentries in it are safe, since
- * for ramfs-type trees they can't go away without unlink() or rmdir(),
- * both impossible due to the lock on directory.
- */
-
-int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
-{
-	struct dentry *dentry = filp->f_path.dentry;
-	struct dentry *cursor = filp->private_data;
-	struct list_head *p, *q = &cursor->d_u.d_child;
-	ino_t ino;
-	int i = filp->f_pos;
-
-	switch (i) {
-		case 0:
-			ino = dentry->d_inode->i_ino;
-			if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
-				break;
-			filp->f_pos++;
-			i++;
-			/* fallthrough */
-		case 1:
-			ino = parent_ino(dentry);
-			if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
-				break;
-			filp->f_pos++;
-			i++;
-			/* fallthrough */
-		default:
-			spin_lock(&dcache_lock);
-			if (filp->f_pos == 2)
-				list_move(q, &dentry->d_subdirs);
-
-			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
-				struct dentry *next;
-				next = list_entry(p, struct dentry, d_u.d_child);
-				if (d_unhashed(next) || !next->d_inode)
-					continue;
-
-				spin_unlock(&dcache_lock);
-				if (filldir(dirent, next->d_name.name, 
-					    next->d_name.len, filp->f_pos, 
-					    next->d_inode->i_ino, 
-					    dt_type(next->d_inode)) < 0)
-					return 0;
-				spin_lock(&dcache_lock);
-				/* next is still alive */
-				list_move(q, p);
-				p = q;
-				filp->f_pos++;
-			}
-			spin_unlock(&dcache_lock);
-	}
-	return 0;
-}
-
-ssize_t generic_read_dir(struct file *filp, char __user *buf, size_t siz, loff_t *ppos)
-{
-	return -EISDIR;
-}
-
-const struct file_operations simple_dir_operations = {
-	.open		= dcache_dir_open,
-	.release	= dcache_dir_close,
-	.llseek		= dcache_dir_lseek,
-	.read		= generic_read_dir,
-	.readdir	= dcache_readdir,
-	.fsync		= simple_sync_file,
-};
-
-const struct inode_operations simple_dir_inode_operations = {
-	.lookup		= simple_lookup,
-};
-
 static const struct super_operations simple_super_operations = {
 	.statfs		= simple_statfs,
 };
@@ -420,113 +238,14 @@ ssize_t simple_read_from_buffer(void __u
 	return count;
 }
 
-/*
- * This is what d_alloc_anon should have been.  Once the exportfs
- * argument transition has been finished I will update d_alloc_anon
- * to this prototype and this wrapper will go away.   --hch
- */
-static struct dentry *exportfs_d_alloc(struct inode *inode)
-{
-	struct dentry *dentry;
-
-	if (!inode)
-		return NULL;
-	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
-
-	dentry = d_alloc_anon(inode);
-	if (!dentry) {
-		iput(inode);
-		dentry = ERR_PTR(-ENOMEM);
-	}
-	return dentry;
-}
-
-/**
- * generic_fh_to_dentry - generic helper for the fh_to_dentry export operation
- * @sb:		filesystem to do the file handle conversion on
- * @fid:	file handle to convert
- * @fh_len:	length of the file handle in bytes
- * @fh_type:	type of file handle
- * @get_inode:	filesystem callback to retrieve inode
- *
- * This function decodes @fid as long as it has one of the well-known
- * Linux filehandle types and calls @get_inode on it to retrieve the
- * inode for the object specified in the file handle.
- */
-struct dentry *generic_fh_to_dentry(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type, struct inode *(*get_inode)
-			(struct super_block *sb, u64 ino, u32 gen))
-{
-	struct inode *inode = NULL;
-
-	if (fh_len < 2)
-		return NULL;
-
-	switch (fh_type) {
-	case FILEID_INO32_GEN:
-	case FILEID_INO32_GEN_PARENT:
-		inode = get_inode(sb, fid->i32.ino, fid->i32.gen);
-		break;
-	}
-
-	return exportfs_d_alloc(inode);
-}
-EXPORT_SYMBOL_GPL(generic_fh_to_dentry);
-
-/**
- * generic_fh_to_dentry - generic helper for the fh_to_parent export operation
- * @sb:		filesystem to do the file handle conversion on
- * @fid:	file handle to convert
- * @fh_len:	length of the file handle in bytes
- * @fh_type:	type of file handle
- * @get_inode:	filesystem callback to retrieve inode
- *
- * This function decodes @fid as long as it has one of the well-known
- * Linux filehandle types and calls @get_inode on it to retrieve the
- * inode for the _parent_ object specified in the file handle if it
- * is specified in the file handle, or NULL otherwise.
- */
-struct dentry *generic_fh_to_parent(struct super_block *sb, struct fid *fid,
-		int fh_len, int fh_type, struct inode *(*get_inode)
-			(struct super_block *sb, u64 ino, u32 gen))
-{
-	struct inode *inode = NULL;
-
-	if (fh_len <= 2)
-		return NULL;
-
-	switch (fh_type) {
-	case FILEID_INO32_GEN_PARENT:
-		inode = get_inode(sb, fid->i32.parent_ino,
-				  (fh_len > 3 ? fid->i32.parent_gen : 0));
-		break;
-	}
-
-	return exportfs_d_alloc(inode);
-}
-EXPORT_SYMBOL_GPL(generic_fh_to_parent);
-
-EXPORT_SYMBOL(dcache_dir_close);
-EXPORT_SYMBOL(dcache_dir_lseek);
-EXPORT_SYMBOL(dcache_dir_open);
-EXPORT_SYMBOL(dcache_readdir);
-EXPORT_SYMBOL(generic_read_dir);
 EXPORT_SYMBOL(get_sb_pseudo);
 EXPORT_SYMBOL(simple_write_begin);
 EXPORT_SYMBOL(simple_write_end);
-EXPORT_SYMBOL(simple_dir_inode_operations);
-EXPORT_SYMBOL(simple_dir_operations);
 EXPORT_SYMBOL(simple_empty);
-EXPORT_SYMBOL(d_alloc_name);
-EXPORT_SYMBOL(simple_getattr);
 EXPORT_SYMBOL(simple_link);
-EXPORT_SYMBOL(simple_lookup);
 EXPORT_SYMBOL(simple_prepare_write);
 EXPORT_SYMBOL(simple_readpage);
 EXPORT_SYMBOL(simple_rename);
 EXPORT_SYMBOL(simple_rmdir);
-EXPORT_SYMBOL(simple_statfs);
-EXPORT_SYMBOL(simple_sync_file);
 EXPORT_SYMBOL(simple_unlink);
 EXPORT_SYMBOL(simple_read_from_buffer);
Index: linux-2.6/fs/libfs/dentry.c
===================================================================
--- /dev/null
+++ linux-2.6/fs/libfs/dentry.c
@@ -0,0 +1,293 @@
+/*
+ *	fs/libfs/dentry.c
+ *	Library for filesystems writers -- directory operations
+ */
+
+#include <linux/libfs.h>
+#include <linux/fsnotify.h>
+#include <linux/module.h>
+#include <linux/vfs.h>
+#include <linux/mutex.h>
+#include <linux/exportfs.h>
+
+#include <asm/uaccess.h>
+
+int simple_getattr(struct vfsmount *mnt, struct dentry *dentry,
+		   struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+	generic_fillattr(inode, stat);
+	stat->blocks = inode->i_mapping->nrpages << (PAGE_CACHE_SHIFT - 9);
+	return 0;
+}
+EXPORT_SYMBOL(simple_getattr);
+
+int simple_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	buf->f_type = dentry->d_sb->s_magic;
+	buf->f_bsize = PAGE_CACHE_SIZE;
+	buf->f_namelen = NAME_MAX;
+	return 0;
+}
+EXPORT_SYMBOL(simple_statfs);
+
+/*
+ * Retaining negative dentries for an in-memory filesystem just wastes
+ * memory and lookup time: arrange for them to be deleted immediately.
+ */
+static int simple_delete_dentry(struct dentry *dentry)
+{
+	return 1;
+}
+
+/*
+ * Lookup the data. This is trivial - if the dentry didn't already
+ * exist, we know it is negative.  Set d_op to delete negative dentries.
+ */
+struct dentry *simple_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
+{
+	static struct dentry_operations simple_dentry_operations = {
+		.d_delete = simple_delete_dentry,
+	};
+
+	if (dentry->d_name.len > NAME_MAX)
+		return ERR_PTR(-ENAMETOOLONG);
+	dentry->d_op = &simple_dentry_operations;
+	d_add(dentry, NULL);
+	return NULL;
+}
+EXPORT_SYMBOL(simple_lookup);
+
+int simple_sync_file(struct file *file, struct dentry *dentry, int datasync)
+{
+	return 0;
+}
+EXPORT_SYMBOL(simple_sync_file);
+
+int dcache_dir_open(struct inode *inode, struct file *file)
+{
+	static struct qstr cursor_name = {.len = 1, .name = "."};
+
+	file->private_data = d_alloc(file->f_path.dentry, &cursor_name);
+
+	return file->private_data ? 0 : -ENOMEM;
+}
+EXPORT_SYMBOL(dcache_dir_open);
+
+int dcache_dir_close(struct inode *inode, struct file *file)
+{
+	dput(file->private_data);
+	return 0;
+}
+EXPORT_SYMBOL(dcache_dir_close);
+
+loff_t dcache_dir_lseek(struct file *file, loff_t offset, int origin)
+{
+	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
+	switch (origin) {
+	case 1:
+		offset += file->f_pos;
+	case 0:
+		if (offset >= 0)
+			break;
+	default:
+		mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
+		return -EINVAL;
+	}
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		if (file->f_pos >= 2) {
+			struct list_head *p;
+			struct dentry *cursor = file->private_data;
+			loff_t n = file->f_pos - 2;
+
+			spin_lock(&dcache_lock);
+			list_del(&cursor->d_u.d_child);
+			p = file->f_path.dentry->d_subdirs.next;
+			while (n && p != &file->f_path.dentry->d_subdirs) {
+				struct dentry *next;
+				next = list_entry(p, struct dentry, d_u.d_child);
+				if (!d_unhashed(next) && next->d_inode)
+					n--;
+				p = p->next;
+			}
+			list_add_tail(&cursor->d_u.d_child, p);
+			spin_unlock(&dcache_lock);
+		}
+	}
+	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
+	return offset;
+}
+EXPORT_SYMBOL(dcache_dir_lseek);
+
+/* Relationship between i_mode and the DT_xxx types */
+static inline unsigned char dt_type(struct inode *inode)
+{
+	return (inode->i_mode >> 12) & 15;
+}
+
+/*
+ * Directory is locked and all positive dentries in it are safe, since
+ * for ramfs-type trees they can't go away without unlink() or rmdir(),
+ * both impossible due to the lock on directory.
+ */
+
+int dcache_readdir(struct file *filp, void *dirent, filldir_t filldir)
+{
+	struct dentry *dentry = filp->f_path.dentry;
+	struct dentry *cursor = filp->private_data;
+	struct list_head *p, *q = &cursor->d_u.d_child;
+	ino_t ino;
+	int i = filp->f_pos;
+
+	switch (i) {
+	case 0:
+		ino = dentry->d_inode->i_ino;
+		if (filldir(dirent, ".", 1, i, ino, DT_DIR) < 0)
+			break;
+		filp->f_pos++;
+		i++;
+		/* fallthrough */
+	case 1:
+		ino = parent_ino(dentry);
+		if (filldir(dirent, "..", 2, i, ino, DT_DIR) < 0)
+			break;
+		filp->f_pos++;
+		i++;
+		/* fallthrough */
+	default:
+		spin_lock(&dcache_lock);
+		if (filp->f_pos == 2)
+			list_move(q, &dentry->d_subdirs);
+
+		for (p = q->next; p != &dentry->d_subdirs; p = p->next) {
+			struct dentry *next;
+			next = list_entry(p, struct dentry, d_u.d_child);
+			if (d_unhashed(next) || !next->d_inode)
+				continue;
+
+			spin_unlock(&dcache_lock);
+			if (filldir(dirent, next->d_name.name,
+				    next->d_name.len, filp->f_pos,
+				    next->d_inode->i_ino,
+				    dt_type(next->d_inode)) < 0)
+				return 0;
+			spin_lock(&dcache_lock);
+			/* next is still alive */
+			list_move(q, p);
+			p = q;
+			filp->f_pos++;
+		}
+		spin_unlock(&dcache_lock);
+	}
+	return 0;
+}
+EXPORT_SYMBOL(dcache_readdir);
+
+ssize_t generic_read_dir(struct file *filp, char __user *buf, size_t siz, loff_t *ppos)
+{
+	return -EISDIR;
+}
+EXPORT_SYMBOL(generic_read_dir);
+
+const struct file_operations simple_dir_operations = {
+	.open		= dcache_dir_open,
+	.release	= dcache_dir_close,
+	.llseek		= dcache_dir_lseek,
+	.read		= generic_read_dir,
+	.readdir	= dcache_readdir,
+	.fsync		= simple_sync_file,
+};
+EXPORT_SYMBOL(simple_dir_operations);
+
+const struct inode_operations simple_dir_inode_operations = {
+	.lookup		= simple_lookup,
+};
+EXPORT_SYMBOL(simple_dir_inode_operations);
+
+/*
+ * This is what d_alloc_anon should have been.  Once the exportfs
+ * argument transition has been finished I will update d_alloc_anon
+ * to this prototype and this wrapper will go away.   --hch
+ */
+static struct dentry *exportfs_d_alloc(struct inode *inode)
+{
+	struct dentry *dentry;
+
+	if (!inode)
+		return NULL;
+	if (IS_ERR(inode))
+		return ERR_PTR(PTR_ERR(inode));
+
+	dentry = d_alloc_anon(inode);
+	if (!dentry) {
+		iput(inode);
+		dentry = ERR_PTR(-ENOMEM);
+	}
+	return dentry;
+}
+
+/**
+ * generic_fh_to_dentry - generic helper for the fh_to_dentry export operation
+ * @sb:		filesystem to do the file handle conversion on
+ * @fid:	file handle to convert
+ * @fh_len:	length of the file handle in bytes
+ * @fh_type:	type of file handle
+ * @get_inode:	filesystem callback to retrieve inode
+ *
+ * This function decodes @fid as long as it has one of the well-known
+ * Linux filehandle types and calls @get_inode on it to retrieve the
+ * inode for the object specified in the file handle.
+ */
+struct dentry *generic_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type, struct inode *(*get_inode)
+			(struct super_block *sb, u64 ino, u32 gen))
+{
+	struct inode *inode = NULL;
+
+	if (fh_len < 2)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN:
+	case FILEID_INO32_GEN_PARENT:
+		inode = get_inode(sb, fid->i32.ino, fid->i32.gen);
+		break;
+	}
+
+	return exportfs_d_alloc(inode);
+}
+EXPORT_SYMBOL_GPL(generic_fh_to_dentry);
+
+/**
+ * generic_fh_to_dentry - generic helper for the fh_to_parent export operation
+ * @sb:		filesystem to do the file handle conversion on
+ * @fid:	file handle to convert
+ * @fh_len:	length of the file handle in bytes
+ * @fh_type:	type of file handle
+ * @get_inode:	filesystem callback to retrieve inode
+ *
+ * This function decodes @fid as long as it has one of the well-known
+ * Linux filehandle types and calls @get_inode on it to retrieve the
+ * inode for the _parent_ object specified in the file handle if it
+ * is specified in the file handle, or NULL otherwise.
+ */
+struct dentry *generic_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type, struct inode *(*get_inode)
+			(struct super_block *sb, u64 ino, u32 gen))
+{
+	struct inode *inode = NULL;
+
+	if (fh_len <= 2)
+		return NULL;
+
+	switch (fh_type) {
+	case FILEID_INO32_GEN_PARENT:
+		inode = get_inode(sb, fid->i32.parent_ino,
+				  (fh_len > 3 ? fid->i32.parent_gen : 0));
+		break;
+	}
+
+	return exportfs_d_alloc(inode);
+}
+EXPORT_SYMBOL_GPL(generic_fh_to_parent);
Index: linux-2.6/fs/libfs/Makefile
===================================================================
--- linux-2.6.orig/fs/libfs/Makefile
+++ linux-2.6/fs/libfs/Makefile
@@ -1,3 +1,3 @@
 libfs-y += file.o
 
-obj-$(CONFIG_LIBFS) += libfs.o inode.o super.o
+obj-$(CONFIG_LIBFS) += libfs.o inode.o super.o dentry.o

-- 

