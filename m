Return-Path: <linux-kernel-owner+w=401wt.eu-S1763920AbXEUKOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763920AbXEUKOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761366AbXEUKJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:35 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:4457 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761048AbXEUKJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:17 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510261:sNHT227244136"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 31/32] Blackfin serial driver: implement support for ignoring parity/break errors
Date: Mon, 21 May 2007 18:09:39 +0800
Message-Id: <11797421881610-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

properly setting up and respecting the read_status_mask / ignore_status_mask fields of the serial core

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c |   97 ++++++++++++++++++++++++++++-----------------
 1 files changed, 61 insertions(+), 36 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index a8271d9..787dc71 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -6,8 +6,6 @@
  * Created:
  * Description:  Driver for blackfin 5xx serial ports
  *
- * Rev:          $Id: bfin_5xx.c,v 1.19 2006/09/24 02:33:53 aubrey Exp $
- *
  * Modified:
  *               Copyright 2006 Analog Devices Inc.
  *
@@ -152,7 +150,7 @@ static void local_put_char(struct bfin_serial_port *uart, char ch)
 
 static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 {
-	struct tty_struct *tty = uart->port.info?uart->port.info->tty:0;
+	struct tty_struct *tty = uart->port.info->tty;
 	unsigned int status, ch, flg;
 #ifdef BF533_FAMILY
 	static int in_break = 0;
@@ -173,8 +171,10 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 		if (ch != 0) {
 			in_break = 0;
 			ch = UART_GET_CHAR(uart);
-		}
-		return;
+			if (bfin_revid() < 5)
+				return;
+		} else
+			return;
 	}
 #endif
 
@@ -185,27 +185,32 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 		uart->port.icount.brk++;
 		if (uart_handle_break(&uart->port))
 			goto ignore_char;
-		flg = TTY_BREAK;
-	} else if (status & PE) {
-		flg = TTY_PARITY;
+	}
+	if (status & PE)
 		uart->port.icount.parity++;
-	} else if (status & OE) {
-		flg = TTY_OVERRUN;
+	if (status & OE)
 		uart->port.icount.overrun++;
-	} else if (status & FE) {
-		flg = TTY_FRAME;
+	if (status & FE)
 		uart->port.icount.frame++;
-	} else
+
+	status &= uart->port.read_status_mask;
+
+	if (status & BI)
+		flg = TTY_BREAK;
+	else if (status & PE)
+		flg = TTY_PARITY;
+	else if (status & FE)
+		flg = TTY_FRAME;
+	else
 		flg = TTY_NORMAL;
 
 	if (uart_handle_sysrq_char(&uart->port, ch))
 		goto ignore_char;
-	if (tty)
-		uart_insert_char(&uart->port, status, 2, ch, flg);
 
-ignore_char:
-	if (tty)
-		tty_flip_buffer_push(tty);
+	uart_insert_char(&uart->port, status, OE, ch, flg);
+
+ ignore_char:
+	tty_flip_buffer_push(tty);
 }
 
 static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
@@ -254,7 +259,6 @@ static irqreturn_t bfin_serial_rx_int(int irq, void *dev_id)
 static irqreturn_t bfin_serial_tx_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
-	unsigned short status;
 
 	spin_lock(&uart->port.lock);
 	while ((UART_GET_IIR(uart) & IIR_STATUS) == IIR_TX_READY)
@@ -325,7 +329,7 @@ static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart)
 	spin_unlock_irqrestore(&uart->port.lock, flags);
 }
 
-static void bfin_serial_dma_rx_chars(struct bfin_serial_port * uart)
+static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 {
 	struct tty_struct *tty = uart->port.info->tty;
 	int i, flg, status;
@@ -337,25 +341,32 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port * uart)
 		uart->port.icount.brk++;
 		if (uart_handle_break(&uart->port))
 			goto dma_ignore_char;
-		flg = TTY_BREAK;
-	} else if (status & PE) {
-		flg = TTY_PARITY;
+	}
+	if (status & PE)
 		uart->port.icount.parity++;
-	} else if (status & OE) {
-		flg = TTY_OVERRUN;
+	if (status & OE)
 		uart->port.icount.overrun++;
-	} else if (status & FE) {
-		flg = TTY_FRAME;
+	if (status & FE)
 		uart->port.icount.frame++;
-	} else
+
+	status &= uart->port.read_status_mask;
+
+	if (status & BI)
+		flg = TTY_BREAK;
+	else if (status & PE)
+		flg = TTY_PARITY;
+	else if (status & FE)
+		flg = TTY_FRAME;
+	else
 		flg = TTY_NORMAL;
 
 	for (i = uart->rx_dma_buf.head; i < uart->rx_dma_buf.tail; i++) {
 		if (uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
 			goto dma_ignore_char;
-		uart_insert_char(&uart->port, status, 2, uart->rx_dma_buf.buf[i], flg);
+		uart_insert_char(&uart->port, status, OE, uart->rx_dma_buf.buf[i], flg);
 	}
-dma_ignore_char:
+
+ dma_ignore_char:
 	tty_flip_buffer_push(tty);
 }
 
@@ -620,13 +631,27 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 			lcr |= EPS;
 	}
 
-	/* These controls are not implemented for this port */
-	termios->c_iflag |= INPCK | BRKINT | PARMRK;
-	termios->c_iflag &= ~(IGNPAR | IGNBRK);
+	port->read_status_mask = OE;
+	if (termios->c_iflag & INPCK)
+		port->read_status_mask |= (FE | PE);
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		port->read_status_mask |= BI;
 
-	/* These controls are not implemented for this port */
-	termios->c_iflag |= INPCK | BRKINT | PARMRK;
-	termios->c_iflag &= ~(IGNPAR | IGNBRK);
+	/*
+	 * Characters to ignore
+	 */
+	port->ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		port->ignore_status_mask |= FE | PE;
+	if (termios->c_iflag & IGNBRK) {
+		port->ignore_status_mask |= BI;
+		/*
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR)
+			port->ignore_status_mask |= OE;
+	}
 
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
 	quot = uart_get_divisor(port, baud);
-- 
1.5.1.2
