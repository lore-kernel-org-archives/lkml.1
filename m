Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbXLEOjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbXLEOjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXLEOiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:38:50 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48127 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbXLEOis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:38:48 -0500
Date: Wed, 5 Dec 2007 20:08:30 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [RFC PATCH 1/5] Remove existing directory listing implementation
Message-ID: <20071205143830.GD2471@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20071205143718.GC2471@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205143718.GC2471@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the existing readdir implementation.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/readdir.c          |   10 +
 fs/union.c            |  333 --------------------------------------------------
 include/linux/union.h |   23 ---
 3 files changed, 8 insertions(+), 358 deletions(-)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -16,12 +16,12 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
-#include <linux/union.h>
 
 #include <asm/uaccess.h>
 
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int res = -ENOTDIR;
 
 	if (!file->f_op || !file->f_op->readdir)
@@ -31,7 +31,13 @@ int vfs_readdir(struct file *file, filld
 	if (res)
 		goto out;
 
-	res = do_readdir(file, buf, filler);
+	mutex_lock(&inode->i_mutex);
+	res = -ENOENT;
+	if (!IS_DEADDIR(inode)) {
+		res = file->f_op->readdir(file, buf, filler);
+		file_accessed(file);
+	}
+	mutex_unlock(&inode->i_mutex);
 out:
 	return res;
 }
