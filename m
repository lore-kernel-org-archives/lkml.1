Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYIZVVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYIZVVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYIZVTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:19:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbYIZVT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:19:29 -0400
Subject: [RFC 11/11] fanotify: send file f_flags along with notifications
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Content-Type: text/plain
Date: Fri, 26 Sep 2008 17:19:22 -0400
Message-Id: <1222463962.2872.227.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fanotify: send file f_flags along with notifications

From: Eric Paris <eparis@redhat.com>

fanotify listeners may be interested in what flags the file associated with
a particular event were set.  This sends f_flags along with the event
metadata.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify.h          |    1 +
 fs/notify/notification.c      |    1 +
 fs/notify/notification_user.c |   11 +++++++----
 3 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/fs/notify/fanotify.h b/fs/notify/fanotify.h
index c2581ec..5b9b327 100644
--- a/fs/notify/fanotify.h
+++ b/fs/notify/fanotify.h
@@ -77,6 +77,7 @@ struct fanotify_event {
 	unsigned long cookie;
 	pid_t pid;		/* pid of the original process */
 	pid_t tgid;		/* tgid of the original process */
+	unsigned int f_flags;	/* f_flags from the original file */
 	spinlock_t response_lock; /* protects response */
 	unsigned int response;	/* userspace answer to question */
 };
diff --git a/fs/notify/notification.c b/fs/notify/notification.c
index 4a34be1..4828561 100644
--- a/fs/notify/notification.c
+++ b/fs/notify/notification.c
@@ -147,6 +147,7 @@ struct fanotify_event *create_event(struct file *file, unsigned int mask)
 
 	event->pid = current->pid;
 	event->tgid = current->tgid;
+	event->f_flags = file->f_flags;
 
 	WARN_ON(!event->path.dentry);
 	WARN_ON(!event->path.mnt);
diff --git a/fs/notify/notification_user.c b/fs/notify/notification_user.c
index 4f87986..15afb45 100644
--- a/fs/notify/notification_user.c
+++ b/fs/notify/notification_user.c
@@ -49,12 +49,13 @@
  * "cookie=%lu "= 27 characters
  * "pid=%d "	= 16 characters
  * "tgid=%d "	= 17 characters
+ * "flags=%x "	= 15 characters
  * "\n "	=  2 characters
  * NULL		=  1 character
  * 
- * MAX_MESG_LEN = 92
+ * MAX_MESG_LEN = 107
  */
-#define MAX_MESG_LEN 92
+#define MAX_MESG_LEN 107
 
 static ssize_t fanotify_notification_read(struct file *file, char __user *buf, size_t lenp, loff_t *offset)
 {
@@ -135,8 +136,10 @@ static ssize_t fanotify_notification_read(struct file *file, char __user *buf, s
 	 * Build metadata string to send to the listener
 	 * IF YOU CHANGE THIS STRING UPDATE MAX_MSG_LEN!!!!!!11111!!!!
 	 */
-	rc = snprintf(output, lenp-1, "fd=%d mask=%x cookie=%lu pid=%d tgid=%d\n",
-		      client_fd, event->mask, event->cookie, event->pid, event->tgid);
+	rc = snprintf(output, lenp-1, "fd=%d mask=%x cookie=%lu pid=%d tgid=%d "
+		      "flags=%x\n",
+		      client_fd, event->mask, event->cookie, event->pid, event->tgid,
+		      event->f_flags);
 	if (rc < 0)
 		goto out;
 	output[rc] = '\0';


