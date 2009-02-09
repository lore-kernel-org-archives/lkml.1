Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZBIVS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZBIVS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbZBIVQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:16:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36419 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZBIVQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:16:47 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 06/11] fsnotify: generic notification queue and waitq
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       malware-list@lists.printk.net, akpm@linux-foundation.org
Date: Mon, 09 Feb 2009 16:15:53 -0500
Message-ID: <20090209211553.8985.95361.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
References: <20090209211525.8985.13887.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify needs to do asyc notification in which event information is stored
on a queue until the listener is ready to receive it.  This patch
implements a generic notification queue for inotify (and later fanotify) to
store events to be sent at a later time.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fsnotify.h             |    3 +
 fs/notify/group.c                |    9 ++
 fs/notify/notification.c         |  181 +++++++++++++++++++++++++++++++++++++-
 include/linux/fsnotify_backend.h |   34 +++++++
 4 files changed, 223 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index bad4da9..6d6942c 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -15,8 +15,11 @@ extern struct srcu_struct fsnotify_grp_srcu_struct;
 extern struct list_head fsnotify_groups;
 extern __u64 fsnotify_mask;
 
+extern void fsnotify_flush_notif(struct fsnotify_group *group);
+
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is);
 
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flags);
+
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index bac7d8d..9168e81 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -91,6 +91,9 @@ void fsnotify_get_group(struct fsnotify_group *group)
 
 static void fsnotify_destroy_group(struct fsnotify_group *group)
 {
+	/* clear the notification queue of all events */
+	fsnotify_flush_notif(group);
+
 	/* clear all inode mark entries for this group */
 	fsnotify_clear_marks_by_group(group);
 
@@ -172,6 +175,12 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int
 	group->group_num = group_num;
 	group->mask = mask;
 
+	mutex_init(&group->notification_mutex);
+	INIT_LIST_HEAD(&group->notification_list);
+	init_waitqueue_head(&group->notification_waitq);
+	group->q_len = 0;
+	group->max_events = UINT_MAX;
+
 	spin_lock_init(&group->mark_lock);
 	INIT_LIST_HEAD(&group->mark_entries);
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index c893873..3884879 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -33,6 +33,14 @@
 #include "fsnotify.h"
 
 static struct kmem_cache *event_kmem_cache;
+static struct kmem_cache *event_holder_kmem_cache;
+static struct fsnotify_event q_overflow_event;
+
+/* return 1 if something is available, return 0 otherwise */
+int fsnotify_check_notif_queue(struct fsnotify_group *group)
+{
+	return !list_empty(&group->notification_list);
+}
 
 void fsnotify_get_event(struct fsnotify_event *event)
 {
@@ -58,6 +66,16 @@ void fsnotify_put_event(struct fsnotify_event *event)
 	}
 }
 
