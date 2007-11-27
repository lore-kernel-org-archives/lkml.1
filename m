Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbXK0K6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbXK0K6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbXK0K6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:58:35 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:15489 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbXK0K6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:58:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xvMVbNNGZfrGxClNO8GXa4nI8b6MlHDKzbAXS8N10zLuzRL+uFg9b3SKS6iMcmEuLG7HByJfdQfaAmrk6LWi7wEp+K6E4FoBB1+g3Ttobv1EOMyzHg8A39Jp7DeH93X7M07CMaVKCd5djLYrub683d+Ax7kLGF71aFEaJETA5Pc=
Message-ID: <f17812d70711270258v1e2b47aam74da33687728a78@mail.gmail.com>
Date: Tue, 27 Nov 2007 18:58:33 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
In-Reply-To: <200711261746.55235.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <f17812d70711132240m359fcd5doac56ab06bfe76f69@mail.gmail.com>
	 <200711132308.48779.david-b@pacbell.net>
	 <200711261746.55235.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here's the all-in-one patch based on David's most recent gpiolib fix,

Changes include:

1. use per gpio structure "gpio_desc", thus eliminating the restriction of
   ARCH_GPIOS_PER_CHIP, thus making it possible leaving no holes in GPIOs
   numbering

   Note: the number of GPIOs on different GPIO expander chips may vary
   much, from 1-2 GPIOs on some audio codecs to dedicated 16-pin GPIO
   expander chips. The ARCH_GPIOS_PER_CHIP might not be fair enough.

   this change introduces the following small changes:

   a) removal of "gpio_chips[]" and use "gpio_desc[]" instead
   b) move of "is_out" and "requested" from "struct gpio_chip" to "struct
      gpio_desc" and make them bit fields
   c) removal of "gpiochip_is_requested()", and use "gpio_desc->requested"
      instead

   Note: I do want a reference count field within gpio_chip to record the
   number of requested GPIOs within the chip, leave this to next patch

   d) make gpio_ensure_requested() use gpio_desc, and simplify the code a
      bit

2. reduce ARCH_NR_GPIOS to 256, which is moderate for most sane platforms,
   and thus saving some memory of the per gpio structures

3. dedicated "gpio_desc.requested_label" field for use with debugfs

4. use a loop for "gpio_desc[]" instead of a loop for "gpio_chips[]" in
   gpiolib_show(), change is straight forward; since it is now per gpio
   based, the gpio_chip.dbg_show() is removed as well

------ >8 -------

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 869b739..e3b2c8f 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -14,14 +14,20 @@
  */

 #ifndef ARCH_NR_GPIOS
-#define ARCH_NR_GPIOS		512
-#endif
-
-#ifndef ARCH_GPIOS_PER_CHIP
-#define ARCH_GPIOS_PER_CHIP	BITS_PER_LONG
+#define ARCH_NR_GPIOS		256
 #endif

 struct seq_file;
+struct gpio_chip;
+
+struct gpio_desc {
+	struct gpio_chip	*chip;
+	unsigned		is_out:1;
+	unsigned		requested:1;
+#ifdef CONFIG_DEBUG_FS
+	const char		*requested_label;
+#endif
+};

 /**
  * struct gpio_chip - abstract a GPIO controller
@@ -41,8 +47,6 @@ struct seq_file;
  *	(base + ngpio - 1).
  * @can_sleep: flag must be set iff get()/set() methods sleep, as they
  *	must while accessing GPIO expander chips over I2C or SPI
- * @is_out: bit array where bit N is true iff GPIO with offset N has been
- *	 called successfully to configure this as an output
  *
  * A gpio_chip can help platforms abstract various sources of GPIOs so
  * they can all be accessed through a common programing interface.
@@ -65,37 +69,11 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
-	void			(*dbg_show)(struct seq_file *s,
-						struct gpio_chip *chip);
 	int			base;
 	u16			ngpio;
 	unsigned		can_sleep:1;
-
-	/* other fields are modified by the gpio library only */
-	DECLARE_BITMAP(is_out, ARCH_GPIOS_PER_CHIP);
-
-#ifdef CONFIG_DEBUG_FS
-	/* fat bits */
-	const char		*requested[ARCH_GPIOS_PER_CHIP];
-#else
-	/* thin bits */
-	DECLARE_BITMAP(requested, ARCH_GPIOS_PER_CHIP);
-#endif
 };

