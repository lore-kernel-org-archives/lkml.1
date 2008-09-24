Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYIXWP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYIXWP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 18:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYIXWIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 18:08:16 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:31087 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755496AbYIXWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:08:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lKmsRrzCjEENc5LaVTkfdd2K4CdFldsJOprycnDjkgp+6yZwLuPEoMOnuJW8e+1++oUzvcL70PfkjPQ1Z/5tZJsthJ3Ej7o1AR8R/Z1qcz26Qi6HDwP0r1Rd1wIptKjlqbxlaM2nZzfztMjkPsXY6PwIdLgnRsSP5ybb2coKmaI=  ;
X-YMail-OSG: kz7wF5oVM1nvnpeuaoT7u_KwoF7hidS.GC2rA2tbuE9ml1VZAk5aePP2lPrYwNtSSu.dtlEKQ_JOrafEPsRK4O3Db9Dczb4KbvS_S2ciZjV5F4Kir5m6YNxQaTEDbecYNT9MBC161c5w7vsC9Wj8t1Io
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.27-rc7] gpiolib: request/free hooks
Date: Wed, 24 Sep 2008 15:08:10 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241508.11091.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add a new internal mechanism to gpiolib to support low power
operations by letting gpio_chip instances see when their GPIOs
are in use.  When no GPIOs are active, chips may be able to 
enter lower powered runtime states by disabling clocks and/or
power domains.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/gpio.txt     |    4 ++++
 drivers/gpio/gpiolib.c     |   42 ++++++++++++++++++++++++++++++------------
 include/asm-generic/gpio.h |    9 +++++++++
 3 files changed, 43 insertions(+), 12 deletions(-)

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
@@ -69,14 +69,18 @@ static inline void desc_set_label(struct
  * those calls have no teeth) we can't avoid autorequesting.  This nag
  * message should motivate switching to explicit requests...
  */
-static void gpio_ensure_requested(struct gpio_desc *desc)
+static void gpio_ensure_requested(struct gpio_desc *desc, unsigned offset)
 {
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
-		pr_warning("GPIO-%d autorequested\n", (int)(desc - gpio_desc));
+		struct gpio_chip *chip = desc->chip;
+		int gpio = chip->base + offset;
+
+		pr_warning("GPIO-%d autorequested\n", gpio);
 		desc_set_label(desc, "[auto]");
-		if (!try_module_get(desc->chip->owner))
-			pr_err("GPIO-%d: module can't be gotten \n",
-					(int)(desc - gpio_desc));
+		if (!try_module_get(chip->owner))
+			pr_err("GPIO-%d: module can't be gotten \n", gpio);
+		if (chip->request)
+			chip->request(chip, offset);
 	}
 }
 
@@ -781,6 +785,7 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
 int gpio_request(unsigned gpio, const char *label)
 {
 	struct gpio_desc	*desc;
+	struct gpio_chip	*chip;
 	int			status = -EINVAL;
 	unsigned long		flags;
 
@@ -789,22 +794,31 @@ int gpio_request(unsigned gpio, const ch
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
 
+	if (chip->request) {
+		status = chip->request(chip, gpio - chip->base);
+		if (status < 0) {
+			module_put(chip->owner);
+			goto done;
+		}
+	}
+
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
 		desc_set_label(desc, label ? : "?");
 		status = 0;
 	} else {
 		status = -EBUSY;
-		module_put(desc->chip->owner);
+		module_put(chip->owner);
 	}
 
 done:
@@ -820,6 +834,7 @@ void gpio_free(unsigned gpio)
 {
 	unsigned long		flags;
 	struct gpio_desc	*desc;
+	struct gpio_chip	*chip;
 
 	if (!gpio_is_valid(gpio)) {
 		WARN_ON(extra_checks);
@@ -831,8 +846,11 @@ void gpio_free(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
-	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
+	chip = desc->chip;
+	if (chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
 		desc_set_label(desc, NULL);
+		if (chip->free)
+			chip->free(chip, gpio - chip->base);
 		module_put(desc->chip->owner);
 	} else
 		WARN_ON(extra_checks);
@@ -898,7 +916,7 @@ int gpio_direction_input(unsigned gpio)
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(desc);
+	gpio_ensure_requested(desc, gpio);
 
 	/* now we know the gpio is valid and chip won't vanish */
 
@@ -936,7 +954,7 @@ int gpio_direction_output(unsigned gpio,
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
 		goto fail;
-	gpio_ensure_requested(desc);
+	gpio_ensure_requested(desc, gpio);
 
 	/* now we know the gpio is valid and chip won't vanish */
 
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
