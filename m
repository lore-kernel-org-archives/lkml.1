Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYARBqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYARBqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYARBqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:46:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758143AbYARBqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:46:43 -0500
Message-ID: <479004F0.10508@redhat.com>
Date: Fri, 18 Jan 2008 02:46:24 +0100
From: Miloslav Trmac <mitr@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: dwmw2@infradead.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Let userspace fully control TTY input auditing
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------040803030300050407040400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040803030300050407040400
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Remove the code that automatically disables TTY input auditing in 
processes that open TTYs when they have no other TTY open; this 
heuristic was intended to automatically handle daemons, but it has false 
positives (e.g. with sshd) that make it impossible to control TTY input 
auditing from a PAM module.  With this patch, TTY input auditing is 
controlled from user-space only.

On the other hand, not even for daemons does it make sense to audit 
"input" from PTY masters; this data was produced by a program writing to 
the PTY slave, and does not represent data entered by the user.

--------------040803030300050407040400
Content-Type: text/x-patch;
 name="linux-upstream.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-upstream.patch"

From: Miloslav Trmac <mitr@redhat.com>

Remove the code that automatically disables TTY input auditing in
processes that open TTYs when they have no other TTY open; this
heuristic was intended to automatically handle daemons, but it has
false positives (e.g. with sshd) that make it impossible to control
TTY input auditing from a PAM module.  With this patch, TTY input
auditing is controlled from user-space only.

On the other hand, not even for daemons does it make sense to audit
"input" from PTY masters; this data was produced by a program writing
to the PTY slave, and does not represent data entered by the user.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
---
 drivers/char/tty_audit.c |   54 ++-----------------------------------
 drivers/char/tty_io.c    |   14 ---------
 include/linux/tty.h      |    5 ---
 3 files changed, 5 insertions(+), 68 deletions(-)

diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index d222012..1691b00 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -231,6 +231,10 @@ void tty_audit_add_data(struct tty_struct *tty, unsigned char *data,
 	if (unlikely(size == 0))
 		return;
 
+	if (tty->driver->type == TTY_DRIVER_TYPE_PTY
+	    && tty->driver->subtype == PTY_TYPE_MASTER)
+		return;
+
 	buf = tty_audit_buf_get(tty);
 	if (!buf)
 		return;
@@ -293,53 +297,3 @@ void tty_audit_push(struct tty_struct *tty)
 		tty_audit_buf_put(buf);
 	}
 }
-
-/**
- *	tty_audit_opening	-	A TTY is being opened.
- *
- *	As a special hack, tasks that close all their TTYs and open new ones
- *	are assumed to be system daemons (e.g. getty) and auditing is
- *	automatically disabled for them.
- */
-void tty_audit_opening(void)
-{
-	int disable;
-
-	disable = 1;
-	spin_lock_irq(&current->sighand->siglock);
-	if (current->signal->audit_tty == 0)
-		disable = 0;
-	spin_unlock_irq(&current->sighand->siglock);
-	if (!disable)
-		return;
-
-	task_lock(current);
-	if (current->files) {
-		struct fdtable *fdt;
-		unsigned i;
-
-		/*
-		 * We don't take a ref to the file, so we must hold ->file_lock
-		 * instead.
-		 */
-		spin_lock(&current->files->file_lock);
-		fdt = files_fdtable(current->files);
-		for (i = 0; i < fdt->max_fds; i++) {
-			struct file *filp;
-
-			filp = fcheck_files(current->files, i);
-			if (filp && is_tty(filp)) {
-				disable = 0;
-				break;
-			}
-		}
-		spin_unlock(&current->files->file_lock);
-	}
-	task_unlock(current);
-	if (!disable)
-		return;
-
-	spin_lock_irq(&current->sighand->siglock);
-	current->signal->audit_tty = 0;
-	spin_unlock_irq(&current->sighand->siglock);
-}
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index f36fecd..361f3c5 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1533,15 +1533,6 @@ int tty_hung_up_p(struct file * filp)
 
 EXPORT_SYMBOL(tty_hung_up_p);
 
-/**
- * is_tty	-	checker whether file is a TTY
- */
-int is_tty(struct file *filp)
-{
-	return filp->f_op->read == tty_read
-		|| filp->f_op->read == hung_up_tty_read;
-}
-
 static void session_clear_tty(struct pid *session)
 {
 	struct task_struct *p;
@@ -2710,7 +2701,6 @@ got_driver:
 		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
 	mutex_unlock(&tty_mutex);
-	tty_audit_opening();
 	return 0;
 }
 
@@ -2773,10 +2763,8 @@ static int ptmx_open(struct inode * inode, struct file * filp)
 
 	check_tty_count(tty, "tty_open");
 	retval = ptm_driver->open(tty, filp);
-	if (!retval) {
-		tty_audit_opening();
+	if (!retval)
 		return 0;
-	}
 out1:
 	release_dev(filp);
 	return retval;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index c555f54..e9c3f89 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -307,7 +307,6 @@ extern void tty_hangup(struct tty_struct * tty);
 extern void tty_vhangup(struct tty_struct * tty);
 extern void tty_unhangup(struct file *filp);
 extern int tty_hung_up_p(struct file * filp);
-extern int is_tty(struct file *filp);
 extern void do_SAK(struct tty_struct *tty);
 extern void __do_SAK(struct tty_struct *tty);
 extern void disassociate_ctty(int priv);
@@ -358,7 +357,6 @@ extern void tty_audit_exit(void);
 extern void tty_audit_fork(struct signal_struct *sig);
 extern void tty_audit_push(struct tty_struct *tty);
 extern void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid);
-extern void tty_audit_opening(void);
 #else
 static inline void tty_audit_add_data(struct tty_struct *tty,
 				      unsigned char *data, size_t size)
@@ -376,9 +374,6 @@ static inline void tty_audit_push(struct tty_struct *tty)
 static inline void tty_audit_push_task(struct task_struct *tsk, uid_t loginuid)
 {
 }
-static inline void tty_audit_opening(void)
-{
-}
 #endif
 
 /* tty_ioctl.c */

--------------040803030300050407040400--
