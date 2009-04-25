Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbZDYBdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbZDYBdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZDYB3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:44586 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbZDYB2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:52 -0400
Message-Id: <20090425012210.888446921@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:33 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 13/27] fs: scale inode alias list
References: <20090425012020.457460929@suse.de>
Content-Disposition: inline; filename=fs-dcache-scale-i_dentry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new lock, dcache_inode_lock, to protect the inode's i_dentry list
from concurrent modification. d_alias is also protected by d_lock.

---
 fs/affs/amigaffs.c          |    2 +
 fs/dcache.c                 |   56 +++++++++++++++++++++++++++++++++++++++-----
 fs/exportfs/expfs.c         |    4 +++
 fs/nfs/getroot.c            |    4 +++
 fs/notify/inotify/inotify.c |    2 +
 fs/ocfs2/dcache.c           |    3 +-
 fs/sysfs/dir.c              |    3 ++
 include/linux/dcache.h      |    1 
 8 files changed, 68 insertions(+), 7 deletions(-)

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
 
@@ -125,6 +130,7 @@ static void d_free(struct dentry *dentry
  */
 static void dentry_iput(struct dentry * dentry)
 	__releases(dentry->d_lock)
+	__releases(dcache_inode_lock)
 	__releases(dcache_lock)
 {
 	struct inode *inode = dentry->d_inode;
@@ -132,6 +138,7 @@ static void dentry_iput(struct dentry *
 		dentry->d_inode = NULL;
 		list_del_init(&dentry->d_alias);
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
@@ -141,6 +148,7 @@ static void dentry_iput(struct dentry *
 			iput(inode);
 	} else {
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 	}
 }
@@ -212,6 +220,7 @@ static void dentry_lru_del_init(struct d
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
+	__releases(dcache_inode_lock)
 	__releases(dcache_lock)
 {
 	struct dentry *parent;
@@ -276,16 +285,21 @@ repeat:
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
@@ -313,6 +327,7 @@ repeat:
  	spin_unlock(&dentry->d_lock);
 	if (parent)
 		spin_unlock(&parent->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	return;
 
@@ -487,7 +502,9 @@ struct dentry * d_find_alias(struct inod
 
 	if (!list_empty(&inode->i_dentry)) {
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		de = __d_find_alias(inode, 0);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 	}
 	return de;
@@ -502,18 +519,21 @@ void d_prune_aliases(struct inode *inode
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
 
@@ -541,6 +561,7 @@ static void prune_one_dentry(struct dent
 		struct dentry *parent = NULL;
 
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 again:
 		spin_lock(&dentry->d_lock);
 		if (dentry->d_parent && dentry != dentry->d_parent) {
@@ -555,6 +576,7 @@ again:
 			if (parent)
 				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			return;
 		}
@@ -625,6 +647,7 @@ restart:
 	spin_unlock(&dcache_lru_lock);
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 again:
 	spin_lock(&dcache_lru_lock); /* lru_lock also protects tmp list */
 	while (!list_empty(&tmp)) {
@@ -657,8 +680,10 @@ again1:
 		prune_one_dentry(dentry);
 		/* dcache_lock and dentry->d_lock dropped */
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		spin_lock(&dcache_lru_lock);
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	if (count == NULL && !list_empty(&sb->s_dentry_lru))
@@ -1195,7 +1220,9 @@ void d_instantiate(struct dentry *entry,
 {
 	BUG_ON(!list_empty(&entry->d_alias));
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	__d_instantiate(entry, inode);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(entry, inode);
 }
@@ -1255,7 +1282,9 @@ struct dentry *d_instantiate_unique(stru
 	BUG_ON(!list_empty(&entry->d_alias));
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	result = __d_instantiate_unique(entry, inode);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	if (!result) {
@@ -1345,8 +1374,10 @@ struct dentry *d_obtain_alias(struct ino
 	tmp->d_parent = tmp; /* make sure dput doesn't croak */
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	res = __d_find_alias(inode, 0);
 	if (res) {
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		dput(tmp);
 		goto out_iput;
@@ -1361,6 +1392,7 @@ struct dentry *d_obtain_alias(struct ino
 	list_add(&tmp->d_alias, &inode->i_dentry);
 	hlist_add_head(&tmp->d_hash, &inode->i_sb->s_anon);
 	spin_unlock(&tmp->d_lock);
+	spin_unlock(&dcache_inode_lock);
 
 	spin_unlock(&dcache_lock);
 	return tmp;
@@ -1393,9 +1425,11 @@ struct dentry *d_splice_alias(struct ino
 
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
@@ -1404,6 +1438,7 @@ struct dentry *d_splice_alias(struct ino
 		} else {
 			/* already taking dcache_lock, so d_add() by hand */
 			__d_instantiate(dentry, inode);
+			spin_unlock(&dcache_inode_lock);
 			spin_unlock(&dcache_lock);
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
@@ -1477,8 +1512,10 @@ struct dentry *d_add_ci(struct dentry *d
 	 * already has a dentry.
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	if (!S_ISDIR(inode->i_mode) || list_empty(&inode->i_dentry)) {
 		__d_instantiate(found, inode);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		security_d_instantiate(found, inode);
 		return found;
@@ -1490,6 +1527,7 @@ struct dentry *d_add_ci(struct dentry *d
 	 */
 	new = list_entry(inode->i_dentry.next, struct dentry, d_alias);
 	dget_locked(new);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	security_d_instantiate(found, inode);
 	d_move(new, found);
@@ -1705,6 +1743,7 @@ void d_delete(struct dentry * dentry)
 	 * Are we the only user?
 	 */
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (dentry->d_count == 1) {
@@ -1717,6 +1756,7 @@ void d_delete(struct dentry * dentry)
 		__d_drop(dentry);
 
 	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	fsnotify_nameremove(dentry, isdir);
@@ -1963,6 +2003,7 @@ out_unalias:
 	d_move_locked(alias, dentry);
 	ret = alias;
 out_err:
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 	if (m2)
 		mutex_unlock(m2);
@@ -2028,6 +2069,7 @@ struct dentry *d_materialise_unique(stru
 	BUG_ON(!d_unhashed(dentry));
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 
 	if (!inode) {
 		actual = dentry;
@@ -2072,6 +2114,7 @@ found:
 	_d_rehash(actual);
 	spin_unlock(&dcache_hash_lock);
 	spin_unlock(&actual->d_lock);
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 out_nolock:
 	if (actual == dentry) {
@@ -2083,6 +2126,7 @@ out_nolock:
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
@@ -548,6 +548,7 @@ static void sysfs_drop_dentry(struct sys
 	 */
 repeat:
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (d_unhashed(dentry)) {
@@ -557,10 +558,12 @@ repeat:
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
 
Index: linux-2.6/fs/exportfs/expfs.c
===================================================================
--- linux-2.6.orig/fs/exportfs/expfs.c
+++ linux-2.6/fs/exportfs/expfs.c
@@ -48,8 +48,10 @@ find_acceptable_alias(struct dentry *res
 		return result;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	list_for_each_entry(dentry, &result->d_inode->i_dentry, d_alias) {
 		dget_locked(dentry);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 		if (toput)
 			dput(toput);
@@ -58,8 +60,10 @@ find_acceptable_alias(struct dentry *res
 			return dentry;
 		}
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
 		toput = dentry;
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	if (toput)
Index: linux-2.6/fs/affs/amigaffs.c
===================================================================
--- linux-2.6.orig/fs/affs/amigaffs.c
+++ linux-2.6/fs/affs/amigaffs.c
@@ -129,6 +129,7 @@ affs_fix_dcache(struct dentry *dentry, u
 	struct list_head *head, *next;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dcache_inode_lock);
 	head = &inode->i_dentry;
 	next = head->next;
 	while (next != head) {
@@ -139,6 +140,7 @@ affs_fix_dcache(struct dentry *dentry, u
 		}
 		next = next->next;
 	}
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 }
 
Index: linux-2.6/fs/ocfs2/dcache.c
===================================================================
--- linux-2.6.orig/fs/ocfs2/dcache.c
+++ linux-2.6/fs/ocfs2/dcache.c
@@ -141,7 +141,7 @@ struct dentry *ocfs2_find_local_alias(st
 	struct dentry *dentry = NULL;
 
 	spin_lock(&dcache_lock);
-
+	spin_lock(&dcache_inode_lock);
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
 
@@ -159,6 +159,7 @@ struct dentry *ocfs2_find_local_alias(st
 		dentry = NULL;
 	}
 
+	spin_unlock(&dcache_inode_lock);
 	spin_unlock(&dcache_lock);
 
 	return dentry;
Index: linux-2.6/fs/nfs/getroot.c
===================================================================
--- linux-2.6.orig/fs/nfs/getroot.c
+++ linux-2.6/fs/nfs/getroot.c
@@ -66,7 +66,11 @@ static int nfs_superblock_set_dummy_root
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
 		spin_lock(&dcache_lock);
+		spin_lock(&dcache_inode_lock);
+		spin_lock(&sb->s_root->d_lock);
 		list_del_init(&sb->s_root->d_alias);
+		spin_unlock(&sb->s_root->d_lock);
+		spin_unlock(&dcache_inode_lock);
 		spin_unlock(&dcache_lock);
 	}
 	return 0;


