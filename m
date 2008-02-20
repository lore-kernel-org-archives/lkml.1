Return-Path: <linux-kernel-owner+w=401wt.eu-S934134AbYBTUgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934134AbYBTUgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934268AbYBTUfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:35:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35612 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934260AbYBTUfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:35:51 -0500
Date: Wed, 20 Feb 2008 20:26:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] specialix: Prepare for BKL pushdown
Message-ID: <20080220202649.2e296e79@core>
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

Lock the ioctl handlers and remove bogus softcar handling.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/specialix.c linux-2.6.25-rc2-mm1/drivers/char/specialix.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/specialix.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/specialix.c	2008-02-20 11:48:55.000000000 +0000
@@ -1924,29 +1924,13 @@
 	int change_speed;
 
 	func_enter();
-	/*
-	if (!access_ok(VERIFY_READ, (void *) newinfo, sizeof(tmp))) {
-		func_exit();
-		return -EFAULT;
-	}
-	*/
+
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp))) {
 		func_enter();
 		return -EFAULT;
 	}
-
-#if 0
-	if ((tmp.irq != bp->irq) ||
-	    (tmp.port != bp->base) ||
-	    (tmp.type != PORT_CIRRUS) ||
-	    (tmp.baud_base != (SX_OSCFREQ + CD186x_TPC/2) / CD186x_TPC) ||
-	    (tmp.custom_divisor != 0) ||
-	    (tmp.xmit_fifo_size != CD186x_NFIFO) ||
-	    (tmp.flags & ~SPECIALIX_LEGAL_FLAGS)) {
-		func_exit();
-		return -EINVAL;
-	}
-#endif
+	
+	lock_kernel();
 
 	change_speed = ((port->flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
@@ -1958,6 +1942,7 @@
 		    ((tmp.flags & ~ASYNC_USR_MASK) !=
 		     (port->flags & ~ASYNC_USR_MASK))) {
 			func_exit();
+			unlock_kernel();
 			return -EPERM;
 		}
 		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
@@ -1974,6 +1959,7 @@
 		sx_change_speed(bp, port);
 	}
 	func_exit();
+	unlock_kernel();
 	return 0;
 }
 
@@ -1986,12 +1972,8 @@
 
 	func_enter();
 
-	/*
-	if (!access_ok(VERIFY_WRITE, (void *) retinfo, sizeof(tmp)))
-		return -EFAULT;
-	*/
-
 	memset(&tmp, 0, sizeof(tmp));
+	lock_kernel();
 	tmp.type = PORT_CIRRUS;
 	tmp.line = port - sx_port;
 	tmp.port = bp->base;
@@ -2002,6 +1984,7 @@
 	tmp.closing_wait = port->closing_wait * HZ/100;
 	tmp.custom_divisor =  port->custom_divisor;
 	tmp.xmit_fifo_size = CD186x_NFIFO;
+	unlock_kernel();
 	if (copy_to_user(retinfo, &tmp, sizeof(tmp))) {
 		func_exit();
 		return -EFAULT;
@@ -2047,23 +2030,6 @@
 		sx_send_break(port, arg ? arg*(HZ/10) : HZ/4);
 		func_exit();
 		return 0;
-	 case TIOCGSOFTCAR:
-		 if (put_user(C_CLOCAL(tty)?1:0, (unsigned long __user *)argp)) {
-			 func_exit();
-			 return -EFAULT;
-		 }
-		 func_exit();
-		return 0;
-	 case TIOCSSOFTCAR:
-		 if (get_user(arg, (unsigned long __user *) argp)) {
-			 func_exit();
-			 return -EFAULT;
-		 }
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			(arg ? CLOCAL : 0));
-		func_exit();
-		return 0;
 	 case TIOCGSERIAL:
 		 func_exit();
 		return sx_get_serial_info(port, argp);
