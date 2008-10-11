Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbYJKHjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbYJKHjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYJKHhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:14 -0400
Received: from vms172073pub.verizon.net ([206.46.172.73]:32811 "EHLO
	vms172073pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106AbYJKHhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:12 -0400
Date: Sat, 11 Oct 2008 02:36:07 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 47/85] acer-wmi: Add rfkill support for wireless and bluetooth
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Len Brown <len.brown@intel.com>
Message-id: <0606e1abfcb66c3a29722162f5d2c7ad8b638237.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

This patch implements rfkill support for the wireless and bluetooth devices
commonly found on Acer laptops.

For now, we will always poll these devices once a second to guarantee we
can catch state changes. On newer Acer laptops, it may be possible to rely
on WMI events to do this instead, and experimental support for this will be
added in a later patch.

3G has been deliberately left off for now, as we still have no way to
detect it, (nor, AFAIK, has any Linux user tried the code) and on laptops
that don't support 3G, trying to poll for the status will leave the logs
full of ACPI tracebacks.

The old sysfs interface for wireless and bluetooth will be removed in a
later patch.

(Thanks to Henrique de Moraes Holschuh and Dmitry Torokhov for reviewing
this patch).

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/misc/Kconfig    |    1 +
 drivers/misc/acer-wmi.c |  130 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 130 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index a726f3b..6abb959 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -145,6 +145,7 @@ config ACER_WMI
 	depends on NEW_LEDS
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on SERIO_I8042
+	depends on RFKILL
 	select ACPI_WMI
 	---help---
 	  This is a driver for newer Acer (and Wistron) laptops. It adds
diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index d8b0d32..e3e11e8 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -33,6 +33,8 @@
 #include <linux/platform_device.h>
 #include <linux/acpi.h>
 #include <linux/i8042.h>
+#include <linux/rfkill.h>
+#include <linux/workqueue.h>
 #include <linux/debugfs.h>
 
 #include <acpi/acpi_drivers.h>
@@ -157,6 +159,9 @@ struct acer_debug {
 	u32 wmid_devices;
 };
 
