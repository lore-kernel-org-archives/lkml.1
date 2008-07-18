Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbYGRNEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbYGRNEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbYGRNEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:04:38 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:54959 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752948AbYGRNEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:04:37 -0400
Date: Fri, 18 Jul 2008 14:04:33 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>
Subject: Add to_irq fields to gpiolib (with sample implementation)
Message-ID: <20080718130433.GA24568@fluff.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The two patches form a pair of patches to show
that we should consider adding an to_irq field
to the gpio_chip structure and gpiolib support.

The reason is that if we add support for devices
registering gpio to also register interrputs, then
a single arch-dependant interrupt mapping is not
going to be sufficient.

Note, this set does not remove any clashing
definitions that may have of gpio_to_irq.

---
GPIO: Add generic gpio_to_irq call.

Add gpio_to_irq() implementation allowing the
gpio_chip registration to also specify an function
to map GPIO offsets into IRQs.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt3/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6.26-quilt3.orig/drivers/gpio/gpiolib.c	2008-07-18 00:40:52.000000000 +0100
+++ linux-2.6.26-quilt3/drivers/gpio/gpiolib.c	2008-07-18 00:52:07.000000000 +0100
@@ -339,6 +339,36 @@ const char *gpiochip_is_requested(struct
 }
 EXPORT_SYMBOL_GPL(gpiochip_is_requested);
 
