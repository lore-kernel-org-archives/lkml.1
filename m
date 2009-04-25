Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbZDYBeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbZDYBeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbZDYB3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:44585 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbZDYB2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:53 -0400
Message-Id: <20090425012211.798273449@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:39 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 19/27] fs: dcache per-inode inode alias locking
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=dcache-split-inode_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dcache_inode_lock can be replaced with per-inode locking. Use existing
inode->i_lock for this. This is slightly non-trivial because we sometimes
need to find the inode from the dentry, which requires d_inode to be
stabilised (either with refcount or d_lock).

---
 fs/affs/amigaffs.c          |    4 -
 fs/dcache.c                 |  118 +++++++++++++++++++++++++-------------------
 fs/exportfs/expfs.c         |   12 ++--
 fs/nfs/getroot.c            |    4 -
 fs/notify/inotify/inotify.c |    4 -
 fs/ocfs2/dcache.c           |    4 -
 fs/sysfs/dir.c              |    6 +-
 include/linux/dcache.h      |    1 
 8 files changed, 87 insertions(+), 66 deletions(-)

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
@@ -138,14 +135,13 @@ static void d_free(struct dentry *dentry
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
@@ -154,7 +150,6 @@ static void dentry_iput(struct dentry *
 			iput(inode);
 	} else {
 		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_inode_lock);
 	}
 }
 
