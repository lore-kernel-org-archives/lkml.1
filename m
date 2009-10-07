Return-Path: <linux-kernel-owner+w=401wt.eu-S934223AbZJGI7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223AbZJGI7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 04:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933586AbZJGI7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 04:59:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:40118 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933380AbZJGI71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 04:59:27 -0400
Date: Wed, 7 Oct 2009 10:58:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [rfc][patch] store-free path walking
Message-ID: <20091007085849.GN30316@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006124941.GS5216@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 02:49:41PM +0200, Jens Axboe wrote:
> On Tue, Oct 06 2009, Nick Piggin wrote:
> > It's a copout, but you could try running multiple dbenches under
> > different working directories (or actually, IIRC dbench does root
> > based path lookups so maybe that won't help you much).
> 
> Yeah, it's hitting dentry->d_lock pretty hard so basically
> spin-serialized at that point.
> 
> > > Anyway, below are the results. Seem very stable.
> > > 
> > >                                 throughput
> > > ------------------------------------------------
> > > 2.6.32-rc3-git          |      561.218 MB/sec
> > > 2.6.32-rc3-git+patch    |      627.022 MB/sec
> > 
> > Well it's good to see you got some improvement.
> 
> Yes, it's an improvement though the results are still pretty abysmal :-)

OK, I have a really basic patch that does store-free path walking
(except on the final element). dbench is pretty nasty still because
it seems to do a lot of stupid things like reading from /proc/mounts
all the time.

Actually it isn't quite store-free because it still takes mnt ref
(which is hard to avoid, but at least it is a per-cpu data). So
this patch applies on top of my recent patchset. At least it does
not store to the dentries.

Basically it is holding rcu_read_lock for the entire walk, it uses
inode RCU from my earlier patches to check inode permissions, and
it bails out at the slightest sign of trouble :) (actually I think
I have got it to walk mountpoints which is nice).

The seqlock in the dentry is for getting consistent name,len pointer,
and also not giving a false positive if a rename has partially
overwritten the name string (false negatives are always fine in the
lock free lookup path but false positives are not). Possibly we
could make do with a per-sb seqlock for this (or just rename_lock).

I have duplicated most of the lookup code, altering it to the lock
free version, which returns -EAGAIN if it gets in trouble and the
regular path walk starts up. I don't know if this is the best way
to go... it's fairly easy but a bit ugly. But complexifying the
existing path walk any more would not be nice either. It might be
nice to try locking the dentry that we're having trouble with and
continuing from there, rather than redoing the whole walk with
locks...

Anyway, this is the basics working for now, microbenchmark shows
same-cwd lookups scale linearly now too. We can probably slowly
tackle more cases if they come up as being important, simply by
auditing filesystems etc.

