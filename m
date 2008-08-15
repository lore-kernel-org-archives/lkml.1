Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbYHOJ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbYHOJ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 05:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYHOJ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 05:56:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44190 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751635AbYHOJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 05:56:51 -0400
Date: Fri, 15 Aug 2008 10:39:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc3
Message-ID: <20080815103938.467e2521@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808131522330.3462@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org>
	<20080813110316.1d9af655@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808131522330.3462@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 15:24:15 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 13 Aug 2008, Alan Cox wrote:
> >
> > (If it looks ok let me know .. it'll also apply for testing versus -rc but
> >  wants a final polish in that form)
> 
> Looks ok. It's biggish, but looks pretty straightforward, and a fair chunk 
> of it seems to be the comment changes/additions. So send some final 
> version over when the polish is done..

tty: remove resize window special case

From: Alan Cox <alan@redhat.com>

This moves it to being a tty operation. That removes special cases and now
also means that resize can be picked up by um and other non vt consoles
which may have a resize operation.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c      |   72 +++++++++++++++++++++------------------
 drivers/char/vt.c          |   82 +++++++++++++++++++++++++++++++++-----------
 drivers/char/vt_ioctl.c    |    4 ++
 include/linux/tty.h        |    2 +
 include/linux/tty_driver.h |   14 ++++++++
 include/linux/vt_kern.h    |    1 -
 6 files changed, 121 insertions(+), 54 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index b499a38..ddf5562 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2496,45 +2496,25 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
 }
 
 /**
- *	tiocswinsz		-	implement window size set ioctl
- *	@tty; tty
- *	@arg: user buffer for result
+ *	tty_do_resize		-	resize event
+ *	@tty: tty being resized
+ *	@real_tty: real tty (if using a pty/tty pair)
+ *	@rows: rows (character)
+ *	@cols: cols (character)
  *
- *	Copies the user idea of the window size to the kernel. Traditionally
- *	this is just advisory information but for the Linux console it
- *	actually has driver level meaning and triggers a VC resize.
- *
- *	Locking:
- *		Called function use the console_sem is used to ensure we do
- *	not try and resize the console twice at once.
- *		The tty->termios_mutex is used to ensure we don't double
- *	resize and get confused. Lock order - tty->termios_mutex before
- *	console sem
+ *	Update the termios variables and send the neccessary signals to
+ *	peform a terminal resize correctly
  */
 