-/* returns true iff a given gpio signal has been requested;
- * primarily for code dumping gpio_chip state.
- */
-static inline int
-gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
-{
-#ifdef CONFIG_DEBUG_FS
-	return chip->requested[offset] != NULL;
-#else
-	return test_bit(offset, chip->requested);
-#endif
-}
-
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
 extern int __must_check gpiochip_remove(struct gpio_chip *chip);
diff --git a/lib/gpiolib.c b/lib/gpiolib.c
index a853715..f24182e 100644
--- a/lib/gpiolib.c
+++ b/lib/gpiolib.c
@@ -28,39 +28,30 @@
 #define	extra_checks	0
 #endif

-/* gpio_lock protects the table of chips and gpio_chip->requested.
+/* gpio_lock protects the table of gpio_desc[] and desc->requested.
  * While any GPIO is requested, its gpio_chip is not removable;
  * each GPIO's "requested" flag serves as a lock and refcount.
  */
 static DEFINE_SPINLOCK(gpio_lock);
-static struct gpio_chip *chips[DIV_ROUND_UP(ARCH_NR_GPIOS,
-					ARCH_GPIOS_PER_CHIP)];
-
+struct gpio_desc gpio_desc[ARCH_NR_GPIOS];

 /* Warn when drivers omit gpio_request() calls -- legal but
  * ill-advised when setting direction, and otherwise illegal.
  */
-static void gpio_ensure_requested(struct gpio_chip *chip, unsigned offset)
+static void gpio_ensure_requested(struct gpio_desc *desc, unsigned gpio)
 {
-	int		requested;
-
 #ifdef CONFIG_DEBUG_FS
-	requested = (int) chip->requested[offset];
-	if (!requested)
-		chip->requested[offset] = "[auto]";
-#else
-	requested = test_and_set_bit(offset, chip->requested);
+	if (!desc->requested)
+		desc->requested_label = "(auto)";
 #endif
-
-	if (!requested)
-		printk(KERN_DEBUG "GPIO-%d autorequested\n",
-				chip->base + offset);
+	if (!desc->requested)
+		printk(KERN_DEBUG "GPIO-%d autorequested\n", gpio);
 }

 /* caller holds gpio_lock *OR* gpio is marked as requested */
 static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
-	return chips[gpio / ARCH_GPIOS_PER_CHIP];
+	return gpio_desc[gpio].chip;
 }

 /**
@@ -75,26 +66,25 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 int gpiochip_add(struct gpio_chip *chip)
 {
 	unsigned long	flags;
-	int		status = 0;
 	unsigned	id;

-	if (chip->base < 0 || (chip->base % ARCH_GPIOS_PER_CHIP) != 0)
-		return -EINVAL;
-	if ((chip->base + chip->ngpio) >= ARCH_NR_GPIOS)
-		return -EINVAL;
-	if (chip->ngpio > ARCH_GPIOS_PER_CHIP)
+	if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS)
 		return -EINVAL;

 	spin_lock_irqsave(&gpio_lock, flags);

-	id = chip->base / ARCH_GPIOS_PER_CHIP;
-	if (chips[id] == NULL)
-		chips[id] = chip;
-	else
-		status = -EBUSY;
+	/* make sure the GPIOs are not claimed by any gpio_chip */
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		if (gpio_desc[id].chip != NULL) {
+			spin_unlock_irqrestore(&gpio_lock, flags);
+			return -EBUSY;
+		}
+
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		gpio_desc[id].chip = chip;

 	spin_unlock_irqrestore(&gpio_lock, flags);
-	return status;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);

