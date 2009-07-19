Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZGSSYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZGSSYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 14:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbZGSSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 14:24:36 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42772 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbZGSSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 14:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KaCzLuTkGObwIniDwGGSEU+iY3F4iv9uN7WatxIYSVPOC8S7gWFJVIkezpicpfnqvn
         FwsBdrfzbz2pktRguU0PxdlbxV96X8bgxQIu4yV9s3rrP0CZ2k48ptUuq3nR9QEpB7br
         IbP30nTof7PpBrQHIkgzCpms/J/qrP06aml4E=
Message-ID: <4A6364DF.3040303@tuffmail.co.uk>
Date: Sun, 19 Jul 2009 19:24:31 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
References: <4A61FE7D.9080409@tuffmail.co.uk>	 <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>	 <4A623490.50305@tuffmail.co.uk>	 <8db1092f0907190028o334371d7g798c1e8cb9a5744b@mail.gmail.com>	 <4A635618.3070507@tuffmail.co.uk> <8db1092f0907191110p2d3c2c45je61bda6365ed1468@mail.gmail.com>
In-Reply-To: <8db1092f0907191110p2d3c2c45je61bda6365ed1468@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/7/19 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>   
>> Maciej Rutecki wrote:
>>     
>>> 2009/7/18 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>>> [...]
>>>
>>>       
>>>> I'll try extending this to bluetooth and wwan as Matthew suggested.  If
>>>> you have time to run "acpidump" and send me the output, that would help
>>>>
>>>>         
>>> acpidump in attachment.
>>>
>>>       
>> Heh, I got lucky borrowing the G7000.  Your acpidump is much less human
>> readable, and Matthews lot is the same.  I gave up looking for the right
>> bits.
>>
>> So I had to guess :-).  The interface seems nicely structured, so I
>> generalized my changes and applied them to the other rfkill devices.
>> Patch follows - apply on top of the first one.
>>
>> Now if you disable bluetooth in the Windows driver and reboot to linux,
>> you should find it stays disabled.
>>
>>     
>
> 2.6.31-rc3+ patches:
> http://lkml.org/lkml/2009/7/18/131
> http://lkml.org/lkml/2009/7/10/339
> http://lkml.org/lkml/2009/7/19/57
>
> Disable bluetooth and wireless in Windows XP
> When modprobe hp-wmi during boot:
> [    9.648259] input: HP WMI hotkeys as /class/input/input8
> [    9.664468] Platform driver 'hp-wmi' needs updating - please use dev_pm_ops
> [    9.707352] ------------[ cut here ]------------
> [    9.708007] Kernel BUG at f80763b7 [verbose debug info unavailable

> [    9.708007] EIP is at rfkill_init_sw_state+0x57/0x70 [rfkill

> [    9.708007]  [<f8efa18f>] ? hp_wmi_bios_setup+0x18f/0x211 [hp_wmi

Sorry, that was a dumb copy+paste error.  Here's a fixed version.

> LED from wifi/bluetooth button sometimes flashing(!)

Hmm.  That might be a sign that I guessed wrong.

--------------------------------------------------------------------------
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 517ac47..35ef858 100644
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
@@ -180,41 +186,23 @@ static const struct rfkill_ops hp_wmi_rfkill_ops = {
 	.set_block = hp_wmi_set_block,
 };
 
-static bool hp_wmi_wifi_sw_state(void)
+static bool hp_wmi_get_sw_state(enum hp_wmi_radio r)
 {
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
+	int mask = 0x200 << (r * 8);
 
-	if (wireless & 0x200)
+	if (wireless & mask)
 		return false;
 	else
 		return true;
 }
 
-static bool hp_wmi_wifi_hw_state(void)
+static bool hp_wmi_get_hw_state(enum hp_wmi_radio r)
 {
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
+	int mask = 0x800 << (r * 8);
 
-	if (wireless & 0x800)
-		return false;
-	else
-		return true;
-}
-
-static bool hp_wmi_bluetooth_state(void)
-{
-	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
-
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
@@ -339,50 +327,55 @@ static void hp_wmi_notify(u32 value, void *context)
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
 			input_sync(hp_wmi_input_dev);
-		} else if (eventcode == 0x5) {
-			if (wifi_rfkill)
-				rfkill_set_states(wifi_rfkill,
-						  hp_wmi_wifi_sw_state(),
-						  hp_wmi_wifi_hw_state());
-			if (bluetooth_rfkill)
-				rfkill_set_sw_state(bluetooth_rfkill,
-						    hp_wmi_bluetooth_state());
-			if (wwan_rfkill)
-				rfkill_set_sw_state(wwan_rfkill,
-						    hp_wmi_wwan_state());
-		} else
-			printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
-			       eventcode);
+			input_report_key(hp_wmi_input_dev,
+					 key->keycode, 0);
+			input_sync(hp_wmi_input_dev);
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
@@ -461,11 +454,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 		wifi_rfkill = rfkill_alloc("hp-wifi", &device->dev,
 					   RFKILL_TYPE_WLAN,
 					   &hp_wmi_rfkill_ops,
-					   (void *) 0);
+					   (void *) HPWMI_WIFI);
 		rfkill_init_sw_state(wifi_rfkill,
-				     hp_wmi_wifi_sw_state());
+				     hp_wmi_get_sw_state(HPWMI_WIFI));
 		rfkill_set_hw_state(wifi_rfkill,
-				    hp_wmi_wifi_hw_state());
+				    hp_wmi_get_hw_state(HPWMI_WIFI));
 		err = rfkill_register(wifi_rfkill);
 		if (err)
 			goto register_wifi_error;
@@ -475,8 +468,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 		bluetooth_rfkill = rfkill_alloc("hp-bluetooth", &device->dev,
 						RFKILL_TYPE_BLUETOOTH,
 						&hp_wmi_rfkill_ops,
-						(void *) 1);
-		err = rfkill_register(bluetooth_rfkill);
+						(void *) HPWMI_BLUETOOTH);
+		rfkill_init_sw_state(bluetooth_rfkill,
+				     hp_wmi_get_sw_state(HPWMI_BLUETOOTH));
+		rfkill_set_hw_state(bluetooth_rfkill,
+				    hp_wmi_get_hw_state(HPWMI_BLUETOOTH));
 		if (err)
 			goto register_bluetooth_error;
 	}
@@ -485,7 +481,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
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
@@ -541,9 +541,21 @@ static int hp_wmi_resume_handler(struct platform_device *device)
 			    hp_wmi_tablet_state());
 	input_sync(hp_wmi_input_dev);
 
-	rfkill_set_states(wifi_rfkill,
-			  hp_wmi_wifi_sw_state(),
-			  hp_wmi_wifi_hw_state());
+	if (wifi_rfkill) {
+		rfkill_set_states(wifi_rfkill,
+				  hp_wmi_get_sw_state(HPWMI_WIFI),
+				  hp_wmi_get_hw_state(HPWMI_WIFI));
+	}
+	if (bluetooth_rfkill) {
+		rfkill_set_states(bluetooth_rfkill,
+				  hp_wmi_get_sw_state(HPWMI_BLUETOOTH),
+				  hp_wmi_get_hw_state(HPWMI_BLUETOOTH));
+	}
+	if (wwan_rfkill) {
+		rfkill_set_states(wwan_rfkill,
+				  hp_wmi_get_sw_state(HPWMI_WWAN),
+				  hp_wmi_get_hw_state(HPWMI_WWAN));
+	}
 
 	return 0;
 }



