Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbYFEWel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbYFEWel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYFEWee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:34:34 -0400
Received: from 81.184.114.62.dyn.user.ono.com ([81.184.114.62]:59965 "EHLO
	pof.eslack.org." rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org
	with ESMTP id S1751424AbYFEWec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:34:32 -0400
Message-ID: <4848683E.4070709@eslack.org>
Date: Fri, 06 Jun 2008 00:27:10 +0200
From: Pau Oliva Fora <pau@eslack.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@osdl.org>, Torokhov <dmitry.torokhov@gmail.com>,
       Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Pavel Machek <pavel@suse.cz>, Yan@ATrpms.net, Dmitry@ATrpms.net,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [lm-sensors] [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection
 System 3D ACPI driver -- please review!
References: <1212235533.3815.5.camel@localhost>	<4846EBF5.2030406@tremplin-utc.net>	<20080604225830.1dff64fc@hyperion.delvare>	<20080604230510.GB30475@elf.ucw.cz>	<484728B2.1000209@tremplin-utc.net> <20080605082950.6957f1a2@hyperion.delvare> <4847B415.2080708@cam.ac.uk> <48484DD6.3050706@tremplin-utc.net>
In-Reply-To: <48484DD6.3050706@tremplin-utc.net>
X-Enigmail-Version: 0.95.6
OpenPGP: id=33539E02
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pau Oliva Fora <pau@eslack.org>

Add support for HTC Shift UMPC G-Sensor LIS3LV02DL accelerometer.

Signed-off-by: Pau Oliva Fora <pau@eslack.org>

---

Éric Piel wrote:
> 05-06-08 11:38, Jonathan Cameron wrote/a écrit:
>> Also, the LI3L02DQ (very similar to the chip you are using) is one of my
>> test chips, so combining the two drivers should be straight forward.
>> Also the driver I have is SPI only, so this may give us an easy way to
>> test a combined driver.
> For now I'll go back to the drawing board (with Yan) in order to address
> the comments received, all very insightful. I'll also go around the
> other versions of the driver to pick up the nice parts. Looking at the
> openmoko driver, I finally understood how to avoid polling. It will
> likely be worthy :-)
> In addition, I'll try to make the main functions as independent as
> possible of the platform, hoping that we can then easily merge the SPI
> and the ACPI versions together.

Here's an i2c version of the driver for the LIS3LV02DL accelerometer,
please try to combine it too, so we'll end up having ACPI, SPI and I2C.


Patch against linux-2.6.26-rc5, should apply clean on other versions too.


diff -uprN linux-2.6.26-rc5/drivers/input/joystick/htcgsensor.c linux/drivers/input/joystick/htcgsensor.c
--- linux-2.6.26-rc5/drivers/input/joystick/htcgsensor.c	1970-01-01 01:00:00.000000000 +0100
+++ linux/drivers/input/joystick/htcgsensor.c	2008-06-05 23:56:58.000000000 +0200
@@ -0,0 +1,303 @@
+/*
+ * HTC Shift G-Sensor Joystick driver
+ * The G-Sensor chip is a STMicroelectronics LIS3LV02DL connected via i2c
+ *
+ * Copyright (C) 2008 Pau Oliva Fora <pof@eslack.org>
+ *
+ * Based on:
+ * 	mdps.c - HP Mobile Data Protection System 3D ACPI driver
+ * 	ams.c  - Apple Motion Sensor driver
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/input-polldev.h>
+#include <linux/dmi.h>
+
+#define GSENSOR_WHO_AM_I        0x0F /*r      00111010 */
+#define GSENSOR_CTRL_REG1       0x20 /*rw     00000111 */
+#define GSENSOR_CTRL_REG2       0x21 /*rw     00000000 */
+#define GSENSOR_CTRL_REG3       0x22 /*rw     00001000 */
+#define GSENSOR_OUTX_L          0x28 /*r               */
+#define GSENSOR_OUTX_H          0x29 /*r               */
+#define GSENSOR_OUTY_L          0x2A /*r               */
+#define GSENSOR_OUTY_H          0x2B /*r               */
+#define GSENSOR_OUTZ_L          0x2C /*r               */
+#define GSENSOR_OUTZ_H          0x2D /*r               */
+
+#define GSENSOR_ID		0x3A /* GSENSOR_WHO_AM_I */
+
+#define AXIS_MAX		16384
+
+MODULE_DESCRIPTION("HTC Shift G-Sensor driver");
+MODULE_AUTHOR("Pau Oliva Fora <pof@eslack.org>");
+MODULE_LICENSE("GPL");
+
+static unsigned int invert_x;
+module_param(invert_x, bool, 0644);
+MODULE_PARM_DESC(invert_x, "Invert input data on X axis");
+
+static unsigned int invert_y;
+module_param(invert_y, bool, 0644);
+MODULE_PARM_DESC(invert_y, "Invert input data on Y axis");
+
+static unsigned int swap_xy;
+module_param(swap_xy, bool, 0644);
+MODULE_PARM_DESC(swap_xy, "Swap X and Y axis");
+
+static struct dmi_system_id __initdata htcshift_dmi_table[] = {
+	{
+		.ident = "Shift",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "High Tech Computer Corp"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Shift"),
+		},
+	},
+	{ }
+};
+
+struct gsensor {
+	char			init;		/* has it been initialized ? */
+	int			bus;		/* i2c bus */
+	int			address;	/* i2c address */
+	struct i2c_client	client;		/* i2c client */
+	struct input_polled_dev	*idev;		/* input device */
+	int			xcalib;		/* x calibrated null value */
+	int			ycalib;		/* y calibrated null value */
+	int			zcalib;		/* z calibrated null value */
+};
+
+static struct gsensor gsensor;
+
+static int gsensor_attach(struct i2c_adapter *adapter);
+static int gsensor_detach(struct i2c_adapter *adapter);
+#ifdef CONFIG_PM
+static int gsensor_suspend(struct i2c_client *adapter, pm_message_t state);
+static int gsensor_resume(struct i2c_client *adapter);
+#endif
+
+static struct i2c_driver gsensor_driver = {
+	.driver = {
+		.name	= "gsensor",
+		.owner	= THIS_MODULE,
+	},
+	.attach_adapter	= gsensor_attach,
+	.detach_adapter	= gsensor_detach,
+#ifdef CONFIG_PM
+	.suspend        = gsensor_suspend,
+	.resume         = gsensor_resume,
+#endif
+};
+
+static inline int gsensor_read(int reg)
+{
+	return i2c_smbus_read_byte_data(&gsensor.client, reg);
+}
+
+static inline int gsensor_write(int reg, int value)
+{
+	return i2c_smbus_write_byte_data(&gsensor.client, reg, value);
+}
+
+static void gsensor_sensors(short *x, short *y, short *z)
+{
+	int xh, xl, yh, yl, zh, zl;
+	short tmp;
+
+	xh = gsensor_read(GSENSOR_OUTX_L);
+	xl = gsensor_read(GSENSOR_OUTX_H);
+	*x = (xh << 8) | (xl);
+
+	yh = gsensor_read(GSENSOR_OUTY_L);
+	yl = gsensor_read(GSENSOR_OUTY_H);
+	*y = (yh << 8) | (yl);
+
+	zh = gsensor_read(GSENSOR_OUTZ_L);
+	zl = gsensor_read(GSENSOR_OUTZ_H);
+	*z = (zh << 8) | (zl);
+
+	if (swap_xy) {
+		tmp = *x;
+		*x = *y;
+		*y = tmp;
+	}
+
+	/* printk(KERN_DEBUG "gsensor: Sensors (%d, %d, %d)\n", x, y, z); */
+}
+
+static void gsensor_idev_poll(struct input_polled_dev *dev)
+{
+	struct input_dev *idev = dev->input;
+	short x, y, z;
+
+	gsensor_sensors(&x, &y, &z);
+
+	x -= gsensor.xcalib;
+	y -= gsensor.ycalib;
+	z -= gsensor.zcalib;
+
+	input_report_abs(idev, ABS_X, invert_x ? -x : x);
+	input_report_abs(idev, ABS_Y, invert_y ? -y : y);
+	input_report_abs(idev, ABS_Z, z);
+	input_sync(idev);
+}
+
+static void gsensor_joystick_enable(void)
+{
+	short x, y, z;
+	struct input_dev *input;
+
+	if (gsensor.idev) {
+		printk(KERN_INFO "gsensor: joystick already enabled\n");
+		return;
+	}
+
+	gsensor_sensors(&x, &y, &z);
+	gsensor.xcalib = x;
+	gsensor.ycalib = y;
+	gsensor.zcalib = z;
+
+	gsensor.idev = input_allocate_polled_device();
+	if (!gsensor.idev) {
+		printk(KERN_INFO "gsensor: can't allocate input dev\n");
+		return;
+	}
+
+	gsensor.idev->poll = gsensor_idev_poll;
+	gsensor.idev->poll_interval = 30;
+
+	input = gsensor.idev->input;
+	input->name = "HTC G-Sensor";
+	input->id.bustype = BUS_I2C;
+
+	input_set_abs_params(input, ABS_X, -AXIS_MAX, AXIS_MAX, 9, 0);
+	input_set_abs_params(input, ABS_Y, -AXIS_MAX, AXIS_MAX, 9, 0);
+	input_set_abs_params(input, ABS_Z, -AXIS_MAX, AXIS_MAX, 9, 0);
+	set_bit(EV_ABS, input->evbit);
+
+	if (input_register_polled_device(gsensor.idev)) {
+		printk(KERN_INFO "gsensor: can't register input dev\n");
+		input_free_polled_device(gsensor.idev);
+		gsensor.idev = NULL;
+		return;
+	}
+}
+
+static void gsensor_joystick_disable(void)
+{
+	if (gsensor.idev) {
+		input_unregister_polled_device(gsensor.idev);
+		input_free_polled_device(gsensor.idev);
+		gsensor.idev = NULL;
+	}
+}
+
+static inline void gsensor_poweron(void)
+{
+	/* device on, decimate by 512, X, Y and Z axis enabled */
+	gsensor_write(GSENSOR_CTRL_REG1, 0x47);
+
+	/* scale +-2g, BDU non continuous, big endian, 3-wire,
+	 * alignment 16-bit left */
+	gsensor_write(GSENSOR_CTRL_REG2, 0x63);
+}
+
+
+static inline void gsensor_poweroff(void)
+{
+	/* disable X,Y,Z axis and power off */
+	gsensor_write(GSENSOR_CTRL_REG1, 0x00);
+}
+
+#ifdef CONFIG_PM
+static int gsensor_suspend(struct i2c_client *adapter, pm_message_t state)
+{
+	gsensor_poweroff();
+	return 0;
+}
+
+static int gsensor_resume(struct i2c_client *adapter)
+{
+	gsensor_poweron();
+	return 0;
+}
+#endif
+
+static int gsensor_attach(struct i2c_adapter *adapter)
+{
+	if (gsensor.init)
+		return 0;
+
+	gsensor.client.addr = gsensor.address;
+	gsensor.client.adapter = adapter;
+	gsensor.client.driver = &gsensor_driver;
+	strcpy(gsensor.client.name, "HTC G-Sensor");
+
+	if (gsensor_read(GSENSOR_WHO_AM_I) != GSENSOR_ID) {
+		printk(KERN_INFO "gsensor: invalid device\n");
+		return -ENODEV;
+	}
+
+	gsensor_poweron();
+
+	if (i2c_attach_client(&gsensor.client)) {
+		printk(KERN_INFO "gsensor: i2c attach client failed\n");
+		return -ENODEV;
+	}
+
+	gsensor_joystick_enable();
+	gsensor.init = 1;
+	printk(KERN_INFO "gsensor: HTC G-Sensor enabled\n");
+
+	return 0;
+}
+
+static int gsensor_detach(struct i2c_adapter *adapter)
+{
+	if (!gsensor.init) {
+		printk(KERN_INFO "gsensor: already disabled\n");
+		return 0;
+	}
+
+	gsensor_poweroff();
+	gsensor_joystick_disable();
+	i2c_detach_client(&gsensor.client);
+	gsensor.init = 0;
+
+	printk(KERN_INFO "gsensor: HTC G-Sensor disabled\n");
+
+	return 0;
+}
+
+static int __init gsensor_init(void)
+{
+	gsensor.bus = 0;
+	gsensor.address = 0x1d;
+
+	if (dmi_check_system(htcshift_dmi_table)) {
+		invert_x = 1;
+		invert_y = 1;
+		swap_xy = 1;
+	}
+
+	if (i2c_add_driver(&gsensor_driver) < 0)
+		return -ENODEV;
+
+	return 0;
+}
+
+static void __exit gsensor_exit(void)
+{
+	i2c_del_driver(&gsensor_driver);
+}
+
+module_init(gsensor_init);
+module_exit(gsensor_exit);
diff -uprN linux-2.6.26-rc5/drivers/input/joystick/Kconfig linux/drivers/input/joystick/Kconfig
--- linux-2.6.26-rc5/drivers/input/joystick/Kconfig	2008-06-06 00:04:36.000000000 +0200
+++ linux/drivers/input/joystick/Kconfig	2008-06-06 00:02:46.000000000 +0200
@@ -100,6 +100,16 @@ config JOYSTICK_GUILLEMOT
  	  To compile this driver as a module, choose M here: the
  	  module will be called guillemot.

