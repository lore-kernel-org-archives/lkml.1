Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYG0SRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYG0SRr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 14:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758945AbYG0SRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 14:17:36 -0400
Received: from usul.saidi.cx ([204.11.33.34]:53906 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758944AbYG0SRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 14:17:35 -0400
Message-ID: <488CBBAB.6010508@overt.org>
Date: Sun, 27 Jul 2008 11:17:15 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling through
 rfkill
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's been a patch floating around for toshiba_acpi that exports an ad-hoc
/proc interface to toggle the bluetooth adapter in a large number of Toshiba
laptops. I'm not sure if it's still relevant for the latest models, but it is
still required for older models such as my Tecra M3.

This change pulls in the low level Toshiba-specific code from the old patch and
sets up an rfkill device and a polled input device to track the state of the
hardware kill-switch.

Signed-off-by: Philip Langdale <philipl@overt.org>
---
  Kconfig        |    1
  toshiba_acpi.c |  332 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
  2 files changed, 325 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index c52fca8..bf1ae18 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -262,6 +262,7 @@ config ACPI_ASUS
  config ACPI_TOSHIBA
  	tristate "Toshiba Laptop Extras"
  	depends on X86
+	select INPUT_POLLDEV
  	select BACKLIGHT_CLASS_DEVICE
  	---help---
  	  This driver adds support for access to certain system settings
diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 0a43c8e..9f747d7 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -3,6 +3,7 @@
   *
   *
   *  Copyright (C) 2002-2004 John Belmonte
+ *  Copyright (C) 2008 Philip Langdale
   *
   *  This program is free software; you can redistribute it and/or modify
   *  it under the terms of the GNU General Public License as published by
@@ -33,7 +34,7 @@
   *
   */

-#define TOSHIBA_ACPI_VERSION	"0.18"
+#define TOSHIBA_ACPI_VERSION	"0.19"
  #define PROC_INTERFACE_VERSION	1

  #include <linux/kernel.h>
@@ -42,6 +43,9 @@
  #include <linux/types.h>
  #include <linux/proc_fs.h>
  #include <linux/backlight.h>
+#include <linux/platform_device.h>
+#include <linux/rfkill.h>
+#include <linux/input-polldev.h>

  #include <asm/uaccess.h>

@@ -62,6 +66,10 @@ MODULE_LICENSE("GPL");
  #define METHOD_HCI_2		"\\_SB_.VALZ.GHCI"
  #define METHOD_VIDEO_OUT	"\\_SB_.VALX.DSSX"

+/* Toshiba ACPI Bluetooth object */
+#define BT_ACPI_OBJECT			"\\_SB_.BT"
+#define BT_ACPI_SOFT_UNBLOCKED_EVENT	0x90
+
  /* Toshiba HCI interface definitions
   *
   * HCI is Toshiba's "Hardware Control Interface" which is supposed to
@@ -90,6 +98,7 @@ MODULE_LICENSE("GPL");
  #define HCI_VIDEO_OUT			0x001c
  #define HCI_HOTKEY_EVENT		0x001e
  #define HCI_LCD_BRIGHTNESS		0x002a
+#define HCI_WIRELESS			0x0056

  /* field definitions */
  #define HCI_LCD_BRIGHTNESS_BITS		3
@@ -98,9 +107,14 @@ MODULE_LICENSE("GPL");
  #define HCI_VIDEO_OUT_LCD		0x1
  #define HCI_VIDEO_OUT_CRT		0x2
  #define HCI_VIDEO_OUT_TV		0x4
+#define HCI_WIRELESS_KILL_SWITCH	0x01
+#define HCI_WIRELESS_BT_PRESENT		0x0f
+#define HCI_WIRELESS_BT_ATTACH		0x40
+#define HCI_WIRELESS_BT_POWER		0x80

  static const struct acpi_device_id toshiba_device_ids[] = {
  	{"TOS6200", 0},
+	{"TOS6208", 0},
  	{"TOS1900", 0},
  	{"", 0},
  };
@@ -193,7 +207,7 @@ static acpi_status hci_raw(const u32 in[HCI_WORDS], u32 out[HCI_WORDS])
  	return status;
  }

