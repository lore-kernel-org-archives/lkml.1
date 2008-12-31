Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYLaJ2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYLaJ2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYLaJ2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:28:05 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:54744 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbYLaJ2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:28:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=N6XLJMGABfYOR7wcPgjL+k4LW/pf74Y0imQGB36aNFN7WsuURHWqrGw+GXhdJvIT2b
         3IWuzfGnawhjjaTVbn2GgVxrISki8IYBSkuDUZ+0xvg06IqHax+hycEZ0nXwsh0ytQrL
         8ckK38MiuPL1bGD5HRc70wuQc1ezLTidXf/zc=
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: jayakumar.lkml@gmail.com
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>,
       David Brownell <david-b@pacbell.net>, Eric Miao <eric.miao@marvell.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Sam Ravnborg <sam@ravnborg.org>, Russell King <rmk@arm.linux.org.uk>,
       Ben Gardner <bgardner@wabtec.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [RFC 2.6.28 1/1] gpiolib: add set/get batch v3
Date: Wed, 31 Dec 2008 17:27:52 +0800
Message-Id: <12307156721518-git-send-email-jayakumar.lkml@gmail.com>
X-Mailer: git-send-email 1.5.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi friends,

This is v3 of my attempt to add batch support to gpiolib. Thanks to David
Brownell, Eric Miao, Robin, Ben, Jamie and others for prior feedback.  Here
are my notes to summarize some of the lengthy previous discussion (long):

*- naming choice
I had previously suggested set_value_bus, set_values, set_multiple, and
these weren't well liked. Rightfully so, as they weren't quite right. After
some thought, I've picked gpio_set/get_batch and stuck with it because I
think this reflects accurately what my code is doing. I checked google
define:batch

1: batch together; assemble or process as a batch
2: In Unix-like computer operating systems, the at command is used to schedule
commands to be executed once, at a particular time in the future.
3: A collection of products or data which is treated as one entity with
respect to certain operations eg processing and production.
4: A group of records or documents considered as a single unit for the
purpose of data processing.

*- API choice of using startpin, bitmask and length
Okay, this one is harder for me to defend since it is more subjective. I
read through Robin and David's remarks carefully. The points are valid about
creating a more generic API that is not limited to 32-bits of GPIO being
set/get at a time. I agree that that type of an API is more elegant and more
capable. But we have to look at the use cases. We need to ask ourselves, is
there a use case out there where a driver is trying to set more than 32-bits
of GPIO at a time AND needs such a set to be very fast. My opinion is that
such a case doesn't currently exist. Also, I'd like to emphasize that nothing
prevents such an API from being added in future if by some luck, we encounter
the need for it.

I think I should also clarify that this start/mask/width API doesn't
require that the 32-bits all be in the same register. The code is designed
to handle crossing multiple register boundaries and in fact, the only
current use case, a 16-bit bus in am300epd.c sits between 2 32-bit register
boundaries, so this code is tested to support crossing reg boundaries.

There was a question about why have both bitmask AND width when width
could be worked out from bitmask. The reason for having both bitmask and
length is for performance. Let's compare the following two scenarios:

/* flash to black */
for (i=0; i < 800*600; i++)
	gpio_set_batch(DB0, 0x00000000, 0x0000FFFF)

Internally, the above implementation has to work out the length of bits
that are being set in bitmask in order to figure out which register
boundaries are being crossed. That means looping through the bitmask
and counting bits. That would need to be repeated for every call of
gpio_set_batch in the above loop and would be a relatively high expense.

/* flash to black */
for (i=0; i < 800*600; i++)
	gpio_set_batch(DB0, 0x00000000, 0x0000FFFF, 16)

In the 2nd case, the implementation is able to skip all the bit counting.
This usage method is also the intuitive way for drivers that are trying
to push data across a gpio bus since they explicitly know the bus length.

*- returning an error
I thought this was an excellent idea. But then while writing the code, I
realized the error paths in this startpin/mask/width usage scenario would
be due to API usage errors rather than return errors. For example:

if a caller hit the generic case, it would go through:
+       for (i = 0; i < width; i++) {
+               mask = 1 << i;
+               if (bitmask & mask) {
+                       value = values & mask;
+                       chip->set(chip, offset + i, value);
+               }
+       }

The pre-existing chip->set API returns no error so there isn't one that we
create in order to pass back to the caller.

I've put in:
+       BUG_ON(offset + width >  chip->ngpio);
+       BUG_ON(bitwidth > 32);
to capture API usage errors. I think this was the right thing to do. If not,
please let me know and I can return such conditions as errors and move the
return value to an argument.

