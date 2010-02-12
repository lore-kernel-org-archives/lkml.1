Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab0BLOLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:11:11 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:42337 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0BLOLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:11:09 -0500
X-Loopcount0: from 10.208.86.12
Message-ID: <4B75617B.4000805@dell.com>
Date: Fri, 12 Feb 2010 08:11:07 -0600
From: Bob Rodgers <Robert_Rodgers@dell.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>, "lenb@kernel.org" <lenb@kernel.org>,
       "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
       Linux-kernel <linux-kernel@vger.kernel.org>
CC: Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>,
       Bob Rodgers <Robert_Rodgers@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] v2 - Add Dell Business Class Netbook LED driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an LED driver to support the Dell Activity LED on the 
Dell Latitude 2100 netbook and future products to come. The Activity LED 
is visible externally in the lid so classroom instructors can observe it 
from a distance. The driver uses the sysfs led_class and provides a 
standard LED interface. This driver is ready for submission upstream.

Signed-off by: Bob Rodgers <Robert_Rodgers@dell.com>
Signed-off-by: Louis Davis <Louis_Davis@dell.com>
Signed-off-by: Jim Dailey <Jim_Dailey@dell.com>, Developers
Acked-by: Matthew Garrett <mjg@redhat.com>

---
Description of changes in v2:
1) Added X86 and ACPI_WMI dependencies to the Kconfig file.
2) Removed platform_driver and platform_device as they are not needed in this driver.

 drivers/leds/Kconfig    |    7 ++
 drivers/leds/Makefile   |    1 +
 drivers/leds/dell-led.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/dell-led.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 8a0e1ec..ce8ca57 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -269,6 +269,13 @@ config LEDS_ADP5520
 	  To compile this driver as a module, choose M here: the module will
 	  be called leds-adp5520.
 
+config LEDS_DELL_NETBOOKS
+	tristate "External LED on Dell Business Netbooks"
+	depends on LEDS_CLASS && X86 && ACPI_WMI
+	help
+	  This adds support for the Latitude 2100 and similar
+	  notebooks that have an external LED.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGERS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 9e63869..327bfa0 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_LEDS_REGULATOR)		+= leds-regulator.o
 obj-$(CONFIG_LEDS_INTEL_SS4200)		+= leds-ss4200.o
 obj-$(CONFIG_LEDS_LT3593)		+= leds-lt3593.o
 obj-$(CONFIG_LEDS_ADP5520)		+= leds-adp5520.o
