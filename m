Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab0APAVj (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 19:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892Ab0APAVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 19:21:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:49088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab0APAVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 19:21:38 -0500
Message-ID: <4B51063E.5070206@kernel.org>
Date: Fri, 15 Jan 2010 16:20:14 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 03/14] pci: add pci_bridge_release_unused_res and pci_bus_release_unused_bridge_res
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>	<1261522954-12591-4-git-send-email-yinghai@kernel.org> <20100115105305.400cda90@jbarnes-piketon>
In-Reply-To: <20100115105305.400cda90@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 10:53 AM, Jesse Barnes wrote:
> On Tue, 22 Dec 2009 15:02:23 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
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
>> +	dev = bus->self;
>> +	for (idx = PCI_BRIDGE_RESOURCES; idx <=
>> PCI_BRIDGE_RESOURCE_END;
>> +	     idx++) {
>> +		r = &dev->resource[idx];
>> +		if ((r->flags & type_mask) != type)
>> +			continue;
>> +		if (!r->parent)
>> +			continue;
>> +		/*
>> +		 * if there are children under that, we should
>> release them
>> +		 *  all
>> +		 */
>> +		release_child_resources(r);
>> +		if (!release_resource(r)) {
>> +			dev_printk(KERN_DEBUG, &dev->dev,
>> +				 "resource %d %pR released\n", idx,
>> r);
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
>> +		__pci_setup_bridge(bus, type);
>> +	}
>> +}
> 
> Isn't this freeing resources regardless of whether there are children?
> If so, shouldn't it just be called pci_bridge_release_resources?
> 
ok
>> +
>> +/*
>> + * try to release pci bridge resources that is from leaf bridge,
>> + * so we can allocate big new one later
>> + * check:
>> + *    0: only release the bridge and only the bridge is leaf
>> + *    1: release all down side bridge for third shoot
>> + */
>> +static void __ref pci_bus_release_unused_bridge_res(struct pci_bus
>> *bus,
>> +						    unsigned long
>> type,
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
>> +				pci_bus_release_unused_bridge_res(b,
>> type,
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
>> +	default:
>> +		if ((check_leaf && is_leaf_bridge) || !check_leaf)
>> +			pci_bridge_release_unused_res(bus, type);
>> +		break;
>> +	}
>> +}
> 
> Naming comment applies here too.  I'd also rather see the "check_leaf"
> flag be an enum, that makes the callers more self documenting.  The
> enums should probably be called "leaf_only" and "whole_subtree" or
> similar , since the function will only release the resources of a leaf
> bridge when the former is passed, while the whole bridge and its
> subtree will be released in the latter case.
ok

YH
