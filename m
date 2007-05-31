Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbXEaXJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbXEaXJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbXEaXJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:09:38 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:14614 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXEaXJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:09:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=RLMeveS0pEO3dcx/n4aOErhSEklElEYCERgzcnOTbUzHcbRB5R7/GjwPXKxQdzR1pjCade7xfK3cxZpHynfZxk3NHtCyrlDumJ2HybRvcQu7CeZbkNK4liyx10y3crhfFt4KlbTi/OyLsjR71w+xAlPKrGvPlwEfPvN3ubVJlMo=
Subject: Re: Add INPUT support to toshiba_acpi
From: Richard Hughes <hughsient@gmail.com>
To: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
Cc: Bastien Nocera <hadess@hadess.net>, John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <20070531164639.GA13742@rhlx01.hs-esslingen.de>
References: <1180614979.2693.26.camel@localhost.localdomain>
	 <1180615994.3030.166.camel@cookie.hadess.net>
	 <1180619002.2693.35.camel@localhost.localdomain>
	 <1180626416.3469.7.camel@localhost.localdomain>
	 <20070531164639.GA13742@rhlx01.hs-esslingen.de>
Content-Type: multipart/mixed; boundary="=-Jkj4oVQhIgPTEeHC2aZh"
Date: Fri, 01 Jun 2007 00:09:32 +0100
Message-Id: <1180652972.25067.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Jkj4oVQhIgPTEeHC2aZh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-05-31 at 18:46 +0200, Andreas Mohr wrote:
> HCI_EMPTY is *by far* the most frequent state to occur I think
> (users won't press keys all the time), thus it's probably better(?)
> for branch prediction to have this placed first, right?
> Not that it matters too much instruction-wise, but still...

Sure.

> Apart from that I'm very happy to see progress on this front
> (speaking as a "proud" owner of an old Toshiba notebook requiring
> this stuff).

Good - this stuff should just work :-)

> And I'd definitely move the multiple identical "Re-enabled hotkeys" parts
> into one single non-inlined(!) function for the same reason.
> Not to mention that it's BUTT UGLY to have the *same* fat
> multi-line comment duplicated bazillion times.

Agree. New patch (untested) attached.

Thanks for review,

Richard.


--=-Jkj4oVQhIgPTEeHC2aZh
Content-Disposition: attachment; filename=toshiba_acpi_add_buttons_05.patch
Content-Type: text/x-patch; name=toshiba_acpi_add_buttons_05.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 139f41f..38835b6 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -222,6 +222,7 @@ config ACPI_TOSHIBA
 	tristate "Toshiba Laptop Extras"
 	depends on X86
 	select BACKLIGHT_CLASS_DEVICE
+	select INPUT_POLLDEV
 	---help---
 	  This driver adds support for access to certain system settings
 	  on "legacy free" Toshiba laptops.  These laptops can be recognized by
diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 3906d47..f802609 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -27,13 +27,13 @@
  *		engineering the Windows drivers
  *	Yasushi Nagato - changes for linux kernel 2.4 -> 2.5
  *	Rob Miller - TV out and hotkeys help
- *
+ *	Richard Hughes - emit INPUT events for hotkeys
  *
  *  TODO
  *
  */
 
-#define TOSHIBA_ACPI_VERSION	"0.18"
+#define TOSHIBA_ACPI_VERSION	"0.19"
 #define PROC_INTERFACE_VERSION	1
 
 #include <linux/kernel.h>
@@ -42,6 +42,7 @@
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 #include <linux/backlight.h>
+#include <linux/input-polldev.h>
 
 #include <asm/uaccess.h>
 
@@ -99,6 +100,16 @@ MODULE_LICENSE("GPL");
 #define HCI_VIDEO_OUT_CRT		0x2
 #define HCI_VIDEO_OUT_TV		0x4
 
+/* key definitions */
+#define HCI_HKEY_MUTE			0x0101
+#define HCI_HKEY_LOCK			0x013b
+#define HCI_HKEY_SEARCH			0x013c
+#define HCI_HKEY_SUSPEND		0x013d
+#define HCI_HKEY_HIBERNATE		0x013e
+#define HCI_HKEY_BRIGHTNESSDOWN		0x0140
+#define HCI_HKEY_BRIGHTNESSUP		0x0141
+#define HCI_HKEY_WLAN			0x0142
+
 /* utility
  */
 
@@ -213,9 +224,15 @@ static acpi_status hci_read1(u32 reg, u32 * out1, u32 * result)
 
 static struct proc_dir_entry *toshiba_proc_dir /*= 0*/ ;
 static struct backlight_device *toshiba_backlight_device;
