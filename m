Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZHQBwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZHQBwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 21:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZHQBwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 21:52:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43794 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbZHQBwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 21:52:05 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/3] notify: unused event private race
To: linux-kernel@vger.kernel.org, fs-devel@vger.kernel.org
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk
Date: Sun, 16 Aug 2009 21:51:44 -0400
Message-ID: <20090817015143.15099.80614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify decides if private data it passed to get added to an event was used
by checking list_empty().  But it's possible that the event may have been
dequeued and the private event removed so it would look empty.  The fix is
to use the return code from fsnotify_add_notify_event rather than looking
at the list.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_fsnotify.c |   13 +++++++------
 fs/notify/inotify/inotify_user.c     |    7 +++----
 fs/notify/notification.c             |    7 +++----
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index 47cd258..5dcbafe 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -62,13 +62,14 @@ static int inotify_handle_event(struct fsnotify_group *group, struct fsnotify_ev
 	event_priv->wd = wd;
 
 	ret = fsnotify_add_notify_event(group, event, fsn_event_priv);
-	/* EEXIST is not an error */
-	if (ret == -EEXIST)
-		ret = 0;
-
-	/* did event_priv get attached? */
-	if (list_empty(&fsn_event_priv->event_list))
+	if (ret) {
 		inotify_free_event_priv(fsn_event_priv);
+		/* EEXIST says we tail matched, EOVERFLOW isn't something
+		 * to report up the stack. */
+		if ((ret == -EEXIST) ||
+		    (ret == -EOVERFLOW))
+			ret = 0;
+	}
 
 	/*
 	 * If we hold the entry until after the event is on the queue
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index c17d5a3..54cbded 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -386,6 +386,7 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
 	struct fsnotify_event *ignored_event;
 	struct inotify_event_private_data *event_priv;
 	struct fsnotify_event_private_data *fsn_event_priv;
+	int ret;
 
 	ignored_event = fsnotify_create_event(NULL, FS_IN_IGNORED, NULL,
 					      FSNOTIFY_EVENT_NONE, NULL, 0,
@@ -404,10 +405,8 @@ void inotify_ignored_and_remove_idr(struct fsnotify_mark_entry *entry,
 	fsn_event_priv->group = group;
 	event_priv->wd = ientry->wd;
 
-	fsnotify_add_notify_event(group, ignored_event, fsn_event_priv);
-
-	/* did the private data get added? */
-	if (list_empty(&fsn_event_priv->event_list))
+	ret = fsnotify_add_notify_event(group, ignored_event, fsn_event_priv);
+	if (ret)
 		inotify_free_event_priv(fsn_event_priv);
 
 skip_send_ignore:
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 5213685..74b3cf3 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -171,9 +171,7 @@ int fsnotify_add_notify_event(struct fsnotify_group *group, struct fsnotify_even
 	struct list_head *list = &group->notification_list;
 	struct fsnotify_event_holder *last_holder;
 	struct fsnotify_event *last_event;
-
-	/* easy to tell if priv was attached to the event */
-	INIT_LIST_HEAD(&priv->event_list);
+	int ret = 0;
 
 	/*
 	 * There is one fsnotify_event_holder embedded inside each fsnotify_event.
@@ -194,6 +192,7 @@ alloc_holder:
 
 	if (group->q_len >= group->max_events) {
 		event = &q_overflow_event;
+		ret = -EOVERFLOW;
 		/* sorry, no private data on the overflow event */
 		priv = NULL;
 	}
@@ -235,7 +234,7 @@ alloc_holder:
 	mutex_unlock(&group->notification_mutex);
 
 	wake_up(&group->notification_waitq);
-	return 0;
+	return ret;
 }
 
 /*

