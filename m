Return-Path: <linux-kernel-owner+w=401wt.eu-S1754084AbXDQNPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbXDQNPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbXDQNPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:15:08 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38535 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbXDQNPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:15:04 -0400
Date: Tue, 17 Apr 2007 18:52:08 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  9/15] Simple union-mount readdir
Message-ID: <20070417132208.GJ4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>
Subject: Simple union-mount readdir

This is a very simple union mount readdir implementation. It modifies the
readdir routine to merge the entries of union mounted directories and
eliminate duplicates while walking the union stack.

FIXME: This patch needs to be reworked! At the moment this only works for
ext2/3 and tmpfs. All kind of index directories that return d_off > i_size
don't work with this.

The directory entries are read starting from the top layer and they
are maintained in a cache. Subsequently when the entries from the bottom layers
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
 fs/aio.c              |    7 
 fs/file_table.c       |   14 +
 fs/readdir.c          |    2 
 fs/union.c            |  393 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/union.h |   17 ++
 5 files changed, 426 insertions(+), 7 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -21,6 +21,7 @@
 
 #include <linux/sched.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
@@ -487,6 +488,12 @@ static void aio_fput_routine(struct work
 
 		/* Complete the fput */
 		__fput(req->ki_filp);
+		/*
+		 * __fput no longer releases the dentry and vfsmnt, thanks to
+		 * to union mount. Hence do this manually.
+		 */
+		dput(req->ki_filp->f_path.dentry);
+		mntput(req->ki_filp->f_path.mnt);
 
 		/* Link the iocb into the context's free list */
 		spin_lock_irq(&ctx->ctx_lock);
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -141,8 +141,14 @@ EXPORT_SYMBOL(get_empty_filp);
 
 void fastcall fput(struct file *file)
 {
-	if (atomic_dec_and_test(&file->f_count))
+	struct dentry *dentry = file->f_path.dentry;
+	struct vfsmount *mnt = file->f_path.mnt;
+
+	if (atomic_dec_and_test(&file->f_count)) {
 		__fput(file);
+		dput(dentry);
+		mntput(mnt);
+	}
 }
 
 EXPORT_SYMBOL(fput);
@@ -152,9 +158,7 @@ EXPORT_SYMBOL(fput);
  */
 void fastcall __fput(struct file *file)
 {
-	struct dentry *dentry = file->f_path.dentry;
-	struct vfsmount *mnt = file->f_path.mnt;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 
 	might_sleep();
 
@@ -180,8 +184,6 @@ void fastcall __fput(struct file *file)
 	file->f_path.dentry = NULL;
 	file->f_path.mnt = NULL;
 	file_free(file);
-	dput(dentry);
-	mntput(mnt);
 }
 
 struct file fastcall *fget(unsigned int fd)
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -33,7 +33,7 @@ int vfs_readdir(struct file *file, filld
 	mutex_lock(&inode->i_mutex);
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		res = file->f_op->readdir(file, buf, filler);
+		res = do_readdir(file, buf, filler);
 		file_accessed(file);
 	}
 	mutex_unlock(&inode->i_mutex);
--- a/fs/union.c
+++ b/fs/union.c
@@ -14,6 +14,7 @@
 #include <linux/namei.h>
 #include <linux/module.h>
 #include <linux/mount.h>
+#include <linux/file.h>
 
 void
 __union_check(struct dentry *dentry)
@@ -962,3 +963,395 @@ int follow_union_mount(struct vfsmount *
 
 	return res;
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
+/*
+ * The readdir union cache object
+ */
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
+	UM_DEBUG_READDIR("freed %d entries\n", count);
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
+static int filldir_topmost(void *_buf, const char *name, int namlen,
+			   loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = _buf;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return cb->filler(cb->buf, name, namlen, cb->offset + offset, ino,
+			  d_type);
+}
+
+static int filldir_topmost_cacheonly(void *_buf, const char *name, int namlen,
+				     loff_t offset, u64 ino,
+				     unsigned int d_type)
+{
+	struct union_cache_callback *cb = _buf;
+
+	if (offset > cb->count)
+		return -EINVAL;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return 0;
+}
+
+static int filldir_overlaid(void *_buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = _buf;
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
+static int filldir_overlaid_cacheonly(void *_buf, const char *name, int namlen,
+				      loff_t offset, u64 ino,
+				      unsigned int d_type)
+{
+	struct union_cache_callback *cb = _buf;
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
+static void fastcall fput_union(struct file *file)
+{
+	struct dentry *dentry = file->f_dentry;
+	struct vfsmount *mnt = file->f_vfsmnt;
+
+	if (atomic_dec_and_test(&file->f_count)) {
+		__fput(file);
+		__dput(dentry);
+		mntput(mnt);
+	}
+}
+
+static struct file * __dentry_open_read(struct dentry *dentry,
+					struct vfsmount *mnt, int flags)
+{
+	struct file *f;
+	struct inode *inode;
+	int error;
+
+	error = -ENFILE;
+	f = get_empty_filp();
+	if (!f)
+		goto out;
+	f->f_flags = flags;
+	f->f_mode = ((flags+1) & O_ACCMODE) | FMODE_LSEEK |
+		FMODE_PREAD | FMODE_PWRITE;
+	inode = dentry->d_inode;
+	BUG_ON(f->f_mode & FMODE_WRITE);
+	f->f_mapping = inode->i_mapping;
+	f->f_dentry = dentry;
+	f->f_vfsmnt = mnt;
+	f->f_pos = 0;
+	f->f_op = fops_get(inode->i_fop);
+	file_move(f, &inode->i_sb->s_files);
+
+	if (f->f_op && f->f_op->open) {
+		error = f->f_op->open(inode,f);
+		if (error)
+			goto cleanup;
+	}
+	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
+
+	file_ra_state_init(&f->f_ra, f->f_mapping->host->i_mapping);
+
+	/* NB: we're sure to have correct a_ops only after f_op->open */
+	if (f->f_flags & O_DIRECT) {
+		if (!f->f_mapping->a_ops || !f->f_mapping->a_ops->direct_IO) {
+			fput_union(f);
+			f = ERR_PTR(-EINVAL);
+		}
+	}
+
+	return f;
+
+cleanup:
+	fops_put(f->f_op);
+	file_kill(f);
+	f->f_dentry = NULL;
+	f->f_vfsmnt = NULL;
+	put_filp(f);
+out:
+	return ERR_PTR(error);
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
+	cb->count = ((file->f_pos > i_size_read(file->f_dentry->d_inode)) ?
+		      i_size_read(file->f_dentry->d_inode) :
+		      file->f_pos) & INT_MAX;
+	old_pos = file->f_pos;
+	file->f_pos = 0;
+	UM_DEBUG_READDIR("count=%ld\n", cb->count);
+	res = file->f_op->readdir(file, _buf, filler);
+	file->f_pos = old_pos;
+	cb->count = old_count;
+	return res;
+}
+
+/**
+ * readdir_union - A wrapper around ->readdir()
+ *
+ * This is a wrapper around the filesystems readdir(), which is walking
+ * the union stack and calls ->readdir() for every directory in the stack.
+ * The directory entries are read into the union mounts readdir cache to
+ * support whiteout's and duplicate removal.
+ */
+int readdir_union(struct file *file, void *_buf, filldir_t filler)
+{
+	int res = -ENOENT;
+	struct union_cache_callback cb;
+	struct dentry *dentry;
+	struct getdents_callback *buf = _buf;
+	loff_t offset = 0;
+
+	INIT_LIST_HEAD(&cb.list);
+	cb.buf = _buf;
+	cb.filler = filler;
+	cb.offset = 0;
+	offset = i_size_read(file->f_dentry->d_inode);
+	cb.count = file->f_pos;
+	UM_DEBUG_READDIR("file=%s, f_pos=%lld, i_size=%lld\n",
+			 file->f_dentry->d_name.name,
+			 file->f_pos,
+			 offset);
+
+	if (file->f_pos > 0) {
+		/* we have already read from this dir,
+		 * lets read that stuff to our union-cache
+		 * only */
+		res = readdir_union_cache(file, &cb,
+					  filldir_topmost_cacheonly);
+		if (res)
+			goto out;
+	}
+
+	if (file->f_pos < offset) {
+		res = file->f_op->readdir(file, &cb,
+					  filldir_topmost);
+		if (res)
+			goto out;
+	}
+
+	dentry = file->f_dentry->d_overlaid;
+	while (dentry) {
+		struct vfsmount *mnt;
+		struct file *ftmp;
+		struct inode *inode;
+
+		if (buf->count <= 0)
+			break;
+
+		mnt = find_mnt(dentry);
+		__dget(dentry);
+		ftmp = __dentry_open_read(dentry, mnt, file->f_flags);
+		if (IS_ERR(ftmp)) {
+			__dput(dentry);
+			mntput(mnt);
+			res = PTR_ERR(ftmp);
+			break;
+		}
+
+		inode = dentry->d_inode;
+		mutex_lock(&inode->i_mutex);
+
+		/* rearrange the file position */
+		cb.offset += offset;
+		offset = i_size_read(inode);
+		ftmp->f_pos = file->f_pos - cb.offset;
+		cb.count = ftmp->f_pos;
+		if (ftmp->f_pos < 0) {
+			mutex_unlock(&inode->i_mutex);
+			fput_union(ftmp);
+			break;
+		}
+
+		UM_DEBUG_READDIR("ftmp=%s, f_pos=%lld, i_size=%lld\n",
+				 ftmp->f_dentry->d_name.name,
+				 ftmp->f_pos,
+				 offset);
+
+		res = -ENOENT;
+		if (IS_DEADDIR(inode))
+			goto out_fput;
+
+		if (ftmp->f_pos > 0) {
+			/* we have already read from this dir,
+			 * lets read that stuff to our union-cache
+			 * only */
+			res = readdir_union_cache(ftmp, &cb,
+						  filldir_overlaid_cacheonly);
+			if (res)
+				goto out_fput;
+		}
+
+		if (ftmp->f_pos < offset) {
+			res = ftmp->f_op->readdir(ftmp, &cb,
+						  filldir_overlaid);
+			file->f_pos += ftmp->f_pos;
+		}
+
+		file_accessed(ftmp);
+
+	out_fput:
+		mutex_unlock(&inode->i_mutex);
+		fput_union(ftmp);
+
+		if (res)
+			break;
+
+		dentry = dentry->d_overlaid;
+	}
+out:
+	union_cache_free(&cb.list);
+	return res;
+}
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -29,6 +29,7 @@ extern struct dentry * real_lookup_union
 					 struct nameidata *);
 extern struct dentry * __lookup_hash_union(struct qstr *, struct dentry *,
 					   struct nameidata *);
+extern int readdir_union(struct file *, void *, filldir_t);
 
 #else	/* CONFIG_UNION_MOUNT */
 
@@ -56,5 +57,21 @@ static inline struct dentry * __lookup_h
 #endif
 }
 
+static inline int do_readdir(struct file *file, void *buf, filldir_t filler)
+{
+#ifdef CONFIG_UNION_MOUNT
+	int res;
+
+	if (file->f_dentry->d_overlaid) {
+		union_lock(file->f_dentry);
+		res = readdir_union(file, buf, filler);
+		union_unlock(file->f_dentry);
+	} else
+#endif
+		res = file->f_op->readdir(file, buf, filler);
+
+	return res;
+}
+
 #endif	/* __KERNEL __ */
 #endif	/* __LINUX_UNION_H */
