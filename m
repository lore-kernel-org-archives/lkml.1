Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbZAQJ5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbZAQJ5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 04:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbZAQJ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 04:57:30 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:5014 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbZAQJ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 04:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b7tjebGUcGfbxLrdhlek7LEaNqijlLfjLi7V/vbQqnNCAFJQTHe+eQ8mB4wA+umAJM
         Vmw4CGPTmHSYlqPQX6RA3w2YC8TXzhxIvWvXayDvVrzlhTOmQPvDTZIdua9+O6DKuMkI
         aZjteYfk976D6+q3C9h5vQVE0nusq4nMZ7MKk=
From: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [RFC 2.6.28 1/2] gpiolib: add set/get batch v4
Date: Sat, 17 Jan 2009 17:57:17 +0800
Message-Id: <12321862383405-git-send-email-jayakumar.lkml@gmail.com>
X-Mailer: git-send-email 1.5.2.3
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi friends,

This is v4 of batch support for gpiolib. Thanks to David Brownell, Eric Miao,
David Hylands, Robin, Ben, Jamie and others for prior feedback. The post for
v3 summarized the previous discussion. Since then the changes I've made are:
- split the patches into generic and arch specific
- optimizing the empty mask case
- adjusting the API to add error returns
- documenting this optional API in gpio.txt
- cleanup of the commenting

Please let me know your thoughts and feedback.

Thanks,
jaya

Cc: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: linux-embedded@vger.kernel.org
Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
---
 Documentation/gpio.txt     |   60 ++++++++
 drivers/gpio/Kconfig       |    5 +
 drivers/gpio/gpiolib.c     |  323 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   19 +++-
 4 files changed, 406 insertions(+), 1 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index b1b9887..d7e5fe9 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -185,6 +185,66 @@ and not to need spinlocks.  Such optimized calls can make bitbanging
 applications a lot more efficient (in both space and time) than spending
 dozens of instructions on subroutine calls.
 
+[OPTIONAL] Spinlock-Safe GPIO Batch access
+------------------------------------------
+The original GPIO API implements single bit access to GPIO pins. Some
+drivers for devices that treat GPIO as a mechanism for bulk data transfer
+may find the performance of the single bit API to be inadequate. In this
+scenario, the user can consider enabling the batch access API. This API is
+as follows:
+
+	/* BATCH GPIO INPUT */
+int gpio_get_batch(unsigned gpio, u32 bitmask, int maskwidth, u32 *result);
+
+The following examples help explain how this function is to be used.
+ Q: How to get gpio pins 0 through 7? (8 bits)
+ A: gpio_get_batch(gpio=0, bitmask=0xFF, width=8, &result) result=0xnn
+ Q: How to get gpio pins 58 through 73? (16 bits)
+ A: gpio_get_batch(gpio=58, bitmask=0xFFFF, width=16, &result) result=0xnnnn
+ Q: How to get gpio pins 16 through 47? (32 bits)
+ A: gpio_get_batch(offset=16, bitmask=0xFFFFFFFF, width=32, &result)
+ A: result=0xnnnnnnnn
+
+	/* BATCH GPIO OUTPUT */
+int gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int maskwidth);
+
+The following examples help explain how this function is to be used.
+ Q: How to set gpio pins 0 through 7 to all 0? (8 bits)
+ A: gpio_set_batch(gpio=0, values=0x0, bitmask=0xFF, width=8);
+ Q: How to set gpio pins 58 through 73 to all 1? (16 bits)
+ A: gpio_set_batch(gpio=58, values=0xFFFF, bitmask=0xFFFF, width=16);
+ Q: How to set gpio pins 16 through 47 to 0xCAFEC001? (32 bits)
+ A: gpio_set_batch(gpio=16, values=0xCAFEC001, bitmask=0xFFFFFFFF, width=32);
+
+The following example shows the use of the batch API and a comparison with
+the original single bit API:
+
+Original input method which loops through a set of pins:
+-       for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
+-               res |= (gpio_get_value(DB0_GPIO_PIN + i)) ? (1 << i) : 0;
+
+Batch input method:
++       u16 val;
++       err = gpio_get_batch(DB0_GPIO_PIN, 0xFFFF, 16, &val);
+
+Original output method:
+-       for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
+-               gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
+Batch output method:
++       int err;
++       err = gpio_set_batch(DB0_GPIO_PIN, data, 0xFFFF, 16);
+
+Using these calls for GPIOs that can't safely be accessed without sleeping
+(see below) is an error.
+
+Platform-specific implementations are encouraged to optimize the two
+calls by checking if the batch get/set requested can be achieved within the
+platform's fast path access to gpio registers. For example, if the starting
+gpio and width of bits to be written is contained within a single register
+then the platform specific implementation may choose to execute it. If the
+request is more complex, then the platform specific implementation can
+choose to call upon the platform independent __gpio_get/set_batch functions
+which are able to cross gpio_chip boundaries.
 
 GPIO access that may sleep
 --------------------------
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3d25654..474070b 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -37,6 +37,11 @@ menuconfig GPIOLIB
 
 if GPIOLIB
 
