Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbZC2QkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbZC2QkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZC2Qhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:37:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZC2Qha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:30 -0400
Message-Id: <20090329155749.760003572@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:49 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 10/14] fs: dcache remove dcache_lock
References: <20090329155539.275927173@nick.local0.net>
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
 fs/dcache.c                 |  134 ++++++--------------------------------------
 fs/libfs.c                  |    8 --
 fs/namei.c                  |    5 -
 fs/notify/inotify/inotify.c |    2 
 fs/seq_file.c               |    2 
 fs/sysfs/dir.c              |    3 
 include/linux/dcache.h      |   17 ++---
 7 files changed, 26 insertions(+), 145 deletions(-)

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
@@ -130,7 +127,6 @@ static void d_free(struct dentry *dentry
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
 	__releases(dcache_inode_lock)
-	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
@@ -138,7 +134,6 @@ static void dentry_iput(struct dentry *
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
@@ -148,7 +143,6 @@ static void dentry_iput(struct dentry *
 	} else {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 	}
 }
 
@@ -214,13 +208,12 @@ static void dentry_lru_del_init(struct d
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
 
@@ -277,21 +270,10 @@ repeat:
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
@@ -305,7 +287,6 @@ drop2:
 	dentry->d_count--;
 	if (dentry->d_count) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		return;
 	}
 
@@ -327,7 +308,6 @@ drop2:
 	if (parent)
 		spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	return;
 
 unhash_it:
@@ -357,11 +337,9 @@ int d_invalidate(struct dentry * dentry)
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
@@ -370,9 +348,7 @@ int d_invalidate(struct dentry * dentry)
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
 		shrink_dcache_parent(dentry);
-		spin_lock(&dcache_lock);
 	}
 
 	/*
@@ -389,18 +365,15 @@ int d_invalidate(struct dentry * dentry)
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
 
-/* This should be called _only_ with dcache_lock held */
 static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
 {
 	dentry->d_count++;
@@ -478,11 +451,9 @@ struct dentry * d_find_alias(struct inod
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
@@ -495,7 +466,6 @@ void d_prune_aliases(struct inode *inode
 {
 	struct dentry *dentry;
 restart:
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
@@ -504,14 +474,12 @@ restart:
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
@@ -524,20 +492,16 @@ restart:
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
@@ -554,7 +518,6 @@ again:
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_inode_lock);
-			spin_unlock(&dcache_lock);
 			return;
 		}
 
@@ -623,7 +586,6 @@ restart:
 	}
 	spin_unlock(&dcache_lru_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 again:
 	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
@@ -654,14 +616,13 @@ again1:
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
@@ -691,7 +652,6 @@ static void prune_dcache(int count)
 
 	if (unused == 0 || count == 0)
 		return;
-	spin_lock(&dcache_lock);
 restart:
 	if (count >= unused)
 		prune_ratio = 1;
@@ -727,11 +687,9 @@ restart:
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
@@ -747,7 +705,6 @@ restart:
 		}
 	}
 	spin_unlock(&sb_lock);
