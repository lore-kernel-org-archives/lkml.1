Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbXDQNOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbXDQNOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbXDQNOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:14:14 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55519 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbXDQNOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:14:09 -0400
Date: Tue, 17 Apr 2007 18:51:30 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  8/15] Union-mount lookup
Message-ID: <20070417132130.GI4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Union-mount lookup

Modifies the vfs lookup routines to work with union mounted directories.

The existing lookup routines generally lookup for a pathname only in the
topmost or given directory. The changed versions of the lookup routines
search for the pathname in the entire union mounted stack. Also they have been
modified to setup the union stack during lookup from dcache cache and from
real_lookup().

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/dcache.c            |   16 +
 fs/namei.c             |   76 +++++-
 fs/namespace.c         |   35 ++
 fs/union.c             |  597 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |   17 +
 include/linux/namei.h  |    4 
 include/linux/union.h  |   27 ++
 7 files changed, 761 insertions(+), 11 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1278,7 +1278,7 @@ struct dentry * d_lookup(struct dentry *
 	return dentry;
 }
 
-struct dentry * __d_lookup(struct dentry * parent, struct qstr * name)
+struct dentry * __d_lookup_single(struct dentry *parent, struct qstr *name)
 {
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
@@ -1363,6 +1363,20 @@ out:
 	return dentry;
 }
 
+struct dentry * d_lookup_single(struct dentry *parent, struct qstr *name)
+{
+	struct dentry *dentry;
+	unsigned long seq;
+
+        do {
+                seq = read_seqbegin(&rename_lock);
+                dentry = __d_lookup_single(parent, name);
+                if (dentry)
+			break;
+	} while (read_seqretry(&rename_lock, seq));
+	return dentry;
+}
+
 /**
  * d_validate - verify dentry provided from insecure source
  * @dentry: The dentry alleged to be valid child of @dparent
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -374,6 +374,33 @@ void release_open_intent(struct nameidat
 }
 
 static inline struct dentry *
+do_revalidate_single(struct dentry *dentry, struct nameidata *nd)
+{
+	int status = dentry->d_op->d_revalidate(dentry, nd);
+	if (unlikely(status <= 0)) {
+		/*
+		 * The dentry failed validation.
+		 * If d_revalidate returned 0 attempt to invalidate
+		 * the dentry otherwise d_revalidate is asking us
+		 * to return a fail status.
+		 */
+		if (!status) {
+			if (!d_invalidate(dentry)) {
+				__dput_single(dentry);
+				dentry = NULL;
+			}
+		} else {
+			__dput_single(dentry);
+			dentry = ERR_PTR(status);
+		}
+	}
+	return dentry;
+}
+
+/*
+ * FIXME: We need a union aware revalidate here!
+ */
+static inline struct dentry *
 do_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	int status = dentry->d_op->d_revalidate(dentry, nd);
