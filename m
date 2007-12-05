Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbXLEOl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbXLEOl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbXLEOls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:41:48 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:54119 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXLEOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:41:46 -0500
Date: Wed, 5 Dec 2007 20:11:17 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       viro@zeniv.linux.org.uk, Christoph Hellwig <hch@lst.de>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: [RFC PATCH 5/5] Directory cache invalidation
Message-ID: <20071205144117.GH2471@in.ibm.com>
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

Changes to keep dirent cache uptodate.

Dirent cache stored as part of topmost directory's struct file needs to
be marked stale whenever there is a modification in any of the directories
that is part of the union. Modifications(like addition/deletion of new
entries) to a directory can occur from places like mkdir, rmdir, mknod etc.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/dcache.c            |    1 
 fs/namei.c             |   13 +++
 fs/union.c             |  178 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/dcache.h |    4 -
 include/linux/fs.h     |    4 +
 include/linux/union.h  |    3 
 6 files changed, 201 insertions(+), 2 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -974,6 +974,7 @@ struct dentry *d_alloc(struct dentry * p
 #endif
 #ifdef CONFIG_UNION_MOUNT
 	INIT_LIST_HEAD(&dentry->d_unions);
+	INIT_LIST_HEAD(&dentry->d_overlaid);
 	dentry->d_unionized = 0;
 #endif
 	INIT_HLIST_NODE(&dentry->d_hash);
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2237,6 +2237,7 @@ static int __open_namei_create(struct na
 	nd->path.dentry = path->dentry;
 	if (error)
 		return error;
+	rdcache_invalidate(&nd->path);
 	/* Don't check for write permission, don't truncate */
 	return may_open(nd, 0, flag & ~O_TRUNC);
 }
@@ -2682,6 +2683,8 @@ asmlinkage long sys_mknodat(int dfd, con
 					  mode, 0);
 			break;
 	}
