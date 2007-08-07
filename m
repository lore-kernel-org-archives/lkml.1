Return-Path: <linux-kernel-owner+w=401wt.eu-S934429AbXHGXZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934429AbXHGXZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 19:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbXHGXZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 19:25:11 -0400
Received: from perm68-235.ij.net ([209.216.68.235]:4073 "EHLO smirk.3gfp.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752577AbXHGXZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 19:25:09 -0400
X-Greylist: delayed 1866 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 19:25:09 EDT
Message-ID: <46B8F7FE.3090904@3gfp.com>
Date: Tue, 07 Aug 2007 18:53:50 -0400
From: Harvey Chapman <hchapman-linux-kernel@3gfp.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] serial inter-character timeout usage with async io
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for comments, thanks.

This patch adds a timeout mode to n_tty that will only send SIGIO
signals (for input) when the UART's IIR indicates that a character
timeout has occurred. This reduces overhead by reducing the number of
SIGIO signals sent and consequently the unnecessary wake-ups of a
sleeping process waiting for serial input asynchronously.

two boolean values "timeout_enabled" and "timeout" are added to
tty_struct which enable/disable the mode and record whether an
inter-character timeout occurred during the last interrupt, respectively.

A new ioctl, TIOCSTIMEOUT, is added to set/clear "timeout_enabled." This
seemed to be the cleanest way to do that (that I saw, at least).

In n_tty_receive_buf(), some additional tests were added before the
kill_async() call to accommodate the old behavior and the newer timeout
behavior as well as adding a check to make sure the read buffer doesn't
overflow without a timeout received.

This should be 100% backwards compatible since the timeout mode is
disabled by default.

Currently, I only have this code enabled for i386 and arm, and only for
the 8250 and pxa serial drivers. If no one thinks this is a terrible
idea, I'll modify all of the other ioctl.h files and resubmit the patch.

Thanks,

Harvey


