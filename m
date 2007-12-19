Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbXLSPPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbXLSPPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbXLSPOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:14:38 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63858 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758681AbXLSPOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:14:36 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>, linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH v2 1/6] atmel_serial: Clean up the code
Date: Wed, 19 Dec 2007 16:12:05 +0100
Message-Id: <1198077130-9021-2-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Remy Bohmer <linux@bohmer.net>

This patch cleans up the atmel_serial driver to conform the coding rules.
It contains no functional change.

Signed-off-by: Remy Bohmer <linux@bohmer.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |  327 ++++++++++++++++++++++++-----------------
 1 files changed, 189 insertions(+), 138 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 111da57..bd41529 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -74,38 +74,42 @@
 
 #define ATMEL_ISR_PASS_LIMIT	256
 
-#define UART_PUT_CR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_CR)
-#define UART_GET_MR(port)	__raw_readl((port)->membase + ATMEL_US_MR)
-#define UART_PUT_MR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_MR)
-#define UART_PUT_IER(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_IER)
-#define UART_PUT_IDR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_IDR)
-#define UART_GET_IMR(port)	__raw_readl((port)->membase + ATMEL_US_IMR)
-#define UART_GET_CSR(port)	__raw_readl((port)->membase + ATMEL_US_CSR)
-#define UART_GET_CHAR(port)	__raw_readl((port)->membase + ATMEL_US_RHR)
-#define UART_PUT_CHAR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_THR)
-#define UART_GET_BRGR(port)	__raw_readl((port)->membase + ATMEL_US_BRGR)
-#define UART_PUT_BRGR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_BRGR)
-#define UART_PUT_RTOR(port,v)	__raw_writel(v, (port)->membase + ATMEL_US_RTOR)
-
-// #define UART_GET_CR(port)	__raw_readl((port)->membase + ATMEL_US_CR)		// is write-only
+#define at_readl(port, off)	__raw_readl((port)->membase + (off))
+#define at_writel(v, port, off)	__raw_writel(v, (port)->membase + (off))
+
+#define UART_PUT_CR(port, v)	at_writel(v, port, ATMEL_US_CR)
+#define UART_PUT_MR(port, v)	at_writel(v, port, ATMEL_US_MR)
+#define UART_PUT_IER(port, v)	at_writel(v, port, ATMEL_US_IER)
+#define UART_PUT_IDR(port, v)	at_writel(v, port, ATMEL_US_IDR)
+#define UART_PUT_CHAR(port, v)	at_writel(v, port, ATMEL_US_THR)
+#define UART_PUT_BRGR(port, v)	at_writel(v, port, ATMEL_US_BRGR)
+#define UART_PUT_RTOR(port, v)	at_writel(v, port, ATMEL_US_RTOR)
+
+#define UART_GET_MR(port)	at_readl(port, ATMEL_US_MR)
+#define UART_GET_IMR(port)	at_readl(port, ATMEL_US_IMR)
+#define UART_GET_CSR(port)	at_readl(port, ATMEL_US_CSR)
+#define UART_GET_CHAR(port)	at_readl(port, ATMEL_US_RHR)
+#define UART_GET_BRGR(port)	at_readl(port, ATMEL_US_BRGR)
+
+/* is write-only */
+/* #define UART_GET_CR(port)	at_readl(port, ATMEL_US_CR) */
 
  /* PDC registers */
