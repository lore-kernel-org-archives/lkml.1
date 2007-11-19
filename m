Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbXKSPWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbXKSPWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbXKSPWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:22:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53321 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753622AbXKSPWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:22:23 -0500
Date: Mon, 19 Nov 2007 15:20:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] keyspan_pda: Clean up speed handling
Message-ID: <20071119152031.688c7dc9@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/usb/serial/keyspan_pda.c linux-2.6.24-rc2-mm1/drivers/usb/serial/keyspan_pda.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/usb/serial/keyspan_pda.c	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/usb/serial/keyspan_pda.c	2007-11-16 18:37:19.000000000 +0000
@@ -303,7 +303,7 @@
 }
 
 
-static int keyspan_pda_setbaud (struct usb_serial *serial, int baud)
+static speed_t keyspan_pda_setbaud (struct usb_serial *serial, speed_t baud)
 {
 	int rc;
 	int bindex;
@@ -319,7 +319,9 @@
 		case 38400: bindex = 7; break;
 		case 57600: bindex = 8; break;
 		case 115200: bindex = 9; break;
-		default: return -EINVAL;
+		default: 
+			bindex = 5;	/* Default to 9600 */
+			baud = 9600;
 	}
 
 	/* rather than figure out how to sleep while waiting for this
@@ -334,7 +336,9 @@
 			     NULL, /* &data */
 			     0, /* size */
 			     2000); /* timeout */
-	return(rc);
+	if (rc < 0)
+		return 0;			     
+	return baud;
 }
 
 
@@ -366,7 +370,7 @@
 				     struct ktermios *old_termios)
 {
 	struct usb_serial *serial = port->serial;
-	unsigned int cflag = port->tty->termios->c_cflag;
+	speed_t speed;
 
 	/* cflag specifies lots of stuff: number of stop bits, parity, number
 	   of data bits, baud. What can the device actually handle?:
@@ -388,22 +392,18 @@
 
 	   For now, just do baud. */
 
-	switch (cflag & CBAUD) {
-		/* we could support more values here, just need to calculate
-		   the necessary divisors in the firmware. <asm/termbits.h>
-		   has the Bnnn constants. */
-		case B110: keyspan_pda_setbaud(serial, 110); break;
-		case B300: keyspan_pda_setbaud(serial, 300); break;
-		case B1200: keyspan_pda_setbaud(serial, 1200); break;
-		case B2400: keyspan_pda_setbaud(serial, 2400); break;
-		case B4800: keyspan_pda_setbaud(serial, 4800); break;
-		case B9600: keyspan_pda_setbaud(serial, 9600); break;
-		case B19200: keyspan_pda_setbaud(serial, 19200); break;
-		case B38400: keyspan_pda_setbaud(serial, 38400); break;
-		case B57600: keyspan_pda_setbaud(serial, 57600); break;
-		case B115200: keyspan_pda_setbaud(serial, 115200); break;
-		default: dbg("can't handle requested baud rate"); break;
-	}
+	speed = tty_get_baud_rate(port->tty);
+	speed = keyspan_pda_setbaud(serial, speed);
+
+	if (speed == 0) {
+		dbg("can't handle requested baud rate");
+		/* It hasn't changed so.. */
+		speed = tty_termios_baud_rate(old_termios);
+	}
+	/* Only speed can change so copy the old h/w parameters
+	   then encode the new speed */
+	tty_termios_copy_hw(port->tty->termios, old_termios);
+	tty_encode_baud_rate(port->tty, speed, speed);
 }
 
 
