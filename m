Return-Path: <linux-kernel-owner+w=401wt.eu-S1760298AbZDYBc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298AbZDYBc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZDYB27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:28:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZDYB2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:50 -0400
Message-Id: <20090425012211.509344338@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:37 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 17/27] fs: dcache per-bucket dcache hash locking
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=dcache-chain-hashlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can turn the dcache hash locking from a global dcache_hash_lock into
per-bucket locking.

XXX: should probably use a bit lock in the first bit of the hash pointers
to avoid any space bloating (non-atomic unlock means no extra atomics either)
---
 fs/dcache.c            |  197 ++++++++++++++++++++++++++++---------------------
 include/linux/dcache.h |   20 ----
 2 files changed, 115 insertions(+), 102 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -38,7 +38,7 @@
  * Usage:
  * dcache_inode_lock protects:
  *   - the inode alias lists, d_inode
- * dcache_hash_lock protects:
+ * dcache_hash_bucket->lock protects:
  *   - the dcache hash table
  * dcache_lru_lock protects:
  *   - the dcache lru lists and counters
@@ -53,18 +53,16 @@
  * dcache_inode_lock
  *   dentry->d_lock
  *     dcache_lru_lock
- *     dcache_hash_lock
+ *     dcache_hash_bucket->lock
  */
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(dcache_inode_lock);
-EXPORT_SYMBOL(dcache_hash_lock);
 
 static struct kmem_cache *dentry_cache __read_mostly;
 
@@ -83,7 +81,12 @@ static struct kmem_cache *dentry_cache _
 
 static unsigned int d_hash_mask __read_mostly;
 static unsigned int d_hash_shift __read_mostly;