-#define UART_PUT_PTCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_PTCR)
-#define UART_GET_PTSR(port)	__raw_readl((port)->membase + ATMEL_PDC_PTSR)
-
-#define UART_PUT_RPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RPR)
-#define UART_GET_RPR(port)	__raw_readl((port)->membase + ATMEL_PDC_RPR)
-#define UART_PUT_RCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RCR)
-#define UART_PUT_RNPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RNPR)
-#define UART_PUT_RNCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_RNCR)
-
-#define UART_PUT_TPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TPR)
-#define UART_PUT_TCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TCR)
-//#define UART_PUT_TNPR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TNPR)
-//#define UART_PUT_TNCR(port,v)	__raw_writel(v, (port)->membase + ATMEL_PDC_TNCR)
-
-static int (*atmel_open_hook)(struct uart_port *);
-static void (*atmel_close_hook)(struct uart_port *);
+#define UART_PUT_PTCR(port, v)	at_writel(v, port, ATMEL_PDC_PTCR)
+#define UART_PUT_RPR(port, v)	at_writel(v, port, ATMEL_PDC_RPR)
+#define UART_PUT_RCR(port, v)	at_writel(v, port, ATMEL_PDC_RCR)
+#define UART_PUT_RNPR(port, v)	at_writel(v, port, ATMEL_PDC_RNPR)
+#define UART_PUT_RNCR(port, v)	at_writel(v, port, ATMEL_PDC_RNCR)
+#define UART_PUT_TPR(port, v)	at_writel(v, port, ATMEL_PDC_TPR)
+#define UART_PUT_TCR(port, v)	at_writel(v, port, ATMEL_PDC_TCR)
+/*#define UART_PUT_TNPR(port, v) at_writel(v, port, ATMEL_PDC_TNPR) */
+/*#define UART_PUT_TNCR(port, v) at_writel(v, port, ATMEL_PDC_TNCR) */
+
+#define UART_GET_PTSR(port)	at_readl(port, ATMEL_PDC_PTSR)
+#define UART_GET_RPR(port)	at_readl(port, ATMEL_PDC_RPR)
+
+static int (*atmel_open_hook) (struct uart_port *);
+static void (*atmel_close_hook) (struct uart_port *);
 
 /*
  * We wrap our port structure around the generic uart_port.
@@ -142,8 +146,8 @@ static void atmel_set_mctrl(struct uart_port *port, u_int mctrl)
 #ifdef CONFIG_ARCH_AT91RM9200
 	if (cpu_is_at91rm9200()) {
 		/*
-		 * AT91RM9200 Errata #39: RTS0 is not internally connected to PA21.
-		 *  We need to drive the pin manually.
+		 * AT91RM9200 Errata #39: RTS0 is not internally connected
+		 * to PA21. We need to drive the pin manually.
 		 */
 		if (port->mapbase == AT91RM9200_BASE_US0) {
 			if (mctrl & TIOCM_RTS)
@@ -228,7 +232,8 @@ static void atmel_stop_rx(struct uart_port *port)
  */
 static void atmel_enable_ms(struct uart_port *port)
 {
-	UART_PUT_IER(port, ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC | ATMEL_US_CTSIC);
+	UART_PUT_IER(port, ATMEL_US_RIIC | ATMEL_US_DSRIC
+			| ATMEL_US_DCDIC | ATMEL_US_CTSIC);
 }
 
 /*
@@ -247,7 +252,7 @@ static void atmel_break_ctl(struct uart_port *port, int break_state)
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 	struct tty_struct *tty = port->info->tty;
 	unsigned int status, ch, flg;
 
@@ -266,10 +271,12 @@ static void atmel_rx_chars(struct uart_port *port)
 		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME
 				       | ATMEL_US_OVRE | ATMEL_US_RXBRK)
 			     || atmel_port->break_active)) {
-			UART_PUT_CR(port, ATMEL_US_RSTSTA);	/* clear error */
+			/* clear error */
+			UART_PUT_CR(port, ATMEL_US_RSTSTA);
 			if (status & ATMEL_US_RXBRK
 			    && !atmel_port->break_active) {
-				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);	/* ignore side-effect */
+				/* ignore side-effect */
+				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);
 				port->icount.brk++;
 				atmel_port->break_active = 1;
 				UART_PUT_IER(port, ATMEL_US_RXBRK);
@@ -309,7 +316,7 @@ static void atmel_rx_chars(struct uart_port *port)
 
 		uart_insert_char(port, status, ATMEL_US_OVRE, ch, flg);
 
