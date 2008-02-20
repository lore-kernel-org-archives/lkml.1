Return-Path: <linux-kernel-owner+w=401wt.eu-S933669AbYBTUXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbYBTUXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755603AbYBTUXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:23:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44375 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754197AbYBTUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:23:11 -0500
Date: Wed, 20 Feb 2008 20:13:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] epca: lock_kernel push down
Message-ID: <20080220201339.15cb7a54@core>
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

Prepare epca for removing the lock from above. Most of epca is internally
locked so we can trivially push it down to a few bits of code. Drop the TIOCG/SSOFTCAR handling as that is done *properly* with locks by the mid layer.

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/epca.c linux-2.6.25-rc2-mm1/drivers/char/epca.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/epca.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/epca.c	2008-02-20 11:45:43.000000000 +0000
@@ -2206,21 +2206,6 @@
 		tty_wait_until_sent(tty, 0);
 		digi_send_break(ch, arg ? arg*(HZ/10) : HZ/4);
 		return 0;
-	case TIOCGSOFTCAR:
-		if (put_user(C_CLOCAL(tty)?1:0, (unsigned long __user *)arg))
-			return -EFAULT;
-		return 0;
-	case TIOCSSOFTCAR:
-		{
-			unsigned int value;
-
-			if (get_user(value, (unsigned __user *)argp))
-				return -EFAULT;
-			tty->termios->c_cflag =
-				((tty->termios->c_cflag & ~CLOCAL) |
-				 (value ? CLOCAL : 0));
-			return 0;
-		}
 	case TIOCMODG:
 		mflag = pc_tiocmget(tty, file);
 		if (put_user(mflag, (unsigned long __user *)argp))
@@ -2253,6 +2238,7 @@
 		break;
 	case DIGI_SETAW:
 	case DIGI_SETAF:
+		lock_kernel();
 		if (cmd == DIGI_SETAW) {
 			/* Setup an event to indicate when the transmit buffer empties */
 			spin_lock_irqsave(&epca_lock, flags);
@@ -2264,6 +2250,7 @@
 			if (tty->ldisc.flush_buffer)
 				tty->ldisc.flush_buffer(tty);
 		}
+		unlock_kernel();
 		/* Fall Thru */
 	case DIGI_SETA:
 		if (copy_from_user(&ch->digiext, argp, sizeof(digi_t)))
