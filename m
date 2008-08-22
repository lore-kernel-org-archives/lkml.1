Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYHVVSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYHVVSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbYHVVRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:17:49 -0400
Received: from const.mimas.ru ([88.200.217.78]:49610 "EHLO const.mimas.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758867AbYHVVRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:17:47 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 17:17:47 EDT
Message-ID: <48AF2ABF.8080901@const.mimas.ru>
Date: Sat, 23 Aug 2008 02:08:15 +0500
From: Constantin Baranov <const@const.mimas.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.16) Gecko/20080805 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 2.6.27-rc3] led: driver for LEDs on PCEngines ALIX.2 and
 ALIX.3 boards
References: <48AB019D.6080302@const.mimas.ru> <20080822115150.6b3907a4.akpm@linux-foundation.org>
In-Reply-To: <20080822115150.6b3907a4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> How's this look?
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> - cleanups
> 
> - fix off-by-one on error path
> 
> Cc: Constantin Baranov <const@tltsu.ru>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/leds/leds-alix.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/leds/leds-alix.c~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix drivers/leds/leds-alix.c
> --- a/drivers/leds/leds-alix.c~led-driver-for-leds-on-pcengines-alix2-and-alix3-boards-fix
> +++ a/drivers/leds/leds-alix.c
> @@ -4,7 +4,7 @@
>   * Copyright (C) 2008 Constantin Baranov <const@tltsu.ru>
>   */
>  
> -#include <asm/io.h>
> +#include <linux/io.h>
>  #include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/leds.h>
> @@ -22,6 +22,7 @@ static void alix_led_set(struct led_clas
>  {
>  	struct alix_led *led_dev =
>  		container_of(led_cdev, struct alix_led, cdev);
> +
>  	if (brightness)
>  		outl(led_dev->on_value, led_dev->port);
>  	else
> @@ -63,6 +64,7 @@ static struct alix_led alix_leds[] = {
>  static int alix_led_suspend(struct platform_device *dev, pm_message_t state)
>  {
>  	int i;
> +
>  	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
>  		led_classdev_suspend(&alix_leds[i].cdev);
>  	return 0;
> @@ -71,6 +73,7 @@ static int alix_led_suspend(struct platf
>  static int alix_led_resume(struct platform_device *dev)
>  {
>  	int i;
> +
>  	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
>  		led_classdev_resume(&alix_leds[i].cdev);
>  	return 0;
> @@ -92,7 +95,7 @@ static int __init alix_led_probe(struct 
>  		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
>  
>  	if (ret < 0) {
> -		for (i = i - 2; i >= 0; i--)
> +		while (--i >= 0)
>  			led_classdev_unregister(&alix_leds[i].cdev);
>  	}

At the first iteration this while-loop will attempt to unregister
device that has failed and thus is not registered.
My for-loop starts from device immediately before failed one.
Note that probe routine originates from leds-ams-delta.c.

>  
> @@ -102,6 +105,7 @@ static int __init alix_led_probe(struct 
>  static int alix_led_remove(struct platform_device *pdev)
>  {
>  	int i;
> +
>  	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
>  		led_classdev_unregister(&alix_leds[i].cdev);
>  	return 0;
> @@ -122,6 +126,7 @@ static struct platform_device *pdev;
>  static int __init alix_led_init(void)
>  {
>  	int ret;
> +
>  	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
>  	if (!IS_ERR(pdev)) {
>  		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
> _
> 

I have fixed header and whitespaces.

From: Constantin Baranov <const@tltsu.ru>

Driver for LEDs on PCEngines ALIX.2 and ALIX.3 system boards.

Signed-off-by: Constantin Baranov <const@tltsu.ru>
---
 drivers/leds/Kconfig     |    6 +
 drivers/leds/Makefile    |    1 
 drivers/leds/leds-alix.c |  151 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 158 insertions(+)

diff -uprN linux-2.6.27-rc3/drivers/leds/Kconfig linux-2.6.27-rc3-alix/drivers/leds/Kconfig
--- linux-2.6.27-rc3/drivers/leds/Kconfig	2008-08-19 20:14:06.355647765 +0500
+++ linux-2.6.27-rc3-alix/drivers/leds/Kconfig	2008-08-19 20:20:08.023147125 +0500
@@ -77,6 +77,12 @@ config LEDS_WRAP
 	help
 	  This option enables support for the PCEngines WRAP programmable LEDs.
 
+config LEDS_ALIX
+	tristate "LED support for ALIX series"
+	depends on LEDS_CLASS && X86
+	help
+	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
+
 config LEDS_H1940
 	tristate "LED Support for iPAQ H1940 device"
 	depends on LEDS_CLASS && ARCH_H1940
diff -uprN linux-2.6.27-rc3/drivers/leds/leds-alix.c linux-2.6.27-rc3-alix/drivers/leds/leds-alix.c
--- linux-2.6.27-rc3/drivers/leds/leds-alix.c	1970-01-01 04:00:00.000000000 +0400
+++ linux-2.6.27-rc3-alix/drivers/leds/leds-alix.c	2008-08-19 21:59:05.207153570 +0500
@@ -0,0 +1,151 @@
+/*
+ * LEDs driver for PCEngines ALIX.2 and ALIX.3
+ *
+ * Copyright (C) 2008 Constantin Baranov <const@tltsu.ru>
+ */
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+
+struct alix_led {
+	struct led_classdev cdev;
+	unsigned short port;
+	unsigned int on_value;
+	unsigned int off_value;
+};
+
+static void alix_led_set(struct led_classdev *led_cdev,
+			 enum led_brightness brightness)
+{
+	struct alix_led *led_dev =
+		container_of(led_cdev, struct alix_led, cdev);
+
+	if (brightness)
+		outl(led_dev->on_value, led_dev->port);
+	else
+		outl(led_dev->off_value, led_dev->port);
+}
+
+static struct alix_led alix_leds[] = {
+	{
+		.cdev = {
+			.name = "alix:1",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6100,
+		.on_value = 1 << 22,
+		.off_value = 1 << 6,
+	},
+	{
+		.cdev = {
+			.name = "alix:2",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6180,
+		.on_value = 1 << 25,
+		.off_value = 1 << 9,
+	},
+	{
+		.cdev = {
+			.name = "alix:3",
+			.brightness_set = alix_led_set,
+		},
+		.port = 0x6180,
+		.on_value = 1 << 27,
+		.off_value = 1 << 11,
+	},
+};
+
+#ifdef CONFIG_PM
+
+static int alix_led_suspend(struct platform_device *dev, pm_message_t state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_suspend(&alix_leds[i].cdev);
+	return 0;
+}
+
+static int alix_led_resume(struct platform_device *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_resume(&alix_leds[i].cdev);
+	return 0;
+}
+
+#else
+
+#define alix_led_suspend NULL
+#define alix_led_resume NULL
+
+#endif
+
+static int __init alix_led_probe(struct platform_device *pdev)
+{
+	int i;
+	int ret = 0;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds) && ret >= 0; i++)
+		ret = led_classdev_register(&pdev->dev, &alix_leds[i].cdev);
+
+	if (ret < 0) {
+		for (i = i - 2; i >= 0; i--)
+			led_classdev_unregister(&alix_leds[i].cdev);
+	}
+
+	return ret;
+}
+
+static int alix_led_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(alix_leds); i++)
+		led_classdev_unregister(&alix_leds[i].cdev);
+	return 0;
+}
+
+static struct platform_driver alix_led_driver = {
+	.remove = alix_led_remove,
+	.suspend = alix_led_suspend,
+	.resume = alix_led_resume,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct platform_device *pdev;
+
+static int __init alix_led_init(void)
+{
+	int ret;
+
+	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
+	if (!IS_ERR(pdev)) {
+		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
+		if (ret)
+			platform_device_unregister(pdev);
+	} else
+		ret = PTR_ERR(pdev);
+	return ret;
+}
+
+static void __exit alix_led_exit(void)
+{
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&alix_led_driver);
+}
+
+module_init(alix_led_init);
+module_exit(alix_led_exit);
+
+MODULE_AUTHOR("Constantin Baranov <const@tltsu.ru>");
+MODULE_DESCRIPTION("PCEngines ALIX LED driver");
+MODULE_LICENSE("GPL");
diff -uprN linux-2.6.27-rc3/drivers/leds/Makefile linux-2.6.27-rc3-alix/drivers/leds/Makefile
--- linux-2.6.27-rc3/drivers/leds/Makefile	2008-08-19 20:14:06.365646999 +0500
+++ linux-2.6.27-rc3-alix/drivers/leds/Makefile	2008-08-19 20:20:22.485647344 +0500
@@ -13,6 +13,7 @@ obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c2
 obj-$(CONFIG_LEDS_AMS_DELTA)		+= leds-ams-delta.o
 obj-$(CONFIG_LEDS_NET48XX)		+= leds-net48xx.o
 obj-$(CONFIG_LEDS_WRAP)			+= leds-wrap.o
+obj-$(CONFIG_LEDS_ALIX)			+= leds-alix.o
 obj-$(CONFIG_LEDS_H1940)		+= leds-h1940.o
 obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