-/* common hci tasks (get or set one value)
+/* common hci tasks (get or set one or two value)
   *
   * In addition to the ACPI status, the HCI system returns a result which
   * may be useful (such as "not supported").
@@ -218,6 +232,191 @@ static acpi_status hci_read1(u32 reg, u32 * out1, u32 * result)
  	return status;
  }

+static acpi_status hci_write2(u32 reg, u32 in1, u32 in2, u32* result)
+{
+        u32 in[HCI_WORDS] = { HCI_SET, reg, in1, in2, 0, 0 };
+        u32 out[HCI_WORDS];
+        acpi_status status = hci_raw(in, out);
+        *result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+        return status;
+}
+
+static acpi_status hci_read2(u32 reg, u32* out1, u32* out2, u32* result)
+{
+        u32 in[HCI_WORDS] = { HCI_GET, reg, *out1, *out2, 0, 0 };
+        u32 out[HCI_WORDS];
+        acpi_status status = hci_raw(in, out);
+        *out1 = out[2];
+        *out2 = out[3];
+        *result = (status == AE_OK) ? out[0] : HCI_FAILURE;
+        return status;
+}
+
+struct toshiba_acpi_dev {
+	struct platform_device *p_dev;
+	struct rfkill *rfk_dev;
+	struct input_polled_dev *poll_dev;
+
+	const char *bt_name;
+	acpi_handle bt_handle;
+	bool ignore_next_bt_event;
+
+	bool last_rfk_state;
+
+	struct mutex mutex;
+};
+
+static struct toshiba_acpi_dev toshiba_acpi = {
+	.bt_name = "Toshiba Bluetooth",
+	.ignore_next_bt_event = FALSE,
+	.last_rfk_state = FALSE,
+};
+
+/* Bluetooth rfkill handlers */
+
+static u32 hci_get_bt_present(bool *present)
+{
+	u32 hci_result;
+	u32 value, value2;
+	value = 0;
+	value2 = 0;
+	hci_read2(HCI_WIRELESS, &value, &value2, &hci_result);
+	if (hci_result == HCI_SUCCESS) {
+		*present = (value & HCI_WIRELESS_BT_PRESENT) ? TRUE : FALSE;
+	}
+	return hci_result;
+}
+
+static u32 hci_get_bt_on(bool *on)
+{
+	u32 hci_result;
+	u32 value, value2;
+	value = 0;
+	value2 = 0x0001;
+	hci_read2(HCI_WIRELESS, &value, &value2, &hci_result);
+	if (hci_result == HCI_SUCCESS) {
+		*on = (value & HCI_WIRELESS_BT_POWER) &&
+		      (value & HCI_WIRELESS_BT_ATTACH);
+	}
+	return hci_result;
+}
+
+static u32 hci_get_radio_state(bool *radio_state)
+{
+	u32 hci_result;
+	u32 value, value2;
+
+	value = 0;
+	value2 = 0x0001;
+	hci_read2(HCI_WIRELESS, &value, &value2, &hci_result);
+
+	*radio_state = value & HCI_WIRELESS_KILL_SWITCH;
+	return hci_result;
+}
+
+static int bt_rfkill_toggle_radio(void *data, enum rfkill_state state)
+{
+	u32 result1, result2;
+	u32 value;
+
+	struct toshiba_acpi_dev *dev = data;
+
+	value = state == RFKILL_STATE_UNBLOCKED;
+
+	if (state == RFKILL_STATE_SOFT_BLOCKED) {
+		/*
+		 * The ACPI event is emitted on every transition to
+		 * the SOFT_BLOCKED state. We want to respond to
+		 * it by turning the bluetooth device on when going
+		 * from HARD_BLOCKED, but we certainly don't want
+		 * to when going from UNBLOCKED! So we have to explictly
+		 * ignore the next event in that case.
+		 */
+		dev->ignore_next_bt_event = TRUE;
+	}
+
+	mutex_lock(&dev->mutex);
+	hci_write2(HCI_WIRELESS, value, HCI_WIRELESS_BT_POWER, &result1);
+	hci_write2(HCI_WIRELESS, value, HCI_WIRELESS_BT_ATTACH, &result2);
+	mutex_unlock(&dev->mutex);
+
+	if (result1 != HCI_SUCCESS || result2 != HCI_SUCCESS) {
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int bt_rfkill_get_state(void *data, enum rfkill_state *state)
+{
+	u32 hci_result;
+	bool radio_on;
+	bool bt_on;
+
+	hci_result = hci_get_bt_on(&bt_on);
+	if (hci_result != HCI_SUCCESS) {
+		return -EFAULT;
+	}
+
+	hci_result = hci_get_radio_state(&radio_on);
+	if (hci_result != HCI_SUCCESS) {
+		return -EFAULT;
+	}
+
+	if (bt_on) {
+		*state = RFKILL_STATE_UNBLOCKED;
+	} else if (radio_on) {
+		*state = RFKILL_STATE_SOFT_BLOCKED;
+	} else {
+		*state = RFKILL_STATE_HARD_BLOCKED;
+	}
+
+	return 0;
+}
+
+static void bt_acpi_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct toshiba_acpi_dev *dev = data;
+
+	switch (event) {
+	case BT_ACPI_SOFT_UNBLOCKED_EVENT:
+		if (!dev->ignore_next_bt_event) {
+			bt_rfkill_toggle_radio(data, RFKILL_STATE_UNBLOCKED);
+		} else {
+			dev->ignore_next_bt_event = FALSE;
+		}
+		break;
+	default:
+		printk(MY_NOTICE "Unknown event notified on BT object\n");
+		break;
+	}
+}
+
+static void bt_poll_rfkill(struct input_polled_dev *poll_dev)
+{
+	bool state_changed;
+	bool new_rfk_state;
+	bool value;
+	u32 hci_result;
+
+	struct toshiba_acpi_dev *dev = poll_dev->private;
+
+	hci_result = hci_get_radio_state(&value);
+	if (hci_result != HCI_SUCCESS) {
+		return; /* Can't do anything useful */
+	}
+	new_rfk_state = !value;
+
+	mutex_lock(&dev->mutex);
+	state_changed = new_rfk_state != dev->last_rfk_state;
+	dev->last_rfk_state = new_rfk_state;
+	mutex_unlock(&dev->mutex);
+
+	if (unlikely(state_changed)) {
+		input_report_switch(poll_dev->input, SW_RFKILL_ALL, new_rfk_state);
+	}
+}
+
  static struct proc_dir_entry *toshiba_proc_dir /*= 0*/ ;
  static struct backlight_device *toshiba_backlight_device;
  static int force_fan;
@@ -547,6 +746,22 @@ static struct backlight_ops toshiba_backlight_data = {

  static void toshiba_acpi_exit(void)
  {
+	if (toshiba_acpi.poll_dev) {
+		input_unregister_polled_device(toshiba_acpi.poll_dev);
+		input_free_polled_device(toshiba_acpi.poll_dev);
+	}
+
+	if (toshiba_acpi.bt_handle) {
+		acpi_remove_notify_handler(toshiba_acpi.bt_handle,
+					   ACPI_ALL_NOTIFY,
+					   bt_acpi_notify);
+	}
+
+	if (toshiba_acpi.rfk_dev) {
+		rfkill_unregister(toshiba_acpi.rfk_dev);
+		rfkill_free(toshiba_acpi.rfk_dev);
+	}
+
  	if (toshiba_backlight_device)
  		backlight_device_unregister(toshiba_backlight_device);

@@ -555,6 +770,8 @@ static void toshiba_acpi_exit(void)
  	if (toshiba_proc_dir)
  		remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);

+	platform_device_unregister(toshiba_acpi.p_dev);
+
  	return;
  }

@@ -562,6 +779,10 @@ static int __init toshiba_acpi_init(void)
  {
  	acpi_status status = AE_OK;
  	u32 hci_result;
+	bool bt_present;
+	bool bt_on;
+	bool radio_on;
+	int ret = 0;

  	if (acpi_disabled)
  		return -ENODEV;
@@ -578,6 +799,18 @@ static int __init toshiba_acpi_init(void)
  	       TOSHIBA_ACPI_VERSION);
  	printk(MY_INFO "    HCI method: %s\n", method_hci);

+	mutex_init(&toshiba_acpi.mutex);
+
+	toshiba_acpi.p_dev = platform_device_register_simple("toshiba_acpi",
+							      -1, NULL, 0);
+	if (IS_ERR(toshiba_acpi.p_dev)) {
+		ret = PTR_ERR(toshiba_acpi.p_dev);
+		printk(MY_ERR "unable to register platform device\n");
+		toshiba_acpi.p_dev= NULL;
+		toshiba_acpi_exit();
+		return ret;
+	}
+
  	force_fan = 0;
  	key_event_valid = 0;

@@ -586,19 +819,23 @@ static int __init toshiba_acpi_init(void)

  	toshiba_proc_dir = proc_mkdir(PROC_TOSHIBA, acpi_root_dir);
  	if (!toshiba_proc_dir) {
-		status = AE_ERROR;
+		toshiba_acpi_exit();
+		return -ENODEV;
  	} else {
  		toshiba_proc_dir->owner = THIS_MODULE;
  		status = add_device();
-		if (ACPI_FAILURE(status))
-			remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);
+		if (ACPI_FAILURE(status)) {
+			toshiba_acpi_exit();
+			return -ENODEV;
+		}
  	}

