Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYDZLDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYDZLDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYDZLDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:03:08 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:43898
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291AbYDZLDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:03:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoIBANSoEkh8qMj2/2dsb2JhbAAIqnE
X-IronPort-AV: E=Sophos;i="4.25,710,1199631600"; 
   d="scan'208";a="320662727"
Subject: [PATCH] Give gpiolib an implementation of gpio_is_valid()
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, bn@niasdigital.com
Content-Type: text/plain
Organization: Nias Digital
Date: Sat, 26 Apr 2008 21:03:01 +1000
Message-Id: <1209207781.3756.120.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Platforms which use generic (NOP) gpio routines get an implementation of
gpio_is_valid() (in linux/gpio.h) but the people who actually use gpio
don't get one.  Roll an implementation for gpiolib based on
gpio_request(); this ought to do for most people.

Signed-off-by: Ben Nizette <bn@niasdigital.com>
---
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d8db2f8..137688c 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -158,6 +158,34 @@ int gpiochip_remove(struct gpio_chip *chip)
 }
 EXPORT_SYMBOL_GPL(gpiochip_remove);
 
+/**
+ * gpio_is_valid() - check if a gpio number actually corresponds to a gpio
+ * @number: the gpio number to test
+ *
+ * Returns 1 if the gpio is valid, 0 otherwise.
+ */
+int gpio_is_valid(int number)
+{
+	struct gpio_desc	*desc;
+	int			ret = 0;
+	unsigned long		flags;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+
+	if (number >= ARCH_NR_GPIOS)
+		goto done;
+
+	desc = &gpio_desc[number];
+	if (desc->chip == NULL)
+		goto done;
+
+	ret = 1;
+
+done:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(gpio_is_valid);
 
 /* These "optional" allocation calls help prevent drivers from stomping
  * on each other, and help provide better diagnostics in debugfs.
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index f29a502..8c26523 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -75,6 +75,8 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
 /* Always use the library code for GPIO management calls,
  * or when sleeping may be involved.
  */
+extern int gpio_is_valid(int number);
+
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 

