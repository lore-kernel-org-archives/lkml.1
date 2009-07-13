Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZGMMUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZGMMUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 08:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZGMMUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 08:20:14 -0400
Received: from ppp-145-35.adsl.restena.lu ([158.64.145.35]:34415 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbZGMMUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 08:20:12 -0400
Date: Mon, 13 Jul 2009 14:19:58 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mark Lord <lkml@rtr.ca>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH] HID: Input driver for Twinhan USB 6253:0100 remote control
Message-ID: <20090713141958.4d17f32a@neptune.home>
In-Reply-To: <alpine.LNX.2.00.0907131316420.10476@wotan.suse.de>
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com>
	<200904131931.24009.dmitry.torokhov@gmail.com>
	<49E4B678.9030508@rtr.ca>
	<200904140945.14652.dmitry.torokhov@gmail.com>
	<49E4C9CF.5060504@rtr.ca>
	<alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>
	<49E5EAD7.7000309@rtr.ca>
	<alpine.LNX.2.00.0904161123180.13028@wotan.suse.de>
	<20090712182026.7a09c736@neptune.home>
	<alpine.LNX.2.00.0907131048110.10476@wotan.suse.de>
	<20090713113157.701ba027@neptune.home>
	<alpine.LNX.2.00.0907131316420.10476@wotan.suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add explicit key mappings for TwinHan USB HID remote control.

All dummy Ctrl, Alt, Meta, ... key press/release events generated
by the remote are silenced by "unmapping" them. This makes Power and
Volume keys single-key and strips the regular (even while idle) key
release events for Ctrl, Alt, Meta, ...

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---

On Mon, 13 July 2009 Jiri Kosina <jkosina@suse.cz> wrote:
> > > > +	// set_bit(EV_REP, hi->input->evbit);
> > > Why is this commented out?
> > That was a remaining line from basing on hid-gyration.c Don't know
> > what it does, looks like related to key repeating but I've not read
> > enough of HID/Input code to find out. (all my tests were run with
> > it commented out, so I will drop it unless there is a good reason
> > to uncomment it)
> 
> Yes, EV_REP is a flag which signals whether the keys produced by the 
> device in question should be auto-repreated.

Remote always sends press/release events (and does send them again
repeatedly if the key remains pressed), so this has no effect anyhow,
dropped

> > With my patch it seems the mappings don't show up for EVIOCGKEYCODE:
> > 
> > int codes[2];
> > for (codes[0] = 0; codes[0] < 1024; codes[0]++)
> >   if (ioctl(evdev, EVIOCGKEYCODE, codes) >= 0) {
> >     // display
> >   } else
> >     break;
> > 
> > Code block above only displays for codes[0] == 0:
> >  codes = { 0, 388 /* KEY_TEXT */ }
> > 
> > For all other values of codes[0] ioctl returns EINVAL.
> > 
> > Is this expected or should complete mapping table be returned
> > as it is for generic PS2 PC keyboard (if so, what changes does the
> > patch need for it)?
> 
> The HID core's perception of scancode is the actual HID usage as
> reported by the device, inlcuding the page number.
> 
> I.e. for your device, the usages would be in 0x70004 - 0x70052 range,
> not 0-1024 (which is what your current code is checking for).

Ok, with the range changed it's fine

> Also, looking at the patch again -- could you please keep the usage 
> numbers sorted in the switch-case in twinhan_input_mapping(), so that
> it's more readable and compatible with other drivers?

I sorted them and now return -1 for all keys not present on the remote,
this way the mapping table is "clean" and does not contain default
keyboard keys.


Note: checkpatch complains about the break at line-end but I ignored
those errors as that's common practice for all hid drivers I looked into.


 drivers/hid/Kconfig       |    7 ++
 drivers/hid/Makefile      |    1 +
 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-ids.h     |    3 +
 drivers/hid/hid-twinhan.c |  147 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 159 insertions(+), 0 deletions(-)
---
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 7831a03..d972c7d 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -152,6 +152,13 @@ config HID_GYRATION
 	---help---
 	Support for Gyration remote control.
 
