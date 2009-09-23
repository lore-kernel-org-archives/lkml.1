Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZIWFaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZIWFaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 01:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZIWFaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 01:30:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:32824 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZIWFaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 01:30:22 -0400
Subject: Re: [PATCH 3/3 pci#linux-next] pccard: configure CLS on attach
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
       Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-pci@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Axel Birndt <towerlexa@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <4AB88C28.8070602@kernel.org>
References: <4A4EE3E9.7090205@kernel.org>
	 <20090917103131.55eca691@jbarnes-g45>  <4AB88C28.8070602@kernel.org>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 15:28:45 +1000
Message-Id: <1253683726.7103.285.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 17:34 +0900, Tejun Heo wrote:
> For non hotplug PCI devices, the system firmware usually configures
> CLS correctly.  For pccard devices system firmware can't do it and
> Linux PCI layer doesn't do it either.  Unfortunately this leads to
> poor performance for certain devices (sata_sil).  Unless MWI, which
> requires separate configuration, is to be used, CLS doesn't affect
> correctness, so the configuration should be harmless.

That isn't entirely true. We had some errata from some AMCC SoCs
telling us to filter out CLS because devices would use Memory
Read Multiple unless it's set to 0 and they have a bug with it...

(I find it weird too, MRM shouldn't relate to CLS ... I strongly suspect
they were thinking about Memory Read Line).

No objection to the patch though, I don't see a problem in setting
it properly on Cardbus, and for those bogus SoCs we actually filter
out the write at the low level config space access level afaik.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Ben.

> This patch makes pci_set_cacheline_size() always built and export it
> and make pccard call it during attach.
> 
> Please note that some other PCI hotplug drivers (shpchp and pciehp)
> also configure CLS on hotplug.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Daniel Ritz <daniel.ritz@gmx.ch>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Greg KH <greg@kroah.com>
> Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Cc: Axel Birndt <towerlexa@gmx.de>
> ---
>  drivers/pci/pci.c        |   39 +++++++++++++++++++--------------------
>  drivers/pcmcia/cardbus.c |   23 +++++++++++++++--------
>  include/linux/pci.h      |    1 +
>  3 files changed, 35 insertions(+), 28 deletions(-)
> 
> Index: work/drivers/pcmcia/cardbus.c
> ===================================================================
> --- work.orig/drivers/pcmcia/cardbus.c
> +++ work/drivers/pcmcia/cardbus.c
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
> @@ -228,7 +235,7 @@ int __ref cb_alloc(struct pcmcia_socket
>  	 */
>  	pci_bus_size_bridges(bus);
>  	pci_bus_assign_resources(bus);
> -	cardbus_assign_irqs(bus, s->pci_irq);
> +	cardbus_config_irq_and_cls(bus, s->pci_irq);
> 
>  	/* socket specific tune function */
>  	if (s->tune_bridge)
> Index: work/drivers/pci/pci.c
> ===================================================================
> --- work.orig/drivers/pci/pci.c
> +++ work/drivers/pci/pci.c
> @@ -1871,23 +1871,6 @@ void pci_clear_master(struct pci_dev *de
>  	__pci_set_master(dev, false);
>  }
> 
> -#ifdef PCI_DISABLE_MWI
> -int pci_set_mwi(struct pci_dev *dev)
> -{
> -	return 0;
> -}
> -
> -int pci_try_set_mwi(struct pci_dev *dev)
> -{
> -	return 0;
> -}
> -
> -void pci_clear_mwi(struct pci_dev *dev)
> -{
> -}
> -
> -#else
> -
>  /**
>   * pci_set_cacheline_size - ensure the CACHE_LINE_SIZE register is programmed
>   * @dev: the PCI device for which MWI is to be enabled
> @@ -1898,13 +1881,12 @@ void pci_clear_mwi(struct pci_dev *dev)
>   *
>   * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
>   */
> -static int
> -pci_set_cacheline_size(struct pci_dev *dev)
> +int pci_set_cacheline_size(struct pci_dev *dev)
>  {
>  	u8 cacheline_size;
> 
>  	if (!pci_cache_line_size)
> -		return -EINVAL;		/* The system doesn't support MWI. */
> +		return -EINVAL;
> 
>  	/* Validate current setting: the PCI_CACHE_LINE_SIZE must be
>  	   equal to or multiple of the right value. */
> @@ -1926,6 +1908,23 @@ pci_set_cacheline_size(struct pci_dev *d
>  	return -EINVAL;
>  }
> 
> +#ifdef PCI_DISABLE_MWI
> +int pci_set_mwi(struct pci_dev *dev)
> +{
> +	return 0;
> +}
> +
> +int pci_try_set_mwi(struct pci_dev *dev)
> +{
> +	return 0;
> +}
> +
> +void pci_clear_mwi(struct pci_dev *dev)
> +{
> +}
> +
> +#else
> +
>  /**
>   * pci_set_mwi - enables memory-write-invalidate PCI transaction
>   * @dev: the PCI device for which MWI is enabled
> Index: work/include/linux/pci.h
> ===================================================================
> --- work.orig/include/linux/pci.h
> +++ work/include/linux/pci.h
> @@ -701,6 +701,7 @@ void pci_disable_device(struct pci_dev *
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

