Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYCZLyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYCZLyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYCZLym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:54:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34737 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752587AbYCZLym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:54:42 -0400
Date: Wed, 26 Mar 2008 11:38:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: drop the BKL for driver/ldisc ioctl methods
Message-ID: <20080326113806.79e84f6d@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have pushed the lock down we can stop wrapping the call with a
lock in the tty layer

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc5-mm1/drivers/char/tty_io.c linux-2.6.25-rc5-mm1/drivers/char/tty_io.c
--- linux.vanilla-2.6.25-rc5-mm1/drivers/char/tty_io.c	2008-03-18 15:52:20.000000000 +0000
+++ linux-2.6.25-rc5-mm1/drivers/char/tty_io.c	2008-03-18 15:58:26.000000000 +0000
@@ -3459,11 +3582,8 @@
 		switch (cmd) {
 		case TIOCSBRK:
 		case TIOCCBRK:
-			if (tty->driver->ioctl) {
-				lock_kernel();
+			if (tty->driver->ioctl)
 				retval = tty->driver->ioctl(tty, file, cmd, arg);
-				unlock_kernel();
-			}
 			return retval;
 
 		/* These two ioctl's always return success; even if */
@@ -3584,18 +3704,14 @@
 		break;
 	}
 	if (tty->driver->ioctl) {
-		lock_kernel();
 		retval = (tty->driver->ioctl)(tty, file, cmd, arg);
-		unlock_kernel();
 		if (retval != -ENOIOCTLCMD)
 			return retval;
 	}
 	ld = tty_ldisc_ref_wait(tty);
 	retval = -EINVAL;
 	if (ld->ioctl) {
-		lock_kernel();
 		retval = ld->ioctl(tty, file, cmd, arg);
-		unlock_kernel();
 		if (retval == -ENOIOCTLCMD)
 			retval = -EINVAL;
 	}
