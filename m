Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYIKCtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYIKCtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 22:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYIKCsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 22:48:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55188 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYIKCsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 22:48:52 -0400
Message-ID: <48C886B0.8030605@jp.fujitsu.com>
Date: Thu, 11 Sep 2008 11:47:12 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v2 02/13] PCI: prevent duplicate slot names
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100012.29542.62582.stgit@bob.kio>
In-Reply-To: <20080909100012.29542.62582.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Prevent callers of pci_create_slot() from registering slots with
> duplicate names. This condition occurs most often when PCI hotplug
> drivers are loaded on platforms with broken firmware that assigns
> identical names to multiple slots.
> 
> We now rename these duplicate slots on behalf of the user.
> 
> If firmware assigns the name N to multiple slots, then:
> 
> 	The first registered slot is assigned N
> 	The second registered slot is assigned N-1
> 	The third registered slot is assigned N-2
> 	The Mth registered slot becomes N-M
> 
> A side effect of this patch is that the error condition for when
> multiple drivers attempt to claim the same slot becomes much more
> prominent.
> 
> In other words, the previous error condition returned for
> duplicate slot names (-EEXIST) masked the case when multiple
> drivers attempted to claim the same slot. Now, the -EBUSY return
> makes the true error more obvious.
> 
> This is the permanent fix mentioned in earlier commits:
> 
> 	shpchp: Rename duplicate slot name N as N-1, N-2, N-M...
> 	d6a9e9b40be7da84f82eb414c2ad98c5bb69986b
> 
> 	pciehp: Rename duplicate slot name N as N-1, N-2, N-M...
> 	167e782e301188c7c7e31e486bbeea5f918324c1
> 
> Cc: jbarnes@virtuousgeek.org
> Cc: kristen.c.accardi@intel.com
> Cc: matthew@wil.cx
> Cc: kaneshige.kenji@jp.fujitsu.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/hotplug/pci_hotplug_core.c |   23 ++++--
>  drivers/pci/hotplug/pciehp_core.c      |   14 ----
>  drivers/pci/hotplug/shpchp_core.c      |   15 ----
>  drivers/pci/slot.c                     |  117 +++++++++++++++++++++++++++-----
>  include/linux/pci.h                    |    3 +
>  5 files changed, 117 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
> index 3e37d63..2232608 100644
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -558,7 +558,8 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>  			const char *name)
>  {
>  	int result;
> -	struct pci_slot *pci_slot;
> +	struct pci_dev *dev;
> +	struct pci_slot *pci_slot, *tmp_slot = NULL;
>  
>  	if (slot == NULL)
>  		return -ENODEV;
> @@ -570,9 +571,17 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>  		return -EINVAL;
>  	}
>  
> -	/* Check if we have already registered a slot with the same name. */
> -	if (get_slot_from_name(name))
> -		return -EEXIST;
> +	/*
> +	 * If we find a tmp_slot here, it means that another slot
> +	 * driver has already created a pci_slot for this device.
> +	 * We care (below) if the existing slot has a different name from
> +	 * the new name that this particular hotplug driver is requesting.
> +	 */
> +	dev = pci_get_slot(bus, PCI_DEVFN(slot_nr, 0));
> +	if (dev && dev->slot) {
> +		tmp_slot = dev->slot;
> +		pci_dev_put(dev);
> +	}
>

I have two comments here.

(1) I think the reference counter of the device will be leaked if
(dev == NULL) && (dev->slot != NULL). We need pci_dev_put() whenever
dev is not NULL.

(2) When the slot is empty, the 'dev' will be always NULL. Therefore,
'tmp_slot' will be always NULL on the empty slot here. Because of
this, the following code to rename the slot will not work on the
empty slot, I think.

>  	/*
> -	 * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
> +	 * Allow pcihp drivers to override existing slot name.
>  	 */
> -	if (strcmp(kobject_name(&pci_slot->kobj), name)) {
> -		result = kobject_rename(&pci_slot->kobj, name);
> +	if (tmp_slot && strcmp(kobject_name(&tmp_slot->kobj), name)) {
> +		result = pci_rename_slot(pci_slot, name);
>  		if (result) {
>  			pci_destroy_slot(pci_slot);
>  			return result;

Thanks,
Kenji Kaneshige

