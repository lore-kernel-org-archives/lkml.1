Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbZKUNnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbZKUNnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbZKUNnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:43:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41031 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbZKUNj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:39:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=TIhymfmX7YkIzjNCT4yIYEuzuPmZ3KDwUQmhJa54JG0yxs0BlIDyCJ9klTP41uK84S
         4tB6DOcIkleHLFk7n3s8q0QVEOdfzW//39bbL3iEe40Bq10v6DDHMHj8XLuKCS7UtNrt
         Nqy67hbW28lnioVWvFhfdC/YSrdsZBAusHAlo=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 3/9] Serial: sc26xx - use interrupt trigger flags from
	resources.
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:40:03 +0100
Message-ID: <20091121134003.16090.79502.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows platform resources to specify interrupt flags.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/serial/sc26xx.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index dc09682..ca74bf6 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -631,7 +631,7 @@ static void __devinit sc26xx_init_masks(struct uart_sc26xx_port *up,
 
 static int __devinit sc26xx_probe(struct platform_device *dev)
 {
-	struct resource *res;
+	struct resource *res, *irq_res;
 	struct uart_sc26xx_port *up;
 	unsigned int *sc26xx_data = dev->dev.platform_data;
 	int err;
@@ -640,6 +640,10 @@ static int __devinit sc26xx_probe(struct platform_device *dev)
 	if (!res)
 		return -ENODEV;
 
+	irq_res = platform_get_resource(dev, IORESOURCE_IRQ, 0);
+	if (!irq_res)
+		return -ENXIO;
+
 	up = kzalloc(sizeof *up, GFP_KERNEL);
 	if (unlikely(!up))
 		return -ENOMEM;
@@ -652,7 +656,7 @@ static int __devinit sc26xx_probe(struct platform_device *dev)
 	up->port[0].mapbase = res->start;
 	up->port[0].membase = ioremap_nocache(up->port[0].mapbase, 0x40);
 	up->port[0].iotype = UPIO_MEM;
-	up->port[0].irq = platform_get_irq(dev, 0);
+	up->port[0].irq = irq_res->start;
 
 	up->port[0].dev = &dev->dev;
 
@@ -688,7 +692,8 @@ static int __devinit sc26xx_probe(struct platform_device *dev)
 	if (err)
 		goto out_remove_port0;
 
-	err = request_irq(up->port[0].irq, sc26xx_interrupt, 0, "sc26xx", up);
+	err = request_irq(up->port[0].irq, sc26xx_interrupt,
+		irq_res->flags & IRQF_TRIGGER_MASK, "sc26xx", up);
 	if (err)
 		goto out_remove_ports;
 

