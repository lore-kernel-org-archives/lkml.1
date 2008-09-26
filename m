Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYIZVVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYIZVVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYIZVTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:19:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48412 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbYIZVTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:19:19 -0400
Subject: [RFC 9/11] fanotify: send pid with fanotify notification events
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:19:15 -0400
Message-Id: <1222463955.2872.223.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: send pid with fanotify notification events

From: Eric Paris <eparis@redhat.com>

Often things like AV scanners may want to allow access to 'bad' files
based on the process making the access help by sending the pid of the
originally acting process.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify.h          |    1 +
 fs/notify/notification.c      |    2 ++
 fs/notify/notification_user.c |    8 +++++---
 3 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index cb97dbb..0394406 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -75,6 +75,7 @@ struct fanotify_event {
 	atomic_t refcnt;	/* how many groups still are using/need to send this event */
 	/* if waiting for a userspace access answer this is the cookie they will send back */
 	unsigned long cookie;
+	pid_t pid;		/* pid of the original process */
 	spinlock_t response_lock; /* protects response */
 	unsigned int response;	/* userspace answer to question */
 };
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index aa74137..d51411f 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -145,6 +145,8 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 	event->cookie = 0;
 	event->mask = mask;
 
+	event->pid = current->pid;
+
 	WARN_ON(!event->path.dentry);
 	WARN_ON(!event->path.mnt);
 
diff --git a/fs/notify/notification_user.c b/fs/notify/notification_user.c
index b492137..484260f 100644
--- a/fs/notify/notification_user.c
+++ b/fs/notify/notification_user.c
@@ -47,12 +47,13 @@
  * "fd=%d "	= 15 characters
  * "mask=%x "	= 14 characters
  * "cookie=%lu "= 27 characters
+ * "pid=%d "	= 16 characters
  * "\n "	=  2 characters
  * NULL		=  1 character
  * 
- * MAX_MESG_LEN = 59
+ * MAX_MESG_LEN = 75
  */
-#define MAX_MESG_LEN 59
+#define MAX_MESG_LEN 75
 
 static ssize_t fanotify_notification_read(struct file *file, char __user *buf, size_t lenp, loff_t *offset)
 {
@@ -133,7 +134,8 @@ static ssize_t fanotify_notification_read(struct file *file, char __user *buf, s
 	 * Build metadata string to send to the listener
 	 * IF YOU CHANGE THIS STRING UPDATE MAX_MSG_LEN!!!!!!11111!!!!
 	 */
-	rc = snprintf(output, lenp-1, "fd=%d mask=%x cookie=%lu\n", client_fd, event->mask, event->cookie);
+	rc = snprintf(output, lenp-1, "fd=%d mask=%x cookie=%lu pid=%d\n",
+		      client_fd, event->mask, event->cookie, event->pid);
 	if (rc < 0)
 		goto out;
 	output[rc] = '\0';