+config HID_TWINHAN
+	tristate "Twinhan" if EMBEDDED
+	depends on USB_HID
+	default !EMBEDDED
+	---help---
+	Support for Twinhan IR remote control.
+
 config HID_KENSINGTON
 	tristate "Kensington" if EMBEDDED
 	depends on USB_HID
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index db35151..9b9271d 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
 obj-$(CONFIG_HID_GREENASIA)	+= hid-gaff.o
 obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o
 obj-$(CONFIG_HID_TOPSEED)	+= hid-topseed.o
+obj-$(CONFIG_HID_TWINHAN)	+= hid-twinhan.o
 obj-$(CONFIG_HID_ZEROPLUS)	+= hid-zpff.o
 obj-$(CONFIG_HID_WACOM)		+= hid-wacom.o
 
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index f2c21d5..ed8766f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1312,6 +1312,7 @@ static const struct hid_device_id hid_blacklist[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TWINHAN, USB_DEVICE_ID_TWINHAN_IR_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_SMARTJOY_PLUS) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 6301010..a20fef8 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -403,6 +403,9 @@
 #define USB_VENDOR_ID_TURBOX		0x062a
 #define USB_DEVICE_ID_TURBOX_KEYBOARD	0x0201
 
+#define USB_VENDOR_ID_TWINHAN           0x6253
+#define USB_DEVICE_ID_TWINHAN_IR_REMOTE 0x0100
+
 #define USB_VENDOR_ID_UCLOGIC		0x5543
 #define USB_DEVICE_ID_UCLOGIC_TABLET_PF1209	0x0042
 
