Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbZC2QlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbZC2QlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZC2Qhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:37:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZC2Qhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:31 -0400
Message-Id: <20090329155750.373059212@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:53 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 14/14] fs: dcache per-inode inode alias locking
References: <20090329155539.275927173@nick.local0.net>
Content-Disposition: inline; filename=dcache-split-inode_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_inode_lock can be replaced with per-inode locking. Use existing
inode->i_lock for this. This is slightly non-trivial because we sometimes
need to find the inode from the dentry, which requires d_inode to be
stabilised (either with refcount or d_lock).

---
 fs/dcache.c                 |  105 +++++++++++++++++++++++++-------------------
 fs/notify/inotify/inotify.c |    4 -
 fs/sysfs/dir.c              |    6 +-
 include/linux/dcache.h      |    1 
 4 files changed, 65 insertions(+), 51 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -36,7 +36,7 @@
 
 /*
  * Usage:
- * dcache_inode_lock protects:
+ * dcache->d_inode->i_lock protects:
  *   - the inode alias lists, d_inode
  * dcache_hash_bucket->lock protects:
  *   - the dcache hash table
@@ -50,7 +50,7 @@
  *   - d_subdirs and children's d_child
  *
  * Ordering:
- * dcache_inode_lock
+ * dcache->d_inode->i_lock
  *   dentry->d_lock
  *     dcache_lru_lock
  *     dcache_hash_bucket->lock
@@ -58,12 +58,9 @@
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
-EXPORT_SYMBOL(dcache_inode_lock);
-
 static struct kmem_cache *dentry_cache __read_mostly;
 
 #define DNAME_INLINE_LEN (sizeof(struct dentry)-offsetof(struct dentry,d_iname))
@@ -137,14 +134,13 @@ static void d_free(struct dentry *dentry
  */
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
-	__releases(dcache_inode_lock)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
 		dentry->d_inode = NULL;
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
 		if (dentry->d_op && dentry->d_op->d_iput)
@@ -153,7 +149,6 @@ static void dentry_iput(struct dentry *
 			iput(inode);
 	} else {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_inode_lock);
 	}
 }
 
