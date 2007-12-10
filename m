Return-Path: <linux-kernel-owner+w=401wt.eu-S1752457AbXLJEw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbXLJEw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbXLJEwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:52:00 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:28965 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751336AbXLJEv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:51:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=X3z5KagrSzoPY6dBl8JswQVs1cm2JV6nhrzoAGeZpOW4Ehlyx1qEROXnSem8SkEHURnNrKTX2mj+oyAw47mbLq0Y1RuC3cleVw+kgpHno8ml7vbrtOAwnlR8Czb9Ma6mA93ZEaY1oOehv2OvybOFLWDdga9iVi3iZiT8M7qZTcg=  ;
X-YMail-OSG: zDc1hl8VM1mrx2TyxN61BQMDeL9WFi_nyr5P4HPNi6LTtUEiZQwvJb.YnGoD6IunHZRq0JQ4XA--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc4-mm 1/6] gpiolib: add gpio_desc[]
Date: Sun, 9 Dec 2007 20:39:19 -0800
User-Agent: KMail/1.9.6
Cc: eric miao <eric.y.miao@marvell.com>
References: <200712092022.14062.david-b@pacbell.net>
In-Reply-To: <200712092022.14062.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712092039.20238.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Update gpiolib to use a table of per-GPIO "struct gpio_desc" instead of
a table of "struct gpio_chip".

 - Change "is_out" and "requested" from arrays in "struct gpio_chip" to
   bit fields in "struct gpio_desc", eliminating ARCH_GPIOS_PER_CHIP.

 - Stop overloading "requested" flag with "label" tracked for debugfs.

 - Change gpiochip_is_requested() into a regular function, since it
   now accesses data that's not exported from the gpiolib code.  Also
   change its signature, for the same reason.

 - Reduce default ARCH_NR_GPIOS to 256 to shrink gpio_desc table cost.
   On 32-bit platforms without debugfs, that table size is 2KB.

This makes it easier to work with chips with different numbers of GPIOs,
and to avoid holes in GPIOs number sequences.  Those holes can cost a
lot of unusable irq_desc space for GPIOs that act as IRQs; and needing
the can cause surprises when trying to set up multiple GPIO controllers.

Based on a patch from Eric Miao.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Eric Miao <eric.miao@marvell.com>
---
 arch/avr32/mach-at32ap/pio.c         |    7 -
 include/asm-avr32/arch-at32ap/gpio.h |    2 
 include/asm-generic/gpio.h           |   49 +-------
 lib/gpiolib.c                        |  213 ++++++++++++++++++++---------------
 4 files changed, 139 insertions(+), 132 deletions(-)

