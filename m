Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZCSRGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZCSRGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZCSRFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:05:52 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:33148 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZCSRFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:05:51 -0400
Date: Thu, 19 Mar 2009 11:05:48 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/12] PCI: Introduce pci_rescan_bus()
Message-ID: <20090319170548.GE8074@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318223956.887.57080.stgit@bob.kio> <20090319022735.f24b7329.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319022735.f24b7329.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 18 Mar 2009 16:39:56 -0600 Alex Chiang <achiang@hp.com> wrote:
> 
> > This API is used by the PCI core to rescan a bus and rediscover
> > newly added devices.
> > 
> > Over time, it is expected that the various PCI hotplug drivers
> > will migrate to this interface and away from the old
> > pci_do_scan_bus() interface.
> > 
> > ...
> >
> > @@ -1195,10 +1195,39 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
> >  EXPORT_SYMBOL(pci_scan_bus_parented);
> >  
> >  #ifdef CONFIG_HOTPLUG
> > +/**
> > + * pci_rescan_bus - scan a PCI bus for devices.
> > + * @bus: PCI bus to scan
> > + *
> > + * Scan a PCI bus and child buses for new devices, adds them,
> > + * and enables them.
> > + *
> > + * Returns the max number of subordinate bus discovered.
> > + */
> > +unsigned int __devinit pci_rescan_bus(struct pci_bus *bus)
> > +{
> > +	unsigned int max;
> > +	struct pci_dev *dev;
> > +
> > +	max = pci_scan_child_bus(bus);
> > +	list_for_each_entry(dev, &bus->devices, bus_list)
> > +		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
> > +		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
> > +			if (dev->subordinate)
> > +				pci_bus_size_bridges(dev->subordinate);
> > +
> > +	pci_bus_assign_resources(bus);
> > +	pci_enable_bridges(bus);
> > +	pci_bus_add_devices(bus);
> > +
> > +	return max;
> > +}
> > +
> >  EXPORT_SYMBOL(pci_add_new_bus);
> >  EXPORT_SYMBOL(pci_scan_slot);
> >  EXPORT_SYMBOL(pci_scan_bridge);
> >  EXPORT_SYMBOL_GPL(pci_scan_child_bus);
> > +EXPORT_SYMBOL_GPL(pci_rescan_bus);
> 
> uhm, is there any rationale for the seemingly-random mixup of export types
> in this interface?

History?

I've no clue why we're mixing EXPORT_SYMBOL and EXPORT_SYMBOL_GPL.

git-blame says that the mishmash existed pre-git.

For my new interface, I thought that EXPORT_SYMBOL_GPL would be
most appropriate, but maybe not?

What would you like me to do? Make them all the same?

Thanks.

/ac

