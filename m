Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbZHKQal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbZHKQal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZHKQah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:30:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55891 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbZHKQaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:30:35 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 6/8] fsnotify: per group notification queue merge types
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Date: Tue, 11 Aug 2009 12:30:34 -0400
Message-ID: <20090811163033.8648.11496.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
References: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify only wishes to merge a new event with the last event on the
notification fifo.  fanotify is willing to merge any events including by
means of bitwise OR masks of multiple events together.  This patch moves
the inotify event merging logic out of the generic fsnotify notification.c
and into the inotify code.  This allows each use of fsnotify to provide
their own merge functionality.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_fsnotify.c |   52 ++++++++++++++++++++++++++++
 fs/notify/inotify/inotify_user.c     |    2 +
 fs/notify/notification.c             |   63 +++++++++-------------------------
 include/linux/fsnotify_backend.h     |    6 ++-
 4 files changed, 72 insertions(+), 51 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 743d8fa..133f080 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -31,6 +31,56 @@
 
 #include "inotify.h"
 
+/*
+ * Check if 2 events contain the same information.  We do not compare private data
+ * but at this moment that isn't a problem for any know fsnotify listeners.
+ */
+static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
+{
+	if ((old->mask == new->mask) &&
+	    (old->to_tell == new->to_tell) &&
+	    (old->data_type == new->data_type) &&
+	    (old->name_len == new->name_len)) {
+		switch (old->data_type) {
+		case (FSNOTIFY_EVENT_INODE):
+			/* remember, after old was put on the wait_q we aren't
+			 * allowed to look at the inode any more, only thing
+			 * left to check was if the file_name is the same */
+			if (old->name_len &&
+			    !strcmp(old->file_name, new->file_name))
+				return true;
+			break;
+		case (FSNOTIFY_EVENT_PATH):
+			if ((old->path.mnt == new->path.mnt) &&
+			    (old->path.dentry == new->path.dentry))
+				return true;
+			break;
+		case (FSNOTIFY_EVENT_NONE):
+			return true;
+		};
+	}
+	return false;
+}
+
+static int inotify_merge(struct list_head *list, struct fsnotify_event *event)
+{
+	struct fsnotify_event_holder *last_holder;
+	struct fsnotify_event *last_event;
+	int ret = 0;
+
+	/* and the list better be locked by something too */
+	spin_lock(&event->lock);
+
+	last_holder = list_entry(list->prev, struct fsnotify_event_holder, event_list);
+	last_event = last_holder->event;
+	if (event_compare(last_event, event))
+		ret = -EEXIST;
+
+	spin_unlock(&event->lock);
+
+	return ret;
+}
+
 static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_event *event)
 {
 	struct fsnotify_mark_entry *entry;
@@ -61,7 +111,7 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 	fsn_event_priv->group = group;
 	event_priv->wd = wd;
 
-	ret = fsnotify_add_notify_event(group, event, fsn_event_priv);
+	ret = fsnotify_add_notify_event(group, event, fsn_event_priv, inotify_merge);
 	/* EEXIST is not an error */
 	if (ret == -EEXIST)
 		ret = 0;
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index fb38e73..d5e78f6 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -401,7 +401,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
 	fsn_event_priv->group = group;
 	event_priv->wd = ientry->wd;
 
-	fsnotify_add_notify_event(group, ignored_event, fsn_event_priv);
+	fsnotify_add_notify_event(group, ignored_event, fsn_event_priv, NULL);
 
 	/* did the private data get added? */
 	if (list_empty(&fsn_event_priv->event_list))
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index cdf203c..bcf6fde 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -104,7 +104,8 @@ struct fsnotify_event_holder *fsnotify_alloc_event_holder(void)
 
 void fsnotify_destroy_event_holder(struct fsnotify_event_holder *holder)
 {
-	kmem_cache_free(fsnotify_event_holder_cachep, holder);
+	if (holder)
+		kmem_cache_free(fsnotify_event_holder_cachep, holder);
 }
 
 /*
@@ -129,48 +130,16 @@ struct fsnotify_event_private_data *fsnotify_remove_priv_from_event(struct fsnot
 }
 
 /*
- * Check if 2 events contain the same information.  We do not compare private data
- * but at this moment that isn't a problem for any know fsnotify listeners.
- */
-static bool event_compare(struct fsnotify_event *old, struct fsnotify_event *new)
-{
-	if ((old->mask == new->mask) &&
-	    (old->to_tell == new->to_tell) &&
-	    (old->data_type == new->data_type) &&
-	    (old->name_len == new->name_len)) {
-		switch (old->data_type) {
-		case (FSNOTIFY_EVENT_INODE):
-			/* remember, after old was put on the wait_q we aren't
-			 * allowed to look at the inode any more, only thing
-			 * left to check was if the file_name is the same */
-			if (old->name_len &&
-			    !strcmp(old->file_name, new->file_name))
-				return true;
-			break;
-		case (FSNOTIFY_EVENT_PATH):
-			if ((old->path.mnt == new->path.mnt) &&
-			    (old->path.dentry == new->path.dentry))
-				return true;
-			break;
-		case (FSNOTIFY_EVENT_NONE):
-			return false;
-		};
-	}
-	return false;
-}
-
-/*
  * Add an event to the group notification queue.  The group can later pull this
  * event off the queue to deal with.  If the event is successfully added to the
  * group's notification queue, a reference is taken on event.
  */
 int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event,
-			      struct fsnotify_event_private_data *priv)
+			      struct fsnotify_event_private_data *priv,
+			      int (*merge)(struct list_head *, struct fsnotify_event *))
 {
 	struct fsnotify_event_holder *holder = NULL;
 	struct list_head *list = &group->notification_list;
-	struct fsnotify_event_holder *last_holder;
-	struct fsnotify_event *last_event;
 
 	/* easy to tell if priv was attached to the event */
 	if (priv)
@@ -199,6 +168,18 @@ alloc_holder:
 		priv = NULL;
 	}
 
