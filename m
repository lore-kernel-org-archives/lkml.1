Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYGIVOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYGIVOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYGIVNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:13:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:35747 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbYGIVNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:13:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=aRrQxLwnnykUXS4WW2O3Il1oznmTf8CQZZWcrKDP4L+vo6XJFlXxnpPQPWQdsysW7g
         zEcVxMacXWe8D5I+OMgDeT3RIX55NZd6mWZ9I6K65BfJe36TtTtZhQgIINBhU2ljYKlS
         aa2TjrnajabiMVprE6zJTDUCy8lxeJm4XNzyY=
Date: Wed, 9 Jul 2008 23:08:43 +0200
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
       Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <ivdoorn@gmail.com>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Subject: [RESEND] [PATCH -next 1/2] acpi,rfkill,backlight: comapl-laptop
 update - clarify the code
Message-ID: <20080709230844.7bc3348a@debian>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>

* Clarify the code
* The current LCD brightness after booting should now be reflected in the
  standard backlight interface sysfs file (previously it was always set to 0).        

Signed-off-by: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
---
diff -Nuar a/drivers/misc/compal-laptop.c b/drivers/misc/compal-laptop.c
--- a/drivers/misc/compal-laptop.c	2008-07-09 21:21:20.000000000 +0200
+++ b/drivers/misc/compal-laptop.c	2008-07-09 21:33:18.000000000 +0200
@@ -24,19 +24,10 @@
  */
 
 /*
- * comapl-laptop.c - Compal laptop support.
+ * compal-laptop.c - Compal laptop support.
  *
- * This driver exports a few files in /sys/devices/platform/compal-laptop/:
- *
- *   wlan - wlan subsystem state: contains 0 or 1 (rw)
- *
- *   bluetooth - Bluetooth subsystem state: contains 0 or 1 (rw)
- *
- *   raw - raw value taken from embedded controller register (ro)
- *
- * In addition to these platform device attributes the driver
- * registers itself in the Linux backlight control subsystem and is
- * available to userspace under /sys/class/backlight/compal-laptop/.
+ * This driver registers itself in the Linux backlight control subsystem
+ * and rfkill switch subsystem.
  *
  * This driver might work on other laptops produced by Compal. If you
  * want to try it you can pass force=1 as argument to the module which
@@ -53,7 +44,10 @@
 #include <linux/platform_device.h>
 #include <linux/autoconf.h>
 
-#define COMPAL_DRIVER_VERSION "0.2.6"
+#define COMPAL_DRIVER_VERSION "0.3.0"
+#define COMPAL_DRIVER_NAME "compal-laptop"
+#define COMPAL_ERR KERN_ERR COMPAL_DRIVER_NAME ": "
+#define COMPAL_INFO KERN_INFO COMPAL_DRIVER_NAME ": "
 
 #define COMPAL_LCD_LEVEL_MAX 8
 
@@ -253,7 +247,7 @@
 
 static struct platform_driver compal_driver = {
 	.driver = {
-		.name = "compal-laptop",
+		.name = COMPAL_DRIVER_NAME,
 		.owner = THIS_MODULE,
 	}
 };
@@ -264,7 +258,7 @@
 
 static int dmi_check_cb(const struct dmi_system_id *id)
 {
-	printk(KERN_INFO "compal-laptop: Identified laptop model '%s'.\n",
+	printk(COMPAL_INFO "Identified laptop model '%s'.\n",
 		id->ident);
 
 	return 0;
@@ -326,12 +320,13 @@
 
 	/* Register backlight stuff */
 
-	compalbl_device = backlight_device_register("compal-laptop", NULL, NULL,
-						&compalbl_ops);
+	compalbl_device = backlight_device_register(COMPAL_DRIVER_NAME,
+					NULL, NULL, &compalbl_ops);
 	if (IS_ERR(compalbl_device))
 		return PTR_ERR(compalbl_device);
 
 	compalbl_device->props.max_brightness = COMPAL_LCD_LEVEL_MAX-1;
+	compalbl_device->props.brightness = get_lcd_level();
 
 	ret = platform_driver_register(&compal_driver);
 	if (ret)
@@ -339,7 +334,7 @@
 
 	/* Register platform stuff */
 
-	compal_device = platform_device_alloc("compal-laptop", -1);
+	compal_device = platform_device_alloc(COMPAL_DRIVER_NAME, -1);
 	if (!compal_device) {
 		ret = -ENOMEM;
 		goto fail_platform_driver;
@@ -354,8 +349,8 @@
 	if (ret)
 		goto fail_platform_device2;
 
-	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
-		" successfully loaded.\n");
+	printk(COMPAL_INFO "driver "COMPAL_DRIVER_VERSION
+			" successfully loaded.\n");
 
 	return 0;
 
@@ -386,7 +381,7 @@
 	platform_driver_unregister(&compal_driver);
 	backlight_device_unregister(compalbl_device);
 
-	printk(KERN_INFO "compal-laptop: driver unloaded.\n");
+	printk(COMPAL_INFO "driver unloaded.\n");
 }
 
 module_init(compal_init);
