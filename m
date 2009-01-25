Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZAYJzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZAYJzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 04:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZAYJy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 04:54:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:20789 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZAYJy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 04:54:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=PAUIfgcFM6GBFoFPFS+i24iV0H5/PTnbQxvtuzdrjfvxFvD1SASp2wIEPJbCtXeLmz
         s4ZtjUCQDpdRNMqPV+WIDbBlqRnYtDhBsVuIjsfO8Z0S2E7Mnekb/tfHoBBV81HsSnAo
         T5DuvkLfsJWucO0jIw4ut9MV6GGIBs34/Kico=
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: jayakumar.lkml@gmail.com
Cc: David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [RFC 2.6.28 1/3] gpiolib: add batch set/get
Date: Sun, 25 Jan 2009 17:54:47 +0800
Message-Id: <123287728936-git-send-email-jayakumar.lkml@gmail.com>
X-Mailer: git-send-email 1.5.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi friends,

This is v5 of batch support for gpiolib. Thanks to Uwe Kleine-König,
Ryan Mallon and others for prior feedback. The changes I've made are:
- split the patches into generic, arch specific and am300epd
- adjusting the API to remove width (note, the actual API call where
  width was dropped is in the arch specific code, not here.)
- updating documentation of this API in gpio.txt
- cleanup of the width, mask terms

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
 Documentation/gpio.txt     |   72 ++++++++++++
 drivers/gpio/Kconfig       |    5 +
 drivers/gpio/gpiolib.c     |  272 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   17 +++-
 4 files changed, 365 insertions(+), 1 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index b1b9887..d249b5c 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -185,6 +185,78 @@ and not to need spinlocks.  Such optimized calls can make bitbanging
 applications a lot more efficient (in both space and time) than spending
 dozens of instructions on subroutine calls.
 
+[OPTIONAL] Spinlock-Safe GPIO Batch access
+------------------------------------------
+The original GPIO API provides single bit access to GPIO pins. However,
+some devices treat GPIO as a mechanism for bulk data transfer. In this type
+of system, the performance of the single bit API may be inadequate. As such,
+the user can consider enabling the batch access API. The batch access API
+allows access of up-to 32-bits of GPIO at a time. This API is as follows:
+
+	/* BATCH GPIO INPUT */
+int gpio_get_batch(unsigned startpin, u32 mask, u32 *result);
+
+The following examples help explain how this function is to be used.
+ Q: How do I get gpio pins 0 through 7? (8 bits)
+ A: gpio_get_batch(startpin=0, mask=0xFF, &result) result=0xnn
+ Q: How do I get gpio pins 58 through 73? (16 bits)
+ A: gpio_get_batch(startpin=58, mask=0xFFFF, &result) result=0xnnnn
+ Q: How do I get gpio pins 16 through 47? (32 bits)
+ A: gpio_get_batch(startpin=16, mask=0xFFFFFFFF, &result)
+ A: result=0xnnnnnnnn
+ Q: How do I get non-consecutive gpio pins 5 and 9?
+ A: Use the mask to mask out 6, 7 and 8
+ A: So mask in binary is 10001 which is 0x11
+ A: gpio_get_batch(startpin=5, mask=0x11, &result)
+ A: result is in the same form, binary n000n
+
+	/* BATCH GPIO OUTPUT */
+int gpio_set_batch(unsigned startpin, u32 mask, u32 values);
+
+The following examples help explain how this function is to be used.
+ Q: How to set gpio pins 0 through 7 to all 0? (8 bits)
+ A: gpio_set_batch(startpin=0, mask=0xFF, values=0x0);
+ Q: How to set gpio pins 58 through 73 to all 1? (16 bits)
+ A: gpio_set_batch(startpin=58, mask=0xFFFF, values=0xFFFF);
+ Q: How to set gpio pins 16 through 47 to 0xCAFEC001? (32 bits)
+ A: gpio_set_batch(startpin=16, mask=0xFFFFFFFF, values=0xCAFEC001);
+ Q: How do I set non-consecutive gpio pins 5 and 9 to both 1?
+ A: Use the mask to mask out 6, 7 and 8
+ A: So mask in binary is 10001 which is 0x11
+ A: gpio_set_batch(startpin=5, mask=0x11, values=0x11)
+
+The following example shows the use of the batch API and a comparison with
+the original single bit API:
+
+Original input method which loops through a set of pins:
+       for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
+               res |= (gpio_get_value(DB0_GPIO_PIN + i)) ? (1 << i) : 0;
+
+Batch input method:
+       u32 val;
+       err = gpio_get_batch(DB0_GPIO_PIN, 0xFFFF, &val);
+
+Original output method:
+       for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
+               gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
+
+Batch output method:
+       int err;
+       err = gpio_set_batch(DB0_GPIO_PIN, 0xFFFF, data);
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
+which are able to cross gpio_chip boundaries. Implementations are also
+encouraged to use the bitops macros. These will also optimize for use cases
+where the masks are constants.
 
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
index 35e7aea..12e1e30 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -643,6 +643,272 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 
 #endif /* CONFIG_GPIO_SYSFS */
 
