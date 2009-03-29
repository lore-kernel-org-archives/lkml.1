Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZC2QnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZC2QnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbZC2QiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:38:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:52658 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZC2Qh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:29 -0400
Message-Id: <20090329155748.993705551@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:44 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 05/14] fs: dcache scale dentry refcount
References: <20090329155539.275927173@nick.local0.net>
Content-Disposition: inline; filename=fs-dcache-scale-d_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make d_count non-atomic and protect it with d_lock. This allows us to
ensure a 0 refcount dentry remains 0 without dcache_lock. It is also
fairly natural when we start protecting many other dentry members with
d_lock.

---
 fs/configfs/dir.c      |    3 --
 fs/dcache.c            |   68 ++++++++++++++++++++++++++++++-------------------
 fs/locks.c             |    2 -
 fs/namei.c             |    2 -
 include/linux/dcache.h |    8 +++--
 5 files changed, 51 insertions(+), 32 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -258,13 +258,23 @@ void dput(struct dentry *dentry)
 		return;
 
 repeat:
-	if (atomic_read(&dentry->d_count) == 1)
+	if (dentry->d_count == 1)
 		might_sleep();
-	if (!atomic_dec_and_lock(&dentry->d_count, &dcache_lock))
-		return;
-
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count)) {
+	if (dentry->d_count == 1) {
+		if (!spin_trylock(&dcache_lock)) {
+			/*
+			 * Something of a livelock possibility we could avoid
+			 * by taking dcache_lock and trying again, but we
+			 * want to reduce dcache_lock anyway so this will
+			 * get improved.
+			 */
+			spin_unlock(&dentry->d_lock);
+			goto repeat;
+		}
+	}
+	dentry->d_count--;
+	if (dentry->d_count) {
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
 		return;
@@ -341,7 +351,7 @@ int d_invalidate(struct dentry * dentry)
 	 * working directory or similar).
 	 */
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count) > 1) {
+	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
@@ -358,16 +368,15 @@ int d_invalidate(struct dentry * dentry)
 /* This should be called _only_ with dcache_lock held */
 static inline struct dentry * __dget_locked_dlock(struct dentry *dentry)
 {
-	atomic_inc(&dentry->d_count);
+	dentry->d_count++;
 	dentry_lru_del_init(dentry);
 	return dentry;
 }
 
 static inline struct dentry * __dget_locked(struct dentry *dentry)
 {
-	atomic_inc(&dentry->d_count);
 	spin_lock(&dentry->d_lock);
-	dentry_lru_del_init(dentry);
+	__dget_locked_dlock(dentry);
 	spin_lock(&dentry->d_lock);
 	return dentry;
 }
@@ -444,7 +453,7 @@ restart:
 	spin_lock(&dcache_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
-		if (!atomic_read(&dentry->d_count)) {
+		if (!dentry->d_count) {
 			__dget_locked_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
@@ -479,7 +488,10 @@ static void prune_one_dentry(struct dent
 	 */
 	while (dentry) {
 		spin_lock(&dcache_lock);
-		if (!atomic_dec_and_lock(&dentry->d_count, &dentry->d_lock)) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_count--;
+		if (dentry->d_count) {
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			return;
 		}
@@ -565,7 +577,7 @@ again:
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
-		if (atomic_read(&dentry->d_count)) {
+		if (dentry->d_count) {
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
@@ -726,7 +738,7 @@ static void shrink_dcache_for_umount_sub
 		do {
 			struct inode *inode;
 
-			if (atomic_read(&dentry->d_count) != 0) {
+			if (dentry->d_count != 0) {
 				printk(KERN_ERR
 				       "BUG: Dentry %p{i=%lx,n=%s}"
 				       " still in use (%d)"
@@ -735,7 +747,7 @@ static void shrink_dcache_for_umount_sub
 				       dentry->d_inode ?
 				       dentry->d_inode->i_ino : 0UL,
 				       dentry->d_name.name,
-				       atomic_read(&dentry->d_count),
+				       dentry->d_count,
 				       dentry->d_sb->s_type->name,
 				       dentry->d_sb->s_id);
 				BUG();
@@ -745,7 +757,9 @@ static void shrink_dcache_for_umount_sub
 				parent = NULL;
 			else {
 				parent = dentry->d_parent;
-				atomic_dec(&parent->d_count);
+				spin_lock(&parent->d_lock);
+				parent->d_count--;
+				spin_unlock(&parent->d_lock);
 			}
 
 			list_del(&dentry->d_u.d_child);
@@ -800,7 +814,9 @@ void shrink_dcache_for_umount(struct sup
 
 	dentry = sb->s_root;
 	sb->s_root = NULL;
-	atomic_dec(&dentry->d_count);
+	spin_lock(&dentry->d_lock);
+	dentry->d_count--;
+	spin_unlock(&dentry->d_lock);
 	shrink_dcache_for_umount_subtree(dentry);
 
 	while (!hlist_empty(&sb->s_anon)) {
@@ -892,17 +908,15 @@ resume:
 
 		spin_lock(&dentry->d_lock);
 		dentry_lru_del_init(dentry);
-		spin_unlock(&dentry->d_lock);
 		/* 
 		 * move only zero ref count dentries to the end 
 		 * of the unused list for prune_dcache
 		 */
-		if (!atomic_read(&dentry->d_count)) {
-			spin_lock(&dentry->d_lock);
+		if (!dentry->d_count) {
 			dentry_lru_add_tail(dentry);
-			spin_unlock(&dentry->d_lock);
 			found++;
 		}
+		spin_unlock(&dentry->d_lock);
 
 		/*
 		 * We can return to the caller if we have found some (this
@@ -1011,7 +1025,7 @@ struct dentry *d_alloc(struct dentry * p
 	memcpy(dname, name->name, name->len);
 	dname[name->len] = 0;
 
-	atomic_set(&dentry->d_count, 1);
+	dentry->d_count = 1;
 	dentry->d_flags = DCACHE_UNHASHED;
 	spin_lock_init(&dentry->d_lock);
 	dentry->d_inode = NULL;
@@ -1491,7 +1505,7 @@ struct dentry * __d_lookup(struct dentry
 				goto next;
 		}
 
-		atomic_inc(&dentry->d_count);
+		dentry->d_count++;
 		found = dentry;
 		spin_unlock(&dentry->d_lock);
 		break;
@@ -1601,7 +1615,7 @@ void d_delete(struct dentry * dentry)
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
-	if (atomic_read(&dentry->d_count) == 1) {
+	if (dentry->d_count == 1) {
 		dentry_iput(dentry);
 		fsnotify_nameremove(dentry, isdir);
 		return;
@@ -2278,11 +2292,15 @@ resume:
 			this_parent = dentry;
 			goto repeat;
 		}
-		atomic_dec(&dentry->d_count);
+		spin_lock(&dentry->d_lock);
+		dentry->d_count--;
+		spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
 		next = this_parent->d_u.d_child.next;
-		atomic_dec(&this_parent->d_count);
+		spin_lock(&this_parent->d_lock);
+		this_parent->d_count--;
+		spin_unlock(&this_parent->d_lock);
 		this_parent = this_parent->d_parent;
 		goto resume;
 	}
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -87,7 +87,7 @@ full_name_hash(const unsigned char *name
 #endif
 
 struct dentry {
-	atomic_t d_count;
+	unsigned int d_count;		/* protected by d_lock */
 	unsigned int d_flags;		/* protected by d_lock */
 	spinlock_t d_lock;		/* per dentry lock */
 	int d_mounted;
@@ -334,8 +334,10 @@ extern char *dentry_path(struct dentry *
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
-		BUG_ON(!atomic_read(&dentry->d_count));
-		atomic_inc(&dentry->d_count);
+		BUG_ON(!dentry->d_count);
+		spin_lock(&dentry->d_lock);
+		dentry->d_count++;
+		spin_unlock(&dentry->d_lock);
 	}
 	return dentry;
 }
Index: linux-2.6/fs/configfs/dir.c
===================================================================
--- linux-2.6.orig/fs/configfs/dir.c
+++ linux-2.6/fs/configfs/dir.c
@@ -311,8 +311,7 @@ static void remove_dir(struct dentry * d
 	if (d->d_inode)
 		simple_rmdir(parent->d_inode,d);
 
-	pr_debug(" o %s removing done (%d)\n",d->d_name.name,
-		 atomic_read(&d->d_count));
+	pr_debug(" o %s removing done (%d)\n",d->d_name.name, d->d_count);
 
 	dput(parent);
 }
Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c
+++ linux-2.6/fs/locks.c
@@ -1373,7 +1373,7 @@ int generic_setlease(struct file *filp,
 		if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 			goto out;
 		if ((arg == F_WRLCK)
-		    && ((atomic_read(&dentry->d_count) > 1)
+		    && (dentry->d_count > 1
 			|| (atomic_read(&inode->i_count) > 1)))
 			goto out;
 	}
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c
+++ linux-2.6/fs/namei.c
@@ -2107,7 +2107,7 @@ void dentry_unhash(struct dentry *dentry
 	shrink_dcache_parent(dentry);
 	spin_lock(&dcache_lock);
 	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count) == 2)
+	if (dentry->d_count == 2)
 		__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);


