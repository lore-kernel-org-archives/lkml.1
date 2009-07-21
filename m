Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZGUT6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZGUT6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZGUT55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:57:57 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:17961 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbZGUT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:57:56 -0400
Date: Tue, 21 Jul 2009 13:57:55 -0600
From: Alex Chiang <achiang@hp.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] PCI Hotplug: acpiphp: get pci_bus from acpi
	handle correctly
Message-ID: <20090721195755.GJ32046@ldl.fc.hp.com>
References: <20090714204823.18933.40768.stgit@bob.kio> <20090714205333.18933.73027.stgit@bob.kio> <200907201455.44959.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907201455.44959.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bjorn Helgaas <bjorn.helgaas@hp.com>:
> On Tuesday 14 July 2009 02:53:33 pm Alex Chiang wrote:
> > We cannot simply call acpi_get_pci_dev() on any random ACPI handle
> > and hope that it works, because a PCI root bridge may not have
> > an associated struct pci_dev.
> > 
> > This is allowed per the PCI specification, and is referred to as a
> > non-materialized bridge.
> > 
> > So, depending on the type of PCI bridge that the handle points to,
> > use the appropriate interface to return the struct pci_bus correctly.
> > 
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> > ---
> > 
> >  drivers/pci/hotplug/acpiphp_glue.c |   27 ++++++++++++++++-----------
> >  1 files changed, 16 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> > index 0cb0f83..fa4658b 100644
> > --- a/drivers/pci/hotplug/acpiphp_glue.c
> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -62,6 +62,21 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus);
> >  static void acpiphp_set_hpp_values(acpi_handle handle, struct pci_bus *bus);
> >  static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
> >  
> > +static struct pci_bus *pci_bus_from_handle(acpi_handle handle)
> > +{
> > +	struct pci_bus *pbus;
> > +
> > +	if (acpi_is_root_bridge(handle)) {
> > +		struct acpi_pci_root *root = acpi_pci_find_root(handle);
> > +		pbus = root->bus;
> > +	} else {
> > +		struct pci_dev *pdev = acpi_get_pci_dev(handle);
> > +		pbus = pdev->subordinate;
> > +		pci_dev_put(pdev);
> > +	}
> > +	return pbus;
> 
> I worry that acpi_is_root_bridge() merely checks the device IDs of
> "handle", which isn't quite the same as checking whether the pci_root
> driver has claimed "handle".

Hm, I understand this concern in a theoretical sense, but could
you explain more of what you're thinking about, and give me a
concrete example of something that might go wrong here?

> Are you confident that it's safe to move the pci_dev_put(), so it is
> released before configuring the bridge?

I'm confident that I'm not changing the lifetime assumptions in
acpiphp_configure_bridge(), as the old code didn't seem to care
either.

Commit d6aa484c (acpiphp: convert to acpi_get_pci_dev) changed
from pci_find_bus() to use acpi_get_pci_dev(), and pci_find_bus()
does not elevate any reference counts.

What I'm trying to fix here is that acpi_get_pci_dev() /might/
not work all the time, namely on machines that have both:

	a) hotpluggable root bridges
	b) non-materialized root bridges

> What do you think about something like this (even though the get/put
> is still a little clunky):
> 
> 	struct pci_dev *dev = NULL;
> 
> 	root = acpi_pci_find_root(handle);
> 	if (root)
> 		bus = root->bus;
> 	else {
> 		dev = acpi_get_pci_dev(handle);
> 		if (dev)
> 			bus = pdev->subordinate;
> 		else {
> 			err("cannot get PCI domain and bus number for bridge\n");
> 			return -EINVAL;
> 		}
> 	}
> 
> 	pci_bus_size_bridges(bus);
> 	...
> 	if (dev)
> 		pci_dev_put(dev);
> 	return 0;
 
This seems like a good approach too, but I'd like to understand
your concern about acpi_is_root_bridge() first.

Thanks for the review.

/ac

