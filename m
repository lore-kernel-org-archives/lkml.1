Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYJHFo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYJHFo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 01:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJHFoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 01:44:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35715 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYJHFoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 01:44:18 -0400
Message-ID: <48EC4851.2080300@jp.fujitsu.com>
Date: Wed, 08 Oct 2008 14:42:41 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v4 02/15] PCI Hotplug: serialize pci_hp_register/deregister
References: <20081003230125.9989.31145.stgit@bob.kio> <20081003231737.9989.94126.stgit@bob.kio>
In-Reply-To: <20081003231737.9989.94126.stgit@bob.kio>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we no longer need pci_hotplug_slot_list_lock with your patch.

Thanks,
Kenji Kaneshige


Alex Chiang wrote:
> Add explicit locking to pci_hp_register/deregister. For a given pci_slot,
> we want to make sure that the pci_slot->hotplug pointer isn't being
> changed from underneath us.
> 
> Cc: jbarnes@virtuousgeek.org
> Cc: kristen.c.accardi@intel.com
> Cc: matthew@wil.cx
> Cc: kaneshige.kenji@jp.fujitsu.com
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/pci/hotplug/pci_hotplug_core.c |    7 +++++++
>  drivers/pci/slot.c                     |    4 ++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
> index 0e7a511..e00266b 100644
> --- a/drivers/pci/hotplug/pci_hotplug_core.c
> +++ b/drivers/pci/hotplug/pci_hotplug_core.c
> @@ -37,6 +37,7 @@
>  #include <linux/init.h>
>  #include <linux/mount.h>
>  #include <linux/namei.h>
> +#include <linux/mutex.h>
>  #include <linux/pci.h>
>  #include <linux/pci_hotplug.h>
>  #include <asm/uaccess.h>
> @@ -554,6 +555,7 @@ out:
>   *
>   * Returns 0 if successful, anything else for an error.
>   */
> +static DEFINE_MUTEX(pci_hp_mutex);
>  int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>  			const char *name)
>  {
> @@ -583,7 +585,9 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>  	if (IS_ERR(pci_slot))
>  		return PTR_ERR(pci_slot);
>  
> +	mutex_lock(&pci_hp_mutex);
>  	if (pci_slot->hotplug) {
> +		mutex_unlock(&pci_hp_mutex);
>  		dbg("%s: already claimed\n", __func__);
>  		pci_destroy_slot(pci_slot);
>  		return -EBUSY;
> @@ -591,6 +595,7 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
>  
>  	slot->pci_slot = pci_slot;
>  	pci_slot->hotplug = slot;
> +	mutex_unlock(&pci_hp_mutex);
>  
>  	/*
>  	 * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
> @@ -635,6 +640,7 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
>  	if (temp != hotplug)
>  		return -ENODEV;
>  
> +	mutex_lock(&pci_hp_mutex);
>  	spin_lock(&pci_hotplug_slot_list_lock);
>  	list_del(&hotplug->slot_list);
>  	spin_unlock(&pci_hotplug_slot_list_lock);
> @@ -645,6 +651,7 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
>  
>  	hotplug->release(hotplug);
>  	slot->hotplug = NULL;
> +	mutex_unlock(&pci_hp_mutex);
>  	pci_destroy_slot(slot);
>  
>  	return 0;
> diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
> index 0c6db03..1fffb27 100644
> --- a/drivers/pci/slot.c
> +++ b/drivers/pci/slot.c
> @@ -164,10 +164,10 @@ placeholder:
>  	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
>  		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
>  
> - out:
> +out:
>  	up_write(&pci_bus_sem);
>  	return slot;
> - err:
> +err:
>  	kfree(slot);
>  	slot = ERR_PTR(err);
>  	goto out;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


