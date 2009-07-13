Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZGMPTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZGMPTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZGMPTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:19:44 -0400
Received: from ru.mvista.com ([213.79.90.228]:62974 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756133AbZGMPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:19:43 -0400
Date: Mon, 13 Jul 2009 19:19:42 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] gpiolib: Implement gpio_set_values_sync()
Message-ID: <20090713151942.GA4486@oksana.dev.rtsoft.ru>
References: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090713151911.GA28114@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it's necessary to set GPIO values synchronously, e.g.
when CPU's GPIOs go to a FPGA and the FPGA has no latch-enable line,
so intermediate values on GPIO lines may trigger unnecessary actions
by the FPGA.

Another usage is chip-select muxes, e.g. using X GPIOs as address lines
to mux 2^X chip-selects, and setting some amount of GPIOs at once may
be a huge win.

Note that it's not always possible to set up GPIOs synchronously, so
gpio_can_set_values_sync() call is implemented. Currently it checks
for two things:

1. Whether gpio_chip has .set_sync() callback;
2. Whether all passed GPIOs belong to one particular gpio_chip.

Someday we may want to implement chip-specific .can_set_sync() check,
but currently this isn't needed.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/gpiolib.c     |   57 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    8 ++++++
 include/linux/gpio.h       |   14 ++++++++++
 3 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..cf714ad 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1067,6 +1067,53 @@ void __gpio_set_value(unsigned gpio, int value)
 EXPORT_SYMBOL_GPL(__gpio_set_value);
 
 /**
+ * __gpio_can_set_values_sync() - check if gpios can be set synchronously
+ * @num: amount of gpios
+ * @gpios: gpios in question
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_can_set_values_sync().
+ * It returns nonzero if an array of gpios can be set simultaneously.
+ */
+int __gpio_can_set_values_sync(unsigned num, unsigned *gpios)
+{
+	struct gpio_chip *chip;
+	unsigned i;
+
+	chip = gpio_to_chip(gpios[0]);
+	if (!chip->set_sync)
+		return 0;
+
+	for (i = 1; i < num; i++) {
+		if (chip != gpio_to_chip(gpios[i]))
+			return 0;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(__gpio_can_set_values_sync);
+
+/**
+ * __gpio_set_values_sync() - assign gpios' values synchronously
+ * @num: amount of gpios
+ * @gpios: gpios whose value will be assigned
+ * @values: value to assign
+ * Context: any
+ *
+ * This is used directly or indirectly to implement gpio_set_values_sync().
+ * It invokes the associated gpio_chip.set_sync() method.
+ */
+void __gpio_set_values_sync(unsigned num, unsigned *gpios, int *values)
+{
+	struct gpio_chip *chip;
+
+	chip = gpio_to_chip(gpios[0]);
+	WARN_ON(extra_checks && chip->can_sleep);
+	chip->set_sync(chip, num, gpios, values);
+}
+EXPORT_SYMBOL_GPL(__gpio_set_values_sync);
+
+/**
  * __gpio_cansleep() - report whether gpio value access will sleep
  * @gpio: gpio in question
  * Context: any
@@ -1129,6 +1176,16 @@ void gpio_set_value_cansleep(unsigned gpio, int value)
 }
 EXPORT_SYMBOL_GPL(gpio_set_value_cansleep);
 
+void gpio_set_values_sync_cansleep(unsigned num, unsigned *gpios, int *values)
+{
+	struct gpio_chip	*chip;
+
+	might_sleep_if(extra_checks);
+	chip = gpio_to_chip(gpios[0]);
+	chip->set_sync(chip, num, gpios, values);
+}
+EXPORT_SYMBOL_GPL(gpio_set_values_sync_cansleep);
+
 
 #ifdef CONFIG_DEBUG_FS
 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d6c379d..c181623 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -88,6 +88,10 @@ struct gpio_chip {
 						unsigned offset, int value);
 	void			(*set)(struct gpio_chip *chip,
 						unsigned offset, int value);
+	/* NOTE: _sync() version accepts gpios, not offsets. */
+	void			(*set_sync)(struct gpio_chip *chip,
+						unsigned num, unsigned *gpios,
+						int *values);
 
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
@@ -121,6 +125,8 @@ extern int gpio_direction_output(unsigned gpio, int value);
 
 extern int gpio_get_value_cansleep(unsigned gpio);
 extern void gpio_set_value_cansleep(unsigned gpio, int value);
+extern void gpio_set_values_sync_cansleep(unsigned num, unsigned *gpios,
+					  int *values);
 
 
 /* A platform's <asm/gpio.h> code may want to inline the I/O calls when
@@ -129,6 +135,8 @@ extern void gpio_set_value_cansleep(unsigned gpio, int value);
  */
 extern int __gpio_get_value(unsigned gpio);
 extern void __gpio_set_value(unsigned gpio, int value);
+extern int __gpio_can_set_values_sync(unsigned num, unsigned *gpios);
+extern void __gpio_set_values_sync(unsigned num, unsigned *gpios, int *values);
 
 extern int __gpio_cansleep(unsigned gpio);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index e10c49a..ff62c1e 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -62,6 +62,20 @@ static inline void gpio_set_value(unsigned gpio, int value)
 	WARN_ON(1);
 }
 
+static inline int gpio_can_set_values_sync(unsigned num, unsigned *gpios)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+	return 0;
+}
+
+static inline void gpio_set_values_sync(unsigned num, unsigned *gpios,
+					int *values)
+{
+	/* GPIO can never have been requested or set as output */
+	WARN_ON(1);
+}
+
 static inline int gpio_cansleep(unsigned gpio)
 {
 	/* GPIO can never have been requested or set as {in,out}put */
-- 
1.6.3.3

