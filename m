Return-Path: <linux-kernel-owner+w=401wt.eu-S1756876AbYJEQWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbYJEQWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbYJEQSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:18:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49665 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758206AbYJEQSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:18:11 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 47/76] tty: shutdown method
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:18:11 +0100
Message-ID: <20081005161805.1997.35082.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now there are various drivers that try to use tty->count to know when
they get the final close. Aristeau Rozanski showed while debugging the vt
sysfs race that this isn't entirely safe.

Instead of driver side tricks to work around this introduce a shutdown which
is called when the tty is being destructed. This also means that the shutdown
method is tied into the refcounting.

Use this to rework the console close/sysfs logic.

Remove lots of special case code from the tty core code. The pty code can now
have a shutdown() method that replaces the special case hackery in the tree
free up paths.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c         |   15 ++++++++++---
 drivers/char/tty_io.c      |   49 ++++++++++++++++++++++++++------------------
 drivers/char/vt.c          |   34 +++++++++++++++----------------
 include/linux/tty.h        |    3 ++-
 include/linux/tty_driver.h |    6 +++++
 5 files changed, 65 insertions(+), 42 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 76b2793..ec09c1c 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -388,7 +388,14 @@ static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
-static const struct tty_operations pty_unix98_ops = {
+static void pty_shutdown(struct tty_struct *tty)
+{
+	/* We have our own method as we don't use the tty index */
+	kfree(tty->termios);
+	kfree(tty->termios_locked);
+}
+
+static const struct tty_operations ptm_unix98_ops = {
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -397,10 +404,10 @@ static const struct tty_operations pty_unix98_ops = {
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
-	.ioctl = pty_unix98_ioctl
+	.ioctl = pty_unix98_ioctl,
+	.shutdown = pty_shutdown
 };
 
-
 static void __init unix98_pty_init(void)
 {
 	ptm_driver = alloc_tty_driver(NR_UNIX98_PTY_MAX);
@@ -427,7 +434,7 @@ static void __init unix98_pty_init(void)
 	ptm_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
 		TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_DEVPTS_MEM;
 	ptm_driver->other = pts_driver;
-	tty_set_operations(ptm_driver, &pty_unix98_ops);
+	tty_set_operations(ptm_driver, &ptm_unix98_ops);
 
 	pts_driver->owner = THIS_MODULE;
 	pts_driver->driver_name = "pty_slave";
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 2e96ce0..f91704d 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1482,6 +1482,31 @@ release_mem_out:
 	goto end_init;
 }
 
+void tty_free_termios(struct tty_struct *tty)
+{
+	struct ktermios *tp;
+	int idx = tty->index;
+	/* Kill this flag and push into drivers for locking etc */
+	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
+		/* FIXME: Locking on ->termios array */
+		tp = tty->termios;
+		tty->driver->termios[idx] = NULL;
+		kfree(tp);
+
+		tp = tty->termios_locked;
+		tty->driver->termios_locked[idx] = NULL;
+		kfree(tp);
+	}
+}
+EXPORT_SYMBOL(tty_free_termios);
+
+void tty_shutdown(struct tty_struct *tty)
+{
+	tty->driver->ttys[tty->index] = NULL;
+	tty_free_termios(tty);
+}
+EXPORT_SYMBOL(tty_shutdown);
+
 /**
  *	release_one_tty		-	release tty structure memory
  *	@kref: kref of tty we are obliterating
@@ -1499,27 +1524,11 @@ static void release_one_tty(struct kref *kref)
 {
 	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
 	struct tty_driver *driver = tty->driver;
-	int devpts = tty->driver->flags & TTY_DRIVER_DEVPTS_MEM;
-	struct ktermios *tp;
-	int idx = tty->index;
-
-	if (!devpts)
-		tty->driver->ttys[idx] = NULL;
-
-	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
-		/* FIXME: Locking on ->termios array */
-		tp = tty->termios;
-		if (!devpts)
-			tty->driver->termios[idx] = NULL;
-		kfree(tp);
-
-		tp = tty->termios_locked;
-		if (!devpts)
-			tty->driver->termios_locked[idx] = NULL;
-		kfree(tp);
-	}
-
 
