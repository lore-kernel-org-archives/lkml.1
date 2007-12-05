Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXLEOjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXLEOjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXLEOjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:39:35 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39865 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXLEOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:39:33 -0500
Date: Wed, 5 Dec 2007 20:09:16 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [RFC PATCH 2/5] Add New directory listing approach
Message-ID: <20071205143916.GE2471@in.ibm.com>
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

Another readdir implementation for union uounted directories.

Reads dirents from all layers of the union into a cache, eliminates duplicates,
before returning them into userspace. The cache is stored persistently as part
of struct file of the topmost directory. Instead of original directory offsets,
offsets are defined as linearly increasing indices on this cache and the same
is returned to userspace.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/file_table.c       |    1 
 fs/readdir.c          |   10 -
 fs/union.c            |  281 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h    |   30 +++++
 include/linux/union.h |   28 ++++
 5 files changed, 342 insertions(+), 8 deletions(-)

--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -286,6 +286,7 @@ void fastcall __fput(struct file *file)
 		drop_file_write_access(file);
 
 	put_pid(file->f_owner.pid);
+	put_rdstate(file->f_rdstate);
 	file_kill(file);
 	file->f_path.dentry = NULL;
 	file->f_path.mnt = NULL;
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -16,12 +16,12 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
+#include <linux/union.h>
 
 #include <asm/uaccess.h>
 
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int res = -ENOTDIR;
 
 	if (!file->f_op || !file->f_op->readdir)