Whew, I hope I have addressed everyone's feedback. I appreciate the strong
feedback, it took me a bit by surprise, but it is very useful and I am
grateful for it. Please let me know your thoughts on the appended code.

Thanks and Happy New Year,
jaya

am300epd was doing 800*600*16*gpio_set_value for each framebuffer transfer
(it uses 16-pins of gpio as its data bus). I found this caused a wee
performance limitation. This patch adds an API for gpio_s/get_batch
which allows drivers to s/get batches of gpio together in a single call.
I have done a test implementation on gumstix (pxa255) with am300epd
and it provides a nice improvement in performance.

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ben Gardner <bgardner@wabtec.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/mach-pxa/Kconfig             |    1 +
 arch/arm/mach-pxa/am300epd.c          |   14 +---
 arch/arm/mach-pxa/gpio.c              |   60 ++++++++++++
 arch/arm/mach-pxa/include/mach/gpio.h |   43 +++++++++
 drivers/gpio/Kconfig                  |    5 +
 drivers/gpio/gpiolib.c                |  161 +++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h            |   18 ++++-
 7 files changed, 289 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index 768618b..a5a306e 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -41,6 +41,7 @@ config GUMSTIX_AM200EPD
 	bool "Enable AM200EPD board support"
 
 config GUMSTIX_AM300EPD
+	select GPIOLIB_BATCH
 	bool "Enable AM300EPD board support"
 
 endchoice
diff --git a/arch/arm/mach-pxa/am300epd.c b/arch/arm/mach-pxa/am300epd.c
index 4bd10a1..19c8af2 100644
--- a/arch/arm/mach-pxa/am300epd.c
+++ b/arch/arm/mach-pxa/am300epd.c
@@ -187,24 +187,14 @@ static void am300_cleanup(struct broadsheetfb_par *par)
 
 static u16 am300_get_hdb(struct broadsheetfb_par *par)
 {
-	u16 res = 0;
-	int i;
-
-	for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
-		res |= (gpio_get_value(DB0_GPIO_PIN + i)) ? (1 << i) : 0;
-
-	return res;
+	return gpio_get_batch(DB0_GPIO_PIN, 0xFFFF, 16);
 }
 
 static void am300_set_hdb(struct broadsheetfb_par *par, u16 data)
 {
-	int i;
-
-	for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
-		gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
+	gpio_set_batch(DB0_GPIO_PIN, data, 0xFFFF, 16);
 }
 
-
 static void am300_set_ctl(struct broadsheetfb_par *par, unsigned char bit,
 				u8 state)
 {
diff --git a/arch/arm/mach-pxa/gpio.c b/arch/arm/mach-pxa/gpio.c
index 5fec1e4..1cee979 100644
--- a/arch/arm/mach-pxa/gpio.c
+++ b/arch/arm/mach-pxa/gpio.c
@@ -162,6 +162,64 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 		__raw_writel(mask, pxa->regbase + GPCR_OFFSET);
 }
 
+#ifdef CONFIG_GPIOLIB_BATCH
+/*
+ * Set output GPIO level in batches
+ */
+static void pxa_gpio_set_batch(struct gpio_chip *chip, unsigned offset,
+				u32 values, u32 bitmask, int width)
+{
+	struct pxa_gpio_chip *pxa;
+
+	/* we're guaranteed by the caller that offset + bitmask remains
+	 * in this chip.
+	 */
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+
+	/* bitmask is used twice in shifted form */
+	bitmask <<= offset;
+
+	values = (values << offset) & bitmask;
+	if (values)
+		__raw_writel(values, pxa->regbase + GPSR_OFFSET);
+
+	values = ~values & bitmask;
+	if (values)
+		__raw_writel(values, pxa->regbase + GPCR_OFFSET);
+}
+
+/*
+ * Get output GPIO level in batches
+ */
+static u32 pxa_gpio_get_batch(struct gpio_chip *chip, unsigned offset,
+				u32 bitmask, int width)
+{
+	u32 values;
+	struct pxa_gpio_chip *pxa;
+
+	/* we're guaranteed by the caller that offset + bitmask remains
+	 * in this chip.
+	 */
+	pxa = container_of(chip, struct pxa_gpio_chip, chip);
+
+	values = __raw_readl(pxa->regbase + GPLR_OFFSET);
+
+	/* shift the result back into original position */
+	return (values >> offset) & bitmask;
+}
+#endif
+
+/* this is done this way so that we can insert an ifdef-able value
+ * into the following GPIO_CHIP macro
+ */
+#ifdef CONFIG_GPIOLIB_BATCH
+#define SET_BATCH_MACRO	.set_batch 	  = pxa_gpio_set_batch,
+#define GET_BATCH_MACRO	.get_batch	  = pxa_gpio_get_batch,
+#else
+#define SET_BATCH_MACRO
+#define GET_BATCH_MACRO
+#endif
+
 #define GPIO_CHIP(_n)							\
 	[_n] = {							\
 		.regbase = GPIO##_n##_BASE,				\
@@ -173,6 +231,8 @@ static void pxa_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 			.set		  = pxa_gpio_set,		\
 			.base		  = (_n) * 32,			\
 			.ngpio		  = 32,				\
+			SET_BATCH_MACRO					\
+			GET_BATCH_MACRO					\
 		},							\
 	}
 
