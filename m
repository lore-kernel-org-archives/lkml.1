Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbYLJVBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbYLJVBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYLJVB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:01:29 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:37441 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbYLJVB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:01:28 -0500
X-Greylist: delayed 1862 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2008 16:01:28 EST
Message-ID: <494026CD.5020102@inf.tu-dresden.de>
Date: Wed, 10 Dec 2008 21:30:05 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>, Richard Purdie <rpurdie@rpsys.net>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] video: mbp_nvidia_bl: Fix brightness after suspend/hibernation
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mbp_nvidia_bl driver allows to change the display brightness on
Apple MacBook Pro with Nvidia graphics adapters. However, after
resuming from suspend the brightness is at its maximum instead of
the last recently used value. This patch converts the driver into a
platform_driver in order to register a resume hook to re-send brightness.
In addition, resources will be allocated through platform_driver means
instead of calling request_region/release_region directly.

A patch incorporating MacBook 5 MacBook Air 2, and MacBook Pro 5
support is also available and will be sent next.

Acked-by:      Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
---
 drivers/video/backlight/mbp_nvidia_bl.c |   95 +++++++++++++++++++++++++------
 1 files changed, 77 insertions(+), 18 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 06964af..40a6b79 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -25,8 +25,6 @@
 #include <linux/dmi.h>
 #include <linux/io.h>

-static struct backlight_device *mbp_backlight_device;
-
 static struct dmi_system_id __initdata mbp_device_table[] = {
 	{
 		.ident = "3,1",
@@ -74,35 +72,96 @@ static struct backlight_ops mbp_ops = {
 	.update_status  = mbp_send_intensity,
 };

+static int mbp_probe(struct platform_device *pdev)
+{
+	struct backlight_device *bd;
+
+	bd = backlight_device_register("mbp_backlight", NULL, NULL, &mbp_ops);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
+
+	bd->props.max_brightness = 15;
+	bd->props.brightness = mbp_get_intensity(bd);
+	backlight_update_status(bd);
+
+	platform_set_drvdata(pdev, bd);
+	return 0;
+}
+
+static int mbp_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	backlight_device_unregister(bd);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int mbp_resume(struct platform_device *pdev)
+{
+	/*
+	 * Nvidia GeForce 8600M GT in MacBookPro 3,1 and MacBookPro 4,1:
+	 *   1. Resume after suspend:
+	 *      SMI still reports the last recently written value, while
+	 *      the brightness is actually at its maximum.
+	 *   2. Resume after hibernation:
+	 *      SMI reports the actual (maximum) value, but the state
+	 *      in props.brightness might be different.
+	 * -> Re-send to fix (1), but do not re-read to fix (2).
+	 */
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	backlight_update_status(bd);
+	return 0;
+}
+#else
+#define mbp_resume NULL
+#endif
+
+static struct platform_driver mbp_driver = {
+	.probe          = mbp_probe,
+	.remove         = mbp_remove,
+	.resume         = mbp_resume,
+	.driver         = {
+		.owner  = THIS_MODULE,
+		.name   = "mbp_nvidia_bl"
+	},
+};
+
+static struct resource mbp_iores = {
+	.start          = 0xb2,
+	.end            = 0xb3,
+	.name           = "mbp_nvidia_bl",
+	.flags          = IORESOURCE_IO
+};
+
+static struct platform_device *mbp_device;
+
 static int __init mbp_init(void)
 {
+	int ret;
+
 	if (!dmi_check_system(mbp_device_table))
 		return -ENODEV;

-	if (!request_region(0xb2, 2, "Macbook Pro backlight"))
-		return -ENXIO;
+	ret = platform_driver_register(&mbp_driver);
+	if (ret)
+		return ret;

-	mbp_backlight_device = backlight_device_register("mbp_backlight",
-							 NULL, NULL,
-							 &mbp_ops);
-	if (IS_ERR(mbp_backlight_device)) {
-		release_region(0xb2, 2);
-		return PTR_ERR(mbp_backlight_device);
+	mbp_device = platform_device_register_simple("mbp_nvidia_bl", -1,
+						     &mbp_iores, 1);
+	if (!mbp_device) {
+		platform_driver_unregister(&mbp_driver);
+		return -ENOMEM;
 	}

-	mbp_backlight_device->props.max_brightness = 15;
-	mbp_backlight_device->props.brightness =
-		mbp_get_intensity(mbp_backlight_device);
-	backlight_update_status(mbp_backlight_device);
-
 	return 0;
 }

 static void __exit mbp_exit(void)
 {
-	backlight_device_unregister(mbp_backlight_device);
-
-	release_region(0xb2, 2);
+	platform_device_unregister(mbp_device);
+	platform_driver_unregister(&mbp_driver);
 }

 module_init(mbp_init);
-- 
1.5.6.3

