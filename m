Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZHKQaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZHKQaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZHKQap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:30:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55895 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbZHKQak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:30:40 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 7/8] fsnotify: clone existing events
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Date: Tue, 11 Aug 2009 12:30:40 -0400
Message-ID: <20090811163039.8648.68084.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
References: <20090811163000.8648.87614.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fsnotify_clone_event will take an event, clone it, and return the cloned
event to the caller.  Since events may be in use by multiple fsnotify
groups simultaneously certain event entries (such as the mask) cannot be
changed after the event was created.  Since fanotify would like to merge
events happening on the same file it needs a new clean event to work with
so it can change any fields it wishes.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/notification.c         |   29 +++++++++++++++++++++++++----
 include/linux/fsnotify_backend.h |    3 +++
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index bcf6fde..4fb1399 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -286,11 +286,33 @@ static void initialize_event(struct fsnotify_event *event)
 
 	spin_lock_init(&event->lock);
 
-	event->data_type = FSNOTIFY_EVENT_NONE;
-
 	INIT_LIST_HEAD(&event->private_data_list);
 }
 
+struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event)
+{
+	struct fsnotify_event *event;
+
+	event = kmem_cache_alloc(fsnotify_event_cachep, GFP_KERNEL);
+	if (!event)
+		return NULL;
+
+	memcpy(event, old_event, sizeof(*event));
+	initialize_event(event);
+
+	if (event->name_len) {
+		event->file_name = kstrdup(old_event->file_name, GFP_KERNEL);
+		if (!event->file_name) {
+			kmem_cache_free(fsnotify_event_cachep, event);
+			return NULL;
+		}
+	}
+	if (event->data_type == FSNOTIFY_EVENT_PATH)
+		path_get(&event->path);
+
+	return event;
+}
+
 /*
  * fsnotify_create_event - Allocate a new event which will be sent to each
  * group's handle_event function if the group was interested in this
@@ -326,6 +348,7 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 
 	event->sync_cookie = cookie;
 	event->to_tell = to_tell;
+	event->data_type = data_type;
 
 	switch (data_type) {
 	case FSNOTIFY_EVENT_FILE: {
@@ -342,12 +365,10 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 		event->path.dentry = path->dentry;
 		event->path.mnt = path->mnt;
 		path_get(&event->path);
-		event->data_type = FSNOTIFY_EVENT_PATH;
 		break;
 	}
 	case FSNOTIFY_EVENT_INODE:
 		event->inode = data;
-		event->data_type = FSNOTIFY_EVENT_INODE;
 		break;
 	case FSNOTIFY_EVENT_NONE:
 		event->inode = NULL;
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 25789d4..3a7fff2 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -363,6 +363,9 @@ extern struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32
 						    void *data, int data_is, const char *name,
 						    u32 cookie, gfp_t gfp);
 
+/* fanotify likes to change events after they are on lists... */
+extern struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event);
+
 #else
 
 static inline void fsnotify(struct inode *to_tell, __u32 mask, void *data, int data_is,

