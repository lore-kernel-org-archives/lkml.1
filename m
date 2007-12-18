Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXLROQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXLROQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:16:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXLROPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:15:53 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57344 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752058AbXLROPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:15:52 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Remy Bohmer <hskinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: Split the interrupt handler
Date: Tue, 18 Dec 2007 15:14:15 +0100
Message-Id: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Remy Bohmer <hskinnemoen@atmel.com>

This patch splits up the interrupt handler of the serial port
into a interrupt top-half and a tasklet.

The goal is to get the interrupt top-half as short as possible to
minimize latencies on interrupts. But the old code also does some
calls in the interrupt handler that are not allowed on preempt-RT
in IRQF_NODELAY context. This handler is executed in this context
because of the interrupt sharing with the timer interrupt.
The timer interrupt on Preempt-RT runs in IRQF_NODELAY context.

The tasklet takes care of handling control status changes, pushing
incoming characters to the tty layer, handling break and other errors.

The Transmit path was IRQF_NODELAY safe by itself, and is not adapted.
The read path for DMA(PDC) is also not adapted, because that code
does not run in IRQF_NODELAY context due to irq-sharing. The DBGU
which is shared with the timer-irq does not work with DMA, so
therefor this is no problem.

Reading the complete receive queue is still done in the top-half
because we never want to miss any incoming character.

This patch demands the following patches to be installed first:
* atmel_serial_cleanup.patch

[hskinnemoen@atmel.com: misc cleanups and simplifications]
Signed-off-by: Remy Bohmer <linux@bohmer.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
Changes since v1:
	Whitespace cleanups
	Allocate rx ring data separately
	Move more of the rx processing into tasklet
	Consolidate rx and status tasklets into one
	Use circ_buf instead of atmel_uart_ring
	Eliminate RX ring locking

In this version of the patch, we try to only do things that are
absolutely necessary in the interrupt handler, storing away the
status register along with the received character and letting the
tasklet handle break, sysrq, error flags, etc.

Since we don't need to store the tty flags and overrun bit, the size
of each entry in the RX ring is reduced from 16 bytes to 4 bytes.

I've also used the first SMP barrier pair in my life; hope it's
correct. I don't think we need full barriers because we don't deal
with I/O, but we need SMP barriers to get correct ordering across CPUs
and to prevent the compiler from reading things in the wrong order.

This patch should apply on top of the cleanup patch I sent earlier
today. Or at least I think so...I'll send the full series once
everyone are happy.

 drivers/serial/atmel_serial.c |  208 ++++++++++++++++++++++++++++++++---------
 1 files changed, 162 insertions(+), 46 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index bd41529..a733db5 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -111,6 +111,13 @@
 static int (*atmel_open_hook) (struct uart_port *);
 static void (*atmel_close_hook) (struct uart_port *);
 
+struct atmel_uart_char {
+	u16		status;
+	u16		ch;
+};
+
+#define ATMEL_SERIAL_RINGSIZE 1024
+
 /*
  * We wrap our port structure around the generic uart_port.
  */
@@ -119,6 +126,12 @@ struct atmel_uart_port {
 	struct clk		*clk;		/* uart clock */
 	unsigned short		suspended;	/* is port suspended? */
 	int			break_active;	/* break being received */
+
+	struct tasklet_struct	tasklet;
+	unsigned int		irq_pending;
+	unsigned int		irq_status;
+
+	struct circ_buf		rx_ring;
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
@@ -248,22 +261,42 @@ static void atmel_break_ctl(struct uart_port *port, int break_state)
 }
 
 /*
+ * Stores the incoming character in the ring buffer
+ */
+static void
+atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
+		     unsigned int ch)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct circ_buf *ring = &atmel_port->rx_ring;
+	struct atmel_uart_char *c;
+
+	if (!CIRC_SPACE(ring->head, ring->tail, ATMEL_SERIAL_RINGSIZE))
+		/* Buffer overflow, ignore char */
+		return;
+
+	c = &((struct atmel_uart_char *)ring->buf)[ring->head];
+	c->status	= status;
+	c->ch		= ch;
+
+	/* Make sure the character is stored before we update head. */
+	smp_wmb();
+
+	ring->head = (ring->head + 1) & (ATMEL_SERIAL_RINGSIZE - 1);
+}
+
+/*
  * Characters received (called from interrupt handler)
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
-	struct tty_struct *tty = port->info->tty;
-	unsigned int status, ch, flg;
+	unsigned int status, ch;
 
 	status = UART_GET_CSR(port);
 	while (status & ATMEL_US_RXRDY) {
 		ch = UART_GET_CHAR(port);
 
-		port->icount.rx++;
-
-		flg = TTY_NORMAL;
-
 		/*
 		 * note that the error handling code is
 		 * out of the main execution path
@@ -271,17 +304,14 @@ static void atmel_rx_chars(struct uart_port *port)
 		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME
 				       | ATMEL_US_OVRE | ATMEL_US_RXBRK)
 			     || atmel_port->break_active)) {
+
 			/* clear error */
 			UART_PUT_CR(port, ATMEL_US_RSTSTA);