+config GPIOLIB_BATCH
+	bool "Batch GPIO support"
+	help
+	  Say Y here to add the capability to batch set/get GPIOs.
+
 config DEBUG_GPIO
 	bool "Debug GPIO calls"
 	depends on DEBUG_KERNEL
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 35e7aea..a9cf75e 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -643,6 +643,323 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 
 #endif /* CONFIG_GPIO_SYSFS */
 
+#ifdef CONFIG_GPIOLIB_BATCH
+/**
+ * __generic_gpio_set_batch() - Set batch of gpio pins in provided gpio_chip.
+ * @chip: gpio_chip containing this set of pins
+ * @offset: starting gpio pin
+ * @values: values to assign including masked bits
+ * @bitmask: the bitmask to be applied to values
+ * @width: the width of the bitmask
+ * Context: any
+ *
+ * This provides a generic platform independent set_batch capability.
+ * It invokes the associated gpio_chip.set() method to actually set the
+ * value. gpio_chip-s that don't implement their own optimized
+ * set_batch function are assigned this function as a default.
+ *
+ * The following examples help explain how this function works.
+ * Q: How to set gpio pins at offset 0 through 7 to all 0? (8 bits)
+ * A: offset=0, values=0x0, bitmask=0xFF, width=8
+ * Q: How to set gpio pins at offset 26 through 31 to all 1? (6 bits)
+ * A: offset=26, values=0x3F, bitmask=0x3F, width=6
+ * Q: How to set gpio pins at offset 16 through 31 to 0xCAFE? (16 bits)
+ * A: offset=16, values=0xCAFE, bitmask=0xFFFF, width=16
+ * Q: Why isn't width calculated from the mask here?
+ * A: This function is intended to be called repetitively and doing the
+ * bit shift looping to calculate the width here would be an undesirable
+ * penalty. Instead, the width is provided by the caller, thus avoiding
+ * the performance penalty since it is a fixed value known by the caller.
+ *
+ * Returns a negative errno if the caller supplied bad data, such as
+ * offset or width in excess of this chips gpio. Otherwise, we return zero
+ * as a success code.
+ */
+static int __generic_gpio_set_batch(struct gpio_chip *chip, unsigned offset,
+					u32 values, u32 bitmask, int width)
+{
+	int i;
+	int value;
+	u32 mask;
+
+	/*
+	 * If the caller attempted to exceed the number of gpios that
+	 * are in this chip, then we flag that as an invalid value for
+	 * either the offset or the width supplied.
+	 */
+	if (offset + width >  chip->ngpio)
+		return -EINVAL;
+
+	/*
+	 * We start the loop and continue till we reach the width
+	 * of the bitmask that is provided to us.
+	 */
+	for (i = 0; i < width; i++) {
+		/*
+		 * If this bit is enabled by the bitmask then
+		 * we perform the set. If it is disabled we leave
+		 * it alone.
+		 */
+		mask = 1 << i;
+		if (bitmask & mask) {
+			value = values & mask;
+			chip->set(chip, offset + i, value);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * __generic_gpio_get_batch() - Get batch of gpio pins in provided gpio_chip.
+ * @chip: gpio_chip containing this set of pins
+ * @offset: starting gpio pin
+ * @values: values to assign including masked bits
+ * @bitmask: the bitmask to be applied to values
+ * @width: the width of the bitmask
+ * @result: the result to be returned
+ * Context: any
+ *
+ * This provides a generic platform independent get_batch capability.
+ * It invokes the associated gpio_chip.get() method to actually set the
+ * value. gpio_chip-s that don't implement their own optimized
+ * get_batch function are assigned this function as a default.
+ *
+ * The following examples help explain how this function works.
+ * Q: How to get gpio pins at offset 0 through 7? (8 bits)
+ * A: offset=0, bitmask=0xFF, width=8, result=0xnn
+ * Q: How to get gpio pins at offset 26 through 31? (6 bits)
+ * A: offset=26, bitmask=0x3F, width=6, result=0xnn
+ * Q: How to get gpio pins at offset 16 through 31? (16 bits)
+ * A: offset=16, bitmask=0xFFFF, width=16, result=0xnnnn
+ * Q: Why isn't width calculated from the mask here?
+ * A: This function is intended to be called repetitively and doing the
+ * bit shift looping to calculate the width here would be an undesirable
+ * penalty. Instead, the width is provided by the caller, thus avoiding
+ * the performance penalty since it is a fixed value known by the caller.
+ *
+ * Returns a negative errno if the caller supplied bad data, such as
+ * offset or width in excess of this chips gpio. Otherwise, we return zero
+ * as a success code.
+ * Context: any
+ */
+static int __generic_gpio_get_batch(struct gpio_chip *chip, unsigned offset,
+					u32 bitmask, int width, u32 *result)
+{
+	int i;
+	u32 mask;
+	u32 values = 0;
+
+	/*
+	 * If the caller attempted to exceed the number of gpios that
+	 * are in this chip, then we flag that as an invalid value for
+	 * either the offset or the width supplied.
+	 */
+	if (offset + width >  chip->ngpio)
+		return -EINVAL;
+
+	/*
+	 * We start the loop and continue till we reach the width
+	 * of the bitmask that is provided to us.
+	 */
+	for (i = 0; i < width; i++) {
+		/*
+		 * If this bit is enabled by the bitmask then
+		 * we perform the get. If it is disabled we leave
+		 * it alone thus leaving it as 0 because we initialized
+		 * values.
+		 */
+		mask = 1 << i;
+		if (bitmask & mask) {
+			if (chip->get(chip, offset + i))
+				values |= mask;
+		}
+	}
+
+	*result = values;
+	return 0;
+}
+
+/**
+ * __gpio_set_batch() - set batch of gpio pins across multiple gpio_chip-s
+ * @gpio: starting gpio pin
+ * @values: values to assign including masked bits
+ * @bitmask: the bitmask to be applied to values
+ * @bitwidth: the width of the bitmask
+ * Context: any
+ *
+ * This function is platform independent and uses the starting gpio and
+ * bitwidth information to iterate through the set of required gpio_chips
+ * to use their set_batch capability in order to set a batch of gpio pins.
+ * This function handles going across gpio_chip boundaries. It is intended
+ * to be called from arch/mach specific code if they detect that the caller
+ * requires functionality outside the fast-path.
+ *
+ * The following examples help explain how this function is to be used.
+ * Q: How to set gpio pins 0 through 7 to all 0? (8 bits)
+ * A: gpio=0, values=0x0, bitmask=0xFF, width=8
+ * Q: How to set gpio pins 58 through 73 to all 1? (16 bits)
+ * A: gpio=58, values=0xFFFF, bitmask=0xFFFF, width=16
+ * Q: How to set gpio pins 16 through 47 to 0xCAFEC001? (32 bits)
+ * A: offset=16, values=0xCAFEC001, bitmask=0xFFFFFFFF, width=32
+ * Q: Why isn't width calculated from the mask here?
+ * A: This function is intended to be called repetitively and doing the
+ * bit shift looping to calculate the width here would be an undesirable
+ * penalty. Instead, the width is provided by the caller, thus avoiding
+ * the performance penalty since it is a fixed value known by the caller.
+ *
+ * Returns a negative errno if the caller supplied bad data, such as
+ * gpio or width in excess of the platforms max gpio. Otherwise, we return
+ * zero as a success code.
+ *
+ */
+int __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth)
+{
+	struct gpio_chip *chip;
+	int i = 0;
+	int value, width, remwidth;
+	u32 mask;
+	int ret;
+
+	/*
+	 * If the caller attempted to exceed the number of gpios that
+	 * are available here, then we flag that as an invalid value for
+	 * either the gpio or the width supplied.
+	 */
+	if ((bitwidth > 32) || (gpio + bitwidth >  ARCH_NR_GPIOS))
+		return -EINVAL;
+
+	do {
+		chip = gpio_to_chip(gpio + i);
+		WARN_ON(extra_checks && chip->can_sleep);
+
+		value = values >> i; /* shift off the used data bits */
+
+		/* Work out the remaining width in this chip. */
+		remwidth = ((chip->base + (int) chip->ngpio) -
+					((int) gpio + i));
+
+		/*
+		 * Check if the remaining bits to be handled are less than
+		 * the remaining width in this chip.
+		 */
+		width = min(bitwidth, remwidth);
+
+		/* Shift off the used mask bits. */
+		mask = bitmask >> i;
+
+		/* Now adjust mask by width of this set. */
+		mask &= ((1 << width) - 1);
+
+		/* If the mask is empty, then we can skip this chip. */
+		if (mask) {
+			ret = chip->set_batch(chip, gpio + i - chip->base,
+						value, mask, width);
+			if (ret)
+				return ret;
+		}
+
+		/* deduct the used bits from our todolist */
+		i += width;
+		bitwidth -= width;
+	} while (bitwidth);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__gpio_set_batch);
+
+/**
+ * __gpio_get_batch() - get batch of gpio pins across multiple gpio_chip-s
+ * @gpio: starting gpio pin
+ * @bitmask: the bitmask to be applied to values
+ * @bitwidth: the width of the bitmask
+ * @result: returned values
+ * Context: any
+ *
+ * This function is platform independent and uses the starting gpio and
+ * bitwidth information to iterate through the set of required gpio_chips
+ * to use their get_batch capability in order to get a batch of gpio pins.
+ * This function handles going across gpio_chip boundaries. It is intended
+ * to be called from arch/mach specific code if they detect that the caller
+ * requires functionality outside the fast-path.
+ *
+ * The following examples help explain how this function is to be used.
+ * Q: How to get gpio pins 0 through 7? (8 bits)
+ * A: gpio=0, bitmask=0xFF, width=8, result=0xnn
+ * Q: How to get gpio pins 58 through 73? (16 bits)
+ * A: gpio=58, bitmask=0xFFFF, width=16, result=0xnnnn
+ * Q: How to get gpio pins 16 through 47? (32 bits)
+ * A: offset=16, bitmask=0xFFFFFFFF, width=32, result=0xnnnnnnnn
+ * Q: Why isn't width calculated from the mask here?
+ * A: This function is intended to be called repetitively and doing the
+ * bit shift looping to calculate the width here would be an undesirable
+ * penalty. Instead, the width is provided by the caller, thus avoiding
+ * the performance penalty since it is a fixed value known by the caller.
+ *
+ * Returns a negative errno if the caller supplied bad data, such as
+ * gpio or width in excess of the platforms max gpio. Otherwise, we return
+ * zero as a success code
+ *
+ */
+int __gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth, u32 *result)
+{
+	struct gpio_chip *chip;
+	int i = 0;
+	int width, remwidth;
+	u32 mask;
+	u32 values = 0;
+	u32 value;
+	int ret;
+
+	/*
+	 * If the caller attempted to exceed the number of gpios that
+	 * are available here, then we flag that as an invalid value for
+	 * either the gpio or the width supplied.
+	 */
+	if ((bitwidth > 32) || (gpio + bitwidth >  ARCH_NR_GPIOS))
+		return -EINVAL;
+
+	do {
+		chip = gpio_to_chip(gpio + i);
+		WARN_ON(extra_checks && chip->can_sleep);
+
+		/* Work out the remaining width in this chip. */
+		remwidth = ((chip->base + (int) chip->ngpio) -
+					((int) gpio + i));
+
+		/*
+		 * Check if the remaining bits to be handled are less than
+		 * the remaining width in this chip.
+		 */
+		width = min(bitwidth, remwidth);
+
+		/* shift off the used mask bits */
+		mask = bitmask >> i;
+		/* now adjust mask by width of get */
+		mask &= ((1 << width) - 1);
+
+		/* If the mask is empty, then we can skip this chip. */
+		if (mask) {
+			ret = chip->get_batch(chip, gpio + i - chip->base,
+						mask, width, &value);
+			if (ret)
+				return ret;
+
+			/* shift result back into correct position */
+			values |= value << i;
+		}
+
+		/* deduct the used bits from our todolist */
+		i += width;
+		bitwidth -= width;
+	} while (bitwidth);
+
+	*result = values;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__gpio_get_batch);
+#endif
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -683,6 +1000,12 @@ int gpiochip_add(struct gpio_chip *chip)
 		}
 		chip->base = base;
 	}
