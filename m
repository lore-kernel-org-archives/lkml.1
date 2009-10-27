Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZJ0TKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZJ0TKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZJ0TKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664AbZJ0TKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:10:16 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 5/6] inotify: rename mark_entry to just mark
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agruen@suse.de
Date: Tue, 27 Oct 2009 15:10:18 -0400
Message-ID: <20091027191018.27472.61371.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
References: <20091027190952.27472.91015.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename anything in inotify that deals with mark_entry to just be mark.  It
makes a lot more sense.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify.h          |    7 +
 fs/notify/inotify/inotify_fsnotify.c |   48 ++++-----
 fs/notify/inotify/inotify_user.c     |  192 +++++++++++++++++-----------------
 3 files changed, 123 insertions(+), 124 deletions(-)

diff --git a/fs/notify/inotify/inotify.h b/fs/notify/inotify/inotify.h
index 07be6df..b6642e4 100644
--- a/fs/notify/inotify/inotify.h
+++ b/fs/notify/inotify/inotify.h
@@ -9,13 +9,12 @@ struct inotify_event_private_data {
 	int wd;
 };
 
-struct inotify_inode_mark_entry {
-	/* fsnotify_mark MUST be the first thing */
-	struct fsnotify_mark fsn_entry;
+struct inotify_inode_mark {
+	struct fsnotify_mark fsn_mark;
 	int wd;
 };
 
-extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *entry,
+extern void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 					   struct fsnotify_group *group);
 extern void inotify_free_event_priv(struct fsnotify_event_private_data *event_priv);
 
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 94954c1..0156e27 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -87,8 +87,8 @@ static int inotify_merge(struct list_head *list, struct fsnotify_event *event)
 
 static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_event *event)
 {
-	struct fsnotify_mark *entry;
-	struct inotify_inode_mark_entry *ientry;
+	struct fsnotify_mark *fsn_mark;
+	struct inotify_inode_mark *i_mark;
 	struct inode *to_tell;
 	struct inotify_event_private_data *event_priv;
 	struct fsnotify_event_private_data *fsn_event_priv;
@@ -97,14 +97,14 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 	to_tell = event->to_tell;
 
 	spin_lock(&to_tell->i_lock);
-	entry = fsnotify_find_mark(group, to_tell);
+	fsn_mark = fsnotify_find_mark(group, to_tell);
 	spin_unlock(&to_tell->i_lock);
 	/* race with watch removal?  We already passes should_send */
-	if (unlikely(!entry))
+	if (unlikely(!fsn_mark))
 		return 0;
-	ientry = container_of(entry, struct inotify_inode_mark_entry,
-			      fsn_entry);
-	wd = ientry->wd;
+	i_mark = container_of(fsn_mark, struct inotify_inode_mark,
+			      fsn_mark);
+	wd = i_mark->wd;
 
 	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_KERNEL);
 	if (unlikely(!event_priv))
@@ -126,37 +126,37 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 	}
 
 	/*
-	 * If we hold the entry until after the event is on the queue
+	 * If we hold the fsn_mark until after the event is on the queue
 	 * IN_IGNORED won't be able to pass this event in the queue
 	 */
-	fsnotify_put_mark(entry);
+	fsnotify_put_mark(fsn_mark);
 
 	return ret;
 }
 
-static void inotify_freeing_mark(struct fsnotify_mark *entry, struct fsnotify_group *group)
+static void inotify_freeing_mark(struct fsnotify_mark *fsn_mark, struct fsnotify_group *group)
 {
-	inotify_ignored_and_remove_idr(entry, group);
+	inotify_ignored_and_remove_idr(fsn_mark, group);
 }
 
 static bool inotify_should_send_event(struct fsnotify_group *group, struct inode *inode,
 				      struct vfsmount *mnt, __u32 mask, void *data,
 				      int data_type)
 {
-	struct fsnotify_mark *entry;
+	struct fsnotify_mark *fsn_mark;
 	bool send;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_mark(group, inode);
 	spin_unlock(&inode->i_lock);
-	if (!entry)
+	if (!fsn_mark)
 		return false;
 
 	mask = (mask & ~FS_EVENT_ON_CHILD);
-	send = (entry->mask & mask);
+	send = (fsn_mark->mask & mask);
 
 	/* find took a reference */
-	fsnotify_put_mark(entry);
+	fsnotify_put_mark(fsn_mark);
 
 	return send;
 }
