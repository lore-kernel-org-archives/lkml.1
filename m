Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186Ab0AHGcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0AHGcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 01:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384Ab0AHGce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 01:32:34 -0500
Received: from trinity.fluff.org ([89.16.178.74]:53919 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab0AHGcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 01:32:33 -0500
From: Ben Dooks <ben-linux@fluff.org>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: add gpio_lookup_chip() to get chip information for gpio
Date: Fri,  8 Jan 2010 06:32:28 +0000
Message-Id: <1262932348-2888-2-git-send-email-ben-linux@fluff.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1262932348-2888-1-git-send-email-ben-linux@fluff.org>
References: <1262932348-2888-1-git-send-email-ben-linux@fluff.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a call to get the 'struct gpio_chip' pointer for a given gpio, so
that core implementations which want to use gpiolib gpio numbering for
things like mux configuration can get back to the gpio_chip that they
registered without having to have their own list of gpio.

This is especially useful for the Samsung S3C64XX series where the GPIO
bank sizes can vary from 32 down to 3, making it difficult to store an
array to convert a number to chip.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
---
 drivers/gpio/gpiolib.c     |   26 ++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    2 ++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a25ad28..d748600 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -120,6 +120,32 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 	return gpio_desc[gpio].chip;
 }
 
+/**
+ * gpio_lookup_chip - return the chip for a given gpio
+ * @gpio: The GPIO number to lookup
+ *
+ * Returns NULL if the GPIO chip is not valid or there is no chip registered
+ * for that GPIO. This call is available for core code to turn a GPIO number
+ * into a chip so that further information can be looked up.
+ *
+ * This call makes no guarantees about the actuall gpio_chip's state, or
+ * whether the @gpio itself is requested.
+ */
+struct gpio_chip *gpio_lookup_chip(unsigned gpio)
+{
+	struct gpio_chip *chip;
+	unsigned long flags;
+
+	if (!gpio_is_valid(gpio))
+		return NULL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	chip = gpio_to_chip(gpio);
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return chip;
+}
+
 /* dynamic allocation of GPIOs, e.g. on a hotplugged device */
 static int gpiochip_find_base(int ngpio)
 {
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 485eeb6..34b3276 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -103,6 +103,8 @@ struct gpio_chip {
 	unsigned		exported:1;
 };
 
+extern struct gpio_chip *gpio_lookup_chip(unsigned gpio);
+
 extern const char *gpiochip_is_requested(struct gpio_chip *chip,
 			unsigned offset);
 extern int __must_check gpiochip_reserve(int start, int ngpio);
-- 
1.6.0.4

