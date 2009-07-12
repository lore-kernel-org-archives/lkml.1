Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZGLQ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZGLQ1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 12:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbZGLQ1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 12:27:47 -0400
Received: from ppp-152-113.adsl.restena.lu ([158.64.152.113]:49224 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbZGLQ1n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 12:27:43 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jul 2009 12:27:43 EDT
Date: Sun, 12 Jul 2009 18:20:26 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mark Lord <lkml@rtr.ca>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
Message-ID: <20090712182026.7a09c736@neptune.home>
In-Reply-To: <alpine.LNX.2.00.0904161123180.13028@wotan.suse.de>
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com>
	<200904131931.24009.dmitry.torokhov@gmail.com>
	<49E4B678.9030508@rtr.ca>
	<200904140945.14652.dmitry.torokhov@gmail.com>
	<49E4C9CF.5060504@rtr.ca>
	<alpine.LNX.2.00.0904151022170.13028@wotan.suse.de>
	<49E5EAD7.7000309@rtr.ca>
	<alpine.LNX.2.00.0904161123180.13028@wotan.suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 April 2009 Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 15 Apr 2009, Mark Lord wrote:
> > > Yes, hid-belking is a good example of trivial driver that sits on
> > > a HID bus for you, as it utilizes the ->input_mapping() callback,
> > > which is probably the only callback from HID core you'd need.
> > Actually, the input-mapping() alone won't do the job here.
> > This Twinhan remote control sends single-byte codes for most
> > buttons, but some buttons send multi-byte codes, and we have to
> > discard the extraneous bytes somehow.
> 
> If the usages make it through the generic HID layer (depends on the
> report descriptor of the device), then just registering hid_driver
> with ->event() set to your callback and fixing this on the fly could
> be enough.

I do have such a remote around.

I wrote the below patch to adjust it's key mappings, though I'm not
sure if/how I should deal with the number keys (0..9) with regard to
keyboard layout and/or numlock key.

I tried with KEY_0..KEY_9 (default) as well as KEY_KP0..KEY_KP9 but
neither produces optimal results on my machine (laptop with numlock
disabled and belgian keyboard layout, e.g. KEY_1 => '&' unless shift
is down)

KEY_NUMERIC_0..KEY_NUMERIC_9 are not recognized by Linux console (don't
know if/how userspace understands them)


To disable the dummy ctrl/alt/meta keys the remote sends all the time
as release events (and as press event around power and volume keys)
I do return -1 in input_mapping() and 1 in event(), looking at what
reaches listener on event device this seems to work.
Possibly the whole event() callback is not even needed.


If someone has a better idea for the mapping of some of the keys,
please tell me, especially for the following keys I just took what
did look like eventually matching:
  Recall       -> KEY_RESTART
  Capture      -> KEY_PRINT
  Record List  -> KEY_LIST
  Preview      -> KEY_PROGRAM
  Teletext     -> KEY_TEXT

Bruno

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
index 0000000..6f00a67
--- /dev/null
+++ b/drivers/hid/hid-twinhan.c
@@ -0,0 +1,170 @@
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
+ *	KEY_1               KEY_2                KEY_3
+ *
+ *	4                     5                      6
+ *	KEY_4               KEY_5                KEY_6
+ *
+ *	7                     8                      9
+ *	KEY_7               KEY_8                KEY_9
+ *
+ *	REC                   0               Favorite
+ *	KEY_RECORD          KEY_0        KEY_FAVORITES
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
+	// set_bit(EV_REP, hi->input->evbit);
+	switch (usage->hid & HID_USAGE) {
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
+		return -1;
+
+	/* Map all keys from Twinhan Remote */
+	case 0x01d: th_map_key_clear(KEY_SCREEN);       break;
+	case 0x01e: th_map_key_clear(KEY_KP1);          break;
+	case 0x01f: th_map_key_clear(KEY_KP2);          break;
+	case 0x020: th_map_key_clear(KEY_KP3);          break;
+	case 0x021: th_map_key_clear(KEY_KP4);          break;
+	case 0x022: th_map_key_clear(KEY_KP5);          break;
+	case 0x023: th_map_key_clear(KEY_KP6);          break;
+	case 0x024: th_map_key_clear(KEY_KP7);          break;
+	case 0x025: th_map_key_clear(KEY_KP8);          break;
+	case 0x026: th_map_key_clear(KEY_KP9);          break;
+	case 0x027: th_map_key_clear(KEY_KP0);          break;
+	case 0x04a: th_map_key_clear(KEY_RECORD);       break;
+	case 0x019: th_map_key_clear(KEY_FAVORITES);    break;
+	case 0x00c: th_map_key_clear(KEY_REWIND);       break;
+	case 0x011: th_map_key_clear(KEY_FORWARD);      break;
+	case 0x04b: th_map_key_clear(KEY_CHANNELUP);    break;
+	case 0x04e: th_map_key_clear(KEY_CHANNELDOWN);  break;
+	case 0x028: th_map_key_clear(KEY_PLAY);         break;
+	case 0x006: th_map_key_clear(KEY_RESTART);      break;
+	case 0x04d: th_map_key_clear(KEY_STOP);         break;
+	case 0x017: th_map_key_clear(KEY_PAUSE);        break;
+	case 0x010: th_map_key_clear(KEY_MUTE);         break;
+	case 0x029: th_map_key_clear(KEY_CANCEL);       break;
+	case 0x013: th_map_key_clear(KEY_PRINT);        break;
+	case 0x00e: th_map_key_clear(KEY_PROGRAM);      break;
+	case 0x008: th_map_key_clear(KEY_EPG);          break;
+	case 0x00f: th_map_key_clear(KEY_LIST);         break;
+	case 0x02b: th_map_key_clear(KEY_TAB);          break;
+	case 0x004: th_map_key_clear(KEY_TEXT);         break;
+	/* Power       = 0x0e0 + 0x0e1 + 0x0e2 + 0x03f */
+	case 0x03f: th_map_key_clear(KEY_POWER2);       break;
+	/* Volume down = 0x0e1 + 0x051                 */
+	case 0x051: th_map_key_clear(KEY_VOLUMEDOWN);   break;
+	/* Volume up   = 0x0e1 + 0x052                 */
+	case 0x052: th_map_key_clear(KEY_VOLUMEUP);     break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static int twinhan_event(struct hid_device *hdev, struct hid_field *field,
+		struct hid_usage *usage, __s32 value)
+{
+	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_KEYBOARD)
+		switch (usage->hid & HID_USAGE) {
+		case 0x0e0:
+		case 0x0e1:
+		case 0x0e2:
+		case 0x0e3:
+		case 0x0e4:
+		case 0x0e5:
+		case 0x0e6:
+		case 0x0e7:
+			return 1;
+		}
+
+	return 0;
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
+	.event = twinhan_event,
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
