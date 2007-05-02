Return-Path: <linux-kernel-owner+w=401wt.eu-S1766960AbXEBRwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766960AbXEBRwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766970AbXEBRwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:52:42 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:38865
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766960AbXEBRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:52:40 -0400
Subject: [PATCH] tty add compat_ioctl method
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200704270008.58811.arnd@arndb.de>
References: <1177620717.5060.11.camel@amdx2.microgate.com>
	 <200704262337.56240.arnd@arndb.de> <46312AEE.1000302@microgate.com>
	 <200704270008.58811.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 02 May 2007 12:52:01 -0500
Message-Id: <1178128321.9430.14.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add compat_ioctl method for tty code to allow processing
of 32 bit ioctl calls on 64 bit systems by tty core,
tty drivers, and line disciplines.

Based on patch by Arnd Bergmann:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0511.0/1732.html

This patch does not remove tty ioctl entries in compat_ioctl.[ch]
That will be implemented in a separate patch.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
CC: Arnd Bergmann <arnd@arndb.de>

--- a/drivers/char/n_tty.c	2007-04-30 15:13:19.000000000 -0500
+++ b/drivers/char/n_tty.c	2007-04-30 15:17:28.000000000 -0500
@@ -1545,21 +1545,18 @@ static unsigned int normal_poll(struct t
 }
 
 struct tty_ldisc tty_ldisc_N_TTY = {
-	TTY_LDISC_MAGIC,	/* magic */
-	"n_tty",		/* name */
-	0,			/* num */
-	0,			/* flags */
-	n_tty_open,		/* open */
-	n_tty_close,		/* close */
-	n_tty_flush_buffer,	/* flush_buffer */
-	n_tty_chars_in_buffer,	/* chars_in_buffer */
-	read_chan,		/* read */
-	write_chan,		/* write */
-	n_tty_ioctl,		/* ioctl */
-	n_tty_set_termios,	/* set_termios */
-	normal_poll,		/* poll */
-	NULL,			/* hangup */
-	n_tty_receive_buf,	/* receive_buf */
-	n_tty_write_wakeup	/* write_wakeup */
+	.magic           = TTY_LDISC_MAGIC,
+	.name            = "n_tty",
+	.open            = n_tty_open,
+	.close           = n_tty_close,
+	.flush_buffer    = n_tty_flush_buffer,
+	.chars_in_buffer = n_tty_chars_in_buffer,
+	.read            = read_chan,
+	.write           = write_chan,
+	.ioctl           = n_tty_ioctl,
+	.set_termios     = n_tty_set_termios,
+	.poll            = normal_poll,
+	.receive_buf     = n_tty_receive_buf,
+	.write_wakeup    = n_tty_write_wakeup
 };
 
