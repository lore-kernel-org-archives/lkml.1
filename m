Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYJBBFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYJBBFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 21:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYJBBFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 21:05:45 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15902 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYJBBFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 21:05:44 -0400
Date: Wed, 1 Oct 2008 19:05:42 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v3 02/14] PCI: prevent duplicate slot names
Message-ID: <20081002010542.GA745@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20080923163753.12628.98683.stgit@bob.kio> <20080923164523.12628.69510.stgit@bob.kio> <48E09936.2030905@jp.fujitsu.com> <48E189BF.4020907@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E189BF.4020907@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Kenji Kaneshige wrote:
>> Hi Alex-san,
>>
>> Here is one comment, though I have not finished reviewing/testing
>> your patches yet (sorry for the delay).
>>
>> Alex Chiang wrote:
>>
>> (snip.)
>>
>>> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c  
>>> b/drivers/pci/hotplug/pci_hotplug_core.c
>>> index 3e37d63..46802dc 100644
>>> --- a/drivers/pci/hotplug/pci_hotplug_core.c
>>> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
>>> @@ -570,39 +570,32 @@ int pci_hp_register(struct hotplug_slot *slot,  
>>> struct pci_bus *bus, int slot_nr,
>>>          return -EINVAL;
>>>      }
>>>  -    /* Check if we have already registered a slot with the same 
>>> name. */
>>> -    if (get_slot_from_name(name))
>>> -        return -EEXIST;
>>> -
>>>      /*
>>> -     * No problems if we call this interface from both ACPI_PCI_SLOT
>>> -     * driver and call it here again. If we've already created the
>>> -     * pci_slot, the interface will simply bump the refcount.
>>> +     * Look for existing slot. If we find it, and it was created by a
>>> +     * slot detection driver (ie, doesn't have a ->hotplug()) then we
>>> +     * allow the hotplug driver calling us to rename the slot if  
>>> desired.
>>> +     *
>>> +     * Otherwise, create the slot and carry on with life.
>>>       */
>>> -    pci_slot = pci_create_slot(bus, slot_nr, name);
>>> -    if (IS_ERR(pci_slot))
>>> -        return PTR_ERR(pci_slot);
>>> -
>>> -    if (pci_slot->hotplug) {
>>> -        dbg("%s: already claimed\n", __func__);
>>> -        pci_destroy_slot(pci_slot);
>>> -        return -EBUSY;
>>> +    pci_slot = pci_get_pci_slot(bus, slot_nr);
>>
>> The pci_get_pci_slot() function refers pci_bus->slots list, so it
>> should be called with pci_bus_sem semaphore held as pci_create_slot()
>> does, or pci_bus_sem semaphore should be held by pci_get_pci_slot()
>> itself.

Yes, I've changed pci_get_pci_slot() to acquire the pci_bus_sem
semaphore.

Thank you for pointing this out.

It will be fixed in v4 of this patch series, which I will send
out after I receive the rest of your review comments.

Thanks!

/ac

