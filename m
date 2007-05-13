Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbXEMXkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbXEMXkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbXEMXkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:40:13 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4787 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbXEMXkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:40:11 -0400
Date: Mon, 14 May 2007 00:10:29 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-pcmcia@lists.infradead.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pcmcia: export pcmcia_bus_type
Message-ID: <20070513231029.GC28855@flint.arm.linux.org.uk>
Mail-Followup-To: Olof Johansson <olof@lixom.net>,
	Christoph Hellwig <hch@infradead.org>,
	linux-pcmcia@lists.infradead.org, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070512153307.GA13223@lixom.net> <20070512180658.GA14291@lixom.net> <20070513212042.GA14668@infradead.org> <20070513214007.GA24163@lixom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513214007.GA24163@lixom.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some random review comments on your driver, while I was passing.  Spotted
a few things.

On Sun, May 13, 2007 at 04:40:07PM -0500, Olof Johansson wrote:
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/platform_device.h>
> +#include <linux/platform_device.h>

Silly duplicate includes.

> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +
> +#include <pcmcia/ss.h>
> +#include <asm/of_platform.h>
> +
> +static const char driver_name[] = "electra-cf";
>...
> +static int electra_cf_get_status(struct pcmcia_socket *s, u_int *sp)
> +{
> +	struct electra_cf_socket *cf;
> +
> +	if (!sp)
> +		return -EINVAL;

Never called with a NULL argument, so useless check.

> +
> +	cf = container_of(s, struct electra_cf_socket, socket);
> +
> +	/* NOTE CF is always 3VCARD */
> +	if (electra_cf_present(cf)) {
> +		struct electra_cf_socket *cf;
> +
> +		*sp = SS_READY | SS_DETECT | SS_POWERON | SS_3VCARD;
> +		cf = container_of(s, struct electra_cf_socket, socket);
> +		s->pci_irq = cf->irq;
> +	} else
> +		*sp = 0;
> +	return 0;
> +}
>...
> +static int electra_cf_ss_suspend(struct pcmcia_socket *s)
> +{
> +	pr_debug("%s: %s\n", driver_name, __FUNCTION__);
> +	return electra_cf_set_socket(s, &dead_socket);
> +}

That's already done for you.  Remove this function entirely and set
the ".suspend" method to NULL.

> +static int electra_cf_set_io_map(struct pcmcia_socket *s,
> +				 struct pccard_io_map *io)
> +{
> +	struct electra_cf_socket *cf;
> +
> +	cf = container_of(s, struct electra_cf_socket, socket);
> +	io->flags &= MAP_ACTIVE|MAP_ATTRIB|MAP_16BIT;
> +	io->start = (unsigned long)cf->io_base;
> +	io->stop = (unsigned long)cf->io_base + 0x800 - 1;
> +	return 0;
> +}

PCMCIA code will ignore your writes to 'io'.  Therefore, does this
do anything useful?  If not, an empty function will do.

