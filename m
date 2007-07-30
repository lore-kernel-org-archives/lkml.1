Return-Path: <linux-kernel-owner+w=401wt.eu-S939317AbXG3QR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939317AbXG3QR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938340AbXG3QOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:40567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765189AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161325.004086646@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:43 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 20/26] union-mount: Simple union-mount readdir implementation
Content-Disposition: inline; filename=um/union-mount-readdir.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a very simple union mount readdir implementation. It modifies the
readdir routine to merge the entries of union mounted directories and
eliminate duplicates while walking the union stack.

  FIXME:
  This patch needs to be reworked! At the moment this only works for ext2 and
  tmpfs. All kind of index directories that return d_off > i_size don't work
  with this.

The directory entries are read starting from the top layer and they are
maintained in a cache. Subsequently when the entries from the bottom layers
of the union stack are read they are checked for duplicates (in the cache)
before being passed out to the user space. There can be multiple calls
to readdir/getdents routines for reading the entries of a single directory.
But union directory cache is not maitained across these calls. Instead
for every call, the previously read entries are re-read into the cache
and newly read entires are compared against these for duplicates before
being they are returned to user space.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/readdir.c          |   11 -
 fs/union.c            |  336 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/union.h |   25 +++
 3 files changed, 364 insertions(+), 8 deletions(-)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -16,13 +16,14 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
+#include <linux/union.h>
 
 #include <asm/uaccess.h>
 
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int res = -ENOTDIR;
+
 	if (!file->f_op || !file->f_op->readdir)
 		goto out;
 
@@ -30,13 +31,7 @@ int vfs_readdir(struct file *file, filld
 	if (res)
 		goto out;
 
-	mutex_lock(&inode->i_mutex);
-	res = -ENOENT;
-	if (!IS_DEADDIR(inode)) {
-		res = file->f_op->readdir(file, buf, filler);
-		file_accessed(file);
-	}
-	mutex_unlock(&inode->i_mutex);
+	res = do_readdir(file, buf, filler);
 out:
 	return res;
 }
--- a/fs/union.c
+++ b/fs/union.c
@@ -18,6 +18,8 @@
 #include <linux/hash.h>
 #include <linux/fs.h>
 #include <linux/union.h>
