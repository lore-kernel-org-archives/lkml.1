Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbXEaNop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbXEaNop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXEaNog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:44:36 -0400
Received: from ag-out-0708.google.com ([72.14.246.244]:48097 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbXEaNof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=OdPCb8L/DoLkuwdXoxtaMdfiCxq9/aWndGK72DmXrRwdcZRvgFhEYlC9tRQDIxdFvVdEAntNIDtH5VDlHR4K8IK53R8pwzRVwRgvXyUJAOSxOtf/leDviYwqrne5/5hVovi/+TvGuGJ1F5eY/e5BB+UGchokABXPi1jkO3SB/pM=
Subject: Re: Add INPUT support to toshiba_acpi
From: Richard Hughes <hughsient@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: John Belmonte <john@neggie.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <1180615994.3030.166.camel@cookie.hadess.net>
References: <1180614979.2693.26.camel@localhost.localdomain>
	 <1180615994.3030.166.camel@cookie.hadess.net>
Content-Type: multipart/mixed; boundary="=-EnXmTnR1DTz6yy1+8kSx"
Date: Thu, 31 May 2007 14:43:22 +0100
Message-Id: <1180619002.2693.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EnXmTnR1DTz6yy1+8kSx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-05-31 at 13:53 +0100, Bastien Nocera wrote:
> On Thu, 2007-05-31 at 13:36 +0100, Richard Hughes wrote:
> > Attached patch adds a kernel thread to do polling on Toshiba hardware.
> > 
> > Toshiba hardware is a little oddball, and does not provide ACPI events
> > on some key presses, typically Fn hotkey buttons. The key interface is
> > now polled, and events now matched to a list of toshiba specific
> > scancodes, and are squirted to userspace using the INPUT subsystem.
> > 
> > This means that toshiba laptops buttons "just work" without any
> > userspace daemon (using uinput) such as fnfx or bodges such as using a
> > userspace hal addon. Doing the polling in kernel is more efficient, and
> > makes stuff just work out of the box. You can assign the keys using
> > standard X keymaps, or using tools such as gnome-keybinding-properties.
> > 
> > This is similar to other patches sent for the thinkpad_acpi driver, and
> > is part of the "Unf*ck my keyboard" initiative to make multimedia keys
> > just work.
> > 
> > Changes from the first patch involve switching to a workqueue for the
> > polling, not breaking the spaces in "hotkeys_via_input" and also masking
> > out the fn key button up.
> 
> A couple of things:
> - use a switch statement in toshiba_deliver_button_event(), would look a
> bit cleaner.

Agree, done.

> - make the magic number #defines

Agree, done.

> - not sure if it's possible, but you should disable the workqueue
> altogether if nothing has the input device opened.

Do we get an event when the [input]->users value changes? If not, we
could do 1Hz (users > 0) checking when the input device is unclaimed,
and then switch to 4Hz polling when the input device is open.

> Hopefully we'll find a way to receive an interrupt, or some kind of
> event when the keys are pressed in the future, and completely avoid the
> polling. In the meantime, it should be minimised.

Nope, impossible AFAICS. The hardware is just broken. Windows XP has an
toshiba supplied daemon that polls, so I think we have to just bite the
bullet.

New patch attached.

Richard.


--=-EnXmTnR1DTz6yy1+8kSx
Content-Disposition: attachment; filename=toshiba_acpi_add_buttons_03.patch
Content-Type: text/x-patch; name=toshiba_acpi_add_buttons_03.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 3906d47..cf4ab76 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -27,13 +27,13 @@
  *		engineering the Windows drivers
  *	Yasushi Nagato - changes for linux kernel 2.4 -> 2.5
  *	Rob Miller - TV out and hotkeys help
- *
+ *	Richard Hughes - emit INPUT events, based on a patch from Daniel Silverstone
  *
  *  TODO
  *
  */
 
-#define TOSHIBA_ACPI_VERSION	"0.18"
+#define TOSHIBA_ACPI_VERSION	"0.19"
 #define PROC_INTERFACE_VERSION	1
 
 #include <linux/kernel.h>
@@ -42,6 +42,8 @@
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 #include <linux/backlight.h>
+#include <linux/input.h>
+#include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
 
@@ -99,6 +101,16 @@ MODULE_LICENSE("GPL");
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
 
@@ -213,9 +225,15 @@ static acpi_status hci_read1(u32 reg, u32 * out1, u32 * result)
 
 static struct proc_dir_entry *toshiba_proc_dir /*= 0*/ ;
 static struct backlight_device *toshiba_backlight_device;
+static struct input_dev *toshiba_input;
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
@@ -443,27 +461,33 @@ static char *read_keys(char *p)
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
@@ -534,15 +558,133 @@ static acpi_status __exit remove_device(void)
 }
 
 static struct backlight_ops toshiba_backlight_data = {
-        .get_brightness = get_lcd,
-        .update_status  = set_lcd_status,
+	.get_brightness = get_lcd,
+	.update_status  = set_lcd_status,
 };
 