@@ -225,7 +220,6 @@ static void dentry_lru_del_init(struct d
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
-	__releases(dcache_inode_lock)
 {
 	struct dentry *parent;
 
@@ -341,6 +335,7 @@ EXPORT_SYMBOL(dget_parent);
 void dput(struct dentry *dentry)
 {
 	struct dentry *parent;
+	struct inode *inode;
 
 	if (!dentry)
 		return;
@@ -376,17 +371,24 @@ repeat:
 	spin_unlock(&dentry->d_lock);
   	return;
 
-kill_it:
-	spin_unlock(&dentry->d_lock);
-	spin_lock(&dcache_inode_lock);
-relock:
+relock1:
 	spin_lock(&dentry->d_lock);
+kill_it:
+	inode = dentry->d_inode;
+	if (inode) {
+		if (!spin_trylock(&inode->i_lock)) {
+relock2:
+			spin_unlock(&dentry->d_lock);
+			goto relock1;
+		}
+	}
 	parent = dentry->d_parent;
 	if (parent) {
 		BUG_ON(parent == dentry);
 		if (!spin_trylock(&parent->d_lock)) {
-			spin_unlock(&dentry->d_lock);
-			goto relock;
+			if (inode)
+				spin_unlock(&inode->i_lock);
+			goto relock2;
 		}
 	}
 	dentry->d_count--;
@@ -394,7 +396,8 @@ relock:
 		/* This case should be fine */
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&parent->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		if (inode)
+			spin_unlock(&inode->i_lock);
 		return;
 	}
 	/* if dentry was on the d_lru list delete it from there */
@@ -510,9 +513,9 @@ struct dentry * d_find_alias(struct inod
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
@@ -525,20 +528,20 @@ void d_prune_aliases(struct inode *inode
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
@@ -560,8 +563,10 @@ static void prune_one_dentry(struct dent
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
@@ -576,7 +581,8 @@ again:
 			if (parent)
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dcache_inode_lock);
+			if (inode)
+				spin_unlock(&inode->i_lock);
 			return;
 		}
 
@@ -645,10 +651,11 @@ restart:
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
@@ -666,11 +673,18 @@ again1:
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
@@ -678,10 +692,8 @@ again1:
 
 		prune_one_dentry(dentry);
 		/* dentry->d_lock dropped */
-		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
-	spin_unlock(&dcache_inode_lock);
 
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
 		goto restart;
@@ -1244,9 +1256,11 @@ static void __d_instantiate(struct dentr
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
 
@@ -1304,9 +1318,11 @@ struct dentry *d_instantiate_unique(stru
 
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
@@ -1386,10 +1402,10 @@ struct dentry *d_obtain_alias(struct ino
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
@@ -1403,7 +1419,7 @@ struct dentry *d_obtain_alias(struct ino
 	list_add(&tmp->d_alias, &inode->i_dentry);
 	hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
 	spin_unlock(&tmp->d_lock);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	return tmp;
 
@@ -1434,19 +1450,19 @@ struct dentry *d_splice_alias(struct ino
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
@@ -1518,10 +1534,10 @@ struct dentry *d_add_ci(struct dentry *d
 	 * Negative dentry: instantiate it unless the inode is a directory and
 	 * already has a dentry.
 	 */
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	if (!S_ISDIR(inode->i_mode) || list_empty(&inode->i_dentry)) {
 		__d_instantiate(found, inode);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		security_d_instantiate(found, inode);
 		return found;
 	}
@@ -1532,7 +1548,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
 	iput(inode);
@@ -1742,15 +1758,17 @@ out:
  
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
@@ -1983,6 +2001,7 @@ static struct dentry *__d_unalias(struct
 {
 	struct mutex *m1 = NULL, *m2 = NULL;
 	struct dentry *ret;
+	struct inode *inode;
 
 	/* If alias and dentry share a parent, then no extra locks required */
 	if (alias->d_parent == dentry->d_parent)
@@ -1998,14 +2017,15 @@ static struct dentry *__d_unalias(struct
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
@@ -2076,7 +2096,7 @@ struct dentry *d_materialise_unique(stru
 		goto out_nolock;
 	}
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 
 	if (S_ISDIR(inode->i_mode)) {
 		struct dentry *alias;
@@ -2112,7 +2132,7 @@ struct dentry *d_materialise_unique(stru
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
@@ -547,7 +547,7 @@ static void sysfs_drop_dentry(struct sys
 	 * dput to immediately free the dentry  if it is not in use.
 	 */
 repeat:
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (d_unhashed(dentry)) {
@@ -557,11 +557,11 @@ repeat:
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
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c
+++ linux-2.6/fs/exportfs/expfs.c
@@ -43,24 +43,26 @@ find_acceptable_alias(struct dentry *res
 		void *context)
 {
 	struct dentry *dentry, *toput = NULL;
+	struct inode *inode;
 
 	if (acceptable(context, result))
 		return result;
 
-	spin_lock(&dcache_inode_lock);
-	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
+	inode = result->d_inode;
+	spin_lock(&inode->i_lock);
+	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		dget_locked(dentry);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&inode->i_lock);
 		if (toput)
 			dput(toput);
 		if (dentry != result && acceptable(context, dentry)) {
 			dput(result);
 			return dentry;
 		}
-		spin_lock(&dcache_inode_lock);
+		spin_lock(&inode->i_lock);
 		toput = dentry;
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	if (toput)
 		dput(toput);
Index: linux-2.6/fs/affs/amigaffs.c
===================================================================
--- linux-2.6.orig/fs/affs/amigaffs.c
+++ linux-2.6/fs/affs/amigaffs.c
@@ -128,7 +128,7 @@ affs_fix_dcache(struct dentry *dentry, u
 	void *data = dentry->d_fsdata;
 	struct list_head *head, *next;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	head = &inode->i_dentry;
 	next = head->next;
 	while (next != head) {
@@ -139,7 +139,7 @@ affs_fix_dcache(struct dentry *dentry, u
 		}
 		next = next->next;
 	}
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 }
 
 
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c
+++ linux-2.6/fs/nfs/getroot.c
@@ -65,11 +65,11 @@ static int nfs_superblock_set_dummy_root
 		 * This again causes shrink_dcache_for_umount_subtree() to
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
-		spin_lock(&dcache_inode_lock);
+		spin_lock(&sb->s_root->d_inode->i_lock);
 		spin_lock(&sb->s_root->d_lock);
 		list_del_init(&sb->s_root->d_alias);
 		spin_unlock(&sb->s_root->d_lock);
-		spin_unlock(&dcache_inode_lock);
+		spin_unlock(&sb->s_root->d_inode->i_lock);
 	}
 	return 0;
 }
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c
+++ linux-2.6/fs/ocfs2/dcache.c
@@ -140,7 +140,7 @@ struct dentry *ocfs2_find_local_alias(st
 	struct list_head *p;
 	struct dentry *dentry = NULL;
 
-	spin_lock(&dcache_inode_lock);
+	spin_lock(&inode->i_lock);
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
 
@@ -158,7 +158,7 @@ struct dentry *ocfs2_find_local_alias(st
 		dentry = NULL;
 	}
 
-	spin_unlock(&dcache_inode_lock);
+	spin_unlock(&inode->i_lock);
 
 	return dentry;
 }


