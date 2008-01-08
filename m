Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYAHO6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYAHO6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbYAHO56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:57:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39613 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752399AbYAHO56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:57:58 -0500
Date: Tue, 8 Jan 2008 14:55:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: [PATCH] pl2303: Fix mode switching regression
Message-ID: <20080108145551.41bd3064@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning out all the incorrect 'no change made' checks for termios
settings showed up a problem with the PL2303. The hardware here seems to
lose sync and bits if you tell it to make no changes. This shows up with
a real world application.

To fix this the driver check for meaningful hardware changes is restored
but doing the tests correctly and as a tty layer function so it doesn't
get duplicated wrongly everywhere if other drivers turn out to need it.

Signed-off-by: Alan Cox <alan@redhat.com>
Tested-by: Mirko Parthey <mirko.parthey@informatik.tu-chemnitz.de>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/usb/serial/pl2303.c linux-2.6.24-rc6-mm1/drivers/usb/serial/pl2303.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/usb/serial/pl2303.c	2008-01-02 16:04:24.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/usb/serial/pl2303.c	2008-01-07 11:47:59.000000000 +0000
@@ -531,6 +531,13 @@
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* The PL2303 is reported to lose bytes if you change
+	   serial settings even to the same values as before. Thus
+	   we actually need to filter in this specific case */
+
+	if (!tty_termios_hw_change(port->tty->termios, old_termios))
+		return;
+
 	cflag = port->tty->termios->c_cflag;
 
 	buf = kzalloc(7, GFP_KERNEL);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/char/tty_ioctl.c linux-2.6.24-rc6-mm1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.24-rc6-mm1/drivers/char/tty_ioctl.c	2008-01-02 16:04:19.000000000 +0000
+++ linux-2.6.24-rc6-mm1/drivers/char/tty_ioctl.c	2008-01-07 11:43:39.000000000 +0000
@@ -360,6 +360,25 @@
 EXPORT_SYMBOL(tty_termios_copy_hw);
 
 /**
+ *	tty_termios_hw_change	-	check for setting change
+ *	@a: termios
+ *	@b: termios to compare
+ *
+ *	Check if any of the bits that affect a dumb device have changed
+ *	between the two termios structures, or a speed change is needed.
+ */
+
+int tty_termios_hw_change(struct ktermios *a, struct ktermios *b)
+{
+	if (a->c_ispeed != b->c_ispeed || a->c_ospeed != b->c_ospeed)
+		return 1;
+	if ((a->c_cflag ^ b->c_cflag) & ~(HUPCL | CREAD | CLOCAL))
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(tty_termios_hw_change);
+ 
+/**
  *	change_termios		-	update termios values
  *	@tty: tty to update
  *	@new_termios: desired new value
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/include/linux/tty.h linux-2.6.24-rc6-mm1/include/linux/tty.h
--- linux.vanilla-2.6.24-rc6-mm1/include/linux/tty.h	2008-01-02 16:04:25.000000000 +0000
+++ linux-2.6.24-rc6-mm1/include/linux/tty.h	2008-01-07 11:43:19.000000000 +0000
@@ -312,6 +312,7 @@
 extern void tty_termios_encode_baud_rate(struct ktermios *termios, speed_t ibaud, speed_t obaud);
 extern void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud);
 extern void tty_termios_copy_hw(struct ktermios *new, struct ktermios *old);
+extern int tty_termios_hw_change(struct ktermios *a, struct ktermios *b);
 
 extern struct tty_ldisc *tty_ldisc_ref(struct tty_struct *);
 extern void tty_ldisc_deref(struct tty_ldisc *);
