Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbXKBPcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbXKBPcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbXKBPcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:32:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42542 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753565AbXKBPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:32:15 -0400
Date: Fri, 2 Nov 2007 15:33:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3]: tty - fix network driver interactions with TCGET/SET
 calls
Message-ID: <20071102153329.1a236477@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Miller noted various cases where line disciplines for things like
ppp go poking around in termios themselves in ways that broke with the
new termios code. Rather than have them all learning about termios
internals provide proper methods for this

- tty_mode_ioctl()

	This handles all the terminal mode handling for speed/carrier etc
and none of the methods are ldisc dependant so they can be called by any
user

- tty_perform_flush()

	This extracts the flush functionality and enables pppd the ppp
layer to share it cleanly.


The existing n_tty_ioctl code is refactored in this patch to provide the
new functions and to call them itself appropriately. This patch has no
(intended) behaviour changes and simply prepares for the other fixes.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/include/linux/tty.h linux-2.6.24-rc1/include/linux/tty.h
--- linux.vanilla-2.6.24-rc1/include/linux/tty.h	2007-11-01 11:42:08.000000000 +0000
+++ linux-2.6.24-rc1/include/linux/tty.h	2007-11-02 12:18:21.000000000 +0000
@@ -332,7 +332,9 @@
 
 extern int tty_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		     unsigned long arg);
-
+extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg);
+extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
 extern dev_t tty_devnum(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc1/drivers/char/tty_ioctl.c linux-2.6.24-rc1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.24-rc1/drivers/char/tty_ioctl.c	2007-11-01 11:41:54.000000000 +0000
+++ linux-2.6.24-rc1/drivers/char/tty_ioctl.c	2007-11-02 12:42:48.000000000 +0000
@@ -730,13 +730,23 @@
 	return 0;
 }
 
-int n_tty_ioctl(struct tty_struct * tty, struct file * file,
-		       unsigned int cmd, unsigned long arg)
+/**
+ *	tty_mode_ioctl		-	mode related ioctls
+ *	@tty: tty for the ioctl
+ *	@file: file pointer for the tty
+ *	@cmd: command
+ *	@arg: ioctl argument
+ *
+ *	Perform non line discipline specific mode control ioctls. This
+ *	is designed to be called by line disciplines to ensure they provide
+ *	consistent mode setting.
+ */
+
+int tty_mode_ioctl(struct tty_struct * tty, struct file *file,
+			unsigned int cmd, unsigned long arg)
 {
 	struct tty_struct * real_tty;
 	void __user *p = (void __user *)arg;
-	int retval;
-	struct tty_ldisc *ld;
 
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
@@ -799,6 +809,93 @@
 			return set_termios(real_tty, p, TERMIOS_WAIT | TERMIOS_TERMIO);
 		case TCSETA:
 			return set_termios(real_tty, p, TERMIOS_TERMIO);
+#ifndef TCGETS2
+		case TIOCGLCKTRMIOS:
+			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
+				return -EFAULT;
+			return 0;
+
+		case TIOCSLCKTRMIOS:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+			if (user_termios_to_kernel_termios(real_tty->termios_locked, (struct termios __user *) arg))
+				return -EFAULT;
+			return 0;
+#else
+		case TIOCGLCKTRMIOS:
+			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
+				return -EFAULT;
+			return 0;
+
+		case TIOCSLCKTRMIOS:
+			if (!capable(CAP_SYS_ADMIN))
+				return -EPERM;
+			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
+				return -EFAULT;
+			return 0;
+#endif
+		case TIOCGSOFTCAR:
+			return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)arg);
+		case TIOCSSOFTCAR:
+			if (get_user(arg, (unsigned int __user *) arg))
+				return -EFAULT;
+			mutex_lock(&tty->termios_mutex);
+			tty->termios->c_cflag =
+				((tty->termios->c_cflag & ~CLOCAL) |
+				 (arg ? CLOCAL : 0));
+			mutex_unlock(&tty->termios_mutex);
+			return 0;
+		default:
+			return -ENOIOCTLCMD;
+	}	
+}
+
+EXPORT_SYMBOL_GPL(tty_mode_ioctl);
+
+int tty_perform_flush(struct tty_struct *tty, unsigned long arg)
+{
+	struct tty_ldisc *ld;
+	int retval = tty_check_change(tty);
+	if (retval)
+		return retval;
+
+	ld = tty_ldisc_ref(tty);
+	switch (arg) {
+	case TCIFLUSH:
+		if (ld && ld->flush_buffer)
+			ld->flush_buffer(tty);
+		break;
+	case TCIOFLUSH:
+		if (ld && ld->flush_buffer)
+			ld->flush_buffer(tty);
+		/* fall through */
+	case TCOFLUSH:
+		if (tty->driver->flush_buffer)
+			tty->driver->flush_buffer(tty);
+		break;
+	default:
+		tty_ldisc_deref(ld);
+		return -EINVAL;
+	}
+	tty_ldisc_deref(ld);
+	return 0;
+}
+
+EXPORT_SYMBOL_GPL(tty_perform_flush);
+
+int n_tty_ioctl(struct tty_struct * tty, struct file * file,
+		       unsigned int cmd, unsigned long arg)
+{
+	struct tty_struct * real_tty;
+	int retval;
+
+	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
+	    tty->driver->subtype == PTY_TYPE_MASTER)
+		real_tty = tty->link;
+	else
+		real_tty = tty;
+
+	switch (cmd) {
 		case TCXONC:
 			retval = tty_check_change(tty);
 			if (retval)
@@ -829,30 +926,7 @@
 			}
 			return 0;
 		case TCFLSH:
