Return-Path: <linux-kernel-owner+w=401wt.eu-S1763380AbYD2NeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763380AbYD2NeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYD2NeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:34:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51456 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751613AbYD2NeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:34:13 -0400
Date: Tue, 29 Apr 2008 14:26:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Add throttle/unthrottle helpers
Message-ID: <20080429142611.5aafcfce@core>
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

Something Arjan suggested which allows us to clean up the code nicely

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/tty_ioctl.c linux-2.6.25-mm1/drivers/char/tty_ioctl.c
--- linux.vanilla-2.6.25-mm1/drivers/char/tty_ioctl.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/tty_ioctl.c	2008-04-14 14:27:41.000000000 +0100
@@ -67,6 +67,24 @@
 
 EXPORT_SYMBOL(tty_driver_flush_buffer);
 
+void tty_throttle(struct tty_struct *tty)
+{
+	/* check TTY_THROTTLED first so it indicates our state */
+	if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
+	    tty->ops->throttle)
+		tty->ops->throttle(tty);
+}
+
+EXPORT_SYMBOL(tty_throttle);
+
+void tty_unthrottle(struct tty_struct *tty)
+{
+	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
+	    tty->ops->unthrottle)
+		tty->ops->unthrottle(tty);
+}
+
+EXPORT_SYMBOL(tty_unthrottle);
 
 /**
  *	tty_wait_until_sent	-	wait for I/O to finish
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/include/linux/tty_driver.h linux-2.6.25-mm1/include/linux/tty_driver.h
--- linux.vanilla-2.6.25-mm1/include/linux/tty_driver.h	2008-04-28 11:36:52.000000000 +0100
+++ linux-2.6.25-mm1/include/linux/tty_driver.h	2008-04-14 14:27:30.000000000 +0100
@@ -83,10 +83,10 @@
  * void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
  *
  * 	This routine allows the tty driver to be notified when
- * 	device's termios settings have changed.
+ * 	device's termios settings have changed.
  *
  *	Optional: Called under the termios lock
  *
  *
  * void (*set_ldisc)(struct tty_struct *tty);
  *
@@ -100,6 +100,8 @@
  * 	This routine notifies the tty driver that input buffers for
  * 	the line discipline are close to full, and it should somehow
  * 	signal that no more characters should be sent to the tty.
+ *
+ *	Optional: Always invoke via tty_throttle();
  * 
  * void (*unthrottle)(struct tty_struct * tty);
  *
@@ -107,12 +109,14 @@
  * 	that characters can now be sent to the tty without fear of
  * 	overrunning the input buffers of the line disciplines.
  * 
+ *	Optional: Always invoke via tty_unthrottle();
+ *
  * void (*stop)(struct tty_struct *tty);
  *
  * 	This routine notifies the tty driver that it should stop
  * 	outputting characters to the tty device.  
  *
- *	Optional:
+ *	Optional: 
  *
  *	Note: Call stop_tty not this method.
  * 
@@ -141,7 +145,7 @@
  *
  * 	If this routine is implemented, the high-level tty driver will
  * 	handle the following ioctls: TCSBRK, TCSBRKP, TIOCSBRK,
- * 	TIOCCBRK.
+ * 	TIOCCBRK. 
  *
  *	Optional: Required for TCSBRK/BRKP/etc handling.
  *
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/include/linux/tty.h linux-2.6.25-mm1/include/linux/tty.h
--- linux.vanilla-2.6.25-mm1/include/linux/tty.h	2008-04-28 11:36:52.000000000 +0100
+++ linux-2.6.25-mm1/include/linux/tty.h	2008-04-28 12:26:36.000000000 +0100
@@ -303,6 +321,8 @@
 extern int tty_chars_in_buffer(struct tty_struct *tty);
 extern int tty_write_room(struct tty_struct *tty);
 extern void tty_driver_flush_buffer(struct tty_struct *tty);
+extern void tty_throttle(struct tty_struct *tty);
+extern void tty_unthrottle(struct tty_struct *tty);
 
 extern int is_current_pgrp_orphaned(void);
 extern struct pid *tty_get_pgrp(struct tty_struct *tty);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/bluetooth/hci_ldisc.c linux-2.6.25-mm1/drivers/bluetooth/hci_ldisc.c
--- linux.vanilla-2.6.25-mm1/drivers/bluetooth/hci_ldisc.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/bluetooth/hci_ldisc.c	2008-04-28 11:43:39.000000000 +0100
@@ -370,9 +370,7 @@
 	hu->hdev->stat.byte_rx += count;
 	spin_unlock(&hu->rx_lock);
 
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
-					tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static int hci_uart_register_dev(struct hci_uart *hu)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/char/n_tty.c linux-2.6.25-mm1/drivers/char/n_tty.c
--- linux.vanilla-2.6.25-mm1/drivers/char/n_tty.c	2008-04-28 11:36:48.000000000 +0100
+++ linux-2.6.25-mm1/drivers/char/n_tty.c	2008-04-14 14:26:29.000000000 +0100
@@ -147,10 +147,8 @@
 
 static void check_unthrottle(struct tty_struct *tty)
 {
-	if (tty->count &&
-	    test_and_clear_bit(TTY_THROTTLED, &tty->flags) &&
-	    tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	if (tty->count)
+		tty_unthrottle(tty);
 }
 
 /**
@@ -982,12 +980,8 @@
 	 * mode.  We don't want to throttle the driver if we're in
 	 * canonical mode and don't have a newline yet!
 	 */
