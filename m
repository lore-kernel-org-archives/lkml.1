Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYIIJEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYIIJEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 05:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYIIJEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 05:04:24 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:36315 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbYIIJEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 05:04:22 -0400
Date: Tue, 9 Sep 2008 03:04:21 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH 02/13] PCI: prevent duplicate slot names
Message-ID: <20080909090421.GA11901@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20080816235504.5461.20733.stgit@blender.achiang> <20080817001516.5461.59384.stgit@blender.achiang> <48AD4265.10108@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD4265.10108@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

As always, thank you very much for the excellent review.

Sorry for the delay; I've been busy with travel, and trying to
figure out how to solve the issue you pointed out below.

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Hi Alex-san,
>
> Thank you for updated patches and I'm sorry for delayed comment.
> I reviewed your patch and I found two problems. Please see below.
>
> Alex Chiang wrote:
>> Prevent callers of pci_create_slot() from registering slots with
>> duplicate names. This condition occurs most often when PCI hotplug
>> drivers are loaded on platforms with broken firmware that assigns
>> identical names to multiple slots.
>>
>> We now rename these duplicate slots on behalf of the user.
>>
>> If firmware assigns the name N to multiple slots, then:
>>
>> 	The first registered slot is assigned N
>> 	The second registered slot is assigned N-1
>> 	The third registered slot is assigned N-2
>> 	The Mth registered slot becomes N-M
>>
>> A side effect of this patch is that the error condition for when
>> multiple drivers attempt to claim the same slot becomes much more
>> prominent.
>>
>> In other words, the previous error condition returned for
>> duplicate slot names (-EEXIST) masked the case when multiple
>> drivers attempted to claim the same slot. Now, the -EBUSY return
>> makes the true error more obvious.
>>
>> Finally, since we now prevent duplicate slot names, we remove
>> the logic introduced by the following commits:
>>
>>  +static char *make_slot_name(const char *name)
>> +{
>> +	char *new_name;
>> +	int len, width, dup = 1;
>> +	struct kobject *dup_slot;
>> +
>> +	new_name = kstrdup(name, GFP_KERNEL);
>> +	if (!new_name)
>> +		goto out;
>> +
>> +	/*
>> +	 * Start off allocating enough room for "name-X"
>> +	 */
>> +	len = strlen(name) + 2;
>> +	width = 1;
>> +
>> +try_again:
>> +	dup_slot = kset_find_obj(pci_slots_kset, new_name);
>> +	if (!dup_slot)
>> +		goto out;
>> +
>
> The kset_find_obj() increments reference counter of specified kobject. So
> we must call kobject_put() for 'dup_slot', otherwise it leaks reference
> counter of 'dup_slot' kobject and the corresponding slot directory will
> never be removed. Here is a sample to fix this problem.
>
> 	dup_slot = kset_find_ojb(pci_slots_kset, new_name);
> 	if (!dup_slot)
> 		goto out;
> 	kobject_put(dup_slot);
> 	^^^^^^^^^^^^^^^^^^^^^^ Added this line

Yes, thanks for catching that. I've fixed it.

> I found another problem in pci_hp_register() that would be more complex
> to fix than above-mentioned problem. Here is a pci_hp_register() with
> all of your patch applied.
>
> int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>                        const char *name)
> {
> 	(snip...)
>
>        /*
>         * No problems if we call this interface from both ACPI_PCI_SLOT
>         * driver and call it here again. If we've already created the
>         * pci_slot, the interface will simply bump the refcount.
>         */
>        pci_slot = pci_create_slot(bus, slot_nr, name);
>        if (IS_ERR(pci_slot))
>                return PTR_ERR(pci_slot);
>
>        if (pci_slot->hotplug) {
>                dbg("%s: already claimed\n", __func__);
>                pci_destroy_slot(pci_slot);
>                return -EBUSY;
>        }
>
>        slot->pci_slot = pci_slot;
>        pci_slot->hotplug = slot;
>
>        /*
>         * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
>         */
>        if (strcmp(kobject_name(&pci_slot->kobj), name)) {
>                result = kobject_rename(&pci_slot->kobj, name);
>                if (result) {
>                        pci_destroy_slot(pci_slot);
>                        return result;
>                }
>        }
>
> 	(snip...)
> }
>
> If name duplication was detected in pci_create_slot(), it renames the
> slot name like 'N-1' and return successfully. Even though slot's kobject
> name was registered as 'N-1', 'name' array still have 'N' at this point.
> So the following 'if' statement becomes true unexpectedly.
>
> 	/*
>         * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
>         */
>        if (strcmp(kobject_name(&pci_slot->kobj), name)) {
>
> Then pci_hp_register() attempt to rename the slot name with 'N' again
> by calling kobject_rename(), but it fails because there already exists
> kobject with name 'N'. As a result, pci_hp_register() will fail.

Yes, you are right, that is a problem.

I've taken the following approach:

	- the above code is providing a mechanism to allow a
	  _hotplug_ driver to override a _detection_ driver slot
	  name.

	- in other words, we only have to worry about the case
	  when a _detection_ driver was loaded before a _hotplug_
	  driver.

	- we can ignore the case where another _hotplug_ driver
	  was loaded first, because we'll already return -EBUSY.

	- so, to figure out if a _detection_ driver has already
	  been loaded, we check to see if the pci_dev already has
	  a valid pci_slot pointer.

	- if yes, then we later check to see if the existing slot
	  name matches the requested slot name from the hotplug
	  driver.

	- if the hotplug driver is requesting a different name,
	  then we use a new interface, pci_rename_slot() which
	  will safely attempt to rename the slot without name
	  collision.

I'll send out the patch set soon, it would be great if you could
test it for me, since I don't have systems with duplicate slot
names.

Thank you very much!

/ac

