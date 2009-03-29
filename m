Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbZC2Qma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbZC2Qma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZC2QiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:38:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:52662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZC2Qhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:31 -0400
Message-Id: <20090329155749.455863870@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:47 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 08/14] fs: scale inode alias list
References: <20090329155539.275927173@nick.local0.net>
Content-Disposition: inline; filename=fs-dcache-scale-i_dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, dcache_inode_lock, to protect the inode's i_dentry list
from concurrent modification. d_alias is also protected by d_lock.

---
 fs/dcache.c                 |   56 +++++++++++++++++++++++++++++++++++++++-----
 fs/notify/inotify/inotify.c |    2 +
 fs/sysfs/dir.c              |    3 ++
 include/linux/dcache.h      |    1 
 4 files changed, 56 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -36,6 +36,8 @@
 
 /*
  * Usage:
+ * dcache_inode_lock protects:
+ *   - the inode alias lists, d_inode
  * dcache_hash_lock protects:
  *   - the dcache hash table
  * dcache_lru_lock protects:
@@ -49,18 +51,21 @@
  *
  * Ordering:
  * dcache_lock
- *   dentry->d_lock
- *     dcache_lru_lock
- *     dcache_hash_lock
+ *   dcache_inode_lock
+ *     dentry->d_lock
+ *       dcache_lru_lock
+ *       dcache_hash_lock
  */
 int sysctl_vfs_cache_pressure __read_mostly = 100;
 EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
 
+__cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_inode_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_hash_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lock);
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
+EXPORT_SYMBOL(dcache_inode_lock);
 EXPORT_SYMBOL(dcache_hash_lock);
 EXPORT_SYMBOL(dcache_lock);
 
