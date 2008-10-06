Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYJFOpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYJFOpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYJFOpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:45:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53922 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYJFOph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:45:37 -0400
Date: Mon, 6 Oct 2008 08:45:34 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v4 02/15] PCI Hotplug: serialize pci_hp_register/deregister
Message-ID: <20081006144534.GD25780@parisc-linux.org>
References: <20081003230125.9989.31145.stgit@bob.kio> <20081003231737.9989.94126.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003231737.9989.94126.stgit@bob.kio>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 05:17:37PM -0600, Alex Chiang wrote:
> Add explicit locking to pci_hp_register/deregister. For a given pci_slot,
> we want to make sure that the pci_slot->hotplug pointer isn't being
> changed from underneath us.

I'm torn between saying this goes too far and this doesn't go far
enough.  If pci_hp_register() and pci_hp_deregister() can race against
each other, then I don't like the way we grab, release, grab, release
the pci_hotplug_slot_list_lock in pci_hp_deregister()/get_slot_from_name().
I think it would be smarter to grab the pci_hotplug_slot_list_lock
before calling get_slot_from_name() and release it after the list_del().

Mind you, I can't see a race there, but I'm also not at my best today
and it's possible there's one there I can't see.

As it currently stands, I don't think it needs to be a mutex -- do we do
anything sleeping under it?

Another part of me says "Just slap a mutex around both functions and
have done with it".

So, in summary, more eyes on this please.  I don't think I can do a good
job today at spotting races.

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

Gratuitous whitespace change?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
