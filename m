Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYFJDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYFJDWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 23:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYFJDWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 23:22:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46207 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbYFJDWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 23:22:06 -0400
Message-ID: <484DF11A.7000306@jp.fujitsu.com>
Date: Tue, 10 Jun 2008 12:12:26 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4, v14] PCI, ACPI: Physical PCI slot objects
References: <20080604200829.GC379@ldl.fc.hp.com> <484CE515.4030205@jp.fujitsu.com> <20080609221108.GA16588@ldl.fc.hp.com> <484DEF46.7080106@jp.fujitsu.com>
In-Reply-To: <484DEF46.7080106@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige wrote:
> Alex Chiang wrote:
>> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:

(snip.)

> Thank you for explanation. I understood.
> 
> But I have one concern about the behavior when pci slot driver is not
> loaded. My patch (a86161b3134465f) prevents the kernel trace dump
> because of duplicate kobject add that would happen in the following two
> cases, though (b) is not described in the header of the patch (sorry).
> 
>   (a) multiple driver attempt to handle the same slot.
> 
>   (b) one or more driver attempt to register multiple slots with the
>       same name (This can happen if broken platform assigns the same
>       slot number to multiple hotplug slots, for example).
> 
> With your patch, duplicate kobject add in case (b) is not prevented.
> That is my concern.
> 
> I made a below patch to prevent (b), please take a look. And could you
> please consider merging it to "[PATCH 2/3] Introduce pci_slot" in your
> latest series.
> 
> Thanks,
> Kenji Kaneshige
> 
> 
> ---
>  drivers/pci/hotplug/pci_hotplug_core.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> Index: 20080610/drivers/pci/hotplug/pci_hotplug_core.c
> ===================================================================
> --- 20080610.orig/drivers/pci/hotplug/pci_hotplug_core.c
> +++ 20080610/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -555,6 +555,7 @@ int pci_hp_register(struct hotplug_slot 
>  {
>  	int result;
>  	struct pci_slot *pci_slot;
> +	struct hotplug_slot *tmp;
>  
>  	if (slot == NULL)
>  		return -ENODEV;
> @@ -567,6 +568,21 @@ int pci_hp_register(struct hotplug_slot 
>  	}
>  
>  	/*
> +	 * Prevent registering multiple hotplug slots with the same name.
> +	 */
> +	spin_lock(&pci_hotplug_slot_list_lock);
> +	list_for_each_entry(tmp, &pci_hotplug_slot_list, slot_list) {
> +		pci_slot = tmp->pci_slot;
> +		if (pci_slot->bus == bus && pci_slot->number == slot_nr)
> +			continue;
> +		if (!strcmp(tmp->name, slot->name)) {
> +			spin_unlock(&pci_hotplug_slot_list_lock);
> +			return -EEXIST;
> +		}
> +	}
> +	spin_unlock(&pci_hotplug_slot_list_lock);
> +
> +	/*
>  	 * No problems if we call this interface from both ACPI_PCI_SLOT
>  	 * driver and call it here again. If we've already created the
>  	 * pci_slot, the interface will simply bump the refcount.
> 
>

Please note that I made this patch against linux-next with your
latest three patches applied.

Thanks,
Kenji Kaneshige