+	if (!error)
+		rdcache_invalidate(&nd.path);
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	path_put_conditional(&path, &nd);
@@ -2757,6 +2760,8 @@ asmlinkage long sys_mkdirat(int dfd, con
 	if (error)
 		goto out_dput;
 	error = vfs_mkdir(nd.path.dentry->d_inode, path.dentry, mode);
+	if (!error)
+		rdcache_invalidate(&nd.path);
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	path_put_conditional(&path, &nd);
@@ -3287,6 +3292,8 @@ static long do_rmdir(int dfd, const char
 	if (error)
 		goto exit3;
 	error = vfs_rmdir(nd.path.dentry->d_inode, path.dentry);
+	if (!error)
+		rdcache_invalidate(&nd.path);
 	mnt_drop_write(nd.path.mnt);
 exit3:
 	path_put_conditional(&path, &nd);
@@ -3375,6 +3382,8 @@ static long do_unlinkat(int dfd, const c
 		if (error)
 			goto exit2;
 		error = vfs_unlink(nd.path.dentry->d_inode, path.dentry);
+		if (!error)
+			rdcache_invalidate(&nd.path);
 		mnt_drop_write(nd.path.mnt);
 	exit2:
 		path_put_conditional(&path, &nd);
@@ -3466,6 +3475,8 @@ asmlinkage long sys_symlinkat(const char
 		goto out_dput;
 	error = vfs_symlink(nd.path.dentry->d_inode, path.dentry, from,
 			    S_IALLUGO);
+	if (!error)
+		rdcache_invalidate(&nd.path);
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	path_put_conditional(&path, &nd);
@@ -3566,6 +3577,8 @@ asmlinkage long sys_linkat(int olddfd, c
 		goto out_dput;
 	error = vfs_link(old_nd.path.dentry, nd.path.dentry->d_inode,
 			 path.dentry);
+	if (!error)
+		rdcache_invalidate(&nd.path);
 	mnt_drop_write(nd.path.mnt);
 out_dput:
 	path_put_conditional(&path, &nd);
--- a/fs/union.c
+++ b/fs/union.c
@@ -39,6 +39,7 @@ static struct hlist_head *union_hashtabl
 static unsigned int union_rhash_mask __read_mostly;
 static unsigned int union_rhash_shift __read_mostly;
 static struct hlist_head *union_rhashtable __read_mostly;
+static struct hlist_head *readdir_hashtable __read_mostly;
 
 /*
  * Locking Rules:
@@ -103,6 +104,18 @@ static int __init init_union(void)
 	for (loop = 0; loop < (1 << union_rhash_shift); loop++)
 		INIT_HLIST_HEAD(&union_rhashtable[loop]);
 
+	readdir_hashtable = alloc_large_system_hash("readdir-cache",
+						  sizeof(struct hlist_head),
+						  union_hash_entries,
+						  14,
+						  0,
+						  &union_rhash_shift,
+						  &union_rhash_mask,
+						  0);
+
+	for (loop = 0; loop < (1 << union_rhash_shift); loop++)
+		INIT_HLIST_HEAD(&readdir_hashtable[loop]);
+
 	readdir_cache = kmem_cache_create("readdir-cache",
 					sizeof(struct rdcache_entry), 0,
 					SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
@@ -126,6 +139,7 @@ struct union_mount *union_alloc(struct d
 	atomic_set(&um->u_count, 1);
 	INIT_LIST_HEAD(&um->u_unions);
 	INIT_LIST_HEAD(&um->u_list);
+	INIT_LIST_HEAD(&um->u_overlaid);
 	INIT_HLIST_NODE(&um->u_hash);
 	INIT_HLIST_NODE(&um->u_rhash);
 
@@ -290,6 +304,7 @@ int append_to_union(struct vfsmount *mnt
 	}
 	list_add(&this->u_list, &mnt->mnt_unions);
 	list_add(&this->u_unions, &dentry->d_unions);
+	list_add(&this->u_overlaid, &dest_dentry->d_overlaid);
 	dest_dentry->d_unionized++;
 	__union_hash(this);
 	spin_unlock(&union_lock);
@@ -367,6 +382,22 @@ int follow_union_mount(struct vfsmount *
 	return res;
 }
 
+int follow_union_up(struct vfsmount **mnt, struct dentry **dentry)
+{
+	struct union_mount *um;
+
+	if (!IS_UNION(*dentry))
+		return 0;
+
+	um = union_rlookup(*dentry, *mnt);
+	if (um) {
+		*dentry = um->u_this.dentry;
+		*mnt = um->u_this.mnt;
+		return 1;
+	}
+	return 0;
+}
+
 /*
  * is_dir_unioned - check if the directory represented by @path has a union
  * stack underneath.
@@ -418,6 +449,7 @@ repeat:
 		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
+		list_del(&this->u_overlaid);
 		spin_unlock(&union_lock);
 		union_put(this);
 		goto repeat;
@@ -447,6 +479,7 @@ repeat:
 		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
+		list_del(&this->u_overlaid);
 		spin_unlock(&union_lock);
 		if (__union_put(this)) {
 			__dput(n_dentry, list);
@@ -474,6 +507,7 @@ repeat:
 		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
+		list_del(&this->u_overlaid);
 		spin_unlock(&union_lock);
 		union_put(this);
 		goto repeat;
@@ -505,6 +539,7 @@ void detach_mnt_union(struct vfsmount *m
 	list_del(&um->u_list);
 	list_del(&um->u_unions);
 	um->u_next.dentry->d_unionized--;
+	list_del(&um->u_overlaid);
 	spin_unlock(&union_lock);
 	union_put(um);
 	return;
@@ -657,6 +692,35 @@ static int filldir_union(void *buf, cons
 }
 
 /*
+ * Called when rdcache becomes stale due to modifications to the directory.
+ * Discard the existing rdcache, reread the entries and rebuild the cache
+ * till the current f_pos.
+ * rdcache is marked stale from places like mkdir(), creat() etc.
+ *
+ * CHECK: What if current f_pos can't be established after the change ?
+ */
+static int rebuild_rdcache(struct file *file)
+{
+	struct rdstate *r = file->f_rdstate;
+
+	rdcache_free(&r->dirent_cache);
+
+	path_put(&r->cur_path);
+	r->cur_path = file->f_path;
+	path_get(&r->cur_path);
+
+	/* Fill rdcache until the previously known offset */
+	r->fill_off = r->cur_off - 1;
+
+	r->cur_off = r->last_off = 0;
+	r->cur_dirent = NULL;
+	r->file_off = 0;
+	r->nr_dirents = 0;
+
+	return readdir_union(file, NULL, NULL);
+}
+
+/*
  * This is called when current offset in rdcache gets changed and when
  * we need to change the current underlying directory in the rdstate
  * to match the current offset.
@@ -704,6 +768,13 @@ static int readdir_rdcache(struct file *
 	struct rdcache_entry *tmp = r->cur_dirent;
 	int err = 0;
 
+	if (unlikely(r->flags & RDSTATE_STALE)) {
+		r->flags &= ~RDSTATE_STALE;
+		err = rebuild_rdcache(file);
+		if (err)
+			return err;
+	}
+
 	BUG_ON(r->cur_off > r->last_off);
 
 	/* If offsets already uptodate, just return */
@@ -734,6 +805,11 @@ void put_rdstate(struct rdstate *rdstate
 		return;
 
 	mutex_lock(&union_rdmutex);
+	spin_lock(&union_lock);
+	hlist_del(&rdstate->hash);
+	spin_unlock(&union_lock);
+
+	path_put(&rdstate->path);
 	path_put(&rdstate->cur_path);
 	rdcache_free(&rdstate->dirent_cache);
 	mutex_unlock(&union_rdmutex);
@@ -758,10 +834,16 @@ static struct rdstate *get_rdstate(struc
 	if (!r)
 		return ERR_PTR(-ENOMEM);
 
-	r->cur_path = file->f_path;
+	r->path = r->cur_path = file->f_path;
+	path_get(&r->path);
 	path_get(&r->cur_path);
 	INIT_LIST_HEAD(&r->dirent_cache);
 	file->f_rdstate = r;
+	INIT_HLIST_NODE(&r->hash);
+	spin_lock(&union_lock);
+	hlist_add_head(&r->hash, readdir_hashtable +
+			hash(r->path.dentry, r->path.mnt));
+	spin_unlock(&union_lock);
 	return r;
 }
 
@@ -916,6 +998,13 @@ loff_t llseek_union(struct file *file, l
 	if (!r)
 		return -EINVAL;
 
+	if (unlikely(r->flags & RDSTATE_STALE)) {
+		r->flags &= ~RDSTATE_STALE;
+		err = rebuild_rdcache(file);
+		if (err)
+			goto out;
+	}
+
 	switch (origin) {
 	case SEEK_END:
 		/*
@@ -965,6 +1054,93 @@ out:
 	return err;
 }
 
+static struct rdstate *lookup_rdstate(struct path *path)
+{
+	struct hlist_head *head = readdir_hashtable +
+					hash(path->dentry, path->mnt);
+	struct hlist_node *node;
+	struct rdstate *r;
+
+	hlist_for_each_entry(r, node, head, hash) {
+		if ((r->path.dentry == path->dentry) &&
+		    (r->path.mnt == path->mnt))
+			return r;
+	}
+	return NULL;
+}
+
+static inline void mark_rdstate_stale(struct path *path)
+{
+	struct rdstate *r = lookup_rdstate(path);
+
+	if (r)
+		r->flags |= RDSTATE_STALE;
+	return;
+}
+
+/*
+ * Mark rdstates associated with all the unions of this
+ * @path->dentry is part of as stale.
+ */
+static void rdcache_invalidate_union(struct path *path)
+{
+	struct union_mount *um;
+
+	spin_lock(&union_lock);
+	list_for_each_entry(um, &path->dentry->d_unions, u_unions)
+		mark_rdstate_stale(&um->u_this);
+	spin_unlock(&union_lock);
+}
+
+/*
+ * Mark rdstates associated with all the unions where
+ * @path->dentry has been overlaid as stale.
+ */
+static void rdcache_invalidate_overlaid(struct path *path)
+{
+	struct union_mount *um;
+	struct path cur;
+
+	spin_lock(&dcache_lock);
+	spin_lock(&union_lock);
+	list_for_each_entry(um, &path->dentry->d_overlaid, u_overlaid) {
+		/*
+		 * CHECK: Here we don't get reference to toplevel dentry of any
+		 * union with the understanding that no dentry can go away
+		 * with us holding the dcache_lock.
+		 */
+		cur = um->u_this;
+		mark_rdstate_stale(&cur);
+		while (follow_union_up(&cur.mnt, &cur.dentry))
+			mark_rdstate_stale(&cur);
+	}
+	spin_unlock(&union_lock);
+	spin_unlock(&dcache_lock);
+}
+
+void rdcache_invalidate(struct path *path)
+{
+	struct path save;
+
+	/* If this dentry is not part of any union, no rdstate to invalidate */
+	if (!IS_UNION(path->dentry))
+		return;
+
+	save = *path;
+	path_get(&save);
+
+	mutex_lock(&union_rdmutex);
+
+	if (!list_empty(&save.dentry->d_unions))
+		rdcache_invalidate_union(&save);
+
+	if (IS_DENTRY_OVERLAID(save.dentry))
+		rdcache_invalidate_overlaid(&save);
+
+	mutex_unlock(&union_rdmutex);
+	path_put(&save);
+}
+
 /*
  * Union mount copyup support
  */
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -97,9 +97,11 @@ struct dentry {
 #ifdef CONFIG_UNION_MOUNT
 	/*
 	 * The following fields are used by the VFS based union mount
-	 * implementation. Both are protected by union_lock!
+	 * implementation. They are protected by union_lock!
 	 */
 	struct list_head d_unions;	/* list of union_mount's */
+	struct list_head d_overlaid;	/* list of union_mount's from where this
+					   dentry is overlaid */
 	unsigned int d_unionized;	/* unions referencing this dentry */
 #endif
 
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -798,6 +798,8 @@ struct rdcache_entry {
 struct rdstate {
 	struct path cur_path;	/* Current directory on which readdir is
 				   in progress */
+	struct hlist_node hash;	/* used to link into readdir_hashtable */
+	struct path path;	/* the path to which this rdstate belongs to */
 	loff_t file_off;	/* File offset of underlying directory */
 	loff_t cur_off;		/* Offset to current dirent in rdcache */
 	loff_t last_off;	/* Offset to last dirent in rdcache */
@@ -815,9 +817,11 @@ struct rdstate {
 #define RDSTATE_NEED_UPDATE	0x02
 
 extern void put_rdstate(struct rdstate *rdstate);
+extern void rdcache_invalidate(struct path *path);
 
 #else
 #define put_rdstate(x)		do { } while (0)
+#define rdcache_invalidate(x)	do { } while (0)
 #endif
 
 #define FILE_MNT_WRITE_TAKEN	1
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -31,6 +31,7 @@ struct union_mount {
 	struct mutex u_mutex;
 	struct list_head u_unions;	/* list head for d_unions */
 	struct list_head u_list;	/* list head for mnt_unions */
+	struct list_head u_overlaid;	/* list head for d_overlaid */
 	struct hlist_node u_hash;	/* list head for seaching */
 	struct hlist_node u_rhash;	/* list head for reverse seaching */
 
@@ -42,6 +43,7 @@ struct union_mount {
 #define IS_UNION(dentry)	(!list_empty(&(dentry)->d_unions) || \
 				 (dentry)->d_unionized)
 #define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
+#define IS_DENTRY_OVERLAID(dentry)	(dentry)->d_unionized
 
 extern int is_unionized(struct dentry *, struct vfsmount *);
 extern int append_to_union(struct vfsmount *, struct dentry *,
@@ -70,6 +72,7 @@ extern struct mutex union_rdmutex;
 
 #define IS_UNION(x)			(0)
 #define IS_MNT_UNION(x)			(0)
+#define IS_DENTRY_OVERLAID(x)		(0)
 #define is_unionized(x, y)		(0)
 #define append_to_union(x1, y1, x2, y2, z)	({ BUG(); (0); })
 #define follow_union_down(x, y)		({ (0); })
