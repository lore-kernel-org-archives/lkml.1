Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab0BXQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:02:28 -0500
Received: from legolas.restena.lu ([158.64.1.34]:50231 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab0BXQCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:02:23 -0500
Date: Wed, 24 Feb 2010 17:00:49 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: [PATCH 1/3] picolcd: driver for PicoLCD HID device
Message-ID: <20100224170049.0d04af3c@neptune.home>
In-Reply-To: <20100221002001.0a7e05a7@neptune.home>
References: <20100221002001.0a7e05a7@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for graphic PicoLCD device ( http://www.picolcd.com ) with
framebuffer support (using deferredio), backlight control via backlight
class, contrast control via lcd class and input for keypad.

More features of the device include CIR and GPIO, support for them will
be added at a later time.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Cc: Nicu Pavel <npavel@ituner.com>
---
Note, this patch requires
  "backlight: Add backlight_device parameter to check_fb"

Some lines are longer than suggested 80 columns, especially those for
the declaration of initial framebuffer content that I did format one
framebuffer line (256 pixel) per source line.

 drivers/hid/Kconfig                 |   18 ++
 drivers/hid/Makefile                |    1 +
 drivers/hid/hid-core.c              |    1 +
 drivers/hid/hid-ids.h               |    1 +
 drivers/hid/hid-picolcd.c           | 1075 +++++++++++++++++++++++++
 5 files changed, 1096 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 24d90ea..55915c8 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -183,6 +183,24 @@ config LOGIRUMBLEPAD2_FF
 	  Say Y here if you want to enable force feedback support for Logitech
 	  Rumblepad 2 devices.
 
+config HID_PICOLCD
+	tristate "Minibox PicoLCD (graphic version)"
+	depends on FB
+	select FB_DEFERRED_IO
+	select FB_SYS_FILLRECT
+	select FB_SYS_COPYAREA
+	select FB_SYS_IMAGEBLIT
+	select FB_SYS_FOPS
+	select BACKLIGHT_LCD_SUPPORT
+	select BACKLIGHT_CLASS_DEVICE
+	select LCD_CLASS_DEVICE
+	help
+	  This provides support for Minibox PicoLCD devices, currently
+	  only the graphical ones are supported. This includes support
+	  for the device as a keypad input with mappable keys as well as
+	  a framebuffer for the LCD display.
+	  Support for the GPIOs and IR is not yet implemented
+
 config HID_MICROSOFT
 	tristate "Microsoft" if EMBEDDED
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 0de2dff..450f09f 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_HID_GYRATION)	+= hid-gyration.o
 obj-$(CONFIG_HID_KENSINGTON)	+= hid-kensington.o
 obj-$(CONFIG_HID_KYE)		+= hid-kye.o
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
+obj-$(CONFIG_HID_PICOLCD)	+= hid-picolcd.o
 obj-$(CONFIG_HID_MICROSOFT)	+= hid-microsoft.o
 obj-$(CONFIG_HID_MONTEREY)	+= hid-monterey.o
 obj-$(CONFIG_HID_NTRIG)		+= hid-ntrig.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index eabe5f8..1db0b3a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1330,6 +1330,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_RUMBLEPAD2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACETRAVELLER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_SPACENAVIGATOR) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_LK6K) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 010368e..fc66622 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -330,6 +330,7 @@
 #define USB_VENDOR_ID_MICROCHIP		0x04d8
 #define USB_DEVICE_ID_PICKIT1		0x0032
 #define USB_DEVICE_ID_PICKIT2		0x0033