+config JOYSTICK_HTCGSENSOR
+	tristate "HTC Shift G-Sensor accelerometer"
+	depends on I2C
+	help
+	  Say Y here if you have an HTC Shift UMPC and want to use
+	  the integrated LIS3LV02DL accelerometer as a joystick.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called htcgsensor.
+
  config JOYSTICK_INTERACT
  	tristate "InterAct digital joysticks and gamepads"
  	select GAMEPORT
diff -uprN linux-2.6.26-rc5/drivers/input/joystick/Makefile linux/drivers/input/joystick/Makefile
--- linux-2.6.26-rc5/drivers/input/joystick/Makefile	2008-06-06 00:04:36.000000000 +0200
+++ linux/drivers/input/joystick/Makefile	2008-06-05 23:56:31.000000000 +0200
@@ -15,6 +15,7 @@ obj-$(CONFIG_JOYSTICK_GF2K)		+= gf2k.o
  obj-$(CONFIG_JOYSTICK_GRIP)		+= grip.o
  obj-$(CONFIG_JOYSTICK_GRIP_MP)		+= grip_mp.o
  obj-$(CONFIG_JOYSTICK_GUILLEMOT)	+= guillemot.o
+obj-$(CONFIG_JOYSTICK_HTCGSENSOR)	+= htcgsensor.o
  obj-$(CONFIG_JOYSTICK_IFORCE)		+= iforce/
  obj-$(CONFIG_JOYSTICK_INTERACT)		+= interact.o
  obj-$(CONFIG_JOYSTICK_JOYDUMP)		+= joydump.o


