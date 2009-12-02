Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZLBOO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZLBOO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZLBOO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:14:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbZLBOOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:14:55 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/4] fanotify: create_fd cleanup
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Wed, 02 Dec 2009 09:14:52 -0500
Message-ID: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Code cleanup which does the fd creation work seperately from the userspace
metadata creation.  It fits better with the other code.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify_user.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c5f59d8..7646111 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -44,17 +44,14 @@ static struct fsnotify_event *get_one_event(struct fsnotify_group *group,
 	return fsnotify_remove_notify_event(group);
 }
 
-static int create_and_fill_fd(struct fsnotify_group *group,
-			      struct fanotify_event_metadata *metadata,
-			      struct fsnotify_event *event)
+static int create_fd(struct fsnotify_group *group, struct fsnotify_event *event)
 {
 	int client_fd, err;
 	struct dentry *dentry;
 	struct vfsmount *mnt;
 	struct file *new_file;
 
-	pr_debug("%s: group=%p metadata=%p event=%p\n", __func__, group,
-		 metadata, event);
+	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
 	client_fd = get_unused_fd();
 	if (client_fd < 0)
@@ -98,9 +95,7 @@ static int create_and_fill_fd(struct fsnotify_group *group,
 		fd_install(client_fd, new_file);
 	}
 
-	metadata->fd = client_fd;
-
-	return 0;
+	return client_fd;
 }
 
 static ssize_t fill_event_metadata(struct fsnotify_group *group,
@@ -113,9 +108,9 @@ static ssize_t fill_event_metadata(struct fsnotify_group *group,
 	metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
 	metadata->mask = fanotify_outgoing_mask(event->mask);
+	metadata->fd = create_fd(group, event);
 
-	return create_and_fill_fd(group, metadata, event);
-
+	return metadata->fd;
 }
 
 static ssize_t copy_event_to_user(struct fsnotify_group *group,
@@ -128,7 +123,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
 	ret = fill_event_metadata(group, &fanotify_event_metadata, event);
-	if (ret)
+	if (ret < 0)
 		return ret;
 
 	if (copy_to_user(buf, &fanotify_event_metadata, FAN_EVENT_METADATA_LEN))

