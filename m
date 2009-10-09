Return-Path: <linux-kernel-owner+w=401wt.eu-S1760148AbZJIBSI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148AbZJIBSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbZJIBSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:18:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814AbZJIBSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:18:05 -0400
Message-ID: <4ACE8EF5.5050707@redhat.com>
Date: Fri, 09 Oct 2009 09:16:37 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: lenb@kernel.org, bjorn.helgaas@hp.com, andrew.patterson@hp.com,
       jbarnes@virtuousgeek.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: pci_root: fix NULL pointer deref after resume	from
 suspend
References: <1254119480-9730-1-git-send-email-dfeng@redhat.com> <20090928173819.GA2441@ldl.fc.hp.com> <4AC16682.50207@redhat.com> <20091001200522.GF31915@ldl.fc.hp.com>
In-Reply-To: <20091001200522.GF31915@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 04:05 AM, Alex Chiang wrote:
> Hi Danny,
>
> * Danny Feng<dfeng@redhat.com>:
>    
>> Call Trace:
>>   [<ffffffff81254193>] acpi_get_pci_dev+0x106/0x167
>>   [<ffffffff8125545a>] acpi_pci_bind+0x1c/0x86
>>   [<ffffffff8116230a>] ? sysfs_create_file+0x2a/0x2c
>>   [<ffffffff8125141f>] acpi_add_single_object+0x964/0xa0c
>>   [<ffffffff812515a7>] acpi_bus_check_add+0xe0/0x138
>>   [<ffffffff81251667>] acpi_bus_scan+0x68/0xa0
>>   [<ffffffff812516f4>] acpi_bus_add+0x2a/0x2e
>>   [<ffffffff81252c59>] hotplug_dock_devices+0x114/0x13e
>>   [<ffffffff8125301a>] acpi_dock_deferred_cb+0xbf/0x192
>>   [<ffffffff8124d6ca>] acpi_os_execute_deferred+0x29/0x36
>>   [<ffffffff8106a244>] worker_thread+0x251/0x347
>>   [<ffffffff8106a1ef>] ? worker_thread+0x1fc/0x347
>>   [<ffffffff8124d6a1>] ? acpi_os_execute_deferred+0x0/0x36
>>   [<ffffffff8106e426>] ? autoremove_wake_function+0x0/0x39
>>   [<ffffffff81069ff3>] ? worker_thread+0x0/0x347
>>   [<ffffffff8106e0e0>] kthread+0x7f/0x87
>>   [<ffffffff81012cea>] child_rip+0xa/0x20
>>   [<ffffffff81012650>] ? restore_args+0x0/0x30
>>   [<ffffffff8106e061>] ? kthread+0x0/0x87
>>   [<ffffffff81012ce0>] ? child_rip+0x0/0x20
>> Code: ff 49 89 fc 41 89 f5 a9 00 ff ff 07 74 11 be 87 00 00 00 48 c7 c7
>> 45 6d 5a 81 e8 f6 2b e3 ff 48 c7 c7 30 ab 68 81 e8 29 77 20 00<49>  8b
>> 5c 24 28 49 83 c4 28 eb 09 44 39 6b 38 74 10 48 89 c3 48
>> RIP  [<ffffffff812217e7>] pci_get_slot+0x4c/0x8c
>>   RSP<ffff88022ee69aa0>
>> CR2: 0000000000000028
>> ---[ end trace b5a7793bd9db2a4d ]---
>>      
> Can you please reproduce with this debug patch? I'm guessing that
> we're dying because we have a NULL parent device, but I'm curious
> as to what causes this situation to occur.
>
> Thanks.
> /ac
> ---
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 7338b6a..4c1b128 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -126,6 +126,7 @@ add_dock_dependent_device(struct dock_station *ds,
>   {
>   	spin_lock(&ds->dd_lock);
>   	list_add_tail(&dd->list,&ds->dependent_devices);
> +	printk("%s adding handle %p\n", __func__, dd->handle);
>   	spin_unlock(&ds->dd_lock);
>   }
>
> @@ -142,6 +143,8 @@ dock_add_hotplug_device(struct dock_station *ds,
>   {
>   	mutex_lock(&ds->hp_lock);
>   	list_add_tail(&dd->hotplug_list,&ds->hotplug_devices);
> +	dump_stack();
> +	printk("%s adding handle %p\n", __func__, dd->handle);
>   	mutex_unlock(&ds->hp_lock);
>   }
>
> @@ -325,14 +328,17 @@ static struct acpi_device * dock_create_acpi_device(acpi_handle handle)
>   	acpi_handle parent;
>   	int ret;
>
> +	printk("%s handle %p\n", __func__, handle);
>   	if (acpi_bus_get_device(handle,&device)) {
>   		/*
>   		 * no device created for this object,
>   		 * so we should create one.
>   		 */
>   		acpi_get_parent(handle,&parent);
> -		if (acpi_bus_get_device(parent,&parent_device))
> +		if (acpi_bus_get_device(parent,&parent_device)) {
>   			parent_device = NULL;
> +			printk("%s no parent, setting NULL\n", __func__);
> +		}
>
>   		ret = acpi_bus_add(&device, parent_device, handle,
>   			ACPI_BUS_TYPE_DEVICE);
> @@ -385,8 +391,10 @@ static void hotplug_dock_devices(struct dock_station *ds, u32 event)
>   	 * First call driver specific hotplug functions
>   	 */
>   	list_for_each_entry(dd,&ds->hotplug_devices, hotplug_list) {
> -		if (dd->ops&&  dd->ops->handler)
> +		if (dd->ops&&  dd->ops->handler) {
> +			printk("%s handle %p\n", __func__, dd->handle);
>   			dd->ops->handler(dd->handle, event, dd->context);
> +		}
>   	}
>
>   	/*
> @@ -1041,6 +1049,7 @@ static int dock_add(acpi_handle handle)
>   		ret = -ENOMEM;
>   		goto dock_add_err_unregister;
>   	}
> +	printk("%s adding self as dependent %p)\n", __func__, dd->handle);
>   	add_dock_dependent_device(dock_station, dd);
>
>   	dock_station_count++;
>
>    
Sorry for the late response, just back from holidays. Will do it soon, 
thanks.
