Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221Ab0ATNXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0ATNXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666Ab0ATNXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:23:09 -0500
Received: from relay.bearnet.nu ([80.252.223.222]:1561 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0ATNXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:23:08 -0500
X-Greylist: delayed 894 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 08:23:07 EST
Message-ID: <4B570031.6090405@pelagicore.com>
Date: Wed, 20 Jan 2010 14:08:01 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: timbgpio: Add support for interrupt triggering on both flanks
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces support for triggering interrupts on both rising
and falling edge.

This feature requires version 3 or newer of the IP, a version check is done
when triggering on both edges is requested.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index a4d344b..471be03 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -37,6 +37,8 @@
 #define TGPIO_ICR	0x14
 #define TGPIO_FLR	0x18
 #define TGPIO_LVR	0x1c
+#define TGPIO_VER	0x20
+#define TGPIO_BFLR	0x24

 struct timbgpio {
 	void __iomem		*membase;
@@ -125,17 +127,23 @@ static int timbgpio_irq_type(unsigned irq, unsigned trigger)
 	struct timbgpio *tgpio = get_irq_chip_data(irq);
 	int offset = irq - tgpio->irq_base;
 	unsigned long flags;
-	u32 lvr, flr;
+	u32 lvr, flr, bflr = 0;
+	u32 ver;

 	if (offset < 0 || offset > tgpio->gpio.ngpio)
 		return -EINVAL;

+	ver = ioread32(tgpio->membase + TGPIO_VER);
+
 	spin_lock_irqsave(&tgpio->lock, flags);

 	lvr = ioread32(tgpio->membase + TGPIO_LVR);
 	flr = ioread32(tgpio->membase + TGPIO_FLR);
+	if (ver > 2)
+		bflr = ioread32(tgpio->membase + TGPIO_BFLR);

 	if (trigger & (IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW)) {
+		bflr &= ~(1 << offset);
 		flr &= ~(1 << offset);
 		if (trigger & IRQ_TYPE_LEVEL_HIGH)
 			lvr |= 1 << offset;
@@ -143,21 +151,27 @@ static int timbgpio_irq_type(unsigned irq, unsigned trigger)
 			lvr &= ~(1 << offset);
 	}

-	if ((trigger & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH)
-		return -EINVAL;
-	else {
+	if ((trigger & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
+		if (ver < 3)
+			return -EINVAL;
+		else {
+			flr |= 1 << offset;
+			bflr |= 1 << offset;
+		}
+	} else {
+		bflr &= ~(1 << offset);
 		flr |= 1 << offset;
-		/* opposite compared to the datasheet, but it mirrors the
-		 * reality
-		 */
 		if (trigger & IRQ_TYPE_EDGE_FALLING)
-			lvr |= 1 << offset;
-		else
 			lvr &= ~(1 << offset);
+		else
+			lvr |= 1 << offset;
 	}

 	iowrite32(lvr, tgpio->membase + TGPIO_LVR);
 	iowrite32(flr, tgpio->membase + TGPIO_FLR);
+	if (ver > 2)
+		iowrite32(bflr, tgpio->membase + TGPIO_BFLR);
+
 	iowrite32(1 << offset, tgpio->membase + TGPIO_ICR);
 	spin_unlock_irqrestore(&tgpio->lock, flags);