--- a/arch/avr32/mach-at32ap/pio.c	2007-12-09 19:50:50.000000000 -0800
+++ b/arch/avr32/mach-at32ap/pio.c	2007-12-09 19:50:59.000000000 -0800
@@ -315,12 +315,15 @@ static void pio_bank_show(struct seq_fil
 	bank = 'A' + pio->pdev->id;
 
 	for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
-		if (!gpiochip_is_requested(chip, i))
+		const char *label;
+
+		label = gpiochip_is_requested(chip, i);
+		if (!label)
 			continue;
 
 		seq_printf(s, " gpio-%-3d P%c%-2d (%-12s) %s %s %s",
 			chip->base + i, bank, i,
-			chip->requested[i],
+			label,
 			(osr & mask) ? "out" : "in ",
 			(mask & pdsr) ? "hi" : "lo",
 			(mask & pusr) ? "  " : "up");
--- a/include/asm-avr32/arch-at32ap/gpio.h	2007-12-09 19:50:50.000000000 -0800
+++ b/include/asm-avr32/arch-at32ap/gpio.h	2007-12-09 19:50:59.000000000 -0800
@@ -8,7 +8,7 @@
 /* Some GPIO chips can manage IRQs; some can't.  The exact numbers can
  * be changed if needed, but for the moment they're not configurable.
  */
-#define ARCH_NR_GPIOS	(NR_GPIO_IRQS + 2 * ARCH_GPIOS_PER_CHIP)
+#define ARCH_NR_GPIOS	(NR_GPIO_IRQS + 2 * 32)
 
 
 /* Arch-neutral GPIO API, supporting both "native" and external GPIOs. */
--- a/include/asm-generic/gpio.h	2007-12-09 19:50:50.000000000 -0800
+++ b/include/asm-generic/gpio.h	2007-12-09 19:50:59.000000000 -0800
@@ -4,21 +4,16 @@
 #ifdef CONFIG_GPIO_LIB
 
 /* Platforms may implement their GPIO interface with library code,
- * at a small performance cost for non-inlined operations.
+ * at a small performance cost for non-inlined operations and some
+ * extra memory (for code and for per-GPIO table entries).
  *
  * While the GPIO programming interface defines valid GPIO numbers
  * to be in the range 0..MAX_INT, this library restricts them to the
- * smaller range 0..ARCH_NR_GPIOS and allocates them in groups of
- * ARCH_GPIOS_PER_CHIP (which will usually be the word size used for
- * each bank of a SOC processor's integrated GPIO modules).
+ * smaller range 0..ARCH_NR_GPIOS.
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
@@ -36,21 +31,18 @@ struct seq_file;
  *	state (such as pullup/pulldown configuration).
  * @base: identifies the first GPIO number handled by this chip; or, if
  *	negative during registration, requests dynamic ID allocation.
- * @ngpio: the number of GPIOs handled by this controller; the value must
- *	be at most ARCH_GPIOS_PER_CHIP, so the last GPIO handled is
- *	(base + ngpio - 1).
+ * @ngpio: the number of GPIOs handled by this controller; the last GPIO
+ *	handled is (base + ngpio - 1).
  * @can_sleep: flag must be set iff get()/set() methods sleep, as they
  *	must while accessing GPIO expander chips over I2C or SPI
- * @is_out: bit array where bit N is true iff GPIO with offset N has been
- *	 called successfully to configure this as an output
  *
  * A gpio_chip can help platforms abstract various sources of GPIOs so
  * they can all be accessed through a common programing interface.
  * Example sources would be SOC controllers, FPGAs, multifunction
  * chips, dedicated GPIO expanders, and so on.
  *
- * Each chip controls a number of signals, numbered 0..@ngpio, which are
- * identified in method calls by an "offset" value.  When those signals
+ * Each chip controls a number of signals, identified in method calls
+ * by "offset" values in the range 0..(@ngpio - 1).  When those signals
  * are referenced through calls like gpio_get_value(gpio), the offset
  * is calculated by subtracting @base from the gpio number.
  */
@@ -70,31 +62,10 @@ struct gpio_chip {
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
+extern const char *gpiochip_is_requested(struct gpio_chip *chip,
+			unsigned offset);
 
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
--- a/lib/gpiolib.c	2007-12-09 19:50:50.000000000 -0800
+++ b/lib/gpiolib.c	2007-12-09 19:50:59.000000000 -0800
@@ -28,39 +28,43 @@
 #define	extra_checks	0
 #endif
 
-/* gpio_lock protects the table of chips and gpio_chip->requested.
+/* gpio_lock prevents conflicts during gpio_desc[] table updates.
  * While any GPIO is requested, its gpio_chip is not removable;
  * each GPIO's "requested" flag serves as a lock and refcount.
  */
 static DEFINE_SPINLOCK(gpio_lock);
-static struct gpio_chip *chips[DIV_ROUND_UP(ARCH_NR_GPIOS,
-					ARCH_GPIOS_PER_CHIP)];
+
+struct gpio_desc {
+	struct gpio_chip	*chip;
+	unsigned long		flags;
+/* flag symbols are bit numbers */
+#define FLAG_REQUESTED	0
+#define FLAG_IS_OUT	1
+
+#ifdef CONFIG_DEBUG_FS
+	const char		*label;
+#endif
+};
+static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
 
 /* Warn when drivers omit gpio_request() calls -- legal but
  * ill-advised when setting direction, and otherwise illegal.
  */
-static void gpio_ensure_requested(struct gpio_chip *chip, unsigned offset)
+static void gpio_ensure_requested(struct gpio_desc *desc)
 {
-	int		requested;
-
+	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
+		pr_warning("GPIO-%d autorequested\n", (int)(desc - gpio_desc));
 #ifdef CONFIG_DEBUG_FS
-	requested = (int) chip->requested[offset];
-	if (!requested)
-		chip->requested[offset] = "[auto]";
-#else
-	requested = test_and_set_bit(offset, chip->requested);
+		desc->label = "[auto]";
 #endif
-
-	if (!requested)
-		printk(KERN_DEBUG "GPIO-%d autorequested\n",
-				chip->base + offset);
+	}
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
 static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
-	return chips[gpio / ARCH_GPIOS_PER_CHIP];
+	return gpio_desc[gpio].chip;
 }
 
 /**
@@ -78,20 +82,28 @@ int gpiochip_add(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 
-	if (chip->base < 0 || (chip->base % ARCH_GPIOS_PER_CHIP) != 0)
-		return -EINVAL;
-	if ((chip->base + chip->ngpio) >= ARCH_NR_GPIOS)
-		return -EINVAL;
-	if (chip->ngpio > ARCH_GPIOS_PER_CHIP)
+	/* NOTE chip->base negative is reserved to mean a request for
+	 * dynamic allocation.  We don't currently support that.
+	 */
+
+	if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS)
 		return -EINVAL;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	id = chip->base / ARCH_GPIOS_PER_CHIP;