diff --git a/arch/arm/mach-pxa/include/mach/gpio.h b/arch/arm/mach-pxa/include/mach/gpio.h
index 2c538d8..fd20129 100644
--- a/arch/arm/mach-pxa/include/mach/gpio.h
+++ b/arch/arm/mach-pxa/include/mach/gpio.h
@@ -56,6 +56,49 @@ static inline void gpio_set_value(unsigned gpio, int value)
 	}
 }
 
+#ifdef CONFIG_GPIOLIB_BATCH
+static inline void gpio_set_batch(unsigned gpio, u32 values, u32 bitmask,
+					int bitwidth)
+{
+	if (__builtin_constant_p(gpio) &&
+		(gpio + bitwidth < NR_BUILTIN_GPIO) &&
+		((gpio + bitwidth) <= roundup(gpio+1, 32))) {
+		int shift;
+
+		shift = gpio % 32;
+		bitmask <<= shift;
+
+		values = (values << shift) & bitmask;
+		if (values)
+			GPSR(gpio) = values;
+
+		values = ~values & bitmask;
+		if (values)
+			GPCR(gpio) = values;
+	} else {
+		__gpio_set_batch(gpio, values, bitmask, bitwidth);
+	}
+}
+
+static inline u32 gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth)
+{
+	if (__builtin_constant_p(gpio) &&
+		(gpio + bitwidth < NR_BUILTIN_GPIO) &&
+		((gpio + bitwidth) <= roundup(gpio+1, 32))) {
+		int shift;
+		u32 values;
+
+		shift = gpio % 32;
+
+		values = GPLR(gpio);
+
+		return (values >> shift) & bitmask;
+	} else {
+		return __gpio_get_batch(gpio, bitmask, bitwidth);
+	}
+}
+#endif
+
 #define gpio_cansleep __gpio_cansleep
 
 #define gpio_to_irq(gpio)	IRQ_GPIO(gpio)
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 48f49d9..aeeb83c 100644
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
index 82020ab..3d4c39a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -643,6 +643,161 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 
 #endif /* CONFIG_GPIO_SYSFS */
 
