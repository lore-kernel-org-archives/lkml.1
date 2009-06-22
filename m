Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbZFVPWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbZFVPWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZFVPWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:22:24 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:49156 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbZFVPWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:22:23 -0400
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 2/2] gpio: pl061: fix IRQ handling for GPIOs >= PL061_GPIO_NR
Date: Mon, 22 Jun 2009 18:20:55 +0300
Message-Id: <1245684055-9185-2-git-send-email-baruch@tkos.co.il>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245684055-9185-1-git-send-email-baruch@tkos.co.il>
References: <1245684055-9185-1-git-send-email-baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQ handling is wrong for any GPIO >= PL061_GPIO_NR.

Fix this by implementing and using a proper .to_irq method.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 drivers/gpio/pl061.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/pl061.c b/drivers/gpio/pl061.c
index 80e4839..4ee4c83 100644
--- a/drivers/gpio/pl061.c
+++ b/drivers/gpio/pl061.c
@@ -109,6 +109,16 @@ static void pl061_set_value(struct gpio_chip *gc, unsigned offset, int value)
 	writeb(!!value << offset, chip->base + (1 << (offset + 2)));
 }
 
+static int pl061_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
+
+	if (chip->irq_base == (unsigned) -1)
+		return -EINVAL;
+
+	return chip->irq_base + offset;
+}
+
 /*
  * PL061 GPIO IRQ
  */
@@ -200,7 +210,7 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 	desc->chip->ack(irq);
 	list_for_each(ptr, chip_list) {
 		unsigned long pending;
-		int gpio;
+		int offset;
 
 		chip = list_entry(ptr, struct pl061_gpio, list);
 		pending = readb(chip->base + GPIOMIS);
@@ -209,8 +219,8 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 		if (pending == 0)
 			continue;
 
-		for_each_bit(gpio, &pending, PL061_GPIO_NR)
-			generic_handle_irq(gpio_to_irq(gpio));
+		for_each_bit(offset, &pending, PL061_GPIO_NR)
+			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
 	}
 	desc->chip->unmask(irq);
 }
@@ -251,6 +261,7 @@ static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
 	chip->gc.direction_output = pl061_direction_output;
 	chip->gc.get = pl061_get_value;
 	chip->gc.set = pl061_set_value;
+	chip->gc.to_irq = pl061_to_irq;
 	chip->gc.base = pdata->gpio_base;
 	chip->gc.ngpio = PL061_GPIO_NR;
 	chip->gc.label = dev_name(&dev->dev);
-- 
1.6.3.1