+obj-$(CONFIG_LEDS_DELL_NETBOOKS)	+= dell-led.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff --git a/drivers/leds/dell-led.c b/drivers/leds/dell-led.c
new file mode 100644
index 0000000..5126c5c
--- /dev/null
+++ b/drivers/leds/dell-led.c
@@ -0,0 +1,200 @@
+/*
+ * dell_led.c - Dell LED Driver
+ *
+ * Copyright (C) 2010 Dell Inc.
+ * Louis Davis <louis_davis@dell.com>
+ * Jim Dailey <jim_dailey@dell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <linux/acpi.h>
+#include <linux/leds.h>
+
+MODULE_AUTHOR("Louis Davis/Jim Dailey");
+MODULE_DESCRIPTION("Dell LED Control Driver");
+MODULE_LICENSE("GPL");
+
+#define DELL_LED_BIOS_GUID "F6E4FE6E-909D-47cb-8BAB-C9F6F2F8D396"
+MODULE_ALIAS("wmi:" DELL_LED_BIOS_GUID);
+
+/* Error Result Codes: */
+#define INVALID_DEVICE_ID	250
+#define INVALID_PARAMETER	251
+#define INVALID_BUFFER		252
+#define INTERFACE_ERROR		253
+#define UNSUPPORTED_COMMAND	254
+#define UNSPECIFIED_ERROR	255
+
+/* Device ID */
+#define DEVICE_ID_PANEL_BACK	1
+
+/* LED Commands */
+#define CMD_LED_ON	16
+#define CMD_LED_OFF	17
+#define CMD_LED_BLINK	18
+
+struct bios_args {
+	unsigned char length;
+	unsigned char result_code;
+	unsigned char device_id;
+	unsigned char command;
+	unsigned char on_time;
+	unsigned char off_time;
+};
+
+static u8 dell_led_perform_fn(u8 length,
+		u8 result_code,
+		u8 device_id,
+		u8 command,
+		u8 on_time,
+		u8 off_time)
+{
+	struct bios_args *bios_return;
+	u8 return_code;
+	union acpi_object *obj;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_buffer input;
+
+	struct bios_args args;
+	args.length = length;
+	args.result_code = result_code;
+	args.device_id = device_id;
+	args.command = command;
+	args.on_time = on_time;
+	args.off_time = off_time;
+
+	input.length = sizeof(struct bios_args);
+	input.pointer = &args;
+
+	wmi_evaluate_method(DELL_LED_BIOS_GUID,
+		1,
+		1,
+		&input,
+		&output);
+
+	obj = output.pointer;
+
+	if (!obj || obj->type != ACPI_TYPE_BUFFER)
+		return -EINVAL;
+
+	bios_return = ((struct bios_args *)obj->buffer.pointer);
+	return_code = bios_return->result_code;
+
+	kfree(obj);
+
+	return return_code;
+}
+
+static u8 led_on(void)
+{
+	return dell_led_perform_fn(3,	/* Length of command */
+		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
+		DEVICE_ID_PANEL_BACK,	/* Device ID */
+		CMD_LED_ON,		/* Command */
+		0,			/* not used */
+		0);			/* not used */
+}
+
+static u8 led_off(void)
+{
+	return dell_led_perform_fn(3,	/* Length of command */
+		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
+		DEVICE_ID_PANEL_BACK,	/* Device ID */
+		CMD_LED_OFF,		/* Command */
+		0,			/* not used */
+		0);			/* not used */
+}
+
+static u8 led_blink(unsigned char on_eighths,
+		unsigned char off_eighths)
+{
+	return dell_led_perform_fn(5,	/* Length of command */
+		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
+		DEVICE_ID_PANEL_BACK,	/* Device ID */
+		CMD_LED_BLINK,		/* Command */
+		on_eighths,		/* blink on in eigths of a second */
+		off_eighths);		/* blink off in eights of a second */
+}
+
+static void dell_led_set(struct led_classdev *led_cdev,
+		enum led_brightness value)
+{
+	if (value == LED_OFF)
+		led_off();
+	else
+		led_on();
+}
+
+static int dell_led_blink(struct led_classdev *led_cdev,
+		unsigned long *delay_on,
+		unsigned long *delay_off)
+{
+	unsigned long on_eighths;
+	unsigned long off_eighths;
+
+	/* The Dell LED delay is based on 125ms intervals.
+	   Need to round up to next interval. */
+
+	on_eighths = (*delay_on + 124) / 125;
+	if (0 == on_eighths)
+		on_eighths = 1;
+	if (on_eighths > 255)
+		on_eighths = 255;
+	*delay_on = on_eighths * 125;
+
+	off_eighths = (*delay_off + 124) / 125;
+	if (0 == off_eighths)
+		off_eighths = 1;
+	if (off_eighths > 255)
+		off_eighths = 255;
+	*delay_off = off_eighths * 125;
+
+	led_blink(on_eighths, off_eighths);
+
+	return 0;
+}
+
+static struct led_classdev dell_led = {
+	.name		= "dell::lid",
+	.brightness	= LED_OFF,
+	.max_brightness = 1,
+	.brightness_set = dell_led_set,
+	.blink_set	= dell_led_blink,
+	.flags		= LED_CORE_SUSPENDRESUME,
+};
+
+static int __init dell_led_init(void)
+{
+	int error = 0;
+
+	if (!wmi_has_guid(DELL_LED_BIOS_GUID)) {
+		printk(KERN_DEBUG KBUILD_MODNAME
+			": could not find: DELL_LED_BIOS_GUID\n");
+		return -ENODEV;
+	}
+
+	error = led_off();
+	if (error != 0) {
+		printk(KERN_DEBUG KBUILD_MODNAME
+			": could not communicate with LED"
+			": error %d\n", error);
+		return -ENODEV;
+	}
+
+	return led_classdev_register(NULL, &dell_led);
+}
+
+static void __exit dell_led_exit(void)
+{
+	led_classdev_unregister(&dell_led);
+
+	led_off();
+}
+
+module_init(dell_led_init);
+module_exit(dell_led_exit);
-- 
1.6.6.1


