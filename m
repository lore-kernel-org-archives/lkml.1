Return-Path: <linux-kernel-owner+w=401wt.eu-S1757060AbZFBOET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbZFBOET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbZFBOEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:04:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39826 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbZFBOD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:03:58 -0400
Date: Tue, 2 Jun 2009 15:03:57 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: linux-acpi@vger.kernel.org, dsilvers@simtec.co.uk,
       toshiba_acpi@memebeam.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] toshiba-acpi: Support TOS1900-type devices
Message-ID: <20090602140357.GA13548@srcf.ucam.org>
References: <20090331214749.GD29489@srcf.ucam.org> <74962ea30903311506m41306659td0cd70c5736f6660@mail.gmail.com> <20090331221107.GA30383@srcf.ucam.org> <74962ea30903311519s2fb6087fxfe8859e3c570ac99@mail.gmail.com> <20090331230217.GA31599@srcf.ucam.org> <74962ea30904010950u31fbdca3w51eafb9b7ec1ca73@mail.gmail.com> <20090401165345.GA13939@srcf.ucam.org> <74962ea30904011003o354e8780ya5e9ac1a6a579084@mail.gmail.com> <20090401170708.GA14167@srcf.ucam.org> <74962ea30904011013v5ffa0620y1f1aefa2c84e1ce@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74962ea30904011013v5ffa0620y1f1aefa2c84e1ce@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. From looking at your DSDT I'm still a little bit confused, but 
anyway. As far as I can tell the correct way to drive TOS1900-type 
devices is to call ENAB (which doesn't do anything on your machine) and 
then call the INFO method when we receive notifications. Your DSDT 
includes a NTFY method that doesn't appear to be called from anywhere. 
The path that we should be following is the one triggered by the _Q43 
EC query, which then generates a notification and flags that there's a 
hotkey waiting. The INFO method then unflags that, saves the value of 
TOHK and writes a zero into there.

So, from what I can tell, the following patch should work for you 
(against clean upstream). If it doesn't then we need to figure out 
what's happening when you press a hotkey in the first place.

commit 6edd24bf5ef664e8ac8d5f53774cb9ada8b11a37
Author: Matthew Garrett <mjg@redhat.com>
Date:   Fri Mar 6 00:25:45 2009 +0000

    toshiba-acpi: Add support for hotkey notifications
    
    Calling the ENAB method on Toshiba laptops results in notifications being
    sent when laptop hotkeys are pressed. This patch simply calls that method
    and sets up an input device if it's successful.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 9f18726..45c1fb0 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -46,6 +46,7 @@
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
 #include <linux/input-polldev.h>
+#include <linux/input.h>
 
 #include <asm/uaccess.h>
 
@@ -62,9 +63,10 @@ MODULE_LICENSE("GPL");
 
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
@@ -116,6 +118,37 @@ static const struct acpi_device_id toshiba_device_ids[] = {
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
 
@@ -252,6 +285,8 @@ struct toshiba_acpi_dev {
 	struct platform_device *p_dev;
 	struct rfkill *rfk_dev;
 	struct input_polled_dev *poll_dev;
+	struct input_dev *hotkey_dev;
+	acpi_handle handle;
 
 	const char *bt_name;
 	const char *rfk_name;
@@ -700,6 +735,154 @@ static struct backlight_ops toshiba_backlight_data = {
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
 	if (toshiba_acpi.poll_dev) {
@@ -707,12 +890,18 @@ static void toshiba_acpi_exit(void)
 		input_free_polled_device(toshiba_acpi.poll_dev);
 	}
 
+	if (toshiba_acpi.hotkey_dev)
+		input_unregister_device(toshiba_acpi.hotkey_dev);
+
 	if (toshiba_acpi.rfk_dev)
 		rfkill_unregister(toshiba_acpi.rfk_dev);
 
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
 
+	acpi_remove_notify_handler(toshiba_acpi.handle, ACPI_DEVICE_NOTIFY,
+				   toshiba_acpi_notify);
+
 	remove_device();
 
 	if (toshiba_proc_dir)
@@ -736,11 +925,15 @@ static int __init toshiba_acpi_init(void)
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

-- 
Matthew Garrett | mjg59@srcf.ucam.org