@@ -170,18 +170,18 @@ static bool inotify_should_send_event(struct fsnotify_group *group, struct inode
  */
 static int idr_callback(int id, void *p, void *data)
 {
-	struct fsnotify_mark *entry;
-	struct inotify_inode_mark_entry *ientry;
+	struct fsnotify_mark *fsn_mark;
+	struct inotify_inode_mark *i_mark;
 	static bool warned = false;
 
 	if (warned)
 		return 0;
 
 	warned = false;
-	entry = p;
-	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
+	fsn_mark = p;
+	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 
-	WARN(1, "inotify closing but id=%d for entry=%p in group=%p still in "
+	WARN(1, "inotify closing but id=%d for fsn_mark=%p in group=%p still in "
 		"idr.  Probably leaking memory\n", id, p, data);
 
 	/*
@@ -190,9 +190,9 @@ static int idr_callback(int id, void *p, void *data)
 	 * out why we got here and the panic is no worse than the original
 	 * BUG() that was here.
 	 */
-	if (entry)
-		printk(KERN_WARNING "entry->group=%p inode=%p wd=%d\n",
-			entry->group, entry->i.inode, ientry->wd);
+	if (fsn_mark)
+		printk(KERN_WARNING "fsn_mark->group=%p inode=%p wd=%d\n",
+			fsn_mark->group, fsn_mark->i.inode, i_mark->wd);
 	return 0;
 }
 
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 4733e50..974bc59 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -363,7 +363,7 @@ static int inotify_find_inode(const char __user *dirname, struct path *path, uns
 
 static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
 			      int last_wd,
-			      struct inotify_inode_mark_entry *ientry)
+			      struct inotify_inode_mark *i_mark)
 {
 	int ret;
 
@@ -372,64 +372,64 @@ static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
 			return -ENOMEM;
 
 		spin_lock(idr_lock);
-		ret = idr_get_new_above(idr, ientry, last_wd + 1,
-					&ientry->wd);
+		ret = idr_get_new_above(idr, i_mark, last_wd + 1,
+					&i_mark->wd);
 		/* we added the mark to the idr, take a reference */
 		if (!ret)
-			fsnotify_get_mark(&ientry->fsn_entry);
+			fsnotify_get_mark(&i_mark->fsn_mark);
 		spin_unlock(idr_lock);
 	} while (ret == -EAGAIN);
 
 	return ret;
 }
 