--

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -1187,6 +1187,7 @@ struct dentry *d_alloc(struct dentry * p
 	dentry->d_count = 1;
 	dentry->d_flags = DCACHE_UNHASHED;
 	spin_lock_init(&dentry->d_lock);
+	seqcount_init(&dentry->d_seq);
 	dentry->d_inode = NULL;
 	dentry->d_parent = NULL;
 	dentry->d_sb = NULL;
@@ -1579,21 +1580,6 @@ err_out:
  * d_lookup() is protected against the concurrent renames in some unrelated
  * directory using the seqlockt_t rename_lock.
  */
-
-struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
-{
-	struct dentry * dentry = NULL;
-	unsigned seq;
-
-        do {
-                seq = read_seqbegin(&rename_lock);
-                dentry = __d_lookup(parent, name);
-                if (dentry)
-			break;
-	} while (read_seqretry(&rename_lock, seq));
-	return dentry;
-}
-
 struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
 {
 	unsigned int len = name->len;
@@ -1656,6 +1642,78 @@ next:
  	return found;
 }
 
+struct dentry * d_lookup(struct dentry * parent, struct qstr * name)
+{
+	struct dentry *dentry = NULL;
+	unsigned seq;
+
+        do {
+                seq = read_seqbegin(&rename_lock);
+                dentry = __d_lookup(parent, name);
+                if (dentry)
+			break;
+	} while (read_seqretry(&rename_lock, seq));
+	return dentry;
+}
+
+struct dentry * __d_lookup_rcu(struct dentry * parent, struct qstr * name)
+{
+	unsigned int len = name->len;
+	unsigned int hash = name->hash;
+	const unsigned char *str = name->name;
+	struct dcache_hash_bucket *b = d_hash(parent, hash);
+	struct hlist_head *head = &b->head;
+	struct hlist_node *node;
+	struct dentry *dentry;
+
+	hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
+		unsigned seq;
+		struct dentry *tparent;
+		const char *tname;
+		int tlen;
+
+		if (dentry->d_name.hash != hash)
+			continue;
+
+seqretry:
+		seq = read_seqcount_begin(&dentry->d_seq);
+		tparent = dentry->d_parent;
+		if (tparent != parent)
+			continue;
+		tlen = dentry->d_name.len;
+		if (tlen != len)
+			continue;
+		tname = dentry->d_name.name;
+		if (read_seqcount_retry(&dentry->d_seq, seq))
+			goto seqretry;
+		if (memcmp(tname, str, tlen))
+			continue;
+		if (read_seqcount_retry(&dentry->d_seq, seq))
+			goto seqretry;
+
+		return dentry;
+ 	}
+ 	return NULL;
+}
+
+struct dentry *d_lookup_rcu(struct dentry *parent, struct qstr * name)
+{
+	struct dentry *dentry = NULL;
+	unsigned seq;
+
+	if (parent->d_op && parent->d_op->d_compare)
+		goto out;
+
+        do {
+                seq = read_seqbegin(&rename_lock);
+                dentry = __d_lookup_rcu(parent, name);
+                if (dentry)
+			break;
+	} while (read_seqretry(&rename_lock, seq));
+out:
+	return dentry;
+}
+
 /**
  * d_hash_and_lookup - hash the qstr then search for a dentry
  * @dir: Directory to search in
@@ -1925,6 +1983,8 @@ static void d_move_locked(struct dentry
 	list_del(&target->d_u.d_child);
 
 	/* Switch the names.. */
+	write_seqcount_begin(&dentry->d_seq);
+	write_seqcount_begin(&target->d_seq);
 	switch_names(dentry, target);
 	swap(dentry->d_name.hash, target->d_name.hash);
 
@@ -1939,6 +1999,8 @@ static void d_move_locked(struct dentry
 		/* And add them back to the (new) parent lists */
 		list_add(&target->d_u.d_child, &target->d_parent->d_subdirs);
 	}
+	write_seqcount_end(&target->d_seq);
+	write_seqcount_end(&dentry->d_seq);
 
 	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
 	if (target->d_parent != dentry->d_parent)
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -200,6 +200,29 @@ static int acl_permission_check(struct i
 	return -EACCES;
 }
 
+static int acl_permission_check_rcu(struct inode *inode, int mask,
+		int (*check_acl)(struct inode *inode, int mask))
+{
+	umode_t			mode = inode->i_mode;
+
+	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
+
+	if (current_fsuid() == inode->i_uid)
+		mode >>= 6;
+	else {
+		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl)
+			return -EAGAIN;
+		if (in_group_p(inode->i_gid))
+			mode >>= 3;
+	}
+
+	/*
+	 * If the DACs are ok we don't need any capability check.
+	 */
+	if ((mask & ~mode) == 0)
+		return 0;
+	return -EACCES;
+}
 /**
  * generic_permission  -  check for access rights on a Posix-like filesystem
  * @inode:	inode to check access rights for
@@ -465,6 +488,25 @@ ok:
 	return security_inode_permission(inode, MAY_EXEC);
 }
 
+static int exec_permission_lite_rcu(struct inode *inode)
+{
+	int ret;
+
+	if (inode->i_op->permission)
+		return -EAGAIN;
+	ret = acl_permission_check_rcu(inode, MAY_EXEC, inode->i_op->check_acl);
+	if (ret == -EAGAIN)
+		return ret;
+	if (!ret)
+		goto ok;
+
+	if (capable(CAP_DAC_OVERRIDE) || capable(CAP_DAC_READ_SEARCH))
+		goto ok;
+
+	return ret;
+ok:
+	return security_inode_permission(inode, MAY_EXEC);
+}
 /*
  * This is called when everything else fails, and we actually have
  * to go to the low-level filesystem to find out what we should do..
@@ -569,6 +611,17 @@ static __always_inline void set_root(str
 	}
 }
 
+static __always_inline void set_root_rcu(struct nameidata *nd)
+{
+	if (!nd->root.mnt) {
+		struct fs_struct *fs = current->fs;
+		read_lock(&fs->lock);
+		nd->root = fs->root;
+		mntget(nd->root.mnt);
+		read_unlock(&fs->lock);
+	}
+}
+
 static __always_inline int __vfs_follow_link(struct nameidata *nd, const char *link)
 {
 	int res = 0;
@@ -611,6 +664,14 @@ static void path_put_conditional(struct
 		mntput(path->mnt);
 }
 
+static inline void path_to_nameidata_rcu(struct path *path, struct nameidata *nd)
+{
+	if (nd->path.mnt != path->mnt)
+		mntput(nd->path.mnt);
+	nd->path.mnt = path->mnt;
+	nd->path.dentry = path->dentry;
+}
+
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 {
 	dput(nd->path.dentry);
@@ -705,6 +766,22 @@ int follow_up(struct path *path)
 /* no need for dcache_lock, as serialization is taken care in
  * namespace.c
  */
