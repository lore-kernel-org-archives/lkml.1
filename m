Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0CIH5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 02:57:53 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:37647 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0CIH5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 02:57:50 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>
	<86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>
	<m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Mar 2010 23:57:46 -0800
In-Reply-To: <4B95F37E.6060309@kernel.org> (Yinghai Lu's message of "Mon\, 08 Mar 2010 23\:06\:38 -0800")
Message-ID: <m16356nczp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 03/08/2010 04:35 PM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>> 
>> Yep this looks like a couple more cases of drivers that don't
>> statically declare and allocate their sysfs attributes.
>> The ipmi driver looks like it just wants to waste memory.
>> I haven't made sense of the thermal driver yet.
>> 
>> Something like the untested patch below should fix the impi driver.
>> 
>> 
>> Eric
>> 
>>> On Mon, Mar 8, 2010 at 3:47 PM, Alexander Beregalov
>>> <a.beregalov@gmail.com> wrote:
>>>> Hi
>>>>
>>>> Kernel version is 2.6.34-rc1
>>>>
>>>> bus: 'acpi': add driver processor
>>>> bus: 'acpi': driver_probe_device: matched device LNXCPU:00 with driver processor
>>>> bus: 'acpi': really_probe: probing driver processor with device LNXCPU:00
>>>> device: 'cooling_device0': device_add
>>>> driver: 'LNXCPU:00': driver_bound: bound to device 'processor'
>>>> bus: 'acpi': really_probe: bound device LNXCPU:00 to driver processor
>>>> bus: 'acpi': add driver thermal
>>>> bus: 'acpi': driver_probe_device: matched device LNXTHERM:00 with driver thermal
>>>> bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:00
>>>> bus: 'acpi': driver_probe_device: matched device LNXTHERM:01 with driver thermal
>>>> bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:01
>>>> device: 'thermal_zone0': device_add
>>>> BUG: key f71f0168 not in .data!
>>>> ------------[ cut here ]------------
>>>> WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x16f/0x4f0()
>>>> Hardware name:
>>>> Modules linked in:
>>>> Pid: 1, comm: swapper Not tainted 2.6.34-rc1 #1
>>>> Call Trace:
>>>>  [<c1351758>] ? printk+0x18/0x20
>>>>  [<c102aa5d>] warn_slowpath_common+0x6d/0xa0
>>>>  [<c104e9af>] ? lockdep_init_map+0x16f/0x4f0
>>>>  [<c104e9af>] ? lockdep_init_map+0x16f/0x4f0
>>>>  [<c1001000>] ? do_one_initcall+0x0/0x190
>>>>  [<c102aaa5>] warn_slowpath_null+0x15/0x20
>>>>  [<c104e9af>] lockdep_init_map+0x16f/0x4f0
>>>>  [<c10dcd98>] sysfs_add_file_mode+0x58/0xb0
>>>>  [<c10dce03>] sysfs_add_file+0x13/0x20
>>>> Switched to NOHz mode on CPU #0
>>>>  [<c10dcec6>] sysfs_create_file+0x26/0x30
>>>>  [<c1247ab3>] device_create_file+0x13/0x20
>>>>  [<c12c5bd4>] thermal_zone_bind_cooling_device+0x1e4/0x2f0
>>>>  [<c11feb35>] ? acpi_bus_data_handler+0x0/0x5
>>>>  [<c121ed40>] acpi_thermal_cooling_device_cb+0x70/0x11e
>>>>  [<c12c5780>] ? thermal_zone_device_register+0x260/0x400
>>>>  [<c12c59f0>] ? thermal_zone_bind_cooling_device+0x0/0x2f0
>>>>  [<c121ee0a>] acpi_thermal_bind_cooling_device+0xd/0xf
>>>>  [<c12c57f9>] thermal_zone_device_register+0x2d9/0x400
>>>>  [<c121ef82>] acpi_thermal_add+0x176/0x398
>>>>  [<c10de301>] ? sysfs_do_create_link+0xa1/0x140
>>>>  [<c11fec0f>] acpi_device_probe+0x3a/0xf4
>>>>  [<c124a097>] driver_probe_device+0xb7/0x1b0
>>>>  [<c124a219>] __driver_attach+0x89/0x90
>>>>  [<c12498b8>] bus_for_each_dev+0x48/0x70
>>>>  [<c1249e79>] driver_attach+0x19/0x20
>>>>  [<c124a190>] ? __driver_attach+0x0/0x90
>>>>  [<c124922b>] bus_add_driver+0xcb/0x230
>>>>  [<c11feb45>] ? acpi_device_remove+0x0/0x90
>>>>  [<c124a495>] driver_register+0x65/0x110
>>>>  [<c162119a>] ? kernel_init+0x0/0x120
>>>>  [<c10d6bd3>] ? proc_mkdir_mode+0x33/0x50
>>>>  [<c162119a>] ? kernel_init+0x0/0x120
>>>>  [<c11ffebb>] acpi_bus_register_driver+0x3a/0x3f
>>>>  [<c1639062>] acpi_thermal_init+0x50/0x6f
>>>>  [<c100102d>] do_one_initcall+0x2d/0x190
>>>>  [<c162119a>] ? kernel_init+0x0/0x120
>>>>  [<c1639012>] ? acpi_thermal_init+0x0/0x6f
>>>>  [<c162119a>] ? kernel_init+0x0/0x120
>>>>  [<c1621221>] kernel_init+0x87/0x120
>>>>  [<c1002fba>] kernel_thread_helper+0x6/0x1c
>>>> ---[ end trace a7919e7f17c0a725 ]---
>>>
>>>
>>> got
>>>
>>> [  145.239329] BUG: key ffff88206fe99c58 not in .data!
>>> [  145.244994] ------------[ cut here ]------------
>>> [  145.250949] WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xf1/0x53c()
>>> [  145.262424] Hardware name: Sun Fire x4800
>>> [  145.267543] Modules linked in:
>>> [  145.275078] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-yh-dirty #221
>>> [  145.285140] Call Trace:
>>> [  145.290143]  [<ffffffff810759b0>] warn_slowpath_common+0x7c/0x94
>>> [  145.304624]  [<ffffffff810759dc>] warn_slowpath_null+0x14/0x16
>>> [  145.314632]  [<ffffffff8109f299>] lockdep_init_map+0xf1/0x53c
>>> [  145.325228]  [<ffffffff8117e100>] ? sysfs_new_dirent+0x8f/0x104
>>> [  145.334331]  [<ffffffff8117d72e>] sysfs_add_file_mode+0x66/0xac
>>> [  145.339850]  [<ffffffff8117d785>] sysfs_add_file+0x11/0x13
>>> [  145.355513]  [<ffffffff8117d844>] sysfs_create_file+0x2a/0x2c
>>> [  145.360637]  [<ffffffff8148ca98>] device_create_file+0x19/0x1b
>>> [  145.375187]  [<ffffffff8145fc9a>] ipmi_register_smi+0x862/0xd72
>>> [  145.384606]  [<ffffffff8148b9f8>] ? put_device+0x17/0x19
>>> [  145.395142]  [<ffffffff8148cee5>] ? device_add+0x44b/0x52a
>>> [  145.403666]  [<ffffffff8108fb5a>] ? autoremove_wake_function+0x0/0x39
>>> [  145.416309]  [<ffffffff81462e71>] try_smi_init+0x6d0/0x8a0
>>> [  145.424534]  [<ffffffff81ba2fd5>] init_ipmi_si+0x4cf/0x907
>>> [  145.434799]  [<ffffffff81ba2b06>] ? init_ipmi_si+0x0/0x907
>>> [  145.439677]  [<ffffffff8100020d>] do_one_initcall+0x72/0x17f
>>> [  145.455681]  [<ffffffff826836a0>] kernel_init+0x166/0x1f0
>>> [  145.463319]  [<ffffffff81032914>] kernel_thread_helper+0x4/0x10
>>> [  145.476497]  [<ffffffff81bfc2bc>] ? restore_args+0x0/0x30
>>> [  145.485014]  [<ffffffff8268353a>] ? kernel_init+0x0/0x1f0
>>> [  145.495859]  [<ffffffff81032910>] ? kernel_thread_helper+0x0/0x10
>>> [  145.501541] ---[ end trace 0ec12b1482c47368 ]---
>> 
>> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
>> index ec5e3f8..16e9073 100644
>> --- a/drivers/char/ipmi/ipmi_msghandler.c
>> +++ b/drivers/char/ipmi/ipmi_msghandler.c
>> @@ -2272,42 +2272,52 @@ static int create_files(struct bmc_device *bmc)
>>  	bmc->device_id_attr.attr.name = "device_id";
>>  	bmc->device_id_attr.attr.mode = S_IRUGO;
>>  	bmc->device_id_attr.show = device_id_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->provides_dev_sdrs_attr.attr.name = "provides_device_sdrs";
>>  	bmc->provides_dev_sdrs_attr.attr.mode = S_IRUGO;
>>  	bmc->provides_dev_sdrs_attr.show = provides_dev_sdrs_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->revision_attr.attr.name = "revision";
>>  	bmc->revision_attr.attr.mode = S_IRUGO;
>>  	bmc->revision_attr.show = revision_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->firmware_rev_attr.attr.name = "firmware_revision";
>>  	bmc->firmware_rev_attr.attr.mode = S_IRUGO;
>>  	bmc->firmware_rev_attr.show = firmware_rev_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->version_attr.attr.name = "ipmi_version";
>>  	bmc->version_attr.attr.mode = S_IRUGO;
>>  	bmc->version_attr.show = ipmi_version_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->add_dev_support_attr.attr.name = "additional_device_support";
>>  	bmc->add_dev_support_attr.attr.mode = S_IRUGO;
>>  	bmc->add_dev_support_attr.show = add_dev_support_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->manufacturer_id_attr.attr.name = "manufacturer_id";
>>  	bmc->manufacturer_id_attr.attr.mode = S_IRUGO;
>>  	bmc->manufacturer_id_attr.show = manufacturer_id_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->product_id_attr.attr.name = "product_id";
>>  	bmc->product_id_attr.attr.mode = S_IRUGO;
>>  	bmc->product_id_attr.show = product_id_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->guid_attr.attr.name = "guid";
>>  	bmc->guid_attr.attr.mode = S_IRUGO;
>>  	bmc->guid_attr.show = guid_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	bmc->aux_firmware_rev_attr.attr.name = "aux_firmware_revision";
>>  	bmc->aux_firmware_rev_attr.attr.mode = S_IRUGO;
>>  	bmc->aux_firmware_rev_attr.show = aux_firmware_rev_show;
>> +	sysfs_attr_init(&bmc->device_id_attr.attr);
>>  
>>  	err = device_create_file(&bmc->dev->dev,
>>  			   &bmc->device_id_attr);
>
> still have bunch of that BUG...

I expect if you look the backtrace will be different.
There are real issues here, I just don't know how to find them
without bug reports, or volunteers helping me to fix them.

But the fixes are trivial, there is no problem if you disable lockdep,
and the machine still runs with lockdep enabled.

Which ultimately means that lockdep can finally report errors between
sysfs and files and locking reasonably accurately.

If you would be so kind and help by posting the back traces so we can
find the handful of places left that dynamically allocate their sysfs
attributes that would be very much appreciated.

Eric
