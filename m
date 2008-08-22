Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYHVTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYHVTyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 15:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbYHVTyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 15:54:00 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:17947 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYHVTx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 15:53:59 -0400
Date: Fri, 22 Aug 2008 13:53:58 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] PCI: create function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080822195358.GC20820@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, jbarnes@virtuousgeek.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080822162048.GA20820@ldl.fc.hp.com> <20080822182317.GW8318@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822182317.GW8318@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Fri, Aug 22, 2008 at 10:20:49AM -0600, Alex Chiang wrote:
> > This is a second attempt at creating some handy symlinks in
> > /sys/bus/pci/ between slots and devices.
> > 
> > It addresses the following concerns from last time:
> > 
> > 	- does not create superfluous 'device' link
> > 	- correctly adds and removes links after hotplug ops
> > 	- adds a bunch of documentation ;)
> > 
> > It does not address Willy's concerns about not needing the
> > functionN back-links.  I kinda thought they were useful, no one
> > else seemed to express an opinion...
> 
> I was just explaining why I didn't create them when I did my version of
> this patch.  I don't have an objection to adding them; they make logical
> sense.  The only concern might be the additional memory usage.

Yes, agree about the memory usage, although I wonder what the
actual overhead is.

Does anyone have numbers for how much it costs to create a new
symlink? I could try and figure this out but it will take a few
days (busy with other stuff).

> > +++ b/drivers/pci/pci-sysfs.c
> > @@ -716,6 +716,39 @@ int __attribute__ ((weak)) pcibios_add_platform_entries(struct pci_dev *dev)
> >  	return 0;
> >  }
> >  
> > +static void pci_remove_slot_links(struct pci_dev *dev)
> > +{
> > +	char func[10];
> > +	struct pci_slot *slot;
> > +
> > +	sysfs_remove_link(&dev->dev.kobj, "slot");
> > +	list_for_each_entry(slot, &dev->bus->slots, list) {
> > +		if (slot->number != PCI_SLOT(dev->devfn))
> > +			continue;
> > +		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
> > +		sysfs_remove_link(&slot->kobj, func);
> > +	}
> 
> Rather than this loop, why not not use dev->slot?
> 
> > +static int pci_create_slot_links(struct pci_dev *dev)
> > +{
> 
> Likewise in this function.

Good points, both.  I'll try that for v3.

> > +++ b/drivers/pci/slot.c
> > +static void remove_sysfs_files(struct pci_slot *slot)
> > +{
> > +	char func[10];
> > +	struct list_head *tmp;
> > +
> > +	list_for_each(tmp, &slot->bus->devices) {
> > +		struct pci_dev *dev = pci_dev_b(tmp);
> > +		if (PCI_SLOT(dev->devfn) != slot->number)
> > +			continue;
> > +		sysfs_remove_link(&dev->dev.kobj, "slot");
> > +
> > +		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
> > +		sysfs_remove_link(&slot->kobj, func);
> > +	}
> > +}
> 
> It feels a bit strange to be doing this in two different files.  I
> understand why -- you've got a slot to remove or you've got a device to
> remove, and in either case you have to get rid of the links.
> 
> Did you try putting all the logic in one of the two files and calling it
> from the other?

I did actually try that at first, albeit as a single function to
create links for either type of caller and another function to
remove links for either type of caller.

It was possible, but the looping I had to do was ugly.  I could
try again, and possible be smarter about detecting what was
passed in... or making the interface more complicated... or at
least just patching the same file and keeping the two different
flavours of add/remove links.

Thanks.

/ac

