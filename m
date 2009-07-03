Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZGCNPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZGCNPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZGCNPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:15:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:5211 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZGCNPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:15:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,342,1243839600"; 
   d="scan'208,223";a="471783069"
Date: Fri, 3 Jul 2009 21:10:34 +0800
From: Alek Du <alek.du@intel.com>
To: David Brownell <david-b@pacbell.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: pca953x: add irq_chip for irq demuxing
Message-ID: <20090703211034.47fc0880@dxy.sh.intel.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 02227060687d8ce8254714d9812e19b815463dd4 Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Wed, 1 Jul 2009 17:07:00 +0800
Subject: [PATCH] gpio: pca953x: add irq_chip for irq demuxing

This patch is required when using this gpio driver with gpio_keys driver

Signed-off-by: Alek Du <alek.du@intel.com>
CC: David Brownell <david-b@pacbell.net>
---
 drivers/gpio/pca953x.c      |   54 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pca953x.h |    3 ++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 8ab1308..47c1d99 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
 #ifdef CONFIG_OF_GPIO
@@ -51,6 +52,7 @@ MODULE_DEVICE_TABLE(i2c, pca953x_id);
 
 struct pca953x_chip {
 	unsigned gpio_start;
+	unsigned irq_base;
 	uint16_t reg_output;
 	uint16_t reg_direction;
 
@@ -183,6 +185,13 @@ static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 	chip->reg_output = reg_val;
 }
 
+static int pca953x_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
+{
+	struct pca953x_chip *chip = container_of(gc, struct pca953x_chip,
+								gpio_chip);
+	return chip->irq_base + offset;
+}
+
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
 	struct gpio_chip *gc;
@@ -193,6 +202,7 @@ static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 	gc->direction_output = pca953x_gpio_direction_output;
 	gc->get = pca953x_gpio_get_value;
 	gc->set = pca953x_gpio_set_value;
+	gc->to_irq = pca953x_gpio_to_irq;
 	gc->can_sleep = 1;
 
 	gc->base = chip->gpio_start;
@@ -251,6 +261,34 @@ pca953x_get_alt_pdata(struct i2c_client *client)
 }
 #endif
 
+/* the irq_chip at least needs one handler */
+static void pca953x_irq_unmask(unsigned irq)
+{
+}
+
+static struct irq_chip pca953x_irqchip = {
+	.name		= "pca953x_irqchip",
+	.unmask		= pca953x_irq_unmask,
+};
+
+static void pca953x_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct pca953x_chip *chip = (struct pca953x_chip *)get_irq_data(irq);
+	int i;
+
+	if (desc->chip->ack)
+		desc->chip->ack(irq);
+	/* we must call all sub-irqs, since there is no way to read
+	 * I2C gpio expander's status in irq context. The driver itself
+	 * would be reponsible to check if the irq is for him.
+	 */
+	for (i = 0; i < chip->gpio_chip.ngpio; i++)
+		generic_handle_irq(chip->irq_base + i);
+
+	if (desc->chip->unmask)
+		desc->chip->unmask(irq);
+}
+
 static int __devinit pca953x_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
@@ -284,6 +322,8 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 
 	chip->names = pdata->names;
 
+	chip->irq_base = pdata->irq_base;
+
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
@@ -315,6 +355,20 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	}
 
 	i2c_set_clientdata(client, chip);
+
+	if (chip->irq_base) {
+		int i;
+
+		set_irq_type(client->irq,
+				IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING);
+		set_irq_chained_handler(client->irq, pca953x_irq_handler);
+		set_irq_data(client->irq, chip);
+		for (i = 0; i < chip->gpio_chip.ngpio; i++) {
+			set_irq_chip_and_handler_name(i + chip->irq_base,
+				&pca953x_irqchip, handle_simple_irq, "demux");
+			set_irq_chip_data(i + chip->irq_base, chip);
+		}
+	}
 	return 0;
 
 out_failed:
diff --git a/include/linux/i2c/pca953x.h b/include/linux/i2c/pca953x.h
index 81736d6..bf7c0a3 100644
--- a/include/linux/i2c/pca953x.h
+++ b/include/linux/i2c/pca953x.h
@@ -4,6 +4,9 @@ struct pca953x_platform_data {
 	/* number of the first GPIO */
 	unsigned	gpio_base;
 
+	/* number of the first IRQ */
+	unsigned	irq_base;
+
 	/* initial polarity inversion setting */
 	uint16_t	invert;
 
-- 
1.6.0.4
