Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYKCKaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYKCKaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYKCKaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:30:23 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:46227 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbYKCKaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:30:22 -0500
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andrew Victor <avictor.za@gmail.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: keep clock off when it's not needed
Date: Mon,  3 Nov 2008 11:29:56 +0100
Message-Id: <1225708196-32194-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 03 Nov 2008 10:29:36.0961 (UTC) FILETIME=[121ACB10:01C93D9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The atmel_serial driver is mismanaging its clock by leaving it on
at all times ... the whole point of clock management is to leave
it off unless it's actively needed, which conserves power!!

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
[haavard.skinnemoen@atmel.com: Make sure clock is enabled early for console]
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
Although the kernel doesn't actually hang without my fix, it does
discard quite a lot of early console output.

The result still looks correct:

          usart        users= 1 on   35000000 Hz, for atmel_usart.0
          usart        users= 0 off  35000000 Hz, for atmel_usart.2

when using ttyS0 as serial console.

 drivers/serial/atmel_serial.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 61fb8b6..d5efd6c 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -1258,6 +1258,8 @@ static void __devinit atmel_init_port(struct atmel_uart_port *atmel_port,
 		atmel_port->clk = clk_get(&pdev->dev, "usart");
 		clk_enable(atmel_port->clk);
 		port->uartclk = clk_get_rate(atmel_port->clk);
+		clk_disable(atmel_port->clk);
+		/* only enable clock when USART is in use */
 	}
 
 	atmel_port->use_dma_rx = data->use_dma_rx;
@@ -1379,6 +1381,8 @@ static int __init atmel_console_setup(struct console *co, char *options)
 		return -ENODEV;
 	}
 
+	clk_enable(atmel_ports[co->index].clk);
+
 	UART_PUT_IDR(port, -1);
 	UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
 	UART_PUT_CR(port, ATMEL_US_TXEN | ATMEL_US_RXEN);
@@ -1403,7 +1407,7 @@ static struct console atmel_console = {
 	.data		= &atmel_uart,
 };
 
-#define ATMEL_CONSOLE_DEVICE	&atmel_console
+#define ATMEL_CONSOLE_DEVICE	(&atmel_console)
 
 /*
  * Early console initialization (before VM subsystem initialized).
@@ -1534,6 +1538,15 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_add_port;
 
+	if (atmel_is_console_port(&port->uart)
+			&& ATMEL_CONSOLE_DEVICE->flags & CON_ENABLED) {
+		/*
+		 * The serial core enabled the clock for us, so undo
+		 * the clk_enable() in atmel_console_setup()
+		 */
+		clk_disable(port->clk);
+	}
+
 	device_init_wakeup(&pdev->dev, 1);
 	platform_set_drvdata(pdev, port);
 
@@ -1544,7 +1557,6 @@ err_add_port:
 	port->rx_ring.buf = NULL;
 err_alloc_ring:
 	if (!atmel_is_console_port(&port->uart)) {
-		clk_disable(port->clk);
 		clk_put(port->clk);
 		port->clk = NULL;
 	}
@@ -1568,7 +1580,6 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
 
 	/* "port" is allocated statically, so we shouldn't free it */
 
-	clk_disable(atmel_port->clk);
 	clk_put(atmel_port->clk);
 
 	return ret;
-- 
1.5.6.5

