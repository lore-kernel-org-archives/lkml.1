Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZKVDWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZKVDWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 22:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbZKVDWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 22:22:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:22571 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbZKVDWs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 22:22:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,265,1257148800"; 
   d="scan'208,223";a="571910649"
Date: Sun, 22 Nov 2009 11:19:01 +0800
From: Alek Du <alek.du@intel.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] gpio: Langwell GPIO driver miscellaneous clean-ups
Message-ID: <20091122111901.5e99a391@dxy.sh.intel.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9ba8224f5246ef7fdf1c0a15bb5535e442731435 Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Sun, 22 Nov 2009 10:58:21 +0800
Subject: [PATCH] gpio: Langwell GPIO driver miscellaneous clean-ups

1. Use >= N to check invalid gpio number (unsigned type)
2. Remove wrong and unnecessary unmask operation
3. Remove extra GEDR reading

The 2) and 3) will fix interrupts losing when two or more pins are triggered at close time.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/gpio/langwell_gpio.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 5711ce5..6c0ebbd 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -123,7 +123,7 @@ static int lnw_irq_type(unsigned irq, unsigned type)
 	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
 	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
 
-	if (gpio < 0 || gpio > lnw->chip.ngpio)
+	if (gpio >= lnw->chip.ngpio)
 		return -EINVAL;
 	spin_lock_irqsave(&lnw->lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
@@ -144,13 +144,6 @@ static int lnw_irq_type(unsigned irq, unsigned type)
 
 static void lnw_irq_unmask(unsigned irq)
 {
-	struct lnw_gpio *lnw = get_irq_chip_data(irq);
-	u32 gpio = irq - lnw->irq_base;
-	u8 reg = gpio / 32;
-	void __iomem *gedr;
-
-	gedr = (void __iomem *)(&lnw->reg_base->GEDR[reg]);
-	writel(BIT(gpio % 32), gedr);
 };
 
 static void lnw_irq_mask(unsigned irq)
@@ -183,13 +176,11 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 		gedr_v = readl(gedr);
 		if (!gedr_v)
 			continue;
-		for (gpio = reg*32; gpio < reg*32+32; gpio++) {
-			gedr_v = readl(gedr);
+		for (gpio = reg*32; gpio < reg*32+32; gpio++)
 			if (gedr_v & BIT(gpio % 32)) {
 				pr_debug("pin %d triggered\n", gpio);
 				generic_handle_irq(lnw->irq_base + gpio);
 			}
-		}
 		/* clear the edge detect status bit */
 		writel(gedr_v, gedr);
 	}
-- 
1.6.3.3