+struct fsnotify_event_holder *alloc_event_holder(void)
+{
+	return kmem_cache_alloc(event_holder_kmem_cache, GFP_KERNEL);
+}
+
+void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder)
+{
+	kmem_cache_free(event_holder_kmem_cache, holder);
+}
+
 struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event)
 {
 	struct fsnotify_event_private_data *lpriv;
@@ -72,14 +90,152 @@ struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify
 	return priv;
 }
 
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is)
+static inline int event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
+{
+	if ((old->mask == new->mask) &&
+	    (old->to_tell == new->to_tell) &&
+	    (old->flag == new->flag)) {
+		if ((old->flag == FSNOTIFY_EVENT_INODE) &&
+		    (old->inode == new->inode))
+			return 1;
+		else if ((old->flag == FSNOTIFY_EVENT_PATH) &&
+		    (old->path.mnt == new->path.mnt) &&
+		    (old->path.dentry == new->path.dentry))
+			return 1;
+		else if (old->flag == FSNOTIFY_EVENT_NONE)
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * we do NOT compare private data when determining if the last event in the
+ * notification queue is the same as this event someone is trying to add
+ */
+int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event, struct fsnotify_event_private_data *priv)
+{
+	struct fsnotify_event_holder *holder;
+	struct list_head *list = &group->notification_list;
+	struct fsnotify_event_holder *last_holder;
+	struct fsnotify_event *last_event;
+
+	/*
+	 * holder locking
+	 *
+	 * only this task is going to be adding this event to lists, thus only
+	 * this task can add the in event holder to a list.
+	 *
+	 * other tasks may be removing this event from some other group's
+	 * notification_list.
+	 *
+	 * those other tasks will blank the in event holder list under
+	 * the holder spinlock.  If we see it blank we know that once we
+	 * get that lock the in event holder will be ok for us to (re)use.
+	 */
+	if (list_empty(&event->holder.event_list))
+		holder = (struct fsnotify_event_holder *)event;
+	else
+		holder = alloc_event_holder();
+
+	if (!holder)
+		return -ENOMEM;
+
+	mutex_lock(&group->notification_mutex);
+
+	if (group->q_len >= group->max_events)
+		event = &q_overflow_event;
+
+	spin_lock(&event->lock);
+
+	if (!list_empty(list)) {
+		last_holder = list_entry(list->prev, struct fsnotify_event_holder, event_list);
+		last_event = last_holder->event;
+		if (event_compare(last_event, event)) {
+			spin_unlock(&event->lock);
+			mutex_unlock(&group->notification_mutex);
+			if (holder != (struct fsnotify_event_holder *)event)
+				fsnotify_destroy_event_holder(holder);
+			return 0;
+		}
+	}
+
+	group->q_len++;
+	holder->event = event;
+
+	fsnotify_get_event(event);
+	list_add_tail(&holder->event_list, list);
+	if (priv)
+		list_add_tail(&priv->event_list, &event->private_data_list);
+	spin_unlock(&event->lock);
+	mutex_unlock(&group->notification_mutex);
+
+	wake_up(&group->notification_waitq);
+	return 0;
+}
+
+/*
+ * must be called with group->notification_mutex held and must know event is present.
+ * it is the responsibility of the caller to call put_event() on the returned
+ * structure
+ */
+struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group)
 {
 	struct fsnotify_event *event;
+	struct fsnotify_event_holder *holder;
 
-	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
-	if (!event)
-		return NULL;
+	holder = list_first_entry(&group->notification_list, struct fsnotify_event_holder, event_list);
+
+	event = holder->event;
+
+	spin_lock(&event->lock);
+	holder->event = NULL;
+	list_del_init(&holder->event_list);
+	spin_unlock(&event->lock);
+
+	/* event == holder means we are referenced through the in event holder */
+	if (event != (struct fsnotify_event *)holder)
+		fsnotify_destroy_event_holder(holder);
+
+	group->q_len--;
+
+	return event;
+}
+
+/*
+ * caller must hold group->notification_mutex and must know event is present.
+ * this will not remove the event, that must be done with fsnotify_remove_notif_event()
+ */
+struct fsnotify_event *fsnotify_peek_notif_event(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+	struct fsnotify_event_holder *holder;
+
+	holder = list_first_entry(&group->notification_list, struct fsnotify_event_holder, event_list);
+	event = holder->event;
 
+	return event;
+}
+
+void fsnotify_flush_notif(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+
+	/* do I really need the mutex here?  I think the group is now safe to
+	 * play with lockless... */
+	mutex_lock(&group->notification_mutex);
+	while (fsnotify_check_notif_queue(group)) {
+		event = fsnotify_remove_notif_event(group);
+		if (group->ops->free_event_priv)
+			group->ops->free_event_priv(group, event);
+		fsnotify_put_event(event);
+	}
+	mutex_unlock(&group->notification_mutex);
+}
+
+static void initialize_event(struct fsnotify_event *event)
+{
+	event->holder.event = NULL;
+	INIT_LIST_HEAD(&event->holder.event_list);
 	atomic_set(&event->refcnt, 1);
 
 	spin_lock_init(&event->lock);
@@ -87,9 +243,22 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 	event->path.dentry = NULL;
 	event->path.mnt = NULL;
 	event->inode = NULL;
+	event->flag = FSNOTIFY_EVENT_NONE;
 
 	INIT_LIST_HEAD(&event->private_data_list);
 
+	event->to_tell = NULL;
+}
+
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is)
+{
+	struct fsnotify_event *event;
+
+	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
+	if (!event)
+		return NULL;
+
+	initialize_event(event);
 	event->to_tell = to_tell;
 
 	switch (data_is) {
@@ -126,6 +295,10 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 __init int fsnotify_notification_init(void)
 {
 	event_kmem_cache = kmem_cache_create("fsnotify_event", sizeof(struct fsnotify_event), 0, SLAB_PANIC, NULL);
+	event_holder_kmem_cache = kmem_cache_create("fsnotify_event_holder", sizeof(struct fsnotify_event_holder), 0, SLAB_PANIC, NULL);
+
+	initialize_event(&q_overflow_event);
+	q_overflow_event.mask = FS_Q_OVERFLOW;
 
 	return 0;
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 2bada0f..6223efa 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -69,6 +69,7 @@
 				 FS_DELETE)
 
 /* when calling fsnotify tell it if the data is a path or inode */
+#define FSNOTIFY_EVENT_NONE	0
 #define FSNOTIFY_EVENT_PATH	1
 #define FSNOTIFY_EVENT_INODE	2
 #define FSNOTIFY_EVENT_FILE	3
@@ -101,6 +102,13 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	/* needed to send notification to userspace */
+	struct mutex notification_mutex;	/* protect the notification_list */
+	struct list_head notification_list;	/* list of event_holder this group needs to send to userspace */
+	wait_queue_head_t notification_waitq;	/* read() on the notification file blocks on this waitq */
+	unsigned int q_len;			/* events on the queue */
+	unsigned int max_events;		/* maximum events allowed on the list */
+
 	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
 	spinlock_t mark_lock;		/* protect mark_entries list */
 	struct list_head mark_entries;	/* all inode mark entries for this group */
@@ -113,6 +121,21 @@ struct fsnotify_group {
 	};
 };
 
+/*
+ * A single event can be queued in multiple group->notification_lists.
+ *
+ * each group->notification_list will point to an event_holder which in turns points
+ * to the actual event that needs to be sent to userspace.
+ *
+ * Seemed cheaper to create a refcnt'd event and a small holder for every group
+ * than create a different event for every group
+ *
+ */
+struct fsnotify_event_holder {
+	struct fsnotify_event *event;
+	struct list_head event_list;
+};
+
 struct fsnotify_event_private_data {
 	struct fsnotify_group *group;
 	struct list_head event_list;
@@ -125,6 +148,12 @@ struct fsnotify_event_private_data {
  * listener this structure is where you need to be adding fields.
  */
 struct fsnotify_event {
+	/*
+	 * If we create an event we are also likely going to need a holder
+	 * to link to a group.  So embed one holder in the event.  Means only
+	 * one allocation for the common case where we only have one group
+	 */
+	struct fsnotify_event_holder holder;
 	spinlock_t lock;	/* protection for the associated event_holder and private_list */
 	struct inode *to_tell;
 	/*
@@ -183,6 +212,11 @@ extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);
 extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
 
+extern int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event, struct fsnotify_event_private_data *priv);
+extern int fsnotify_check_notif_queue(struct fsnotify_group *group);
+extern struct fsnotify_event *fsnotify_peek_notif_event(struct fsnotify_group *group);
+extern struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group);
+
 extern void fsnotify_recalc_inode_mask(struct inode *inode);
 extern void fsnotify_init_mark(struct fsnotify_mark_entry *entry, struct fsnotify_group *group, struct inode *inode, __u64 mask);
 extern struct fsnotify_mark_entry *fsnotify_find_mark_entry(struct fsnotify_group *group, struct inode *inode);

