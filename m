Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZFEFtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZFEFtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbZFEFtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:49:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:54652 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752610AbZFEFta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:49:30 -0400
X-Authenticated: #15509084
X-Provags-ID: V01U2FsdGVkX1+zn15oUcqz15VOfk6/8JeqeCrFJUk4843bReqLXr
	LN3uFMOZHoIsKO
Message-ID: <4A28B1E8.5090306@gmx.de>
Date: Fri, 05 Jun 2009 07:49:28 +0200
From: Axel Birndt <towerlexa@gmx.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Greg KH <greg@kroah.com>, Robert Hancock <hancockrwd@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Axel Birndt <towerlexa@gmx.de>
Subject: Re: [RFC PATCH] pccard: configure CLS on attach
References: <4A1BE904.8080302@kernel.org> <20090526142300.73d466d0@lxorguk.ukuu.org.uk> <4A1C7EF9.2030000@gmail.com> <4A1C8091.4050909@kernel.org> <4A1C86F5.1020603@jp.fujitsu.com> <4A1D40FD.5050102@kernel.org>
In-Reply-To: <4A1D40FD.5050102@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

i'm sorry, but i don't know how to apply this patch. I'am not a
developer, and so i don't  know what i should do.

If it make sense (in your opinion) i would try this, but maybe someone
could me help please? (of course its not a problem to do the three-step:
configure, make, make install... but after this i don't know to remove
the installed files)

So, Maybe someone could build me an deb-package for my Kubuntu-System???

---------------
Linux UBUNTUNB 2.6.24-24-generic #1 SMP Wed Apr 15 15:54:25 UTC 2009
i686 GNU/Linux

....
cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=8.04
DISTRIB_CODENAME=hardy
DISTRIB_DESCRIPTION="Ubuntu 8.04.2"
------------------

Thanks and regards
Axel



Tejun Heo schrieb:
> 
> THIS IS A RFC PATCH, SO NO SOB.  PLEASE DON'T APPLY YET.
> 
> towerlexa, can you please test this patch?

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
> 