diff -urp -x '*.orig' -x '*.rej' -x '*~'
linux-2.6.22.1.orig/drivers/char/n_tty.c linux-2.6.22.1/drivers/char/n_tty.c
--- linux-2.6.22.1.orig/drivers/char/n_tty.c	2007-07-10
14:56:30.000000000 -0400
+++ linux-2.6.22.1/drivers/char/n_tty.c	2007-08-07 18:23:44.000000000 -0400
@@ -957,7 +957,17 @@ static void n_tty_receive_buf(struct tty

 	n_tty_set_room(tty);

-	if (!tty->icanon && (tty->read_cnt >= tty->minimum_to_wake)) {
+	/*
+	 * Make sure we're not in canonical mode. If not in timeout mode,
+	 * use vmin setting as usual. If in timeout mode, only send if the
+	 * last interrupt was a timeout. As a last resort, check to make
+	 * sure the read buffer doesn't get too close to full. The factor of
+	 * 4 used is an arbitrary number.
+	 */
+	if (!tty->icanon &&
+	    ((!tty->timeout_enabled && (tty->read_cnt >= tty->minimum_to_wake)) ||
+	     tty->timeout ||
+	     tty->receive_room < (4 * TTY_THRESHOLD_THROTTLE))) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
 			wake_up_interruptible(&tty->read_wait);
diff -urp -x '*.orig' -x '*.rej' -x '*~'
linux-2.6.22.1.orig/drivers/char/tty_ioctl.c
linux-2.6.22.1/drivers/char/tty_ioctl.c
--- linux-2.6.22.1.orig/drivers/char/tty_ioctl.c	2007-07-10
14:56:30.000000000 -0400
+++ linux-2.6.22.1/drivers/char/tty_ioctl.c	2007-08-07
15:11:23.000000000 -0400
@@ -852,6 +852,15 @@ int n_tty_ioctl(struct tty_struct * tty,
 				 (arg ? CLOCAL : 0));
 			mutex_unlock(&tty->termios_mutex);
 			return 0;
+
+		case TIOCSTIMEOUT:
+			if (get_user(arg, (unsigned int __user *) arg))
+				return -EFAULT;
+			tty->timeout_enabled = (arg ? 1 : 0);
+			tty->minimum_to_wake = 0;
+			MIN_CHAR(tty) = 0;
+			return 0;
+
 		default:
 			return -ENOIOCTLCMD;
 		}
diff -urp -x '*.orig' -x '*.rej' -x '*~'
linux-2.6.22.1.orig/drivers/serial/8250.c
linux-2.6.22.1/drivers/serial/8250.c
--- linux-2.6.22.1.orig/drivers/serial/8250.c	2007-07-10
14:56:30.000000000 -0400
+++ linux-2.6.22.1/drivers/serial/8250.c	2007-08-07 17:29:24.000000000 -0400
@@ -1466,6 +1466,12 @@ static irqreturn_t serial8250_interrupt(

 		iir = serial_in(up, UART_IIR);
 		if (!(iir & UART_IIR_NO_INT)) {
+			/* Flag an inter-character timeout */
+			if (up->port.info->tty->timeout_enabled &&
+			    (iir & UART_IIR_TOD) == UART_IIR_TOD)
+				up->port.info->tty->timeout = 1;
+			else
+				up->port.info->tty->timeout = 0;
 			serial8250_handle_port(up);

 			handled = 1;
diff -urp -x '*.orig' -x '*.rej' -x '*~'
linux-2.6.22.1.orig/drivers/serial/pxa.c linux-2.6.22.1/drivers/serial/pxa.c
--- linux-2.6.22.1.orig/drivers/serial/pxa.c	2007-07-10
14:56:30.000000000 -0400
+++ linux-2.6.22.1/drivers/serial/pxa.c	2007-08-07 17:29:59.000000000 -0400
@@ -238,6 +238,12 @@ static inline irqreturn_t serial_pxa_irq
 	iir = serial_in(up, UART_IIR);
 	if (iir & UART_IIR_NO_INT)
 		return IRQ_NONE;
+	/* Flag an inter-character timeout */
+	if (up->port.info->tty->timeout_enabled &&
+	    (iir & UART_IIR_TOD) == UART_IIR_TOD)
+		up->port.info->tty->timeout = 1;
+	else
+		up->port.info->tty->timeout = 0;
 	lsr = serial_in(up, UART_LSR);
 	if (lsr & UART_LSR_DR)
 		receive_chars(up, &lsr);
diff -urp -x '*.orig' -x '*.rej' -x '*~'
linux-2.6.22.1.orig/include/asm-arm/ioctls.h
linux-2.6.22.1/include/asm-arm/ioctls.h
--- linux-2.6.22.1.orig/include/asm-arm/ioctls.h	2007-07-10
14:56:30.000000000 -0400
+++ linux-2.6.22.1/include/asm-arm/ioctls.h	2007-08-07
15:11:23.000000000 -0400
@@ -69,6 +69,7 @@
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
 #define FIOQSIZE	0x545E
+#define TIOCSTIMEOUT	0x545F

 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
diff -urp -x '*.orig' -x '*.rej' -x '*~'
linux-2.6.22.1.orig/include/asm-i386/ioctls.h
linux-2.6.22.1/include/asm-i386/ioctls.h
--- linux-2.6.22.1.orig/include/asm-i386/ioctls.h	2007-07-10
14:56:30.000000000 -0400
+++ linux-2.6.22.1/include/asm-i386/ioctls.h	2007-08-07
18:33:49.000000000 -0400
@@ -72,6 +72,7 @@
 #define TIOCGHAYESESP   0x545E  /* Get Hayes ESP configuration */
 #define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
 #define FIOQSIZE	0x5460
+#define TIOCSTIMEOUT	0x5461

 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
diff -urp -x '*.orig' -x '*.rej' -x '*~'
linux-2.6.22.1.orig/include/linux/tty.h linux-2.6.22.1/include/linux/tty.h
--- linux-2.6.22.1.orig/include/linux/tty.h	2007-07-10
14:56:30.000000000 -0400
+++ linux-2.6.22.1/include/linux/tty.h	2007-08-07 15:11:23.000000000 -0400
@@ -227,6 +227,7 @@ struct tty_struct {
 	unsigned int column;
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
 	unsigned char closing:1;
+	unsigned char timeout:1, timeout_enabled:1;
 	unsigned short minimum_to_wake;
 	unsigned long overrun_time;
 	int num_overrun;
