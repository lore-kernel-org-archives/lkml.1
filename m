Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXLSPMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXLSPMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXLSPMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:12:16 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:64444 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754460AbXLSPMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:12:14 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>, linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, Chip Coldwell <coldwell@redhat.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH v2 6/6] atmel_serial: Add DMA support
Date: Wed, 19 Dec 2007 16:12:10 +0100
Message-Id: <1198077130-9021-7-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198077130-9021-6-git-send-email-hskinnemoen@atmel.com>
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
 <1198077130-9021-2-git-send-email-hskinnemoen@atmel.com>
 <1198077130-9021-3-git-send-email-hskinnemoen@atmel.com>
 <1198077130-9021-4-git-send-email-hskinnemoen@atmel.com>
 <1198077130-9021-5-git-send-email-hskinnemoen@atmel.com>
 <1198077130-9021-6-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chip Coldwell <coldwell@redhat.com>

This patch is based on the DMA-patch by Chip Coldwell for the
AT91/AT32 serial USARTS, with some tweaks to make it apply neatly on
top of the other patches in this series.

The RX and TX code has been moved to a tasklet and reworked a bit.
Instead of depending on the ENDRX and TIMEOUT bits in CSR, we simply
grab as much data as we can from the DMA buffers. I think this closes
a race where the ENDRX bit is set after we read CSR but before we read
RPR, although I haven't confirmed this.

Similarly, the two TX handlers (ENDTX and TXBUFE) have been combined
into one. Since the current code only uses a single TX buffer, there's
no point in handling those interrupts separately.

This also fixes a DMA sync bug in the original patch.

[linux@bohmer.net: rebased onto irq-splitup patch]
[hskinnemoen@atmel.com: moved to tasklet, fixed dma bug, misc cleanups]
Signed-off-by: Remy Bohmer <linux@bohmer.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |  390 ++++++++++++++++++++++++++++++++++++++---
 1 files changed, 365 insertions(+), 25 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 0013c6a..7967054 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -7,6 +7,8 @@
  *  Based on drivers/char/serial_sa1100.c, by Deep Blue Solutions Ltd.
  *  Based on drivers/char/serial.c, by Linus Torvalds, Theodore Ts'o.
  *
+ *  DMA support added by Chip Coldwell.
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -33,6 +35,7 @@
 #include <linux/sysrq.h>
 #include <linux/tty_flip.h>
 #include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
 #include <linux/atmel_pdc.h>
 
 #include <asm/io.h>
@@ -47,6 +50,11 @@
 
 #include "atmel_serial.h"
 
+#define SUPPORT_PDC
+#define PDC_BUFFER_SIZE		(L1_CACHE_BYTES << 3)
+#warning "Revisit"
+#define PDC_RX_TIMEOUT		(3 * 10)		/* 3 bytes */
+
 #if defined(CONFIG_SERIAL_ATMEL_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
 #define SUPPORT_SYSRQ
 #endif
@@ -111,6 +119,13 @@
 static int (*atmel_open_hook) (struct uart_port *);
 static void (*atmel_close_hook) (struct uart_port *);
 