+	if (tty->ops->shutdown)
+		tty->ops->shutdown(tty);
+	else
+		tty_shutdown(tty);
 	tty->magic = 0;
 	/* FIXME: locking on tty->driver->refcount */
 	tty->driver->refcount--;
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index ec94521..37a45db 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2758,6 +2758,12 @@ static int con_open(struct tty_struct *tty, struct file *filp)
 		ret = vc_allocate(currcons);
 		if (ret == 0) {
 			struct vc_data *vc = vc_cons[currcons].d;
+
+			/* Still being freed */
+			if (vc->vc_tty) {
+				release_console_sem();
+				return -ERESTARTSYS;
+			}
 			tty->driver_data = vc;
 			vc->vc_tty = tty;
 
@@ -2787,25 +2793,18 @@ static int con_open(struct tty_struct *tty, struct file *filp)
  */
 static void con_close(struct tty_struct *tty, struct file *filp)
 {
-	mutex_lock(&tty_mutex);
-	acquire_console_sem();
-	if (tty && tty->count == 1) {
-		struct vc_data *vc = tty->driver_data;
+	/* Nothing to do - we defer to shutdown */
+}
 
-		if (vc)
-			vc->vc_tty = NULL;
-		tty->driver_data = NULL;
-		vcs_remove_sysfs(tty);
-		release_console_sem();
-		mutex_unlock(&tty_mutex);
-		/*
-		 * tty_mutex is released, but we still hold BKL, so there is
-		 * still exclusion against init_dev()
-		 */
-		return;
-	}
+static void con_shutdown(struct tty_struct *tty)
+{
+	struct vc_data *vc = tty->driver_data;
+	BUG_ON(vc == NULL);
+	acquire_console_sem();
+	vc->vc_tty = NULL;
+	vcs_remove_sysfs(tty);
 	release_console_sem();
-	mutex_unlock(&tty_mutex);
+	tty_shutdown(tty);
 }
 
 static int default_italic_color    = 2; // green (ASCII)
@@ -2930,6 +2929,7 @@ static const struct tty_operations con_ops = {
 	.throttle = con_throttle,
 	.unthrottle = con_unthrottle,
 	.resize = vt_resize,
+	.shutdown = con_shutdown
 };
 
 int __init vty_init(void)
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e00393a..6e39c70 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -354,7 +354,8 @@ extern void tty_throttle(struct tty_struct *tty);
 extern void tty_unthrottle(struct tty_struct *tty);
 extern int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
 						struct winsize *ws);
-
+extern void tty_shutdown(struct tty_struct *tty);
+extern void tty_free_termios(struct tty_struct *tty);
 extern int is_current_pgrp_orphaned(void);
 extern struct pid *tty_get_pgrp(struct tty_struct *tty);
 extern int is_ignored(int sig);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index ac6e58e..2322313 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -21,6 +21,11 @@
  *
  *	Required method.
  *
+ * void (*shutdown)(struct tty_struct * tty);
+ *
+ * 	This routine is called when a particular tty device is closed for
+ *	the last time freeing up the resources.
+ *
  * int (*write)(struct tty_struct * tty,
  * 		 const unsigned char *buf, int count);
  *
@@ -200,6 +205,7 @@ struct tty_driver;
 struct tty_operations {
 	int  (*open)(struct tty_struct * tty, struct file * filp);
 	void (*close)(struct tty_struct * tty, struct file * filp);
+	void (*shutdown)(struct tty_struct *tty);
 	int  (*write)(struct tty_struct * tty,
 		      const unsigned char *buf, int count);
 	int  (*put_char)(struct tty_struct *tty, unsigned char ch);

