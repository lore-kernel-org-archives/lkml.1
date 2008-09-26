Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYIZVUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYIZVUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYIZVTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:19:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbYIZVTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:19:15 -0400
Subject: [RFC 8/11] fanotify: ability for userspace to delay responses
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:19:11 -0400
Message-Id: <1222463951.2872.221.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: ability for userspace to delay responses

From: Eric Paris <eparis@redhat.com>

Userspace may know that it is behind, may know it is going to take a while
to get a good response, or have any number of other reasons to block an
access request.  FAN_RESTTIMER will reset the timeout for an fanotify
access decision response.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/access.c       |   33 ++++++++++++++++++++++++++++-----
 fs/notify/fanotify.h     |    2 ++
 fs/notify/notification.c |    2 ++
 include/linux/fanotify.h |    5 +++--
 4 files changed, 35 insertions(+), 7 deletions(-)


diff --git a/fs/notify/access.c b/fs/notify/access.c
index 132ef7b..b4b132b 100644
--- a/fs/notify/access.c
+++ b/fs/notify/access.c
@@ -56,6 +56,8 @@ int add_event_to_group_access(struct fanotify_group *group, struct fanotify_even
 int get_response_from_group_access(struct fanotify_group *group, struct fanotify_event *event)
 {
 	int ret;
+
+retry:
 	ret = wait_event_interruptible_timeout(group->access_waitq,
 						event->response,
 						msecs_to_jiffies(5000));
@@ -88,13 +90,25 @@ int get_response_from_group_access(struct fanotify_group *group, struct fanotify
 	}
 
 	/* userspace responded, convert to something usable */
+	spin_lock(&event->response_lock);
 	switch (event->response) {
 	case FAN_ALLOW:
-		return 0;
+		ret = 0;
+		break;
 	case FAN_DENY:
+		ret = -EPERM;
+		break;
+	case FAN_RESETTIMER:
+		event->response = 0;
+		spin_unlock(&event->response_lock);
+		goto retry;
 	default:
-		return -EPERM;
+		ret = -EPERM;
+		break;
 	}
+	spin_unlock(&event->response_lock);
+
+	return ret;
 }
 
 int fanotify_process_access_response(struct fanotify_group *group, unsigned long cookie, unsigned int response)
@@ -107,7 +121,7 @@ int fanotify_process_access_response(struct fanotify_group *group, unsigned long
 	 * userspace can send a valid responce or we will clean it up after the
 	 * timeout
 	 */
-	if (response & ~(FAN_ALLOW | FAN_DENY))
+	if (response & ~(FAN_ALLOW | FAN_DENY | FAN_RESETTIMER))
 		return -EINVAL;
 
 	mutex_lock(&group->access_mutex);
@@ -116,11 +130,16 @@ int fanotify_process_access_response(struct fanotify_group *group, unsigned long
 			continue;
 
 		event = holder->event;
+
+		/* FAN_RESETTIMER should be left on the list for later....  */
+		if (response == FAN_RESETTIMER)
+			break;
+
 		holder->event = NULL;
 		/* as soon as we do this the event.holder might be reused */
 		list_del_init(&holder->event_list);
 
-		if (event != (struct fanotify_event *)holder)
+			if (event != (struct fanotify_event *)holder)
 			destroy_event_holder(holder);
 		break;
 	}
@@ -129,9 +148,13 @@ int fanotify_process_access_response(struct fanotify_group *group, unsigned long
 	if (!event)
 		return -ENOENT;
 
+	spin_lock(&event->response_lock);
 	event->response = response;
+	spin_unlock(&event->response_lock);
 	wake_up(&group->access_waitq);
-	put_event(event);
+
+	if (response != FAN_RESETTIMER)
+		put_event(event);
 
 	return 0;
 }
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index 38e156e..cb97dbb 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -9,6 +9,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/path.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
 
@@ -74,6 +75,7 @@ struct fanotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	/* if waiting for a userspace access answer this is the cookie they will send back */
 	unsigned long cookie;
+	spinlock_t response_lock; /* protects response */
 	unsigned int response;	/* userspace answer to question */
 };
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index e1a6a24..aa74137 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -25,6 +25,7 @@
 #include <linux/path.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 
 #include <linux/fanotify.h>
 #include "fanotify.h"
@@ -135,6 +136,7 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 	event->holder.event = NULL;
 	INIT_LIST_HEAD(&event->holder.event_list);
 	atomic_set(&event->refcnt, 1);
+	spin_lock_init(&event->response_lock);
 
 	event->path.dentry = file->f_path.dentry;
 	event->path.mnt = file->f_path.mnt;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 5d3e5d0..2a31e53 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -44,9 +44,10 @@
 #define FAN_ALL_EVENTS_ACCESS   (FAN_OPEN_ACCESS |\
 				 FAN_READ_ACCESS)
 
-/* answers will need to be either allow or deny */
+/* answers will need to be either allow, deny, or reset */
 #define FAN_ALLOW		0x00000001
-#define FAN_DENY		0x00000010
+#define FAN_DENY		0x00000002
+#define FAN_RESETTIMER		0x00000004
 
 #ifdef __KERNEL__
 