+struct atmel_dma_buffer {
+	unsigned char	*buf;
+	dma_addr_t	dma_addr;
+	size_t		dma_size;
+	unsigned int	ofs;
+};
+
 struct atmel_uart_char {
 	u16		status;
 	u16		ch;
@@ -127,6 +142,13 @@ struct atmel_uart_port {
 	unsigned short		suspended;	/* is port suspended? */
 	int			break_active;	/* break being received */
 
+	short			use_dma_rx;	/* enable PDC receiver */
+	short			pdc_rx_idx;	/* current PDC RX buffer */
+	struct atmel_dma_buffer	pdc_rx[2];	/* PDC receier */
+
+	short			use_dma_tx;	/* enable PDC transmitter */
+	struct atmel_dma_buffer	pdc_tx;		/* PDC transmitter */
+
 	struct tasklet_struct	tasklet;
 	unsigned int		irq_status;
 	unsigned int		irq_status_prev;
@@ -136,10 +158,39 @@ struct atmel_uart_port {
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
 
+#define PDC_RX_BUF(port)	&(port)->pdc_rx[(port)->pdc_rx_idx]
+#define PDC_RX_SWITCH(port)	(port)->pdc_rx_idx = !(port)->pdc_rx_idx
+
 #ifdef SUPPORT_SYSRQ
 static struct console atmel_console;
 #endif
 
+#ifdef SUPPORT_PDC
+static bool atmel_use_dma_rx(struct uart_port *port)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+
+	return atmel_port->use_dma_rx;
+}
+
+static bool atmel_use_dma_tx(struct uart_port *port)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+
+	return atmel_port->use_dma_tx;
+}
+#else
+static bool atmel_use_dma_rx(struct uart_port *port)
+{
+	return false;
+}
+
+static bool atmel_use_dma_tx(struct uart_port *port)
+{
+	return false;
+}
+#endif
+
 /*
  * Return TIOCSER_TEMT when transmitter FIFO and Shift register is empty.
  */
@@ -221,7 +272,12 @@ static u_int atmel_get_mctrl(struct uart_port *port)
  */
 static void atmel_stop_tx(struct uart_port *port)
 {
-	UART_PUT_IDR(port, ATMEL_US_TXRDY);
+	if (atmel_use_dma_tx(port)) {
+		/* disable PDC transmit */
+		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
+		UART_PUT_IDR(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
+	} else
+		UART_PUT_IDR(port, ATMEL_US_TXRDY);
 }
 
 /*
@@ -229,7 +285,17 @@ static void atmel_stop_tx(struct uart_port *port)
  */
 static void atmel_start_tx(struct uart_port *port)
 {
-	UART_PUT_IER(port, ATMEL_US_TXRDY);
+	if (atmel_use_dma_tx(port)) {
+		if (UART_GET_PTSR(port) & ATMEL_PDC_TXTEN)
+			/* The transmitter is already running.  Yes, we
+			   really need this.*/
+			return;
+
+		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
+		/* re-enable PDC transmit */
+		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
+	} else
+		UART_PUT_IER(port, ATMEL_US_TXRDY);
 }
 
 /*
@@ -237,7 +303,12 @@ static void atmel_start_tx(struct uart_port *port)
  */
 static void atmel_stop_rx(struct uart_port *port)
 {
-	UART_PUT_IDR(port, ATMEL_US_RXRDY);
+	if (atmel_use_dma_rx(port)) {
+		/* disable PDC receive */
+		UART_PUT_PTCR(port, ATMEL_PDC_RXTDIS);
+		UART_PUT_IDR(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT);
+	} else
+		UART_PUT_IDR(port, ATMEL_US_RXRDY);
 }
 
 /*
@@ -286,6 +357,27 @@ atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
 }
 
 /*
+ * Deal with parity, framing and overrun errors.
+ */
+static void atmel_pdc_rxerr(struct uart_port *port, unsigned int status)
+{
+	/* clear error */
+	UART_PUT_CR(port, ATMEL_US_RSTSTA);
+
+	if (status & ATMEL_US_RXBRK) {
+		/* ignore side-effect */
+		status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);
+		port->icount.brk++;
+	}
+	if (status & ATMEL_US_PARE)
+		port->icount.parity++;
+	if (status & ATMEL_US_FRAME)
+		port->icount.frame++;
+	if (status & ATMEL_US_OVRE)
+		port->icount.overrun++;
+}
+
+/*
  * Characters received (called from interrupt handler)
  */
 static void atmel_rx_chars(struct uart_port *port)
@@ -372,6 +464,25 @@ atmel_handle_receive(struct uart_port *port, unsigned int pending)
 {
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
+	if (atmel_use_dma_rx(port)) {
+		/*
+		 * PDC receive. Just schedule the tasklet and let it
+		 * figure out the details.
+		 *
+		 * TODO: We're not handling error flags correctly at
+		 * the moment.
+		 */
+		if (pending & (ATMEL_US_ENDRX | ATMEL_US_TIMEOUT)) {
+			UART_PUT_IDR(port, (ATMEL_US_ENDRX
+						| ATMEL_US_TIMEOUT));
+			tasklet_schedule(&atmel_port->tasklet);
+		}
+
+		if (pending & (ATMEL_US_RXBRK | ATMEL_US_OVRE |
+				ATMEL_US_FRAME | ATMEL_US_PARE))
+			atmel_pdc_rxerr(port, pending);
+	}
+
 	/* Interrupt receive */
 	if (pending & ATMEL_US_RXRDY)
 		atmel_rx_chars(port);
@@ -394,10 +505,18 @@ atmel_handle_transmit(struct uart_port *port, unsigned int pending)
 {
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
-	/* Interrupt transmit */
-	if (pending & ATMEL_US_TXRDY) {
-		UART_PUT_IDR(port, ATMEL_US_TXRDY);
-		tasklet_schedule(&atmel_port->tasklet);
+	if (atmel_use_dma_tx(port)) {
+		/* PDC transmit */
+		if (pending & (ATMEL_US_ENDTX | ATMEL_US_TXBUFE)) {
+			UART_PUT_IDR(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
+			tasklet_schedule(&atmel_port->tasklet);
+		}
+	} else {
+		/* Interrupt transmit */
+		if (pending & ATMEL_US_TXRDY) {
+			UART_PUT_IDR(port, ATMEL_US_TXRDY);
+			tasklet_schedule(&atmel_port->tasklet);
+		}
 	}
 }
 
@@ -425,20 +544,67 @@ static irqreturn_t atmel_interrupt(int irq, void *dev_id)
 	struct uart_port *port = dev_id;
 	unsigned int status, pending, pass_counter = 0;
 
-	status = UART_GET_CSR(port);
-	pending = status & UART_GET_IMR(port);
-	while (pending) {
+	do {
+		status = UART_GET_CSR(port);
+		pending = status & UART_GET_IMR(port);
+		if (!pending)
+			break;
+
 		atmel_handle_receive(port, pending);
 		atmel_handle_status(port, pending, status);
 		atmel_handle_transmit(port, pending);
+	} while (pass_counter++ < ATMEL_ISR_PASS_LIMIT);
 
-		if (pass_counter++ > ATMEL_ISR_PASS_LIMIT)
-			break;
+	return IRQ_HANDLED;
+}
 
-		status = UART_GET_CSR(port);
-		pending = status & UART_GET_IMR(port);
+/*
+ * Called from tasklet with ENDTX and TXBUFE interrupts disabled.
+ */
+static void atmel_tx_dma(struct uart_port *port)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct circ_buf *xmit = &port->info->xmit;
+	struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
+	int count;
+
+	xmit->tail += pdc->ofs;
+	if (xmit->tail >= SERIAL_XMIT_SIZE)
+		xmit->tail -= SERIAL_XMIT_SIZE;
+
+	port->icount.tx += pdc->ofs;
+	pdc->ofs = 0;
+
+	if (!uart_circ_empty(xmit)) {
+		/* more to transmit - setup next transfer */
+
+		/* disable PDC transmit */
+		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
+		dma_sync_single_for_device(port->dev,
+					   pdc->dma_addr,
+					   pdc->dma_size,
+					   DMA_TO_DEVICE);
+
+		if (xmit->tail < xmit->head)
+			count = xmit->head - xmit->tail;
+		else
+			count = SERIAL_XMIT_SIZE - xmit->tail;
+		pdc->ofs = count;
+
+		UART_PUT_TPR(port, pdc->dma_addr + xmit->tail);
+		UART_PUT_TCR(port, count);
+		/* re-enable PDC transmit and interrupts */
+		UART_PUT_PTCR(port, ATMEL_PDC_TXTEN);
+		UART_PUT_IER(port, ATMEL_US_ENDTX | ATMEL_US_TXBUFE);
+	} else {
+		/* nothing left to transmit - disable the transmitter */
+
+		/* disable PDC transmit */
+		UART_PUT_PTCR(port, ATMEL_PDC_TXTDIS);
 	}
-	return IRQ_HANDLED;
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(port);
 }
 
 static void atmel_rx_from_ring(struct uart_port *port)
@@ -503,6 +669,70 @@ static void atmel_rx_from_ring(struct uart_port *port)
 	tty_flip_buffer_push(port->info->tty);
 }
 
+static void atmel_rx_from_dma(struct uart_port *port)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct tty_struct *tty = port->info->tty;
+	struct atmel_dma_buffer *pdc;
+	int rx_idx = atmel_port->pdc_rx_idx;
+	unsigned int head;
+	unsigned int tail;
+	unsigned int count;
+
+	do {
+		/* Reset the UART timeout early so that we don't miss one */
+		UART_PUT_CR(port, ATMEL_US_STTTO);
+
+		pdc = &atmel_port->pdc_rx[rx_idx];
+		head = UART_GET_RPR(port) - pdc->dma_addr;
+		tail = pdc->ofs;
+
+		/* If the PDC has switched buffers, RPR won't contain
+		 * any address within the current buffer. Since head
+		 * is unsigned, we just need a one-way comparison to
+		 * find out.
+		 *
+		 * In this case, we just need to consume the entire
+		 * buffer and resubmit it for DMA. This will clear the
+		 * ENDRX bit as well, so that we can safely re-enable
+		 * all interrupts below.
+		 */
+		if (head >= pdc->dma_size)
+			head = pdc->dma_size;
+
+		if (likely(head != tail)) {
+			dma_sync_single_for_cpu(port->dev, pdc->dma_addr,
+					pdc->dma_size, DMA_FROM_DEVICE);
+
+			count = head - tail;
+			tty_insert_flip_string(tty, pdc->buf + pdc->ofs, count);
+
+			dma_sync_single_for_device(port->dev, pdc->dma_addr,
+					pdc->dma_size, DMA_FROM_DEVICE);
+
+			port->icount.rx += count;
+			pdc->ofs = head;
+		}
+
+		/*
+		 * If the current buffer is full, we need to check if
+		 * the next one contains any additional data.
+		 */
+		if (head >= pdc->dma_size) {
+			pdc->ofs = 0;
+			UART_PUT_RNPR(port, pdc->dma_addr);
+			UART_PUT_RNCR(port, pdc->dma_size);
+
+			rx_idx = !rx_idx;
+			atmel_port->pdc_rx_idx = rx_idx;
+		}
+	} while (head >= pdc->dma_size);
+
+	tty_flip_buffer_push(tty);
+
+	UART_PUT_IER(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT);
+}
+
 /*
  * tasklet handling tty stuff outside the interrupt handler.
  */
@@ -516,7 +746,10 @@ static void atmel_tasklet_func(unsigned long data)
 	/* The interrupt handler does not take the lock */
 	spin_lock(&port->lock);
 
-	atmel_tx_chars(port);
+	if (atmel_use_dma_tx(port))
+		atmel_tx_dma(port);
+	else
+		atmel_tx_chars(port);
 
 	status = atmel_port->irq_status;
 	status_change = status ^ atmel_port->irq_status_prev;
@@ -538,7 +771,10 @@ static void atmel_tasklet_func(unsigned long data)
 		atmel_port->irq_status_prev = status;
 	}
 
