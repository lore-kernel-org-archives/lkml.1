Return-Path: <linux-kernel-owner+w=401wt.eu-S933399AbZLOTRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399AbZLOTRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbZLOTRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:17:48 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:60902 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbZLOTRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:17:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rIWILICIwmerw5p/24Nf7ZTTW7ldRnw1LcJK3btIoPg2h2B7CCN39scF2AcNdtx3cu
         mGxv1+uQkhgLB0IouZ80p1OvmfFNjxThK5kvqfsH/1mI/jZ20xgtc0aVKDMA0068FzEU
         wHJ5tOoDA4KS1PGsbEilJWvo6SnOKFlRKT/bM=
Message-ID: <4B27E146.1070206@gmail.com>
Date: Tue, 15 Dec 2009 20:19:34 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial: Fix test of unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables were unsigned so the tests did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

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
 
