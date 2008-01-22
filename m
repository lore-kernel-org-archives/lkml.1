Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbYAVOvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbYAVOvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYAVOvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:51:33 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53528 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751587AbYAVOvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:51:32 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <linux@maxim.org.za>
Cc: Remy Bohmer <linux@bohmer.net>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH 4/6] atmel_serial: Fix bugs in probe() error path and remove()
Date: Tue, 22 Jan 2008 15:50:42 +0100
Message-Id: <1201013444-30370-5-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201013444-30370-4-git-send-email-hskinnemoen@atmel.com>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
 <1201013444-30370-2-git-send-email-hskinnemoen@atmel.com>
 <1201013444-30370-3-git-send-email-hskinnemoen@atmel.com>
 <1201013444-30370-4-git-send-email-hskinnemoen@atmel.com>
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
index 38bdc7a..f44316f 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -938,8 +938,18 @@ static int __init atmel_late_console_init(void)
 
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
@@ -997,9 +1007,19 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
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
@@ -1011,16 +1031,15 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
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
1.5.3.7

