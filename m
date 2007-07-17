Return-Path: <linux-kernel-owner+w=401wt.eu-S935654AbXGQSOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935654AbXGQSOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761665AbXGQSOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:14:33 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:56947 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762548AbXGQSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:14:32 -0400
Message-ID: <469D06D2.9020902@freemail.hu>
Date: Tue, 17 Jul 2007 20:13:38 +0200
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu; rv:1.7.12) Gecko/20050920
X-Accept-Language: hu, en, de
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, linux-input@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
Subject: Re: [PATCH 3/3] leds-clevo-mail: driver for Clevo mail LED
References: <469C978A.5060809@freemail.hu>
In-Reply-To: <469C978A.5060809@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The driver supports the mail LED commonly found on different Clevo notebooks.
The driver access the LED through the i8042 hardware and implements the support for
hardware accelerated blink function.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.22.orig/drivers/leds/Kconfig linux-2.6.22/drivers/leds/Kconfig
--- linux-2.6.22.orig/drivers/leds/Kconfig	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/drivers/leds/Kconfig	2007-07-17 10:52:43.000000000 +0200
@@ -95,6 +95,26 @@ config LEDS_COBALT
  	help
  	  This option enables support for the front LED on Cobalt Server

+config LEDS_CLEVO_MAIL
+	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
+	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
+	help
+	  This driver makes the mail LED accessible from userspace
+	  programs through the leds subsystem. This LED can blink at
+	  about 0.5Hz and 1Hz.
+
+	  This module can drive the mail LED for the following notebooks:
+
+		Clevo D410J
+		Clevo D410V
+		Clevo D400V/D470V (not tested, but might work)
+		Clevo M540N
+		Clevo M5x0N (not tested, but might work)
+		Positivo Mobile (Clevo M5x0V)
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called leds-clevo-mail.
+
  comment "LED Triggers"

  config LEDS_TRIGGERS