+#define USB_DEVICE_ID_PICOLCD		0xc002
 
 #define USB_VENDOR_ID_MICROSOFT		0x045e
 #define USB_DEVICE_ID_SIDEWINDER_GV	0x003b
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index e69de29..90f6be5 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -0,0 +1,1075 @@
+/***************************************************************************
+ *   Copyright (C) 2010 by Bruno Prémont <bonbons@linux-vserver.org>       *
+ *                                                                         *
+ *   Based on Logitech G13 driver (v0.4)                                   *
+ *     Copyright (C) 2009 by Rick L. Vinyard, Jr. <rvinyard@cs.nmsu.edu>   *
+ *                                                                         *
+ *   This program is free software: you can redistribute it and/or modify  *
+ *   it under the terms of the GNU General Public License as published by  *
+ *   the Free Software Foundation, either version 2 of the License.        *
+ *                                                                         *
+ *   This driver is distributed in the hope that it will be useful, but    *
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of            *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU      *
+ *   General Public License for more details.                              *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public License     *
+ *   along with this software. If not see <http://www.gnu.org/licenses/>.  *
+ ***************************************************************************/
+
+#include <linux/hid.h>
+#include <linux/input.h>
+#include "hid-ids.h"
+#include "usbhid/usbhid.h"
+#include <linux/usb.h>
+
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/lcd.h>
+#include <linux/vmalloc.h>
+
+#include <linux/completion.h>
+
+#define PICOLCD_NAME "PicoLCD (graphic)"
+
+/* Report numbers */
+#define REPORT_BRIGHTNESS   0x91
+#define REPORT_CONTRAST     0x92
+#define REPORT_RESET        0x93
+#define REPORT_LCD_CMD      0x94
+#define REPORT_LCD_DATA     0x95
+#define REPORT_LCD_CMD_DATA 0x96
+#define REPORT_VERSION      0xf1
+#define REPORT_SPLASH_SIZE  0xf6
+#define REPORT_KEYPAD       0x11
+/* Additional features of picoLCD that are not supported yet:
+ *  - CIR
+ *  - GPIO
+ *  - Programming / flashing (full firmware or just splash?)
+ *  - interface to ICSP header?
+ */
+
+/* Framebuffer
+ *
+ * The PicoLCD use a Topway LCD module of 256x64 pixel
+ * This display area is tiled over 4 controllers with 8 tiles
+ * each. Each tile has 8x64 pixel, each data byte representing
+ * a 1-bit wide vertical line of the tile.
+ *
+ * The display can be updated at a tile granularity.
+ *
+ *       Chip 1           Chip 2           Chip 3           Chip 4
+ * +----------------+----------------+----------------+----------------+
+ * |     Tile 1     |     Tile 1     |     Tile 1     |     Tile 1     |
+ * +----------------+----------------+----------------+----------------+
+ * |     Tile 2     |     Tile 2     |     Tile 2     |     Tile 2     |
+ * +----------------+----------------+----------------+----------------+
+ *                                  ...
+ * +----------------+----------------+----------------+----------------+
+ * |     Tile 8     |     Tile 8     |     Tile 8     |     Tile 8     |
+ * +----------------+----------------+----------------+----------------+
+ */
+#define PICOLCDFB_NAME "picolcdfb"
+#define PICOLCDFB_WIDTH (256)
+#define PICOLCDFB_LINE_LENGTH (256/8)
+#define PICOLCDFB_HEIGHT (64)
+#define PICOLCDFB_SIZE (PICOLCDFB_LINE_LENGTH*PICOLCDFB_HEIGHT)
+
+#define PICOLCDFB_UPDATE_RATE_LIMIT   10
+#define PICOLCDFB_UPDATE_RATE_DEFAULT  2
+
+/* Framebuffer visual structures */
+static const struct fb_fix_screeninfo picolcdfb_fix = {
+	.id          = PICOLCDFB_NAME,
+	.type        = FB_TYPE_PACKED_PIXELS,
+	.visual      = FB_VISUAL_MONO01,
+	.xpanstep    = 0,
+	.ypanstep    = 0,
+	.ywrapstep   = 0,
+	.line_length = PICOLCDFB_LINE_LENGTH,
+	.accel       = FB_ACCEL_NONE,
+};
+
+static const struct fb_var_screeninfo picolcdfb_var = {
+	.xres           = PICOLCDFB_WIDTH,
+	.yres           = PICOLCDFB_HEIGHT,
+	.xres_virtual   = PICOLCDFB_WIDTH,
+	.yres_virtual   = PICOLCDFB_HEIGHT,
+	.width          = 103,
+	.height         = 26,
+	.bits_per_pixel = 1,
+};
+
+#ifdef CONFIG_LOGO
+/*
+ * This is a default logo to be loaded upon driver initialization
+ * replacing the default PicoLCD image loaded on device
+ * initialization. This is to provide the user a cue that the
+ * Linux driver is loaded and ready.
+ *
+ * This logo contains the text PicoLCD in the center with one penguin
+ * on each side of the text. The penguins are a 64x64 rendition of
+ * the default framebuffer 80x80 monochrome image scaled down and
+ * cleaned up to retain something that looks a little better than
+ * a simple scaling.
+ *
+ * This logo is a simple xbm image created in GIMP and exported.
+ * To view the image copy the following two #defines plus the
+ * picolcd_bits to an ASCII text file and save with extension
+ * .xbm, then open with GIMP or any other graphical editor
+ * such as eog that recognizes the .xbm format.
+ */
+#define picolcd_width 256
+#define picolcd_height 64
+static const u8 picolcd_bits[PICOLCDFB_SIZE] = {
+	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1f, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xe7, 0xe7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xe7, 0xe7, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xdf, 0xf9, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xdf, 0xf9, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xbf, 0xfe, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xfe, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0x7f, 0xff, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xff, 0x7f, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0x7f, 0xcf, 0xbf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xcf, 0xbf, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0x7f, 0xdf, 0xbf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x7f, 0xdf, 0xbf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xff, 0xff, 0xbf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xbf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xff, 0xff, 0xdf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xdf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xff, 0xff, 0xdf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xdf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xcf, 0x8f, 0xdf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xcf, 0x8f, 0xdf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xc7, 0x07, 0xdf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xc7, 0x07, 0xdf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xd3, 0x67, 0xdf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xd3, 0x67, 0xdf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xfb, 0x73, 0xdf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xfb, 0x73, 0xdf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xff, 0xf3, 0xbf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xf3, 0xbf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xf0, 0x37, 0xbf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xf0, 0x37, 0xbf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xc5, 0x0f, 0xdf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xc5, 0x0f, 0xdf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xc0, 0x1b, 0xdf, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xc0, 0x1b, 0xdf, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xc0, 0x27, 0xef, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xc0, 0x27, 0xef, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xe0, 0xc7, 0xef, 0xff, 0xff, 0xff, 0xff, 0xff, 0xe3, 0xff, 0xff, 0xff, 0xfe, 0x3f, 0xfe, 0x00, 0x78, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xe0, 0xc7, 0xef, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xff, 0x1b, 0x67, 0xff, 0xff, 0xff, 0xff, 0xff, 0xe3, 0xff, 0xff, 0xff, 0xfe, 0x3f, 0xfc, 0x00, 0x38, 0x00, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xff, 0x1b, 0x67, 0xff, 0xff,
+	0xff, 0xff, 0xfe, 0xd0, 0xc3, 0xb7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xe3, 0xff, 0xff, 0xff, 0xfe, 0x3f, 0xfc, 0x00, 0x38, 0x00, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xfe, 0xd0, 0xc3, 0xb7, 0xff, 0xff,
+	0xff, 0xff, 0xfd, 0xcf, 0x03, 0xfb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0x3f, 0xfc, 0x7e, 0x38, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xfd, 0xcf, 0x03, 0xfb, 0xff, 0xff,
+	0xff, 0xff, 0xfd, 0xc0, 0x01, 0xfd, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xfd, 0xc0, 0x01, 0xfd, 0xff, 0xff,
+	0xff, 0xff, 0xfb, 0x80, 0x01, 0xfd, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xfb, 0x80, 0x01, 0xfd, 0xff, 0xff,
+	0xff, 0xff, 0xf7, 0x00, 0x00, 0xfe, 0xff, 0xff, 0xff, 0xf1, 0x01, 0xe3, 0xc0, 0x0f, 0x80, 0x1e, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xf7, 0x00, 0x00, 0xfe, 0xff, 0xff,
+	0xff, 0xff, 0xef, 0x00, 0x00, 0xff, 0x7f, 0xff, 0xff, 0xf0, 0x00, 0xe3, 0x80, 0x07, 0x00, 0x0e, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xef, 0x00, 0x00, 0xff, 0x7f, 0xff,
+	0xff, 0xff, 0xef, 0x00, 0x00, 0x7f, 0x7f, 0xff, 0xff, 0xf0, 0x00, 0xe3, 0x80, 0x07, 0x00, 0x0e, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xef, 0x00, 0x00, 0x7f, 0x7f, 0xff,
+	0xff, 0xff, 0xdf, 0x8c, 0x0f, 0x7f, 0xbf, 0xff, 0xff, 0xf1, 0xf8, 0xe3, 0x8f, 0xc7, 0x1f, 0x8e, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xdf, 0x8c, 0x0f, 0x7f, 0xbf, 0xff,
+	0xff, 0xff, 0xde, 0x08, 0x07, 0xbf, 0xdf, 0xff, 0xff, 0xf1, 0xf8, 0xe3, 0x8f, 0xff, 0x1f, 0x8e, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xde, 0x08, 0x07, 0xbf, 0xdf, 0xff,
+	0xff, 0xff, 0xbc, 0x00, 0x01, 0xff, 0xdf, 0xff, 0xff, 0xf1, 0xf8, 0xe3, 0x8f, 0xff, 0x1f, 0x8e, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xbc, 0x00, 0x01, 0xff, 0xdf, 0xff,
+	0xff, 0xff, 0xbc, 0x00, 0x00, 0x7f, 0xdf, 0xff, 0xff, 0xf1, 0xf8, 0xe3, 0x8f, 0xff, 0x1f, 0x8e, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xbc, 0x00, 0x00, 0x7f, 0xdf, 0xff,
+	0xff, 0xff, 0x78, 0x00, 0x00, 0x1f, 0xef, 0xff, 0xff, 0xf1, 0xf8, 0xe3, 0x8f, 0xff, 0x1f, 0x8e, 0x3f, 0xfc, 0x7f, 0xf8, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xff, 0x78, 0x00, 0x00, 0x1f, 0xef, 0xff,
+	0xff, 0xfe, 0xf8, 0x00, 0x00, 0x1d, 0xe7, 0xff, 0xff, 0xf1, 0xf8, 0xe3, 0x8f, 0xc7, 0x1f, 0x8e, 0x3f, 0x1c, 0x7e, 0x38, 0xfc, 0x7f, 0xff, 0xff, 0xff, 0xfe, 0xf8, 0x00, 0x00, 0x1d, 0xe7, 0xff,
+	0xff, 0xfe, 0xf0, 0x00, 0x00, 0x1d, 0xf7, 0xff, 0xff, 0xf0, 0x00, 0xe3, 0x80, 0x07, 0x00, 0x0e, 0x00, 0x1c, 0x00, 0x38, 0x00, 0x7f, 0xff, 0xff, 0xff, 0xfe, 0xf0, 0x00, 0x00, 0x1d, 0xf7, 0xff,
+	0xff, 0xfd, 0xf0, 0x00, 0x00, 0x1d, 0xf7, 0xff, 0xff, 0xf0, 0x00, 0xe3, 0x80, 0x07, 0x00, 0x0e, 0x00, 0x1c, 0x00, 0x38, 0x00, 0x7f, 0xff, 0xff, 0xff, 0xfd, 0xf0, 0x00, 0x00, 0x1d, 0xf7, 0xff,
+	0xff, 0xfd, 0xf0, 0x00, 0x00, 0x0e, 0xfb, 0xff, 0xff, 0xf1, 0x01, 0xe3, 0xc0, 0x0f, 0x80, 0x1e, 0x00, 0x1e, 0x00, 0x78, 0x00, 0xff, 0xff, 0xff, 0xff, 0xfd, 0xf0, 0x00, 0x00, 0x0e, 0xfb, 0xff,
+	0xff, 0xfd, 0xe0, 0x10, 0x00, 0x0e, 0xfb, 0xff, 0xff, 0xf1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfd, 0xe0, 0x10, 0x00, 0x0e, 0xfb, 0xff,
+	0xff, 0xfb, 0xe0, 0x10, 0x00, 0x0e, 0xfb, 0xff, 0xff, 0xf1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf9, 0x86, 0x7f, 0x3b, 0xff, 0xff, 0xff, 0xff, 0xfb, 0xe0, 0x10, 0x00, 0x0e, 0xfb, 0xff,
+	0xff, 0xfb, 0xe0, 0x10, 0x00, 0x0e, 0xfb, 0xff, 0xff, 0xf1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf6, 0xbd, 0xfe, 0xfb, 0xff, 0xff, 0xff, 0xff, 0xfb, 0xe0, 0x10, 0x00, 0x0e, 0xfb, 0xff,
+	0xff, 0xfb, 0xe0, 0x10, 0x00, 0x0e, 0xfb, 0xff, 0xff, 0xf1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfe, 0x8c, 0x6a, 0x36, 0xff, 0xff, 0xff, 0xff, 0xfb, 0xe0, 0x10, 0x00, 0x0e, 0xfb, 0xff,
+	0xff, 0xfb, 0xe0, 0x10, 0x00, 0x10, 0x3b, 0xff, 0xff, 0xf1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfd, 0xf5, 0xb6, 0xd0, 0xff, 0xff, 0xff, 0xff, 0xfb, 0xe0, 0x10, 0x00, 0x10, 0x3b, 0xff,
+	0xff, 0xfa, 0x30, 0x00, 0x00, 0x7f, 0xdb, 0xff, 0xff, 0xf1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfb, 0xf5, 0xaa, 0xde, 0xff, 0xff, 0xff, 0xff, 0xfa, 0x30, 0x00, 0x00, 0x7f, 0xdb, 0xff,
+	0xff, 0xfc, 0x38, 0x00, 0x00, 0x4f, 0xe7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf0, 0x8e, 0x7f, 0x3e, 0xff, 0xff, 0xff, 0xff, 0xfc, 0x38, 0x00, 0x00, 0x4f, 0xe7, 0xff,
+	0xff, 0xf8, 0x1c, 0x00, 0x00, 0x8f, 0xc7, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf8, 0x1c, 0x00, 0x00, 0x8f, 0xc7, 0xff,
+	0xff, 0xf0, 0x07, 0x00, 0x00, 0x87, 0x87, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xf0, 0x07, 0x00, 0x00, 0x87, 0x87, 0xff,
+	0xff, 0xc0, 0x07, 0x80, 0x00, 0x80, 0x07, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc0, 0x07, 0x80, 0x00, 0x80, 0x07, 0xff,
+	0xff, 0x00, 0x03, 0xc0, 0x00, 0x80, 0x07, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x03, 0xc0, 0x00, 0x80, 0x07, 0xff,
+	0xff, 0x00, 0x03, 0xc0, 0x00, 0x80, 0x03, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x03, 0xc0, 0x00, 0x80, 0x03, 0xff,
+	0xff, 0x00, 0x01, 0xc0, 0x00, 0x80, 0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x01, 0xc0, 0x00, 0x80, 0x00, 0xff,
+	0xff, 0x00, 0x01, 0xc0, 0x01, 0x80, 0x00, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x01, 0xc0, 0x01, 0x80, 0x00, 0x7f,
+	0xff, 0x00, 0x00, 0x80, 0x03, 0x80, 0x00, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x80, 0x03, 0x80, 0x00, 0x7f,
+	0xff, 0x00, 0x00, 0x40, 0x07, 0x80, 0x00, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x40, 0x07, 0x80, 0x00, 0x7f,
+	0xff, 0x00, 0x00, 0x00, 0x3f, 0x80, 0x01, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x3f, 0x80, 0x01, 0xff,
+	0xff, 0x00, 0x00, 0x3f, 0xff, 0x00, 0x03, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x3f, 0xff, 0x00, 0x03, 0xff,
+	0xff, 0x00, 0x00, 0x3f, 0xff, 0x00, 0x0f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x3f, 0xff, 0x00, 0x0f, 0xff,
+	0xff, 0x80, 0x00, 0x3f, 0xff, 0x00, 0x1f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80, 0x00, 0x3f, 0xff, 0x00, 0x1f, 0xff,
+	0xff, 0xfc, 0x00, 0x38, 0x03, 0x00, 0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xfc, 0x00, 0x38, 0x03, 0x00, 0x7f, 0xff,
+	0xff, 0xff, 0xc0, 0x07, 0xfc, 0x80, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc0, 0x07, 0xfc, 0x80, 0xff, 0xff,
+	0xff, 0xff, 0xe0, 0x7f, 0xff, 0x81, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xe0, 0x7f, 0xff, 0x81, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+#endif
+
+
+/* Input device
+ *
+ * The PicoLCD has an IR receiver header, a built-in keypad with 5 keys
+ * and header for 4x4 key matrix. The built-in keys are part of the matrix.
+ */
+#define PICOLCD_KEYS 33
+
+static const int def_keymap[PICOLCD_KEYS] = {
+	KEY_RESERVED, KEY_BACK, KEY_HOMEPAGE, KEY_RESERVED, KEY_RESERVED, KEY_SCROLLUP, KEY_OK, KEY_SCROLLDOWN,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED, KEY_RESERVED,
+	KEY_RESERVED
+};
+
+
+
+/* Per device data structure */
+struct picolcd_data {
+	struct hid_device *hdev;
+
+	/* input stuff */
+	struct input_dev *input_keys;
+	struct input_dev *input_cir;
+	int keycode[PICOLCD_KEYS];
+	u8 pressed_keys[2];
+
+	/* Framebuffer stuff */
+	u8 fb_update_rate;
+	u8 *fb_vbitmap;		/* local copy of what was sent to PicoLCD */
+	u8 *fb_bitmap;		/* framebuffer */
+	struct fb_info *fb_info;
+	struct fb_deferred_io fb_defio;
+	struct lcd_device *lcd;
+	struct backlight_device *backlight;
+	int lcd_contrast;
+	int lcd_power;
+	int lcd_brightness;
+
+	/* GPIO stuff */
+
+	/* Housekeeping stuff */
+	spinlock_t lock;
+	struct completion ready;
+	int status;
+#define PICOLCD_READY_ALIVE 1
+#define PICOLCD_READY_FB 2
+#define PICOLCD_READY_ALL (PICOLCD_READY_ALIVE | PICOLCD_READY_FB)
+};
+
+
+
+/* Find a given output report */
+static struct hid_report *picolcd_out_report(int id, struct hid_device *hdev)
+{
+	struct list_head *feature_report_list = &hdev->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct hid_report *report = NULL;
+
+	list_for_each_entry(report, feature_report_list, list) {
+		if (report->id == id)
+			return report;
+	}
+	dev_err(&hdev->dev, "No report with id 0x%x found\n", id);
+	return NULL;
+}
+
+
+
+/* Send a given tile to PicoLCD */
+static inline int picolcd_fb_send_tile(struct hid_device *hdev, int chip,
+		int tile)
+{
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+	struct hid_report *report1 = picolcd_out_report(REPORT_LCD_CMD_DATA, hdev);
+	struct hid_report *report2 = picolcd_out_report(REPORT_LCD_DATA, hdev);
+	u8 *tdata;
+	int i;
+
+	if (!report1 || report1->maxfield != 1 || !report2 || report2->maxfield != 1)
+		return -ENODEV;
+
+	hid_set_field(report1->field[0],  0, chip << 2);
+	hid_set_field(report1->field[0],  1, 0x02);
+	hid_set_field(report1->field[0],  2, 0x00);
+	hid_set_field(report1->field[0],  3, 0x00);
+	hid_set_field(report1->field[0],  4, 0xb8 | tile);
+	hid_set_field(report1->field[0],  5, 0x00);
+	hid_set_field(report1->field[0],  6, 0x00);
+	hid_set_field(report1->field[0],  7, 0x40);
+	hid_set_field(report1->field[0],  8, 0x00);
+	hid_set_field(report1->field[0],  9, 0x00);
+	hid_set_field(report1->field[0], 10,   32);
+
+	hid_set_field(report2->field[0],  0, (chip << 2) | 0x01);
+	hid_set_field(report2->field[0],  1, 0x00);
+	hid_set_field(report2->field[0],  2, 0x00);
+	hid_set_field(report2->field[0],  3,   32);
+
+	tdata = data->fb_vbitmap + (tile * 4 + chip) * 64;
+	for (i = 0; i < 64; i++)
+		if (i < 32)
+			hid_set_field(report1->field[0], 11 + i, tdata[i]);
+		else
+			hid_set_field(report2->field[0], 4 + i - 32, tdata[i]);
+
+	usbhid_submit_report(data->hdev, report1, USB_DIR_OUT);
+	usbhid_submit_report(data->hdev, report2, USB_DIR_OUT);
+	return 0;
+}
+
+/* Translate a single tile*/
+static inline int picolcd_fb_update_tile(u8 *vbitmap, const u8 *bitmap,
+		int chip, int tile)
+{
+	int i, b, changed = 0;
+	u8 tdata[64];
+	u8 *vdata = vbitmap + (tile * 4 + chip) * 64;
+
+	for (b = 7; b >= 0; b--) {
+		const u8 *bdata = bitmap + tile * 256 + chip * 8 + b * 32;
+		for (i = 0; i < 64; i++) {
+			tdata[i] <<= 1;
+			tdata[i] |= (bdata[i/8] >> (7 - i % 8)) & 0x01;
+		}
+	}
+	for (i = 0; i < 64; i++)
+		if (tdata[i] != vdata[i]) {
+			changed = 1;
+			vdata[i] = tdata[i];
+		}
+	return changed;
+}
+
+/* Reconfigure LCD display
+ *   TODO: prevent concurrent runs */
+static int picolcd_fb_reset(struct hid_device *hdev, int clear)
+{
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+	struct hid_report *report = picolcd_out_report(REPORT_LCD_CMD, hdev);
+	int chip, tile, i, j;
+	static const u8 mapcmd[8] = { 0x00, 0x02, 0x00, 0x64, 0x3f, 0x00, 0x64, 0xc0 };
+
+	if (!report || report->maxfield != 1)
+		return -ENODEV;
+
+	for (i = 0; i < 4; i++) {
+		for (j = 0; j < report->field[0]->maxusage; j++)
+			if (j == 0)
+				hid_set_field(report->field[0], j, i << 2);
+			else if (j < sizeof(mapcmd))
+				hid_set_field(report->field[0], j, mapcmd[j]);
+			else
+				hid_set_field(report->field[0], j, 0);
+		usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	}
+
+	if (!clear) {
+		spin_lock(&data->lock);
+		data->status |= PICOLCD_READY_FB;
+		spin_unlock(&data->lock);
+		for (chip = 0; chip < 4; chip++)
+			for (tile = 0; tile < 8; tile++) {
+				i = picolcd_fb_send_tile(data->hdev, chip, tile);
+				if (i != 0)
+					return i;
+			}
+		return 0;
+	}
+
+#ifdef CONFIG_LOGO
+	memcpy(data->fb_bitmap, picolcd_bits, PICOLCDFB_SIZE);
+#else
+	memset(data->fb_bitmap, 0, PICOLCDFB_SIZE);
+#endif
+	for (chip = 0; chip < 4; chip++)
+		for (tile = 0; tile < 8; tile++) {
+			picolcd_fb_update_tile(data->fb_vbitmap,
+					data->fb_bitmap, chip, tile);
+			i = picolcd_fb_send_tile(data->hdev, chip, tile);
+			if (i != 0)
+				return i;
+		}
+
+	spin_lock(&data->lock);
+	data->status |= PICOLCD_READY_FB;
+	spin_unlock(&data->lock);
+	return 0;
+}
+
+/* Update fb_vbitmap from the screen_base and send changed tiles to device */
+static void picolcd_fb_update(struct picolcd_data *data)
+{
+	int chip, tile;
+
+	spin_lock(&data->lock);
+	if (!(data->status & PICOLCD_READY_FB)) {
+		spin_unlock(&data->lock);
+		picolcd_fb_reset(data->hdev, 0);
+	} else
+		spin_unlock(&data->lock);
+
+	/*
+	 * Translate the XBM format screen_base into the format needed by the
+	 * PicoLCD. See display layout above.
+	 * Do this one tile after the other and push those tiles that changed.
+	 */
+	for (chip = 0; chip < 4; chip++)
+		for (tile = 0; tile < 8; tile++)
+			if (picolcd_fb_update_tile(data->fb_vbitmap,
+					data->fb_bitmap, chip, tile))
+				picolcd_fb_send_tile(data->hdev, chip, tile);
+}
+
+/* Stub to call the system default and update the image on the picoLCD */
+static void picolcd_fb_fillrect(struct fb_info *info,
+		const struct fb_fillrect *rect)
+{
+	if (!info->par)
+		return;
+	sys_fillrect(info, rect);
+
+	picolcd_fb_update(info->par);
+}
+
+/* Stub to call the system default and update the image on the picoLCD */
+static void picolcd_fb_copyarea(struct fb_info *info,
+		const struct fb_copyarea *area)
+{
+	if (!info->par)
+		return;
+	sys_copyarea(info, area);
+
+	picolcd_fb_update(info->par);
+}
+
+/* Stub to call the system default and update the image on the picoLCD */
+static void picolcd_fb_imageblit(struct fb_info *info, const struct fb_image *image)
+{
+	if (!info->par)
+		return;
+	sys_imageblit(info, image);
+
+	picolcd_fb_update(info->par);
+}
+
+/*
+ * this is the slow path from userspace. they can seek and write to
+ * the fb. it's inefficient to do anything less than a full screen draw
+ */
+static ssize_t picolcd_fb_write(struct fb_info *info, const char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	ssize_t ret;
+	if (!info->par)
+		return -ENODEV;
+	ret = fb_sys_write(info, buf, count, ppos);
+	if (ret >= 0)
+		picolcd_fb_update(info->par);
+	return ret;
+}
+
+static int picolcd_fb_blank(int blank, struct fb_info *info)
+{
+	if (!info->par)
+		return -ENODEV;
+	/* We let fb notification do this for us via lcd/backlight device */
+	return 0;
+}
+
+static void picolcd_fb_destroy(struct fb_info *info)
+{
+	fb_deferred_io_cleanup(info);
+	if (info->par)
+		((struct picolcd_data *)info->par)->fb_info = NULL;
+	framebuffer_release(info);
+}
+
+/* Note this can't be const because of struct fb_info definition */
+static struct fb_ops picolcdfb_ops = {
+	.owner        = THIS_MODULE,
+	.fb_destroy   = picolcd_fb_destroy,
+	.fb_read      = fb_sys_read,
+	.fb_write     = picolcd_fb_write,
+	.fb_blank     = picolcd_fb_blank,
+	.fb_fillrect  = picolcd_fb_fillrect,
+	.fb_copyarea  = picolcd_fb_copyarea,
+	.fb_imageblit = picolcd_fb_imageblit,
+};
+
+
+/* Callback from deferred IO workqueue */
+static void picolcd_fb_deferred_io(struct fb_info *info, struct list_head *pagelist)
+{
+	picolcd_fb_update(info->par);
+}
+
+static const struct fb_deferred_io picolcd_fb_defio = {
+	.delay = HZ / PICOLCDFB_UPDATE_RATE_DEFAULT,
+	.deferred_io = picolcd_fb_deferred_io,
+};
+
+
+/*
+ * The "fb_update_rate" attribute
+ */
+static ssize_t picolcd_fb_update_rate_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct picolcd_data *data = dev_get_drvdata(dev);
+	unsigned fb_update_rate = data->fb_update_rate;
+
+	return snprintf(buf, PAGE_SIZE, "%u (1..%u)\n", fb_update_rate,
+			PICOLCDFB_UPDATE_RATE_LIMIT);
+}
+
+static ssize_t picolcd_fb_update_rate_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct picolcd_data *data = dev_get_drvdata(dev);
+	int i;
+	unsigned u;
+
+	if (count < 1 || count > 10)
+		return -EINVAL;
+
+	i = sscanf(buf, "%u", &u);
+	if (i != 1)
+		return -EINVAL;
+
+	if (u > PICOLCDFB_UPDATE_RATE_LIMIT)
+		return -ERANGE;
+	else if (u == 0)
+		u = PICOLCDFB_UPDATE_RATE_DEFAULT;
+
+	data->fb_update_rate = u;
+	data->fb_defio.delay = HZ / data->fb_update_rate;
+	return count;
+}
+
+static DEVICE_ATTR(fb_update_rate, 0666, picolcd_fb_update_rate_show,
+		picolcd_fb_update_rate_store);
+
+
+/*
+ * backlight class device
+ */
+static int picolcd_get_brightness(struct backlight_device *bdev)
+{
+	struct picolcd_data *data = bl_get_data(bdev);
+	return data->lcd_brightness;
+}
+
+static int picolcd_set_brightness(struct backlight_device *bdev)
+{
+	struct picolcd_data *data = bl_get_data(bdev);
+	struct hid_report *report = picolcd_out_report(REPORT_BRIGHTNESS, data->hdev);
+
+	if (!report || report->maxfield != 1 || report->field[0]->maxusage != 1)
+		return -ENODEV;
+
+	data->lcd_brightness = bdev->props.brightness & 0x0ff;
+	data->lcd_power      = bdev->props.power;
+	hid_set_field(report->field[0], 0, data->lcd_power == FB_BLANK_UNBLANK ? data->lcd_brightness : 0);
+	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	return 0;
+}
+
+static int picolcd_check_bl_fb(struct backlight_device *bdev, struct fb_info *fb)
+{
+	struct picolcd_data *data = bl_get_data(bdev);
+	return fb == data->fb_info;
+}
+
+static const struct backlight_ops picolcd_blops = {
+	.update_status  = picolcd_set_brightness,
+	.get_brightness = picolcd_get_brightness,
+	.check_fb       = picolcd_check_bl_fb,
+};
+
+/*
+ * lcd class device
+ */
+static int picolcd_get_power(struct lcd_device *ldev)
+{
+	struct picolcd_data *data = lcd_get_data(ldev);
+	return data->lcd_power;
+}
+
+static int picolcd_set_power(struct lcd_device *ldev, int power)
+{
+	struct picolcd_data *data = lcd_get_data(ldev);
+	data->backlight->props.power = power;
+	return picolcd_set_brightness(data->backlight);
+}
+
+static int picolcd_get_contrast(struct lcd_device *ldev)
+{
+	struct picolcd_data *data = lcd_get_data(ldev);
+	return data->lcd_contrast;
+}
+
+static int picolcd_set_contrast(struct lcd_device *ldev, int contrast)
+{
+	struct picolcd_data *data = lcd_get_data(ldev);
+	struct hid_report *report = picolcd_out_report(REPORT_CONTRAST, data->hdev);
+
+	if (!report || report->maxfield != 1 || report->field[0]->maxusage != 1)
+		return -ENODEV;
+
+	data->lcd_contrast = contrast & 0x0ff;
+	hid_set_field(report->field[0], 0, data->lcd_contrast);
+	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
+	return 0;
+}
+
+static int picolcd_check_lcd_fb(struct lcd_device *ldev, struct fb_info *fb)
+{
+	struct picolcd_data *data = lcd_get_data(ldev);
+	return fb == data->fb_info;
+}
+
+static struct lcd_ops picolcd_lcdops = {
+	.get_power      = picolcd_get_power,
+	.set_power      = picolcd_set_power,
+	.get_contrast   = picolcd_get_contrast,
+	.set_contrast   = picolcd_set_contrast,
+	.check_fb       = picolcd_check_lcd_fb,
+};
+
+
+/*
+ * input class device
+ */
+static int picolcd_raw_keypad(struct hid_device *hdev,
+		struct hid_report *report, u8 *raw_data, int size)
+{
+	/*
+	 * Keypad event
+	 * First and second data bytes list currently pressed keys,
+	 * 0x00 means no key and at most 2 keys may be pressed at same time
+	 */
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+	int i, j;
+
+	/* determine newly pressed keys */
+	for (i = 0; i < size; i++) {
+		int key_code;
+		if (raw_data[i] == 0)
+			continue;
+		for (j = 0; j < sizeof(data->pressed_keys); j++)
+			if (data->pressed_keys[j] == raw_data[i])
+				goto key_already_down;
+		for (j = 0; j < sizeof(data->pressed_keys); j++)
+			if (data->pressed_keys[j] == 0) {
+				data->pressed_keys[j] = raw_data[i];
+				break;
+			}
+		input_event(data->input_keys, EV_MSC, MSC_SCAN, raw_data[i]);
+		if (input_get_keycode(data->input_keys, raw_data[i], &key_code))
+			key_code = KEY_UNKNOWN;
+		if (key_code != KEY_UNKNOWN) {
+			dbg_hid(PICOLCD_NAME " got key press for %u:%d", raw_data[i], key_code);
+			input_report_key(data->input_keys, key_code, 1);
+		}
+		input_sync(data->input_keys);
+key_already_down:
+		continue;
+	}
+
+	/* determine newly released keys */
+	for (j = 0; j < sizeof(data->pressed_keys); j++) {
+		int key_code;
+		if (data->pressed_keys[j] == 0)
+			continue;
+		for (i = 0; i < size; i++)
+			if (data->pressed_keys[j] == raw_data[i])
+				goto key_still_down;
+		input_event(data->input_keys, EV_MSC, MSC_SCAN, data->pressed_keys[j]);
+		if (input_get_keycode(data->input_keys, data->pressed_keys[j], &key_code))
+			key_code = KEY_UNKNOWN;
+		if (key_code != KEY_UNKNOWN) {
+			dbg_hid(PICOLCD_NAME " got key release for %u:%d", data->pressed_keys[j], key_code);
+			input_report_key(data->input_keys, key_code, 0);
+		}
+		input_sync(data->input_keys);
+		data->pressed_keys[j] = 0;
+key_still_down:
+		continue;
+	}
+	return 1;
+}
+
+
+
+
+
+/*
+ * Reset our device and wait for answer to VERSION request
+ */
+static int picolcd_reset(struct hid_device *hdev)
+{
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+	struct hid_report *report1 = picolcd_out_report(REPORT_RESET, hdev);
+	struct hid_report *report2 = picolcd_out_report(REPORT_VERSION, hdev);
+	int ret;
+
+	if (!report1 || report1->maxfield != 1 || !report2)
+		return -ENODEV;
+
+	spin_lock(&data->lock);
+	data->status = 0;
+	spin_unlock(&data->lock);
+	INIT_COMPLETION(data->ready);
+
+	hid_set_field(report1->field[0], 0, 1);
+	usbhid_submit_report(hdev, report1, USB_DIR_OUT);
+
+	usbhid_submit_report(hdev, report2, USB_DIR_OUT);
+	wait_for_completion_interruptible_timeout(&data->ready, HZ*2);
+
+	spin_lock(&data->lock);
+	if (data->status == 0) {
+		spin_unlock(&data->lock);
+		return -EBUSY;
+	} else
+		spin_unlock(&data->lock);
+
+	ret = picolcd_set_contrast(data->lcd, data->lcd_contrast);
+	if (ret)
+		return ret;
+	ret = picolcd_set_brightness(data->backlight);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/*
+ * The "reset" attribute
+ */
+static ssize_t picolcd_reset_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "all fb");
+}
+
+static ssize_t picolcd_reset_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct picolcd_data *data = dev_get_drvdata(dev);
+	size_t cnt = count;
+	while (cnt > 0 && (buf[cnt-1] == ' ' || buf[cnt-1] == '\n'))
+		cnt--;
+	if (strncmp(buf, "all", cnt) == 0) {
+		picolcd_reset(data->hdev);
+		picolcd_fb_reset(data->hdev, 1);
+	} else if (strncmp(buf, "fb", cnt) == 0) {
+		picolcd_fb_reset(data->hdev, 1);
+	} else
+		return -EINVAL;
+	return count;
+}
+
+static DEVICE_ATTR(reset, 0600, picolcd_reset_show,
+		picolcd_reset_store);
+
+
+
+/*
+ * Handle raw report as sent by device
+ */
+static int picolcd_raw_event(struct hid_device *hdev,
+		struct hid_report *report, u8 *raw_data, int size)
+{
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+	char hexdata[25];
+	int i;
+
+	if (data == NULL)
+		return 1;
+
+	for (i = 0; i < sizeof(hexdata) / 2; i++)
+		sprintf(hexdata+2*i, "%02hhx", raw_data[i]);
+	if (size >= sizeof(hexdata)/2) {
+		hexdata[sizeof(hexdata)-4] = '.';
+		hexdata[sizeof(hexdata)-3] = '.';
+		hexdata[sizeof(hexdata)-2] = '.';
+		hexdata[sizeof(hexdata)-1] = '\0';
+	} else
+		hexdata[size*2] = '\0';
+
+	switch (report->id) {
+	case REPORT_KEYPAD:
+		if (size == 3 && raw_data[0] == 0x11 && data->input_keys) {
+			return picolcd_raw_keypad(hdev, report, raw_data+1, size-1);
+		} else {
+			dbg_hid(PICOLCD_NAME " unsupported key event (%d bytes): 0x%s\n", size, hexdata);
+			break;
+		}
+		break;
+	case REPORT_VERSION:
+		if (size == 3)
+			dev_info(&hdev->dev, "Firmware version is %hd.%hd\n", raw_data[1], raw_data[2]);
+
+		spin_lock(&data->lock);
+		if (!(data->status & PICOLCD_READY_ALIVE)) {
+			data->status |= PICOLCD_READY_ALIVE;
+			spin_unlock(&data->lock);
+			complete_all(&data->ready);
+		} else
+			spin_unlock(&data->lock);
+		break;
+
+	default:
+		dbg_hid(PICOLCD_NAME " got raw event %d with length %d: %s\n", report->id, size, hexdata);
+		return 0;
+	}
+
+	return 1;
+}
+
+
+/*
+ * Create a group of attributes so that we can create and destroy them all
+ * at once.
+ */
+static struct attribute *picolcd_attrs[] = {
+	&dev_attr_fb_update_rate.attr,
+	&dev_attr_reset.attr,
+	NULL,	 /* need to NULL terminate the list of attributes */
+};
+
+/*
+ * An unnamed attribute group will put all of the attributes directly in
+ * the kobject directory.  If we specify a name, a subdirectory will be
+ * created for the attributes with the directory being the name of the
+ * attribute group.
+ */
+static const struct attribute_group picolcd_attr_group = {
+	.attrs = picolcd_attrs,
+};
+
+
+static int picolcd_probe(struct hid_device *hdev,
+		     const struct hid_device_id *id)
+{
+	struct picolcd_data *data;
+	struct input_dev *idev;
+	int i, error = -ENOMEM;
+	char name[12];
+
+	dbg_hid(PICOLCD_NAME " hardware probe...\n");
+
+	/*
+	 * Let's allocate the picolcd data structure, set some reasonable
+	 * defaults, and associate it with the device
+	 */
+	data = kzalloc(sizeof(struct picolcd_data), GFP_KERNEL);
+	if (data == NULL) {
+		dev_err(&hdev->dev, "can't allocate space for Minibox PicoLCD device data\n");
+		error = -ENOMEM;
+		goto err_no_cleanup;
+	}
+
+	spin_lock_init(&data->lock);
+	init_completion(&data->ready);
+	data->hdev = hdev;
+	hid_set_drvdata(hdev, data);
+
+	data->fb_bitmap = vmalloc(PICOLCDFB_SIZE);
+	if (data->fb_bitmap == NULL) {
+		dev_err(&hdev->dev, "can't get a free page for framebuffer\n");
+		error = -ENOMEM;
+		goto err_cleanup_data;
+	}
+
+	data->fb_vbitmap = kmalloc(PICOLCDFB_SIZE, GFP_KERNEL);
+	if (data->fb_vbitmap == NULL) {
+		dev_err(&hdev->dev, "can't alloc vbitmap image buffer\n");
+		error = -ENOMEM;
+		goto err_cleanup_fb_bitmap;
+	}
+
+	/* Parse the device reports and start it up */
+	error = hid_parse(hdev);
+	if (error) {
+		dev_err(&hdev->dev, "device report parse failed\n");
+		goto err_cleanup_fb_vbitmap;
+	}
+
+	error = hid_hw_start(hdev, HID_CONNECT_HIDINPUT);
+	if (error) {
+		dev_err(&hdev->dev, "hardware start failed\n");
+		goto err_cleanup_fb_vbitmap;
+	}
+	dbg_hid(PICOLCD_NAME " claimed: %d\n", hdev->claimed);
+
+	error = hdev->ll_driver->open(hdev);
+	if (error) {
+		dev_err(&hdev->dev, "failed to open input interrupt pipe for key and IR events\n");
+		goto err_cleanup_hid_hw;
+	}
+
+	/* Setup input device */
+	idev = input_allocate_device();
+	if (idev == NULL) {
+		dev_err(&hdev->dev, "failed to allocate input device");
+		error = -ENOMEM;
+		goto err_cleanup_hid_ll;
+	}
+	input_set_drvdata(idev, hdev);
+	memcpy(data->keycode, def_keymap, sizeof(def_keymap));
+	idev->name = hdev->name;
+	idev->phys = hdev->phys;
+	idev->uniq = hdev->uniq;
+	idev->id.bustype = hdev->bus;
+	idev->id.vendor  = hdev->vendor;
+	idev->id.product = hdev->product;
+	idev->id.version = hdev->version;
+	idev->dev.parent = hdev->dev.parent;
+	idev->keycode     = &data->keycode;
+	idev->keycodemax  = PICOLCD_KEYS;
+	idev->keycodesize = sizeof(int);
+	input_set_capability(idev, EV_MSC, MSC_SCAN);
+	set_bit(EV_REP, idev->evbit);
+	for (i = 0; i < PICOLCD_KEYS; i++) {
+		int key = ((int *)idev->keycode)[i];
+		if (key < KEY_MAX && key >= 0)
+			input_set_capability(idev, EV_KEY, key);
+	}
+	error = input_register_device(idev);
+	if (error) {
+		dev_err(&hdev->dev, "error registering the input device");
+		input_free_device(idev);
+		goto err_cleanup_hid_ll;
+	}
+	data->input_keys = idev;
+
+	/* Set up the framebuffer device */
+	data->fb_update_rate = PICOLCDFB_UPDATE_RATE_DEFAULT;
+	data->fb_defio = picolcd_fb_defio;
+	data->fb_info = framebuffer_alloc(0, &hdev->dev);
+	if (data->fb_info == NULL) {
+		dev_err(&hdev->dev, "failed to allocate a framebuffer\n");
+		error = -ENOMEM;
+		goto err_cleanup_input_keys;
+	}
+
+	data->fb_info->fbdefio = &data->fb_defio;
+	data->fb_info->screen_base = (char __force __iomem *) data->fb_bitmap;
+	data->fb_info->fbops = &picolcdfb_ops;
+	data->fb_info->var = picolcdfb_var;
+	data->fb_info->fix = picolcdfb_fix;
+	data->fb_info->fix.smem_len = PICOLCDFB_SIZE;
+	data->fb_info->par = data;
+	data->fb_info->flags = FBINFO_FLAG_DEFAULT;
+	fb_deferred_io_init(data->fb_info);
+
+	error = register_framebuffer(data->fb_info);
+	if (error < 0) {
+		dev_err(&hdev->dev, "failed to register framebuffer\n");
+		fb_deferred_io_cleanup(data->fb_info);
+		framebuffer_release(data->fb_info);
+		goto err_cleanup_input_keys;
+	} else
+		error = 0;
+
+	snprintf(name, sizeof(name), "fb%d", data->fb_info->node);
+	data->lcd = lcd_device_register(name, &hdev->dev, data, &picolcd_lcdops);
+	if (IS_ERR(data->lcd)) {
+		dev_err(&hdev->dev, "failed to register LCD\n");
+		error = PTR_ERR(data->lcd);
+		goto err_cleanup_fb;
+	}
+	data->lcd->props.max_contrast = 0x0ff;
+	data->lcd_contrast = 0xe5;
+
+	data->backlight = backlight_device_register(name, &hdev->dev, data, &picolcd_blops);
+	if (IS_ERR(data->backlight)) {
+		dev_err(&hdev->dev, "failed to register backlight\n");
+		error = PTR_ERR(data->backlight);
+		goto err_cleanup_lcd;
+	}
+	data->backlight->props.max_brightness = 0x0ff;
+	data->backlight->props.brightness     = 0xff;
+	data->lcd_brightness                  = 0xff;
+
+	dbg_hid(PICOLCD_NAME " waiting for device to activate\n");
+	if (!picolcd_reset(hdev)) {
+		dbg_hid(PICOLCD_NAME " initialized\n");
+	} else
+		dev_warn(&hdev->dev, "hasn't responded yet, forging ahead with initialization\n");
+
+	picolcd_fb_reset(hdev, 1);
+
+	/* Add the sysfs attributes */
+	error = sysfs_create_group(&(hdev->dev.kobj), &picolcd_attr_group);
+	if (error) {
+		dev_err(&hdev->dev, "failed to create sysfs group attributes\n");
+		goto err_cleanup_bl;
+	}
+
+	dbg_hid(PICOLCD_NAME " activated and initialized\n");
+	return 0;
+
+
+err_cleanup_bl:
+	backlight_device_unregister(data->backlight);
+err_cleanup_lcd:
+	lcd_device_unregister(data->lcd);
+err_cleanup_fb:
+	unregister_framebuffer(data->fb_info);
+err_cleanup_input_keys:
+	input_unregister_device(data->input_keys);
+err_cleanup_hid_ll:
+	hdev->ll_driver->close(hdev);
+err_cleanup_hid_hw:
+	hid_hw_stop(hdev);
+err_cleanup_fb_vbitmap:
+	kfree(data->fb_vbitmap);
+err_cleanup_fb_bitmap:
+	vfree(data->fb_bitmap);
+err_cleanup_data:
+	kfree(data);
+err_no_cleanup:
+	hid_set_drvdata(hdev, NULL);
+
+	return error;
+}
+
+static void picolcd_remove(struct hid_device *hdev)
+{
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+
+	dbg_hid(PICOLCD_NAME " hardware remove...\n");
+	sysfs_remove_group(&(hdev->dev.kobj), &picolcd_attr_group);
+
+	hdev->ll_driver->close(hdev);
+	hid_hw_stop(hdev);
+
+	/* Clean up the framebuffer */
+	backlight_device_unregister(data->backlight);
+	lcd_device_unregister(data->lcd);
+	unregister_framebuffer(data->fb_info);
+
+	/* Get the internal picolcd data buffer */
+	input_unregister_device(data->input_keys);
+
+	vfree(data->fb_bitmap);
+	kfree(data->fb_vbitmap);
+
+	/* Finally, clean up the picolcd data itself */
+	kfree(data);
+}
+
+static const struct hid_device_id picolcd_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_PICOLCD) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, picolcd_devices);
+
+static struct hid_driver picolcd_driver = {
+	.name =          "hid-picolcd",
+	.id_table =      picolcd_devices,
+	.probe =         picolcd_probe,
+	.remove =        picolcd_remove,
+	.raw_event =     picolcd_raw_event,
+};
+
+static int __init picolcd_init(void)
+{
+	return hid_register_driver(&picolcd_driver);
+}
+
+static void __exit picolcd_exit(void)
+{
+	hid_unregister_driver(&picolcd_driver);
+}
+
+module_init(picolcd_init);
+module_exit(picolcd_exit);
+MODULE_DESCRIPTION("Minibox graphics PicoLCD Driver");
+MODULE_LICENSE("GPL");
