Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZI3Crr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZI3Crr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 22:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZI3Crq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 22:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbZI3Crq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 22:47:46 -0400
Message-ID: <4AC2C687.8060601@redhat.com>
Date: Wed, 30 Sep 2009 10:46:31 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alex Chiang <achiang@hp.com>, lenb@kernel.org, bjorn.helgaas@hp.com,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: pci_root: fix NULL pointer deref after  resume
 from suspend
References: <1254119480-9730-1-git-send-email-dfeng@redhat.com> <20090928173819.GA2441@ldl.fc.hp.com> <4AC16682.50207@redhat.com> <200909292212.42697.rjw@sisk.pl>
In-Reply-To: <200909292212.42697.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2009 04:12 AM, Rafael J. Wysocki wrote:
> On Tuesday 29 September 2009, Danny Feng wrote:
>> On 09/29/2009 01:38 AM, Alex Chiang wrote:
>>> Hi Xiaotian,
>>>
>>> Thanks for the bug report.
>>>
>>> * Xiaotian Feng<dfeng@redhat.com>:
>>>
>>>> commit 275582 introduces acpi_get_pci_dev(), but pdev->subordinate
>>>> can be NULL, then a NULL was passed to pci_get_slot, this results
>>>> the kernel oops when resume from suspend.
>>>>
>>>> This patch resolves following kernel oops:
>>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
>>>> IP: [<ffffffff812217e7>] pci_get_slot+0x4c/0x8c
>>>>
>>>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>>>> ---
>>>>    drivers/acpi/pci_root.c |    6 +++++-
>>>>    1 files changed, 5 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>>>> index 3112221..3c35144 100644
>>>> --- a/drivers/acpi/pci_root.c
>>>> +++ b/drivers/acpi/pci_root.c
>>>> @@ -387,7 +387,11 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
>>>>    		if (!pdev || hnd == handle)
>>>>    			break;
>>>>
>>>> -		pbus = pdev->subordinate;
>>>> +		if (pdev->subordinate)
>>>> +			pbus = pdev->subordinate;
>>>> +		else
>>>> +			pbus = pdev->bus;
>>>> +
>>>>
>>> I'm a little confused by this. If we start from the PCI root
>>> bridge and walk back down the hierarchy, shouldn't everything
>>> between the root and the device be a P2P bridge?
>>>
>>> What is special about suspend/resume that causes the subordinate
>>> bus to become NULL?
>>>
>>> Can you send the full stacktrace?
>>>
>>> Thanks.
>>>
>>> /ac
>>>
>>>
>>>
>> the full call trace is here:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
>> IP: [<ffffffff812217e7>] pci_get_slot+0x4c/0x8c
>> PGD 208b9d067 PUD 208a89067 PMD 0
>> Oops: 0000 [#1] SMP
>> last sysfs file: /sys/power/state
>> CPU 0
>> Modules linked in: fuse radeon ttm drm_kms_helper drm i2c_algo_bit sco
>> bridge stp llc bnep l2cap bluetooth sunrpc ip6t_REJECT nf_conntrack_ipv6
>> ip6table_filter ip6_tables ipv6 dm_multipath uinput snd_hda_codec_analog
>> snd_hda_intel snd_hda_codec snd_hwdep e1000e snd_pcm snd_timer i2c_i801
>> i2c_core snd soundcore snd_page_alloc iTCO_wdt iTCO_vendor_support
>> serio_raw ppdev parport_pc parport pcspkr dcdbas ata_generic pata_acpi
>> [last unloaded: speedstep_lib]
>> Pid: 35, comm: kacpi_hotplug Not tainted 2.6.32-rc2 #3 OptiPlex 760
>> RIP: 0010:[<ffffffff812217e7>]  [<ffffffff812217e7>] pci_get_slot+0x4c/0x8c
>> RSP: 0018:ffff88022ee69aa0  EFLAGS: 00010286
>> RAX: 0000000000000000 RBX: ffff88022e9b1090 RCX: 00000000000000a0
>> RDX: 000000000000002f RSI: ffffffff8168ab38 RDI: ffffffff8168ab38
>> RBP: ffff88022ee69ac0 R08: ffffffff8168ab30 R09: ffff880100000000
>> R10: ffffffff8168ab50 R11: 0000000000000000 R12: 0000000000000000
>> R13: 0000000000000001 R14: ffff88022f712000 R15: ffff88022f710dd0
>> FS:  0000000000000000(0000) GS:ffff880028200000(0000)
>> knlGS:0000000000000000
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> CR2: 0000000000000028 CR3: 00000001fc298000 CR4: 00000000000406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process kacpi_hotplug (pid: 35, threadinfo ffff88022ee68000, task
>> ffff88022eefc120)
>> Stack:
>>    0000000000000018 ffff88022e9b1090 ffff88020880e9c0 0000000000000000
>> <0>  ffff88022ee69b30 ffffffff81254193 0000000000000000 ffff88022ee69ae0
>> <0>  ffff88020880e340 ffff88020880ee38 ffff88022f710208 0000000000000001
>> Call Trace:
>>    [<ffffffff81254193>] acpi_get_pci_dev+0x106/0x167
>
> Have you checked (using gdb) which source code line this corresponds to?
>
Yep, the code line corresponds to
pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));

