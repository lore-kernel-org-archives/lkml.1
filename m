Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbZDYBei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbZDYBei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbZDYB3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:44588 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZDYB2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:53 -0400
Message-Id: <20090425012211.215750250@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:35 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 15/27] fs: dcache remove dcache_lock
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-dcache_lock-remove.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_lock no longer protects anything (I hope). remove it.

This breaks a lot of the tree where I haven't thought about the problem,
but it simplifies the dcache.c code quite a bit (and it's also probably
a good thing to break unconverted code). So I include this here before
making further changes to the locking.

---
 Documentation/filesystems/Locking         |    2 
 arch/powerpc/platforms/cell/spufs/inode.c |    5 -
 drivers/infiniband/hw/ipath/ipath_fs.c    |    6 -
 drivers/staging/pohmelfs/path_entry.c     |    2 
 drivers/usb/core/inode.c                  |    3 
 fs/affs/amigaffs.c                        |    2 
 fs/autofs4/expire.c                       |   11 --
 fs/autofs4/inode.c                        |    6 -
 fs/autofs4/root.c                         |   20 ----
 fs/autofs4/waitq.c                        |    3 
 fs/coda/cache.c                           |    2 
 fs/configfs/configfs_internal.h           |    2 
 fs/configfs/inode.c                       |    6 -
 fs/dcache.c                               |  131 ++++--------------------------
 fs/exportfs/expfs.c                       |    4 
 fs/namei.c                                |    5 -
 fs/ncpfs/dir.c                            |    3 
 fs/ncpfs/ncplib_kernel.h                  |    4 
 fs/nfs/dir.c                              |    3 
 fs/nfs/getroot.c                          |    2 
 fs/nfs/namespace.c                        |    3 
 fs/notify/inotify/inotify.c               |    4 
 fs/ocfs2/dcache.c                         |    2 
 fs/seq_file.c                             |    2 
 fs/smbfs/cache.c                          |    4 
 fs/sysfs/dir.c                            |    3 
 include/linux/dcache.h                    |   17 +--
 kernel/cgroup.c                           |    6 -
 net/sunrpc/rpc_pipe.c                     |   11 +-
 security/selinux/selinuxfs.c              |    4 
 security/tomoyo/realpath.c                |    2 
 31 files changed, 36 insertions(+), 244 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -50,11 +50,10 @@
  *   - d_subdirs and children's d_child
  *
  * Ordering:
