Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbYEPJy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbYEPJy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 05:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYEPJyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 05:54:11 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49867 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751092AbYEPJyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 05:54:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       marcel@holtmann.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, Jiri Slaby <jirislaby@gmail.com>,
       Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 08/10] HID: move apple quirks
Date: Fri, 16 May 2008 11:49:21 +0200
Message-Id: <1210931362-18422-8-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1210931362-18422-7-git-send-email-jirislaby@gmail.com>
References: <1210931362-18422-1-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-2-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-3-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-4-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-5-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-6-git-send-email-jirislaby@gmail.com>
 <1210931362-18422-7-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move them from core code to separate driver.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/Kconfig             |   14 ++
 drivers/hid/Makefile            |    1 +
 drivers/hid/hid-apple.c         |  466 +++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-core.c          |   28 +++
 drivers/hid/hid-input-quirks.c  |    8 -
 drivers/hid/hid-input.c         |  219 +------------------
 drivers/hid/usbhid/Kconfig      |   11 -
 drivers/hid/usbhid/hid-quirks.c |   43 ----
 include/linux/hid.h             |   12 -
 net/bluetooth/hidp/core.c       |   22 --
 10 files changed, 510 insertions(+), 314 deletions(-)
 create mode 100644 drivers/hid/hid-apple.c

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 066e8c0..9a9fd7d 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -78,6 +78,20 @@ config HID_LOGITECH
 	Support for some Logitech devices which breaks less or more
 	HID specification.
 
+config HID_APPLE
+	tristate "Apple"
+	default m
+	depends on (USB_HID || BT_HIDP)
+	---help---
+	Support for some Apple devices which less or more break
+	HID specification.
+
+	Say Y here if you want support for the special keys (Fn, Numlock) on
+	Apple iBooks, PowerBooks, MacBooks, MacBook Pros and aluminum USB
+	keyboards.
+
+	If unsure, say N.
+
 endmenu
 
 endif # HID_SUPPORT
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index cae036b..8a5cbbe 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -9,6 +9,7 @@ hid-$(CONFIG_HID_DEBUG)		+= hid-debug.o
 hid-$(CONFIG_HIDRAW)		+= hidraw.o
 
 obj-$(CONFIG_HID_LOGITECH)	+= hid-logitech.o
+obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
 
 obj-$(CONFIG_USB_HID)		+= usbhid/
 obj-$(CONFIG_USB_MOUSE)		+= usbhid/
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
new file mode 100644
index 0000000..b39d25c
--- /dev/null
+++ b/drivers/hid/hid-apple.c
@@ -0,0 +1,466 @@
+/*
+ *  USB HID quirks support for Linux
+ *
+ *  Copyright (c) 1999 Andreas Gal
+ *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
+ *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
+ *  Copyright (c) 2006-2007 Jiri Kosina
+ *  Copyright (c) 2007 Paul Walmsley
+ *  Copyright (c) 2008 Jiri Slaby <jslaby@suse.cz>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/device.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+
+#include "hid-ids.h"
+
+#define APPLE_RDESC_JIS		0x0001
+#define APPLE_IGNORE_MOUSE	0x0002
+#define APPLE_HAS_FN		0x0004
+#define APPLE_FN_ON		0x0008	/* is fn pressed? */
+#define APPLE_HIDDEV		0x0010
+#define APPLE_ISO_KEYBOARD	0x0020
+#define APPLE_MIGHTYMOUSE	0x0040
+#define APPLE_INVERT_HWHEEL	0x0080
+#define APPLE_IGNORE_HIDINPUT	0x0100
+#define APPLE_NUMLOCK_EMULATION	0x0200
+
+#define APPLE_FLAG_FKEY		0x01
+
+static unsigned int fnmode = 1;
+module_param(fnmode, uint, 0644);
+MODULE_PARM_DESC(fnmode, "Mode of fn key on Apple keyboards (0 = disabled, "
+		"[1] = fkeyslast, 2 = fkeysfirst)");
+
+struct apple_sc {
+	unsigned long quirks;
+	DECLARE_BITMAP(pressed_fn, KEY_CNT);
+	DECLARE_BITMAP(pressed_numlock, KEY_CNT);
+};
+
+struct apple_key_translation {
+	u16 from;
+	u16 to;
+	u8 flags;
+};
+
+static struct apple_key_translation apple_fn_keys[] = {
+	{ KEY_BACKSPACE, KEY_DELETE },
+	{ KEY_F1,	KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
+	{ KEY_F2,	KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
+	{ KEY_F3,	KEY_FN_F5,          APPLE_FLAG_FKEY }, /* ExposÃ© */
+	{ KEY_F4,	KEY_FN_F4,          APPLE_FLAG_FKEY }, /* Dashboard */
+	{ KEY_F7,	KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
+	{ KEY_F8,	KEY_PLAYPAUSE,      APPLE_FLAG_FKEY },
+	{ KEY_F9,	KEY_NEXTSONG,       APPLE_FLAG_FKEY },
+	{ KEY_F10,	KEY_MUTE,           APPLE_FLAG_FKEY },
+	{ KEY_F11,	KEY_VOLUMEDOWN,     APPLE_FLAG_FKEY },
+	{ KEY_F12,	KEY_VOLUMEUP,       APPLE_FLAG_FKEY },
+	{ KEY_UP,	KEY_PAGEUP },
+	{ KEY_DOWN,	KEY_PAGEDOWN },
+	{ KEY_LEFT,	KEY_HOME },
+	{ KEY_RIGHT,	KEY_END },
+	{ }
+};
+
+static struct apple_key_translation powerbook_fn_keys[] = {
+	{ KEY_BACKSPACE, KEY_DELETE },
+	{ KEY_F1,	KEY_BRIGHTNESSDOWN,     APPLE_FLAG_FKEY },
+	{ KEY_F2,	KEY_BRIGHTNESSUP,       APPLE_FLAG_FKEY },
+	{ KEY_F3,	KEY_MUTE,               APPLE_FLAG_FKEY },
+	{ KEY_F4,	KEY_VOLUMEDOWN,         APPLE_FLAG_FKEY },
+	{ KEY_F5,	KEY_VOLUMEUP,           APPLE_FLAG_FKEY },
+	{ KEY_F6,	KEY_NUMLOCK,            APPLE_FLAG_FKEY },
+	{ KEY_F7,	KEY_SWITCHVIDEOMODE,    APPLE_FLAG_FKEY },
+	{ KEY_F8,	KEY_KBDILLUMTOGGLE,     APPLE_FLAG_FKEY },
+	{ KEY_F9,	KEY_KBDILLUMDOWN,       APPLE_FLAG_FKEY },
+	{ KEY_F10,	KEY_KBDILLUMUP,         APPLE_FLAG_FKEY },
+	{ KEY_UP,	KEY_PAGEUP },
+	{ KEY_DOWN,	KEY_PAGEDOWN },
+	{ KEY_LEFT,	KEY_HOME },
+	{ KEY_RIGHT,	KEY_END },
+	{ }
+};
+
+static struct apple_key_translation powerbook_numlock_keys[] = {
+	{ KEY_J,	KEY_KP1 },
+	{ KEY_K,	KEY_KP2 },
+	{ KEY_L,	KEY_KP3 },
+	{ KEY_U,	KEY_KP4 },
+	{ KEY_I,	KEY_KP5 },
+	{ KEY_O,	KEY_KP6 },
+	{ KEY_7,	KEY_KP7 },
+	{ KEY_8,	KEY_KP8 },
+	{ KEY_9,	KEY_KP9 },
+	{ KEY_M,	KEY_KP0 },
+	{ KEY_DOT,	KEY_KPDOT },
+	{ KEY_SLASH,	KEY_KPPLUS },
+	{ KEY_SEMICOLON, KEY_KPMINUS },
+	{ KEY_P,	KEY_KPASTERISK },
+	{ KEY_MINUS,	KEY_KPEQUAL },
+	{ KEY_0,	KEY_KPSLASH },
+	{ KEY_F6,	KEY_NUMLOCK },
+	{ KEY_KPENTER,	KEY_KPENTER },
+	{ KEY_BACKSPACE, KEY_BACKSPACE },
+	{ }
+};
+
+static struct apple_key_translation apple_iso_keyboard[] = {
+	{ KEY_GRAVE,	KEY_102ND },
+	{ KEY_102ND,	KEY_GRAVE },
+	{ }
+};
+
+static struct apple_key_translation *apple_find_translation(
+		struct apple_key_translation *table, u16 from)
+{
+	struct apple_key_translation *trans;
+
+	/* Look for the translation */
+	for (trans = table; trans->from; trans++)
+		if (trans->from == from)
+			return trans;
+
+	return NULL;
+}
+
+static int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
+		struct hid_usage *usage, __s32 value)
+{
+	struct apple_sc *asc = hid_get_drvdata(hid);
+	struct apple_key_translation *trans;
+
+	if (usage->code == KEY_FN) {
+		if (value)
+			asc->quirks |= APPLE_FN_ON;
+		else
+			asc->quirks &= ~APPLE_FN_ON;
+
+		input_event(input, usage->type, usage->code, value);
+
+		return 1;
+	}
+
+	if (fnmode) {
+		int do_translate;
+
+		trans = apple_find_translation((hid->product < 0x220 ||
+					hid->product >= 0x300) ?
+					powerbook_fn_keys : apple_fn_keys,
+					usage->code);
+		if (trans) {
+			if (test_bit(usage->code, asc->pressed_fn))
+				do_translate = 1;
+			else if (trans->flags & APPLE_FLAG_FKEY)
+				do_translate =
+					(fnmode == 2 && (asc->quirks & APPLE_FN_ON)) ||
+					(fnmode == 1 && !(asc->quirks & APPLE_FN_ON));
+			else
+				do_translate = (asc->quirks & APPLE_FN_ON);
+
+			if (do_translate) {
+				if (value)
+					set_bit(usage->code, asc->pressed_fn);
+				else
+					clear_bit(usage->code, asc->pressed_fn);
+
+				input_event(input, usage->type, trans->to,
+						value);
+
+				return 1;
+			}
+		}
+
+		if (asc->quirks & APPLE_NUMLOCK_EMULATION &&
+				(test_bit(usage->code, asc->pressed_numlock) ||
+				test_bit(LED_NUML, input->led))) {
+			trans = apple_find_translation(powerbook_numlock_keys,
+					usage->code);
+
+			if (trans) {
+				if (value)
+					set_bit(usage->code,
+							asc->pressed_numlock);
+				else
+					clear_bit(usage->code,
+							asc->pressed_numlock);
+
+				input_event(input, usage->type, trans->to,
+						value);
+			}
+
+			return 1;
+		}
+	}
+
+	if (asc->quirks & APPLE_ISO_KEYBOARD) {
+		trans = apple_find_translation(apple_iso_keyboard, usage->code);
+		if (trans) {
+			input_event(input, usage->type, trans->to, value);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int apple_event(struct hid_device *hdev, struct hid_field *field,
+		struct hid_usage *usage, __s32 value)
+{
+	struct apple_sc *asc = hid_get_drvdata(hdev);
+
+	if (!field->hidinput)
+		return -ENODEV;
+
+	if ((asc->quirks & APPLE_INVERT_HWHEEL) &&
+			usage->code == REL_HWHEEL) {
+		input_event(field->hidinput->input, usage->type, usage->code,
+				-value);
+		return 0;
+	}
+
+	if ((asc->quirks & APPLE_HAS_FN) &&
+			hidinput_apple_event(hdev, field->hidinput->input,
+				usage, value))
+		return 0;
+
+
+	return -ENODEV;
+}
+
+/*
+ * MacBook JIS keyboard has wrong logical maximum
+ */
+static void apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
+		unsigned int rsize)
+{
+	struct apple_sc *asc = hid_get_drvdata(hdev);
+
+	if ((asc->quirks & APPLE_RDESC_JIS) && rsize >= 60 &&
+			rdesc[53] == 0x65 && rdesc[59] == 0x65) {
+		dev_info(&hdev->dev, "fixing up MacBook JIS keyboard report "
+				"descriptor\n");
+		rdesc[53] = rdesc[59] = 0xe7;
+	}
+}
+
+static void apple_setup_input(struct input_dev *input)
+{
+	struct apple_key_translation *trans;
+
+	set_bit(KEY_NUMLOCK, input->keybit);
+
+	/* Enable all needed keys */
+	for (trans = apple_fn_keys; trans->from; trans++)
+		set_bit(trans->to, input->keybit);
+
+	for (trans = powerbook_fn_keys; trans->from; trans++)
+		set_bit(trans->to, input->keybit);
+
+	for (trans = powerbook_numlock_keys; trans->from; trans++)
+		set_bit(trans->to, input->keybit);
+
+	for (trans = apple_iso_keyboard; trans->from; trans++)
+		set_bit(trans->to, input->keybit);
+}
+
+static int apple_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_usage *usage, unsigned long **bit, int *max)
+{
+	if (usage->hid == (HID_UP_CUSTOM | 0x0003)) {
+		/* The fn key on Apple USB keyboards */
+		set_bit(EV_REP, hi->input->evbit);
+		hid_map_usage_clear(hi, usage, bit, max, EV_KEY, KEY_FN);
+		apple_setup_input(hi->input);
+		return 1;
+	}
+
+	/* we want the hid layer to go through standard path (set and ignore) */
+	return 0;
+}
+
+static void apple_input_mapped(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_usage *usage, unsigned long **bit, int *max)
+{
+	struct apple_sc *asc = hid_get_drvdata(hdev);
+
+	if (asc->quirks & APPLE_MIGHTYMOUSE) {
+		if (usage->hid == HID_GD_Z)
+			hid_map_usage(hi, usage, bit, max, EV_REL, REL_HWHEEL);
+		else if (usage->code == BTN_1)
+			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_2);
+		else if (usage->code == BTN_2)
+			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_1);
+	}
+}
+
+static int apple_probe(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	unsigned long quirks = id->driver_data;
+	struct apple_sc *asc;
+	int ret;
+
+	/* return something else or move to hid layer? device will reside
+	   allocated */
+	if (id->bus == BUS_USB && (id->driver_data & APPLE_IGNORE_MOUSE) &&
+			to_usb_interface(hdev->dev.parent)->cur_altsetting->
+			desc.bInterfaceProtocol == USB_INTERFACE_PROTOCOL_MOUSE)
+		return -ENODEV;
+
+	asc = kzalloc(sizeof(*asc), GFP_KERNEL);
+	if (asc == NULL) {
+		dev_err(&hdev->dev, "can't alloc apple descriptor\n");
+		return -ENOMEM;
+	}
+
+	hid_set_drvdata(hdev, asc);
+
+	if (quirks & APPLE_HIDDEV)
+		hdev->quirks |= HID_QUIRK_HIDDEV;
+	if (quirks & APPLE_IGNORE_HIDINPUT)
+		hdev->quirks |= HID_QUIRK_IGNORE_HIDINPUT;
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "parse failed\n");
+		goto err_free;
+	}
+
+	ret = hid_hw_start(hdev);
+	if (ret) {
+		dev_err(&hdev->dev, "hw start failed\n");
+		goto err_free;
+	}
+
+	return 0;
+err_free:
+	kfree(asc);
+	return ret;
+}
+
+static void apple_remove(struct hid_device *hdev)
+{
+	hid_hw_stop(hdev);
+	kfree(hid_get_drvdata(hdev));
+}
+
+static const struct hid_device_id apple_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4),
+		.driver_data = APPLE_HIDDEV | APPLE_IGNORE_HIDINPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE),
+		.driver_data = APPLE_MIGHTYMOUSE | APPLE_INVERT_HWHEEL },
+
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE | APPLE_ISO_KEYBOARD},
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE | APPLE_ISO_KEYBOARD},
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE | APPLE_ISO_KEYBOARD},
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_JIS),
+		.driver_data = APPLE_HAS_FN },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_ISO_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY),
+		.driver_data = APPLE_HAS_FN | APPLE_NUMLOCK_EMULATION |
+			APPLE_IGNORE_MOUSE },
+
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS),
+		.driver_data = APPLE_RDESC_JIS },
+
+	/* Apple wireless Mighty Mouse */
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c),
+		.driver_data = APPLE_MIGHTYMOUSE | APPLE_INVERT_HWHEEL },
+
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, apple_devices);
+
+static struct hid_driver apple_driver = {
+	.name = "apple",
+	.id_table = apple_devices,
+	.report_fixup = apple_report_fixup,
+	.probe = apple_probe,
+	.remove = apple_remove,
+	.event = apple_event,
+	.input_mapping = apple_input_mapping,
+	.input_mapped = apple_input_mapped,
+};
+
+static int apple_init(void)
+{
+	int ret;
+
+	ret = hid_register_driver(&apple_driver);
+	if (ret)
+		printk(KERN_ERR "can't register apple driver\n");
+
+	return ret;
+}
+
+static void apple_exit(void)
+{
+	hid_unregister_driver(&apple_driver);
+}
+
+module_init(apple_init);
+module_exit(apple_exit);
+MODULE_LICENSE("GPL");
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index fa9d05b..be080d4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1129,6 +1129,34 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER_2) },
+	/* APPLE */
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS) },
+
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c) },
 	{ }
 };
 
