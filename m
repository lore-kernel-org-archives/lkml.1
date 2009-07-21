Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbZGULOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbZGULOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZGULOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:14:09 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:25437 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZGULOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=oEN8DWm4kZtwwSHd6LgsatHCjxGEksTsYNdffjh8BFXDYRYPAliOn75kV+Lffdp9Ae
         yi/ODWE5H42WNszEhcIiuC6du/MK57n1wg5yxEU3mZVS0a77lhwryXJepjqnKY7gjti+
         KcW2Qbx4UaN+oUM8DQxA3c5EHxpDMD7gAh3cU=
Message-ID: <4A65A2F9.1060509@tuffmail.co.uk>
Date: Tue, 21 Jul 2009 12:14:01 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] hp-wmi: improve rfkill support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Add support for reading the hardware blocked state.  Previously
   we read a combination of the hardware and software blocked states,
   reporting it as the software blocked state.  This caused some
   confusing behaviour.

2) The software state is persistent, mark it as such.

3) Check rfkill in the resume handler.  Both the hard and soft
   blocked states may change over hibernation.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
---

This code is the combination of two patches tested by Maciej.
There are no changes to that code, only an updated changelog.

I tested wifi on the G7000.  Maciej tested wifi and bluetooth.
wwan is as yet untested; we are assuming the interface follows
the same pattern as wifi and bluetooth.

 drivers/platform/x86/hp-wmi.c |  139 +++++++++++++++++++++++++----------------
 1 files changed, 84 insertions(+), 55 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index ca50856..adb26d3 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -51,6 +51,12 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 #define HPWMI_WIRELESS_QUERY 0x5
 #define HPWMI_HOTKEY_QUERY 0xc
 
+enum hp_wmi_radio {
+	HPWMI_WIFI = 0,
+	HPWMI_BLUETOOTH = 1,
+	HPWMI_WWAN = 2,
+};
+
 static int __init hp_wmi_bios_setup(struct platform_device *device);
 static int __exit hp_wmi_bios_remove(struct platform_device *device);
 static int hp_wmi_resume_handler(struct platform_device *device);
@@ -170,8 +176,8 @@ static int hp_wmi_tablet_state(void)
 
 static int hp_wmi_set_block(void *data, bool blocked)
 {
-	unsigned long b = (unsigned long) data;
-	int query = BIT(b + 8) | ((!blocked) << b);
+	enum hp_wmi_radio r = (enum hp_wmi_radio) data;
+	int query = BIT(r + 8) | ((!blocked) << r);
 
 	return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, query);
 }
@@ -180,31 +186,23 @@ static const struct rfkill_ops hp_wmi_rfkill_ops = {
 	.set_block = hp_wmi_set_block,
 };
 
-static bool hp_wmi_wifi_state(void)
+static bool hp_wmi_get_sw_state(enum hp_wmi_radio r)
 {
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
+	int mask = 0x200 << (r * 8);
 
-	if (wireless & 0x100)
+	if (wireless & mask)
 		return false;
 	else
 		return true;
 }
 
-static bool hp_wmi_bluetooth_state(void)
+static bool hp_wmi_get_hw_state(enum hp_wmi_radio r)
 {
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
+	int mask = 0x800 << (r * 8);
 
-	if (wireless & 0x10000)
-		return false;
-	else
-		return true;
-}
-
-static bool hp_wmi_wwan_state(void)
-{
-	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
-
-	if (wireless & 0x1000000)
+	if (wireless & mask)
 		return false;
 	else
 		return true;
@@ -329,49 +327,55 @@ static void hp_wmi_notify(u32 value, void *context)
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	static struct key_entry *key;
 	union acpi_object *obj;
+	int eventcode;
 
 	wmi_get_event_data(value, &response);
 
 	obj = (union acpi_object *)response.pointer;
 
-	if (obj && obj->type == ACPI_TYPE_BUFFER && obj->buffer.length == 8) {
-		int eventcode = *((u8 *) obj->buffer.pointer);
-		if (eventcode == 0x4)
-			eventcode = hp_wmi_perform_query(HPWMI_HOTKEY_QUERY, 0,
-							 0);
-		key = hp_wmi_get_entry_by_scancode(eventcode);
-		if (key) {
-			switch (key->type) {
-			case KE_KEY:
-				input_report_key(hp_wmi_input_dev,
-						 key->keycode, 1);
-				input_sync(hp_wmi_input_dev);
-				input_report_key(hp_wmi_input_dev,
-						 key->keycode, 0);
-				input_sync(hp_wmi_input_dev);
-				break;
-			}
-		} else if (eventcode == 0x1) {
-			input_report_switch(hp_wmi_input_dev, SW_DOCK,
-					    hp_wmi_dock_state());
-			input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
-					    hp_wmi_tablet_state());
+	if (!obj || obj->type != ACPI_TYPE_BUFFER || obj->buffer.length != 8) {
+		printk(KERN_INFO "HP WMI: Unknown response received\n");
+		return;
+	}
+
+	eventcode = *((u8 *) obj->buffer.pointer);
+	if (eventcode == 0x4)
+		eventcode = hp_wmi_perform_query(HPWMI_HOTKEY_QUERY, 0,
+						0);
+	key = hp_wmi_get_entry_by_scancode(eventcode);
+	if (key) {
+		switch (key->type) {
+		case KE_KEY:
+			input_report_key(hp_wmi_input_dev,
+					 key->keycode, 1);
+			input_sync(hp_wmi_input_dev);
+			input_report_key(hp_wmi_input_dev,
+					 key->keycode, 0);
 			input_sync(hp_wmi_input_dev);
-		} else if (eventcode == 0x5) {
-			if (wifi_rfkill)
-				rfkill_set_sw_state(wifi_rfkill,
-						    hp_wmi_wifi_state());
-			if (bluetooth_rfkill)
-				rfkill_set_sw_state(bluetooth_rfkill,
-						    hp_wmi_bluetooth_state());
-			if (wwan_rfkill)
-				rfkill_set_sw_state(wwan_rfkill,
-						    hp_wmi_wwan_state());
-		} else
-			printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
-			       eventcode);
+			break;
+		}
+	} else if (eventcode == 0x1) {
+		input_report_switch(hp_wmi_input_dev, SW_DOCK,
+				    hp_wmi_dock_state());
+		input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
+				    hp_wmi_tablet_state());
+		input_sync(hp_wmi_input_dev);
+	} else if (eventcode == 0x5) {
+		if (wifi_rfkill)
+			rfkill_set_states(wifi_rfkill,
+					  hp_wmi_get_sw_state(HPWMI_WIFI),
+					  hp_wmi_get_hw_state(HPWMI_WIFI));
+		if (bluetooth_rfkill)
+			rfkill_set_states(bluetooth_rfkill,
+					  hp_wmi_get_sw_state(HPWMI_BLUETOOTH),
+					  hp_wmi_get_hw_state(HPWMI_BLUETOOTH));
+		if (wwan_rfkill)
+			rfkill_set_states(wwan_rfkill,
+					  hp_wmi_get_sw_state(HPWMI_WWAN),
+					  hp_wmi_get_hw_state(HPWMI_WWAN));
 	} else
