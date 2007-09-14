Return-Path: <linux-kernel-owner+w=401wt.eu-S1764682AbXINFbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764682AbXINFbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 01:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbXINFbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 01:31:05 -0400
Received: from mxsf09.insightbb.com ([74.128.0.79]:27624 "EHLO
	mxsf09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXINFbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 01:31:03 -0400
X-IronPort-AV: E=Sophos;i="4.20,253,1186372800"; 
   d="scan'208";a="55190194"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADa56UZKjlCP/2dsb2JhbACBWw
X-IronPort-AV: E=Sophos;i="4.20,253,1186372800"; 
   d="scan'208";a="77709142"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Fujitsu application panel driver (rev3)
Date: Fri, 14 Sep 2007 01:30:58 -0400
User-Agent: KMail/1.9.3
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net> <20070907120220.GB3901@ucw.cz> <20070912133836.5bc87768@oldman>
In-Reply-To: <20070912133836.5bc87768@oldman>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709140130.59732.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wednesday 12 September 2007 07:38, Stephen Hemminger wrote:
> This driver supports the application buttons on some Fujitsu Lifebook laptops.
> It is based on the earlier apanel driver done by Jochen Eisenger, but
> with many changes.  The original driver used ioctl's and a separate
> user space program;  see http://apanel.sourceforge.net/tech.php
> This version hooks into the input subsystem so that the normal
> Gnome/KDE shortcuts work without any userspace changes.
> 
> The Mail Led is handled via leds class device.
> 

Thank you very much for convering the led to led subsystem. I tried
implementing loadable keymap support in the driver, could you please
try the patch below and if it still works for you then I will apply
it to my tree.

Thank you again.

-- 
Dmitry

Subject: Fujitsu application panel driver (rev4)
From: Stephen Hemminger <shemminger@linux-foundation.org>

Input: add Fujitsu application panel driver

This driver supports the application buttons on some Fujitsu Lifebook
laptops. It is based on the earlier apanel driver done by Jochen Eisenger,
but with many changes. The original driver used ioctl's and a separate
user space program; see http://apanel.sourceforge.net/tech.php
This version hooks into the input subsystem so that the normal Gnome/KDE
shortcuts work without any userspace changes.

The Mail Led is handled via leds class device.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/misc/Kconfig  |   14 +
 drivers/input/misc/Makefile |    1 
 drivers/input/misc/apanel.c |  527 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 542 insertions(+)

Index: work/drivers/input/misc/Kconfig
===================================================================
--- work.orig/drivers/input/misc/Kconfig
+++ work/drivers/input/misc/Kconfig
@@ -40,6 +40,20 @@ config INPUT_M68K_BEEP
 	tristate "M68k Beeper support"
 	depends on M68K
 
+config INPUT_APANEL
+	tristate "Fujitsu Lifebook Application Panel buttons"
+	depends on X86
+	select I2C_I801
+	select INPUT_POLLDEV
+	select CHECK_SIGNATURE
+	help
+	  Say Y here for support of the Application Panel buttons, used on
+	  Fujitsu Lifebook. These are attached to the mainboard through
+	  an SMBus interface managed by the I2C Intel ICH (i801) driver.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called apanel.
+
 config INPUT_IXP4XX_BEEPER
 	tristate "IXP4XX Beeper support"
 	depends on ARCH_IXP4XX
Index: work/drivers/input/misc/Makefile
===================================================================
--- work.orig/drivers/input/misc/Makefile
+++ work/drivers/input/misc/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_INPUT_POWERMATE)		+= powerm
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
+obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
Index: work/drivers/input/misc/apanel.c
===================================================================
--- /dev/null
+++ work/drivers/input/misc/apanel.c
@@ -0,0 +1,527 @@
+/*
+ *  Fujitsu Lifebook Application Panel button drive
+ *
+ *  Copyright (C) 2007 Stephen Hemminger <shemminger@linux-foundation.org>
+ *  Copyright (C) 2001-2003 Jochen Eisinger <jochen@penguin-breeder.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Many Fujitsu Lifebook have a small panel of buttons that are
+ * accessible via the i2c/smbus interface. This driver polls those
+ * buttons and generates input events.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/dmi.h>
+#include <linux/platform_device.h>
+#include <linux/input-polldev.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/leds.h>
+
+#define APANEL_NAME	"Fujitsu Application Panel"
+#define APANEL_VERSION	"1.1"
+#define APANEL		"apanel"
+
+#ifndef pr_warn
+#define pr_warn(fmt, arg...) \
+	printk(KERN_WARNING fmt, ##arg)
+#endif
+
+struct keymap {
+	int bit;
+	unsigned int keycode;
+};
+
+static struct keymap app_media_keys[] __initdata = {
+	{ 0,	KEY_MAIL },
+	{ 1,	KEY_WWW },
+	{ 2,	KEY_PROG2 },
+	{ 3,	KEY_PROG1 },
+	{ 8,	KEY_FORWARD },
+	{ 9,	KEY_REWIND },
+	{ 10,	KEY_STOPCD },
+	{ 11,	KEY_PLAYPAUSE },
+	{ -1 }
+};
+
+static struct keymap four_keys[] __initdata = {
+	{ 0,	KEY_PROG4 },
+	{ 1,	KEY_PROG3 },
+	{ 2,	KEY_PROG2 },
+	{ 3,	KEY_PROG1 },
+	{ -1 }
+};
+
+static struct keymap *keymap;
+
+/* Copy the good keymap, as the original ones are free'd */
+static int __init apanel_copy_keymap(const struct keymap *src)
+{
+	const struct keymap *key;
+	unsigned int length = 1;
+
+	for (key = src; key->bit != -1; key++)
+		length++;
+
+	keymap = kmalloc(length * sizeof(struct keymap), GFP_KERNEL);
+	if (!keymap)
+		return -ENOMEM;
+
+	memcpy(keymap, src, length * sizeof(struct keymap));
+	return 0;
+}
+
+
+static int __init dmi_matched(struct dmi_system_id *dmi)
+{
+	apanel_copy_keymap(dmi->driver_data);
+	return 1;
+}
+
+/* List of systems known to work */
+static struct dmi_system_id  __initdata apanel_dmi_table[] = {
+	{
+		.callback = dmi_matched,
+		.ident = "Lifebook S",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook S Series"),
+		},
+		.driver_data = app_media_keys,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Lifebook B6210",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lifebook B6210"),
+		},
+		.driver_data = four_keys,
+	},
+	{ }
+};
+
+/* Magic constants in BIOS that tell about buttons */
+enum apanel_devid {
+	APANEL_DEV_NONE		= 0,
+	APANEL_DEV_APPBTN	= 1,
+	APANEL_DEV_CDBTN	= 2,
+	APANEL_DEV_LCD		= 3,
+	APANEL_DEV_LED		= 4,
+	APANEL_DEV_MAX,
+};
+
+enum apanel_chip {
+	CHIP_NONE	= 0,
+	CHIP_OZ992C	= 1,
+	CHIP_OZ163T	= 2,
+	CHIP_OZ711M3	= 4,
+};
+static enum apanel_chip device_chip[APANEL_DEV_MAX];
+
+/* names for APANEL_XXX */
+static const char *device_names[APANEL_DEV_MAX] = {
+	[APANEL_DEV_APPBTN]	= "Application Buttons",
+	[APANEL_DEV_LCD]	= "LCD",
+	[APANEL_DEV_LED]	= "LED",
+	[APANEL_DEV_CDBTN]	= "CD Buttons",
+};
+
+struct apanel {
+	struct input_polled_dev *ipdev;
+	struct i2c_client client;
+
+	u16 led_bits;
+	struct work_struct led_work;
+	struct led_classdev mail_led;
+
+	struct keymap keymap[0];
+};
+
+static int force;
+module_param(force, bool, 0);
+MODULE_PARM_DESC(force, "Load even if computer is not in database");
+
+static int apanel_probe(struct i2c_adapter *, int, int);
+
+/* for now, we only support one address */
+static unsigned short normal_i2c[] = {0, I2C_CLIENT_END};
+static unsigned short ignore = I2C_CLIENT_END;
+static struct i2c_client_address_data addr_data = {
+	.normal_i2c	= normal_i2c,
+	.probe		= &ignore,
+	.ignore		= &ignore,
+};
+
+/* Poll for key changes every 100ms
+ *
+ * Read Application keys via SMI
+ *  A (0x4), B (0x8), Internet (0x2), Email (0x1).
+ */
+static void report_key(struct input_dev *input, const struct keymap *key)
+{
+	input_event(input, EV_MSC, MSC_SCAN, key->bit);
+	input_report_key(input, key->keycode, 1);
+	input_sync(input);
+
+	input_event(input, EV_MSC, MSC_SCAN, key->bit);
+	input_report_key(input, key->keycode, 0);
+	input_sync(input);
+}
+
+static void apanel_poll(struct input_polled_dev *ipdev)
+{
+	struct apanel *ap = ipdev->private;
+	struct input_dev *idev = ipdev->input;
+	u8 cmd = device_chip[APANEL_DEV_APPBTN] == CHIP_OZ992C ? 0 : 8;
+	const struct keymap *key;
+	s32 data;
+
+	data = i2c_smbus_read_word_data(&ap->client, cmd);
+	if (data < 0) {
+		if (printk_ratelimit())
+			pr_info(APANEL ": smbus read error %d\n", data);
+		return;
+	}
+
+	/* write back to clear latch */
+	i2c_smbus_write_word_data(&ap->client, cmd, 0);
+
+	if (!data)
+		return;
+
+	pr_debug(APANEL ": poll data=%#x\n", data);
+	for (key = keymap; key->bit != -1; ++key)
+		if (data & (1UL << key->bit))
+			report_key(idev, key);
+}
+
+static struct keymap *apanel_get_key_by_bit(int bit)
+{
+	struct keymap *key;
+
+	for (key = keymap; key->bit != -1; key++)
+		if (bit == key->bit)
+			return key;
+
+	return NULL;
+}
+
+static struct keymap *apanel_get_key_by_keycode(int keycode)
+{
+	struct keymap *key;
+
+	for (key = keymap; key->bit != -1; key++)
+		if (keycode == key->keycode)
+			return key;
+
+	return NULL;
+}
+
+static int apanel_getkeycode(struct input_dev *dev, int scancode, int *keycode)
+{
+	const struct keymap *key = apanel_get_key_by_bit(scancode);
+
+	if (key) {
+		*keycode = key->keycode;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int apanel_setkeycode(struct input_dev *dev, int scancode, int keycode)
+{
+	struct keymap *key;
+	int old_keycode;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
+
+	key = apanel_get_key_by_bit(scancode);
+	if (key) {
+		old_keycode = key->keycode;
+		key->keycode = keycode;
+		set_bit(keycode, dev->keybit);
+		if (!apanel_get_key_by_keycode(old_keycode))
+			clear_bit(old_keycode, dev->keybit);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+/* Track state changes of LED */
+static void led_update(struct work_struct *work)
+{
+	struct apanel *ap = container_of(work, struct apanel, led_work);
+
+	i2c_smbus_write_word_data(&ap->client, 0x10, ap->led_bits);
+}
+
+static void mail_led_set(struct led_classdev *led,
+			 enum led_brightness value)
+{
+	struct apanel *ap = container_of(led, struct apanel, mail_led);
+	if (value)
+		ap->led_bits |= 0x8000;
+	else
+		ap->led_bits &= ~0x8000;
+	ap->led_bits = value;
+	schedule_work(&ap->led_work);
+}
+
+static int apanel_detach_client(struct i2c_client *client)
+{
+	struct apanel *ap = i2c_get_clientdata(client);
+
+	if (device_chip[APANEL_DEV_LED] != CHIP_NONE)
+		led_classdev_unregister(&ap->mail_led);
+
+	input_unregister_polled_device(ap->ipdev);
+	i2c_detach_client(&ap->client);
+	input_free_polled_device(ap->ipdev);
+	kfree(ap);
+	return 0;
+}
+
+/* Function is invoked for every i2c adapter. */
+static int apanel_attach_adapter(struct i2c_adapter *adap)
+{
+	pr_debug(APANEL ": attach adapter id=%d\n", adap->id);
+
+	/* Our device is connected only to i801 on laptop */
+	if (adap->id != I2C_HW_SMBUS_I801)
+		return -ENODEV;
+
+	return i2c_probe(adap, &addr_data, apanel_probe);
+}
+
+static struct i2c_driver apanel_driver = {
+	.driver = {
+		.name = APANEL,
+	},
+	.attach_adapter = &apanel_attach_adapter,
+	.detach_client  = &apanel_detach_client,
+};
+
+/*
+  basically this function should probe the i2c client, but we know that it has
+  to be the one we're looking for.
+ */
+static int apanel_probe(struct i2c_adapter *bus, int address, int kind)
+{
+	struct apanel *ap;
+	const struct keymap *key;
+	struct input_polled_dev *ipdev;
+	struct input_dev *idev;
+	u8 cmd = device_chip[APANEL_DEV_APPBTN] == CHIP_OZ992C ? 0 : 8;
+	int err = -ENOMEM;
+
+	pr_debug(APANEL ": probe adapter %p addr %d kind %d\n",
+		 bus, address, kind);
+
+	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
+	if (!ap)
+		goto out0;
+
+	ipdev = input_allocate_polled_device();
+	if (!ipdev)
+		goto out1;
+
+	ap->ipdev = ipdev;
+	ap->client.adapter = bus;
+	ap->client.addr = address;
+	ap->client.driver = &apanel_driver;
+	strlcpy(ap->client.name, APANEL, I2C_NAME_SIZE);
+	i2c_set_clientdata(&ap->client, ap);
+
+	err = i2c_attach_client(&ap->client);
+	if (err)
+		goto out2;
+
+	err = i2c_smbus_write_word_data(&ap->client, cmd, 0);
+	if (err) {
+		pr_warn(APANEL ": smbus write error %d\n", err);
+		goto out3;
+	}
+
+	ipdev->poll = apanel_poll;
+	ipdev->poll_interval = 1000;	/* 1 sec (power save) */
+	ipdev->private = ap;
+
+	idev = ipdev->input;
+	idev->name = APANEL_NAME " buttons";
+	idev->phys = "apanel/input0";
+	idev->id.bustype = BUS_HOST;
+	idev->dev.parent = &ap->client.dev;
+	idev->getkeycode = apanel_getkeycode;
+	idev->setkeycode = apanel_setkeycode;
+
+	__set_bit(EV_KEY, idev->evbit);
+	for (key = keymap; key->bit != -1; ++key)
+		__set_bit(key->keycode, idev->keybit);
+
+	input_set_capability(idev, EV_MSC, MSC_SCAN);
+
+	err = input_register_polled_device(ipdev);
+	if (err)
+		goto out3;
+
+	INIT_WORK(&ap->led_work, led_update);
+	if (device_chip[APANEL_DEV_LED] != CHIP_NONE) {
+		ap->mail_led.name = APANEL ":mail";
+		ap->mail_led.brightness_set = mail_led_set;
+
+		err = led_classdev_register(&ap->client.dev, &ap->mail_led);
+		if (err)
+			goto out4;
+	}
+
+	return 0;
+out4:
+	input_unregister_polled_device(ipdev);
+out3:
+	i2c_detach_client(&ap->client);
+out2:
+	input_free_polled_device(ipdev);
+out1:
+	kfree(ap);
+out0:
+	return err;
+}
+
+/* Scan the system ROM for the signature "FJKEYINF" */
+static __init const void __iomem *bios_signature(const void __iomem *bios)
+{
+	ssize_t offset;
+	const unsigned char signature[] = "FJKEYINF";
+
+	for (offset = 0; offset < 0x10000; offset += 0x10) {
+		if (check_signature(bios + offset, signature,
+				    sizeof(signature)-1))
+			return bios + offset;
+	}
+
+	pr_warn(APANEL ": Fujitsu BIOS signature '%s' not found...\n",
+	       signature);
+	return NULL;
+}
+
+static int __init apanel_init(void)
+{
+	void __iomem *bios;
+	const void __iomem *p;
+	u8 devno;
+	int error;
+	int found = 0;
+
+	if (!dmi_check_system(apanel_dmi_table)) {
+		pr_warn(APANEL ": DMI information does not match\n");
+		if (!force)
+			return -ENODEV;
+	}
+
+	if (!keymap) {
+		/* default key map */
+		error = apanel_copy_keymap(four_keys);
+		if (error) {
+			printk(KERN_ERR APANEL ": can't copy keymap, "
+				"error %d\n", error);
+			return error;
+		}
+	}
+
+	bios = ioremap(0xF0000, 0x10000); /* Can't fail */
+
+	p = bios_signature(bios);
+	if (!p) {
+		iounmap(bios);
+		error = -ENODEV;
+		goto fail;
+	}
+
+	/* just use the first address */
+	p += 8;
+	normal_i2c[0] = readb(p+3) >> 1;
+
+	for ( ; (devno = readb(p)) & 0x7f; p += 4) {
+		unsigned char method, slave, chip;
+
+		method = readb(p + 1);
+		chip = readb(p + 2);
+		slave = readb(p + 3) >> 1;
+
+		if (slave != normal_i2c[0]) {
+			printk(KERN_ERR APANEL ": only one SMBus slave "
+				 "address supported, skiping device...\n");
+			continue;
+		}
+
+		/* translate alternative device numbers */
+		switch (devno) {
+		case 6:
+			devno = APANEL_DEV_APPBTN;
+			break;
+		case 7:
+			devno = APANEL_DEV_LED;
+			break;
+		}
+
+		if (devno >= APANEL_DEV_MAX)
+			pr_warn(APANEL ": unknown device %d found\n", devno);
+		else if (device_chip[devno] != CHIP_NONE)
+			printk(KERN_ERR APANEL ": duplicate entry for %s\n",
+			       device_names[devno]);
+
+		else if (method != 1 && method != 2 && method != 4) {
+			printk(KERN_ERR APANEL ": unknown  method %u for %s\n",
+			       method, device_names[devno]);
+		} else {
+			pr_debug(APANEL ": %s found, chip=%d\n",
+				 device_names[devno], chip);
+
+			device_chip[devno] = (enum apanel_chip) chip;
+			++found;
+		}
+	}
+	iounmap(bios);
+
+	if (found == 0) {
+		printk(KERN_ERR APANEL ": no input devices reported by BIOS\n");
+		error = -EIO;
+		goto fail;
+	}
+
+	error = i2c_add_driver(&apanel_driver);
+	if (error)
+		goto fail;
+
+	return 0;
+
+ fail:
+	kfree(keymap);
+	return error;
+}
+
+module_init(apanel_init);
+
+static void __exit apanel_cleanup(void)
+{
+	i2c_del_driver(&apanel_driver);
+	kfree(keymap);
+}
+module_exit(apanel_cleanup);
+
+MODULE_AUTHOR("Stephen Hemminger <shemminger@osdl.org>");
+MODULE_DESCRIPTION(APANEL_NAME " driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(APANEL_VERSION);
+
+MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBookSSeries:pvr*:rvnFUJITSU:*");
+MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBookB6210:pvr*:rvnFUJITSU:*");