Also gdb shows pci_bus->devices has offset of 0x28.

I've put some check in acpi_get_pci_dev, it shows that pbus is NULL when 
the panic happens.

>>    [<ffffffff8125545a>] acpi_pci_bind+0x1c/0x86
>>    [<ffffffff8116230a>] ? sysfs_create_file+0x2a/0x2c
>>    [<ffffffff8125141f>] acpi_add_single_object+0x964/0xa0c
>>    [<ffffffff812515a7>] acpi_bus_check_add+0xe0/0x138
>>    [<ffffffff81251667>] acpi_bus_scan+0x68/0xa0
>>    [<ffffffff812516f4>] acpi_bus_add+0x2a/0x2e
>
> This looks like a device has just been discovered.
>
>>    [<ffffffff81252c59>] hotplug_dock_devices+0x114/0x13e
>>    [<ffffffff8125301a>] acpi_dock_deferred_cb+0xbf/0x192
>
> Have the machine been docked while suspended?
I was confused too..I didn't touch anything just suspend and then power 
up. Are there some devices unplugged or ejected at suspend stage?
>
>>    [<ffffffff8124d6ca>] acpi_os_execute_deferred+0x29/0x36
>>    [<ffffffff8106a244>] worker_thread+0x251/0x347
>>    [<ffffffff8106a1ef>] ? worker_thread+0x1fc/0x347
>>    [<ffffffff8124d6a1>] ? acpi_os_execute_deferred+0x0/0x36
>>    [<ffffffff8106e426>] ? autoremove_wake_function+0x0/0x39
>>    [<ffffffff81069ff3>] ? worker_thread+0x0/0x347
>>    [<ffffffff8106e0e0>] kthread+0x7f/0x87
>>    [<ffffffff81012cea>] child_rip+0xa/0x20
>>    [<ffffffff81012650>] ? restore_args+0x0/0x30
>>    [<ffffffff8106e061>] ? kthread+0x0/0x87
>>    [<ffffffff81012ce0>] ? child_rip+0x0/0x20
>> Code: ff 49 89 fc 41 89 f5 a9 00 ff ff 07 74 11 be 87 00 00 00 48 c7 c7
>> 45 6d 5a 81 e8 f6 2b e3 ff 48 c7 c7 30 ab 68 81 e8 29 77 20 00<49>  8b
>> 5c 24 28 49 83 c4 28 eb 09 44 39 6b 38 74 10 48 89 c3 48
>> RIP  [<ffffffff812217e7>] pci_get_slot+0x4c/0x8c
>>    RSP<ffff88022ee69aa0>
>> CR2: 0000000000000028
>> ---[ end trace b5a7793bd9db2a4d ]---
>
> Thanks,
> Rafael
>

