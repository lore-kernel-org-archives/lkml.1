Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbYLLVzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbYLLVzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYLLVwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:52:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606AbYLLVwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:52:20 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 10/14] fsnotify: generic notification queue and waitq
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:52:07 -0500
Message-ID: <20081212215207.27112.48279.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
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

 fs/notify/fsnotify.h             |   29 +++++++++
 fs/notify/group.c                |    9 +++
 fs/notify/notification.c         |  127 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsnotify_backend.h |    7 ++
 4 files changed, 172 insertions(+), 0 deletions(-)

diff --git a/fs/notify/fsnotify.h b/fs/notify/fsnotify.h
index e6f4f0d..6b2dc15 100644
--- a/fs/notify/fsnotify.h
+++ b/fs/notify/fsnotify.h
@@ -10,6 +10,20 @@
 #include <linux/fsnotify.h>
 
 #include <asm/atomic.h>
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
 
 struct fsnotify_event_private_data {
 	struct fsnotify_group *group;
@@ -23,6 +37,12 @@ struct fsnotify_event_private_data {
  * listener this structure is where you need to be adding fields.
  */
 struct fsnotify_event {
+	/*
+	 * If we create an event we are also going to need to create a holder
+	 * to link to a group.  So embed one holder in the event.  Means only
+	 * one allocation for the common case where we only have one group
+	 */
+	struct fsnotify_event_holder holder;
 	spinlock_t lock; /* protection for the associated event_holder and private_list */
 	struct inode *to_tell;
 	/*
@@ -72,6 +92,13 @@ extern __u64 fsnotify_mask;
 extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);
 extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
+
+extern void fsnotify_flush_notif(struct fsnotify_group *group);
+extern int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event, struct fsnotify_event_private_data *priv);
+extern int fsnotify_check_notif_queue(struct fsnotify_group *group);
+extern struct fsnotify_event *fsnotify_peek_notif_event(struct fsnotify_group *group);
+extern struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group);
+
 extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is);
 
 extern void fsnotify_clear_marks_by_group(struct fsnotify_group *group);
@@ -79,4 +106,6 @@ extern void fsnotify_clear_marks_by_inode(struct inode *inode, unsigned int flag
 extern void fsnotify_destroy_mark_by_entry(struct fsnotify_mark_entry *entry);
 extern void fsnotify_get_mark(struct fsnotify_mark_entry *entry);
 extern void fsnotify_put_mark(struct fsnotify_mark_entry *entry);
+ extern struct fsnotify_event_holder *fsnotify_alloc_event_holder(void);
+ extern void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder);
 #endif	/* _LINUX_FSNOTIFY_PRIVATE_H */
diff --git a/fs/notify/group.c b/fs/notify/group.c
index 1ed97fe..b041e6d 100644
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
 
@@ -168,6 +171,12 @@ struct fsnotify_group *fsnotify_obtain_group(unsigned int priority, unsigned int
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
index f008a15..e039a47 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -33,6 +33,14 @@
 #include "fsnotify.h"
 
 static struct kmem_cache *event_kmem_cache;
+static struct kmem_cache *event_holder_kmem_cache;
+
+int fsnotify_check_notif_queue(struct fsnotify_group *group)
+{
+	if (!list_empty(&group->notification_list))
+		return 1;
+	return 0;
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
@@ -72,6 +90,112 @@ struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify
 	return priv;
 }
 
+int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event, struct fsnotify_event_private_data *priv)
+{
+	struct fsnotify_event_holder *holder;
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
+	if (!holder)
+		return -ENOMEM;
+
+	fsnotify_get_event(event);
+
+	mutex_lock(&group->notification_mutex);
+
+	if (group->q_len + 1 >= group->max_events) {
+		mutex_unlock(&group->notification_mutex);
+		return -ENOSPC;
+	} else {
+		group->q_len++;
+	}
+	spin_lock(&event->lock);
+	holder->event = event;
+	list_add_tail(&holder->event_list, &group->notification_list);
+	if (priv)
+		list_add_tail(&priv->event_list, &event->private_data_list);
+	spin_unlock(&event->lock);
+	mutex_unlock(&group->notification_mutex);
+
+	wake_up(&group->notification_waitq);
+
+	return 0;
+}
+
+/*
+ * must be called with group->notification_mutex held and must know event is present.
+ * it is the responsibility of the caller to call put_event() on the returned
+ * structure
+ */
+struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group)
+{
+	struct fsnotify_event *event;
+	struct fsnotify_event_holder *holder;
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
+
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
 struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask, void *data, int data_is)
 {
 	struct fsnotify_event *event;
@@ -80,6 +204,8 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 	if (!event)
 		return NULL;
 
+	event->holder.event = NULL;
+	INIT_LIST_HEAD(&event->holder.event_list);
 	atomic_set(&event->refcnt, 1);
 
 	spin_lock_init(&event->lock);
@@ -116,6 +242,7 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u64 mask,
 __init int fsnotify_notification_init(void)
 {
 	event_kmem_cache = kmem_cache_create("fsnotify_event", sizeof(struct fsnotify_event), 0, SLAB_PANIC, NULL);
+	event_holder_kmem_cache = kmem_cache_create("fsnotify_event_holder", sizeof(struct fsnotify_event_holder), 0, SLAB_PANIC, NULL);
 
 	return 0;
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 3e4ac24..b6d1895 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -99,6 +99,13 @@ struct fsnotify_group {
 
 	const struct fsnotify_ops *ops;	/* how this group handles things */
 
+	/* needed to send notification to userspace */
+	struct mutex notification_mutex;/* protect the notification_list */
+	struct list_head notification_list;     /* list of event_holder this group needs to send to userspace */
+	wait_queue_head_t notification_waitq;   /* read() on the notification file blocks on this waitq */
+	unsigned int q_len;                     /* events on the queue */
+	unsigned int max_events;                /* maximum events allowed on the list */
+
 	/* stores all fastapth entries assoc with this group so they can be cleaned on unregister */
 	spinlock_t mark_lock;    /* protect mark_entries list */
 	struct list_head mark_entries; /* all inode mark entries for this group */

