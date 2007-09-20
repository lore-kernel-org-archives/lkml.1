Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXITLag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXITLag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 07:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbXITL3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 07:29:55 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:21121 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbXITL3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 07:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=np20ryZZL76I/ZRQJkwsN4xLfSx0VUH1r05uLmYik+eQyWxXS1mEVZZD6IJdo9X3sooaHqSJdiyqHY5vn6V1QX0/cr1IIWWBPXTOKr97p3ONa9NVvoB78c8u4HXi4Td2SUcoMGWlkroYVfCu7rgKjrrerf0gcYrf7ZMS6OvAGq0=
Message-ID: <8b67d60709200429n420e7b17xae6034de6da3e7f7@mail.gmail.com>
Date: Thu, 20 Sep 2007 12:29:52 +0100
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Fwd: [PATCH 2/3] Add Maple bus support for the SEGA Dreamcast - maple keyboard (repost)
Cc: "Paul Mundt" <lethal@linux-sh.org>, "Greg KH" <greg@kroah.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the keyboard on the SEGA Dreamcast

Signed-off by Adrian McMenamin <adrian@mcmen.demon.co.uk>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>


diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index c97d5eb..056cc52 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -253,4 +253,14 @@ config KEYBOARD_GPIO
         To compile this driver as a module, choose M here: the
         module will be called gpio-keys.

+
+config KEYBOARD_MAPLE
+       tristate "Maple bus keyboard"
+       depends on SH_DREAMCAST && MAPLE
+       help
+         Say Y here if you have a Dreamcast console running Linux and have
+         a keyboard attached to its Maple bus.
+
+         To compile this driver as a module, choose M here: the
+         module will be called maple_keyb.
 endif
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index 28d211b..3f775ed 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -21,4 +21,5 @@ obj-$(CONFIG_KEYBOARD_OMAP)           += omap-keypad.o
 obj-$(CONFIG_KEYBOARD_PXA27x)          += pxa27x_keyboard.o
 obj-$(CONFIG_KEYBOARD_AAED2000)                += aaed2000_kbd.o
 obj-$(CONFIG_KEYBOARD_GPIO)            += gpio_keys.o
+obj-$(CONFIG_KEYBOARD_MAPLE)           += maple_keyb.o