--- a/include/linux/tty_driver.h	2006-11-29 15:57:37.000000000 -0600
+++ b/include/linux/tty_driver.h	2007-04-30 14:05:02.000000000 -0500
@@ -132,6 +132,10 @@ struct tty_operations {
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	int  (*ioctl)(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
+			     unsigned int cmd, unsigned long arg);
+#endif
 	void (*set_termios)(struct tty_struct *tty, struct termios * old);
 	void (*throttle)(struct tty_struct * tty);
 	void (*unthrottle)(struct tty_struct * tty);
@@ -193,6 +197,10 @@ struct tty_driver {
 	int  (*chars_in_buffer)(struct tty_struct *tty);
 	int  (*ioctl)(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
+			     unsigned int cmd, unsigned long arg);
+#endif
 	void (*set_termios)(struct tty_struct *tty, struct termios * old);
 	void (*throttle)(struct tty_struct * tty);
 	void (*unthrottle)(struct tty_struct * tty);
--- a/drivers/char/tty_io.c	2006-11-29 15:57:37.000000000 -0600
+++ b/drivers/char/tty_io.c	2007-04-30 14:51:01.000000000 -0500
@@ -151,6 +151,9 @@ static int tty_open(struct inode *, stru
 static int tty_release(struct inode *, struct file *);
 int tty_ioctl(struct inode * inode, struct file * file,
 	      unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg);
+#endif
 static int tty_fasync(int fd, struct file * filp, int on);
 static void release_mem(struct tty_struct *tty, int idx);
 
@@ -1153,8 +1156,8 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static int hung_up_tty_ioctl(struct inode * inode, struct file * file,
-			     unsigned int cmd, unsigned long arg)
+static long hung_up_tty_ioctl(struct file * file,
+			      unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1165,6 +1168,9 @@ static const struct file_operations tty_
 	.write		= tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= tty_compat_ioctl,
+#endif
 	.open		= tty_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1177,6 +1183,9 @@ static const struct file_operations ptmx
 	.write		= tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= tty_compat_ioctl,
+#endif
 	.open		= ptmx_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1189,6 +1198,9 @@ static const struct file_operations cons
 	.write		= redirected_tty_write,
 	.poll		= tty_poll,
 	.ioctl		= tty_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= tty_compat_ioctl,
+#endif
 	.open		= tty_open,
 	.release	= tty_release,
 	.fasync		= tty_fasync,
@@ -1199,7 +1211,10 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.ioctl		= hung_up_tty_ioctl,
+	.unlocked_ioctl = hung_up_tty_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= hung_up_tty_ioctl,
+#endif
 	.release	= tty_release,
 };
 
@@ -3284,6 +3299,32 @@ int tty_ioctl(struct inode * inode, stru
 	return retval;
 }
 
+#ifdef CONFIG_COMPAT
+long tty_compat_ioctl(struct file * file, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct tty_struct *tty;
+	struct tty_ldisc *ld;
+	int retval = -ENOIOCTLCMD;
+
+	tty = (struct tty_struct *)file->private_data;
+	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
+		return -EINVAL;
+
+	if (tty->driver->compat_ioctl) {
+		retval = (tty->driver->compat_ioctl)(tty, file, cmd, arg);
+		if (retval != -ENOIOCTLCMD)
+			return retval;
+	}
+
+	ld = tty_ldisc_ref_wait(tty);
+	if (ld->compat_ioctl)
+		retval = ld->compat_ioctl(tty, file, cmd, arg);
+	tty_ldisc_deref(ld);
+
+	return retval;
+}
+#endif
 
 /*
  * This implements the "Secure Attention Key" ---  the idea is to
@@ -3691,6 +3732,9 @@ void tty_set_operations(struct tty_drive
 	driver->write_room = op->write_room;
 	driver->chars_in_buffer = op->chars_in_buffer;
 	driver->ioctl = op->ioctl;
+#ifdef CONFIG_COMPAT
+	driver->compat_ioctl = op->compat_ioctl;
+#endif
 	driver->set_termios = op->set_termios;
 	driver->throttle = op->throttle;
 	driver->unthrottle = op->unthrottle;
--- a/include/linux/tty_ldisc.h	2006-11-29 15:57:37.000000000 -0600
+++ b/include/linux/tty_ldisc.h	2007-04-30 14:06:19.000000000 -0500
@@ -59,6 +59,11 @@
  * 	low-level driver can "grab" an ioctl request before the line
  * 	discpline has a chance to see it.
  * 
+ * long	(*compat_ioctl)(struct tty_struct * tty, struct file * file,
+ * 		        unsigned int cmd, unsigned long arg);
+ *
+ *      Process ioctl calls from 32-bit process on 64-bit system
+ *
  * void	(*set_termios)(struct tty_struct *tty, struct termios * old);
  *
  * 	This function notifies the line discpline that a change has
@@ -118,6 +123,10 @@ struct tty_ldisc {
 			 const unsigned char * buf, size_t nr);	
 	int	(*ioctl)(struct tty_struct * tty, struct file * file,
 			 unsigned int cmd, unsigned long arg);
+#ifdef CONFIG_COMPAT
+	long	(*compat_ioctl)(struct tty_struct * tty, struct file * file,
+				unsigned int cmd, unsigned long arg);
+#endif
 	void	(*set_termios)(struct tty_struct *tty, struct termios * old);
 	unsigned int (*poll)(struct tty_struct *, struct file *,
 			     struct poll_table_struct *);




