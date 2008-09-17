Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYIQV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYIQV0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbYIQVZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:25:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37134 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbYIQVZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:25:54 -0400
Subject: [PATCH] Audit: Log TIOCSTI
From: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
To: Eric Paris <eparis@redhat.com>, viro <viro@zeniv.linux.org.uk>
Cc: linux-audit <linux-audit@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 23:24:48 +0200
Message-Id: <1221686688.3674.7.camel@amilo>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miloslav Trmac <mitr@redhat.com>

AUDIT_TTY records currently log all data read by processes marked for
TTY input auditing, even if the data was "pushed back" using the TIOCSTI
ioctl, not typed by the user.

This patch records all TIOCSTI calls to disambiguate the input.  It
generates one audit message per character pushed back; considering
TIOCSTI is used very rarely, this simple solution is probably good
enough.  (The only program I could find that uses TIOCSTI is mailx/nail
in "header editing" mode, e.g. using the ~h escape.  mailx is used very
rarely, and the escapes are used even rarer.)

Signed-Off-By: Miloslav Trmac <mitr@redhat.com>
---
 drivers/char/tty_audit.c |   75 +++++++++++++++++++++++++++++--------
 drivers/char/tty_io.c    |    1 
 include/linux/tty.h      |    4 +
 3 files changed, 65 insertions(+), 15 deletions(-)
diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 3582f43..d927616 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -67,6 +67,28 @@ static void tty_audit_buf_put(struct tty_audit_buf *buf)
 		tty_audit_buf_free(buf);
 }
 
+static void tty_audit_log(const char *description, struct task_struct *tsk,
+			  uid_t loginuid, unsigned sessionid, int major,
+			  int minor, unsigned char *data, size_t size)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
+	if (ab) {
+		char name[sizeof(tsk->comm)];
+
+		audit_log_format(ab, "%s pid=%u uid=%u auid=%u ses=%u "
+				 "major=%d minor=%d comm=", description,
+				 tsk->pid, tsk->uid, loginuid, sessionid,
+				 major, minor);
+		get_task_comm(name, tsk);
+		audit_log_untrustedstring(ab, name);
+		audit_log_format(ab, " data=");
+		audit_log_n_untrustedstring(ab, data, size);
+		audit_log_end(ab);
+	}
+}
+
 /**
  *	tty_audit_buf_push	-	Push buffered data out
  *
@@ -77,25 +99,12 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
 			       unsigned int sessionid,
 			       struct tty_audit_buf *buf)
 {
-	struct audit_buffer *ab;
-
 	if (buf->valid == 0)
 		return;
 	if (audit_enabled == 0)
 		return;
-	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
-	if (ab) {
-		char name[sizeof(tsk->comm)];
-
-		audit_log_format(ab, "tty pid=%u uid=%u auid=%u ses=%u "
-				 "major=%d minor=%d comm=", tsk->pid, tsk->uid,
-				 loginuid, sessionid, buf->major, buf->minor);
-		get_task_comm(name, tsk);
-		audit_log_untrustedstring(ab, name);
-		audit_log_format(ab, " data=");
-		audit_log_n_untrustedstring(ab, buf->data, buf->valid);
-		audit_log_end(ab);
-	}
+	tty_audit_log("tty", tsk, loginuid, sessionid, buf->major, buf->minor,
+		      buf->data, buf->valid);
 	buf->valid = 0;
 }
 
@@ -150,6 +159,42 @@ void tty_audit_fork(struct signal_struct *sig)
 }
 
 /**
+ *	tty_audit_tiocsti	-	Log TIOCSTI
+ */
+void tty_audit_tiocsti(struct tty_struct *tty, char ch)
+{
+	struct tty_audit_buf *buf;
+	int major, minor, should_audit;
+
+	spin_lock_irq(&current->sighand->siglock);
+	should_audit = current->signal->audit_tty;
+	buf = current->signal->tty_audit_buf;
+	if (buf)
+		atomic_inc(&buf->count);
+	spin_unlock_irq(&current->sighand->siglock);
+
+	major = tty->driver->major;
+	minor = tty->driver->minor_start + tty->index;
+	if (buf) {
+		mutex_lock(&buf->mutex);
+		if (buf->major == major && buf->minor == minor)
+			tty_audit_buf_push_current(buf);
+		mutex_unlock(&buf->mutex);
+		tty_audit_buf_put(buf);
+	}
+
+	if (should_audit && audit_enabled) {
+		uid_t auid;
+		unsigned int sessionid;
+
+		auid = audit_get_loginuid(current);
+		sessionid = audit_get_sessionid(current);
+		tty_audit_log("ioctl=TIOCSTI", current, auid, sessionid, major,
+			      minor, &ch, 1);
+	}
+}
+
+/**
  *	tty_audit_push_task	-	Flush task's pending audit data
  */
 void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid, u32 sessionid)
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index daeb8f7..53cc0d6 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2467,6 +2467,7 @@ static int tiocsti(struct tty_struct *tty, char __user *p)
 		return -EPERM;
 	if (get_user(ch, p))
 		return -EFAULT;
+	tty_audit_tiocsti(tty, ch);
 	ld = tty_ldisc_ref_wait(tty);
 	ld->ops->receive_buf(tty, &ch, &mbz, 1);
 	tty_ldisc_deref(ld);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 0cbec74..3995211 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -403,6 +403,7 @@ extern void tty_audit_add_data(struct tty_struct *tty, unsigned char *data,
 			       size_t size);
 extern void tty_audit_exit(void);
 extern void tty_audit_fork(struct signal_struct *sig);
+extern void tty_audit_tiocsti(struct tty_struct *tty, char ch);
 extern void tty_audit_push(struct tty_struct *tty);
 extern void tty_audit_push_task(struct task_struct *tsk,
 					uid_t loginuid, u32 sessionid);
@@ -411,6 +412,9 @@ static inline void tty_audit_add_data(struct tty_struct *tty,
 				      unsigned char *data, size_t size)
 {
 }
+static inline void tty_audit_tiocsti(struct tty_struct *tty, char ch)
+{
+}
 static inline void tty_audit_exit(void)
 {
 }


