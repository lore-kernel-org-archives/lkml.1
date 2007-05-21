Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbXEUKNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbXEUKNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbXEUKJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:25 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:1813 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054AbXEUKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:13 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505450:sNHT29186171"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Aubrey Li <aubrey.li@analog.com>, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 30/32] Blackfin serial driver: fix overhead issue
Date: Mon, 21 May 2007 18:09:38 +0800
Message-Id: <11797421882932-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aubrey Li <aubrey.li@analog.com>

Signed-off-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/serial/bfin_5xx.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 408390f..a8271d9 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -240,24 +240,30 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 		bfin_serial_stop_tx(&uart->port);
 }
 
-static irqreturn_t bfin_serial_int(int irq, void *dev_id)
+static irqreturn_t bfin_serial_rx_int(int irq, void *dev_id)
+{
+	struct bfin_serial_port *uart = dev_id;
+
+	spin_lock(&uart->port.lock);
+	while ((UART_GET_IIR(uart) & IIR_STATUS) == IIR_RX_READY)
+		bfin_serial_rx_chars(uart);
+	spin_unlock(&uart->port.lock);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t bfin_serial_tx_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
 	unsigned short status;
 
 	spin_lock(&uart->port.lock);
-	status = UART_GET_IIR(uart);
-	do {
-		if ((status & IIR_STATUS) == IIR_TX_READY)
-			bfin_serial_tx_chars(uart);
-		if ((status & IIR_STATUS) == IIR_RX_READY)
-			bfin_serial_rx_chars(uart);
-		status = UART_GET_IIR(uart);
-	} while (status & (IIR_TX_READY | IIR_RX_READY));
+	while ((UART_GET_IIR(uart) & IIR_STATUS) == IIR_TX_READY)
+		bfin_serial_tx_chars(uart);
 	spin_unlock(&uart->port.lock);
 	return IRQ_HANDLED;
 }
 
+
 static void bfin_serial_do_work(struct work_struct *work)
 {
 	struct bfin_serial_port *uart = container_of(work, struct bfin_serial_port, cts_workqueue);
@@ -545,14 +551,14 @@ static int bfin_serial_startup(struct uart_port *port)
 	add_timer(&(uart->rx_dma_timer));
 #else
 	if (request_irq
-	    (uart->port.irq, bfin_serial_int, IRQF_DISABLED,
+	    (uart->port.irq, bfin_serial_rx_int, IRQF_DISABLED,
 	     "BFIN_UART_RX", uart)) {
 		printk(KERN_NOTICE "Unable to attach BlackFin UART RX interrupt\n");
 		return -EBUSY;
 	}
 
 	if (request_irq
-	    (uart->port.irq+1, bfin_serial_int, IRQF_DISABLED,
+	    (uart->port.irq+1, bfin_serial_tx_int, IRQF_DISABLED,
 	     "BFIN_UART_TX", uart)) {
 		printk(KERN_NOTICE "Unable to attach BlackFin UART TX interrupt\n");
 		free_irq(uart->port.irq, uart);
-- 
1.5.1.2