-	toshiba_backlight_device = backlight_device_register("toshiba",NULL,
+	toshiba_backlight_device = backlight_device_register("toshiba",
+						&toshiba_acpi.p_dev->dev,
  						NULL,
  						&toshiba_backlight_data);
          if (IS_ERR(toshiba_backlight_device)) {
-		int ret = PTR_ERR(toshiba_backlight_device);
+		ret = PTR_ERR(toshiba_backlight_device);

  		printk(KERN_ERR "Could not register toshiba backlight device\n");
  		toshiba_backlight_device = NULL;
@@ -607,7 +844,86 @@ static int __init toshiba_acpi_init(void)
  	}
          toshiba_backlight_device->props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;

-	return (ACPI_SUCCESS(status)) ? 0 : -ENODEV;
+	/* Register rfkill switch for Bluetooth */
+	if (hci_get_bt_present(&bt_present) == HCI_SUCCESS && bt_present) {
+		toshiba_acpi.rfk_dev = rfkill_allocate(&toshiba_acpi.p_dev->dev,
+							RFKILL_TYPE_BLUETOOTH);
+		if (!toshiba_acpi.rfk_dev) {
+			printk(MY_ERR "unable to allocate rfkill device\n");
+			toshiba_acpi_exit();
+			return -ENOMEM;
+		}
+
+		toshiba_acpi.rfk_dev->name = toshiba_acpi.bt_name;
+		toshiba_acpi.rfk_dev->state = RFKILL_STATE_OFF;
+		toshiba_acpi.rfk_dev->toggle_radio = bt_rfkill_toggle_radio;
+		toshiba_acpi.rfk_dev->get_state = bt_rfkill_get_state;
+		toshiba_acpi.rfk_dev->user_claim_unsupported = 1;
+		toshiba_acpi.rfk_dev->data = &toshiba_acpi;
+		toshiba_acpi.rfk_dev->dev.class->suspend = NULL;
+		toshiba_acpi.rfk_dev->dev.class->resume = NULL;
+
+		ret = rfkill_register(toshiba_acpi.rfk_dev);
+		if (ret) {
+			printk(MY_ERR "unable to register rfkill device\n");
+			toshiba_acpi_exit();
+			return -ENOMEM;
+		}
+
+		if (hci_get_bt_on(&bt_on) == HCI_SUCCESS && bt_on) {
+			toshiba_acpi.rfk_dev->state = RFKILL_STATE_UNBLOCKED;
+		} else if (hci_get_radio_state(&radio_on) == HCI_SUCCESS && radio_on) {
+			toshiba_acpi.rfk_dev->state = RFKILL_STATE_HARD_BLOCKED;
+		} else {
+			toshiba_acpi.rfk_dev->state = RFKILL_STATE_SOFT_BLOCKED;
+		}
+
+		/* Register for acpi events on BT ACPI object. */
+		status = acpi_get_handle(NULL, BT_ACPI_OBJECT, &toshiba_acpi.bt_handle);
+		if (ACPI_FAILURE(status)) {
+			printk(MY_ERR "unable to find ACPI Bluetooth object\n");
+			toshiba_acpi.bt_handle = NULL;
+			toshiba_acpi_exit();
+			return -ENODEV;
+		}
+		status = acpi_install_notify_handler(toshiba_acpi.bt_handle,
+						     ACPI_ALL_NOTIFY,
+						     bt_acpi_notify,
+						     &toshiba_acpi);
+		if (ACPI_FAILURE(status)) {
+			printk(MY_ERR "unable to register for events "
+				      "on ACPI Bluetooth object\n");
+			toshiba_acpi.bt_handle = NULL;
+			toshiba_acpi_exit();
+			return -ENODEV;
+		}
+	}
+
+	/* Register input device for kill switch */
+	toshiba_acpi.poll_dev = input_allocate_polled_device();
+	if (!toshiba_acpi.poll_dev) {
+		printk(MY_ERR "unable to allocate kill-switch input device\n");
+		toshiba_acpi_exit();
+		return -ENOMEM;
+	}
+	toshiba_acpi.poll_dev->private = &toshiba_acpi;
+	toshiba_acpi.poll_dev->poll = bt_poll_rfkill;
+	toshiba_acpi.poll_dev->poll_interval = 1000; /* msecs */
+
+	toshiba_acpi.poll_dev->input->name = toshiba_acpi.bt_name;
+	toshiba_acpi.poll_dev->input->id.bustype = BUS_HOST;
+	toshiba_acpi.poll_dev->input->id.vendor = 0x0930; /* Toshiba USB Vendor ID */
+	toshiba_acpi.poll_dev->input->evbit[0] = BIT(EV_SW);
+	set_bit(SW_RFKILL_ALL, toshiba_acpi.poll_dev->input->keybit);
+
+	ret = input_register_polled_device(toshiba_acpi.poll_dev);
+	if (ret) {
+		printk(MY_ERR "unable to register kill-switch input device\n");
+		toshiba_acpi_exit();
+		return ret;
+	}
+
+	return 0;
  }

  module_init(toshiba_acpi_init);
