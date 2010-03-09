Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab0CIRWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:22:45 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54693 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab0CIRWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:30 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 06/13] serial: bfin_sport_uart: add support for CTS/RTS via GPIOs
Date: Tue,  9 Mar 2010 12:25:33 -0500
Message-Id: <1268155540-8241-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
References: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Some people need flow control on their ports, so now boards can support
that via any GPIOs.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/Kconfig           |   24 ++++++++
 drivers/serial/bfin_sport_uart.c |  111 ++++++++++++++++++++++++++++++++++----
 drivers/serial/bfin_sport_uart.h |   11 ++++
 3 files changed, 135 insertions(+), 11 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index d6ff733..0d95b5f 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1433,24 +1433,48 @@ config SERIAL_BFIN_SPORT0_UART
 	help
 	  Enable UART over SPORT0
 
+config SERIAL_BFIN_SPORT0_UART_CTSRTS
+	bool "Enable UART over SPORT0 hardware flow control"
+	depends on SERIAL_BFIN_SPORT0_UART
+	help
+	  Enable hardware flow control in the driver.
+
 config SERIAL_BFIN_SPORT1_UART
 	bool "Enable UART over SPORT1"
 	depends on SERIAL_BFIN_SPORT
 	help
 	  Enable UART over SPORT1
 
+config SERIAL_BFIN_SPORT1_UART_CTSRTS
+	bool "Enable UART over SPORT1 hardware flow control"
+	depends on SERIAL_BFIN_SPORT1_UART
+	help
+	  Enable hardware flow control in the driver.
+
 config SERIAL_BFIN_SPORT2_UART
 	bool "Enable UART over SPORT2"
 	depends on SERIAL_BFIN_SPORT && (BF54x || BF538 || BF539)
 	help
 	  Enable UART over SPORT2
 
+config SERIAL_BFIN_SPORT2_UART_CTSRTS
+	bool "Enable UART over SPORT2 hardware flow control"
+	depends on SERIAL_BFIN_SPORT2_UART
+	help
+	  Enable hardware flow control in the driver.
+
 config SERIAL_BFIN_SPORT3_UART
 	bool "Enable UART over SPORT3"
 	depends on SERIAL_BFIN_SPORT && (BF54x || BF538 || BF539)
 	help
 	  Enable UART over SPORT3
 
+config SERIAL_BFIN_SPORT3_UART_CTSRTS
+	bool "Enable UART over SPORT3 hardware flow control"
+	depends on SERIAL_BFIN_SPORT3_UART
+	help
+	  Enable hardware flow control in the driver.
+
 config SERIAL_TIMBERDALE
 	tristate "Support for timberdale UART"
 	select SERIAL_CORE
diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 5101e38..a720e63 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -47,6 +47,10 @@ struct sport_uart_port {
 	unsigned short		txmask2;
 	unsigned char		stopb;
 /*	unsigned char		parib; */
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	int cts_pin;
+	int rts_pin;
+#endif
 };
 
 static void sport_uart_tx_chars(struct sport_uart_port *up);
@@ -197,6 +201,59 @@ static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+static unsigned int sport_get_mctrl(struct uart_port *port)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+	if (up->cts_pin < 0)
+		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
+
+	/* CTS PIN is negative assertive. */
+	if (SPORT_UART_GET_CTS(up))
+		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
+	else
+		return TIOCM_DSR | TIOCM_CAR;
+}
+
+static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)port;
+	if (up->rts_pin < 0)
+		return;
+
+	/* RTS PIN is negative assertive. */
+	if (mctrl & TIOCM_RTS)
+		SPORT_UART_ENABLE_RTS(up);
+	else
+		SPORT_UART_DISABLE_RTS(up);
+}
+
+/*
+ * Handle any change of modem status signal.
+ */
+static irqreturn_t sport_mctrl_cts_int(int irq, void *dev_id)
+{
+	struct sport_uart_port *up = (struct sport_uart_port *)dev_id;
+	unsigned int status;
+
+	status = sport_get_mctrl(&up->port);
+	uart_handle_cts_change(&up->port, status & TIOCM_CTS);
+
+	return IRQ_HANDLED;
+}
+#else
+static unsigned int sport_get_mctrl(struct uart_port *port)
+{
+	pr_debug("%s enter\n", __func__);
+	return TIOCM_CTS | TIOCM_CD | TIOCM_DSR;
+}
+
+static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	pr_debug("%s enter\n", __func__);
+}
+#endif
+
 /* Reqeust IRQ, Setup clock */
 static int sport_startup(struct uart_port *port)
 {
@@ -225,6 +282,21 @@ static int sport_startup(struct uart_port *port)
 		goto fail2;
 	}
 
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	if (up->cts_pin >= 0) {
+		if (request_irq(gpio_to_irq(up->cts_pin),
+			sport_mctrl_cts_int,
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
+			IRQF_DISABLED, "BFIN_SPORT_UART_CTS", up)) {
+			up->cts_pin = -1;
+			dev_info(port->dev, "Unable to attach BlackFin UART \
+				over SPORT CTS interrupt. So, disable it.\n");
+		}
+	}
+	if (up->rts_pin >= 0)
+		gpio_direction_output(up->rts_pin, 0);
+#endif
+
 	return 0;
  fail2:
 	free_irq(up->port.irq+1, up);
