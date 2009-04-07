Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZDGOwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZDGOwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZDGOw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:52:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34158 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752805AbZDGOw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:52:28 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/11] Change hardware flow control from poll to interrupt
	driven
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:51:15 +0100
Message-ID: <20090407154856.18020.53760.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
References: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Only the CTS bit is affected.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 .../mach-bf527/include/mach/bfin_serial_5xx.h      |   26 ----
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |   20 ---
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |   27 ----
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |   45 -------
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |   20 ---
 drivers/serial/bfin_5xx.c                          |  131 +++++++++++++-------
 6 files changed, 82 insertions(+), 187 deletions(-)


diff --git a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
index e8c41fd..d2b160c 100644
--- a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
@@ -167,29 +167,3 @@ struct bfin_serial_res bfin_serial_resource[] = {
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff --git a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
index 5f517f5..70356dd 100644
--- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
@@ -142,23 +142,3 @@ struct bfin_serial_res bfin_serial_resource[] = {
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff --git a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
index 9e34700..d46fc4f 100644
--- a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
@@ -99,7 +99,6 @@ struct bfin_serial_port {
 	struct work_struct	tx_dma_workqueue;
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	struct timer_list 	cts_timer;
 	int		cts_pin;
 	int 		rts_pin;
 #endif
@@ -167,29 +166,3 @@ struct bfin_serial_res bfin_serial_resource[] = {
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff --git a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
index c05e79c..388e232 100644
--- a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
@@ -181,48 +181,3 @@ struct bfin_serial_res bfin_serial_resource[] = {
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART1
-	peripheral_request(P_UART1_TX, DRIVER_NAME);
-	peripheral_request(P_UART1_RX, DRIVER_NAME);
-
-#ifdef CONFIG_BFIN_UART1_CTSRTS
-	peripheral_request(P_UART1_RTS, DRIVER_NAME);
-	peripheral_request(P_UART1_CTS, DRIVER_NAME);
-#endif
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART2
-	peripheral_request(P_UART2_TX, DRIVER_NAME);
-	peripheral_request(P_UART2_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_UART3
-	peripheral_request(P_UART3_TX, DRIVER_NAME);
-	peripheral_request(P_UART3_RX, DRIVER_NAME);
-
-#ifdef CONFIG_BFIN_UART3_CTSRTS
-	peripheral_request(P_UART3_RTS, DRIVER_NAME);
-	peripheral_request(P_UART3_CTS, DRIVER_NAME);
-#endif
-#endif
-	SSYNC();
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff --git a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
index ca8c5f6..d0469e3 100644
--- a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
@@ -142,23 +142,3 @@ struct bfin_serial_res bfin_serial_resource[] = {
 };
 
 #define DRIVER_NAME "bfin-uart"
-
-static void bfin_serial_hw_init(struct bfin_serial_port *uart)
-{
-
-#ifdef CONFIG_SERIAL_BFIN_UART0
-	peripheral_request(P_UART0_TX, DRIVER_NAME);
-	peripheral_request(P_UART0_RX, DRIVER_NAME);
-#endif
-
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, DRIVER_NAME);
-		gpio_direction_input(uart->cts_pin);
-	}
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-}
diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index f9b5a72..fbbddb9 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -63,7 +63,6 @@ static int kgdboc_break_enabled;
 #define DMA_RX_YCOUNT		(PAGE_SIZE / DMA_RX_XCOUNT)
 
 #define DMA_RX_FLUSH_JIFFIES	(HZ / 50)
-#define CTS_CHECK_JIFFIES	(HZ / 50)
 
 #ifdef CONFIG_SERIAL_BFIN_DMA
 static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart);
@@ -71,8 +70,6 @@ static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart);
 static void bfin_serial_tx_chars(struct bfin_serial_port *uart);
 #endif
 
-static void bfin_serial_mctrl_check(struct bfin_serial_port *uart);
-
 static void bfin_serial_reset_irda(struct uart_port *port);
 
 /*
@@ -264,12 +261,6 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 {
 	struct circ_buf *xmit = &uart->port.info->xmit;
 
-	/*
-	 * Check the modem control lines before
-	 * transmitting anything.
-	 */
-	bfin_serial_mctrl_check(uart);
-
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
 #ifdef CONFIG_BF54x
 		/* Clear TFI bit */
@@ -328,12 +319,6 @@ static void bfin_serial_dma_tx_chars(struct bfin_serial_port *uart)
 
 	uart->tx_done = 0;
 
-	/*
-	 * Check the modem control lines before
-	 * transmitting anything.
-	 */
-	bfin_serial_mctrl_check(uart);
-
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
 		uart->tx_count = 0;
 		uart->tx_done = 1;
@@ -524,29 +509,21 @@ static void bfin_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
 #endif
 }
 
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 /*
- * Handle any change of modem status signal since we were last called.
+ * Handle any change of modem status signal.
  */
-static void bfin_serial_mctrl_check(struct bfin_serial_port *uart)
+static irqreturn_t bfin_serial_mctrl_cts_int(int irq, void *dev_id)
 {
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	struct bfin_serial_port *uart = dev_id;
 	unsigned int status;
-	struct uart_info *info = uart->port.info;
-	struct tty_struct *tty = info->port.tty;
 
 	status = bfin_serial_get_mctrl(&uart->port);
 	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
-	if (!(status & TIOCM_CTS)) {
-		tty->hw_stopped = 1;
-		uart->cts_timer.data = (unsigned long)(uart);
-		uart->cts_timer.function = (void *)bfin_serial_mctrl_check;
-		uart->cts_timer.expires = jiffies + CTS_CHECK_JIFFIES;
-		add_timer(&(uart->cts_timer));
-	} else {
-		tty->hw_stopped = 0;
-	}
-#endif
+
+	return IRQ_HANDLED;
 }
+#endif
 
 /*
  * Interrupts are always disabled.
@@ -606,7 +583,7 @@ static int bfin_serial_startup(struct uart_port *port)
 	uart->rx_dma_timer.expires = jiffies + DMA_RX_FLUSH_JIFFIES;
 	add_timer(&(uart->rx_dma_timer));
 #else
-#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+# if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
 	if (kgdboc_port_line == uart->port.line && kgdboc_break_enabled)
 		kgdboc_break_enabled = 0;
@@ -661,11 +638,28 @@ static int bfin_serial_startup(struct uart_port *port)
 		}
 	}
 # endif
-#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+# if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
 	}
 # endif
 #endif
+
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	if (uart->cts_pin >= 0) {
+		if (request_irq(gpio_to_irq(uart->cts_pin),
+			bfin_serial_mctrl_cts_int,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
+			uart->cts_pin = -1;
+			pr_info("Unable to attach BlackFin UART CTS interrupt.\
+				 So, disable it.\n");
+		}
+	}
+	if (uart->rts_pin >= 0) {
+		gpio_request(uart->rts_pin, DRIVER_NAME);
+		gpio_direction_output(uart->rts_pin, 0);
+	}
+#endif
 	UART_SET_IER(uart, ERBFI);
 	return 0;
 }
@@ -699,6 +693,13 @@ static void bfin_serial_shutdown(struct uart_port *port)
 	free_irq(uart->port.irq, uart);
 	free_irq(uart->port.irq+1, uart);
 #endif
+
+# ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	if (uart->cts_pin >= 0)
+		free_irq(gpio_to_irq(uart->cts_pin), uart);
+	if (uart->rts_pin >= 0)
+		gpio_free(uart->rts_pin);
+# endif
 }
 
 static void
@@ -864,6 +865,20 @@ static void bfin_serial_set_ldisc(struct uart_port *port)
 	}
 }
 
+static void bfin_serial_reset_irda(struct uart_port *port)
+{
+	int line = port->line;
+	unsigned short val;
+
+	val = UART_GET_GCTL(&bfin_serial_ports[line]);
+	val &= ~(IREN | RPOLC);
+	UART_PUT_GCTL(&bfin_serial_ports[line], val);
+	SSYNC();
+	val |= (IREN | RPOLC);
+	UART_PUT_GCTL(&bfin_serial_ports[line], val);
+	SSYNC();
+}
+
 #ifdef CONFIG_CONSOLE_POLL
 static void bfin_serial_poll_put_char(struct uart_port *port, unsigned char chr)
 {
@@ -909,20 +924,6 @@ static int bfin_kgdboc_port_startup(struct uart_port *port)
 }
 #endif
 
-static void bfin_serial_reset_irda(struct uart_port *port)
-{
-	int line = port->line;
-	unsigned short val;
-
-	val = UART_GET_GCTL(&bfin_serial_ports[line]);
-	val &= ~(IREN | RPOLC);
-	UART_PUT_GCTL(&bfin_serial_ports[line], val);
-	SSYNC();
-	val |= (IREN | RPOLC);
-	UART_PUT_GCTL(&bfin_serial_ports[line], val);
-	SSYNC();
-}
-
 static struct uart_ops bfin_serial_pops = {
 	.tx_empty	= bfin_serial_tx_empty,
 	.set_mctrl	= bfin_serial_set_mctrl,
@@ -952,6 +953,39 @@ static struct uart_ops bfin_serial_pops = {
 #endif
 };
 
+static void __init bfin_serial_hw_init(void)
+{
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+
+# if defined(CONFIG_BFIN_UART1_CTSRTS) && defined(CONFIG_BF54x)
+	peripheral_request(P_UART1_RTS, DRIVER_NAME);
+	peripheral_request(P_UART1_CTS, DRIVER_NAME);
+# endif
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART2
+	peripheral_request(P_UART2_TX, DRIVER_NAME);
+	peripheral_request(P_UART2_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART3
+	peripheral_request(P_UART3_TX, DRIVER_NAME);
+	peripheral_request(P_UART3_RX, DRIVER_NAME);
+
+# if defined(CONFIG_BFIN_UART3_CTSRTS) && defined(CONFIG_BF54x)
+	peripheral_request(P_UART3_RTS, DRIVER_NAME);
+	peripheral_request(P_UART3_CTS, DRIVER_NAME);
+# endif
+#endif
+}
+
 static void __init bfin_serial_init_ports(void)
 {
 	static int first = 1;
@@ -961,6 +995,8 @@ static void __init bfin_serial_init_ports(void)
 		return;
 	first = 0;
 
+	bfin_serial_hw_init();
+
 	for (i = 0; i < nr_active_ports; i++) {
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
 		bfin_serial_ports[i].port.fifosize  = BFIN_UART_TX_FIFO_SIZE;
@@ -984,15 +1020,12 @@ static void __init bfin_serial_init_ports(void)
 		init_timer(&(bfin_serial_ports[i].rx_dma_timer));
 #endif
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
-		init_timer(&(bfin_serial_ports[i].cts_timer));
 		bfin_serial_ports[i].cts_pin	    =
 			bfin_serial_resource[i].uart_cts_pin;
 		bfin_serial_ports[i].rts_pin	    =
 			bfin_serial_resource[i].uart_rts_pin;
 #endif
-		bfin_serial_hw_init(&bfin_serial_ports[i]);
 	}
-
 }
 
 #if defined(CONFIG_SERIAL_BFIN_CONSOLE) || defined(CONFIG_EARLY_PRINTK)

