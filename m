Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbYIWAFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbYIWAFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 20:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYIWAFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 20:05:21 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:7499 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYIWAFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 20:05:19 -0400
Date: Mon, 22 Sep 2008 18:05:17 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v2 02/13] PCI: prevent duplicate slot names
Message-ID: <20080923000517.GB1814@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20080816235504.5461.20733.stgit@blender.achiang> <20080817001516.5461.59384.stgit@blender.achiang> <48AD4265.10108@jp.fujitsu.com> <20080909090421.GA11901@ldl.fc.hp.com> <48C885B4.2070200@jp.fujitsu.com> <20080909091813.29542.85613.stgit@bob.kio> <20080909100012.29542.62582.stgit@bob.kio> <48C886B0.8030605@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C885B4.2070200@jp.fujitsu.com> <48C886B0.8030605@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Hi Alex-san,
>
> Thank you very much for your continuous effort.

We'll get there some day. ;)

>>> If name duplication was detected in pci_create_slot(), it renames the
>>> slot name like 'N-1' and return successfully. Even though slot's kobject
>>> name was registered as 'N-1', 'name' array still have 'N' at this point.
>>> So the following 'if' statement becomes true unexpectedly.
>>>
>>> 	/*
>>>         * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
>>>         */
>>>        if (strcmp(kobject_name(&pci_slot->kobj), name)) {
>>>
>>> Then pci_hp_register() attempt to rename the slot name with 'N' again
>>> by calling kobject_rename(), but it fails because there already exists
>>> kobject with name 'N'. As a result, pci_hp_register() will fail.
>>
>> Yes, you are right, that is a problem.
>>
>> I've taken the following approach:
>>
>> 	- the above code is providing a mechanism to allow a
>> 	  _hotplug_ driver to override a _detection_ driver slot
>> 	  name.
>>
>> 	- in other words, we only have to worry about the case
>> 	  when a _detection_ driver was loaded before a _hotplug_
>> 	  driver.
>>
>> 	- we can ignore the case where another _hotplug_ driver
>> 	  was loaded first, because we'll already return -EBUSY.
>>
>> 	- so, to figure out if a _detection_ driver has already
>> 	  been loaded, we check to see if the pci_dev already has
>> 	  a valid pci_slot pointer.
>
> We need to take into account that the hotplug slot can be empty.
> In this case, we cannot do this check because pci_dev doesn't
> exist, I think.

You are right. We still only have to worry about the case where a
_detection_ driver was loaded before a _hotplug_ driver, and we
need to worry abou the case of an empty slot.

I created a new interface called pci_get_physical_slot() that
will tell us if we've already created a slot or not. This will
work even if the slot is empty.

Using this inteface should simplify the tortured logic in my last
patch and make pci_hp_register easier to read.

>> 	- if yes, then we later check to see if the existing slot
>> 	  name matches the requested slot name from the hotplug
>> 	  driver.
>>
>> 	- if the hotplug driver is requesting a different name,
>> 	  then we use a new interface, pci_rename_slot() which
>> 	  will safely attempt to rename the slot without name
>> 	  collision.
>>
>> I'll send out the patch set soon, it would be great if you could
>> test it for me, since I don't have systems with duplicate slot
>> names.
>>
>
> Sure.
>
> P.S.
> I also don't have the system with duplicate slot names. So I use
> the debug patch that emulates this kind of system for testing.

Hm, ok. I might think about adding some code to the fakephp
driver to use it as a debug tool as well...

A little more below...

>> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
>> index 3e37d63..2232608 100644
>> --- a/drivers/pci/hotplug/pci_hotplug_core.c
>> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
>> @@ -558,7 +558,8 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>>  			const char *name)
>>  {
>>  	int result;
>> -	struct pci_slot *pci_slot;
>> +	struct pci_dev *dev;
>> +	struct pci_slot *pci_slot, *tmp_slot = NULL;
>>   	if (slot == NULL)
>>  		return -ENODEV;
>> @@ -570,9 +571,17 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>>  		return -EINVAL;
>>  	}
>>  -	/* Check if we have already registered a slot with the same name. */
>> -	if (get_slot_from_name(name))
>> -		return -EEXIST;
>> +	/*
>> +	 * If we find a tmp_slot here, it means that another slot
>> +	 * driver has already created a pci_slot for this device.
>> +	 * We care (below) if the existing slot has a different name from
>> +	 * the new name that this particular hotplug driver is requesting.
>> +	 */
>> +	dev = pci_get_slot(bus, PCI_DEVFN(slot_nr, 0));
>> +	if (dev && dev->slot) {
>> +		tmp_slot = dev->slot;
>> +		pci_dev_put(dev);
>> +	}
>>
>
> I have two comments here.
>
> (1) I think the reference counter of the device will be leaked if
> (dev == NULL) && (dev->slot != NULL). We need pci_dev_put() whenever
> dev is not NULL.
>
> (2) When the slot is empty, the 'dev' will be always NULL. Therefore,
> 'tmp_slot' will be always NULL on the empty slot here. Because of
> this, the following code to rename the slot will not work on the
> empty slot, I think.

The new pci_get_physical_slot() interface will solve both issues.

Thanks.

/ac

