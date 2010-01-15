Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab0AOSxO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588Ab0AOSxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:53:12 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:33389 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754052Ab0AOSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:53:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rr0I3IZ/OuJudnw0ml3zgd1ESZduFBVVy5NXxCGaCwJUxExYXRfXjtGkCAsbDyOYyDX6II2w1Bqndy3CNSoaqwXGGxQX7CHcZeXYc7D1qJSh/0GJp6ZxEYBlnDYseP5i;
Date: Fri, 15 Jan 2010 10:53:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 03/14] pci: add pci_bridge_release_unused_res and
 pci_bus_release_unused_bridge_res
Message-ID: <20100115105305.400cda90@jbarnes-piketon>
In-Reply-To: <1261522954-12591-4-git-send-email-yinghai@kernel.org>
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
	<1261522954-12591-4-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009 15:02:23 -0800
Yinghai Lu <yinghai@kernel.org> wrote:
> +static void pci_bridge_release_unused_res(struct pci_bus *bus,
> +					  unsigned long type)
> +{
> +	int idx;
> +	bool changed = false;
> +	struct pci_dev *dev;
> +	struct resource *r;
> +	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
> +				  IORESOURCE_PREFETCH;
> +
> +	dev = bus->self;
> +	for (idx = PCI_BRIDGE_RESOURCES; idx <=
> PCI_BRIDGE_RESOURCE_END;
> +	     idx++) {
> +		r = &dev->resource[idx];
> +		if ((r->flags & type_mask) != type)
> +			continue;
> +		if (!r->parent)
> +			continue;
> +		/*
> +		 * if there are children under that, we should
> release them
> +		 *  all
> +		 */
> +		release_child_resources(r);
> +		if (!release_resource(r)) {
> +			dev_printk(KERN_DEBUG, &dev->dev,
> +				 "resource %d %pR released\n", idx,
> r);
> +			/* keep the old size */
> +			r->end = resource_size(r) - 1;
> +			r->start = 0;
> +			r->flags = 0;
> +			changed = true;
> +		}
> +	}
> +
> +	if (changed) {
> +		if (type & IORESOURCE_PREFETCH) {
> +			/* avoiding touch the one without PREF */
> +			type = IORESOURCE_PREFETCH;
> +		}
> +		__pci_setup_bridge(bus, type);
> +	}
> +}

Isn't this freeing resources regardless of whether there are children?
If so, shouldn't it just be called pci_bridge_release_resources?

> +
> +/*
> + * try to release pci bridge resources that is from leaf bridge,
> + * so we can allocate big new one later
> + * check:
> + *    0: only release the bridge and only the bridge is leaf
> + *    1: release all down side bridge for third shoot
> + */
> +static void __ref pci_bus_release_unused_bridge_res(struct pci_bus
> *bus,
> +						    unsigned long
> type,
> +						    int check_leaf)
> +{
> +	struct pci_dev *dev;
> +	bool is_leaf_bridge = true;
> +
> +	list_for_each_entry(dev, &bus->devices, bus_list) {
> +		struct pci_bus *b = dev->subordinate;
> +		if (!b)
> +			continue;
> +
> +		switch (dev->class >> 8) {
> +		case PCI_CLASS_BRIDGE_CARDBUS:
> +			is_leaf_bridge = false;
> +			break;
> +
> +		case PCI_CLASS_BRIDGE_PCI:
> +		default:
> +			is_leaf_bridge = false;
> +			if (!check_leaf)
> +				pci_bus_release_unused_bridge_res(b,
> type,
> +							 check_leaf);
> +			break;
> +		}
> +	}
> +
> +	/* The root bus? */
> +	if (!bus->self)
> +		return;
> +
> +	switch (bus->self->class >> 8) {
> +	case PCI_CLASS_BRIDGE_CARDBUS:
> +		break;
> +
> +	case PCI_CLASS_BRIDGE_PCI:
> +	default:
> +		if ((check_leaf && is_leaf_bridge) || !check_leaf)
> +			pci_bridge_release_unused_res(bus, type);
> +		break;
> +	}
> +}

Naming comment applies here too.  I'd also rather see the "check_leaf"
flag be an enum, that makes the callers more self documenting.  The
enums should probably be called "leaf_only" and "whole_subtree" or
similar , since the function will only release the resources of a leaf
bridge when the former is passed, while the whole bridge and its
subtree will be released in the latter case.

This is starting to look a bit easier to follow though, thanks for your
patience so far.
-- 
Jesse Barnes, Intel Open Source Technology Center
