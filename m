Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYIZVVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYIZVVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbYIZVT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:19:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48418 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbYIZVT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:19:27 -0400
Subject: [RFC 10/11] fanotify: send tgid with notification messages
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:19:18 -0400
Message-Id: <1222463958.2872.225.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: send tgid with notification messages

From: Eric Paris <eparis@redhat.com>

Send tgid of original process to fanotify listeners

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify.h          |    1 +
 fs/notify/notification.c      |    1 +
 fs/notify/notification_user.c |    9 +++++----
 3 files changed, 7 insertions(+), 4 deletions(-)


diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index 0394406..c2581ec 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -76,6 +76,7 @@ struct fanotify_event {
 	/* if waiting for a userspace access answer this is the cookie they will send back */
 	unsigned long cookie;
 	pid_t pid;		/* pid of the original process */
+	pid_t tgid;		/* tgid of the original process */
 	spinlock_t response_lock; /* protects response */
 	unsigned int response;	/* userspace answer to question */
 };
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index d51411f..4a34be1 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -146,6 +146,7 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 	event->mask = mask;
 
 	event->pid = current->pid;
+	event->tgid = current->tgid;
 
 	WARN_ON(!event->path.dentry);
 	WARN_ON(!event->path.mnt);
diff --git a/fs/notify/notification_user.c b/fs/notify/notification_user.c
index 484260f..4f87986 100644
--- a/fs/notify/notification_user.c
+++ b/fs/notify/notification_user.c
@@ -48,12 +48,13 @@
  * "mask=%x "	= 14 characters
  * "cookie=%lu "= 27 characters
  * "pid=%d "	= 16 characters
+ * "tgid=%d "	= 17 characters
  * "\n "	=  2 characters
  * NULL		=  1 character
  * 
- * MAX_MESG_LEN = 75
+ * MAX_MESG_LEN = 92
  */
-#define MAX_MESG_LEN 75
+#define MAX_MESG_LEN 92
 
 static ssize_t fanotify_notification_read(struct file *file, char __user *buf, size_t lenp, loff_t *offset)
 {
@@ -134,8 +135,8 @@ static ssize_t fanotify_notification_read(struct file *file, char __user *buf, s
 	 * Build metadata string to send to the listener
 	 * IF YOU CHANGE THIS STRING UPDATE MAX_MSG_LEN!!!!!!11111!!!!
 	 */
-	rc = snprintf(output, lenp-1, "fd=%d mask=%x cookie=%lu pid=%d\n",
-		      client_fd, event->mask, event->cookie, event->pid);
+	rc = snprintf(output, lenp-1, "fd=%d mask=%x cookie=%lu pid=%d tgid=%d\n",
+		      client_fd, event->mask, event->cookie, event->pid, event->tgid);
 	if (rc < 0)
 		goto out;
 	output[rc] = '\0';


