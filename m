Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbYDMRbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbYDMRbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYDMRbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:31:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40754 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751494AbYDMRbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:31:31 -0400
Date: Sun, 13 Apr 2008 18:27:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: switch the serial core to int put_char methods
Message-ID: <20080413182732.6536d8d8@core>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/serial/serial_core.c linux-2.6.25-rc8-mm2/drivers/serial/serial_core.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/serial/serial_core.c	2008-04-13 15:36:54.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/serial/serial_core.c	2008-04-13 16:00:06.000000000 +0100
@@ -422,6 +422,7 @@
 
 EXPORT_SYMBOL(uart_get_divisor);
 
+/* FIXME: Consistent locking policy */
 static void
 uart_change_speed(struct uart_state *state, struct ktermios *old_termios)
 {
@@ -454,27 +455,30 @@
 	port->ops->set_termios(port, termios, old_termios);
 }
 
-static inline void
+static inline int
 __uart_put_char(struct uart_port *port, struct circ_buf *circ, unsigned char c)
 {
 	unsigned long flags;
+	int ret = 0;
 
 	if (!circ->buf)
-		return;
+		return 0;
 
 	spin_lock_irqsave(&port->lock, flags);
 	if (uart_circ_chars_free(circ) != 0) {
 		circ->buf[circ->head] = c;
 		circ->head = (circ->head + 1) & (UART_XMIT_SIZE - 1);
+		ret = 1;
 	}
 	spin_unlock_irqrestore(&port->lock, flags);
+	return ret;
 }
 
-static void uart_put_char(struct tty_struct *tty, unsigned char ch)
+static int uart_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct uart_state *state = tty->driver_data;
 
-	__uart_put_char(state->port, &state->info->xmit, ch);
+	return __uart_put_char(state->port, &state->info->xmit, ch);
 }
 
 static void uart_flush_chars(struct tty_struct *tty)
