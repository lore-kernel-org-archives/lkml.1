Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbXGBSSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbXGBSSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 14:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXGBSSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 14:18:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062AbXGBSSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 14:18:33 -0400
Date: Mon, 2 Jul 2007 11:17:24 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] fujtisu application panel driver
Message-ID: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports the application buttons on some Fujitsu Lifebook laptops.
These buttons are read via the SMBus, for more details see:
	http://apanel.sourceforge.net/tech.php
The buttons are handled as by the regular input system.
Two models are detected now, but other Fujitsu laptop's have
keys that may work similarly.

It is based on the earlier apanel driver done by Jochen Eisenger, but
with many changes.  The original driver used ioctl's and a separate
user space program; this version hooks into the input subsystem so
that the normal Gnome/KDE shortcuts work without any userspace
changes.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

---
 drivers/input/misc/Kconfig  |   12 +
 drivers/input/misc/Makefile |    1 
 drivers/input/misc/apanel.c |  448 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 461 insertions(+)

--- a/drivers/input/misc/Kconfig	2007-06-27 16:50:36.000000000 -0400
+++ b/drivers/input/misc/Kconfig	2007-06-30 10:04:19.000000000 -0400
@@ -40,6 +40,19 @@ config INPUT_M68K_BEEP
 	tristate "M68k Beeper support"
 	depends on M68K
 
+config INPUT_APANEL
+	tristate "Fujitsu Lifebook Application Panel buttons"
+	depends on X86
+	select I2C_I801
+	select INPUT_POLLDEV
+	help
+	 Say Y here for support of the Application Panel buttons, used on
+	 Fujitsu Lifebook. These are attached to the mainboard through
+	 an SMBus interface managed by the I2C Intel ICH (i801) driver.
+
+	 To compile this driver as a module, choose M here: the module will
+	 be called apanel.
+
 config INPUT_IXP4XX_BEEPER
 	tristate "IXP4XX Beeper support"
 	depends on ARCH_IXP4XX
