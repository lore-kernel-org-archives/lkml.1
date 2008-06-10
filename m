Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYFJReh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYFJReh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 13:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbYFJReO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 13:34:14 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33012 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbYFJReL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:34:11 -0400
Date: Tue, 10 Jun 2008 11:34:08 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4, v14] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080610173408.GE25295@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	jbarnes@virtuousgeek.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
	pbadari@us.ibm.com, linux-pci@vger.kernel.org,
	pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080604200829.GC379@ldl.fc.hp.com> <484CE515.4030205@jp.fujitsu.com> <20080609221108.GA16588@ldl.fc.hp.com> <484DEF46.7080106@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484DEF46.7080106@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
> > * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> >> I tried your patches and I have a comment (question) about the behavior.
> >>
> >> To emulate the (broken?) platform that assigns the same name to multiple
> >> slots, I made a debug patch for pciehp driver to assign same name ('1000')
> >> to all slots (my environment has two PCIe slots). With this patch, I
> >> noticed that the behavior or pci_hp_register() (or pci_create_slot())
> >> varies depending on whether pci_slot driver is loaded or not. See below.
> >>
> >> (a) With pci_slot driver loaded
> >>    I got the following error message when I loaded pciehp driver.
> >>
> >>        pciehp: pci_hp_register failed with error -17
> >>        pciehp: Failed to register slot because of name collision. Try
> >>        'pciehp_slot_with_bus' module option.
> >>        pciehp: pciehp: slot initialization failed
> >>      (b) Without pci_slot driver loaded
> >>    I got the kernel stack dump and error messages when I loaded pciehp
> >>    driver.
> >>
> >> 	kobject_add_internal failed for 1000 with -EEXIST, don't try to
> >> 	register things with the same name in the same directory.
> >>
> >> 	Call Trace:
> >> 	 [<a000000100015180>] show_stack+0x40/0xa0
> >> 	                                sp=e0000040a086fb80 bsp=e0000040a0861158
> >> 	 [<a000000100015210>] dump_stack+0x30/0x60
> >>                                sp=e0000040a086fd50 bsp=e0000040a0861140
> >> 	 [<a0000001003b3910>] kobject_add_internal+0x330/0x400
> >> 	                                sp=e0000040a086fd50 bsp=e0000040a0861100
> >> 	 [<a0000001003b3bd0>] kobject_add_varg+0x90/0xc0
> >> 	                                sp=e0000040a086fd50 bsp=e0000040a08610c8
> >> 	 [<a0000001003b3c90>] kobject_init_and_add+0x90/0xc0
> >> 	                                sp=e0000040a086fd50 bsp=e0000040a0861068
> >> 	 [<a0000001003d69b0>] pci_create_slot+0x150/0x260
> >> 	                                sp=e0000040a086fd80 bsp=e0000040a0861030
> >> 	 [<a000000200b71870>] pci_hp_register+0x130/0x880 [pci_hotplug]
> >> 	                                sp=e0000040a086fd80 bsp=e0000040a0860ff0
> >> 	 [<a000000200ec1a60>] pciehp_probe+0x720/0xca0 [pciehp]
> >>
> >> 	(snip...)
> >>
> >> 	Unable to register kobject 1000
> >> 	pciehp: pci_hp_register failed with error -17
> >> 	pciehp: Failed to register slot because of name collision. Try  
> >> 	'pciehp_slot_with_bus' module option.
> >> 	pciehp: pciehp: slot initialization failed
> >>
> >> Could you tell me why that difference happen? And my expectation is
> >> the result should be (a) above regardless of whether pci_slot driver
> >> is loaded or not.
> > 
> > The difference was because in (a), pci_slot created the slots and
> > when pciehp tried to register them, the pci slot infrastructure
> > simply refcounted them and returned, but did not try to
> > re-register the kobjects with the kobj core.
> > 
> > In (b), the pci hotplug core allowed you to create multiple slots
> > with the same name, and called pci_create_slot() multiple times.
> > This time, since you were trying to create new slot objects, we
> > did not refcount them; we actually did a kzalloc *and* tried to
> > register them with the kobject core, which is why we got that
> > stack trace.
> > 
> > I read your patch (a86161b3134465f) in closer detail and decided
> > that it can work without problems with my patch series. 
> > 
> > 	- Your patch will keep track of hotplug slots and
> > 	  disallow multiple hotplug slots with the same name
> > 
> > 	- the PCI slot infrastructure will still allow multiple
> > 	  callers of pci_create_slot() to succeed by refcounting
> > 	  identical slots
> > 
> > This is the correct behavior to allow pciehp and pci_slot to
> > coexist because pci_slot is not trying to register a hotplug
> > handler or do any other hotplug operations.
> > 
> 
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

I apologize, I did not explain well enough. Let me try again.

After reading through your patch a86161b3134465f, I agree that we
should keep the functionality and the code. The refreshed patch
series I sent out yesterday (v15) includes your commit.

Here is the fully patched version of pci_hp_register, after
applying all 3 of my patches:

int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
{
        int result;
        struct pci_slot *pci_slot;
        struct hotplug_slot *tmp;

        if (slot == NULL)
                return -ENODEV;
        if ((slot->info == NULL) || (slot->ops == NULL))
                return -EINVAL;
        if (slot->release == NULL) {
                dbg("Why are you trying to register a hotplug slot "
                    "without a proper release function?\n");
                return -EINVAL;
        }

        /* Check if we have already registered a slot with the same name. */
        tmp = get_slot_from_name(slot->name);
        if (tmp)
                return -EEXIST;

        /*
         * No problems if we call this interface from both ACPI_PCI_SLOT
         * driver and call it here again. If we've already created the
         * pci_slot, the interface will simply bump the refcount.
         */
        pci_slot = pci_create_slot(bus, slot_nr, slot->name);

	[...]

Note how we're checking get_slot_from_name. That should prevent
your scenario (b) that you describe above.

Maybe the diff was confusing, but I am definitely not removing
your code. I'm simply adding on top of a86161b3134465f, and not
removing it.

> I made a below patch to prevent (b), please take a look. And could you
> please consider merging it to "[PATCH 2/3] Introduce pci_slot" in your
> latest series.

Ok, now this is very confusing to me. Why is this patch so
different from a86161b3134465f?

Are you saying the call to get_slot_from_name() is no longer
sufficient?

Thanks,

/ac

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
