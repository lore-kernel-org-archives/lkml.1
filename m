Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbXKOIUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbXKOIUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbXKOIUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:20:37 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:38054 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755706AbXKOIUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:20:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ah2nc8eAg1ONAFaPA1xPLjbDGChk8/kE/6Rmob/Lv+3pJiLjr54WYY/Ut0cZvJLGjrIkvLB5c0xx+jALbjcjibNL3hYoi+5HlIN1XbYvgZMssnbUED6bHoQp3+x4qI4UoXxHTJNCiM+I2LWgkpy7GeFy04qpvwRzraPXVKMnOdc=  ;
X-YMail-OSG: lfki_ssVM1m2fQXljX1uR50vG2yZb4BFkIJsYvkUAmxmeYkI62EkzU7VIWoqAAjanfRztA0sdg--
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Thu, 15 Nov 2007 00:20:33 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
References: <200711091136.20051.david-b@pacbell.net> <200711142302.02498.david-b@pacbell.net> <alpine.LFD.0.9999.0711150824480.3265@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711150824480.3265@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711150020.33887.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007, Thomas Gleixner wrote:
> On Wed, 14 Nov 2007, David Brownell wrote:
> > > The protection of the chip list can be converted to a mutex and
> > > does not need to be a spinlock at all.
> > 
> > No, we still need to use a spinlock to protect table changes.
> > The reason for that is briefly:
> > 
> >   - gpio_request()/gpio_free() have so far been optional.  Most
> >     platforms implement them as NOPs, not all drivers use them.
> >     (Having gpiolib in place should help change that ...)
> 
> By magically doing the request of the pin ? See below.
> 
> >   - gpio_direction_input()/gpio_direction_output() implicitly
> >     request the pins, if they weren't already requested.
> 
> Eek, that's completely wrong. Allowing to access a resource _before_
> it is assigned and then doing the assignment implicit is a really bad
> idea.

This is an artifact of making the GPIO interface easy to adopt,
by letting all the initial adopters wrap "legacy" SOC-specific
GPIO interfaces instead of creating a bunch of new platform code.

Only one of those legacy interfaces actually had a request/free
model.  (That was OMAP, which really needed it at one point to
help sort out driver conflicts ... current drivers don't seem
to trip over such conflicts, they've been fixed.)

You'll observe that a GPIO interface providing a standardized
interface to the capabilities of SOC registers doesn't *need*
to add a per-GPIO "is it allocated" flag ... most didn't.


However, now that we actually *have* such an interface, the
merit of such flags is becoming more apparent.  (As one person
observed:  "Eek"!)  And now gpiolib makes the costt to implement
that mechanism a lot lower.


> >   - Those input/output direction-setting calls may be called
> >     in IRQ contexts, which means (on non-RT kernels) no mutex.
> 
> There is no reason to do that if you actually have a useful reference
> to the chip _before_ accessing the pin.

See above ... until all platforms change and implement the
gpio_request() as more than a NOP, we *do* have a reason.

Fortunately drivers are tending to do the right thing (making
that call), but when they don't there are no warnings/errors.


> > So we're actually in good shape; just take out a bit of code
> > (or turn it into debugging instrumentation) and I don't think
> > anyone will complain about the locking any more.
> 
> This still does not solve the lookup, which is done for each operation
> on a pin (direction setting, read, write).

Are you saying that an array index is a cost to worry about here??

FYI, see the appended patch ... it's been sanity tested.

- Dave


=============
Simplify the hot-path (gpio value get/set) locking by taking advantage
of the fact that gpio_request() effectively locks that GPIO in memory.
This helps us avoid the belated complaints about whether this locking
was one of the places raw spinlocks are OK to use.

This is a net code shrink, most of it by removing explicit locking
calls from those hot paths.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/gpio.txt |    3 -
 lib/gpiolib.c          |  118 ++++++++++++++-----------------------------------
 2 files changed, 36 insertions(+), 85 deletions(-)

--- a/Documentation/gpio.txt	2007-11-14 21:36:34.000000000 -0800
+++ b/Documentation/gpio.txt	2007-11-15 00:04:56.000000000 -0800
@@ -173,7 +173,8 @@ get to the head of a queue to transmit a
 This requires sleeping, which can't be done from inside IRQ handlers.
 
 Platforms that support this type of GPIO distinguish them from other GPIOs
-by returning nonzero from this call:
+by returning nonzero from this call (which may be issued even for GPIOs
+that have not been requested):
 
 	int gpio_cansleep(unsigned gpio);
 
--- a/lib/gpiolib.c	2007-11-15 00:04:50.000000000 -0800
+++ b/lib/gpiolib.c	2007-11-15 00:04:56.000000000 -0800
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
@@ -303,22 +288,22 @@ EXPORT_SYMBOL_GPL(gpio_direction_output)
  * When "set" operations are inlinable, they involve writing that mask to
  * one register to set a low value, or a different register to set it high.
  * Otherwise locking is needed, so there may be little value to inlining.
+ *
+ *------------------------------------------------------------------------
+ *
+ * IMPORTANT!!!  These hot paths -- get/set value -- assume that callers
+ * have correctly requested the GPIO.  That can include implicit requesting
+ * through direction setting.  Marking a gpio as requested locks its chip
+ * in memory, guaranteeing that these table lookups need no more locking.
+ *
+ * REVISIT when debugging, cosider adding some instrumentation to ensure
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
@@ -326,19 +311,9 @@ EXPORT_SYMBOL_GPL(__gpio_get_value);
 
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
@@ -348,65 +323,40 @@ int __gpio_cansleep(unsigned gpio)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
+	int			retval;
 
-	local_irq_save(flags);
-	__raw_spin_lock(&gpio_lock);
-
+	/* it's OK to call this on a GPIO you've not requested */
+	spin_lock_irqsave(&gpio_lock, flags);
 	chip = gpio_to_chip(gpio);
-	if (extra_checks)
-		gpio_ensure_requested(chip, gpio - chip->base);
-
-	__raw_spin_unlock(&gpio_lock);
-	local_irq_restore(flags);
+	retval = chip->can_sleep;
+	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	return chip->can_sleep;
+	return retval;
 }
 EXPORT_SYMBOL_GPL(__gpio_cansleep);
 
 
 
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
