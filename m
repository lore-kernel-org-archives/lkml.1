Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYJMKHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYJMKHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932067AbYJMJqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:46:01 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:33171 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763269AbYJMJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:45:50 -0400
X-IronPort-AV: E=Sophos;i="4.33,402,1220241600"; 
   d="scan'208";a="61013700"
From: Bryan Wu <cooloney@kernel.org>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/6] Blackfin Serial Driver: updates kgdb over Blackfin serial driver with kgdb framework
Date: Mon, 13 Oct 2008 17:46:20 +0800
Message-Id: <1223891185-13924-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
References: <1223891185-13924-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |  187 +++++++++++++++++++++-----------------------
 1 files changed, 89 insertions(+), 98 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 569f0e2..d63fad7 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -22,7 +22,8 @@
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 
-#ifdef CONFIG_KGDB_UART
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
 #include <linux/kgdb.h>
 #include <asm/irq_regs.h>
 #endif
@@ -45,6 +46,16 @@
 static struct bfin_serial_port bfin_serial_ports[BFIN_UART_NR_PORTS];
 static int nr_active_ports = ARRAY_SIZE(bfin_serial_resource);
 
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+
+# ifndef CONFIG_SERIAL_BFIN_PIO
+#  error KGDB only support UART in PIO mode.
+# endif
+
+static int kgdboc_port_line;
+static int kgdboc_break_enabled;
+#endif
 /*
  * Setup for console. Argument comes from the menuconfig
  */
@@ -110,9 +121,7 @@ static void bfin_serial_start_tx(struct uart_port *port)
 static void bfin_serial_stop_rx(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-#ifdef CONFIG_KGDB_UART
-	if (uart->port.line != CONFIG_KGDB_UART_PORT)
-#endif
+
 	UART_CLEAR_IER(uart, ERBFI);
 }
 
@@ -123,49 +132,6 @@ static void bfin_serial_enable_ms(struct uart_port *port)
 {
 }
 
-#ifdef CONFIG_KGDB_UART
-static int kgdb_entry_state;
-
-void kgdb_put_debug_char(int chr)
-{
-	struct bfin_serial_port *uart;
-
-	if (CONFIG_KGDB_UART_PORT < 0
-		|| CONFIG_KGDB_UART_PORT >= BFIN_UART_NR_PORTS)
-		uart = &bfin_serial_ports[0];
-	else
-		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
-
-	while (!(UART_GET_LSR(uart) & THRE)) {
-		SSYNC();
-	}
-
-	UART_CLEAR_DLAB(uart);
-	UART_PUT_CHAR(uart, (unsigned char)chr);
-	SSYNC();
-}
-
-int kgdb_get_debug_char(void)
-{
-	struct bfin_serial_port *uart;
-	unsigned char chr;
-
-	if (CONFIG_KGDB_UART_PORT < 0
-		|| CONFIG_KGDB_UART_PORT >= BFIN_UART_NR_PORTS)
-		uart = &bfin_serial_ports[0];
-	else
-		uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
-
-	while(!(UART_GET_LSR(uart) & DR)) {
-		SSYNC();
-	}
-	UART_CLEAR_DLAB(uart);
-	chr = UART_GET_CHAR(uart);
-	SSYNC();
-
-	return chr;
-}
-#endif
 
 #if ANOMALY_05000363 && defined(CONFIG_SERIAL_BFIN_PIO)
 # define UART_GET_ANOMALY_THRESHOLD(uart)    ((uart)->anomaly_threshold)
