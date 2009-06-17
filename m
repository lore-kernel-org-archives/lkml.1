Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZFQHGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZFQHGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZFQHF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:05:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:29142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbZFQHF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:05:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,234,1243839600"; 
   d="scan'208";a="422953527"
Date: Wed, 17 Jun 2009 14:59:55 +0800
From: Alek Du <alek.du@intel.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ben Dooks <ben-linux@fluff.org>, Florian Fainelli <florian@openwrt.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH v2] gpiolib: Add gpio_debounce and gpio_alt_func features to
 GPIOLIB
Message-ID: <20090617145955.355ef2a9@dxy.sh.intel.com>
In-Reply-To: <20090616083948.GB14476@trinity.fluff.org>
References: <20090615171502.2a981bf5@dxy.sh.intel.com>
	<20090615125146.GC19873@fluff.org.uk>
	<200906151504.51934.florian@openwrt.org>
	<20090615130906.GA14476@trinity.fluff.org>
	<20090616092848.7bb60f21@dxy.sh.intel.com>
	<20090616083948.GB14476@trinity.fluff.org>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:

Removed gpio_detect since we should do that with irq_chip.set_type function.


>From 6b3c9398acf338c263170fcb74c0b2b345ad5369 Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Wed, 17 Jun 2009 14:50:51 +0800
Subject: [PATCH] GPIO: Add gpio_debounce and gpio_alt_func features to GPIOLIB

Add gpio_debounce and gpio_alt_func features to GPIOLIB:
* gpio_debounce is to adjust signal HW debounce value (need HW support)
* gpio_alt_func is to set GPIO as alternative function (need HW support)

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/gpio/gpiolib.c     |   22 ++++++++++++++++++++++
 include/asm-generic/gpio.h |   11 ++++++++++-
 include/linux/gpio.h       |   10 ++++++++++
 3 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..6365038 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1066,6 +1066,28 @@ void __gpio_set_value(unsigned gpio, int value)
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
+void gpio_debounce(unsigned gpio, int value)
+{
+	struct gpio_chip	*chip;
+
+	chip = gpio_to_chip(gpio);
+	WARN_ON(extra_checks && chip->can_sleep);
+	if (chip->debounce)
+		chip->debounce(chip, gpio - chip->base, value);
+}
+EXPORT_SYMBOL_GPL(gpio_debounce);
+
+void gpio_alt_func(unsigned gpio, int value)
+{
+	struct gpio_chip	*chip;
+
+	chip = gpio_to_chip(gpio);
+	WARN_ON(extra_checks && chip->can_sleep);
+	if (chip->alt_func)
+		chip->alt_func(chip, gpio - chip->base, value);
+}
+EXPORT_SYMBOL_GPL(gpio_alt_func);
+
 /**
  * __gpio_cansleep() - report whether gpio value access will sleep
  * @gpio: gpio in question
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d6c379d..bc98c96 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -44,6 +44,8 @@ struct module;
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
+ * @debounce: Adjust signal hardware debounce level
+ * @alt_func: configures signal as GPIO or alternative function
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
  *	implementation may not sleep
  * @dbg_show: optional routine to show contents in debugfs; default code
@@ -89,6 +91,12 @@ struct gpio_chip {
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
 
+	void			(*debounce)(struct gpio_chip *chip,
+						unsigned offset,
+						int value);
+	void			(*alt_func)(struct gpio_chip *chip,
+						unsigned offset, int value);
+
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
 
@@ -118,7 +126,8 @@ extern void gpio_free(unsigned gpio);
 
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
-
+extern void gpio_debounce(unsigned gpio, int value);
+extern void gpio_alt_func(unsigned gpio, int value);
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index e10c49a..cf005d5 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -82,6 +82,16 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 	WARN_ON(1);
 }
 
+static inline void gpio_debounce(unsigned gpio, int value)
+{
+	WARN_ON(1);
+}
+
+static inline void gpio_alt_func(unsigned gpio, int value)
+{
+	WARN_ON(1);
+}
+
 static inline int gpio_export(unsigned gpio, bool direction_may_change)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
-- 
1.6.0.4