@@ -224,7 +219,6 @@ static void dentry_lru_del_init(struct d
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
-	__releases(dcache_inode_lock)
 {
 	struct dentry *parent;
 
@@ -318,6 +312,7 @@ struct dentry * dget_locked_dlock(struct
 void dput(struct dentry *dentry)
 {
 	struct dentry *parent;
+	struct inode *inode;
 
 	if (!dentry)
 		return;
@@ -354,7 +349,9 @@ repeat:
 
 kill_it:
 	spin_unlock(&dentry->d_lock);
-	spin_lock(&dcache_inode_lock);
+	inode = dentry->d_inode;
+	if (inode)
+		spin_lock(&inode->i_lock);
 relock:
 	spin_lock(&dentry->d_lock);
 	parent = dentry->d_parent;
@@ -369,7 +366,8 @@ relock:
 	if (dentry->d_count) {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		if (inode)
+			spin_unlock(&inode->i_lock);
 		printk("elevated d_count\n");
 		return;
 	}
@@ -486,9 +484,9 @@ struct dentry * d_find_alias(struct inod
 	struct dentry *de = NULL;
 
 	if (!list_empty(&inode->i_dentry)) {
-		spin_lock(&dcache_inode_lock);
+		spin_lock(&inode->i_lock);
 		de = __d_find_alias(inode, 0);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 	}
 	return de;
 }
@@ -501,20 +499,20 @@ void d_prune_aliases(struct inode *inode
 {
 	struct dentry *dentry;
 restart:
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_inode_lock);
+			spin_unlock(&inode->i_lock);
 			dput(dentry);
 			goto restart;
 		}
 		spin_unlock(&dentry->d_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 
 /*
@@ -536,8 +534,10 @@ static void prune_one_dentry(struct dent
 	 */
 	while (dentry) {
 		struct dentry *parent = NULL;
+		struct inode *inode = dentry->d_inode;
 
-		spin_lock(&dcache_inode_lock);
+		if (inode)
+			spin_lock(&inode->i_lock);
 again:
 		spin_lock(&dentry->d_lock);
 		if (dentry->d_parent && dentry != dentry->d_parent) {
@@ -552,7 +552,8 @@ again:
 			if (parent)
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_inode_lock);
+			if (inode)
+				spin_unlock(&inode->i_lock);
 			return;
 		}
 
@@ -621,10 +622,11 @@ restart:
 	}
 	spin_unlock(&dcache_lru_lock);
 
-	spin_lock(&dcache_inode_lock);
 again:
 	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
 	while (!list_empty(&tmp)) {
+		struct inode *inode;
+
 		dentry = list_entry(tmp.prev, struct dentry, d_lru);
 
 		if (!spin_trylock(&dentry->d_lock)) {
@@ -642,11 +644,18 @@ again1:
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
+		inode = dentry->d_inode;
+		if (inode && !spin_trylock(&inode->i_lock)) {
+again2:
+			spin_unlock(&dentry->d_lock);
+			goto again1;
+		}
 		if (dentry->d_parent) {
 			BUG_ON(dentry == dentry->d_parent);
 			if (!spin_trylock(&dentry->d_parent->d_lock)) {
-				spin_unlock(&dentry->d_lock);
-				goto again1;
+				if (inode)
+					spin_unlock(&inode->i_lock);
+				goto again2;
 			}
 		}
 		__dentry_lru_del_init(dentry);
@@ -654,10 +663,8 @@ again1:
 
 		prune_one_dentry(dentry);
 		/* dentry->d_lock dropped */
-		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
 
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
@@ -1211,9 +1218,11 @@ static void __d_instantiate(struct dentr
 void d_instantiate(struct dentry *entry, struct inode * inode)
 {
 	BUG_ON(!list_empty(&entry->d_alias));
-	spin_lock(&dcache_inode_lock);
+	if (inode)
+		spin_lock(&inode->i_lock);
 	__d_instantiate(entry, inode);
-	spin_unlock(&dcache_inode_lock);
+	if (inode)
+		spin_unlock(&inode->i_lock);
 	security_d_instantiate(entry, inode);
 }
 
@@ -1271,9 +1280,11 @@ struct dentry *d_instantiate_unique(stru
 
 	BUG_ON(!list_empty(&entry->d_alias));
 
-	spin_lock(&dcache_inode_lock);
+	if (inode)
+		spin_lock(&inode->i_lock);
 	result = __d_instantiate_unique(entry, inode);
-	spin_unlock(&dcache_inode_lock);
+	if (inode)
+		spin_unlock(&inode->i_lock);
 
 	if (!result) {
 		security_d_instantiate(entry, inode);
@@ -1353,10 +1364,10 @@ struct dentry *d_obtain_alias(struct ino
 	}
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	res = __d_find_alias(inode, 0);
 	if (res) {
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		dput(tmp);
 		goto out_iput;
 	}
@@ -1370,7 +1381,7 @@ struct dentry *d_obtain_alias(struct ino
 	list_add(&tmp->d_alias, &inode->i_dentry);
 	hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
 	spin_unlock(&tmp->d_lock);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	return tmp;
 
@@ -1401,19 +1412,19 @@ struct dentry *d_splice_alias(struct ino
 	struct dentry *new = NULL;
 
 	if (inode && S_ISDIR(inode->i_mode)) {
-		spin_lock(&dcache_inode_lock);
+		spin_lock(&inode->i_lock);
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
-			spin_unlock(&dcache_inode_lock);
+			spin_unlock(&inode->i_lock);
 			security_d_instantiate(new, inode);
 			d_rehash(dentry);
 			d_move(new, dentry);
 			iput(inode);
 		} else {
-			/* already taken dcache_inode_lock, d_add() by hand */
+			/* already taken inode->i_lock, d_add() by hand */
 			__d_instantiate(dentry, inode);
-			spin_unlock(&dcache_inode_lock);
+			spin_unlock(&inode->i_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
@@ -1488,15 +1499,15 @@ struct dentry *d_add_ci(struct dentry *d
 		d_instantiate(found, inode);
 		return found;
 	}
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	if (list_empty(&inode->i_dentry)) {
 		/*
 		 * Directory without a 'disconnected' dentry; we need to do
-		 * d_instantiate() by hand because it takes dcache_inode_lock which
+		 * d_instantiate() by hand because it takes inode->i_lock which
 		 * we already hold.
 		 */
 		__d_instantiate(found, inode);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		security_d_instantiate(found, inode);
 		return found;
 	}
@@ -1506,7 +1517,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 	/* Do security vodoo. */
 	security_d_instantiate(found, inode);
 	/* Move new in place of found. */
@@ -1718,15 +1729,17 @@ out:
  
 void d_delete(struct dentry * dentry)
 {
+	struct inode *inode;
 	int isdir = 0;
 	/*
 	 * Are we the only user?
 	 */
 again:
 	spin_lock(&dentry->d_lock);
-	isdir = S_ISDIR(dentry->d_inode->i_mode);
+	inode = dentry->d_inode;
+	isdir = S_ISDIR(inode->i_mode);
 	if (dentry->d_count == 1) {
-		if (!spin_trylock(&dcache_inode_lock)) {
+		if (inode && !spin_trylock(&inode->i_lock)) {
 			spin_unlock(&dentry->d_lock);
 			goto again;
 		}
@@ -1959,6 +1972,7 @@ static struct dentry *__d_unalias(struct
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
+	struct inode *inode;
 
 	/* If alias and dentry share a parent, then no extra locks required */
 	if (alias->d_parent == dentry->d_parent)
@@ -1974,14 +1988,15 @@ static struct dentry *__d_unalias(struct
 	if (!mutex_trylock(&dentry->d_sb->s_vfs_rename_mutex))
 		goto out_err;
 	m1 = &dentry->d_sb->s_vfs_rename_mutex;
-	if (!mutex_trylock(&alias->d_parent->d_inode->i_mutex))
+	inode = alias->d_parent->d_inode;
+	if (!mutex_trylock(&inode->i_mutex))
 		goto out_err;
-	m2 = &alias->d_parent->d_inode->i_mutex;
+	m2 = &inode->i_mutex;
 out_unalias:
 	d_move_locked(alias, dentry);
 	ret = alias;
 out_err:
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 	if (m2)
 		mutex_unlock(m2);
 	if (m1)
@@ -2052,7 +2067,7 @@ struct dentry *d_materialise_unique(stru
 		goto out_nolock;
 	}
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 
 	if (S_ISDIR(inode->i_mode)) {
 		struct dentry *alias;
@@ -2088,7 +2103,7 @@ struct dentry *d_materialise_unique(stru
 found:
 	_d_rehash(actual);
 	spin_unlock(&actual->d_lock);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 out_nolock:
 	if (actual == dentry) {
 		security_d_instantiate(dentry, inode);
Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -519,7 +519,7 @@ static void sysfs_drop_dentry(struct sys
 	 * dput to immediately free the dentry  if it is not in use.
 	 */
 repeat:
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (d_unhashed(dentry)) {
@@ -529,11 +529,11 @@ repeat:
 		dget_locked_dlock(dentry);
 		__d_drop(dentry);
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		dput(dentry);
 		goto repeat;
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	/* adjust nlink and update timestamp */
 	mutex_lock(&inode->i_mutex);
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -184,7 +184,6 @@ d_iput:		no		no       yes
 
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
 
-extern spinlock_t dcache_inode_lock;
 extern seqlock_t rename_lock;
 
 /**
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -184,7 +184,7 @@ static void set_dentry_child_flags(struc
 {
 	struct dentry *alias;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
 
@@ -202,7 +202,7 @@ static void set_dentry_child_flags(struc
 		}
 		spin_unlock(&alias->d_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 
 /*


