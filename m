Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0BQVXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:23:35 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:25949 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab0BQVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:23:34 -0500
X-Loopcount0: from 10.208.86.12
Message-ID: <4B7C5E53.3030702@dell.com>
Date: Wed, 17 Feb 2010 15:23:31 -0600
From: Bob Rodgers <Robert_Rodgers@dell.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
       "lenb@kernel.org" <lenb@kernel.org>
CC: Louis Davis <Louis_Davis@dell.com>, Jim Dailey <Jim_Dailey@dell.com>,
       Bob Rodgers <Robert_Rodgers@dell.com>,
       Mario Limonciello <Mario_Limonciello@dell.com>,
       Michael Brown <Michael_E_Brown@dell.com>,
       Matt Domsch <Matt_Domsch@dell.com>, Dan Carpenter <error27@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] v3 - Add Dell Business Class Netbook LED driver
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
Description of changes in v3:
1) Better error handling for wmi_evaluate_method()
2) Eliminated leak of obj when obj is not NULL and is not a buffer.
3) Removed printk() as they were only helpful in debugging.
4) Removed #include <linux/platform_device.h>

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
index 0000000..ee31089
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
+static int dell_led_perform_fn(u8 length,
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
+	acpi_status status;
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
+	status = wmi_evaluate_method(DELL_LED_BIOS_GUID,
+		1,
+		1,
+		&input,
+		&output);
+
+	if (ACPI_FAILURE(status))
+		return status;
+
+	obj = output.pointer;
+
+	if (!obj)
+		return -EINVAL;
+	else if (obj->type != ACPI_TYPE_BUFFER) {
+		kfree(obj);
+		return -EINVAL;
+	}
+
+	bios_return = ((struct bios_args *)obj->buffer.pointer);
+	return_code = bios_return->result_code;
+
+	kfree(obj);
+
+	return return_code;
+}
+
+static int led_on(void)
+{
+	return dell_led_perform_fn(3,	/* Length of command */
+		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
+		DEVICE_ID_PANEL_BACK,	/* Device ID */
+		CMD_LED_ON,		/* Command */
+		0,			/* not used */
+		0);			/* not used */
+}
+
+static int led_off(void)
+{
+	return dell_led_perform_fn(3,	/* Length of command */
+		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
+		DEVICE_ID_PANEL_BACK,	/* Device ID */
+		CMD_LED_OFF,		/* Command */
+		0,			/* not used */
+		0);			/* not used */
+}
+
+static int led_blink(unsigned char on_eighths,
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
+	if (!wmi_has_guid(DELL_LED_BIOS_GUID))
+		return -ENODEV;
+
+	error = led_off();
+	if (error != 0)
+		return -ENODEV;
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


