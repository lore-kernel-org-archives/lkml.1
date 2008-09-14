Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbYINU5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbYINU5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 16:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbYINU5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 16:57:23 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:62515 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753950AbYINU5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 16:57:22 -0400
Subject: GPIO: Add generic gpio_to_irq call.
Message-Id: <20080914205718.377654695@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, david-b@pacbell.net
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-gpiolib-add-irqmappings.patch
Date: Sun, 14 Sep 2008 21:57:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpio_to_irq() implementation allowing the
gpio_chip registration to also specify an function
to map GPIO offsets into IRQs.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.27-rc1-quilt1/drivers/gpio/gpiolib.c
===================================================================
--- linux-2.6.27-rc1-quilt1.orig/drivers/gpio/gpiolib.c	2008-07-30 09:20:12.000000000 +0100
+++ linux-2.6.27-rc1-quilt1/drivers/gpio/gpiolib.c	2008-07-30 10:08:05.000000000 +0100
@@ -842,6 +842,36 @@ const char *gpiochip_is_requested(struct
 }
 EXPORT_SYMBOL_GPL(gpiochip_is_requested);
 
+int __gpio_to_irq(unsigned gpio)
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
+EXPORT_SYMBOL_GPL(__gpio_to_irq);
 
 /* Drivers MUST set GPIO direction before making get/set calls.  In
  * some cases this is done in early boot, before IRQs are enabled.
Index: linux-2.6.27-rc1-quilt1/include/asm-generic/gpio.h
===================================================================
--- linux-2.6.27-rc1-quilt1.orig/include/asm-generic/gpio.h	2008-07-30 09:20:16.000000000 +0100
+++ linux-2.6.27-rc1-quilt1/include/asm-generic/gpio.h	2008-07-30 10:08:05.000000000 +0100
@@ -43,6 +43,7 @@ struct module;
  * @dbg_show: optional routine to show contents in debugfs; default code
  *	will be used when this is omitted, but custom code can show extra
  *	state (such as pullup/pulldown configuration).
+ * @to_irq: convert gpio offset to IRQ number.
  * @base: identifies the first GPIO number handled by this chip; or, if
  *	negative during registration, requests dynamic ID allocation.
  * @ngpio: the number of GPIOs handled by this controller; the last GPIO
@@ -75,6 +76,9 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*dbg_show)(struct seq_file *s,
 						struct gpio_chip *chip);
+	int			(*to_irq)(struct gpio_chip *chip,
+					  unsigned offset);
+
 	int			base;
 	u16			ngpio;
 	unsigned		can_sleep:1;
@@ -102,6 +106,7 @@ extern int gpio_direction_output(unsigne
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
+extern int __gpio_to_irq(unsigned gpio);
 
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
  * the GPIO is constant and refers to some always-present controller,
Index: linux-2.6.27-rc1-quilt1/Documentation/gpio.txt
===================================================================
--- linux-2.6.27-rc1-quilt1.orig/Documentation/gpio.txt	2008-07-30 09:20:08.000000000 +0100
+++ linux-2.6.27-rc1-quilt1/Documentation/gpio.txt	2008-07-30 10:08:05.000000000 +0100
@@ -273,8 +273,9 @@ some GPIOs can't be used as IRQs.)  It i
 number that wasn't set up as an input using gpio_direction_input(), or
 to use an IRQ number that didn't originally come from gpio_to_irq().
 
-These two mapping calls are expected to cost on the order of a single
-addition or subtraction.  They're not allowed to sleep.
+These two mapping calls are expected to cost on between the order of a
+single addition or subtraction to obtaining an spinlock and using the
+to_irq method of the relevant gpio chip. They're not allowed to sleep.
 
 Non-error values returned from gpio_to_irq() can be passed to request_irq()
 or free_irq().  They will often be stored into IRQ resources for platform
@@ -407,6 +408,7 @@ GPIOs through GPIO-lib and the code cann
 Trivial implementations of those functions can directly use framework
 code, which always dispatches through the gpio_chip:
 
+  #define gpio_to_irq	        __gpio_to_irq
   #define gpio_get_value	__gpio_get_value
   #define gpio_set_value	__gpio_set_value
   #define gpio_cansleep		__gpio_cansleep

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
