Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbXIDXel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbXIDXel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 19:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbXIDXed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 19:34:33 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:27962 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbXIDXec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 19:34:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kr2QFTjtwHx4rdNs4Xi1uKrIGPxaxQSy6mtUVFOd9DquDzf0sz19dF4JNueILseAZJiX+a1IBOKSQ/sJiIYXrCKIaBzwZ6PDnOiO1ZAX7D4dmFaMTcHv+SzcIVklhhpdZ3f5eOcvXZo+5e8ArrG/yPXBGJQCynXrWUNH3AdDlgc=
Message-ID: <8b67d60709041634l198d29f0ja049989acdb30b67@mail.gmail.com>
Date: Wed, 5 Sep 2007 00:34:31 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: dmitry.torokhov@gmail.com
Subject: [PATCH] Add support for keyboard on SEGA Dreamcast
Cc: "Paul Mundt" <lethal@linux-sh.org>, linuxsh-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will add support for the Dreamcast keyboard when used
alongside the maple bus patch (http://lkml.org/lkml/2007/9/4/165) and
the pvr2 patch.

Signed off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index c97d5eb..1689f73 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -253,4 +253,14 @@ config KEYBOARD_GPIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called gpio-keys.

+
+config KEYBOARD_MAPLE
+	tristate "Maple bus keyboard"
+	depends on SH_DREAMCAST && MAPLE
+	help
+	  Say Y here if you have a DreamCast console running Linux and have
+	  a keyboard attached to its Maple bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called maple_keyb.	
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 28d211b..3f775ed 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -21,4 +21,5 @@ obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
 obj-$(CONFIG_KEYBOARD_PXA27x)		+= pxa27x_keyboard.o
 obj-$(CONFIG_KEYBOARD_AAED2000)		+= aaed2000_kbd.o
 obj-$(CONFIG_KEYBOARD_GPIO)		+= gpio_keys.o
+obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o

diff --git a/drivers/input/keyboard/maple_keyb.c
b/drivers/input/keyboard/maple_keyb.c
new file mode 100644
index 0000000..12e4692
--- /dev/null
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -0,0 +1,222 @@
+/*
+ * SEGA Dreamcast keyboard driver
+ * Based on drivers/usb/usbkbd.c
+ * Copyright YAEGASHI Takeshi, 2001
+ * Porting to 2.6 Copyright Adrian McMenamin, 2007
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+*/
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/maple.h>
+
+MODULE_AUTHOR("YAEGASHI Takeshi, Adrian McMenamin");
+MODULE_DESCRIPTION("SEGA Dreamcast keyboard driver");
+MODULE_LICENSE("GPL");
+
+static unsigned char dc_kbd_keycode[256] = {
+	0, 0, 0, 0, 30, 48, 46, 32,
+	18, 33, 34, 35, 23, 36, 37, 38,
+	50, 49, 24, 25, 16, 19, 31, 20,
+	22, 47, 17, 45, 21, 44, 2, 3,
+	4, 5, 6, 7, 8, 9, 10, 11, 28,
+	1, 14, 15, 57, 12, 13, 26,
+	27, 43, 43, 39, 40, 41, 51,
+	52, 53, 58, 59, 60, 61, 62, 63, 64,
+	65, 66, 67, 68, 87, 88, 99,
+	70, 119, 110, 102, 104, 111,
+	107, 109, 106, 105, 108, 103,
+	69, 98, 55, 74, 78, 96, 79, 80,
+	81, 75, 76, 77, 71, 72, 73, 82, 83,
+	86, 127, 116, 117, 183, 184, 185,
+	186, 187, 188, 189, 190,
+	191, 192, 193, 194, 134, 138, 130, 132,
+	128, 129, 131, 137, 133, 135, 136, 113,
+	115, 114, 0, 0, 0, 121, 0, 89, 93, 124,
+	92, 94, 95, 0, 0, 0,
+	122, 123, 90, 91, 85, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	0, 0, 0, 0, 0, 0, 0, 0,
+	29, 42, 56, 125, 97, 54, 100, 126,
+	164, 166, 165, 163, 161, 115, 114, 113,
+	150, 158, 159, 128, 136, 177, 178, 176, 142,
+	152, 173, 140
+};
+
+struct dc_kbd {
+	struct input_dev *dev;
+	unsigned char new[8];
+	unsigned char old[8];
+};
+
+static void dc_scan_kbd(struct dc_kbd *kbd)
+{
+	int i;
+	struct input_dev *dev = kbd->dev;
+	for (i = 0; i < 8; i++)
+		input_report_key(dev,
+				 dc_kbd_keycode[i + 224],
+				 (kbd->new[0] >> i) & 1);
+
+	for (i = 2; i < 8; i++) {
+		if (kbd->old[i] > 3
+		    && memchr(kbd->new + 2, kbd->old[i], 6) == NULL) {
+			if (dc_kbd_keycode[kbd->old[i]])
+				input_report_key(dev,
+					dc_kbd_keycode[kbd->old[i]], 0);
+			else
+				printk
+				    ("Unknown key (scancode %#x) released.",
+				     kbd->old[i]);
+		}
+
+		if (kbd->new[i] > 3
+		    && memchr(kbd->old + 2, kbd->new[i], 6) != NULL) {
+			if (dc_kbd_keycode[kbd->new[i]])
+				input_report_key(dev,
+					dc_kbd_keycode[kbd->new[i]], 1);
+			else
+				printk
+				    ("Unknown key (scancode %#x) pressed.",
+				     kbd->new[i]);
+		}
+	}
+	input_sync(dev);
+	memcpy(kbd->old, kbd->new, 8);
+}
+
+static void dc_kbd_callback(struct mapleq *mq)
+{
+	struct maple_device *mapledev = mq->dev;
+	struct dc_kbd *kbd = mapledev->private_data;
+	unsigned long *buf = mq->recvbuf;
+	if (buf[1] == mapledev->function) {
+		memcpy(kbd->new, buf + 2, 8);
+		dc_scan_kbd(kbd);
+	}
+}
+
+static int dc_kbd_connect(struct maple_device *dev)
+{
+	int i, retval;
+	unsigned long data = be32_to_cpu(dev->devinfo.function_data[0]);
+	struct dc_kbd *kbd;
+	if (dev->function != MAPLE_FUNC_KEYBOARD)
+		return -EINVAL;
+
+	kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
+	if (unlikely(!kbd))
+		return -ENOMEM;
+
+	dev->private_data = kbd;
+	kbd->dev = input_allocate_device();
+	if (unlikely(!kbd->dev))
+		goto cleanup;
+
+	kbd->dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+
+	for (i = 0; i < 255; i++)
+		set_bit(dc_kbd_keycode[i], kbd->dev->keybit);
+
+	clear_bit(0, kbd->dev->keybit);
+
+	kbd->dev->private = kbd;
+
+	kbd->dev->name = dev->product_name;
+	kbd->dev->id.bustype = BUS_MAPLE;
+
+	retval = input_register_device(kbd->dev);
+	if (unlikely(retval))
+		goto cleanup;
+
+	maple_getcond_callback(dev, dc_kbd_callback, (25 * HZ) / 1000,
+			       MAPLE_FUNC_KEYBOARD);
+
+	printk(KERN_INFO "input: keyboard(0x%lx): %s\n", data,
+	       kbd->dev->name);
+
+	return 0;
+
+      cleanup:
+	kfree(kbd);
+	return -EINVAL;
+}
+
+static void dc_kbd_disconnect(struct maple_device *dev)
+{
+	struct dc_kbd *kbd = dev->private_data;
+
+	input_unregister_device(kbd->dev);
+	kfree(kbd);
+}
+
+/* allow the keyboard to be used */
+static int probe_maple_kbd(struct device *dev)
+{
+	struct maple_device *mdev;
+	struct maple_driver *mdrv;
+	int proberes;
+
+	mdev = to_maple_dev(dev);
+	mdrv = to_maple_driver(dev->driver);
+
+	proberes = dc_kbd_connect(mdev);
+	if (unlikely(proberes))
+		return proberes;
+	mdev->driver = mdrv;
+	mdev->registered = 1;
+	return 0;
+}
+
+
+static struct maple_driver dc_kbd_driver = {
+	.function = MAPLE_FUNC_KEYBOARD,
+	.connect = dc_kbd_connect,
+	.disconnect = dc_kbd_disconnect,
+	.drv = {
+		.name = "Dreamcast_keyboard",
+		.probe = probe_maple_kbd,
+		},
+};
+
+static int __init dc_kbd_init(void)
+{
+	int retval;
+	retval = maple_driver_register(&dc_kbd_driver.drv);
+	if (retval)
+		return retval;
+	return 0;
+}
+
+static void __exit dc_kbd_exit(void)
+{
+	driver_unregister(&dc_kbd_driver.drv);
+}
+
+module_init(dc_kbd_init);
+module_exit(dc_kbd_exit);
diff --git a/include/linux/input.h b/include/linux/input.h
index e02c6a6..2e65c88 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -688,6 +688,7 @@ struct input_absinfo {
 #define BUS_HOST		0x19
 #define BUS_GSC			0x1A
 #define BUS_ATARI		0x1B
+#define BUS_MAPLE		0x1C

 /*
  * Values describing the status of a force-feedback effect
