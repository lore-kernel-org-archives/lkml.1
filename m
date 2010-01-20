Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631Ab0ATUrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0ATUrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 15:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607Ab0ATUru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 15:47:50 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:64105 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab0ATUrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 15:47:48 -0500
From: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Message-Id: <201001202047.o0KKlMTr014003@mustang.cs.nmsu.edu>
Date: Wed, 20 Jan 2010 13:47:22 -0700
To: linux-kernel@vger.kernel.org
Cc: felipe.balbi@nokia.com, pavel@ucw.cz, jayakumar.lkml@gmail.com,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz, dmitry.torokhov@gmail.com
Subject: [PATCH] hid: Logitech G13 driver 0.0.4
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b9eeb0aff3f8b9a7792f35741215a1847ec0c98d Mon Sep 17 00:00:00 2001
From: Rick L. Vinyard, Jr <rvinyard@cs.nmsu.edu>
Date: Wed, 20 Jan 2010 13:32:04 -0700
Subject: [PATCH] hid Logitech G13 Driver 0.0.4

This is a driver for the Logitech G13 gamepad, and contains four key
parts.  Through the USB reports the device identifies itself as a HID, and as
a result this driver is under the HID framework.

There are three primary sub-components to this driver; an input device, a
framebuffer device, and four instance of the LED class.

Although identified as a HID, the device does not support standard HID
input messages.  As a result, a sub-input device is allocated and
registered separately in g13_probe().  The raw events are monitored and
key presses/joystick activity is reported through the input device after
referencing an indexed keymap.

However, the driver does use the HID feature reports extensively to
control the backlight, LEDs, et. al.

The G13 contains a 160x43 monochrome LCD display.  A registered framebuffer
device manages this display.  The design of this portion of the driver was
based on the design of the hecubafb driver with deferred framebuffer I/O since
there is no real memory to map.

Changes since 0.0.3:
- Replaced the mled sysfs attribute with four LED class instances

- Replaced the sleeping waits with completion signaling

- Removed the G_* key #defines and replaced with brief comments to document
  G_* key indices

- Changed rwlock to a spinlock

- Removed null pointer checks from convenience cast macros

- Removed g13 data structure null pointer checks from sysfs show and store
  functions

- Converted printks to dev_warns

- Removed keycode size checks from input_setkeycode callbacks as we know
  the size allocated by this driver

- Removed locks from input_getkeycode callback as they are unnecessary

- Issue key up for pressed keycodes when keymap has changed as well as the
  keycode for a given scancode. However, if the keycode remains the same,
  we'll leave the keycode in a key down state.

- Changed all keycode/scancode lookups and sets to use input_get_keycode()
  and input_set_keycode() for entry points.

- Removed the emit_msc_raw sysfs attribute

- Removed the mled sysfs attribute

- Changed keymap_switching attribute to mode 0644 from 0666

- Added a sysfs attribute for the minor number used to build LED device paths
  for libsysfs from userspace

- Broke key event handling into a separate function to clean up the input
  message processing

- Changed MSC_SCAN to emit on keypress of an unmapped key

- Moved check for M* key presses to beginning of message processing to ensure
  that the keymap will be indexed properly when switched

- Changed clear_bit() and set_bit() to unlocked versions __clear_bit() and
  __set_bit()

- Changed key 0 references to KEY_RESERVED

- Push the initialized image twice since it seems to sometimes get "lost" in
  that the device ignores the image sent

- Set driver keymap switching to on as a default as this is the general
  behavior expected without a userspace daemon controlling keymap
  switching

- When cleaning up a failed LED class allocation unregister the input
  device as well. Also, added skip ahead to freeing the framebuffer cache
  to avoid freeing the input device twice.

- On device removal remove the sysfs attribute group, remove null data pointer
  checks, add framebuffer deferred i/o cleanup, and led class cleanup

Changes since 0.0.2:
- Moved the module out of the logitech objs to build on its own

- Added dependency on FB_DEFFERRED_IO

- Added explanation as to why the load image is used and how to view it
  outside the code.

- Changed the load image to text "G13" with default penguins resized,
  cleaned up and inverted from framebuffer monochrome penguin logo.

- Cleaned up the raw event callback by moving the key event processing to a
  separate function.

- Removed several of the line breaks introduced to accomodate 80-column lines
  to improve readability.

- Reordeded event processing and utility functions to eliminate the need for
  a g13_set_mled() prototype.

- Removed nonstd flag from framebuffer screeninfo structure

Signed-off-by: Rick L. Vinyard, Jr <rvinyard@cs.nmsu.edu>
---
 drivers/hid/Kconfig    |   14 +
 drivers/hid/Makefile   |    1 +
 drivers/hid/hid-core.c |    1 +
 drivers/hid/hid-g13.c  | 1657 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-ids.h  |    1 +
 5 files changed, 1674 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hid/hid-g13.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 24d90ea..548dd4a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -183,6 +183,20 @@ config LOGIRUMBLEPAD2_FF
 	  Say Y here if you want to enable force feedback support for Logitech
 	  Rumblepad 2 devices.
 
+config HID_LOGITECH_G13
+	tristate "Logitech G13 gameboard support"
+	depends on FB
+	depends on FB_DEFERRED_IO
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	help
+	  This provides support for Logitech G13 gameboard
+	  devices. This includes support for the device
+	  as a keypad input with mappable keys as well as
+	  a framebuffer for the LCD display.
+
 config HID_MICROSOFT
 	tristate "Microsoft" if EMBEDDED
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 0de2dff..d39dc5b 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
 obj-$(CONFIG_HID_KENSINGTON)	+= hid-kensington.o
 obj-$(CONFIG_HID_KYE)		+= hid-kye.o
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
+obj-$(CONFIG_HID_LOGITECH_G13)	+= hid-g13.o
 obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
 obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
 obj-$(CONFIG_HID_NTRIG)		+= hid-ntrig.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 80792d3..eeae383 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1325,6 +1325,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G25_WHEEL) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G13) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACENAVIGATOR) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV) },
