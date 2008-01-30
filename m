Return-Path: <linux-kernel-owner+w=401wt.eu-S1756813AbYA3Jc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813AbYA3Jc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbYA3Ja3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:30:29 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:63088 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYA3JaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:30:18 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47624084"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 03/12] [Blackfin] serial driver: Clean up UART DMA code.
Date: Wed, 30 Jan 2008 17:30:03 +0800
Message-Id: <1201685412-29095-4-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
References: <1201685412-29095-1-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Start next TX DMA in tx dma handler instead of rx timer handler.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index e059475..3a2aa7e 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -84,7 +84,7 @@ static void bfin_serial_mctrl_check(struct bfin_serial_port *uart);
 static void bfin_serial_stop_tx(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-#ifndef CONFIG_BF54x
+#if !defined(CONFIG_BF54x) && !defined(CONFIG_SERIAL_BFIN_DMA)
 	unsigned short ier;
 #endif
 
@@ -307,7 +307,6 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 		UART_PUT_CHAR(uart, uart->port.x_char);
 		uart->port.icount.tx++;
 		uart->port.x_char = 0;
-		return;
 	}
 	/*
 	 * Check the modem control lines before
@@ -376,28 +375,26 @@ static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart)
 
 	if (!uart->tx_done)
 		return;
-
 	uart->tx_done = 0;
 
+	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
+		bfin_serial_stop_tx(&uart->port);
+		uart->tx_done = 1;
+		return;
+	}
+
 	if (uart->port.x_char) {
 		UART_PUT_CHAR(uart, uart->port.x_char);
 		uart->port.icount.tx++;
 		uart->port.x_char = 0;
-		uart->tx_done = 1;
-		return;
 	}
+
 	/*
 	 * Check the modem control lines before
 	 * transmitting anything.
 	 */
 	bfin_serial_mctrl_check(uart);
 
-	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
-		bfin_serial_stop_tx(&uart->port);
-		uart->tx_done = 1;
-		return;
-	}
-
 	spin_lock_irqsave(&uart->port.lock, flags);
 	uart->tx_count = CIRC_CNT(xmit->head, xmit->tail, UART_XMIT_SIZE);
 	if (uart->tx_count > (UART_XMIT_SIZE - xmit->tail))
@@ -471,8 +468,6 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 	int x_pos, pos;
 	int flags = 0;
 
-	bfin_serial_dma_tx_chars(uart);
-
 	spin_lock_irqsave(&uart->port.lock, flags);
 	x_pos = DMA_RX_XCOUNT - get_dma_curr_xcount(uart->rx_dma_channel);
 	if (x_pos == DMA_RX_XCOUNT)
@@ -513,9 +508,9 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq, void *dev_id)
 		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 			uart_write_wakeup(&uart->port);
 
-		if (uart_circ_empty(xmit))
-			bfin_serial_stop_tx(&uart->port);
 		uart->tx_done = 1;
+
+		bfin_serial_dma_tx_chars(uart);
 	}
 
 	spin_unlock(&uart->port.lock);
-- 
1.5.3.4
