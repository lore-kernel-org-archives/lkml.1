Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbYHSS3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbYHSS3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbYHSS3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:29:21 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:16529 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbYHSS3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:29:20 -0400
Date: Tue, 19 Aug 2008 12:29:19 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: create device, function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080819182919.GC18842@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, jbarnes@virtuousgeek.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080818202100.GE23155@ldl.fc.hp.com> <20080819163755.GB8318@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080819163755.GB8318@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Mon, Aug 18, 2008 at 02:21:00PM -0600, Alex Chiang wrote:
> > The original form of this patch was written by Matthew Wilcox,
> > but did not have links from the sysfs slots/ directory pointing
> > back at devices and functions.
> 
> I think the reason I didn't bother was that you could already get this
> information from the 'address' file.  ie:
> 
> $ ls -l /sys/bus/pci/devices/`cat /sys/bus/pci/slots/3/address`*
> 
> But I don't think we had a way to go from a device to the slot it's in,
> without searching through all the slots for matching address.

Hm, ok. So I guess the tradeoff here is convenience vs. memory.

If others are opposed to a 'functionN' backlink, I don't have
very strong feelings, but I thought it was useful.

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
> > +	sysfs_remove_link(&slot->kobj, "device");
> > +}
> > +
> > +static int create_sysfs_files(struct pci_slot *slot)
> > +{
> > +	int result, lastdev = -1;
> > +	char func[10];
> > +	struct list_head *tmp;
> > +
> > +	list_for_each(tmp, &slot->bus->devices) {
> > +		struct pci_dev *dev = pci_dev_b(tmp);
> > +		if (PCI_SLOT(dev->devfn) != slot->number)
> > +			continue;
> 
> Why not use pci_get_slot()?

This will deadlock, because we're already holding pci_bus_sem as
a writer, taken during pci_create_slot():

	down_write(&pci_bus_sem);

Also, it doesn't really help us get rid of a loop, since
slot->number doesn't encode the entire devfn; it only has the
device number. So we would still have to do something like this:

	for (i = 0; i < 8; i++) {
		/* XXX: deadlock! */
		dev = pci_get_slot(slot->bus, PCI_DEVFN(slot->number, i));
		if (!dev)
			break;

Of course, it is entirely possible that I misconstrued what you
were trying to suggest, so if I missed your point, please let me
know. :)

Thanks.

/ac

> 
> > +		result = sysfs_create_link(&dev->dev.kobj, &slot->kobj, "slot");
> > +		if (result)
> > +			goto fail;
> > +
> > +		if (PCI_SLOT(dev->devfn) != lastdev) {
> > +			lastdev = PCI_SLOT(dev->devfn);
> > +			result = sysfs_create_link(&slot->kobj,
> > +						   &dev->dev.kobj,
> > +						   "device");
> > +			if (result)
> > +				goto fail;
> > +		}
> > +
> > +		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
> > +		result = sysfs_create_link(&slot->kobj, &dev->dev.kobj, func);
> > +		if (result)
> > +			goto fail;
> > +	}
> > +
> > +	return 0;
> > +
> > +fail:
> > +	remove_sysfs_files(slot);
> > +	return result;
> > +}
> > +
> >  static void pci_slot_release(struct kobject *kobj)
> >  {
> >  	struct pci_slot *slot = to_pci_slot(kobj);
> > @@ -54,6 +108,8 @@ static void pci_slot_release(struct kobject *kobj)
> >  	pr_debug("%s: releasing pci_slot on %x:%d\n", __func__,
> >  		 slot->bus->number, slot->number);
> >  
> > +	remove_sysfs_files(slot);
> > +
> >  	list_del(&slot->list);
> >  
> >  	kfree(slot);
> > @@ -150,6 +206,8 @@ placeholder:
> >  	INIT_LIST_HEAD(&slot->list);
> >  	list_add(&slot->list, &parent->slots);
> >  
> > +	create_sysfs_files(slot);
> > +
> >  	/* Don't care if debug printk has a -1 for slot_nr */
> >  	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
> >  		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> 
