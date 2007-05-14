Return-Path: <linux-kernel-owner+w=401wt.eu-S966169AbXENJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966169AbXENJgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762235AbXENJfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:35:32 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59206 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965828AbXENJfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:35:24 -0400
Date: Mon, 14 May 2007 15:12:49 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  9/14] Union-mount readdir
Message-ID: <20070514094249.GK4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514093722.GB4139@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Union mount readdir

This modifies the readdir()/getdents() routines to read directory
entries from toplevel and the lower directories of a union and present
a merged view.

The directory entries are read starting from the top layer and they
are maintained in a cache. Subsequently when the entries from the bottom layers
of the union stack are read they are checked for duplicates (in the cache)
before being passed out to the user space. There can be multiple calls
to readdir/getdents routines for reading the entries of a single directory.
And union directory cache is maitained across these calls.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/aio.c                     |    8 
 fs/file_table.c              |   14 -
 fs/read_write.c              |    7 
 fs/readdir.c                 |    2 
 fs/union.c                   |  404 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache_union.h |   27 ++
 include/linux/union.h        |   22 ++
 7 files changed, 475 insertions(+), 9 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -21,6 +21,7 @@
 
 #include <linux/sched.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
@@ -486,6 +487,13 @@ static void aio_fput_routine(struct work
 		/* Complete the fput */
 		__fput(req->ki_filp);
 
+		/*
+		 * __fput no longer releases the dentry and vfsmnt, thanks to
+		 * to union mount. Hence do this manually.
+		 */
+		dput(req->ki_filp->f_path.dentry);
+		mntput(req->ki_filp->f_path.mnt);
+
 		/* Link the iocb into the context's free list */
 		spin_lock_irq(&ctx->ctx_lock);
 		really_put_req(ctx, req);
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
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
+#include <linux/union.h>
 #include "read_write.h"
 
 #include <asm/uaccess.h>
@@ -123,6 +124,12 @@ loff_t vfs_llseek(struct file *file, lof
 		if (file->f_op && file->f_op->llseek)
 			fn = file->f_op->llseek;
 	}
+
+#ifdef CONFIG_UNION_MOUNT
+	if (S_ISDIR(file->f_path.dentry->d_inode->i_mode) &&
+			unlikely(file->f_path.dentry->d_overlaid))
+		return union_dir_llseek(file, offset, origin);
+#endif
 	return fn(file, offset, origin);
 }
 EXPORT_SYMBOL(vfs_llseek);
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
 
 struct union_info * union_alloc(void)
 {
@@ -26,6 +27,8 @@ struct union_info * union_alloc(void)
 	mutex_init(&info->u_mutex);
 	mutex_lock(&info->u_mutex);
 	atomic_set(&info->u_count, 1);
+	INIT_LIST_HEAD(&info->u_rdcache);
+	info->u_cookie = 0;
 	UM_DEBUG_LOCK("allocate union %p\n", info);
 	return info;
 }
@@ -40,6 +43,7 @@ struct union_info * union_get(struct uni
 	return info;
 }
 
