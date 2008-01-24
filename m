Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYAXOeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYAXOeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 09:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYAXOdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 09:33:52 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58674 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751383AbYAXOdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:33:51 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, Andrew Victor <linux@maxim.org.za>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org, David Brownell <dbrownell@users.sourceforge.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH -mm 2/2] PWM LED driver
Date: Thu, 24 Jan 2008 15:33:45 +0100
Message-Id: <1201185225-15789-3-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201185225-15789-2-git-send-email-hskinnemoen@atmel.com>
References: <1201185225-15789-1-git-send-email-hskinnemoen@atmel.com>
 <1201185225-15789-2-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

This is a LED driver using the PWM on newer SOCs from Atmel; brightness
is controlled by changing the PWM duty cycle.  So for example if you've
set up two leds labeled "pwm0" and "pwm1":

	echo 0 > /sys/class/leds/pwm2/brightness	# off (0%)
	echo 80 > /sys/class/leds/pwm2/brightness
	echo 255 > /sys/class/leds/pwm2/brightness	# on (100%)

Note that "brightness" here isn't linear; maybe that should change.
Going from 4 to 8 probably doubles perceived brightness, while 244
to 248 is imperceptible.

This is mostly intended to be a simple example of PWM, although it's
realistic since LCD backlights are often driven with PWM to conserve
battery power (and offer brightness options).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/leds/Kconfig          |    7 ++
 drivers/leds/Makefile         |    1 +
 drivers/leds/leds-atmel-pwm.c |  157 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-atmel-pwm.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ec568fa..4e1db3b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -18,6 +18,13 @@ config LEDS_CLASS
 
 comment "LED drivers"
 
+config LEDS_ATMEL_PWM
+	tristate "LED Support using Atmel PWM outputs"
+	depends on LEDS_CLASS && ATMEL_PWM
+	help
+	  This option enables support for LEDs driven using outputs
+	  of the dedicated PWM controller found on newer Atmel SOCs.
+
 config LEDS_CORGI
 	tristate "LED Support for the Sharp SL-C7x0 series"
 	depends on LEDS_CLASS && PXA_SHARP_C7xx
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index a60de1b..04bc850 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
+obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_CORGI)		+= leds-corgi.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
 obj-$(CONFIG_LEDS_SPITZ)		+= leds-spitz.o
diff --git a/drivers/leds/leds-atmel-pwm.c b/drivers/leds/leds-atmel-pwm.c
new file mode 100644
index 0000000..af61f55
--- /dev/null
+++ b/drivers/leds/leds-atmel-pwm.c
@@ -0,0 +1,157 @@
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <linux/io.h>
+#include <linux/atmel_pwm.h>
+
+
+struct pwmled {
+	struct led_classdev	cdev;
+	struct pwm_channel	pwmc;
+	struct gpio_led		*desc;
+	u32			mult;
+	u8			active_low;
+};
+
+
+/*
+ * For simplicity, we use "brightness" as if it were a linear function
+ * of PWM duty cycle.  However, a logarithmic function of duty cycle is
+ * probably a better match for perceived brightness: two is half as bright
+ * as four, four is half as bright as eight, etc
+ */
+static void pwmled_brightness(struct led_classdev *cdev, enum led_brightness b)
+{
+	struct pwmled		 *led;
+
+	/* update the duty cycle for the *next* period */
+	led = container_of(cdev, struct pwmled, cdev);
+	pwm_channel_writel(&led->pwmc, PWM_CUPD, led->mult * (unsigned) b);
+}
+
+/*
+ * NOTE:  we reuse the platform_data structure of GPIO leds,
+ * but repurpose its "gpio" number as a PWM channel number.
+ */
+static int __init pwmled_probe(struct platform_device *pdev)
+{
+	const struct gpio_led_platform_data	*pdata;
+	struct pwmled				*leds;
+	unsigned				i;
+	int					status;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata || pdata->num_leds < 1)
+		return -ENODEV;
+
+	leds = kcalloc(pdata->num_leds, sizeof(*leds), GFP_KERNEL);
+	if (!leds)
+		return -ENOMEM;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		struct pwmled		*led = leds + i;
+		const struct gpio_led	*dat = pdata->leds + i;
+		u32			tmp;
+
+		led->cdev.name = dat->name;
+		led->cdev.brightness = LED_OFF;
+		led->cdev.brightness_set = pwmled_brightness;
+		led->cdev.default_trigger = dat->default_trigger;
+
+		led->active_low = dat->active_low;
+
+		status = pwm_channel_alloc(dat->gpio, &led->pwmc);
+		if (status < 0)
+			goto err;
+
+		/*
+		 * Prescale clock by 2^x, so PWM counts in low MHz.
+		 * Start each cycle with the LED active, so increasing
+		 * the duty cycle gives us more time on (== brighter).
+		 */
+		tmp = 5;
+		if (!led->active_low)
+			tmp |= PWM_CPR_CPOL;
+		pwm_channel_writel(&led->pwmc, PWM_CMR, tmp);
+
+		/*
+		 * Pick a period so PWM cycles at 100+ Hz; and a multiplier
+		 * for scaling duty cycle:  brightness * mult.
+		 */
+		tmp = (led->pwmc.mck / (1 << 5)) / 100;
+		tmp /= 255;
+		led->mult = tmp;
+		pwm_channel_writel(&led->pwmc, PWM_CDTY,
+				led->cdev.brightness * 255);
+		pwm_channel_writel(&led->pwmc, PWM_CPRD,
+				LED_FULL * tmp);
+
+		pwm_channel_enable(&led->pwmc);
+
+		/* Hand it over to the LED framework */
+		status = led_classdev_register(&pdev->dev, &led->cdev);
+		if (status < 0) {
+			pwm_channel_free(&led->pwmc);
+			goto err;
+		}
+	}
+
+	platform_set_drvdata(pdev, leds);
+	return 0;
+
+err:
+	if (i > 0) {
+		for (i = i - 1; i >= 0; i--) {
+			led_classdev_unregister(&leds[i].cdev);
+			pwm_channel_free(&leds[i].pwmc);
+		}
+	}
+	kfree(leds);
+
+	return status;
+}
+
+static int __exit pwmled_remove(struct platform_device *pdev)
+{
+	const struct gpio_led_platform_data	*pdata;
+	struct pwmled				*leds;
+	unsigned				i;
+
+	pdata = pdev->dev.platform_data;
+	leds = platform_get_drvdata(pdev);
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		struct pwmled		*led = leds + i;
+
+		led_classdev_unregister(&led->cdev);
+		pwm_channel_free(&led->pwmc);
+	}
+
+	kfree(leds);
+	platform_set_drvdata(pdev, NULL);
+	return 0;
+}
+
+static struct platform_driver pwmled_driver = {
+	.driver = {
+		.name =		"leds-atmel-pwm",
+		.owner =	THIS_MODULE,
+	},
+	/* REVISIT add suspend() and resume() methods */
+	.remove =	__exit_p(pwmled_remove),
+};
+
+static int __init modinit(void)
+{
+	return platform_driver_probe(&pwmled_driver, pwmled_probe);
+}
+module_init(modinit);
+
+static void __exit modexit(void)
+{
+	platform_driver_unregister(&pwmled_driver);
+}
+module_exit(modexit);
+
+MODULE_DESCRIPTION("Driver for LEDs with PWM-controlled brightness");
+MODULE_LICENSE("GPL");
-- 
1.5.3.8