@@ -178,7 +144,7 @@ int kgdb_get_debug_char(void)
 #ifdef CONFIG_SERIAL_BFIN_PIO
 static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 {
-	struct tty_struct *tty = uart->port.info->port.tty;
+	struct tty_struct *tty = NULL;
 	unsigned int status, ch, flg;
 	static struct timeval anomaly_start = { .tv_sec = 0 };
 
@@ -188,27 +154,18 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
  	ch = UART_GET_CHAR(uart);
  	uart->port.icount.rx++;
 
-#ifdef CONFIG_KGDB_UART
-	if (uart->port.line == CONFIG_KGDB_UART_PORT) {
-		struct pt_regs *regs = get_irq_regs();
-		if (uart->port.cons->index == CONFIG_KGDB_UART_PORT && ch == 0x1) { /* Ctrl + A */
-			kgdb_breakkey_pressed(regs);
-			return;
-		} else if (kgdb_entry_state == 0 && ch == '$') {/* connection from KGDB */
-			kgdb_entry_state = 1;
-		} else if (kgdb_entry_state == 1 && ch == 'q') {
-			kgdb_entry_state = 0;
-			kgdb_breakkey_pressed(regs);
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+	if (kgdb_connected && kgdboc_port_line == uart->port.line)
+		if (ch == 0x3) {/* Ctrl + C */
+			kgdb_breakpoint();
 			return;
-		} else if (ch == 0x3) {/* Ctrl + C */
-			kgdb_entry_state = 0;
-			kgdb_breakkey_pressed(regs);
-			return;
-		} else {
-			kgdb_entry_state = 0;
 		}
-	}
+
+	if (!uart->port.info || !uart->port.info->tty)
+		return;
 #endif
+	tty = uart->port.info->tty;
 
 	if (ANOMALY_05000363) {
 		/* The BF533 (and BF561) family of processors have a nice anomaly
@@ -630,16 +587,16 @@ static int bfin_serial_startup(struct uart_port *port)
 	uart->rx_dma_timer.expires = jiffies + DMA_RX_FLUSH_JIFFIES;
 	add_timer(&(uart->rx_dma_timer));
 #else
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+	if (kgdboc_port_line == uart->port.line && kgdboc_break_enabled)
+		kgdboc_break_enabled = 0;
+	else {
+# endif
 	if (request_irq(uart->port.irq, bfin_serial_rx_int, IRQF_DISABLED,
 	     "BFIN_UART_RX", uart)) {
-# ifdef	CONFIG_KGDB_UART
-		if (uart->port.line != CONFIG_KGDB_UART_PORT) {
-# endif
 		printk(KERN_NOTICE "Unable to attach BlackFin UART RX interrupt\n");
 		return -EBUSY;
-# ifdef	CONFIG_KGDB_UART
-		}
-# endif
 	}
 
 	if (request_irq
@@ -685,6 +642,10 @@ static int bfin_serial_startup(struct uart_port *port)
 		}
 	}
 # endif
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+	}
+# endif
 #endif
 	UART_SET_IER(uart, ERBFI);
 	return 0;
@@ -716,9 +677,6 @@ static void bfin_serial_shutdown(struct uart_port *port)
 		break;
 	};
 #endif
-#ifdef	CONFIG_KGDB_UART
-	if (uart->port.line != CONFIG_KGDB_UART_PORT)
-#endif
 	free_irq(uart->port.irq, uart);
 	free_irq(uart->port.irq+1, uart);
 #endif
@@ -887,6 +845,51 @@ static void bfin_serial_set_ldisc(struct uart_port *port)
 	}
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static void bfin_serial_poll_put_char(struct uart_port *port, unsigned char chr)
+{
+	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+
+	while (!(UART_GET_LSR(uart) & THRE))
+		cpu_relax();
+
+	UART_CLEAR_DLAB(uart);
+	UART_PUT_CHAR(uart, (unsigned char)chr);
+}
+
+static int bfin_serial_poll_get_char(struct uart_port *port)
+{
+	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
+	unsigned char chr;
+
+	while (!(UART_GET_LSR(uart) & DR))
+		cpu_relax();
+
+	UART_CLEAR_DLAB(uart);
+	chr = UART_GET_CHAR(uart);
+
+	return chr;
+}
+#endif
+
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+static void bfin_kgdboc_port_shutdown(struct uart_port *port)
+{
+	if (kgdboc_break_enabled) {
+		kgdboc_break_enabled = 0;
+		bfin_serial_shutdown(port);
+	}
+}
+
+static int bfin_kgdboc_port_startup(struct uart_port *port)
+{
+	kgdboc_port_line = port->line;
+	kgdboc_break_enabled = !bfin_serial_startup(port);
+	return 0;
+}
+#endif
+
 static struct uart_ops bfin_serial_pops = {
 	.tx_empty	= bfin_serial_tx_empty,
 	.set_mctrl	= bfin_serial_set_mctrl,
@@ -905,6 +908,15 @@ static struct uart_ops bfin_serial_pops = {
 	.request_port	= bfin_serial_request_port,
 	.config_port	= bfin_serial_config_port,
 	.verify_port	= bfin_serial_verify_port,
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+	.kgdboc_port_startup	= bfin_kgdboc_port_startup,
+	.kgdboc_port_shutdown	= bfin_kgdboc_port_shutdown,
+#endif
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_put_char	= bfin_serial_poll_put_char,
+	.poll_get_char	= bfin_serial_poll_get_char,
+#endif
 };
 
 static void __init bfin_serial_init_ports(void)
@@ -1076,10 +1088,7 @@ static int __init bfin_serial_rs_console_init(void)
 {
 	bfin_serial_init_ports();
 	register_console(&bfin_serial_console);
-#ifdef CONFIG_KGDB_UART
-	kgdb_entry_state = 0;
-	init_kgdb_uart();
-#endif
+
 	return 0;
 }
 console_initcall(bfin_serial_rs_console_init);
@@ -1235,10 +1244,6 @@ static struct platform_driver bfin_serial_driver = {
 static int __init bfin_serial_init(void)
 {
 	int ret;
-#ifdef CONFIG_KGDB_UART
-	struct bfin_serial_port *uart = &bfin_serial_ports[CONFIG_KGDB_UART_PORT];
-	struct ktermios t;
-#endif
 
 	pr_info("Serial: Blackfin serial driver\n");
 
@@ -1252,21 +1257,6 @@ static int __init bfin_serial_init(void)
 			uart_unregister_driver(&bfin_serial_reg);
 		}
 	}
-#ifdef CONFIG_KGDB_UART
-	if (uart->port.cons->index != CONFIG_KGDB_UART_PORT) {
-		request_irq(uart->port.irq, bfin_serial_rx_int,
-			IRQF_DISABLED, "BFIN_UART_RX", uart);
-		pr_info("Request irq for kgdb uart port\n");
-		UART_SET_IER(uart, ERBFI);
-		SSYNC();
-		t.c_cflag = CS8|B57600;
-		t.c_iflag = 0;
-		t.c_oflag = 0;
-		t.c_lflag = ICANON;
-		t.c_line = CONFIG_KGDB_UART_PORT;
-		bfin_serial_set_termios(&uart->port, &t, &t);
-	}
-#endif
 	return ret;
 }
 
@@ -1276,6 +1266,7 @@ static void __exit bfin_serial_exit(void)
 	uart_unregister_driver(&bfin_serial_reg);
 }
 
+
 module_init(bfin_serial_init);
 module_exit(bfin_serial_exit);
 
-- 
1.5.6
