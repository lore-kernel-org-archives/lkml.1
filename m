Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbZFVQqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbZFVQqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZFVQpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:45:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53534 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757680AbZFVQpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:45:05 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 13/15] timbuart: Fix for tx_empty
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:43:03 +0100
Message-ID: <20090622174301.25341.91770.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>

Hardware updated to support TX FIFO empty.

Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/timbuart.c |   50 +++++++++++++++++++++++----------------------
 1 files changed, 25 insertions(+), 25 deletions(-)


diff --git a/drivers/serial/timbuart.c b/drivers/serial/timbuart.c
index ac9e5d5..063a313 100644
--- a/drivers/serial/timbuart.c
+++ b/drivers/serial/timbuart.c
@@ -33,29 +33,29 @@ struct timbuart_port {
 	struct uart_port	port;
 	struct tasklet_struct	tasklet;
 	int			usedma;
-	u8			last_ier;
+	u32			last_ier;
 	struct platform_device  *dev;
 };
 
 static int baudrates[] = {9600, 19200, 38400, 57600, 115200, 230400, 460800,
 	921600, 1843200, 3250000};
 
-static void timbuart_mctrl_check(struct uart_port *port, u8 isr, u8 *ier);
+static void timbuart_mctrl_check(struct uart_port *port, u32 isr, u32 *ier);
 
 static irqreturn_t timbuart_handleinterrupt(int irq, void *devid);
 
 static void timbuart_stop_rx(struct uart_port *port)
 {
 	/* spin lock held by upper layer, disable all RX interrupts */
-	u8 ier = ioread8(port->membase + TIMBUART_IER) & ~RXFLAGS;
-	iowrite8(ier, port->membase + TIMBUART_IER);
+	u32 ier = ioread32(port->membase + TIMBUART_IER) & ~RXFLAGS;
+	iowrite32(ier, port->membase + TIMBUART_IER);
 }
 
 static void timbuart_stop_tx(struct uart_port *port)
 {
 	/* spinlock held by upper layer, disable TX interrupt */
-	u8 ier = ioread8(port->membase + TIMBUART_IER) & ~TXBAE;
-	iowrite8(ier, port->membase + TIMBUART_IER);
+	u32 ier = ioread32(port->membase + TIMBUART_IER) & ~TXBAE;
+	iowrite32(ier, port->membase + TIMBUART_IER);
 }
 
 static void timbuart_start_tx(struct uart_port *port)
@@ -72,14 +72,14 @@ static void timbuart_flush_buffer(struct uart_port *port)
 	u8 ctl = ioread8(port->membase + TIMBUART_CTRL) | TIMBUART_CTRL_FLSHTX;
 
 	iowrite8(ctl, port->membase + TIMBUART_CTRL);
