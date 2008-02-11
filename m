Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYBKAXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYBKAXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbYBKAXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:23:09 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:43072 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756816AbYBKAXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:23:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=jSuZYCWMgkD6ONbE1+8JIC6qtJl7f/6q/WdKKeejMBzIKHu4KHoSEUnYI4p3pmBMxs31hSRrjWou6Aw+rrDo1pAWlNy6xGL3GSLOvG2mySg4EDiPpW8IXdFnAWkpbUizHSEI+wYSRzfANbnYnytRkm0XC8+aDAJW5ukNdJI0AuE=  ;
X-YMail-OSG: 2bKn254VM1kAKnUu6dIvUoI5xec7tMFhHaL146GF30UYSCzMH1k62u.v4Ovu6wSUJiDTchDzXQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.25-rc1 3/3] gpio:  define gpio_is_valid()
Date: Sun, 10 Feb 2008 16:22:20 -0800
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802101622.20913.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Introduce a gpio_is_valid() predicate; use it in gpiolib.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
    [ use inline function; follow the gpio_* naming convention;
      work without gpiolib; all programming interfaces need docs ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/gpio.txt     |   10 ++++++++++
 drivers/gpio/gpiolib.c     |   14 +++++++-------
 include/asm-generic/gpio.h |   12 ++++++++++++
 3 files changed, 29 insertions(+), 7 deletions(-)

--- g26.orig/Documentation/gpio.txt	2008-02-10 16:06:30.000000000 -0800
+++ g26/Documentation/gpio.txt	2008-02-10 16:09:54.000000000 -0800
@@ -102,6 +102,16 @@ type of GPIO controller, and on one part
 The numbers need not be contiguous; either of those platforms could also
 use numbers 2000-2063 to identify GPIOs in a bank of I2C GPIO expanders.
 
+If you want to initialize a structure with an invalid GPIO number, use
+some negative number (perhaps "-EINVAL"); that will never be valid.  To
+test if a number could reference a GPIO, you may use this predicate:
+
+	int gpio_is_valid(int number);
+
+A number that's not valid will be rejected by calls which may request
+or free GPIOs (see below).  Other numbers may also be rejected; for
+example, a number might be valid but unused on a given board.
+
 Whether a platform supports multiple GPIO controllers is currently a
 platform-specific implementation issue.
 
--- g26.orig/drivers/gpio/gpiolib.c	2008-02-10 16:09:51.000000000 -0800
+++ g26/drivers/gpio/gpiolib.c	2008-02-10 16:09:54.000000000 -0800
@@ -96,7 +96,7 @@ int gpiochip_add(struct gpio_chip *chip)
 	 * dynamic allocation.  We don't currently support that.
 	 */
 
-	if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS) {
+	if (chip->base < 0 || !gpio_is_valid(chip->base  + chip->ngpio)) {
 		status = -EINVAL;
 		goto fail;
 	}
@@ -171,7 +171,7 @@ int gpio_request(unsigned gpio, const ch
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!gpio_is_valid(gpio))
 		goto done;
 	desc = &gpio_desc[gpio];
 	if (desc->chip == NULL)
@@ -206,7 +206,7 @@ void gpio_free(unsigned gpio)
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 
-	if (gpio >= ARCH_NR_GPIOS) {
+	if (!gpio_is_valid(gpio)) {
 		WARN_ON(extra_checks);
 		return;
 	}
@@ -242,7 +242,7 @@ const char *gpiochip_is_requested(struct
 {
 	unsigned gpio = chip->base + offset;
 
-	if (gpio >= ARCH_NR_GPIOS || gpio_desc[gpio].chip != chip)
+	if (!gpio_is_valid(gpio) || gpio_desc[gpio].chip != chip)
 		return NULL;
 	if (test_bit(FLAG_REQUESTED, &gpio_desc[gpio].flags) == 0)
 		return NULL;
@@ -273,7 +273,7 @@ int gpio_direction_input(unsigned gpio)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!gpio_is_valid(gpio))
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->get || !chip->direction_input)
@@ -311,7 +311,7 @@ int gpio_direction_output(unsigned gpio,
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	if (gpio >= ARCH_NR_GPIOS)
+	if (!gpio_is_valid(gpio))
 		goto fail;
 	chip = desc->chip;
 	if (!chip || !chip->set || !chip->direction_output)
@@ -528,7 +528,7 @@ static int gpiolib_show(struct seq_file 
 
 	/* REVISIT this isn't locked against gpio_chip removal ... */
 
-	for (gpio = 0; gpio < ARCH_NR_GPIOS; gpio++) {
+	for (gpio = 0; gpio_is_valid(gpio); gpio++) {
 		if (chip == gpio_desc[gpio].chip)
 			continue;
 		chip = gpio_desc[gpio].chip;
--- g26.orig/include/asm-generic/gpio.h	2008-02-10 16:09:51.000000000 -0800
+++ g26/include/asm-generic/gpio.h	2008-02-10 16:09:54.000000000 -0800
@@ -16,6 +16,12 @@
 #define ARCH_NR_GPIOS		256
 #endif
 
+static inline int gpio_is_valid(int number)
+{
+	/* only some non-negative numbers are valid */
+	return ((unsigned)number) < ARCH_NR_GPIOS;
+}
+
 struct seq_file;
 struct module;
 
@@ -99,6 +105,12 @@ extern int __gpio_cansleep(unsigned gpio
 
 #else
 
+static inline int gpio_is_valid(int number)
+{
+	/* only non-negative numbers are valid */
+	return number >= 0;
+}
+
 /* platforms that don't directly support access to GPIOs through I2C, SPI,
  * or other blocking infrastructure can use these wrappers.
  */

