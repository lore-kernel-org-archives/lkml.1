Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZHNWzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZHNWzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbZHNWzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:55:41 -0400
Received: from kroah.org ([198.145.64.141]:59416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbZHNWzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:55:41 -0400
Date: Fri, 14 Aug 2009 15:48:35 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Soeren Sonnenburg <bugreports@nn7.de>,
       =?iso-8859-1?Q?J=E9r=E9mie?= Huchet <jeremie@lamah.info>
Subject: Re: [PATCH] Samsung backlight driver
Message-ID: <20090814224835.GA31585@kroah.com>
References: <20090814194815.GA31474@kroah.com>
 <20090814222533.26D94526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090814222533.26D94526EC9@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated version, with two more laptop models supported, and
the comments from Dmitry added in.

thanks,

greg k-h

----------------


From: Greg Kroah-Hartman <gregkh@suse.de>

This driver implements backlight controls for Samsung laptops that
currently do not have ACPI support for this control.

It has been tested on the N130 laptop and properly works there.

Info for the NC10 was provided by Soeren Sonnenburg <bugreports@nn7.de>
Info for the NP-Q45 from Jérémie Huchet <jeremie@lamah.info>

Cc: Soeren Sonnenburg <bugreports@nn7.de>
Cc: Jérémie Huchet <jeremie@lamah.info>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/Kconfig             |   12 ++
 drivers/platform/x86/Makefile            |    1 
 drivers/platform/x86/samsung-backlight.c |  168 +++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+)

--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -425,4 +425,16 @@ config ACPI_TOSHIBA
 
 	  If you have a legacy free Toshiba laptop (such as the Libretto L1
 	  series), say Y.
+
+config SAMSUNG_BACKLIGHT
+	tristate "Samsung Backlight driver"
+	depends on BACKLIGHT_CLASS_DEVICE
+	depends on DMI
+	---help---
+	  This driver adds support to control the backlight on a number of
+	  Samsung laptops, like the N130.
+
+	  It will only be loaded on laptops that properly need it, so it is
+	  safe to say Y here.
+
 endif # X86_PLATFORM_DEVICES
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_INTEL_MENLOW)	+= intel_menl
 obj-$(CONFIG_ACPI_WMI)		+= wmi.o
 obj-$(CONFIG_ACPI_ASUS)		+= asus_acpi.o
 obj-$(CONFIG_ACPI_TOSHIBA)	+= toshiba_acpi.o
+obj-$(CONFIG_SAMSUNG_BACKLIGHT)	+= samsung-backlight.o
--- /dev/null
+++ b/drivers/platform/x86/samsung-backlight.c
@@ -0,0 +1,168 @@
+/*
+ * Samsung N130 and NC10 Laptop Backlight driver
+ *
+ * Copyright (C) 2009 Greg Kroah-Hartman (gregkh@suse.de)
+ * Copyright (C) 2009 Novell Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/backlight.h>
+#include <linux/fb.h>
+#include <linux/dmi.h>
+
+#define MAX_BRIGHT	0xff
+#define OFFSET		0xf4
+
+static struct pci_dev *pci_device;
+static struct backlight_device *backlight_device;
+static int offset = OFFSET;
+static u8 current_brightness;
+
+static void read_brightness(void)
+{
+	if (!pci_device)
+		return;
+	pci_read_config_byte(pci_device, offset, &current_brightness);
+}
+
+static void set_brightness(void)
+{
+	if (!pci_device)
+		return;
+	pci_write_config_byte(pci_device, offset, current_brightness);
+}
+
+static int get_brightness(struct backlight_device *bd)
+{
+	return bd->props.brightness;
+}
+
+static int update_status(struct backlight_device *bd)
+{
+	if (!pci_device)
+		return -ENODEV;
+
+	current_brightness = bd->props.brightness;
+	set_brightness();
+	return 0;
+}
+
+static struct backlight_ops backlight_ops = {
+	.get_brightness	= get_brightness,
+	.update_status	= update_status,
+};
+
+static int find_video_card(void)
+{
+	struct pci_dev *dev = NULL;
+
+	while ((dev = pci_get_device(0x8086, 0x27ae, dev)) != NULL) {
+		/*
+		 * Found one, so let's save it off and break
+		 * Note that the reference is still raised on
+		 * the PCI device here.
+		 */
+		pci_device = dev;
+		break;
+	}
+
+	if (!pci_device)
+		return -ENODEV;
+
+	/* create a backlight device to talk to this one */
+	backlight_device = backlight_device_register("samsung",
+						     &pci_device->dev,
+						     NULL, &backlight_ops);
+	if (IS_ERR(backlight_device))
+		return PTR_ERR(backlight_device);
+	read_brightness();
+	backlight_device->props.max_brightness = MAX_BRIGHT;
+	backlight_device->props.brightness = current_brightness;
+	backlight_device->props.power = FB_BLANK_UNBLANK;
+	backlight_update_status(backlight_device);
+	return 0;
+}
+
+static void remove_video_card(void)
+{
+	if (!pci_device)
+		return;
+
+	backlight_device_unregister(backlight_device);
+	backlight_device = NULL;
+
+	/* we are done with the PCI device, put it back */
+	pci_dev_put(pci_device);
+	pci_device = NULL;
+}
+
+static int dmi_check_cb(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO KBUILD_MODNAME ": found laptop model '%s'\n",
+		id->ident);
+	return 0;
+}
+
+static struct dmi_system_id __initdata samsung_dmi_table[] = {
+	{
+		.ident = "N130",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N130"),
+			DMI_MATCH(DMI_BOARD_NAME, "N130"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
+		.ident = "NC10",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "NC10"),
+			DMI_MATCH(DMI_BOARD_NAME, "NC10"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
+		.ident = "NP-Q45",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SQ45S70S"),
+			DMI_MATCH(DMI_BOARD_NAME, "SQ45S70S"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{ },
+};
+
+static int __init samsung_init(void)
+{
+	if (!dmi_check_system(samsung_dmi_table))
+		return -ENODEV;
+
+	return find_video_card();
+}
+
+static void __exit samsung_exit(void)
+{
+	remove_video_card();
+}
+
+module_init(samsung_init);
+module_exit(samsung_exit);
+
+MODULE_AUTHOR("Greg Kroah-Hartman <gregkh@suse.de>");
+MODULE_DESCRIPTION("Samsung Backlight driver");
+MODULE_LICENSE("GPL");
+module_param(offset, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(offset, "The offset into the PCI device for the brightness control");
+MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnN130:*:rnN130:*");
+MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnNC10:*:rnNC10:*");
+MODULE_ALIAS("dmi:*:svnSAMSUNGELECTRONICSCO.,LTD.:pnSQ45S70S:*:rnSQ45S70S:*");