+	if (!list_empty(list) && merge) {
+		int ret;
+
+		ret = merge(list, event);
+		if (ret) {
+			mutex_unlock(&group->notification_mutex);
+			if (holder != &event->holder)
+				fsnotify_destroy_event_holder(holder);
+			return ret;
+		}
+	}
+
 	spin_lock(&event->lock);
 
 	if (list_empty(&event->holder.event_list)) {
@@ -213,18 +194,6 @@ alloc_holder:
 		goto alloc_holder;
 	}
 
-	if (!list_empty(list)) {
-		last_holder = list_entry(list->prev, struct fsnotify_event_holder, event_list);
-		last_event = last_holder->event;
-		if (event_compare(last_event, event)) {
-			spin_unlock(&event->lock);
-			mutex_unlock(&group->notification_mutex);
-			if (holder != &event->holder)
-				fsnotify_destroy_event_holder(holder);
-			return -EEXIST;
-		}
-	}
-
 	group->q_len++;
 	holder->event = event;
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 0e0c2b7..25789d4 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -328,8 +328,10 @@ extern struct fsnotify_event_private_data *fsnotify_remove_priv_from_event(struc
 									   struct fsnotify_event *event);
 
 /* attach the event to the group notification queue */
-extern int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_event *event,
-				     struct fsnotify_event_private_data *priv);
+extern int fsnotify_add_notify_event(struct fsnotify_group *group,
+				     struct fsnotify_event *event,
+				     struct fsnotify_event_private_data *priv,
+				     int (*merge)(struct list_head *, struct fsnotify_event *));
 /* true if the group notification queue is empty */
 extern bool fsnotify_notify_queue_is_empty(struct fsnotify_group *group);
 /* return, but do not dequeue the first event on the notification queue */