+#ifdef CONFIG_GPIOLIB_BATCH
+/**
+ * __generic_gpio_set_batch() - assigns a batch of gpio pins
+ * @chip: gpio_chip containing this set of pins
+ * @offset: starting gpio pin
+ * @values: unshifted values to assign, sequential and including masked bits
+ * @bitmask: unshifted bitmask to be applied to values
+ * Context: any
+ *
+ * This provides a generic platform independent set_batch capability.
+ * It invokes the associated gpio_chip.set() method to actually set the
+ * value.
+ */
+static void __generic_gpio_set_batch(struct gpio_chip *chip, unsigned offset,
+					u32 values, u32 bitmask, int width)
+{
+	int i;
+	int value;
+	u32 mask;
+
+	BUG_ON(offset + width >  chip->ngpio);
+
+	/* loop between the starting bit and the width and if the bitmask
+	 * enables this bit, then we set the specified value */
+	for (i = 0; i < width; i++) {
+		mask = 1 << i;
+		if (bitmask & mask) {
+			value = values & mask;
+			chip->set(chip, offset + i, value);
+		}
+	}
+}
+
+/**
+ * __generic_gpio_get_batch() - get a batch of gpio pins together
+ * @chip: gpio_chip containing this set of pins
+ * @offset: starting gpio pin
+ * @bitmask: unshifted bitmask to be applied to values
+ * Context: any
+ *
+ * This provides a generic platform independent get_batch capability.
+ * It invokes the associated gpio_chip.get() method to actually get the
+ * value.
+ */
+static u32 __generic_gpio_get_batch(struct gpio_chip *chip, unsigned offset,
+					u32 bitmask, int width)
+{
+	int i;
+	u32 mask;
+	u32 values = 0;
+
+	BUG_ON(offset + width >  chip->ngpio);
+	/* loop between the starting bit and the width and if the bitmask
+	 * matches this bit, then we get the value and track it */
+	for (i = 0; i < width; i++) {
+		mask = 1 << i;
+		if (bitmask & mask) {
+			if (chip->get(chip, offset + i))
+				values |= mask;
+		}
+	}
+
+	return values;
+}
+
+/**
+ * __gpio_set_batch() - assign a batch of gpio pins together
+ * @gpio: starting gpio pin
+ * @values: values to assign, sequential and including masked bits
+ * @bitmask: bitmask to be applied to values
+ * @bitwidth: width inclusive of masked-off bits
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_set_value().
+ * It invokes the associated gpio_chip.set_batch() method. If that
+ * method does not exist for any segment that is involved, then it drops
+ * back down to standard gpio_chip.set()
+ */
+void __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask, int bitwidth)
+{
+	struct gpio_chip *chip;
+	int i = 0;
+	int value, width, remwidth;
+	u32 mask;
+
+	BUG_ON(bitwidth > 32);
+	do {
+		chip = gpio_to_chip(gpio + i);
+		WARN_ON(extra_checks && chip->can_sleep);
+
+		value = values >> i; /* shift off the used data bits */
+		remwidth = ((chip->base + (int) chip->ngpio) -
+					((int) gpio + i));
+		width = min(bitwidth, remwidth);
+
+		/* shift off the used mask bits */
+		mask = bitmask >> i;
+		/* now adjust mask by width of this set */
+		mask &= ((1 << width) - 1);
+
+		chip->set_batch(chip, gpio + i - chip->base, value, mask,
+					width);
+		i += width;
+		bitwidth -= width;
+	} while (bitwidth);
+}
+EXPORT_SYMBOL_GPL(__gpio_set_batch);
+
+/**
+ * __gpio_get_batch() - get a batch of gpio pins together
+ * @gpio: starting gpio pin
+ * @bitmask: bitmask to be applied to values
+ * @bitwidth: width inclusive of masked-off bits
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_get_value().
+ * It invokes the associated gpio_chip.get_batch() method and returns
+ * zero if no such method is provided.
+ */
+u32 __gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth)
+{
+	struct gpio_chip *chip;
+	int i = 0;
+	int width, remwidth;
+	u32 mask;
+	u32 values = 0;
+	u32 value;
+
+	BUG_ON(bitwidth > 32);
+	do {
+		chip = gpio_to_chip(gpio + i);
+		WARN_ON(extra_checks && chip->can_sleep);
+
+		remwidth = ((chip->base + (int) chip->ngpio) -
+					((int) gpio + i));
+		width = min(bitwidth, remwidth);
+
+		/* shift off the used mask bits */
+		mask = bitmask >> i;
+		/* now adjust mask by width of get */
+		mask &= ((1 << width) - 1);
+
+		value = chip->get_batch(chip, gpio + i - chip->base, mask,
+					width);
+		/* shift result back into caller position */
+		values |= value << i;
+		i += width;
+		bitwidth -= width;
+	} while (bitwidth);
+
+	return values;
+}
+EXPORT_SYMBOL_GPL(__gpio_get_batch);
+#endif
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -683,6 +838,12 @@ int gpiochip_add(struct gpio_chip *chip)
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
index 81797ec..6cfe275 100644
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
+	void			(*set_batch)(struct gpio_chip *chip,
+						unsigned offset, u32 values,
+						u32 bitmask, int width);
+	u32			(*get_batch)(struct gpio_chip *chip,
+						unsigned offset, u32 bitmask,
+						int width);
+#endif
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
 
@@ -124,6 +135,11 @@ extern void gpio_set_value_cansleep(unsigned gpio, int value);
  */
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
+#ifdef CONFIG_GPIOLIB_BATCH
+extern void __gpio_set_batch(unsigned gpio, u32 values, u32 bitmask,
+				int bitwidth);
+extern u32 __gpio_get_batch(unsigned gpio, u32 bitmask, int bitwidth);
+#endif
 
 extern int __gpio_cansleep(unsigned gpio);
 
-- 
1.5.2.3

