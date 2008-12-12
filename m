Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYLLUuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYLLUuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYLLUt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:49:58 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:61822 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYLLUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:49:57 -0500
Message-ID: <4942CE33.2020403@inf.tu-dresden.de>
Date: Fri, 12 Dec 2008 21:48:51 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>, Richard Purdie <rpurdie@rpsys.net>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] video: mbp_nvidia_bl: Add support for MacBook 5, MacBook
 Air 2, and MacBook Pro 5
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the new Apple models incorporating
an Nvidia chipset. Apple still uses the same protocol as on older models,
but the registers moved to a different address.

The initial code has been contributed by Hu Gang <hugang@soulinfo.com>.

Changes:
    * new structure to be passed to the DMI_MATCH function
    * separated implementation for Intel/Nvidia chipset models
    * added new entries to the device table (moved down)
    * used driver_data structure to request resources/access ops
      where necessary

Known to work on:
    * MacBook Pro 3
    * MacBook Pro 4
    * MacBook Pro 5

Known to work with limitations on:
    * MacBook 5 / MacBook Air 2:
         Changing brightness within X doesn't work, if using
         Nvidia's proprietary graphics driver. No fix known yet.
         Changing brightness on a text console or using the open-source
         driver does work.

Known Bugs:
    * MacBook Pro 5:
         Initial brightness after bootup is the last recently used
         brightness (in Mac OSX), while the firmware reports maximum.
         Impossible to fix.

Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
---
 drivers/video/backlight/mbp_nvidia_bl.c |  171 ++++++++++++++++++++++++-------
 1 files changed, 132 insertions(+), 39 deletions(-)

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 40a6b79..559daf0 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -25,63 +25,163 @@
 #include <linux/dmi.h>
 #include <linux/io.h>

-static struct dmi_system_id __initdata mbp_device_table[] = {
-	{
-		.ident = "3,1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,1"),
-		},
-	},
-	{
-		.ident = "3,2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,2"),
-		},
-	},
-	{
-		.ident = "4,1",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4,1"),
-		},
-	},
-	{ }
+/* Structure to be passed to the DMI_MATCH function. */
+struct dmi_match_data {
+	/* I/O resource to allocate. */
+	struct resource iores;
+	/* Backlight operations structure. */
+	struct backlight_ops backlight_ops;
 };

-static int mbp_send_intensity(struct backlight_device *bd)
+/*
+ * Implementation for MacBooks with Intel chipset.
+ */
+static int intel_chipset_send_intensity(struct backlight_device *bd)
 {
 	int intensity = bd->props.brightness;

 	outb(0x04 | (intensity << 4), 0xb3);
 	outb(0xbf, 0xb2);
-
 	return 0;
 }

-static int mbp_get_intensity(struct backlight_device *bd)
+static int intel_chipset_get_intensity(struct backlight_device *bd)
 {
 	outb(0x03, 0xb3);
 	outb(0xbf, 0xb2);
 	return inb(0xb3) >> 4;
 }

-static struct backlight_ops mbp_ops = {
-	.get_brightness = mbp_get_intensity,
-	.update_status  = mbp_send_intensity,
+static const struct dmi_match_data intel_chipset_data = {
+	.iores = {
+		.start		= 0xb2,
+		.end		= 0xb3,
+		.name		= "mbp_nvidia_bl",
+		.flags		= IORESOURCE_IO
+	},
+	.backlight_ops		= {
+		.get_brightness	= intel_chipset_get_intensity,
+		.update_status	= intel_chipset_send_intensity,
+	}
 };

+/*
+ * Implementation for MacBooks with Nvidia chipset.
+ */
+static int nvidia_chipset_send_intensity(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	outb(0x04 | (intensity << 4), 0x52f);
+	outb(0xbf, 0x52e);
+	return 0;
+}
+
+static int nvidia_chipset_get_intensity(struct backlight_device *bd)
+{
+	outb(0x03, 0x52f);
+	outb(0xbf, 0x52e);
+	return inb(0x52f) >> 4;
+}
+
+static const struct dmi_match_data nvidia_chipset_data = {
+	.iores = {
+		.start		= 0x52e,
+		.end		= 0x52f,
+		.name		= "mbp_nvidia_bl",
+		.flags		= IORESOURCE_IO,
+	},
+	.backlight_ops		= {
+		.get_brightness	= nvidia_chipset_get_intensity,
+		.update_status	= nvidia_chipset_send_intensity
+	}
+};
+
+/*
+ * DMI matching.
+ */
+static /* const */ struct dmi_match_data *driver_data;
+
+static int dmi_match(const struct dmi_system_id *id)
+{
+	driver_data = id->driver_data;
+
+	printk(KERN_INFO "mbp_nvidia_bl: %s detected\n", id->ident);
+	return 1;
+}
+
+static const struct dmi_system_id __initdata mbp_device_table[] = {
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookPro 3,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookPro 3,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,2"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookPro 4,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBook 5,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookAir 2,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir2,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= dmi_match,
+		.ident		= "MacBookPro 5,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{ }
+};
+
+/*
+ * Platform driver implementation.
+ */
 static int mbp_probe(struct platform_device *pdev)
 {
 	struct backlight_device *bd;

-	bd = backlight_device_register("mbp_backlight", NULL, NULL, &mbp_ops);
+	bd = backlight_device_register("mbp_backlight", NULL, NULL,
+				       &driver_data->backlight_ops);
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);

 	bd->props.max_brightness = 15;
-	bd->props.brightness = mbp_get_intensity(bd);
+	bd->props.brightness = bd->ops->get_brightness(bd);
 	backlight_update_status(bd);

 	platform_set_drvdata(pdev, bd);
@@ -128,13 +228,6 @@ static struct platform_driver mbp_driver = {
 	},
 };

-static struct resource mbp_iores = {
-	.start          = 0xb2,
-	.end            = 0xb3,
-	.name           = "mbp_nvidia_bl",
-	.flags          = IORESOURCE_IO
-};
-
 static struct platform_device *mbp_device;

 static int __init mbp_init(void)
@@ -149,7 +242,7 @@ static int __init mbp_init(void)
 		return ret;

 	mbp_device = platform_device_register_simple("mbp_nvidia_bl", -1,
-						     &mbp_iores, 1);
+						     &driver_data->iores, 1);
 	if (!mbp_device) {
 		platform_driver_unregister(&mbp_driver);
 		return -ENOMEM;
-- 
1.5.6.3

