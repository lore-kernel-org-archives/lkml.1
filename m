Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbXKSO6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbXKSO6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXKSO6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:58:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35928 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753432AbXKSO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:58:33 -0500
Date: Mon, 19 Nov 2007 14:56:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rocket: First pass at termios reporting
Message-ID: <20071119145614.70150186@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also removes a cflag comparison that caused some mode changes to get wrongly ignored


Signed-off-by: Alan Cox <alan@redhat.com>


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/char/rocket.c linux-2.6.24-rc2-mm1/drivers/char/rocket.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/char/rocket.c	2007-11-16 17:55:11.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/char/rocket.c	2007-11-16 18:20:23.000000000 +0000
@@ -715,11 +715,10 @@
 	unsigned rocketMode;
 	int bits, baud, divisor;
 	CHANNEL_t *cp;
+	struct ktermios *t = info->tty->termios;
 
-	if (!info->tty || !info->tty->termios)
-		return;
 	cp = &info->channel;
-	cflag = info->tty->termios->c_cflag;
+	cflag = t->c_cflag;
 
 	/* Byte size and parity */
 	if ((cflag & CSIZE) == CS8) {
@@ -754,10 +753,7 @@
 		baud = 9600;
 	divisor = ((rp_baud_base[info->board] + (baud >> 1)) / baud) - 1;
 	if ((divisor >= 8192 || divisor < 0) && old_termios) {
-		info->tty->termios->c_cflag &= ~CBAUD;
-		info->tty->termios->c_cflag |=
-		    (old_termios->c_cflag & CBAUD);
-		baud = tty_get_baud_rate(info->tty);
+		baud = tty_termios_baud_rate(old_termios);
 		if (!baud)
 			baud = 9600;
 		divisor = (rp_baud_base[info->board] / baud) - 1;
@@ -768,6 +764,9 @@
 	}
 	info->cps = baud / bits;
 	sSetBaud(cp, divisor);
+	
+	/* FIXME: Should really back compute a baud rate from the divisor */
+	tty_encode_baud_rate(info->tty, baud, baud);
 
 	if (cflag & CRTSCTS) {
 		info->intmask |= DELTA_CTS;
@@ -1202,15 +1201,14 @@
 
 	cflag = tty->termios->c_cflag;
 
-	if (cflag == old_termios->c_cflag)
-		return;
-
 	/*
 	 * This driver doesn't support CS5 or CS6
 	 */
 	if (((cflag & CSIZE) == CS5) || ((cflag & CSIZE) == CS6))
 		tty->termios->c_cflag =
 		    ((cflag & ~CSIZE) | (old_termios->c_cflag & CSIZE));
+	/* Or CMSPAR */
+	tty->termios->c_cflag &= ~CMSPAR;
 
 	configure_r_port(info, old_termios);
 