+#ifdef CONFIG_GPIOLIB_BATCH
+/**
+ * __gpio_set_batch_generic() - Set batch of gpio pins in provided gpio_chip.
+ * @chip: gpio_chip containing this set of pins
+ * @startpin: starting gpio pin
+ * @mask: the mask to be applied to values
+ * @width: the width to the last set bit of the mask
+ * @values: values to assign including masked bits
+ * Context: any
+ *
+ * This provides a generic platform independent set_batch capability.
+ * It invokes the associated gpio_chip.set() method to actually set the
+ * value. gpio_chip-s that don't implement their own optimized
+ * set_batch function are assigned this function as a default.
+ *
+ * Returns a negative errno if the caller supplied bad data, such as
+ * startpin or width in excess of this chips gpio. Otherwise, we return zero
+ * as a success code.
+ */
+static int __gpio_set_batch_generic(struct gpio_chip *chip, unsigned startpin,
+					u32 mask, int width, u32 values)
+{
+	int i;
+	u32 pin_mask;
+	int value;
+
+	/*
+	 * If the caller attempted to exceed the number of gpios that
+	 * are in this chip, then we flag that as an invalid value for
+	 * either the startpin or the width supplied.
+	 */
+	if (startpin + width >  chip->ngpio)
+		return -EINVAL;
+
+	/*
+	 * We start the loop and continue till we reach the width
+	 * of the mask that is provided to us.
+	 */
+	for (i = 0; i < width; i++) {
+		/*
+		 * If this bit is enabled by the mask then
+		 * we perform the set. If it is disabled we leave
+		 * it alone.
+		 */
+		pin_mask = 1 << i;
+		if (mask & pin_mask) {
+			value = values & pin_mask;
+			chip->set(chip, startpin + i, value);
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * __gpio_get_batch_generic() - Get batch of gpio pins in provided gpio_chip.
+ * @chip: gpio_chip containing this set of pins
+ * @startpin: starting gpio pin
+ * @mask: the mask to be applied to values
+ * @width: the width to the last set bit of the mask
+ * @result: the result to be returned
+ * Context: any
+ *
+ * This provides a generic platform independent get_batch capability.
+ * It invokes the associated gpio_chip.get() method to actually set the
+ * value. gpio_chip-s that don't implement their own optimized
+ * get_batch function are assigned this function as a default.
+ *
+ * Returns a negative errno if the caller supplied bad data, such as
+ * startpin or width in excess of this chips gpio. Otherwise, we return zero
+ * as a success code.
+ * Context: any
+ */
+static int __gpio_get_batch_generic(struct gpio_chip *chip, unsigned startpin,
+					u32 mask, int width, u32 *result)
+{
+	int i;
+	u32 pin_mask;
+	u32 values = 0;
+
+	/*
+	 * If the caller attempted to exceed the number of gpios that
+	 * are in this chip, then we flag that as an invalid value for
+	 * either the startpin or the width supplied.
+	 */
+	if (startpin + width >  chip->ngpio)
+		return -EINVAL;
+
+	/*
+	 * We start the loop and continue till we reach the width
+	 * of the mask that is provided to us.
+	 */
+	for (i = 0; i < width; i++) {
+		/*
+		 * If this bit is enabled by the mask then
+		 * we perform the get. If it is disabled we leave
+		 * it alone thus leaving it as 0 because we initialized
+		 * values.
+		 */
+		pin_mask = 1 << i;
+		if (mask & pin_mask) {
+			if (chip->get(chip, startpin + i))
+				values |= pin_mask;
+		}
+	}
+
+	*result = values;
+	return 0;
+}
+
+/**
+ * __gpio_set_batch() - set batch of gpio pins across multiple gpio_chip-s
+ * @startpin: starting gpio pin
+ * @mask: the mask to be applied to values
+ * @width: the width to the last set bit of the mask
+ * @values: values to assign including masked bits
+ * Context: any
+ *
+ * This function is platform independent and uses the starting gpio and
+ * width information to iterate through the set of required gpio_chips
+ * to use their set_batch capability in order to set a batch of gpio pins.
+ * This function handles going across gpio_chip boundaries. It is intended
+ * to be called from arch/mach specific code if they detect that the caller
+ * requires functionality outside the fast-path.
+ *
+ * Returns a negative errno if the caller supplied bad data, such as
+ * startpin or width in excess of the platforms max gpio. Otherwise, we return
+ * zero as a success code.
+ *
+ */
+int __gpio_set_batch(unsigned startpin, u32 mask, int width, u32 values)
+{
+	struct gpio_chip *chip;
+	int i = 0;
+	int subwidth, remwidth;
+	u32 subvalue;
+	u32 submask;
+	int ret;
+
+	/*
+	 * If the caller attempted to exceed the number of gpios that
+	 * are available here, then we flag that as an invalid value for
+	 * either the startpin or the width supplied.
+	 */
+	if ((width > 32) || (startpin + width >  ARCH_NR_GPIOS))
+		return -EINVAL;
+
+	do {
+		chip = gpio_to_chip(startpin + i);
+		WARN_ON(extra_checks && chip->can_sleep);
+
+		subvalue = values >> i; /* shift off the used data bits */
+
+		/* Work out the remaining width in this chip. */
+		remwidth = ((chip->base + (int) chip->ngpio) -
+					((int) startpin + i));
+
+		/*
+		 * Check if the remaining bits to be handled are less than
+		 * the remaining width in this chip. That is the width of
+		 * the subset that we are about to handle.
+		 */
+		subwidth = min(width, remwidth);
+
+		/* Shift off the used mask bits. */
+		submask = mask >> i;
+
+		/* Now adjust mask by width of this subset. */
+		submask &= ((1 << subwidth) - 1);
+
+		/* If the mask is empty, then we can skip this chip. */
+		if (submask) {
+			ret = chip->set_batch(chip, startpin + i - chip->base,
+						submask, subwidth, subvalue);
+			if (ret)
+				return ret;
+		}
+
+		/* deduct the used bits from our todolist */
+		i += subwidth;
+		width -= subwidth;
+	} while (width);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__gpio_set_batch);
+
+/**
+ * __gpio_get_batch() - get batch of gpio pins across multiple gpio_chip-s
+ * @startpin: starting gpio pin
+ * @mask: the mask to be applied to values
+ * @width: the width to the last set bit of the mask
+ * @result: returned values
+ * Context: any
+ *
+ * This function is platform independent and uses the starting gpio and
+ * width information to iterate through the set of required gpio_chips
+ * to use their get_batch capability in order to get a batch of gpio pins.
+ * This function handles going across gpio_chip boundaries. It is intended
+ * to be called from arch/mach specific code if they detect that the caller
+ * requires functionality outside the fast-path.
+ *
+ * Returns a negative errno if the caller supplied bad data, such as
+ * startpin or width in excess of the platforms max gpio. Otherwise, we return
+ * zero as a success code
+ *
+ */
+int __gpio_get_batch(unsigned startpin, u32 mask, int width, u32 *result)
+{
+	struct gpio_chip *chip;
+	int i = 0;
+	int subwidth, remwidth;
+	u32 submask;
+	u32 values = 0;
+	u32 subvalue;
+	int ret;
+
+	/*
+	 * If the caller attempted to exceed the number of gpios that
+	 * are available here, then we flag that as an invalid value for
+	 * either the startpin or the width supplied.
+	 */
+	if ((width > 32) || (startpin + width >  ARCH_NR_GPIOS))
+		return -EINVAL;
+
+	do {
+		chip = gpio_to_chip(startpin + i);
+		WARN_ON(extra_checks && chip->can_sleep);
+
+		/* Work out the remaining width in this chip. */
+		remwidth = ((chip->base + (int) chip->ngpio) -
+					((int) startpin + i));
+
+		/*
+		 * Check if the remaining bits to be handled are less than
+		 * the remaining width in this chip.
+		 */
+		subwidth = min(width, remwidth);
+
+		/* shift off the used mask bits */
+		submask = mask >> i;
+		/* now adjust mask by width of get */
+		submask &= ((1 << width) - 1);
+
+		/* If the mask is empty, then we can skip this chip. */
+		if (submask) {
+			ret = chip->get_batch(chip, startpin + i - chip->base,
+						submask, subwidth, &subvalue);
+			if (ret)
+				return ret;
+
+			/* shift result back into correct position */
+			values |= subvalue << i;
+		}
+
+		/* deduct the used bits from our todolist */
+		i += subwidth;
+		width -= subwidth;
+	} while (width);
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
@@ -683,6 +949,12 @@ int gpiochip_add(struct gpio_chip *chip)
 		}
 		chip->base = base;
 	}
+#ifdef CONFIG_GPIOLIB_BATCH
+	if (!chip->set_batch)
+		chip->set_batch = __gpio_set_batch_generic;
+	if (!chip->get_batch)
+		chip->get_batch = __gpio_get_batch_generic;
+#endif
 
 	/* these GPIO numbers must not be managed by another gpio_chip */
 	for (id = base; id < base + chip->ngpio; id++) {
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 81797ec..4e92ccf 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -44,6 +44,10 @@ struct module;
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
+ * @set_batch: batch assigns output values for signals starting at
+ *	"startpin" with mask in "mask" all within this gpio_chip
+ * @get_batch: batch fetches values for consecutive signals starting at
+ *	"startpin" with mask in "mask" all within this gpio_chip
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
+						unsigned startpin, u32 mask,
+						int width, u32 values);
+	int			(*get_batch)(struct gpio_chip *chip,
+						unsigned startpin, u32 mask,
+						int width, u32 *result);
+#endif
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
 
@@ -124,6 +135,10 @@ extern void gpio_set_value_cansleep(unsigned gpio, int value);
  */
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
+#ifdef CONFIG_GPIOLIB_BATCH
+extern int __gpio_set_batch(unsigned gpio, u32 mask, int width, u32 values);
+extern int __gpio_get_batch(unsigned gpio, u32 mask, int width, u32 *result);
+#endif
 
 extern int __gpio_cansleep(unsigned gpio);
 
-- 
1.5.2.3