-static int tiocswinsz(struct tty_struct *tty, struct tty_struct *real_tty,
-	struct winsize __user *arg)
+int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
+					struct winsize *ws)
 {
-	struct winsize tmp_ws;
 	struct pid *pgrp, *rpgrp;
 	unsigned long flags;
 
-	if (copy_from_user(&tmp_ws, arg, sizeof(*arg)))
-		return -EFAULT;
-
 	mutex_lock(&tty->termios_mutex);
-	if (!memcmp(&tmp_ws, &tty->winsize, sizeof(*arg)))
+	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
-
-#ifdef CONFIG_VT
-	if (tty->driver->type == TTY_DRIVER_TYPE_CONSOLE) {
-		if (vc_lock_resize(tty->driver_data, tmp_ws.ws_col,
-					tmp_ws.ws_row)) {
-			mutex_unlock(&tty->termios_mutex);
-			return -ENXIO;
-		}
-	}
-#endif
 	/* Get the PID values and reference them so we can
 	   avoid holding the tty ctrl lock while sending signals */
 	spin_lock_irqsave(&tty->ctrl_lock, flags);
@@ -2550,14 +2530,42 @@ static int tiocswinsz(struct tty_struct *tty, struct tty_struct *real_tty,
 	put_pid(pgrp);
 	put_pid(rpgrp);
 
-	tty->winsize = tmp_ws;
-	real_tty->winsize = tmp_ws;
+	tty->winsize = *ws;
+	real_tty->winsize = *ws;
 done:
 	mutex_unlock(&tty->termios_mutex);
 	return 0;
 }
 
 /**
+ *	tiocswinsz		-	implement window size set ioctl
+ *	@tty; tty
+ *	@arg: user buffer for result
+ *
+ *	Copies the user idea of the window size to the kernel. Traditionally
+ *	this is just advisory information but for the Linux console it
+ *	actually has driver level meaning and triggers a VC resize.
+ *
+ *	Locking:
+ *		Driver dependant. The default do_resize method takes the
+ *	tty termios mutex and ctrl_lock. The console takes its own lock
+ *	then calls into the default method.
+ */
+
+static int tiocswinsz(struct tty_struct *tty, struct tty_struct *real_tty,
+	struct winsize __user *arg)
+{
+	struct winsize tmp_ws;
+	if (copy_from_user(&tmp_ws, arg, sizeof(*arg)))
+		return -EFAULT;
+
+	if (tty->ops->resize)
+		return tty->ops->resize(tty, real_tty, &tmp_ws);
+	else
+		return tty_do_resize(tty, real_tty, &tmp_ws);
+}
+
+/**
  *	tioccons	-	allow admin to move logical console
  *	@file: the file to become console
  *
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index c09170c..05ca1c5 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -803,7 +803,25 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
  */
 #define VC_RESIZE_MAXCOL (32767)
 #define VC_RESIZE_MAXROW (32767)
-int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int lines)
+
+/**
+ *	vc_do_resize	-	resizing method for the tty
+ *	@tty: tty being resized
+ *	@real_tty: real tty (different to tty if a pty/tty pair)
+ *	@vc: virtual console private data
+ *	@cols: columns
+ *	@lines: lines
+ *
+ *	Resize a virtual console, clipping according to the actual constraints.
+ *	If the caller passes a tty structure then update the termios winsize
+ *	information and perform any neccessary signal handling.
+ *
+ *	Caller must hold the console semaphore. Takes the termios mutex and
+ *	ctrl_lock of the tty IFF a tty is passed.
+ */
+
+static int vc_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
+		struct vc_data *vc, unsigned int cols, unsigned int lines)
 {
 	unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
 	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
@@ -907,24 +925,15 @@ int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int lines)
 	gotoxy(vc, vc->vc_x, vc->vc_y);
 	save_cur(vc);
 
-	if (vc->vc_tty) {
-		struct winsize ws, *cws = &vc->vc_tty->winsize;
-		struct pid *pgrp = NULL;
-
+	if (tty) {
+		/* Rewrite the requested winsize data with the actual
+		   resulting sizes */
+		struct winsize ws;
 		memset(&ws, 0, sizeof(ws));
 		ws.ws_row = vc->vc_rows;
 		ws.ws_col = vc->vc_cols;
 		ws.ws_ypixel = vc->vc_scan_lines;
-
-		spin_lock_irq(&vc->vc_tty->ctrl_lock);
-		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col))
-			pgrp = get_pid(vc->vc_tty->pgrp);
-		spin_unlock_irq(&vc->vc_tty->ctrl_lock);
-		if (pgrp) {
-			kill_pgrp(vc->vc_tty->pgrp, SIGWINCH, 1);
-			put_pid(pgrp);
-		}
-		*cws = ws;
+		tty_do_resize(tty, real_tty, &ws);
 	}
 
 	if (CON_IS_VISIBLE(vc))
@@ -932,14 +941,47 @@ int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int lines)
 	return err;
 }
 
-int vc_lock_resize(struct vc_data *vc, unsigned int cols, unsigned int lines)
+/**
+ *	vc_resize		-	resize a VT
+ *	@vc: virtual console
+ *	@cols: columns
+ *	@rows: rows
+ *
+ *	Resize a virtual console as seen from the console end of things. We
+ *	use the common vc_do_resize methods to update the structures. The
+ *	caller must hold the console sem to protect console internals and
+ *	vc->vc_tty
+ */
+
+int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int rows)
+{
+	return vc_do_resize(vc->vc_tty, vc->vc_tty, vc, cols, rows);
+}
+
+/**
+ *	vt_resize		-	resize a VT
+ *	@tty: tty to resize
+ *	@real_tty: tty if a pty/tty pair
+ *	@ws: winsize attributes
+ *
+ *	Resize a virtual terminal. This is called by the tty layer as we
+ *	register our own handler for resizing. The mutual helper does all
+ *	the actual work.
+ *
+ *	Takes the console sem and the called methods then take the tty
+ *	termios_mutex and the tty ctrl_lock in that order.
+ */
+
+int vt_resize(struct tty_struct *tty, struct tty_struct *real_tty,
+	struct winsize *ws)
 {
-	int rc;
+	struct vc_data *vc = tty->driver_data;
+	int ret;
 
 	acquire_console_sem();
-	rc = vc_resize(vc, cols, lines);
+	ret = vc_do_resize(tty, real_tty, vc, ws->ws_col, ws->ws_row);
 	release_console_sem();
-	return rc;
+	return ret;
 }
 
 void vc_deallocate(unsigned int currcons)