+
 			if (status & ATMEL_US_RXBRK
 			    && !atmel_port->break_active) {
-				/* ignore side-effect */
-				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);
-				port->icount.brk++;
 				atmel_port->break_active = 1;
 				UART_PUT_IER(port, ATMEL_US_RXBRK);
-				if (uart_handle_break(port))
-					goto ignore_char;
 			} else {
 				/*
 				 * This is either the end-of-break
@@ -294,33 +324,13 @@ static void atmel_rx_chars(struct uart_port *port)
 				status &= ~ATMEL_US_RXBRK;
 				atmel_port->break_active = 0;
 			}
-			if (status & ATMEL_US_PARE)
-				port->icount.parity++;
-			if (status & ATMEL_US_FRAME)
-				port->icount.frame++;
-			if (status & ATMEL_US_OVRE)
-				port->icount.overrun++;
-
-			status &= port->read_status_mask;
-
-			if (status & ATMEL_US_RXBRK)
-				flg = TTY_BREAK;
-			else if (status & ATMEL_US_PARE)
-				flg = TTY_PARITY;
-			else if (status & ATMEL_US_FRAME)
-				flg = TTY_FRAME;
 		}
 
-		if (uart_handle_sysrq_char(port, ch))
-			goto ignore_char;
-
-		uart_insert_char(port, status, ATMEL_US_OVRE, ch, flg);
-
-ignore_char:
+		atmel_buffer_rx_char(port, status, ch);
 		status = UART_GET_CSR(port);
 	}
 
-	tty_flip_buffer_push(tty);
+	tasklet_schedule(&atmel_port->tasklet);
 }
 
 /*
@@ -379,7 +389,7 @@ atmel_handle_receive(struct uart_port *port, unsigned int pending)
 }
 
 /*
- * transmit interrupt handler.
+ * transmit interrupt handler. (Transmit is IRQF_NODELAY safe)
  */
 static void
 atmel_handle_transmit(struct uart_port *port, unsigned int pending)
@@ -396,18 +406,16 @@ static void
 atmel_handle_status(struct uart_port *port, unsigned int pending,
 		    unsigned int status)
 {
-	/* TODO: All reads to CSR will clear these interrupts! */
-	if (pending & ATMEL_US_RIIC)
-		port->icount.rng++;
-	if (pending & ATMEL_US_DSRIC)
-		port->icount.dsr++;
-	if (pending & ATMEL_US_DCDIC)
-		uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
-	if (pending & ATMEL_US_CTSIC)
-		uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
-	if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC
-				| ATMEL_US_CTSIC))
-		wake_up_interruptible(&port->info->delta_msr_wait);
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+
+	spin_lock(&port->lock);
+
+	atmel_port->irq_pending	|= pending;
+	atmel_port->irq_status	= status;
+
+	spin_unlock(&port->lock);
+
+	tasklet_schedule(&atmel_port->tasklet);
 }
 
 /*
@@ -435,6 +443,100 @@ static irqreturn_t atmel_interrupt(int irq, void *dev_id)
 }
 
 /*
+ * tasklet handling tty stuff outside the interrupt handler.
+ */
+static void atmel_tasklet_func(unsigned long data)
+{
+	struct uart_port *port = (struct uart_port *)data;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct circ_buf *ring = &atmel_port->rx_ring;
+	unsigned long flags;
+	unsigned int status;
+	unsigned int flg;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	if (atmel_port->irq_pending) {
+		unsigned int pending;
+
+		pending = atmel_port->irq_pending;
+		status = atmel_port->irq_status;
+		atmel_port->irq_pending = 0;
+
+		spin_unlock_irqrestore(&port->lock, flags);
+
+		/* TODO: All reads to CSR will clear these interrupts! */
+		if (pending & ATMEL_US_RIIC)
+			port->icount.rng++;
+		if (pending & ATMEL_US_DSRIC)
+			port->icount.dsr++;
+		if (pending & ATMEL_US_DCDIC)
+			uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
+		if (pending & ATMEL_US_CTSIC)
+			uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
+		if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC
+					| ATMEL_US_DCDIC | ATMEL_US_CTSIC))
+			wake_up_interruptible(&port->info->delta_msr_wait);
+	} else {
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+
+	while (ring->head != ring->tail) {
+		struct atmel_uart_char c;
+
+		/* Make sure c is loaded after head. */
+		smp_rmb();
+
+		c = ((struct atmel_uart_char *)ring->buf)[ring->tail];
+
+		ring->tail = (ring->tail + 1) & (ATMEL_SERIAL_RINGSIZE - 1);
+
+		port->icount.rx++;
+		status = c.status;
+		flg = TTY_NORMAL;
+
+		/*
+		 * note that the error handling code is
+		 * out of the main execution path
+		 */
+		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME
+				       | ATMEL_US_OVRE | ATMEL_US_RXBRK))) {
+			if (status & ATMEL_US_RXBRK) {
+				/* ignore side-effect */
+				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);
+
+				port->icount.brk++;
+				if (uart_handle_break(port))
+					continue;
+			}
+			if (status & ATMEL_US_PARE)
+				port->icount.parity++;
+			if (status & ATMEL_US_FRAME)
+				port->icount.frame++;
+			if (status & ATMEL_US_OVRE)
+				port->icount.overrun++;
+
+			status &= port->read_status_mask;
+
+			if (status & ATMEL_US_RXBRK)
+				flg = TTY_BREAK;
+			else if (status & ATMEL_US_PARE)
+				flg = TTY_PARITY;
+			else if (status & ATMEL_US_FRAME)
+				flg = TTY_FRAME;
+		}
+
+
+		if (uart_handle_sysrq_char(port, c.ch))
+			continue;
+
+		uart_insert_char(port, status, ATMEL_US_OVRE, c.ch, flg);
+	}
+
+	tty_flip_buffer_push(port->info->tty);
+}
+
+/*
  * Perform initialization and enable port for reception
  */
 static int atmel_startup(struct uart_port *port)