+#ifdef CONFIG_GPIOLIB_BATCH
+	if (!chip->set_batch)
+		chip->set_batch = __generic_gpio_set_batch;
+	if (!chip->get_batch)
+		chip->get_batch = __generic_gpio_get_batch;
+#endif
 
 	/* these GPIO numbers must not be managed by another gpio_chip */
 	for (id = base; id < base + chip->ngpio; id++) {
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 81797ec..29478d2 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -44,6 +44,10 @@ struct module;
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
+ * @set_batch: batch assigns output values for signals starting at
+ *	"offset" with mask in "bitmask" all within this gpio_chip
+ * @get_batch: batch fetches values for consecutive signals starting at
+ *	"offset" with mask in "bitmask" all within this gpio_chip
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
  *	implementation may not sleep
  * @dbg_show: optional routine to show contents in debugfs; default code
@@ -84,7 +88,14 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
-
+#ifdef CONFIG_GPIOLIB_BATCH
+	int			(*set_batch)(struct gpio_chip *chip,
+						unsigned offset, u32 values,
+						u32 bitmask, int width);
+	int			(*get_batch)(struct gpio_chip *chip,
+						unsigned offset, u32 bitmask,
+						int width, u32 *result);
+#endif
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
 
@@ -124,6 +135,12 @@ extern void gpio_set_value_cansleep(unsigned gpio, int value);
  */
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
+#ifdef CONFIG_GPIOLIB_BATCH
+extern int __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask,
+				int bitwidth);
+extern int __gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth,
+				u32 *result);
+#endif
 
 extern int __gpio_cansleep(unsigned gpio);
 
-- 
1.5.2.3