diff -uprN linux-2.6.22.orig/drivers/leds/leds-clevo-mail.c linux-2.6.22/drivers/leds/leds-clevo-mail.c
--- linux-2.6.22.orig/drivers/leds/leds-clevo-mail.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.22/drivers/leds/leds-clevo-mail.c	2007-07-17 17:53:34.000000000 +0200
@@ -0,0 +1,226 @@
+
+#include <linux/module.h>
+
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/leds.h>
+
+#include <linux/io.h>
+#include <linux/dmi.h>
+
+#include <linux/i8042.h>
+
+
+#define TRUE				1
+#define FALSE				0
+
+#define HANDLED				0
+
+#define CLEVO_MAIL_LED_OFF		0x0084
+#define CLEVO_MAIL_LED_BLINK_1HZ	0x008A
+#define CLEVO_MAIL_LED_BLINK_0_5HZ	0x0083
+
+#define MODULE_FNAME		"leds-clevo-mail.c"
+#define DRVNAME			"clevo-mail-led"
+#define NO_RESOURCES		NULL
+
+MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
+MODULE_DESCRIPTION("Clevo mail LED driver");
+MODULE_LICENSE("GPL");
+
+static unsigned int __initdata nodetect;
+module_param_named(nodetect, nodetect, bool, 0);
+MODULE_PARM_DESC(nodetect, "Skip DMI hardware detection");
+
+
+static struct platform_device *pdev;
+
+
+static int __init clevo_mail_led_dmi_callback(struct dmi_system_id *id)
+{
+	printk(KERN_INFO MODULE_FNAME ": '%s' found\n", id->ident);
+	return 1;
+}
+
+/**
+ * struct mail_led_whitelist - List of known good models
+ *
+ * Contains the known good models this driver is compatible with.
+ * When adding a new model try to be as strict as possible. This
+ * makes it possible to keep the false positives (the model is
+ * detected as working, but in reality it is not) as low as
+ * possible.
+ */
+static struct dmi_system_id __initdata mail_led_whitelist[] = {
+	{
+		.callback = clevo_mail_led_dmi_callback,
+		.ident = "Clevo D410J",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "VIA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "K8N800"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "VT8204B")
+		}
+	},
+	{
+		.callback = clevo_mail_led_dmi_callback,
+		.ident = "Clevo M5x0N",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "M5x0N")
+		}
+	},
+	{
+		.callback = clevo_mail_led_dmi_callback,
+		.ident = "Positivo Mobile",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "CLEVO Co. "),
+			DMI_MATCH(DMI_BOARD_NAME, "M5X0V "),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Positivo Mobile"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "VT6198")
+		}
+	},
+	{
+		.callback = clevo_mail_led_dmi_callback,
+		.ident = "Clevo D410V",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Clevo, Co."),
+			DMI_MATCH(DMI_BOARD_NAME, "D400V/D470V"),
+			DMI_MATCH(DMI_BOARD_VERSION, "SS78B"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Rev. A1")
+		}
+	},
+	{ }
+};
+
+
+static void clevo_mail_led_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
+{
+	if (value == LED_OFF)
+		i8042_command(NULL, CLEVO_MAIL_LED_OFF);
+	else if (value <= LED_HALF)
+		i8042_command(NULL, CLEVO_MAIL_LED_BLINK_0_5HZ);
+	else
+		i8042_command(NULL, CLEVO_MAIL_LED_BLINK_1HZ);
+
+}
+
+static int clevo_mail_led_blink(struct led_classdev *led_cdev,
+				int delay_on, int delay_off)
+{
+	int status = -EINVAL;
+
+	if (delay_on == 500 /* ms */ && delay_off == 500 /* ms */) {
+		/* blink the led with 1Hz */
+		i8042_command(NULL, CLEVO_MAIL_LED_BLINK_1HZ);
+		status = HANDLED;
+
+	} else if (delay_on == 1000 /* ms */ && delay_off == 1000 /* ms */) {
+		/* blink the led with 0.5Hz */
+		i8042_command(NULL, CLEVO_MAIL_LED_BLINK_0_5HZ);
+		status = HANDLED;
+
+	} else {
+		printk(KERN_DEBUG MODULE_FNAME
+		       ": clevo_mail_led_blink(..., %u, %u),"
+		       " returning -EINVAL (unsupported)\n",
+		       delay_on, delay_off);
+	}
+
+	return status;
+}
+
+
+static struct led_classdev clevo_mail_led = {
+	.name			= "clevo::mail",
+	.brightness_set		= clevo_mail_led_set,
+	.blink_set		= clevo_mail_led_blink,
+};
+
+static int __init clevo_mail_led_probe(struct platform_device *pdev)
+{
+	return led_classdev_register(&pdev->dev, &clevo_mail_led);
+}
+
+static int clevo_mail_led_remove(struct platform_device *pdev)
+{
+	led_classdev_unregister(&clevo_mail_led);
+	return 0;
+}
+
+
+
+#ifdef CONFIG_PM
+static int clevo_mail_led_suspend(struct platform_device *dev,
+				  pm_message_t state)
+{
+	led_classdev_suspend(&clevo_mail_led);
+	return 0;
+}
+
+static int clevo_mail_led_resume(struct platform_device *dev)
+{
+	led_classdev_resume(&clevo_mail_led);
+	return 0;
+}
+#endif
+
+static struct platform_driver clevo_mail_led_driver = {
+	.probe		= clevo_mail_led_probe,
+	.remove		= clevo_mail_led_remove,
+#ifdef CONFIG_PM
+	.suspend	= clevo_mail_led_suspend,
+	.resume		= clevo_mail_led_resume,
+#endif
+	.driver		= {
+		.name		= DRVNAME,
+	},
+};
+
+
+static int __init clevo_mail_led_init(void)
+{
+	int error = 0;
+	int count = 0;
+
+	/* Check with the help of DMI if we are running on supported hardware */
+	if (!nodetect) {
+		count = dmi_check_system(mail_led_whitelist);
+	} else {
+		count = 1;
+		printk(KERN_ERR MODULE_FNAME ": Skipping DMI detection. "
+		       "If the driver works on your hardware please "
+		       "report model and the output of dmidecode in tracker "
+		       "at http://sourceforge.net/projects/clevo-mailled/\n");
+	}
+
+	if (!count) {
+		return -ENODEV;
+	}
+
+	pdev = platform_device_register_simple(DRVNAME, -1, NO_RESOURCES, 0);
+	if (!IS_ERR(pdev)) {
+		error = platform_driver_probe(&clevo_mail_led_driver,
+					      clevo_mail_led_probe);
+		if (error) {
+			printk(KERN_ERR MODULE_FNAME
+			       ": Can't probe platform driver\n");
+			platform_device_unregister(pdev);
+		}
+	} else {
+		error = PTR_ERR(pdev);
+	}
+
+	return error;
+}
+
+static void __exit clevo_mail_led_exit(void)
+{
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&clevo_mail_led_driver);
+
+	clevo_mail_led_set(NULL, LED_OFF);
+}
+
+module_init(clevo_mail_led_init);
+module_exit(clevo_mail_led_exit);
diff -uprN linux-2.6.22.orig/drivers/leds/Makefile linux-2.6.22/drivers/leds/Makefile
--- linux-2.6.22.orig/drivers/leds/Makefile	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.22/drivers/leds/Makefile	2007-07-17 10:52:43.000000000 +0200
@@ -16,6 +16,7 @@ obj-$(CONFIG_LEDS_NET48XX)		+= leds-net4
  obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
  obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
  obj-$(CONFIG_LEDS_COBALT)		+= leds-cobalt.o
+obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o

  # LED Triggers
  obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