-	ignore_char:
+ignore_char:
 		status = UART_GET_CSR(port);
 	}
 
@@ -350,44 +357,73 @@ static void atmel_tx_chars(struct uart_port *port)
 }
 
 /*
+ * receive interrupt handler.
+ */
+static void
+atmel_handle_receive(struct uart_port *port, unsigned int pending)
+{
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+
+	/* Interrupt receive */
+	if (pending & ATMEL_US_RXRDY)
+		atmel_rx_chars(port);
+	else if (pending & ATMEL_US_RXBRK) {
+		/*
+		 * End of break detected. If it came along with a
+		 * character, atmel_rx_chars will handle it.
+		 */
+		UART_PUT_CR(port, ATMEL_US_RSTSTA);
+		UART_PUT_IDR(port, ATMEL_US_RXBRK);
+		atmel_port->break_active = 0;
+	}
+}
+
+/*
+ * transmit interrupt handler.
+ */
+static void
+atmel_handle_transmit(struct uart_port *port, unsigned int pending)
+{
+	/* Interrupt transmit */
+	if (pending & ATMEL_US_TXRDY)
+		atmel_tx_chars(port);
+}
+
+/*
+ * status flags interrupt handler.
+ */
+static void
+atmel_handle_status(struct uart_port *port, unsigned int pending,
+		    unsigned int status)
+{
+	/* TODO: All reads to CSR will clear these interrupts! */
+	if (pending & ATMEL_US_RIIC)
+		port->icount.rng++;
+	if (pending & ATMEL_US_DSRIC)
+		port->icount.dsr++;
+	if (pending & ATMEL_US_DCDIC)
+		uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
+	if (pending & ATMEL_US_CTSIC)
+		uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
+	if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC
+				| ATMEL_US_CTSIC))
+		wake_up_interruptible(&port->info->delta_msr_wait);
+}
+
+/*
  * Interrupt handler
  */
 static irqreturn_t atmel_interrupt(int irq, void *dev_id)
 {
 	struct uart_port *port = dev_id;
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
 	unsigned int status, pending, pass_counter = 0;
 
 	status = UART_GET_CSR(port);
 	pending = status & UART_GET_IMR(port);
 	while (pending) {
-		/* Interrupt receive */
-		if (pending & ATMEL_US_RXRDY)
-			atmel_rx_chars(port);
-		else if (pending & ATMEL_US_RXBRK) {
-			/*
-			 * End of break detected. If it came along
-			 * with a character, atmel_rx_chars will
-			 * handle it.
-			 */
-			UART_PUT_CR(port, ATMEL_US_RSTSTA);
-			UART_PUT_IDR(port, ATMEL_US_RXBRK);
-			atmel_port->break_active = 0;
-		}
-
-		// TODO: All reads to CSR will clear these interrupts!
-		if (pending & ATMEL_US_RIIC) port->icount.rng++;
-		if (pending & ATMEL_US_DSRIC) port->icount.dsr++;
-		if (pending & ATMEL_US_DCDIC)
-			uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
-		if (pending & ATMEL_US_CTSIC)
-			uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
-		if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC | ATMEL_US_CTSIC))
-			wake_up_interruptible(&port->info->delta_msr_wait);
-
-		/* Interrupt transmit */
-		if (pending & ATMEL_US_TXRDY)
-			atmel_tx_chars(port);
+		atmel_handle_receive(port, pending);
+		atmel_handle_status(port, pending, status);
+		atmel_handle_transmit(port, pending);
 
 		if (pass_counter++ > ATMEL_ISR_PASS_LIMIT)
 			break;
@@ -415,7 +451,8 @@ static int atmel_startup(struct uart_port *port)
 	/*
 	 * Allocate the IRQ
 	 */
