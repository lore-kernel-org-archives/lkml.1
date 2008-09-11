Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYIKCpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYIKCpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 22:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYIKCoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 22:44:54 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55001 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbYIKCox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:44:53 -0400
Message-ID: <48C885B4.2070200@jp.fujitsu.com>
Date: Thu, 11 Sep 2008 11:43:00 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH 02/13] PCI: prevent duplicate slot names
References: <20080816235504.5461.20733.stgit@blender.achiang> <20080817001516.5461.59384.stgit@blender.achiang> <48AD4265.10108@jp.fujitsu.com> <20080909090421.GA11901@ldl.fc.hp.com>
In-Reply-To: <20080909090421.GA11901@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex-san,

Thank you very much for your continuous effort.
I have one comment about the new design. Please see below.

 >> I found another problem in pci_hp_register() that would be more complex
>> to fix than above-mentioned problem. Here is a pci_hp_register() with
>> all of your patch applied.
>>
>> int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>>                        const char *name)
>> {
>> 	(snip...)
>>
>>        /*
>>         * No problems if we call this interface from both ACPI_PCI_SLOT
>>         * driver and call it here again. If we've already created the
>>         * pci_slot, the interface will simply bump the refcount.
>>         */
>>        pci_slot = pci_create_slot(bus, slot_nr, name);
>>        if (IS_ERR(pci_slot))
>>                return PTR_ERR(pci_slot);
>>
>>        if (pci_slot->hotplug) {
>>                dbg("%s: already claimed\n", __func__);
>>                pci_destroy_slot(pci_slot);
>>                return -EBUSY;
>>        }
>>
>>        slot->pci_slot = pci_slot;
>>        pci_slot->hotplug = slot;
>>
>>        /*
>>         * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
>>         */
>>        if (strcmp(kobject_name(&pci_slot->kobj), name)) {
>>                result = kobject_rename(&pci_slot->kobj, name);
>>                if (result) {
>>                        pci_destroy_slot(pci_slot);
>>                        return result;
>>                }
>>        }
>>
>> 	(snip...)
>> }
>>
>> If name duplication was detected in pci_create_slot(), it renames the
>> slot name like 'N-1' and return successfully. Even though slot's kobject
>> name was registered as 'N-1', 'name' array still have 'N' at this point.
>> So the following 'if' statement becomes true unexpectedly.
>>
>> 	/*
>>         * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
>>         */
>>        if (strcmp(kobject_name(&pci_slot->kobj), name)) {
>>
>> Then pci_hp_register() attempt to rename the slot name with 'N' again
>> by calling kobject_rename(), but it fails because there already exists
>> kobject with name 'N'. As a result, pci_hp_register() will fail.
> 
> Yes, you are right, that is a problem.
> 
> I've taken the following approach:
> 
> 	- the above code is providing a mechanism to allow a
> 	  _hotplug_ driver to override a _detection_ driver slot
> 	  name.
> 
> 	- in other words, we only have to worry about the case
> 	  when a _detection_ driver was loaded before a _hotplug_
> 	  driver.
> 
> 	- we can ignore the case where another _hotplug_ driver
> 	  was loaded first, because we'll already return -EBUSY.
> 
> 	- so, to figure out if a _detection_ driver has already
> 	  been loaded, we check to see if the pci_dev already has
> 	  a valid pci_slot pointer.

We need to take into account that the hotplug slot can be empty.
In this case, we cannot do this check because pci_dev doesn't
exist, I think.

> 
> 	- if yes, then we later check to see if the existing slot
> 	  name matches the requested slot name from the hotplug
> 	  driver.
> 
> 	- if the hotplug driver is requesting a different name,
> 	  then we use a new interface, pci_rename_slot() which
> 	  will safely attempt to rename the slot without name
> 	  collision.
> 
> I'll send out the patch set soon, it would be great if you could
> test it for me, since I don't have systems with duplicate slot
> names.
> 

Sure.

P.S.
I also don't have the system with duplicate slot names. So I use
the debug patch that emulates this kind of system for testing.

Thanks,
Kenji Kaneshige


