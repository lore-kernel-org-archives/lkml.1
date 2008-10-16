Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYJPJKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYJPJKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYJPJKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:10:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33497 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbYJPJKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:10:19 -0400
Date: Thu, 16 Oct 2008 11:10:16 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>, lm-sensors@lm-sensors.org,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Andrew Morton <akpm@osdl.org>
Cc: Thomas Renninger <trenn@suse.de>, Yan Burman <burman.yan@gmail.com>
Subject: Driver for HP harddisk protection LED
Message-ID: <20081016091016.GA15439@atrey.karlin.mff.cuni.cz>
References: <48C984F5.5000804@tudelft.nl> <200809120736.06594.trenn@suse.de> <48CAD89F.1050806@tremplin-utc.net> <20081015072511.GA20607@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015072511.GA20607@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

HP notebooks contain accelerometer-based disk protection subsystem,
and LED that indicates hard disk is protected. This is driver for the
LED part.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 27fe7be..d7b789f 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -132,6 +132,13 @@ config LEDS_CM_X270
 	help
 	  This option enables support for the CM-X270 LEDs.
 
+config LEDS_HP_DISK
+	tristate "LED Support for disk protection LED on HP notebooks"
+	depends on LEDS_CLASS && ACPI
+	help
+	  This option enable support for disk protection LED, found on
+	  newer HP notebooks.
+
 config LEDS_CLEVO_MAIL
 	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
 	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index a18e762..b0ed3d2 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-c
 obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
 obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
+obj-$(CONFIG_LEDS_HP_DISK)		+= leds-hp-disk.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff --git a/drivers/leds/leds-hp-disk.c b/drivers/leds/leds-hp-disk.c
new file mode 100644
index 0000000..6ca97e4
--- /dev/null
+++ b/drivers/leds/leds-hp-disk.c
@@ -0,0 +1,155 @@
+/*
+ *  leds-hp-disk.c - driver for HP "hard disk protection" LED
+ *
+ *  Copyright (C) 2008 Pavel Machek
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/dmi.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+#include <linux/kthread.h>
+#include <linux/version.h>
+#include <linux/leds.h>
+#include <acpi/acpi_drivers.h>
+
+#define DRIVER_NAME     "leds-hp-disk"
+#define ACPI_MDPS_CLASS "led"
+
+/* For automatic insertion of the module */
+static struct acpi_device_id hpled_device_ids[] = {
+	{"HPQ0004", 0}, /* HP Mobile Data Protection System PNP */
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, hpled_device_ids);
+
+struct acpi_hpled {
+	struct acpi_device	*device;   /* The ACPI device */
+};
+
+static struct acpi_hpled adev;
+
+static acpi_status hpled_acpi_write(acpi_handle handle, int reg)
+{
+	unsigned long ret; /* Not used when writting */
+	union acpi_object in_obj[1];
+	struct acpi_object_list args = { 1, in_obj };
+
+	in_obj[0].type          = ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value = reg;
+
+	return acpi_evaluate_integer(handle, "ALED", &args, &ret);
+}
+
+static void hpled_set(struct led_classdev *led_cdev,
+			       enum led_brightness value)
+{
+	hpled_acpi_write(adev.device->handle, !!value);
+}
+
+static struct led_classdev hpled_led = {
+	.name			= "hp:red:hddprotection",
+	.default_trigger	= "heartbeat",
+	.brightness_set		= hpled_set,
+};
+
+#ifdef CONFIG_PM
+static int hpled_suspend(struct acpi_device *dev, pm_message_t state)
+{
+	led_classdev_suspend(&hpled_led);
+	return 0;
+}
+
+static int hpled_resume(struct acpi_device *dev)
+{
+	led_classdev_resume(&hpled_led);
+	return 0;
+}
+#endif
+
+static int hpled_add(struct acpi_device *device)
+{
+	int ret;
+
+	if (!device)
+		return -EINVAL;
+
+	adev.device = device;
+	strcpy(acpi_device_name(device), DRIVER_NAME);
+	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
+	acpi_driver_data(device) = &adev;
+
+	ret = led_classdev_register(NULL, &hpled_led);
+	return ret;
+}
+
+static int hpled_remove(struct acpi_device *device, int type)
+{
+	if (!device)
+		return -EINVAL;
+
+	led_classdev_unregister(&hpled_led);
+	return 0;
+}
+
+
+
+static struct acpi_driver leds_hp_driver = {
+	.name  = DRIVER_NAME,
+	.class = ACPI_MDPS_CLASS,
+	.ids   = hpled_device_ids,
+	.ops = {
+		.add     = hpled_add,
+		.remove  = hpled_remove,
+#ifdef CONFIG_PM
+		.suspend = hpled_suspend,
+		.resume  = hpled_resume,
+#endif
+	}
+};
+
+static int __init hpled_init_module(void)
+{
+	int ret;
+
+	if (acpi_disabled)
+		return -ENODEV;
+
+	ret = acpi_bus_register_driver(&leds_hp_driver);
+	if (ret < 0)
+		return ret;
+
+	printk(KERN_INFO DRIVER_NAME " driver loaded.\n");
+
+	return 0;
+}
+
+static void __exit hpled_exit_module(void)
+{
+	acpi_bus_unregister_driver(&leds_hp_driver);
+}
+
+MODULE_DESCRIPTION("Driver for HP disk protection LED");
+MODULE_AUTHOR("Pavel Machek <pavel@suse.cz>");
+MODULE_LICENSE("GPL");
+
+module_init(hpled_init_module);
+module_exit(hpled_exit_module);


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
