Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbYA3Jbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbYA3Jbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbYA3JaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:21 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:40869 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbYA3JaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:16 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61204641"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 02/12] [Blackfin] Serial driver: Fix bug - serial driver in PIO mode cant handle input very quickly
Date: Wed, 30 Jan 2008 17:30:02 +0800
Message-Id: <1201685412-29095-3-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Output as many bytes as possible in PIO tx handler.
This reduce the number of tx interrupts and shorten the delay to handle
rx interrupt. So, rx overrun disappears.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c |   62 ++++++++++----------------------------------
 1 files changed, 14 insertions(+), 48 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index ac2a3ef..e059475 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -74,7 +74,6 @@ static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart);
 #else
 static void bfin_serial_do_work(struct work_struct *work);
 static void bfin_serial_tx_chars(struct bfin_serial_port *uart);
-static void local_put_char(struct bfin_serial_port *uart, char ch);
 #endif
 
 static void bfin_serial_mctrl_check(struct bfin_serial_port *uart);
@@ -85,6 +84,9 @@ static void bfin_serial_mctrl_check(struct bfin_serial_port *uart);
 static void bfin_serial_stop_tx(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+#ifndef CONFIG_BF54x
+	unsigned short ier;
+#endif
 
 	while (!(UART_GET_LSR(uart) & TEMT))
 		continue;
@@ -100,8 +102,6 @@ static void bfin_serial_stop_tx(struct uart_port *port)
 	UART_PUT_LSR(uart, TFI);
 	UART_CLEAR_IER(uart, ETBEI);
 #else
-	unsigned short ier;
-
 	ier = UART_GET_IER(uart);
 	ier &= ~ETBEI;
 	UART_PUT_IER(uart, ier);
@@ -210,23 +210,6 @@ int kgdb_get_debug_char(void)
 #endif
 
 #ifdef CONFIG_SERIAL_BFIN_PIO
-static void local_put_char(struct bfin_serial_port *uart, char ch)
-{
-	unsigned short status;
-	int flags = 0;
-
-	spin_lock_irqsave(&uart->port.lock, flags);
-
-	do {
-		status = UART_GET_LSR(uart);
-	} while (!(status & THRE));
-
-	UART_PUT_CHAR(uart, ch);
-	SSYNC();
-
-	spin_unlock_irqrestore(&uart->port.lock, flags);
-}
-
 static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 {
 	struct tty_struct *tty = uart->port.info->tty;
@@ -236,8 +219,8 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 	struct pt_regs *regs = get_irq_regs();
 #endif
 
-	status = UART_GET_LSR(uart);
  	ch = UART_GET_CHAR(uart);
+	status = UART_GET_LSR(uart);
  	uart->port.icount.rx++;
 
 #ifdef CONFIG_KGDB_UART
@@ -337,9 +320,12 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 		return;
 	}
 
-	local_put_char(uart, xmit->buf[xmit->tail]);
-	xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
-	uart->port.icount.tx++;
+	while ((UART_GET_LSR(uart) & THRE) && xmit->tail != xmit->head) {
+		UART_PUT_CHAR(uart, xmit->buf[xmit->tail]);
+		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		uart->port.icount.tx++;
+		SSYNC();
+	}
 
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(&uart->port);
@@ -352,21 +338,11 @@ static irqreturn_t bfin_serial_rx_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
 
-#ifdef CONFIG_BF54x
-	unsigned short status;
 	spin_lock(&uart->port.lock);
-	status = UART_GET_LSR(uart);
-	while ((UART_GET_IER(uart) & ERBFI) && (status & DR)) {
+	while ((UART_GET_IER(uart) & ERBFI) && (UART_GET_LSR(uart) & DR))
 		bfin_serial_rx_chars(uart);
-		status = UART_GET_LSR(uart);
-	}
 	spin_unlock(&uart->port.lock);
-#else
-	spin_lock(&uart->port.lock);
-	while ((UART_GET_IIR(uart) & IIR_STATUS) == IIR_RX_READY)
-		bfin_serial_rx_chars(uart);
-	spin_unlock(&uart->port.lock);
-#endif
+
 	return IRQ_HANDLED;
 }
 
@@ -374,21 +350,11 @@ static irqreturn_t bfin_serial_tx_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
 
-#ifdef CONFIG_BF54x
-	unsigned short status;
 	spin_lock(&uart->port.lock);
-	status = UART_GET_LSR(uart);
-	while ((UART_GET_IER(uart) & ETBEI) && (status & THRE)) {
+	if ((UART_GET_IER(uart) & ETBEI) && (UART_GET_LSR(uart) & THRE))
 		bfin_serial_tx_chars(uart);
-		status = UART_GET_LSR(uart);
-	}
 	spin_unlock(&uart->port.lock);
-#else
-	spin_lock(&uart->port.lock);
-	while ((UART_GET_IIR(uart) & IIR_STATUS) == IIR_TX_READY)
-		bfin_serial_tx_chars(uart);
-	spin_unlock(&uart->port.lock);
-#endif
+
 	return IRQ_HANDLED;
 }
 
-- 
1.5.3.4
