Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZCDVyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZCDVyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 16:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbZCDVyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 16:54:06 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:30366 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZCDVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 16:54:05 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #11550] pnp: Huge number of "io resource overlap" messages
Date: Wed, 4 Mar 2009 14:53:51 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Rene Herman <rene.herman@keyaccess.nl>
References: <200809091250.08620.elendil@planet.nl> <200809261540.31443.bjorn.helgaas@hp.com> <200903042117.18034.elendil@planet.nl>
In-Reply-To: <200903042117.18034.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041453.52771.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009 01:17:15 pm Frans Pop wrote:
> On Friday 26 September 2008, Bjorn Helgaas wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=11550
> 
> Sorry for having to revive this old thread. In November 2008 I reported
> that this issue had been solved for me as a result of 1f98757776ea, but I
> now find that was due to faulty testing. (I suspect that changing the BIOS
> setting that affects this issue on my Toshiba laptop only takes effect
> after a cold boot, not a normal reboot.)
> 
> The problem was that with the BIOS setting for "Device config" set to
> "Setup by OS", I get 78 messages like:
>     pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
>     pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.6 BAR 0 (0x0-0xff), disabling
> 
> If the BIOS setting is set to "All Devices", the problem does not occur.
> 
> The origin of these messages was bisected to:
> commit aee3ad815dd291a7193ab01da0f1a30c84d00061
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Fri Jun 27 16:56:57 2008 -0600
>     PNP: replace pnp_resource_table with dynamically allocated resources
> 
> Last analysis from Bjorn was:
> > The problem seems to be that Frans has some PCI devices that are not
> > configured by the BIOS, and their BARs contain zero.  A PNP quirk
> > checks for overlaps of PCI devices and PNP devices, and those zero-
> > valued BARs of course conflict with the PNP motherboard devices that
> > describe legacy hardware.
> >
> > Here's another approach based on section 3.5 of the PCI Firmware spec.
> > It says:
> >
> >   Since not all devices may be configured prior to the operating
> >   system handoff, the operating system needs to know whether a
> >   specific BAR register has been configured by firmware. The operating
> >   system makes the determination by checking the I/O Enable, and
> >   Memory Enable bits in the device's command register, and Expansion
> >   ROM BAR enable bits. If the enable bit is set, then the corresponding
> >   resource register has been configured.
> >
> > So instead of checking whether the BAR contains zero, the patch below
> > checks the I/O, Mem, and ROM BAR enable bits to determine whether a
> > BAR is enabled.
> 
> Below the then proposed patch from Bjorn, rediffed against 2.6.29-rc7.
> I've verified that the patch still solves the issue for me. Attached
> dmesg output for 2.6.29-rc7 without and with the patch.
> 
> Bjorn, could you please consider this patch for inclusion again?
> 
> Original thread: http://marc.info/?l=linux-kernel&m=122095745403793&w=4

Seems like we do need something, but this patch is kind of a klunky
approach, so I'd like to come up with a better proposal.  I don't
have any better ideas yet, though.

Bjorn
 
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index 32e8d88..e63f800 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -26,6 +26,28 @@
>  #include "pci.h"
>  
>  
> +int pci_resource_enabled(struct pci_dev *dev, int bar)
> +{
> +	u16 command = 0;
> +	u32 addr = 0;
> +
> +	pci_read_config_word(dev, PCI_COMMAND, &command);
> +
> +	if (pci_resource_flags(dev, bar) & IORESOURCE_IO)
> +		return command & PCI_COMMAND_IO;
> +
> +	if (command & PCI_COMMAND_MEMORY) {
> +		if (bar == PCI_ROM_RESOURCE) {
> +			pci_read_config_dword(dev, dev->rom_base_reg, &addr);
> +			return addr & PCI_ROM_ADDRESS_ENABLE;
> +		}
> +
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  void pci_update_resource(struct pci_dev *dev, int resno)
>  {
>  	struct pci_bus_region region;
> diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
> index 8473fe5..1f37988 100644
> --- a/drivers/pnp/quirks.c
> +++ b/drivers/pnp/quirks.c
> @@ -247,6 +247,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
>  		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
>  			unsigned long type;
>  
> +			if (!pci_resource_enabled(pdev, i))
> +				continue;
> +
>  			type = pci_resource_flags(pdev, i) &
>  					(IORESOURCE_IO | IORESOURCE_MEM);
>  			if (!type || pci_resource_len(pdev, i) == 0)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index c927ae9..9848ac2 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -870,6 +870,8 @@ static inline int pci_proc_domain(struct pci_bus *bus)
>  }
>  #endif /* CONFIG_PCI_DOMAINS */
>  
> +extern int pci_resource_enabled(struct pci_dev *dev, int bar);
> +
>  #else /* CONFIG_PCI is not enabled */
>  
>  /*
> @@ -1050,6 +1052,9 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
>  						unsigned int devfn)
>  { return NULL; }
>  
> +static inline int pci_resource_enabled(struct pci_dev *dev, int bar)
> +{ return 0; }
> +
>  #endif /* CONFIG_PCI */
>  
>  /* Include architecture-dependent settings and functions */
> 
> 


