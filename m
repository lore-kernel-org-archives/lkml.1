Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZGUUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZGUUPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbZGUUPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:15:51 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:1305 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbZGUUPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:15:50 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH v2 2/2] PCI Hotplug: acpiphp: get pci_bus from acpi handle correctly
Date: Tue, 21 Jul 2009 14:15:47 -0600
User-Agent: KMail/1.9.10
Cc: jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20090714204823.18933.40768.stgit@bob.kio> <200907201455.44959.bjorn.helgaas@hp.com> <20090721195755.GJ32046@ldl.fc.hp.com>
In-Reply-To: <20090721195755.GJ32046@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211415.47628.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009 01:57:55 pm Alex Chiang wrote:
> * Bjorn Helgaas <bjorn.helgaas@hp.com>:
> > On Tuesday 14 July 2009 02:53:33 pm Alex Chiang wrote:
> > > We cannot simply call acpi_get_pci_dev() on any random ACPI handle
> > > and hope that it works, because a PCI root bridge may not have
> > > an associated struct pci_dev.
> > > 
> > > This is allowed per the PCI specification, and is referred to as a
> > > non-materialized bridge.
> > > 
> > > So, depending on the type of PCI bridge that the handle points to,
> > > use the appropriate interface to return the struct pci_bus correctly.
> > > 
> > > Signed-off-by: Alex Chiang <achiang@hp.com>
> > > ---
> > > 
> > >  drivers/pci/hotplug/acpiphp_glue.c |   27 ++++++++++++++++-----------
> > >  1 files changed, 16 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> > > index 0cb0f83..fa4658b 100644
> > > --- a/drivers/pci/hotplug/acpiphp_glue.c
> > > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> > > @@ -62,6 +62,21 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus);
> > >  static void acpiphp_set_hpp_values(acpi_handle handle, struct pci_bus *bus);
> > >  static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
> > >  
> > > +static struct pci_bus *pci_bus_from_handle(acpi_handle handle)
> > > +{
> > > +	struct pci_bus *pbus;
> > > +
> > > +	if (acpi_is_root_bridge(handle)) {
> > > +		struct acpi_pci_root *root = acpi_pci_find_root(handle);
> > > +		pbus = root->bus;
> > > +	} else {
> > > +		struct pci_dev *pdev = acpi_get_pci_dev(handle);
> > > +		pbus = pdev->subordinate;
> > > +		pci_dev_put(pdev);
> > > +	}
> > > +	return pbus;
> > 
> > I worry that acpi_is_root_bridge() merely checks the device IDs of
> > "handle", which isn't quite the same as checking whether the pci_root
> > driver has claimed "handle".
> 
> Hm, I understand this concern in a theoretical sense, but could
> you explain more of what you're thinking about, and give me a
> concrete example of something that might go wrong here?

My concern is only theoretical -- I could imagine a PNP0A03 device
in the namespace (so acpi_is_root_bridge() is true) that has not been
claimed by the pci_root driver (so acpi_pci_find_root() returns NULL).

I don't think this will happen in practice because pci_root can't be
a module, but it's easier to analyze with just one check, since you
can learn everything you need from acpi_pci_find_root() without also
depending on acpi_is_root_bridge().

Bjorn
