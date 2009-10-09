Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbZJIBTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbZJIBTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758145AbZJIBTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:19:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758074AbZJIBTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:19:01 -0400
Message-ID: <4ACE8F29.3000804@redhat.com>
Date: Fri, 09 Oct 2009 09:17:29 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alex Chiang <achiang@hp.com>, lenb@kernel.org, bjorn.helgaas@hp.com,
       andrew.patterson@hp.com, jbarnes@virtuousgeek.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi: pci_root: fix NULL pointer deref after resume from
 suspend
References: <1254119480-9730-1-git-send-email-dfeng@redhat.com> <4AC16682.50207@redhat.com> <20091001200522.GF31915@ldl.fc.hp.com> <200910040056.00247.rjw@sisk.pl>
In-Reply-To: <200910040056.00247.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2009 06:56 AM, Rafael J. Wysocki wrote:
> On Thursday 01 October 2009, Alex Chiang wrote:
>    
>> Hi Danny,
>>
>> * Danny Feng<dfeng@redhat.com>:
>>      
>>> Call Trace:
>>>   [<ffffffff81254193>] acpi_get_pci_dev+0x106/0x167
>>>   [<ffffffff8125545a>] acpi_pci_bind+0x1c/0x86
>>>   [<ffffffff8116230a>] ? sysfs_create_file+0x2a/0x2c
>>>   [<ffffffff8125141f>] acpi_add_single_object+0x964/0xa0c
>>>   [<ffffffff812515a7>] acpi_bus_check_add+0xe0/0x138
>>>   [<ffffffff81251667>] acpi_bus_scan+0x68/0xa0
>>>   [<ffffffff812516f4>] acpi_bus_add+0x2a/0x2e
>>>   [<ffffffff81252c59>] hotplug_dock_devices+0x114/0x13e
>>>   [<ffffffff8125301a>] acpi_dock_deferred_cb+0xbf/0x192
>>>   [<ffffffff8124d6ca>] acpi_os_execute_deferred+0x29/0x36
>>>   [<ffffffff8106a244>] worker_thread+0x251/0x347
>>>   [<ffffffff8106a1ef>] ? worker_thread+0x1fc/0x347
>>>   [<ffffffff8124d6a1>] ? acpi_os_execute_deferred+0x0/0x36
>>>   [<ffffffff8106e426>] ? autoremove_wake_function+0x0/0x39
>>>   [<ffffffff81069ff3>] ? worker_thread+0x0/0x347
>>>   [<ffffffff8106e0e0>] kthread+0x7f/0x87
>>>   [<ffffffff81012cea>] child_rip+0xa/0x20
>>>   [<ffffffff81012650>] ? restore_args+0x0/0x30
>>>   [<ffffffff8106e061>] ? kthread+0x0/0x87
>>>   [<ffffffff81012ce0>] ? child_rip+0x0/0x20
>>> Code: ff 49 89 fc 41 89 f5 a9 00 ff ff 07 74 11 be 87 00 00 00 48 c7 c7
>>> 45 6d 5a 81 e8 f6 2b e3 ff 48 c7 c7 30 ab 68 81 e8 29 77 20 00<49>  8b
>>> 5c 24 28 49 83 c4 28 eb 09 44 39 6b 38 74 10 48 89 c3 48
>>> RIP  [<ffffffff812217e7>] pci_get_slot+0x4c/0x8c
>>>   RSP<ffff88022ee69aa0>
>>> CR2: 0000000000000028
>>> ---[ end trace b5a7793bd9db2a4d ]---
>>>        
>> Can you please reproduce with this debug patch? I'm guessing that
>> we're dying because we have a NULL parent device, but I'm curious
>> as to what causes this situation to occur.
>>      
> If we had a NULL parent, acpi_get_parent() would return an error.  Also, if we
> one of the devices is NULL at the PCI level, pci_get_slot() will return NULL.
> The only possibility left is that one of the buses we find in the ACPI tables
> doesn't have a secondary PCI bus.
>
> I think what happens is that on resume we get a dock notification
> (via dock_acpi_notifier registered in dock_init()) for a dock station device
> that is present in the ACPI tables, but not physically accessible at the moment
> (I guess that falls into the "BIOS bug" category, but we can fix this easily in
> the kernel).
>
> So, IMO, the appended patch is the right fix.
>
> Danny, please test it and report back (in particular, please tell us if you see
> the "Secondary bus not present" message in dmesg).
>
> Thanks,
> Rafael
>
>
> ---
>   drivers/acpi/pci_root.c |   12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -389,6 +389,18 @@ struct pci_dev *acpi_get_pci_dev(acpi_ha
>
>   		pbus = pdev->subordinate;
>   		pci_dev_put(pdev);
> +
> +		/*
> +		 * During resume from a sleep state we can get a dock
> +		 * notification for a device that is present in ACPI tables,
> +		 * but not physically accessible at the moment, so tell the
> +		 * caller it's not present.
> +		 */
> +		if (!pbus) {
> +			dev_info(&pdev->dev, "Secondary bus not present\n");
> +			pdev = NULL;
> +			break;
> +		}
>   	}
>   out:
>   	list_for_each_entry_safe(node, tmp,&device_list, node)
>
>    
Sorry for the late response, just back from holidays. Will test it soon, 
thanks.
