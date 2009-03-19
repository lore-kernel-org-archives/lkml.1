Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbZCSSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbZCSSJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZCSSHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:07:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757649AbZCSSHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:07:07 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 10/13] fsnotify: allow groups to add private data to events
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       sfr@canb.auug.org.au, john@johnmccutchan.com, rlove@rlove.org,
       akpm@linux-foundation.org
Date: Thu, 19 Mar 2009 14:05:47 -0400
Message-ID: <20090319180547.17449.9496.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
References: <20090319180456.17449.76663.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify needs per group information attached to events.  This patch allows
groups to attach private information and implements a callback so that
information can be freed when an event is being destroyed.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/dnotify/dnotify.c      |    1 +
 fs/notify/notification.c         |   31 +++++++++++++++++++++++++++----
 include/linux/fsnotify_backend.h |   15 ++++++++++++++-
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index f69e0c4..26c07c5 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -152,6 +152,7 @@ static struct fsnotify_ops dnotify_fsnotify_ops = {
 	.should_send_event = dnotify_should_send_event,
 	.free_group_priv = NULL,
 	.freeing_mark = dnotify_freeing_mark,
+	.free_event_priv = NULL,
 };
 
 void dnotify_flush(struct file *filp, fl_owner_t id)
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index ecab682..d71fc9b 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -71,6 +71,7 @@ void fsnotify_put_event(struct fsnotify_event *event)
 		if (event->data_type == FSNOTIFY_EVENT_PATH)
 			path_put(&event->path);
 
+		BUG_ON(!list_empty(&event->private_data_list));
 		kfree(event->file_name);
 		kmem_cache_free(event_kmem_cache, event);
 	}
@@ -86,8 +87,23 @@ void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder)
 	kmem_cache_free(event_holder_kmem_cache, holder);
 }
 
+struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event)
+{
+	struct fsnotify_event_private_data *lpriv;
+	struct fsnotify_event_private_data *priv = NULL;
+
+	list_for_each_entry(lpriv, &event->private_data_list, event_list) {
+		if (lpriv->group == group) {
+			priv = lpriv;
+			break;
+		}
+	}
+	return priv;
+}
+
 /*
- * check if 2 events contain the same information.
+ * check if 2 events contain the same information.  we do not compare private data
+ * but at this moment that isn't a problem.
  */
 static inline int event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
 {
@@ -111,10 +127,11 @@ static inline int event_compare(struct fsnotify_event *old, struct fsnotify_even
 }
 
 /*
- * Add an event to the group notification queue.  The group can later pull this
- * event off the queue to deal with.
+ * Add events to the generic group notification queue.  We test if the event
+ * is the same as the last event in the queue, and if so, we do not add it.
+ * Events added to this queue must be removed with fsnotify_remove_notif_event.
  */
-int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event)
+int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event, struct fsnotify_event_private_data *priv)
 {
 	struct fsnotify_event_holder *holder;
 	struct list_head *list = &group->notification_list;
@@ -166,6 +183,8 @@ int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event
 
 	fsnotify_get_event(event);
 	list_add_tail(&holder->event_list, list);
+	if (priv)
+		list_add_tail(&priv->event_list, &event->private_data_list);
 	spin_unlock(&event->lock);
 	mutex_unlock(&group->notification_mutex);
 
@@ -230,6 +249,8 @@ void fsnotify_flush_notif(struct fsnotify_group *group)
 	mutex_lock(&group->notification_mutex);
 	while (fsnotify_check_notif_queue(group)) {
 		event = fsnotify_remove_notif_event(group);
+		if (group->ops->free_event_priv)
+			group->ops->free_event_priv(group, event);
 		fsnotify_put_event(event);
 	}
 	mutex_unlock(&group->notification_mutex);
@@ -248,6 +269,8 @@ static void initialize_event(struct fsnotify_event *event)
 	event->inode = NULL;
 	event->data_type = FSNOTIFY_EVENT_NONE;
 
+	INIT_LIST_HEAD(&event->private_data_list);
+
 	event->to_tell = NULL;
 
 	event->file_name = NULL;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 467ced7..b575dd0 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -79,6 +79,7 @@ struct fsnotify_ops {
 	int (*handle_event)(struct fsnotify_group *group, struct fsnotify_event *event);
 	void (*free_group_priv)(struct fsnotify_group *group);
 	void (*freeing_mark)(struct fsnotify_mark_entry *entry, struct fsnotify_group *group);
+	void (*free_event_priv)(struct fsnotify_group *group, struct fsnotify_event *event);
 };
 
 /*
@@ -130,6 +131,15 @@ struct fsnotify_event_holder {
 };
 
 /*
+ * Inotify needs to tack data onto an event.  This struct lets us later find the
+ * correct private data of the correct group.
+ */
+struct fsnotify_event_private_data {
+	struct fsnotify_group *group;
+	struct list_head event_list;
+};
+
+/*
  * all of the information about the original object we want to now send to
  * a group.  If you want to carry more info from the accessing task to the
  * listener this structure is where you need to be adding fields.
@@ -163,6 +173,8 @@ struct fsnotify_event {
 	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
 	char *file_name;
 	size_t name_len;
+
+	struct list_head private_data_list;	/* groups can store private data here */
 };
 
 /*
@@ -238,10 +250,11 @@ extern void fsnotify_put_group(struct fsnotify_group *group);
 extern void fsnotify_get_event(struct fsnotify_event *event);
 extern void fsnotify_put_event(struct fsnotify_event *event);
 
-extern int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event);
+extern int fsnotify_add_notif_event(struct fsnotify_group *group, struct fsnotify_event *event, struct fsnotify_event_private_data *priv);
 extern int fsnotify_check_notif_queue(struct fsnotify_group *group);
 extern struct fsnotify_event *fsnotify_peek_notif_event(struct fsnotify_group *group);
 extern struct fsnotify_event *fsnotify_remove_notif_event(struct fsnotify_group *group);
+extern struct fsnotify_event_private_data *fsnotify_get_priv_from_event(struct fsnotify_group *group, struct fsnotify_event *event);
 
 /* functions used to manipulate the marks attached to inodes */
 extern void fsnotify_recalc_inode_mask(struct inode *inode);

