Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYFGCyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYFGCyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 22:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbYFGCyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 22:54:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48311 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbYFGCyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 22:54:39 -0400
Date: Sat, 7 Jun 2008 03:54:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, mzxreary@0pointer.de
Subject: [PATCH] Add backlight driver for Nvidia-based Apple Macbook Pros
Message-ID: <20080607025436.GB24254@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nvidia-based Apple Macbook Pros don't appear to handle backlight control 
through the graphics card registers or ACPI, but instead trigger changes 
via SMI calls. This driver registers a generic backlight device that 
lets existing userspace deal with it. Code derived from Julien Blache's 
Pommed application.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Lennart - as far as I could tell from your description, the DMI 
autoloading code for this should be correct. However, it's not working 
for me on F9. Have I missed something, or does it just not work there?

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index dcd8073..56f4572 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -112,3 +112,11 @@ config BACKLIGHT_CARILLO_RANCH
 	help
 	  If you have a Intel LE80578 (Carillo Ranch) say Y to enable the
 	  backlight driver.
+
+config BACKLIGHT_MBP_NVIDIA
+       tristate "Macbook Pro Nvidia Backlight Driver"
+       depends on BACKLIGHT_CLASS_DEVICE && X86
+       default n
+       help
+         If you have an Apple Macbook Pro with Nvidia graphics hardware say Y
+	 to enable a driver for its backlight
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 33f6c7c..5b91515 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
+obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
new file mode 100644
index 0000000..c622d22
--- /dev/null
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -0,0 +1,114 @@
+/*
+ *  Backlight Driver for Nvidia 8600 in Macbook Pro
+ *
+ *  Copyright (c) Red Hat <mjg@redhat.com>
+ *  Based on code from Pommed:
+ *  Copyright (C) 2006 Nicolas Boichat <nicolas @boichat.ch>
+ *  Copyright (C) 2006 Felipe Alfaro Solana <felipe_alfaro @linuxmail.org>
+ *  Copyright (C) 2007 Julien BLACHE <jb@jblache.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This driver triggers SMIs which cause the firmware to change the
+ *  backlight brightness. This is icky in many ways, but it's impractical to
+ *  get at the firmware code in order to figure out what it's actually doing.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/dmi.h>
+#include <linux/io.h>
+
+struct backlight_device *mbp_backlight_device;
+
+static struct dmi_system_id __initdata mbp_device_table[] = {
+	{
+		.ident = "3,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,1"),
+		},
+	},
+	{
+		.ident = "3,2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro3,2"),
+		},
+	},
+	{
+		.ident = "4,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro4,1"),
+		},
+	},
+	{ }
+};
+
+static int mbp_send_intensity(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	outb(0x04 | (intensity << 4), 0xb3);
+	outb(0xbf, 0xb2);
+
+	return 0;
+}
+
+static int mbp_get_intensity(struct backlight_device *bd)
+{
+	outb(0x03, 0xb3);
+	outb(0xbf, 0xb2);
+	return inb(0xb3) >> 4;
+}
+
+static struct backlight_ops mbp_ops = {
+	.get_brightness = mbp_get_intensity,
+	.update_status  = mbp_send_intensity,
+};
+
+static int __init mbp_init(void)
+{
+	if (!dmi_check_system(mbp_device_table))
+		return -ENODEV;
+
+	if (!request_region(0xb2, 2, "Macbook Pro backlight"))
+		return -ENXIO;
+
+	mbp_backlight_device = backlight_device_register("mbp_backlight",
+							 NULL, NULL,
+							 &mbp_ops);
+	if (IS_ERR(mbp_backlight_device))
+		return PTR_ERR(mbp_backlight_device);
+
+	mbp_backlight_device->props.max_brightness = 15;
+	mbp_backlight_device->props.brightness =
+		mbp_get_intensity(mbp_backlight_device);
+	backlight_update_status(mbp_backlight_device);
+
+	return 0;
+}
+
+static void __exit mbp_exit(void)
+{
+	backlight_device_unregister(mbp_backlight_device);
+
+	release_region(0xb2, 2);
+}
+
+module_init(mbp_init);
+module_exit(mbp_exit);
+
+MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
+MODULE_DESCRIPTION("Nvidia-based Macbook Pro Backlight Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("dmi:*:svnApple Inc.:pnMacBookPro3,1:*");
+MODULE_ALIAS("dmi:*:svnApple Inc.:pnMacBookPro3,2:*");
+MODULE_ALIAS("dmi:*:svnApple Inc.:pnMacBookPro4,1:*");

-- 
Matthew Garrett | mjg59@srcf.ucam.org
