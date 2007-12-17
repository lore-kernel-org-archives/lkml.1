Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbXLQGca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbXLQGca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 01:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbXLQGcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 01:32:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:27226 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbXLQGcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 01:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pg53Ry7Anb3ccqblO5qlsgSj88RXJetrvX9KqWh0AV6lvWK3DWjD4diBEg7Ou4bYxNQfNx46OXQj+xuPNtA0nsNq7UzPFRYDrL6E5XzprR6Fb29o6uSHNjdZ29UKpFkjWI4+OVkQVx+sBQ6mqEjmjzPv6DYQFiAd2hKmX2uS0P8=
Message-ID: <f17812d70712162232t4ff0164exccd47c4fe0c700af@mail.gmail.com>
Date: Mon, 17 Dec 2007 14:32:19 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: [PATCH 2.6.24-rc5-mm 2/3] gpiolib: add Generic IRQ support for 16-bit PCA9539 GPIO expander
Cc: "David Brownell" <david-b@pacbell.net>,
       "Jean Delvare" <khali@linux-fr.org>,
       "Ben Gardner" <bgardner@wabtec.com>
In-Reply-To: <f17812d70712142015t1dedf9ecq33a4d45a0c5f033c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70712142015t1dedf9ecq33a4d45a0c5f033c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[updated according to David's suggestion to handle the error
of I2C transfer]

>From c9b78718488dadc702f40789bd532d1f1765d76e Mon Sep 17 00:00:00 2001
From: eric miao <eric.miao@marvell.com>
Date: Mon, 10 Dec 2007 17:24:36 +0800
Subject: [PATCH] gpiolib: add Generic IRQ support for 16-bit PCA9539
GPIO expander

This patch adds the generic IRQ support for the PCA9539 on-chip GPIOs.

Note: due to the inaccessibility of the generic IRQ code within modules,
this support is only available if the driver is built-in.

Signed-off-by: eric miao <eric.miao@marvell.com>
---
 drivers/gpio/Kconfig   |   11 +++-
 drivers/gpio/pca9539.c |  185 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4b54f60..a4f89a6 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -17,7 +17,16 @@ config GPIO_PCA9539
 	  parts are made by NXP and TI.

 	  This driver can also be built as a module.  If so, the module
-	  will be called pca9539.
+	  will be called pca9539.  Note: the Generic IRQ support for the
+	  chip will only be available if the driver is built-in
+
+config GPIO_PCA9539_GENERIC_IRQ
+	bool "Generic IRQ support for PCA9539"
+	depends on GPIO_PCA9539=y && GENERIC_HARDIRQS
+	help
+	  Say yes here to support the Generic IRQ for the PCA9539 on-chip
+	  GPIO lines. Only pin-changed IRQs (IRQ_TYPE_EDGE_BOTH) are
+	  supported in hardware.

 config GPIO_PCF857X
 	tristate "PCF857x, PCA857x, and PCA967x I2C GPIO expanders"
diff --git a/drivers/gpio/pca9539.c b/drivers/gpio/pca9539.c
index fc8bee4..10f9549 100644
--- a/drivers/gpio/pca9539.c
+++ b/drivers/gpio/pca9539.c
@@ -14,6 +14,9 @@

 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca9539.h>

@@ -33,6 +36,22 @@ struct pca9539_chip {

 	struct i2c_client *client;
 	struct gpio_chip gpio_chip;
+#ifdef CONFIG_GPIO_PCA9539_GENERIC_IRQ
+	/*
+	 * Note: Generic IRQ is not accessible within module code, the IRQ
+	 * support will thus _only_ be available if the driver is built-in
+	 */
+	int irq;	/* IRQ for the chip itself */
+	int irq_start;	/* starting IRQ for the on-chip GPIO lines */
+
+	uint16_t irq_mask;
+	uint16_t irq_falling_edge;
+	uint16_t irq_rising_edge;
+	uint16_t last_input;
+
+	struct irq_chip irq_chip;
+	struct work_struct irq_work;
+#endif
 };

 static int pca9539_write_reg(struct pca9539_chip *chip, int reg, uint16_t val)
@@ -155,6 +174,158 @@ static int pca9539_init_gpio(struct pca9539_chip *chip)
 	return gpiochip_add(gc);
 }

