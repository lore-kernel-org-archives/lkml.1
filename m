Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYCJWJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYCJWJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYCJWJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:09:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47348 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756791AbYCJWJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:09:25 -0400
Date: Mon, 10 Mar 2008 21:56:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty_ioctl: Soft carrier handling
Message-ID: <20080310215613.43c7acb0@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First cut at moving the soft carrier handling knowledge entirely into the
core code. One or two drivers still needed to snoop these functions to
track CLOCAL internally. Instead make TIOCSSOFTCAR generate the same
driver calls as other termios ioctls changing the clocal flag. This
allows us to remove any driver knowledge and special casing. Also while
we are at it we can fix the error handling.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c linux-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c	2008-03-10 12:57:53.000000000 +0000
+++ linux-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c	2008-03-10 13:27:09.000000000 +0000
@@ -753,6 +756,32 @@
 }
 
 /**
+ *	tty_change_softcar	-	carrier change ioctl helper
+ *	@tty: tty to update
+ *	@arg: enable/disable CLOCAL
+ *
+ *	Perform a change to the CLOCAL state and call into the driver
+ *	layer to make it visible. All done with the termios mutex
+ */
+ 
+static int tty_change_softcar(struct tty_struct *tty, int arg)
+{
+	int ret = 0;
+	int bit = arg ? CLOCAL : 0;
+	struct ktermios old = *tty->termios;
+	
+	mutex_lock(&tty->termios_mutex);
+	tty->termios->c_cflag &= ~CLOCAL;
+	tty->termios->c_cflag |= bit;
+	if (tty->driver->set_termios)
+		tty->driver->set_termios(tty, &old);
+	if ((tty->termios->c_cflag & CLOCAL) != bit)
+		ret = -EINVAL;	
+	mutex_unlock(&tty->termios_mutex);
+	return ret;
+}
+
+/**
  *	tty_mode_ioctl		-	mode related ioctls
  *	@tty: tty for the ioctl
  *	@file: file pointer for the tty
@@ -862,12 +891,7 @@
 	case TIOCSSOFTCAR:
 		if (get_user(arg, (unsigned int __user *) arg))
 			return -EFAULT;
-		mutex_lock(&tty->termios_mutex);
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			 (arg ? CLOCAL : 0));
-		mutex_unlock(&tty->termios_mutex);
-		return 0;
+		return tty_change_softcar(tty, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