+static struct input_polled_dev *toshiba_poll_dev;
 static int force_fan;
 static int last_key_event;
 static int key_event_valid;
+static int hotkeys_over_input = 1;
+static int hotkeys_check_per_sec = 2;
+
+module_param(hotkeys_over_input, uint, 0400);
+module_param(hotkeys_check_per_sec, uint, 0400);
 
 typedef struct _ProcItem {
 	const char *name;
@@ -438,34 +455,60 @@ static unsigned long write_fan(const char *buffer, unsigned long count)
 	return count;
 }
 
-static char *read_keys(char *p)
+/* returns zero if hci event is invalid */
+static u32 get_hci_system_event_value(void)
 {
 	u32 hci_result;
 	u32 value;
+	u32 retval = 0;
+
+	/* read a system event from the queue */
+	hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+
+	switch (hci_result) {
+	case HCI_EMPTY:
+		/* better luck next time */
+		break;
+	case HCI_SUCCESS:
+		/* value is the data in the queue */
+		retval = value;
+		break;
+	case HCI_NOT_SUPPORTED:
+		/* This is a workaround for an unresolved issue on
+		 * some machines where system events sporadically
+		 * become disabled. */
+		hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+		printk(MY_NOTICE "Re-enabled hotkeys\n");
+		break;
+	default:
+		/* there was an unknown error */
+		printk(MY_ERR "Error reading hotkey status\n");
+	}
+	return retval;
+}
 