+#ifdef CONFIG_GPIO_PCA9539_GENERIC_IRQ
+/* FIXME: change to schedule_delayed_work() here if reading out of
+ * registers does not reflect the actual pin levels
+ */
+
+static void pca9539_irq_work(struct work_struct *work)
+{
+	struct pca9539_chip *chip;
+	uint16_t input, mask, rising, falling;
+	int ret, i;
+
+	chip = container_of(work, struct pca9539_chip, irq_work);
+
+	ret = pca9539_read_reg(chip, PCA9539_INPUT, &input);
+	if (ret < 0)
+		return;
+
+	mask = (input ^ chip->last_input) & chip->irq_mask;
+	rising = (input & mask) & chip->irq_rising_edge;
+	falling = (~input & mask) & chip->irq_falling_edge;
+
+	irq_enter();
+
+	for (i = 0; i < NR_PCA9539_GPIOS; i++) {
+		if ((rising | falling) & (1u << i)) {
+			int irq = chip->irq_start + i;
+			struct irq_desc *desc;
+
+			desc = irq_desc + irq;
+			desc_handle_irq(irq, desc);
+		}
+	}
+
+	irq_exit();
+
+	chip->last_input = input;
+}
+
+static void fastcall
+pca9539_irq_demux(unsigned int irq, struct irq_desc *desc)
+{
+	struct pca9539_chip *chip = desc->handler_data;
+
+	desc->chip->mask(chip->irq);
+	desc->chip->ack(chip->irq);
+	schedule_work(&chip->irq_work);
+	desc->chip->unmask(chip->irq);
+}
+
+static void pca9539_irq_mask(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+	struct pca9539_chip *chip = desc->chip_data;
+
+	chip->irq_mask &= ~(1u << (irq - chip->irq_start));
+}
+
+static void pca9539_irq_unmask(unsigned int irq)
+{
+	struct irq_desc *desc = irq_desc + irq;
+	struct pca9539_chip *chip = desc->chip_data;
+
+	chip->irq_mask |= 1u << (irq - chip->irq_start);
+}
+
+static void pca9539_irq_ack(unsigned int irq)
+{
+	/* unfortunately, we have to provide an empty irq_chip.ack even
+	 * if we do nothing here, Generic IRQ will complain otherwise
+	 */
+}
+
+static int pca9539_irq_set_type(unsigned int irq, unsigned int type)
+{
+	struct irq_desc *desc = irq_desc + irq;
+	struct pca9539_chip *chip = desc->chip_data;
+	uint16_t mask = 1u << (irq - chip->irq_start);
+
+	if (type == IRQT_PROBE) {
+		if ((mask & chip->irq_rising_edge) ||
+		    (mask & chip->irq_falling_edge) ||
+		    (mask & ~chip->reg_direction))
+			return 0;
+
+		type = __IRQT_RISEDGE | __IRQT_FALEDGE;
+	}
+
+	gpio_direction_input(irq_to_gpio(irq));
+
+	if (type & __IRQT_RISEDGE)
+		chip->irq_rising_edge |= mask;
+	else
+		chip->irq_rising_edge &= ~mask;
+
+	if (type & __IRQT_FALEDGE)
+		chip->irq_falling_edge |= mask;
+	else
+		chip->irq_falling_edge &= ~mask;
+
+	return 0;
+}
+
+static int pca9539_init_irq(struct pca9539_chip *chip)
+{
+	struct irq_chip *ic = &chip->irq_chip;
+	int ret, irq, irq_start;
+
+	/* initial input register value for IRQ level change detection */
+	ret = pca9539_read_reg(chip, PCA9539_INPUT, &chip->last_input);
+	if (ret)
+		return -EIO;
+
+	chip->irq = chip->client->irq;
+	chip->irq_start = irq_start = gpio_to_irq(chip->gpio_start);
+
+	/* do not install GPIO interrupts for the chip if
+	 * 1. the PCA9539 interrupt line is not used
+	 * 2. or the GPIO interrupt number exceeds NR_IRQS
+	 */
+	if (chip->irq <= 0 || irq_start + NR_PCA9539_GPIOS >= NR_IRQS)
+		return -EINVAL;
+
+	chip->irq_mask	= 0;
+	chip->irq_rising_edge  = 0;
+	chip->irq_falling_edge = 0;
+
+	ic->ack = pca9539_irq_ack;
+	ic->mask = pca9539_irq_mask;
+	ic->unmask = pca9539_irq_unmask;
+	ic->set_type = pca9539_irq_set_type;
+
+	for (irq = irq_start; irq < irq_start + NR_PCA9539_GPIOS; irq++) {
+		set_irq_chip(irq, ic);
+		set_irq_chip_data(irq, chip);
+		set_irq_handler(irq, handle_edge_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+
+	set_irq_type(chip->irq, IRQT_FALLING);
+	set_irq_data(chip->irq, chip);
+	set_irq_chained_handler(chip->irq, pca9539_irq_demux);
+
+	INIT_WORK(&chip->irq_work, pca9539_irq_work);
+	return 0;
+}
+#else
+static inline int pca9539_init_irq(struct pca9539_chip *chip)
+{
+	return 0;
+}
+#endif /* CONFIG_GPIO_PCA9539_GENERIC_IRQ */
+
 static int __devinit pca9539_probe(struct i2c_client *client)
 {
 	struct pca9539_platform_data *pdata;
@@ -204,6 +375,12 @@ static int __devinit pca9539_probe(struct
i2c_client *client)
 			dev_dbg(&client->dev, "setup failed, %d\n", ret);
 	}

+	ret = pca9539_init_irq(chip);
+	if (ret) {
+		ret = gpiochip_remove(&chip->gpio_chip);
+		goto out_failed;
+	}
+
 	i2c_set_clientdata(client, chip);
 	return 0;

@@ -212,6 +389,13 @@ out_failed:
 	return ret;
 }

+#ifdef CONFIG_GPIO_PCA9539_GENERIC_IRQ
+static int pca9539_remove(struct i2c_client *client)
+{
+	dev_err(&client->dev, "failed to unload driver with IRQ support\n");
+	return -EINVAL;
+}
+#else
 static int pca9539_remove(struct i2c_client *client)
 {
 	struct pca9539_platform_data *pdata = client->dev.platform_data;
@@ -234,6 +418,7 @@ static int pca9539_remove(struct i2c_client *client)
 	kfree(chip);
 	return 0;
 }
+#endif /* CONFIG_GPIO_PCA9539_GENERIC_IRQ */

 static struct i2c_driver pca9539_driver = {
 	.driver = {
-- 
1.5.2.5.GIT

---
Cheers
- eric
