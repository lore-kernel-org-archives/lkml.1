Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZFAO1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZFAO1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZFAO1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:27:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44421 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbZFAO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:27:12 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] hp-wmi: Add support for reporting tablet state
Date: Mon,  1 Jun 2009 15:25:45 +0100
Message-Id: <1243866345-25507-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HP tablets send a WMI event when a tablet state change occurs, but use the
same method as is used for reporting docking and undocking. The same query
is used to obtain the state of the hardware. Bit 0 indicates the docking
state, while bit 2 indicates the tablet state. This patch breaks these out
and sends separate input events for tablet and dock state changes. An
additional sysfs file is added to report the tablet state.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/hp-wmi.c |   87 ++++++++++++++++++++++++++---------------
 1 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 50d9019..46a7a6e 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -47,7 +47,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 #define HPWMI_DISPLAY_QUERY 0x1
 #define HPWMI_HDDTEMP_QUERY 0x2
 #define HPWMI_ALS_QUERY 0x3
-#define HPWMI_DOCK_QUERY 0x4
+#define HPWMI_HARDWARE_QUERY 0x4
 #define HPWMI_WIRELESS_QUERY 0x5
 #define HPWMI_HOTKEY_QUERY 0xc
 
@@ -75,10 +75,9 @@ struct key_entry {
 	u16 keycode;
 };
 
-enum { KE_KEY, KE_SW, KE_END };
+enum { KE_KEY, KE_END };
 
 static struct key_entry hp_wmi_keymap[] = {
-	{KE_SW, 0x01, SW_DOCK},
 	{KE_KEY, 0x02, KEY_BRIGHTNESSUP},
 	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
 	{KE_KEY, 0x20e6, KEY_PROG1},
@@ -151,7 +150,22 @@ static int hp_wmi_als_state(void)
 
 static int hp_wmi_dock_state(void)
 {
-	return hp_wmi_perform_query(HPWMI_DOCK_QUERY, 0, 0);
+	int ret = hp_wmi_perform_query(HPWMI_HARDWARE_QUERY, 0, 0);
+
+	if (ret < 0)
+		return ret;
+
+	return ret & 0x1;
+}
+
+static int hp_wmi_tablet_state(void)
+{
+	int ret = hp_wmi_perform_query(HPWMI_HARDWARE_QUERY, 0, 0);
+
+	if (ret < 0)
+		return ret;
+
+	return (ret & 0x4) ? 1 : 0;
 }
 
 static int hp_wmi_wifi_set(void *data, enum rfkill_state state)
@@ -244,6 +258,15 @@ static ssize_t show_dock(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%d\n", value);
 }
 
+static ssize_t show_tablet(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	int value = hp_wmi_tablet_state();
+	if (value < 0)
+		return -EINVAL;
+	return sprintf(buf, "%d\n", value);
+}
+
 static ssize_t set_als(struct device *dev, struct device_attribute *attr,
 		       const char *buf, size_t count)
 {
@@ -256,6 +279,7 @@ static DEVICE_ATTR(display, S_IRUGO, show_display, NULL);
 static DEVICE_ATTR(hddtemp, S_IRUGO, show_hddtemp, NULL);
 static DEVICE_ATTR(als, S_IRUGO | S_IWUSR, show_als, set_als);
 static DEVICE_ATTR(dock, S_IRUGO, show_dock, NULL);
+static DEVICE_ATTR(tablet, S_IRUGO, show_tablet, NULL);
 
 static struct key_entry *hp_wmi_get_entry_by_scancode(int code)
 {
@@ -338,13 +362,13 @@ static void hp_wmi_notify(u32 value, void *context)
 						 key->keycode, 0);
 				input_sync(hp_wmi_input_dev);
 				break;
-			case KE_SW:
-				input_report_switch(hp_wmi_input_dev,
-						    key->keycode,
-						    hp_wmi_dock_state());
-				input_sync(hp_wmi_input_dev);
-				break;
 			}
+		} else if (eventcode == 0x1) {
+			input_report_switch(hp_wmi_input_dev, SW_DOCK,
+					    hp_wmi_dock_state());
+			input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
+					    hp_wmi_tablet_state());
+			input_sync(hp_wmi_input_dev);
 		} else if (eventcode == 0x5) {
 			if (wifi_rfkill)
 				rfkill_force_state(wifi_rfkill,
@@ -381,18 +405,19 @@ static int __init hp_wmi_input_setup(void)
 			set_bit(EV_KEY, hp_wmi_input_dev->evbit);
 			set_bit(key->keycode, hp_wmi_input_dev->keybit);
 			break;
-		case KE_SW:
-			set_bit(EV_SW, hp_wmi_input_dev->evbit);
-			set_bit(key->keycode, hp_wmi_input_dev->swbit);
-
-			/* Set initial dock state */
-			input_report_switch(hp_wmi_input_dev, key->keycode,
-					    hp_wmi_dock_state());
-			input_sync(hp_wmi_input_dev);
-			break;
 		}
 	}
 
+	set_bit(EV_SW, hp_wmi_input_dev->evbit);
+	set_bit(SW_DOCK, hp_wmi_input_dev->swbit);
+	set_bit(SW_TABLET_MODE, hp_wmi_input_dev->swbit);
+
+	/* Set initial hardware state */
+	input_report_switch(hp_wmi_input_dev, SW_DOCK, hp_wmi_dock_state());
+	input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
+			    hp_wmi_tablet_state());
+	input_sync(hp_wmi_input_dev);
+
 	err = input_register_device(hp_wmi_input_dev);
 
 	if (err) {
@@ -409,6 +434,7 @@ static void cleanup_sysfs(struct platform_device *device)
 	device_remove_file(&device->dev, &dev_attr_hddtemp);
 	device_remove_file(&device->dev, &dev_attr_als);
 	device_remove_file(&device->dev, &dev_attr_dock);
+	device_remove_file(&device->dev, &dev_attr_tablet);
 }
 
 static int __init hp_wmi_bios_setup(struct platform_device *device)
@@ -428,6 +454,9 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 	err = device_create_file(&device->dev, &dev_attr_dock);
 	if (err)
 		goto add_sysfs_error;
+	err = device_create_file(&device->dev, &dev_attr_tablet);
+	if (err)
+		goto add_sysfs_error;
 
 	if (wireless & 0x1) {
 		wifi_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WLAN);
@@ -491,23 +520,17 @@ static int __exit hp_wmi_bios_remove(struct platform_device *device)
 
 static int hp_wmi_resume_handler(struct platform_device *device)
 {
-	struct key_entry *key;
-
 	/*
-	 * Docking state may have changed while suspended, so trigger
-	 * an input event for the current state. As this is a switch,
+	 * Hardware state may have changed while suspended, so trigger
+	 * input events for the current state. As this is a switch,
 	 * the input layer will only actually pass it on if the state
 	 * changed.
 	 */
-	for (key = hp_wmi_keymap; key->type != KE_END; key++) {
-		switch (key->type) {
-		case KE_SW:
-			input_report_switch(hp_wmi_input_dev, key->keycode,
-					    hp_wmi_dock_state());
-			input_sync(hp_wmi_input_dev);
-			break;
-		}
-	}
+
+	input_report_switch(hp_wmi_input_dev, SW_DOCK, hp_wmi_dock_state());
+	input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
+			    hp_wmi_tablet_state());
+	input_sync(hp_wmi_input_dev);
 
 	return 0;
 }
-- 
1.6.2.2