+#include <linux/module.h>
+#include <linux/file.h>
 
 /*
  * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
@@ -462,3 +464,337 @@ void detach_mnt_union(struct vfsmount *m
 	union_put(um);
 	return;
 }
+
+
+/*
+ * Union mounts support for readdir.
+ */
+
+/* This is a copy from fs/readdir.c */
+struct getdents_callback {
+	struct linux_dirent __user *current_dir;
+	struct linux_dirent __user *previous;
+	int count;
+	int error;
+};
+
+/* The readdir union cache object */
+struct union_cache_entry {
+	struct list_head list;
+	struct qstr name;
+};
+
+static int union_cache_add_entry(struct list_head *list,
+				 const char *name, int namelen)
+{
+	struct union_cache_entry *this;
+	char *tmp_name;
+
+	this = kmalloc(sizeof(*this), GFP_KERNEL);
+	if (!this) {
+		printk(KERN_CRIT
+		       "union_cache_add_entry(): out of kernel memory\n");
+		return -ENOMEM;
+	}
+
+	tmp_name = kmalloc(namelen + 1, GFP_KERNEL);
+	if (!tmp_name) {
+		printk(KERN_CRIT
+		       "union_cache_add_entry(): out of kernel memory\n");
+		kfree(this);
+		return -ENOMEM;
+	}
+
+	this->name.name = tmp_name;
+	this->name.len = namelen;
+	this->name.hash = 0;
+	memcpy(tmp_name, name, namelen);
+	tmp_name[namelen] = 0;
+	INIT_LIST_HEAD(&this->list);
+	list_add(&this->list, list);
+	return 0;
+}
+
+static void union_cache_free(struct list_head *uc_list)
+{
+	struct list_head *p;
+	struct list_head *ptmp;
+	int count = 0;
+
+	list_for_each_safe(p, ptmp, uc_list) {
+		struct union_cache_entry *this;
+
+		this = list_entry(p, struct union_cache_entry, list);
+		list_del_init(&this->list);
+		kfree(this->name.name);
+		kfree(this);
+		count++;
+	}
+	return;
+}
+
+static int union_cache_find_entry(struct list_head *uc_list,
+				  const char *name, int namelen)
+{
+	struct union_cache_entry *p;
+	int ret = 0;
+
+	list_for_each_entry(p, uc_list, list) {
+		if (p->name.len != namelen)
+			continue;
+		if (strncmp(p->name.name, name, namelen) == 0) {
+			ret = 1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * There are four filldir() wrapper necessary for the union mount readdir
+ * implementation:
+ *
+ * - filldir_topmost(): fills the union's readdir cache and the user space
+ *			buffer. This is only used for the topmost directory
+ *			in the union stack.
+ * - filldir_topmost_cacheonly(): only fills the union's readdir cache.
+ *			This is only used for the topmost directory in the
+ *			union stack.
+ * - filldir_overlaid(): fills the union's readdir cache and the user space
+ *			buffer. This is only used for directories on the
+ *			stack's lower layers.
+ * - filldir_overlaid_cacheonly(): only fills the union's readdir cache.
+ *			This is only used for directories on the stack's
+ *			lower layers.
+ */
+
+struct union_cache_callback {
+	struct getdents_callback *buf;	/* original getdents_callback */
+	struct list_head list;		/* list of union cache entries */
+	filldir_t filler;		/* the filldir() we should call */
+	loff_t offset;			/* base offset of our dirents */
+	loff_t count;			/* maximum number of bytes to "read" */
+};
+
+static int filldir_topmost(void *buf, const char *name, int namlen,
+			   loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return cb->filler(cb->buf, name, namlen, cb->offset + offset, ino,
+			  d_type);
+}
+
+static int filldir_topmost_cacheonly(void *buf, const char *name, int namlen,
+				     loff_t offset, u64 ino,
+				     unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	if (offset > cb->count)
+		return -EINVAL;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return 0;
+}
+
+static int filldir_overlaid(void *buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	if (union_cache_find_entry(&cb->list, name, namlen))
+		return 0;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return cb->filler(cb->buf, name, namlen, cb->offset + offset, ino,
+			  d_type);
+}
+
+static int filldir_overlaid_cacheonly(void *buf, const char *name, int namlen,
+				      loff_t offset, u64 ino,
+				      unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	if (offset > cb->count)
+		return -EINVAL;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	if (union_cache_find_entry(&cb->list, name, namlen))
+		return 0;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return 0;
+}
+
+/*
+ * readdir_union_cache - A helper to fill the readdir cache
+ */
+static int readdir_union_cache(struct file *file, void *_buf, filldir_t filler)
+{
+	struct union_cache_callback *cb = _buf;
+	int old_count;
+	loff_t old_pos;
+	int res;
+
+	old_count = cb->count;
+	cb->count = ((file->f_pos > i_size_read(file->f_path.dentry->d_inode)) ?
+		      i_size_read(file->f_path.dentry->d_inode) :
+		      file->f_pos) & INT_MAX;
+	old_pos = file->f_pos;
+	file->f_pos = 0;
+	res = file->f_op->readdir(file, _buf, filler);
+	file->f_pos = old_pos;
+	cb->count = old_count;
+	return res;
+}
+
+/*
+ * readdir_union - A wrapper around ->readdir()
+ *
+ * This is a wrapper around the filesystems readdir(), which is walking
+ * the union stack and calls ->readdir() for every directory in the stack.
+ * The directory entries are read into the union mounts readdir cache to
+ * support whiteout's and duplicate removal.
+ */
+int readdir_union(struct file *file, void *buf, filldir_t filler)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct union_cache_callback cb;
+	struct path path;
+	loff_t offset = 0;
+	int res;
+
+	mutex_lock(&inode->i_mutex);
+	if (IS_DEADDIR(inode)) {
+		mutex_unlock(&inode->i_mutex);
+		return -ENOENT;
+	}
+
+	INIT_LIST_HEAD(&cb.list);
+	cb.buf = buf;
+	cb.filler = filler;
+	cb.offset = 0;
+	offset = i_size_read(file->f_path.dentry->d_inode);
+	cb.count = file->f_pos;
+
+	if (file->f_pos > 0) {
+		/*
+		 * We have already read from this dir, lets read that stuff to
+		 * our union-cache only
+		 */
+		res = readdir_union_cache(file, &cb,
+					  filldir_topmost_cacheonly);
+		if (res) {
+			mutex_unlock(&inode->i_mutex);
+			goto out;
+		}
+	}
+
+	if (file->f_pos < offset) {
+		res = file->f_op->readdir(file, &cb, filldir_topmost);
+		file_accessed(file);
+		if (res) {
+			mutex_unlock(&inode->i_mutex);
+			goto out;
+		}
+		/* We read until EOF of this directory */
+		file->f_pos = offset;
+	}
+
+	mutex_unlock(&inode->i_mutex);
+
+	path = file->f_path;
+	pathget(&path);
+	while (follow_union_down(&path.mnt, &path.dentry)) {
+		struct file *ftmp;
+
+		/* get path reference for filep */
+		pathget(&path);
+		ftmp = dentry_open(path.dentry, path.mnt,
+				   ((file->f_flags & ~(O_ACCMODE)) |
+				    O_RDONLY | O_DIRECTORY | O_NOATIME));
+		if (IS_ERR(ftmp)) {
+			res = PTR_ERR(ftmp);
+			break;
+		}
+
+		inode = path.dentry->d_inode;
+		mutex_lock(&inode->i_mutex);
+
+		/* rearrange the file position */
+		cb.offset += offset;
+		offset = i_size_read(inode);
+		ftmp->f_pos = file->f_pos - cb.offset;
+		cb.count = ftmp->f_pos;
+		if (ftmp->f_pos < 0) {
+			mutex_unlock(&inode->i_mutex);
+			fput(ftmp);
+			break;
+		}
+
+		res = -ENOENT;
+		if (IS_DEADDIR(inode))
+			goto out_fput;
+
+		if (ftmp->f_pos > 0) {
+			/*
+			 * We have already read from this dir, lets read that
+			 * stuff to our union-cache only
+			 */
+			res = readdir_union_cache(ftmp, &cb,
+						  filldir_overlaid_cacheonly);
+			if (res)
+				goto out_fput;
+		}
+
+		if (ftmp->f_pos < offset) {
+			res = ftmp->f_op->readdir(ftmp, &cb, filldir_overlaid);
+			file_accessed(ftmp);
+			if (res)
+				file->f_pos += ftmp->f_pos;
+			else
+				/*
+				 * We read until EOF of this directory, so lets
+				 * advance the f_pos by the maximum offset
+				 * (i_size) of this directory
+				 */
+				file->f_pos += offset;
+		}
+
+		file_accessed(ftmp);
+
+out_fput:
+		mutex_unlock(&inode->i_mutex);
+		fput(ftmp);
+
+		if (res)
+			break;
+	}
+	pathput(&path);
+out:
+	union_cache_free(&cb.list);
+	return res;
+}
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -53,6 +53,7 @@ extern void __shrink_d_unions(struct den
 extern int attach_mnt_union(struct vfsmount *, struct vfsmount *,
 			    struct dentry *);
 extern void detach_mnt_union(struct vfsmount *);
+extern int readdir_union(struct file *, void *, filldir_t);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -69,5 +70,29 @@ extern void detach_mnt_union(struct vfsm
 #define detach_mnt_union(x)		do { } while (0)
 
 #endif	/* CONFIG_UNION_MOUNT */
+
+static inline int do_readdir(struct file *file, void *buf, filldir_t filler)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	int res;
+
+#ifdef CONFIG_UNION_MOUNT
+	if (IS_MNT_UNION(file->f_path.mnt))
+		res = readdir_union(file, buf, filler);
+	else
+#endif
+	{
+		mutex_lock(&inode->i_mutex);
+		res = -ENOENT;
+		if (!IS_DEADDIR(inode)) {
+			res = file->f_op->readdir(file, buf, filler);
+			file_accessed(file);
+		}
+		mutex_unlock(&inode->i_mutex);
+	}
+
+	return res;
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* __LINUX_UNION_H */

-- 