-			retval = tty_check_change(tty);
-			if (retval)
-				return retval;
-				
-			ld = tty_ldisc_ref(tty);
-			switch (arg) {
-			case TCIFLUSH:
-				if (ld && ld->flush_buffer)
-					ld->flush_buffer(tty);
-				break;
-			case TCIOFLUSH:
-				if (ld && ld->flush_buffer)
-					ld->flush_buffer(tty);
-				/* fall through */
-			case TCOFLUSH:
-				if (tty->driver->flush_buffer)
-					tty->driver->flush_buffer(tty);
-				break;
-			default:
-				tty_ldisc_deref(ld);
-				return -EINVAL;
-			}
-			tty_ldisc_deref(ld);
-			return 0;
+			return tty_perform_flush(tty, arg);
 		case TIOCOUTQ:
 			return put_user(tty->driver->chars_in_buffer ?
 					tty->driver->chars_in_buffer(tty) : 0,
@@ -862,32 +936,6 @@
 			if (L_ICANON(tty))
 				retval = inq_canon(tty);
 			return put_user(retval, (unsigned int __user *) arg);
-#ifndef TCGETS2
-		case TIOCGLCKTRMIOS:
-			if (kernel_termios_to_user_termios((struct termios __user *)arg, real_tty->termios_locked))
-				return -EFAULT;
-			return 0;
-
-		case TIOCSLCKTRMIOS:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			if (user_termios_to_kernel_termios(real_tty->termios_locked, (struct termios __user *) arg))
-				return -EFAULT;
-			return 0;
-#else
-		case TIOCGLCKTRMIOS:
-			if (kernel_termios_to_user_termios_1((struct termios __user *)arg, real_tty->termios_locked))
-				return -EFAULT;
-			return 0;
-
-		case TIOCSLCKTRMIOS:
-			if (!capable(CAP_SYS_ADMIN))
-				return -EPERM;
-			if (user_termios_to_kernel_termios_1(real_tty->termios_locked, (struct termios __user *) arg))
-				return -EFAULT;
-			return 0;
-#endif
-
 		case TIOCPKT:
 		{
 			int pktmode;
@@ -906,19 +954,9 @@
 				tty->packet = 0;
 			return 0;
 		}
-		case TIOCGSOFTCAR:
-			return put_user(C_CLOCAL(tty) ? 1 : 0, (int __user *)arg);
-		case TIOCSSOFTCAR:
-			if (get_user(arg, (unsigned int __user *) arg))
-				return -EFAULT;
-			mutex_lock(&tty->termios_mutex);
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (arg ? CLOCAL : 0));
-			mutex_unlock(&tty->termios_mutex);
-			return 0;
 		default:
-			return -ENOIOCTLCMD;
+			/* Try the mode commands */
+			return tty_mode_ioctl(tty, file, cmd, arg);
 		}
 }
 
