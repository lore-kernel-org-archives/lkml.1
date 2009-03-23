Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbZCWPrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbZCWPrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZCWPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:46:56 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:8796 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZCWPqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:46:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #11550] pnp: Huge number of "io resource overlap" messages
Date: Mon, 23 Mar 2009 09:46:47 -0600
User-Agent: KMail/1.9.10
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Wilcox <matthew@wil.cx>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Rene Herman <rene.herman@keyaccess.nl>
References: <200809091250.08620.elendil@planet.nl> <200903041453.52771.bjorn.helgaas@hp.com> <20090319190751.0ded0c4b@hobbes.lan>
In-Reply-To: <20090319190751.0ded0c4b@hobbes.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903230946.48535.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 March 2009 08:07:51 pm Jesse Barnes wrote:
> On Wed, 4 Mar 2009 14:53:51 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Wednesday 04 March 2009 01:17:15 pm Frans Pop wrote:
> > > Original thread:
> > > http://marc.info/?l=linux-kernel&m=122095745403793&w=4
> > 
> > Seems like we do need something, but this patch is kind of a klunky
> > approach, so I'd like to come up with a better proposal.  I don't
> > have any better ideas yet, though.
> 
> Patch actually seems pretty reasonable to me, though like we discussed
> at kernel summit last year, there are places where a 0 resource is
> assumed to mean "not assigned".  And clearly we need to do something
> here...  Anyone else have better ideas than Bjorn's patch below?

IIRC, Linus complained that it was ugly and slow to do all those
config space reads, and I have to agree with him.  I'd like it
better if we had some sort of pci_dev "enabled" flag or if we could
make it so the pci_dev resources were invalid when the device is
disabled.

Bjorn

> > > diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> > > index 32e8d88..e63f800 100644
> > > --- a/drivers/pci/setup-res.c
> > > +++ b/drivers/pci/setup-res.c
> > > @@ -26,6 +26,28 @@
> > >  #include "pci.h"
> > >  
> > >  
> > > +int pci_resource_enabled(struct pci_dev *dev, int bar)
> > > +{
> > > +	u16 command = 0;
> > > +	u32 addr = 0;
> > > +
> > > +	pci_read_config_word(dev, PCI_COMMAND, &command);
> > > +
> > > +	if (pci_resource_flags(dev, bar) & IORESOURCE_IO)
> > > +		return command & PCI_COMMAND_IO;
> > > +
> > > +	if (command & PCI_COMMAND_MEMORY) {
> > > +		if (bar == PCI_ROM_RESOURCE) {
> > > +			pci_read_config_dword(dev,
> > > dev->rom_base_reg, &addr);
> > > +			return addr & PCI_ROM_ADDRESS_ENABLE;
> > > +		}
> > > +
> > > +		return 1;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  void pci_update_resource(struct pci_dev *dev, int resno)
> > >  {
> > >  	struct pci_bus_region region;
> > > diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> > > index 8473fe5..1f37988 100644
> > > --- a/drivers/pnp/quirks.c
> > > +++ b/drivers/pnp/quirks.c
> > > @@ -247,6 +247,9 @@ static void quirk_system_pci_resources(struct
> > > pnp_dev *dev) for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> > >  			unsigned long type;
> > >  
> > > +			if (!pci_resource_enabled(pdev, i))
> > > +				continue;
> > > +
> > >  			type = pci_resource_flags(pdev, i) &
> > >  					(IORESOURCE_IO |
> > > IORESOURCE_MEM); if (!type || pci_resource_len(pdev, i) == 0)
> > > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > > index c927ae9..9848ac2 100644
> > > --- a/include/linux/pci.h
> > > +++ b/include/linux/pci.h
> > > @@ -870,6 +870,8 @@ static inline int pci_proc_domain(struct
> > > pci_bus *bus) }
> > >  #endif /* CONFIG_PCI_DOMAINS */
> > >  
> > > +extern int pci_resource_enabled(struct pci_dev *dev, int bar);
> > > +
> > >  #else /* CONFIG_PCI is not enabled */
> > >  
> > >  /*
> > > @@ -1050,6 +1052,9 @@ static inline struct pci_dev
> > > *pci_get_bus_and_slot(unsigned int bus, unsigned int devfn)
> > >  { return NULL; }
> > >  
> > > +static inline int pci_resource_enabled(struct pci_dev *dev, int
> > > bar) +{ return 0; }
> > > +
> > >  #endif /* CONFIG_PCI */
> > >  
> > >  /* Include architecture-dependent settings and functions */
> > > 
> > > 
> > 
> > 
> > 
> 
> 