@@ -31,13 +31,7 @@ int vfs_readdir(struct file *file, filld
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
@@ -46,8 +46,10 @@ static struct hlist_head *union_rhashtab
  * - union_lock
  */
 DEFINE_SPINLOCK(union_lock);
+DEFINE_MUTEX(union_rdmutex);
 
 static struct kmem_cache *union_cache __read_mostly;
+static struct kmem_cache *readdir_cache;
 
 static unsigned long hash(struct dentry *dentry, struct vfsmount *mnt)
 {
@@ -101,6 +103,9 @@ static int __init init_union(void)
 	for (loop = 0; loop < (1 << union_rhash_shift); loop++)
 		INIT_HLIST_HEAD(&union_rhashtable[loop]);
 
+	readdir_cache = kmem_cache_create("readdir-cache",
+					sizeof(struct rdcache_entry), 0,
+					SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	return 0;
 }
 
@@ -516,6 +521,282 @@ int last_union_is_root(struct path *path
 }
 
 /*
+ * readdir support for Union mounts.
+ */
+
+struct rdcache_callback {
+	void *buf;			/* original callback buffer */
+	filldir_t filldir;		/* the filldir() we should call */
+	int error;			/* stores filldir error */
+	struct rdstate *rdstate;	/* readdir state */
+};
+
+/*
+ * This is called after every ->readdir() to persistently store the number of
+ * entries in a directory in the corresponding union_mount structure.
+ */
+static void update_um_dirents(struct rdstate *r)
+{
+	struct union_mount *um;
+
+	spin_lock(&union_lock);
+	um = union_lookup(r->cur_path.dentry, r->cur_path.mnt);
+	if (!um)
+		goto out;
+	um->nr_dirents = r->nr_dirents;
+out:
+	spin_unlock(&union_lock);
+}
+
+static void rdcache_free(struct list_head *list)
+{
+	struct list_head *p;
+	struct list_head *ptmp;
+	int count = 0;
+
+	list_for_each_safe(p, ptmp, list) {
+		struct rdcache_entry *this;
+
+		this = list_entry(p, struct rdcache_entry, list);
+		list_del_init(&this->list);
+		kfree(this->name.name);
+		kmem_cache_free(readdir_cache, this);
+		count++;
+	}
+	INIT_LIST_HEAD(list);
+	return;
+}
+
+static int rdcache_find_entry(struct list_head *uc_list,
+				  const char *name, int namelen)
+{
+	struct rdcache_entry *p;
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
+static int rdcache_add_entry(struct rdstate *r, struct list_head *list,
+		const char *name, int namelen, loff_t offset, u64 ino,
+		unsigned int d_type)
+{
+	struct rdcache_entry *this;
+	char *tmp_name;
+
+	this = kmem_cache_alloc(readdir_cache, GFP_KERNEL);
+	if (!this) {
+		printk(KERN_CRIT "rdcache_add_entry(): out of kernel memory\n");
+		return -ENOMEM;
+	}
+
+	tmp_name = kmalloc(namelen + 1, GFP_KERNEL);
+	if (!tmp_name) {
+		printk(KERN_CRIT "rdcache_add_entry(): out of kernel memory\n");
+		kmem_cache_free(readdir_cache, this);
+		return -ENOMEM;
+	}
+
+	this->name.name = tmp_name;
+	this->name.len = namelen;
+	this->name.hash = 0;
+	memcpy(tmp_name, name, namelen);
+	tmp_name[namelen] = 0;
+	this->off = offset;
+	this->ino = ino;
+	this->dtype = d_type;
+	INIT_LIST_HEAD(&this->list);
+	list_add_tail(&this->list, list);
+	return 0;
+}
+
+/*
+ * filldir routine for union mounted directories.
+ * Handles duplicate elimination by building a readdir cache.
+ */
+static int filldir_union(void *buf, const char *name, int namlen,
+			   loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct rdcache_callback *cb = buf;
+	struct rdstate *r = cb->rdstate;
+	int err = 0;
+
+	/*
+	 * When a dirent gets skipped like this, the offset of the
+	 * next dirent from the previous dirent will also not point to the
+	 * skipped dirent.
+	 */
+	if (rdcache_find_entry(&r->dirent_cache, name, namlen))
+		return 0;
+
+	err =  cb->filldir(cb->buf, name, namlen, r->cur_off,
+				ino, d_type);
+	if (err >= 0) {
+		rdcache_add_entry(r, &r->dirent_cache,
+			name, namlen, offset, ino, d_type);
+		r->cur_off = ++r->last_off;
+		r->nr_dirents++;
+	}
+	cb->error = err;
+	return err;
+}
+
+/* Called from last fput() */
+void put_rdstate(struct rdstate *rdstate)
+{
+	if (!rdstate)
+		return;
+
+	mutex_lock(&union_rdmutex);
+	path_put(&rdstate->cur_path);
+	rdcache_free(&rdstate->dirent_cache);
+	mutex_unlock(&union_rdmutex);
+	kfree(rdstate);
+}
+
+static struct rdstate *get_rdstate(struct file *file)
+{
+	struct rdstate *r = file->f_rdstate;
+
+	if (r)
+		return r;
+
+	/*
+	 * We have read the dirents from this earlier but now don't have a
+	 * corresponding rdstate. This shouldn't happen.
+	 */
+	if (file->f_pos)
+		return ERR_PTR(-EINVAL);
+
+	r = kzalloc(sizeof(struct rdstate), GFP_KERNEL);
+	if (!r)
+		return ERR_PTR(-ENOMEM);
+
+	r->cur_path = file->f_path;
+	path_get(&r->cur_path);
+	INIT_LIST_HEAD(&r->dirent_cache);
+	file->f_rdstate = r;
+	return r;
+}
+
+int readdir_union(struct file *file, void *buf, filldir_t filler)
+{
+	struct dentry *topmost = file->f_path.dentry;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct rdstate *rdstate;
+	struct path path;
+	loff_t offset = 0;
+	struct rdcache_callback cb;
+	int err = 0;
+
+	if (IS_DEADDIR(inode))
+		return -ENOENT;
+
+	rdstate = get_rdstate(file);
+	if (IS_ERR(rdstate)) {
+		err = PTR_ERR(rdstate);
+		return err;
+	}
+
+	cb.buf = buf;
+	cb.filldir = filler;
+	cb.rdstate = rdstate;
+	cb.error = 0;
+
+	offset = rdstate->file_off;
+
+	/* Read from the topmost directory */
+	if (rdstate->cur_path.dentry == topmost) {
+		file->f_pos = offset;
+		err = file->f_op->readdir(file, &cb, filldir_union);
+		rdstate->file_off = file->f_pos;
+		update_um_dirents(rdstate);
+		if (err >= 0)
+			err = cb.error;
+		if (err < 0)
+			goto out;
+
+		/*
+		 * Reading from topmost dir complete, start reading the lower
+		 * dir from the beginning.
+		 */
+		offset = 0;
+		path = file->f_path;
+		path_get(&path);
+		if (!follow_union_down(&path.mnt, &path.dentry))
+			goto out_pathput;
+		rdstate->nr_dirents = 0;
+	} else {
+		path = rdstate->cur_path;
+		path_get(&path);
+	}
+
+	do {
+		struct file *ftmp;
+
+		/* Get a reference for ftmp */
+		path_get(&path);
+		ftmp = dentry_open(path.dentry, path.mnt,
+				   ((file->f_flags & ~(O_ACCMODE)) |
+				    O_RDONLY | O_DIRECTORY | O_NOATIME));
+		if (IS_ERR(ftmp)) {
+			err = PTR_ERR(ftmp);
+			goto out_pathput;
+		}
+
+		inode = path.dentry->d_inode;
+
+		mutex_lock(&inode->i_mutex); /* TODO: use _nested version */
+		if (IS_DEADDIR(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			err = -ENOENT;
+			goto out_pathput;
+		}
+
+		ftmp->f_pos = offset;
+
+		err = ftmp->f_op->readdir(ftmp, &cb, filldir_union);
+		file_accessed(ftmp);
+		rdstate->file_off = ftmp->f_pos;
+		mutex_unlock(&inode->i_mutex);
+		/* TODO: Better to unconditionally put and get ? */
+		if (path.mnt != rdstate->cur_path.mnt) {
+			mntput(rdstate->cur_path.mnt);
+			rdstate->cur_path.mnt = mntget(path.mnt);
+		}
+		if (path.dentry != rdstate->cur_path.dentry) {
+			dput(rdstate->cur_path.dentry);
+			rdstate->cur_path.dentry = dget(path.dentry);
+		}
+		fput(ftmp);
+		update_um_dirents(rdstate);
+		if (err >= 0)
+			err = cb.error;
+		if (err < 0)
+			goto out_pathput;
+
+		/*
+		 * Reading from a lower dir complete, start reading the
+		 * next lower dir from the beginning.
+		 */
+		offset = 0;
+		rdstate->nr_dirents = 0;
+	} while (follow_union_down(&path.mnt, &path.dentry));
+
+out_pathput:
+	path_put(&path);
+out:
+	return err;
+}
+
+/*
  * Union mount copyup support
  */
 
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -785,6 +785,33 @@ static inline int ra_has_index(struct fi
 		index <  ra->start + ra->size);
 }
 
+#ifdef CONFIG_UNION_MOUNT
+/* The readdir cache object */
+struct rdcache_entry {
+	struct list_head list;
+	unsigned long ino;
+	unsigned long off;
+	struct qstr name;
+	unsigned int dtype;
+};
+
+struct rdstate {
+	struct path cur_path;	/* Current directory on which readdir is
+				   in progress */
+	loff_t file_off;	/* File offset of underlying directory */
+	loff_t cur_off;		/* Offset to current dirent in rdcache */
+	loff_t last_off;	/* Offset to last dirent in rdcache */
+	loff_t nr_dirents;	/* Number of entries from current underlying
+				   directory in rdcache */
+	struct list_head dirent_cache;	/* cache of directory entries */
+};
+
+extern void put_rdstate(struct rdstate *rdstate);
+
+#else
+#define put_rdstate(x)		do { } while (0)
+#endif
+
 #define FILE_MNT_WRITE_TAKEN	1
 #define FILE_MNT_WRITE_RELEASED	2
 
@@ -823,6 +850,9 @@ struct file {
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
 	unsigned long f_mnt_write_state;
+#ifdef CONFIG_UNION_MOUNT
+	struct rdstate		*f_rdstate;
+#endif
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -36,6 +36,7 @@ struct union_mount {
 
 	struct path u_this;		/* this is me */
 	struct path u_next;		/* this is what I overlay */
+	loff_t nr_dirents;		/* nr dirents in this directory */
 };
 
 #define IS_UNION(dentry)	(!list_empty(&(dentry)->d_unions) || \
@@ -53,6 +54,7 @@ extern void __shrink_d_unions(struct den
 extern int attach_mnt_union(struct vfsmount *, struct vfsmount *,
 			    struct dentry *);
 extern void detach_mnt_union(struct vfsmount *);
+extern int readdir_union(struct file *, void *, filldir_t);
 extern int last_union_is_root(struct path *);
 extern int is_dir_unioned(struct path *);
 extern int union_relookup_topmost(struct nameidata *, int);
@@ -61,6 +63,8 @@ extern struct dentry *union_create_topmo
 extern int __union_copyup(struct path *, struct nameidata *, struct path *);
 extern int union_copyup(struct nameidata *, int);
 
+extern struct mutex union_rdmutex;
+
 #else /* CONFIG_UNION_MOUNT */
 
 #define IS_UNION(x)			(0)
@@ -82,5 +86,29 @@ extern int union_copyup(struct nameidata
 
 #endif	/* CONFIG_UNION_MOUNT */
 
+static inline int do_readdir(struct file *file, void *buf, filldir_t filler)
+{
+	int res = 0;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+#ifdef CONFIG_UNION_MOUNT
+	if (IS_MNT_UNION(file->f_path.mnt) && is_dir_unioned(&file->f_path)) {
+		mutex_lock(&union_rdmutex);
+		res = readdir_union(file, buf, filler);
+		mutex_unlock(&union_rdmutex);
+	} else
+#endif
+	{
+		res = -ENOENT;
+		if (!IS_DEADDIR(inode)) {
+			res = file->f_op->readdir(file, buf, filler);
+			file_accessed(file);
+		}
+	}
+	mutex_unlock(&inode->i_mutex);
+	return res;
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* __LINUX_UNION_H */
