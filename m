Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbZGaRpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbZGaRpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 13:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZGaRpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 13:45:40 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:29731 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752451AbZGaRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 13:45:40 -0400
X-Greylist: delayed 1105 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2009 13:45:40 EDT
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpiolib: introduce for_each_gpio_in_chip macro
Date: Fri, 31 Jul 2009 10:27:06 -0700
Cc: David Brownell <dbrownell@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311027.06370.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gpiolib: introduce for_each_gpio_in_chip macro

There are a number of places in gpiolib where all the gpio's handled by a
chip are walked thru using a for() loop.  This introduces a for_each_*
macro to clarify the code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..b060f73 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -56,6 +56,11 @@ struct gpio_desc {
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
+#define for_each_gpio_in_chip(__gpio, __chip)			\
+	for ((__gpio) = (__chip)->base;				\
+		(__gpio) < (__chip)->base + (__chip)->ngpio;	\
+		(__gpio)++)
+
 static inline void desc_set_label(struct gpio_desc *d, const char *label)
 {
 #ifdef CONFIG_DEBUG_FS
@@ -694,14 +699,14 @@ int gpiochip_add(struct gpio_chip *chip)
 	}
 
 	/* these GPIO numbers must not be managed by another gpio_chip */
-	for (id = base; id < base + chip->ngpio; id++) {
+	for_each_gpio_in_chip(id, chip) {
 		if (gpio_desc[id].chip != NULL) {
 			status = -EBUSY;
 			break;
 		}
 	}
 	if (status == 0) {
-		for (id = base; id < base + chip->ngpio; id++) {
+		for_each_gpio_in_chip(id, chip) {
 			gpio_desc[id].chip = chip;
 
 			/* REVISIT:  most hardware initializes GPIOs as
@@ -744,14 +749,14 @@ int gpiochip_remove(struct gpio_chip *chip)
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
-	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
+	for_each_gpio_in_chip(id, chip) {
 		if (test_bit(FLAG_REQUESTED, &gpio_desc[id].flags)) {
 			status = -EBUSY;
 			break;
 		}
 	}
 	if (status == 0) {
-		for (id = chip->base; id < chip->base + chip->ngpio; id++)
+		for_each_gpio_in_chip(id, chip)
 			gpio_desc[id].chip = NULL;
 	}
 