+int gpio_to_irq(unsigned gpio)
+{
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	unsigned long		flags;
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+
+	chip = desc->chip;
+	if (!chip || !chip->to_irq)
+		goto fail;
+
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+
+	status = chip->to_irq(chip, gpio);
+
+ fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_to_irq);
 
 /* Drivers MUST set GPIO direction before making get/set calls.  In
  * some cases this is done in early boot, before IRQs are enabled.
Index: linux-2.6.26-quilt3/include/asm-generic/gpio.h
===================================================================
--- linux-2.6.26-quilt3.orig/include/asm-generic/gpio.h	2008-07-18 00:40:52.000000000 +0100
+++ linux-2.6.26-quilt3/include/asm-generic/gpio.h	2008-07-18 00:46:32.000000000 +0100
@@ -40,6 +40,7 @@ struct module;
  * @dbg_show: optional routine to show contents in debugfs; default code
  *	will be used when this is omitted, but custom code can show extra
  *	state (such as pullup/pulldown configuration).
+ * @to_irq: convert gpio offset to IRQ number.
  * @base: identifies the first GPIO number handled by this chip; or, if
  *	negative during registration, requests dynamic ID allocation.
  * @ngpio: the number of GPIOs handled by this controller; the last GPIO
@@ -71,6 +72,9 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*dbg_show)(struct seq_file *s,
 						struct gpio_chip *chip);
+	int			(*to_irq)(struct gpio_chip *chip,
+					  unsigned offset);
+
 	int			base;
 	u16			ngpio;
 	unsigned		can_sleep:1;
@@ -97,6 +101,7 @@ extern int gpio_direction_output(unsigne
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
+extern int gpio_to_irq(unsigned gpio);
 
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
  * the GPIO is constant and refers to some always-present controller,


S3C24XX: Add gpio_to_irq implementation

Add the necessary to_irq fields for the S3C24XX
GPIO banks that support IRQs.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt3/arch/arm/plat-s3c24xx/gpiolib.c
===================================================================
--- linux-2.6.26-quilt3.orig/arch/arm/plat-s3c24xx/gpiolib.c	2008-07-18 12:35:15.000000000 +0100
+++ linux-2.6.26-quilt3/arch/arm/plat-s3c24xx/gpiolib.c	2008-07-18 12:37:39.000000000 +0100
@@ -150,6 +150,19 @@ static int s3c24xx_gpiolib_banka_output(
 	return 0;
 }
 
+static int s3c24xx_gpiolib_bankf_toirq(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset < 4)
+		return IRQ_EINT0 + offset;
+
+	return IRQ_EINT4 + (offset - 4);
+}
+
+static int s3c24xx_gpiolib_bankg_toirq(struct gpio_chip *chip, unsigned offset)
+{
+	return IRQ_EINT8 + offset;
+}
+
 
 struct s3c24xx_gpio_chip gpios[] = {
 	[0] = {
@@ -228,6 +241,7 @@ struct s3c24xx_gpio_chip gpios[] = {
 			.direction_output	= s3c24xx_gpiolib_output,
 			.set			= s3c24xx_gpiolib_set,
 			.get			= s3c24xx_gpiolib_get,
+			.to_irq			= s3c24xx_gpiolib_bankf_toirq,
 		},
 	},
 	[6] = {
@@ -241,6 +255,7 @@ struct s3c24xx_gpio_chip gpios[] = {
 			.direction_output	= s3c24xx_gpiolib_output,
 			.set			= s3c24xx_gpiolib_set,
 			.get			= s3c24xx_gpiolib_get,
+			.to_irq			= s3c24xx_gpiolib_bankg_toirq,
 		},
 	},
 };


-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'

--wRRV7LY7NUeQGEoC
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="simtec-gpiolib-add-irqmappings.patch"

GPIO: Add generic gpio_to_irq call.

Add gpio_to_irq() implementation allowing the
gpio_chip registration to also specify an function
to map GPIO offsets into IRQs.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt3/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6.26-quilt3.orig/drivers/gpio/gpiolib.c	2008-07-18 00:40:52.000000000 +0100
+++ linux-2.6.26-quilt3/drivers/gpio/gpiolib.c	2008-07-18 00:52:07.000000000 +0100
@@ -339,6 +339,36 @@ const char *gpiochip_is_requested(struct
 }
 EXPORT_SYMBOL_GPL(gpiochip_is_requested);
 
+int gpio_to_irq(unsigned gpio)
+{
+	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
+	unsigned long		flags;
+	int			status = -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (!gpio_is_valid(gpio))
+		goto fail;
+
+	chip = desc->chip;
+	if (!chip || !chip->to_irq)
+		goto fail;
+
+	gpio -= chip->base;
+	if (gpio >= chip->ngpio)
+		goto fail;
+
+	status = chip->to_irq(chip, gpio);
+
+ fail:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	if (status)
+		pr_debug("%s: gpio-%d status %d\n",
+			__func__, gpio, status);
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_to_irq);
 
 /* Drivers MUST set GPIO direction before making get/set calls.  In
  * some cases this is done in early boot, before IRQs are enabled.
Index: linux-2.6.26-quilt3/include/asm-generic/gpio.h
===================================================================
--- linux-2.6.26-quilt3.orig/include/asm-generic/gpio.h	2008-07-18 00:40:52.000000000 +0100
+++ linux-2.6.26-quilt3/include/asm-generic/gpio.h	2008-07-18 00:46:32.000000000 +0100
@@ -40,6 +40,7 @@ struct module;
  * @dbg_show: optional routine to show contents in debugfs; default code
  *	will be used when this is omitted, but custom code can show extra
  *	state (such as pullup/pulldown configuration).
+ * @to_irq: convert gpio offset to IRQ number.
  * @base: identifies the first GPIO number handled by this chip; or, if
  *	negative during registration, requests dynamic ID allocation.
  * @ngpio: the number of GPIOs handled by this controller; the last GPIO
@@ -71,6 +72,9 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*dbg_show)(struct seq_file *s,
 						struct gpio_chip *chip);
+	int			(*to_irq)(struct gpio_chip *chip,
+					  unsigned offset);
+
 	int			base;
 	u16			ngpio;
 	unsigned		can_sleep:1;
@@ -97,6 +101,7 @@ extern int gpio_direction_output(unsigne
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
+extern int gpio_to_irq(unsigned gpio);
 
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
  * the GPIO is constant and refers to some always-present controller,

--wRRV7LY7NUeQGEoC
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="simtec-s3c24xx-gpiolib-toirq.patch"

S3C24XX: Add gpio_to_irq implementation

Add the necessary to_irq fields for the S3C24XX
GPIO banks that support IRQs.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt3/arch/arm/plat-s3c24xx/gpiolib.c
===================================================================
--- linux-2.6.26-quilt3.orig/arch/arm/plat-s3c24xx/gpiolib.c	2008-07-18 12:35:15.000000000 +0100
+++ linux-2.6.26-quilt3/arch/arm/plat-s3c24xx/gpiolib.c	2008-07-18 12:37:39.000000000 +0100
@@ -150,6 +150,19 @@ static int s3c24xx_gpiolib_banka_output(
 	return 0;
 }
 
+static int s3c24xx_gpiolib_bankf_toirq(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset < 4)
+		return IRQ_EINT0 + offset;
+
+	return IRQ_EINT4 + (offset - 4);
+}
+
+static int s3c24xx_gpiolib_bankg_toirq(struct gpio_chip *chip, unsigned offset)
+{
+	return IRQ_EINT8 + offset;
+}
+
 
 struct s3c24xx_gpio_chip gpios[] = {
 	[0] = {
@@ -228,6 +241,7 @@ struct s3c24xx_gpio_chip gpios[] = {
 			.direction_output	= s3c24xx_gpiolib_output,
 			.set			= s3c24xx_gpiolib_set,
 			.get			= s3c24xx_gpiolib_get,
+			.to_irq			= s3c24xx_gpiolib_bankf_toirq,
 		},
 	},
 	[6] = {
@@ -241,6 +255,7 @@ struct s3c24xx_gpio_chip gpios[] = {
 			.direction_output	= s3c24xx_gpiolib_output,
 			.set			= s3c24xx_gpiolib_set,
 			.get			= s3c24xx_gpiolib_get,
+			.to_irq			= s3c24xx_gpiolib_bankg_toirq,
 		},
 	},
 };

--wRRV7LY7NUeQGEoC--