diff --git a/drivers/hid/hid-twinhan.c b/drivers/hid/hid-twinhan.c
new file mode 100644
index 0000000..0d33c61
--- /dev/null
+++ b/drivers/hid/hid-twinhan.c
@@ -0,0 +1,147 @@
+/*
+ * HID driver for TwinHan IR remote control
+ *
+ * Based on hid-gyration.c
+ *
+ * Copyright (c) 2009 Bruno Prémont <bonbons@linux-vserver.org>
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License.
+ */
+
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/hid.h>
+#include <linux/module.h>
+
+#include "hid-ids.h"
+
+/*	Remote control key layout + listing:
+ *
+ * 	Full Screen                              Power
+ *	KEY_SCREEN                          KEY_POWER2
+ *
+ *	1                     2                      3
+ *	KEY_NUMERIC_1   KEY_NUMERIC_2    KEY_NUMERIC_3
+ *
+ *	4                     5                      6
+ *	KEY_NUMERIC_4   KEY_NUMERIC_5    KEY_NUMERIC_6
+ *
+ *	7                     8                      9
+ *	KEY_NUMERIC_7   KEY_NUMERIC_8    KEY_NUMERIC_9
+ *
+ *	REC                   0               Favorite
+ *	KEY_RECORD      KEY_NUMERIC_0    KEY_FAVORITES
+ *
+ *	Rewind                                 Forward
+ *	KEY_REWIND           CH+           KEY_FORWARD
+ *	               KEY_CHANNELUP
+ *
+ *	VOL-                  >                   VOL+
+ *	KEY_VOLUMEDOWN    KEY_PLAY        KEY_VOLUMEUP
+ *
+ *	                     CH-
+ *	              KEY_CHANNELDOWN
+ *	Recall                                    Stop
+ *	KEY_RESTART                           KEY_STOP
+ *
+ *	Timeshift/Pause     Mute                Cancel
+ *	KEY_PAUSE         KEY_MUTE          KEY_CANCEL
+ *
+ *	Capture            Preview                 EPG
+ *	KEY_PRINT        KEY_PROGRAM           KEY_EPG
+ *
+ *	Record List          Tab              Teletext
+ *	KEY_LIST            KEY_TAB           KEY_TEXT
+ */
+
+#define th_map_key_clear(c)	hid_map_usage_clear(hi, usage, bit, max, \
+					EV_KEY, (c))
+static int twinhan_input_mapping(struct hid_device *hdev, struct hid_input *hi,
+		struct hid_field *field, struct hid_usage *usage,
+		unsigned long **bit, int *max)
+{
+	if ((usage->hid & HID_USAGE_PAGE) != HID_UP_KEYBOARD)
+		return 0;
+
+	switch (usage->hid & HID_USAGE) {
+	/* Map all keys from Twinhan Remote */
+	case 0x004: th_map_key_clear(KEY_TEXT);         break;
+	case 0x006: th_map_key_clear(KEY_RESTART);      break;
+	case 0x008: th_map_key_clear(KEY_EPG);          break;
+	case 0x00c: th_map_key_clear(KEY_REWIND);       break;
+	case 0x00e: th_map_key_clear(KEY_PROGRAM);      break;
+	case 0x00f: th_map_key_clear(KEY_LIST);         break;
+	case 0x010: th_map_key_clear(KEY_MUTE);         break;
+	case 0x011: th_map_key_clear(KEY_FORWARD);      break;
+	case 0x013: th_map_key_clear(KEY_PRINT);        break;
+	case 0x017: th_map_key_clear(KEY_PAUSE);        break;
+	case 0x019: th_map_key_clear(KEY_FAVORITES);    break;
+	case 0x01d: th_map_key_clear(KEY_SCREEN);       break;
+	case 0x01e: th_map_key_clear(KEY_NUMERIC_1);    break;
+	case 0x01f: th_map_key_clear(KEY_NUMERIC_2);    break;
+	case 0x020: th_map_key_clear(KEY_NUMERIC_3);    break;
+	case 0x021: th_map_key_clear(KEY_NUMERIC_4);    break;
+	case 0x022: th_map_key_clear(KEY_NUMERIC_5);    break;
+	case 0x023: th_map_key_clear(KEY_NUMERIC_6);    break;
+	case 0x024: th_map_key_clear(KEY_NUMERIC_7);    break;
+	case 0x025: th_map_key_clear(KEY_NUMERIC_8);    break;
+	case 0x026: th_map_key_clear(KEY_NUMERIC_9);    break;
+	case 0x027: th_map_key_clear(KEY_NUMERIC_0);    break;
+	case 0x028: th_map_key_clear(KEY_PLAY);         break;
+	case 0x029: th_map_key_clear(KEY_CANCEL);       break;
+	case 0x02b: th_map_key_clear(KEY_TAB);          break;
+	/* Power       = 0x0e0 + 0x0e1 + 0x0e2 + 0x03f */
+	case 0x03f: th_map_key_clear(KEY_POWER2);       break;
+	case 0x04a: th_map_key_clear(KEY_RECORD);       break;
+	case 0x04b: th_map_key_clear(KEY_CHANNELUP);    break;
+	case 0x04d: th_map_key_clear(KEY_STOP);         break;
+	case 0x04e: th_map_key_clear(KEY_CHANNELDOWN);  break;
+	/* Volume down = 0x0e1 + 0x051                 */
+	case 0x051: th_map_key_clear(KEY_VOLUMEDOWN);   break;
+	/* Volume up   = 0x0e1 + 0x052                 */
+	case 0x052: th_map_key_clear(KEY_VOLUMEUP);     break;
+	/* Kill the extra keys used for multi-key "power" and "volume" keys
+	 * as well as continuously to release CTRL,ALT,META,... keys */
+	case 0x0e0:
+	case 0x0e1:
+	case 0x0e2:
+	case 0x0e3:
+	case 0x0e4:
+	case 0x0e5:
+	case 0x0e6:
+	case 0x0e7:
+	default:
+		return -1;
+	}
+	return 1;
+}
+
+static const struct hid_device_id twinhan_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_TWINHAN, USB_DEVICE_ID_TWINHAN_IR_REMOTE) },
+	{ }
+};
+MODULE_DEVICE_TABLE(hid, twinhan_devices);
+
+static struct hid_driver twinhan_driver = {
+	.name = "twinhan",
+	.id_table = twinhan_devices,
+	.input_mapping = twinhan_input_mapping,
+};
+
+static int twinhan_init(void)
+{
+	return hid_register_driver(&twinhan_driver);
+}
+
+static void twinhan_exit(void)
+{
+	hid_unregister_driver(&twinhan_driver);
+}
+
+module_init(twinhan_init);
+module_exit(twinhan_exit);
+MODULE_LICENSE("GPL");
