Return-Path: <linux-kernel-owner+w=401wt.eu-S1765973AbYDPRLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765973AbYDPRLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbYDPRLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:11:30 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:16542 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYDPRL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:11:29 -0400
Date: Wed, 16 Apr 2008 11:11:27 -0600
From: Alex Chiang <achiang@hp.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
Message-ID: <20080416171127.GA18290@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Badari Pulavarty <pbadari@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <1207331616.5916.15.camel@badari-desktop> <20080404180518.GA12642@ldl.fc.hp.com> <1207340371.5916.23.camel@badari-desktop> <20080404224227.GA31436@ldl.fc.hp.com> <1207352128.5916.26.camel@badari-desktop> <20080407234255.GA22514@ldl.fc.hp.com> <20080416031712.GB3333@ldl.fc.hp.com> <1208331916.6958.270.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208331916.6958.270.camel@pasglop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

* Benjamin Herrenschmidt <benh@kernel.crashing.org>:
> 
> On Tue, 2008-04-15 at 21:17 -0600, Alex Chiang wrote:
> > 
> > Could you take a look at this patch and tell me what I'm doing
> > wrong?
> 
> Hrm, I'll have a look but I'd need some context first... This is to fix
> a problem introduced by another serie of patches ? Can you give me some
> pointers here ?

Thanks for taking a look. The patch series that got accepted into
-mm is here:

	http://lkml.org/lkml/2008/3/25/228

There have been several fixes on top of that series. I'm not sure
what the canonical way to refer to -mm patches is, but if you
navigate to this URL:

	http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm2/patch-list

You'll also need to apply:

	pci-hotplug-introduce-pci_slot-fix.patch
	pci-hotplug-introduce-pci_slot-fix-fix.patch
	pci-hotplug-introduce-pci_slot-fix-2.patch
	pci-hotplug-introduce-pci_slot-fix-99.patch
	pci-hotplug-introduce-pci_slot-fix-3.patch
	pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
	drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch

[wow, that's bad on me :( ]


> The pSeries PCI stuff can be tricky so I'll need some time tomorrow to
> context switch and remind myself of everything involved :-) So I'd like
> to make sure by that time, I have all the elements.

The basic idea, which I keep botching on pSeries, is that when we
make a call to pci_hp_register, we now need to pass it:

pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)

I am having trouble figuring out the slot_nr argument. Basically,
I want to get the devfn of the slot we're looking at.

Thanks again.

/ac

> Thanks,
> Ben.
> 
> > Thanks.
> > 
> > /ac
> > 
> > * Alex Chiang <achiang@hp.com>:
> > > Hi Badari,
> > > 
> > > > > > pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> > > > > > rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
> > > > > > rpaphp_register_slot registering slot:path[/pci@800000020000003/pci@2,4] index[22010003], name[U787E.001.AAA3015-P2-C1] pdomain[22010003] type[16]
> > > > > > Unable to handle kernel paging request for data at address 0x00000070
> > > > > 
> > > > > Hrm, this is a little more information, but still not quite
> > > > > enough. I'm going to take a stab in the dark and say I'm probably
> > > > > doing something wrong on this line, maybe dereferencing a pointer
> > > > > incorrectly:
> > > > > 
> > > > >         retval = pci_hp_register(php_slot, slot->bus,
> > > > > 				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
> > > > 
> > > > Sorry. I thought you knew this already. Disassembly clearly showed
> > > > that slot->dn->child is NULL. 
> > > > 
> > > > I confirmed it by adding printk also.
> > > 
> > > This patch is a complete guess on my part (since I've not been
> > > able to understand pseries architecture) but I think it should
> > > fix your issue.
> > > 
> > > Can you give it a try and let me know? It applies on top of the
> > > -mm tree that includes my physical pci_slot series.
> > > 
> > > Also, I'm hoping Linas will speak up and let me know what the
> > > real answer might be. ;)
> > > 
> > > Thanks.
> > > 
> > > /ac
> > > 
> > > From: Alex Chiang <achiang@hp.com>
> > > Subject: rpaphp: correctly call pci_hp_register for empty PCI slots
> > > 
> > > Unpopulated device_node slots do not have children, and
> > > attempting to dereference them will result in a panic.
> > > 
> > > Instead, attempt to derive the PCI slot number from the bus
> > > itself, and failing that, default to 0.
> > > 
> > > Signed-off-by: Alex Chiang <achiang@hp.com>
> > > ---
> > > diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
> > > index 0d4cfc7..91ce6a6 100644
> > > --- a/drivers/pci/hotplug/rpaphp_slot.c
> > > +++ b/drivers/pci/hotplug/rpaphp_slot.c
> > > @@ -121,6 +121,7 @@ int rpaphp_register_slot(struct slot *slot)
> > >  {
> > >  	struct hotplug_slot *php_slot = slot->hotplug_slot;
> > >  	int retval;
> > > +	int slot_nr;
> > >  
> > >  	dbg("%s registering slot:path[%s] index[%x], name[%s] pdomain[%x] type[%d]\n", 
> > >  		__FUNCTION__, slot->dn->full_name, slot->index, slot->name, 
> > > @@ -132,8 +133,11 @@ int rpaphp_register_slot(struct slot *slot)
> > >  		return -EAGAIN;
> > >  	}	
> > >  
> > > -	retval = pci_hp_register(php_slot, slot->bus,
> > > -				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
> > > +	if (slot->bus->self)
> > > +		slot_nr = PCI_SLOT(slot->bus->self->devfn);
> > > +	else
> > > +		slot_nr = 0;
> > > +	retval = pci_hp_register(php_slot, slot->bus, slot_nr);
> > >  	if (retval) {
> > >  		err("pci_hp_register failed with error %d\n", retval);
> > >  		return retval;
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > > 
> 