-	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED, "atmel_serial", port);
+	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED,
+			"atmel_serial", port);
 	if (retval) {
 		printk("atmel_serial: atmel_startup - Can't get irq\n");
 		return retval;
@@ -437,9 +474,11 @@ static int atmel_startup(struct uart_port *port)
 	 * Finally, enable the serial port
 	 */
 	UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
-	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);		/* enable xmit & rcvr */
+	/* enable xmit & rcvr */
+	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);
 
-	UART_PUT_IER(port, ATMEL_US_RXRDY);		/* enable receive only */
+	/* enable receive only */
+	UART_PUT_IER(port, ATMEL_US_RXRDY);
 
 	return 0;
 }
@@ -471,45 +510,48 @@ static void atmel_shutdown(struct uart_port *port)
 /*
  * Power / Clock management.
  */
-static void atmel_serial_pm(struct uart_port *port, unsigned int state, unsigned int oldstate)
+static void atmel_serial_pm(struct uart_port *port, unsigned int state,
+			    unsigned int oldstate)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
 	switch (state) {
-		case 0:
-			/*
-			 * Enable the peripheral clock for this serial port.
-			 * This is called on uart_open() or a resume event.
-			 */
-			clk_enable(atmel_port->clk);
-			break;
-		case 3:
-			/*
-			 * Disable the peripheral clock for this serial port.
-			 * This is called on uart_close() or a suspend event.
-			 */
-			clk_disable(atmel_port->clk);
-			break;
-		default:
-			printk(KERN_ERR "atmel_serial: unknown pm %d\n", state);
+	case 0:
+		/*
+		 * Enable the peripheral clock for this serial port.
+		 * This is called on uart_open() or a resume event.
+		 */
+		clk_enable(atmel_port->clk);
+		break;
+	case 3:
+		/*
+		 * Disable the peripheral clock for this serial port.
+		 * This is called on uart_close() or a suspend event.
+		 */
+		clk_disable(atmel_port->clk);
+		break;
+	default:
+		printk(KERN_ERR "atmel_serial: unknown pm %d\n", state);
 	}
 }
 
 /*
  * Change the port parameters
  */
-static void atmel_set_termios(struct uart_port *port, struct ktermios * termios, struct ktermios * old)
+static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
+			      struct ktermios *old)
 {
 	unsigned long flags;
 	unsigned int mode, imr, quot, baud;
 
 	/* Get current mode register */
-	mode = UART_GET_MR(port) & ~(ATMEL_US_USCLKS | ATMEL_US_CHRL | ATMEL_US_NBSTOP | ATMEL_US_PAR);
+	mode = UART_GET_MR(port) & ~(ATMEL_US_USCLKS | ATMEL_US_CHRL
+					| ATMEL_US_NBSTOP | ATMEL_US_PAR);
 
-	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
+	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
 	quot = uart_get_divisor(port, baud);
 
-	if (quot > 65535) {		/* BRGR is 16-bit, so switch to slower clock */
+	if (quot > 65535) {	/* BRGR is 16-bit, so switch to slower clock */
 		quot /= 8;
 		mode |= ATMEL_US_USCLKS_MCK_DIV8;
 	}
@@ -536,18 +578,17 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios * termios,
 
 	/* parity */
 	if (termios->c_cflag & PARENB) {
-		if (termios->c_cflag & CMSPAR) {			/* Mark or Space parity */
+		/* Mark or Space parity */
+		if (termios->c_cflag & CMSPAR) {
 			if (termios->c_cflag & PARODD)
 				mode |= ATMEL_US_PAR_MARK;
 			else
 				mode |= ATMEL_US_PAR_SPACE;
-		}
-		else if (termios->c_cflag & PARODD)
+		} else if (termios->c_cflag & PARODD)
 			mode |= ATMEL_US_PAR_ODD;
 		else
 			mode |= ATMEL_US_PAR_EVEN;
-	}
-	else
+	} else
 		mode |= ATMEL_US_PAR_NONE;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -573,16 +614,16 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios * termios,
 		if (termios->c_iflag & IGNPAR)
 			port->ignore_status_mask |= ATMEL_US_OVRE;
 	}
