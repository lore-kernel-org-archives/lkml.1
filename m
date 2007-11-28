Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXK1FLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXK1FLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbXK1FLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:11:44 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:50098 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbXK1FLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:11:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DEdi8P17Ni0Eps2su/8KOua/5TOFoVhrojriMDLz6HQ0Rh1q/HGP4rmrO3t9wBN4gYsNP+u6dhCA1Wi2QNsVTmD80DVJT+D/IpIyVHnOHaOnw6XvrFJVE76+Q8L+bshaayVhb7rtnaYUM3N7pJFB/Yc3YVc98PeH/VNdKLRV5io=
Message-ID: <f17812d70711272111g4fe1abeeo7b1ec31d547975b6@mail.gmail.com>
Date: Wed, 28 Nov 2007 13:11:42 +0800
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
In-Reply-To: <200711271129.46754.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710291809.29936.david-b@pacbell.net>
	 <200711261746.55235.david-b@pacbell.net>
	 <f17812d70711270258v1e2b47aam74da33687728a78@mail.gmail.com>
	 <200711271129.46754.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I thought you want a preliminary one, here's the one
tested and including your comments except for one:

if caller holds gpio_lock, gpio_ensure_requested() is actually
safe.

please review:

---
 include/asm-generic/gpio.h |   35 +++-----
 lib/gpiolib.c              |  212 +++++++++++++++++++-------------------------
 2 files changed, 104 insertions(+), 143 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 869b739..34e60ba 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -14,14 +14,22 @@
  */

 #ifndef ARCH_NR_GPIOS
-#define ARCH_NR_GPIOS		512
+#define ARCH_NR_GPIOS		256
 #endif

-#ifndef ARCH_GPIOS_PER_CHIP
-#define ARCH_GPIOS_PER_CHIP	BITS_PER_LONG
+struct seq_file;
+struct gpio_chip;
+
+struct gpio_desc {
+	struct gpio_chip	*chip;
+	unsigned		is_out:1;
+	unsigned		requested:1;
+#ifdef CONFIG_DEBUG_FS
+	const char		*requested_label;
 #endif
+};

-struct seq_file;
+extern struct gpio_desc gpio_desc[ARCH_NR_GPIOS];

 /**
  * struct gpio_chip - abstract a GPIO controller
@@ -41,8 +49,6 @@ struct seq_file;
  *	(base + ngpio - 1).
  * @can_sleep: flag must be set iff get()/set() methods sleep, as they
  *	must while accessing GPIO expander chips over I2C or SPI
- * @is_out: bit array where bit N is true iff GPIO with offset N has been
- *	 called successfully to configure this as an output
  *
  * A gpio_chip can help platforms abstract various sources of GPIOs so
  * they can all be accessed through a common programing interface.
@@ -70,17 +76,6 @@ struct gpio_chip {
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

 /* returns true iff a given gpio signal has been requested;
@@ -89,11 +84,7 @@ struct gpio_chip {
 static inline int
 gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
 {
-#ifdef CONFIG_DEBUG_FS
-	return chip->requested[offset] != NULL;
-#else
-	return test_bit(offset, chip->requested);
-#endif
+	return gpio_desc[chip->base + offset].requested;
 }

 /* add/remove chips */
diff --git a/lib/gpiolib.c b/lib/gpiolib.c
index a853715..6050af5 100644
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

@@ -238,7 +218,7 @@ int gpio_direction_input(unsigned gpio)

 	status = chip->direction_input(chip, gpio);
 	if (status == 0)
-		clear_bit(gpio, chip->is_out);
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

@@ -270,7 +255,7 @@ int gpio_direction_output(unsigned gpio, int value)

 	status = chip->direction_output(chip, gpio, value);
 	if (status == 0)
-		set_bit(gpio, chip->is_out);
+		desc->is_out = 1;
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -363,29 +348,39 @@ EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>

-
-static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+static int gpiolib_show(struct seq_file *s, void *unused)
 {
-	unsigned	i;
+	unsigned		gpio = 0;
+	unsigned		offset;
+
+	/* REVISIT this isn't locked against gpio_chip removal ... */

-	for (i = 0; i < chip->ngpio; i++) {
-		unsigned	gpio;
-		int		is_out;
+	seq_printf(s, "gpio   chip_name    requested  direction  value  irq\n");

-		if (!chip->requested[i])
+	while (gpio < ARCH_NR_GPIOS) {
+		struct gpio_desc *desc = &gpio_desc[gpio];
+		struct gpio_chip *chip = desc->chip;
+
+		if (chip == NULL)
 			continue;

-		gpio = chip->base + i;
-		is_out = test_bit(i, chip->is_out);
+		if (chip->dbg_show) {
+			chip->dbg_show(s, chip);
+			gpio += chip->ngpio;
+			continue;
+		}
+
+		offset = gpio - chip->base;

-		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
-			gpio, chip->requested[i],
-			is_out ? "out" : "in ",
-			chip->get
-				? (chip->get(chip, i) ? "hi" : "lo")
-				: "?  ");
+		seq_printf(s, " %3d %11.11s  %10.10s  %9.9s  %5.5s", gpio,
+				chip->label,
+				desc->requested_label,
+				(desc->is_out) ? "out" : "in",
+				(chip->get) ?
+					(chip->get(chip, offset) ? "hi" : "lo")
+					: "?");

-		if (!is_out) {
+		if (!desc->is_out) {
 			int		irq = gpio_to_irq(gpio);
 			struct irq_desc	*desc = irq_desc + irq;

@@ -430,32 +425,7 @@ static void gpiolib_dbg_show(struct seq_file *s,
struct gpio_chip *chip)
 		}

 		seq_printf(s, "\n");
-	}
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
+		gpio++;
 	}
 	return 0;
 }
-- 
1.5.2.5.GIT



On Nov 28, 2007 3:29 AM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 27 November 2007, eric miao wrote:
> > status = chip->direction_input(chip, gpio);
> > -if (status == 0)
> > -clear_bit(gpio, chip->is_out);
> > +if (status)
> > +desc->is_out = 0;
>
> You added that same bug in two places (direction_output too).
> Only zero status means success; otherwise it's negative errno.
>
> Clearly this patch wasn't tested at all.
>



-- 
Cheers
- eric
