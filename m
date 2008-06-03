Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbYFCT5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbYFCT5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 15:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbYFCT5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 15:57:25 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:35499 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbYFCT5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 15:57:24 -0400
Message-ID: <4845A217.3030701@keyaccess.nl>
Date: Tue, 03 Jun 2008 21:57:11 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 15/15] PNP: convert resource options to single linked
 list
References: <20080530224853.976744229@ldl.fc.hp.com> <20080530224934.357694359@ldl.fc.hp.com>
In-Reply-To: <20080530224934.357694359@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31-05-08 00:49, Bjorn Helgaas wrote:

> ISAPNP, PNPBIOS, and ACPI describe the "possible resource settings" of
> a device, i.e., the possibilities an OS bus driver has when it assigns
> I/O port, MMIO, and other resources to the device.
> 
> PNP used to maintain this "possible resource setting" information in
> one independent option structure and a list of dependent option
> structures for each device.  Each of these option structures had lists
> of I/O, memory, IRQ, and DMA resources, for example:
> 
>   dev
>     independent options
>       ind-io0  -> ind-io1  ...
>       ind-mem0 -> ind-mem1 ...
>       ...
>     dependent option set 0
>       dep0-io0  -> dep0-io1  ...
>       dep0-mem0 -> dep0-mem1 ...
>       ...
>     dependent option set 1
>       dep1-io0  -> dep1-io1  ...
>       dep1-mem0 -> dep1-mem1 ...
>       ...
>     ...
> 
> This data structure was designed for ISAPNP, where the OS configures
> device resource settings by writing directly to configuration
> registers.  The OS can write the registers in arbitrary order much
> like it writes PCI BARs.
> 
> However, for PNPBIOS and ACPI devices, the OS uses firmware interfaces
> that perform device configuration, and it is important to pass the
> desired settings to those interfaces in the correct order.  The OS
> learns the correct order by using firmware interfaces that return the
> "current resource settings" and "possible resource settings," but the
> option structures above doesn't store the ordering information.
> 
> This patch replaces the independent and dependent lists with a single
> list of options.  For example, a device might have possible resource
> settings like this:
> 
>   dev
>     options
>       ind-io0 -> dep0-io0 -> dep1->io0 -> ind-io1 ...


Just for the record -- due to an ISAPnP bug, ISAPnP doesn't actually at 
the moment deal with independents following dependents at all (it does 
not reset the option to independent upon seeing an _STAG_ENDDEP tag) and 
the rework actually fixes this bug. The ISAPnP spec does recommend that 
independents precede dependents, but does not guarantee.

Might be good to mention this in the log though? In the unlikely event 
that some piece of ISAPnP hardware out there actually changes behaviour 
(to "fixed" ...) that might be a hint in looking at it.

<snip>

> +#define PNP_OPTION_DEPENDENT		0x80000000
> +#define PNP_OPTION_SET_MASK		0xff
> +#define PNP_OPTION_SET_SHIFT		16
> +#define PNP_OPTION_PRIORITY_MASK	0xffff
> +#define PNP_OPTION_PRIORITY_SHIFT	0

I checked, and ISAPnP and PnPBIOS definitely limit the priority to 8-bit 
and ACPI seems to as well meaning the (only) reason for using 16 would 
be the RES_PRIORITY_INVALID value.

I have on the other hand not encountered text limiting the number of 
dependents sets to 255 nor do I believe the old code enforced this?

Yes, I suppose this is exceedingly unlikely to be a practical issue.

<snip>

>  static void pnp_print_option(pnp_info_buffer_t * buffer, char *space,
> -			     struct pnp_option *option, int dep)
> +			     struct pnp_option *option)

