Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZJ0TKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZJ0TKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZJ0TKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:10:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbZJ0TJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:09:57 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/6] fsnotify: rename fsnotify_mark_entry to just fsnotify_mark
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Tue, 27 Oct 2009 15:09:59 -0400
Message-ID: <20091027190959.27472.13750.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
References: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name is long and it serves no real purpose.  So rename
fsnotify_mark_entry to just fsnotify_mark.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/inode.c                           |    2 +
 fs/notify/dnotify/dnotify.c          |   24 +++++++++--------
 fs/notify/group.c                    |    8 +++---
 fs/notify/inode_mark.c               |   48 +++++++++++++++++-----------------
 fs/notify/inotify/inotify.h          |    6 ++--
 fs/notify/inotify/inotify_fsnotify.c |    8 +++---
 fs/notify/inotify/inotify_user.c     |    8 +++---
 include/linux/fs.h                   |    2 +
 include/linux/fsnotify.h             |   20 +++++++-------
 include/linux/fsnotify_backend.h     |   38 +++++++++++++--------------
 kernel/audit_tree.c                  |   14 +++++-----
 kernel/audit_watch.c                 |    8 +++---
 kernel/auditsc.c                     |    4 +--
 13 files changed, 95 insertions(+), 95 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 06c1f02..b440974 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -270,7 +270,7 @@ void inode_init_once(struct inode *inode)
 	mutex_init(&inode->inotify_mutex);
 #endif
 #ifdef CONFIG_FSNOTIFY
-	INIT_HLIST_HEAD(&inode->i_fsnotify_mark_entries);
+	INIT_HLIST_HEAD(&inode->i_fsnotify_marks);
 #endif
 }
 EXPORT_SYMBOL(inode_init_once);
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index fc3a9dc..e6edae6 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -34,12 +34,12 @@ static struct fsnotify_group *dnotify_group __read_mostly;
 static DEFINE_MUTEX(dnotify_mark_mutex);
 
 /*
- * dnotify will attach one of these to each inode (i_fsnotify_mark_entries) which
+ * dnotify will attach one of these to each inode (i_fsnotify_marks) which
  * is being watched by dnotify.  If multiple userspace applications are watching
  * the same directory with dnotify their information is chained in dn
  */
 struct dnotify_mark_entry {
-	struct fsnotify_mark_entry fsn_entry;
+	struct fsnotify_mark fsn_entry;
 	struct dnotify_struct *dn;
 };
 