diff --git a/drivers/hid/hid-input-quirks.c b/drivers/hid/hid-input-quirks.c
index 51ae184..ff9bbdd 100644
--- a/drivers/hid/hid-input-quirks.c
+++ b/drivers/hid/hid-input-quirks.c
@@ -399,19 +399,11 @@ int hidinput_event_quirks(struct hid_device *hid, struct hid_field *field, struc
 		return 1;
 	}
 
-	if ((hid->quirks & HID_QUIRK_INVERT_HWHEEL) && (usage->code == REL_HWHEEL)) {
-		input_event(input, usage->type, usage->code, -value);
-		return 1;
-	}
-
 	if ((hid->quirks & HID_QUIRK_2WHEEL_MOUSE_HACK_ON) && (usage->code == REL_WHEEL)) {
 		input_event(input, usage->type, REL_HWHEEL, value);
 		return 1;
 	}
 
-	if ((hid->quirks & HID_QUIRK_APPLE_HAS_FN) && hidinput_apple_event(hid, input, usage, value))
-		return 1;
-
 	/* Handling MS keyboards special buttons */
 	if (hid->quirks & HID_QUIRK_MICROSOFT_KEYS && 
 			usage->hid == (HID_UP_MSVENDOR | 0xff05)) {
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 5dc017e..0b13dca 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -34,11 +34,6 @@
 #include <linux/hid.h>
 #include <linux/hid-debug.h>
 
-static int hid_apple_fnmode = 1;
-module_param_named(pb_fnmode, hid_apple_fnmode, int, 0644);
-MODULE_PARM_DESC(pb_fnmode,
-		"Mode of fn key on Apple keyboards (0 = disabled, 1 = fkeyslast, 2 = fkeysfirst)");
-
 #define unk	KEY_UNKNOWN
 
 static const unsigned char hid_keyboard[256] = {
@@ -88,200 +83,6 @@ static const struct {
 #define map_key_clear(c)	hid_map_usage_clear(hidinput, usage, &bit, \
 		&max, EV_KEY, (c))
 
-#ifdef CONFIG_USB_HIDINPUT_POWERBOOK
-
-struct hidinput_key_translation {
-	u16 from;
-	u16 to;
-	u8 flags;
-};
-
-#define APPLE_FLAG_FKEY 0x01
-
-static struct hidinput_key_translation apple_fn_keys[] = {
-	{ KEY_BACKSPACE, KEY_DELETE },
-	{ KEY_F1,       KEY_BRIGHTNESSDOWN, APPLE_FLAG_FKEY },
-	{ KEY_F2,       KEY_BRIGHTNESSUP,   APPLE_FLAG_FKEY },
-	{ KEY_F3,       KEY_FN_F5,          APPLE_FLAG_FKEY }, /* Exposé */
-	{ KEY_F4,       KEY_FN_F4,          APPLE_FLAG_FKEY }, /* Dashboard */
-	{ KEY_F7,       KEY_PREVIOUSSONG,   APPLE_FLAG_FKEY },
-	{ KEY_F8,       KEY_PLAYPAUSE,      APPLE_FLAG_FKEY },
-	{ KEY_F9,       KEY_NEXTSONG,       APPLE_FLAG_FKEY },
-	{ KEY_F10,      KEY_MUTE,           APPLE_FLAG_FKEY },
-	{ KEY_F11,      KEY_VOLUMEDOWN,     APPLE_FLAG_FKEY },
-	{ KEY_F12,      KEY_VOLUMEUP,       APPLE_FLAG_FKEY },
-	{ KEY_UP,       KEY_PAGEUP },
-	{ KEY_DOWN,     KEY_PAGEDOWN },
-	{ KEY_LEFT,     KEY_HOME },
-	{ KEY_RIGHT,    KEY_END },
-	{ }
-};
-
-static struct hidinput_key_translation powerbook_fn_keys[] = {
-	{ KEY_BACKSPACE, KEY_DELETE },
-	{ KEY_F1,       KEY_BRIGHTNESSDOWN,     APPLE_FLAG_FKEY },
-	{ KEY_F2,       KEY_BRIGHTNESSUP,       APPLE_FLAG_FKEY },
-	{ KEY_F3,       KEY_MUTE,               APPLE_FLAG_FKEY },
-	{ KEY_F4,       KEY_VOLUMEDOWN,         APPLE_FLAG_FKEY },
-	{ KEY_F5,       KEY_VOLUMEUP,           APPLE_FLAG_FKEY },
-	{ KEY_F6,       KEY_NUMLOCK,            APPLE_FLAG_FKEY },
-	{ KEY_F7,       KEY_SWITCHVIDEOMODE,    APPLE_FLAG_FKEY },
-	{ KEY_F8,       KEY_KBDILLUMTOGGLE,     APPLE_FLAG_FKEY },
-	{ KEY_F9,       KEY_KBDILLUMDOWN,       APPLE_FLAG_FKEY },
-	{ KEY_F10,      KEY_KBDILLUMUP,         APPLE_FLAG_FKEY },
-	{ KEY_UP,       KEY_PAGEUP },
-	{ KEY_DOWN,     KEY_PAGEDOWN },
-	{ KEY_LEFT,     KEY_HOME },
-	{ KEY_RIGHT,    KEY_END },
-	{ }
-};
-
-static struct hidinput_key_translation powerbook_numlock_keys[] = {
-	{ KEY_J,        KEY_KP1 },
-	{ KEY_K,        KEY_KP2 },
-	{ KEY_L,        KEY_KP3 },
-	{ KEY_U,        KEY_KP4 },
-	{ KEY_I,        KEY_KP5 },
-	{ KEY_O,        KEY_KP6 },
-	{ KEY_7,        KEY_KP7 },
-	{ KEY_8,        KEY_KP8 },
-	{ KEY_9,        KEY_KP9 },
-	{ KEY_M,        KEY_KP0 },
-	{ KEY_DOT,      KEY_KPDOT },
-	{ KEY_SLASH,    KEY_KPPLUS },
-	{ KEY_SEMICOLON, KEY_KPMINUS },
-	{ KEY_P,        KEY_KPASTERISK },
-	{ KEY_MINUS,    KEY_KPEQUAL },
-	{ KEY_0,        KEY_KPSLASH },
-	{ KEY_F6,       KEY_NUMLOCK },
-	{ KEY_KPENTER,  KEY_KPENTER },
-	{ KEY_BACKSPACE, KEY_BACKSPACE },
-	{ }
-};
-
-static struct hidinput_key_translation apple_iso_keyboard[] = {
-	{ KEY_GRAVE,    KEY_102ND },
-	{ KEY_102ND,    KEY_GRAVE },
-	{ }
-};
-
-static struct hidinput_key_translation *find_translation(struct hidinput_key_translation *table, u16 from)
-{
-	struct hidinput_key_translation *trans;
-
-	/* Look for the translation */
-	for (trans = table; trans->from; trans++)
-		if (trans->from == from)
-			return trans;
-
-	return NULL;
-}
-
-int hidinput_apple_event(struct hid_device *hid, struct input_dev *input,
-		struct hid_usage *usage, __s32 value)
-{
-	struct hidinput_key_translation *trans;
-
-	if (usage->code == KEY_FN) {
-		if (value) hid->quirks |=  HID_QUIRK_APPLE_FN_ON;
-		else       hid->quirks &= ~HID_QUIRK_APPLE_FN_ON;
-
-		input_event(input, usage->type, usage->code, value);
-
-		return 1;
-	}
-
-	if (hid_apple_fnmode) {
-		int do_translate;
-
-		trans = find_translation((hid->product < 0x220 ||
-					  hid->product >= 0x300) ?
-					 powerbook_fn_keys : apple_fn_keys,
-					 usage->code);
-		if (trans) {
-			if (test_bit(usage->code, hid->apple_pressed_fn))
-				do_translate = 1;
-			else if (trans->flags & APPLE_FLAG_FKEY)
-				do_translate =
-					(hid_apple_fnmode == 2 &&  (hid->quirks & HID_QUIRK_APPLE_FN_ON)) ||
-					(hid_apple_fnmode == 1 && !(hid->quirks & HID_QUIRK_APPLE_FN_ON));
-			else
-				do_translate = (hid->quirks & HID_QUIRK_APPLE_FN_ON);
-
-			if (do_translate) {
-				if (value)
-					set_bit(usage->code, hid->apple_pressed_fn);
-				else
-					clear_bit(usage->code, hid->apple_pressed_fn);
-
-				input_event(input, usage->type, trans->to, value);
-
-				return 1;
-			}
-		}
-
-		if (hid->quirks & HID_QUIRK_APPLE_NUMLOCK_EMULATION && (
-				test_bit(usage->code, hid->pb_pressed_numlock) ||
-				test_bit(LED_NUML, input->led))) {
-			trans = find_translation(powerbook_numlock_keys, usage->code);
-
-			if (trans) {
-				if (value)
-					set_bit(usage->code, hid->pb_pressed_numlock);
-				else
-					clear_bit(usage->code, hid->pb_pressed_numlock);
-
-				input_event(input, usage->type, trans->to, value);
-			}
-
-			return 1;
-		}
-	}
-
-	if (hid->quirks & HID_QUIRK_APPLE_ISO_KEYBOARD) {
-		trans = find_translation(apple_iso_keyboard, usage->code);
-		if (trans) {
-			input_event(input, usage->type, trans->to, value);
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
-static void hidinput_apple_setup(struct input_dev *input)
-{
-	struct hidinput_key_translation *trans;
-
-	set_bit(KEY_NUMLOCK, input->keybit);
-
-	/* Enable all needed keys */
-	for (trans = apple_fn_keys; trans->from; trans++)
-		set_bit(trans->to, input->keybit);
-
-	for (trans = powerbook_fn_keys; trans->from; trans++)
-		set_bit(trans->to, input->keybit);
-
-	for (trans = powerbook_numlock_keys; trans->from; trans++)
-		set_bit(trans->to, input->keybit);
-
-	for (trans = apple_iso_keyboard; trans->from; trans++)
-		set_bit(trans->to, input->keybit);
-
-}
-#else
-inline int hidinput_apple_event(struct hid_device *hid,
-				       struct input_dev *input,
-				       struct hid_usage *usage, __s32 value)
-{
-	return 0;
-}
-
-static inline void hidinput_apple_setup(struct input_dev *input)
-{
-}
-#endif
-
 static inline int match_scancode(int code, int scancode)
 {
 	if (scancode == 0)
@@ -719,16 +520,7 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case HID_UP_CUSTOM: /* Reported on Logitech and Apple USB keyboards */
 
 			set_bit(EV_REP, input->evbit);
-			switch(usage->hid & HID_USAGE) {
-				case 0x003:
-					/* The fn key on Apple USB keyboards */
-					map_key_clear(KEY_FN);
-					hidinput_apple_setup(input);
-					break;
-
-				default:    goto ignore;
-			}
-			break;
+			goto ignore;
 
 		case HID_UP_LOGIVENDOR:
 
@@ -765,15 +557,6 @@ mapped:
 		device->driver->input_mapped(device, hidinput, usage,
 				&bit, &max);
 
-	if (device->quirks & HID_QUIRK_MIGHTYMOUSE) {
-		if (usage->hid == HID_GD_Z)
-			map_rel(REL_HWHEEL);
-		else if (usage->code == BTN_1)
-			map_key(BTN_2);
-		else if (usage->code == BTN_2)
-			map_key(BTN_1);
-	}
-
 	if ((device->quirks & (HID_QUIRK_2WHEEL_MOUSE_HACK_7 | HID_QUIRK_2WHEEL_MOUSE_HACK_5 |
 			HID_QUIRK_2WHEEL_MOUSE_HACK_B8)) && (usage->type == EV_REL) &&
 			(usage->code == REL_WHEEL))
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
index 18f0910..177bfa1 100644
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -24,17 +24,6 @@ config USB_HID
 comment "Input core support is needed for USB HID input layer or HIDBP support"
 	depends on USB_HID && INPUT=n
 
-config USB_HIDINPUT_POWERBOOK
-	bool "Enable support for Apple laptop/aluminum USB special keys"
-	default n
-	depends on USB_HID
-	help
-	  Say Y here if you want support for the special keys (Fn, Numlock) on
-	  Apple iBooks, PowerBooks, MacBooks, MacBook Pros and aluminum USB
-	  keyboards.
-
-	  If unsure, say N.
-
 config HID_FF
 	bool "Force feedback support (EXPERIMENTAL)"
 	depends on USB_HID && EXPERIMENTAL
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
index df71db7..c6ccbfa 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -54,7 +54,6 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
 
 	{ USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM, HID_QUIRK_HIDDEV },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4, HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },
 	{ USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE, HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV, HID_QUIRK_HIDINPUT },
 
@@ -67,8 +66,6 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_NE4K, HID_QUIRK_MICROSOFT_KEYS },
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_LK6K, HID_QUIRK_MICROSOFT_KEYS },
 
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
-
 	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
 	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },
 
@@ -92,29 +89,6 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER3_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE | HID_QUIRK_APPLE_ISO_KEYBOARD},
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ANSI, HID_QUIRK_APPLE_HAS_FN },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_ISO, HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_JIS, HID_QUIRK_APPLE_HAS_FN },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_FOUNTAIN_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_IGNORE_MOUSE },
-
 	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_KBD, HID_QUIRK_RESET_LEDS },
 
