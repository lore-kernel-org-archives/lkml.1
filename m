Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573Ab0AZQ7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0AZQ7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 11:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996Ab0AZQ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 11:59:07 -0500
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:49845 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107Ab0AZQ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 11:59:05 -0500
From: Frans Pop <elendil@planet.nl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Status of 'toshiba-acpi: Add support for hotkey notifications' patch?
Date: Tue, 26 Jan 2010 17:59:00 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001261759.01081.elendil@planet.nl>
X-OriginalArrivalTime: 26 Jan 2010 16:59:01.0627 (UTC) FILETIME=[DC01A4B0:01CA9EA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

What's the status of the patch below [1]? IIRC you were waiting for feedback
from a particular user?

The patch works fine for me on my Satellite A40 and I'd like to see
it included.

Cheers,
FJP

[1] Patch has been rebased for current mainline.

Author: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: toshiba-acpi: Add support for hotkey notifications

Calling the ENAB method on Toshiba laptops results in notifications being
sent when laptop hotkeys are pressed. This patch simply calls that method
and sets up an input device if it's successful.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 77bf5d8..13344b1 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -46,6 +46,8 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
+#include <linux/input-polldev.h>
+#include <linux/input.h>
 
 #include <asm/uaccess.h>
 
@@ -62,9 +64,10 @@ MODULE_LICENSE("GPL");
 
 /* Toshiba ACPI method paths */
 #define METHOD_LCD_BRIGHTNESS	"\\_SB_.PCI0.VGA_.LCD_._BCM"
-#define METHOD_HCI_1		"\\_SB_.VALD.GHCI"
-#define METHOD_HCI_2		"\\_SB_.VALZ.GHCI"
+#define TOSH_INTERFACE_1	"\\_SB_.VALD"
+#define TOSH_INTERFACE_2	"\\_SB_.VALZ"
 #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"
+#define GHCI_METHOD		".GHCI"
 
 /* Toshiba HCI interface definitions
  *
@@ -116,6 +119,37 @@ static const struct acpi_device_id toshiba_device_ids[] = {
 };
 MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
 
+struct key_entry {
+	char type;
+	u16 code;
+	u16 keycode;
+};
+
+enum {KE_KEY, KE_END};
+
+static struct key_entry toshiba_acpi_keymap[]  = {
+	{KE_KEY, 0x101, KEY_MUTE},
+	{KE_KEY, 0x13b, KEY_COFFEE},
+	{KE_KEY, 0x13c, KEY_BATTERY},
+	{KE_KEY, 0x13d, KEY_SLEEP},
+	{KE_KEY, 0x13e, KEY_SUSPEND},
+	{KE_KEY, 0x13f, KEY_SWITCHVIDEOMODE},
+	{KE_KEY, 0x140, KEY_BRIGHTNESSDOWN},
+	{KE_KEY, 0x141, KEY_BRIGHTNESSUP},
+	{KE_KEY, 0x142, KEY_WLAN},
+	{KE_KEY, 0x143, KEY_PROG1},
+	{KE_KEY, 0x17f, KEY_BRIGHTNESSDOWN},
+	{KE_KEY, 0xb05, KEY_PROG2},
+	{KE_KEY, 0xb06, KEY_WWW},
+	{KE_KEY, 0xb07, KEY_MAIL},
+	{KE_KEY, 0xb30, KEY_STOP},
+	{KE_KEY, 0xb31, KEY_PREVIOUSSONG},
+	{KE_KEY, 0xb32, KEY_NEXTSONG},
+	{KE_KEY, 0xb33, KEY_PLAYPAUSE},
+	{KE_KEY, 0xb5a, KEY_MEDIA},
+	{KE_END, 0, 0},
+};
+
 /* utility
  */
 
@@ -251,6 +285,9 @@ static acpi_status hci_read2(u32 reg, u32 *out1, u32 *out2, u32 
*result)
 struct toshiba_acpi_dev {
 	struct platform_device *p_dev;
 	struct rfkill *bt_rfk;
+	struct input_polled_dev *poll_dev;
+	struct input_dev *hotkey_dev;
+	acpi_handle handle;
 
 	const char *bt_name;
 
@@ -711,6 +748,154 @@ static struct backlight_ops toshiba_backlight_data = {
         .update_status  = set_lcd_status,
 };
 
+static struct key_entry *toshiba_acpi_get_entry_by_scancode(int code)
+{
+	struct key_entry *key;
+
+	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
+		if (code == key->code)
+			return key;
+
+	return NULL;
+}
+
+static struct key_entry *toshiba_acpi_get_entry_by_keycode(int code)
+{
+	struct key_entry *key;
+
+	for (key = toshiba_acpi_keymap; key->type != KE_END; key++)
+		if (code == key->keycode && key->type == KE_KEY)
+			return key;
+
+	return NULL;
+}
+
+static int toshiba_acpi_getkeycode(struct input_dev *dev, int scancode,
+				   int *keycode)
+{
+	struct key_entry *key = toshiba_acpi_get_entry_by_scancode(scancode);
+
+	if (key && key->type == KE_KEY) {
+		*keycode = key->keycode;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int toshiba_acpi_setkeycode(struct input_dev *dev, int scancode,
+				   int keycode)
+{
+	struct key_entry *key;
+	int old_keycode;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
+
+	key = toshiba_acpi_get_entry_by_scancode(scancode);
+	if (key && key->type == KE_KEY) {
+		old_keycode = key->keycode;
+		key->keycode = keycode;
+		set_bit(keycode, dev->keybit);
+		if (!toshiba_acpi_get_entry_by_keycode(old_keycode))
+			clear_bit(old_keycode, dev->keybit);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void toshiba_acpi_notify(acpi_handle handle, u32 event, void **data)
+{
+	u32 hci_result, value;
+	struct key_entry *key;
+
+	if (event != 0x80)
+		return;
+	do {
+		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+		if (hci_result == HCI_SUCCESS) {
+			if (value == 0x100)
+				continue;
+			else if (!(value & 0x80)) {
+				key = toshiba_acpi_get_entry_by_scancode
+					(value);
+				if (!key) {
+					printk(MY_INFO "Unknown key %x\n",
+					       value);
+					continue;
+				}
+				input_report_key(toshiba_acpi.hotkey_dev,
+						 key->keycode, 1);
+				input_sync(toshiba_acpi.hotkey_dev);
+				input_report_key(toshiba_acpi.hotkey_dev,
+						 key->keycode, 0);
+				input_sync(toshiba_acpi.hotkey_dev);
+			}
+		} else if (hci_result == HCI_NOT_SUPPORTED) {
+			/* This is a workaround for an unresolved issue on
+			 * some machines where system events sporadically
+			 * become disabled. */
+			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+			printk(MY_NOTICE "Re-enabled hotkeys\n");
+		}
+	} while (hci_result != HCI_EMPTY);
+}
+
+static int toshiba_acpi_setup_keyboard(char *device)
+{
+	acpi_status status;
+	acpi_handle handle;
+	int result;
+	const struct key_entry *key;
+
+	status = acpi_get_handle(NULL, device, &handle);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_INFO "Unable to get notification device\n");
+		return -ENODEV;
+	}
+
+	toshiba_acpi.handle = handle;
+
+	status = acpi_evaluate_object(handle, "ENAB", NULL, NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_INFO "Unable to enable hotkeys\n");
+		return -ENODEV;
+	}
+
+	status = acpi_install_notify_handler (handle, ACPI_DEVICE_NOTIFY,
+					      toshiba_acpi_notify, NULL);
+	if (ACPI_FAILURE(status)) {
+		printk(MY_INFO "Unable to install hotkey notification\n");
+		return -ENODEV;
+	}
+
+	toshiba_acpi.hotkey_dev = input_allocate_device();
+	if (!toshiba_acpi.hotkey_dev) {
+		printk(MY_INFO "Unable to register input device\n");
+		return -ENOMEM;
+	}
+
+	toshiba_acpi.hotkey_dev->name = "Toshiba input device";
+	toshiba_acpi.hotkey_dev->phys = device;
+	toshiba_acpi.hotkey_dev->id.bustype = BUS_HOST;
+	toshiba_acpi.hotkey_dev->getkeycode = toshiba_acpi_getkeycode;
+	toshiba_acpi.hotkey_dev->setkeycode = toshiba_acpi_setkeycode;
+
+	for (key = toshiba_acpi_keymap; key->type != KE_END; key++) {
+		set_bit(EV_KEY, toshiba_acpi.hotkey_dev->evbit);
+		set_bit(key->keycode, toshiba_acpi.hotkey_dev->keybit);
+	}
+
+	result = input_register_device(toshiba_acpi.hotkey_dev);
+	if (result) {
+		printk(MY_INFO "Unable to register input device\n");
+		return result;
+	}
+
+	return 0;
+}
+
 static void toshiba_acpi_exit(void)
 {
 	if (toshiba_acpi.bt_rfk) {
@@ -718,9 +903,15 @@ static void toshiba_acpi_exit(void)
 		rfkill_destroy(toshiba_acpi.bt_rfk);
 	}
 
+	if (toshiba_acpi.hotkey_dev)
+		input_unregister_device(toshiba_acpi.hotkey_dev);
+
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
 
+	acpi_remove_notify_handler(toshiba_acpi.handle, ACPI_DEVICE_NOTIFY,
+				   toshiba_acpi_notify);
+
 	remove_device();
 
 	if (toshiba_proc_dir)
@@ -742,11 +933,15 @@ static int __init toshiba_acpi_init(void)
 		return -ENODEV;
 
 	/* simple device detection: look for HCI method */
-	if (is_valid_acpi_path(METHOD_HCI_1))
-		method_hci = METHOD_HCI_1;
-	else if (is_valid_acpi_path(METHOD_HCI_2))
-		method_hci = METHOD_HCI_2;
-	else
+	if (is_valid_acpi_path(TOSH_INTERFACE_1 GHCI_METHOD)) {
+		method_hci = TOSH_INTERFACE_1 GHCI_METHOD;
+		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_1))
+			printk(MY_INFO "Unable to activate hotkeys\n");
+	} else if (is_valid_acpi_path(TOSH_INTERFACE_2 GHCI_METHOD)) {
+		method_hci = TOSH_INTERFACE_2 GHCI_METHOD;
+		if (toshiba_acpi_setup_keyboard(TOSH_INTERFACE_2))
+			printk(MY_INFO "Unable to activate hotkeys\n");
+	} else
 		return -ENODEV;
 
 	printk(MY_INFO "Toshiba Laptop ACPI Extras version %s\n",
