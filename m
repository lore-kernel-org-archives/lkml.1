Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZJ0TKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZJ0TKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZJ0TKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:10:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664AbZJ0TKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:10:04 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/6] fsnotify: rename fsnotify_find_mark_entry to
	fsnotify_find_mark
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Tue, 27 Oct 2009 15:10:05 -0400
Message-ID: <20091027191005.27472.35279.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
References: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the _entry portion of fsnotify functions is useless.  Drop it.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c          |   14 +++++++-------
 fs/notify/inode_mark.c               |   14 +++++++-------
 fs/notify/inotify/inotify_fsnotify.c |    4 ++--
 fs/notify/inotify/inotify_user.c     |    6 +++---
 include/linux/fsnotify_backend.h     |    4 ++--
 kernel/audit_tree.c                  |   12 ++++++------
 kernel/audit_watch.c                 |    8 ++++----
 7 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index e6edae6..b202bc5 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -96,7 +96,7 @@ static int dnotify_handle_event(struct fsnotify_group *group,
 	to_tell = event->to_tell;
 
 	spin_lock(&to_tell->i_lock);
-	entry = fsnotify_find_mark_entry(group, to_tell);
+	entry = fsnotify_find_mark(group, to_tell);
 	spin_unlock(&to_tell->i_lock);
 
 	/* unlikely since we alreay passed dnotify_should_send_event() */
@@ -148,7 +148,7 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 		return false;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark_entry(group, inode);
+	entry = fsnotify_find_mark(group, inode);
 	spin_unlock(&inode->i_lock);
 
 	/* no mark means no dnotify watch */
@@ -158,7 +158,7 @@ static bool dnotify_should_send_event(struct fsnotify_group *group,
 	mask = (mask & ~FS_EVENT_ON_CHILD);
 	send = (mask & entry->mask);
 
-	fsnotify_put_mark(entry); /* matches fsnotify_find_mark_entry */
+	fsnotify_put_mark(entry); /* matches fsnotify_find_mark */
 
 	return send;
 }
@@ -202,7 +202,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 		return;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark_entry(dnotify_group, inode);
+	entry = fsnotify_find_mark(dnotify_group, inode);
 	spin_unlock(&inode->i_lock);
 	if (!entry)
 		return;
@@ -226,7 +226,7 @@ void dnotify_flush(struct file *filp, fl_owner_t id)
 
 	/* nothing else could have found us thanks to the dnotify_mark_mutex */
 	if (dnentry->dn == NULL)
-		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_destroy_mark(entry);
 
 	fsnotify_recalc_group_mask(dnotify_group);
 
@@ -357,7 +357,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 
 	/* add the new_entry or find an old one. */
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark_entry(dnotify_group, inode);
+	entry = fsnotify_find_mark(dnotify_group, inode);
 	spin_unlock(&inode->i_lock);
 	if (entry) {
 		dnentry = container_of(entry, struct dnotify_mark_entry, fsn_entry);
@@ -414,7 +414,7 @@ out:
 	spin_unlock(&entry->lock);
 
 	if (destroy)
-		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_destroy_mark(entry);
 
 	fsnotify_recalc_group_mask(dnotify_group);
 
diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
index c01a4a9..9681126 100644
--- a/fs/notify/inode_mark.c
+++ b/fs/notify/inode_mark.c
@@ -56,7 +56,7 @@
  * - The inode is unlinked for the last time.  (fsnotify_inode_remove)
  * - The inode is being evicted from cache. (fsnotify_inode_delete)
  * - The fs the inode is on is unmounted.  (fsnotify_inode_delete/fsnotify_unmount_inodes)
- * - Something explicitly requests that it be removed.  (fsnotify_destroy_mark_by_entry)
+ * - Something explicitly requests that it be removed.  (fsnotify_destroy_mark)
  * - The fsnotify_group associated with the mark is going away and all such marks
  *   need to be cleaned up. (fsnotify_clear_marks_by_group)
  *
@@ -141,7 +141,7 @@ void fsnotify_recalc_inode_mask(struct inode *inode)
  * The caller had better be holding a reference to this mark so we don't actually
  * do the final put under the entry->lock
  */
-void fsnotify_destroy_mark_by_entry(struct fsnotify_mark *entry)
+void fsnotify_destroy_mark(struct fsnotify_mark *entry)
 {
 	struct fsnotify_group *group;
 	struct inode *inode;
@@ -234,7 +234,7 @@ void fsnotify_clear_marks_by_group(struct fsnotify_group *group)
 	spin_unlock(&group->mark_lock);
 
 	list_for_each_entry_safe(entry, lentry, &free_list, free_g_list) {
-		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_destroy_mark(entry);
 		fsnotify_put_mark(entry);
 	}
 }
@@ -257,7 +257,7 @@ void fsnotify_clear_marks_by_inode(struct inode *inode)
 	spin_unlock(&inode->i_lock);
 
 	list_for_each_entry_safe(entry, lentry, &free_list, i.free_i_list) {
-		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_destroy_mark(entry);
 		fsnotify_put_mark(entry);
 	}
 }
@@ -266,8 +266,8 @@ void fsnotify_clear_marks_by_inode(struct inode *inode)
  * given a group and inode, find the mark associated with that combination.
  * if found take a reference to that mark and return it, else return NULL
  */
-struct fsnotify_mark *fsnotify_find_mark_entry(struct fsnotify_group *group,
-					       struct inode *inode)
+struct fsnotify_mark *fsnotify_find_mark(struct fsnotify_group *group,
+					 struct inode *inode)
 {
 	struct fsnotify_mark *entry;
 	struct hlist_node *pos;
@@ -350,7 +350,7 @@ int fsnotify_add_mark(struct fsnotify_mark *entry,
 	spin_lock(&inode->i_lock);
 
 	if (!allow_dups)
-		lentry = fsnotify_find_mark_entry(group, inode);
+		lentry = fsnotify_find_mark(group, inode);
 	if (!lentry) {
 		entry->group = group;
 		entry->i.inode = inode;
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 0777a09..94954c1 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -97,7 +97,7 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 	to_tell = event->to_tell;
 
 	spin_lock(&to_tell->i_lock);
-	entry = fsnotify_find_mark_entry(group, to_tell);
+	entry = fsnotify_find_mark(group, to_tell);
 	spin_unlock(&to_tell->i_lock);
 	/* race with watch removal?  We already passes should_send */
 	if (unlikely(!entry))
@@ -147,7 +147,7 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
 	bool send;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark_entry(group, inode);
+	entry = fsnotify_find_mark(group, inode);
 	spin_unlock(&inode->i_lock);
 	if (!entry)
 		return false;
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4979f14..4733e50 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -578,7 +578,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 		return -EINVAL;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark_entry(group, inode);
+	entry = fsnotify_find_mark(group, inode);
 	spin_unlock(&inode->i_lock);
 	if (!entry)
 		return -ENOENT;
@@ -618,7 +618,7 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 	/* return the wd */
 	ret = ientry->wd;
 
-	/* match the get from fsnotify_find_mark_entry() */
+	/* match the get from fsnotify_find_mark() */
 	fsnotify_put_mark(entry);
 
 	return ret;
@@ -861,7 +861,7 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 
 	ret = 0;
 
-	fsnotify_destroy_mark_by_entry(&ientry->fsn_entry);
+	fsnotify_destroy_mark(&ientry->fsn_entry);
 
 	/* match ref taken by inotify_idr_find */
 	fsnotify_put_mark(&ientry->fsn_entry);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 59c072e..83b6bfe 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -363,13 +363,13 @@ extern struct fsnotify_event *fsnotify_remove_notify_event(struct fsnotify_group
 extern void fsnotify_recalc_inode_mask(struct inode *inode);
 extern void fsnotify_init_mark(struct fsnotify_mark *entry, void (*free_mark)(struct fsnotify_mark *entry));
 /* find (and take a reference) to a mark associated with group and inode */
-extern struct fsnotify_mark *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);
+extern struct fsnotify_mark *fsnotify_find_mark(struct fsnotify_group *group, struct inode *inode);
 /* copy the values from old into new */
 extern void fsnotify_duplicate_mark(struct fsnotify_mark *new, struct fsnotify_mark *old);
 /* attach the mark to both the group and the inode */
 extern int fsnotify_add_mark(struct fsnotify_mark *entry, struct fsnotify_group *group, struct inode *inode, int allow_dups);
 /* given a mark, flag it to be freed when all references are dropped */
-extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark *entry);
+extern void fsnotify_destroy_mark(struct fsnotify_mark *entry);
 /* run all the marks in a group, and flag them to be freed */
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_get_mark(struct fsnotify_mark *entry);
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index def7d4a..1351902 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -249,7 +249,7 @@ static void untag_chunk(struct node *p)
 		list_del_rcu(&chunk->hash);
 		spin_unlock(&hash_lock);
 		spin_unlock(&entry->lock);
-		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_destroy_mark(entry);
 		fsnotify_put_mark(entry);
 		goto out;
 	}
@@ -292,7 +292,7 @@ static void untag_chunk(struct node *p)
 		owner->root = new;
 	spin_unlock(&hash_lock);
 	spin_unlock(&entry->lock);
-	fsnotify_destroy_mark_by_entry(entry);
+	fsnotify_destroy_mark(entry);
 	fsnotify_put_mark(entry);
 	goto out;
 
@@ -332,7 +332,7 @@ static int create_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&hash_lock);
 		chunk->dead = 1;
 		spin_unlock(&entry->lock);
-		fsnotify_destroy_mark_by_entry(entry);
+		fsnotify_destroy_mark(entry);
 		fsnotify_put_mark(entry);
 		return 0;
 	}
