Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbZFBHM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbZFBHM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbZFBHLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:11:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46624 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757238AbZFBHLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:11:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 05/11] Blackfin Serial Driver: fix error while transferring large files
Date: Tue,  2 Jun 2009 03:11:34 -0400
Message-Id: <1243926700-30485-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
References: <1243926700-30485-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Ignore receiving data if new position is in the same line of current
buffer tail and is small.  This should decrease overruns.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   31 +++++++++++++++++++++++++++++--
 1 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index d86123e..65a4c07 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -477,6 +477,15 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 
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
@@ -487,7 +496,11 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
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
@@ -532,11 +545,25 @@ static irqreturn_t bfin_serial_dma_rx_int(int irq, void *dev_id)
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
1.6.3.1

