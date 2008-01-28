Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYA1LtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYA1LtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYA1Lsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:48:54 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62117 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750798AbYA1Lsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:48:53 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux@maxim.org.za, linux@bohmer.net, coldwell@redhat.com,
       linux-kernel@vger.kernel.org, marc.pignat@hevs.ch, david-b@pacbell.net,
       alan@lxorguk.ukuu.org.uk, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH -mm] atmel_serial dma: Misc fixes and cleanups
Date: Mon, 28 Jan 2008 12:48:50 +0100
Message-Id: <1201520930-17183-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080128124125.5c4e0a31@dhcp-252-066.norway.atmel.com>
References: <20080128124125.5c4e0a31@dhcp-252-066.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some issues identified by Andrew Morton:
  * Kill unused PDC_RX_BUF() and PDC_RX_SWITCH() macros
  * Simplify TX circ buffer management a bit.
  * Don't open-code min()
  * Add comment explaining why "count = head - tail" will not cause
    wraparound problems.

Also, s/SERIAL_XMIT_SIZE/UART_XMIT_SIZE/ since the latter is what the
serial core circ macros use.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
Please fold into atmel_serial-add-dma-support.patch, or let me know if
you want a replacement for that patch.

 drivers/serial/atmel_serial.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 63505cc..62654ab 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -114,7 +114,7 @@ static void (*atmel_close_hook)(struct uart_port *);
 struct atmel_dma_buffer {
 	unsigned char	*buf;
 	dma_addr_t	dma_addr;
-	size_t		dma_size;
+	unsigned int	dma_size;
 	unsigned int	ofs;
 };
 
@@ -150,9 +150,6 @@ struct atmel_uart_port {
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
 
-#define PDC_RX_BUF(port)	&(port)->pdc_rx[(port)->pdc_rx_idx]
-#define PDC_RX_SWITCH(port)	(port)->pdc_rx_idx = !(port)->pdc_rx_idx
-
 #ifdef SUPPORT_SYSRQ
 static struct console atmel_console;
 #endif
@@ -567,8 +564,7 @@ static void atmel_tx_dma(struct uart_port *port)
 	int count;
 
 	xmit->tail += pdc->ofs;
-	if (xmit->tail >= SERIAL_XMIT_SIZE)
-		xmit->tail -= SERIAL_XMIT_SIZE;
+	xmit->tail &= UART_XMIT_SIZE - 1;
 
 	port->icount.tx += pdc->ofs;
 	pdc->ofs = 0;
@@ -583,10 +579,7 @@ static void atmel_tx_dma(struct uart_port *port)
 					   pdc->dma_size,
 					   DMA_TO_DEVICE);
 
-		if (xmit->tail < xmit->head)
-			count = xmit->head - xmit->tail;
-		else
-			count = SERIAL_XMIT_SIZE - xmit->tail;
+		count = CIRC_CNT_TO_END(xmit->head, xmit->tail, UART_XMIT_SIZE);
 		pdc->ofs = count;
 
 		UART_PUT_TPR(port, pdc->dma_addr + xmit->tail);
@@ -701,14 +694,20 @@ static void atmel_rx_from_dma(struct uart_port *port)
 		 * ENDRX bit as well, so that we can safely re-enable
 		 * all interrupts below.
 		 */
-		if (head >= pdc->dma_size)
-			head = pdc->dma_size;
+		head = min(head, pdc->dma_size);
 
 		if (likely(head != tail)) {
 			dma_sync_single_for_cpu(port->dev, pdc->dma_addr,
 					pdc->dma_size, DMA_FROM_DEVICE);
 
+			/*
+			 * head will only wrap around when we recycle
+			 * the DMA buffer, and when that happens, we
+			 * explicitly set tail to 0. So head will
+			 * always be greater than tail.
+			 */
 			count = head - tail;
+
 			tty_insert_flip_string(tty, pdc->buf + pdc->ofs, count);
 
 			dma_sync_single_for_device(port->dev, pdc->dma_addr,
@@ -859,9 +858,9 @@ static int atmel_startup(struct uart_port *port)
 		pdc->buf = xmit->buf;
 		pdc->dma_addr = dma_map_single(port->dev,
 					       pdc->buf,
-					       SERIAL_XMIT_SIZE,
+					       UART_XMIT_SIZE,
 					       DMA_TO_DEVICE);
-		pdc->dma_size = SERIAL_XMIT_SIZE;
+		pdc->dma_size = UART_XMIT_SIZE;
 		pdc->ofs = 0;
 	}
 
-- 
1.5.3.8

