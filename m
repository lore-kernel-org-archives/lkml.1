Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbYDMRQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYDMRQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbYDMRPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:15:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53497 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750776AbYDMRPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:15:53 -0400
Date: Sun, 13 Apr 2008 18:11:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] char: switch gs, cyclades and esp to return int for
 put_char
Message-ID: <20080413181153.14f6ab70@core>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/cyclades.c linux-2.6.25-rc8-mm2/drivers/char/cyclades.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/cyclades.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/cyclades.c	2008-04-13 15:40:58.000000000 +0100
@@ -2815,7 +2815,7 @@
  * done stuffing characters into the driver.  If there is no room
  * in the queue, the character is ignored.
  */
-static void cy_put_char(struct tty_struct *tty, unsigned char ch)
+static int cy_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct cyclades_port *info = tty->driver_data;
 	unsigned long flags;
@@ -2825,15 +2825,15 @@
 #endif
 
 	if (serial_paranoia_check(info, tty->name, "cy_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->card->card_lock, flags);
 	if (info->xmit_cnt >= (int)(SERIAL_XMIT_SIZE - 1)) {
 		spin_unlock_irqrestore(&info->card->card_lock, flags);
-		return;
+		return 0;
 	}
 
 	info->xmit_buf[info->xmit_head++] = ch;
@@ -2842,6 +2842,7 @@
 	info->idle_stats.xmit_bytes++;
 	info->idle_stats.xmit_idle = jiffies;
 	spin_unlock_irqrestore(&info->card->card_lock, flags);
+	return 1;
 }				/* cy_put_char */
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/esp.c linux-2.6.25-rc8-mm2/drivers/char/esp.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/esp.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/esp.c	2008-04-13 15:40:59.000000000 +0100
@@ -1156,24 +1156,27 @@
 	spin_unlock_irqrestore(&info->lock, flags);
 }
 
-static void rs_put_char(struct tty_struct *tty, unsigned char ch)
+static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct esp_struct *info = (struct esp_struct *)tty->driver_data;
 	unsigned long flags;
+	int ret = 0;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&info->lock, flags);
 	if (info->xmit_cnt < ESP_XMIT_SIZE - 1) {
 		info->xmit_buf[info->xmit_head++] = ch;
 		info->xmit_head &= ESP_XMIT_SIZE-1;
 		info->xmit_cnt++;
+		ret = 1;
 	}
 	spin_unlock_irqrestore(&info->lock, flags);
+	return ret;
 }
 
 static void rs_flush_chars(struct tty_struct *tty)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/generic_serial.c linux-2.6.25-rc8-mm2/drivers/char/generic_serial.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/generic_serial.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/generic_serial.c	2008-04-13 15:41:06.000000000 +0100
@@ -49,19 +49,19 @@
 module_param(gs_debug, int, 0644);
 
 
-void gs_put_char(struct tty_struct * tty, unsigned char ch)
+int gs_put_char(struct tty_struct * tty, unsigned char ch)
 {
 	struct gs_port *port;
 
 	func_enter (); 
 
-	if (!tty) return;
+	if (!tty) return 0;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port) return 0;
 
-	if (! (port->flags & ASYNC_INITIALIZED)) return;
+	if (! (port->flags & ASYNC_INITIALIZED)) return 0;
 
 	/* Take a lock on the serial tranmit buffer! */
 	mutex_lock(& port->port_write_mutex);
@@ -69,7 +69,7 @@
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		/* Sorry, buffer is full, drop character. Update statistics???? -- REW */
 		mutex_unlock(&port->port_write_mutex);
-		return;
+		return 0;
 	}
 
 	port->xmit_buf[port->xmit_head++] = ch;
@@ -78,6 +78,7 @@
 
 	mutex_unlock(&port->port_write_mutex);
 	func_exit ();
+	return 1;
 }
 
 
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/include/linux/generic_serial.h linux-2.6.25-rc8-mm2/include/linux/generic_serial.h
--- linux.vanilla-2.6.25-rc8-mm2/include/linux/generic_serial.h	2008-04-13 12:55:26.000000000 +0100
+++ linux-2.6.25-rc8-mm2/include/linux/generic_serial.h	2008-04-13 15:38:56.000000000 +0100
@@ -78,7 +78,7 @@
 #define GS_DEBUG_WRITE   0x00000040
 
 #ifdef __KERNEL__
-void gs_put_char(struct tty_struct *tty, unsigned char ch);
+int gs_put_char(struct tty_struct *tty, unsigned char ch);
 int  gs_write(struct tty_struct *tty, 
              const unsigned char *buf, int count);
 int  gs_write_room(struct tty_struct *tty);