+static struct rfkill *wireless_rfkill;
+static struct rfkill *bluetooth_rfkill;
+
 /* Each low-level interface must define at least some of the following */
 struct wmi_interface {
 	/* The WMI device type */
@@ -933,6 +938,125 @@ static void acer_backlight_exit(void)
 }
 
 /*
+ * Rfkill devices
+ */
+static struct workqueue_struct *rfkill_workqueue;
+
+static void acer_rfkill_update(struct work_struct *ignored);
+static DECLARE_DELAYED_WORK(acer_rfkill_work, acer_rfkill_update);
+static void acer_rfkill_update(struct work_struct *ignored)
+{
+	u32 state;
+	acpi_status status;
+
+	status = get_u32(&state, ACER_CAP_WIRELESS);
+	if (ACPI_SUCCESS(status))
+		rfkill_force_state(wireless_rfkill, state ?
+			RFKILL_STATE_UNBLOCKED : RFKILL_STATE_SOFT_BLOCKED);
+
+	if (has_cap(ACER_CAP_BLUETOOTH)) {
+		status = get_u32(&state, ACER_CAP_BLUETOOTH);
+		if (ACPI_SUCCESS(status))
+			rfkill_force_state(bluetooth_rfkill, state ?
+				RFKILL_STATE_UNBLOCKED :
+				RFKILL_STATE_SOFT_BLOCKED);
+	}
+
+	queue_delayed_work(rfkill_workqueue, &acer_rfkill_work,
+		round_jiffies_relative(HZ));
+}
+
+static int acer_rfkill_set(void *data, enum rfkill_state state)
+{
+	acpi_status status;
+	u32 *cap = data;
+	status = set_u32((u32) (state == RFKILL_STATE_UNBLOCKED), *cap);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+	return 0;
+}
+
+static struct rfkill * acer_rfkill_register(struct device *dev,
+enum rfkill_type type, char *name, u32 cap)
+{
+	int err;
+	u32 state;
+	u32 *data;
+	struct rfkill *rfkill_dev;
+
+	rfkill_dev = rfkill_allocate(dev, type);
+	if (!rfkill_dev)
+		return ERR_PTR(-ENOMEM);
+	rfkill_dev->name = name;
+	get_u32(&state, cap);
+	rfkill_dev->state = state ? RFKILL_STATE_UNBLOCKED :
+		RFKILL_STATE_SOFT_BLOCKED;
+	data = kzalloc(sizeof(u32), GFP_KERNEL);
+	if (!data) {
+		rfkill_free(rfkill_dev);
+		return ERR_PTR(-ENOMEM);
+	}
+	*data = cap;
+	rfkill_dev->data = data;
+	rfkill_dev->toggle_radio = acer_rfkill_set;
+	rfkill_dev->user_claim_unsupported = 1;
+
+	err = rfkill_register(rfkill_dev);
+	if (err) {
+		kfree(rfkill_dev->data);
+		rfkill_free(rfkill_dev);
+		return ERR_PTR(err);
+	}
+	return rfkill_dev;
+}
+
+static int acer_rfkill_init(struct device *dev)
+{
+	wireless_rfkill = acer_rfkill_register(dev, RFKILL_TYPE_WLAN,
+		"acer-wireless", ACER_CAP_WIRELESS);
+	if (IS_ERR(wireless_rfkill))
+		return PTR_ERR(wireless_rfkill);
+
+	if (has_cap(ACER_CAP_BLUETOOTH)) {
+		bluetooth_rfkill = acer_rfkill_register(dev,
+			RFKILL_TYPE_BLUETOOTH, "acer-bluetooth",
+			ACER_CAP_BLUETOOTH);
+		if (IS_ERR(bluetooth_rfkill)) {
+			kfree(wireless_rfkill->data);
+			rfkill_unregister(wireless_rfkill);
+			return PTR_ERR(bluetooth_rfkill);
+		}
+	}
+
+	rfkill_workqueue = create_singlethread_workqueue("rfkill_workqueue");
+	if (!rfkill_workqueue) {
+		if (has_cap(ACER_CAP_BLUETOOTH)) {
+			kfree(bluetooth_rfkill->data);
+			rfkill_unregister(bluetooth_rfkill);
+		}
+		kfree(wireless_rfkill->data);
+		rfkill_unregister(wireless_rfkill);
+		return -ENOMEM;
+	}
+	queue_delayed_work(rfkill_workqueue, &acer_rfkill_work, HZ);
+
+	return 0;
+}
+
+static void acer_rfkill_exit(void)
+{
+	cancel_delayed_work_sync(&acer_rfkill_work);
+	destroy_workqueue(rfkill_workqueue);
+	kfree(wireless_rfkill->data);
+	rfkill_unregister(wireless_rfkill);
+	if (has_cap(ACER_CAP_BLUETOOTH)) {
+		kfree(wireless_rfkill->data);
+		rfkill_unregister(bluetooth_rfkill);
+	}
+	return;
+}
+
+/*
  * Read/ write bool sysfs macro
  */
 #define show_set_bool(value, cap) \
@@ -1026,7 +1150,9 @@ static int __devinit acer_platform_probe(struct platform_device *device)
 			goto error_brightness;
 	}
 
-	return 0;
+	err = acer_rfkill_init(&device->dev);
+
+	return err;
 
 error_brightness:
 	acer_led_exit();
@@ -1040,6 +1166,8 @@ static int acer_platform_remove(struct platform_device *device)
 		acer_led_exit();
 	if (has_cap(ACER_CAP_BRIGHTNESS))
 		acer_backlight_exit();
+
+	acer_rfkill_exit();
 	return 0;
 }
 
-- 
1.5.5.1