>...
> +static int __devinit electra_cf_probe(struct of_device *ofdev,
> +				      const struct of_device_id *match)
> +{
> +	struct device *device = &ofdev->dev;
> +	struct device_node *np = ofdev->node;
> +	struct electra_cf_socket   *cf;
> +	struct resource mem, io;
> +	int status;
> +	const unsigned int *prop;
> +	int err;
> +
> +	err = of_address_to_resource(np, 0, &mem);
> +	if (err)
> +		return -EINVAL;
> +
> +	err = of_address_to_resource(np, 1, &io);
> +	if (err)
> +		return -EINVAL;
> +
> +	cf = kzalloc(sizeof *cf, GFP_KERNEL);
> +	if (!cf)
> +		return -ENOMEM;
> +
> +	init_timer(&cf->timer);
> +	cf->timer.function = electra_cf_timer;
> +	cf->timer.data = (unsigned long) cf;
> +
> +	cf->ofdev = ofdev;
> +	cf->mem_phys = mem.start;
> +	cf->mem_base = ioremap(mem.start, mem.end - mem.start);
> +	cf->io_base = ioremap(io.start, io.end - io.start);
> +	cf->gpio_base = ioremap(0xfc103000, 0x1000);
> +	dev_set_drvdata(device, cf);
> +
> +	if (!cf->mem_base || !cf->io_base || !cf->gpio_base) {
> +		dev_err(device, "can't ioremap ranges\n");
> +		status = -ENOMEM;
> +		goto fail1;
> +	}
> +
> +	cf->iomem.start = (unsigned long)cf->io_base;
> +	cf->iomem.end = (unsigned long)cf->io_base + (io.end - io.start);
> +	cf->iomem.flags = IORESOURCE_MEM;
> +
> +	cf->irq = irq_of_parse_and_map(np, 0);
> +
> +	status = request_irq(cf->irq, electra_cf_irq, IRQF_SHARED,
> +			     driver_name, cf);
> +	if (status < 0) {
> +		dev_err(device, "request_irq failed\n");
> +		goto fail1;
> +	}
> +
> +	cf->socket.pci_irq = cf->irq;
> +
> +	prop = get_property(np, "card-detect-gpio", NULL);
> +	cf->gpio_detect = *prop;
> +	prop = get_property(np, "card-vsense-gpio", NULL);
> +	cf->gpio_vsense = *prop;
> +	prop = get_property(np, "card-3v-gpio", NULL);
> +	cf->gpio_3v = *prop;
> +	prop = get_property(np, "card-5v-gpio", NULL);
> +	cf->gpio_5v = *prop;
> +
> +	/* pcmcia layer only remaps "real" memory not iospace */
> +	cf->socket.io_offset = (unsigned long)cf->io_base;
> +
> +	/* reserve chip-select regions */
> +	if (!request_mem_region(mem.start, mem.end + 1 - mem.start,
> +				driver_name)) {
> +		status = -ENXIO;
> +		dev_err(device, "Can't claim memory region\n");
> +		goto fail1;
> +	}
> +
> +	if (!request_mem_region(io.start, io.end + 1 - io.start,
> +				driver_name)) {
> +		status = -ENXIO;
> +		dev_err(device, "Can't claim I/O region\n");
> +		goto fail2;
> +	}
> +
> +	cf->socket.owner = THIS_MODULE;
> +	cf->socket.dev.parent = &ofdev->dev;
> +	cf->socket.ops = &electra_cf_ops;
> +	cf->socket.resource_ops = &pccard_static_ops;
> +	cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP |
> +				SS_CAP_MEM_ALIGN;
> +	cf->socket.map_size = 0x800;
> +	cf->socket.io[0].res = &cf->iomem;

Not a good idea - PCMCIA manages this resources itself and will free it
when the card is removed.  Use ss_cap_static_map and socket.io_offset.

> +
> +	status = pcmcia_register_socket(&cf->socket);
> +	if (status < 0) {
> +		dev_err(device, "pcmcia_register_socket failed\n");
> +		goto fail3;
> +	}
> +
> +	dev_info(device, "at mem 0x%lx io 0x%lx irq %d\n",
> +		 mem.start, io.start, cf->irq);
> +
> +	cf->active = 1;
> +	electra_cf_timer((unsigned long)cf);
> +	return 0;
> +
> +fail3:
> +	release_mem_region(io.start, io.end + 1 - io.start);
> +fail2:
> +	release_mem_region(mem.start, mem.end + 1 - mem.start);
> +fail1:
> +	if (cf->io_base)
> +		iounmap(cf->io_base);
> +	if (cf->mem_base)
> +		iounmap(cf->mem_base);
> +	if (cf->gpio_base)
> +		iounmap(cf->gpio_base);
> +	device_init_wakeup(&ofdev->dev, 0);
> +	kfree(cf);
> +	return status;
> +
> +}
> +
> +static int __devexit electra_cf_remove(struct of_device *ofdev)
> +{
> +	struct device *device = &ofdev->dev;
> +	struct electra_cf_socket *cf;
> +
> +	cf = dev_get_drvdata(device);
> +
> +	cf->active = 0;
> +	pcmcia_unregister_socket(&cf->socket);
> +	del_timer_sync(&cf->timer);
> +	free_irq(cf->irq, cf);

What if an IRQ occurs after the timer has been deleted?  Doesn't the
interrupt handler re-add the timer back?

> +
> +	iounmap(cf->io_base);
> +	iounmap(cf->mem_base);
> +	iounmap(cf->gpio_base);
> +	release_mem_region(cf->mem_phys, cf->mem_size);
> +	release_region(cf->io_phys, cf->io_size);
> +
> +	kfree(cf);
> +
> +	return 0;
> +}

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
