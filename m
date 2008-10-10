Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYJJEpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYJJEpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 00:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYJJEo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 00:44:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57164 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYJJEo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 00:44:57 -0400
Message-ID: <48EEDD7E.5090002@jp.fujitsu.com>
Date: Fri, 10 Oct 2008 13:43:42 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v5 04/16] PCI: prevent duplicate slot names
References: <20081009043140.8678.44164.stgit@bob.kio> <20081009044649.8678.30990.stgit@bob.kio> <48ED9716.3040301@jp.fujitsu.com> <20081009055654.GA30972@ldl.fc.hp.com> <48EDF9F5.9020802@jp.fujitsu.com> <20081010021034.GA13292@ldl.fc.hp.com>
In-Reply-To: <20081010021034.GA13292@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Alex Chiang wrote:
>>> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>>>> Thank your new patches. Very quick!!!
>>> I'm trying to get into 2.6.28. ;)
>>>
>>>> Though I have not reviewed/tested your patches yet (of course), I have
>>>> one concern as I said in the e-mail soon before. Does the new one
>>>> consider the following senario?
>>>>
>>>> 	Scenario C:
>>>> 	hotplug driver(A)               	hotplug_driver(B)
>>>> 	--------------                  	----------------
>>>>        pci_create_slot(name=A, rename=1)
>>>> 						pci_create_slot(name=B, rename=1)
>>>>
>>>> The hotplug driver (A) creates the slot with name "A". The the hotplug
>>>> driver (B) tries to create the same slot, but wants the name "B" instead.
>>>> In this case, hotplug driver fails to create the slot and the slot name
>>>> should not be changed to "B" from "A".
>>> Hm... I don't think this is a common scenario but...
>>>
>> It was a common scenario until recently because acpiphp and
>> native hotplug drivers(pciehp, shpchp) had different naming
>> rules. That is, acpiphp used _SUN number, while pciehp/shpchp
>> used bus number and physical slot number pair. Although the
>> pciehp/shpchp driver has been changed not to use bus_number
>> for slot names and acpiphp and pciehp/shpchp has the same
>> names on my system now, but I think the scenario is still
>> possible because naming rule of each hotplug driver could be
>> changed in the future again.
>>
>> By the way, acpiphp was changed to handle 64bit _SUN number
>> recently for new ia64 HP servers, IIRC. Are hotplug slots
>> on that server can also be handled through PCIe controller?
>> If it is yes, I think _SUN doesn't match physical slot number
>> because physical slot number (in Slot Capabilities Register)
>> has only 13bit. In this case, the above scenario will happen.
> 
> Hm, ok, I agree.
> 
>>> int pci_hp_register(...)
>>> {
>>> 	...
>>>
>>>         pci_slot = pci_create_slot(bus, slot_nr, name, 1);
>>>         if (IS_ERR(pci_slot))                    return 
>>> PTR_ERR(pci_slot);
>>>
>>>         if (pci_slot->hotplug) {
>>>                 dbg("%s: already claimed\n", __func__);
>>>                 pci_destroy_slot(pci_slot);
>>>                 return -EBUSY;
>>>         }
>>> 	...
>>> }
>>>
>>> I could maybe move that check into pci_create_slot() instead.
>>>
>>> struct pci_slot *pci_create_slot(...)
>>> {
>>> 	...
>>>
>>>         /*
>>>          * Get existing slot and rename if desired
>>>          */
>>>         slot = get_slot(parent, slot_nr);
>>>         if (slot && rename) {
>>> 		if ((err = slot->hotplug ? -EBUSY : 0)
>>> 		     || (err = rename_slot(slot, name))) {
>>>                         kobject_put(&slot->kobj);
>>>                         slot = NULL;
>>>                         goto err;
>>>                 } else
>>>                         goto out;
>>>         } else if (slot)
>>>                 goto out;
>>> 	...
>>> }
>>>
>>> Seems a little ugly to me, but maybe it's necessary?
>>>
>> I don't like this, and I think it's wrong because callers
>> might get -EBUSY even though they are not related to hotplug.
>>
>> I thought of the following alternative ideas, when I was making
>> sample patches. What do you think about those? My was concerned
>> that both need to add hotplug related code into generic pci slot
>> management code/API.
>>
>> - Add 'hotplug' arg to pci_create_slot(), instead of 'rename'
>>  flag. The pci_create_slot() would be as follows:
>>
>> 	struct pci_slot *pci_create_slot(..., struct hotplug_slot *hotplug)
>> 	{
>> 		...
>> 		/*
>> 		 * Get existing slot and rename if desired
>> 		 */
>> 		slot = get_slot(parent, slot_nr);
>> 		if (slot) {
>> 			if (hotplug) {
>> 				if ((err = slot->hotplug ? -EBUSY : 0)
>> 				     || err = rename_slot(slot, name))) {
>> 					Some cleanups;
>> 					return err;
>> 				}
>> 			}
>> 			goto out;
>> 		}
>> 		...
>> 	out:
>> 		if (hotplug)
>> 			slot->hotplug = hotplug;
>> 		...
>> 	}
> 
> I like this approach a little better, since the flow of execution
> is easier to understand (vs. pci_create_slot + pci_slot_hp_register).
> 
> I prototyped it, but didn't get a chance to test it (I did
> compile it though).
> 
> I'll send 2 test patches shortly that should replace the earlier
> 03/16 and 04/16 patches.
> 

I'm sorry, but I forgot to tell you one important thing. Now we are
trying to change pci slot management API to setup pci_slot->hotplug.
We must consider how to implement the counterpart to clean up
pci_slot->hotplug at the same time. My current idea is adding hotplug
arg to pci_destroy_slot(), but it seems a little ugly...

Thanks,
Kenji Kaneshige

