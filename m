Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZFOJU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZFOJU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZFOJUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:20:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:57264 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbZFOJUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:20:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,221,1243839600"; 
   d="scan'208,223";a="524602091"
Date: Mon, 15 Jun 2009 17:15:02 +0800
From: Alek Du <alek.du@intel.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func
 features to GPIOLIB
Message-ID: <20090615171502.2a981bf5@dxy.sh.intel.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7a76916ccea4a376a260ea67fbc79ac4d958757f Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Fri, 8 May 2009 09:46:49 +0800
Subject: [PATCH] gpiolib: Add gpio_detect, gpio_debounce and gpio_alt_func features to GPIOLIB

Add some more functions to GPIOLIB, they are:
* gpio_detect is to set GPIO interrupt triggering method (edge, level, high,
  low, etc.)
* gpio_debounce is to set GPIO trigger HW debounce value if GPIO hw supports.
* gpio_alt_func is to set pin as alternative function or GPIO.

We will submit GPIO drivers that leverage this new interface later.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/gpio/gpiolib.c     |   33 +++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   25 ++++++++++++++++++++++++-
 include/linux/gpio.h       |   15 +++++++++++++++
 3 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..087efce 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1066,6 +1066,39 @@ void __gpio_set_value(unsigned gpio, int value)
 }
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
+void gpio_detect(unsigned gpio, enum gpio_trigger_t value)
+{
+	struct gpio_chip	*chip;
+
+	chip = gpio_to_chip(gpio);
+	WARN_ON(extra_checks && chip->can_sleep);
+	if (chip->detect)
+		chip->detect(chip, gpio - chip->base, value);
+}
+EXPORT_SYMBOL_GPL(gpio_detect);
+
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
index d6c379d..de9aaf9 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -30,6 +30,15 @@ static inline int gpio_is_valid(int number)
 struct seq_file;
 struct module;
 
+enum gpio_trigger_t {
+	DETECT_LEVEL_LOW = -2,
+	DETECT_EDGE_FALLING = -1,
+	DETECT_DISABLE = 0,
+	DETECT_EDGE_RISING = 1,
+	DETECT_LEVEL_HIGH = 2,
+	DETECT_EDGE_BOTH = 3,
+};
+
 /**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
@@ -44,6 +53,9 @@ struct module;
  *	returns either the value actually sensed, or zero
  * @direction_output: configures signal "offset" as output, or returns error
  * @set: assigns output value for signal "offset"
+ * @detect: configures signal interrupt detection method, see gpio_trigger_t
+ * @debounce: configures signal interrupt detection debounce
+ * @alt_func: configure signal as GPIO or alternative function
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
  *	implementation may not sleep
  * @dbg_show: optional routine to show contents in debugfs; default code
@@ -89,6 +101,15 @@ struct gpio_chip {
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
 
+	void			(*detect)(struct gpio_chip *chip,
+						unsigned offset,
+						enum gpio_trigger_t value);
+	void			(*debounce)(struct gpio_chip *chip,
+						unsigned offset,
+						int value);
+	void			(*alt_func)(struct gpio_chip *chip,
+						unsigned offset, int value);
+
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
 
@@ -118,7 +139,9 @@ extern void gpio_free(unsigned gpio);
 
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
-
+extern void gpio_detect(unsigned gpio, enum gpio_trigger_t value);
+extern void gpio_debounce(unsigned gpio, int value);
+extern void gpio_alt_func(unsigned gpio, int value);
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index e10c49a..76dd5f9 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -82,6 +82,21 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
 	WARN_ON(1);
 }
 
+static inline void gpio_detect(unsigned gpio, int value)
+{
+	WARN_ON(1);
+}
+
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