+static void toshiba_keys_fire(struct work_struct *work);
+static struct workqueue_struct *toshiba_keys_wq;
+static DECLARE_DELAYED_WORK(toshiba_keys_work, toshiba_keys_fire);
+
+static void toshiba_deliver_button_event(u32 value)
+{
+	int keycode = KEY_UNKNOWN;
+	int key_down = 1;
+
+	if (!toshiba_input)
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
+		input_report_key(toshiba_input, keycode, key_down);
+		input_sync(toshiba_input);
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
+static void toshiba_keys_fire(struct work_struct *work)
+{
+	u32 hci_result, value;
+
+	do {
+		hci_read1(HCI_SYSTEM_EVENT, &value, &hci_result);
+		if (hci_result == HCI_SUCCESS) {
+			/* we got a button event */
+			toshiba_deliver_button_event(value);
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
+
+	/* reschedule another check */
+	queue_delayed_work(toshiba_keys_wq, &toshiba_keys_work, HZ / hotkeys_check_per_sec);
+}
+
 static void __exit toshiba_acpi_exit(void)
 {
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
 
+	if (toshiba_keys_wq) {
+		cancel_delayed_work(&toshiba_keys_work);
+		destroy_workqueue(toshiba_keys_wq);
+	}
+
 	remove_device();
 
 	if (toshiba_proc_dir)
@@ -551,6 +693,45 @@ static void __exit toshiba_acpi_exit(void)
 	return;
 }
 
+static int __init toshiba_input_init(void)
+{
+	int error;
+
+	/* use INPUT for key events */
+	toshiba_input = input_allocate_device();
+	if (!toshiba_input) {
+		error = -ENOMEM;
+		goto err_no_mem;
+	}
+
+	toshiba_keys_clear();
+
+	/* create one 'keyboard' virtual input device for all the acpi events */
+	toshiba_input->name = "Toshiba Extra Buttons";
+	toshiba_input->phys = "toshiba/input0";
+	toshiba_input->id.bustype = BUS_HOST;
+	toshiba_input->id.product = 0x0001;
+	toshiba_input->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_MUTE, toshiba_input->keybit);
+	set_bit(KEY_BREAK, toshiba_input->keybit); /* probably should be KEY_LOCK */
+	set_bit(KEY_SEARCH, toshiba_input->keybit);
+	set_bit(KEY_SUSPEND, toshiba_input->keybit);
+	set_bit(KEY_SLEEP, toshiba_input->keybit);
+	set_bit(KEY_BRIGHTNESSDOWN, toshiba_input->keybit);
+	set_bit(KEY_BRIGHTNESSUP, toshiba_input->keybit);
+	set_bit(KEY_WLAN, toshiba_input->keybit);
+
+	error = input_register_device(toshiba_input);
+	if (error)
+		goto err_free_input;
+	return 0;
+
+err_free_input:
+	input_free_device(toshiba_input);
+err_no_mem:
+	return error;
+}
+
 static int __init toshiba_acpi_init(void)
 {
 	acpi_status status = AE_OK;
@@ -590,12 +771,38 @@ static int __init toshiba_acpi_init(void)
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
+		toshiba_input_init ();
+		/* just abort */
+		if (!toshiba_input) {
+			printk(KERN_ERR "could not allocate input device\n");
+			toshiba_acpi_exit();
+		}
+
+		/* setup workqueue */
+		toshiba_keys_wq = create_singlethread_workqueue("ktoshkeyd");
+		if (!toshiba_keys_wq) {
+			printk(KERN_ERR "failed to create workqueue\n");
+			toshiba_acpi_exit();
+		}
+
+		/* sanitise to something sane */
+		if (hotkeys_check_per_sec > 10)
+			hotkeys_check_per_sec = 10;
+		printk(KERN_INFO "ktoshkeyd checks per second : %d\n", hotkeys_check_per_sec);
+
+		/* start polling after delay */
+		queue_delayed_work(toshiba_keys_wq, &toshiba_keys_work, HZ / hotkeys_check_per_sec);
+	}
 
 	return (ACPI_SUCCESS(status)) ? 0 : -ENODEV;
 }

--=-EnXmTnR1DTz6yy1+8kSx--

