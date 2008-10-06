Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbYJFE5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbYJFE5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 00:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYJFE53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 00:57:29 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:36907 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751626AbYJFE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 00:57:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Vr8LeFcPH9Rdz+xkKnQpoUufyVZdY98EeNwxCjTmbbNJ0Tp8ZsPh1Sd9/lx5KyjXys5eJMauyOaon4wEFDg4y/QedtVAOdqMF+sXd/EvpZBZzIJePs45e6oJr3qIJ/bzt3vkrzKEY4+splc1OS4zRc3kEaD0PGyi+9CSnxPOhVg=  ;
X-YMail-OSG: hSG.mlUVM1lY5seNy32RczUgTyiwfvMF5QAoNHc9bNxYvreMoCe9Q_wxvggxk0PRT8X4pK8wR4FtWHwfc2g0vJuW4VUgMPoIz0gj10Z4HGdSEpujUtr73oKzflaXaHpVLk9xhro57YjrvO61347LYst5
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Magnus Damm" <magnus.damm@gmail.com>
Subject: Re: [patch 2.6.27-rc7] gpiolib: request/free hooks
Date: Sun, 5 Oct 2008 21:57:25 -0700
User-Agent: KMail/1.9.9
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <200809241508.11091.david-b@pacbell.net> <aec7e5c30809282048x3d9a201j12303091e9d93a49@mail.gmail.com> <200809291021.30655.david-b@pacbell.net>
In-Reply-To: <200809291021.30655.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810052157.25408.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I'll send an updated patch along soonish.

This updated version seems to behave for me; against RC8.
It resolves the locking issues I noticed, as well as the
record-keeping one you commented on.  Comments?

- Dave

==================
From: David Brownell <dbrownell@users.sourceforge.net>

Add a new internal mechanism to gpiolib to support low power
operations by letting gpio_chip instances see when their GPIOs
are in use.  When no GPIOs are active, chips may be able to 
enter lower powered runtime states by disabling clocks and/or
power domains.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/gpio.txt     |    4 +
 drivers/gpio/gpiolib.c     |   91 ++++++++++++++++++++++++++++++++++++-------
 include/asm-generic/gpio.h |    9 ++++
 3 files changed, 91 insertions(+), 13 deletions(-)

--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -240,6 +240,10 @@ signal, or (b) something wrongly believe
 needed to manage a signal that's in active use.  That is, requesting a
 GPIO can serve as a kind of lock.
 
+Some platforms may also use knowledge about what GPIOs are active for
+power management, such as by powering down unused chip sectors and, more
+easily, gating off unused clocks.
+
 These two calls are optional because not not all current Linux platforms
 offer such functionality in their GPIO support; a valid implementation
 could return success for all gpio_request() calls.  Unlike the other calls,
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -67,17 +67,28 @@ static inline void desc_set_label(struct
  * when setting direction, and otherwise illegal.  Until board setup code
  * and drivers use explicit requests everywhere (which won't happen when
  * those calls have no teeth) we can't avoid autorequesting.  This nag
- * message should motivate switching to explicit requests...
+ * message should motivate switching to explicit requests... so should
+ * the weaker cleanup after faults, compared to gpio_request().
  */
-static void gpio_ensure_requested(struct gpio_desc *desc)
+static int gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 {
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
-		pr_warning("GPIO-%d autorequested\n", (int)(desc - gpio_desc));
+		struct gpio_chip *chip = desc->chip;
+		int gpio = chip->base + offset;
+
+		if (!try_module_get(chip->owner)) {
+			pr_err("GPIO-%d: module can't be gotten \n", gpio);
+			clear_bit(FLAG_REQUESTED, &desc->flags);
+			/* lose */
+			return -EIO;
+		}
+		pr_warning("GPIO-%d autorequested\n", gpio);
 		desc_set_label(desc, "[auto]");
-		if (!try_module_get(desc->chip->owner))
-			pr_err("GPIO-%d: module can't be gotten \n",
-					(int)(desc - gpio_desc));
+		/* caller must chip->request() w/o spinlock */
+		if (chip->request)
+			return 1;
 	}
+	return 0;
 }
 
 /* caller holds gpio_lock *OR* gpio is marked as requested */
