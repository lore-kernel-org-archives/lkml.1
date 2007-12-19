Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbXLSPOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbXLSPOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 10:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXLSPOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 10:14:31 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52803 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753467AbXLSPOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 10:14:30 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>, linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH v2 4/6] atmel_serial: Fix bugs in probe() error path and remove()
Date: Wed, 19 Dec 2007 16:12:08 +0100
Message-Id: <1198077130-9021-5-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198077130-9021-4-git-send-email-hskinnemoen@atmel.com>
References: <1198077130-9021-1-git-send-email-hskinnemoen@atmel.com>
 <1198077130-9021-2-git-send-email-hskinnemoen@atmel.com>
 <1198077130-9021-3-git-send-email-hskinnemoen@atmel.com>
 <1198077130-9021-4-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an error happens in probe(), the clocks should be disabled, but
only if the port isn't already used as a console.

In remove(), the port struct shouldn't be freed because it's defined
statically.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |   39 +++++++++++++++++++++++++++++----------
 1 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index a6b3828..d2b4b0a 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -941,8 +941,18 @@ static int __init atmel_late_console_init(void)
 
 core_initcall(atmel_late_console_init);
 
+static inline bool atmel_is_console_port(struct uart_port *port)
+{
+	return port->cons && port->cons->index == port->line;
+}
+
 #else
 #define ATMEL_CONSOLE_DEVICE	NULL
+
+static inline bool atmel_is_console_port(struct uart_port *port)
+{
+	return false;
+}
 #endif
 
 static struct uart_driver atmel_uart = {
@@ -1000,9 +1010,19 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
 	atmel_init_port(port, pdev);
 
 	ret = uart_add_one_port(&atmel_uart, &port->uart);
-	if (!ret) {
-		device_init_wakeup(&pdev->dev, 1);
-		platform_set_drvdata(pdev, port);
+	if (ret)
+		goto err_add_port;
+
+	device_init_wakeup(&pdev->dev, 1);
+	platform_set_drvdata(pdev, port);
+
+	return 0;
+
+err_add_port:
+	if (!atmel_is_console_port(&port->uart)) {
+		clk_disable(port->clk);
+		clk_put(port->clk);
+		port->clk = NULL;
 	}
 
 	return ret;
@@ -1014,16 +1034,15 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 	int ret = 0;
 
-	clk_disable(atmel_port->clk);
-	clk_put(atmel_port->clk);
-
 	device_init_wakeup(&pdev->dev, 0);
 	platform_set_drvdata(pdev, NULL);
 
-	if (port) {
-		ret = uart_remove_one_port(&atmel_uart, port);
-		kfree(port);
-	}
+	ret = uart_remove_one_port(&atmel_uart, port);
+
+	/* "port" is allocated statically, so we shouldn't free it */
+
+	clk_disable(atmel_port->clk);
+	clk_put(atmel_port->clk);
 
 	return ret;
 }
-- 
1.5.3.4