-
-	// TODO: Ignore all characters if CREAD is set.
+	/* TODO: Ignore all characters if CREAD is set.*/
 
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* disable interrupts and drain transmitter */
-	imr = UART_GET_IMR(port);	/* get interrupt mask */
-	UART_PUT_IDR(port, -1);		/* disable all interrupts */
-	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY)) { barrier(); }
+	/* save/disable interrupts and drain transmitter */
+	imr = UART_GET_IMR(port);
+	UART_PUT_IDR(port, -1);
+	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
+		barrier();
 
 	/* disable receiver and transmitter */
 	UART_PUT_CR(port, ATMEL_US_TXDIS | ATMEL_US_RXDIS);
@@ -708,7 +749,8 @@ static struct uart_ops atmel_pops = {
 /*
  * Configure the port from the platform device resource info.
  */
-static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port, struct platform_device *pdev)
+static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
+				      struct platform_device *pdev)
 {
 	struct uart_port *port = &atmel_port->uart;
 	struct atmel_uart_data *data = pdev->dev.platform_data;
@@ -731,7 +773,8 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port, struct
 		port->membase	= NULL;
 	}
 
-	if (!atmel_port->clk) {		/* for console, the clock could already be configured */
+	/* for console, the clock could already be configured */
+	if (!atmel_port->clk) {
 		atmel_port->clk = clk_get(&pdev->dev, "usart");
 		clk_enable(atmel_port->clk);
 		port->uartclk = clk_get_rate(atmel_port->clk);
@@ -755,7 +798,6 @@ void __init atmel_register_uart_fns(struct atmel_port_fns *fns)
 	atmel_pops.set_wake	= fns->set_wake;
 }
 
-
 #ifdef CONFIG_SERIAL_ATMEL_CONSOLE
 static void atmel_console_putchar(struct uart_port *port, int ch)
 {
@@ -773,28 +815,30 @@ static void atmel_console_write(struct console *co, const char *s, u_int count)
 	unsigned int status, imr;
 
 	/*
-	 *	First, save IMR and then disable interrupts
+	 * First, save IMR and then disable interrupts
 	 */
-	imr = UART_GET_IMR(port);	/* get interrupt mask */
+	imr = UART_GET_IMR(port);
 	UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
 
 	uart_console_write(port, s, count, atmel_console_putchar);
 
 	/*
-	 *	Finally, wait for transmitter to become empty
-	 *	and restore IMR
+	 * Finally, wait for transmitter to become empty
+	 * and restore IMR
 	 */
 	do {
 		status = UART_GET_CSR(port);
 	} while (!(status & ATMEL_US_TXRDY));
-	UART_PUT_IER(port, imr);	/* set interrupts back the way they were */
+	/* set interrupts back the way they were */
+	UART_PUT_IER(port, imr);
 }
 
 /*
- * If the port was already initialised (eg, by a boot loader), try to determine
- * the current setup.
+ * If the port was already initialised (eg, by a boot loader),
+ * try to determine the current setup.
  */
-static void __init atmel_console_get_options(struct uart_port *port, int *baud, int *parity, int *bits)
+static void __init atmel_console_get_options(struct uart_port *port, int *baud,
+					     int *parity, int *bits)
 {
 	unsigned int mr, quot;
 
@@ -836,10 +880,11 @@ static int __init atmel_console_setup(struct console *co, char *options)
 	int parity = 'n';
 	int flow = 'n';
 
-	if (port->membase == 0)		/* Port not initialized yet - delay setup */
+	if (port->membase == 0)
+		/* Port not initialized yet - delay setup */
 		return -ENODEV;
 
-	UART_PUT_IDR(port, -1);				/* disable interrupts */
+	UART_PUT_IDR(port, -1);
 	UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
 	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);
 
@@ -854,13 +899,13 @@ static int __init atmel_console_setup(struct console *co, char *options)
 static struct uart_driver atmel_uart;
 
 static struct console atmel_console = {
-	.name		= ATMEL_DEVICENAME,
-	.write		= atmel_console_write,
-	.device		= uart_console_device,
-	.setup		= atmel_console_setup,
-	.flags		= CON_PRINTBUFFER,
-	.index		= -1,
-	.data		= &atmel_uart,
+	.name	= ATMEL_DEVICENAME,
+	.write	= atmel_console_write,
+	.device	= uart_console_device,
+	.setup	= atmel_console_setup,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+	.data	= &atmel_uart,
 };
 
 #define ATMEL_CONSOLE_DEVICE	&atmel_console
@@ -871,13 +916,16 @@ static struct console atmel_console = {
 static int __init atmel_console_init(void)
 {
 	if (atmel_default_console_device) {
-		add_preferred_console(ATMEL_DEVICENAME, atmel_default_console_device->id, NULL);
-		atmel_init_port(&(atmel_ports[atmel_default_console_device->id]), atmel_default_console_device);
+		add_preferred_console(ATMEL_DEVICENAME,
+				      atmel_default_console_device->id, NULL);
+		atmel_init_port(&atmel_ports[atmel_default_console_device->id],
+				atmel_default_console_device);
 		register_console(&atmel_console);
 	}
 
 	return 0;
 }
+
 console_initcall(atmel_console_init);
 
 /*
@@ -885,11 +933,13 @@ console_initcall(atmel_console_init);
  */
 static int __init atmel_late_console_init(void)
 {
-	if (atmel_default_console_device && !(atmel_console.flags & CON_ENABLED))
+	if (atmel_default_console_device
+	    && !(atmel_console.flags & CON_ENABLED))
 		register_console(&atmel_console);
 
 	return 0;
 }
+
 core_initcall(atmel_late_console_init);
 
 #else
@@ -897,22 +947,24 @@ core_initcall(atmel_late_console_init);
 #endif
 
 static struct uart_driver atmel_uart = {
-	.owner			= THIS_MODULE,
-	.driver_name		= "atmel_serial",
-	.dev_name		= ATMEL_DEVICENAME,
-	.major			= SERIAL_ATMEL_MAJOR,
-	.minor			= MINOR_START,
-	.nr			= ATMEL_MAX_UART,
-	.cons			= ATMEL_CONSOLE_DEVICE,
+	.owner		= THIS_MODULE,
+	.driver_name	= "atmel_serial",
+	.dev_name	= ATMEL_DEVICENAME,
+	.major		= SERIAL_ATMEL_MAJOR,
+	.minor		= MINOR_START,
+	.nr		= ATMEL_MAX_UART,
+	.cons		= ATMEL_CONSOLE_DEVICE,
 };
 
 #ifdef CONFIG_PM
-static int atmel_serial_suspend(struct platform_device *pdev, pm_message_t state)
+static int atmel_serial_suspend(struct platform_device *pdev,
+				pm_message_t state)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
-	if (device_may_wakeup(&pdev->dev) && !at91_suspend_entering_slow_clock())
+	if (device_may_wakeup(&pdev->dev)
+	    && !at91_suspend_entering_slow_clock())
 		enable_irq_wake(port->irq);
 	else {
 		uart_suspend_port(&atmel_uart, port);
@@ -925,13 +977,12 @@ static int atmel_serial_suspend(struct platform_device *pdev, pm_message_t state
 static int atmel_serial_resume(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
 	if (atmel_port->suspended) {
 		uart_resume_port(&atmel_uart, port);
 		atmel_port->suspended = 0;
-	}
-	else
+	} else
 		disable_irq_wake(port->irq);
 
 	return 0;
@@ -961,7 +1012,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 static int __devexit atmel_serial_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 	int ret = 0;
 
 	clk_disable(atmel_port->clk);
-- 
1.5.3.4