-	if (chips[id] == NULL)
-		chips[id] = chip;
-	else
-		status = -EBUSY;
+	/* these GPIO numbers must not be managed by another gpio_chip */
+	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+		if (gpio_desc[id].chip != NULL) {
+			status = -EBUSY;
+			break;
+		}
+	}
+	if (status == 0) {
+		for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+			gpio_desc[id].chip = chip;
+			gpio_desc[id].flags = 0;
+		}
+	}
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
@@ -108,23 +120,19 @@ int gpiochip_remove(struct gpio_chip *ch
 {
 	unsigned long	flags;
 	int		status = 0;
-	int		offset;
-	unsigned	id = chip->base / ARCH_GPIOS_PER_CHIP;
+	unsigned	id;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	for (offset = 0; offset < chip->ngpio; offset++) {
-		if (gpiochip_is_requested(chip, offset)) {
+	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+		if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
 			status = -EBUSY;
 			break;
 		}
 	}
-
 	if (status == 0) {
-		if (chips[id] == chip)
-			chips[id] = NULL;
-		else
-			status = -EINVAL;
+		for (id = chip->base; id < chip->base + chip->ngpio; id++)
+			gpio_desc[id].chip = NULL;
 	}
 
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -139,35 +147,29 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
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
+	if (gpio >= ARCH_NR_GPIOS)
 		goto done;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
+	desc = &gpio_desc[gpio];
+	if (desc->chip == NULL)
 		goto done;
 
 	/* NOTE:  gpio_request() can be called in early boot,
 	 * before IRQs are enabled.
 	 */
 
-	status = 0;
+	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
 #ifdef CONFIG_DEBUG_FS
-	if (!label)
-		label = "?";
-	if (chip->requested[gpio])
-		status = -EBUSY;
-	else
-		chip->requested[gpio] = label;
-#else
-	if (test_and_set_bit(gpio, chip->requested))
-		status = -EBUSY;
+		desc->label = (label == NULL) ? "?" : label;
 #endif
+		status = 0;
+	} else
+		status = -EBUSY;
 
 done:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -178,57 +180,85 @@ EXPORT_SYMBOL_GPL(gpio_request);
 void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
-	struct gpio_chip	*chip;
+	struct gpio_desc	*desc;
 
-	spin_lock_irqsave(&gpio_lock, flags);
+	if (gpio >= ARCH_NR_GPIOS) {
+		WARN_ON(extra_checks);
+		return;
+	}
 
-	chip = gpio_to_chip(gpio);
-	if (!chip)
-		goto done;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto done;
+	spin_lock_irqsave(&gpio_lock, flags);
 
+	desc = &gpio_desc[gpio];
+	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
 #ifdef CONFIG_DEBUG_FS
-	if (chip->requested[gpio])
-		chip->requested[gpio] = NULL;
-	else
-		chip = NULL;
-#else
-	if (!test_and_clear_bit(gpio, chip->requested))
-		chip = NULL;
+		desc->label = NULL;
 #endif
-	WARN_ON(extra_checks && chip == NULL);
-done:
+	} else
+		WARN_ON(extra_checks);
+
 	spin_unlock_irqrestore(&gpio_lock, flags);
 }
 EXPORT_SYMBOL_GPL(gpio_free);
 
 
+/**
+ * gpiochip_is_requested - return string iff signal was requested
+ * @chip: controller managing the signal
+ * @offset: of signal within controller's 0..(ngpio - 1) range
+ *
+ * Returns NULL if the GPIO is not currently requested, else a string.
+ * If debugfs support is enabled, the string returned is the label passed
+ * to gpio_request(); otherwise it is a meaningless constant.
+ *
+ * This function is for use by GPIO controller drivers.  The label can
+ * help with diagnostics, and knowing that the signal is used as a GPIO
+ * can help avoid accidentally multiplexing it to another controller.
+ */
+const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned gpio = chip->base + offset;
 
