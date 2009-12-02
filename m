Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbZLBOPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbZLBOPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZLBOPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:15:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZLBOPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:15:08 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/4] fsnotify: split generic and inode specific mark code
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Wed, 02 Dec 2009 09:15:05 -0500
Message-ID: <20091202141505.12819.36722.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
References: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently all marking is done by functions in inode-mark.c.  Some of this
is pretty generic and should be instead done in a generic function and we
should only put the inode specific code in inode-mark.c

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/Makefile                   |    3 
 fs/notify/dnotify/dnotify.c          |   12 +
 fs/notify/fanotify/fanotify.c        |    2 
 fs/notify/fanotify/fanotify_user.c   |    8 -
 fs/notify/fsnotify.h                 |    7 +
 fs/notify/inode_mark.c               |  246 ++--------------------------
 fs/notify/inotify/inotify_fsnotify.c |    4 
 fs/notify/inotify/inotify_user.c     |    4 
 fs/notify/mark.c                     |  294 ++++++++++++++++++++++++++++++++++
 include/linux/fsnotify_backend.h     |    5 -
 kernel/audit_tree.c                  |    8 -
 kernel/audit_watch.c                 |    6 -
 12 files changed, 347 insertions(+), 252 deletions(-)
 create mode 100644 fs/notify/mark.c

diff --git a/fs/notify/Makefile b/fs/notify/Makefile
index 396a387..8f7f3b0 100644
--- a/fs/notify/Makefile
+++ b/fs/notify/Makefile
@@ -1,4 +1,5 @@
-obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o
+obj-$(CONFIG_FSNOTIFY)		+= fsnotify.o notification.o group.o inode_mark.o \
+				   mark.o
 
 obj-y			+= dnotify/
 obj-y			+= inotify/
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index cac2eb8..69f42df 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -95,7 +95,7 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 
 	to_tell = event->to_tell;
 
-	fsn_mark = fsnotify_find_mark(group, to_tell);
+	fsn_mark = fsnotify_find_inode_mark(group, to_tell);
 	if (unlikely(!fsn_mark))
 		return 0;
 	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
@@ -143,14 +143,14 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 	if (!S_ISDIR(inode->i_mode))
 		return false;
 
-	fsn_mark = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
 		return false;
 
 	mask = (mask & ~FS_EVENT_ON_CHILD);
 	send = (mask & fsn_mark->mask);
 
-	fsnotify_put_mark(fsn_mark); /* matches fsnotify_find_mark */
+	fsnotify_put_mark(fsn_mark); /* matches fsnotify_find_inode_mark */
 
 	return send;
 }
@@ -193,7 +193,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 	if (!S_ISDIR(inode->i_mode))
 		return;
 
-	fsn_mark = fsnotify_find_mark(dnotify_group, inode);
+	fsn_mark = fsnotify_find_inode_mark(dnotify_group, inode);
 	if (!fsn_mark)
 		return;
 	dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
@@ -346,12 +346,12 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	mutex_lock(&dnotify_mark_mutex);
 
 	/* add the new_fsn_mark or find an old one. */