diff --git a/drivers/input/keyboard/maple_keyb.c
b/drivers/input/keyboard/maple_keyb.c
new file mode 100644
index 0000000..3bb58e1
--- /dev/null
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -0,0 +1,234 @@
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
+#include <asm/mach/maple.h>
+
+/* Very simple mutex to ensure proper cleanup */
+static DEFINE_MUTEX(maple_keyb_mutex);
+
+#define NR_SCANCODES 256
+
+MODULE_AUTHOR("YAEGASHI Takeshi, Adrian McMenamin");
+MODULE_DESCRIPTION("SEGA Dreamcast keyboard driver");
+MODULE_LICENSE("GPL");
+
+struct dc_kbd {
+       struct input_dev *dev;
+       unsigned char keycode[NR_SCANCODES];
+       unsigned char new[8];
+       unsigned char old[8];
+};
+
+const static unsigned char dc_kbd_keycode[NR_SCANCODES] = {
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_A,
KEY_B, KEY_C, KEY_D,
+       KEY_E, KEY_F, KEY_G, KEY_H, KEY_I, KEY_J, KEY_K, KEY_L,
+       KEY_M, KEY_N, KEY_O, KEY_P, KEY_Q, KEY_R, KEY_S, KEY_T,
+       KEY_U, KEY_V, KEY_W, KEY_X, KEY_Y, KEY_Z, KEY_1, KEY_2,
+       KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9, KEY_0,
+       KEY_ENTER, KEY_ESC, KEY_BACKSPACE, KEY_TAB, KEY_SPACE, KEY_MINUS,
KEY_EQUAL, KEY_LEFTBRACE,
+       KEY_RIGHTBRACE, KEY_BACKSLASH, KEY_BACKSLASH, KEY_SEMICOLON,
KEY_APOSTROPHE, KEY_GRAVE, KEY_COMMA,
+       KEY_DOT, KEY_SLASH, KEY_CAPSLOCK, KEY_F1, KEY_F2, KEY_F3, KEY_F4,
KEY_F5, KEY_F6,
+       KEY_F7, KEY_F8, KEY_F9, KEY_F10, KEY_F11, KEY_F12, KEY_SYSRQ,
+       KEY_SCROLLLOCK, KEY_PAUSE, KEY_INSERT, KEY_HOME, KEY_PAGEUP, KEY_DELETE,
+       KEY_END, KEY_PAGEDOWN, KEY_RIGHT, KEY_LEFT, KEY_DOWN, KEY_UP,
+       KEY_NUMLOCK, KEY_KPSLASH, KEY_KPASTERISK, KEY_KPMINUS, KEY_KPPLUS,
KEY_KPENTER, KEY_KP1, KEY_KP2,
+       KEY_KP3, KEY_KP4, KEY_KP5, KEY_KP6, KEY_KP7, KEY_KP8, KEY_KP9,
KEY_KP0, KEY_KPDOT,
+       KEY_102ND, KEY_COMPOSE, KEY_POWER, KEY_KPEQUAL, KEY_F13,
KEY_F14, KEY_F15,
+       KEY_F16, KEY_F17, KEY_F18, KEY_F19, KEY_F20,
+       KEY_F21, KEY_F22, KEY_F23, KEY_F24, KEY_OPEN, KEY_HELP,
KEY_PROPS, KEY_FRONT,
+       KEY_STOP, KEY_AGAIN, KEY_UNDO, KEY_CUT, KEY_COPY, KEY_PASTE,
KEY_FIND, KEY_MUTE,
+       KEY_VOLUMEUP, KEY_VOLUMEDOWN, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_KPCOMMA, KEY_RESERVED, KEY_RO, KEY_KATAKANAHIRAGANA
, KEY_YEN,
+       KEY_HENKAN, KEY_MUHENKAN, KEY_KPJPCOMMA, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED,
+       KEY_HANGEUL, KEY_HANJA, KEY_KATAKANA, KEY_HIRAGANA,
KEY_ZENKAKUHANKAKU, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+       KEY_LEFTCTRL, KEY_LEFTSHIFT, KEY_LEFTALT, KEY_LEFTMETA,
KEY_RIGHTCTRL, KEY_RIGHTSHIFT, KEY_RIGHTALT, KEY_RIGHTMETA,
+       KEY_PLAYPAUSE, KEY_STOPCD, KEY_PREVIOUSSONG, KEY_NEXTSONG,
KEY_EJECTCD, KEY_VOLUMEUP, KEY_VOLUMEDOWN, KEY_MUTE,
+       KEY_WWW, KEY_BACK, KEY_FORWARD, KEY_STOP, KEY_FIND, KEY_SCROLLUP,
KEY_SCROLLDOWN, KEY_EDIT, KEY_SLEEP,
+       KEY_SCREENLOCK, KEY_REFRESH, KEY_CALC, KEY_RESERVED, KEY_RESERVED,
KEY_RESERVED, KEY_RESERVED
+};
+
+static void dc_scan_kbd(struct dc_kbd *kbd)
+{
+       int i;
+       void *ptr;
+       struct input_dev *dev = kbd->dev;
+
+       for (i = 0; i < 8; i++)
+               input_report_key(dev, kbd->keycode[i + 224],
+                                       (kbd->new[0] >> i) & 1);
+
+       for (i = 2; i < 8; i++) {
+               ptr = memchr(kbd->new + 2, kbd->old[i], 6);
+               if (kbd->old[i] > 3 && ptr == NULL) {
+                       if (dc_kbd_keycode[kbd->old[i]])
+                               input_report_key(dev,
kbd->keycode[kbd->old[i]], 0);
+                       else
+                               printk (KERN_DEBUG "Unknown key
(scancode %#x) released.", kbd->old[i]);
+               }
+               ptr = memchr(kbd->old + 2, kbd->new[i], 6);
+               if (kbd->new[i] > 3 && ptr) {
+                       if (dc_kbd_keycode[kbd->new[i]])
+                               input_report_key(dev,
kbd->keycode[kbd->new[i]], 1);
+                       else
+                               printk(KERN_DEBUG "Unknown key
(scancode %#x) pressed.", kbd->new[i]);
+               }
+       }
+       input_sync(dev);
+       memcpy(kbd->old, kbd->new, 8);
+}
+
+static void dc_kbd_callback(struct mapleq *mq)
+{
+       struct maple_device *mapledev = mq->dev;
+       struct dc_kbd *kbd = mapledev->private_data;
+       unsigned long *buf = mq->recvbuf;
+
+       if (!mutex_trylock(&maple_keyb_mutex)) /* Can only be locked if
already in cleanup */
+               return;
+       if (buf[1] == mapledev->function) {
+               memcpy(kbd->new, buf + 2, 8);
+               dc_scan_kbd(kbd);
+       }
+       mutex_unlock(&maple_keyb_mutex);
+}
+
+static int dc_kbd_connect(struct maple_device *mdev)
+{
+       int i, retval = 0;
+       struct dc_kbd *kbd;
+       struct input_dev *dev;
+
+       if (!(mdev->function & MAPLE_FUNC_KEYBOARD))
+               return -EINVAL;
+
+       kbd = kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);
+       if (unlikely(!kbd))
+               return -ENOMEM;
+
+       mdev->private_data = kbd;
+       kbd->dev = input_allocate_device();
+       if (!kbd->dev){
+               retval = -ENODEV;
+               goto cleanup_memory;
+       }
+
+       dev = kbd->dev;
+
+       memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
+
+       dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
+       dev->keycodesize = sizeof (unsigned char);
+       dev->keycodemax = ARRAY_SIZE(kbd->keycode);
+       dev->keycode = kbd->keycode;
+       dev->dev.parent = &mdev->dev;
+
+       for (i = 0; i < NR_SCANCODES; i++)
+               set_bit(dc_kbd_keycode[i], dev->keybit);
+
+       clear_bit(0, dev->keybit);
+
+       input_set_drvdata(dev, kbd);
+
+       dev->name = mdev->product_name;
+       dev->id.bustype = BUS_HOST;
+
+       retval = input_register_device(dev);
+       if (retval)
+               goto cleanup;
+       /* Maple polling is locked to VBLANK - which may be just 50/s */
+       maple_getcond_callback(mdev, dc_kbd_callback, HZ/50,
MAPLE_FUNC_KEYBOARD);
+       return retval;
+
+cleanup:
+       input_free_device(kbd->dev);
+cleanup_memory:
+       kfree(kbd);
+       return retval;
+}
+
+static void dc_kbd_disconnect(struct maple_device *mdev)
+{
+       struct dc_kbd *kbd;
+
+       mutex_lock(&maple_keyb_mutex);
+       kbd = mdev->private_data;
+
+       input_unregister_device(kbd->dev);
+       kfree(kbd);
+       mutex_unlock(&maple_keyb_mutex);
+}
+
+/* allow the keyboard to be used */
+static int probe_maple_kbd(struct device *dev)
+{
+       struct maple_device *mdev;
+       struct maple_driver *mdrv;
+       int proberes;
+
+       mdev = to_maple_dev(dev);
+       mdrv = to_maple_driver(dev->driver);
+
+       proberes = dc_kbd_connect(mdev);
+       if (unlikely(proberes))
+               return proberes;
+       mdev->driver = mdrv;
+       mdev->registered = 1;
+       return 0;
+}
+
+static struct maple_driver dc_kbd_driver = {
+       .function = MAPLE_FUNC_KEYBOARD,
+       .connect = dc_kbd_connect,
+       .disconnect = dc_kbd_disconnect,
+       .drv = {
+               .name = "Dreamcast_keyboard",
+               .probe = probe_maple_kbd,
+               },
+};
+
+static int __init dc_kbd_init(void)
+{
+       return maple_driver_register(&dc_kbd_driver.drv);
+}
+
+static void __exit dc_kbd_exit(void)
+{
+       driver_unregister(&dc_kbd_driver.drv);
+}
+
+module_init(dc_kbd_init);
+module_exit(dc_kbd_exit);
