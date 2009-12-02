Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZLBOPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZLBOPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZLBOPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:15:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbZLBOPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:15:00 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/4] fanotify: Add pids to events
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Wed, 02 Dec 2009 09:14:59 -0500
Message-ID: <20091202141458.12819.96170.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
References: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Pass the process identifiers of the triggering processes to fanotify
listeners: this information is useful for event filtering and logging.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.c      |    5 +++--
 fs/notify/fanotify/fanotify_user.c |    1 +
 fs/notify/notification.c           |    3 +++
 include/linux/fanotify.h           |    1 +
 include/linux/fsnotify_backend.h   |    1 +
 5 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 5b0b6b4..881067d 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -10,8 +10,9 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 {
 	pr_debug("%s: old=%p new=%p\n", __func__, old, new);
 
-	if ((old->to_tell == new->to_tell) &&
-	    (old->data_type == new->data_type)) {
+	if (old->to_tell == new->to_tell &&
+	    old->data_type == new->data_type &&
+	    old->tgid == new->tgid) {
 		switch (old->data_type) {
 		case (FSNOTIFY_EVENT_PATH):
 			if ((old->path.mnt == new->path.mnt) &&
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 7646111..7cfb2f6 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -108,6 +108,7 @@ static ssize_t fill_event_metadata(struct fsnotify_group *group,
 	metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
 	metadata->mask = fanotify_outgoing_mask(event->mask);
+	metadata->pid = pid_vnr(event->tgid);
 	metadata->fd = create_fd(group, event);
 
 	return metadata->fd;
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 066f1f9..7fc8d00 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -93,6 +93,7 @@ void fsnotify_put_event(struct fsnotify_event *event)
 		BUG_ON(!list_empty(&event->private_data_list));
 
 		kfree(event->file_name);
+		put_pid(event->tgid);
 		kmem_cache_free(fsnotify_event_cachep, event);
 	}
 }
@@ -346,6 +347,7 @@ struct fsnotify_event *fsnotify_clone_event(struct fsnotify_event *old_event)
 			return NULL;
 		}
 	}
+	event->tgid = get_pid(old_event->tgid);
 	if (event->data_type == FSNOTIFY_EVENT_PATH)
 		path_get(&event->path);
 
@@ -385,6 +387,7 @@ struct fsnotify_event *fsnotify_create_event(struct inode *to_tell, __u32 mask,
 		event->name_len = strlen(event->file_name);
 	}
 
+	event->tgid = get_pid(task_tgid(current));
 	event->sync_cookie = cookie;
 	event->to_tell = to_tell;
 	event->data_type = data_type;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index c1c6616..5f633af 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -62,6 +62,7 @@ struct fanotify_event_metadata {
 	__u32 vers;
 	__s32 fd;
 	__u64 mask;
+	__s64 pid;
 } __attribute__ ((packed));
 
 /* Helper functions to deal with fanotify_event_metadata buffers */
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index ff654c1..7d93572 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -221,6 +221,7 @@ struct fsnotify_event {
 	u32 sync_cookie;	/* used to corrolate events, namely inotify mv events */
 	char *file_name;
 	size_t name_len;
+	struct pid *tgid;
 
 	struct list_head private_data_list;	/* groups can store private data here */
 };