--- a/fs/union.c
+++ b/fs/union.c
@@ -516,339 +516,6 @@ int last_union_is_root(struct path *path
 }
 
 /*
- * Union mounts support for readdir.
- */
-
-/* This is a copy from fs/readdir.c */
-struct getdents_callback {
-	struct linux_dirent __user *current_dir;
-	struct linux_dirent __user *previous;
-	int count;
-	int error;
-};
-
-/* The readdir union cache object */
-struct union_cache_entry {
-	struct list_head list;
-	struct qstr name;
-};
-
-static int union_cache_add_entry(struct list_head *list,
-				 const char *name, int namelen)
-{
-	struct union_cache_entry *this;
-	char *tmp_name;
-
-	this = kmalloc(sizeof(*this), GFP_KERNEL);
-	if (!this) {
-		printk(KERN_CRIT
-		       "union_cache_add_entry(): out of kernel memory\n");
-		return -ENOMEM;
-	}
-
-	tmp_name = kmalloc(namelen + 1, GFP_KERNEL);
-	if (!tmp_name) {
-		printk(KERN_CRIT
-		       "union_cache_add_entry(): out of kernel memory\n");
-		kfree(this);
-		return -ENOMEM;
-	}
-
-	this->name.name = tmp_name;
-	this->name.len = namelen;
-	this->name.hash = 0;
-	memcpy(tmp_name, name, namelen);
-	tmp_name[namelen] = 0;
-	INIT_LIST_HEAD(&this->list);
-	list_add(&this->list, list);
-	return 0;
-}
-
-static void union_cache_free(struct list_head *uc_list)
-{
-	struct list_head *p;
-	struct list_head *ptmp;
-	int count = 0;
-
-	list_for_each_safe(p, ptmp, uc_list) {
-		struct union_cache_entry *this;
-
-		this = list_entry(p, struct union_cache_entry, list);
-		list_del_init(&this->list);
-		kfree(this->name.name);
-		kfree(this);
-		count++;
-	}
-	return;
-}
-
-static int union_cache_find_entry(struct list_head *uc_list,
-				  const char *name, int namelen)
-{
-	struct union_cache_entry *p;
-	int ret = 0;
-
-	list_for_each_entry(p, uc_list, list) {
-		if (p->name.len != namelen)
-			continue;
-		if (strncmp(p->name.name, name, namelen) == 0) {
-			ret = 1;
-			break;
-		}
-	}
-
-	return ret;
-}
-
-/*
- * There are four filldir() wrapper necessary for the union mount readdir
- * implementation:
- *
- * - filldir_topmost(): fills the union's readdir cache and the user space
- *			buffer. This is only used for the topmost directory
- *			in the union stack.
- * - filldir_topmost_cacheonly(): only fills the union's readdir cache.
- *			This is only used for the topmost directory in the
- *			union stack.
- * - filldir_overlaid(): fills the union's readdir cache and the user space
- *			buffer. This is only used for directories on the
- *			stack's lower layers.
- * - filldir_overlaid_cacheonly(): only fills the union's readdir cache.
- *			This is only used for directories on the stack's
- *			lower layers.
- */
-
-struct union_cache_callback {
-	struct getdents_callback *buf;	/* original getdents_callback */
-	struct list_head list;		/* list of union cache entries */
-	filldir_t filler;		/* the filldir() we should call */
-	loff_t offset;			/* base offset of our dirents */
-	loff_t count;			/* maximum number of bytes to "read" */
-};
-
-static int filldir_topmost(void *buf, const char *name, int namlen,
-			   loff_t offset, u64 ino, unsigned int d_type)
-{
-	struct union_cache_callback *cb = buf;
-
-	union_cache_add_entry(&cb->list, name, namlen);
-	return cb->filler(cb->buf, name, namlen, cb->offset + offset, ino,
-			  d_type);
-}
-
-static int filldir_topmost_cacheonly(void *buf, const char *name, int namlen,
-				     loff_t offset, u64 ino,
-				     unsigned int d_type)
-{
-	struct union_cache_callback *cb = buf;
-
-	if (offset > cb->count)
-		return -EINVAL;
-
-	union_cache_add_entry(&cb->list, name, namlen);
-	return 0;
-}
-
-static int filldir_overlaid(void *buf, const char *name, int namlen,
-			    loff_t offset, u64 ino, unsigned int d_type)
-{
-	struct union_cache_callback *cb = buf;
-
-	switch (namlen) {
-	case 2:
-		if (name[1] != '.')
-			break;
-	case 1:
-		if (name[0] != '.')
-			break;
-		return 0;
-	}
-
-	if (union_cache_find_entry(&cb->list, name, namlen))
-		return 0;
-
-	union_cache_add_entry(&cb->list, name, namlen);
-	return cb->filler(cb->buf, name, namlen, cb->offset + offset, ino,
-			  d_type);
-}
-
-static int filldir_overlaid_cacheonly(void *buf, const char *name, int namlen,
-				      loff_t offset, u64 ino,
-				      unsigned int d_type)
-{
-	struct union_cache_callback *cb = buf;
-
-	if (offset > cb->count)
-		return -EINVAL;
-
-	switch (namlen) {
-	case 2:
-		if (name[1] != '.')
-			break;
-	case 1:
-		if (name[0] != '.')
-			break;
-		return 0;
-	}
-
-	if (union_cache_find_entry(&cb->list, name, namlen))
-		return 0;
-
-	union_cache_add_entry(&cb->list, name, namlen);
-	return 0;
-}
-
-/*
- * readdir_union_cache - A helper to fill the readdir cache
- */
-static int readdir_union_cache(struct file *file, void *_buf, filldir_t filler)
-{
-	struct union_cache_callback *cb = _buf;
-	int old_count;
-	loff_t old_pos;
-	int res;
-
-	old_count = cb->count;
-	cb->count = ((file->f_pos > i_size_read(file->f_path.dentry->d_inode)) ?
-		      i_size_read(file->f_path.dentry->d_inode) :
-		      file->f_pos) & INT_MAX;
-	old_pos = file->f_pos;
-	file->f_pos = 0;
-	res = file->f_op->readdir(file, _buf, filler);
-	file->f_pos = old_pos;
-	cb->count = old_count;
-	return res;
-}
-
-/*
- * readdir_union - A wrapper around ->readdir()
- *
- * This is a wrapper around the filesystems readdir(), which is walking
- * the union stack and calls ->readdir() for every directory in the stack.
- * The directory entries are read into the union mounts readdir cache to
- * support whiteout's and duplicate removal.
- */
-int readdir_union(struct file *file, void *buf, filldir_t filler)
-{
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct union_cache_callback cb;
-	struct path path;
-	loff_t offset = 0;
-	int res = 0;
-
-	mutex_lock(&inode->i_mutex);
-	if (IS_DEADDIR(inode)) {
-		mutex_unlock(&inode->i_mutex);
-		return -ENOENT;
-	}
-
-	INIT_LIST_HEAD(&cb.list);
-	cb.buf = buf;
-	cb.filler = filler;
-	cb.offset = 0;
-	offset = i_size_read(file->f_path.dentry->d_inode);
-	cb.count = file->f_pos;
-
-	if (file->f_pos > 0) {
-		/*
-		 * We have already read from this dir, lets read that stuff to
-		 * our union-cache only
-		 */
-		res = readdir_union_cache(file, &cb,
-					  filldir_topmost_cacheonly);
-		if (res) {
-			mutex_unlock(&inode->i_mutex);
-			goto out;
-		}
-	}
-
-	if (file->f_pos < offset) {
-		res = file->f_op->readdir(file, &cb, filldir_topmost);
-		file_accessed(file);
-		if (res) {
-			mutex_unlock(&inode->i_mutex);
-			goto out;
-		}
-		/* We read until EOF of this directory */
-		file->f_pos = offset;
-	}
-
-	mutex_unlock(&inode->i_mutex);
-
-	path = file->f_path;
-	path_get(&path);
-	while (follow_union_down(&path.mnt, &path.dentry)) {
-		struct file *ftmp;
-
-		/* get path reference for filep */
-		path_get(&path);
-		ftmp = dentry_open(path.dentry, path.mnt,
-				   ((file->f_flags & ~(O_ACCMODE)) |
-				    O_RDONLY | O_DIRECTORY | O_NOATIME));
-		if (IS_ERR(ftmp)) {
-			res = PTR_ERR(ftmp);
-			break;
-		}
-
-		inode = path.dentry->d_inode;
-		mutex_lock(&inode->i_mutex);
-
-		/* rearrange the file position */
-		cb.offset += offset;
-		offset = i_size_read(inode);
-		ftmp->f_pos = file->f_pos - cb.offset;
-		cb.count = ftmp->f_pos;
-		if (ftmp->f_pos < 0) {
-			mutex_unlock(&inode->i_mutex);
-			fput(ftmp);
-			break;
-		}
-
-		res = -ENOENT;
-		if (IS_DEADDIR(inode))
-			goto out_fput;
-
-		if (ftmp->f_pos > 0) {
-			/*
-			 * We have already read from this dir, lets read that
-			 * stuff to our union-cache only
-			 */
-			res = readdir_union_cache(ftmp, &cb,
-						  filldir_overlaid_cacheonly);
-			if (res)
-				goto out_fput;
-		}
-
-		if (ftmp->f_pos < offset) {
-			res = ftmp->f_op->readdir(ftmp, &cb, filldir_overlaid);
-			file_accessed(ftmp);
-			if (res)
-				file->f_pos += ftmp->f_pos;
-			else
-				/*
-				 * We read until EOF of this directory, so lets
-				 * advance the f_pos by the maximum offset
-				 * (i_size) of this directory
-				 */
-				file->f_pos += offset;
-		}
-
-		file_accessed(ftmp);
-
-out_fput:
-		mutex_unlock(&inode->i_mutex);
-		fput(ftmp);
-
-		if (res)
-			break;
-	}
-	path_put(&path);
-out:
-	union_cache_free(&cb.list);
-	return res;
-}
-
-/*
  * Union mount copyup support
  */
 
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -54,7 +54,6 @@ extern int attach_mnt_union(struct vfsmo
 			    struct dentry *);
 extern void detach_mnt_union(struct vfsmount *);
 extern int last_union_is_root(struct path *);
-extern int readdir_union(struct file *, void *, filldir_t);
 extern int is_dir_unioned(struct path *);
 extern int union_relookup_topmost(struct nameidata *, int);
 extern struct dentry *union_create_topmost(struct nameidata *, struct qstr *,
@@ -83,27 +82,5 @@ extern int union_copyup(struct nameidata
 
 #endif	/* CONFIG_UNION_MOUNT */
 
-static inline int do_readdir(struct file *file, void *buf, filldir_t filler)
-{
-	int res = 0;
-	struct inode *inode = file->f_path.dentry->d_inode;
-
-#ifdef CONFIG_UNION_MOUNT
-	if (IS_MNT_UNION(file->f_path.mnt) && is_dir_unioned(&file->f_path))
-		res = readdir_union(file, buf, filler);
-	else
-#endif
-	{
-		mutex_lock(&inode->i_mutex);
-		res = -ENOENT;
-		if (!IS_DEADDIR(inode)) {
-			res = file->f_op->readdir(file, buf, filler);
-			file_accessed(file);
-		}
-		mutex_unlock(&inode->i_mutex);
-	}
-	return res;
-}
-
 #endif	/* __KERNEL__ */
 #endif	/* __LINUX_UNION_H */
