Return-Path: <linux-kernel-owner+w=401wt.eu-S1752159AbXCMXIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbXCMXIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXCMXIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:08:52 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:56412 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXCMXIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:08:49 -0400
Message-ID: <45F72E40.9020909@tremplin-utc.net>
Date: Wed, 14 Mar 2007 00:05:36 +0100
From: Eric Piel <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 2.0b2 (X11/20070307)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: mitr@volny.cz, otauber@web.de, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wriston_btns: Add acerhk laptop database
References: <45ECA23A.5010503@tremplin-utc.net> <d120d5000703060536k7743ece9hb20fa4d1f7ad7ad7@mail.gmail.com> <45ED8809.70309@tremplin-utc.net>
In-Reply-To: <45ED8809.70309@tremplin-utc.net>
Content-Type: multipart/mixed;
 boundary="------------030102040006020809060409"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030102040006020809060409
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds all the "tm_new" laptops information that is in acerhk 
to wistron_btns. That's about 25 more laptops. Obviously, I couldn't try 
them all. I've just tried the Aspire 3020. For this reason, I've also 
added a printk which ask the users of those laptops to confirm me it 
works (or not). Surprisingly, the dmi information could be found on 
google for a majority of the laptops, so it might not work so badly.

The information about which laptop has which led is also imported, 
however for now it doesn't do anything. It's just in case someone adds 
led support later, in order to avoid hunting information in the acerhk 
for a second time.

Eric

--------------030102040006020809060409
Content-Type: text/x-patch;
 name="wistron_btns-add-acerhk-database-2.6.21.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="wistron_btns-add-acerhk-database-2.6.21.patch"

From: Eric Piel <eric.piel@tremplin-utc.net>

wriston_btns: Add acerhk laptop database

acerhk supports already a lot of laptops. Lets import its database so that everyone can benefit
of the work of Olaf Tauber. Only the "tm_new" laptops were imported. "tm_old" laptops could be possible 
but requires more testing and probably only few laptops are still alive. "dritek" laptops should 
probably be imported into a different driver. Also compress the keymaps by fitting each entry on
an int. Most of the dmi matching was written based on google searches, so it's rather prone to errors.
That's why I'm asking people to confirm it works.

This adds the following hardware:
Acer TravelMate 370
Acer TravelMate 380
Acer TravelMate C300
Acer TravelMate C100
Acer TravelMate C110
Acer TravelMate 250
Acer TravelMate 350
Acer TravelMate 620
Acer TravelMate 630
Acer TravelMate 220
Acer TravelMate 230
Acer TravelMate 260
Acer TravelMate 280
Acer TravelMate 360
Acer TravelMate 2100
Acer TravelMate 2410
Acer Aspire 1500
Acer Aspire 1600
Acer Aspire 3020
Acer Aspire 5020
Medion MD 2900
Medion MD 40100
Medion MD 95400
Medion MD 96500
Fujitsu Siemens Amilo 7820

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>

--- linux-2.6.21/drivers/input/misc/wistron_btns.c~tm610	2007-03-10 01:41:23.000000000 +0100
+++ linux-2.6.21/drivers/input/misc/wistron_btns.c	2007-03-12 00:54:54.000000000 +0100
@@ -233,11 +233,15 @@ static void bios_set_state(u8 subsys, in
 struct key_entry {
 	char type;		/* See KE_* below */
 	u8 code;
-	unsigned keycode;	/* For KE_KEY */
+	u16 keycode;		/* For KE_KEY */
 };
 
 enum { KE_END, KE_KEY, KE_WIFI, KE_BLUETOOTH };
 
+#define FE_MAIL_LED 0x01
+#define FE_WIFI_LED 0x02
+#define FE_UNTESTED 0x80
+
 static const struct key_entry *keymap; /* = NULL; Current key map */
 static int have_wifi;
 static int have_bluetooth;
@@ -288,7 +292,16 @@ static struct key_entry keymap_wistron_m
 	{ KE_KEY,  0x13, KEY_PROG3 },
 	{ KE_KEY,  0x31, KEY_MAIL },
 	{ KE_KEY,  0x36, KEY_WWW },
-	{ KE_END,  0 }
+	{ KE_END, FE_MAIL_LED }
+};
+
+static struct key_entry keymap_wistron_md40100[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x37, KEY_SCREEN }, /* Display on/off */
+	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
 };
 
 static struct key_entry keymap_wistron_ms2141[] = {
@@ -305,23 +318,163 @@ static struct key_entry keymap_wistron_m
 };
 
 static struct key_entry keymap_acer_aspire_1500[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x03, KEY_POWER },
 	{ KE_KEY, 0x11, KEY_PROG1 },
 	{ KE_KEY, 0x12, KEY_PROG2 },
 	{ KE_WIFI, 0x30, 0 },
 	{ KE_KEY, 0x31, KEY_MAIL },
 	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x49, KEY_CONFIG },
 	{ KE_BLUETOOTH, 0x44, 0 },
