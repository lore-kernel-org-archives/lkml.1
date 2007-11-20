Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbXKTSrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbXKTSrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbXKTSrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:47:10 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:31765 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753710AbXKTSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:47:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=DvHMwYGDd0SiZ+ftAcm/xAJlColW9d0blG/VJS1Aqyum97I0X5NG4sb83BkN0a6yUlsIOefwmHo5+bkrZ7l3UmgZLn7Gw6rWSsNm0nDkII3lDWVTLmHaKPuGzVQXHZfaW6RxOyOdNG0edhA5hUP2bUpw5AADKuDbafkSmkBA8+s=  ;
X-YMail-OSG: kzEI7WoVM1lHPF.8b0b7CvY7sk3mpRBsOuoZCBRXYi5YgQmfPEqpq2Dbi45B20Ftba231Rd33w--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.24-rc mmotm] gpiolib locking simplified
Date: Tue, 20 Nov 2007 10:31:49 -0800
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201031.50131.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the hot-path (gpio value get/set) locking by taking advantage
of the fact that gpio_request() effectively locks that GPIO in memory.
This also helps avoid the belated complaints about whether this locking
is one of the places raw spinlocks are OK to use; it's now back to
using regular spinlocks.

Also update docs to clarify some issues that came up.  We'd like to
eventually have direction-setting stop implicitly requesting GPIOs,
so discourage that usage.  Also document the "locking" implication of
gpio_request().

This is a code shrink relative to the previous code, most of it by
removing explicit locking calls from those hot paths.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/gpio.txt |   14 ++++-
 lib/gpiolib.c          |  116 +++++++++++++------------------------------------
 2 files changed, 42 insertions(+), 88 deletions(-)

--- a/Documentation/gpio.txt	2007-11-20 10:23:49.000000000 -0800
+++ b/Documentation/gpio.txt	2007-11-20 10:23:51.000000000 -0800
@@ -123,6 +123,10 @@ before tasking is enabled, as part of ea
 For output GPIOs, the value provided becomes the initial output value.
 This helps avoid signal glitching during system startup.
 
+For compatibility with legacy interfaces to GPIOs, setting the direction
+of a GPIO implicitly requests that GPIO (see below).  That compatibility
+may be removed in the future; explicitly requesting GPIOs is preferred.
+
 Setting the direction can fail if the GPIO number is invalid, or when
 that particular GPIO can't be used in that mode.  It's generally a bad
 idea to rely on boot firmware to have set the direction correctly, since
@@ -173,7 +177,8 @@ get to the head of a queue to transmit a
 This requires sleeping, which can't be done from inside IRQ handlers.
 
 Platforms that support this type of GPIO distinguish them from other GPIOs
-by returning nonzero from this call:
+by returning nonzero from this call (which requires a valid GPIO number,
+either explicitly or implicitly requested):
 
 	int gpio_cansleep(unsigned gpio);
 
@@ -212,8 +217,11 @@ before tasking is enabled, as part of ea
 These calls serve two basic purposes.  One is marking the signals which
 are actually in use as GPIOs, for better diagnostics; systems may have
 several hundred potential GPIOs, but often only a dozen are used on any
-given board.  Another is to catch conflicts between drivers, reporting
-errors when drivers wrongly think they have exclusive use of that signal.
+given board.  Another is to catch conflicts, identifying errors when
+(a) two or more drivers wrongly think they have exclusive use of that
+signal, or (b) something wrongly believes it's safe to remove drivers
+needed to manage a signal that's in active use.  That is, requesting a
+GPIO can serve as a kind of lock.
 
 These two calls are optional because not not all current Linux platforms
 offer such functionality in their GPIO support; a valid implementation
--- a/lib/gpiolib.c	2007-11-20 10:23:49.000000000 -0800
+++ b/lib/gpiolib.c	2007-11-20 10:23:51.000000000 -0800
@@ -29,11 +29,10 @@
 #endif
 
 /* gpio_lock protects the table of chips and gpio_chip->requested.
- * While any gpio is requested, its gpio_chip is not removable.  It's
- * a raw spinlock to ensure safe access from hardirq contexts, and to
- * shrink bitbang overhead:  per-bit preemption would be very wrong.
+ * While any GPIO is requested, its gpio_chip is not removable;
+ * each GPIO's "requested" flag serves as a lock and refcount.
  */
-static raw_spinlock_t gpio_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(gpio_lock);
 static struct gpio_chip *chips[DIV_ROUND_UP(ARCH_NR_GPIOS,
 					ARCH_GPIOS_PER_CHIP)];
 
@@ -58,7 +57,7 @@ static void gpio_ensure_requested(struct
 				chip->base + offset);
 }
 
-/* caller holds gpio_lock */
+/* caller holds gpio_lock *OR* gpio is marked as requested */
 static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
 	return chips[gpio / ARCH_GPIOS_PER_CHIP];
@@ -86,8 +85,7 @@ int gpiochip_add(struct gpio_chip *chip)
 	if (chip->ngpio > ARCH_GPIOS_PER_CHIP)
 		return -EINVAL;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
+	spin_lock_irqsave(&gpio_lock, flags);
 
 	id = chip->base / ARCH_GPIOS_PER_CHIP;
 	if (chips[id] == NULL)
