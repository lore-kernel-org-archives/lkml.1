Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbYJPRq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbYJPRq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbYJPRo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:44:59 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:21761 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbYJPRo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=JMqXJUH2BbZo67g177IfiHT6uJ2Iy0L4u1LjsMk8pTCou3pqEefCmiJGQ4DnScJyPS
         WUwIUznKIvnrg+/dIoeCdaoeyRXEtbZB32PZSX0VY0Z8ORZf+FMLPZqVNCQqtDYdHLVv
         D2s7oQ4iami100p1nZLgH1LeM01pFTR7pAOlc=
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 6/9] Blackfin Serial Driver: Fix bug - BF527-EZKIT unable to receive large files over UART in DMA mode
Date: Fri, 17 Oct 2008 01:44:04 +0800
Message-Id: <1224179047-13073-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
References: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Add spin_lock_irqsave() when receive and transfer data.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 44a0855..82854d7 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -82,7 +82,9 @@ static void bfin_serial_reset_irda(struct uart_port *port);
 static void bfin_serial_stop_tx(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+#ifdef CONFIG_SERIAL_BFIN_DMA
 	struct circ_buf *xmit = &uart->port.info->xmit;
+#endif
 
 	while (!(UART_GET_LSR(uart) & TEMT))
 		cpu_relax();
@@ -413,7 +415,9 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
 
 void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 {
-	int x_pos, pos;
+	int x_pos, pos, flags;
+
+	spin_lock_irqsave(&uart->port.lock, flags);
 
 	uart->rx_dma_nrows = get_dma_curr_ycount(uart->rx_dma_channel);
 	x_pos = get_dma_curr_xcount(uart->rx_dma_channel);
@@ -431,6 +435,8 @@ void bfin_serial_rx_dma_timeout(struct bfin_serial_port *uart)
 		uart->rx_dma_buf.tail = uart->rx_dma_buf.head;
 	}
 
+	spin_unlock_irqrestore(&uart->port.lock, flags);
+
 	mod_timer(&(uart->rx_dma_timer), jiffies + DMA_RX_FLUSH_JIFFIES);
 }
 
@@ -465,10 +471,9 @@ static irqreturn_t bfin_serial_dma_rx_int(int irq, void *dev_id)
 	spin_lock(&uart->port.lock);
 	irqstat = get_dma_curr_irqstat(uart->rx_dma_channel);
 	clear_dma_irqstat(uart->rx_dma_channel);
+	bfin_serial_dma_rx_chars(uart);
 	spin_unlock(&uart->port.lock);
 
-	mod_timer(&(uart->rx_dma_timer), jiffies);
-
 	return IRQ_HANDLED;
 }
 #endif
-- 
1.5.6

