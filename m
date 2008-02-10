Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbYBJTMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbYBJTMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYBJTL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:11:56 -0500
Received: from mail.gmx.net ([213.165.64.20]:49742 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752551AbYBJTLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:11:55 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+1yAo8t1i1aOiZFQoQpvhf7ZP3tYarcxBrRwUAwC
	sjA1TTqvlq/xAD
Date: Sun, 10 Feb 2008 20:12:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] introduce is_valid_gpio() predicate and use it in gpiolib.c
Message-ID: <Pine.LNX.4.64.0802102002270.4417@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a is_valid_gpio() predicate to be used in gpiolib core and 
drivers.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d8db2f8..5390f46 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -96,7 +96,7 @@ int gpiochip_add(struct gpio_chip *chip)
 	 * dynamic allocation.  We don't currently support that.
 	 */
 
-	if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS) {
+	if (chip->base < 0 || !is_valid_gpio(chip->base  + chip->ngpio)) {
 		status = -EINVAL;
 		goto fail;
 	}
@@ -171,7 +171,7 @@ int gpio_request(unsigned gpio, const char *label)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!is_valid_gpio(gpio))
 		goto done;
 	desc = &gpio_desc[gpio];
 	if (desc->chip == NULL)
@@ -201,7 +201,7 @@ void gpio_free(unsigned gpio)
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 
-	if (gpio >= ARCH_NR_GPIOS) {
+	if (!is_valid_gpio(gpio)) {
 		WARN_ON(extra_checks);
 		return;
 	}
@@ -236,7 +236,7 @@ const char *gpiochip_is_requested(struct gpio_chip *chip, unsigned offset)
 {
 	unsigned gpio = chip->base + offset;
 
-	if (gpio >= ARCH_NR_GPIOS || gpio_desc[gpio].chip != chip)
+	if (!is_valid_gpio(gpio) || gpio_desc[gpio].chip != chip)
 		return NULL;
 	if (test_bit(FLAG_REQUESTED, &gpio_desc[gpio].flags) == 0)
 		return NULL;
@@ -267,7 +267,7 @@ int gpio_direction_input(unsigned gpio)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!is_valid_gpio(gpio))
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->get || !chip->direction_input)
@@ -305,7 +305,7 @@ int gpio_direction_output(unsigned gpio, int value)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!is_valid_gpio(gpio))
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->direction_output)
@@ -522,7 +522,7 @@ static int gpiolib_show(struct seq_file *s, void *unused)
 
 	/* REVISIT this isn't locked against gpio_chip removal ... */
 
-	for (gpio = 0; gpio < ARCH_NR_GPIOS; gpio++) {
+	for (gpio = 0; is_valid_gpio(gpio); gpio++) {
 		if (chip == gpio_desc[gpio].chip)
 			continue;
 		chip = gpio_desc[gpio].chip;
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index f29a502..87dab12 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -16,6 +16,8 @@
 #define ARCH_NR_GPIOS		256
 #endif
 
+#define is_valid_gpio(gpio)	((unsigned int)(gpio) < ARCH_NR_GPIOS)
+
 struct seq_file;
 
 /**