-	spin_unlock(&dcache_lock);
 }
 
 /**
@@ -776,12 +733,10 @@ static void shrink_dcache_for_umount_sub
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
@@ -790,7 +745,6 @@ static void shrink_dcache_for_umount_sub
 
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
@@ -800,7 +754,6 @@ static void shrink_dcache_for_umount_sub
 				spin_unlock(&loop->d_lock);
 			}
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 
 			/* move to the first child */
 			dentry = list_entry(dentry->d_subdirs.next,
@@ -871,8 +824,7 @@ out:
 
 /*
  * destroy the dentries attached to a superblock on unmounting
- * - we don't need to use dentry->d_lock, and only need dcache_lock when
- *   removing the dentry from the system lists and hashes because:
+ * - we don't need to use dentry->d_lock because:
  *   - the superblock is detached from all mountings and open files, so the
  *     dentry trees will not be rearranged by the VFS
  *   - s_umount is write-locked, so the memory pressure shrinker will ignore
@@ -923,7 +875,6 @@ rename_retry:
 	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
 
-	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
 		goto positive;
 	spin_lock(&this_parent->d_lock);
@@ -965,7 +916,6 @@ resume:
 		 * or deletion */
 		if (d_unhashed(this_parent) || read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -973,12 +923,10 @@ resume:
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
@@ -1009,7 +957,6 @@ rename_retry:
 	this_parent = parent;
 	seq = read_seqbegin(&rename_lock);
 
-	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -1072,7 +1019,6 @@ resume:
 				(/* d_unhashed(this_parent) XXX: hmm... */ 0 ||
 				read_seqretry(&rename_lock, seq))) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -1081,7 +1027,6 @@ resume:
 	}
 out:
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	return found;
@@ -1181,7 +1126,6 @@ struct dentry *d_alloc(struct dentry * p
 	INIT_LIST_HEAD(&dentry->d_u.d_child);
 
 	if (parent) {
-		spin_lock(&dcache_lock);
 		spin_lock(&parent->d_lock);
 		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		dentry->d_parent = dget_dlock(parent);
@@ -1189,7 +1133,6 @@ struct dentry *d_alloc(struct dentry * p
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_lock);
 	}
 
 	atomic_inc(&dentry_stat.nr_dentry);
@@ -1207,7 +1150,6 @@ struct dentry *d_alloc_name(struct dentr
 	return d_alloc(parent, &q);
 }
 
-/* the caller must hold dcache_lock */
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
 	if (inode)
@@ -1234,11 +1176,9 @@ static void __d_instantiate(struct dentr
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
 
@@ -1296,11 +1236,9 @@ struct dentry *d_instantiate_unique(stru
 
 	BUG_ON(!list_empty(&entry->d_alias));
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	result = __d_instantiate_unique(entry, inode);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	if (!result) {
 		security_d_instantiate(entry, inode);
@@ -1388,12 +1326,10 @@ struct dentry *d_obtain_alias(struct ino
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
@@ -1409,7 +1345,6 @@ struct dentry *d_obtain_alias(struct ino
 	spin_unlock(&tmp->d_lock);
 	spin_unlock(&dcache_inode_lock);
 
-	spin_unlock(&dcache_lock);
 	return tmp;
 
  out_iput:
@@ -1439,22 +1374,19 @@ struct dentry *d_splice_alias(struct ino
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
@@ -1529,17 +1461,15 @@ struct dentry *d_add_ci(struct dentry *d
 		d_instantiate(found, inode);
 		return found;
 	}
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	if (list_empty(&inode->i_dentry)) {
 		/*
 		 * Directory without a 'disconnected' dentry; we need to do
-		 * d_instantiate() by hand because it takes dcache_lock which
+		 * d_instantiate() by hand because it takes dcache_inode_lock which
 		 * we already hold.
 		 */
 		__d_instantiate(found, inode);
 		spin_unlock(&dcache_inode_lock);
-		spin_unlock(&dcache_lock);
 		security_d_instantiate(found, inode);
 		return found;
 	}
@@ -1550,7 +1480,6 @@ struct dentry *d_add_ci(struct dentry *d
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	/* Do security vodoo. */
 	security_d_instantiate(found, inode);
 	/* Move new in place of found. */
@@ -1577,7 +1506,7 @@ err_out:
  * is returned. The caller must use dput to free the entry when it has
  * finished using it. %NULL is returned on failure.
  *
- * __d_lookup is dcache_lock free. The hash list is protected using RCU.
+ * __d_lookup is global lock free. The hash list is protected using RCU.
  * Memory barriers are used while updating and doing lockless traversal. 
  * To avoid races with d_move while rename is happening, d_lock is used.
  *
@@ -1589,7 +1518,7 @@ err_out:
  *
  * The dentry unused LRU is not updated even if lookup finds the required dentry
  * in there. It is updated in places such as prune_dcache, shrink_dcache_sb,
- * select_parent and __dget_locked. This laziness saves lookup from dcache_lock
+ * select_parent and __dget_locked. This laziness saves lookup from LRU lock
  * acquisition.
  *
  * d_lookup() is protected against the concurrent renames in some unrelated
@@ -1719,22 +1648,19 @@ int d_validate(struct dentry *dentry, st
 	if (dentry->d_parent != dparent)
 		goto out;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_hash_lock);
 	base = d_hash(dparent, dentry->d_name.hash);
 	hlist_for_each(lhp,base) { 
 		/* hlist_for_each_entry_rcu() not required for d_hash list
-		 * as it is parsed under dcache_lock
+		 * as it is parsed under dcache_hash_lock
 		 */
 		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
 			spin_unlock(&dcache_hash_lock);
 			__dget_locked(dentry);
-			spin_unlock(&dcache_lock);
 			return 1;
 		}
 	}
 	spin_unlock(&dcache_hash_lock);
-	spin_unlock(&dcache_lock);
 out:
 	return 0;
 }
@@ -1766,7 +1692,6 @@ void d_delete(struct dentry * dentry)
 	/*
 	 * Are we the only user?
 	 */
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
@@ -1781,7 +1706,6 @@ void d_delete(struct dentry * dentry)
 
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -1807,13 +1731,11 @@ static void _d_rehash(struct dentry * en
  
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
@@ -1967,9 +1889,7 @@ static void d_move_locked(struct dentry
 
 void d_move(struct dentry * dentry, struct dentry * target)
 {
-	spin_lock(&dcache_lock);
 	d_move_locked(dentry, target);
-	spin_unlock(&dcache_lock);
 }
 
 /**
@@ -1995,13 +1915,12 @@ struct dentry *d_ancestor(struct dentry
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
@@ -2028,7 +1947,6 @@ out_unalias:
 	ret = alias;
 out_err:
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	if (m2)
 		mutex_unlock(m2);
 	if (m1)
@@ -2092,7 +2010,6 @@ struct dentry *d_materialise_unique(stru
 
 	BUG_ON(!d_unhashed(dentry));
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 
 	if (!inode) {
@@ -2139,7 +2056,6 @@ found:
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
 		security_d_instantiate(dentry, inode);
@@ -2151,7 +2067,6 @@ out_nolock:
 
 shouldnt_be_hashed:
 	spin_unlock(&dcache_inode_lock);
-	spin_unlock(&dcache_lock);
 	BUG();
 }
 
@@ -2183,8 +2098,7 @@ static int prepend_name(char **buffer, i
  * Returns a pointer into the buffer or an error code if the
  * path was too long.
  *
- * "buflen" should be positive. Caller holds the dcache_lock and
- * path->dentry->d_lock.
+ * "buflen" should be positive. Caller holds the path->dentry->d_lock.
  *
  * If path is not reachable from the supplied root, then the value of
  * root is changed (without modifying refcounts).
@@ -2289,14 +2203,12 @@ char *d_path(const struct path *path, ch
 
 rename_retry:
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	spin_lock(&vfsmount_lock);
 	spin_lock(&path->dentry->d_lock);
 	tmp = root;
 	res = __d_path(path, &tmp, buf, buflen);
 	spin_unlock(&path->dentry->d_lock);
 	spin_unlock(&vfsmount_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 
@@ -2338,7 +2250,6 @@ rename_retry:
 	end = buf + buflen;
 	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock(); /* protect parent */
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	prepend(&end, &buflen, "\0", 1);
 	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
@@ -2363,7 +2274,6 @@ rename_retry:
 	}
 out:
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
@@ -2409,7 +2319,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 
 	error = -ENOENT;
 	/* Has the current directory has been unlinked? */
-	spin_lock(&dcache_lock);
 	spin_lock(&vfsmount_lock);
 	spin_lock(&pwd.dentry->d_lock);
 	if (IS_ROOT(pwd.dentry) || !d_unhashed(pwd.dentry)) {
@@ -2420,7 +2329,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
 		spin_unlock(&pwd.dentry->d_lock);
 		spin_unlock(&vfsmount_lock);
-		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
 		if (IS_ERR(cwd))
@@ -2435,7 +2343,6 @@ SYSCALL_DEFINE2(getcwd, char __user *, b
 		}
 	} else {
 		spin_unlock(&pwd.dentry->d_lock);
-		spin_unlock(&dcache_lock);
 	}
 
 out:
@@ -2497,7 +2404,6 @@ void d_genocide(struct dentry *root)
 rename_retry:
 	this_parent = root;
 	seq = read_seqbegin(&rename_lock);
-	spin_lock(&dcache_lock);
 	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
@@ -2533,7 +2439,6 @@ resume:
 		 * or deletion */
 		if (d_unhashed(this_parent) || read_seqretry(&rename_lock, seq)) {
 			spin_unlock(&this_parent->d_lock);
-			spin_unlock(&dcache_lock);
 			rcu_read_unlock();
 			goto rename_retry;
 		}
@@ -2541,7 +2446,6 @@ resume:
 		goto resume;
 	}
 	spin_unlock(&this_parent->d_lock);
-	spin_unlock(&dcache_lock);
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 }
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -101,7 +101,6 @@ loff_t dcache_dir_lseek(struct file *fil
 			struct dentry *cursor = file->private_data;
 			loff_t n = file->f_pos - 2;
 
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 			list_del(&cursor->d_u.d_child);
 			p = dentry->d_subdirs.next;
@@ -116,7 +115,6 @@ loff_t dcache_dir_lseek(struct file *fil
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -159,7 +157,6 @@ int dcache_readdir(struct file * filp, v
 			i++;
 			/* fallthrough */
 		default:
-			spin_lock(&dcache_lock);
 			spin_lock(&dentry->d_lock);
 			if (filp->f_pos == 2)
 				list_move(q, &dentry->d_subdirs);
@@ -175,13 +172,11 @@ int dcache_readdir(struct file * filp, v
 
 				spin_unlock(&next->d_lock);
 				spin_unlock(&dentry->d_lock);
-				spin_unlock(&dcache_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
 					    next->d_inode->i_ino, 
 					    dt_type(next->d_inode)) < 0)
 					return 0;
-				spin_lock(&dcache_lock);
 				spin_lock(&dentry->d_lock);
 				/* next is still alive */
 				list_move(q, p);
@@ -189,7 +184,6 @@ int dcache_readdir(struct file * filp, v
 				filp->f_pos++;
 			}
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_lock);
 	}
 	return 0;
 }
@@ -285,7 +279,6 @@ int simple_empty(struct dentry *dentry)
 	struct dentry *child;
 	int ret = 0;
 
-	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
 		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
@@ -298,7 +291,6 @@ int simple_empty(struct dentry *dentry)
 	ret = 1;
 out:
 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
 	return ret;
 }
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -752,14 +752,11 @@ static __always_inline void follow_dotdo
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
 		spin_lock(&vfsmount_lock);
 		parent = nd->path.mnt->mnt_parent;
 		if (parent == nd->path.mnt) {
@@ -2105,12 +2102,10 @@ void dentry_unhash(struct dentry *dentry
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
 		spin_lock(&vfsmount_lock);
 		p = __d_path(path, root, s, m->size - m->count);
 		spin_unlock(&vfsmount_lock);
-		spin_unlock(&dcache_lock);
 		if (read_seqretry(&rename_lock, seq))
 			goto rename_retry;
 
Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -519,7 +519,6 @@ static void sysfs_drop_dentry(struct sys
 	 * dput to immediately free the dentry  if it is not in use.
 	 */
 repeat:
-	spin_lock(&dcache_lock);
 	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
@@ -531,12 +530,10 @@ repeat:
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


