Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbYBTUdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbYBTUdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934212AbYBTUcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:32:35 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35509 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934026AbYBTUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:32:34 -0500
Date: Wed, 20 Feb 2008 20:23:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] riscom8: Prepare for BKL pushdown
Message-ID: <20080220202303.52923ded@core>
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

Push the locking down into a couple of functions that need it and remove
bogus TIOCG/SSOFTCAR handling

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/riscom8.c linux-2.6.25-rc2-mm1/drivers/char/riscom8.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/riscom8.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/riscom8.c	2008-02-20 11:48:38.000000000 +0000
@@ -1385,7 +1385,7 @@
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	void __user *argp = (void __user *)arg;
-	int retval;
+	int retval = 0;
 				
 	if (rc_paranoia_check(port, tty->name, "rc_ioctl"))
 		return -ENODEV;
@@ -1406,23 +1406,20 @@
 		tty_wait_until_sent(tty, 0);
 		rc_send_break(port, arg ? arg*(HZ/10) : HZ/4);
 		break;
-	 case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned __user *)argp);
-	 case TIOCSSOFTCAR:
-		if (get_user(arg,(unsigned __user *) argp))
-			return -EFAULT;
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			(arg ? CLOCAL : 0));
+	 case TIOCGSERIAL:
+	 	lock_kernel();
+		retval = rc_get_serial_info(port, argp);
+		unlock_kernel();
 		break;
-	 case TIOCGSERIAL:	
-		return rc_get_serial_info(port, argp);
 	 case TIOCSSERIAL:	
-		return rc_set_serial_info(port, argp);
+	 	lock_kernel();
+		retval = rc_set_serial_info(port, argp);
+		unlock_kernel();
+		break;
 	 default:
-		return -ENOIOCTLCMD;
+		retval = -ENOIOCTLCMD;
 	}
-	return 0;
+	return retval;
 }
 
 static void rc_throttle(struct tty_struct * tty)
