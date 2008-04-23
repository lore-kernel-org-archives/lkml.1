Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbYDWV7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbYDWV7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYDWV7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:59:40 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:57929 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYDWV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:59:40 -0400
Message-ID: <480FB148.5000704@tiscali.nl>
Date: Wed, 23 Apr 2008 23:59:36 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ben-linux@fluff.org, Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial: s3c2410: platform_get_irq() may return signed unnoticed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->irq is unsigned, platform_get_irq() may return signed unnoticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/serial/s3c2410.c b/drivers/serial/s3c2410.c
index 4ffa258..da5a02c 100644
--- a/drivers/serial/s3c2410.c
+++ b/drivers/serial/s3c2410.c
@@ -1022,6 +1022,7 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 	struct uart_port *port = &ourport->port;
 	struct s3c2410_uartcfg *cfg;
 	struct resource *res;
+	int ret;
 
 	dbg("s3c24xx_serial_init_port: port=%p, platdev=%p\n", port, platdev);
 
@@ -1064,9 +1065,11 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 
 	port->mapbase	= res->start;
 	port->membase	= S3C24XX_VA_UART + (res->start - S3C24XX_PA_UART);
-	port->irq	= platform_get_irq(platdev, 0);
-	if (port->irq < 0)
+	ret = platform_get_irq(platdev, 0);
+	if (ret < 0)
 		port->irq = 0;
+	else
+		port->irq = ret;
 
 	ourport->clk	= clk_get(&platdev->dev, "uart");
 
