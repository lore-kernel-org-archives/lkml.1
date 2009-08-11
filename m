Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbZHKQa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbZHKQa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZHKQa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:30:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431AbZHKQap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:30:45 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 8/8] fsnotify: replace an event on a list
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Date: Tue, 11 Aug 2009 12:30:45 -0400
Message-ID: <20090811163045.8648.98326.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
References: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify would like to clone events already on its notification list, make
changes to the new event, and then replace the old event on the list with
the new event.  This patch implements the replace functionality of that
process.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/notification.c         |   56 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsnotify_backend.h |    2 +
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 4fb1399..4f69b6f 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -289,6 +289,62 @@ static void initialize_event(struct fsnotify_event *event)
 	INIT_LIST_HEAD(&event->private_data_list);
 }
 
+/*
+ * Caller damn well better be holding whatever mutex is protecting the
+ * old_holder->event_list.
+ */
+int fsnotify_replace_event(struct fsnotify_event_holder *old_holder,
+			   struct fsnotify_event *new_event)
+{
+	struct fsnotify_event *old_event = old_holder->event;
+	struct fsnotify_event_holder *new_holder = NULL;
+
+	/*
+	 * There is one fsnotify_event_holder embedded inside each fsnotify_event.
+	 * Check if we expect to be able to use that holder.  If not alloc a new
+	 * holder.
+	 * For the overflow event it's possible that something will use the in
+	 * event holder before we get the lock so we may need to jump back and
+	 * alloc a new holder, this can't happen for most events...
+	 */
+	if (!list_empty(&new_event->holder.event_list)) {
+alloc_holder:
+		new_holder = fsnotify_alloc_event_holder();
+		if (!new_holder)
+			return -ENOMEM;
+	}
+
+	spin_lock(&old_event->lock);
+	spin_lock(&new_event->lock);
+
+	if (list_empty(&new_event->holder.event_list)) {
+		if (unlikely(new_holder))
+			fsnotify_destroy_event_holder(new_holder);
+		new_holder = &new_event->holder;
+	} else if (unlikely(!new_holder)) {
+		/* between the time we checked above and got the lock the in
+		 * event holder was used, go back and get a new one */
+		spin_unlock(&new_event->lock);
+		spin_unlock(&old_event->lock);
+		goto alloc_holder;
+	}
+
+	new_holder->event = new_event;
+	list_replace_init(&old_holder->event_list, &new_holder->event_list);
+
+	spin_unlock(&new_event->lock);
+	spin_unlock(&old_event->lock);
+
+	/* event == holder means we are referenced through the in event holder */
+	if (old_holder != &old_event->holder)
+		fsnotify_destroy_event_holder(old_holder);
+
+	fsnotify_get_event(new_event); /* on the list take reference */
+	fsnotify_put_event(old_event); /* off the list, drop reference */
+
+	return 0;
+}
+
 struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event)
 {
 	struct fsnotify_event *event;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 3a7fff2..427f6ff 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -365,6 +365,8 @@ extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32
 
 /* fanotify likes to change events after they are on lists... */
 extern struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event);
+extern int fsnotify_replace_event(struct fsnotify_event_holder *old_holder,
+				  struct fsnotify_event *new_event);
 
 #else
 

