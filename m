Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0BBHyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:54:45 -0500
Received: from iksaif.net ([88.191.73.63]:50263 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab0BBHwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:52:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 20/28] asus-laptop: switch to sparse keymap library
Date: Tue,  2 Feb 2010 08:39:03 +0100
Message-Id: <1265096351-15239-21-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1265096351-15239-20-git-send-email-corentincj@iksaif.net>
References: <1265096351-15239-1-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-2-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-3-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-4-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-5-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-6-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-7-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-8-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-9-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-10-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-11-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-12-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-13-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-14-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-15-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-16-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-17-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-18-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-19-git-send-email-corentincj@iksaif.net>
 <1265096351-15239-20-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on Dmitry Torokhov's patch with
some modifications and cleanups.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/Kconfig       |    1 +
 drivers/platform/x86/asus-laptop.c |  208 ++++++++++++------------------------
 2 files changed, 68 insertions(+), 141 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index f526e73..7f5a222 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -59,6 +59,7 @@ config ASUS_LAPTOP
 	select NEW_LEDS
 	select BACKLIGHT_CLASS_DEVICE
 	depends on INPUT
+	select INPUT_SPARSEKMAP
 	---help---
 	  This is the new Linux driver for Asus laptops. It may also support some
 	  MEDION, JVC or VICTOR laptops. It makes all the extra buttons generate
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index bb8fb45..8042568 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -49,6 +49,7 @@
 #include <acpi/acpi_bus.h>
 #include <asm/uaccess.h>
 #include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
 
 #define ASUS_LAPTOP_VERSION	"0.42"
 
@@ -243,52 +244,45 @@ struct asus_laptop {
 	u16 *keycode_map;
 };
 
