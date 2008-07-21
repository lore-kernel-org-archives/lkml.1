Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYGUVOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYGUVOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 17:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYGUVOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 17:14:07 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:62753 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282AbYGUVOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:14:06 -0400
Date: Mon, 21 Jul 2008 21:14:04 +0000
From: Sean Young <sean@mess.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] Led driver for technologic systems 5500
Message-ID: <20080721211403.GB72268@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch for the led on the Technologic Systems 5500 board. The
first patch had a bug in an error path. Detection is still a bit flimsy; Is 
there anything that can be done about that?
 
Signed-off-by: Sean Young <sean@mess.org>
---
diff -urpN linux-2.6.26/drivers/leds/Kconfig /home/sean/tiger/linux-2.6.26/drivers/leds/Kconfig
--- linux-2.6.26/drivers/leds/Kconfig	2008-07-13 22:51:29.000000000 +0100
+++ /home/sean/tiger/linux-2.6.26/drivers/leds/Kconfig	2008-07-21 12:19:51.000000000 +0100
@@ -147,6 +147,16 @@ config LEDS_CLEVO_MAIL
 	  To compile this driver as a module, choose M here: the
 	  module will be called leds-clevo-mail.
 
+config LEDS_TS5500
+	tristate "LED Support for the TS-5500"
+	depends on LEDS_CLASS && X86
+	help
+	  This driver makes the led on the Technologic Systems 5500 
+	  (and possibly other models) accessible for userspace. 
+
+	  Note that this led is hardwired to be xor'ed with Compact Flash
+	  activity.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
Binary files linux-2.6.26/drivers/leds/.leds-net48xx.c.swp and /home/sean/tiger/linux-2.6.26/drivers/leds/.leds-net48xx.c.swp differ
diff -urpN linux-2.6.26/drivers/leds/leds-ts5500.c /home/sean/tiger/linux-2.6.26/drivers/leds/leds-ts5500.c
--- linux-2.6.26/drivers/leds/leds-ts5500.c	1970-01-01 01:00:00.000000000 +0100
+++ /home/sean/tiger/linux-2.6.26/drivers/leds/leds-ts5500.c	2008-07-21 21:15:41.000000000 +0100
@@ -0,0 +1,115 @@
+/*
+ * Copyright (C) 2008 Sean Young <sean@mess.org>
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/leds.h>
+
+#define DRVNAME "ts5500-leds"
+
+static struct platform_device *ts5500_pdev;
+
+static void ts5500_led_set(struct led_classdev *led_dev, enum led_brightness value)
+{
+	outb(value ? 1 : 0, 0x77);
+}
+
+static struct led_classdev ts5500_led = {
+	.name = "ts5500:green",
+	.brightness_set = ts5500_led_set,
+};
+
+static int __devinit ts5500leds_probe(struct platform_device *pdev)
+{
+	return led_classdev_register(&pdev->dev, &ts5500_led);
+}
+
+static int __devexit ts5500leds_remove(struct platform_device *pdev)
+{
+	led_classdev_unregister(&ts5500_led);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ts5500leds_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	led_classdev_suspend(&ts5500_led);
+	return 0;
+}
+
+static int ts5500leds_resume(struct platform_device *pdev)
+{
+	led_classdev_resume(&ts5500_led);
+	return 0;
+}
+#endif
+
+static struct platform_driver ts5500leds_driver = {
+	.driver		= {
+		.name	= DRVNAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ts5500leds_probe,
+	.remove		= __devexit_p(ts5500leds_remove),
+#ifdef CONFIG_PM
+	.suspend	= ts5500leds_suspend,
+	.resume		= ts5500leds_resume,
+#endif
+};
+
+
+static int __init ts5500leds_init(void)
+{
+	int rc;
+	uint8_t product_code;
+
+	if (!request_region(0x74, 1, DRVNAME))
+		return -ENODEV;
+
+	product_code = inb(0x74);
+
+	release_region(0x74, 1);
+
+	if (product_code != 0x60)
+		return -ENODEV;
+
+	if (!request_region(0x77, 1, DRVNAME))
+		return -ENODEV;
+
+	rc = platform_driver_register(&ts5500leds_driver);
+	if (rc)
+		goto free_port;
+
+	ts5500_pdev = platform_device_register_simple(DRVNAME, -1, NULL, 0);
+	if (IS_ERR(ts5500_pdev)) {
+		rc = PTR_ERR(ts5500_pdev);
+		goto driver_unreg;
+	}
+
+	return 0;
+
+driver_unreg:
+	platform_driver_unregister(&ts5500leds_driver);
+free_port:
+	release_region(0x77, 1);
+
+	return rc;
+}
+
+static void __exit ts5500leds_exit(void)
+{
+	platform_device_unregister(ts5500_pdev);
+	platform_driver_unregister(&ts5500leds_driver);
+	release_region(0x77, 1);
+}
+
+module_init(ts5500leds_init);
+module_exit(ts5500leds_exit);
+
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_DESCRIPTION("LED driver for the Technology Systems 5500");
+MODULE_LICENSE("GPL");
diff -urpN linux-2.6.26/drivers/leds/Makefile /home/sean/tiger/linux-2.6.26/drivers/leds/Makefile
--- linux-2.6.26/drivers/leds/Makefile	2008-07-13 22:51:29.000000000 +0100
+++ /home/sean/tiger/linux-2.6.26/drivers/leds/Makefile	2008-07-17 15:14:55.000000000 +0100
@@ -21,6 +21,7 @@ obj-$(CONFIG_LEDS_CM_X270)              
 obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
+obj-$(CONFIG_LEDS_TS5500)		+= leds-ts5500.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