-	if (tty->receive_room < TTY_THRESHOLD_THROTTLE) {
-		/* check TTY_THROTTLED first so it indicates our state */
-		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags) &&
-		    tty->ops->throttle)
-			tty->ops->throttle(tty);
-	}
+	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
+		tty_throttle(tty);
 }
 
 int is_ignored(int sig)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/net/hamradio/6pack.c linux-2.6.25-mm1/drivers/net/hamradio/6pack.c
--- linux.vanilla-2.6.25-mm1/drivers/net/hamradio/6pack.c	2008-04-28 11:36:49.000000000 +0100
+++ linux-2.6.25-mm1/drivers/net/hamradio/6pack.c	2008-04-14 14:29:14.000000000 +0100
@@ -491,9 +491,7 @@
 	sixpack_decode(sp, buf, count1);
 
 	sp_put(sp);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/net/hamradio/mkiss.c linux-2.6.25-mm1/drivers/net/hamradio/mkiss.c
--- linux.vanilla-2.6.25-mm1/drivers/net/hamradio/mkiss.c	2008-04-28 11:36:49.000000000 +0100
+++ linux-2.6.25-mm1/drivers/net/hamradio/mkiss.c	2008-04-14 14:29:29.000000000 +0100
@@ -936,9 +936,7 @@
 	}
 
 	mkiss_put(ax);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/net/ppp_async.c linux-2.6.25-mm1/drivers/net/ppp_async.c
--- linux.vanilla-2.6.25-mm1/drivers/net/ppp_async.c	2008-04-28 11:36:49.000000000 +0100
+++ linux-2.6.25-mm1/drivers/net/ppp_async.c	2008-04-14 14:28:29.000000000 +0100
@@ -361,9 +361,7 @@
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
 	ap_put(ap);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static void
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-mm1/drivers/net/ppp_synctty.c linux-2.6.25-mm1/drivers/net/ppp_synctty.c
--- linux.vanilla-2.6.25-mm1/drivers/net/ppp_synctty.c	2008-04-28 11:36:49.000000000 +0100
+++ linux-2.6.25-mm1/drivers/net/ppp_synctty.c	2008-04-14 14:28:46.000000000 +0100
@@ -401,9 +401,7 @@
 	if (!skb_queue_empty(&ap->rqueue))
 		tasklet_schedule(&ap->tsk);
 	sp_put(ap);
-	if (test_and_clear_bit(TTY_THROTTLED, &tty->flags)
-	    && tty->ops->unthrottle)
-		tty->ops->unthrottle(tty);
+	tty_unthrottle(tty);
 }
 
 static void
