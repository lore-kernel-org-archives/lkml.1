Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbXJ1K0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbXJ1K0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbXJ1K00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:26:26 -0400
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:58713 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXJ1K0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:26:24 -0400
Message-ID: <472470F0.4090702@freemail.hu>
Date: Sun, 28 Oct 2007 12:22:24 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Rodrigo Pereira <rodripe@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] leds-clevo-mail: driver for Clevo mail LED
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The driver supports the mail LED commonly found on different Clevo notebooks.
The driver access the LED through the i8042 hardware which is handled by
the input subsystem.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN linux-2.6.24-rc1.orig/drivers/leds/Kconfig linux-2.6.24-rc1.a/drivers/leds/Kconfig
--- linux-2.6.24-rc1.orig/drivers/leds/Kconfig	2007-10-28 09:14:14.000000000 +0100
+++ linux-2.6.24-rc1.a/drivers/leds/Kconfig	2007-10-28 09:13:13.000000000 +0100
@@ -114,6 +114,30 @@ config LEDS_CM_X270
 	help
 	  This option enables support for the CM-X270 LEDs.

+config LEDS_CLEVO_MAIL
+	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
+	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
+	help
+	  This driver makes the mail LED accessible from userspace
+	  programs through the leds subsystem. This LED have three
+	  known mode: off, blink at 0.5Hz and blink at 1Hz.
+
+	  As this LED cannot change it's brightness it blinks instead.
+	  The brightness value 0 means off, 1..127 means blink at 0.5Hz
+	  and 128..255 means blink at 1Hz.
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
diff -uprN linux-2.6.24-rc1.orig/drivers/leds/leds-clevo-mail.c linux-2.6.24-rc1.a/drivers/leds/leds-clevo-mail.c
--- linux-2.6.24-rc1.orig/drivers/leds/leds-clevo-mail.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.24-rc1.a/drivers/leds/leds-clevo-mail.c	2007-10-28 10:18:42.000000000 +0100
@@ -0,0 +1,182 @@
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
+#define CLEVO_MAIL_LED_OFF		0x0084
+#define CLEVO_MAIL_LED_BLINK_1HZ	0x008A
+#define CLEVO_MAIL_LED_BLINK_0_5HZ	0x0083
+
+MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
+MODULE_DESCRIPTION("Clevo mail LED driver");
+MODULE_LICENSE("GPL");
+
+static unsigned int __initdata nodetect;
+module_param_named(nodetect, nodetect, bool, 0);
+MODULE_PARM_DESC(nodetect, "Skip DMI hardware detection");
+
+static struct platform_device *pdev;
+
+static int __init clevo_mail_led_dmi_callback(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO KBUILD_MODNAME ": '%s' found\n", id->ident);
+	return 1;
+}
+
+/*
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
+static struct led_classdev clevo_mail_led = {
+	.name			= "clevo",
+	.brightness_set		= clevo_mail_led_set,
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
+#else
+#define clevo_mail_led_suspend    NULL
+#define clevo_mail_led_resume     NULL
+#endif
+
+static struct platform_driver clevo_mail_led_driver = {
+	.probe		= clevo_mail_led_probe,
+	.remove		= clevo_mail_led_remove,
+	.suspend	= clevo_mail_led_suspend,
+	.resume		= clevo_mail_led_resume,
+	.driver		= {
+		.name		= KBUILD_MODNAME,
+	},
+};
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
+		printk(KERN_ERR KBUILD_MODNAME ": Skipping DMI detection. "
+		       "If the driver works on your hardware please "
+		       "report model and the output of dmidecode in tracker "
+		       "at http://sourceforge.net/projects/clevo-mailled/\n");
+	}
+
+	if (!count)
+		return -ENODEV;
+
+	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
+	if (!IS_ERR(pdev)) {
+		error = platform_driver_probe(&clevo_mail_led_driver,
+					      clevo_mail_led_probe);
+		if (error) {
+			printk(KERN_ERR KBUILD_MODNAME
+			       ": Can't probe platform driver\n");
+			platform_device_unregister(pdev);
+		}
+	} else
+		error = PTR_ERR(pdev);
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
diff -uprN linux-2.6.24-rc1.orig/drivers/leds/Makefile linux-2.6.24-rc1.a/drivers/leds/Makefile
--- linux-2.6.24-rc1.orig/drivers/leds/Makefile	2007-10-28 09:01:56.000000000 +0100
+++ linux-2.6.24-rc1.a/drivers/leds/Makefile	2007-10-28 07:59:42.000000000 +0100
@@ -19,6 +19,7 @@ obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_CM_X270)              += leds-cm-x270.o
+obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o

 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