@@ -107,28 +97,21 @@ EXPORT_SYMBOL_GPL(gpiochip_add);
 int gpiochip_remove(struct gpio_chip *chip)
 {
 	unsigned long	flags;
-	int		status = 0;
-	int		offset;
-	unsigned	id = chip->base / ARCH_GPIOS_PER_CHIP;
+	unsigned	id;

 	spin_lock_irqsave(&gpio_lock, flags);

-	for (offset = 0; offset < chip->ngpio; offset++) {
-		if (gpiochip_is_requested(chip, offset)) {
-			status = -EBUSY;
-			break;
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		if (gpio_desc[id].requested) {
+			spin_unlock_irqrestore(&gpio_lock, flags);
+			return -EBUSY;
 		}
-	}

-	if (status == 0) {
-		if (chips[id] == chip)
-			chips[id] = NULL;
-		else
-			status = -EINVAL;
-	}
+	for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		gpio_desc[id].chip = NULL;

 	spin_unlock_irqrestore(&gpio_lock, flags);
-	return status;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);

@@ -139,17 +122,15 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
  */
 int gpio_request(unsigned gpio, const char *label)
 {
-	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 	int			status = -EINVAL;
 	unsigned long		flags;

 	spin_lock_irqsave(&gpio_lock, flags);

-	chip = gpio_to_chip(gpio);
-	if (!chip)
-		goto done;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
+	desc = &gpio_desc[gpio];
+
+	if (desc->chip == NULL)
 		goto done;

 	/* NOTE:  gpio_request() can be called in early boot,
@@ -157,18 +138,16 @@ int gpio_request(unsigned gpio, const char *label)
 	 */

 	status = 0;
-#ifdef CONFIG_DEBUG_FS
-	if (!label)
-		label = "?";
-	if (chip->requested[gpio])
-		status = -EBUSY;
+
+	if (!desc->requested)
+		desc->requested = 1;
 	else
-		chip->requested[gpio] = label;
-#else
-	if (test_and_set_bit(gpio, chip->requested))
 		status = -EBUSY;
-#endif

+#ifdef CONFIG_DEBUG_FS
+	if (status == 0)
+		desc->requested_label = (label == NULL) ? "?" : label;
+#endif
 done:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
@@ -178,27 +157,23 @@ EXPORT_SYMBOL_GPL(gpio_request);
 void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
-	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;

 	spin_lock_irqsave(&gpio_lock, flags);

-	chip = gpio_to_chip(gpio);
-	if (!chip)
-		goto done;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
+	desc = &gpio_desc[gpio];
+
+	if (desc->chip == NULL)
 		goto done;

-#ifdef CONFIG_DEBUG_FS
-	if (chip->requested[gpio])
-		chip->requested[gpio] = NULL;
+	if (desc->requested)
+		desc->requested = 0;
 	else
-		chip = NULL;
-#else
-	if (!test_and_clear_bit(gpio, chip->requested))
-		chip = NULL;
+		WARN_ON(extra_checks);
+
+#ifdef CONFIG_DEBUG_FS
+	desc->requested_label = NULL;
 #endif
-	WARN_ON(extra_checks && chip == NULL);
 done:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 }
@@ -218,17 +193,22 @@ int gpio_direction_input(unsigned gpio)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 	int			status = -EINVAL;

 	spin_lock_irqsave(&gpio_lock, flags);

-	chip = gpio_to_chip(gpio);
+	desc = &gpio_desc[gpio];
+	chip = desc->chip;
+
+	gpio_ensure_requested(desc, gpio);
+
 	if (!chip || !chip->get || !chip->direction_input)
 		goto fail;
+
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(chip, gpio);

 	/* now we know the gpio is valid and chip won't vanish */

@@ -237,8 +217,8 @@ int gpio_direction_input(unsigned gpio)
 	might_sleep_if(extra_checks && chip->can_sleep);

 	status = chip->direction_input(chip, gpio);
-	if (status == 0)
-		clear_bit(gpio, chip->is_out);
+	if (status)
+		desc->is_out = 0;
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -250,17 +230,22 @@ int gpio_direction_output(unsigned gpio, int value)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 	int			status = -EINVAL;

 	spin_lock_irqsave(&gpio_lock, flags);

-	chip = gpio_to_chip(gpio);
+	desc = &gpio_desc[gpio];
+	chip = desc->chip;
+
+	gpio_ensure_requested(desc, gpio);
+
 	if (!chip || !chip->set || !chip->direction_output)
 		goto fail;
+
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(chip, gpio);

 	/* now we know the gpio is valid and chip won't vanish */

@@ -269,8 +254,8 @@ int gpio_direction_output(unsigned gpio, int value)
 	might_sleep_if(extra_checks && chip->can_sleep);

 	status = chip->direction_output(chip, gpio, value);
-	if (status == 0)
-		set_bit(gpio, chip->is_out);
+	if (status)
+		desc->is_out = 1;
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -363,27 +348,29 @@ EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>

-
-static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+static int gpiolib_show(struct seq_file *s, void *unused)
 {
-	unsigned	i;
+	struct gpio_chip	*chip;
+	unsigned		id;

-	for (i = 0; i < chip->ngpio; i++) {
-		unsigned	gpio;
-		int		is_out;
+	/* REVISIT this isn't locked against gpio_chip removal ... */

-		if (!chip->requested[i])
-			continue;
+	seq_printf(s, "gpio   chip_name   requested  direction  value  irq\n");

-		gpio = chip->base + i;
-		is_out = test_bit(i, chip->is_out);
+	for (id = 0; id < ARCH_NR_GPIO; id++) {
+		struct gpio_desc *desc = &gpio_desc[id];
+		struct gpio_chip *chip = desc->chip;
+
+		if (chip == NULL)
+			continue;

-		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
-			gpio, chip->requested[i],
-			is_out ? "out" : "in ",
-			chip->get
-				? (chip->get(chip, i) ? "hi" : "lo")
-				: "?  ");
+		seq_printf(s, " %3d %12s  %9s  %9s  %5s", gpio,
+				chip->label,
+				desc->requested_label,
+				(desc->is_out) ? "out" : "in",
+				(chip->get) ?
+					(chip->get(chip, i) ? "hi" : "lo")
+					: "?");

 		if (!is_out) {
 			int		irq = gpio_to_irq(gpio);
@@ -431,32 +418,6 @@ static void gpiolib_dbg_show(struct seq_file *s,
struct gpio_chip *chip)

 		seq_printf(s, "\n");
 	}
-}
-
-static int gpiolib_show(struct seq_file *s, void *unused)
-{
-	struct gpio_chip	*chip;
-	unsigned		id;
-	int			started = 0;
-
-	/* REVISIT this isn't locked against gpio_chip removal ... */
-
-	for (id = 0; id < ARRAY_SIZE(chips); id++) {
-		chip = chips[id];
-		if (!chip)
-			continue;
-
-		seq_printf(s, "%sGPIOs %d-%d, %s%s:\n",
-				started ? "\n" : "",
-				chip->base, chip->base + chip->ngpio - 1,
-				chip->label ? : "generic",
-				chip->can_sleep ? ", can sleep" : "");
-		started = 1;
-		if (chip->dbg_show)
-			chip->dbg_show(s, chip);
-		else
-			gpiolib_dbg_show(s, chip);
-	}
 	return 0;
 }

------ >8 -------

On Nov 27, 2007 9:46 AM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 13 November 2007, David Brownell wrote:
> > So the point of these is to make it easier for platforms
> > (or even just boards) to make sure the GPIO number space
> > is densely packed, rather than loosely so? Paying about
> > 2KBytes for that privilege. (Assuming a 32 bit system
> > with 256 GPIOs.)
> >
> > I could see that being a reasonable tradeoff. I wouldn't
> > have started there myself, but you know how that goes!
> >
> > Does anyone else have any comments on that issue?
>
> Nobody else seems to have any comments on Eric's series
> of patches to add a gpio_desc layer ... whereas, I was
> looking at updating one platform, and got annoyed at some
> stuff that would have been non-issues with them in place!
>
>
> Eric, would you feel like rolling an all-in-one patch against
> the gpiolib support from 2.6.24-rc3-mm?  Including updated
> versions of your patches:
>
>  - [PATCH 2/5] define gpio_chip.requested_str
>         (renaming it as "label" to match its usage)
>  - [PATCH 3/5] use a per GPIO "struct gpio_desc"
>         (but without that needless list; for debug,
>         just scan the gpio_desc list for the next
>         non-null chip)
>  - [PATCH] move per GPIO "is_out" to "struct gpio_desc"
>         (i.e. patch 4/5)
>  - [PATCH 5/5] move per GPIO "requested" to "struct gpio_desc"
>         (and "label" too)
>
> along with removing the ARCH_GPIOS_PER_CHIP symbol, and
> reducing ARCH_NR_GPIOS to a value which will waste less
> space by default?  (Like maybe 256.)
>
> I think an all-in-one patch will be easier to review
> and agree on including (or not).
>
> - Dave
>

-- 
Cheers
- eric
