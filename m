Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYJNU57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYJNU57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYJNUxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:53:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37843 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbYJNUxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:53:10 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 13/16] fanotify: ability for userspace to delay responses
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:52:38 -0400
Message-ID: <20081014205238.1057.6024.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
References: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Userspace may know that it is behind, may know it is going to take a while
to get a good response, or have any number of other reasons to block an
access request.  FAN_RESTTIMER will reset the timeout for an fanotify
access decision response.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/access.c       |   31 +++++++++++++++++++++++++++----
 fs/notify/fanotify.h     |    1 +
 fs/notify/notification.c |    2 ++
 include/linux/fanotify.h |    1 +
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/notify/access.c b/fs/notify/access.c
index 6a2606c..5b3b32e 100644
--- a/fs/notify/access.c
+++ b/fs/notify/access.c
@@ -55,6 +55,8 @@ int fanotify_add_event_to_access(struct fanotify_group *group, struct fanotify_e
 int fanotify_get_response_from_access(struct fanotify_group *group, struct fanotify_event *event)
 {
 	int ret;
+
+retry:
 	ret = wait_event_interruptible_timeout(group->access_waitq,
 						event->response,
 						msecs_to_jiffies(5000));
@@ -89,13 +91,25 @@ int fanotify_get_response_from_access(struct fanotify_group *group, struct fanot
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
@@ -108,7 +122,7 @@ int fanotify_process_access_response(struct fanotify_group *group, unsigned long
 	 * userspace can send a valid responce or we will clean it up after the
 	 * timeout
 	 */
-	if (response & ~(FAN_ALLOW | FAN_DENY))
+	if (response & ~(FAN_ALLOW | FAN_DENY | FAN_RESETTIMER))
 		return -EINVAL;
 
 	mutex_lock(&group->access_mutex);
@@ -117,6 +131,11 @@ int fanotify_process_access_response(struct fanotify_group *group, unsigned long
 			continue;
 
 		event = holder->event;
+
+		/* FAN_RESETTIMER should be left on the list for later....  */
+		if (response == FAN_RESETTIMER)
+			break;
+
 		spin_lock(&event->holder_spinlock);
 		holder->event = NULL;
 		/* as soon as we do this the event.holder might be reused */
@@ -132,9 +151,13 @@ int fanotify_process_access_response(struct fanotify_group *group, unsigned long
 	if (!event)
 		return -ENOENT;
 
+	spin_lock(&event->response_lock);
 	event->response = response;
+	spin_unlock(&event->response_lock);
 	wake_up(&group->access_waitq);
-	fanotify_put_event(event);
+
+	if (response != FAN_RESETTIMER)
+		fanotify_put_event(event);
 
 	return 0;
 }
diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index e07703f..d65db61 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -48,6 +48,7 @@ struct fanotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	/* if waiting for a userspace access answer this is the cookie they will send back */
 	unsigned long cookie;
+	spinlock_t response_lock; /* protects response */
 	unsigned int response;	/* userspace answer to question */
 };
 
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 89bb02c..dd0d2db 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -27,6 +27,7 @@
 #include <linux/path.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 
 #include <linux/fanotify.h>
 #include "fanotify.h"
@@ -169,6 +170,7 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 	event->holder.event = NULL;
 	INIT_LIST_HEAD(&event->holder.event_list);
 	atomic_set(&event->refcnt, 1);
+	spin_lock_init(&event->response_lock);
 
 	spin_lock_init(&event->holder_spinlock);
 
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index b5c9db9..a36bd6b 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -49,6 +49,7 @@
 /* answers will need to be either allow or deny */
 #define FAN_ALLOW		0x00000001
 #define FAN_DENY		0x00000002
+#define FAN_RESETTIMER		0x00000004
 
 #ifdef __KERNEL__
 #include <linux/types.h>

