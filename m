Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbYBTUq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbYBTUq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYBTUqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:46:17 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41000 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753044AbYBTUqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:46:15 -0500
Date: Wed, 20 Feb 2008 20:37:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn_tty: Prepare for BKL push down
Message-ID: <20080220203712.79a8c1f3@core>
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

Three things here
- Remove softcar handler
- Correct termios change detection logic
- Wrap break/ioctl in lock_kernel ready to drop it in the caller

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/isdn/i4l/isdn_tty.c linux-2.6.25-rc2-mm1/drivers/isdn/i4l/isdn_tty.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/isdn/i4l/isdn_tty.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/isdn/i4l/isdn_tty.c	2008-02-20 11:50:10.000000000 +0000
@@ -1352,12 +1352,14 @@
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
 
+	lock_kernel();
 #ifdef ISDN_DEBUG_MODEM_IOCTL
 	printk(KERN_DEBUG "ttyI%d ioctl TIOCMGET\n", info->line);
 #endif
 
 	control = info->mcr;
 	status = info->msr;
+	unlock_kernel();
 	return ((control & UART_MCR_RTS) ? TIOCM_RTS : 0)
 	    | ((control & UART_MCR_DTR) ? TIOCM_DTR : 0)
 	    | ((status & UART_MSR_DCD) ? TIOCM_CAR : 0)
@@ -1381,6 +1383,7 @@
 	printk(KERN_DEBUG "ttyI%d ioctl TIOCMxxx: %x %x\n", info->line, set, clear);
 #endif
 
+	lock_kernel();
 	if (set & TIOCM_RTS)
 		info->mcr |= UART_MCR_RTS;
 	if (set & TIOCM_DTR) {
@@ -1402,6 +1405,7 @@
 			isdn_tty_modem_hup(info, 1);
 		}
 	}
+	unlock_kernel();
 	return 0;
 }
 
@@ -1435,21 +1439,6 @@
 				return retval;
 			tty_wait_until_sent(tty, 0);
 			return 0;
-		case TIOCGSOFTCAR:
-#ifdef ISDN_DEBUG_MODEM_IOCTL
-			printk(KERN_DEBUG "ttyI%d ioctl TIOCGSOFTCAR\n", info->line);
-#endif
-			return put_user(C_CLOCAL(tty) ? 1 : 0, (ulong __user *) arg);
-		case TIOCSSOFTCAR:
-#ifdef ISDN_DEBUG_MODEM_IOCTL
-			printk(KERN_DEBUG "ttyI%d ioctl TIOCSSOFTCAR\n", info->line);
-#endif
-			if (get_user(arg, (ulong __user *) arg))
-				return -EFAULT;
-			tty->termios->c_cflag =
-			    ((tty->termios->c_cflag & ~CLOCAL) |
-			     (arg ? CLOCAL : 0));
-			return 0;
 		case TIOCSERGETLSR:	/* Get line status register */
 #ifdef ISDN_DEBUG_MODEM_IOCTL
 			printk(KERN_DEBUG "ttyI%d ioctl TIOCSERGETLSR\n", info->line);
@@ -1472,13 +1461,14 @@
 	if (!old_termios)
 		isdn_tty_change_speed(info);
 	else {
-		if (tty->termios->c_cflag == old_termios->c_cflag)
+		if (tty->termios->c_cflag == old_termios->c_cflag &&
+		    tty->termios->c_ispeed == old_termios->c_ispeed &&
+		    tty->termios->c_ospeed == old_termios->c_ospeed)
 			return;
 		isdn_tty_change_speed(info);
 		if ((old_termios->c_cflag & CRTSCTS) &&
-		    !(tty->termios->c_cflag & CRTSCTS)) {
+		    !(tty->termios->c_cflag & CRTSCTS))
 			tty->hw_stopped = 0;
-		}
 	}
 }
 
