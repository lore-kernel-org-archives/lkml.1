Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZJ0TKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZJ0TKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756664AbZJ0TKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:10:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbZJ0TKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:10:10 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 4/6] fsnotify: rename mark_entry to just mark
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Tue, 27 Oct 2009 15:10:12 -0400
Message-ID: <20091027191011.27472.73790.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
References: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

previously I used mark_entry when talking about marks on inodes.  The
_entry is pretty useless.  Just use "mark" instead.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/group.c                |    6 +-
 fs/notify/inode_mark.c           |  148 +++++++++++++++++++-------------------
 include/linux/fsnotify_backend.h |   26 +++----
 3 files changed, 90 insertions(+), 90 deletions(-)

diff --git a/fs/notify/group.c b/fs/notify/group.c
index b70e7d2..9e9eb40 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -74,11 +74,11 @@ void fsnotify_recalc_group_mask(struct fsnotify_group *group)
 {
 	__u32 mask = 0;
 	__u32 old_mask = group->mask;
-	struct fsnotify_mark *entry;
+	struct fsnotify_mark *mark;
 
 	spin_lock(&group->mark_lock);
-	list_for_each_entry(entry, &group->marks_list, g_list)
-		mask |= entry->mask;
+	list_for_each_entry(mark, &group->marks_list, g_list)
+		mask |= mark->mask;
 	spin_unlock(&group->mark_lock);
 
 	group->mask = mask;
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index 9681126..31ec37b 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -30,21 +30,21 @@
  * There are 3 spinlocks involved with fsnotify inode marks and they MUST
  * be taken in order as follows:
  *
- * entry->lock
+ * mark->lock
  * group->mark_lock
  * inode->i_lock
  *
- * entry->lock protects 2 things, entry->group and entry->inode.  You must hold
+ * mark->lock protects 2 things, mark->group and mark->inode.  You must hold
  * that lock to dereference either of these things (they could be NULL even with
  * the lock)
  *
  * group->mark_lock protects the marks_list anchored inside a given group
- * and each entry is hooked via the g_list.  It also sorta protects the
+ * and each mark is hooked via the g_list.  It also sorta protects the
  * free_g_list, which when used is anchored by a private list on the stack of the
  * task which held the group->mark_lock.
  *
  * inode->i_lock protects the i_fsnotify_marks list anchored inside a
- * given inode and each entry is hooked via the i_list. (and sorta the
+ * given inode and each mark is hooked via the i_list. (and sorta the
  * free_i_list)
  *
  *
@@ -96,15 +96,15 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-void fsnotify_get_mark(struct fsnotify_mark *entry)
+void fsnotify_get_mark(struct fsnotify_mark *mark)
 {
-	atomic_inc(&entry->refcnt);
+	atomic_inc(&mark->refcnt);
 }
 
-void fsnotify_put_mark(struct fsnotify_mark *entry)
+void fsnotify_put_mark(struct fsnotify_mark *mark)
 {
-	if (atomic_dec_and_test(&entry->refcnt))
-		entry->free_mark(entry);
+	if (atomic_dec_and_test(&mark->refcnt))
+		mark->free_mark(mark);
 }
 
 /*
@@ -112,14 +112,14 @@ void fsnotify_put_mark(struct fsnotify_mark *entry)
  */
 static void fsnotify_recalc_inode_mask_locked(struct inode *inode)
 {
-	struct fsnotify_mark *entry;
+	struct fsnotify_mark *mark;
 	struct hlist_node *pos;
 	__u32 new_mask = 0;
 
 	assert_spin_locked(&inode->i_lock);
 
-	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_marks, i.i_list)
-		new_mask |= entry->mask;
+	hlist_for_each_entry(mark, pos, &inode->i_fsnotify_marks, i.i_list)
+		new_mask |= mark->mask;
 	inode->i_fsnotify_mask = new_mask;
 }
 
@@ -139,40 +139,40 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
 /*
  * Any time a mark is getting freed we end up here.
  * The caller had better be holding a reference to this mark so we don't actually
- * do the final put under the entry->lock
+ * do the final put under the mark->lock
  */
-void fsnotify_destroy_mark(struct fsnotify_mark *entry)
+void fsnotify_destroy_mark(struct fsnotify_mark *mark)
 {
 	struct fsnotify_group *group;
 	struct inode *inode;
 
-	spin_lock(&entry->lock);
+	spin_lock(&mark->lock);
 
-	group = entry->group;
-	inode = entry->i.inode;
+	group = mark->group;
+	inode = mark->i.inode;
 
 	BUG_ON(group && !inode);
 	BUG_ON(!group && inode);
 
 	/* if !group something else already marked this to die */
 	if (!group) {
-		spin_unlock(&entry->lock);
+		spin_unlock(&mark->lock);
 		return;
 	}
 
 	/* 1 from caller and 1 for being on i_list/g_list */
-	BUG_ON(atomic_read(&entry->refcnt) < 2);
+	BUG_ON(atomic_read(&mark->refcnt) < 2);
 
 	spin_lock(&group->mark_lock);
 	spin_lock(&inode->i_lock);
 
-	hlist_del_init(&entry->i.i_list);
-	entry->i.inode = NULL;
+	hlist_del_init(&mark->i.i_list);
+	mark->i.inode = NULL;
 
-	list_del_init(&entry->g_list);
-	entry->group = NULL;
+	list_del_init(&mark->g_list);
+	mark->group = NULL;
 
-	fsnotify_put_mark(entry); /* for i_list and g_list */
+	fsnotify_put_mark(mark); /* for i_list and g_list */
 
 	/*
 	 * this mark is now off the inode->i_fsnotify_marks list and we
@@ -183,21 +183,21 @@ void fsnotify_destroy_mark(struct fsnotify_mark *entry)
 
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&group->mark_lock);
-	spin_unlock(&entry->lock);
+	spin_unlock(&mark->lock);
 
 	/*
 	 * Some groups like to know that marks are being freed.  This is a
-	 * callback to the group function to let it know that this entry
+	 * callback to the group function to let it know that this mark
 	 * is being freed.
 	 */
 	if (group->ops->freeing_mark)
-		group->ops->freeing_mark(entry, group);
+		group->ops->freeing_mark(mark, group);
 
 	/*
 	 * __fsnotify_update_child_dentry_flags(inode);
 	 *
 	 * I really want to call that, but we can't, we have no idea if the inode
-	 * still exists the second we drop the entry->lock.
+	 * still exists the second we drop the mark->lock.
 	 *
 	 * The next time an event arrive to this inode from one of it's children
 	 * __fsnotify_parent will see that the inode doesn't care about it's
@@ -222,20 +222,20 @@ void fsnotify_destroy_mark(struct fsnotify_mark *entry)
  */
 void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
 {
-	struct fsnotify_mark *lentry, *entry;
+	struct fsnotify_mark *lmark, *mark;
 	LIST_HEAD(free_list);
 
 	spin_lock(&group->mark_lock);
-	list_for_each_entry_safe(entry, lentry, &group->marks_list, g_list) {
-		list_add(&entry->free_g_list, &free_list);
-		list_del_init(&entry->g_list);
-		fsnotify_get_mark(entry);
+	list_for_each_entry_safe(mark, lmark, &group->marks_list, g_list) {
+		list_add(&mark->free_g_list, &free_list);
+		list_del_init(&mark->g_list);
+		fsnotify_get_mark(mark);
 	}
 	spin_unlock(&group->mark_lock);
 
-	list_for_each_entry_safe(entry, lentry, &free_list, free_g_list) {
-		fsnotify_destroy_mark(entry);
-		fsnotify_put_mark(entry);
+	list_for_each_entry_safe(mark, lmark, &free_list, free_g_list) {
+		fsnotify_destroy_mark(mark);
+		fsnotify_put_mark(mark);
 	}
 }
 
@@ -244,21 +244,21 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
  */
 void fsnotify_clear_marks_by_inode(struct inode *inode)
 {
-	struct fsnotify_mark *entry, *lentry;
+	struct fsnotify_mark *mark, *lmark;
 	struct hlist_node *pos, *n;
 	LIST_HEAD(free_list);
 
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry_safe(entry, pos, n, &inode->i_fsnotify_marks, i.i_list) {
-		list_add(&entry->i.free_i_list, &free_list);
-		hlist_del_init(&entry->i.i_list);
-		fsnotify_get_mark(entry);
+	hlist_for_each_entry_safe(mark, pos, n, &inode->i_fsnotify_marks, i.i_list) {
+		list_add(&mark->i.free_i_list, &free_list);
+		hlist_del_init(&mark->i.i_list);
+		fsnotify_get_mark(mark);
 	}
 	spin_unlock(&inode->i_lock);
 
-	list_for_each_entry_safe(entry, lentry, &free_list, i.free_i_list) {
-		fsnotify_destroy_mark(entry);
-		fsnotify_put_mark(entry);
+	list_for_each_entry_safe(mark, lmark, &free_list, i.free_i_list) {
+		fsnotify_destroy_mark(mark);
+		fsnotify_put_mark(mark);
 	}
 }
 
@@ -269,15 +269,15 @@ void fsnotify_clear_marks_by_inode(struct inode *inode)
 struct fsnotify_mark *fsnotify_find_mark(struct fsnotify_group *group,
 					 struct inode *inode)
 {
-	struct fsnotify_mark *entry;
+	struct fsnotify_mark *mark;
 	struct hlist_node *pos;
 
 	assert_spin_locked(&inode->i_lock);
 
-	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_marks, i.i_list) {
-		if (entry->group == group) {
-			fsnotify_get_mark(entry);
-			return entry;
+	hlist_for_each_entry(mark, pos, &inode->i_fsnotify_marks, i.i_list) {
+		if (mark->group == group) {
+			fsnotify_get_mark(mark);
+			return mark;
 		}
 	}
 	return NULL;
@@ -295,35 +295,35 @@ void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *ol
 /*
  * Nothing fancy, just initialize lists and locks and counters.
  */
-void fsnotify_init_mark(struct fsnotify_mark *entry,
-			void (*free_mark)(struct fsnotify_mark *entry))
+void fsnotify_init_mark(struct fsnotify_mark *mark,
+			void (*free_mark)(struct fsnotify_mark *mark))
 {
-	spin_lock_init(&entry->lock);
-	atomic_set(&entry->refcnt, 1);
-	INIT_HLIST_NODE(&entry->i.i_list);
-	entry->group = NULL;
-	entry->mask = 0;
-	entry->i.inode = NULL;
-	entry->free_mark = free_mark;
+	spin_lock_init(&mark->lock);
+	atomic_set(&mark->refcnt, 1);
+	INIT_HLIST_NODE(&mark->i.i_list);
+	mark->group = NULL;
+	mark->mask = 0;
+	mark->i.inode = NULL;
+	mark->free_mark = free_mark;
 }
 
 /*
- * Attach an initialized mark entry to a given group and inode.
+ * Attach an initialized mark mark to a given group and inode.
  * These marks may be used for the fsnotify backend to determine which
  * event types should be delivered to which group and for which inodes.
  */
-int fsnotify_add_mark(struct fsnotify_mark *entry,
+int fsnotify_add_mark(struct fsnotify_mark *mark,
 		      struct fsnotify_group *group, struct inode *inode,
 		      int allow_dups)
 {
-	struct fsnotify_mark *lentry = NULL;
+	struct fsnotify_mark *lmark = NULL;
 	int ret = 0;
 
 	inode = igrab(inode);
 	if (unlikely(!inode))
 		return -EINVAL;
 
-	entry->flags = FSNOTIFY_MARK_FLAG_INODE;
+	mark->flags = FSNOTIFY_MARK_FLAG_INODE;
 
 	/*
 	 * if this group isn't being testing for inode type events we need
@@ -341,24 +341,24 @@ int fsnotify_add_mark(struct fsnotify_mark *entry,
 
 	/*
 	 * LOCKING ORDER!!!!
-	 * entry->lock
+	 * mark->lock
 	 * group->mark_lock
 	 * inode->i_lock
 	 */
-	spin_lock(&entry->lock);
+	spin_lock(&mark->lock);
 	spin_lock(&group->mark_lock);
 	spin_lock(&inode->i_lock);
 
 	if (!allow_dups)
-		lentry = fsnotify_find_mark(group, inode);
-	if (!lentry) {
-		entry->group = group;
-		entry->i.inode = inode;
+		lmark = fsnotify_find_mark(group, inode);
+	if (!lmark) {
+		mark->group = group;
+		mark->i.inode = inode;
 
-		hlist_add_head(&entry->i.i_list, &inode->i_fsnotify_marks);
-		list_add(&entry->g_list, &group->marks_list);
+		hlist_add_head(&mark->i.i_list, &inode->i_fsnotify_marks);
+		list_add(&mark->g_list, &group->marks_list);
 
-		fsnotify_get_mark(entry); /* for i_list and g_list */
+		fsnotify_get_mark(mark); /* for i_list and g_list */
 
 		atomic_inc(&group->num_marks);
 
@@ -367,12 +367,12 @@ int fsnotify_add_mark(struct fsnotify_mark *entry,
 
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&group->mark_lock);
-	spin_unlock(&entry->lock);
+	spin_unlock(&mark->lock);
 
-	if (lentry) {
+	if (lmark) {
 		ret = -EEXIST;
 		iput(inode);
-		fsnotify_put_mark(lentry);
+		fsnotify_put_mark(lmark);
 	} else {
 		__fsnotify_update_child_dentry_flags(inode);
 	}
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 83b6bfe..ff654c1 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -83,7 +83,7 @@ struct fsnotify_ops {
 				  int data_type);
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
-	void (*freeing_mark)(struct fsnotify_mark *entry, struct fsnotify_group *group);
+	void (*freeing_mark)(struct fsnotify_mark *mark, struct fsnotify_group *group);
 	void (*free_event_priv)(struct fsnotify_event_private_data *priv);
 };
 
@@ -135,7 +135,7 @@ struct fsnotify_group {
 
 	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
 	spinlock_t mark_lock;		/* protect marks_list */
-	atomic_t num_marks;		/* 1 for each mark entry and 1 for not being
+	atomic_t num_marks;		/* 1 for each mark and 1 for not being
 					 * past the point of no return when freeing
 					 * a group */
 	struct list_head marks_list;	/* all inode marks for this group */
@@ -229,7 +229,7 @@ struct fsnotify_event {
  * Inode specific fields in an fsnotify_mark
  */
 struct fsnotify_inode_mark {
-	struct inode *inode;		/* inode this entry is associated with */
+	struct inode *inode;		/* inode this mark is associated with */
 	struct hlist_node i_list;	/* list of marks by inode->i_fsnotify_marks */
 	struct list_head free_i_list;	/* tmp list used when freeing this mark */
 };
@@ -238,13 +238,13 @@ struct fsnotify_inode_mark {
  * Mount point specific fields in an fsnotify_mark
  */
 struct fsnotify_vfsmount_mark {
-	struct vfsmount *mnt;		/* inode this entry is associated with */
+	struct vfsmount *mnt;		/* vfsmount this mark is associated with */
 	struct hlist_node m_list;	/* list of marks by inode->i_fsnotify_marks */
 	struct list_head free_m_list;	/* tmp list used when freeing this mark */
 };
 
 /*
- * a mark is simply an entry attached to an in core inode which allows an
+ * a mark is simply an object attached to an in core inode which allows an
  * fsnotify listener to indicate they are either no longer interested in events
  * of a type matching mask or only interested in those events.
  *
@@ -254,11 +254,11 @@ struct fsnotify_vfsmount_mark {
  * inode eviction or modification.
  */
 struct fsnotify_mark {
-	__u32 mask;			/* mask this mark entry is for */
+	__u32 mask;			/* mask this mark is for */
 	/* we hold ref for each i_list and g_list.  also one ref for each 'thing'
 	 * in kernel that found and may be using this mark. */
 	atomic_t refcnt;		/* active things looking at this mark */
-	struct fsnotify_group *group;	/* group this mark entry is for */
+	struct fsnotify_group *group;	/* group this mark is for */
 	struct list_head g_list;	/* list of marks by group->i_fsnotify_marks */
 	spinlock_t lock;		/* protect group and inode */
 	union {
@@ -269,7 +269,7 @@ struct fsnotify_mark {
 #define FSNOTIFY_MARK_FLAG_INODE	0x01
 #define FSNOTIFY_MARK_FLAG_VFSMOUNT	0x02
 	unsigned int flags;		/* vfsmount or inode mark? */
-	void (*free_mark)(struct fsnotify_mark *entry); /* called on final put+free */
+	void (*free_mark)(struct fsnotify_mark *mark); /* called on final put+free */
 };
 
 #ifdef CONFIG_FSNOTIFY
@@ -361,19 +361,19 @@ extern struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group
 
 /* run all marks associated with an inode and update inode->i_fsnotify_mask */
 extern void fsnotify_recalc_inode_mask(struct inode *inode);
-extern void fsnotify_init_mark(struct fsnotify_mark *entry, void (*free_mark)(struct fsnotify_mark *entry));
+extern void fsnotify_init_mark(struct fsnotify_mark *mark, void (*free_mark)(struct fsnotify_mark *mark));
 /* find (and take a reference) to a mark associated with group and inode */
 extern struct fsnotify_mark *fsnotify_find_mark(struct fsnotify_group *group, struct inode *inode);
 /* copy the values from old into new */
 extern void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old);
 /* attach the mark to both the group and the inode */
-extern int fsnotify_add_mark(struct fsnotify_mark *entry, struct fsnotify_group *group, struct inode *inode, int allow_dups);
+extern int fsnotify_add_mark(struct fsnotify_mark *mark, struct fsnotify_group *group, struct inode *inode, int allow_dups);
 /* given a mark, flag it to be freed when all references are dropped */
-extern void fsnotify_destroy_mark(struct fsnotify_mark *entry);
+extern void fsnotify_destroy_mark(struct fsnotify_mark *mark);
 /* run all the marks in a group, and flag them to be freed */
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
-extern void fsnotify_get_mark(struct fsnotify_mark *entry);
-extern void fsnotify_put_mark(struct fsnotify_mark *entry);
+extern void fsnotify_get_mark(struct fsnotify_mark *mark);
+extern void fsnotify_put_mark(struct fsnotify_mark *mark);
 extern void fsnotify_unmount_inodes(struct list_head *list);
 
 /* put here because inotify does some weird stuff when destroying watches */