@@ -403,16 +430,16 @@ do_revalidate(struct dentry *dentry, str
  */
 static struct dentry * cached_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
 {
-	struct dentry * dentry = __d_lookup(parent, name);
+	struct dentry *dentry = __d_lookup_single(parent, name);
 
 	/* lockess __d_lookup may fail due to concurrent d_move() 
 	 * in some unrelated directory, so try with d_lookup
 	 */
 	if (!dentry)
-		dentry = d_lookup(parent, name);
+		dentry = d_lookup_single(parent, name);
 
 	if (dentry && dentry->d_op && dentry->d_op->d_revalidate)
-		dentry = do_revalidate(dentry, nd);
+		dentry = do_revalidate_single(dentry, nd);
 
 	return dentry;
 }
@@ -465,7 +492,7 @@ ok:
  * make sure that nobody added the entry to the dcache in the meantime..
  * SMP-safe
  */
-static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
+struct dentry * real_lookup_single(struct dentry *parent, struct qstr *name, struct nameidata *nd)
 {
 	struct dentry * result;
 	struct inode *dir = parent->d_inode;
@@ -485,7 +512,7 @@ static struct dentry * real_lookup(struc
 	 *
 	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
 	 */
-	result = d_lookup(parent, name);
+	result = d_lookup_single(parent, name);
 	if (!result) {
 		struct dentry * dentry = d_alloc(parent, name);
 		result = ERR_PTR(-ENOMEM);
@@ -506,7 +533,7 @@ static struct dentry * real_lookup(struc
 	 */
 	mutex_unlock(&dir->i_mutex);
 	if (result->d_op && result->d_op->d_revalidate) {
-		result = do_revalidate(result, nd);
+		result = do_revalidate_single(result, nd);
 		if (!result)
 			result = ERR_PTR(-ENOENT);
 	}
@@ -699,7 +726,7 @@ static int __follow_mount(struct path *p
 	return res;
 }
 
-static void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
+void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
 {
 	while (d_mountpoint(*dentry)) {
 		struct vfsmount *mounted = lookup_mnt(*mnt, *dentry);
@@ -773,6 +800,7 @@ static __always_inline void follow_dotdo
 		nd->mnt = parent;
 	}
 	follow_mount(&nd->mnt, &nd->dentry);
+	follow_union_mount(&nd->mnt, &nd->dentry);
 }
 
 /*
@@ -784,7 +812,15 @@ static int do_lookup(struct nameidata *n
 		     struct path *path)
 {
 	struct vfsmount *mnt = nd->mnt;
-	struct dentry *dentry = __d_lookup(nd->dentry, name);
+	struct dentry *dentry;
+
+	UM_DEBUG_UID("lookup \"%s\" in \"%s\" (inode=%p,dev=%s)\n",
+		     name->name,
+		     nd->dentry->d_name.name,
+		     nd->dentry->d_inode,
+		     nd->mnt->mnt_devname);
+
+	dentry = __d_lookup(nd->dentry, name);
 
 	if (!dentry)
 		goto need_lookup;
@@ -793,7 +829,17 @@ static int do_lookup(struct nameidata *n
 done:
 	path->mnt = mnt;
 	path->dentry = dentry;
+
+	if (nd->dentry->d_sb != dentry->d_sb)
+		path->mnt = find_mnt(dentry);
+
 	__follow_mount(path);
+	follow_union_mount(&path->mnt, &path->dentry);
+
+	UM_DEBUG_UID("found \"%s\" (inode=%p,dev=%s)\n",
+		     path->dentry->d_name.name,
+		     path->dentry->d_inode,
+		     path->mnt->mnt_devname);
 	return 0;
 
 need_lookup:
@@ -838,6 +884,9 @@ static fastcall int __link_path_walk(con
 	if (nd->depth)
 		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
 
+	UM_DEBUG_UID("begin walking for %s\n", name);
+	follow_union_mount(&nd->mnt, &nd->dentry);
+
 	/* At this point we know we have a real path component. */
 	for(;;) {
 		unsigned long hash;
@@ -931,6 +980,7 @@ static fastcall int __link_path_walk(con
 last_with_slashes:
 		lookup_flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
 last_component:
+		UM_DEBUG_UID("last component %s\n", this.name);
 		/* Clear LOOKUP_CONTINUE iff it was previously unset */
 		nd->flags &= lookup_flags | ~LOOKUP_CONTINUE;
 		if (lookup_flags & LOOKUP_PARENT)
@@ -1270,8 +1320,14 @@ int __user_path_lookup_open(const char _
  * Restricted form of lookup. Doesn't follow links, single-component only,
  * needs parent already locked. Doesn't follow mounts.
  * SMP-safe.
+ *
+ * NOTE: On union mounts it is important that the overlaid dentries are
+ * correct. Therefore we need to follow mounts. Take a look at
+ * __lookup_hash_union() how it is done.
+ *
+ * Called with union already locked (before the parent inode is locked !!!)
  */
-static struct dentry * __lookup_hash(struct qstr *name, struct dentry * base, struct nameidata *nd)
+struct dentry * __lookup_hash_single(struct qstr *name, struct dentry *base, struct nameidata *nd)
 {
 	struct dentry * dentry;
 	struct inode *inode;
@@ -1307,6 +1363,8 @@ static struct dentry * __lookup_hash(str
 			dput(new);
 	}
 out:
+	UM_DEBUG_UID("name=\"%s\", inode=%p\n",
+		     dentry->d_name.name, dentry->d_inode);
 	return dentry;
 }
 
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -130,6 +130,41 @@ struct vfsmount *lookup_mnt(struct vfsmo
 	return child_mnt;
 }
 
+/*
+ * find_mnt - find a vfsmount struct
+ * @dentry: a dentry
+ *
+ * This searches the namespace for a given dentries
+ * vfsmount struct. This is used by union-mount.
+ */
+struct vfsmount * find_mnt(struct dentry *dentry)
+{
+	struct list_head *tmp;
+	struct vfsmount *p, *mnt = NULL;
+
+	down_read(&namespace_sem);
+	spin_lock(&vfsmount_lock);
+	if (list_empty(&current->nsproxy->mnt_ns->list)) {
+		spin_unlock(&vfsmount_lock);
+		up_read(&namespace_sem);
+		return NULL;
+	}
+	list_for_each(tmp, &current->nsproxy->mnt_ns->list) {
+		p = list_entry(tmp, struct vfsmount, mnt_list);
+		if (dentry->d_sb == p->mnt_sb) {
+			mnt = mntget(p);
+			break;
+		}
+	}
+	spin_unlock(&vfsmount_lock);
+	up_read(&namespace_sem);
+
+	BUG_ON(!mnt);
+//	UM_DEBUG_UID("found %s/%p in %s\n", dentry->d_name.name,
+//		     dentry->d_inode, mnt->mnt_devname);
+	return mnt;
+}
+
 static inline int check_mnt(struct vfsmount *mnt)
 {
 	return mnt->mnt_ns == current->nsproxy->mnt_ns;
--- a/fs/union.c
+++ b/fs/union.c
@@ -365,3 +365,600 @@ void detach_mnt_union(struct vfsmount *m
 	 * union stack */
 	__dput(path->dentry);
 }
+
+static noinline int revalidate_union(struct dentry * dentry)
+{
+	union_check(dentry);
+
+	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
+	if (atomic_read(&dentry->d_count) < 2) {
+		UM_DEBUG_DCACHE("dentry unused, count=%d\n",
+			     atomic_read(&dentry->d_count));
+		__d_drop(dentry);
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_lock);
+		return 0;
+	}
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_lock);
+
+	return 1;
+}
+
+static noinline void replace_union_info(struct dentry *dentry,
+					struct union_info *lock)
+{
+	struct dentry *tmp = dentry;
+	struct union_info *old_lock = union_get(dentry->d_union);
+
+	BUG_ON(!lock);
+	BUG_ON(dentry->d_union == lock);
+
+	while (tmp) {
+		spin_lock(&tmp->d_lock);
+		union_put(tmp->d_union);
+		tmp->d_union = union_get(lock);
+		spin_unlock(&tmp->d_lock);
+		tmp = tmp->d_overlaid;
+	}
+
+	BUG_ON(atomic_read(&old_lock->u_count) != 1);
+	union_put(old_lock);
+	return;
+}
+
+static void __dput_from_to(struct dentry *from, struct dentry *to,
+			   struct union_info *lock)
+{
+	struct dentry *next = from;
+	struct union_info *mylock = union_get(from->d_union);
+
+	while (next) {
+		struct dentry *tmp = next;
+		next = next->d_overlaid;
+
+		UM_DEBUG_UID("dput_all dentry=\"%s\", inode=\"%p\"\n",
+			     tmp->d_name.name, tmp->d_inode);
+
+		if (lock) {
+			spin_lock(&tmp->d_lock);
+			tmp->d_topmost = NULL;
+			tmp->d_overlaid = NULL;
+			union_put(tmp->d_union);
+			tmp->d_union = NULL;
+			spin_unlock(&tmp->d_lock);
+		}
+
+		__dput_single(tmp);
+
+		if (tmp == to)
+			break;
+	}
+
+	UM_DEBUG_LOCK("\"??\" unlocking union %p\n", lock);
+	mutex_unlock(&mylock->u_mutex);
+	union_put(mylock);
+}
+
+/*
+ * Lookup for the @name in the dentry cache. Look through the lower layers
+ * of the union stack and build a union stack if necessary.
+ *
+ * 1.) used dentry, negative dentry, NULL dentry: just return
+ * 2.) unused union-mount dentry: How do I know? Hmm, our parent is overlaid.
+ *     Some of our d_overlaid dentries COULD be out of cache but we don't know
+ *     for sure. So lets return NULL. Maybe we should also drop the dentry?
+ * 3.) used union-mount dentry: How do I know? Because we are used and our
+ *     d_overlaid isn't NULL. What should happen? Increment the d_count on
+ *     all our d_overlaid dentries and return.
+ *
+ * TODO: Consider breaking this function into smaller bits.
+ */
+struct dentry * __d_lookup_union(struct dentry *base, struct qstr *name)
+{
+	struct dentry *parent = base->d_overlaid;
+	struct dentry *dentry = NULL;
+	struct dentry *topmost;
+	struct dentry *last;
+	struct qstr this;
+	struct union_info *lock = NULL;
+	int err;
+
+	union_lock(base);
+	topmost = __d_lookup_single(base, name);
+	last = topmost;
+
+	if (!topmost || !base->d_overlaid)
+		goto out;
+
+	this.name = name->name;
+	this.len = name->len;
+	this.hash = name->hash;
+
+	if (topmost->d_inode)
+		goto lookup_union;
+
+	/*
+	 * look for the first non-negative dentry
+	 */
+	while (parent) {
+		if (parent->d_op && parent->d_op->d_hash) {
+			err = parent->d_op->d_hash(parent, &this);
+			if (err < 0) {
+				__dput_single(topmost);
+				topmost = NULL;
+				goto out;
+			}
+		}
+		dentry = __d_lookup_single(parent, &this);
+		/*
+		 * Force a real lookup if parts of the
+		 * union stack are not in the dcache
+		 */
+		if (!dentry) {
+			__dput_single(topmost);
+			topmost = NULL;
+			goto out;
+		}
+		if (dentry->d_inode)
+			break;
+		__dput_single(dentry);
+		dentry = NULL;
+		parent = parent->d_overlaid;
+	}
+
+	if (!dentry)
+		goto out;
+
+	__dput_single(topmost);
+	topmost = dentry;
+	last = dentry;
+
+lookup_union:
+	do {
+		struct vfsmount *mnt = find_mnt(topmost);
+		UM_DEBUG_DCACHE("name=\"%s\", inode=%p, device=%s\n",
+				topmost->d_name.name, topmost->d_inode,
+				mnt->mnt_devname);
+		mntput(mnt);
+	} while (0);
+
+	if (!S_ISDIR(topmost->d_inode->i_mode))
+		goto out;
+
+	if (!revalidate_union(topmost)) {
+		__dput_single(topmost);
+		topmost = NULL;
+		goto out;
+	}
+
+	spin_lock(&topmost->d_lock);
+	if (topmost->d_union) {
+		union_lock_spinlock(topmost, &topmost->d_lock);
+	}
+	spin_unlock(&topmost->d_lock);
+
+	parent = topmost->d_parent->d_overlaid;
+	while (parent) {
+		if (parent->d_op && parent->d_op->d_hash) {
+			err = parent->d_op->d_hash(parent, &this);
+			if (err < 0) {
+				UM_DEBUG("failed to hash the qstr\n");
+				goto dput_all;
+			}
+		}
+		dentry = __d_lookup_single(parent, &this);
+		if (!dentry) {
+			__dput_single(dentry);
+			goto dput_all;
+		}
+		if (!dentry->d_inode) {
+			__dput_single(dentry);
+			parent = parent->d_overlaid;
+			continue;
+		}
+		if (!S_ISDIR(dentry->d_inode->i_mode)) {
+			__dput_single(dentry);
+			break;
+		}
+		if (last->d_overlaid
+		    && (last->d_overlaid != dentry)) {
+			printk(KERN_ERR "%s: strange stack layout " \
+			       "(\"%s\" overlays \"%s\")\n",
+			       __FUNCTION__, last->d_name.name,
+			       dentry->d_name.name);
+			dump_stack();
+			__dput_single(dentry);
+			goto dput_all;
+		}
+		spin_lock(&topmost->d_lock);
+		if (!topmost->d_union) {
+			UM_DEBUG_LOCK("allocate union for \"%s\"\n",
+				      topmost->d_name.name);
+			topmost->d_union = union_alloc();
+			lock = topmost->d_union;
+		}
+		spin_unlock(&topmost->d_lock);
+		spin_lock(&dentry->d_lock);
+		if (!dentry->d_union)
+			dentry->d_union = union_get(topmost->d_union);
+		spin_unlock(&dentry->d_lock);
+		if (dentry->d_union != topmost->d_union) {
+			union_lock(dentry);
+			replace_union_info(topmost, dentry->d_union);
+		}
+		dentry->d_topmost = topmost;
+		last->d_overlaid = dentry;
+		last = dentry;
+		parent = parent->d_overlaid;
+	}
+
+	spin_lock(&topmost->d_lock);
+	if (topmost->d_union && atomic_read(&topmost->d_union->u_count) == 1) {
+		union_put(topmost->d_union);
+		topmost->d_union = NULL;
+	} else
+		union_unlock(topmost);
+	spin_unlock(&topmost->d_lock);
+out:
+	union_unlock(base);
+	return topmost;
+
+dput_all:
+	__dput_from_to(topmost, last, lock);
+	union_unlock(base);
+	return NULL;
+}
+
+/* "stack" is a already existing union stack, "new" is a dentry or
+ * a union stack which is overlaid by "stack". So the topmost dentry
+ * is in "stack". */
+static void append_to_stack(struct dentry *stack, struct dentry *new)
+{
+	struct dentry *topmost;
+	struct dentry *prev = stack;
+	struct dentry *next = new;
+
+	BUG_ON(!stack);
+	BUG_ON(!new);
+
+	while (prev->d_overlaid)
+		prev = prev->d_overlaid;
+
+	if (prev->d_topmost)
+		topmost = prev->d_topmost;
+	else
+		topmost = stack;
+
+	while (next) {
+		next->d_topmost = topmost;
+		prev->d_overlaid = next;
+		prev = next;
+		next = next->d_overlaid;
+	}
+
+	return;
+}
+
+/*
+ * FIXME: export this from fs/namei.c ???
+ */
+extern int follow_mount(struct vfsmount **, struct dentry **);
+extern struct dentry * __lookup_hash_single(struct qstr *, struct dentry *,
+					    struct nameidata *);
+extern struct dentry * real_lookup_single(struct dentry *, struct qstr *,
+					  struct nameidata *);
+
+/*
+ * This is called when a dentries parent is union-mounted and we have
+ * to lookup the overlaid dentries. The lookup starts at the parents
+ * first overlaid dentry of the given dentry. Negative dentries are
+ * ignored and not included in the overlaid list.
+ *
+ * If we reach a dentry with restricted access, we just stop the lookup
+ * because we shouldn't see through that dentry. Same thing for dentry
+ * type mismatch and whiteouts.
+ *
+ * FIXME:
+ * - handle DT_WHT
+ * - handle union stacks in use
+ * - handle union stacks mounted upon union stacks
+ * - avoid unnecessary allocations of union locks
+ */
+static int __lookup_union(struct dentry *topmost, struct qstr *name,
+			  struct nameidata *__nd)
+{
+	struct dentry *parent;
+	struct dentry *last;
+	struct dentry *dentry;
+	unsigned int hash = name->hash;
+	struct nameidata nd;
+	int err;
+
+	/* we may also be called via lookup_hash
+	 * with a NULLed nd argument */
+	if (__nd) {
+		nd.last.name = NULL;	// handled in __link_path_walk
+		nd.last.len = 0;
+		nd.last.hash = 0;
+		nd.flags = __nd->flags;
+		nd.um_flags = 0;	// dito
+		nd.last_type = -1;	// dito
+		nd.depth = 0;		// handled in do_follow_link
+		memcpy(&nd.intent, &__nd->intent, sizeof(nd.intent));
+	}
+
+	spin_lock(&topmost->d_lock);
+	if (topmost->d_union) {
+		union_lock_spinlock(topmost, &topmost->d_lock);
+	}
+	spin_unlock(&topmost->d_lock);
+
+	parent = topmost->d_parent->d_overlaid;
+	last = topmost;
+
+	while (parent) {
+		/* the hash could be changed in the last __lookup_hash_single()
+		 * so we need to reset it here */
+		name->hash = hash;
+		nd.dentry = __dget(parent);
+		nd.mnt = find_mnt(parent);
+
+		mutex_lock(&parent->d_inode->i_mutex);
+		dentry = __lookup_hash_single(name, parent,
+					      __nd ? &nd : NULL);
+		mutex_unlock(&parent->d_inode->i_mutex);
+		if (IS_ERR(dentry)) {
+			err = PTR_ERR(dentry);
+			goto out;
+		}
+
+		if (!dentry->d_inode) {
+			__dput_single(dentry);
+			goto loop;
+		}
+
+		if (!S_ISDIR(dentry->d_inode->i_mode)) {
+			__dput_single(dentry);
+			err = 0;
+			goto out;
+		}
+
+		/* Now we know, we found something real */
+		follow_mount(&nd.mnt, &dentry);
+
+		do {
+			struct vfsmount *mnt = find_mnt(dentry);
+			UM_DEBUG_UID("name=\"%s\", inode=%p, device=%s\n",
+				     dentry->d_name.name, dentry->d_inode,
+				     mnt->mnt_devname);
+			mntput(mnt);
+		} while (0);
+
+		if (last->d_overlaid && (last->d_overlaid != dentry)) {
+			printk(KERN_ERR "%s: strange stack layout " \
+			       "(\"%s\" overlays \"%s\")\n",
+			       __FUNCTION__, last->d_name.name,
+			       dentry->d_name.name);
+			dump_stack();
+			__dput_single(dentry);
+			/* lets try to make a clean ending */
+			last->d_overlaid = NULL;
+			err = -EFAULT;	// FIXME: something better?
+			goto out;
+		}
+
+		spin_lock(&topmost->d_lock);
+		if (!topmost->d_union) {
+			UM_DEBUG_LOCK("allocate union for \"%s\"\n",
+				      topmost->d_name.name);
+			topmost->d_union = union_alloc();
+		}
+		spin_unlock(&topmost->d_lock);
+
+		spin_lock(&dentry->d_lock);
+		if (!dentry->d_union)
+			dentry->d_union = union_get(topmost->d_union);
+		spin_unlock(&dentry->d_lock);
+
+		if (topmost->d_union != dentry->d_union) {
+			union_lock(dentry);
+			replace_union_info(topmost, dentry->d_union);
+		}
+
+		dentry->d_topmost = topmost;
+		last->d_overlaid = dentry;
+		last = dentry;
+	loop:
+		__dput(nd.dentry);
+		mntput(nd.mnt);
+		parent = parent->d_overlaid;
+	}
+
+	err = 0;
+	union_unlock(topmost);
+	return err;
+out:
+	__dput(nd.dentry);
+	mntput(nd.mnt);
+	union_unlock(topmost);
+	return err;
+}
+
+struct dentry * real_lookup_union(struct dentry *base, struct qstr *name,
+				  struct nameidata *__nd)
+{
+	struct dentry *parent;
+	struct dentry *topmost;
+	unsigned int hash = name->hash;
+	struct nameidata nd;
+	int err;
+
+	union_lock(base);
+	topmost = real_lookup_single(base, name, __nd);
+	if (IS_ERR(topmost))
+		goto out;
+
+	if (topmost->d_inode) {
+		parent = base;
+		goto lookup_union;
+	}
+
+	if (__nd) {
+		nd.last.name = NULL;	// handled in __link_path_walk
+		nd.last.len = 0;
+		nd.last.hash = 0;
+		nd.flags = __nd->flags;
+		nd.um_flags = 0;	// dito
+		nd.last_type = -1;	// dito
+		nd.depth = 0;		// handled in do_follow_link
+		memcpy(&nd.intent, &__nd->intent, sizeof(nd.intent));
+	}
+
+	parent = base->d_overlaid;
+	while (parent) {
+		struct dentry * dentry;
+
+		name->hash = hash;
+		nd.dentry = __dget(parent);
+		nd.mnt = find_mnt(parent);
+
+		dentry = real_lookup_single(nd.dentry, name, &nd);
+		__dput(nd.dentry);
+		mntput(nd.mnt);
+		if (IS_ERR(dentry))
+			goto out;
+
+		if (dentry->d_inode) {
+			__dput_single(topmost);
+			topmost = dentry;
+			goto lookup_union;
+		}
+		__dput_single(dentry);
+		parent = parent->d_overlaid;
+	}
+
+out:
+	union_unlock(base);
+	return topmost;
+
+lookup_union:
+	if (!parent->d_overlaid || !S_ISDIR(topmost->d_inode->i_mode))
+		goto out;
+
+	do {
+		struct vfsmount *mnt = find_mnt(topmost);
+		UM_DEBUG_UID("name=\"%s\", inode=%p, device=%s\n",
+			     topmost->d_name.name, topmost->d_inode,
+			     mnt->mnt_devname);
+		mntput(mnt);
+	} while (0);
+
+	name->hash = hash;
+	err = __lookup_union(topmost, name, &nd);
+	if (err) {
+		dput(topmost);
+		topmost = ERR_PTR(err);
+	}
+
+	union_unlock(base);
+	return topmost;
+}
+
+struct dentry * __lookup_hash_union(struct qstr *name, struct dentry *parent,
+				    struct nameidata *__nd)
+{
+	struct dentry *topmost;
+	unsigned int hash = name->hash;
+	struct nameidata nd;
+	int err;
+
+	topmost =  __lookup_hash_single(name, parent, __nd);
+	if (IS_ERR(topmost))
+		goto out;
+
+	if (topmost->d_inode)
+		goto lookup_union;
+
+	if (__nd) {
+		nd.last.name = NULL;	// handled in __link_path_walk
+		nd.last.len = 0;
+		nd.last.hash = 0;
+		nd.flags = __nd->flags;
+		nd.um_flags = 0;	// dito
+		nd.last_type = -1;	// dito
+		nd.depth = 0;		// handled in do_follow_link
+		memcpy(&nd.intent, &__nd->intent, sizeof(nd.intent));
+	}
+
+	parent = parent->d_overlaid;
+	while (parent) {
+		struct dentry *dentry;
+
+		name->hash = hash;
+		nd.dentry = __dget(parent);
+		nd.mnt = find_mnt(parent);
+
+		mutex_lock(&parent->d_inode->i_mutex);
+		dentry = __lookup_hash_single(name, nd.dentry, &nd);
+		mutex_unlock(&parent->d_inode->i_mutex);
+		__dput(nd.dentry);
+		mntput(nd.mnt);
+		if (IS_ERR(dentry))
+			goto out;
+
+		if (dentry->d_inode) {
+			__dput_single(topmost);
+			topmost = dentry;
+			goto lookup_union;
+		}
+		__dput_single(dentry);
+		parent = parent->d_overlaid;
+	}
+
+out:
+	return topmost;
+
+lookup_union:
+	if (!parent->d_overlaid || !S_ISDIR(topmost->d_inode->i_mode))
+		goto out;
+
+	do {
+		struct vfsmount *mnt = find_mnt(topmost);
+		UM_DEBUG_UID("name=\"%s\", inode=%p, device=%s\n",
+			     topmost->d_name.name, topmost->d_inode,
+			     mnt->mnt_devname);
+		mntput(mnt);
+	} while (0);
+
+	name->hash = hash;
+	err = __lookup_union(topmost, name, &nd);
+	if (err) {
+		dput(topmost);
+		topmost = ERR_PTR(err);
+	}
+
+	return topmost;
+}
+
+int follow_union_mount(struct vfsmount **mnt, struct dentry **dentry)
+{
+	int res = 0;
+
+	while ((*dentry)->d_topmost) {
+		struct dentry *d_tmp = dget((*dentry)->d_topmost);
+		struct vfsmount *m_tmp = find_mnt((*dentry)->d_topmost);
+
+		UM_DEBUG_UID("name=\"%s\", follow union from %s to %s\n",
+			     (*dentry)->d_name.name, (*mnt)->mnt_devname,
+			     m_tmp->mnt_devname);
+		mntput(*mnt);
+		*mnt = m_tmp;
+		dput(*dentry);
+		*dentry = d_tmp;
+		res = 1;
+	}
+
+	return res;
+}
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -294,9 +294,23 @@ extern void d_move(struct dentry *, stru
 
 /* appendix may either be NULL or be used for transname suffixes */
 extern struct dentry * d_lookup(struct dentry *, struct qstr *);
-extern struct dentry * __d_lookup(struct dentry *, struct qstr *);
+extern struct dentry * d_lookup_single(struct dentry *, struct qstr *);
+extern struct dentry * __d_lookup_single(struct dentry *, struct qstr *);
 extern struct dentry * d_hash_and_lookup(struct dentry *, struct qstr *);
 
+#ifdef CONFIG_UNION_MOUNT
+extern struct dentry * __d_lookup_union(struct dentry *, struct qstr *);
+#endif
+
+static inline struct dentry * __d_lookup(struct dentry *parent, struct qstr *name)
+{
+#ifdef CONFIG_UNION_MOUNT
+       return __d_lookup_union(parent, name);
+#else
+       return __d_lookup_single(parent, name);
+#endif
+}
+
 /* validate "insecure" dentry pointer */
 extern int d_validate(struct dentry *, struct dentry *);
 
@@ -426,6 +440,7 @@ static inline int d_mountpoint(struct de
 extern struct vfsmount *lookup_mnt(struct vfsmount *, struct dentry *);
 extern struct vfsmount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
 extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
+extern struct vfsmount *find_mnt(struct dentry *);
 
 extern int sysctl_vfs_cache_pressure;
 
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -19,6 +19,7 @@ struct nameidata {
 	struct vfsmount *mnt;
 	struct qstr	last;
 	unsigned int	flags;
+	unsigned int	um_flags;
 	int		last_type;
 	unsigned	depth;
 	char *saved_names[MAX_NESTED_LINKS + 1];
@@ -39,6 +40,9 @@ struct path {
  */
 enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 
+#define LAST_UNION             0x01
+#define LAST_LOWLEVEL          0x02
+
 /*
  * The bitmask for a lookup event:
  *  - follow links at the end
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -17,17 +17,44 @@
 #ifdef CONFIG_UNION_MOUNT
 
 #include <linux/fs_struct.h>
+#include <linux/dcache_union.h>
 
 /* namespace stuff used at mount time */
 extern void attach_mnt_union(struct vfsmount *, struct nameidata *);
 extern void detach_mnt_union(struct vfsmount *, struct path *);
 
+/* lookup stuff */
+extern int follow_union_mount(struct vfsmount **, struct dentry **);
+extern struct dentry * real_lookup_union(struct dentry *, struct qstr *,
+					 struct nameidata *);
+extern struct dentry * __lookup_hash_union(struct qstr *, struct dentry *,
+					   struct nameidata *);
+
 #else	/* CONFIG_UNION_MOUNT */
 
 #define attach_mnt_union(mnt,nd) do { /* empty */ } while (0)
 #define detach_mnt_union(mnt,nd) do { /* empty */ } while (0)
+#define follow_union_mount(x,y) do { /* empty */ } while (0)
 
 #endif	/* CONFIG_UNION_MOUNT */
 
+static inline struct dentry * real_lookup(struct dentry *parent, struct qstr *name, struct nameidata *nd)
+{
+#ifdef CONFIG_UNION_MOUNT
+	return real_lookup_union(parent, name, nd);
+#else
+	return real_lookup_single(parent, name, nd);
+#endif
+}
+
+static inline struct dentry * __lookup_hash(struct qstr *name, struct dentry *base, struct nameidata *nd)
+{
+#ifdef CONFIG_UNION_MOUNT
+	return __lookup_hash_union(name, base, nd);
+#else
+	return __lookup_hash_single(name, base, nd);
+#endif
+}
+
 #endif	/* __KERNEL __ */
 #endif	/* __LINUX_UNION_H */
