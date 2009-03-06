Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZCFGqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZCFGqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZCFGlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:11 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:39798 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbZCFGkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:55 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883648"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 05/18] Blackfin Serial Driver: fix bug - serial port transfer big file from host to target would have more lines
Date: Fri,  6 Mar 2009 14:42:47 +0800
Message-Id: <1236321780-28718-6-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Ignore receiving data if new position is in the same line of
current buffer tail and small.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 8d34ccd..5a163f6 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -407,6 +407,15 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 
 	spin_lock_irqsave(&uart->port.lock, flags);
 
+	/* 2D DMA RX buffer ring is used. Because curr_y_count and
+	 * curr_x_count can't be read as an atomic operation,
+	 * curr_y_count should be read before curr_x_count. When
+	 * curr_x_count is read, curr_y_count may already indicate
+	 * next buffer line. But, the position calculated here is
+	 * still indicate the old line. The wrong position data may
+	 * be smaller than current buffer tail, which cause garbages
+	 * are received if it is not prohibit.
+	 */
 	uart->rx_dma_nrows = get_dma_curr_ycount(uart->rx_dma_channel);
 	x_pos = get_dma_curr_xcount(uart->rx_dma_channel);
 	uart->rx_dma_nrows = DMA_RX_YCOUNT - uart->rx_dma_nrows;
@@ -417,7 +426,11 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 		x_pos = 0;
 
 	pos = uart->rx_dma_nrows * DMA_RX_XCOUNT + x_pos;
-	if (pos != uart->rx_dma_buf.tail) {
+	/* Ignore receiving data if new position is in the same line of
+	 * current buffer tail and small.
+	 */
+	if (pos > uart->rx_dma_buf.tail ||
+		uart->rx_dma_nrows < (uart->rx_dma_buf.tail/DMA_RX_XCOUNT)) {
 		uart->rx_dma_buf.head = pos;
 		bfin_serial_dma_rx_chars(uart);
 		uart->rx_dma_buf.tail = uart->rx_dma_buf.head;
@@ -455,11 +468,25 @@ static irqreturn_t bfin_serial_dma_rx_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
 	unsigned short irqstat;
+	int pos;
 
 	spin_lock(&uart->port.lock);
 	irqstat = get_dma_curr_irqstat(uart->rx_dma_channel);
 	clear_dma_irqstat(uart->rx_dma_channel);
-	bfin_serial_dma_rx_chars(uart);
+
+	uart->rx_dma_nrows = get_dma_curr_ycount(uart->rx_dma_channel);
+	uart->rx_dma_nrows = DMA_RX_YCOUNT - uart->rx_dma_nrows;
+	if (uart->rx_dma_nrows == DMA_RX_YCOUNT)
+		uart->rx_dma_nrows = 0;
+
+	pos = uart->rx_dma_nrows * DMA_RX_XCOUNT;
+	if (pos > uart->rx_dma_buf.tail ||
+		uart->rx_dma_nrows < (uart->rx_dma_buf.tail/DMA_RX_XCOUNT)) {
+		uart->rx_dma_buf.head = pos;
+		bfin_serial_dma_rx_chars(uart);
+		uart->rx_dma_buf.tail = uart->rx_dma_buf.head;
+	}
+
 	spin_unlock(&uart->port.lock);
 
 	return IRQ_HANDLED;
-- 
1.5.6.3