-	iowrite8(TXBF, port->membase + TIMBUART_ISR);
+	iowrite32(TXBF, port->membase + TIMBUART_ISR);
 }
 
 static void timbuart_rx_chars(struct uart_port *port)
 {
 	struct tty_struct *tty = port->info->port.tty;
 
-	while (ioread8(port->membase + TIMBUART_ISR) & RXDP) {
+	while (ioread32(port->membase + TIMBUART_ISR) & RXDP) {
 		u8 ch = ioread8(port->membase + TIMBUART_RXFIFO);
 		port->icount.rx++;
 		tty_insert_flip_char(tty, ch, TTY_NORMAL);
@@ -97,7 +97,7 @@ static void timbuart_tx_chars(struct uart_port *port)
 {
 	struct circ_buf *xmit = &port->info->xmit;
 
-	while (!(ioread8(port->membase + TIMBUART_ISR) & TXBF) &&
+	while (!(ioread32(port->membase + TIMBUART_ISR) & TXBF) &&
 		!uart_circ_empty(xmit)) {
 		iowrite8(xmit->buf[xmit->tail],
 			port->membase + TIMBUART_TXFIFO);
@@ -114,7 +114,7 @@ static void timbuart_tx_chars(struct uart_port *port)
 		ioread8(port->membase + TIMBUART_BAUDRATE));
 }
 
-static void timbuart_handle_tx_port(struct uart_port *port, u8 isr, u8 *ier)
+static void timbuart_handle_tx_port(struct uart_port *port, u32 isr, u32 *ier)
 {
 	struct timbuart_port *uart =
 		container_of(port, struct timbuart_port, port);
@@ -129,7 +129,7 @@ static void timbuart_handle_tx_port(struct uart_port *port, u8 isr, u8 *ier)
 	if (isr & TXFLAGS) {
 		timbuart_tx_chars(port);
 		/* clear all TX interrupts */
-		iowrite8(TXFLAGS, port->membase + TIMBUART_ISR);
+		iowrite32(TXFLAGS, port->membase + TIMBUART_ISR);
 
 		if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 			uart_write_wakeup(port);
@@ -148,7 +148,7 @@ static void timbuart_handle_tx_port(struct uart_port *port, u8 isr, u8 *ier)
 	dev_dbg(port->dev, "%s - leaving\n", __func__);
 }
 
-void timbuart_handle_rx_port(struct uart_port *port, u8 isr, u8 *ier)
+void timbuart_handle_rx_port(struct uart_port *port, u32 isr, u32 *ier)
 {
 	if (isr & RXFLAGS) {
 		/* Some RX status is set */
@@ -161,7 +161,7 @@ void timbuart_handle_rx_port(struct uart_port *port, u8 isr, u8 *ier)
 			timbuart_rx_chars(port);
 
 		/* ack all RX interrupts */
-		iowrite8(RXFLAGS, port->membase + TIMBUART_ISR);
+		iowrite32(RXFLAGS, port->membase + TIMBUART_ISR);
 	}
 
 	/* always have the RX interrupts enabled */
@@ -173,11 +173,11 @@ void timbuart_handle_rx_port(struct uart_port *port, u8 isr, u8 *ier)
 void timbuart_tasklet(unsigned long arg)
 {
 	struct timbuart_port *uart = (struct timbuart_port *)arg;
-	u8 isr, ier = 0;
+	u32 isr, ier = 0;
 
 	spin_lock(&uart->port.lock);
 
-	isr = ioread8(uart->port.membase + TIMBUART_ISR);
+	isr = ioread32(uart->port.membase + TIMBUART_ISR);
 	dev_dbg(uart->port.dev, "%s ISR: %x\n", __func__, isr);
 
 	if (!uart->usedma)
@@ -188,7 +188,7 @@ void timbuart_tasklet(unsigned long arg)
 	if (!uart->usedma)
 		timbuart_handle_rx_port(&uart->port, isr, &ier);
 
-	iowrite8(ier, uart->port.membase + TIMBUART_IER);
+	iowrite32(ier, uart->port.membase + TIMBUART_IER);
 
 	spin_unlock(&uart->port.lock);
 	dev_dbg(uart->port.dev, "%s leaving\n", __func__);
@@ -196,9 +196,9 @@ void timbuart_tasklet(unsigned long arg)
 
 static unsigned int timbuart_tx_empty(struct uart_port *port)
 {
-	u8 isr = ioread8(port->membase + TIMBUART_ISR);
+	u32 isr = ioread32(port->membase + TIMBUART_ISR);
 
-	return (isr & TXBAE) ? TIOCSER_TEMT : 0;
+	return (isr & TXBE) ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int timbuart_get_mctrl(struct uart_port *port)
@@ -222,13 +222,13 @@ static void timbuart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
 }
 
-static void timbuart_mctrl_check(struct uart_port *port, u8 isr, u8 *ier)
+static void timbuart_mctrl_check(struct uart_port *port, u32 isr, u32 *ier)
 {
 	unsigned int cts;
 
 	if (isr & CTS_DELTA) {
 		/* ack */
-		iowrite8(CTS_DELTA, port->membase + TIMBUART_ISR);
+		iowrite32(CTS_DELTA, port->membase + TIMBUART_ISR);
 		cts = timbuart_get_mctrl(port);
 		uart_handle_cts_change(port, cts & TIOCM_CTS);
 		wake_up_interruptible(&port->info->delta_msr_wait);
@@ -255,9 +255,9 @@ static int timbuart_startup(struct uart_port *port)
 	dev_dbg(port->dev, "%s\n", __func__);
 
 	iowrite8(TIMBUART_CTRL_FLSHRX, port->membase + TIMBUART_CTRL);
-	iowrite8(0xff, port->membase + TIMBUART_ISR);
+	iowrite32(0x1ff, port->membase + TIMBUART_ISR);
 	/* Enable all but TX interrupts */
-	iowrite8(RXBAF | RXBF | RXTT | CTS_DELTA,
+	iowrite32(RXBAF | RXBF | RXTT | CTS_DELTA,
 		port->membase + TIMBUART_IER);
 
 	return request_irq(port->irq, timbuart_handleinterrupt, IRQF_SHARED,
@@ -270,7 +270,7 @@ static void timbuart_shutdown(struct uart_port *port)
 		container_of(port, struct timbuart_port, port);
 	dev_dbg(port->dev, "%s\n", __func__);
 	free_irq(port->irq, uart);
-	iowrite8(0, port->membase + TIMBUART_IER);
+	iowrite32(0, port->membase + TIMBUART_IER);
 }
 
 static int get_bindex(int baud)
@@ -359,10 +359,10 @@ static irqreturn_t timbuart_handleinterrupt(int irq, void *devid)
 	struct timbuart_port *uart = (struct timbuart_port *)devid;
 
 	if (ioread8(uart->port.membase + TIMBUART_IPR)) {
-		uart->last_ier = ioread8(uart->port.membase + TIMBUART_IER);
+		uart->last_ier = ioread32(uart->port.membase + TIMBUART_IER);
 
 		/* disable interrupts, the tasklet enables them again */
-		iowrite8(0, uart->port.membase + TIMBUART_IER);
+		iowrite32(0, uart->port.membase + TIMBUART_IER);
 
 		/* fire off bottom half */
 		tasklet_schedule(&uart->tasklet);