@@ -282,17 +354,6 @@ static unsigned int sport_tx_empty(struct uart_port *port)
 		return 0;
 }
 
-static unsigned int sport_get_mctrl(struct uart_port *port)
-{
-	pr_debug("%s enter\n", __func__);
-	return (TIOCM_CTS | TIOCM_CD | TIOCM_DSR);
-}
-
-static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
-{
-	pr_debug("%s enter\n", __func__);
-}
-
 static void sport_stop_tx(struct uart_port *port)
 {
 	struct sport_uart_port *up = (struct sport_uart_port *)port;
@@ -363,6 +424,10 @@ static void sport_shutdown(struct uart_port *port)
 	free_irq(up->port.irq, up);
 	free_irq(up->port.irq+1, up);
 	free_irq(up->err_irq, up);
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	if (up->cts_pin >= 0)
+		free_irq(gpio_to_irq(up->cts_pin), up);
+#endif
 }
 
 static const char *sport_type(struct uart_port *port)
@@ -535,7 +600,11 @@ sport_uart_console_setup(struct console *co, char *options)
 	int baud = 57600;
 	int bits = 8;
 	int parity = 'n';
+# ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+	int flow = 'r';
+# else
 	int flow = 'n';
+# endif
 
 	/* Check whether an invalid uart number has been specified */
 	if (co->index < 0 || co->index >= BFIN_SPORT_UART_MAX_PORTS)
@@ -728,6 +797,22 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 			ret = -ENOENT;
 			goto out_error_unmap;
 		}
+#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
+		if (res == NULL)
+			sport->cts_pin = -1;
+		else
+			sport->cts_pin = res->start;
+
+		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
+		if (res == NULL)
+			sport->rts_pin = -1;
+		else
+			sport->rts_pin = res->start;
+
+		if (sport->rts_pin >= 0)
+			gpio_request(sport->rts_pin, DRV_NAME);
+#endif
 	}
 
 #ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
@@ -766,6 +851,10 @@ static int __devexit sport_uart_remove(struct platform_device *pdev)
 
 	if (sport) {
 		uart_remove_one_port(&sport_uart_reg, &sport->port);
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+		if (sport->rts_pin >= 0)
+			gpio_free(sport->rts_pin);
+#endif
 		iounmap(sport->port.membase);
 		peripheral_free_list(
 			(unsigned short *)pdev->dev.platform_data);
diff --git a/drivers/serial/bfin_sport_uart.h b/drivers/serial/bfin_sport_uart.h
index 9791fcc..9ce253e 100644
--- a/drivers/serial/bfin_sport_uart.h
+++ b/drivers/serial/bfin_sport_uart.h
@@ -72,4 +72,15 @@
 
 #define SPORT_TX_FIFO_SIZE	8
 
+#define SPORT_UART_GET_CTS(x)		gpio_get_value(x->cts_pin)
+#define SPORT_UART_DISABLE_RTS(x)	gpio_set_value(x->rts_pin, 1)
+#define SPORT_UART_ENABLE_RTS(x)	gpio_set_value(x->rts_pin, 0)
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT0_UART_CTSRTS) \
+	|| defined(CONFIG_SERIAL_BFIN_SPORT1_UART_CTSRTS) \
+	|| defined(CONFIG_SERIAL_BFIN_SPORT2_UART_CTSRTS) \
+	|| defined(CONFIG_SERIAL_BFIN_SPORT3_UART_CTSRTS)
+# define CONFIG_SERIAL_BFIN_SPORT_CTSRTS
+#endif
+
 #endif /* _BFIN_SPORT_UART_H */
-- 
1.7.0.2