-struct key_entry {
-	char type;
-	u8 code;
-	u16 keycode;
-};
-
-enum { KE_KEY, KE_END };
-
 static const struct key_entry asus_keymap[] = {
-	{KE_KEY, 0x02, KEY_SCREENLOCK},
-	{KE_KEY, 0x05, KEY_WLAN},
-	{KE_KEY, 0x08, KEY_F13},
-	{KE_KEY, 0x17, KEY_ZOOM},
-	{KE_KEY, 0x1f, KEY_BATTERY},
-	{KE_KEY, 0x30, KEY_VOLUMEUP},
-	{KE_KEY, 0x31, KEY_VOLUMEDOWN},
-	{KE_KEY, 0x32, KEY_MUTE},
-	{KE_KEY, 0x33, KEY_SWITCHVIDEOMODE},
-	{KE_KEY, 0x34, KEY_SWITCHVIDEOMODE},
-	{KE_KEY, 0x40, KEY_PREVIOUSSONG},
-	{KE_KEY, 0x41, KEY_NEXTSONG},
-	{KE_KEY, 0x43, KEY_STOPCD},
-	{KE_KEY, 0x45, KEY_PLAYPAUSE},
-	{KE_KEY, 0x4c, KEY_MEDIA},
-	{KE_KEY, 0x50, KEY_EMAIL},
-	{KE_KEY, 0x51, KEY_WWW},
-	{KE_KEY, 0x55, KEY_CALC},
-	{KE_KEY, 0x5C, KEY_SCREENLOCK},  /* Screenlock */
-	{KE_KEY, 0x5D, KEY_WLAN},
-	{KE_KEY, 0x5E, KEY_WLAN},
-	{KE_KEY, 0x5F, KEY_WLAN},
-	{KE_KEY, 0x60, KEY_SWITCHVIDEOMODE},
-	{KE_KEY, 0x61, KEY_SWITCHVIDEOMODE},
-	{KE_KEY, 0x62, KEY_SWITCHVIDEOMODE},
-	{KE_KEY, 0x63, KEY_SWITCHVIDEOMODE},
-	{KE_KEY, 0x6B, KEY_F13}, /* Lock Touchpad */
-	{KE_KEY, 0x82, KEY_CAMERA},
-	{KE_KEY, 0x88, KEY_WLAN },
-	{KE_KEY, 0x8A, KEY_PROG1},
-	{KE_KEY, 0x95, KEY_MEDIA},
-	{KE_KEY, 0x99, KEY_PHONE},
-	{KE_KEY, 0xc4, KEY_KBDILLUMUP},
-	{KE_KEY, 0xc5, KEY_KBDILLUMDOWN},
+	{KE_KEY, 0x02, { KEY_SCREENLOCK } },
+	{KE_KEY, 0x05, { KEY_WLAN } },
+	{KE_KEY, 0x08, { KEY_F13 } },
+	{KE_KEY, 0x17, { KEY_ZOOM } },
+	{KE_KEY, 0x1f, { KEY_BATTERY } },
+	{KE_KEY, 0x30, { KEY_VOLUMEUP } },
+	{KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
+	{KE_KEY, 0x32, { KEY_MUTE } },
+	{KE_KEY, 0x33, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x34, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
+	{KE_KEY, 0x41, { KEY_NEXTSONG } },
+	{KE_KEY, 0x43, { KEY_STOPCD } },
+	{KE_KEY, 0x45, { KEY_PLAYPAUSE } },
+	{KE_KEY, 0x4c, { KEY_MEDIA } },
+	{KE_KEY, 0x50, { KEY_EMAIL } },
+	{KE_KEY, 0x51, { KEY_WWW } },
+	{KE_KEY, 0x55, { KEY_CALC } },
+	{KE_KEY, 0x5C, { KEY_SCREENLOCK } },  /* Screenlock */
+	{KE_KEY, 0x5D, { KEY_WLAN } },
+	{KE_KEY, 0x5E, { KEY_WLAN } },
+	{KE_KEY, 0x5F, { KEY_WLAN } },
+	{KE_KEY, 0x60, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x61, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } },
+	{KE_KEY, 0x6B, { KEY_F13 } }, /* Lock Touchpad */
+	{KE_KEY, 0x82, { KEY_CAMERA } },
+	{KE_KEY, 0x88, { KEY_WLAN  } },
+	{KE_KEY, 0x8A, { KEY_PROG1 } },
+	{KE_KEY, 0x95, { KEY_MEDIA } },
+	{KE_KEY, 0x99, { KEY_PHONE } },
+	{KE_KEY, 0xc4, { KEY_KBDILLUMUP } },
+	{KE_KEY, 0xc5, { KEY_KBDILLUMDOWN } },
 	{KE_END, 0},
 };
 
+
 /*
  * This function evaluates an ACPI method, given an int as parameter, the
  * method is searched within the scope of the handle, can be NULL. The output
@@ -1050,123 +1044,55 @@ static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 /*
  * Input device (i.e. hotkeys)
  */
-static struct key_entry *asus_get_entry_by_scancode(struct asus_laptop *asus,
-						    int code)
-{
-	struct key_entry *key;
-
-	for (key = asus->keymap; key->type != KE_END; key++)
-		if (code == key->code)
-			return key;
-
-	return NULL;
-}
-
-static struct key_entry *asus_get_entry_by_keycode(struct asus_laptop *asus,
-						   int code)
-{
-	struct key_entry *key;
-
-	for (key = asus->keymap; key->type != KE_END; key++)
-		if (code == key->keycode && key->type == KE_KEY)
-			return key;
-
-	return NULL;
-}
-
-static int asus_getkeycode(struct input_dev *dev, int scancode, int *keycode)
-{
-	struct asus_laptop *asus = input_get_drvdata(dev);
-	struct key_entry *key = asus_get_entry_by_scancode(asus, scancode);
-
-	if (key && key->type == KE_KEY) {
-		*keycode = key->keycode;
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
-static int asus_setkeycode(struct input_dev *dev, int scancode, int keycode)
-{
-	struct asus_laptop *asus = input_get_drvdata(dev);
-	struct key_entry *key;
-	int old_keycode;
-
-	if (keycode < 0 || keycode > KEY_MAX)
-		return -EINVAL;
-
-	key = asus_get_entry_by_scancode(asus, scancode);
-	if (key && key->type == KE_KEY) {
-		old_keycode = key->keycode;
-		key->keycode = keycode;
-		set_bit(keycode, dev->keybit);
-		if (!asus_get_entry_by_keycode(asus, old_keycode))
-			clear_bit(old_keycode, dev->keybit);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static void asus_input_notify(struct asus_laptop *asus, int event)
 {
-	struct key_entry *key;
-
-	key = asus_get_entry_by_scancode(asus, event);
-	if (!key)
-		return ;
-
-	switch (key->type) {
-	case KE_KEY:
-		input_report_key(asus->inputdev, key->keycode, 1);
-		input_sync(asus->inputdev);
-		input_report_key(asus->inputdev, key->keycode, 0);
-		input_sync(asus->inputdev);
-		break;
-	}
+	if (asus->inputdev)
+		sparse_keymap_report_event(asus->inputdev, event, 1, true);
 }
 
 static int asus_input_init(struct asus_laptop *asus)
 {
-	const struct key_entry *key;
-	int result;
+	struct input_dev *input;
+	int error;
 
-	asus->inputdev = input_allocate_device();
-	if (!asus->inputdev) {
+	input = input_allocate_device();
+	if (!input) {
 		pr_info("Unable to allocate input device\n");
 		return 0;
 	}
-	asus->inputdev->name = "Asus Laptop extra buttons";
-	asus->inputdev->dev.parent = &asus->platform_device->dev;
-	asus->inputdev->phys = ASUS_LAPTOP_FILE "/input0";
-	asus->inputdev->id.bustype = BUS_HOST;
-	asus->inputdev->getkeycode = asus_getkeycode;
-	asus->inputdev->setkeycode = asus_setkeycode;
-	input_set_drvdata(asus->inputdev, asus);
-
-	asus->keymap = kmemdup(asus_keymap, sizeof(asus_keymap),
-				GFP_KERNEL);
-	for (key = asus->keymap; key->type != KE_END; key++) {
-		switch (key->type) {
-		case KE_KEY:
-			set_bit(EV_KEY, asus->inputdev->evbit);
-			set_bit(key->keycode, asus->inputdev->keybit);
-			break;
-		}
+	input->name = "Asus Laptop extra buttons";
+	input->phys = ASUS_LAPTOP_FILE "/input0";
+	input->id.bustype = BUS_HOST;
+	input->dev.parent = &asus->platform_device->dev;
+	input_set_drvdata(input, asus);
+
+	error = sparse_keymap_setup(input, asus_keymap, NULL);
+	if (error) {
+		pr_err("Unable to setup input device keymap\n");
+		goto err_keymap;
 	}
-	result = input_register_device(asus->inputdev);
-	if (result) {
+	error = input_register_device(input);
+	if (error) {
 		pr_info("Unable to register input device\n");
-		input_free_device(asus->inputdev);
+		goto err_device;
 	}
-	return result;
+
+	asus->inputdev = input;
+	return 0;
+
+err_keymap:
+	sparse_keymap_free(input);
+err_device:
+	input_free_device(input);
+	return error;
 }
 
 static void asus_input_exit(struct asus_laptop *asus)
 {
-	if (asus->inputdev)
+	if (asus->inputdev) {
+		sparse_keymap_free(asus->inputdev);
 		input_unregister_device(asus->inputdev);
+	}
 }
 
 /*
-- 
1.6.6.1