-	fsn_mark = fsnotify_find_mark(dnotify_group, inode);
+	fsn_mark = fsnotify_find_inode_mark(dnotify_group, inode);
 	if (fsn_mark) {
 		dn_mark = container_of(fsn_mark, struct dnotify_mark, fsn_mark);
 		spin_lock(&fsn_mark->lock);
 	} else {
-		fsnotify_add_mark(new_fsn_mark, dnotify_group, inode, 0);
+		fsnotify_add_mark(new_fsn_mark, dnotify_group, inode, NULL, 0);
 		spin_lock(&new_fsn_mark->lock);
 		fsn_mark = new_fsn_mark;
 		dn_mark = new_dn_mark;
diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 881067d..aa5e926 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -118,7 +118,7 @@ static bool fanotify_should_send_event(struct fsnotify_group *group, struct inod
 	if (data_type != FSNOTIFY_EVENT_PATH)
 		return false;
 
-	fsn_mark = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
 		return false;
 
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 7cfb2f6..79376ec 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -310,7 +310,7 @@ static int fanotify_remove_mark(struct fsnotify_group *group,
 	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__,
 		 group, inode, mask);
 
-	fsn_mark = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
 		return -ENOENT;
 
@@ -326,7 +326,7 @@ static int fanotify_remove_mark(struct fsnotify_group *group,
 
 	fsnotify_recalc_group_mask(group);
 
-	/* matches the fsnotify_find_mark() */
+	/* matches the fsnotify_find_inode_mark() */
 	fsnotify_put_mark(fsn_mark);
 
 	return 0;
@@ -343,7 +343,7 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__,
 		 group, inode, mask);
 
-	fsn_mark = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark) {
 		struct fsnotify_mark *new_fsn_mark;
 
@@ -353,7 +353,7 @@ static int fanotify_add_mark(struct fsnotify_group *group,
 			goto out;
 
 		fsnotify_init_mark(new_fsn_mark, fanotify_free_mark);
-		ret = fsnotify_add_mark(new_fsn_mark, group, inode, 0);
+		ret = fsnotify_add_mark(new_fsn_mark, group, inode, NULL, 0);
 		if (ret) {
 			fanotify_free_mark(new_fsn_mark);
 			goto out;
diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index 2ba5915..7c7a904 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -20,6 +20,11 @@ extern __u32 fsnotify_vfsmount_mask;
 /* destroy all events sitting in this groups notification queue */
 extern void fsnotify_flush_notify(struct fsnotify_group *group);
 
+/* add a mark to an inode */
+extern int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
+				   struct fsnotify_group *group, struct inode *inode,
+				   int allow_dups);
+
 /* add a group to the inode group list */
 extern void fsnotify_add_inode_group(struct fsnotify_group *group);
 /* add a group to the vfsmount group list */
@@ -27,6 +32,8 @@ extern void fsnotify_add_vfsmount_group(struct fsnotify_group *group);
 /* final kfree of a group */
 extern void fsnotify_final_destroy_group(struct fsnotify_group *group);
 
+/* inode specific destruction of a mark */
+extern void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark);
 /* run the list of all marks associated with inode and flag them to be freed */
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
 /*
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 7468af1..b857ab2 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -16,72 +16,6 @@
  *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-/*
- * fsnotify inode mark locking/lifetime/and refcnting
- *
- * REFCNT:
- * The mark->refcnt tells how many "things" in the kernel currently are
- * referencing this object.  The object typically will live inside the kernel
- * with a refcnt of 2, one for each list it is on (i_list, g_list).  Any task
- * which can find this object holding the appropriete locks, can take a reference
- * and the object itself is guarenteed to survive until the reference is dropped.
- *
- * LOCKING:
- * There are 3 spinlocks involved with fsnotify inode marks and they MUST
- * be taken in order as follows:
- *
- * mark->lock
- * group->mark_lock
- * inode->i_lock
- *
- * mark->lock protects 2 things, mark->group and mark->inode.  You must hold
- * that lock to dereference either of these things (they could be NULL even with
- * the lock)
- *
- * group->mark_lock protects the marks_list anchored inside a given group
- * and each mark is hooked via the g_list.  It also sorta protects the
- * free_g_list, which when used is anchored by a private list on the stack of the
- * task which held the group->mark_lock.
- *
- * inode->i_lock protects the i_fsnotify_marks list anchored inside a
- * given inode and each mark is hooked via the i_list. (and sorta the
- * free_i_list)
- *
- *
- * LIFETIME:
- * Inode marks survive between when they are added to an inode and when their
- * refcnt==0.
- *
- * The inode mark can be cleared for a number of different reasons including:
- * - The inode is unlinked for the last time.  (fsnotify_inode_remove)
- * - The inode is being evicted from cache. (fsnotify_inode_delete)
- * - The fs the inode is on is unmounted.  (fsnotify_inode_delete/fsnotify_unmount_inodes)
- * - Something explicitly requests that it be removed.  (fsnotify_destroy_mark)
- * - The fsnotify_group associated with the mark is going away and all such marks
- *   need to be cleaned up. (fsnotify_clear_marks_by_group)
- *
- * Worst case we are given an inode and need to clean up all the marks on that
- * inode.  We take i_lock and walk the i_fsnotify_marks safely.  For each
- * mark on the list we take a reference (so the mark can't disappear under us).
- * We remove that mark form the inode's list of marks and we add this mark to a
- * private list anchored on the stack using i_free_list;  At this point we no
- * longer fear anything finding the mark using the inode's list of marks.
- *
- * We can safely and locklessly run the private list on the stack of everything
- * we just unattached from the original inode.  For each mark on the private list
- * we grab the mark-> and can thus dereference mark->group and mark->inode.  If
- * we see the group and inode are not NULL we take those locks.  Now holding all
- * 3 locks we can completely remove the mark from other tasks finding it in the
- * future.  Remember, 10 things might already be referencing this mark, but they
- * better be holding a ref.  We drop our reference we took before we unhooked it
- * from the inode.  When the ref hits 0 we can free the mark.
- *
- * Very similarly for freeing by group, except we use free_g_list.
- *
- * This has the very interesting property of being able to run concurrently with
- * any (or all) other directions.
- */
-
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -96,17 +30,6 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-void fsnotify_get_mark(struct fsnotify_mark *mark)
-{
-	atomic_inc(&mark->refcnt);
-}
-
-void fsnotify_put_mark(struct fsnotify_mark *mark)
-{
-	if (atomic_dec_and_test(&mark->refcnt))
-		mark->free_mark(mark);
-}
-
 /*
  * Recalculate the mask of events relevant to a given inode locked.
  */
@@ -136,44 +59,18 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 	__fsnotify_update_child_dentry_flags(inode);
 }
 
-/*
- * Any time a mark is getting freed we end up here.
- * The caller had better be holding a reference to this mark so we don't actually
- * do the final put under the mark->lock
- */
-void fsnotify_destroy_mark(struct fsnotify_mark *mark)
+void fsnotify_destroy_inode_mark(struct fsnotify_mark *mark)
 {
-	struct fsnotify_group *group;
-	struct inode *inode;
-
-	spin_lock(&mark->lock);
+	struct inode *inode = mark->i.inode;
 
-	group = mark->group;
-	inode = mark->i.inode;
+	assert_spin_locked(&mark->lock);
+	assert_spin_locked(&mark->group->mark_lock);
 
-	BUG_ON(group && !inode);
-	BUG_ON(!group && inode);
-
-	/* if !group something else already marked this to die */
-	if (!group) {
-		spin_unlock(&mark->lock);
-		return;
-	}
-
-	/* 1 from caller and 1 for being on i_list/g_list */
-	BUG_ON(atomic_read(&mark->refcnt) < 2);
-
-	spin_lock(&group->mark_lock);
 	spin_lock(&inode->i_lock);
 
 	hlist_del_init(&mark->i.i_list);
 	mark->i.inode = NULL;
 
-	list_del_init(&mark->g_list);
-	mark->group = NULL;
-
-	fsnotify_put_mark(mark); /* for i_list and g_list */
-
 	/*
 	 * this mark is now off the inode->i_fsnotify_marks list and we
 	 * hold the inode->i_lock, so this is the perfect time to update the
@@ -182,61 +79,6 @@ void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 	fsnotify_recalc_inode_mask_locked(inode);
 
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&group->mark_lock);
-	spin_unlock(&mark->lock);
-
-	/*
-	 * Some groups like to know that marks are being freed.  This is a
-	 * callback to the group function to let it know that this mark
-	 * is being freed.
-	 */
-	if (group->ops->freeing_mark)
-		group->ops->freeing_mark(mark, group);
-
-	/*
-	 * __fsnotify_update_child_dentry_flags(inode);
-	 *
-	 * I really want to call that, but we can't, we have no idea if the inode
-	 * still exists the second we drop the mark->lock.
-	 *
-	 * The next time an event arrive to this inode from one of it's children
-	 * __fsnotify_parent will see that the inode doesn't care about it's
-	 * children and will update all of these flags then.  So really this
-	 * is just a lazy update (and could be a perf win...)
-	 */
-
-
-	iput(inode);
-
-	/*
-	 * it's possible that this group tried to destroy itself, but this
-	 * this mark was simultaneously being freed by inode.  If that's the
-	 * case, we finish freeing the group here.
-	 */
-	if (unlikely(atomic_dec_and_test(&group->num_marks)))
-		fsnotify_final_destroy_group(group);
-}
-
-/*
- * Given a group, destroy all of the marks associated with that group.
- */
-void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
-{
-	struct fsnotify_mark *lmark, *mark;
-	LIST_HEAD(free_list);
-
-	spin_lock(&group->mark_lock);
-	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
-		list_add(&mark->free_g_list, &free_list);
-		list_del_init(&mark->g_list);
-		fsnotify_get_mark(mark);
-	}
-	spin_unlock(&group->mark_lock);
-
-	list_for_each_entry_safe(mark, lmark, &free_list, free_g_list) {
-		fsnotify_destroy_mark(mark);
-		fsnotify_put_mark(mark);
-	}
 }
 
 /*
@@ -262,8 +104,12 @@ void fsnotify_clear_marks_by_inode(struct inode *inode)
 	}
 }
 
-static struct fsnotify_mark *fsnotify_find_mark_locked(struct fsnotify_group *group,
-						       struct inode *inode)
+/*
+ * given a group and inode, find the mark associated with that combination.
+ * if found take a reference to that mark and return it, else return NULL
+ */
+struct fsnotify_mark *fsnotify_find_inode_mark_locked(struct fsnotify_group *group,
+						      struct inode *inode)
 {
 	struct fsnotify_mark *mark;
 	struct hlist_node *pos;
@@ -283,50 +129,26 @@ static struct fsnotify_mark *fsnotify_find_mark_locked(struct fsnotify_group *gr
  * given a group and inode, find the mark associated with that combination.
  * if found take a reference to that mark and return it, else return NULL
  */
-struct fsnotify_mark *fsnotify_find_mark(struct fsnotify_group *group,
-					 struct inode *inode)
+struct fsnotify_mark *fsnotify_find_inode_mark(struct fsnotify_group *group,
+					       struct inode *inode)
 {
 	struct fsnotify_mark *mark;
 
 	spin_lock(&inode->i_lock);
-	mark = fsnotify_find_mark_locked(group, inode);
+	mark = fsnotify_find_inode_mark_locked(group, inode);
 	spin_unlock(&inode->i_lock);
 
 	return mark;
 }
 
-void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old)
-{
-	assert_spin_locked(&old->lock);
-	new->i.inode = old->i.inode;
-	new->group = old->group;
-	new->mask = old->mask;
-	new->free_mark = old->free_mark;
-}
-
-/*
- * Nothing fancy, just initialize lists and locks and counters.
- */
-void fsnotify_init_mark(struct fsnotify_mark *mark,
-			void (*free_mark)(struct fsnotify_mark *mark))
-{
-	spin_lock_init(&mark->lock);
-	atomic_set(&mark->refcnt, 1);
-	INIT_HLIST_NODE(&mark->i.i_list);
-	mark->group = NULL;
-	mark->mask = 0;
-	mark->i.inode = NULL;
-	mark->free_mark = free_mark;
-}
-
 /*
  * Attach an initialized mark mark to a given group and inode.
  * These marks may be used for the fsnotify backend to determine which
  * event types should be delivered to which group and for which inodes.
  */
-int fsnotify_add_mark(struct fsnotify_mark *mark,
-		      struct fsnotify_group *group, struct inode *inode,
-		      int allow_dups)
+int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
+			    struct fsnotify_group *group, struct inode *inode,
+			    int allow_dups)
 {
 	struct fsnotify_mark *lmark = NULL;
 	int ret = 0;
@@ -337,56 +159,26 @@ int fsnotify_add_mark(struct fsnotify_mark *mark,
 
 	mark->flags = FSNOTIFY_MARK_FLAG_INODE;
 
-	/*
-	 * if this group isn't being testing for inode type events we need
-	 * to start testing
-	 */
-	if (unlikely(list_empty(&group->inode_group_list)))
-		fsnotify_add_inode_group(group);
-	/*
-	 * XXX This is where we could also do the fsnotify_add_vfsmount_group
-	 * if we are setting and vfsmount mark....
-
-	if (unlikely(list_empty(&group->vfsmount_group_list)))
-		fsnotify_add_vfsmount_group(group);
-	 */
+	assert_spin_locked(&mark->lock);
+	assert_spin_locked(&group->mark_lock);
 
-	/*
-	 * LOCKING ORDER!!!!
-	 * mark->lock
-	 * group->mark_lock
-	 * inode->i_lock
-	 */
-	spin_lock(&mark->lock);
-	spin_lock(&group->mark_lock);
 	spin_lock(&inode->i_lock);
 
 	if (!allow_dups)
-		lmark = fsnotify_find_mark_locked(group, inode);
+		lmark = fsnotify_find_inode_mark_locked(group, inode);
 	if (!lmark) {
-		mark->group = group;
 		mark->i.inode = inode;
 
 		hlist_add_head(&mark->i.i_list, &inode->i_fsnotify_marks);
-		list_add(&mark->g_list, &group->marks_list);
-
-		fsnotify_get_mark(mark); /* for i_list and g_list */
-
-		atomic_inc(&group->num_marks);
 
 		fsnotify_recalc_inode_mask_locked(inode);
 	}
 
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&group->mark_lock);
-	spin_unlock(&mark->lock);
 
 	if (lmark) {
 		ret = -EEXIST;
 		iput(inode);
-		fsnotify_put_mark(lmark);
-	} else {
-		__fsnotify_update_child_dentry_flags(inode);
 	}
 
 	return ret;
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 3a20053..bd2468d 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -96,7 +96,7 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 
 	to_tell = event->to_tell;
 
-	fsn_mark = fsnotify_find_mark(group, to_tell);
+	fsn_mark = fsnotify_find_inode_mark(group, to_tell);
 	/* race with watch removal?  We already passes should_send */
 	if (unlikely(!fsn_mark))
 		return 0;
@@ -144,7 +144,7 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
 	struct fsnotify_mark *fsn_mark;
 	bool send;
 
-	fsn_mark = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
 		return false;
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4d1c0f6..1ba7c86 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -571,7 +571,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 	if (unlikely(!mask))
 		return -EINVAL;
 
-	fsn_mark = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_inode_mark(group, inode);
 	if (!fsn_mark)
 		return -ENOENT;
 
@@ -649,7 +649,7 @@ static int inotify_new_watch(struct fsnotify_group *group,
 		goto out_err;
 
 	/* we are on the idr, now get on the inode */
-	ret = fsnotify_add_mark(&tmp_i_mark->fsn_mark, group, inode, 0);
+	ret = fsnotify_add_mark(&tmp_i_mark->fsn_mark, group, inode, NULL, 0);
 	if (ret) {
 		/* we failed to get on the inode, get off the idr */
 		inotify_remove_from_idr(group, tmp_i_mark);
diff --git a/fs/notify/mark.c b/fs/notify/mark.c
new file mode 100644
index 0000000..e56e876
--- /dev/null
+++ b/fs/notify/mark.c
@@ -0,0 +1,294 @@
+/*
+ *  Copyright (C) 2008 Red Hat, Inc., Eric Paris <eparis@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2, or (at your option)
+ *  any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/*
+ * fsnotify inode mark locking/lifetime/and refcnting
+ *
+ * REFCNT:
+ * The mark->refcnt tells how many "things" in the kernel currently are
+ * referencing this object.  The object typically will live inside the kernel
+ * with a refcnt of 2, one for each list it is on (i_list, g_list).  Any task
+ * which can find this object holding the appropriete locks, can take a reference
+ * and the object itself is guarenteed to survive until the reference is dropped.
+ *
+ * LOCKING:
+ * There are 3 spinlocks involved with fsnotify inode marks and they MUST
+ * be taken in order as follows:
+ *
+ * mark->lock
+ * group->mark_lock
+ * inode->i_lock
+ *
+ * mark->lock protects 2 things, mark->group and mark->inode.  You must hold
+ * that lock to dereference either of these things (they could be NULL even with
+ * the lock)
+ *
+ * group->mark_lock protects the marks_list anchored inside a given group
+ * and each mark is hooked via the g_list.  It also sorta protects the
+ * free_g_list, which when used is anchored by a private list on the stack of the
+ * task which held the group->mark_lock.
+ *
+ * inode->i_lock protects the i_fsnotify_marks list anchored inside a
+ * given inode and each mark is hooked via the i_list. (and sorta the
+ * free_i_list)
+ *
+ *
+ * LIFETIME:
+ * Inode marks survive between when they are added to an inode and when their
+ * refcnt==0.
+ *
+ * The inode mark can be cleared for a number of different reasons including:
+ * - The inode is unlinked for the last time.  (fsnotify_inode_remove)
+ * - The inode is being evicted from cache. (fsnotify_inode_delete)
+ * - The fs the inode is on is unmounted.  (fsnotify_inode_delete/fsnotify_unmount_inodes)
+ * - Something explicitly requests that it be removed.  (fsnotify_destroy_mark)
+ * - The fsnotify_group associated with the mark is going away and all such marks
+ *   need to be cleaned up. (fsnotify_clear_marks_by_group)
+ *
+ * Worst case we are given an inode and need to clean up all the marks on that
+ * inode.  We take i_lock and walk the i_fsnotify_marks safely.  For each
+ * mark on the list we take a reference (so the mark can't disappear under us).
+ * We remove that mark form the inode's list of marks and we add this mark to a
+ * private list anchored on the stack using i_free_list;  At this point we no
+ * longer fear anything finding the mark using the inode's list of marks.
+ *
+ * We can safely and locklessly run the private list on the stack of everything
+ * we just unattached from the original inode.  For each mark on the private list
+ * we grab the mark-> and can thus dereference mark->group and mark->inode.  If
+ * we see the group and inode are not NULL we take those locks.  Now holding all
+ * 3 locks we can completely remove the mark from other tasks finding it in the
+ * future.  Remember, 10 things might already be referencing this mark, but they
+ * better be holding a ref.  We drop our reference we took before we unhooked it
+ * from the inode.  When the ref hits 0 we can free the mark.
+ *
+ * Very similarly for freeing by group, except we use free_g_list.
+ *
+ * This has the very interesting property of being able to run concurrently with
+ * any (or all) other directions.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/writeback.h> /* for inode_lock */
+
+#include <asm/atomic.h>
+
+#include <linux/fsnotify_backend.h>
+#include "fsnotify.h"
+
+void fsnotify_get_mark(struct fsnotify_mark *mark)
+{
+	atomic_inc(&mark->refcnt);
+}
+
+void fsnotify_put_mark(struct fsnotify_mark *mark)
+{
+	if (atomic_dec_and_test(&mark->refcnt))
+		mark->free_mark(mark);
+}
+
+/*
+ * Any time a mark is getting freed we end up here.
+ * The caller had better be holding a reference to this mark so we don't actually
+ * do the final put under the mark->lock
+ */
+void fsnotify_destroy_mark(struct fsnotify_mark *mark)
+{
+	struct fsnotify_group *group;
+	struct inode *inode;
+
+	spin_lock(&mark->lock);
+
+	group = mark->group;
+	inode = mark->i.inode;
+
+	BUG_ON(group && !inode);
+	BUG_ON(!group && inode);
+
+	/* if !group something else already marked this to die */
+	if (!group) {
+		spin_unlock(&mark->lock);
+		return;
+	}
+
+	/* 1 from caller and 1 for being on i_list/g_list */
+	BUG_ON(atomic_read(&mark->refcnt) < 2);
+
+	spin_lock(&group->mark_lock);
+
+	if (mark->flags & FSNOTIFY_MARK_FLAG_INODE)
+		fsnotify_destroy_inode_mark(mark);
+	else
+		BUG();
+
+	list_del_init(&mark->g_list);
+	mark->group = NULL;
+
+	fsnotify_put_mark(mark); /* for i_list and g_list */
+
+	spin_unlock(&group->mark_lock);
+	spin_unlock(&mark->lock);
+
+	/*
+	 * Some groups like to know that marks are being freed.  This is a
+	 * callback to the group function to let it know that this mark
+	 * is being freed.
+	 */
+	if (group->ops->freeing_mark)
+		group->ops->freeing_mark(mark, group);
+
+	/*
+	 * __fsnotify_update_child_dentry_flags(inode);
+	 *
+	 * I really want to call that, but we can't, we have no idea if the inode
+	 * still exists the second we drop the mark->lock.
+	 *
+	 * The next time an event arrive to this inode from one of it's children
+	 * __fsnotify_parent will see that the inode doesn't care about it's
+	 * children and will update all of these flags then.  So really this
+	 * is just a lazy update (and could be a perf win...)
+	 */
+
+
+	iput(inode);
+
+	/*
+	 * it's possible that this group tried to destroy itself, but this
+	 * this mark was simultaneously being freed by inode.  If that's the
+	 * case, we finish freeing the group here.
+	 */
+	if (unlikely(atomic_dec_and_test(&group->num_marks)))
+		fsnotify_final_destroy_group(group);
+}
+
+/*
+ * Attach an initialized mark to a given group and fs object.
+ * These marks may be used for the fsnotify backend to determine which
+ * event types should be delivered to which group.
+ */
+int fsnotify_add_mark(struct fsnotify_mark *mark,
+		      struct fsnotify_group *group, struct inode *inode,
+		      struct vfsmount *mnt, int allow_dups)
+{
+	int ret = 0;
+
+	BUG_ON(mnt);
+	BUG_ON(inode && mnt);
+	BUG_ON(!inode && !mnt);
+
+	/*
+	 * if this group isn't being testing for inode type events we need
+	 * to start testing
+	 */
+	if (inode && unlikely(list_empty(&group->inode_group_list)))
+		fsnotify_add_inode_group(group);
+	else if (mnt && unlikely(list_empty(&group->vfsmount_group_list)))
+		fsnotify_add_vfsmount_group(group);
+
+	/*
+	 * LOCKING ORDER!!!!
+	 * mark->lock
+	 * group->mark_lock
+	 * inode->i_lock
+	 */
+	spin_lock(&mark->lock);
+	spin_lock(&group->mark_lock);
+
+	mark->group = group;
+	list_add(&mark->g_list, &group->marks_list);
+	atomic_inc(&group->num_marks);
+	fsnotify_get_mark(mark); /* for i_list and g_list */
+
+	if (inode) {
+		ret = fsnotify_add_inode_mark(mark, group, inode, allow_dups);
+		if (ret)
+			goto err;
+	} else {
+		BUG();
+	}
+
+	spin_unlock(&group->mark_lock);
+	spin_unlock(&mark->lock);
+
+	if (inode)
+		__fsnotify_update_child_dentry_flags(inode);
+
+	return ret;
+err:
+	mark->group = NULL;
+	list_del_init(&mark->g_list);
+	atomic_dec(&group->num_marks);
+	fsnotify_put_mark(mark);
+
+	spin_unlock(&group->mark_lock);
+	spin_unlock(&mark->lock);
+
+	return ret;
+}
+
+/*
+ * Given a group, destroy all of the marks associated with that group.
+ */
+void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
+{
+	struct fsnotify_mark *lmark, *mark;
+	LIST_HEAD(free_list);
+
+	spin_lock(&group->mark_lock);
+	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
+		list_add(&mark->free_g_list, &free_list);
+		list_del_init(&mark->g_list);
+		fsnotify_get_mark(mark);
+	}
+	spin_unlock(&group->mark_lock);
+
+	list_for_each_entry_safe(mark, lmark, &free_list, free_g_list) {
+		fsnotify_destroy_mark(mark);
+		fsnotify_put_mark(mark);
+	}
+}
+
+void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old)
+{
+	assert_spin_locked(&old->lock);
+	new->i.inode = old->i.inode;
+	new->m.mnt = old->m.mnt;
+	new->group = old->group;
+	new->mask = old->mask;
+	new->free_mark = old->free_mark;
+}
+
+/*
+ * Nothing fancy, just initialize lists and locks and counters.
+ */
+void fsnotify_init_mark(struct fsnotify_mark *mark,
+			void (*free_mark)(struct fsnotify_mark *mark))
+{
+	spin_lock_init(&mark->lock);
+	atomic_set(&mark->refcnt, 1);
+	INIT_HLIST_NODE(&mark->i.i_list);
+	mark->group = NULL;
+	mark->mask = 0;
+	mark->i.inode = NULL;
+	mark->free_mark = free_mark;
+}
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 7d93572..27cccbe 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -364,11 +364,12 @@ extern struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group
 extern void fsnotify_recalc_inode_mask(struct inode *inode);
 extern void fsnotify_init_mark(struct fsnotify_mark *mark, void (*free_mark)(struct fsnotify_mark *mark));
 /* find (and take a reference) to a mark associated with group and inode */
-extern struct fsnotify_mark *fsnotify_find_mark(struct fsnotify_group *group, struct inode *inode);
+extern struct fsnotify_mark *fsnotify_find_inode_mark(struct fsnotify_group *group, struct inode *inode);
 /* copy the values from old into new */
 extern void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old);
 /* attach the mark to both the group and the inode */
