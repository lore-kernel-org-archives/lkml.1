Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbZE0ODh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbZE0ODh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762887AbZE0OD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:03:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39031 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761291AbZE0OD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:03:28 -0400
Date: Wed, 27 May 2009 08:03:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <greg@kroah.com>, Robert Hancock <hancockrwd@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, towerlexa@gmx.de,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC PATCH] pccard: configure CLS on attach
Message-ID: <20090527140328.GG5816@parisc-linux.org>
References: <4A1BE904.8080302@kernel.org> <20090526142300.73d466d0@lxorguk.ukuu.org.uk> <4A1C7EF9.2030000@gmail.com> <4A1C8091.4050909@kernel.org> <4A1C86F5.1020603@jp.fujitsu.com> <4A1D40FD.5050102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1D40FD.5050102@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:32:45PM +0900, Tejun Heo wrote:
> THIS IS A RFC PATCH, SO NO SOB.  PLEASE DON'T APPLY YET.

This breaks CONFIG_PPC64, fwiw.  We'll want to stub out
pci_set_cacheline_size() for the PCI_DISABLE_MWI case too.

I don't know what PPC machines have Cardbus slots, presumably some
Macs do.  I don't know whether firmware takes care of configuring the
Cacheline Size register for Cardbus hotplug or not.  So we may want to
include pci_set_cacheline_size() in the !MWI build, or not.  Ben, Paul?

> towerlexa, can you please test this patch?
> 
> Cc: Daniel Ritz <daniel.ritz@gmx.ch>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Greg KH <greg@kroah.com>
> Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Cc: towerlexa@gmx.de
> ---
>  drivers/pci/pci.c        |    3 +--
>  drivers/pcmcia/cardbus.c |   23 +++++++++++++++--------
>  include/linux/pci.h      |    1 +
>  3 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 1a91bf9..eafbe01 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1860,8 +1860,7 @@ u8 pci_cache_line_size = PCI_CACHE_LINE_BYTES / 4;
>   *
>   * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
>   */
> -static int
> -pci_set_cacheline_size(struct pci_dev *dev)
> +int pci_set_cacheline_size(struct pci_dev *dev)
>  {
>  	u8 cacheline_size;
>  
> diff --git a/drivers/pcmcia/cardbus.c b/drivers/pcmcia/cardbus.c
> index db77e1f..98789c0 100644
> --- a/drivers/pcmcia/cardbus.c
> +++ b/drivers/pcmcia/cardbus.c
> @@ -184,26 +184,33 @@ fail:
>      
>  =====================================================================*/
>  
> -/*
> - * Since there is only one interrupt available to CardBus
> - * devices, all devices downstream of this device must
> - * be using this IRQ.
> - */
> -static void cardbus_assign_irqs(struct pci_bus *bus, int irq)
> +static void cardbus_config_irq_and_cls(struct pci_bus *bus, int irq)
>  {
>  	struct pci_dev *dev;
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		u8 irq_pin;
>  
> +		/*
> +		 * Since there is only one interrupt available to
> +		 * CardBus devices, all devices downstream of this
> +		 * device must be using this IRQ.
> +		 */
>  		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &irq_pin);
>  		if (irq_pin) {
>  			dev->irq = irq;
>  			pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
>  		}
>  
> +		/*
> +		 * Some controllers transfer very slowly with 0 CLS.
> +		 * Configure it.  This may fail as CLS configuration
> +		 * is mandatory only for MWI.
> +		 */
> +		pci_set_cacheline_size(dev);
> +
>  		if (dev->subordinate)
> -			cardbus_assign_irqs(dev->subordinate, irq);
> +			cardbus_config_irq_and_cls(dev->subordinate, irq);
>  	}
>  }
>  
> @@ -228,7 +235,7 @@ int __ref cb_alloc(struct pcmcia_socket * s)
>  	 */
>  	pci_bus_size_bridges(bus);
>  	pci_bus_assign_resources(bus);
> -	cardbus_assign_irqs(bus, s->pci_irq);
> +	cardbus_config_irq_and_cls(bus, s->pci_irq);
>  
>  	/* socket specific tune function */
>  	if (s->tune_bridge)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 72698d8..e1a1aa6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -688,6 +688,7 @@ void pci_disable_device(struct pci_dev *dev);
>  void pci_set_master(struct pci_dev *dev);
>  void pci_clear_master(struct pci_dev *dev);
>  int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state);
> +int pci_set_cacheline_size(struct pci_dev *dev);
>  #define HAVE_PCI_SET_MWI
>  int __must_check pci_set_mwi(struct pci_dev *dev);
>  int pci_try_set_mwi(struct pci_dev *dev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