-	atmel_rx_from_ring(port);
+	if (atmel_use_dma_rx(port))
+		atmel_rx_from_dma(port);
+	else
+		atmel_rx_from_ring(port);
 
 	spin_unlock(&port->lock);
 }
@@ -548,6 +784,7 @@ static void atmel_tasklet_func(unsigned long data)
  */
 static int atmel_startup(struct uart_port *port)
 {
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 	int retval;
 
 	/*
@@ -568,6 +805,56 @@ static int atmel_startup(struct uart_port *port)
 	}
 
 	/*
+	 * Initialize DMA (if necessary)
+	 */
+	if (atmel_use_dma_rx(port)) {
+		int i;
+
+		for (i = 0; i < 2; i++) {
+			struct atmel_dma_buffer *pdc = &atmel_port->pdc_rx[i];
+
+			pdc->buf = kmalloc(PDC_BUFFER_SIZE, GFP_KERNEL);
+			if (pdc->buf == NULL) {
+				if (i != 0) {
+					dma_unmap_single(port->dev,
+						atmel_port->pdc_rx[0].dma_addr,
+						PDC_BUFFER_SIZE,
+						DMA_FROM_DEVICE);
+					kfree(atmel_port->pdc_rx[0].buf);
+				}
+				free_irq(port->irq, port);
+				return -ENOMEM;
+			}
+			pdc->dma_addr = dma_map_single(port->dev,
+						       pdc->buf,
+						       PDC_BUFFER_SIZE,
+						       DMA_FROM_DEVICE);
+			pdc->dma_size = PDC_BUFFER_SIZE;
+			pdc->ofs = 0;
+		}
+
+		atmel_port->pdc_rx_idx = 0;
+
+		UART_PUT_RPR(port, atmel_port->pdc_rx[0].dma_addr);
+		UART_PUT_RCR(port, PDC_BUFFER_SIZE);
+
+		UART_PUT_RNPR(port, atmel_port->pdc_rx[1].dma_addr);
+		UART_PUT_RNCR(port, PDC_BUFFER_SIZE);
+	}
+	if (atmel_use_dma_tx(port)) {
+		struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
+		struct circ_buf *xmit = &port->info->xmit;
+
+		pdc->buf = xmit->buf;
+		pdc->dma_addr = dma_map_single(port->dev,
+					       pdc->buf,
+					       SERIAL_XMIT_SIZE,
+					       DMA_TO_DEVICE);
+		pdc->dma_size = SERIAL_XMIT_SIZE;
+		pdc->ofs = 0;
+	}
+
+	/*
 	 * If there is a specific "open" function (to register
 	 * control line interrupts)
 	 */
@@ -586,8 +873,18 @@ static int atmel_startup(struct uart_port *port)
 	/* enable xmit & rcvr */
 	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);
 