-static struct inotify_inode_mark_entry *inotify_idr_find_locked(struct fsnotify_group *group,
+static struct inotify_inode_mark *inotify_idr_find_locked(struct fsnotify_group *group,
 								int wd)
 {
 	struct idr *idr = &group->inotify_data.idr;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
-	struct inotify_inode_mark_entry *ientry;
+	struct inotify_inode_mark *i_mark;
 
 	assert_spin_locked(idr_lock);
 
-	ientry = idr_find(idr, wd);
-	if (ientry) {
-		struct fsnotify_mark *fsn_entry = &ientry->fsn_entry;
+	i_mark = idr_find(idr, wd);
+	if (i_mark) {
+		struct fsnotify_mark *fsn_mark = &i_mark->fsn_mark;
 
-		fsnotify_get_mark(fsn_entry);
+		fsnotify_get_mark(fsn_mark);
 		/* One ref for being in the idr, one ref we just took */
-		BUG_ON(atomic_read(&fsn_entry->refcnt) < 2);
+		BUG_ON(atomic_read(&fsn_mark->refcnt) < 2);
 	}
 
-	return ientry;
+	return i_mark;
 }
 
-static struct inotify_inode_mark_entry *inotify_idr_find(struct fsnotify_group *group,
+static struct inotify_inode_mark *inotify_idr_find(struct fsnotify_group *group,
 							 int wd)
 {
-	struct inotify_inode_mark_entry *ientry;
+	struct inotify_inode_mark *i_mark;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
 
 	spin_lock(idr_lock);
-	ientry = inotify_idr_find_locked(group, wd);
+	i_mark = inotify_idr_find_locked(group, wd);
 	spin_unlock(idr_lock);
 
-	return ientry;
+	return i_mark;
 }
 
 static void do_inotify_remove_from_idr(struct fsnotify_group *group,
-				       struct inotify_inode_mark_entry *ientry)
+				       struct inotify_inode_mark *i_mark)
 {
 	struct idr *idr = &group->inotify_data.idr;
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
-	int wd = ientry->wd;
+	int wd = i_mark->wd;
 
 	assert_spin_locked(idr_lock);
 
 	idr_remove(idr, wd);
 
 	/* removed from the idr, drop that ref */
-	fsnotify_put_mark(&ientry->fsn_entry);
+	fsnotify_put_mark(&i_mark->fsn_mark);
 }
 
 /*
@@ -437,51 +437,51 @@ static void do_inotify_remove_from_idr(struct fsnotify_group *group,
  * on the mark because it was in the idr.
  */
 static void inotify_remove_from_idr(struct fsnotify_group *group,
-				    struct inotify_inode_mark_entry *ientry)
+				    struct inotify_inode_mark *i_mark)
 {
 	spinlock_t *idr_lock = &group->inotify_data.idr_lock;
-	struct inotify_inode_mark_entry *found_ientry = NULL;
+	struct inotify_inode_mark *found_i_mark = NULL;
 	int wd;
 
 	spin_lock(idr_lock);
-	wd = ientry->wd;
+	wd = i_mark->wd;
 
 	/*
-	 * does this ientry think it is in the idr?  we shouldn't get called
+	 * does this i_mark think it is in the idr?  we shouldn't get called
 	 * if it wasn't....
 	 */
 	if (wd == -1) {
-		printk(KERN_WARNING "%s: ientry=%p ientry->wd=%d ientry->group=%p"
-			" ientry->inode=%p\n", __func__, ientry, ientry->wd,
-			ientry->fsn_entry.group, ientry->fsn_entry.i.inode);
+		printk(KERN_WARNING "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
+			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
+			i_mark->fsn_mark.group, i_mark->fsn_mark.i.inode);
 		WARN_ON(1);
 		goto out;
 	}
 
 	/* Lets look in the idr to see if we find it */
-	found_ientry = inotify_idr_find_locked(group, wd);
-	if (unlikely(!found_ientry)) {
-		printk(KERN_WARNING "%s: ientry=%p ientry->wd=%d ientry->group=%p"
-			" ientry->inode=%p\n", __func__, ientry, ientry->wd,
-			ientry->fsn_entry.group, ientry->fsn_entry.i.inode);
+	found_i_mark = inotify_idr_find_locked(group, wd);
+	if (unlikely(!found_i_mark)) {
+		printk(KERN_WARNING "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
+			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
+			i_mark->fsn_mark.group, i_mark->fsn_mark.i.inode);
 		WARN_ON(1);
 		goto out;
 	}
 
 	/*
-	 * We found an entry in the idr at the right wd, but it's
-	 * not the entry we were told to remove.  eparis seriously
+	 * We found an mark in the idr at the right wd, but it's
+	 * not the mark we were told to remove.  eparis seriously
 	 * fucked up somewhere.
 	 */
-	if (unlikely(found_ientry != ientry)) {
+	if (unlikely(found_i_mark != i_mark)) {
 		WARN_ON(1);
-		printk(KERN_WARNING "%s: ientry=%p ientry->wd=%d ientry->group=%p "
-			"entry->inode=%p found_ientry=%p found_ientry->wd=%d "
-			"found_ientry->group=%p found_ientry->inode=%p\n",
-			__func__, ientry, ientry->wd, ientry->fsn_entry.group,
-			ientry->fsn_entry.i.inode, found_ientry, found_ientry->wd,
-			found_ientry->fsn_entry.group,
-			found_ientry->fsn_entry.i.inode);
+		printk(KERN_WARNING "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p "
+			"mark->inode=%p found_i_mark=%p found_i_mark->wd=%d "
+			"found_i_mark->group=%p found_i_mark->inode=%p\n",
+			__func__, i_mark, i_mark->wd, i_mark->fsn_mark.group,
+			i_mark->fsn_mark.i.inode, found_i_mark, found_i_mark->wd,
+			found_i_mark->fsn_mark.group,
+			found_i_mark->fsn_mark.i.inode);
 		goto out;
 	}
 
@@ -490,30 +490,30 @@ static void inotify_remove_from_idr(struct fsnotify_group *group,
 	 * one ref held by the caller trying to kill us
 	 * one ref grabbed by inotify_idr_find
 	 */
-	if (unlikely(atomic_read(&ientry->fsn_entry.refcnt) < 3)) {
-		printk(KERN_WARNING "%s: ientry=%p ientry->wd=%d ientry->group=%p"
-			" ientry->inode=%p\n", __func__, ientry, ientry->wd,
-			ientry->fsn_entry.group, ientry->fsn_entry.i.inode);
+	if (unlikely(atomic_read(&i_mark->fsn_mark.refcnt) < 3)) {
+		printk(KERN_WARNING "%s: i_mark=%p i_mark->wd=%d i_mark->group=%p"
+			" i_mark->inode=%p\n", __func__, i_mark, i_mark->wd,
+			i_mark->fsn_mark.group, i_mark->fsn_mark.i.inode);
 		/* we can't really recover with bad ref cnting.. */
 		BUG();
 	}
 
-	do_inotify_remove_from_idr(group, ientry);
+	do_inotify_remove_from_idr(group, i_mark);
 out:
 	/* match the ref taken by inotify_idr_find_locked() */
-	if (found_ientry)
-		fsnotify_put_mark(&found_ientry->fsn_entry);
-	ientry->wd = -1;
+	if (found_i_mark)
+		fsnotify_put_mark(&found_i_mark->fsn_mark);
+	i_mark->wd = -1;
 	spin_unlock(idr_lock);
 }
 
 /*
  * Send IN_IGNORED for this wd, remove this wd from the idr.
  */
-void inotify_ignored_and_remove_idr(struct fsnotify_mark *entry,
+void inotify_ignored_and_remove_idr(struct fsnotify_mark *fsn_mark,
 				    struct fsnotify_group *group)
 {
-	struct inotify_inode_mark_entry *ientry;
+	struct inotify_inode_mark *i_mark;
 	struct fsnotify_event *ignored_event;
 	struct inotify_event_private_data *event_priv;
 	struct fsnotify_event_private_data *fsn_event_priv;
@@ -525,7 +525,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *entry,
 	if (!ignored_event)
 		return;
 
-	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
+	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 
 	event_priv = kmem_cache_alloc(event_priv_cachep, GFP_NOFS);
 	if (unlikely(!event_priv))
@@ -534,7 +534,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark *entry,
 	fsn_event_priv = &event_priv->fsnotify_event_priv_data;
 
 	fsn_event_priv->group = group;
-	event_priv->wd = ientry->wd;
+	event_priv->wd = i_mark->wd;
 
 	ret = fsnotify_add_notify_event(group, ignored_event, fsn_event_priv, NULL);
 	if (ret)
@@ -545,28 +545,28 @@ skip_send_ignore:
 	/* matches the reference taken when the event was created */
 	fsnotify_put_event(ignored_event);
 
-	/* remove this entry from the idr */
-	inotify_remove_from_idr(group, ientry);
+	/* remove this mark from the idr */
+	inotify_remove_from_idr(group, i_mark);
 
 	atomic_dec(&group->inotify_data.user->inotify_watches);
 }
 
 /* ding dong the mark is dead */
-static void inotify_free_mark(struct fsnotify_mark *entry)
+static void inotify_free_mark(struct fsnotify_mark *fsn_mark)
 {
-	struct inotify_inode_mark_entry *ientry;
+	struct inotify_inode_mark *i_mark;
 
-	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
+	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 
-	kmem_cache_free(inotify_inode_mark_cachep, ientry);
+	kmem_cache_free(inotify_inode_mark_cachep, i_mark);
 }
 
 static int inotify_update_existing_watch(struct fsnotify_group *group,
 					 struct inode *inode,
 					 u32 arg)
 {
-	struct fsnotify_mark *entry;
-	struct inotify_inode_mark_entry *ientry;
+	struct fsnotify_mark *fsn_mark;
+	struct inotify_inode_mark *i_mark;
 	__u32 old_mask, new_mask;
 	__u32 mask;
 	int add = (arg & IN_MASK_ADD);
@@ -578,35 +578,35 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 		return -EINVAL;
 
 	spin_lock(&inode->i_lock);
-	entry = fsnotify_find_mark(group, inode);
+	fsn_mark = fsnotify_find_mark(group, inode);
 	spin_unlock(&inode->i_lock);
-	if (!entry)
+	if (!fsn_mark)
 		return -ENOENT;
 
-	ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
+	i_mark = container_of(fsn_mark, struct inotify_inode_mark, fsn_mark);
 
-	spin_lock(&entry->lock);
+	spin_lock(&fsn_mark->lock);
 
-	old_mask = entry->mask;
+	old_mask = fsn_mark->mask;
 	if (add) {
-		entry->mask |= mask;
-		new_mask = entry->mask;
+		fsn_mark->mask |= mask;
+		new_mask = fsn_mark->mask;
 	} else {
-		entry->mask = mask;
-		new_mask = entry->mask;
+		fsn_mark->mask = mask;
+		new_mask = fsn_mark->mask;
 	}
 
-	spin_unlock(&entry->lock);
+	spin_unlock(&fsn_mark->lock);
 
 	if (old_mask != new_mask) {
 		/* more bits in old than in new? */
 		int dropped = (old_mask & ~new_mask);
-		/* more bits in this entry than the inode's mask? */
+		/* more bits in this fsn_mark than the inode's mask? */
 		int do_inode = (new_mask & ~inode->i_fsnotify_mask);
-		/* more bits in this entry than the group? */
+		/* more bits in this fsn_mark than the group? */
 		int do_group = (new_mask & ~group->mask);
 
-		/* update the inode with this new entry */
+		/* update the inode with this new fsn_mark */
 		if (dropped || do_inode)
 			fsnotify_recalc_inode_mask(inode);
 
@@ -616,10 +616,10 @@ static int inotify_update_existing_watch(struct fsnotify_group *group,
 	}
 
 	/* return the wd */
-	ret = ientry->wd;
+	ret = i_mark->wd;
 
 	/* match the get from fsnotify_find_mark() */
-	fsnotify_put_mark(entry);
+	fsnotify_put_mark(fsn_mark);
 
 	return ret;
 }
@@ -628,7 +628,7 @@ static int inotify_new_watch(struct fsnotify_group *group,
 			     struct inode *inode,
 			     u32 arg)
 {
-	struct inotify_inode_mark_entry *tmp_ientry;
+	struct inotify_inode_mark *tmp_i_mark;
 	__u32 mask;
 	int ret;
 	struct idr *idr = &group->inotify_data.idr;
@@ -639,47 +639,47 @@ static int inotify_new_watch(struct fsnotify_group *group,
 	if (unlikely(!mask))
 		return -EINVAL;
 
-	tmp_ientry = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
-	if (unlikely(!tmp_ientry))
+	tmp_i_mark = kmem_cache_alloc(inotify_inode_mark_cachep, GFP_KERNEL);
+	if (unlikely(!tmp_i_mark))
 		return -ENOMEM;
 
-	fsnotify_init_mark(&tmp_ientry->fsn_entry, inotify_free_mark);
-	tmp_ientry->fsn_entry.mask = mask;
-	tmp_ientry->wd = -1;
+	fsnotify_init_mark(&tmp_i_mark->fsn_mark, inotify_free_mark);
+	tmp_i_mark->fsn_mark.mask = mask;
+	tmp_i_mark->wd = -1;
 
 	ret = -ENOSPC;
 	if (atomic_read(&group->inotify_data.user->inotify_watches) >= inotify_max_user_watches)
 		goto out_err;
 
 	ret = inotify_add_to_idr(idr, idr_lock, group->inotify_data.last_wd,
-				 tmp_ientry);
+				 tmp_i_mark);
 	if (ret)
 		goto out_err;
 
 	/* we are on the idr, now get on the inode */
-	ret = fsnotify_add_mark(&tmp_ientry->fsn_entry, group, inode, 0);
+	ret = fsnotify_add_mark(&tmp_i_mark->fsn_mark, group, inode, 0);
 	if (ret) {
 		/* we failed to get on the inode, get off the idr */
-		inotify_remove_from_idr(group, tmp_ientry);
+		inotify_remove_from_idr(group, tmp_i_mark);
 		goto out_err;
 	}
 
 	/* update the idr hint, who cares about races, it's just a hint */
-	group->inotify_data.last_wd = tmp_ientry->wd;
+	group->inotify_data.last_wd = tmp_i_mark->wd;
 
 	/* increment the number of watches the user has */
 	atomic_inc(&group->inotify_data.user->inotify_watches);
 
-	/* return the watch descriptor for this new entry */
-	ret = tmp_ientry->wd;
+	/* return the watch descriptor for this new mark */
+	ret = tmp_i_mark->wd;
 
 	/* if this mark added a new event update the group mask */
 	if (mask & ~group->mask)
 		fsnotify_recalc_group_mask(group);
 
 out_err:
-	/* match the ref from fsnotify_init_markentry() */
-	fsnotify_put_mark(&tmp_ientry->fsn_entry);
+	/* match the ref from fsnotify_init_mark() */
+	fsnotify_put_mark(&tmp_i_mark->fsn_mark);
 
 	return ret;
 }
@@ -839,7 +839,7 @@ fput_and_out:
 SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 {
 	struct fsnotify_group *group;
-	struct inotify_inode_mark_entry *ientry;
+	struct inotify_inode_mark *i_mark;
 	struct file *filp;
 	int ret = 0, fput_needed;
 
@@ -855,16 +855,16 @@ SYSCALL_DEFINE2(inotify_rm_watch, int, fd, __s32, wd)
 	group = filp->private_data;
 
 	ret = -EINVAL;
-	ientry = inotify_idr_find(group, wd);
-	if (unlikely(!ientry))
+	i_mark = inotify_idr_find(group, wd);
+	if (unlikely(!i_mark))
 		goto out;
 
 	ret = 0;
 
-	fsnotify_destroy_mark(&ientry->fsn_entry);
+	fsnotify_destroy_mark(&i_mark->fsn_mark);
 
 	/* match ref taken by inotify_idr_find */
-	fsnotify_put_mark(&ientry->fsn_entry);
+	fsnotify_put_mark(&i_mark->fsn_mark);
 
 out:
 	fput_light(filp, fput_needed);
@@ -902,7 +902,7 @@ static int __init inotify_user_setup(void)
 	if (IS_ERR(inotify_mnt))
 		panic("inotify: kern_mount ret %ld!\n", PTR_ERR(inotify_mnt));
 
-	inotify_inode_mark_cachep = KMEM_CACHE(inotify_inode_mark_entry, SLAB_PANIC);
+	inotify_inode_mark_cachep = KMEM_CACHE(inotify_inode_mark, SLAB_PANIC);
 	event_priv_cachep = KMEM_CACHE(inotify_event_private_data, SLAB_PANIC);
 
 	inotify_max_queued_events = 16384;

