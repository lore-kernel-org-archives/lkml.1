Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbZC2Ql2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbZC2Ql2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZC2Qhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:37:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:52660 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbZC2Qha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:30 -0400
Message-Id: <20090329155749.305582270@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:46 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 07/14] fs: dcache scale subdirs
References: <20090329155539.275927173@nick.local0.net>
Content-Disposition: inline; filename=fs-dcache-scale-d_subdirs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Protect d_subdirs and d_child with d_lock.

XXX: probably don't need parent lock in inotify (because child lock
should stabilize parent).

---
 fs/dcache.c                 |  155 +++++++++++++++++++++++++++++++++++---------
 fs/libfs.c                  |   19 +++--
 fs/notify/inotify/inotify.c |   16 +++-
 include/linux/dcache.h      |   10 ++
 4 files changed, 159 insertions(+), 41 deletions(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -44,6 +44,8 @@
  *   - d_flags
  *   - d_name
  *   - d_lru
+ *   - d_unhashed
+ *   - d_subdirs and children's d_child
  *
  * Ordering:
  * dcache_lock
@@ -204,7 +206,8 @@ static void dentry_lru_del_init(struct d
  *
  * If this is the root of the dentry tree, return NULL.
  *
- * dcache_lock and d_lock must be held by caller, are dropped by d_kill.
+ * dcache_lock and d_lock and d_parent->d_lock must be held by caller, and
+ * are dropped by d_kill.
  */
 static struct dentry *d_kill(struct dentry *dentry)
 	__releases(dentry->d_lock)
@@ -213,12 +216,14 @@ static struct dentry *d_kill(struct dent
 	struct dentry *parent;
 
 	list_del(&dentry->d_u.d_child);
-	/*drops the locks, at that point nobody can reach this dentry */
-	dentry_iput(dentry);
+	if (dentry->d_parent && dentry != dentry->d_parent)
+		spin_unlock(&dentry->d_parent->d_lock);
 	if (IS_ROOT(dentry))
 		parent = NULL;
 	else
 		parent = dentry->d_parent;
+	/*drops the locks, at that point nobody can reach this dentry */
+	dentry_iput(dentry);
 	d_free(dentry);
 	return parent;
 }
@@ -254,6 +259,7 @@ static struct dentry *d_kill(struct dent
 
 void dput(struct dentry *dentry)
 {
+	struct dentry *parent;
 	if (!dentry)
 		return;
 
@@ -272,6 +278,15 @@ repeat:
 			spin_unlock(&dentry->d_lock);
 			goto repeat;
 		}
+		parent = dentry->d_parent;
+		if (parent) {
+			BUG_ON(parent == dentry);
+			if (!spin_trylock(&parent->d_lock)) {
+				spin_unlock(&dentry->d_lock);
+				spin_unlock(&dcache_lock);
+				goto repeat;
+			}
+		}
 	}
 	dentry->d_count--;
 	if (dentry->d_count) {
@@ -295,6 +310,8 @@ repeat:
 		dentry_lru_add(dentry);
   	}
  	spin_unlock(&dentry->d_lock);
+	if (parent)
+		spin_unlock(&parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return;
 
@@ -498,10 +515,22 @@ static void prune_one_dentry(struct dent
 	 * because dcache_lock needs to be taken anyway.
 	 */
 	while (dentry) {
+		struct dentry *parent = NULL;
+
 		spin_lock(&dcache_lock);
+again:
 		spin_lock(&dentry->d_lock);
+		if (dentry->d_parent && dentry != dentry->d_parent) {
+			if (!spin_trylock(&dentry->d_parent->d_lock)) {
+				spin_unlock(&dentry->d_lock);
+				goto again;
+			}
+ 			parent = dentry->d_parent;
+		}
 		dentry->d_count--;
 		if (dentry->d_count) {
+			if (parent)
+				spin_unlock(&parent->d_lock);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			return;
@@ -579,20 +608,28 @@ again:
 		dentry = list_entry(tmp.prev, struct dentry, d_lru);
 
 		if (!spin_trylock(&dentry->d_lock)) {
+again1:
 			spin_unlock(&dcache_lru_lock);
 			goto again;
 		}
-		__dentry_lru_del_init(dentry);
 		/*
 		 * We found an inuse dentry which was not removed from
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
 		if (dentry->d_count) {
+			__dentry_lru_del_init(dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
-
+		if (dentry->d_parent) {
+			BUG_ON(dentry == dentry->d_parent);
+			if (!spin_trylock(&dentry->d_parent->d_lock)) {
+				spin_unlock(&dentry->d_lock);
+				goto again1;
+			}
+		}
+		__dentry_lru_del_init(dentry);
 		spin_unlock(&dcache_lru_lock);
 		prune_one_dentry(dentry);
 		/* dcache_lock and dentry->d_lock dropped */
@@ -729,14 +766,15 @@ static void shrink_dcache_for_umount_sub
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
 			spin_lock(&dcache_lock);
+			spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				spin_lock(&loop->d_lock);
+				spin_lock_nested(&loop->d_lock, DENTRY_D_LOCK_NESTED);
 				dentry_lru_del_init(loop);
 				__d_drop(loop);
 				spin_unlock(&loop->d_lock);
-				cond_resched_lock(&dcache_lock);
 			}
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 
 			/* move to the first child */
@@ -764,16 +802,17 @@ static void shrink_dcache_for_umount_sub
 				BUG();
 			}
 
-			if (IS_ROOT(dentry))
+			if (IS_ROOT(dentry)) {
 				parent = NULL;
-			else {
+				list_del(&dentry->d_u.d_child);
+			} else {
 				parent = dentry->d_parent;
 				spin_lock(&parent->d_lock);
 				parent->d_count--;
+				list_del(&dentry->d_u.d_child);
 				spin_unlock(&parent->d_lock);
 			}
 
-			list_del(&dentry->d_u.d_child);
 			detached++;
 
 			inode = dentry->d_inode;
@@ -858,6 +897,7 @@ int have_submounts(struct dentry *parent
 	spin_lock(&dcache_lock);
 	if (d_mountpoint(parent))
 		goto positive;
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -865,22 +905,32 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
+
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		/* Have we found a mount point ? */
-		if (d_mountpoint(dentry))
+		if (d_mountpoint(dentry)) {
+			spin_unlock(&dentry->d_lock);
+			spin_unlock(&this_parent->d_lock);
 			goto positive;
+		}
 		if (!list_empty(&dentry->d_subdirs)) {
+			spin_unlock(&this_parent->d_lock);
 			this_parent = dentry;
 			goto repeat;
 		}
+		spin_unlock(&dentry->d_lock);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
 		next = this_parent->d_u.d_child.next;
+		spin_unlock(&this_parent->d_lock);
 		this_parent = this_parent->d_parent;
+		spin_lock(&this_parent->d_lock);
 		goto resume;
 	}
+	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return 0; /* No mount points found in tree */
 positive:
@@ -909,6 +959,7 @@ static int select_parent(struct dentry *
 	int found = 0;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -916,8 +967,9 @@ resume:
 		struct list_head *tmp = next;
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
+		BUG_ON(this_parent == dentry);
 
-		spin_lock(&dentry->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		dentry_lru_del_init(dentry);
 		/* 
 		 * move only zero ref count dentries to the end 
@@ -927,33 +979,45 @@ resume:
 			dentry_lru_add_tail(dentry);
 			found++;
 		}
-		spin_unlock(&dentry->d_lock);
 
 		/*
 		 * We can return to the caller if we have found some (this
 		 * ensures forward progress). We'll be coming back to find
 		 * the rest.
 		 */
-		if (found && need_resched())
+		if (found && need_resched()) {
+			spin_unlock(&dentry->d_lock);
 			goto out;
+		}
 
 		/*
 		 * Descend a level if the d_subdirs list is non-empty.
 		 */
 		if (!list_empty(&dentry->d_subdirs)) {
+			spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
 			this_parent = dentry;
+			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
+
+		spin_unlock(&dentry->d_lock);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
 	 */
 	if (this_parent != parent) {
+		struct dentry *tmp;
 		next = this_parent->d_u.d_child.next;
-		this_parent = this_parent->d_parent;
+		tmp = this_parent->d_parent;
+		spin_unlock(&this_parent->d_lock);
+		BUG_ON(tmp == this_parent);
+		this_parent = tmp;
+		spin_lock(&this_parent->d_lock);
 		goto resume;
 	}
 out:
+	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
 	return found;
 }
@@ -1049,19 +1113,20 @@ struct dentry *d_alloc(struct dentry * p
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
 	INIT_LIST_HEAD(&dentry->d_alias);
-
-	if (parent) {
-		dentry->d_parent = dget(parent);
-		dentry->d_sb = parent->d_sb;
-	} else {
-		INIT_LIST_HEAD(&dentry->d_u.d_child);
-	}
+	INIT_LIST_HEAD(&dentry->d_u.d_child);
 
 	if (parent) {
 		spin_lock(&dcache_lock);
+		spin_lock(&parent->d_lock);
+		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		dentry->d_parent = dget_dlock(parent);
+		dentry->d_sb = parent->d_sb;
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&parent->d_lock);
 		spin_unlock(&dcache_lock);
 	}
+
 	atomic_inc(&dentry_stat.nr_dentry);
 
 	return dentry;
@@ -1749,15 +1814,27 @@ static void d_move_locked(struct dentry
 		printk(KERN_WARNING "VFS: moving negative dcache entry\n");
 
 	write_seqlock(&rename_lock);
-	/*
-	 * XXXX: do we really need to take target->d_lock?
-	 */
+
+	if (target->d_parent != dentry->d_parent) {
+		if (target->d_parent < dentry->d_parent) {
+			spin_lock(&target->d_parent->d_lock);
+			spin_lock_nested(&dentry->d_parent->d_lock,
+						DENTRY_D_LOCK_NESTED);
+		} else {
+			spin_lock(&dentry->d_parent->d_lock);
+			spin_lock_nested(&target->d_parent->d_lock,
+						DENTRY_D_LOCK_NESTED);
+		}
+	} else {
+		spin_lock(&target->d_parent->d_lock);
+	}
+
 	if (target < dentry) {
-		spin_lock(&target->d_lock);
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		spin_lock_nested(&target->d_lock, 2);
+		spin_lock_nested(&dentry->d_lock, 3);
 	} else {
-		spin_lock(&dentry->d_lock);
-		spin_lock_nested(&target->d_lock, DENTRY_D_LOCK_NESTED);
+		spin_lock_nested(&dentry->d_lock, 2);
+		spin_lock_nested(&target->d_lock, 3);
 	}
 
 	/* Move the dentry to the target hash queue, if on different bucket */
@@ -1790,7 +1867,10 @@ static void d_move_locked(struct dentry
 	}
 
 	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
+	if (target->d_parent != dentry->d_parent)
+		spin_unlock(&dentry->d_parent->d_lock);
 	spin_unlock(&target->d_lock);
+	spin_unlock(&target->d_parent->d_lock);
 	fsnotify_d_move(dentry);
 	spin_unlock(&dentry->d_lock);
 	write_sequnlock(&rename_lock);
@@ -1889,6 +1969,12 @@ static void __d_materialise_dentry(struc
 	dparent = dentry->d_parent;
 	aparent = anon->d_parent;
 
+	/* XXX: hack */
+	spin_lock(&aparent->d_lock);
+	spin_lock(&dparent->d_lock);
+	spin_lock(&dentry->d_lock);
+	spin_lock(&anon->d_lock);
+
 	dentry->d_parent = (aparent == anon) ? dentry : aparent;
 	list_del(&dentry->d_u.d_child);
 	if (!IS_ROOT(dentry))
@@ -1903,6 +1989,11 @@ static void __d_materialise_dentry(struc
 	else
 		INIT_LIST_HEAD(&anon->d_u.d_child);
 
+	spin_unlock(&anon->d_lock);
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dparent->d_lock);
+	spin_unlock(&aparent->d_lock);
+
 	anon->d_flags &= ~DCACHE_DISCONNECTED;
 }
 
@@ -2302,6 +2393,7 @@ void d_genocide(struct dentry *root)
 	struct list_head *next;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -2315,7 +2407,7 @@ resume:
 			continue;
 		}
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&dentry->d_lock);
+			spin_unlock(&this_parent->d_lock);
 			this_parent = dentry;
 			goto repeat;
 		}
@@ -2324,12 +2416,13 @@ resume:
 	}
 	if (this_parent != root) {
 		next = this_parent->d_u.d_child.next;
-		spin_lock(&this_parent->d_lock);
 		this_parent->d_count--;
 		spin_unlock(&this_parent->d_lock);
 		this_parent = this_parent->d_parent;
+		spin_lock(&this_parent->d_lock);
 		goto resume;
 	}
+	spin_unlock(&this_parent->d_lock);
 	spin_unlock(&dcache_lock);
 }
 
Index: linux-2.6/fs/libfs.c
===================================================================
--- linux-2.6.orig/fs/libfs.c
+++ linux-2.6/fs/libfs.c
@@ -82,7 +82,8 @@ int dcache_dir_close(struct inode *inode
 
 loff_t dcache_dir_lseek(struct file *file, loff_t offset, int origin)
 {
-	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
+	struct dentry *dentry = file->f_path.dentry;
+	mutex_lock(&dentry->d_inode->i_mutex);
 	switch (origin) {
 		case 1:
 			offset += file->f_pos;
@@ -90,7 +91,7 @@ loff_t dcache_dir_lseek(struct file *fil
 			if (offset >= 0)
 				break;
 		default:
-			mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
+			mutex_unlock(&dentry->d_inode->i_mutex);
 			return -EINVAL;
 	}
 	if (offset != file->f_pos) {
@@ -101,9 +102,10 @@ loff_t dcache_dir_lseek(struct file *fil
 			loff_t n = file->f_pos - 2;
 
 			spin_lock(&dcache_lock);
+			spin_lock(&dentry->d_lock);
 			list_del(&cursor->d_u.d_child);
-			p = file->f_path.dentry->d_subdirs.next;
-			while (n && p != &file->f_path.dentry->d_subdirs) {
+			p = dentry->d_subdirs.next;
+			while (n && p != &dentry->d_subdirs) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
 				spin_lock(&next->d_lock);
@@ -113,10 +115,11 @@ loff_t dcache_dir_lseek(struct file *fil
 				p = p->next;
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 		}
 	}
-	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
+	mutex_unlock(&dentry->d_inode->i_mutex);
 	return offset;
 }
 
@@ -157,6 +160,7 @@ int dcache_readdir(struct file * filp, v
 			/* fallthrough */
 		default:
 			spin_lock(&dcache_lock);
+			spin_lock(&dentry->d_lock);
 			if (filp->f_pos == 2)
 				list_move(q, &dentry->d_subdirs);
 
@@ -170,6 +174,7 @@ int dcache_readdir(struct file * filp, v
 				}
 
 				spin_unlock(&next->d_lock);
+				spin_unlock(&dentry->d_lock);
 				spin_unlock(&dcache_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
@@ -177,11 +182,13 @@ int dcache_readdir(struct file * filp, v
 					    dt_type(next->d_inode)) < 0)
 					return 0;
 				spin_lock(&dcache_lock);
+				spin_lock(&dentry->d_lock);
 				/* next is still alive */
 				list_move(q, p);
 				p = q;
 				filp->f_pos++;
 			}
+			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 	}
 	return 0;
@@ -279,6 +286,7 @@ int simple_empty(struct dentry *dentry)
 	int ret = 0;
 
 	spin_lock(&dcache_lock);
+	spin_lock(&dentry->d_lock);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
 		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 		if (simple_positive(child)) {
@@ -289,6 +297,7 @@ int simple_empty(struct dentry *dentry)
 	}
 	ret = 1;
 out:
+	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 	return ret;
 }
Index: linux-2.6/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.orig/fs/notify/inotify/inotify.c
+++ linux-2.6/fs/notify/inotify/inotify.c
@@ -188,17 +188,19 @@ static void set_dentry_child_flags(struc
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		struct dentry *child;
 
+		spin_lock(&alias->d_lock);
 		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
 			if (!child->d_inode)
 				continue;
 
-			spin_lock(&child->d_lock);
+			spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 			if (watched)
 				child->d_flags |= DCACHE_INOTIFY_PARENT_WATCHED;
 			else
 				child->d_flags &=~DCACHE_INOTIFY_PARENT_WATCHED;
 			spin_unlock(&child->d_lock);
 		}
+		spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&dcache_lock);
 }
@@ -338,18 +340,26 @@ void inotify_dentry_parent_queue_event(s
 	if (!(dentry->d_flags & DCACHE_INOTIFY_PARENT_WATCHED))
 		return;
 
+retry:
 	spin_lock(&dentry->d_lock);
 	parent = dentry->d_parent;
+	if (!spin_trylock(&parent->d_lock)) {
+		spin_unlock(&dentry->d_lock);
+		goto retry;
+	}
 	inode = parent->d_inode;
 
 	if (inotify_inode_watched(inode)) {
-		dget(parent);
+		dget_dlock(parent);
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&parent->d_lock);
 		inotify_inode_queue_event(inode, mask, cookie, name,
 					  dentry->d_inode);
 		dput(parent);
-	} else
+	} else {
 		spin_unlock(&dentry->d_lock);
+		spin_unlock(&parent->d_lock);
+	}
 }
 EXPORT_SYMBOL_GPL(inotify_dentry_parent_queue_event);
 
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h
+++ linux-2.6/include/linux/dcache.h
@@ -331,12 +331,18 @@ extern char *dentry_path(struct dentry *
  *	and call dget_locked() instead of dget().
  */
  
+static inline struct dentry *dget_dlock(struct dentry *dentry)
+{
+	BUG_ON(!dentry->d_count);
+	dentry->d_count++;
+	return dentry;
+}
+
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
-		BUG_ON(!dentry->d_count);
 		spin_lock(&dentry->d_lock);
-		dentry->d_count++;
+		dget_dlock(dentry);
 		spin_unlock(&dentry->d_lock);
 	}
 	return dentry;


