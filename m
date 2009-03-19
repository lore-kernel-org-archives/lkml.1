Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbZCSSIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbZCSSIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757194AbZCSSHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:07:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46009 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640AbZCSSHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:07:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 07/13] fsnotify: generic notification queue and waitq
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:30 -0400
Message-ID: <20090319180530.17449.68562.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
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

 fs/notify/fsnotify.h             |    2 
 fs/notify/group.c                |    9 ++
 fs/notify/notification.c         |  209 ++++++++++++++++++++++++++++++++++++--
 include/linux/fsnotify_backend.h |   35 ++++++
 4 files changed, 244 insertions(+), 11 deletions(-)

diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index be842e2..4ae0741 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -15,6 +15,8 @@ extern struct srcu_struct fsnotify_grp_srcu;
 extern struct list_head fsnotify_groups;
 extern __u32 fsnotify_mask;
 
+extern void fsnotify_flush_notif(struct fsnotify_group *group);
+
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
 extern void fsnotify_clear_marks_by_inode(struct inode *inode);
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index db7ddf5..e30c58d 100644
--- a/fs/notify/group.c
+++ b/fs/notify/group.c
@@ -94,6 +94,9 @@ static void fsnotify_destroy_group(struct fsnotify_group *group)
 	/* clear all inode mark entries for this group */
 	fsnotify_clear_marks_by_group(group);
 
+	/* clear the notification queue of all events */
+	fsnotify_flush_notif(group);
+
 	if (group->ops->free_group_priv)
 		group->ops->free_group_priv(group);
 
@@ -181,6 +184,12 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int
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
index eb23a69..be98511 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -33,6 +33,21 @@
 #include "fsnotify.h"
 
 static struct kmem_cache *event_kmem_cache;
+static struct kmem_cache *event_holder_kmem_cache;
+/*
+ * this is a magic event we sent when the q is too full.  since it doesn't
+ * hold real event information we just keep one system wide and use it any time
+ * it is needed.  It's refcnt is set 1 at kernel init time and will never
+ * get set to 0 so it will never get 'freed'
+ */
+static struct fsnotify_event q_overflow_event;
+
+/* return 1 if something is available, return 0 otherwise */
+int fsnotify_check_notif_queue(struct fsnotify_group *group)
+{
+	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+	return !list_empty(&group->notification_list);
+}
 
 void fsnotify_get_event(struct fsnotify_event *event)
 {
@@ -45,26 +60,175 @@ void fsnotify_put_event(struct fsnotify_event *event)
 		return;
 
 	if (atomic_dec_and_test(&event->refcnt)) {
-		if (event->data_type == FSNOTIFY_EVENT_PATH) {
+		if (event->data_type == FSNOTIFY_EVENT_PATH)
 			path_put(&event->path);
-			event->path.dentry = NULL;
-			event->path.mnt = NULL;
-		}
+		kmem_cache_free(event_kmem_cache, event);
+	}
+}
 
-		event->mask = 0;
+struct fsnotify_event_holder *alloc_event_holder(void)
+{
+	return kmem_cache_alloc(event_holder_kmem_cache, GFP_KERNEL);
+}
 
-		kmem_cache_free(event_kmem_cache, event);
+void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder)
+{
+	kmem_cache_free(event_holder_kmem_cache, holder);
+}
+
+/*
+ * check if 2 events contain the same information.
+ */
+static inline int event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
+{
+	if ((old->mask == new->mask) &&
+	    (old->to_tell == new->to_tell) &&
+	    (old->data_type == new->data_type)) {
+		switch (old->data_type) {
+		case (FSNOTIFY_EVENT_INODE):
+			if (old->inode == new->inode)
+				return 1;
+			break;
+		case (FSNOTIFY_EVENT_PATH):
+			if ((old->path.mnt == new->path.mnt) &&
+			    (old->path.dentry == new->path.dentry))
+				return 1;
+		case (FSNOTIFY_EVENT_NONE):
+			return 1;
+		};
 	}
+	return 0;
 }
 
-struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_type)
+/*
+ * Add an event to the group notification queue.  The group can later pull this
+ * event off the queue to deal with.
+ */
+int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event)
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
+	 * those other tasks will del_init() the embedded holder.event_list under
+	 * the event->lock.  If we see it empty we know that once we
+	 * get that lock the embedded holder will be ok for us to (re)use
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
+	spin_unlock(&event->lock);
+	mutex_unlock(&group->notification_mutex);
+
+	wake_up(&group->notification_waitq);
+	return 0;
+}
+
+/*
+ * remove and return the first event from the notification list.  There is a
+ * reference held on this event since it was on the list.  It is the responsibility
+ * of the caller to drop this reference.
+ */
+struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group)
 {
 	struct fsnotify_event *event;
+	struct fsnotify_event_holder *holder;
 
-	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
-	if (!event)
-		return NULL;
+	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+
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
 
+	return event;
+}
+
+/*
+ * this will not remove the event, that must be done with fsnotify_remove_notif_event()
+ */
+struct fsnotify_event *fsnotify_peek_notif_event(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+	struct fsnotify_event_holder *holder;
+
+	BUG_ON(!mutex_is_locked(&group->notification_mutex));
+
+	holder = list_first_entry(&group->notification_list, struct fsnotify_event_holder, event_list);
+	event = holder->event;
+
+	return event;
+}
+
+/*
+ * called when a group is being torn down to clean up any outstanding
+ * event notifications.
+ */
+void fsnotify_flush_notif(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+
+	mutex_lock(&group->notification_mutex);
+	while (fsnotify_check_notif_queue(group)) {
+		event = fsnotify_remove_notif_event(group);
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
@@ -72,7 +236,28 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 	event->path.dentry = NULL;
 	event->path.mnt = NULL;
 	event->inode = NULL;
+	event->data_type = FSNOTIFY_EVENT_NONE;
+
+	event->to_tell = NULL;
+}
+
+/*
+ * create a new event to send to all interested fsnotify implementors.
+ * @to_tell the inode which is supposed to receive the event (sometimes a
+ *	parent of the inode to which the event happened.
+ * @mask what actually happened.
+ * @data pointer to the object which was actually affected
+ * @data_type flag indication if the data is a file, path, inode, nothing...
+ */
+struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask, void *data, int data_type)
+{
+	struct fsnotify_event *event;
 
+	event = kmem_cache_alloc(event_kmem_cache, GFP_KERNEL);
+	if (!event)
+		return NULL;
+
+	initialize_event(event);
 	event->to_tell = to_tell;
 
 	switch (data_type) {
@@ -109,6 +294,10 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
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
index 5c815b4..e5b674e 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -95,6 +95,13 @@ struct fsnotify_group {
 
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
@@ -108,11 +115,32 @@ struct fsnotify_group {
 };
 
 /*
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
+/*
  * all of the information about the original object we want to now send to
  * a group.  If you want to carry more info from the accessing task to the
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
@@ -124,6 +152,7 @@ struct fsnotify_event {
 		struct inode *inode;
 	};
 /* when calling fsnotify tell it if the data is a path or inode */
+#define FSNOTIFY_EVENT_NONE	0
 #define FSNOTIFY_EVENT_PATH	1
 #define FSNOTIFY_EVENT_INODE	2
 #define FSNOTIFY_EVENT_FILE	3
@@ -203,7 +232,11 @@ extern void fsnotify_put_group(struct fsnotify_group *group);
 
 extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);
-extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
+
+extern int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event);
+extern int fsnotify_check_notif_queue(struct fsnotify_group *group);
+extern struct fsnotify_event *fsnotify_peek_notif_event(struct fsnotify_group *group);
+extern struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group);
 
 /* functions used to manipulate the marks attached to inodes */
 extern void fsnotify_recalc_inode_mask(struct inode *inode);

