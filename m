Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbYGQXue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbYGQXue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932118AbYGQXuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:50:25 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:61303 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760363AbYGQXuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:50:25 -0400
Subject: GPIO: Add generic gpio_to_irq call.
Message-Id: <20080717235021.655442945@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, david-b@pacbell.net
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-gpiolib-add-irqmappings.patch
Date: Fri, 18 Jul 2008 00:50:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpio_to_irq() implementation allowing the
gpio_chip registration to also specify an function
to map GPIO offsets into IRQs.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt3/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6.26-quilt3.orig/drivers/gpio/gpiolib.c	2008-07-18 00:40:52.000000000 +0100
+++ linux-2.6.26-quilt3/drivers/gpio/gpiolib.c	2008-07-18 00:47:03.000000000 +0100
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
+	status = chip->to_irq(chip, offset);
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

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
