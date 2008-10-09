Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbYJIEVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbYJIEVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758775AbYJIEMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:12:50 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:24537 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728AbYJIEMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:12:48 -0400
Date: Wed, 8 Oct 2008 22:12:47 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v4 03/15] PCI: prevent duplicate slot names
Message-ID: <20081009041247.GD4668@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20081003230125.9989.31145.stgit@bob.kio> <20081003231742.9989.89860.stgit@bob.kio> <48EC4C67.9060501@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EC4C67.9060501@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>
>> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
>> index e00266b..b196ea1 100644
>> --- a/drivers/pci/hotplug/pci_hotplug_core.c
>> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
>> @@ -572,41 +572,32 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>>  		return -EINVAL;
>>  	}
>>  -	/* Check if we have already registered a slot with the same name. */
>> -	if (get_slot_from_name(name))
>> -		return -EEXIST;
>> -
>>  	/*
>> -	 * No problems if we call this interface from both ACPI_PCI_SLOT
>> -	 * driver and call it here again. If we've already created the
>> -	 * pci_slot, the interface will simply bump the refcount.
>> +	 * Look for existing slot. If we find it, and it was created by a
>> +	 * slot detection driver (ie, doesn't have a ->hotplug()) then we
>> +	 * allow the hotplug driver calling us to rename the slot if desired.
>> +	 *
>> +	 * Otherwise, create the slot and carry on with life.
>>  	 */
>> -	pci_slot = pci_create_slot(bus, slot_nr, name);
>> -	if (IS_ERR(pci_slot))
>> -		return PTR_ERR(pci_slot);
>> -
>>  	mutex_lock(&pci_hp_mutex);
>> -	if (pci_slot->hotplug) {
>> -		mutex_unlock(&pci_hp_mutex);
>> -		dbg("%s: already claimed\n", __func__);
>> -		pci_destroy_slot(pci_slot);
>> -		return -EBUSY;
>> +	pci_slot = pci_get_pci_slot(bus, slot_nr);
>> +	if (pci_slot) {
>> +		if (pci_slot->hotplug) {
>> +			result = -EBUSY;
>> +			goto err;
>> +		}
>> +
>> +		if (strcmp(kobject_name(&pci_slot->kobj), name))
>> +			if ((result = pci_rename_slot(pci_slot, name)))
>> +				goto err;
>> +	} else {
>> +		pci_slot = pci_create_slot(bus, slot_nr, name);
>> +		if ((result = IS_ERR(pci_slot)))
>> +			goto out;
>>  	}
>>
>
> I think there still remain race condition. The situation I imagine
> is as follows, though I might be misunderstanding something.
>
> If pci_slot driver created pci_slot between pci_get_pci_slot() and
> pci_create_slot() in pci_hp_register() in the hotplug driver's thread,
> pci_rename_slot() would never be called and name specified by pci_slot
> driver would be used instead of the one specified by hotplug driver.

Ah, now I finally understand.

And I think the solution is to avoid all the crap code I've been
introducing into pci_hp_register.

A better way to do it would be to make slot creation and name
override into one atomic operation, inside of pci_create_slot.

We are already serializing pci_create_slot by acquiring
pci_bus_sem, so that should prevent any race condition.

I wrote a long changelog entry for my patches that should explain
it all.

Please review. :)

>> -void pci_update_slot_number(struct pci_slot *slot, int slot_nr)
>> +void pci_renumber_slot(struct pci_slot *slot, int slot_nr)
>>  {
>> -	int name_count = 0;
>>  	struct pci_slot *tmp;
>>   	down_write(&pci_bus_sem);
>>   	list_for_each_entry(tmp, &slot->bus->slots, list) {
>>  		WARN_ON(tmp->number == slot_nr);
>> -		if (!strcmp(kobject_name(&tmp->kobj), kobject_name(&slot->kobj)))
>> -			name_count++;
>> +		goto out;
>>  	}
>>  -	if (name_count > 1)
>> -		printk(KERN_WARNING "pci_update_slot_number found %d slots with the same name: %s\n", name_count, kobject_name(&slot->kobj));
>> -
>>  	slot->number = slot_nr;
>> +out:
>>  	up_write(&pci_bus_sem);
>>  }
>> -EXPORT_SYMBOL_GPL(pci_update_slot_number);
>> +EXPORT_SYMBOL_GPL(pci_renumber_slot);
>>  
>
> You changed exported symbol name. I think it should be made as
> an another patch.

Ok.

Thanks.

/ac

