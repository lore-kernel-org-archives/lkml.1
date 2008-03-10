Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbYCJWHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbYCJWHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYCJWHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:07:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39200 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752000AbYCJWHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:07:08 -0400
Date: Mon, 10 Mar 2008 21:53:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty_ioctl: locking for tty_wait_until_sent
Message-ID: <20080310215325.2b8d33e8@core>
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

This function still depends on the big kernel lock in some cases. Push
locking into the function ready for removal of the BKL from ioctl call
paths.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c linux-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c	2008-03-10 12:57:53.000000000 +0000
+++ linux-2.6.25-rc3-mm1/drivers/char/tty_ioctl.c	2008-03-10 13:27:09.000000000 +0000
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -61,11 +62,13 @@
 		return;
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
+	lock_kernel();
 	if (wait_event_interruptible_timeout(tty->write_wait,
-			!tty->driver->chars_in_buffer(tty), timeout) < 0)
-		return;
-	if (tty->driver->wait_until_sent)
-		tty->driver->wait_until_sent(tty, timeout);
+			!tty->driver->chars_in_buffer(tty), timeout) >= 0) {
+		if (tty->driver->wait_until_sent)
+			tty->driver->wait_until_sent(tty, timeout);
+	}
+	unlock_kernel();
 }
 EXPORT_SYMBOL(tty_wait_until_sent);
 