@@ -360,7 +360,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	int n;
 
 	spin_lock(&inode->i_lock);
-	old_entry = fsnotify_find_mark_entry(audit_tree_group, inode);
+	old_entry = fsnotify_find_mark(audit_tree_group, inode);
 	spin_unlock(&inode->i_lock);
 	if (!old_entry)
 		return create_chunk(inode, tree);
@@ -411,7 +411,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 		spin_unlock(&chunk_entry->lock);
 		spin_unlock(&old_entry->lock);
 
-		fsnotify_destroy_mark_by_entry(chunk_entry);
+		fsnotify_destroy_mark(chunk_entry);
 
 		fsnotify_put_mark(chunk_entry);
 		fsnotify_put_mark(old_entry);
@@ -442,7 +442,7 @@ static int tag_chunk(struct inode *inode, struct audit_tree *tree)
 	spin_unlock(&hash_lock);
 	spin_unlock(&chunk_entry->lock);
 	spin_unlock(&old_entry->lock);
-	fsnotify_destroy_mark_by_entry(old_entry);
+	fsnotify_destroy_mark(old_entry);
 	fsnotify_put_mark(old_entry);
 	return 0;
 }
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 010aca9..ae32d73 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -101,7 +101,7 @@ static inline struct audit_parent *audit_find_parent(struct inode *inode)
 	struct fsnotify_mark *entry;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark_entry(audit_watch_group, inode);
+	entry = fsnotify_find_mark(audit_watch_group, inode);
 	spin_unlock(&inode->i_lock);
 
 	if (entry)
@@ -353,7 +353,7 @@ static void audit_remove_parent_watches(struct audit_parent *parent)
 	}
 	mutex_unlock(&audit_filter_mutex);
 
-	fsnotify_destroy_mark_by_entry(&parent->mark);
+	fsnotify_destroy_mark(&parent->mark);
 
 	fsnotify_recalc_group_mask(audit_watch_group);
 
@@ -503,7 +503,7 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 
 		if (list_empty(&parent->watches)) {
 			audit_get_parent(parent);
-			fsnotify_destroy_mark_by_entry(&parent->mark);
+			fsnotify_destroy_mark(&parent->mark);
 			audit_put_parent(parent);
 		}
 	}
@@ -520,7 +520,7 @@ static bool audit_watch_should_send_event(struct fsnotify_group *group, struct i
 	bool send;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark_entry(group, inode);
+	entry = fsnotify_find_mark(group, inode);
 	spin_unlock(&inode->i_lock);
 	if (!entry)
 		return false;