@@ -51,7 +51,7 @@ struct dnotify_mark_entry {
  * it calls the fsnotify function so it can update the set of all events relevant
  * to this inode.
  */
-static void dnotify_recalc_inode_mask(struct fsnotify_mark_entry *entry)
+static void dnotify_recalc_inode_mask(struct fsnotify_mark *entry)
 {
 	__u32 new_mask, old_mask;
 	struct dnotify_struct *dn;
@@ -85,7 +85,7 @@ static void dnotify_recalc_inode_mask(struct fsnotify_mark_entry *entry)
 static int dnotify_handle_event(struct fsnotify_group *group,
 				struct fsnotify_event *event)
 {
-	struct fsnotify_mark_entry *entry = NULL;
+	struct fsnotify_mark *entry = NULL;
 	struct dnotify_mark_entry *dnentry;
 	struct inode *to_tell;
 	struct dnotify_struct *dn;
@@ -136,7 +136,7 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 				      struct inode *inode, struct vfsmount *mnt,
 				      __u32 mask, void *data, int data_type)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	bool send;
 
 	/* !dir_notify_enable should never get here, don't waste time checking
@@ -163,7 +163,7 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 	return send;
 }
 
-static void dnotify_free_mark(struct fsnotify_mark_entry *entry)
+static void dnotify_free_mark(struct fsnotify_mark *entry)
 {
 	struct dnotify_mark_entry *dnentry = container_of(entry,
 							  struct dnotify_mark_entry,
@@ -184,14 +184,14 @@ static struct fsnotify_ops dnotify_fsnotify_ops = {
 
 /*
  * Called every time a file is closed.  Looks first for a dnotify mark on the
- * inode.  If one is found run all of the ->dn entries attached to that
+ * inode.  If one is found run all of the ->dn structures attached to that
  * mark for one relevant to this process closing the file and remove that
  * dnotify_struct.  If that was the last dnotify_struct also remove the
- * fsnotify_mark_entry.
+ * fsnotify_mark.
  */
 void dnotify_flush(struct file *filp, fl_owner_t id)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	struct dnotify_mark_entry *dnentry;
 	struct dnotify_struct *dn;
 	struct dnotify_struct **prev;
@@ -260,7 +260,7 @@ static __u32 convert_arg(unsigned long arg)
 
 /*
  * If multiple processes watch the same inode with dnotify there is only one
- * dnotify mark in inode->i_fsnotify_mark_entries but we chain a dnotify_struct
+ * dnotify mark in inode->i_fsnotify_marks but we chain a dnotify_struct
  * onto that mark.  This function either attaches the new dnotify_struct onto
  * that list, or it |= the mask onto an existing dnofiy_struct.
  */
@@ -298,7 +298,7 @@ static int attach_dn(struct dnotify_struct *dn, struct dnotify_mark_entry *dnent
 int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 {
 	struct dnotify_mark_entry *new_dnentry, *dnentry;
-	struct fsnotify_mark_entry *new_entry, *entry;
+	struct fsnotify_mark *new_entry, *entry;
 	struct dnotify_struct *dn;
 	struct inode *inode;
 	fl_owner_t id = current->files;
@@ -378,7 +378,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 	/* if (f != filp) means that we lost a race and another task/thread
 	 * actually closed the fd we are still playing with before we grabbed
 	 * the dnotify_mark_mutex and entry->lock.  Since closing the fd is the
-	 * only time we clean up the mark entries we need to get our mark off
+	 * only time we clean up the marks we need to get our mark off
 	 * the list. */
 	if (f != filp) {
 		/* if we added ourselves, shoot ourselves, it's possible that
diff --git a/fs/notify/group.c b/fs/notify/group.c
index aa4654f..b70e7d2 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -74,10 +74,10 @@ void fsnotify_recalc_group_mask(struct fsnotify_group *group)
 {
 	__u32 mask = 0;
 	__u32 old_mask = group->mask;
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 
 	spin_lock(&group->mark_lock);
-	list_for_each_entry(entry, &group->mark_entries, g_list)
+	list_for_each_entry(entry, &group->marks_list, g_list)
 		mask |= entry->mask;
 	spin_unlock(&group->mark_lock);
 
@@ -133,7 +133,7 @@ void fsnotify_final_destroy_group(struct fsnotify_group *group)
  */
 static void fsnotify_destroy_group(struct fsnotify_group *group)
 {
-	/* clear all inode mark entries for this group */
+	/* clear all inode marks for this group */
 	fsnotify_clear_marks_by_group(group);
 
 	/* past the point of no return, matches the initial value of 1 */
@@ -224,7 +224,7 @@ struct fsnotify_group *fsnotify_alloc_group(const struct fsnotify_ops *ops)
 	INIT_LIST_HEAD(&group->vfsmount_group_list);
 
 	spin_lock_init(&group->mark_lock);
-	INIT_LIST_HEAD(&group->mark_entries);
+	INIT_LIST_HEAD(&group->marks_list);
 
 	group->ops = ops;
 
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index cee4404..c01a4a9 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -38,12 +38,12 @@
  * that lock to dereference either of these things (they could be NULL even with
  * the lock)
  *
- * group->mark_lock protects the mark_entries list anchored inside a given group
+ * group->mark_lock protects the marks_list anchored inside a given group
  * and each entry is hooked via the g_list.  It also sorta protects the
  * free_g_list, which when used is anchored by a private list on the stack of the
  * task which held the group->mark_lock.
  *
- * inode->i_lock protects the i_fsnotify_mark_entries list anchored inside a
+ * inode->i_lock protects the i_fsnotify_marks list anchored inside a
  * given inode and each entry is hooked via the i_list. (and sorta the
  * free_i_list)
  *
@@ -61,7 +61,7 @@
  *   need to be cleaned up. (fsnotify_clear_marks_by_group)
  *
  * Worst case we are given an inode and need to clean up all the marks on that
- * inode.  We take i_lock and walk the i_fsnotify_mark_entries safely.  For each
+ * inode.  We take i_lock and walk the i_fsnotify_marks safely.  For each
  * mark on the list we take a reference (so the mark can't disappear under us).
  * We remove that mark form the inode's list of marks and we add this mark to a
  * private list anchored on the stack using i_free_list;  At this point we no
@@ -96,12 +96,12 @@
 #include <linux/fsnotify_backend.h>
 #include "fsnotify.h"
 
-void fsnotify_get_mark(struct fsnotify_mark_entry *entry)
+void fsnotify_get_mark(struct fsnotify_mark *entry)
 {
 	atomic_inc(&entry->refcnt);
 }
 
-void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
+void fsnotify_put_mark(struct fsnotify_mark *entry)
 {
 	if (atomic_dec_and_test(&entry->refcnt))
 		entry->free_mark(entry);
@@ -112,13 +112,13 @@ void fsnotify_put_mark(struct fsnotify_mark_entry *entry)
  */
 static void fsnotify_recalc_inode_mask_locked(struct inode *inode)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	struct hlist_node *pos;
 	__u32 new_mask = 0;
 
 	assert_spin_locked(&inode->i_lock);
 
-	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_mark_entries, i.i_list)
+	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_marks, i.i_list)
 		new_mask |= entry->mask;
 	inode->i_fsnotify_mask = new_mask;
 }
@@ -141,7 +141,7 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
  * The caller had better be holding a reference to this mark so we don't actually
  * do the final put under the entry->lock
  */
-void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
+void fsnotify_destroy_mark_by_entry(struct fsnotify_mark *entry)
 {
 	struct fsnotify_group *group;
 	struct inode *inode;
@@ -175,7 +175,7 @@ void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
 	fsnotify_put_mark(entry); /* for i_list and g_list */
 
 	/*
-	 * this mark is now off the inode->i_fsnotify_mark_entries list and we
+	 * this mark is now off the inode->i_fsnotify_marks list and we
 	 * hold the inode->i_lock, so this is the perfect time to update the
 	 * inode->i_fsnotify_mask
 	 */
@@ -222,11 +222,11 @@ void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry)
  */
 void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
 {
-	struct fsnotify_mark_entry *lentry, *entry;
+	struct fsnotify_mark *lentry, *entry;
 	LIST_HEAD(free_list);
 
 	spin_lock(&group->mark_lock);
-	list_for_each_entry_safe(entry, lentry, &group->mark_entries, g_list) {
+	list_for_each_entry_safe(entry, lentry, &group->marks_list, g_list) {
 		list_add(&entry->free_g_list, &free_list);
 		list_del_init(&entry->g_list);
 		fsnotify_get_mark(entry);
@@ -244,12 +244,12 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
  */
 void fsnotify_clear_marks_by_inode(struct inode *inode)
 {
-	struct fsnotify_mark_entry *entry, *lentry;
+	struct fsnotify_mark *entry, *lentry;
 	struct hlist_node *pos, *n;
 	LIST_HEAD(free_list);
 
 	spin_lock(&inode->i_lock);
-	hlist_for_each_entry_safe(entry, pos, n, &inode->i_fsnotify_mark_entries, i.i_list) {
+	hlist_for_each_entry_safe(entry, pos, n, &inode->i_fsnotify_marks, i.i_list) {
 		list_add(&entry->i.free_i_list, &free_list);
 		hlist_del_init(&entry->i.i_list);
 		fsnotify_get_mark(entry);
@@ -266,15 +266,15 @@ void fsnotify_clear_marks_by_inode(struct inode *inode)
  * given a group and inode, find the mark associated with that combination.
  * if found take a reference to that mark and return it, else return NULL
  */
-struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group,
-						     struct inode *inode)
+struct fsnotify_mark *fsnotify_find_mark_entry(struct fsnotify_group *group,
+					       struct inode *inode)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	struct hlist_node *pos;
 
 	assert_spin_locked(&inode->i_lock);
 
-	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_mark_entries, i.i_list) {
+	hlist_for_each_entry(entry, pos, &inode->i_fsnotify_marks, i.i_list) {
 		if (entry->group == group) {
 			fsnotify_get_mark(entry);
 			return entry;
@@ -283,7 +283,7 @@ struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *grou
 	return NULL;
 }
 
-void fsnotify_duplicate_mark(struct fsnotify_mark_entry *new, struct fsnotify_mark_entry *old)
+void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old)
 {
 	assert_spin_locked(&old->lock);
 	new->i.inode = old->i.inode;
@@ -295,8 +295,8 @@ void fsnotify_duplicate_mark(struct fsnotify_mark_entry *new, struct fsnotify_ma
 /*
  * Nothing fancy, just initialize lists and locks and counters.
  */
-void fsnotify_init_mark(struct fsnotify_mark_entry *entry,
-			void (*free_mark)(struct fsnotify_mark_entry *entry))
+void fsnotify_init_mark(struct fsnotify_mark *entry,
+			void (*free_mark)(struct fsnotify_mark *entry))
 {
 	spin_lock_init(&entry->lock);
 	atomic_set(&entry->refcnt, 1);
@@ -312,11 +312,11 @@ void fsnotify_init_mark(struct fsnotify_mark_entry *entry,
  * These marks may be used for the fsnotify backend to determine which
  * event types should be delivered to which group and for which inodes.
  */
-int fsnotify_add_mark(struct fsnotify_mark_entry *entry,
+int fsnotify_add_mark(struct fsnotify_mark *entry,
 		      struct fsnotify_group *group, struct inode *inode,
 		      int allow_dups)
 {
-	struct fsnotify_mark_entry *lentry = NULL;
+	struct fsnotify_mark *lentry = NULL;
 	int ret = 0;
 
 	inode = igrab(inode);
@@ -355,8 +355,8 @@ int fsnotify_add_mark(struct fsnotify_mark_entry *entry,
 		entry->group = group;
 		entry->i.inode = inode;
 
-		hlist_add_head(&entry->i.i_list, &inode->i_fsnotify_mark_entries);
-		list_add(&entry->g_list, &group->mark_entries);
+		hlist_add_head(&entry->i.i_list, &inode->i_fsnotify_marks);
+		list_add(&entry->g_list, &group->marks_list);
 
 		fsnotify_get_mark(entry); /* for i_list and g_list */
 
diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
index f234f3a..07be6df 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -10,12 +10,12 @@ struct inotify_event_private_data {
 };
 
 struct inotify_inode_mark_entry {
-	/* fsnotify_mark_entry MUST be the first thing */
-	struct fsnotify_mark_entry fsn_entry;
+	/* fsnotify_mark MUST be the first thing */
+	struct fsnotify_mark fsn_entry;
 	int wd;
 };
 
-extern void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
+extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *entry,
 					   struct fsnotify_group *group);
 extern void inotify_free_event_priv(struct fsnotify_event_private_data *event_priv);
 
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index badf1a9..0777a09 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -87,7 +87,7 @@ static int inotify_merge(struct list_head *list, struct fsnotify_event *event)
 
 static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_event *event)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	struct inotify_inode_mark_entry *ientry;
 	struct inode *to_tell;
 	struct inotify_event_private_data *event_priv;
@@ -134,7 +134,7 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 	return ret;
 }
 
-static void inotify_freeing_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group)
+static void inotify_freeing_mark(struct fsnotify_mark *entry, struct fsnotify_group *group)
 {
 	inotify_ignored_and_remove_idr(entry, group);
 }
@@ -143,7 +143,7 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
 				      struct vfsmount *mnt, __u32 mask, void *data,
 				      int data_type)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	bool send;
 
 	spin_lock(&inode->i_lock);
@@ -170,7 +170,7 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
  */
 static int idr_callback(int id, void *p, void *data)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	struct inotify_inode_mark_entry *ientry;
 	static bool warned = false;
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index f323a02..4979f14 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -394,7 +394,7 @@ static struct inotify_inode_mark_entry *inotify_idr_find_locked(struct fsnotify_
 
 	ientry = idr_find(idr, wd);
 	if (ientry) {
-		struct fsnotify_mark_entry *fsn_entry = &ientry->fsn_entry;
+		struct fsnotify_mark *fsn_entry = &ientry->fsn_entry;
 
 		fsnotify_get_mark(fsn_entry);
 		/* One ref for being in the idr, one ref we just took */
@@ -510,7 +510,7 @@ out:
 /*
  * Send IN_IGNORED for this wd, remove this wd from the idr.
  */
-void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
+void inotify_ignored_and_remove_idr(struct fsnotify_mark *entry,
 				    struct fsnotify_group *group)
 {
 	struct inotify_inode_mark_entry *ientry;
@@ -552,7 +552,7 @@ skip_send_ignore:
 }
 
 /* ding dong the mark is dead */
-static void inotify_free_mark(struct fsnotify_mark_entry *entry)
+static void inotify_free_mark(struct fsnotify_mark *entry)
 {
 	struct inotify_inode_mark_entry *ientry;
 
@@ -565,7 +565,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 					 struct inode *inode,
 					 u32 arg)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	struct inotify_inode_mark_entry *ientry;
 	__u32 old_mask, new_mask;
 	__u32 mask;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2620a8c..6292328 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -762,7 +762,7 @@ struct inode {
 
 #ifdef CONFIG_FSNOTIFY
 	__u32			i_fsnotify_mask; /* all events this inode cares about */
-	struct hlist_head	i_fsnotify_mark_entries; /* fsnotify mark entries */
+	struct hlist_head	i_fsnotify_marks;
 #endif
 
 #ifdef CONFIG_INOTIFY
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 2d032b9..294f488 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -20,12 +20,12 @@
  * fsnotify_d_instantiate - instantiate a dentry for inode
  * Called with dcache_lock held.
  */
-static inline void fsnotify_d_instantiate(struct dentry *entry,
+static inline void fsnotify_d_instantiate(struct dentry *dentry,
 						struct inode *inode)
 {
-	__fsnotify_d_instantiate(entry, inode);
+	__fsnotify_d_instantiate(dentry, inode);
 
-	inotify_d_instantiate(entry, inode);
+	inotify_d_instantiate(dentry, inode);
 }
 
 /* Notify this dentry's parent about a child's events. */
@@ -40,18 +40,18 @@ static inline void fsnotify_parent(struct path *path, struct dentry *dentry, __u
 }
 
 /*
- * fsnotify_d_move - entry has been moved
- * Called with dcache_lock and entry->d_lock held.
+ * fsnotify_d_move - dentry has been moved
+ * Called with dcache_lock and dentry->d_lock held.
  */
-static inline void fsnotify_d_move(struct dentry *entry)
+static inline void fsnotify_d_move(struct dentry *dentry)
 {
 	/*
-	 * On move we need to update entry->d_flags to indicate if the new parent
-	 * cares about events from this entry.
+	 * On move we need to update dentry->d_flags to indicate if the new parent
+	 * cares about events from this dentry.
 	 */
-	__fsnotify_update_dcache_flags(entry);
+	__fsnotify_update_dcache_flags(dentry);
 
-	inotify_d_move(entry);
+	inotify_d_move(dentry);
 }
 
 /*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 7a6ba75..59c072e 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -62,7 +62,7 @@
 
 struct fsnotify_group;
 struct fsnotify_event;
-struct fsnotify_mark_entry;
+struct fsnotify_mark;
 struct fsnotify_event_private_data;
 
 /*
@@ -83,7 +83,7 @@ struct fsnotify_ops {
 				  int data_type);
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
-	void (*freeing_mark)(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
+	void (*freeing_mark)(struct fsnotify_mark *entry, struct fsnotify_group *group);
 	void (*free_event_priv)(struct fsnotify_event_private_data *priv);
 };
 
@@ -133,12 +133,12 @@ struct fsnotify_group {
 	unsigned int q_len;			/* events on the queue */
 	unsigned int max_events;		/* maximum events allowed on the list */
 
-	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
-	spinlock_t mark_lock;		/* protect mark_entries list */
+	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
+	spinlock_t mark_lock;		/* protect marks_list */
 	atomic_t num_marks;		/* 1 for each mark entry and 1 for not being
 					 * past the point of no return when freeing
 					 * a group */
-	struct list_head mark_entries;	/* all inode mark entries for this group */
+	struct list_head marks_list;	/* all inode marks for this group */
 
 	/* prevents double list_del of group_list.  protected by global fsnotify_grp_mutex */
 	bool on_inode_group_list;
@@ -226,20 +226,20 @@ struct fsnotify_event {
 };
 
 /*
- * Inode specific fields in an fsnotify_mark_entry
+ * Inode specific fields in an fsnotify_mark
  */
 struct fsnotify_inode_mark {
 	struct inode *inode;		/* inode this entry is associated with */
-	struct hlist_node i_list;	/* list of mark_entries by inode->i_fsnotify_mark_entries */
+	struct hlist_node i_list;	/* list of marks by inode->i_fsnotify_marks */
 	struct list_head free_i_list;	/* tmp list used when freeing this mark */
 };
 
 /*
- * Mount point specific fields in an fsnotify_mark_entry
+ * Mount point specific fields in an fsnotify_mark
  */
 struct fsnotify_vfsmount_mark {
 	struct vfsmount *mnt;		/* inode this entry is associated with */
-	struct hlist_node m_list;	/* list of mark_entries by inode->i_fsnotify_mark_entries */
+	struct hlist_node m_list;	/* list of marks by inode->i_fsnotify_marks */
 	struct list_head free_m_list;	/* tmp list used when freeing this mark */
 };
 
@@ -253,13 +253,13 @@ struct fsnotify_vfsmount_mark {
  * (such as dnotify) will flush these when the open fd is closed and not at
  * inode eviction or modification.
  */
-struct fsnotify_mark_entry {
+struct fsnotify_mark {
 	__u32 mask;			/* mask this mark entry is for */
 	/* we hold ref for each i_list and g_list.  also one ref for each 'thing'
 	 * in kernel that found and may be using this mark. */
 	atomic_t refcnt;		/* active things looking at this mark */
 	struct fsnotify_group *group;	/* group this mark entry is for */
-	struct list_head g_list;	/* list of mark_entries by group->i_fsnotify_mark_entries */
+	struct list_head g_list;	/* list of marks by group->i_fsnotify_marks */
 	spinlock_t lock;		/* protect group and inode */
 	union {
 		struct fsnotify_inode_mark i;
@@ -269,7 +269,7 @@ struct fsnotify_mark_entry {
 #define FSNOTIFY_MARK_FLAG_INODE	0x01
 #define FSNOTIFY_MARK_FLAG_VFSMOUNT	0x02
 	unsigned int flags;		/* vfsmount or inode mark? */
-	void (*free_mark)(struct fsnotify_mark_entry *entry); /* called on final put+free */
+	void (*free_mark)(struct fsnotify_mark *entry); /* called on final put+free */
 };
 
 #ifdef CONFIG_FSNOTIFY
@@ -361,19 +361,19 @@ extern struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group
 
 /* run all marks associated with an inode and update inode->i_fsnotify_mask */
 extern void fsnotify_recalc_inode_mask(struct inode *inode);
-extern void fsnotify_init_mark(struct fsnotify_mark_entry *entry, void (*free_mark)(struct fsnotify_mark_entry *entry));
+extern void fsnotify_init_mark(struct fsnotify_mark *entry, void (*free_mark)(struct fsnotify_mark *entry));
 /* find (and take a reference) to a mark associated with group and inode */
-extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);
+extern struct fsnotify_mark *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);
 /* copy the values from old into new */
-extern void fsnotify_duplicate_mark(struct fsnotify_mark_entry *new, struct fsnotify_mark_entry *old);
+extern void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old);
 /* attach the mark to both the group and the inode */
-extern int fsnotify_add_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode, int allow_dups);
+extern int fsnotify_add_mark(struct fsnotify_mark *entry, struct fsnotify_group *group, struct inode *inode, int allow_dups);
 /* given a mark, flag it to be freed when all references are dropped */
-extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
+extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark *entry);
 /* run all the marks in a group, and flag them to be freed */
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
-extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
-extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
+extern void fsnotify_get_mark(struct fsnotify_mark *entry);
+extern void fsnotify_put_mark(struct fsnotify_mark *entry);
 extern void fsnotify_unmount_inodes(struct list_head *list);
 
 /* put here because inotify does some weird stuff when destroying watches */
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index f2e191d..def7d4a 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -21,7 +21,7 @@ struct audit_tree {
 
 struct audit_chunk {
 	struct list_head hash;
-	struct fsnotify_mark_entry mark;
+	struct fsnotify_mark mark;
 	struct list_head trees;		/* with root here */
 	int dead;
 	int count;
@@ -133,7 +133,7 @@ static void __put_chunk(struct rcu_head *rcu)
 	audit_put_chunk(chunk);
 }
 
-static void audit_tree_destroy_watch(struct fsnotify_mark_entry *entry)
+static void audit_tree_destroy_watch(struct fsnotify_mark *entry)
 {
 	struct audit_chunk *chunk = container_of(entry, struct audit_chunk, mark);
 	call_rcu(&chunk->head, __put_chunk);
@@ -175,7 +175,7 @@ static inline struct list_head *chunk_hash(const struct inode *inode)
 /* hash_lock & entry->lock is held by caller */
 static void insert_hash(struct audit_chunk *chunk)
 {
-	struct fsnotify_mark_entry *entry = &chunk->mark;
+	struct fsnotify_mark *entry = &chunk->mark;
 	struct list_head *list;
 
 	if (!entry->i.inode)
@@ -221,7 +221,7 @@ static struct audit_chunk *find_chunk(struct node *p)
 static void untag_chunk(struct node *p)
 {
 	struct audit_chunk *chunk = find_chunk(p);
-	struct fsnotify_mark_entry *entry = &chunk->mark;
+	struct fsnotify_mark *entry = &chunk->mark;
 	struct audit_chunk *new;
 	struct audit_tree *owner;
 	int size = chunk->count - 1;
@@ -315,7 +315,7 @@ out:
 
 static int create_chunk(struct inode *inode, struct audit_tree *tree)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	struct audit_chunk *chunk = alloc_chunk(1);
 	if (!chunk)
 		return -ENOMEM;
@@ -353,7 +353,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 /* the first tagged inode becomes root of tree */
 static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 {
-	struct fsnotify_mark_entry *old_entry, *chunk_entry;
+	struct fsnotify_mark *old_entry, *chunk_entry;
 	struct audit_tree *owner;
 	struct audit_chunk *chunk, *old;
 	struct node *p;
@@ -950,7 +950,7 @@ static int audit_tree_handle_event(struct fsnotify_group *group, struct fsnotify
 	return -EOPNOTSUPP;
 }
 
-static void audit_tree_freeing_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group)
+static void audit_tree_freeing_mark(struct fsnotify_mark *entry, struct fsnotify_group *group)
 {
 	struct audit_chunk *chunk = container_of(entry, struct audit_chunk, mark);
 
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index ab8a5b3..010aca9 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -55,7 +55,7 @@ struct audit_watch {
 
 struct audit_parent {
 	struct list_head	watches; /* anchor for audit_watch->wlist */
-	struct fsnotify_mark_entry mark; /* fsnotify mark on the inode */
+	struct fsnotify_mark mark; /* fsnotify mark on the inode */
 };
 
 /* fsnotify handle. */
@@ -71,7 +71,7 @@ static void audit_free_parent(struct audit_parent *parent)
 	kfree(parent);
 }
 
-static void audit_watch_free_mark(struct fsnotify_mark_entry *entry)
+static void audit_watch_free_mark(struct fsnotify_mark *entry)
 {
 	struct audit_parent *parent;
 
@@ -98,7 +98,7 @@ static void audit_put_parent(struct audit_parent *parent)
 static inline struct audit_parent *audit_find_parent(struct inode *inode)
 {
 	struct audit_parent *parent = NULL;
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 
 	spin_lock(&inode->i_lock);
 	entry = fsnotify_find_mark_entry(audit_watch_group, inode);
@@ -516,7 +516,7 @@ static bool audit_watch_should_send_event(struct fsnotify_group *group, struct i
 					  struct vfsmount *mnt, __u32 mask, void *data,
 					  int data_type)
 {
-	struct fsnotify_mark_entry *entry;
+	struct fsnotify_mark *entry;
 	bool send;
 
 	spin_lock(&inode->i_lock);
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index ef0410c..880120c 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1725,7 +1725,7 @@ static inline void handle_one(const struct inode *inode)
 	struct audit_tree_refs *p;
 	struct audit_chunk *chunk;
 	int count;
-	if (likely(hlist_empty(&inode->i_fsnotify_mark_entries)))
+	if (likely(hlist_empty(&inode->i_fsnotify_marks)))
 		return;
 	context = current->audit_context;
 	p = context->trees;
@@ -1768,7 +1768,7 @@ retry:
 	seq = read_seqbegin(&rename_lock);
 	for(;;) {
 		struct inode *inode = d->d_inode;
-		if (inode && unlikely(!hlist_empty(&inode->i_fsnotify_mark_entries))) {
+		if (inode && unlikely(!hlist_empty(&inode->i_fsnotify_marks))) {
 			struct audit_chunk *chunk;
 			chunk = audit_tree_lookup(inode);
 			if (chunk) {

