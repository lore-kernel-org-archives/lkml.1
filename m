Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbYBTUZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbYBTUZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbYBTUZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:25:25 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44390 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753643AbYBTUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:25:24 -0500
Date: Wed, 20 Feb 2008 20:15:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] isicom: prepare for lock_kernel push down
Message-ID: <20080220201554.61328d23@core>
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

Again lock the bits we can't trivially prove are safe without the BKL and
remove the broken TIOCS/GSOFTCAR handler.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/isicom.c linux-2.6.25-rc2-mm1/drivers/char/isicom.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/isicom.c	2008-02-19 11:01:44.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/isicom.c	2008-02-20 11:45:50.000000000 +0000
@@ -1258,6 +1258,8 @@
 	if (copy_from_user(&newinfo, info, sizeof(newinfo)))
 		return -EFAULT;
 
+	lock_kernel();
+	
 	reconfig_port = ((port->flags & ASYNC_SPD_MASK) !=
 		(newinfo.flags & ASYNC_SPD_MASK));
 
@@ -1265,8 +1267,10 @@
 		if ((newinfo.close_delay != port->close_delay) ||
 				(newinfo.closing_wait != port->closing_wait) ||
 				((newinfo.flags & ~ASYNC_USR_MASK) !=
-				(port->flags & ~ASYNC_USR_MASK)))
+				(port->flags & ~ASYNC_USR_MASK))) {
+			unlock_kernel();
 			return -EPERM;
+		}
 		port->flags = ((port->flags & ~ ASYNC_USR_MASK) |
 				(newinfo.flags & ASYNC_USR_MASK));
 	}
@@ -1282,6 +1286,7 @@
 		isicom_config_port(port);
 		spin_unlock_irqrestore(&port->card->card_lock, flags);
 	}
+	unlock_kernel();
 	return 0;
 }
 
@@ -1290,6 +1295,7 @@
 {
 	struct serial_struct out_info;
 
+	lock_kernel();
 	memset(&out_info, 0, sizeof(out_info));
 /*	out_info.type = ? */
 	out_info.line = port - isi_ports;
@@ -1299,6 +1305,7 @@
 /*	out_info.baud_base = ? */
 	out_info.close_delay = port->close_delay;
 	out_info.closing_wait = port->closing_wait;
+	unlock_kernel();
 	if (copy_to_user(info, &out_info, sizeof(out_info)))
 		return -EFAULT;
 	return 0;
@@ -1331,19 +1338,6 @@
 		tty_wait_until_sent(tty, 0);
 		isicom_send_break(port, arg ? arg * (HZ/10) : HZ/4);
 		return 0;
-
-	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0,
-				(unsigned long __user *)argp);
-
-	case TIOCSSOFTCAR:
-		if (get_user(arg, (unsigned long __user *) argp))
-			return -EFAULT;
-		tty->termios->c_cflag =
-			((tty->termios->c_cflag & ~CLOCAL) |
-			(arg ? CLOCAL : 0));
-		return 0;
-
 	case TIOCGSERIAL:
 		return isicom_get_serial_info(port, argp);
 
