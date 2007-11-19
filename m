Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbXKSOtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbXKSOtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbXKSOtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:49:04 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57450 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753787AbXKSOtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:49:01 -0500
Date: Mon, 19 Nov 2007 14:47:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] moxa: first pass at termios reporting
Message-ID: <20071119144717.53572ade@the-village.bc.nu>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/char/moxa.c linux-2.6.24-rc2-mm1/drivers/char/moxa.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/char/moxa.c	2007-11-16 17:54:39.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/char/moxa.c	2007-11-16 18:19:07.000000000 +0000
@@ -207,7 +207,7 @@
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
-static void moxa_set_tty_param(struct tty_struct *);
+static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
 static int moxa_block_till_ready(struct tty_struct *, struct file *,
 			    struct moxa_port *);
 static void moxa_setup_empty_event(struct tty_struct *);
@@ -500,7 +500,7 @@
 	ch->tty = tty;
 	if (!(ch->asyncflags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
-		moxa_set_tty_param(tty);
+		moxa_set_tty_param(tty, tty->termios);
 		MoxaPortLineCtrl(ch->port, 1, 1);
 		MoxaPortEnable(ch->port);
 		ch->asyncflags |= ASYNC_INITIALIZED;
@@ -803,7 +803,7 @@
 
 	if (ch == NULL)
 		return;
-	moxa_set_tty_param(tty);
+	moxa_set_tty_param(tty, old_termios);
 	if (!(old_termios->c_cflag & CLOCAL) &&
 	    (tty->termios->c_cflag & CLOCAL))
 		wake_up_interruptible(&ch->open_wait);
@@ -903,11 +903,11 @@
 
 /******************************************************************************/
 
-static void moxa_set_tty_param(struct tty_struct *tty)
+static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	register struct ktermios *ts;
 	struct moxa_port *ch;
-	int rts, cts, txflow, rxflow, xany;
+	int rts, cts, txflow, rxflow, xany, baud;
 
 	ch = (struct moxa_port *) tty->driver_data;
 	ts = tty->termios;
@@ -924,8 +924,15 @@
 		rxflow = 1;
 	if (ts->c_iflag & IXANY)
 		xany = 1;
+		
+	/* Clear the features we don't support */
+	ts->c_cflag &= ~CMSPAR;
 	MoxaPortFlowCtrl(ch->port, rts, cts, txflow, rxflow, xany);
-	MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
+	baud = MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
+	if (baud == -1)
+		baud = tty_termios_baud_rate(old_termios);
+	/* Not put the baud rate into the termios data */
+	tty_encode_baud_rate(tty, baud, baud);
 }
 
 static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
@@ -2065,7 +2072,7 @@
 		if (baud >= 921600L)
 			return (-1);
 	}
-	MoxaPortSetBaud(port, baud);
+	baud = MoxaPortSetBaud(port, baud);
 
 	if (termio->c_iflag & (IXON | IXOFF | IXANY)) {
 		writeb(termio->c_cc[VSTART], ofsAddr + FuncArg);
@@ -2074,7 +2081,7 @@
 		moxa_wait_finish(ofsAddr);
 
 	}
-	return (0);
+	return (baud);
 }
 
 int MoxaPortGetLineOut(int port, int *dtrState, int *rtsState)