@@ -124,6 +129,7 @@ static void d_free(struct dentry *dentry
  */
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
+	__releases(dcache_inode_lock)
 	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
@@ -131,6 +137,7 @@ static void dentry_iput(struct dentry *
 		dentry->d_inode = NULL;
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
@@ -140,6 +147,7 @@ static void dentry_iput(struct dentry *
 			iput(inode);
 	} else {
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 	}
 }
@@ -211,6 +219,7 @@ static void dentry_lru_del_init(struct d
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
+	__releases(dcache_inode_lock)
 	__releases(dcache_lock)
 {
 	struct dentry *parent;
@@ -275,16 +284,21 @@ repeat:
 			 * want to reduce dcache_lock anyway so this will
 			 * get improved.
 			 */
+drop1:
 			spin_unlock(&dentry->d_lock);
 			goto repeat;
 		}
+		if (!spin_trylock(&dcache_inode_lock)) {
+drop2:
+			spin_unlock(&dcache_lock);
+			goto drop1;
+		}
 		parent = dentry->d_parent;
 		if (parent) {
 			BUG_ON(parent == dentry);
 			if (!spin_trylock(&parent->d_lock)) {
-				spin_unlock(&dentry->d_lock);
-				spin_unlock(&dcache_lock);
-				goto repeat;
+				spin_unlock(&dcache_inode_lock);
+				goto drop2;
 			}
 		}
 	}
@@ -311,6 +325,7 @@ repeat:
  	spin_unlock(&dentry->d_lock);
 	if (parent)
 		spin_unlock(&parent->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	return;
 
@@ -463,7 +478,9 @@ struct dentry * d_find_alias(struct inod
 
 	if (!list_empty(&inode->i_dentry)) {
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		de = __d_find_alias(inode, 0);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 	}
 	return de;
@@ -478,18 +495,21 @@ void d_prune_aliases(struct inode *inode
 	struct dentry *dentry;
 restart:
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			dput(dentry);
 			goto restart;
 		}
 		spin_unlock(&dentry->d_lock);
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 }
 
@@ -517,6 +537,7 @@ static void prune_one_dentry(struct dent
 		struct dentry *parent = NULL;
 
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 again:
 		spin_lock(&dentry->d_lock);
 		if (dentry->d_parent && dentry != dentry->d_parent) {
@@ -531,6 +552,7 @@ again:
 			if (parent)
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			return;
 		}
@@ -601,6 +623,7 @@ restart:
 	spin_unlock(&dcache_lru_lock);
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 again:
 	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
 	while (!list_empty(&tmp)) {
@@ -633,8 +656,10 @@ again1:
 		prune_one_dentry(dentry);
 		/* dcache_lock and dentry->d_lock dropped */
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
@@ -1169,7 +1194,9 @@ void d_instantiate(struct dentry *entry,
 {
 	BUG_ON(!list_empty(&entry->d_alias));
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	__d_instantiate(entry, inode);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
@@ -1229,7 +1256,9 @@ struct dentry *d_instantiate_unique(stru
 	BUG_ON(!list_empty(&entry->d_alias));
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	result = __d_instantiate_unique(entry, inode);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	if (!result) {
@@ -1319,8 +1348,10 @@ struct dentry *d_obtain_alias(struct ino
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	res = __d_find_alias(inode, 0);
 	if (res) {
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		dput(tmp);
 		goto out_iput;
@@ -1335,6 +1366,7 @@ struct dentry *d_obtain_alias(struct ino
 	list_add(&tmp->d_alias, &inode->i_dentry);
 	hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
 	spin_unlock(&tmp->d_lock);
+	spin_unlock(&dcache_inode_lock);
 
 	spin_unlock(&dcache_lock);
 	return tmp;
@@ -1367,9 +1399,11 @@ struct dentry *d_splice_alias(struct ino
 
 	if (inode && S_ISDIR(inode->i_mode)) {
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		new = __d_find_alias(inode, 1);
 		if (new) {
 			BUG_ON(!(new->d_flags & DCACHE_DISCONNECTED));
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			security_d_instantiate(new, inode);
 			d_rehash(dentry);
@@ -1378,6 +1412,7 @@ struct dentry *d_splice_alias(struct ino
 		} else {
 			/* already taking dcache_lock, so d_add() by hand */
 			__d_instantiate(dentry, inode);
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
@@ -1454,6 +1489,7 @@ struct dentry *d_add_ci(struct dentry *d
 		return found;
 	}
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	if (list_empty(&inode->i_dentry)) {
 		/*
 		 * Directory without a 'disconnected' dentry; we need to do
@@ -1461,6 +1497,7 @@ struct dentry *d_add_ci(struct dentry *d
 		 * we already hold.
 		 */
 		__d_instantiate(found, inode);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		security_d_instantiate(found, inode);
 		return found;
@@ -1471,6 +1508,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	/* Do security vodoo. */
 	security_d_instantiate(found, inode);
@@ -1688,6 +1726,7 @@ void d_delete(struct dentry * dentry)
 	 * Are we the only user?
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (dentry->d_count == 1) {
@@ -1700,6 +1739,7 @@ void d_delete(struct dentry * dentry)
 		__d_drop(dentry);
 
 	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	fsnotify_nameremove(dentry, isdir);
@@ -1944,6 +1984,7 @@ out_unalias:
 	d_move_locked(alias, dentry);
 	ret = alias;
 out_err:
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	if (m2)
 		mutex_unlock(m2);
@@ -2009,6 +2050,7 @@ struct dentry *d_materialise_unique(stru
 	BUG_ON(!d_unhashed(dentry));
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 
 	if (!inode) {
 		actual = dentry;
@@ -2053,6 +2095,7 @@ found:
 	_d_rehash(actual);
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
@@ -2064,6 +2107,7 @@ out_nolock:
 	return actual;
 
 shouldnt_be_hashed:
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	BUG();
 }
Index: linux-2.6/fs/sysfs/dir.c
===================================================================
--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -520,6 +520,7 @@ static void sysfs_drop_dentry(struct sys
 	 */
 repeat:
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (d_unhashed(dentry)) {
@@ -529,10 +530,12 @@ repeat:
 		dget_locked_dlock(dentry);
 		__d_drop(dentry);
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		dput(dentry);
 		goto repeat;
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	/* adjust nlink and update timestamp */
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -184,6 +184,7 @@ d_iput:		no		no		no       yes
 
 #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
 
+extern spinlock_t dcache_inode_lock;
 extern spinlock_t dcache_hash_lock;
 extern spinlock_t dcache_lock;
 extern seqlock_t rename_lock;
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -185,6 +185,7 @@ static void set_dentry_child_flags(struc
 	struct dentry *alias;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
 
@@ -202,6 +203,7 @@ static void set_dentry_child_flags(struc
 		}
 		spin_unlock(&alias->d_lock);
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 }
 