-/* Drivers MUST make configuration calls before get/set calls
+	if (gpio >= ARCH_NR_GPIOS || gpio_desc[gpio].chip != chip)
+		return NULL;
+	if (test_bit(FLAG_REQUESTED, &gpio_desc[gpio].flags) == 0)
+		return NULL;
+#ifdef CONFIG_DEBUG_FS
+	return gpio_desc[gpio].label;
+#else
+	return "?";
+#endif
+}
+EXPORT_SYMBOL_GPL(gpiochip_is_requested);
+
+
+/* Drivers MUST set GPIO direction before making get/set calls.  In
+ * some cases this is done in early boot, before IRQs are enabled.
  *
  * As a rule these aren't called more than once (except for drivers
  * using the open-drain emulation idiom) so these are natural places
- * to accumulate extra debugging checks.  Note that we can't rely on
- * gpio_request() having been called beforehand.
+ * to accumulate extra debugging checks.  Note that we can't (yet)
+ * rely on gpio_request() having been called beforehand.
  */
 
 int gpio_direction_input(unsigned gpio)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	chip = gpio_to_chip(gpio);
+	if (gpio >= ARCH_NR_GPIOS)
+		goto fail;
+	chip = desc->chip;
 	if (!chip || !chip->get || !chip->direction_input)
 		goto fail;
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(chip, gpio);
+	gpio_ensure_requested(desc);
 
 	/* now we know the gpio is valid and chip won't vanish */
 
@@ -238,7 +268,7 @@ int gpio_direction_input(unsigned gpio)
 
 	status = chip->direction_input(chip, gpio);
 	if (status == 0)
-		clear_bit(gpio, chip->is_out);
+		clear_bit(FLAG_IS_OUT, &desc->flags);
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -250,17 +280,20 @@ int gpio_direction_output(unsigned gpio,
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
+	struct gpio_desc	*desc = &gpio_desc[gpio];
 	int			status = -EINVAL;
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	chip = gpio_to_chip(gpio);
+	if (gpio >= ARCH_NR_GPIOS)
+		goto fail;
+	chip = desc->chip;
 	if (!chip || !chip->set || !chip->direction_output)
 		goto fail;
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(chip, gpio);
+	gpio_ensure_requested(desc);
 
 	/* now we know the gpio is valid and chip won't vanish */
 
@@ -270,7 +303,7 @@ int gpio_direction_output(unsigned gpio,
 
 	status = chip->direction_output(chip, gpio, value);
 	if (status == 0)
-		set_bit(gpio, chip->is_out);
+		set_bit(FLAG_IS_OUT, &desc->flags);
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -366,20 +399,18 @@ EXPORT_SYMBOL_GPL(gpio_set_value_canslee
 
 static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
-	unsigned	i;
-
-	for (i = 0; i < chip->ngpio; i++) {
-		unsigned	gpio;
-		int		is_out;
+	unsigned		i;
+	unsigned		gpio = chip->base;
+	struct gpio_desc	*gdesc = &gpio_desc[gpio];
+	int			is_out;
 
-		if (!chip->requested[i])
+	for (i = 0; i < chip->ngpio; i++, gpio++, gdesc++) {
+		if (!test_bit(FLAG_REQUESTED, &gdesc->flags))
 			continue;
 
-		gpio = chip->base + i;
-		is_out = test_bit(i, chip->is_out);
-
+		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
 		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
-			gpio, chip->requested[i],
+			gpio, gdesc->label,
 			is_out ? "out" : "in ",
 			chip->get
 				? (chip->get(chip, i) ? "hi" : "lo")
@@ -435,14 +466,16 @@ static void gpiolib_dbg_show(struct seq_
 
 static int gpiolib_show(struct seq_file *s, void *unused)
 {
-	struct gpio_chip	*chip;
-	unsigned		id;
+	struct gpio_chip	*chip = NULL;
+	unsigned		gpio;
 	int			started = 0;
 
 	/* REVISIT this isn't locked against gpio_chip removal ... */
 
-	for (id = 0; id < ARRAY_SIZE(chips); id++) {
-		chip = chips[id];
+	for (gpio = 0; gpio < ARCH_NR_GPIOS; gpio++) {
+		if (chip == gpio_desc[gpio].chip)
+			continue;
+		chip = gpio_desc[gpio].chip;
 		if (!chip)
 			continue;
 