> +	switch (option->type) {
> +	case IORESOURCE_IO:
> +		pnp_print_port(buffer, space, &option->u.port);
> +		break;
> +	case IORESOURCE_MEM:
> +		pnp_print_mem(buffer, space, &option->u.mem);
> +		break;
> +	case IORESOURCE_IRQ:
> +		pnp_print_irq(buffer, space, &option->u.irq);
> +		break;

I believe it would be good if pnp_print_irq() now also displayed 
"(optional)" if the flag is set.

> @@ -659,26 +654,24 @@ static int __init isapnp_create_device(s
>  				priority = 0x100 | tmp[0];
>  				size = 0;
>  			}
> -			option = pnp_register_dependent_option(dev, priority);
> -			if (!option)
> -				return 1;
> +			option_flags = pnp_dependent_option(dev, priority);
>  			break;
>  		case _STAG_ENDDEP:
>  			if (size != 0)
>  				goto __skip;
> -			priority = 0;
> -			dev_dbg(&dev->dev, "end dependent options\n");
> +			option_flags = pnp_independent_option();

(here is the bugfix)

> -static int pnp_assign_resources(struct pnp_dev *dev, int depnum)
> +static int pnp_assign_resources(struct pnp_dev *dev, int set)
>  {
> -	struct pnp_port *port;
> -	struct pnp_mem *mem;
> -	struct pnp_irq *irq;
> -	struct pnp_dma *dma;
> +	struct pnp_option *option;
>  	int nport = 0, nmem = 0, nirq = 0, ndma = 0;
> +	int ret = 0;
>  
> -	dbg_pnp_show_resources(dev, "before pnp_assign_resources");
> +	dev_dbg(&dev->dev, "pnp_assign_resources, try dependent set %d\n", set);
>  	mutex_lock(&pnp_res_mutex);
>  	pnp_clean_resource_table(dev);
> -	if (dev->independent) {
> -		dev_dbg(&dev->dev, "assigning independent options\n");
> -		port = dev->independent->port;
> -		mem = dev->independent->mem;
> -		irq = dev->independent->irq;
> -		dma = dev->independent->dma;
> -		while (port) {
> -			if (pnp_assign_port(dev, port, nport) < 0)
> -				goto fail;
> -			nport++;
> -			port = port->next;
> -		}
> -		while (mem) {
> -			if (pnp_assign_mem(dev, mem, nmem) < 0)
> -				goto fail;
> -			nmem++;
> -			mem = mem->next;
> -		}
> -		while (irq) {
> -			if (pnp_assign_irq(dev, irq, nirq) < 0)
> -				goto fail;
> -			nirq++;
> -			irq = irq->next;
> -		}
> -		while (dma) {
> -			if (pnp_assign_dma(dev, dma, ndma) < 0)
> -				goto fail;
> -			ndma++;
> -			dma = dma->next;
> -		}
> -	}
>  
> -	if (depnum) {
> -		struct pnp_option *dep;
> -		int i;
> -
> -		dev_dbg(&dev->dev, "assigning dependent option %d\n", depnum);
> -		for (i = 1, dep = dev->dependent; i < depnum;
> -		     i++, dep = dep->next)
> -			if (!dep)
> -				goto fail;
> -		port = dep->port;
> -		mem = dep->mem;
> -		irq = dep->irq;
> -		dma = dep->dma;
> -		while (port) {
> -			if (pnp_assign_port(dev, port, nport) < 0)
> -				goto fail;
> -			nport++;
> -			port = port->next;
> -		}
> -		while (mem) {
> -			if (pnp_assign_mem(dev, mem, nmem) < 0)
> -				goto fail;
> -			nmem++;
> -			mem = mem->next;
> -		}
> -		while (irq) {
> -			if (pnp_assign_irq(dev, irq, nirq) < 0)
> -				goto fail;
> -			nirq++;
> -			irq = irq->next;
> +	list_for_each_entry(option, &dev->options, list) {
> +		if (pnp_option_is_dependent(option) &&
> +		    pnp_option_set(option) != set)
> +				continue;
> +
> +		switch (option->type) {
> +		case IORESOURCE_IO:
> +			ret = pnp_assign_port(dev, &option->u.port, nport++);
> +			break;
> +		case IORESOURCE_MEM:
> +			ret = pnp_assign_mem(dev, &option->u.mem, nmem++);
> +			break;
> +		case IORESOURCE_IRQ:
> +			ret = pnp_assign_irq(dev, &option->u.irq, nirq++);
> +			break;
> +		case IORESOURCE_DMA:
> +			ret = pnp_assign_dma(dev, &option->u.dma, ndma++);
> +			break;
> +		default:
> +			ret = -EINVAL;
> +			break;
>  		}
> -		while (dma) {
> -			if (pnp_assign_dma(dev, dma, ndma) < 0)
> -				goto fail;
> -			ndma++;
> -			dma = dma->next;
> -		}
> -	} else if (dev->dependent)
> -		goto fail;
> +		if (ret < 0)
> +			break;
> +	}

Mmm. Previously when it failed halfway through it re-cleared the 
resources (at label fail). Does it want to do so now also?

>  	mutex_unlock(&pnp_res_mutex);
> -	dbg_pnp_show_resources(dev, "after pnp_assign_resources");
> -	return 1;
> -
> -fail:
> -	pnp_clean_resource_table(dev);
> -	mutex_unlock(&pnp_res_mutex);
> -	dbg_pnp_show_resources(dev, "after pnp_assign_resources (failed)");
> -	return 0;
> +	if (ret == 0)
> +		dbg_pnp_show_resources(dev, "pnp_assign_resources succeeded");
> +	else
> +		dev_dbg(&dev->dev, "pnp_assign_resources failed (%d)\n", ret);
> +	return ret;
>  }
>  
>  /**
> @@ -332,29 +282,21 @@ fail:
>   */
>  int pnp_auto_config_dev(struct pnp_dev *dev)
>  {
> -	struct pnp_option *dep;
> -	int i = 1;
> +	int i, ret = 0;
>  
>  	if (!pnp_can_configure(dev)) {
>  		dev_dbg(&dev->dev, "configuration not supported\n");
>  		return -ENODEV;
>  	}
>  
> -	if (!dev->dependent) {
> -		if (pnp_assign_resources(dev, 0))
> +	for (i = 0; i == 0 || i < dev->num_dependent_sets; i++) {
> +		ret = pnp_assign_resources(dev, i);
> +		if (ret == 0)
>  			return 0;

Eeeew. Perhaps:

i = 0;
do {
	ret = pnp_assign_resources(dev, i);
	if (ret == 0)
		return 0;
} while (++i < dev->num_dependent_sets);

<snip>

> Index: work10/drivers/pnp/quirks.c
> ===================================================================
> --- work10.orig/drivers/pnp/quirks.c	2008-05-30 15:58:14.000000000 -0600
> +++ work10/drivers/pnp/quirks.c	2008-05-30 15:58:15.000000000 -0600
> @@ -5,6 +5,8 @@
>   *  when building up the resource structure for the first time.
>   *
>   *  Copyright (c) 2000 Peter Denison <peterd@pnd-pc.demon.co.uk>
> + *  (c) Copyright 2008 Hewlett-Packard Development Company, L.P.
> + *	Bjorn Helgaas <bjorn.helgaas@hp.com>
>   *
>   *  Heavily based on PCI quirks handling which is
>   *
> @@ -20,188 +22,208 @@
>  #include <linux/kallsyms.h>
>  #include "base.h"
>  
> +static void quirk_awe32_add_ports(struct pnp_dev *dev,
> +				  struct pnp_option *option,
> +				  unsigned int offset)
> +{
> +	struct pnp_option *new_option;
> +
> +	new_option = kmalloc(sizeof(struct pnp_option), GFP_KERNEL);
> +	if (!new_option) {
> +		dev_err(&dev->dev, "couldn't add ioport region to option set "
> +			"%d\n", pnp_option_set(option));
> +		return;
> +	}
> +
> +	*new_option = *option;
> +	new_option->u.port.min += offset;
> +	new_option->u.port.max += offset;
> +	list_add(&new_option->list, &option->list);
> +
> +	dev_info(&dev->dev, "added ioport region %#llx-%#llx to set %d\n",
> +		(unsigned long long) new_option->u.port.min,
> +		(unsigned long long) new_option->u.port.max,
> +		pnp_option_set(option));
> +}
> +
>  static void quirk_awe32_resources(struct pnp_dev *dev)
>  {
> -	struct pnp_port *port, *port2, *port3;
> -	struct pnp_option *res = dev->dependent;
> +	struct pnp_option *option;
> +	unsigned int set = ~0;
>  
>  	/*
> -	 * Unfortunately the isapnp_add_port_resource is too tightly bound
> -	 * into the PnP discovery sequence, and cannot be used. Link in the
> -	 * two extra ports (at offset 0x400 and 0x800 from the one given) by
> -	 * hand.
> +	 * Add two extra ioport regions (at offset 0x400 and 0x800 from the
> +	 * one given) to every dependent option set.
>  	 */
> -	for (; res; res = res->next) {
> -		port2 = pnp_alloc(sizeof(struct pnp_port));
> -		if (!port2)
> -			return;
> -		port3 = pnp_alloc(sizeof(struct pnp_port));
> -		if (!port3) {
> -			kfree(port2);
> -			return;
> +	list_for_each_entry(option, &dev->options, list) {
> +		if (pnp_option_is_dependent(option) &&
> +		    pnp_option_set(option) != set) {
> +			set = pnp_option_set(option);
> +			quirk_awe32_add_ports(dev, option, 0x800);
> +			quirk_awe32_add_ports(dev, option, 0x400);
>  		}
> -		port = res->port;
> -		memcpy(port2, port, sizeof(struct pnp_port));
> -		memcpy(port3, port, sizeof(struct pnp_port));
> -		port->next = port2;
> -		port2->next = port3;
> -		port2->min += 0x400;
> -		port2->max += 0x400;
> -		port3->min += 0x800;
> -		port3->max += 0x800;

Why do you do 0x800, 0x400 in that order? Shouldn't it just be 0x400, 
0x800 to mimick the old order?

> -		dev_info(&dev->dev,
> -			"AWE32 quirk - added ioports 0x%lx and 0x%lx\n",
> -			(unsigned long)port2->min,
> -			(unsigned long)port3->min);
>  	}
>  }
>  
>  static void quirk_cmi8330_resources(struct pnp_dev *dev)
>  {
> -	struct pnp_option *res = dev->dependent;
> -	unsigned long tmp;
> -
> -	for (; res; res = res->next) {
> -
> -		struct pnp_irq *irq;
> -		struct pnp_dma *dma;
> +	struct pnp_option *option;
> +	struct pnp_irq *irq;
> +	struct pnp_dma *dma;
>  
> -		for (irq = res->irq; irq; irq = irq->next) {	// Valid irqs are 5, 7, 10
> -			tmp = 0x04A0;
> -			bitmap_copy(irq->map.bits, &tmp, 16);	// 0000 0100 1010 0000
> -		}
> +	list_for_each_entry(option, &dev->options, list) {
> +		if (!pnp_option_is_dependent(option))
> +			continue;
>  
> -		for (dma = res->dma; dma; dma = dma->next)	// Valid 8bit dma channels are 1,3
> +		if (option->type == IORESOURCE_IRQ) {
> +			irq = &option->u.irq;
> +			bitmap_zero(irq->map.bits, PNP_IRQ_NR);
> +			__set_bit(5, irq->map.bits);
> +			__set_bit(7, irq->map.bits);
> +			__set_bit(10, irq->map.bits);
> +			dev_info(&dev->dev, "set possible IRQs in "
> +				 "option set %d to 5, 7, 10\n",
> +				 pnp_option_set(option));
> +		} else if (option->type == IORESOURCE_DMA) {
> +			dma = &option->u.dma;
>  			if ((dma->flags & IORESOURCE_DMA_TYPE_MASK) ==
> -			    IORESOURCE_DMA_8BIT)
> +						IORESOURCE_DMA_8BIT &&
> +			    dma->map != 0x000A) {

It's a char, so 0x0A? 0x000A makes it looks like it's 16-bit.

> +				dev_info(&dev->dev, "changing possible "
> +					 "DMA channel mask in option set %d "
> +					 "from %#x to 0xA (1, 3)\n",
> +					 pnp_option_set(option), dma->map);
>  				dma->map = 0x000A;

And here...

> +			}
> +		}
>  	}
> -	dev_info(&dev->dev, "CMI8330 quirk - forced possible IRQs to 5, 7, 10 "
> -		"and DMA channels to 1, 3\n");
>  }
>  
>  static void quirk_sb16audio_resources(struct pnp_dev *dev)
>  {
> +	struct pnp_option *option;
> +	unsigned int prev_option_flags = ~0, n = 0;
>  	struct pnp_port *port;
> -	struct pnp_option *res = dev->dependent;
> -	int changed = 0;
>  
>  	/*
>  	 * The default range on the mpu port for these devices is 0x388-0x388.
>  	 * Here we increase that range so that two such cards can be
>  	 * auto-configured.
>  	 */

While you're there -- s/mpu/OPL/.

> +static void quirk_ad1815_mpu_resources(struct pnp_dev *dev)
>  {
> -	struct pnp_option *res;
> +	struct pnp_option *option, *irq_option = NULL;
> +	unsigned int independent_irqs = 0;
> +
> +	list_for_each_entry(option, &dev->options, list) {
> +		if (option->type == IORESOURCE_IRQ &&
> +		    !pnp_option_is_dependent(option)) {
> +			independent_irqs++;
> +			irq_option = option;
> +		}
> +	}
>  
> -	res = dev->dependent;
> -	if (!res)
> +	if (independent_irqs != 1)
>  		return;
>  
> -	while (res->next)
> -		res = res->next;
> +	irq_option->flags |= IORESOURCE_IRQ_OPTIONAL;

You're in maze of unsigned variables, all named flags...

irq_option->u.irq.flags |= IORESOURCE_IRQ_OPTIONAL;

This was the thing that made things not work when I tested -- on an 
AD1815...


> +	dev_info(&dev->dev, "made independent IRQ optional\n");
>  
> -	res->next = quirk_isapnp_mpu_options(dev);
> +	quirk_add_irq_optional_dependent_sets(dev);

And as before, this one be gone.

The other quirks look good -- but I have the hardware and will test them 
specifically.

> Index: work10/drivers/pnp/resource.c
> ===================================================================
> --- work10.orig/drivers/pnp/resource.c	2008-05-30 15:58:13.000000000 -0600
> +++ work10/drivers/pnp/resource.c	2008-05-30 15:58:15.000000000 -0600
> @@ -3,6 +3,8 @@
>   *
>   * based on isapnp.c resource management (c) Jaroslav Kysela <perex@perex.cz>
>   * Copyright 2003 Adam Belay <ambx1@neo.rr.com>
> + * (c) Copyright 2008 Hewlett-Packard Development Company, L.P.
> + *	Bjorn Helgaas <bjorn.helgaas@hp.com>
>   */
>  
>  #include <linux/module.h>
> @@ -28,78 +30,37 @@ static int pnp_reserve_mem[16] = {[0 ...
>   * option registration
>   */
>  
> -struct pnp_option *pnp_build_option(int priority)
> +struct pnp_option *pnp_build_option(struct pnp_dev *dev,
> +					   unsigned long type,
> +					   unsigned int option_flags)
>  {
> -	struct pnp_option *option = pnp_alloc(sizeof(struct pnp_option));
> +	struct pnp_option *option;
>  
> +	option = kzalloc(sizeof(struct pnp_option), GFP_KERNEL);
>  	if (!option)
>  		return NULL;
>  
> -	option->priority = priority & 0xff;
> -	/* make sure the priority is valid */
> -	if (option->priority > PNP_RES_PRIORITY_FUNCTIONAL)
> -		option->priority = PNP_RES_PRIORITY_INVALID;

Dropping this made the 0x100 | prio ISAPnP/PnPBIOS bug appear. That 
0x100 should go anyway but perhaps this limiting is still a good idea?

> +	option->flags = option_flags;
> +	option->type = type;
>  
> +	list_add_tail(&option->list, &dev->options);
>  	return option;
>  }

Rene.
