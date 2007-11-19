Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbXKSPUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbXKSPUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:20:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbXKSPUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:20:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59864 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753360AbXKSPUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:20:42 -0500
Date: Mon, 19 Nov 2007 15:18:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] belkin_sa: clean up for new style termios and speed
 handling, plus style
Message-ID: <20071119151851.5cb59add@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A tester with actual hardware would be useful

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/usb/serial/belkin_sa.c linux-2.6.24-rc2-mm1/drivers/usb/serial/belkin_sa.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/usb/serial/belkin_sa.c	2007-11-16 17:20:48.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/usb/serial/belkin_sa.c	2007-11-16 18:35:53.000000000 +0000
@@ -350,14 +350,12 @@
 	unsigned long control_state;
 	int bad_flow_control;
 	speed_t baud;
+	struct ktermios *termios = port->tty->termios;
 	
-	if ((!port->tty) || (!port->tty->termios)) {
-		dbg ("%s - no tty or termios structure", __FUNCTION__);
-		return;
-	}
-
-	iflag = port->tty->termios->c_iflag;
-	cflag = port->tty->termios->c_cflag;
+	iflag = termios->c_iflag;
+	cflag = termios->c_cflag;
+	
+	termios->c_cflag &= ~CMSPAR;
 
 	/* get a local copy of the current port settings */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -369,33 +367,30 @@
 	old_cflag = old_termios->c_cflag;
 
 	/* Set the baud rate */
-	if( (cflag&CBAUD) != (old_cflag&CBAUD) ) {
+	if ((cflag & CBAUD) != (old_cflag & CBAUD)) {
 		/* reassert DTR and (maybe) RTS on transition from B0 */
 		if( (old_cflag&CBAUD) == B0 ) {
 			control_state |= (TIOCM_DTR|TIOCM_RTS);
 			if (BSA_USB_CMD(BELKIN_SA_SET_DTR_REQUEST, 1) < 0)
 				err("Set DTR error");
 			/* don't set RTS if using hardware flow control */
-			if (!(old_cflag&CRTSCTS) )
+			if (!(old_cflag & CRTSCTS))
 				if (BSA_USB_CMD(BELKIN_SA_SET_RTS_REQUEST, 1) < 0)
 					err("Set RTS error");
 		}
 	}
 
 	baud = tty_get_baud_rate(port->tty);
-	if (baud == 0) {
-		dbg("%s - tty_get_baud_rate says 0 baud", __FUNCTION__);
-		return;
-	}
-	urb_value = BELKIN_SA_BAUD(baud);
-	/* Clip to maximum speed */
-	if (urb_value == 0)
-		urb_value = 1;
-	/* Turn it back into a resulting real baud rate */
-	baud = BELKIN_SA_BAUD(urb_value);
-	/* FIXME: Once the tty updates are done then push this back to the tty */
-
-	if ((cflag & CBAUD) != B0 ) {
+	if (baud) {
+		urb_value = BELKIN_SA_BAUD(baud);
+		/* Clip to maximum speed */
+		if (urb_value == 0)
+			urb_value = 1;
+		/* Turn it back into a resulting real baud rate */
+		baud = BELKIN_SA_BAUD(urb_value);
+	
+		/* Report the actual baud rate back to the caller */
+		tty_encode_baud_rate(port->tty, baud, baud);
 		if (BSA_USB_CMD(BELKIN_SA_SET_BAUDRATE_REQUEST, urb_value) < 0)
 			err("Set baudrate error");
 	} else {
