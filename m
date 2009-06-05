Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbZFEQAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbZFEQAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZFEP7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:59:53 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:8676 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZFEP7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:59:52 -0400
Date: Fri, 5 Jun 2009 09:59:54 -0600
From: Alex Chiang <achiang@hp.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 07/11] ACPI: acpi_pci_unbind should clean up
	properly after acpi_pci_bind
Message-ID: <20090605155954.GA11891@ldl.fc.hp.com>
References: <20090604054504.18802.21690.stgit@bob.kio> <4A2788FA.2050606@jp.fujitsu.com> <20090604233521.GA12900@ethanol> <200906050949.02097.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906050949.02097.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bjorn Helgaas <bjorn.helgaas@hp.com>:
> On Thursday 04 June 2009 05:35:21 pm Alex Chiang wrote:
> > * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > >
> > > I have a concern about this change.
> > >
> > > The acpi_pci_irq_del_prt() against dev->bus removes not only
> > > the _PRT entries for PCI function corresponding to specified
> > > acpi_device, but also other _PRT entries for working PCI
> > > devices/functions on the same bus. As a result, interrupt
> > > initialization for those PCI functions would no longer work
> > > properly after that.
> > >
> > > So I think we should not call acpi_pci_irq_del_prt() against
> > > dev->bus.
> > 
> > Thanks for the review. I agree with you.
> 
> I agree that this respun version makes things more the way they were,
> so in that sense, it should do no harm.  But I still have the niggling
> concern that .bind() adds _PRT info for non-bridges, and there's no
> corresponding removal.  There should be some path that makes this
> more symmetric.

The comment in acpi_pci_bind doesn't seem to know if you can even
have a _PRT for non-bridges. The spec (3.0b) says that _PRT is
required for all root bridges, but doesn't mention anything about
non-bridge devices.

My gut feeling is the way to cure the symmetry is to remove the
path in .bind() that adds _PRT for non-bridges, but I'm a little
hesitant to do that without knowing for sure.

I think for this patch, the Hippocratic approach is the right
one for now.

Thanks.

/ac
 
> > Here is a respun version of this patch.
> > 
> > From: Alex Chiang <achiang@hp.com>
> > 
> > ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind
> > 
> > In acpi_pci_bind, we set device->ops.bind and device->ops.unbind, but
> > never clear them out.
> > 
> > Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> > ---
> > diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
> > index 62cb383..c9cc650 100644
> > --- a/drivers/acpi/pci_bind.c
> > +++ b/drivers/acpi/pci_bind.c
> > @@ -109,11 +109,13 @@ static int acpi_pci_unbind(struct acpi_device *device)
> >  	struct pci_dev *dev;
> >  
> >  	dev = acpi_get_pci_dev(device->handle);
> > -	if (!dev)
> > +	if (!dev || !dev->subordinate)
> >  		return 0;
> >  
> > -	if (dev->subordinate)
> > -		acpi_pci_irq_del_prt(dev->subordinate);
> > +	acpi_pci_irq_del_prt(dev->subordinate);
> > +
> > +	device->ops.bind = NULL;
> > +	device->ops.unbind = NULL;
> >  
> >  	pci_dev_put(dev);
> >  	return 0;
> > 
> 
> 