@@ -2905,6 +2947,7 @@ static const struct tty_operations con_ops = {
 	.start = con_start,
 	.throttle = con_throttle,
 	.unthrottle = con_unthrottle,
+	.resize = vt_resize,
 };
 
 int __init vty_init(void)
@@ -4059,7 +4102,6 @@ EXPORT_SYMBOL(default_blu);
 EXPORT_SYMBOL(update_region);
 EXPORT_SYMBOL(redraw_screen);
 EXPORT_SYMBOL(vc_resize);
-EXPORT_SYMBOL(vc_lock_resize);
 EXPORT_SYMBOL(fg_console);
 EXPORT_SYMBOL(console_blank_hook);
 EXPORT_SYMBOL(console_blanked);
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 86f8421..8944ce5 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -949,14 +949,16 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		    get_user(cc, &vtsizes->v_cols))
 			ret = -EFAULT;
 		else {
+			acquire_console_sem();
 			for (i = 0; i < MAX_NR_CONSOLES; i++) {
 				vc = vc_cons[i].d;
 
 				if (vc) {
 					vc->vc_resize_user = 1;
-					vc_lock_resize(vc_cons[i].d, cc, ll);
+					vc_resize(vc_cons[i].d, cc, ll);
 				}
 			}
+			release_console_sem();
 		}
 		break;
 	}
diff --git a/include/linux/tty.h b/include/linux/tty.h
index e3579cb..0cbec74 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -331,6 +331,8 @@ extern int tty_write_room(struct tty_struct *tty);
 extern void tty_driver_flush_buffer(struct tty_struct *tty);
 extern void tty_throttle(struct tty_struct *tty);
 extern void tty_unthrottle(struct tty_struct *tty);
+extern int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
+						struct winsize *ws);
 
 extern int is_current_pgrp_orphaned(void);
 extern struct pid *tty_get_pgrp(struct tty_struct *tty);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index e1065ac..16d2794 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -168,6 +168,18 @@
  *
  *	Optional: If not provided then the write method is called under
  *	the atomic write lock to keep it serialized with the ldisc.
+ *
+ * int (*resize)(struct tty_struct *tty, struct tty_struct *real_tty,
+ *				unsigned int rows, unsigned int cols);
+ *
+ *	Called when a termios request is issued which changes the
+ *	requested terminal geometry.
+ *
+ *	Optional: the default action is to update the termios structure
+ *	without error. This is usually the correct behaviour. Drivers should
+ *	not force errors here if they are not resizable objects (eg a serial
+ *	line). See tty_do_resize() if you need to wrap the standard method
+ *	in your own logic - the usual case.
  */
 
 #include <linux/fs.h>
@@ -206,6 +218,8 @@ struct tty_operations {
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
+	int (*resize)(struct tty_struct *tty, struct tty_struct *real_tty,
+				struct winsize *ws);
 #ifdef CONFIG_CONSOLE_POLL
 	int (*poll_init)(struct tty_driver *driver, int line, char *options);
 	int (*poll_get_char)(struct tty_driver *driver, int line);
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 1c78d56..1cbd0a7 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -35,7 +35,6 @@ extern int fg_console, last_console, want_console;
 int vc_allocate(unsigned int console);
 int vc_cons_allocated(unsigned int console);
 int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int lines);
-int vc_lock_resize(struct vc_data *vc, unsigned int cols, unsigned int lines);
 void vc_deallocate(unsigned int console);
 void reset_palette(struct vc_data *vc);
 void do_blank_screen(int entering_gfx);
