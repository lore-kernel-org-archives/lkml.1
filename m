Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbXEaQAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbXEaQAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXEaQA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:00:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:54531 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbXEaQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:00:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=eN4QWwyViq/8+4izgSqbxizVk+EvCcnncx3JurAMTSqTKJ9ZRpfH4LFVmiCaSt3wnY9FTgtjfWAY3gKT1vxz7Wn/nu6Yf8OisLg7n1Qt9PEIblJJ61i8RVjoXp1jBmaGDQcQudl5/XOYCF1AEMVb0ol/9oa/ZSqUmwSChrWq2qo=
Subject: Re: Add INPUT support to toshiba_acpi
From: Richard Hughes <hughsient@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <1180619002.2693.35.camel@localhost.localdomain>
References: <1180614979.2693.26.camel@localhost.localdomain>
	 <1180615994.3030.166.camel@cookie.hadess.net>
	 <1180619002.2693.35.camel@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-iWd3CNRZWogU02e6x+Xv"
Date: Thu, 31 May 2007 16:46:56 +0100
Message-Id: <1180626416.3469.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iWd3CNRZWogU02e6x+Xv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-05-31 at 14:44 +0100, Richard Hughes wrote:
> Nope, impossible AFAICS. The hardware is just broken. Windows XP has an
> toshiba supplied daemon that polls, so I think we have to just bite the
> bullet.

... adding in reply in different thread...

On Thu, 2007-05-31 at 10:37 -0400, Dmitry Torokhov wrote:
> Please use input-polldev to set up polled devices. It
> will create work queue for you and will make sure that polling is
> stopped when device is closed. 

Okay, I had never heard of this. I've done the suggested changes in the
attached patch. Please can you have a look and make sure I'm being sane.

> Also I don't think you want to use
> KEY_BREAK. What is the expected function of that key?

It's a "lock" key, I really want KEY_LOCK added to input.h, but that
might prove difficult. For now I've used KEY_CLEAR, yell if you think
there's a better one to substitute or if you guys want me to add get a
constant added to input.h.

Thanks for the review.

Richard.


--=-iWd3CNRZWogU02e6x+Xv
Content-Disposition: attachment; filename=toshiba_acpi_add_buttons_04.patch
Content-Type: text/x-patch; name=toshiba_acpi_add_buttons_04.patch; charset=UTF-8
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
index 3906d47..2b1a3d9 100644
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
+#define HCI_HKEY_BREAK			0x013b
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
@@ -443,27 +460,33 @@ static char *read_keys(char *p)
 	u32 hci_result;
 	u32 value;
 
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
+	if (!hotkeys_over_input) {
+		if (!key_event_valid) {
+			hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+			if (hci_result == HCI_SUCCESS) {
+				key_event_valid = 1;
+				last_key_event = value;
+			} else if (hci_result == HCI_EMPTY) {
+				/* better luck next time */
+			} else if (hci_result == HCI_NOT_SUPPORTED) {
+				/* This is a workaround for an unresolved issue on
+				 * some machines where system events sporadically
+				 * become disabled. */
+				hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+				printk(MY_NOTICE "Re-enabled hotkeys\n");
+			} else {
+				printk(MY_ERR "Error reading hotkey status\n");
+				goto end;
+			}
 		}
+	} else {
+		key_event_valid = 0;
+		last_key_event = 0;
 	}
 
 	p += sprintf(p, "hotkey_ready:            %d\n", key_event_valid);
 	p += sprintf(p, "hotkey:                  0x%04x\n", last_key_event);
+	p += sprintf(p, "hotkeys_via_input:       %d\n", hotkeys_over_input);
 
       end:
 	return p;
@@ -534,15 +557,127 @@ static acpi_status __exit remove_device(void)
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
+	case HCI_HKEY_BREAK:
+		keycode = KEY_BREAK;
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
+static void toshiba_keys_clear(void)
+{
+	int dropped = 0;
+	int clear_queue = 0;
+	u32 hci_result, value;
+
+	do {
+		/* We don't want to get stuck here; older toshibas such as the
+		 * A60 may load and then return junk during the hci_read */
+		if (clear_queue++ > 16)
+			break;
+
+		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+		if (hci_result == HCI_SUCCESS) {
+			dropped++;
+		} else if (hci_result == HCI_EMPTY) {
+			/* better luck next time */
+		} else if (hci_result == HCI_NOT_SUPPORTED) {
+			/* This is a workaround for an unresolved issue on
+			 * some machines where system events sporadically
+			 * become disabled. */
+			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+			printk(MY_NOTICE "Re-enabled hotkeys\n");
+		}
+	} while (hci_result != HCI_EMPTY);
+
+	printk(MY_INFO "Dropped %d keys from the queue on startup\n", dropped);
+}
+
+static void handle_buttons(struct input_polled_dev *dev)
+{
+	u32 hci_result, value;
+	struct input_dev *input = dev->input;
+
+	do {
+		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+		if (hci_result == HCI_SUCCESS) {
+			/* we got a button event */
+			toshiba_deliver_button_event(input, value);
+		} else if (hci_result == HCI_EMPTY) {
+			/* better luck next time */
+		} else if (hci_result == HCI_NOT_SUPPORTED) {
+			/* This is a workaround for an
+			 * unresolved issue on some machines
+			 * where system events sporadically
+			 * become disabled. */
+			hci_write1(HCI_SYSTEM_EVENT, 1, &hci_result);
+			printk(MY_NOTICE "Re-enabled hotkeys\n");
+		}
+	} while (hci_result == HCI_SUCCESS);
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
@@ -551,6 +686,49 @@ static void __exit toshiba_acpi_exit(void)
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
@@ -590,12 +768,28 @@ static int __init toshiba_acpi_init(void)
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

--=-iWd3CNRZWogU02e6x+Xv--