-static struct hlist_head *dentry_hashtable __read_mostly;
+
+struct dcache_hash_bucket {
+	spinlock_t lock;
+	struct hlist_head head;
+};
+static struct dcache_hash_bucket *dentry_hashtable __read_mostly;
 
 /* Statistics gathering. */
 struct dentry_stat_t dentry_stat = {
@@ -91,6 +94,14 @@ struct dentry_stat_t dentry_stat = {
 	.age_limit = 45,
 };
 
+static inline struct dcache_hash_bucket *d_hash(struct dentry *parent,
+					unsigned long hash)
+{
+	hash += ((unsigned long) parent ^ GOLDEN_RATIO_PRIME) / L1_CACHE_BYTES;
+	hash = hash ^ ((hash ^ GOLDEN_RATIO_PRIME) >> D_HASHBITS);
+	return dentry_hashtable + (hash & D_HASHMASK);
+}
+
 static void __d_free(struct dentry *dentry)
 {
 	WARN_ON(!list_empty(&dentry->d_alias));
@@ -231,6 +242,73 @@ static struct dentry *d_kill(struct dent
 	return parent;
 }
 
+void __d_drop(struct dentry *dentry)
+{
+	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
+		struct dcache_hash_bucket *b;
+		b = d_hash(dentry->d_parent, dentry->d_name.hash);
+		dentry->d_flags |= DCACHE_UNHASHED;
+		spin_lock(&b->lock);
+		hlist_del_rcu(&dentry->d_hash);
+		spin_unlock(&b->lock);
+	}
+}
+
+void d_drop(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+ 	__d_drop(dentry);
+	spin_unlock(&dentry->d_lock);
+}
+
+/* This should be called _only_ with a lock pinning the dentry */
+static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
+{
+	dentry->d_count++;
+	dentry_lru_del_init(dentry);
+	return dentry;
+}
+
+static inline struct dentry * __dget_locked(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	__dget_locked_dlock(dentry);
+	spin_lock(&dentry->d_lock);
+	return dentry;
+}
+
+struct dentry * dget_locked_dlock(struct dentry *dentry)
+{
+	return __dget_locked_dlock(dentry);
+}
+
+struct dentry * dget_locked(struct dentry *dentry)
+{
+	return __dget_locked(dentry);
+}
+
+struct dentry *dget_parent(struct dentry *dentry)
+{
+	struct dentry *ret;
+
+repeat:
+	spin_lock(&dentry->d_lock);
+	ret = dentry->d_parent;
+	if (!ret)
+		goto out;
+	if (!spin_trylock(&ret->d_lock)) {
+		spin_unlock(&dentry->d_lock);
+		goto repeat;
+	}
+	BUG_ON(!ret->d_count);
+	ret->d_count++;
+	spin_unlock(&ret->d_lock);
+out:
+	spin_unlock(&dentry->d_lock);
+	return ret;
+}
+EXPORT_SYMBOL(dget_parent);
+
 /* 
  * This is dput
  *
@@ -380,54 +458,6 @@ int d_invalidate(struct dentry * dentry)
 	return 0;
 }
 
-/* This should be called _only_ with a lock pinning the dentry */
-static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
-{
-	dentry->d_count++;
-	dentry_lru_del_init(dentry);
-	return dentry;
-}
-
-static inline struct dentry * __dget_locked(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
-	__dget_locked_dlock(dentry);
-	spin_lock(&dentry->d_lock);
-	return dentry;
-}
-
-struct dentry * dget_locked_dlock(struct dentry *dentry)
-{
-	return __dget_locked_dlock(dentry);
-}
-
-struct dentry * dget_locked(struct dentry *dentry)
-{
-	return __dget_locked(dentry);
-}
-
-struct dentry *dget_parent(struct dentry *dentry)
-{
-	struct dentry *ret;
-
-repeat:
-	spin_lock(&dentry->d_lock);
-	ret = dentry->d_parent;
-	if (!ret)
-		goto out;
-	if (!spin_trylock(&ret->d_lock)) {
-		spin_unlock(&dentry->d_lock);
-		goto repeat;
-	}
-	BUG_ON(!ret->d_count);
-	ret->d_count++;
-	spin_unlock(&ret->d_lock);
-out:
-	spin_unlock(&dentry->d_lock);
-	return ret;
-}
-EXPORT_SYMBOL(dget_parent);
-
 /**
  * d_find_alias - grab a hashed alias of inode
  * @inode: inode in question
@@ -1316,14 +1346,6 @@ struct dentry * d_alloc_root(struct inod
 	return res;
 }
 
-static inline struct hlist_head *d_hash(struct dentry *parent,
-					unsigned long hash)
-{
-	hash += ((unsigned long) parent ^ GOLDEN_RATIO_PRIME) / L1_CACHE_BYTES;
-	hash = hash ^ ((hash ^ GOLDEN_RATIO_PRIME) >> D_HASHBITS);
-	return dentry_hashtable + (hash & D_HASHMASK);
-}
-
 /**
  * d_obtain_alias - find or allocate a dentry for a given inode
  * @inode: inode to allocate the dentry for
@@ -1570,7 +1592,8 @@ struct dentry * __d_lookup(struct dentry
 	unsigned int len = name->len;
 	unsigned int hash = name->hash;
 	const unsigned char *str = name->name;
-	struct hlist_head *head = d_hash(parent,hash);
+	struct dcache_hash_bucket *b = d_hash(parent, hash);
+	struct hlist_head *head = &b->head;
 	struct dentry *found = NULL;
 	struct hlist_node *node;
 	struct dentry *dentry;
@@ -1664,6 +1687,7 @@ out:
  
 int d_validate(struct dentry *dentry, struct dentry *dparent)
 {
+	struct dcache_hash_bucket *b;
 	struct hlist_head *base;
 	struct hlist_node *lhp;
 
@@ -1675,20 +1699,21 @@ int d_validate(struct dentry *dentry, st
 		goto out;
 
 	spin_lock(&dentry->d_lock);
-	spin_lock(&dcache_hash_lock);
-	base = d_hash(dparent, dentry->d_name.hash);
-	hlist_for_each(lhp,base) { 
+	b = d_hash(dparent, dentry->d_name.hash);
+	base = &b->head;
+	spin_lock(&b->lock);
+	hlist_for_each(lhp, base) {
 		/* hlist_for_each_entry_rcu() not required for d_hash list
-		 * as it is parsed under dcache_hash_lock
+		 * as it is parsed under dcache_hash_bucket->lock
 		 */
 		if (dentry == hlist_entry(lhp, struct dentry, d_hash)) {
-			spin_unlock(&dcache_hash_lock);
+			spin_unlock(&b->lock);
 			__dget_locked_dlock(dentry);
 			spin_unlock(&dentry->d_lock);
 			return 1;
 		}
 	}
-	spin_unlock(&dcache_hash_lock);
+	spin_unlock(&b->lock);
 	spin_unlock(&dentry->d_lock);
 out:
 	return 0;
@@ -1739,11 +1764,12 @@ void d_delete(struct dentry * dentry)
 	fsnotify_nameremove(dentry, isdir);
 }
 
-static void __d_rehash(struct dentry * entry, struct hlist_head *list)
+static void __d_rehash(struct dentry * entry, struct dcache_hash_bucket *b)
 {
-
  	entry->d_flags &= ~DCACHE_UNHASHED;
- 	hlist_add_head_rcu(&entry->d_hash, list);
+	spin_lock(&b->lock);
+ 	hlist_add_head_rcu(&entry->d_hash, &b->head);
+	spin_unlock(&b->lock);
 }
 
 static void _d_rehash(struct dentry * entry)
