Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbYBTU2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbYBTU2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbYBTU2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:28:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35499 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752294AbYBTU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:28:09 -0500
Date: Wed, 20 Feb 2008 20:18:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] moxa: prepare for BKL pushdown
Message-ID: <20080220201857.04626cac@core>
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

Moxa needs a few routines wrapping with the BKL for now. It also snoops
the TIOCG/SSOFTCAR function so needs its own implementation for now. That
wants fixing by turning it into a termios set downcall into the drivers
later.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/moxa.c linux-2.6.25-rc2-mm1/drivers/char/moxa.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/moxa.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/moxa.c	2008-02-20 11:45:50.000000000 +0000
@@ -686,8 +686,8 @@
 	int flag = 0, dtr, rts;
 
 	port = tty->index;
-	if ((port != MAX_PORTS) && (!ch))
-		return (-EINVAL);
+	if (port != MAX_PORTS && !ch)
+		return -EINVAL;
 
 	MoxaPortGetLineOut(ch->port, &dtr, &rts);
 	if (dtr)
@@ -712,9 +712,10 @@
 	int dtr, rts;
 
 	port = tty->index;
-	if ((port != MAX_PORTS) && (!ch))
-		return (-EINVAL);
+	if (port != MAX_PORTS && !ch)
+		return -EINVAL;
 
+	lock_kernel();
 	MoxaPortGetLineOut(ch->port, &dtr, &rts);
 	if (set & TIOCM_RTS)
 		rts = 1;
@@ -725,6 +726,7 @@
 	if (clear & TIOCM_DTR)
 		dtr = 0;
 	MoxaPortLineCtrl(ch->port, dtr, rts);
+	unlock_kernel();
 	return 0;
 }
 
@@ -734,52 +736,56 @@
 	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 	register int port;
 	void __user *argp = (void __user *)arg;
-	int retval;
-
+	int retval = 0;
+	
 	port = tty->index;
-	if ((port != MAX_PORTS) && (!ch))
-		return (-EINVAL);
+	if (port != MAX_PORTS && !ch)
+		return -EINVAL;
 
 	switch (cmd) {
 	case TCSBRK:		/* SVID version: non-zero arg --> no break */
 		retval = tty_check_change(tty);
 		if (retval)
-			return (retval);
+			break;
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 0);
 		if (!arg)
 			MoxaPortSendBreak(ch->port, 0);
-		return (0);
+		break;
 	case TCSBRKP:		/* support for POSIX tcsendbreak() */
 		retval = tty_check_change(tty);
 		if (retval)
-			return (retval);
+			break;
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 0);
 		MoxaPortSendBreak(ch->port, arg);
-		return (0);
-	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *) argp);
+		break;
 	case TIOCSSOFTCAR:
 		if(get_user(retval, (unsigned long __user *) argp))
 			return -EFAULT;
 		arg = retval;
+		mutex_lock(&tty->termios_mutex);
 		tty->termios->c_cflag = ((tty->termios->c_cflag & ~CLOCAL) |
 					 (arg ? CLOCAL : 0));
 		if (C_CLOCAL(tty))
 			ch->asyncflags &= ~ASYNC_CHECK_CD;
 		else
 			ch->asyncflags |= ASYNC_CHECK_CD;
-		return (0);
+		mutex_unlock(&tty->termios_mutex);
+		break;
 	case TIOCGSERIAL:
 		return moxa_get_serial_info(ch, argp);
-
 	case TIOCSSERIAL:
-		return moxa_set_serial_info(ch, argp);
+		lock_kernel();
+		retval = moxa_set_serial_info(ch, argp);
+		unlock_kernel();
+		break;
 	default:
+		lock_kernel();
 		retval = MoxaDriverIoctl(cmd, arg, port);
+		unlock_kernel();
 	}
-	return (retval);
+	return retval;
 }
 
 static void moxa_throttle(struct tty_struct *tty)
@@ -2414,6 +2420,7 @@
 	struct serial_struct tmp;
 
 	memset(&tmp, 0, sizeof(tmp));
+	lock_kernel();
 	tmp.type = info->type;
 	tmp.line = info->port;
 	tmp.port = 0;
@@ -2424,6 +2431,7 @@
 	tmp.closing_wait = info->closing_wait;
 	tmp.custom_divisor = 0;
 	tmp.hub6 = 0;
+	unlock_kernel();
 	if(copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
 	return (0);
