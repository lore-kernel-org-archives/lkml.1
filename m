Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbYBTUhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbYBTUhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYBTUhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:37:00 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35615 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752362AbYBTUg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:36:59 -0500
Date: Wed, 20 Feb 2008 20:27:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] stallion: Prepare for BKL push down
Message-ID: <20080220202757.318512ef@core>
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

Remove broken softcar functions, wrap ioctl handler in BKL

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/stallion.c linux-2.6.25-rc2-mm1/drivers/char/stallion.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/stallion.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/stallion.c	2008-02-20 11:49:03.000000000 +0000
@@ -1273,18 +1273,9 @@
 
 	rc = 0;
 
+	lock_kernel();
+	
 	switch (cmd) {
-	case TIOCGSOFTCAR:
-		rc = put_user(((tty->termios->c_cflag & CLOCAL) ? 1 : 0),
-			(unsigned __user *) argp);
-		break;
-	case TIOCSSOFTCAR:
-		if (get_user(ival, (unsigned int __user *) arg))
-			return -EFAULT;
-		tty->termios->c_cflag =
-				(tty->termios->c_cflag & ~CLOCAL) |
-				(ival ? CLOCAL : 0);
-		break;
 	case TIOCGSERIAL:
 		rc = stl_getserial(portp, argp);
 		break;
@@ -1308,7 +1299,7 @@
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-
+	unlock_kernel();
 	return rc;
 }
 
