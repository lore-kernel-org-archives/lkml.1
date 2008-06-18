Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYFRRfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYFRRfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYFRRez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:34:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:48983 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYFRRey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JQ+d4OCIAB9aRbPK8mB8Vy1cQmGZtXhXGVuXfbr/k8YsxKroLS/kWNoD4hgpt+yneQ
         jr/3xo5QPPwAmR1GEk5TQTcyo/vsT4bVgY+rKjPIYMGb4xQYQdR6PhLSSD8BFL6Pc6RV
         WlEWAca+p6XxjhscAcaNDDoTfXY8ek29j3j/Q=
Subject: [PATCH] asic3: add gpiolib support
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 19:34:48 +0200
Message-Id: <1213810488.8144.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the custom asic3_get/set_gpio_value calls with GPIO
API support. asic3_set_gpio_value is removed completely,
asic3_get_gpio_value is unexported but kept for the IRQT_BOTHEDGE
emulation. Now struct asic3 can be made private, so it is moved out of
the public header.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/Kconfig       |    2 +-
 drivers/mfd/asic3.c       |  169 ++++++++++++++++++++++++++++++++++----------
 include/linux/mfd/asic3.h |   14 +----
 3 files changed, 132 insertions(+), 53 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 66c3e53..bbadc9f 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -17,7 +17,7 @@ config MFD_SM501
 
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
-	depends on GENERIC_HARDIRQS && ARM
+	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
 	  PDAs (mainly iPAQ and HTC based ones)
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 7d3488d..f55cebc 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -20,11 +20,33 @@
 #include <linux/kernel.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 
 #include <linux/mfd/asic3.h>
 
+struct asic3;
+
+struct asic3_gpio_chip {
+	struct asic3 *asic;
+	unsigned int base;
+	struct gpio_chip chip;
+};
+
+struct asic3 {
+	void __iomem *mapping;
+	unsigned int bus_shift;
+	unsigned int irq_nr;
+	unsigned int irq_base;
+	spinlock_t lock;
+	u16 irq_bothedge[4];
+	struct asic3_gpio_chip agpio[4];
+	struct device *dev;
+};
+
+int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio);
+
 static inline void asic3_write_register(struct asic3 *asic,
 				 unsigned int reg, u32 value)
 {
@@ -394,6 +416,7 @@ static void asic3_set_gpio(struct asic3 *asic, unsigned int base,
 	     asic3_set_gpio_d((asic), fn, (bits), (pdata)->gpio_d.field); \
 	} while (0)
 
+/* keep this function for now, needed for IRQT_BOTHEDGE emulation above */
 int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio)
 {
 	u32 mask = ASIC3_GPIO_bit(gpio);
@@ -413,40 +436,85 @@ int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio)
 		return -EINVAL;
 	}
 }
-EXPORT_SYMBOL(asic3_gpio_get_value);
 
-void asic3_gpio_set_value(struct asic3 *asic, unsigned gpio, int val)
+static int asic3_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
-	u32 mask = ASIC3_GPIO_bit(gpio);
-	u32 bitval = 0;
-	if (val)
-		bitval = mask;
+	struct asic3_gpio_chip *agpio;
+	struct asic3 *asic;
+	unsigned long flags;
+	int val;
 
-	switch (gpio >> 4) {
-	case ASIC3_GPIO_BANK_A:
-		asic3_set_gpio_a(asic, Out, mask, bitval);
-		return;
-	case ASIC3_GPIO_BANK_B:
-		asic3_set_gpio_b(asic, Out, mask, bitval);
-		return;
-	case ASIC3_GPIO_BANK_C:
-		asic3_set_gpio_c(asic, Out, mask, bitval);
-		return;
-	case ASIC3_GPIO_BANK_D:
-		asic3_set_gpio_d(asic, Out, mask, bitval);
-		return;
-	default:
-		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
-		       __func__, gpio);
-		return;
-	}
+	agpio = container_of(chip, struct asic3_gpio_chip, chip);
+	asic = agpio->asic;
+
+	spin_lock_irqsave(&asic->lock, flags);
+	val = asic3_read_register(asic, agpio->base + ASIC3_GPIO_Direction);
+	val &= ~(1 << offset);
+	asic3_write_register(asic, agpio->base + ASIC3_GPIO_Direction, val);
+	spin_unlock_irqrestore(&asic->lock, flags);
+
+	return 0;
+}
+
+static int asic3_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	struct asic3_gpio_chip *agpio;
+	struct asic3 *asic;
+	unsigned long flags;
+	int val;
+
+	agpio = container_of(chip, struct asic3_gpio_chip, chip);
+	asic = agpio->asic;
+
+	spin_lock_irqsave(&asic->lock, flags);
+	val =  asic3_read_register(asic, agpio->base + ASIC3_GPIO_Direction);
+	val |= (1 << offset);
+	asic3_write_register(asic, agpio->base + ASIC3_GPIO_Direction, val);
+	spin_unlock_irqrestore(&asic->lock, flags);
+
+	return 0;
+}
+
+
+static int asic3_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct asic3_gpio_chip *agpio;
+	struct asic3 *asic;
+
+	agpio = container_of(chip, struct asic3_gpio_chip, chip);
+	asic = agpio->asic;
+
+	return asic3_get_gpio(asic, agpio->base,
+				ASIC3_GPIO_Status) & (1 << offset);
+}
+
+static void asic3_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct asic3_gpio_chip *agpio;
+	struct asic3 *asic;
+	unsigned long flags;
+	int val;
+
+	agpio = container_of(chip, struct asic3_gpio_chip, chip);
+	asic = agpio->asic;
+
+	spin_lock_irqsave(&asic->lock, flags);
+	val = asic3_read_register(asic, agpio->base + ASIC3_GPIO_Out);
+	if (value)
+		val |= (1 << offset);
+	else
+		val &= ~(1 << offset);
+	asic3_write_register(asic, agpio->base + ASIC3_GPIO_Out, val);
+	spin_unlock_irqrestore(&asic->lock, flags);
 }
