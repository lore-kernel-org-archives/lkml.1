Return-Path: <linux-kernel-owner+w=401wt.eu-S932144Ab0AEV0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0AEV0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979Ab0AEV0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:26:41 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34153 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab0AEV0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:26:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2/12] PCI / PM: Propagate wake-up enable for PCIe devices too
Date: Tue, 5 Jan 2010 22:27:18 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <200912272057.10443.rjw@sisk.pl> <200912272100.33117.rjw@sisk.pl> <20100104154038.76a9eedf@jbarnes-piketon>
In-Reply-To: <20100104154038.76a9eedf@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001052227.18130.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Jesse Barnes wrote:
> On Sun, 27 Dec 2009 21:00:33 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Having read the PM part of the PCIe 2.0 specification more carefully
> > I think that it was a mistake to restrict the wake-up enable
> > propagation to non-PCIe devices, because if we do not request
> > control of the root ports' PME registers via OSC, PCIe PME is
> > supposed to be handled by the platform, just like the non-PCIe PME.
> > Even if we do that, the wake-up propagation is done to allow the
> > devices to wake up the system from sleep states which involves the
> > platform anyway, so it won't hurt.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  drivers/pci/pci-acpi.c |   10 ++--------
> >  1 file changed, 2 insertions(+), 8 deletions(-)
> > 
> > Index: linux-2.6/drivers/pci/pci-acpi.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pci-acpi.c
> > +++ linux-2.6/drivers/pci/pci-acpi.c
> > @@ -112,11 +112,7 @@ static bool acpi_pci_can_wakeup(struct p
> >  static void acpi_pci_propagate_wakeup_enable(struct pci_bus *bus,
> > bool enable) {
> >  	while (bus->parent) {
> > -		struct pci_dev *bridge = bus->self;
> > -		int ret;
> > -
> > -		ret = acpi_pm_device_sleep_wake(&bridge->dev,
> > enable);
> > -		if (!ret || pci_is_pcie(bridge))
> > +		if (!acpi_pm_device_sleep_wake(&bus->self->dev,
> > enable)) return;
> >  		bus = bus->parent;
> >  	}
> > @@ -131,9 +127,7 @@ static int acpi_pci_sleep_wake(struct pc
> >  	if (acpi_pci_can_wakeup(dev))
> >  		return acpi_pm_device_sleep_wake(&dev->dev, enable);
> >  
> > -	if (!pci_is_pcie(dev))
> > -		acpi_pci_propagate_wakeup_enable(dev->bus, enable);
> > -
> > +	acpi_pci_propagate_wakeup_enable(dev->bus, enable);
> >  	return 0;
> >  }
> 
> Seems ok to try it out, but as usual with this sort of thing, the real
> question is, "What does Windows do?", since wakeup enable ACPI support
> for PCIe devices is likely broken unless Windows uses it.

Well, that's in the Linus' tree already, so I guess we're going to learn. ;-)

Seriously, I think that Windows actually uses ACPI wake-up support for PCIe
devices.  On my Toshiba Portege R500 the BIOS doesn't even allow us to use
the native PCIe PME mechanism directly, so the patch is correct IMO.

Rafael