-	{ KE_END, 0 }
+	{ KE_END, FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_aspire_1600[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x49, KEY_CONFIG },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+/* 3020 has been tested */
+static struct key_entry keymap_acer_aspire_5020[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x05, KEY_MEDIA }, /* Display switch */
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x6a, KEY_CONFIG },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_2410[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x6d, KEY_POWER },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x6a, KEY_CONFIG },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_110[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_KEY, 0x4a, KEY_CLOSE }, /* lid close */
+	{ KE_KEY, 0x4b, KEY_OPEN }, /* lid open */
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_300[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_380[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER }, /* TM370 doesn't have this one */
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+/* unusual map */
+static struct key_entry keymap_acer_travelmate_220[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_MAIL },
+	{ KE_KEY, 0x12, KEY_WWW },
+	{ KE_KEY, 0x13, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_PROG1 },
+	{ KE_END, FE_WIFI_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_230[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_END, FE_WIFI_LED | FE_UNTESTED }
 };
 
 static struct key_entry keymap_acer_travelmate_240[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE },
 	{ KE_KEY, 0x31, KEY_MAIL },
 	{ KE_KEY, 0x36, KEY_WWW },
 	{ KE_KEY, 0x11, KEY_PROG1 },
 	{ KE_KEY, 0x12, KEY_PROG2 },
 	{ KE_BLUETOOTH, 0x44, 0 },
 	{ KE_WIFI, 0x30, 0 },
-	{ KE_END, 0 }
+	{ KE_END, FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_350[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_MAIL },
+	{ KE_KEY, 0x14, KEY_PROG3 },
+	{ KE_KEY, 0x15, KEY_WWW },
+	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_acer_travelmate_360[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_MAIL },
+	{ KE_KEY, 0x14, KEY_PROG3 },
+	{ KE_KEY, 0x15, KEY_WWW },
+	{ KE_KEY, 0x40, KEY_WLAN },
+	{ KE_END, FE_WIFI_LED | FE_UNTESTED } /* no mail led */
 };
 
 /* Wifi subsystem only activate the led. Therefore we need to pass
@@ -335,8 +488,24 @@ static struct key_entry keymap_acer_trav
 	{ KE_KEY, 0x13, KEY_PROG3 },
 	{ KE_KEY, 0x14, KEY_MAIL },
 	{ KE_KEY, 0x15, KEY_WWW },
-	{ KE_KEY, 0x40, KEY_WLAN }, /* Wifi */
-	{ KE_END, 0 }
+	{ KE_KEY, 0x40, KEY_WLAN },
+	{ KE_END, FE_MAIL_LED | FE_WIFI_LED }
+};
+
+static struct key_entry keymap_acer_travelmate_630[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x03, KEY_POWER },
+	{ KE_KEY, 0x08, KEY_MUTE }, /* not 620 */
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x13, KEY_PROG3 },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
 };
 
 static struct key_entry keymap_aopen_1559as[] = {
@@ -358,7 +527,39 @@ static struct key_entry keymap_fs_amilo_
 	{ KE_KEY, 0x11, KEY_PROG1 },
 	{ KE_KEY, 0x12, KEY_PROG2 },
 	{ KE_KEY, 0x13, KEY_PROG3 },
-	{ KE_END, 0 }
+	{ KE_END, FE_MAIL_LED | FE_WIFI_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_wistron_md2900[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_END, FE_MAIL_LED | FE_UNTESTED }
+};
+
+static struct key_entry keymap_wistron_md96500[] = {
+	{ KE_KEY, 0x01, KEY_HELP },
+	{ KE_KEY, 0x02, KEY_CONFIG },
+	{ KE_KEY, 0x05, KEY_MEDIA }, /* Display switch */
+	{ KE_KEY, 0x06, KEY_SCREEN }, /* Display on/off */
+	{ KE_KEY, 0x08, KEY_MUTE },
+	{ KE_KEY, 0x11, KEY_PROG1 },
+	{ KE_KEY, 0x12, KEY_PROG2 },
+	{ KE_KEY, 0x20, KEY_VOLUMEUP },
+	{ KE_KEY, 0x21, KEY_VOLUMEDOWN },
+	{ KE_KEY, 0x22, KEY_REWIND },
+	{ KE_KEY, 0x23, KEY_FORWARD },
+	{ KE_KEY, 0x24, KEY_PLAYPAUSE },
+	{ KE_KEY, 0x25, KEY_STOPCD },
+	{ KE_KEY, 0x31, KEY_MAIL },
+	{ KE_KEY, 0x36, KEY_WWW },
+	{ KE_WIFI, 0x30, 0 },
+	{ KE_BLUETOOTH, 0x44, 0 },
+	{ KE_END, FE_UNTESTED }
 };
 
 /*
@@ -405,6 +606,133 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer Aspire 1600",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 1600"),
+		},
+		.driver_data = keymap_acer_aspire_1600
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Aspire 3020",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 3020"),
+		},
+		.driver_data = keymap_acer_aspire_5020
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Aspire 5020",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5020"),
+		},
+		.driver_data = keymap_acer_aspire_5020
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 2100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2100"),
+		},
+		.driver_data = keymap_acer_aspire_5020
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 2410",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 2410"),
+		},
+		.driver_data = keymap_acer_travelmate_2410
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate C300",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C300"),
+		},
+		.driver_data = keymap_acer_travelmate_300
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate C100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C100"),
+		},
+		.driver_data = keymap_acer_travelmate_300
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate C110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate C110"),
+		},
+		.driver_data = keymap_acer_travelmate_110
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 380",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 380"),
+		},
+		.driver_data = keymap_acer_travelmate_380
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 370",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 370"),
+		},
+		.driver_data = keymap_acer_travelmate_380 /* keyboard minus 1 key */
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 220",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 220"),
+		},
+		.driver_data = keymap_acer_travelmate_220
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 260",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 260"),
+		},
+		.driver_data = keymap_acer_travelmate_220
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 230",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 230"),
+			/* acerhk looks for "TravelMate F4..." ?! */
+		},
+		.driver_data = keymap_acer_travelmate_230
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 280",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 280"),
+		},
+		.driver_data = keymap_acer_travelmate_230
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Acer TravelMate 240",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
@@ -414,6 +742,15 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer TravelMate 250",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 250"),
+		},
+		.driver_data = keymap_acer_travelmate_240
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Acer TravelMate 2424NWXCi",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
@@ -423,6 +760,24 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer TravelMate 350",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 350"),
+		},
+		.driver_data = keymap_acer_travelmate_350
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 360",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
+		},
+		.driver_data = keymap_acer_travelmate_360
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Acer TravelMate 610",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ACER"),
@@ -432,6 +787,24 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Acer TravelMate 620",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 620"),
+		},
+		.driver_data = keymap_acer_travelmate_630
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer TravelMate 630",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 630"),
+		},
+		.driver_data = keymap_acer_travelmate_630
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "AOpen 1559AS",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "E2U"),
@@ -450,6 +823,51 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Medion MD 40100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONNB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WID2000"),
+		},
+		.driver_data = keymap_wistron_md40100
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Medion MD 2900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONNB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2000"),
+		},
+		.driver_data = keymap_wistron_md2900
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Medion MD 96500",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2040"),
+		},
+		.driver_data = keymap_wistron_md96500
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Medion MD 95400",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDIONPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2050"),
+		},
+		.driver_data = keymap_wistron_md96500
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "Fujitsu Siemens Amilo D7820",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"), /* not sure */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Amilo D"),
+		},
+		.driver_data = keymap_fs_amilo_d88x0
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Fujitsu Siemens Amilo D88x0",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
@@ -506,6 +924,12 @@ static int __devinit setup_input_dev(voi
 		}
 	}
 
+	/* reads information flags on KE_END */
+	if (key->code & FE_UNTESTED)
+		printk(KERN_WARNING "Untested laptop multimedia keys, "
+			"please report success or failure to eric.piel"
+			"@tremplin-utc.net\n");
+
 	error = input_register_device(input_dev);
 	if (error) {
 		input_free_device(input_dev);

--------------030102040006020809060409--
