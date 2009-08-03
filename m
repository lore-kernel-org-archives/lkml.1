Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbZHCOjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbZHCOjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932181AbZHCOjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:39:24 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:34103 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbZHCOjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:39:23 -0400
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: haavard.skinnemoen@atmel.com
Cc: nicolas.ferre@atmel.com, linux@maxim.org.za, linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH] Switch atmel_serial to dev_pm_ops
Date: Mon,  3 Aug 2009 16:39:07 +0200
Message-Id: <1249310347-22291-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 drivers/serial/atmel_serial.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 607d43a..3546ead 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -38,6 +38,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/atmel_pdc.h>
 #include <linux/atmel_serial.h>
+#include <linux/pm.h>
 
 #include <asm/io.h>
 
@@ -1488,10 +1489,9 @@ static bool atmel_serial_clk_will_stop(void)
 #endif
 }
 
-static int atmel_serial_suspend(struct platform_device *pdev,
-				pm_message_t state)
+static int atmel_serial_suspend(struct device *dev)
 {
-	struct uart_port *port = platform_get_drvdata(pdev);
+	struct uart_port *port = dev_get_drvdata(dev);
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_is_console_port(port) && console_suspend_enabled) {
@@ -1501,28 +1501,32 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 	}
 
 	/* we can not wake up if we're running on slow clock */
-	atmel_port->may_wakeup = device_may_wakeup(&pdev->dev);
+	atmel_port->may_wakeup = device_may_wakeup(dev);
 	if (atmel_serial_clk_will_stop())
-		device_set_wakeup_enable(&pdev->dev, 0);
+		device_set_wakeup_enable(dev, 0);
 
 	uart_suspend_port(&atmel_uart, port);
 
 	return 0;
 }
 
-static int atmel_serial_resume(struct platform_device *pdev)
+static int atmel_serial_resume(struct device *dev)
 {
-	struct uart_port *port = platform_get_drvdata(pdev);
+	struct uart_port *port = dev_get_drvdata(dev);
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	uart_resume_port(&atmel_uart, port);
-	device_set_wakeup_enable(&pdev->dev, atmel_port->may_wakeup);
+	device_set_wakeup_enable(dev, atmel_port->may_wakeup);
 
 	return 0;
 }
+
+static struct dev_pm_ops atmel_serial_pm_ops = {
+	.suspend = atmel_serial_suspend,
+	.resume = atmel_serial_resume,
+};
 #else
-#define atmel_serial_suspend NULL
-#define atmel_serial_resume NULL
+static struct dev_pm_ops atmel_serial_pm_ops;
 #endif
 
 static int __devinit atmel_serial_probe(struct platform_device *pdev)
@@ -1603,11 +1607,10 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
 static struct platform_driver atmel_serial_driver = {
 	.probe		= atmel_serial_probe,
 	.remove		= __devexit_p(atmel_serial_remove),
-	.suspend	= atmel_serial_suspend,
-	.resume		= atmel_serial_resume,
 	.driver		= {
 		.name	= "atmel_usart",
 		.owner	= THIS_MODULE,
+		.pm = &atmel_serial_pm_ops,
 	},
 };
 
-- 
1.6.3.3

