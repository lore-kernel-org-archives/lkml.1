Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZLUB5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZLUB5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbZLUB5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:57:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:37007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349AbZLUB5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:57:38 -0500
Message-ID: <4B2ED5BD.7030504@kernel.org>
Date: Sun, 20 Dec 2009 17:56:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/12] pci: add pci_bridge_release_unused_res and	pci_bus_release_unused_bridge_res
 -v2
References: <4B2BE9DD.3040504@kernel.org> <4B2BEC1B.9090104@kernel.org>	 <alpine.LFD.2.00.0912181316190.3712@localhost.localdomain>	 <4B2C1DA9.4030907@kernel.org> <1261353843.26429.61.camel@dc7800.home>
In-Reply-To: <1261353843.26429.61.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Fri, 2009-12-18 at 16:26 -0800, Yinghai Lu wrote:
>> Subject: [PATCH 2/12] pci: add pci_bridge_release_unused_res and pci_bus_release_unused_bridge_res -v3
>>
>> so later we could use it to release small resource before pci assign unassign res
>>
>> -v2: change name to release_child_resources according to Jesse
>> -v3: according to Linus, move release_child_resources to resource.c
>>      also need to put the lock around them all to avoid recursive deep.
>>      (my test case only have one level that need to be released)
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  drivers/pci/setup-bus.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/ioport.h  |    1 
>>  kernel/resource.c       |   30 +++++++++++++++
>>  3 files changed, 125 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6/drivers/pci/setup-bus.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/pci/setup-bus.c
>> +++ linux-2.6/drivers/pci/setup-bus.c
>> @@ -209,7 +209,6 @@ static void pci_setup_bridge_mmio_pref(s
>>  		l = (region.start >> 16) & 0xfff0;
>>  		l |= region.end & 0xfff00000;
>>  		if (res->flags & IORESOURCE_MEM_64) {
>> -			pref_mem64 = 1;
>>  			bu = upper_32_bits(region.start);
>>  			lu = upper_32_bits(region.end);
>>  		}
>> @@ -608,6 +607,100 @@ void __ref pci_bus_assign_resources(cons
>>  }
>>  EXPORT_SYMBOL(pci_bus_assign_resources);
>>  
>> +static void pci_bridge_release_unused_res(struct pci_bus *bus,
>> +					  unsigned long type)
>> +{
>> +	int idx;
>> +	bool changed = false;
>> +	struct pci_dev *dev;
>> +	struct resource *r;
>> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
>> +				  IORESOURCE_PREFETCH;
>> +
>> +	/* for pci bridges res only */
>> +	dev = bus->self;
>> +	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_BRIDGE_RESOURCES + 3;
> 
> I *think* this magic "3" refers to the three possible windows supported
> by PCI bridges (I/O, memory, prefetchable memory).  I asked you before
> about using something more descriptive here; do you have any ideas?  I
> think even PCI_BRIDGE_RESOURCE_NUM (4) would be better, because I think
> that's the number of bridge windows we support (CardBus bridges have
> four windows, regular PCI bridges only have three).  For regular PCI
> bridges, that fourth window should be NULL, so it could easily be
> skipped here.

ok. will try to use PCI_BRIDGE_RESOURCE_NUM

> 
>> +	    idx++) {
>> +		r = &dev->resource[idx];
>> +		if ((r->flags & type_mask) != type)
>> +			continue;
>> +		if (!r->parent)
>> +			continue;
>> +		/*
>> +		 * if there are children under that, we should release them
>> +		 *  all
>> +		 */
>> +		release_child_resources(r);
> 
> Sorry for my ignorance here, but is it possible there's a driver using
> any of these child devices?

Good question!.

this function is only being called 
1. during pci_assign unassgined resources. during first...so no driver using those...
2. during loading pciehp device under that pcie port are assigned pci resource. at that time no resource are claimed for those devices.


> 
>> +		if (!release_resource(r)) {
>> +			dev_printk(KERN_DEBUG, &dev->dev,
>> +				 "resource %d %pR released\n", idx, r);
>> +			/* keep the old size */
>> +			r->end = resource_size(r) - 1;
>> +			r->start = 0;
>> +			r->flags = 0;
>> +			changed = true;
>> +		}
>> +	}
>> +
>> +	if (changed) {
>> +		if (type & IORESOURCE_PREFETCH) {
>> +			/* avoiding touch the one without PREF */
>> +			type = IORESOURCE_PREFETCH;
>> +		}
> 
> Again, it's probably perfectly obvious why we need to leave the
> non-prefetchable window untouched, but I don't know the reason.  Can you
> add a comment about why that's important?

only release related type.

for example: the device under that bridge, didn't get pref mmio correctly assigned, 
will only try to release bridge's pref mmio window instead of release mmio window at
same time.

> 
>> +		__pci_setup_bridge(bus, type);
>> +	}
>> +}
>> +
>> +/*
>> + * try to release pci bridge resources that is from leaf bridge,
>> + * so we can allocate big new one later
>> + * check:
>> + *    0: only release the bridge and only the bridge is leaf
>> + *    1: release all down side bridge for third shoot
>> + */
>> +static void __ref pci_bus_release_unused_bridge_res(struct pci_bus *bus,
>> +						    unsigned long type,
>> +						    int check_leaf)
>> +{
>> +	struct pci_dev *dev;
>> +	bool is_leaf_bridge = true;
>> +
>> +	list_for_each_entry(dev, &bus->devices, bus_list) {
>> +		struct pci_bus *b = dev->subordinate;
>> +		if (!b)
>> +			continue;
>> +
>> +		switch (dev->class >> 8) {
>> +		case PCI_CLASS_BRIDGE_CARDBUS:
>> +			is_leaf_bridge = false;
>> +			break;
>> +
>> +		case PCI_CLASS_BRIDGE_PCI:
>> +		default:
>> +			is_leaf_bridge = false;
>> +			if (!check_leaf)
>> +				pci_bus_release_unused_bridge_res(b, type,
>> +							 check_leaf);
>> +			break;
>> +		}
>> +	}
>> +
>> +	/* The root bus? */
>> +	if (!bus->self)
>> +		return;
>> +
>> +	switch (bus->self->class >> 8) {
>> +	case PCI_CLASS_BRIDGE_CARDBUS:
>> +		break;
>> +
>> +	case PCI_CLASS_BRIDGE_PCI:
> 
> Sorry for my ignorance again.  Why do we have to treat CardBus bridges
> so much differently?  I realize their windows are programmed a bit
> differently, but I don't know what the conceptual difference is as far
> as a bridge window being too small to accomodate all downstream devices.

i didn't have those cardbus stuff around, and have no way to test them.

and looks like some special code for card bus etc handling. so could leave other

guys to play them later.


thanks for closely reading through the code.

Yinghai