diff --git a/drivers/hid/hid-g13.c b/drivers/hid/hid-g13.c
new file mode 100644
index 0000000..992c242
--- /dev/null
+++ b/drivers/hid/hid-g13.c
@@ -0,0 +1,1657 @@
+/***************************************************************************
+ *   Copyright (C) 2009 by Rick L. Vinyard, Jr.                            *
+ *   rvinyard@cs.nmsu.edu                                                  *
+ *                                                                         *
+ *   This program is free software: you can redistribute it and/or modify  *
+ *   it under the terms of the GNU General Public License as published by  *
+ *   the Free Software Foundation, either version 2 of the License, or     *
+ *   (at your option) any later version.                                   *
+ *                                                                         *
+ *   This driver is distributed in the hope that it will be useful, but    *
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU      *
+ *   General Public License for more details.                              *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public License     *
+ *   along with this software. If not see <http://www.gnu.org/licenses/>.  *
+ ***************************************************************************/
+#include <linux/fb.h>
+#include <linux/hid.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/mm.h>
+#include <linux/sysfs.h>
+#include <linux/uaccess.h>
+#include <linux/usb.h>
+#include <linux/vmalloc.h>
+#include <linux/leds.h>
+#include <linux/completion.h>
+
+#include "hid-ids.h"
+#include "usbhid/usbhid.h"
+
+#define G13_NAME "Logitech G13"
+
+/* Key defines */
+#define G13_KEYS 35
+#define G13_KEYMAP_SIZE (G13_KEYS*3)
+
+/* Framebuffer defines */
+#define G13FB_NAME "g13fb"
+#define G13FB_WIDTH (160)
+#define G13FB_LINE_LENGTH (160/8)
+#define G13FB_HEIGHT (43)
+#define G13FB_SIZE (G13FB_LINE_LENGTH*G13FB_HEIGHT)
+
+#define G13FB_UPDATE_RATE_LIMIT (20)
+#define G13FB_UPDATE_RATE_DEFAULT (10)
+
+/*
+ * The native G13 format uses vertical bits. Therefore the number of bytes
+ * needed to represent the first column is 43/8 (rows/bits) rounded up.
+ * Additionally, the format requires a padding of 32 bits in front of the
+ * image data.
+ *
+ * Therefore the vbitmap size must be:
+ *   160 * ceil(43/8) + 32 = 160 * 6 + 32 = 992
+ */
+#define G13_VBITMAP_SIZE (992)
+
+/* Backlight defaults */
+#define G13_DEFAULT_RED (0)
+#define G13_DEFAULT_GREEN (255)
+#define G13_DEFAULT_BLUE (0)
+
+/* LED array indices */
+#define G13_LED_M1 0
+#define G13_LED_M2 1
+#define G13_LED_M3 2
+#define G13_LED_MR 3
+
+#define G13_READY_STAGE_1 0x01
+#define G13_READY_STAGE_2 0x02
+#define G13_READY 0x03
+
+/* Per device data structure */
+struct g13_data {
+	/* HID reports */
+	struct hid_device *hdev;
+	struct hid_report *backlight_report;
+	struct hid_report *start_input_report;
+	struct hid_report *report_4;
+	struct hid_report *led_report;
+	struct input_dev *input_dev;
+
+	/* core state */
+	char *name;
+	int keycode[G13_KEYMAP_SIZE];
+	int scancode_state[G13_KEYS];
+	u8 rgb[3];
+	u8 led;
+	u8 curkeymap;
+	u8 keymap_switching;
+
+	/* Framebuffer stuff */
+	u8 fb_update_rate;
+	u8 *fb_vbitmap;
+	u8 *fb_bitmap;
+	struct fb_info *fb_info;
+	struct fb_deferred_io fb_defio;
+
+	/* LED stuff */
+	struct led_classdev *led[4];
+
+	/* Housekeeping stuff */
+	spinlock_t lock;
+	struct completion ready;
+	int ready_stages;
+};
+
+/* Convenience macros */
+#define hid_get_g13data(hdev) \
+	((struct g13_data *)(hid_get_drvdata(hdev)))
+
+#define input_get_hdev(idev) \
+	((struct hid_device *)(input_get_drvdata(idev)))
+
+#define input_get_g13data(idev) (hid_get_g13data(input_get_hdev(idev)))
+
+/*
+ * Keymap array indices
+ *
+ * Key        Index
+ * ---------  ------
+ * G1-G22     0-21
+ * FUNC       22
+ * LCD1       23
+ * LCD2       24
+ * LCD3       25
+ * LCD4       26
+ * M1         27
+ * M2         28
+ * M3         29
+ * MR         30
+ * BTN_LEFT   31
+ * BTN_DOWN   32
+ * BTN_STICK  33
+ * LIGHT      34
+ */
+static const unsigned int g13_default_key_map[G13_KEYS] = {
+  /* first row g1 - g7 */
+  KEY_F1, KEY_F2, KEY_F3, KEY_F4, KEY_F5, KEY_F6, KEY_F7,
+  /* second row g8 - g11 */
+  KEY_UNKNOWN, KEY_UNKNOWN, KEY_BACK, KEY_UP,
+  /* second row g12 - g13 */
+  KEY_FORWARD, KEY_UNKNOWN, KEY_UNKNOWN,
+  /* third row g15 - g19 */
+  KEY_UNKNOWN, KEY_LEFT, KEY_DOWN, KEY_RIGHT, KEY_UNKNOWN,
+  /* fourth row g20 - g22 */
+  KEY_BACKSPACE, KEY_ENTER, KEY_SPACE,
+  /* next, light left, light center left, light center right, light right */
+  BTN_0, BTN_1, BTN_2, BTN_3, BTN_4,
+  /* M1, M2, M3, MR */
+  KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+  /* button left, button down, button stick, light */
+  BTN_LEFT, BTN_RIGHT, BTN_MIDDLE, KEY_RESERVED,
+};
+
+/* Framebuffer visual structures */
+static struct fb_fix_screeninfo g13fb_fix = {
+	.id = G13FB_NAME,
+	.type = FB_TYPE_PACKED_PIXELS,
+	.visual = FB_VISUAL_MONO01,
+	.xpanstep = 0,
+	.ypanstep = 0,
+	.ywrapstep = 0,
+	.line_length = G13FB_LINE_LENGTH,
+	.accel = FB_ACCEL_NONE,
+};
+
+static struct fb_var_screeninfo g13fb_var = {
+	.xres = G13FB_WIDTH,
+	.yres = G13FB_HEIGHT,
+	.xres_virtual = G13FB_WIDTH,
+	.yres_virtual = G13FB_HEIGHT,
+	.bits_per_pixel = 1,
+};
+
+/*
+ * This is a default logo to be loaded upon driver initialization
+ * replacing the default Logitech G13 image loaded on device
+ * initialization. This is to provide the user a cue that the
+ * Linux driver is loaded and ready.
+ *
+ * This logo contains the text G13 in the center with two penguins
+ * on each side of the text. The penguins are a 33x40 rendition of
+ * the default framebuffer 80x80 monochrome image scaled down and
+ * cleaned up to retain something that looks a little better than
+ * a simple scaling.
+ *
+ * This logo is a simple xbm image created in GIMP and exported.
+ * To view the image copy the following two #defines plus the
+ * g13_lcd_bits to an ASCII text file and save with extension
+ * .xbm, then open with GIMP or any other graphical editor
+ * such as eog that recognizes the .xbm format.
+ */
+#define g13_lcd_width 160
+#define g13_lcd_height 43
+static unsigned char g13_lcd_bits[] = {
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0f, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x3c, 0x00, 0x00, 0x00, 0xc0, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xc3, 0x01, 0x00,
+ 0x00, 0x20, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x02, 0x00, 0x00, 0x20, 0x10, 0x01,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x80, 0x40, 0x04, 0x00, 0x00, 0x10, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x04, 0x00,
+ 0x00, 0x10, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x08, 0x00, 0x00, 0xd0, 0x18, 0x02,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x40, 0x63, 0x08, 0x00, 0x00, 0xd0, 0x1c, 0x02, 0x00, 0xf0, 0xff, 0xff,
+ 0x83, 0xff, 0x01, 0xf8, 0xff, 0xff, 0x03, 0x00, 0x40, 0x73, 0x08, 0x00,
+ 0x00, 0x10, 0x25, 0x02, 0x00, 0xf8, 0xff, 0xff, 0x83, 0xff, 0x01, 0xf8,
+ 0xff, 0xff, 0x07, 0x00, 0x40, 0x94, 0x08, 0x00, 0x00, 0x10, 0x20, 0x02,
+ 0x00, 0xfc, 0xff, 0xff, 0x83, 0xff, 0x01, 0xf8, 0xff, 0xff, 0x0f, 0x00,
+ 0x40, 0x80, 0x08, 0x00, 0x00, 0xd0, 0x1e, 0x02, 0x00, 0xfe, 0xff, 0xff,
+ 0x83, 0xff, 0x01, 0xf8, 0xff, 0xff, 0x1f, 0x00, 0x40, 0x7b, 0x08, 0x00,
+ 0x00, 0xd0, 0x27, 0x02, 0x00, 0xfe, 0xff, 0xff, 0x83, 0xff, 0x01, 0xf8,
+ 0xff, 0xff, 0x1f, 0x00, 0x40, 0x9f, 0x08, 0x00, 0x00, 0x90, 0x1b, 0x02,
+ 0x00, 0x3e, 0x00, 0x00, 0x00, 0xf0, 0x01, 0x00, 0x00, 0x00, 0x1f, 0x00,
+ 0x40, 0x6e, 0x08, 0x00, 0x00, 0x10, 0x24, 0x02, 0x00, 0x3e, 0x00, 0x00,
+ 0x00, 0xf0, 0x01, 0x00, 0x00, 0x00, 0x1f, 0x00, 0x40, 0x90, 0x08, 0x00,
+ 0x00, 0x48, 0x3b, 0x05, 0x00, 0x3e, 0x00, 0x00, 0x00, 0xf0, 0x01, 0x00,
+ 0x00, 0x00, 0x1f, 0x00, 0x20, 0xed, 0x14, 0x00, 0x00, 0xc8, 0x7c, 0x08,
+ 0x00, 0x3e, 0x00, 0x00, 0x00, 0xf0, 0x01, 0x00, 0x00, 0x00, 0x1f, 0x00,
+ 0x20, 0xf3, 0x21, 0x00, 0x00, 0xe4, 0x7f, 0x10, 0x00, 0x3e, 0x00, 0x00,
+ 0x00, 0xf0, 0x01, 0x00, 0x00, 0x00, 0x1f, 0x00, 0x90, 0xff, 0x41, 0x00,
+ 0x00, 0xe2, 0xff, 0x20, 0x00, 0x3e, 0x00, 0x00, 0x00, 0xf0, 0x01, 0x00,
+ 0x00, 0x00, 0x1f, 0x00, 0x88, 0xff, 0x83, 0x00, 0x00, 0xc2, 0x9c, 0x40,
+ 0x00, 0x3e, 0xf8, 0xff, 0x07, 0xf0, 0x01, 0xf8, 0xff, 0xff, 0x1f, 0x00,
+ 0x08, 0x73, 0x02, 0x01, 0x00, 0xf1, 0x3e, 0x41, 0x00, 0x3e, 0xf8, 0xff,
+ 0x07, 0xf0, 0x01, 0xf8, 0xff, 0xff, 0x0f, 0x00, 0xc4, 0xfb, 0x04, 0x01,
+ 0x00, 0xf1, 0x7f, 0x40, 0x00, 0x3e, 0xf8, 0xff, 0x07, 0xf0, 0x01, 0xf8,
+ 0xff, 0xff, 0x07, 0x00, 0xc4, 0xff, 0x01, 0x01, 0x80, 0xf8, 0xff, 0x89,
+ 0x00, 0x3e, 0xf8, 0xff, 0x07, 0xf0, 0x01, 0xf8, 0xff, 0xff, 0x0f, 0x00,
+ 0xe2, 0xff, 0x27, 0x02, 0x80, 0xf8, 0xff, 0x93, 0x00, 0x3e, 0xf8, 0xff,
+ 0x07, 0xf0, 0x01, 0xf8, 0xff, 0xff, 0x0f, 0x00, 0xe2, 0xff, 0x4f, 0x02,
+ 0x40, 0xfc, 0xff, 0x93, 0x00, 0x3e, 0x00, 0xc0, 0x07, 0xf0, 0x01, 0x00,
+ 0x00, 0x00, 0x1f, 0x00, 0xf1, 0xff, 0x4f, 0x02, 0x40, 0xfc, 0xff, 0x13,
+ 0x01, 0x3e, 0x00, 0xc0, 0x07, 0xf0, 0x01, 0x00, 0x00, 0x00, 0x1f, 0x00,
+ 0xf1, 0xff, 0x4f, 0x04, 0x20, 0x7c, 0xff, 0x13, 0x01, 0x3e, 0x00, 0xc0,
+ 0x07, 0xf0, 0x01, 0x00, 0x00, 0x00, 0x1f, 0x80, 0xf0, 0xfd, 0x4f, 0x04,
+ 0x20, 0x7c, 0xff, 0x13, 0x01, 0x3e, 0x00, 0xc0, 0x07, 0xf0, 0x01, 0x00,
+ 0x00, 0x00, 0x1f, 0x80, 0xf0, 0xfd, 0x4f, 0x04, 0x20, 0x7c, 0xff, 0x3b,
+ 0x01, 0x3e, 0x00, 0xc0, 0x07, 0xf0, 0x01, 0x00, 0x00, 0x00, 0x1f, 0x80,
+ 0xf0, 0xfd, 0xef, 0x04, 0xa0, 0xfc, 0xff, 0x00, 0x01, 0x3e, 0x00, 0xc0,
+ 0x07, 0xf0, 0x01, 0x00, 0x00, 0x00, 0x1f, 0x80, 0xf2, 0xff, 0x03, 0x04,
+ 0xc0, 0xfb, 0x7f, 0x83, 0x00, 0xfe, 0xff, 0xff, 0x87, 0xff, 0x7f, 0xf8,
+ 0xff, 0xff, 0x1f, 0x00, 0xef, 0xff, 0x0d, 0x02, 0xe0, 0xe7, 0x7f, 0xc7,
+ 0x00, 0xfe, 0xff, 0xff, 0x87, 0xff, 0x7f, 0xf8, 0xff, 0xff, 0x1f, 0x80,
+ 0x9f, 0xff, 0x1d, 0x03, 0xf0, 0xc7, 0x7f, 0xff, 0x00, 0xfc, 0xff, 0xff,
+ 0x87, 0xff, 0x7f, 0xf8, 0xff, 0xff, 0x0f, 0xc0, 0x1f, 0xff, 0xfd, 0x03,
+ 0xf8, 0xcf, 0x7f, 0xff, 0x03, 0xfc, 0xff, 0xff, 0x87, 0xff, 0x7f, 0xf8,
+ 0xff, 0xff, 0x0f, 0xe0, 0x3f, 0xff, 0xfd, 0x0f, 0xf8, 0xcf, 0x7f, 0xff,
+ 0x03, 0xf0, 0xff, 0xff, 0x87, 0xff, 0x7f, 0xf8, 0xff, 0xff, 0x03, 0xe0,
+ 0x3f, 0xff, 0xfd, 0x0f, 0xfc, 0xef, 0x7f, 0xff, 0x07, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0, 0xbf, 0xff, 0xfd, 0x1f,
+ 0xfc, 0xdf, 0x9f, 0xff, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0xf0, 0x7f, 0x7f, 0xfe, 0x0f, 0xfc, 0x3f, 0x80, 0xff,
+ 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xf0,
+ 0xff, 0x00, 0xfe, 0x07, 0xf8, 0x3f, 0x80, 0x7f, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xe0, 0xff, 0x00, 0xfe, 0x01,
+ 0xc0, 0xdf, 0x7f, 0x3f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x7f, 0xff, 0xfd, 0x00, 0x00, 0x1c, 0x00, 0x1f,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x70, 0x00, 0x7c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
+
+
+/* Send the current framebuffer vbitmap as an interrupt message */
+static int g13_fb_vbitmap_send(struct hid_device *hdev)
+{
+	struct usb_interface *intf;
+	struct usb_device *usbdev;
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	/* Get the usb device to send the image on */
+	intf = to_usb_interface(hdev->dev.parent);
+	usbdev = interface_to_usbdev(intf);
+
+	return usb_interrupt_msg(usbdev, usb_sndintpipe(usbdev, 0x02),
+				 data->fb_vbitmap, G13_VBITMAP_SIZE,
+				 NULL, USB_CTRL_SET_TIMEOUT*2);
+}
+
+/* Update fb_vbitmap from the screen_base and send to the device */
+static void g13_fb_update(struct g13_data *data)
+{
+	int row;
+	int col;
+	int bit;
+	u8 *u;
+	size_t offset;
+	u8 temp;
+
+	/* Clear the vbitmap and set the necessary magic number */
+	memset(data->fb_vbitmap, 0x00, G13_VBITMAP_SIZE);
+	data->fb_vbitmap[0] = 0x03;
+
+	/*
+	 * Translate the XBM format screen_base into the format needed by the
+	 * G13. This format places the pixels in a vertical rather than
+	 * horizontal format. Assuming a grid with 0,0 in the upper left corner
+	 * and 159,42 in the lower right corner, the first byte contains the
+	 * pixels 0,0 through 0,7 and the second byte contains the pixels 1,0
+	 * through 1,7. Within the byte, bit 0 represents 0,0; bit 1 0,1; etc.
+	 *
+	 * This loop operates in reverse to shift the lower bits into their
+	 * respective positions, shifting the lower rows into the higher bits.
+	 *
+	 * The offset is calculated for every 8 rows and is adjusted by 32 since
+	 * that is what the G13 image message expects.
+	 */
+	for (row = G13FB_HEIGHT-1; row >= 0; row--) {
+		offset = 32 + row/8 * G13FB_WIDTH;
+		u = data->fb_vbitmap + offset;
+		/*
+		 * Iterate across the screen_base columns to get the
+		 * individual bits
+		 */
+		for (col = 0; col < G13FB_LINE_LENGTH; col++) {
+			/*
+			 * We will work with a temporary value since we don't
+			 * want to modify screen_base as we shift each bit
+			 * downward.
+			 */
+			temp = data->fb_bitmap[row * G13FB_LINE_LENGTH + col];
+
+			/*
+			 * For each bit in the pixel row we will shift it onto
+			 * the appropriate by by shift the g13 byte up by 1 and
+			 * simply doing a bitwise or of the low byte
+			 */
+			for (bit = 0; bit < 8; bit++) {
+				/*Shift the g13 byte up by 1 for this new row*/
+				u[bit] <<= 1;
+				/* Bring in the new pixel of temp */
+				u[bit] |= (temp & 0x01);
+				/*
+				 * Shift temp down so the low pixel is ready
+				 * for the next byte
+				 */
+				temp >>= 1;
+			}
+
+			/*
+			 * The last byte represented 8 vertical pixels so we'll
+			 * jump ahead 8
+			 */
+			u += 8;
+		}
+	}
+
+	/*
+	 * Now that we have translated screen_base into a format expected by
+	 * the g13 let's send out the vbitmap
+	 */
+	g13_fb_vbitmap_send(data->hdev);
+
+}
+
+/* Callback from deferred IO workqueue */
+static void g13_fb_deferred_io(struct fb_info *info, struct list_head *pagelist)
+{
+	g13_fb_update(info->par);
+}
+
+/* Stub to call the system default and update the image on the g13 */
+static void g13_fb_fillrect(struct fb_info *info,
+			    const struct fb_fillrect *rect)
+{
+	struct g13_data *par = info->par;
+
+	sys_fillrect(info, rect);
+
+	g13_fb_update(par);
+}
+
+/* Stub to call the system default and update the image on the g13 */
+static void g13_fb_copyarea(struct fb_info *info,
+			    const struct fb_copyarea *area)
+{
+	struct g13_data *par = info->par;
+
+	sys_copyarea(info, area);
+
+	g13_fb_update(par);
+}
+
+/* Stub to call the system default and update the image on the g13 */
+static void g13_fb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	struct g13_data *par = info->par;
+
+	sys_imageblit(info, image);
+
+	g13_fb_update(par);
+}
+
+/*
+ * this is the slow path from userspace. they can seek and write to
+ * the fb. it's inefficient to do anything less than a full screen draw
+ */
+static ssize_t g13_fb_write(struct fb_info *info, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	struct g13_data *par = info->par;
+	unsigned long p = *ppos;
+	void *dst;
+	int err = 0;
+	unsigned long total_size;
+
+	if (info->state != FBINFO_STATE_RUNNING)
+		return -EPERM;
+
+	total_size = info->fix.smem_len;
+
+	if (p > total_size)
+		return -EFBIG;
+
+	if (count > total_size) {
+		err = -EFBIG;
+		count = total_size;
+	}
+
+	if (count + p > total_size) {
+		if (!err)
+			err = -ENOSPC;
+
+		count = total_size - p;
+	}
+
+	dst = (void __force *)(info->screen_base + p);
+
+	if (copy_from_user(dst, buf, count))
+		err = -EFAULT;
+
+	if (!err)
+		*ppos += count;
+
+	g13_fb_update(par);
+
+	return (err) ? err : count;
+}
+
+static struct fb_ops g13fb_ops = {
+	.owner = THIS_MODULE,
+	.fb_read = fb_sys_read,
+	.fb_write = g13_fb_write,
+	.fb_fillrect  = g13_fb_fillrect,
+	.fb_copyarea  = g13_fb_copyarea,
+	.fb_imageblit = g13_fb_imageblit,
+};
+
+/*
+ * The "fb_node" attribute
+ */
+static ssize_t g13_fb_node_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	unsigned fb_node;
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	fb_node = data->fb_info->node;
+
+	return sprintf(buf, "%u\n", fb_node);
+}
+
+static DEVICE_ATTR(fb_node, 0444, g13_fb_node_show, NULL);
+
+
+/*
+ * The "fb_update_rate" attribute
+ */
+static ssize_t g13_fb_update_rate_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	unsigned fb_update_rate;
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	fb_update_rate = data->fb_update_rate;
+
+	return sprintf(buf, "%u\n", fb_update_rate);
+}
+
+static ssize_t g13_set_fb_update_rate(struct hid_device *hdev,
+				      unsigned fb_update_rate)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	if (fb_update_rate > G13FB_UPDATE_RATE_LIMIT)
+		data->fb_update_rate = G13FB_UPDATE_RATE_LIMIT;
+	else if (fb_update_rate == 0)
+		data->fb_update_rate = 1;
+	else
+		data->fb_update_rate = fb_update_rate;
+
+	data->fb_defio.delay = HZ / data->fb_update_rate;
+
+	return 0;
+}
+
+static ssize_t g13_fb_update_rate_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned u;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u", &u);
+	if (i != 1) {
+		dev_warn(dev, G13_NAME " unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_fb_update_rate(hdev, u);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(fb_update_rate, 0666,
+		   g13_fb_update_rate_show,
+		   g13_fb_update_rate_store);
+
+
+static ssize_t g13_led_send(struct hid_device *hdev)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	data->led_report->field[0]->value[0] = data->led&0x0F;
+	data->led_report->field[0]->value[1] = 0x00;
+	data->led_report->field[0]->value[2] = 0x00;
+	data->led_report->field[0]->value[3] = 0x00;
+
+	usbhid_submit_report(hdev, data->led_report, USB_DIR_OUT);
+
+	return 0;
+}
+
+static void g13_led_set(struct led_classdev *led_cdev,
+			 enum led_brightness value,
+			 int led_num)
+{
+	struct device *dev;
+	struct hid_device *hdev;
+	struct g13_data *data;
+	u8 mask;
+
+	/* Get the device associated with the led */
+	dev = led_cdev->dev->parent;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* Get the underlying data value */
+	data = hid_get_g13data(hdev);
+
+	mask = 0x01<<led_num;
+	if (value)
+		data->led |= mask;
+	else
+		data->led &= ~mask;
+
+	g13_led_send(hdev);
+}
+
+static void g13_led_m1_brightness_set(struct led_classdev *led_cdev,
+				      enum led_brightness value)
+{
+	g13_led_set(led_cdev, value, G13_LED_M1);
+}
+
+static void g13_led_m2_brightness_set(struct led_classdev *led_cdev,
+				      enum led_brightness value)
+{
+	g13_led_set(led_cdev, value, G13_LED_M2);
+}
+
+static void g13_led_m3_brightness_set(struct led_classdev *led_cdev,
+				      enum led_brightness value)
+{
+	g13_led_set(led_cdev, value, G13_LED_M3);
+}
+
+static void g13_led_mr_brightness_set(struct led_classdev *led_cdev,
+				      enum led_brightness value)
+{
+	g13_led_set(led_cdev, value, G13_LED_MR);
+}
+
+static enum led_brightness g13_led_brightness_get(struct led_classdev *led_cdev)
+{
+	struct device *dev;
+	struct hid_device *hdev;
+	struct g13_data *data;
+	int value = 0;
+
+	/* Get the device associated with the led */
+	dev = led_cdev->dev->parent;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* Get the underlying data value */
+	data = hid_get_g13data(hdev);
+
+	if (led_cdev == data->led[G13_LED_M1])
+		value = data->led & 0x01;
+	else if (led_cdev == data->led[G13_LED_M2])
+		value = data->led & 0x02;
+	else if (led_cdev == data->led[G13_LED_M3])
+		value = data->led & 0x04;
+	else if (led_cdev == data->led[G13_LED_MR])
+		value = data->led & 0x08;
+	else
+		dev_info(dev, G13_NAME " error retrieving LED brightness\n");
+
+	if (value)
+		return LED_FULL;
+	return LED_OFF;
+}
+
+static const struct led_classdev g13_leds[4] = {
+	{
+		.brightness_set		= g13_led_m1_brightness_set,
+		.brightness_get		= g13_led_brightness_get,
+	},
+	{
+		.brightness_set		= g13_led_m2_brightness_set,
+		.brightness_get		= g13_led_brightness_get,
+	},
+	{
+		.brightness_set		= g13_led_m3_brightness_set,
+		.brightness_get		= g13_led_brightness_get,
+	},
+	{
+		.brightness_set		= g13_led_mr_brightness_set,
+		.brightness_get		= g13_led_brightness_get,
+	},
+};
+
+static int g13_input_setkeycode(struct input_dev *dev,
+				int scancode,
+				int keycode)
+{
+	int old_keycode;
+	int i;
+	struct g13_data *data = input_get_g13data(dev);
+
+	if (scancode >= dev->keycodemax)
+		return -EINVAL;
+
+	spin_lock(&data->lock);
+
+	old_keycode = data->keycode[scancode];
+	data->keycode[scancode] = keycode;
+
+	__clear_bit(old_keycode, dev->keybit);
+	__set_bit(keycode, dev->keybit);
+
+	for (i = 0; i < dev->keycodemax; i++) {
+		if (data->keycode[i] == old_keycode) {
+			__set_bit(old_keycode, dev->keybit);
+			break; /* Setting the bit twice is useless, so break*/
+		}
+	}
+
+	spin_unlock(&data->lock);
+
+	return 0;
+}
+
+static int g13_input_getkeycode(struct input_dev *dev,
+				int scancode,
+				int *keycode)
+{
+	struct g13_data *data = input_get_g13data(dev);
+
+	if (!dev->keycodesize)
+		return -EINVAL;
+
+	if (scancode >= dev->keycodemax)
+		return -EINVAL;
+
+	*keycode = data->keycode[scancode];
+
+	return 0;
+}
+
+
+/*
+ * The "keymap" attribute
+ */
+static ssize_t g13_keymap_index_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", data->curkeymap);
+}
+
+static ssize_t g13_set_keymap_index(struct hid_device *hdev, unsigned k)
+{
+	int scancode;
+	int offset_old;
+	int offset_new;
+	int keycode_old;
+	int keycode_new;
+	struct g13_data *data = hid_get_g13data(hdev);
+	struct input_dev *idev = data->input_dev;
+
+	if (k > 2)
+		return -EINVAL;
+
+	/*
+	 * Release all the pressed keys unless the new keymap has the same key
+	 * in the same scancode position.
+	 *
+	 * Also, clear the scancode state unless the new keymap has the same
+	 * key in the same scancode position.
+	 *
+	 * This allows a keycode mapped to the same scancode in two different
+	 * keymaps to remain pressed without a key up code when the keymap is
+	 * switched.
+	 */
+	offset_old = G13_KEYS * data->curkeymap;
+	offset_new = G13_KEYS * k;
+	for (scancode = 0; scancode < G13_KEYS; scancode++) {
+		keycode_old = data->keycode[offset_old+scancode];
+		keycode_new = data->keycode[offset_new+scancode];
+		if (keycode_old != keycode_new) {
+			if (keycode_old != KEY_RESERVED)
+				input_report_key(idev, keycode_old, 0);
+			data->scancode_state[scancode] = 0;
+		}
+	}
+
+	data->curkeymap = k;
+
+	if (data->keymap_switching) {
+		data->led = 1 << k;
+		g13_led_send(hdev);
+	}
+
+	return 0;
+}
+
+static ssize_t g13_keymap_index_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned k;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u", &k);
+	if (i != 1) {
+		dev_warn(dev, G13_NAME " unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_keymap_index(hdev, k);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(keymap_index, 0666,
+		   g13_keymap_index_show,
+		   g13_keymap_index_store);
+
+/*
+ * The "keycode" attribute
+ */
+static ssize_t g13_keymap_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	int offset = 0;
+	int result;
+	int scancode;
+	int keycode;
+	int error;
+
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	for (scancode = 0; scancode < G13_KEYMAP_SIZE; scancode++) {
+		error = input_get_keycode(data->input_dev, scancode, &keycode);
+		if (error) {
+			dev_warn(dev, G13_NAME " error accessing scancode %d\n",
+				 scancode);
+			continue;
+		}
+
+		result = sprintf(buf+offset, "0x%03x 0x%04x\n",
+				 scancode, keycode);
+		if (result < 0)
+			return -EINVAL;
+		offset += result;
+	}
+
+	return offset+1;
+}
+
+static ssize_t g13_keymap_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int scanned;
+	int consumed;
+	int scancd;
+	int keycd;
+	int error;
+	int set = 0;
+	int gkey;
+	int index;
+	int good;
+	struct g13_data *data;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	/* Now, let's get the data structure */
+	data = hid_get_g13data(hdev);
+
+	do {
+		good = 0;
+
+		/* Look for scancode keycode pair in hex */
+		scanned = sscanf(buf, "%x %x%n", &scancd, &keycd, &consumed);
+		if (scanned == 2) {
+			buf += consumed;
+			error = g13_input_setkeycode(data->input_dev, scancd, keycd);
+			if (error)
+				goto err_input_setkeycode;
+			set++;
+			good = 1;
+		} else {
+			/*
+			 * Look for Gkey keycode pair and assign to current
+			 * keymap
+			 */
+			scanned = sscanf(buf, "G%d %x%n", &gkey, &keycd, &consumed);
+			if (scanned == 2 && gkey > 0 && gkey <= G13_KEYS) {
+				buf += consumed;
+				scancd = data->curkeymap * G13_KEYS + gkey - 1;
+				error = g13_input_setkeycode(data->input_dev, scancd, keycd);
+				if (error)
+					goto err_input_setkeycode;
+				set++;
+				good = 1;
+			} else {
+				/*
+				 * Look for Gkey-index keycode pair and assign
+				 * to indexed keymap
+				 */
+				scanned = sscanf(buf, "G%d-%d %x%n", &gkey, &index, &keycd, &consumed);
+				if (scanned == 3 &&
+				    gkey > 0 && gkey <= G13_KEYS &&
+				    index >= 0 && index <= 2) {
+					buf += consumed;
+					scancd = index * G13_KEYS + gkey - 1;
+					error = g13_input_setkeycode(data->input_dev, scancd, keycd);
+					if (error)
+						goto err_input_setkeycode;
+					set++;
+					good = 1;
+				}
+			}
+		}
+
+	} while (good);
+
+	if (set == 0) {
+		dev_warn(dev, G13_NAME " unrecognized keycode input: %s", buf);
+		return -1;
+	}
+
+	return count;
+
+err_input_setkeycode:
+	dev_warn(dev, G13_NAME " error setting scancode %d to keycode %d\n",
+		 scancd, keycd);
+	return error;
+}
+
+static DEVICE_ATTR(keymap, 0666, g13_keymap_show, g13_keymap_store);
+
+/*
+ * The "keymap_switching" attribute
+ */
+static ssize_t g13_keymap_switching_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%u\n", data->keymap_switching);
+}
+
+static ssize_t g13_set_keymap_switching(struct hid_device *hdev, unsigned k)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	data->keymap_switching = k;
+
+	if (data->keymap_switching) {
+		data->led = 1 << data->curkeymap;
+		g13_led_send(hdev);
+	}
+
+	return 0;
+}
+
+static ssize_t g13_keymap_switching_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned k;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u", &k);
+	if (i != 1) {
+		dev_warn(dev, G13_NAME "unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_keymap_switching(hdev, k);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(keymap_switching, 0644,
+		   g13_keymap_switching_show,
+		   g13_keymap_switching_store);
+
+
+static ssize_t g13_name_show(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+	int result;
+
+	if (data->name == NULL) {
+		buf[0] = 0x00;
+		return 1;
+	}
+
+	spin_lock(&data->lock);
+	result = sprintf(buf, "%s", data->name);
+	spin_unlock(&data->lock);
+
+	return result;
+}
+
+static ssize_t g13_name_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+	size_t limit = count;
+	char *end;
+
+	spin_lock(&data->lock);
+
+	if (data->name != NULL) {
+		kfree(data->name);
+		data->name = NULL;
+	}
+
+	end = strpbrk(buf, "\n\r");
+	if (end != NULL)
+		limit = end - buf;
+
+	if (end != buf) {
+
+		if (limit > 100)
+			limit = 100;
+
+		data->name = kzalloc(limit+1, GFP_KERNEL);
+
+		strncpy(data->name, buf, limit);
+	}
+
+	spin_unlock(&data->lock);
+
+	return count;
+}
+
+static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
+
+/*
+ * The "rgb" attribute
+ * red green blue
+ * each with values 0 - 255 (black - full intensity)
+ */
+static ssize_t g13_rgb_show(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	unsigned r, g, b;
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	r = data->rgb[0];
+	g = data->rgb[1];
+	b = data->rgb[2];
+
+	return sprintf(buf, "%u %u %u\n", r, g, b);
+}
+
+static ssize_t g13_set_rgb(struct hid_device *hdev,
+			   unsigned r, unsigned g, unsigned b)
+{
+	struct g13_data *data = hid_get_g13data(hdev);
+
+	data->backlight_report->field[0]->value[0] = r;
+	data->backlight_report->field[0]->value[1] = g;
+	data->backlight_report->field[0]->value[2] = b;
+	data->backlight_report->field[0]->value[3] = 0x00;
+
+	usbhid_submit_report(hdev, data->backlight_report, USB_DIR_OUT);
+
+	data->rgb[0] = r;
+	data->rgb[1] = g;
+	data->rgb[2] = b;
+
+	return 0;
+}
+
+static ssize_t g13_rgb_store(struct device *dev,
+			     struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct hid_device *hdev;
+	int i;
+	unsigned r;
+	unsigned g;
+	unsigned b;
+	ssize_t set_result;
+
+	/* Get the hid associated with the device */
+	hdev = container_of(dev, struct hid_device, dev);
+
+	/* If we have an invalid pointer we'll return ENODATA */
+	if (hdev == NULL || &(hdev->dev) != dev)
+		return -ENODATA;
+
+	i = sscanf(buf, "%u %u %u", &r, &g, &b);
+	if (i != 3) {
+		dev_warn(dev, G13_NAME "unrecognized input: %s", buf);
+		return -1;
+	}
+
+	set_result = g13_set_rgb(hdev, r, g, b);
+
+	if (set_result < 0)
+		return set_result;
+
+	return count;
+}
+
+static DEVICE_ATTR(rgb, 0666, g13_rgb_show, g13_rgb_store);
+
+/*
+ * The "minor" attribute
+ */
+static ssize_t g13_minor_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct g13_data *data = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", data->hdev->minor);
+}
+
+static DEVICE_ATTR(minor, 0444, g13_minor_show, NULL);
+
+/*
+ * Create a group of attributes so that we can create and destroy them all
+ * at once.
+ */
+static struct attribute *g13_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_rgb.attr,
+	&dev_attr_keymap_index.attr,
+	&dev_attr_keymap_switching.attr,
+	&dev_attr_keymap.attr,
+	&dev_attr_minor.attr,
+	&dev_attr_fb_update_rate.attr,
+	&dev_attr_fb_node.attr,
+	NULL,	 /* need to NULL terminate the list of attributes */
+};
+
+/*
+ * An unnamed attribute group will put all of the attributes directly in
+ * the kobject directory.  If we specify a name, a subdirectory will be
+ * created for the attributes with the directory being the name of the
+ * attribute group.
+ */
+static struct attribute_group g13_attr_group = {
+	.attrs = g13_attrs,
+};
+
+static struct fb_deferred_io g13_fb_defio = {
+	.delay = HZ / G13FB_UPDATE_RATE_DEFAULT,
+	.deferred_io = g13_fb_deferred_io,
+};
+
+static void g13_handle_key_event(struct g13_data *data,
+				 struct input_dev *idev,
+				 int scancode,
+				 int value)
+{
+	int error;
+	int keycode;
+	int offset;
+
+	offset = G13_KEYS * data->curkeymap;
+
+	error = input_get_keycode(idev, scancode+offset, &keycode);
+
+	if (error) {
+		dev_warn(&idev->dev, G13_NAME " error in input_get_keycode(): scancode=%d\n", scancode);
+		return;
+	}
+
+	/* Only report mapped keys */
+	if (keycode != KEY_RESERVED)
+		input_report_key(idev, keycode, value);
+	/* Or report MSC_SCAN on keypress of an unmapped key */
+	else if (data->scancode_state[scancode] == 0 && value)
+		input_event(idev, EV_MSC, MSC_SCAN, scancode);
+
+	data->scancode_state[scancode] = value;
+}
+
+static void g13_raw_event_process_input(struct hid_device *hdev,
+					struct g13_data *data,
+					u8 *raw_data)
+{
+	struct input_dev *idev = data->input_dev;
+	int scancode;
+	int value;
+	int i;
+	int mask;
+
+	if (!data->ready.done && data->ready_stages != G13_READY) {
+		data->ready_stages |= G13_READY_STAGE_2;
+		if (data->ready_stages == G13_READY)
+			complete_all(&data->ready);
+	}
+
+	/*
+	 * We'll check for the M* keys being pressed before processing
+	 * the remainder of the key data. That way the new keymap will
+	 * be loaded if there is a keymap switch.
+	 */
+	if (data->keymap_switching) {
+		if (data->curkeymap != 0 && raw_data[6] & 0x20)
+			g13_set_keymap_index(hdev, 0);
+		else if (data->curkeymap != 1 && raw_data[6] & 0x40)
+			g13_set_keymap_index(hdev, 1);
+		else if (data->curkeymap != 2 && raw_data[6] & 0x80)
+			g13_set_keymap_index(hdev, 2);
+	}
+
+	for (i = 0, mask = 0x01; i < 8; i++, mask <<= 1) {
+		/* Keys G1 through G8 */
+		scancode = i;
+		value = raw_data[3] & mask;
+		g13_handle_key_event(data, idev, scancode, value);
+
+		/* Keys G9 through G16 */
+		scancode = i + 8;
+		value = raw_data[4] & mask;
+		g13_handle_key_event(data, idev, scancode, value);
+
+		/* Keys G17 through G22 */
+		scancode = i + 16;
+		value = raw_data[5] & mask;
+		if (i <= 5)
+			g13_handle_key_event(data, idev, scancode, value);
+
+		/* Keys FUNC through M3 */
+		scancode = i + 22;
+		value = raw_data[6] & mask;
+		g13_handle_key_event(data, idev, scancode, value);
+
+		/* Keys MR through LIGHT */
+		scancode = i + 30;
+		value = raw_data[7] & mask;
+		if (i <= 4)
+			g13_handle_key_event(data, idev, scancode, value);
+	}
+
+	input_report_abs(idev, ABS_X, raw_data[1]);
+	input_report_abs(idev, ABS_Y, raw_data[2]);
+	input_sync(idev);
+}
+
+static int g13_raw_event(struct hid_device *hdev,
+			 struct hid_report *report,
+			 u8 *raw_data, int size)
+{
+	/*
+	* On initialization receive a 258 byte message with
+	* data = 6 0 255 255 255 255 255 255 255 255 ...
+	*/
+	struct g13_data *data;
+	data = dev_get_drvdata(&hdev->dev);
+
+	if (data == NULL)
+		return 1;
+
+	switch (report->id) {
+	case 6:
+		if (data->ready.done)
+			break;
+		data->ready_stages |= G13_READY_STAGE_1;
+		if (data->ready_stages == G13_READY)
+			complete_all(&data->ready);
+		break;
+	case 1:
+		g13_raw_event_process_input(hdev, data, raw_data);
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void g13_initialize_keymap(struct g13_data *data)
+{
+	int i;
+
+	for (i = 0; i < G13_KEYS; i++) {
+		data->keycode[i] = g13_default_key_map[i];
+		__set_bit(data->keycode[i], data->input_dev->keybit);
+	}
+
+	__clear_bit(KEY_RESERVED, data->input_dev->keybit);
+}
+
+static int g13_probe(struct hid_device *hdev,
+		     const struct hid_device_id *id)
+{
+	int error;
+	struct g13_data *data;
+	int i;
+	int led_num;
+	struct list_head *feature_report_list =
+		&hdev->report_enum[HID_FEATURE_REPORT].report_list;
+	struct hid_report *report;
+	char *led_name;
+
+	dev_dbg(&hdev->dev, "Logitech G13 HID hardware probe...");
+
+	/*
+	 * Let's allocate the g13 data structure, set some reasonable
+	 * defaults, and associate it with the device
+	 */
+	data = kzalloc(sizeof(struct g13_data), GFP_KERNEL);
+	if (data == NULL) {
+		dev_err(&hdev->dev, "can't allocate space for Logitech G13 device attributes\n");
+		error = -ENOMEM;
+		goto err_no_cleanup;
+	}
+
+	spin_lock_init(&data->lock);
+
+	init_completion(&data->ready);
+
+	data->hdev = hdev;
+
+	data->fb_bitmap = vmalloc(G13FB_SIZE);
+	if (data->fb_bitmap == NULL) {
+		dev_err(&hdev->dev, G13_NAME ": ERROR: can't get a free page for framebuffer\n");
+		error = -ENOMEM;
+		goto err_cleanup_data;
+	}
+	memcpy(data->fb_bitmap, g13_lcd_bits, G13FB_SIZE);
+
+	data->fb_vbitmap = kmalloc(sizeof(u8) * G13_VBITMAP_SIZE, GFP_KERNEL);
+	if (data->fb_vbitmap == NULL) {
+		dev_err(&hdev->dev, G13_NAME ": ERROR: can't alloc vbitmap image buffer\n");
+		error = -ENOMEM;
+		goto err_cleanup_fb_bitmap;
+	}
+
+	hid_set_drvdata(hdev, data);
+
+	dbg_hid("Preparing to parse " G13_NAME " hid reports\n");
+
+	/* Parse the device reports and start it up */
+	error = hid_parse(hdev);
+	if (error) {
+		dev_err(&hdev->dev, G13_NAME " device report parse failed\n");
+		error = -EINVAL;
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	error = hid_hw_start(hdev, HID_CONNECT_DEFAULT | HID_CONNECT_HIDINPUT_FORCE);
+	if (error) {
+		dev_err(&hdev->dev, G13_NAME " hardware start failed\n");
+		error = -EINVAL;
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	dbg_hid(G13_NAME " claimed: %d\n", hdev->claimed);
+
+	error = hdev->ll_driver->open(hdev);
+	if (error) {
+		dev_err(&hdev->dev, G13_NAME " failed to open input interrupt pipe for key and joystick events\n");
+		error = -EINVAL;
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	/* Set up the input device for the key I/O */
+	data->input_dev = input_allocate_device();
+	if (data->input_dev == NULL) {
+		dev_err(&hdev->dev, G13_NAME " error initializing the input device");
+		error = -ENOMEM;
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	input_set_drvdata(data->input_dev, hdev);
+
+	data->input_dev->name = G13_NAME;
+	data->input_dev->phys = hdev->phys;
+	data->input_dev->uniq = hdev->uniq;
+	data->input_dev->id.bustype = hdev->bus;
+	data->input_dev->id.vendor = hdev->vendor;
+	data->input_dev->id.product = hdev->product;
+	data->input_dev->id.version = hdev->version;
+	data->input_dev->dev.parent = hdev->dev.parent;
+	data->input_dev->keycode = data->keycode;
+	data->input_dev->keycodemax = G13_KEYMAP_SIZE;
+	data->input_dev->keycodesize = sizeof(int);
+	data->input_dev->setkeycode = g13_input_setkeycode;
+	data->input_dev->getkeycode = g13_input_getkeycode;
+
+	input_set_capability(data->input_dev, EV_ABS, ABS_X);
+	input_set_capability(data->input_dev, EV_ABS, ABS_Y);
+	input_set_capability(data->input_dev, EV_MSC, MSC_SCAN);
+	input_set_capability(data->input_dev, EV_KEY, KEY_UNKNOWN);
+	data->input_dev->evbit[0] |= BIT_MASK(EV_REP);
+
+	/* 4 center values */
+	input_set_abs_params(data->input_dev, ABS_X, 0, 0xff, 0, 4);
+	input_set_abs_params(data->input_dev, ABS_Y, 0, 0xff, 0, 4);
+
+	g13_initialize_keymap(data);
+
+	error = input_register_device(data->input_dev);
+	if (error) {
+		dev_err(&hdev->dev, G13_NAME " error registering the input device");
+		error = -EINVAL;
+		goto err_cleanup_input_dev;
+	}
+
+	/* Set up the framebuffer device */
+	data->fb_update_rate = G13FB_UPDATE_RATE_DEFAULT;
+	data->fb_info = framebuffer_alloc(0, &hdev->dev);
+	if (data->fb_info == NULL) {
+		dev_err(&hdev->dev, G13_NAME " failed to allocate a framebuffer\n");
+		goto err_cleanup_input_dev;
+	}
+
+	dbg_hid(KERN_INFO G13_NAME " allocated framebuffer\n");
+
+	data->fb_defio = g13_fb_defio;
+	data->fb_info->fbdefio = &data->fb_defio;
+
+	dbg_hid(KERN_INFO G13_NAME " allocated deferred IO structure\n");
+
+	data->fb_info->screen_base = (char __force __iomem *) data->fb_bitmap;
+	data->fb_info->fbops = &g13fb_ops;
+	data->fb_info->var = g13fb_var;
+	data->fb_info->fix = g13fb_fix;
+	data->fb_info->fix.smem_len = G13FB_SIZE;
+	data->fb_info->par = data;
+	data->fb_info->flags = FBINFO_FLAG_DEFAULT;
+
+	fb_deferred_io_init(data->fb_info);
+
+	if (register_framebuffer(data->fb_info) < 0)
+		goto err_cleanup_fb;
+
+	if (list_empty(feature_report_list)) {
+		dev_err(&hdev->dev, "no feature report found\n");
+		error = -ENODEV;
+		goto err_cleanup_fb;
+	}
+	dbg_hid("G13 feature report found\n");
+
+	list_for_each_entry(report, feature_report_list, list) {
+		switch (report->id) {
+		case 0x04:
+			data->report_4 = report;
+			break;
+		case 0x05:
+			data->led_report = report;
+			break;
+		case 0x06:
+			data->start_input_report = report;
+			break;
+		case 0x07:
+			data->backlight_report = report;
+			break;
+		default:
+			break;
+		}
+		dbg_hid("G13 Feature report: id=%u type=%u size=%u maxfield=%u report_count=%u\n",
+			report->id, report->type, report->size,
+			report->maxfield, report->field[0]->report_count);
+	}
+
+	dbg_hid("Found all reports\n");
+
+	/* Create the LED structures */
+	for (i = 0; i < 4; i++) {
+		data->led[i] = kzalloc(sizeof(struct led_classdev), GFP_KERNEL);
+		if (data->led[i] == NULL) {
+			dev_err(&hdev->dev, G13_NAME " error allocating memory for led %d", i);
+			error = -ENOMEM;
+			goto err_cleanup_led_structs;
+		}
+		/* Set the accessor functions by copying from template*/
+		*(data->led[i]) = g13_leds[i];
+
+		/*
+		 * Allocate memory for the LED name
+		 *
+		 * Since led_classdev->name is a const char* we'll use an
+		 * intermediate until the name is formatted with sprintf().
+		 */
+		led_name = kzalloc(sizeof(char)*15, GFP_KERNEL);
+		if (led_name == NULL) {
+			dev_err(&hdev->dev, G13_NAME " error allocating memory for led %d name", i);
+			error = -ENOMEM;
+			goto err_cleanup_led_structs;
+		}
+		switch (i) {
+		case 0:
+		case 1:
+		case 2:
+			sprintf(led_name, "g13_%d:red:m%d", hdev->minor, i+1);
+			break;
+		case 3:
+			sprintf(led_name, "g13_%d:red:mr", hdev->minor);
+			break;
+		}
+		data->led[i]->name = led_name;
+	}
+
+	for (i = 0; i < 4; i++) {
+		led_num = i;
+		error = led_classdev_register(&hdev->dev, data->led[i]);
+		if (error < 0) {
+			dev_err(&hdev->dev, G13_NAME " error registering led %d", i);
+			error = -EINVAL;
+			goto err_cleanup_registered_leds;
+		}
+	}
+
+	dbg_hid("Waiting for G13 to activate\n");
+
+	wait_for_completion_interruptible_timeout(&data->ready, HZ*2);
+
+	/* Add the sysfs attributes */
+	error = sysfs_create_group(&(hdev->dev.kobj), &g13_attr_group);
+	if (error) {
+		dev_err(&hdev->dev, G13_NAME " failed to create sysfs group attributes\n");
+		goto err_cleanup_fb;
+	}
+
+	if (!(data->ready.done))
+		dev_warn(&hdev->dev, G13_NAME " hasn't responded yet, forging ahead with initialization\n");
+	else
+		dbg_hid("G13 initialized\n");
+
+	/*
+	 * Set the initial color and load the linux logo
+	 * We're going to ignore the error values. If there is an error at this
+	 * point we'll forge ahead.
+	 */
+
+	dbg_hid("Set default color\n");
+
+	error = g13_set_rgb(hdev, G13_DEFAULT_RED, G13_DEFAULT_GREEN, G13_DEFAULT_BLUE);
+	if (error)
+		dev_warn(&hdev->dev, G13_NAME " setting default color failed\n");
+
+	usbhid_submit_report(hdev, data->start_input_report, USB_DIR_IN);
+
+	/* Push the logo twice since it seems to sometimes fail */
+	g13_fb_update(data);
+	g13_fb_update(data);
+
+	g13_set_keymap_switching(hdev, 1);
+
+	dbg_hid("G13 activated and initialized\n");
+
+	/* Everything went well */
+	return 0;
+
+err_cleanup_registered_leds:
+	for (i = 0; i < led_num; i++)
+		led_classdev_unregister(data->led[i]);
+
+err_cleanup_led_structs:
+	for (i = 0; i < 4; i++) {
+		if (data->led[i] != NULL) {
+			if (data->led[i]->name != NULL)
+				kfree(data->led[i]->name);
+			kfree(data->led[i]);
+		}
+	}
+
+err_cleanup_fb:
+	framebuffer_release(data->fb_info);
+	input_unregister_device(data->input_dev);
+	goto err_cleanup_fb_vbitmap; /* to skip input_free_device() */
+
+err_cleanup_input_dev:
+	input_free_device(data->input_dev);
+
+err_cleanup_fb_vbitmap:
+	kfree(data->fb_vbitmap);
+
+err_cleanup_fb_bitmap:
+	vfree(data->fb_bitmap);
+
+err_cleanup_data:
+	/* Make sure we clean up the allocated data structure */
+	kfree(data);
+
+err_no_cleanup:
+
+	hid_set_drvdata(hdev, NULL);
+
+	return error;
+}
+
+static void g13_remove(struct hid_device *hdev)
+{
+	struct g13_data *data;
+	int i;
+
+	hdev->ll_driver->close(hdev);
+
+	hid_hw_stop(hdev);
+
+	sysfs_remove_group(&(hdev->dev.kobj), &g13_attr_group);
+
+	/* Get the internal g13 data buffer */
+	data = hid_get_drvdata(hdev);
+
+	input_unregister_device(data->input_dev);
+
+	kfree(data->name);
+
+	/* Clean up the leds */
+	for (i = 0; i < 4; i++) {
+		led_classdev_unregister(data->led[i]);
+		kfree(data->led[i]->name);
+		kfree(data->led[i]);
+	}
+
+	/* Clean up the framebuffer */
+	fb_deferred_io_cleanup(data->fb_info);
+	unregister_framebuffer(data->fb_info);
+	framebuffer_release(data->fb_info);
+	vfree(data->fb_bitmap);
+	kfree(data->fb_vbitmap);
+
+	/* Finally, clean up the g13 data itself */
+	kfree(data);
+}
+
+static const struct hid_device_id g13_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_G13)
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, g13_devices);
+
+static struct hid_driver g13_driver = {
+	.name =		"hid-g13",
+	.id_table =	g13_devices,
+	.probe =	g13_probe,
+	.remove =	g13_remove,
+	.raw_event =	g13_raw_event,
+};
+
+static int __init g13_init(void)
+{
+	return hid_register_driver(&g13_driver);
+}
+
+static void __exit g13_exit(void)
+{
+	hid_unregister_driver(&g13_driver);
+}
+
+module_init(g13_init);
+module_exit(g13_exit);
+MODULE_DESCRIPTION("Logitech G13 HID Driver");
+MODULE_AUTHOR("Rick L Vinyard Jr (rvinyard@cs.nmsu.edu)");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3839340..f3e27d3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -295,6 +295,7 @@
 #define USB_DEVICE_ID_LOGITECH_EXTREME_3D	0xc215
 #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2	0xc218
 #define USB_DEVICE_ID_LOGITECH_RUMBLEPAD2_2	0xc219
+#define USB_DEVICE_ID_LOGITECH_G13		0xc21c
 #define USB_DEVICE_ID_LOGITECH_WINGMAN_F3D	0xc283
 #define USB_DEVICE_ID_LOGITECH_FORCE3D_PRO	0xc286
 #define USB_DEVICE_ID_LOGITECH_WHEEL	0xc294
-- 
1.6.6