- * dcache_lock
- *   dcache_inode_lock
- *     dentry->d_lock
- *       dcache_lru_lock
- *       dcache_hash_lock
+ * dcache_inode_lock
+ *   dentry->d_lock
+ *     dcache_lru_lock
+ *     dcache_hash_lock
  */
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
@@ -62,12 +61,10 @@ EXPORT_SYMBOL_GPL(sysctl_vfs_cache_press
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(dcache_inode_lock);
 EXPORT_SYMBOL(dcache_hash_lock);
-EXPORT_SYMBOL(dcache_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
@@ -109,7 +106,7 @@ static void d_callback(struct rcu_head *
 }
 
 /*
- * no dcache_lock, please.
+ * no locks, please.
  */
 static void d_free(struct dentry *dentry)
 {
@@ -131,7 +128,6 @@ static void d_free(struct dentry *dentry
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
 	__releases(dcache_inode_lock)
-	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
@@ -139,7 +135,6 @@ static void dentry_iput(struct dentry *
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
@@ -149,7 +144,6 @@ static void dentry_iput(struct dentry *
 	} else {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 	}
 }
 
@@ -215,13 +209,12 @@ static void dentry_lru_del_init(struct d
  *
  * If this is the root of the dentry tree, return NULL.
  *
- * dcache_lock and d_lock and d_parent->d_lock must be held by caller, and
+ * d_lock and d_parent->d_lock must be held by caller, and
  * are dropped by d_kill.
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
 	__releases(dcache_inode_lock)
-	__releases(dcache_lock)
 {
 	struct dentry *parent;
 
@@ -278,21 +271,10 @@ repeat:
 		might_sleep();
 	spin_lock(&dentry->d_lock);
 	if (dentry->d_count == 1) {
-		if (!spin_trylock(&dcache_lock)) {
-			/*
-			 * Something of a livelock possibility we could avoid
-			 * by taking dcache_lock and trying again, but we
-			 * want to reduce dcache_lock anyway so this will
-			 * get improved.
-			 */
-drop1:
-			spin_unlock(&dentry->d_lock);
-			goto repeat;
-		}
 		if (!spin_trylock(&dcache_inode_lock)) {
 drop2:
-			spin_unlock(&dcache_lock);
-			goto drop1;
+			spin_unlock(&dentry->d_lock);
+			goto repeat;
 		}
 		parent = dentry->d_parent;
 		if (parent) {
@@ -306,7 +288,6 @@ drop2:
 	dentry->d_count--;
 	if (dentry->d_count) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		return;
 	}
 
@@ -328,7 +309,6 @@ drop2:
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	return;
 
 unhash_it:
@@ -358,11 +338,9 @@ int d_invalidate(struct dentry * dentry)
 	/*
 	 * If it's already been dropped, return OK.
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		return 0;
 	}
 	/*
@@ -371,9 +349,7 @@ int d_invalidate(struct dentry * dentry)
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		shrink_dcache_parent(dentry);
-		spin_lock(&dcache_lock);
 	}
 
 	/*
@@ -390,14 +366,12 @@ int d_invalidate(struct dentry * dentry)
 	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			return -EBUSY;
 		}
 	}
 
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	return 0;
 }
 
@@ -501,11 +475,9 @@ struct dentry * d_find_alias(struct inod
 	struct dentry *de = NULL;
 
 	if (!list_empty(&inode->i_dentry)) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 		de = __d_find_alias(inode, 0);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 	}
 	return de;
 }
@@ -518,7 +490,6 @@ void d_prune_aliases(struct inode *inode
 {
 	struct dentry *dentry;
 restart:
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
@@ -527,14 +498,12 @@ restart:
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			dput(dentry);
 			goto restart;
 		}
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -547,20 +516,16 @@ restart:
  */
 static void prune_one_dentry(struct dentry * dentry)
 	__releases(dentry->d_lock)
-	__releases(dcache_lock)
-	__acquires(dcache_lock)
 {
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
 
 	/*
-	 * Prune ancestors.  Locking is simpler than in dput(),
-	 * because dcache_lock needs to be taken anyway.
+	 * Prune ancestors.
 	 */
 	while (dentry) {
 		struct dentry *parent = NULL;
 
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 again:
 		spin_lock(&dentry->d_lock);
@@ -577,7 +542,6 @@ again:
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			return;
 		}
 
@@ -646,7 +610,6 @@ restart:
 	}
 	spin_unlock(&dcache_lru_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 again:
 	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
@@ -677,14 +640,13 @@ again1:
 		}
 		__dentry_lru_del_init(dentry);
 		spin_unlock(&dcache_lru_lock);
+
 		prune_one_dentry(dentry);
-		/* dcache_lock and dentry->d_lock dropped */
-		spin_lock(&dcache_lock);
+		/* dentry->d_lock dropped */
 		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
@@ -714,7 +676,6 @@ static void prune_dcache(int count)
 
 	if (unused == 0 || count == 0)
 		return;
-	spin_lock(&dcache_lock);
 restart:
 	if (count >= unused)
 		prune_ratio = 1;
@@ -750,11 +711,9 @@ restart:
 		if (down_read_trylock(&sb->s_umount)) {
 			if ((sb->s_root != NULL) &&
 			    (!list_empty(&sb->s_dentry_lru))) {
-				spin_unlock(&dcache_lock);
 				__shrink_dcache_sb(sb, &w_count,
 						DCACHE_REFERENCED);
 				pruned -= w_count;
-				spin_lock(&dcache_lock);
 			}
 			up_read(&sb->s_umount);
 		}
@@ -770,7 +729,6 @@ restart:
 		}
 	}
 	spin_unlock(&sb_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /**
@@ -799,12 +757,10 @@ static void shrink_dcache_for_umount_sub
 	BUG_ON(!IS_ROOT(dentry));
 
 	/* detach this root from the system */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	dentry_lru_del_init(dentry);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 	for (;;) {
 		/* descend to the first leaf in the current subtree */
@@ -813,7 +769,6 @@ static void shrink_dcache_for_umount_sub
 
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
@@ -823,7 +778,6 @@ static void shrink_dcache_for_umount_sub
 				spin_unlock(&loop->d_lock);
 			}
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 
 			/* move to the first child */
 			dentry = list_entry(dentry->d_subdirs.next,
@@ -894,8 +848,7 @@ out:
 
 /*
  * destroy the dentries attached to a superblock on unmounting
- * - we don't need to use dentry->d_lock, and only need dcache_lock when
- *   removing the dentry from the system lists and hashes because:
+ * - we don't need to use dentry->d_lock because:
  *   - the superblock is detached from all mountings and open files, so the
  *     dentry trees will not be rearranged by the VFS
  *   - s_umount is write-locked, so the memory pressure shrinker will ignore
@@ -946,7 +899,6 @@ rename_retry:
 	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
 
-	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
 		goto positive;
 	spin_lock(&this_parent->d_lock);
@@ -993,7 +945,6 @@ resume:
 		if (this_parent != child->d_parent ||
 				read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -1001,12 +952,10 @@ resume:
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return 0; /* No mount points found in tree */
 positive:
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return 1;
@@ -1037,7 +986,6 @@ rename_retry:
 	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -1104,7 +1052,6 @@ resume:
 //				(/* d_unhashed(this_parent) XXX: hmm... */ 0 ||
 //				read_seqretry(&rename_lock, seq))) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -1113,7 +1060,6 @@ resume:
 	}
 out:
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return found;
@@ -1213,7 +1159,6 @@ struct dentry *d_alloc(struct dentry * p
 	INIT_LIST_HEAD(&dentry->d_u.d_child);
 
 	if (parent) {
-		spin_lock(&dcache_lock);
 		spin_lock(&parent->d_lock);
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		dentry->d_parent = dget_dlock(parent);
@@ -1221,7 +1166,6 @@ struct dentry *d_alloc(struct dentry * p
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_lock);
 	}
 
 	atomic_inc(&dentry_stat.nr_dentry);
@@ -1239,7 +1183,6 @@ struct dentry *d_alloc_name(struct dentr
 	return d_alloc(parent, &q);
 }
 
-/* the caller must hold dcache_lock */
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	if (inode)
@@ -1266,11 +1209,9 @@ static void __d_instantiate(struct dentr
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
 	BUG_ON(!list_empty(&entry->d_alias));
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	__d_instantiate(entry, inode);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
 
@@ -1328,11 +1269,9 @@ struct dentry *d_instantiate_unique(stru
 
 	BUG_ON(!list_empty(&entry->d_alias));
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	result = __d_instantiate_unique(entry, inode);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	if (!result) {
 		security_d_instantiate(entry, inode);
@@ -1420,12 +1359,10 @@ struct dentry *d_obtain_alias(struct ino
 	}
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	res = __d_find_alias(inode, 0);
 	if (res) {
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		dput(tmp);
 		goto out_iput;
 	}
@@ -1441,7 +1378,6 @@ struct dentry *d_obtain_alias(struct ino
 	spin_unlock(&tmp->d_lock);
 	spin_unlock(&dcache_inode_lock);
 
-	spin_unlock(&dcache_lock);
 	return tmp;
 
  out_iput:
@@ -1471,22 +1407,19 @@ struct dentry *d_splice_alias(struct ino
 	struct dentry *new = NULL;
 
 	if (inode && S_ISDIR(inode->i_mode)) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			security_d_instantiate(new, inode);
 			d_rehash(dentry);
 			d_move(new, dentry);
 			iput(inode);
 		} else {
-			/* already taking dcache_lock, so d_add() by hand */
+			/* already taken dcache_inode_lock, d_add() by hand */
 			__d_instantiate(dentry, inode);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1558,12 +1491,10 @@ struct dentry *d_add_ci(struct dentry *d
 	 * Negative dentry: instantiate it unless the inode is a directory and
 	 * already has a dentry.
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	if (!S_ISDIR(inode->i_mode) || list_empty(&inode->i_dentry)) {
 		__d_instantiate(found, inode);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		security_d_instantiate(found, inode);
 		return found;
 	}
@@ -1575,7 +1506,6 @@ struct dentry *d_add_ci(struct dentry *d
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
 	iput(inode);
@@ -1597,7 +1527,7 @@ err_out:
  * is returned. The caller must use dput to free the entry when it has
  * finished using it. %NULL is returned on failure.
  *
- * __d_lookup is dcache_lock free. The hash list is protected using RCU.
+ * __d_lookup is global lock free. The hash list is protected using RCU.
  * Memory barriers are used while updating and doing lockless traversal. 
  * To avoid races with d_move while rename is happening, d_lock is used.
  *
@@ -1609,7 +1539,7 @@ err_out:
  *
  * The dentry unused LRU is not updated even if lookup finds the required dentry
  * in there. It is updated in places such as prune_dcache, shrink_dcache_sb,
- * select_parent and __dget_locked. This laziness saves lookup from dcache_lock
+ * select_parent and __dget_locked. This laziness saves lookup from LRU lock
  * acquisition.
  *
  * d_lookup() is protected against the concurrent renames in some unrelated
@@ -1739,25 +1669,22 @@ int d_validate(struct dentry *dentry, st
 	if (dentry->d_parent != dparent)
 		goto out;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	spin_lock(&dcache_hash_lock);
 	base = d_hash(dparent, dentry->d_name.hash);
 	hlist_for_each(lhp,base) { 
 		/* hlist_for_each_entry_rcu() not required for d_hash list
-		 * as it is parsed under dcache_lock
+		 * as it is parsed under dcache_hash_lock
 		 */
 		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
 			spin_unlock(&dcache_hash_lock);
 			__dget_locked_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 out:
 	return 0;
 }
@@ -1789,7 +1716,6 @@ void d_delete(struct dentry * dentry)
 	/*
 	 * Are we the only user?
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
@@ -1804,7 +1730,6 @@ void d_delete(struct dentry * dentry)
 
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -1830,13 +1755,11 @@ static void _d_rehash(struct dentry * en
  
 void d_rehash(struct dentry * entry)
 {
-	spin_lock(&dcache_lock);
 	spin_lock(&entry->d_lock);
 	spin_lock(&dcache_hash_lock);
 	_d_rehash(entry);
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&entry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -1990,9 +1913,7 @@ static void d_move_locked(struct dentry
 
 void d_move(struct dentry * dentry, struct dentry * target)
 {
-	spin_lock(&dcache_lock);
 	d_move_locked(dentry, target);
-	spin_unlock(&dcache_lock);
 }
 
 /**
@@ -2018,13 +1939,12 @@ struct dentry *d_ancestor(struct dentry
  * This helper attempts to cope with remotely renamed directories
  *
  * It assumes that the caller is already holding
- * dentry->d_parent->d_inode->i_mutex and the dcache_lock
+ * dentry->d_parent->d_inode->i_mutex
  *
  * Note: If ever the locking in lock_rename() changes, then please
  * remember to update this too...
  */
 static struct dentry *__d_unalias(struct dentry *dentry, struct dentry *alias)
-	__releases(dcache_lock)
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
@@ -2051,7 +1971,6 @@ out_unalias:
 	ret = alias;
 out_err:
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	if (m2)
 		mutex_unlock(m2);
 	if (m1)
@@ -2115,7 +2034,6 @@ struct dentry *d_materialise_unique(stru
 
 	BUG_ON(!d_unhashed(dentry));
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 
 	if (!inode) {
@@ -2162,7 +2080,6 @@ found:
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
 		security_d_instantiate(dentry, inode);
@@ -2174,7 +2091,6 @@ out_nolock:
 
 shouldnt_be_hashed:
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	BUG();
 }
 
@@ -2206,8 +2122,7 @@ static int prepend_name(char **buffer, i
  * Returns a pointer into the buffer or an error code if the
  * path was too long.
  *
- * "buflen" should be positive. Caller holds the dcache_lock and
- * path->dentry->d_lock.
+ * "buflen" should be positive. Caller holds the path->dentry->d_lock.
  *
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
@@ -2312,14 +2227,12 @@ char *d_path(const struct path *path, ch
 
 rename_retry:
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	vfsmount_read_lock();
 	spin_lock(&path->dentry->d_lock);
 	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
 	spin_unlock(&path->dentry->d_lock);
 	vfsmount_read_unlock();
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 
@@ -2361,7 +2274,6 @@ rename_retry:
 	end = buf + buflen;
 	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock(); /* protect parent */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
@@ -2386,7 +2298,6 @@ rename_retry:
 	}
 out:
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
@@ -2432,7 +2343,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 
 	error = -ENOENT;
 	/* Has the current directory has been unlinked? */
-	spin_lock(&dcache_lock);
 	vfsmount_read_lock();
 	spin_lock(&pwd.dentry->d_lock);
 	if (IS_ROOT(pwd.dentry) || !d_unhashed(pwd.dentry)) {
@@ -2443,7 +2353,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
 		spin_unlock(&pwd.dentry->d_lock);
 		vfsmount_read_unlock();
-		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
 		if (IS_ERR(cwd))
@@ -2459,7 +2368,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 	} else {
 		spin_unlock(&pwd.dentry->d_lock);
 		vfsmount_read_unlock();
-		spin_unlock(&dcache_lock);
 	}
 
 out:
@@ -2520,7 +2428,6 @@ void d_genocide(struct dentry *root)
 rename_retry:
 	this_parent = root;
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -2561,7 +2468,6 @@ resume:
 		if (this_parent != child->d_parent ||
 				read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -2569,7 +2475,6 @@ resume:
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 }
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -754,14 +754,11 @@ static __always_inline void follow_dotdo
 			break;
 		}
                 read_unlock(&fs->lock);
-		spin_lock(&dcache_lock);
 		if (nd->path.dentry != nd->path.mnt->mnt_root) {
 			nd->path.dentry = dget(nd->path.dentry->d_parent);
-			spin_unlock(&dcache_lock);
 			dput(old);
 			break;
 		}
-		spin_unlock(&dcache_lock);
 		vfsmount_read_lock();
 		parent = nd->path.mnt->mnt_parent;
 		if (parent == nd->path.mnt) {
@@ -2114,12 +2111,10 @@ void dentry_unhash(struct dentry *dentry
 {
 	dget(dentry);
 	shrink_dcache_parent(dentry);
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (dentry->d_count == 2)
 		__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
Index: linux-2.6/fs/seq_file.c
===================================================================
--- linux-2.6.orig/fs/seq_file.c
+++ linux-2.6/fs/seq_file.c
@@ -463,11 +463,9 @@ int seq_path_root(struct seq_file *m, st
 
 rename_retry:
 		seq = read_seqbegin(&rename_lock);
-		spin_lock(&dcache_lock);
 		vfsmount_read_lock();
 		p = __d_path(path, root, s, m->size - m->count);
 		vfsmount_read_unlock();
-		spin_unlock(&dcache_lock);
 		if (read_seqretry(&rename_lock, seq))
 			goto rename_retry;
 
Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -547,7 +547,6 @@ static void sysfs_drop_dentry(struct sys
 	 * dput to immediately free the dentry  if it is not in use.
 	 */
 repeat:
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
@@ -559,12 +558,10 @@ repeat:
 		__d_drop(dentry);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		dput(dentry);
 		goto repeat;
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	/* adjust nlink and update timestamp */
 	mutex_lock(&inode->i_mutex);
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -150,13 +150,13 @@ struct dentry_operations {
 
 /*
 locking rules:
-		big lock	dcache_lock	d_lock   may block
-d_revalidate:	no		no		no       yes
-d_hash		no		no		no       yes
-d_compare:	no		yes		yes      no
-d_delete:	no		yes		no       no
-d_release:	no		no		no       yes
-d_iput:		no		no		no       yes
+		big lock	d_lock   may block
+d_revalidate:	no		no       yes
+d_hash		no		no       yes
+d_compare:	no		yes      no
+d_delete:	no		no       no
+d_release:	no		no       yes
+d_iput:		no		no       yes
  */
 
 /* d_flags entries */
@@ -186,7 +186,6 @@ d_iput:		no		no		no       yes
 
 extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
-extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
 
 /**
@@ -217,11 +216,9 @@ static inline void __d_drop(struct dentr
 
 static inline void d_drop(struct dentry *dentry)
 {
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
  	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 static inline int dname_external(struct dentry *dentry)
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -184,7 +184,6 @@ static void set_dentry_child_flags(struc
 {
 	struct dentry *alias;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
@@ -204,7 +203,6 @@ static void set_dentry_child_flags(struc
 		spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -272,6 +270,7 @@ void inotify_d_instantiate(struct dentry
 	if (!inode)
 		return;
 
+	/* XXX: need parent lock in place of dcache_lock? */
 	spin_lock(&entry->d_lock);
 	parent = entry->d_parent;
 	if (parent->d_inode && inotify_inode_watched(parent->d_inode))
@@ -286,6 +285,7 @@ void inotify_d_move(struct dentry *entry
 {
 	struct dentry *parent;
 
+	/* XXX: need parent lock in place of dcache_lock? */
 	parent = entry->d_parent;
 	if (inotify_inode_watched(parent->d_inode))
 		entry->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c
+++ linux-2.6/fs/exportfs/expfs.c
@@ -47,24 +47,20 @@ find_acceptable_alias(struct dentry *res
 	if (acceptable(context, result))
 		return result;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
 		dget_locked(dentry);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		if (toput)
 			dput(toput);
 		if (dentry != result && acceptable(context, dentry)) {
 			dput(result);
 			return dentry;
 		}
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 		toput = dentry;
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	if (toput)
 		dput(toput);
Index: linux-2.6/Documentation/filesystems/Locking
===================================================================
--- linux-2.6.orig/Documentation/filesystems/Locking
+++ linux-2.6/Documentation/filesystems/Locking
@@ -17,7 +17,7 @@ prototypes:
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
 
-locking rules:
+locking rules: XXX: update these!!
 	none have BKL
 		dcache_lock	rename_lock	->d_lock	may block
 d_revalidate:	no		no		no		yes
Index: linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/inode.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/inode.c
@@ -158,21 +158,18 @@ static void spufs_prune_dir(struct dentr
 
 	mutex_lock(&dir->d_inode->i_mutex);
 	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
 			dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
-			/* XXX: what is dcache_lock protecting here? Other
+			/* XXX: what was dcache_lock protecting here? Other
 			 * filesystems (IB, configfs) release dcache_lock
 			 * before unlink */
-			spin_unlock(&dcache_lock);
 			dput(dentry);
 		} else {
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 		}
 	}
 	shrink_dcache_parent(dir);
Index: linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ipath/ipath_fs.c
+++ linux-2.6/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -272,18 +272,14 @@ static int remove_file(struct dentry *pa
 		goto bail;
 	}
 
-	spin_lock(&dcache_lock);
 	spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_locked_dlock(tmp);
 		__d_drop(tmp);
 		spin_unlock(&tmp->d_lock);
-		spin_unlock(&dcache_lock);
 		simple_unlink(parent->d_inode, tmp);
-	} else {
+	} else
 		spin_unlock(&tmp->d_lock);
-		spin_unlock(&dcache_lock);
-	}
 
 	ret = 0;
 bail:
Index: linux-2.6/drivers/usb/core/inode.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/inode.c
+++ linux-2.6/drivers/usb/core/inode.c
@@ -343,18 +343,15 @@ static int usbfs_empty (struct dentry *d
 {
 	struct list_head *list;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	list_for_each(list, &dentry->d_subdirs) {
 		struct dentry *de = list_entry(list, struct dentry, d_u.d_child);
 		if (usbfs_positive(de)) {
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			return 0;
 		}
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 	return 1;
 }
Index: linux-2.6/fs/affs/amigaffs.c
===================================================================
--- linux-2.6.orig/fs/affs/amigaffs.c
+++ linux-2.6/fs/affs/amigaffs.c
@@ -128,7 +128,6 @@ affs_fix_dcache(struct dentry *dentry, u
 	void *data = dentry->d_fsdata;
 	struct list_head *head, *next;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	head = &inode->i_dentry;
 	next = head->next;
@@ -141,7 +140,6 @@ affs_fix_dcache(struct dentry *dentry, u
 		next = next->next;
 	}
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 }
 
 
Index: linux-2.6/fs/autofs4/expire.c
===================================================================
--- linux-2.6.orig/fs/autofs4/expire.c
+++ linux-2.6/fs/autofs4/expire.c
@@ -104,7 +104,6 @@ static struct dentry *get_next_positive_
 	struct list_head *next;
 	struct dentry *ret;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&p->d_lock);
 again:
 	next = p->d_subdirs.next;
@@ -122,9 +121,7 @@ again:
 				dget_dlock(p);
 				spin_unlock(&p->d_lock);
 				parent = dget_parent(p);
-				spin_unlock(&dcache_lock);
 				dput(p);
-				spin_lock(&dcache_lock);
 				spin_lock(&parent->d_lock);
 			} else
 				spin_unlock(&p->d_lock);
@@ -146,8 +143,6 @@ again:
 	dget_dlock(ret);
 	spin_unlock(&ret->d_lock);
 
-	spin_unlock(&dcache_lock);
-
 	return ret;
 }
 
@@ -337,7 +332,6 @@ struct dentry *autofs4_expire_indirect(s
 	now = jiffies;
 	timeout = sbi->exp_timeout;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&root->d_lock);
 	next = root->d_subdirs.next;
 
@@ -354,7 +348,6 @@ struct dentry *autofs4_expire_indirect(s
 
 		dentry = dget(dentry);
 		spin_unlock(&root->d_lock);
-		spin_unlock(&dcache_lock);
 
 		spin_lock(&sbi->fs_lock);
 		ino = autofs4_dentry_ino(dentry);
@@ -419,12 +412,10 @@ struct dentry *autofs4_expire_indirect(s
 next:
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
-		spin_lock(&dcache_lock);
 		spin_lock(&root->d_lock);
 		next = next->next;
 	}
 	spin_unlock(&root->d_lock);
-	spin_unlock(&dcache_lock);
 	return NULL;
 
 found:
@@ -434,11 +425,9 @@ found:
 	ino->flags |= AUTOFS_INF_EXPIRING;
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
-	spin_lock(&dcache_lock);
 	spin_lock(&expired->d_parent->d_lock);
 	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
 	spin_unlock(&expired->d_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	return expired;
 }
 
Index: linux-2.6/fs/autofs4/inode.c
===================================================================
--- linux-2.6.orig/fs/autofs4/inode.c
+++ linux-2.6/fs/autofs4/inode.c
@@ -109,7 +109,6 @@ static void autofs4_force_release(struct
 	if (!sbi->sb->s_root)
 		return;
 
-	spin_lock(&dcache_lock);
 repeat:
 	spin_lock(&this_parent->d_lock);
 	next = this_parent->d_subdirs.next;
@@ -130,13 +129,11 @@ resume:
 
 		next = next->next;
 		spin_unlock(&this_parent->d_lock);
-		spin_unlock(&dcache_lock);
 
 		DPRINTK("dentry %p %.*s",
 			dentry, (int)dentry->d_name.len, dentry->d_name.name);
 
 		dput(dentry);
-		spin_lock(&dcache_lock);
 	}
 
 	if (this_parent != sbi->sb->s_root) {
@@ -145,15 +142,12 @@ resume:
 		next = this_parent->d_u.d_child.next;
 		spin_unlock(&this_parent->d_lock);
 		this_parent = this_parent->d_parent;
-		spin_unlock(&dcache_lock);
 		DPRINTK("parent dentry %p %.*s",
 			dentry, (int)dentry->d_name.len, dentry->d_name.name);
 		dput(dentry);
-		spin_lock(&dcache_lock);
 		spin_lock(&this_parent->d_lock);
 		goto resume;
 	}
-	spin_unlock(&dcache_lock);
 	spin_unlock(&this_parent->d_lock);
 }
 
Index: linux-2.6/fs/autofs4/root.c
===================================================================
--- linux-2.6.orig/fs/autofs4/root.c
+++ linux-2.6/fs/autofs4/root.c
@@ -92,15 +92,12 @@ static int autofs4_dir_open(struct inode
 	 * autofs file system so just let the libfs routines handle
 	 * it.
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (!d_mountpoint(dentry) && __simple_empty(dentry)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		return -ENOENT;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 out:
 	return dcache_dir_open(inode, file);
@@ -214,12 +211,10 @@ static void *autofs4_follow_link(struct
 	 * multi-mount with no root mount offset. So don't try to
 	 * mount it again.
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
 	    (!d_mountpoint(dentry) && __simple_empty(dentry))) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 
 		status = try_to_fill_dentry(dentry, 0);
 		if (status)
@@ -228,7 +223,6 @@ static void *autofs4_follow_link(struct
 		goto follow;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 follow:
 	/*
 	 * If there is no root mount it must be an autofs
@@ -299,13 +293,11 @@ static int autofs4_revalidate(struct den
 		return 0;
 
 	/* Check for a non-mountpoint directory with no contents */
-	spin_lock(&dcache_lock);
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
 	    !d_mountpoint(dentry) && 
 	    __simple_empty(dentry)) {
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
-		spin_unlock(&dcache_lock);
 
 		/* The daemon never causes a mount to trigger */
 		if (oz_mode)
@@ -321,7 +313,6 @@ static int autofs4_revalidate(struct den
 
 		return status;
 	}
-	spin_unlock(&dcache_lock);
 
 	return 1;
 }
@@ -373,7 +364,6 @@ static struct dentry *autofs4_lookup_act
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->active_list;
 	list_for_each(p, head) {
@@ -406,14 +396,12 @@ static struct dentry *autofs4_lookup_act
 			dget_locked_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&sbi->lookup_lock);
-			spin_unlock(&dcache_lock);
 			return dentry;
 		}
 next:
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&dcache_lock);
 
 	return NULL;
 }
@@ -425,7 +413,6 @@ static struct dentry *autofs4_lookup_exp
 	const unsigned char *str = name->name;
 	struct list_head *p, *head;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&sbi->lookup_lock);
 	head = &sbi->expiring_list;
 	list_for_each(p, head) {
@@ -458,14 +445,12 @@ static struct dentry *autofs4_lookup_exp
 			dget_locked_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&sbi->lookup_lock);
-			spin_unlock(&dcache_lock);
 			return dentry;
 		}
 next:
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
-	spin_unlock(&dcache_lock);
 
 	return NULL;
 }
@@ -711,7 +696,6 @@ static int autofs4_dir_unlink(struct ino
 
 	dir->i_mtime = CURRENT_TIME;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&sbi->lookup_lock);
 	if (list_empty(&ino->expiring))
 		list_add(&ino->expiring, &sbi->expiring_list);
@@ -719,7 +703,6 @@ static int autofs4_dir_unlink(struct ino
 	spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 	return 0;
 }
@@ -736,11 +719,9 @@ static int autofs4_dir_rmdir(struct inod
 	if (!autofs4_oz_mode(sbi))
 		return -EACCES;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (!list_empty(&dentry->d_subdirs)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		return -ENOTEMPTY;
 	}
 	spin_lock(&sbi->lookup_lock);
@@ -749,7 +730,6 @@ static int autofs4_dir_rmdir(struct inod
 	spin_unlock(&sbi->lookup_lock);
 	__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 	if (atomic_dec_and_test(&ino->count)) {
 		p_ino = autofs4_dentry_ino(dentry->d_parent);
Index: linux-2.6/fs/coda/cache.c
===================================================================
--- linux-2.6.orig/fs/coda/cache.c
+++ linux-2.6/fs/coda/cache.c
@@ -86,7 +86,6 @@ static void coda_flag_children(struct de
 	struct list_head *child;
 	struct dentry *de;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	list_for_each(child, &parent->d_subdirs)
 	{
@@ -97,7 +96,6 @@ static void coda_flag_children(struct de
 		coda_flag_inode(de->d_inode, flag);
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	return; 
 }
 
Index: linux-2.6/fs/configfs/configfs_internal.h
===================================================================
--- linux-2.6.orig/fs/configfs/configfs_internal.h
+++ linux-2.6/fs/configfs/configfs_internal.h
@@ -117,7 +117,6 @@ static inline struct config_item *config
 {
 	struct config_item * item = NULL;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (!d_unhashed(dentry)) {
 		struct configfs_dirent * sd = dentry->d_fsdata;
@@ -128,7 +127,6 @@ static inline struct config_item *config
 			item = config_item_get(sd->s_element);
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 
 	return item;
 }
Index: linux-2.6/fs/configfs/inode.c
===================================================================
--- linux-2.6.orig/fs/configfs/inode.c
+++ linux-2.6/fs/configfs/inode.c
@@ -215,18 +215,14 @@ void configfs_drop_dentry(struct configf
 	struct dentry * dentry = sd->s_dentry;
 
 	if (dentry) {
-		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
 			dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			simple_unlink(parent->d_inode, dentry);
-		} else {
+		} else
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
-		}
 	}
 }
 
Index: linux-2.6/fs/ncpfs/dir.c
===================================================================
--- linux-2.6.orig/fs/ncpfs/dir.c
+++ linux-2.6/fs/ncpfs/dir.c
@@ -364,7 +364,6 @@ ncp_dget_fpos(struct dentry *dentry, str
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -375,13 +374,11 @@ ncp_dget_fpos(struct dentry *dentry, str
 			else
 				dent = NULL;
 			spin_unlock(&parent->d_lock);
-			spin_unlock(&dcache_lock);
 			goto out;
 		}
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	return NULL;
 
 out:
Index: linux-2.6/fs/ncpfs/ncplib_kernel.h
===================================================================
--- linux-2.6.orig/fs/ncpfs/ncplib_kernel.h
+++ linux-2.6/fs/ncpfs/ncplib_kernel.h
@@ -192,7 +192,6 @@ ncp_renew_dentries(struct dentry *parent
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -206,7 +205,6 @@ ncp_renew_dentries(struct dentry *parent
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 static inline void
@@ -216,7 +214,6 @@ ncp_invalidate_dircache_entries(struct d
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -226,7 +223,6 @@ ncp_invalidate_dircache_entries(struct d
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 struct ncp_cache_head {
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c
+++ linux-2.6/fs/nfs/dir.c
@@ -1433,11 +1433,9 @@ static int nfs_unlink(struct inode *dir,
 	dfprintk(VFS, "NFS: unlink(%s/%ld, %s)\n", dir->i_sb->s_id,
 		dir->i_ino, dentry->d_name.name);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	if (dentry->d_count > 1) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		/* Start asynchronous writeout of the inode */
 		write_inode_now(dentry->d_inode, 0);
 		error = nfs_sillyrename(dir, dentry);
@@ -1448,7 +1446,6 @@ static int nfs_unlink(struct inode *dir,
 		need_rehash = 1;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	error = nfs_safe_remove(dentry);
 	if (!error || error == -ENOENT) {
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c
+++ linux-2.6/fs/ocfs2/dcache.c
@@ -140,7 +140,6 @@ struct dentry *ocfs2_find_local_alias(st
 	struct list_head *p;
 	struct dentry *dentry = NULL;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
@@ -160,7 +159,6 @@ struct dentry *ocfs2_find_local_alias(st
 	}
 
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	return dentry;
 }
Index: linux-2.6/fs/smbfs/cache.c
===================================================================
--- linux-2.6.orig/fs/smbfs/cache.c
+++ linux-2.6/fs/smbfs/cache.c
@@ -62,7 +62,6 @@ smb_invalidate_dircache_entries(struct d
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -72,7 +71,6 @@ smb_invalidate_dircache_entries(struct d
 		next = next->next;
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -98,7 +96,6 @@ smb_dget_fpos(struct dentry *dentry, str
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
@@ -115,7 +112,6 @@ smb_dget_fpos(struct dentry *dentry, str
 	dent = NULL;
 out_unlock:
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	return dent;
 }
 
Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -693,7 +693,6 @@ static void cgroup_clear_directory(struc
 	struct list_head *node;
 
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	node = dentry->d_subdirs.next;
 	while (node != &dentry->d_subdirs) {
@@ -708,18 +707,15 @@ static void cgroup_clear_directory(struc
 			dget_locked_dlock(d);
 			spin_unlock(&d->d_lock);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 			d_delete(d);
 			simple_unlink(dentry->d_inode, d);
 			dput(d);
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 		} else
 			spin_unlock(&d->d_lock);
 		node = dentry->d_subdirs.next;
 	}
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /*
@@ -731,14 +727,12 @@ static void cgroup_d_remove_dir(struct d
 
 	cgroup_clear_directory(dentry);
 
-	spin_lock(&dcache_lock);
 	parent = dentry->d_parent;
 	spin_lock(&parent->d_lock);
 	spin_lock(&dentry->d_lock);
 	list_del_init(&dentry->d_u.d_child);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	remove_dir(dentry);
 }
 
Index: linux-2.6/net/sunrpc/rpc_pipe.c
===================================================================
--- linux-2.6.orig/net/sunrpc/rpc_pipe.c
+++ linux-2.6/net/sunrpc/rpc_pipe.c
@@ -547,15 +547,14 @@ static void rpc_depopulate(struct dentry
 
 	mutex_lock_nested(&dir->i_mutex, I_MUTEX_CHILD);
 repeat:
-	spin_lock(&dcache_lock);
 	spin_lock(&parent->d_lock);
 	list_for_each_safe(pos, next, &parent->d_subdirs) {
 		dentry = list_entry(pos, struct dentry, d_u.d_child);
+		spin_lock(&dentry->d_lock);
 		if (!dentry->d_inode ||
 				dentry->d_inode->i_ino < start ||
 				dentry->d_inode->i_ino >= eof)
-			continue;
-		spin_lock(&dentry->d_lock);
+			goto next;
 		if (!d_unhashed(dentry)) {
 			dget_locked_dlock(dentry);
 			__d_drop(dentry);
@@ -563,11 +562,11 @@ repeat:
 			dvec[n++] = dentry;
 			if (n == ARRAY_SIZE(dvec))
 				break;
-		} else
-			spin_unlock(&dentry->d_lock);
+		}
+next:
+		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (n) {
 		do {
 			dentry = dvec[--n];
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c
+++ linux-2.6/security/selinux/selinuxfs.c
@@ -947,7 +947,6 @@ static void sel_remove_entries(struct de
 {
 	struct list_head *node;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&de->d_lock);
 	node = de->d_subdirs.next;
 	while (node != &de->d_subdirs) {
@@ -960,11 +959,9 @@ static void sel_remove_entries(struct de
 			dget_locked_dlock(d);
 			spin_unlock(&de->d_lock);
 			spin_unlock(&d->d_lock);
-			spin_unlock(&dcache_lock);
 			d_delete(d);
 			simple_unlink(de->d_inode, d);
 			dput(d);
-			spin_lock(&dcache_lock);
 			spin_lock(&de->d_lock);
 		} else
 			spin_unlock(&d->d_lock);
@@ -972,7 +969,6 @@ static void sel_remove_entries(struct de
 	}
 
 	spin_unlock(&de->d_lock);
-	spin_unlock(&dcache_lock);
 }
 
 #define BOOL_DIR_NAME "booleans"
Index: linux-2.6/security/tomoyo/realpath.c
===================================================================
--- linux-2.6.orig/security/tomoyo/realpath.c
+++ linux-2.6/security/tomoyo/realpath.c
@@ -102,10 +102,8 @@ int tomoyo_realpath_from_path2(struct pa
 		if (ns_root.mnt)
 			ns_root.dentry = dget(ns_root.mnt->mnt_root);
 		vfsmount_read_unlock();
-		spin_lock(&dcache_lock);
 		tmp = ns_root;
 		sp = __d_path(path, &tmp, newname, newname_len);
-		spin_unlock(&dcache_lock);
 		path_put(&root);
 		path_put(&ns_root);
 	}
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c
+++ linux-2.6/fs/nfs/getroot.c
@@ -65,13 +65,11 @@ static int nfs_superblock_set_dummy_root
 		 * This again causes shrink_dcache_for_umount_subtree() to
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
-		spin_lock(&dcache_lock);
 		spin_lock(&dcache_inode_lock);
 		spin_lock(&sb->s_root->d_lock);
 		list_del_init(&sb->s_root->d_alias);
 		spin_unlock(&sb->s_root->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 	}
 	return 0;
 }
Index: linux-2.6/drivers/staging/pohmelfs/path_entry.c
===================================================================
--- linux-2.6.orig/drivers/staging/pohmelfs/path_entry.c
+++ linux-2.6/drivers/staging/pohmelfs/path_entry.c
@@ -100,7 +100,6 @@ int pohmelfs_path_length(struct pohmelfs
 	rcu_read_lock();
 rename_retry:
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 
 	if (!IS_ROOT(d) && d_unhashed(d))
 		len += UNHASHED_OBSCURE_STRING_SIZE; /* Obscure " (deleted)" string */
@@ -109,7 +108,6 @@ rename_retry:
 		len += d->d_name.len + 1; /* Plus slash */
 		d = d->d_parent;
 	}
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	rcu_read_unlock();
Index: linux-2.6/fs/autofs4/waitq.c
===================================================================
--- linux-2.6.orig/fs/autofs4/waitq.c
+++ linux-2.6/fs/autofs4/waitq.c
@@ -194,12 +194,10 @@ static int autofs4_getpath(struct autofs
 	rcu_read_lock();
 rename_retry:
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	for (tmp = dentry ; tmp != root ; tmp = tmp->d_parent)
 		len += tmp->d_name.len + 1;
 
 	if (!len || --len > NAME_MAX) {
-		spin_unlock(&dcache_lock);
 		if (read_seqretry(&rename_lock, seq))
 			goto rename_retry;
 		rcu_read_unlock();
@@ -215,7 +213,6 @@ rename_retry:
 		p -= tmp->d_name.len;
 		strncpy(p, tmp->d_name.name, tmp->d_name.len);
 	}
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	rcu_read_unlock();
Index: linux-2.6/fs/nfs/namespace.c
===================================================================
--- linux-2.6.orig/fs/nfs/namespace.c
+++ linux-2.6/fs/nfs/namespace.c
@@ -57,7 +57,6 @@ char *nfs_path(const char *base,
 	rcu_read_lock();
 rename_retry:
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	while (!IS_ROOT(dentry) && dentry != droot) {
 		namelen = dentry->d_name.len;
 		buflen -= namelen + 1;
@@ -68,7 +67,6 @@ rename_retry:
 		*--end = '/';
 		dentry = dentry->d_parent;
 	}
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	rcu_read_unlock();
@@ -83,7 +81,6 @@ rename_retry:
 	memcpy(end, base, namelen);
 	return end;
 Elong_unlock:
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	rcu_read_unlock();