-extern int fsnotify_add_mark(struct fsnotify_mark *mark, struct fsnotify_group *group, struct inode *inode, int allow_dups);
+extern int fsnotify_add_mark(struct fsnotify_mark *mark, struct fsnotify_group *group,
+			     struct inode *inode, struct vfsmount *mnt, int allow_dups);
 /* given a mark, flag it to be freed when all references are dropped */
 extern void fsnotify_destroy_mark(struct fsnotify_mark *mark);
 /* run all the marks in a group, and flag them to be freed */
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 001f4e7..1de235a 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -258,7 +258,7 @@ static void untag_chunk(struct node *p)
 	if (!new)
 		goto Fallback;
 	fsnotify_duplicate_mark(&new->mark, entry);
-	if (fsnotify_add_mark(&new->mark, new->mark.group, new->mark.i.inode, 1)) {
+	if (fsnotify_add_mark(&new->mark, new->mark.group, new->mark.i.inode, NULL, 1)) {
 		free_chunk(new);
 		goto Fallback;
 	}
@@ -321,7 +321,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 		return -ENOMEM;
 
 	entry = &chunk->mark;
-	if (fsnotify_add_mark(entry, audit_tree_group, inode, 0)) {
+	if (fsnotify_add_mark(entry, audit_tree_group, inode, NULL, 0)) {
 		free_chunk(chunk);
 		return -ENOSPC;
 	}
@@ -359,7 +359,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	struct node *p;
 	int n;
 
-	old_entry = fsnotify_find_mark(audit_tree_group, inode);
+	old_entry = fsnotify_find_inode_mark(audit_tree_group, inode);
 	if (!old_entry)
 		return create_chunk(inode, tree);
 
@@ -391,7 +391,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	}
 
 	fsnotify_duplicate_mark(chunk_entry, old_entry);
-	if (fsnotify_add_mark(chunk_entry, chunk_entry->group, chunk_entry->i.inode, 1)) {
+	if (fsnotify_add_mark(chunk_entry, chunk_entry->group, chunk_entry->i.inode, NULL, 1)) {
 		spin_unlock(&old_entry->lock);
 		free_chunk(chunk);
 		fsnotify_put_mark(old_entry);
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index e8023ad..31f9be8 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -100,7 +100,7 @@ static inline struct audit_parent *audit_find_parent(struct inode *inode)
 	struct audit_parent *parent = NULL;
 	struct fsnotify_mark *entry;
 
-	entry = fsnotify_find_mark(audit_watch_group, inode);
+	entry = fsnotify_find_inode_mark(audit_watch_group, inode);
 	if (entry)
 		parent = container_of(entry, struct audit_parent, mark);
 
@@ -157,7 +157,7 @@ static struct audit_parent *audit_init_parent(struct nameidata *ndp)
 
 	fsnotify_init_mark(&parent->mark, audit_watch_free_mark);
 	parent->mark.mask = AUDIT_FS_WATCH;
-	ret = fsnotify_add_mark(&parent->mark, audit_watch_group, inode, 0);
+	ret = fsnotify_add_mark(&parent->mark, audit_watch_group, inode, NULL, 0);
 	if (ret < 0) {
 		audit_free_parent(parent);
 		return ERR_PTR(ret);
@@ -516,7 +516,7 @@ static bool audit_watch_should_send_event(struct fsnotify_group *group, struct i
 	struct fsnotify_mark *entry;
 	bool send;
 
-	entry = fsnotify_find_mark(group, inode);
+	entry = fsnotify_find_inode_mark(group, inode);
 	if (!entry)
 		return false;
 