+static int __follow_mount_rcu(struct path *path)
+{
+	int res = 0;
+	while (d_mountpoint(path->dentry)) {
+		struct vfsmount *mounted = lookup_mnt(path);
+		if (!mounted)
+			break;
+		if (res)
+			mntput(path->mnt);
+		path->mnt = mounted;
+		path->dentry = mounted->mnt_root;
+		res = 1;
+	}
+	return res;
+}
+
 static int __follow_mount(struct path *path)
 {
 	int res = 0;
@@ -791,6 +868,24 @@ static __always_inline void follow_dotdo
  *  small and for now I'd prefer to have fast path as straight as possible.
  *  It _is_ time-critical.
  */
+static int do_lookup_rcu(struct nameidata *nd, struct qstr *name,
+		     struct path *path)
+{
+	struct vfsmount *mnt = nd->path.mnt;
+	struct dentry *dentry;
+
+	dentry = __d_lookup_rcu(nd->path.dentry, name);
+
+	if (!dentry)
+		return -EAGAIN;
+	if (dentry->d_op && dentry->d_op->d_revalidate)
+		return -EAGAIN;
+	path->mnt = mnt;
+	path->dentry = dentry;
+	__follow_mount_rcu(path);
+	return 0;
+}
+
 static int do_lookup(struct nameidata *nd, struct qstr *name,
 		     struct path *path)
 {
@@ -825,6 +920,134 @@ fail:
 	return PTR_ERR(dentry);
 }
 
+static noinline int link_path_walk_rcu(const char *name, struct nameidata *nd, struct path *next)
+{
+	struct inode *inode;
+	unsigned int lookup_flags = nd->flags;
+
+	while (*name=='/')
+		name++;
+	if (!*name)
+		goto return_reval;
+
+	inode = nd->path.dentry->d_inode;
+	if (nd->depth)
+		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
+
+	/* At this point we know we have a real path component. */
+	for(;;) {
+		unsigned long hash;
+		struct qstr this;
+		unsigned int c;
+
+		nd->flags |= LOOKUP_CONTINUE;
+		if (exec_permission_lite_rcu(inode))
+			return -EAGAIN;
+
+		this.name = name;
+		c = *(const unsigned char *)name;
+
+		hash = init_name_hash();
+		do {
+			name++;
+			hash = partial_name_hash(c, hash);
+			c = *(const unsigned char *)name;
+		} while (c && (c != '/'));
+		this.len = name - (const char *) this.name;
+		this.hash = end_name_hash(hash);
+
+		/* remove trailing slashes? */
+		if (!c)
+			goto last_component;
+		while (*++name == '/');
+		if (!*name)
+			goto last_with_slashes;
+
+		if (this.name[0] == '.') switch (this.len) {
+			default:
+				break;
+			case 2:
+				if (this.name[1] != '.')
+					break;
+				return -EAGAIN;
+			case 1:
+				continue;
+		}
+		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash)
+			return -EAGAIN;
+		/* This does the actual lookups.. */
+		if (do_lookup_rcu(nd, &this, next))
+			return -EAGAIN;
+
+		inode = next->dentry->d_inode;
+		if (!inode)
+			return -ENOENT;
+		if (inode->i_op->follow_link)
+			return -EAGAIN;
+		path_to_nameidata_rcu(next, nd);
+		if (!inode->i_op->lookup)
+			return -ENOTDIR;
+		continue;
+		/* here ends the main loop */
+
+last_with_slashes:
+		lookup_flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+last_component:
+		/* Clear LOOKUP_CONTINUE iff it was previously unset */
+		nd->flags &= lookup_flags | ~LOOKUP_CONTINUE;
+		if (lookup_flags & LOOKUP_PARENT)
+			return -EAGAIN;
+		if (this.name[0] == '.') switch (this.len) {
+			default:
+				break;
+			case 2:
+				if (this.name[1] != '.')
+					break;
+				return -EAGAIN;
+			case 1:
+				goto return_reval;
+		}
+		if (nd->path.dentry->d_op && nd->path.dentry->d_op->d_hash)
+			return -EAGAIN;
+		if (do_lookup_rcu(nd, &this, next))
+			return -EAGAIN;
+		inode = next->dentry->d_inode;
+		if ((lookup_flags & LOOKUP_FOLLOW)
+		    && inode && inode->i_op->follow_link)
+			return -EAGAIN;
+
+		path_to_nameidata_rcu(next, nd);
+		if (!inode)
+			return -ENOENT;
+		if (lookup_flags & LOOKUP_DIRECTORY) {
+			if (!inode->i_op->lookup)
+				return -ENOTDIR;
+		}
+		goto return_base;
+	}
+return_reval:
+	/*
+	 * We bypassed the ordinary revalidation routines.
+	 * We may need to check the cached dentry for staleness.
+	 */
+	if (nd->path.dentry && nd->path.dentry->d_sb &&
+	    (nd->path.dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT))
+		return -EAGAIN;
+return_base:
+	spin_lock(&nd->path.dentry->d_lock);
+	if (d_unhashed(nd->path.dentry)) {
+		spin_unlock(&nd->path.dentry->d_lock);
+		return -EAGAIN;
+	}
+	if (!nd->dentry->d_inode) {
+		spin_unlock(&nd->path.dentry->d_lock);
+		return -EAGAIN;
+	}
+	nd->path.dentry->d_count++;
+	spin_unlock(&nd->path.dentry->d_lock);
+	return 0;
+}
+
 /*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
@@ -887,7 +1110,7 @@ static int __link_path_walk(const char *
 		if (this.name[0] == '.') switch (this.len) {
 			default:
 				break;
-			case 2:	
+			case 2:
 				if (this.name[1] != '.')
 					break;
 				follow_dotdot(nd);
@@ -942,7 +1165,7 @@ last_component:
 		if (this.name[0] == '.') switch (this.len) {
 			default:
 				break;
-			case 2:	
+			case 2:
 				if (this.name[1] != '.')
 					break;
 				follow_dotdot(nd);
@@ -1013,12 +1236,82 @@ return_err:
 	return err;
 }
 
+static int path_walk_rcu(const char *name, struct nameidata *nd)
+{
+	struct path save = nd->path;
+	struct path path = {.mnt = NULL};
+	int err;
+
+	current->total_link_count = 0;
+	err = link_path_walk_rcu(name, nd, &path);
+	if (err) {
+		if (path.mnt != nd->path.mnt)
+			mntput(path.mnt);
+		mntput(nd->path.mnt);
+		if (err == -EAGAIN)
+			nd->path = save;
+	}
+	return err;
+}
+
 static int path_walk(const char *name, struct nameidata *nd)
 {
 	current->total_link_count = 0;
 	return link_path_walk(name, nd);
 }
 
+static noinline int path_init_rcu(int dfd, const char *name, unsigned int flags, struct nameidata *nd)
+{
+	int retval = 0;
+	int fput_needed;
+	struct file *file;
+
+	nd->last_type = LAST_ROOT; /* if there are only slashes... */
+	nd->flags = flags;
+	nd->depth = 0;
+	nd->root.mnt = NULL;
+
+	if (*name=='/') {
+		set_root_rcu(nd);
+		nd->path = nd->root;
+		mntget(nd->root.mnt);
+	} else if (dfd == AT_FDCWD) {
+		struct fs_struct *fs = current->fs;
+		read_lock(&fs->lock);
+		nd->path = fs->pwd;
+		mntget(fs->pwd.mnt);
+		read_unlock(&fs->lock);
+	} else {
+		struct dentry *dentry;
+
+		file = fget_light(dfd, &fput_needed);
+		retval = -EBADF;
+		if (!file)
+			goto out_fail;
+
+		dentry = file->f_path.dentry;
+
+		retval = -ENOTDIR;
+		if (!S_ISDIR(dentry->d_inode->i_mode))
+			goto fput_fail;
+
+		retval = file_permission(file, MAY_EXEC);
+		if (retval)
+			goto fput_fail;
+
+		nd->path = file->f_path;
+		mntget(file->f_path.mnt);
+
+		fput_light(file, fput_needed);
+	}
+	return 0;
+
+fput_fail:
+	fput_light(file, fput_needed);
+out_fail:
+	return retval;
+}
+
 static int path_init(int dfd, const char *name, unsigned int flags, struct nameidata *nd)
 {
 	int retval = 0;
@@ -1075,16 +1368,46 @@ out_fail:
 static int do_path_lookup(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
-	int retval = path_init(dfd, name, flags, nd);
-	if (!retval)
-		retval = path_walk(name, nd);
-	if (unlikely(!retval && !audit_dummy_context() && nd->path.dentry &&
-				nd->path.dentry->d_inode))
-		audit_inode(name, nd->path.dentry);
+	int retval;
+
+	rcu_read_lock();
+	retval = path_init_rcu(dfd, name, flags, nd);
+	if (unlikely(retval)) {
+		rcu_read_unlock();
+		return retval;
+	}
+	retval = path_walk_rcu(name, nd);
+	rcu_read_unlock();
+	if (likely(!retval)) {
+		if (unlikely(!audit_dummy_context())) {
+			if (nd->path.dentry && nd->path.dentry->d_inode)
+				audit_inode(name, nd->path.dentry);
+		}
+	}
 	if (nd->root.mnt) {
-		path_put(&nd->root);
+		mntput(nd->root.mnt);
 		nd->root.mnt = NULL;
 	}
+
+	if (unlikely(retval == -EAGAIN)) {
+		/* slower, locked walk */
+		retval = path_init(dfd, name, flags, nd);
+		if (unlikely(retval))
+			return retval;
+		retval = path_walk(name, nd);
+		if (likely(!retval)) {
+			if (unlikely(!audit_dummy_context())) {
+				if (nd->path.dentry && nd->path.dentry->d_inode)
+					audit_inode(name, nd->path.dentry);
+			}
+		}
+
+		if (nd->root.mnt) {
+			path_put(&nd->root);
+			nd->root.mnt = NULL;
+		}
+	}
+
 	return retval;
 }
 
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/spinlock.h>
+#include <linux/seqlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
 
@@ -81,15 +82,16 @@ full_name_hash(const unsigned char *name
  * large memory footprint increase).
  */
 #ifdef CONFIG_64BIT
-#define DNAME_INLINE_LEN_MIN 32 /* 192 bytes */
+#define DNAME_INLINE_LEN_MIN 24 /* 192 bytes */
 #else
-#define DNAME_INLINE_LEN_MIN 40 /* 128 bytes */
+#define DNAME_INLINE_LEN_MIN 36 /* 128 bytes */
 #endif
 
 struct dentry {
 	unsigned int d_count;		/* protected by d_lock */
 	unsigned int d_flags;		/* protected by d_lock */
 	spinlock_t d_lock;		/* per dentry lock */
+	seqcount_t d_seq;		/* per dentry seqlock */
 	int d_mounted;
 	struct inode *d_inode;		/* Where the name belongs to - NULL is
 					 * negative */
@@ -283,9 +285,11 @@ extern void d_move(struct dentry *, stru
 extern struct dentry *d_ancestor(struct dentry *, struct dentry *);
 
 /* appendix may either be NULL or be used for transname suffixes */
-extern struct dentry * d_lookup(struct dentry *, struct qstr *);
-extern struct dentry * __d_lookup(struct dentry *, struct qstr *);
-extern struct dentry * d_hash_and_lookup(struct dentry *, struct qstr *);
+extern struct dentry *d_lookup(struct dentry *, struct qstr *);
+extern struct dentry *__d_lookup(struct dentry *, struct qstr *);
+extern struct dentry *d_lookup_rcu(struct dentry *, struct qstr *);
+extern struct dentry *__d_lookup_rcu(struct dentry *, struct qstr *);
+extern struct dentry *d_hash_and_lookup(struct dentry *, struct qstr *);
 
 /* validate "insecure" dentry pointer */
 extern int d_validate(struct dentry *, struct dentry *);

