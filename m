Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0CBXhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:37:07 -0500
Received: from kroah.org ([198.145.64.141]:51576 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab0CBXgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/36] serial: fix test of unsigned
Date: Tue,  2 Mar 2010 15:36:16 -0800
Message-Id: <1267573003-782-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

The variables were unsigned so the tests did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/msm_serial.c |    6 ++++--
 drivers/serial/timbuart.c   |    7 ++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
index b05c5aa..ecdc0fa 100644
--- a/drivers/serial/msm_serial.c
+++ b/drivers/serial/msm_serial.c
@@ -691,6 +691,7 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 	struct msm_port *msm_port;
 	struct resource *resource;
 	struct uart_port *port;
+	int irq;
 
 	if (unlikely(pdev->id < 0 || pdev->id >= UART_NR))
 		return -ENXIO;
@@ -711,9 +712,10 @@ static int __init msm_serial_probe(struct platform_device *pdev)
 		return -ENXIO;
 	port->mapbase = resource->start;
 
-	port->irq = platform_get_irq(pdev, 0);
-	if (unlikely(port->irq < 0))
+	irq = platform_get_irq(pdev, 0);
+	if (unlikely(irq < 0))
 		return -ENXIO;
+	port->irq = irq;
 
 	platform_set_drvdata(pdev, port);
 
diff --git a/drivers/serial/timbuart.c b/drivers/serial/timbuart.c
index 34b31da..7bf1026 100644
--- a/drivers/serial/timbuart.c
+++ b/drivers/serial/timbuart.c
@@ -421,7 +421,7 @@ static struct uart_driver timbuart_driver = {
 
 static int timbuart_probe(struct platform_device *dev)
 {
-	int err;
+	int err, irq;
 	struct timbuart_port *uart;
 	struct resource *iomem;
 
@@ -453,11 +453,12 @@ static int timbuart_probe(struct platform_device *dev)
 	uart->port.mapbase = iomem->start;
 	uart->port.membase = NULL;
 
-	uart->port.irq = platform_get_irq(dev, 0);
-	if (uart->port.irq < 0) {
+	irq = platform_get_irq(dev, 0);
+	if (irq < 0) {
 		err = -EINVAL;
 		goto err_register;
 	}
+	uart->port.irq = irq;
 
 	tasklet_init(&uart->tasklet, timbuart_tasklet, (unsigned long)uart);
 
-- 
1.7.0.1