@@ -95,8 +93,7 @@ int gpiochip_add(struct gpio_chip *chip)
 	else
 		status = -EBUSY;
 
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);
@@ -114,8 +111,7 @@ int gpiochip_remove(struct gpio_chip *ch
 	int		offset;
 	unsigned	id = chip->base / ARCH_GPIOS_PER_CHIP;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
+	spin_lock_irqsave(&gpio_lock, flags);
 
 	for (offset = 0; offset < chip->ngpio; offset++) {
 		if (gpiochip_is_requested(chip, offset)) {
@@ -131,8 +127,7 @@ int gpiochip_remove(struct gpio_chip *ch
 			status = -EINVAL;
 	}
 
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
@@ -148,8 +143,7 @@ int gpio_request(unsigned gpio, const ch
 	int			status = -EINVAL;
 	unsigned long		flags;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
+	spin_lock_irqsave(&gpio_lock, flags);
 
 	chip = gpio_to_chip(gpio);
 	if (!chip)
@@ -176,8 +170,7 @@ int gpio_request(unsigned gpio, const ch
 #endif
 
 done:
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_request);
@@ -187,8 +180,7 @@ void gpio_free(unsigned gpio)
 	unsigned long		flags;
 	struct gpio_chip	*chip;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
+	spin_lock_irqsave(&gpio_lock, flags);
 
 	chip = gpio_to_chip(gpio);
 	if (!chip)
@@ -208,8 +200,7 @@ void gpio_free(unsigned gpio)
 #endif
 	WARN_ON(extra_checks && chip == NULL);
 done:
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 }
 EXPORT_SYMBOL_GPL(gpio_free);
 
@@ -229,8 +220,7 @@ int gpio_direction_input(unsigned gpio)
 	struct gpio_chip	*chip;
 	int			status = -EINVAL;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
+	spin_lock_irqsave(&gpio_lock, flags);
 
 	chip = gpio_to_chip(gpio);
 	if (!chip || !chip->get || !chip->direction_input)
@@ -242,8 +232,7 @@ int gpio_direction_input(unsigned gpio)
 
 	/* now we know the gpio is valid and chip won't vanish */
 
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	might_sleep_if(extra_checks && chip->can_sleep);
 
@@ -252,8 +241,7 @@ int gpio_direction_input(unsigned gpio)
 		clear_bit(gpio, chip->is_out);
 	return status;
 fail:
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_input);
@@ -264,8 +252,7 @@ int gpio_direction_output(unsigned gpio,
 	struct gpio_chip	*chip;
 	int			status = -EINVAL;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
+	spin_lock_irqsave(&gpio_lock, flags);
 
 	chip = gpio_to_chip(gpio);
 	if (!chip || !chip->set || !chip->direction_output)
@@ -277,8 +264,7 @@ int gpio_direction_output(unsigned gpio,
 
 	/* now we know the gpio is valid and chip won't vanish */
 
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 
 	might_sleep_if(extra_checks && chip->can_sleep);
 
@@ -287,8 +273,7 @@ int gpio_direction_output(unsigned gpio,
 		set_bit(gpio, chip->is_out);
 	return status;
 fail:
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output);
@@ -303,22 +288,23 @@ EXPORT_SYMBOL_GPL(gpio_direction_output)
  * When "set" operations are inlinable, they involve writing that mask to
  * one register to set a low value, or a different register to set it high.
  * Otherwise locking is needed, so there may be little value to inlining.
+ *
+ *------------------------------------------------------------------------
+ *
+ * IMPORTANT!!!  The hot paths -- get/set value -- assume that callers
+ * have requested the GPIO.  That can include implicit requesting by
+ * a direction setting call.  Marking a gpio as requested locks its chip
+ * in memory, guaranteeing that these table lookups need no more locking
+ * and that gpiochip_remove() will fail.
+ *
+ * REVISIT when debugging, consider adding some instrumentation to ensure
+ * that the GPIO was actually requested.
  */
 int __gpio_get_value(unsigned gpio)
 {
-	unsigned long		flags;
 	struct gpio_chip	*chip;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
-
 	chip = gpio_to_chip(gpio);
-	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
-
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
-
 	WARN_ON(extra_checks && chip->can_sleep);
 	return chip->get(chip, gpio - chip->base);
 }
@@ -326,19 +312,9 @@ EXPORT_SYMBOL_GPL(__gpio_get_value);
 
 void __gpio_set_value(unsigned gpio, int value)
 {
-	unsigned long		flags;
 	struct gpio_chip	*chip;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
-
 	chip = gpio_to_chip(gpio);
-	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
-
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
-
 	WARN_ON(extra_checks && chip->can_sleep);
 	chip->set(chip, gpio - chip->base, value);
 }
@@ -346,18 +322,10 @@ EXPORT_SYMBOL_GPL(__gpio_set_value);
 
 int __gpio_cansleep(unsigned gpio)
 {
-	unsigned long		flags;
 	struct gpio_chip	*chip;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
-
+	/* only call this on GPIOs that are valid! */
 	chip = gpio_to_chip(gpio);
-	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
-
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
 
 	return chip->can_sleep;
 }
@@ -365,48 +333,26 @@ EXPORT_SYMBOL_GPL(__gpio_cansleep);
 
 
 
-/* There's no value in inlining GPIO calls that may sleep.
+/* There's no value in making it easy to inline GPIO calls that may sleep.
  * Common examples include ones connected to I2C or SPI chips.
  */
 
 int gpio_get_value_cansleep(unsigned gpio)
 {
-	unsigned long		flags;
 	struct gpio_chip	*chip;
 
 	might_sleep_if(extra_checks);
-
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
-
 	chip = gpio_to_chip(gpio);
-	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
-
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
-
 	return chip->get(chip, gpio - chip->base);
 }
 EXPORT_SYMBOL_GPL(gpio_get_value_cansleep);
 
 void gpio_set_value_cansleep(unsigned gpio, int value)
 {
-	unsigned long		flags;
 	struct gpio_chip	*chip;
 
 	might_sleep_if(extra_checks);
-
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
-
 	chip = gpio_to_chip(gpio);
-	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
-
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
-
 	chip->set(chip, gpio - chip->base, value);
 }
 EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