@@ -1761,9 +1787,7 @@ static void _d_rehash(struct dentry * en
 void d_rehash(struct dentry * entry)
 {
 	spin_lock(&entry->d_lock);
-	spin_lock(&dcache_hash_lock);
 	_d_rehash(entry);
-	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&entry->d_lock);
 }
 
@@ -1841,6 +1865,7 @@ static void switch_names(struct dentry *
  */
 static void d_move_locked(struct dentry * dentry, struct dentry * target)
 {
+	struct dcache_hash_bucket *b;
 	if (!dentry->d_inode)
 		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
 
@@ -1869,11 +1894,13 @@ static void d_move_locked(struct dentry
 	}
 
 	/* Move the dentry to the target hash queue, if on different bucket */
-	spin_lock(&dcache_hash_lock);
-	if (!d_unhashed(dentry))
+	if (!d_unhashed(dentry)) {
+		b = d_hash(dentry->d_parent, dentry->d_name.hash);
+		spin_lock(&b->lock);
 		hlist_del_rcu(&dentry->d_hash);
+		spin_unlock(&b->lock);
+	}
 	__d_rehash(dentry, d_hash(target->d_parent, target->d_name.hash));
-	spin_unlock(&dcache_hash_lock);
 
 	/* Unhash the target: dput() will then get rid of it */
 	__d_drop(target);
@@ -2080,9 +2107,7 @@ struct dentry *d_materialise_unique(stru
 found_lock:
 	spin_lock(&actual->d_lock);
 found:
-	spin_lock(&dcache_hash_lock);
 	_d_rehash(actual);
-	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
 	spin_unlock(&dcache_inode_lock);
 out_nolock:
@@ -2534,7 +2559,7 @@ static void __init dcache_init_early(voi
 
 	dentry_hashtable =
 		alloc_large_system_hash("Dentry cache",
-					sizeof(struct hlist_head),
+					sizeof(struct dcache_hash_bucket),
 					dhash_entries,
 					13,
 					HASH_EARLY,
@@ -2542,8 +2567,10 @@ static void __init dcache_init_early(voi
 					&d_hash_mask,
 					0);
 
-	for (loop = 0; loop < (1 << d_hash_shift); loop++)
-		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
+	for (loop = 0; loop < (1 << d_hash_shift); loop++) {
+		spin_lock_init(&dentry_hashtable[loop].lock);
+		INIT_HLIST_HEAD(&dentry_hashtable[loop].head);
+	}
 }
 
 static void __init dcache_init(void)
@@ -2566,7 +2593,7 @@ static void __init dcache_init(void)
 
 	dentry_hashtable =
 		alloc_large_system_hash("Dentry cache",
-					sizeof(struct hlist_head),
+					sizeof(struct dcache_hash_bucket),
 					dhash_entries,
 					13,
 					0,
@@ -2574,8 +2601,10 @@ static void __init dcache_init(void)
 					&d_hash_mask,
 					0);
 
-	for (loop = 0; loop < (1 << d_hash_shift); loop++)
-		INIT_HLIST_HEAD(&dentry_hashtable[loop]);
+	for (loop = 0; loop < (1 << d_hash_shift); loop++) {
+		spin_lock_init(&dentry_hashtable[loop].lock);
+		INIT_HLIST_HEAD(&dentry_hashtable[loop].head);
+	}
 }
 
 /* SLAB cache for __getname() consumers */
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -185,7 +185,6 @@ d_iput:		no		no       yes
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
 
 extern spinlock_t dcache_inode_lock;
-extern spinlock_t dcache_hash_lock;
 extern seqlock_t rename_lock;
 
 /**
@@ -203,23 +202,8 @@ extern seqlock_t rename_lock;
  *
  * __d_drop requires dentry->d_lock.
  */
-
-static inline void __d_drop(struct dentry *dentry)
-{
-	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
-		dentry->d_flags |= DCACHE_UNHASHED;
-		spin_lock(&dcache_hash_lock);
-		hlist_del_rcu(&dentry->d_hash);
-		spin_unlock(&dcache_hash_lock);
-	}
-}
-
-static inline void d_drop(struct dentry *dentry)
-{
-	spin_lock(&dentry->d_lock);
- 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
-}
+void d_drop(struct dentry *dentry);
+void __d_drop(struct dentry *dentry);
 
 static inline int dname_external(struct dentry *dentry)
 {


