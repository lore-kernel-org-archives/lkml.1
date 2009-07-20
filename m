Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZGTUIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZGTUIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZGTUIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:08:49 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:41991 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZGTUIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mG7mqmHhrdvUybEcA47IPKXAYD7AcBkab9nj4jCI3ke+6h3YsqgibfTsrH47HHn8j0
         dZ32KG3/lGorP6PzB7fkpfIK27eAlyd85RvazotYsV+EBstlvPwctB1p9OTyGx5L2Dwd
         hUDBomix5FZmOHgsEzWPSGyFGa9x1x5c8FvY0=
Message-ID: <4A64CEC9.8020402@tuffmail.co.uk>
Date: Mon, 20 Jul 2009 21:08:41 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] hp-wmi: improved rfkill support for wifi
References: <4A61FE7D.9080409@tuffmail.co.uk>	 <8db1092f0907181155h3d603a17q11815b9f174ac333@mail.gmail.com>	 <4A623490.50305@tuffmail.co.uk>	 <8db1092f0907190028o334371d7g798c1e8cb9a5744b@mail.gmail.com>	 <4A635618.3070507@tuffmail.co.uk>	 <8db1092f0907191110p2d3c2c45je61bda6365ed1468@mail.gmail.com>	 <4A6364DF.3040303@tuffmail.co.uk>	 <8db1092f0907191208i6fcdf519r8204be542e95bbe4@mail.gmail.com>	 <4A64A50D.5040401@tuffmail.co.uk> <8db1092f0907201254m2be66477k6ec2f447bfad9f73@mail.gmail.com>
In-Reply-To: <8db1092f0907201254m2be66477k6ec2f447bfad9f73@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/7/20 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>   
>> ...and here's the version that remembers to register the bluetooth.  I
>> reviewed the patch again; hopefully that's the last dumb error.
>>     
> [...]
>
> 2.6.31-rc3+ patches:
> http://lkml.org/lkml/2009/7/18/131
> http://lkml.org/lkml/2009/7/10/339
> + patch below:
>
>   
>> diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
>> index 517ac47..adb26d3 100644
>> --- a/drivers/platform/x86/hp-wmi.c
>> +++ b/drivers/platform/x86/hp-wmi.c
>> @@ -51,6 +51,12 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
>>  #define HPWMI_WIRELESS_QUERY 0x5
>>  #define HPWMI_HOTKEY_QUERY 0xc
>>
>> +enum hp_wmi_radio {
>> +       HPWMI_WIFI = 0,
>> +       HPWMI_BLUETOOTH = 1,
>> +       HPWMI_WWAN = 2,
>> +};
>> +
>>  static int __init hp_wmi_bios_setup(struct platform_device *device);
>>  static int __exit hp_wmi_bios_remove(struct platform_device *device);
>>  static int hp_wmi_resume_handler(struct platform_device *device);
>> @@ -170,8 +176,8 @@ static int hp_wmi_tablet_state(void)
>>
>>  static int hp_wmi_set_block(void *data, bool blocked)
>>  {
>> -       unsigned long b = (unsigned long) data;
>> -       int query = BIT(b + 8) | ((!blocked) << b);
>> +       enum hp_wmi_radio r = (enum hp_wmi_radio) data;
>> +       int query = BIT(r + 8) | ((!blocked) << r);
>>
>>        return hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 1, query);
>>  }
>> @@ -180,41 +186,23 @@ static const struct rfkill_ops hp_wmi_rfkill_ops = {
>>        .set_block = hp_wmi_set_block,
>>  };
>>
>> -static bool hp_wmi_wifi_sw_state(void)
>> +static bool hp_wmi_get_sw_state(enum hp_wmi_radio r)
>>  {
>>        int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
>> +       int mask = 0x200 << (r * 8);
>>
>> -       if (wireless & 0x200)
>> +       if (wireless & mask)
>>                return false;
>>        else
>>                return true;
>>  }
>>
>> -static bool hp_wmi_wifi_hw_state(void)
>> +static bool hp_wmi_get_hw_state(enum hp_wmi_radio r)
>>  {
>>        int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
>> +       int mask = 0x800 << (r * 8);
>>
>> -       if (wireless & 0x800)
>> -               return false;
>> -       else
>> -               return true;
>> -}
>> -
>> -static bool hp_wmi_bluetooth_state(void)
>> -{
>> -       int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
>> -
>> -       if (wireless & 0x10000)
>> -               return false;
>> -       else
>> -               return true;
>> -}
>> -
>> -static bool hp_wmi_wwan_state(void)
>> -{
>> -       int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
>> -
>> -       if (wireless & 0x1000000)
>> +       if (wireless & mask)
>>                return false;
>>        else
>>                return true;
>> @@ -339,50 +327,55 @@ static void hp_wmi_notify(u32 value, void *context)
>>        struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
>>        static struct key_entry *key;
>>        union acpi_object *obj;
>> +       int eventcode;
>>
>>        wmi_get_event_data(value, &response);
>>
>>        obj = (union acpi_object *)response.pointer;
>>
>> -       if (obj && obj->type == ACPI_TYPE_BUFFER && obj->buffer.length == 8) {
>> -               int eventcode = *((u8 *) obj->buffer.pointer);
>> -               if (eventcode == 0x4)
>> -                       eventcode = hp_wmi_perform_query(HPWMI_HOTKEY_QUERY, 0,
>> -                                                        0);
>> -               key = hp_wmi_get_entry_by_scancode(eventcode);
>> -               if (key) {
>> -                       switch (key->type) {
>> -                       case KE_KEY:
>> -                               input_report_key(hp_wmi_input_dev,
>> -                                                key->keycode, 1);
>> -                               input_sync(hp_wmi_input_dev);
>> -                               input_report_key(hp_wmi_input_dev,
>> -                                                key->keycode, 0);
>> -                               input_sync(hp_wmi_input_dev);
>> -                               break;
>> -                       }
>> -               } else if (eventcode == 0x1) {
>> -                       input_report_switch(hp_wmi_input_dev, SW_DOCK,
>> -                                           hp_wmi_dock_state());
>> -                       input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
>> -                                           hp_wmi_tablet_state());
>> +       if (!obj || obj->type != ACPI_TYPE_BUFFER || obj->buffer.length != 8) {
>> +               printk(KERN_INFO "HP WMI: Unknown response received\n");
>> +               return;
>> +       }
>> +
>> +       eventcode = *((u8 *) obj->buffer.pointer);
>> +       if (eventcode == 0x4)
>> +               eventcode = hp_wmi_perform_query(HPWMI_HOTKEY_QUERY, 0,
>> +                                               0);
>> +       key = hp_wmi_get_entry_by_scancode(eventcode);
>> +       if (key) {
>> +               switch (key->type) {
>> +               case KE_KEY:
>> +                       input_report_key(hp_wmi_input_dev,
>> +                                        key->keycode, 1);
>> +                       input_sync(hp_wmi_input_dev);
>> +                       input_report_key(hp_wmi_input_dev,
>> +                                        key->keycode, 0);
>>                        input_sync(hp_wmi_input_dev);
>> -               } else if (eventcode == 0x5) {
>> -                       if (wifi_rfkill)
>> -                               rfkill_set_states(wifi_rfkill,
>> -                                                 hp_wmi_wifi_sw_state(),
>> -                                                 hp_wmi_wifi_hw_state());
>> -                       if (bluetooth_rfkill)
>> -                               rfkill_set_sw_state(bluetooth_rfkill,
>> -                                                   hp_wmi_bluetooth_state());
>> -                       if (wwan_rfkill)
>> -                               rfkill_set_sw_state(wwan_rfkill,
>> -                                                   hp_wmi_wwan_state());
>> -               } else
>> -                       printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
>> -                              eventcode);
>> +                       break;
>> +               }
>> +       } else if (eventcode == 0x1) {
>> +               input_report_switch(hp_wmi_input_dev, SW_DOCK,
>> +                                   hp_wmi_dock_state());
>> +               input_report_switch(hp_wmi_input_dev, SW_TABLET_MODE,
>> +                                   hp_wmi_tablet_state());
>> +               input_sync(hp_wmi_input_dev);
>> +       } else if (eventcode == 0x5) {
>> +               if (wifi_rfkill)
>> +                       rfkill_set_states(wifi_rfkill,
>> +                                         hp_wmi_get_sw_state(HPWMI_WIFI),
>> +                                         hp_wmi_get_hw_state(HPWMI_WIFI));
>> +               if (bluetooth_rfkill)
>> +                       rfkill_set_states(bluetooth_rfkill,
>> +                                         hp_wmi_get_sw_state(HPWMI_BLUETOOTH),
>> +                                         hp_wmi_get_hw_state(HPWMI_BLUETOOTH));
>> +               if (wwan_rfkill)
>> +                       rfkill_set_states(wwan_rfkill,
>> +                                         hp_wmi_get_sw_state(HPWMI_WWAN),
>> +                                         hp_wmi_get_hw_state(HPWMI_WWAN));
>>        } else
>> -               printk(KERN_INFO "HP WMI: Unknown response received\n");
>> +               printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
>> +                       eventcode);
>>  }
>>
>>  static int __init hp_wmi_input_setup(void)
>> @@ -461,11 +454,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
>>                wifi_rfkill = rfkill_alloc("hp-wifi", &device->dev,
>>                                           RFKILL_TYPE_WLAN,
>>                                           &hp_wmi_rfkill_ops,
>> -                                          (void *) 0);
>> +                                          (void *) HPWMI_WIFI);
>>                rfkill_init_sw_state(wifi_rfkill,
>> -                                    hp_wmi_wifi_sw_state());
>> +                                    hp_wmi_get_sw_state(HPWMI_WIFI));
>>                rfkill_set_hw_state(wifi_rfkill,
>> -                                   hp_wmi_wifi_hw_state());
>> +                                   hp_wmi_get_hw_state(HPWMI_WIFI));
>>                err = rfkill_register(wifi_rfkill);
>>                if (err)
>>                        goto register_wifi_error;
>> @@ -475,7 +468,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
>>                bluetooth_rfkill = rfkill_alloc("hp-bluetooth", &device->dev,
>>                                                RFKILL_TYPE_BLUETOOTH,
>>                                                &hp_wmi_rfkill_ops,
>> -                                               (void *) 1);
>> +                                               (void *) HPWMI_BLUETOOTH);
>> +               rfkill_init_sw_state(bluetooth_rfkill,
>> +                                    hp_wmi_get_sw_state(HPWMI_BLUETOOTH));
>> +               rfkill_set_hw_state(bluetooth_rfkill,
>> +                                   hp_wmi_get_hw_state(HPWMI_BLUETOOTH));
>>                err = rfkill_register(bluetooth_rfkill);
>>                if (err)
>>                        goto register_bluetooth_error;
>> @@ -485,7 +482,11 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
>>                wwan_rfkill = rfkill_alloc("hp-wwan", &device->dev,
>>                                           RFKILL_TYPE_WWAN,
>>                                           &hp_wmi_rfkill_ops,
>> -                                          (void *) 2);
>> +                                          (void *) HPWMI_WWAN);
>> +               rfkill_init_sw_state(wwan_rfkill,
>> +                                    hp_wmi_get_sw_state(HPWMI_WWAN));
>> +               rfkill_set_hw_state(wwan_rfkill,
>> +                                   hp_wmi_get_hw_state(HPWMI_WWAN));
>>                err = rfkill_register(wwan_rfkill);
>>                if (err)
>>                        goto register_wwan_err;
>> @@ -541,9 +542,18 @@ static int hp_wmi_resume_handler(struct platform_device *device)
>>                            hp_wmi_tablet_state());
>>        input_sync(hp_wmi_input_dev);
>>
>> -       rfkill_set_states(wifi_rfkill,
>> -                         hp_wmi_wifi_sw_state(),
>> -                         hp_wmi_wifi_hw_state());
>> +       if (wifi_rfkill)
>> +               rfkill_set_states(wifi_rfkill,
>> +                                 hp_wmi_get_sw_state(HPWMI_WIFI),
>> +                                 hp_wmi_get_hw_state(HPWMI_WIFI));
>> +       if (bluetooth_rfkill)
>> +               rfkill_set_states(bluetooth_rfkill,
>> +                                 hp_wmi_get_sw_state(HPWMI_BLUETOOTH),
>> +                                 hp_wmi_get_hw_state(HPWMI_BLUETOOTH));
>> +       if (wwan_rfkill)
>> +               rfkill_set_states(wwan_rfkill,
>> +                                 hp_wmi_get_sw_state(HPWMI_WWAN),
>> +                                 hp_wmi_get_hw_state(HPWMI_WWAN));
>>
>>        return 0;
>>  }
>>
>>
>>
>>     
>
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
> 0: phy0: Wireless LAN
>         Soft blocked: yes
>         Hard blocked: yes
> 1: hp-wifi: Wireless LAN
>         Soft blocked: yes
>         Hard blocked: no
> 2: hp-bluetooth: Bluetooth
>         Soft blocked: yes
>         Hard blocked: no
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill unblock 0
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
> 0: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: yes
> 1: hp-wifi: Wireless LAN
>         Soft blocked: yes
>         Hard blocked: no
> 2: hp-bluetooth: Bluetooth
>         Soft blocked: yes
>         Hard blocked: no
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill unblock 1
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
> 0: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: hp-wifi: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 2: hp-bluetooth: Bluetooth
>         Soft blocked: yes
>         Hard blocked: no
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill unblock 2
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
> 0: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: hp-wifi: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 2: hp-bluetooth: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 3: hci0: Bluetooth
>         Soft blocked: yes
>         Hard blocked: no
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill unblock 3
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# ./rfkill list
> 0: phy0: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 1: hp-wifi: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 2: hp-bluetooth: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 3: hci0: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> root@gumis:/home/maciek/zrodelka/rfkill/rfkill# hciconfig
> hci0:   Type: USB
>         BD Address: 00:16:41:88:A0:1B ACL MTU: 1017:8 SCO MTU: 64:8
>         DOWN
>         RX bytes:318 acl:0 sco:0 events:6 errors:0
>         TX bytes:27 acl:0 sco:0 commands:9 errors:0
>
> Works OK. Thanks :-)
>
> During compile I have got:
> CC [M]  drivers/platform/x86/hp-wmi.o
> drivers/platform/x86/hp-wmi.c: In function ‘hp_wmi_bios_setup’:
> drivers/platform/x86/hp-wmi.c:460: warning: ignoring return value of
> ‘rfkill_set_hw_state’, declared with attribute warn_unused_result
> drivers/platform/x86/hp-wmi.c:474: warning: ignoring return value of
> ‘rfkill_set_hw_state’, declared with attribute warn_unused_result
> drivers/platform/x86/hp-wmi.c:488: warning: ignoring return value of
> ‘rfkill_set_hw_state’, declared with attribute warn_unused_result
>   

The attribute is wrong, I've already submitted a patch to remove it.

I'll combine this patch with the previous one and submit it tomorrow.

Thanks again
Alan
