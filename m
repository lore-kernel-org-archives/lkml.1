Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbYDMRTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbYDMRTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYDMRTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:19:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39411 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750890AbYDMRTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:19:43 -0400
Date: Sun, 13 Apr 2008 18:15:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] riscom/rocket: switch to int put_char method
Message-ID: <20080413181543.667ca21a@core>
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

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/riscom8.c linux-2.6.25-rc8-mm2/drivers/char/riscom8.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/riscom8.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/riscom8.c	2008-04-13 15:40:59.000000000 +0100
@@ -1161,16 +1161,17 @@
 	return total;
 }
 
-static void rc_put_char(struct tty_struct * tty, unsigned char ch)
+static int rc_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
 	unsigned long flags;
+	int ret = 0;
 
 	if (rc_paranoia_check(port, tty->name, "rc_put_char"))
-		return;
+		return 0;
 
 	if (!tty || !port->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&riscom_lock, flags);
 	
@@ -1180,9 +1181,11 @@
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	port->xmit_cnt++;
+	ret = 1;
 
 out:
 	spin_unlock_irqrestore(&riscom_lock, flags);
+	return ret;
 }
 
 static void rc_flush_chars(struct tty_struct * tty)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/rocket.c linux-2.6.25-rc8-mm2/drivers/char/rocket.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/rocket.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/rocket.c	2008-04-13 15:40:59.000000000 +0100
@@ -1663,14 +1663,14 @@
  *  writing routines will write directly to transmit FIFO.
  *  Write buffer and counters protected by spinlocks
  */
-static void rp_put_char(struct tty_struct *tty, unsigned char ch)
+static int rp_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct r_port *info = (struct r_port *) tty->driver_data;
 	CHANNEL_t *cp;
 	unsigned long flags;
 
 	if (rocket_paranoia_check(info, "rp_put_char"))
-		return;
+		return 0;
 
 	/*
 	 * Grab the port write mutex, locking out other processes that try to
@@ -1699,6 +1699,7 @@
 	}
 	spin_unlock_irqrestore(&info->slock, flags);
 	mutex_unlock(&info->write_mtx);
+	return 1;
 }
 
 /*