@@ -765,6 +867,11 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 	port->mapbase	= pdev->resource[0].start;
 	port->irq	= pdev->resource[1].start;
 
+	tasklet_init(&atmel_port->tasklet, atmel_tasklet_func,
+			(unsigned long)port);
+
+	memset(&atmel_port->rx_ring, 0, sizeof(atmel_port->rx_ring));
+
 	if (data->regs)
 		/* Already mapped by setup code */
 		port->membase = data->regs;
@@ -995,11 +1102,19 @@ static int atmel_serial_resume(struct platform_device *pdev)
 static int __devinit atmel_serial_probe(struct platform_device *pdev)
 {
 	struct atmel_uart_port *port;
+	void *data;
 	int ret;
 
+	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
+
 	port = &atmel_ports[pdev->id];
 	atmel_init_port(port, pdev);
 
+	data = kmalloc(ATMEL_SERIAL_RINGSIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+	port->rx_ring.buf = data;
+
 	ret = uart_add_one_port(&atmel_uart, &port->uart);
 	if (!ret) {
 		device_init_wakeup(&pdev->dev, 1);
@@ -1023,6 +1138,7 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
 
 	if (port) {
 		ret = uart_remove_one_port(&atmel_uart, port);
+		kfree(atmel_port->rx_ring.buf);
 		kfree(port);
 	}
 
-- 
1.5.3.4