@@ -134,8 +108,6 @@ static const struct hid_rdesc_blacklist {
 
 	{ USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E, HID_QUIRK_RDESC_BUTTON_CONSUMER },
 
-	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_JIS, HID_QUIRK_RDESC_MACBOOK_JIS },
-
 	{ USB_VENDOR_ID_PETALYNX, USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE, HID_QUIRK_RDESC_PETALYNX },
 
 	{ USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE, HID_QUIRK_RDESC_SAMSUNG_REMOTE },
@@ -476,18 +448,6 @@ static void usbhid_fixup_cypress_descriptor(unsigned char *rdesc, int rsize)
 		printk(KERN_INFO "Fixing up Cypress report descriptor\n");
 }
 
-/*
- * MacBook JIS keyboard has wrong logical maximum
- */
-static void usbhid_fixup_macbook_descriptor(unsigned char *rdesc, int rsize)
-{
-	if (rsize >= 60 && rdesc[53] == 0x65
-			&& rdesc[59] == 0x65) {
-		printk(KERN_INFO "Fixing up MacBook JIS keyboard report descriptor\n");
-		rdesc[53] = rdesc[59] = 0xe7;
-	}
-}
-
 static void usbhid_fixup_button_consumer_descriptor(unsigned char *rdesc, int rsize)
 {
 	if (rsize >= 30 && rdesc[29] == 0x05
@@ -530,9 +490,6 @@ static void __usbhid_fixup_report_descriptor(__u32 quirks, char *rdesc, unsigned
 	if (quirks & HID_QUIRK_RDESC_PETALYNX)
 		usbhid_fixup_petalynx_descriptor(rdesc, rsize);
 
-	if (quirks & HID_QUIRK_RDESC_MACBOOK_JIS)
-		usbhid_fixup_macbook_descriptor(rdesc, rsize);
-
 	if (quirks & HID_QUIRK_RDESC_BUTTON_CONSUMER)
 		usbhid_fixup_button_consumer_descriptor(rdesc, rsize);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 96f64d7..c67e5fe 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -267,11 +267,6 @@ struct hid_item {
 #define HID_QUIRK_2WHEEL_MOUSE_HACK_7		0x00000080
 #define HID_QUIRK_2WHEEL_MOUSE_HACK_5		0x00000100
 #define HID_QUIRK_2WHEEL_MOUSE_HACK_ON		0x00000200
-#define HID_QUIRK_MIGHTYMOUSE			0x00000400
-#define HID_QUIRK_APPLE_HAS_FN			0x00000800
-#define HID_QUIRK_APPLE_FN_ON			0x00001000
-#define HID_QUIRK_INVERT_HWHEEL			0x00002000
-#define HID_QUIRK_APPLE_ISO_KEYBOARD		0x00004000
 #define HID_QUIRK_BAD_RELATIVE_KEYS		0x00008000
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_IGNORE_MOUSE			0x00020000
@@ -286,7 +281,6 @@ struct hid_item {
 #define HID_QUIRK_HWHEEL_WHEEL_INVERT		0x04000000
 #define HID_QUIRK_MICROSOFT_KEYS		0x08000000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
-#define HID_QUIRK_APPLE_NUMLOCK_EMULATION	0x20000000
 
 /*
  * Separate quirks for runtime report descriptor fixup
@@ -295,7 +289,6 @@ struct hid_item {
 #define HID_QUIRK_RDESC_CYMOTION		0x00000001
 #define HID_QUIRK_RDESC_SWAPPED_MIN_MAX		0x00000004
 #define HID_QUIRK_RDESC_PETALYNX		0x00000008
-#define HID_QUIRK_RDESC_MACBOOK_JIS		0x00000010
 #define HID_QUIRK_RDESC_BUTTON_CONSUMER		0x00000020
 #define HID_QUIRK_RDESC_SAMSUNG_REMOTE		0x00000040
 #define HID_QUIRK_RDESC_MICROSOFT_RECV_1028	0x00000080
@@ -482,10 +475,6 @@ struct hid_device {							/* device report descriptor */
 
 	/* handler for raw output data, used by hidraw */
 	int (*hid_output_raw_report) (struct hid_device *, __u8 *, size_t);
-#ifdef CONFIG_USB_HIDINPUT_POWERBOOK
-	unsigned long apple_pressed_fn[BITS_TO_LONGS(KEY_CNT)];
-	unsigned long pb_pressed_numlock[BITS_TO_LONGS(KEY_CNT)];
-#endif
 };
 
 static inline void *hid_get_drvdata(struct hid_device *hdev)
@@ -645,7 +634,6 @@ int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int
 int hidinput_mapping_quirks(struct hid_usage *, struct hid_input *,
 		unsigned long **, int *);
 int hidinput_event_quirks(struct hid_device *, struct hid_field *, struct hid_usage *, __s32);
-int hidinput_apple_event(struct hid_device *, struct input_dev *, struct hid_usage *, __s32);
 void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index e4693d0..586e64c 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -677,27 +677,6 @@ static void hidp_close(struct hid_device *hid)
 {
 }
 
-static const struct {
-	__u16 idVendor;
-	__u16 idProduct;
-	unsigned quirks;
-} hidp_blacklist[] = {
-	/* Apple wireless Mighty Mouse */
-	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
-
-	{ }	/* Terminating entry */
-};
-
-static void hidp_setup_quirks(struct hid_device *hid)
-{
-	unsigned int n;
-
-	for (n = 0; hidp_blacklist[n].idVendor; n++)
-		if (hidp_blacklist[n].idVendor == le16_to_cpu(hid->vendor) &&
-				hidp_blacklist[n].idProduct == le16_to_cpu(hid->product))
-			hid->quirks = hidp_blacklist[n].quirks;
-}
-
 static int hidp_parse(struct hid_device *hid)
 {
 	struct hidp_session *session = hid->driver_data;
@@ -723,7 +702,6 @@ static int hidp_parse(struct hid_device *hid)
 
 	session->req = NULL;
 
-	hidp_setup_quirks(hid);
 	return 0;
 }
 
-- 
1.5.4.5

