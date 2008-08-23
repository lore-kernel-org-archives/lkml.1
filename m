Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYHWIhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYHWIhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 04:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbYHWIhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 04:37:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50616 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYHWIhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 04:37:42 -0400
Date: Sat, 23 Aug 2008 09:37:36 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org
Cc: hmh@hmh.eng.br, IvDoorn@gmail.com
Subject: [PATCH] hp-wmi: Update to match current rfkill semantics
Message-ID: <20080823083735.GA7930@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hp-wmi currently changes the RFKill state by altering the struct members 
rather than using the dedicated interface, meaning that update events 
won't be pushed to userspace. This patch fixes that, along with fixing 
the declared type of the WWAN kill switch. It also ensures that rfkill 
interfaces are only registered for hardware that exists.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

diff --git a/drivers/misc/hp-wmi.c b/drivers/misc/hp-wmi.c
index 1dbcbcb..bc6ccfb 100644
--- a/drivers/misc/hp-wmi.c
+++ b/drivers/misc/hp-wmi.c
@@ -177,9 +177,9 @@ static int hp_wmi_wifi_state(void)
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x100)
-		return 1;
+		return RFKILL_STATE_UNBLOCKED;
 	else
-		return 0;
+		return RFKILL_STATE_SOFT_BLOCKED;
 }
 
 static int hp_wmi_bluetooth_state(void)
@@ -187,9 +187,9 @@ static int hp_wmi_bluetooth_state(void)
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x10000)
-		return 1;
+		return RFKILL_STATE_UNBLOCKED;
 	else
-		return 0;
+		return RFKILL_STATE_SOFT_BLOCKED;
 }
 
 static int hp_wmi_wwan_state(void)
@@ -197,9 +197,9 @@ static int hp_wmi_wwan_state(void)
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	if (wireless & 0x1000000)
-		return 1;
+		return RFKILL_STATE_UNBLOCKED;
 	else
-		return 0;
+		return RFKILL_STATE_SOFT_BLOCKED;
 }
 
 static ssize_t show_display(struct device *dev, struct device_attribute *attr,
@@ -338,12 +338,14 @@ void hp_wmi_notify(u32 value, void *context)
 			}
 		} else if (eventcode == 0x5) {
 			if (wifi_rfkill)
-				wifi_rfkill->state = hp_wmi_wifi_state();
+				rfkill_force_state(wifi_rfkill, 
+						   hp_wmi_wifi_state());
 			if (bluetooth_rfkill)
-				bluetooth_rfkill->state =
-				    hp_wmi_bluetooth_state();
+				rfkill_force_state(bluetooth_rfkill,
+						   hp_wmi_bluetooth_state());
 			if (wwan_rfkill)
-				wwan_rfkill->state = hp_wmi_wwan_state();
+				rfkill_force_state(wwan_rfkill, 
+						   hp_wmi_wwan_state());
 		} else
 			printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
 			       eventcode);
@@ -398,6 +400,7 @@ static void cleanup_sysfs(struct platform_device *device)
 static int __init hp_wmi_bios_setup(struct platform_device *device)
 {
 	int err;
+	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
 	err = device_create_file(&device->dev, &dev_attr_display);
 	if (err)
@@ -412,28 +415,33 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 	if (err)
 		goto add_sysfs_error;
 
-	wifi_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WLAN);
-	wifi_rfkill->name = "hp-wifi";
-	wifi_rfkill->state = hp_wmi_wifi_state();
-	wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
-	wifi_rfkill->user_claim_unsupported = 1;
-
-	bluetooth_rfkill = rfkill_allocate(&device->dev,
-					   RFKILL_TYPE_BLUETOOTH);
-	bluetooth_rfkill->name = "hp-bluetooth";
-	bluetooth_rfkill->state = hp_wmi_bluetooth_state();
-	bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
-	bluetooth_rfkill->user_claim_unsupported = 1;
-
-	wwan_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WIMAX);
-	wwan_rfkill->name = "hp-wwan";
-	wwan_rfkill->state = hp_wmi_wwan_state();
-	wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
-	wwan_rfkill->user_claim_unsupported = 1;
-
-	rfkill_register(wifi_rfkill);
-	rfkill_register(bluetooth_rfkill);
-	rfkill_register(wwan_rfkill);
+	if (wireless & 0x1) {
+		wifi_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WLAN);
+		wifi_rfkill->name = "hp-wifi";
+		wifi_rfkill->state = hp_wmi_wifi_state();
+		wifi_rfkill->toggle_radio = hp_wmi_wifi_set;
+		wifi_rfkill->user_claim_unsupported = 1;
+		rfkill_register(wifi_rfkill);
+	}
+
+	if (wireless & 0x2) {
+		bluetooth_rfkill = rfkill_allocate(&device->dev,
+						   RFKILL_TYPE_BLUETOOTH);
+		bluetooth_rfkill->name = "hp-bluetooth";
+		bluetooth_rfkill->state = hp_wmi_bluetooth_state();
+		bluetooth_rfkill->toggle_radio = hp_wmi_bluetooth_set;
+		bluetooth_rfkill->user_claim_unsupported = 1;
+		rfkill_register(bluetooth_rfkill);
+	}
+
+	if (wireless & 0x4) {
+		wwan_rfkill = rfkill_allocate(&device->dev, RFKILL_TYPE_WWAN);
+		wwan_rfkill->name = "hp-wwan";
+		wwan_rfkill->state = hp_wmi_wwan_state();
+		wwan_rfkill->toggle_radio = hp_wmi_wwan_set;
+		wwan_rfkill->user_claim_unsupported = 1;
+		rfkill_register(wwan_rfkill);
+	}
 
 	return 0;
 add_sysfs_error:
@@ -445,9 +453,12 @@ static int __exit hp_wmi_bios_remove(struct platform_device *device)
 {
 	cleanup_sysfs(device);
 
-	rfkill_unregister(wifi_rfkill);
-	rfkill_unregister(bluetooth_rfkill);
-	rfkill_unregister(wwan_rfkill);
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
+	if (wwan_rfkill)
+		rfkill_unregister(wwan_rfkill);
 
 	return 0;
 }

-- 
Matthew Garrett | mjg59@srcf.ucam.org
