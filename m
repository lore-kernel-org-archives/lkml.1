Return-Path: <linux-kernel-owner+w=401wt.eu-S933787AbYBTUfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787AbYBTUfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765711AbYBTUez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:34:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35609 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934431AbYBTUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:34:54 -0500
Date: Wed, 20 Feb 2008 20:25:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial167: prepare to push BKL down into drivers
Message-ID: <20080220202525.78fa4b70@core>
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

Kill the softcar handlers again, wrap the ioctl handler in the BKL

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/serial167.c linux-2.6.25-rc2-mm1/drivers/char/serial167.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/serial167.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/serial167.c	2008-02-20 11:48:49.000000000 +0000
@@ -1539,6 +1539,8 @@
 	printk("cy_ioctl %s, cmd = %x arg = %lx\n", tty->name, cmd, arg);	/* */
 #endif
 
+	lock_kernel();
+
 	switch (cmd) {
 	case CYGETMON:
 		ret_val = get_mon_info(info, argp);
@@ -1584,18 +1586,6 @@
 		break;
 
 /* The following commands are incompletely implemented!!! */
-	case TIOCGSOFTCAR:
-		ret_val =
-		    put_user(C_CLOCAL(tty) ? 1 : 0,
-			     (unsigned long __user *)argp);
-		break;
-	case TIOCSSOFTCAR:
-		ret_val = get_user(val, (unsigned long __user *)argp);
-		if (ret_val)
-			break;
-		tty->termios->c_cflag =
-		    ((tty->termios->c_cflag & ~CLOCAL) | (val ? CLOCAL : 0));
-		break;
 	case TIOCGSERIAL:
 		ret_val = get_serial_info(info, argp);
 		break;
@@ -1605,6 +1595,7 @@
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
+	unlock_kernel();
 
 #ifdef SERIAL_DEBUG_OTHER
 	printk("cy_ioctl done\n");
