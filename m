Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbXKSOvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbXKSOvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXKSOux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:50:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57453 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753634AbXKSOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:50:52 -0500
Date: Mon, 19 Nov 2007 14:49:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mxser/mxser_new: First pass over termios reporting for the
 mxser cards
Message-ID: <20071119144910.59717dec@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/char/mxser.c linux-2.6.24-rc2-mm1/drivers/char/mxser.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/char/mxser.c	2007-11-16 17:55:11.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/char/mxser.c	2007-11-16 18:19:13.000000000 +0000
@@ -1391,7 +1391,8 @@
 			long baud;
 			if (get_user(baud, (long __user *)argp))
 				return -EFAULT;
-			mxser_set_baud(info, baud);
+			if (mxser_set_baud(info, baud) == -1)
+				return -1;
 			return 0;
 		}
 	case MOXA_ASPP_GETBAUD:
@@ -2517,7 +2518,13 @@
 #endif
 	if (mxser_set_baud_method[info->port] == 0) {
 		baud = tty_get_baud_rate(info->tty);
-		mxser_set_baud(info, baud);
+		if (mxser_set_baud(info, baud) == -1) {
+			/* Use previous rate on a failure */
+			if (old_termios) {
+				baud = tty_termios_baud_rate(old_termios);
+				tty_encode_baud_rate(info->tty, baud, baud);
+			}
+		}
 	}
 
 	/* byte size and parity */
@@ -2691,27 +2698,31 @@
 {
 	int quot = 0;
 	unsigned char cval;
-	int ret = 0;
 	unsigned long flags;
+	unsigned int baud;
 
 	if (!info->tty || !info->tty->termios)
-		return ret;
+		return -1;
 
 	if (!(info->base))
-		return ret;
+		return -1;
 
 	if (newspd > info->MaxCanSetBaudRate)
-		return 0;
+		return -1;
 
 	info->realbaud = newspd;
 	if (newspd == 134) {
 		quot = (2 * info->baud_base / 269);
+		tty_encode_baud_rate(info->tty, 134, 134);
 	} else if (newspd) {
 		quot = info->baud_base / newspd;
 		if (quot == 0)
 			quot = 1;
+		baud = info->baud_base / quot;
+		tty_encode_baud_rate(info->tty, baud, baud);
 	} else {
 		quot = 0;
+		tty_encode_baud_rate(info->tty, 0, 0);
 	}
 
 	info->timeout = ((info->xmit_fifo_size * HZ * 10 * quot) / info->baud_base);
@@ -2727,7 +2738,7 @@
 		info->MCR &= ~UART_MCR_DTR;
 		outb(info->MCR, info->base + UART_MCR);
 		spin_unlock_irqrestore(&info->slock, flags);
-		return ret;
+		return 0;
 	}
 
 	cval = inb(info->base + UART_LCR);
@@ -2739,7 +2750,7 @@
 	outb(cval, info->base + UART_LCR);	/* reset DLAB */
 
 
-	return ret;
+	return 0;
 }
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/char/mxser_new.c linux-2.6.24-rc2-mm1/drivers/char/mxser_new.c
--- linux.vanilla-2.6.24-rc2-mm1/drivers/char/mxser_new.c	2007-11-16 17:55:11.000000000 +0000
+++ linux-2.6.24-rc2-mm1/drivers/char/mxser_new.c	2007-11-16 18:19:21.000000000 +0000
@@ -452,18 +452,17 @@
 static int mxser_set_baud(struct mxser_port *info, long newspd)
 {
 	unsigned int i;
-	int quot = 0;
+	int quot = 0, baud;
 	unsigned char cval;
-	int ret = 0;
 
 	if (!info->tty || !info->tty->termios)
-		return ret;
+		return -1;
 
 	if (!(info->ioaddr))
-		return ret;
+		return -1;
 
 	if (newspd > info->max_baud)
-		return 0;
+		return -1;
 
 	info->realbaud = newspd;
 	for (i = 0; i < BAUD_TABLE_NO; i++)
@@ -476,10 +475,13 @@
 	} else {
 		if (newspd == 134) {
 			quot = (2 * info->baud_base / 269);
+			tty_encode_baud_rate(info->tty, 134, 134);
 		} else if (newspd) {
 			quot = info->baud_base / newspd;
 			if (quot == 0)
 				quot = 1;
+			baud = info->baud_base/quot;
+			tty_encode_baud_rate(info->tty, baud, baud);
 		} else {
 			quot = 0;
 		}
@@ -494,7 +496,7 @@
 	} else {
 		info->MCR &= ~UART_MCR_DTR;
 		outb(info->MCR, info->ioaddr + UART_MCR);
-		return ret;
+		return 0;
 	}
 
 	cval = inb(info->ioaddr + UART_LCR);
@@ -518,7 +520,7 @@
 	} else
 		SET_MOXA_MUST_ENUM_VALUE(info->ioaddr, 0);
 
-	return ret;
+	return 0;
 }
 
 /*
