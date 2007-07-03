Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbXGCObd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbXGCObd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXGCOb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:31:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45978 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753721AbXGCObZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:31:25 -0400
Date: Tue, 3 Jul 2007 15:37:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] pl2303: remove bogus checks and fix speed support to use
 tty_get_baud_rate()
Message-ID: <20070703153733.0f39638b@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/pl2303.c linux-2.6.22-rc6-mm1/drivers/usb/serial/pl2303.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/usb/serial/pl2303.c	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/usb/serial/pl2303.c	2007-07-02 21:25:13.000000000 +0100
@@ -484,15 +484,6 @@
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	cflag = port->tty->termios->c_cflag;
-	/* check that they really want us to change something */
-	if (old_termios) {
-		if ((cflag == old_termios->c_cflag) &&
-		    (RELEVANT_IFLAG(port->tty->termios->c_iflag) ==
-		     RELEVANT_IFLAG(old_termios->c_iflag))) {
-			dbg("%s - nothing to change...", __FUNCTION__);
-			return;
-		}
-	}
 
 	buf = kzalloc(7, GFP_KERNEL);
 	if (!buf) {
@@ -517,29 +508,7 @@
 		dbg("%s - data bits = %d", __FUNCTION__, buf[6]);
 	}
 
-	baud = 0;
-	switch (cflag & CBAUD) {
-		case B0:	baud = 0;	break;
-		case B75:	baud = 75;	break;
-		case B150:	baud = 150;	break;
-		case B300:	baud = 300;	break;
-		case B600:	baud = 600;	break;
-		case B1200:	baud = 1200;	break;
-		case B1800:	baud = 1800;	break;
-		case B2400:	baud = 2400;	break;
-		case B4800:	baud = 4800;	break;
-		case B9600:	baud = 9600;	break;
-		case B19200:	baud = 19200;	break;
-		case B38400:	baud = 38400;	break;
-		case B57600:	baud = 57600;	break;
-		case B115200:	baud = 115200;	break;
-		case B230400:	baud = 230400;	break;
-		case B460800:	baud = 460800;	break;
-		default:
-			dev_err(&port->dev, "pl2303 driver does not support"
-				" the baudrate requested (fix it)\n");
-			break;
-	}
+	baud = tty_get_baud_rate(port->tty);;
 	dbg("%s - baud = %d", __FUNCTION__, baud);
 	if (baud) {
 		buf[0] = baud & 0xff;