+static void release_rdstates(struct union_info *info);
 void union_put(struct union_info *info)
 {
 	BUG_ON(!info);
@@ -49,6 +53,7 @@ void union_put(struct union_info *info)
 
 	if (!atomic_read(&info->u_count)) {
 		UM_DEBUG_LOCK("free union %p\n", info);
+		release_rdstates(info);
 		kfree(info);
 	}
 
@@ -968,3 +973,402 @@ int follow_union_mount(struct vfsmount *
 
 	return res;
 }
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
+struct union_cache_callback {
+	struct getdents_callback *buf;	/* original getdents_callback */
+	filldir_t filldir;		/* the filldir() we should call */
+	int error;			/* stores filldir error */
+	struct rdstate *rdstate;	/* readdir state */
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
+static void union_cache_free(struct list_head *list)
+{
+	struct list_head *p;
+	struct list_head *ptmp;
+	int count = 0;
+
+	list_for_each_safe(p, ptmp, list) {
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
+	return ret;
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
+/*
+ * This is same as __dentry_read(). But since this is called with
+ * union lock held, the corresponding release involves doing fput_union()
+ * rather than usual fput().
+ */
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
+	f->f_path.dentry = NULL;
+	f->f_path.mnt = NULL;
+	put_filp(f);
+out:
+	return ERR_PTR(error);
+}
+
+/*
+ * filldir routine for union mounted directories.
+ * Handles duplicate elimination by building a readdir cache.
+ */
+static int filldir_union(void *buf, const char *name, int namlen,
+			   loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+	int err;
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
+	if (union_cache_find_entry(&cb->rdstate->dirent_cache, name, namlen))
+		return 0;
+
+	err =  cb->filldir(cb->buf, name, namlen, offset, ino, d_type);
+	if (err >= 0)
+		union_cache_add_entry(&cb->rdstate->dirent_cache, name, namlen);
+	cb->error = err;
+	return err;
+}
+
+/* rdstate - readdir state */
+#define DIREOF		0xffffff
+#define RDOFFBITS	20
+#define MAXRDCOOKIE	0xfff
+
+static inline off_t rdstate2offset(struct rdstate *r)
+{
+	return ((r->cookie & MAXRDCOOKIE) << RDOFFBITS) | (r->off & DIREOF);
+}
+
+static void put_rdstate(struct rdstate *rdstate)
+{
+	union_cache_free(&rdstate->dirent_cache);
+	list_del(&rdstate->list);
+	kfree(rdstate);
+}
+
+static void release_rdstates(struct union_info *info)
+{
+	struct list_head *pos, *tmp;
+
+	list_for_each_safe(pos, tmp, &info->u_rdcache) {
+		struct rdstate *r = list_entry(pos, struct rdstate, list);
+		put_rdstate(r);
+	}
+}
+
+static struct rdstate *get_rdstate(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct list_head *pos;
+	struct rdstate *r;
+
+	/*
+	 * Do we already have a rdstate for this file at this
+	 * corresponding offset ?
+	 */
+	list_for_each(pos, &dentry->d_union->u_rdcache) {
+		r = list_entry(pos, struct rdstate, list);
+		if (file->f_pos == rdstate2offset(r))
+			return r;
+	}
+
+	/*
+	 * We have read the dirents from this earlier but now
+	 * don't have a corresponding rdstate. AFAICS this can't
+	 * happen.
+	 */
+	if (file->f_pos)
+		return ERR_PTR(-ESTALE);
+
+	/*
+	 * Create a new instance of rdstate for this request.
+	 */
+	r = kmalloc(sizeof(struct rdstate), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+	r->dentry = dentry;
+	r->off = 0;
+	if (dentry->d_union->u_cookie >= (MAXRDCOOKIE - 1))
+		dentry->d_union->u_cookie = 1;
+	else
+		dentry->d_union->u_cookie++;
+	r->cookie = dentry->d_union->u_cookie;
+	INIT_LIST_HEAD(&r->dirent_cache);
+	list_add(&r->list, &dentry->d_union->u_rdcache);
+	return r;
+}
+
+/**
+ * readdir_union - A wrapper around ->readdir()
+ *
+ * This is a wrapper around the filesystems readdir(), which is walking
+ * the union stack and calls ->readdir() for every directory in the stack.
+ * The directory entries are read into the union readdir cache to
+ * support whiteout's and duplicate removal.
+ */
+int readdir_union(struct file *file, void *buf, filldir_t filldir)
+{
+	struct dentry *topmost = file->f_path.dentry;
+	struct rdstate *rdstate;
+	struct dentry *dentry;
+	loff_t offset = 0;
+	struct union_cache_callback cb;
+	int err = 0;
+
+	BUG_ON(!topmost->d_union);
+
+	if (file->f_pos == DIREOF)
+		goto out;
+
+	rdstate = get_rdstate(file);
+	if (IS_ERR(rdstate)) {
+		err = PTR_ERR(rdstate);
+		return err;
+	}
+
+	cb.buf = buf;
+	cb.filldir = filldir;
+	cb.rdstate = rdstate;
+
+	dentry = rdstate->dentry;
+	offset = rdstate->off;
+
+	/* Read from the topmost directory */
+	if (dentry == topmost) {
+		file->f_pos = offset;
+		err = file->f_op->readdir(file, &cb, filldir_union);
+		rdstate->off = file->f_pos;
+		file->f_pos = rdstate2offset(rdstate);
+		if (err < 0 || cb.error < 0)
+			goto out;
+
+		/*
+		 * Reading from topmost dir complete, start reading the lower
+		 * dir from the beginning.
+		 */
+		offset = 0;
+	} else
+		goto read_lower;
+
+	dentry = dentry->d_overlaid;
+	BUG_ON(dentry->d_topmost != topmost);
+
+read_lower:
+	/* Read from the underlying directories */
+	while (dentry) {
+		struct vfsmount *mnt;
+		struct file *ftmp;
+
+		mnt = find_mnt(dentry);
+		__dget(dentry);
+		ftmp = __dentry_open_read(dentry, mnt, file->f_flags);
+		if (IS_ERR(ftmp)) {
+			__dput(dentry);
+			mntput(mnt);
+			err = PTR_ERR(ftmp);
+			goto out;
+		}
+
+		mutex_lock(&dentry->d_inode->i_mutex);
+		ftmp->f_pos = offset;
+
+		err = ftmp->f_op->readdir(ftmp, &cb, filldir_union);
+		file_accessed(ftmp);
+		mutex_unlock(&dentry->d_inode->i_mutex);
+		rdstate->off = ftmp->f_pos;
+		rdstate->dentry = dentry;
+		file->f_pos = rdstate2offset(rdstate);
+		fput_union(ftmp);
+		if (err < 0 || cb.error < 0)
+			goto out;
+
+		/*
+		 * Reading from a lower dir complete, start reading the
+		 * next lower dir from the beginning.
+		 */
+		offset = 0;
+		dentry = dentry->d_overlaid;
+	}
+
+	/*
+	 * We reached the end of lowermost directory of the union,
+	 * we can now release this rdstate.
+	 */
+	put_rdstate(rdstate);
+	file->f_pos = DIREOF;
+	return 0;
+out:
+	return err;
+}
+
+/*
+ * lseek operations on a union directory is restricted. We allow only to
+ * seek to the beginning of the file and to the current position.
+ *
+ * Since union mount gives a new meaning to file->f_pos(for only
+ * union mounted directories) it doesn't make much sense to allow all
+ * seek operations afterall.
+ */
+loff_t union_dir_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct dentry *topmost;
+	struct rdstate *rdstate;
+
+	if (offset)
+		return -EINVAL;
+
+	switch (origin) {
+	case SEEK_SET:
+		topmost = file->f_path.dentry;
+		union_lock(topmost);
+		BUG_ON(!topmost->d_union);
+		/* Flush the readdir cache if one exists */
+		rdstate = get_rdstate(file);
+		put_rdstate(rdstate);
+		union_unlock(topmost);
+		return 0;
+	case SEEK_CUR:
+		return file->f_pos;
+	case SEEK_END:
+		return -EINVAL;
+	}
+	return -EINVAL;
+}
--- a/include/linux/dcache_union.h
+++ b/include/linux/dcache_union.h
@@ -21,6 +21,27 @@
 
 #ifdef CONFIG_UNION_MOUNT
 
+struct rdstate {
+	/* readdir read the entries last time from this directory */
+	struct dentry *dentry;
+
+	/* and stopped reading at this offset */
+	loff_t off;
+
+	/* different rdstates are linked thro' this */
+	struct list_head list;
+
+	/* cache of directory entries. As of now, cache is just a linked list */
+	struct list_head dirent_cache;
+
+	/*
+	 * there can be multiple readdir()/getdents() routines reading a
+	 * directory at a time. And this indicates whose state is this
+	 * rdstate holding.
+	 */
+	unsigned int cookie;
+};
+
 /*
  * This is the union info object, that describes general information about this
  * union directory
@@ -30,8 +51,10 @@
  * or modifing the union stack !
  */
 struct union_info {
-	atomic_t u_count;
-	struct mutex u_mutex;
+	atomic_t u_count; /* number of users of this union */
+	struct mutex u_mutex; /* mutex guarding this union stack */
+	unsigned int u_cookie; /* new rdstates get cookies from here */
+	struct list_head u_rdcache; /* list of rdstates for this union */
 };
 
 /* allocate/de-allocate */
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -30,6 +30,11 @@ extern struct dentry * real_lookup_union
 extern struct dentry * __lookup_hash_kern_union(struct qstr *, struct dentry *,
 					   struct nameidata *);
 
+/* readdir */
+extern int readdir_union(struct file *, void *, filldir_t);
+
+extern loff_t union_dir_llseek(struct file *, loff_t, int);
+
 #else	/* CONFIG_UNION_MOUNT */
 
 #define attach_mnt_union(mnt,nd) do { /* empty */ } while (0)
@@ -78,5 +83,22 @@ static inline struct dentry * __lookup_h
 out:
 	return dentry;
 }
+
+static inline int do_readdir(struct file *file, void *buf, filldir_t filler)
+{
+	int res;
+
+#ifdef CONFIG_UNION_MOUNT
+	if (file->f_path.dentry->d_overlaid) {
+		union_lock(file->f_path.dentry);
+		res = readdir_union(file, buf, filler);
+		union_unlock(file->f_path.dentry);
+	} else
+#endif
+		res = file->f_op->readdir(file, buf, filler);
+
+	return res;
+}
+
 #endif	/* __KERNEL __ */
 #endif	/* __LINUX_UNION_H */