-	if (!key_event_valid) {
-		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
-		if (hci_result == HCI_SUCCESS) {
-			key_event_valid = 1;
-			last_key_event = value;
-		} else if (hci_result == HCI_EMPTY) {
-			/* better luck next time */
-		} else if (hci_result == HCI_NOT_SUPPORTED) {
-			/* This is a workaround for an unresolved issue on
-			 * some machines where system events sporadically
-			 * become disabled. */
-			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
-			printk(MY_NOTICE "Re-enabled hotkeys\n");
-		} else {
-			printk(MY_ERR "Error reading hotkey status\n");
-			goto end;
+/* deprecate this interface... */
+static char *read_keys(char *p)
+{
+	u32 value;
+
+	if (hotkeys_over_input) {
+		key_event_valid = 0;
+		last_key_event = 0;
+	} else {
+		if (!key_event_valid) {
+			value = get_hci_system_event_value();
+			if (value != 0) {
+				key_event_valid = 1;
+				last_key_event = value;
+			}
 		}
 	}
 
 	p += sprintf(p, "hotkey_ready:            %d\n", key_event_valid);
 	p += sprintf(p, "hotkey:                  0x%04x\n", last_key_event);
+	p += sprintf(p, "hotkeys_via_input:       %d\n", hotkeys_over_input);
 
-      end:
 	return p;
 }
 
@@ -534,15 +577,103 @@ static acpi_status __exit remove_device(void)
 }
 
 static struct backlight_ops toshiba_backlight_data = {
-        .get_brightness = get_lcd,
-        .update_status  = set_lcd_status,
+	.get_brightness = get_lcd,
+	.update_status  = set_lcd_status,
 };
 
+static void toshiba_deliver_button_event(struct input_dev *input, u32 value)
+{
+	int keycode = KEY_UNKNOWN;
+	int key_down = 1;
+
+	if (!input)
+		return;
+
+	/* translate MSB to key up */
+	if (value & 0x80) {
+		value &= ~0x80;
+		key_down = 0;
+	}
+
+	/* ignore FN on its own */
+	if (value == 0x0100)
+		return;
+
+	/* translate keys to keycodes */
+	switch (value) {
+	case HCI_HKEY_MUTE:
+		keycode = KEY_MUTE;
+		break;
+	case HCI_HKEY_LOCK:
+		keycode = KEY_CLEAR;
+		break;
+	case HCI_HKEY_SEARCH:
+		keycode = KEY_SEARCH;
+		break;
+	case HCI_HKEY_SUSPEND:
+		keycode = KEY_SLEEP;
+		break;
+	case HCI_HKEY_HIBERNATE:
+		keycode = KEY_SUSPEND;
+		break;
+	case HCI_HKEY_BRIGHTNESSDOWN:
+		keycode = KEY_BRIGHTNESSDOWN;
+		break;
+	case HCI_HKEY_BRIGHTNESSUP:
+		keycode = KEY_BRIGHTNESSUP;
+		break;
+	case HCI_HKEY_WLAN:
+		keycode = KEY_WLAN;
+		break;
+	default:
+		keycode = KEY_UNKNOWN;
+	}
+
+	if (keycode != KEY_UNKNOWN) {
+		printk(MY_INFO "mapped hkey %i to keycode %i [%i]\n", value, keycode, key_down);
+		input_report_key(input, keycode, key_down);
+		input_sync(input);
+	}
+}
+
+/* the HCI buffer might have keys pressed some time ago */
+static void toshiba_keys_clear(void)
+{
+	int hci_queue = 0;
+	do {
+		/* we don't want to get stuck here */
+		if (hci_queue++ > 16)
+			break;
+	} while (get_hci_system_event_value());
+}
+
+static void handle_buttons(struct input_polled_dev *dev)
+{
+	u32 value;
+	int hci_queue = 0;
+	struct input_dev *input = dev->input;
+
+	do {
+		/* we don't want to get stuck here */
+		if (hci_queue++ > 16)
+			break;
+		/* try to get a button event */
+		value = get_hci_system_event_value();
+		if (value)
+			toshiba_deliver_button_event(input, value);
+	} while (value);
+}
+
 static void __exit toshiba_acpi_exit(void)
 {
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
 
+	if (toshiba_poll_dev) {
+		input_unregister_polled_device(toshiba_poll_dev);
+		input_free_polled_device(toshiba_poll_dev);
+	}
+
 	remove_device();
 
 	if (toshiba_proc_dir)
@@ -551,6 +682,49 @@ static void __exit toshiba_acpi_exit(void)
 	return;
 }
 
+static int __init toshiba_input_polldev_init(void)
+{
+	int error;
+	struct input_dev *input;
+
+	/* use INPUT for key events */
+	toshiba_poll_dev = input_allocate_polled_device();;
+	if (!toshiba_poll_dev) {
+		error = -ENOMEM;
+		goto err_no_mem;
+	}
+	toshiba_poll_dev->poll = handle_buttons;
+	toshiba_poll_dev->poll_interval = HZ / hotkeys_check_per_sec;
+	input = toshiba_poll_dev->input;
+
+	/* create one 'keyboard' virtual input device for all the acpi events */
+	input->name = "Toshiba Extra Buttons";
+	input->phys = "toshiba/input0";
+	input->id.bustype = BUS_HOST;
+	input->id.product = 0x0001;
+	input->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_MUTE, input->keybit);
+	set_bit(KEY_BREAK, input->keybit); /* probably should be KEY_LOCK */
+	set_bit(KEY_SEARCH, input->keybit);
+	set_bit(KEY_SUSPEND, input->keybit);
+	set_bit(KEY_SLEEP, input->keybit);
+	set_bit(KEY_BRIGHTNESSDOWN, input->keybit);
+	set_bit(KEY_BRIGHTNESSUP, input->keybit);
+	set_bit(KEY_WLAN, input->keybit);
+
+	toshiba_keys_clear();
+
+	error = input_register_polled_device(toshiba_poll_dev);
+	if (error)
+		goto err_free_input;
+	return 0;
+
+err_free_input:
+	input_free_polled_device(toshiba_poll_dev);
+err_no_mem:
+	return error;
+}
+
 static int __init toshiba_acpi_init(void)
 {
 	acpi_status status = AE_OK;
@@ -590,12 +764,28 @@ static int __init toshiba_acpi_init(void)
 	toshiba_backlight_device = backlight_device_register("toshiba",NULL,
 						NULL,
 						&toshiba_backlight_data);
-        if (IS_ERR(toshiba_backlight_device)) {
+	if (IS_ERR(toshiba_backlight_device)) {
 		printk(KERN_ERR "Could not register toshiba backlight device\n");
 		toshiba_backlight_device = NULL;
 		toshiba_acpi_exit();
 	}
-        toshiba_backlight_device->props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
+	toshiba_backlight_device->props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
+
+	/* we have to poll the device as we do not get events */
+	if (hotkeys_over_input && hotkeys_check_per_sec > 0) {
+
+		/* sanitise to something sane */
+		if (hotkeys_check_per_sec > 10)
+			hotkeys_check_per_sec = 10;
+		printk(KERN_INFO "ktoshkeyd checks per second : %d\n", hotkeys_check_per_sec);
+
+		toshiba_input_polldev_init ();
+		/* just abort */
+		if (!toshiba_poll_dev) {
+			printk(KERN_ERR "could not allocate input device\n");
+			toshiba_acpi_exit();
+		}
+	}
 
 	return (ACPI_SUCCESS(status)) ? 0 : -ENODEV;
 }
diff --git a/drivers/char/ChangeLog b/drivers/char/ChangeLog
diff --git a/drivers/net/LICENSE.SRC b/drivers/net/LICENSE.SRC

--=-Jkj4oVQhIgPTEeHC2aZh--

