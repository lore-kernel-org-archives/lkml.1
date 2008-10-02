Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYJBEsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYJBEsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 00:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYJBEsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 00:48:30 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:34995 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbYJBEs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 00:48:29 -0400
Date: Wed, 1 Oct 2008 22:48:26 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v3 02/14] PCI: prevent duplicate slot names
Message-ID: <20081002044825.GA18063@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20080923163753.12628.98683.stgit@bob.kio> <20080923164523.12628.69510.stgit@bob.kio> <48E09936.2030905@jp.fujitsu.com> <48E189BF.4020907@jp.fujitsu.com> <20081002010542.GA745@ldl.fc.hp.com> <48E43657.4040006@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E43657.4040006@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>>> Kenji Kaneshige wrote:
>>>> Hi Alex-san,
>>>>
>>>> Here is one comment, though I have not finished reviewing/testing
>>>> your patches yet (sorry for the delay).
>>>>
>>>> Alex Chiang wrote:
>>>>
>>>> (snip.)
>>>>
>>>>> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c   
>>>>> b/drivers/pci/hotplug/pci_hotplug_core.c
>>>>> index 3e37d63..46802dc 100644
>>>>> --- a/drivers/pci/hotplug/pci_hotplug_core.c
>>>>> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
>>>>> @@ -570,39 +570,32 @@ int pci_hp_register(struct hotplug_slot 
>>>>> *slot,  struct pci_bus *bus, int slot_nr,
>>>>>          return -EINVAL;
>>>>>      }
>>>>>  -    /* Check if we have already registered a slot with the same 
>>>>> name. */
>>>>> -    if (get_slot_from_name(name))
>>>>> -        return -EEXIST;
>>>>> -
>>>>>      /*
>>>>> -     * No problems if we call this interface from both ACPI_PCI_SLOT
>>>>> -     * driver and call it here again. If we've already created the
>>>>> -     * pci_slot, the interface will simply bump the refcount.
>>>>> +     * Look for existing slot. If we find it, and it was created by a
>>>>> +     * slot detection driver (ie, doesn't have a ->hotplug()) then we
>>>>> +     * allow the hotplug driver calling us to rename the slot if 
>>>>>  desired.
>>>>> +     *
>>>>> +     * Otherwise, create the slot and carry on with life.
>>>>>       */
>>>>> -    pci_slot = pci_create_slot(bus, slot_nr, name);
>>>>> -    if (IS_ERR(pci_slot))
>>>>> -        return PTR_ERR(pci_slot);
>>>>> -
>>>>> -    if (pci_slot->hotplug) {
>>>>> -        dbg("%s: already claimed\n", __func__);
>>>>> -        pci_destroy_slot(pci_slot);
>>>>> -        return -EBUSY;
>>>>> +    pci_slot = pci_get_pci_slot(bus, slot_nr);
>>>> The pci_get_pci_slot() function refers pci_bus->slots list, so it
>>>> should be called with pci_bus_sem semaphore held as pci_create_slot()
>>>> does, or pci_bus_sem semaphore should be held by pci_get_pci_slot()
>>>> itself.
>>
>> Yes, I've changed pci_get_pci_slot() to acquire the pci_bus_sem
>> semaphore.
>>
>> Thank you for pointing this out.
>>
>> It will be fixed in v4 of this patch series, which I will send
>> out after I receive the rest of your review comments.
>>
>
> I noticed that changing pci_get_pci_slot() to acquire the pci_bus_sem
> might be not enough. If slot was created between pci_get_pci_slot() and
> pci_create_slot() by another thread in the following code, something
> wrong would happen I think.
>
>        pci_slot = pci_get_pci_slot(bus, slot_nr);
>        if (pci_slot) {
>                if (pci_slot->hotplug) {
>                        result = -EBUSY;
>                        goto err;
>                }
>
>                if (strcmp(kobject_name(&pci_slot->kobj), name))
>                        if ((result = pci_rename_slot(pci_slot, name)))
>                                goto err;
>        } else {
>                pci_slot = pci_create_slot(bus, slot_nr, name);
>                if ((result = IS_ERR(pci_slot)))
>                        goto out;
>        }

I'm sorry, I don't think I see the problem you are pointing out.

If pci_get_pci_slot() finds a pci_slot, we do not modify
pci_bus->slots any further, so even if a new slot is created, it
shouldn't affect the pci_slot that we already found.

I must be missing something, but I don't know what. Would you
mind explaining what you had in mind with your comment?

> I've finished reviewing and testing your patches. The rest of your
> patch looks good to me. Of course, we must not forget the comment
> from Taku Izumi.

Yes, I've modified my patch series to take into account the bugs
that Taku-san found.

Thank you both for your reviews.

/ac