-		printk(KERN_INFO "HP WMI: Unknown response received\n");
+		printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
+			eventcode);
 }
 
 static int __init hp_wmi_input_setup(void)
@@ -450,7 +454,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 		wifi_rfkill = rfkill_alloc("hp-wifi", &device->dev,
 					   RFKILL_TYPE_WLAN,
 					   &hp_wmi_rfkill_ops,
-					   (void *) 0);
+					   (void *) HPWMI_WIFI);
+		rfkill_init_sw_state(wifi_rfkill,
+				     hp_wmi_get_sw_state(HPWMI_WIFI));
+		rfkill_set_hw_state(wifi_rfkill,
+				    hp_wmi_get_hw_state(HPWMI_WIFI));
 		err = rfkill_register(wifi_rfkill);
 		if (err)
 			goto register_wifi_error;
@@ -460,7 +468,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 		bluetooth_rfkill = rfkill_alloc("hp-bluetooth", &device->dev,
 						RFKILL_TYPE_BLUETOOTH,
 						&hp_wmi_rfkill_ops,
-						(void *) 1);
+						(void *) HPWMI_BLUETOOTH);
+		rfkill_init_sw_state(bluetooth_rfkill,
+				     hp_wmi_get_sw_state(HPWMI_BLUETOOTH));
+		rfkill_set_hw_state(bluetooth_rfkill,
+				    hp_wmi_get_hw_state(HPWMI_BLUETOOTH));
 		err = rfkill_register(bluetooth_rfkill);
 		if (err)
 			goto register_bluetooth_error;
@@ -470,7 +482,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 		wwan_rfkill = rfkill_alloc("hp-wwan", &device->dev,
 					   RFKILL_TYPE_WWAN,
 					   &hp_wmi_rfkill_ops,
-					   (void *) 2);
+					   (void *) HPWMI_WWAN);
+		rfkill_init_sw_state(wwan_rfkill,
+				     hp_wmi_get_sw_state(HPWMI_WWAN));
+		rfkill_set_hw_state(wwan_rfkill,
+				    hp_wmi_get_hw_state(HPWMI_WWAN));
 		err = rfkill_register(wwan_rfkill);
 		if (err)
 			goto register_wwan_err;
@@ -526,6 +542,19 @@ static int hp_wmi_resume_handler(struct platform_device *device)
 			    hp_wmi_tablet_state());
 	input_sync(hp_wmi_input_dev);
 
+	if (wifi_rfkill)
+		rfkill_set_states(wifi_rfkill,
+				  hp_wmi_get_sw_state(HPWMI_WIFI),
+				  hp_wmi_get_hw_state(HPWMI_WIFI));
+	if (bluetooth_rfkill)
+		rfkill_set_states(bluetooth_rfkill,
+				  hp_wmi_get_sw_state(HPWMI_BLUETOOTH),
+				  hp_wmi_get_hw_state(HPWMI_BLUETOOTH));
+	if (wwan_rfkill)
+		rfkill_set_states(wwan_rfkill,
+				  hp_wmi_get_sw_state(HPWMI_WWAN),
+				  hp_wmi_get_hw_state(HPWMI_WWAN));
+
 	return 0;
 }
 
-- 
1.6.3.2

