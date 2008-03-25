Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbYCYDcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbYCYDcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 23:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757505AbYCYDbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 23:31:47 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:40489 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbYCYDbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 23:31:46 -0400
Date: Mon, 24 Mar 2008 21:31:45 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 16/16][BUG] PCI hotplug core: add missing lock for
	hotplug slot list (Not for mainline!)
Message-ID: <20080325033145.GE26434@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Greg KH <gregkh@suse.de>, Gary Hade <garyhade@us.ibm.com>,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
	Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
	rick.jones2@hp.com, linux-kernel@vger.kernel.org,
	linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com> <47E33937.5050205@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E33937.5050205@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Add missing lock for manipulating pci_hotplug_slot_list.

Nice work, thanks. I've merged it.

/ac

> 
> Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> 
> ---
>  drivers/pci/hotplug/pci_hotplug_core.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.25-rc6/drivers/pci/hotplug/pci_hotplug_core.c
> ===================================================================
> --- linux-2.6.25-rc6.orig/drivers/pci/hotplug/pci_hotplug_core.c
> +++ linux-2.6.25-rc6/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -61,6 +61,7 @@ static int debug;
>  //////////////////////////////////////////////////////////////////
>  
>  static LIST_HEAD(pci_hotplug_slot_list);
> +static DEFINE_SPINLOCK(pci_hotplug_slot_list_lock);
>  
>  /* these strings match up with the values in pci_bus_speed */
>  static char *pci_bus_speed_strings[] = {
> @@ -529,12 +530,16 @@ static struct hotplug_slot *get_slot_fro
>  	struct hotplug_slot *slot;
>  	struct list_head *tmp;
>  
> +	spin_lock(&pci_hotplug_slot_list_lock);
>  	list_for_each (tmp, &pci_hotplug_slot_list) {
>  		slot = list_entry (tmp, struct hotplug_slot, slot_list);
>  		if (strcmp(slot->name, name) == 0)
> -			return slot;
> +			goto out;
>  	}
> -	return NULL;
> +	slot = NULL;
> +out:
> +	spin_unlock(&pci_hotplug_slot_list_lock);
> +	return slot;
>  }
>  
>  /**
> @@ -584,7 +589,9 @@ int pci_hp_register(struct hotplug_slot 
>  		}
>  	}
>  
> +	spin_lock(&pci_hotplug_slot_list_lock);
>  	list_add(&slot->slot_list, &pci_hotplug_slot_list);
> +	spin_unlock(&pci_hotplug_slot_list_lock);
>  
>  	result = fs_add_slot(pci_slot);
>  	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
> @@ -613,7 +620,9 @@ int pci_hp_deregister(struct hotplug_slo
>  	if (temp != hotplug)
>  		return -ENODEV;
>  
> +	spin_lock(&pci_hotplug_slot_list_lock);
>  	list_del(&hotplug->slot_list);
> +	spin_unlock(&pci_hotplug_slot_list_lock);
>  
>  	slot = hotplug->pci_slot;
>  	fs_remove_slot(slot);
> 
> 