@@ -752,6 +763,7 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
 int gpio_request(unsigned gpio, const char *label)
 {
 	struct gpio_desc	*desc;
+	struct gpio_chip	*chip;
 	int			status = -EINVAL;
 	unsigned long		flags;
 
@@ -760,14 +772,15 @@ int gpio_request(unsigned gpio, const ch
 	if (!gpio_is_valid(gpio))
 		goto done;
 	desc = &gpio_desc[gpio];
-	if (desc->chip == NULL)
+	chip = desc->chip;
+	if (chip == NULL)
 		goto done;
 
-	if (!try_module_get(desc->chip->owner))
+	if (!try_module_get(chip->owner))
 		goto done;
 
 	/* NOTE:  gpio_request() can be called in early boot,
-	 * before IRQs are enabled.
+	 * before IRQs are enabled, for non-sleeping (SOC) GPIOs.
 	 */
 
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
@@ -775,7 +788,20 @@ int gpio_request(unsigned gpio, const ch
 		status = 0;
 	} else {
 		status = -EBUSY;
-		module_put(desc->chip->owner);
+		module_put(chip->owner);
+	}
+
+	if (chip->request) {
+		/* chip->request may sleep */
+		spin_unlock_irqrestore(&gpio_lock, flags);
+		status = chip->request(chip, gpio - chip->base);
+		spin_lock_irqsave(&gpio_lock, flags);
+
+		if (status < 0) {
+			desc_set_label(desc, NULL);
+			module_put(chip->owner);
+			clear_bit(FLAG_REQUESTED, &desc->flags);
+		}
 	}
 
 done:
@@ -791,6 +817,7 @@ void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
 	struct gpio_desc	*desc;
+	struct gpio_chip	*chip;
 
 	if (!gpio_is_valid(gpio)) {
 		WARN_ON(extra_checks);
@@ -802,9 +829,17 @@ void gpio_free(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
-	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
+	chip = desc->chip;
+	if (chip && test_bit(FLAG_REQUESTED, &desc->flags)) {
+		if (chip->free) {
+			spin_unlock_irqrestore(&gpio_lock, flags);
+			might_sleep_if(extra_checks && chip->can_sleep);
+			chip->free(chip, gpio - chip->base);
+			spin_lock_irqsave(&gpio_lock, flags);
+		}
 		desc_set_label(desc, NULL);
 		module_put(desc->chip->owner);
+		clear_bit(FLAG_REQUESTED, &desc->flags);
 	} else
 		WARN_ON(extra_checks);
 
@@ -869,7 +904,9 @@ int gpio_direction_input(unsigned gpio)
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(desc);
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
 
 	/* now we know the gpio is valid and chip won't vanish */
 
@@ -877,9 +914,22 @@ int gpio_direction_input(unsigned gpio)
 
 	might_sleep_if(extra_checks && chip->can_sleep);
 
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			goto lose;
+		}
+	}
+
 	status = chip->direction_input(chip, gpio);
 	if (status == 0)
 		clear_bit(FLAG_IS_OUT, &desc->flags);
+lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -907,7 +957,9 @@ int gpio_direction_output(unsigned gpio,
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(desc);
+	status = gpio_ensure_requested(desc, gpio);
+	if (status < 0)
+		goto fail;
 
 	/* now we know the gpio is valid and chip won't vanish */
 
@@ -915,9 +967,22 @@ int gpio_direction_output(unsigned gpio,
 
 	might_sleep_if(extra_checks && chip->can_sleep);
 
+	if (status) {
+		status = chip->request(chip, gpio);
+		if (status < 0) {
+			pr_debug("GPIO-%d: chip request fail, %d\n",
+				chip->base + gpio, status);
+			/* and it's not available to anyone else ...
+			 * gpio_request() is the fully clean solution.
+			 */
+			goto lose;
+		}
+	}
+
 	status = chip->direction_output(chip, gpio, value);
 	if (status == 0)
 		set_bit(FLAG_IS_OUT, &desc->flags);
+lose:
 	return status;
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -35,6 +35,10 @@ struct module;
  * @label: for diagnostics
  * @dev: optional device providing the GPIOs
  * @owner: helps prevent removal of modules exporting active GPIOs
+ * @request: optional hook for chip-specific activation, such as
+ *	enabling module power and clock; may sleep
+ * @free: optional hook for chip-specific deactivation, such as
+ *	disabling module power and clock; may sleep
  * @direction_input: configures signal "offset" as input, or returns error
  * @get: returns value for signal "offset"; for output signals this
  *	returns either the value actually sensed, or zero
@@ -67,6 +71,11 @@ struct gpio_chip {
 	struct device		*dev;
 	struct module		*owner;
 
+	int			(*request)(struct gpio_chip *chip,
+						unsigned offset);
+	void			(*free)(struct gpio_chip *chip,
+						unsigned offset);
+
 	int			(*direction_input)(struct gpio_chip *chip,
 						unsigned offset);
 	int			(*get)(struct gpio_chip *chip,