-EXPORT_SYMBOL(asic3_gpio_set_value);
 
 static int __init asic3_gpio_probe(struct platform_device *pdev)
 {
 	struct asic3_platform_data *pdata = pdev->dev.platform_data;
 	struct asic3 *asic = platform_get_drvdata(pdev);
+	struct gpio_chip *chip;
+	int bank;
 
 	asic3_write_register(asic, ASIC3_GPIO_OFFSET(A, Mask), 0xffff);
 	asic3_write_register(asic, ASIC3_GPIO_OFFSET(B, Mask), 0xffff);
@@ -458,18 +526,34 @@ static int __init asic3_gpio_probe(struct platform_device *pdev)
 	asic3_set_gpio_c(asic, SleepMask, 0xffff, 0xffff);
 	asic3_set_gpio_d(asic, SleepMask, 0xffff, 0xffff);
 
-	if (pdata) {
-		asic3_set_gpio_banks(asic, Out, 0xffff, pdata, init);
-		asic3_set_gpio_banks(asic, Direction, 0xffff, pdata, dir);
-		asic3_set_gpio_banks(asic, SleepMask, 0xffff, pdata,
-				     sleep_mask);
-		asic3_set_gpio_banks(asic, SleepOut, 0xffff, pdata, sleep_out);
-		asic3_set_gpio_banks(asic, BattFaultOut, 0xffff, pdata,
-				     batt_fault_out);
-		asic3_set_gpio_banks(asic, SleepConf, 0xffff, pdata,
-				     sleep_conf);
-		asic3_set_gpio_banks(asic, AltFunction, 0xffff, pdata,
-				     alt_function);
+	if (!pdata)
+		return 0;
+
+	asic3_set_gpio_banks(asic, Out, 0xffff, pdata, init);
+	asic3_set_gpio_banks(asic, Direction, 0xffff, pdata, dir);
+	asic3_set_gpio_banks(asic, SleepMask, 0xffff, pdata,
+			     sleep_mask);
+	asic3_set_gpio_banks(asic, SleepOut, 0xffff, pdata, sleep_out);
+	asic3_set_gpio_banks(asic, BattFaultOut, 0xffff, pdata,
+			     batt_fault_out);
+	asic3_set_gpio_banks(asic, SleepConf, 0xffff, pdata,
+			     sleep_conf);
+	asic3_set_gpio_banks(asic, AltFunction, 0xffff, pdata,
+			     alt_function);
+
+	for (bank = 0; bank < 4; bank++) {
+		asic->agpio[bank].asic = asic;
+		asic->agpio[bank].base = ASIC3_GPIO_A_Base +
+						bank * ASIC3_GPIO_Base_INCR;
+		chip = &(asic->agpio[bank].chip);
+		chip->label = "asic3";
+		chip->get = asic3_gpio_get;
+		chip->set = asic3_gpio_set;
+		chip->direction_input = asic3_gpio_direction_input;
+		chip->direction_output = asic3_gpio_direction_output;
+		chip->base = pdata->gpio_base + 16 * bank;
+		chip->ngpio = 16;
+		gpiochip_add(chip);
 	}
 
 	return 0;
@@ -477,7 +561,11 @@ static int __init asic3_gpio_probe(struct platform_device *pdev)
 
 static void asic3_gpio_remove(struct platform_device *pdev)
 {
-	return;
+	struct asic3 *asic = platform_get_drvdata(pdev);
+	int bank;
+
+	for (bank = 0; bank < 4; bank++)
+		gpiochip_remove(&(asic->agpio[bank].chip));
 }
 
 
@@ -552,8 +640,11 @@ static int __init asic3_probe(struct platform_device *pdev)
 static int asic3_remove(struct platform_device *pdev)
 {
 	struct asic3 *asic = platform_get_drvdata(pdev);
+	int ret;
 
-	asic3_gpio_remove(pdev);
+	ret = asic3_gpio_remove(pdev);
+	if (ret)
+		return ret;
 	asic3_irq_remove(pdev);
 
 	asic3_write_register(asic, ASIC3_OFFSET(CLOCK, SEL), 0);
diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index 4ab2162..f5d5df0 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -16,16 +16,6 @@
 
 #include <linux/types.h>
 
-struct asic3 {
-	void __iomem *mapping;
-	unsigned int bus_shift;
-	unsigned int irq_nr;
-	unsigned int irq_base;
-	spinlock_t lock;
-	u16 irq_bothedge[4];
-	struct device *dev;
-};
-
 struct asic3_platform_data {
 	struct {
 		u32 dir;
@@ -40,14 +30,12 @@ struct asic3_platform_data {
 	unsigned int bus_shift;
 
 	unsigned int irq_base;
+	unsigned int gpio_base;
 
 	struct platform_device **children;
 	unsigned int n_children;
 };
 
-int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio);
-void asic3_gpio_set_value(struct asic3 *asic, unsigned gpio, int val);
-
 #define ASIC3_NUM_GPIO_BANKS	4
 #define ASIC3_GPIOS_PER_BANK	16
 #define ASIC3_NUM_GPIOS		64
-- 
1.5.5.4


