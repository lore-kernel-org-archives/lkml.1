Return-Path: <linux-kernel-owner+w=401wt.eu-S934136AbYBTUid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136AbYBTUid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbYBTUiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:38:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41231 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755629AbYBTUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:38:09 -0500
Date: Wed, 20 Feb 2008 20:29:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sx: prepare for BKL pushdown
Message-ID: <20080220202907.1a854828@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the ioctl handler, and in this case the break handler also in the
BKL. Remove bogus softcar handlers.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/sx.c linux-2.6.25-rc2-mm1/drivers/char/sx.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/sx.c	2008-02-19 11:01:44.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/sx.c	2008-02-20 11:49:03.000000000 +0000
@@ -1844,6 +1844,7 @@
 	int rv;
 
 	func_enter();
+	lock_kernel();
 
 	if (flag)
 		rv = sx_send_command(port, HS_START, -1, HS_IDLE_BREAK);
@@ -1852,7 +1853,7 @@
 	if (rv != 1)
 		printk(KERN_ERR "sx: couldn't send break (%x).\n",
 			read_sx_byte(port->board, CHAN_OFFSET(port, hi_hstat)));
-
+	unlock_kernel();
 	func_exit();
 }
 
@@ -1888,23 +1889,12 @@
 	int rc;
 	struct sx_port *port = tty->driver_data;
 	void __user *argp = (void __user *)arg;
-	int ival;
 
 	/* func_enter2(); */
 
 	rc = 0;
+	lock_kernel();
 	switch (cmd) {
-	case TIOCGSOFTCAR:
-		rc = put_user(((tty->termios->c_cflag & CLOCAL) ? 1 : 0),
-				(unsigned __user *)argp);
-		break;
-	case TIOCSSOFTCAR:
-		if ((rc = get_user(ival, (unsigned __user *)argp)) == 0) {
-			tty->termios->c_cflag =
-				(tty->termios->c_cflag & ~CLOCAL) |
-				(ival ? CLOCAL : 0);
-		}
-		break;
 	case TIOCGSERIAL:
 		rc = gs_getserial(&port->gs, argp);
 		break;
@@ -1915,6 +1905,7 @@
 		rc = -ENOIOCTLCMD;
 		break;
 	}
+	unlock_kernel();
 
 	/* func_exit(); */
 	return rc;