-	/* enable receive only */
-	UART_PUT_IER(port, ATMEL_US_RXRDY);
+	if (atmel_use_dma_rx(port)) {
+		/* set UART timeout */
+		UART_PUT_RTOR(port, PDC_RX_TIMEOUT);
+		UART_PUT_CR(port, ATMEL_US_STTTO);
+
+		UART_PUT_IER(port, ATMEL_US_ENDRX | ATMEL_US_TIMEOUT);
+		/* enable PDC controller */
+		UART_PUT_PTCR(port, ATMEL_PDC_RXTEN);
+	} else {
+		/* enable receive only */
+		UART_PUT_IER(port, ATMEL_US_RXRDY);
+	}
 
 	return 0;
 }
@@ -597,6 +894,38 @@ static int atmel_startup(struct uart_port *port)
  */
 static void atmel_shutdown(struct uart_port *port)
 {
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	/*
+	 * Ensure everything is stopped.
+	 */
+	atmel_stop_rx(port);
+	atmel_stop_tx(port);
+
+	/*
+	 * Shut-down the DMA.
+	 */
+	if (atmel_use_dma_rx(port)) {
+		int i;
+
+		for (i = 0; i < 2; i++) {
+			struct atmel_dma_buffer *pdc = &atmel_port->pdc_rx[i];
+
+			dma_unmap_single(port->dev,
+					 pdc->dma_addr,
+					 pdc->dma_size,
+					 DMA_FROM_DEVICE);
+			kfree(pdc->buf);
+		}
+	}
+	if (atmel_use_dma_tx(port)) {
+		struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
+
+		dma_unmap_single(port->dev,
+				 pdc->dma_addr,
+				 pdc->dma_size,
+				 DMA_TO_DEVICE);
+	}
+
 	/*
 	 * Disable all interrupts, port and break condition.
 	 */
@@ -708,6 +1037,10 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (termios->c_iflag & (BRKINT | PARMRK))
 		port->read_status_mask |= ATMEL_US_RXBRK;
 
+	if (atmel_use_dma_rx(port))
+		/* need to enable error interrupts */
+		UART_PUT_IER(port, port->read_status_mask);
+
 	/*
 	 * Characters to ignore
 	 */
@@ -893,6 +1226,11 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 		clk_enable(atmel_port->clk);
 		port->uartclk = clk_get_rate(atmel_port->clk);
 	}
+
+	atmel_port->use_dma_rx = data->use_dma_rx;
+	atmel_port->use_dma_tx = data->use_dma_tx;
+	if (atmel_use_dma_tx(port))
+		port->fifosize = PDC_BUFFER_SIZE;
 }
 
 /*
@@ -1087,7 +1425,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
 	if (device_may_wakeup(&pdev->dev)
-	    && !at91_suspend_entering_slow_clock())
+		&& !clk_must_disable(atmel_port->clk))
 		enable_irq_wake(port->irq);
 	else {
 		uart_suspend_port(&atmel_uart, port);
@@ -1126,11 +1464,13 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	port = &atmel_ports[pdev->id];
 	atmel_init_port(port, pdev);
 
-	ret = -ENOMEM;
-	data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
-	if (!data)
-		goto err_alloc_ring;
-	port->rx_ring.buf = data;
+	if (!atmel_use_dma_rx(&port->uart)) {
+		ret = -ENOMEM;
+		data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
+		if (!data)
+			goto err_alloc_ring;
+		port->rx_ring.buf = data;
+	}
 
 	ret = uart_add_one_port(&atmel_uart, &port->uart);
 	if (ret)
-- 
1.5.3.4