--- a/drivers/input/misc/Makefile	2007-06-27 16:50:36.000000000 -0400
+++ b/drivers/input/misc/Makefile	2007-06-30 10:01:57.000000000 -0400
@@ -18,3 +18,4 @@ obj-$(CONFIG_INPUT_POWERMATE)		+= powerm
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
+obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/input/misc/apanel.c	2007-07-01 14:32:29.000000000 -0400
@@ -0,0 +1,394 @@
+/*
+ *   SMBus client for the Fujitsu Lifebook Application Panel
+ *
+ *  Copyright (C) 2007 Stephen Hemminger <shemminger@osdl.org>
+ *  Copyright (C) 2001-2003 Jochen Eisinger <jochen@penguin-breeder.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/dmi.h>
+#include <linux/input-polldev.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+
+struct keymap {
+	u32 mask;
+	u8 keycode;
+};
+
+static struct keymap app_media_keys[] = {
+	{ 0x1, 	 KEY_MAIL },
+	{ 0x2,	 KEY_WWW },
+	{ 0x4,	 KEY_PROG2 },
+	{ 0x8,	 KEY_PROG1 },
+	{ 0x100, KEY_FORWARD },
+	{ 0x200, KEY_REWIND },
+	{ 0x400, KEY_STOPCD },
+	{ 0x800, KEY_PLAYPAUSE },
+	{ 0 }
+};
+
+static struct keymap four_keys[] = {
+	{ 0x1, 	KEY_PROG4 },
+	{ 0x2,	KEY_PROG3 },
+	{ 0x4,	KEY_PROG2 },
+	{ 0x8,	KEY_PROG1 },
+	{ 0 }
+};
+
+static const struct keymap *keymap;
+
+static int __init dmi_matched(struct dmi_system_id *dmi)
+{
+	keymap = dmi->driver_data;
+	return 1;
+}
+
+/* List of systems known to work */
+static struct dmi_system_id apanel_dmi_table[] __initdata = {
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
+enum apanel_devid {
+	APANEL_DEV_NONE	 = 0,
+	APANEL_DEV_APPBTN= 1,
+	APANEL_DEV_CDBTN = 2,
+	APANEL_DEV_LCD	 = 3,
+	APANEL_DEV_LED	 = 4,
+
+	APANEL_DEV_MAX,
+};
+
+enum apanel_chip {
+	CHIP_NONE   = 0,
+	CHIP_OZ992C = 1,
+	CHIP_OZ163T = 2,
+	CHIP_OZ711M3= 4,
+};
+static enum apanel_chip device_chip[APANEL_DEV_MAX];
+
+static const char *device_names[APANEL_DEV_MAX] = {
+	[APANEL_DEV_APPBTN] = "Application Buttons",
+	[APANEL_DEV_LCD]    = "LCD",
+	[APANEL_DEV_LED]    = "LED",
+	[APANEL_DEV_CDBTN]  = "CD Buttons",
+};
+
+struct apanel {
+	struct input_polled_dev *ipdev;
+	struct i2c_client client;
+	struct work_struct led_work;
+};
+
+MODULE_AUTHOR("Stephen Hemminger <shemminger@osdl.org>");
+MODULE_DESCRIPTION("Fujitsu Lifebook Application Panel driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.3");
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
+static void report_key(struct input_dev *input,unsigned keycode)
+{
+	input_report_key(input, keycode, 1);
+	input_sync(input);
+	input_report_key(input, keycode, 0);
+	input_sync(input);
+}
+
+static void apanel_poll(struct input_polled_dev *ipdev)
+{
+	struct apanel *ap = ipdev->private;
+	u8 cmd = device_chip[APANEL_DEV_APPBTN] == CHIP_OZ992C ? 0 : 8;
+	const struct keymap *key;
+	s32 data;
+
+	data = i2c_smbus_read_word_data(&ap->client, cmd);
+	if (data < 0) {
+		if (printk_ratelimit())
+			printk(KERN_DEBUG "apanel: smbus read error %d\n", data);
+		return;
+	}
+
+	/* write back to clear latch */
+	i2c_smbus_write_word_data(&ap->client, cmd, 0);
+
+	if (!data)
+		return;
+
+	dev_dbg(&ap->client.dev, "poll data=%#x\n", data);
+	for (key = keymap; key->mask; ++key)
+		if (data & key->mask)
+			report_key(ap->ipdev->input, key->keycode);
+}
+
+/* Track state changes of LED
+ * There are actually four LED's (A, B, Internet, E-Mail),
+ * unsure about how to access others and what LED_xxx value would be useful.
+ */
+static void apanel_led(struct work_struct *work)
+{
+	struct apanel *ap = container_of(work, struct apanel, led_work);
+
+	i2c_smbus_write_word_data(&ap->client, 0x10,
+				  test_bit(LED_MAIL, ap->ipdev->input->led)
+				  ? 0x8000 : 0);
+}
+
+/* Callback from input layer when state change happens.
+ * Used to handle LED control.
+ */
+static int apanel_event(struct input_dev *dev, unsigned int type,
+			unsigned int code, int value)
+{
+	struct apanel *ap = dev->private;
+
+	if (device_chip[APANEL_DEV_LED] == CHIP_NONE || type != EV_LED)
+		return -1;
+
+	schedule_work(&ap->led_work);
+	return 0;
+}
+
+static int apanel_detach_client(struct i2c_client *client)
+{
+	struct apanel *ap = i2c_get_clientdata(client);
+
+	input_unregister_polled_device(ap->ipdev);
+	i2c_detach_client(&ap->client);
+	kfree(ap);
+	return 0;
+}
+
+/* Function is invoked for every i2c adapter. */
+static int apanel_attach_adapter(struct i2c_adapter *adap)
+{
+	/* Our device is connected only to i801 on laptop */
+	if (adap->id != I2C_HW_SMBUS_I801)
+		return -ENODEV;
+
+	return i2c_probe(adap, &addr_data, apanel_probe);
+}
+
+static struct i2c_driver apanel_driver = {
+	.driver = {
+		.name = "apanel",
+	},
+	.attach_adapter = &apanel_attach_adapter,
+	.detach_client  = &apanel_detach_client,
+};
+
+/*
+  basically this function should probe the i2c client, but we know that it has
+  to be the one we're looking for.
+ */
+static int apanel_probe(struct i2c_adapter *adap, int addr, int kind)
+{
+	struct apanel *ap;
+	const struct keymap *key;
+	struct input_polled_dev *ipdev;
+	u8 cmd = device_chip[APANEL_DEV_APPBTN] == CHIP_OZ992C ? 0 : 8;
+	int err = -ENOMEM;
+
+	ap = kzalloc(sizeof(*ap), GFP_KERNEL);
+	if (!ap)
+		goto out0;
+
+	dev_dbg(&ap->client.dev, "probe adapter %p addr %d kind %d\n",
+		 adap, addr, kind);
+
+	ipdev = input_allocate_polled_device();
+	if (!ipdev)
+		goto out1;
+
+	ap->ipdev = ipdev;
+	ap->client.adapter = adap;
+	ap->client.addr = addr;
+	strncpy(ap->client.name, "apanel", I2C_NAME_SIZE);
+	ap->client.driver = &apanel_driver;
+
+	INIT_WORK(&ap->led_work, apanel_led);
+	i2c_set_clientdata(&ap->client, ap);
+
+	i2c_smbus_write_word_data(&ap->client, cmd, 0);
+
+	ipdev->private = ap;
+	ipdev->poll = apanel_poll;
+	ipdev->poll_interval = 500;
+
+	ipdev->input->name = "Lifebook Panel buttons";
+	ipdev->input->phys = "apanel/input0";
+	ipdev->input->id.bustype = BUS_HOST;
+	ipdev->input->cdev.dev = &ap->client.dev;
+	ipdev->input->private = ap;
+	ipdev->input->evbit[LONG(EV_KEY)] = BIT(EV_KEY);
+
+	for (key = keymap; key->mask; ++key)
+		set_bit(key->keycode, ipdev->input->keybit);
+
+	if (device_chip[APANEL_DEV_LED] != CHIP_NONE) {
+		ipdev->input->event = apanel_event;
+		ipdev->input->evbit[0] |= BIT(EV_LED);
+		set_bit(LED_MAIL, ipdev->input->ledbit);
+	}
+
+	err = i2c_attach_client(&ap->client);
+	if (err)
+		goto out2;
+
+	err = input_register_polled_device(ipdev);
+	if (err)
+		goto out3;
+
+	return 0;
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
+static __init void __iomem *bios_signature(void)
+{
+	void __iomem *bios;
+	ssize_t offset;
+	const unsigned char signature[] = "FJKEYINF";
+
+	bios = ioremap(0xF0000, 0x10000); /* Can't fail */
+
+	for (offset = 0; offset < 0x10000; offset += 0x10) {
+		if (check_signature(bios + offset, signature,
+				    sizeof(signature)-1))
+			return bios + offset;
+	}
+
+	printk(KERN_ERR  "apanel: Fujitsu BIOS signature '%s' not found...\n",
+	       signature);
+	iounmap(bios);
+	return NULL;
+}
+
+static int __init apanel_init(void)
+{
+	void __iomem *bios;
+	u8 devno;
+	int found = 0;
+
+	if (!dmi_check_system(apanel_dmi_table)) {
+		printk(KERN_WARNING "apanel: DMI information does not match\n");
+		if (!force)
+			return -ENODEV;
+	}
+	BUG_ON(!keymap);
+
+	bios = bios_signature();
+	if (!bios)
+		return -ENODEV;
+
+	bios += 8;
+
+	/* just use the first address */
+	normal_i2c[0] = readb(bios+3) >> 1;
+
+	for ( ; (devno = readb(bios)) & 0x7f; bios += 4) {
+		unsigned char method, slave, chip;
+
+		method = readb(bios + 1);
+		chip = readb(bios + 2);
+		slave = readb(bios + 3) >> 1;
+
+		if (slave != normal_i2c[0]) {
+			printk(KERN_ERR "apanel: only one SMBus slave "
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
+			printk(KERN_WARNING "apanel: unknown device %d found\n",
+			       devno);
+		else if (device_chip[devno] != CHIP_NONE)
+			printk(KERN_ERR "apanel: duplicate entry for %s\n",
+			       device_names[devno]);
+
+		else if (method != 1 && method != 2 && method != 4) {
+			printk(KERN_ERR "apanel: unknown  method %u for %s\n",
+			       method, device_names[devno]);
+		} else {
+			pr_debug("apanel: %s found, chip=%d\n",
+				 device_names[devno], chip);
+
+			device_chip[devno] = (enum apanel_chip) chip;
+			++found;
+		}
+	}
+	iounmap(bios);
+
+	if (found == 0) {
+		printk(KERN_ERR "apanel: no input devices reported by BIOS\n");
+		return -EIO;
+	}
+
+	return i2c_add_driver(&apanel_driver);
+}
+module_init(apanel_init);
+
+static void __exit apanel_cleanup(void)
+{
+	i2c_del_driver(&apanel_driver);
+}
+module_exit(apanel_cleanup);
