Return-Path: <linux-kernel-owner+w=401wt.eu-S1761522AbXEMXsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761522AbXEMXsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758326AbXEMXsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:48:36 -0400
Received: from lixom.net ([66.141.50.11]:58142 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892AbXEMXsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:48:35 -0400
Date: Sun, 13 May 2007 18:51:28 -0500
To: Christoph Hellwig <hch@infradead.org>, linux-pcmcia@lists.infradead.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pcmcia: export pcmcia_bus_type
Message-ID: <20070513235128.GA25128@lixom.net>
References: <20070512153307.GA13223@lixom.net> <20070512180658.GA14291@lixom.net> <20070513212042.GA14668@infradead.org> <20070513214007.GA24163@lixom.net> <20070513231029.GC28855@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070513231029.GC28855@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 14, 2007 at 12:10:29AM +0100, Russell King wrote:
> Some random review comments on your driver, while I was passing.  Spotted
> a few things.

Thanks, I appreciate the feedback.

> On Sun, May 13, 2007 at 04:40:07PM -0500, Olof Johansson wrote:
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/sched.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/platform_device.h>
> 
> Silly duplicate includes.

Silly indeed.

> > +#include <linux/errno.h>
> > +#include <linux/init.h>
> > +#include <linux/delay.h>
> > +#include <linux/interrupt.h>
> > +
> > +#include <pcmcia/ss.h>
> > +#include <asm/of_platform.h>
> > +
> > +static const char driver_name[] = "electra-cf";
> >...
> > +static int electra_cf_get_status(struct pcmcia_socket *s, u_int *sp)
> > +{
> > +	struct electra_cf_socket *cf;
> > +
> > +	if (!sp)
> > +		return -EINVAL;
> 
> Never called with a NULL argument, so useless check.

Ok. Carried over from omap_cf, but I'll definitely fix it here.

> > +
> > +	cf = container_of(s, struct electra_cf_socket, socket);
> > +
> > +	/* NOTE CF is always 3VCARD */
> > +	if (electra_cf_present(cf)) {
> > +		struct electra_cf_socket *cf;
> > +
> > +		*sp = SS_READY | SS_DETECT | SS_POWERON | SS_3VCARD;
> > +		cf = container_of(s, struct electra_cf_socket, socket);
> > +		s->pci_irq = cf->irq;
> > +	} else
> > +		*sp = 0;
> > +	return 0;
> > +}
> >...
> > +static int electra_cf_ss_suspend(struct pcmcia_socket *s)
> > +{
> > +	pr_debug("%s: %s\n", driver_name, __FUNCTION__);
> > +	return electra_cf_set_socket(s, &dead_socket);
> > +}
> 
> That's already done for you.  Remove this function entirely and set
> the ".suspend" method to NULL.

Thanks, will do.

> 
> > +static int electra_cf_set_io_map(struct pcmcia_socket *s,
> > +				 struct pccard_io_map *io)
> > +{
> > +	struct electra_cf_socket *cf;
> > +
> > +	cf = container_of(s, struct electra_cf_socket, socket);
> > +	io->flags &= MAP_ACTIVE|MAP_ATTRIB|MAP_16BIT;
> > +	io->start = (unsigned long)cf->io_base;
> > +	io->stop = (unsigned long)cf->io_base + 0x800 - 1;
> > +	return 0;
> > +}
> 
> PCMCIA code will ignore your writes to 'io'.  Therefore, does this
> do anything useful?  If not, an empty function will do.

Not sure if it does, it came over from omap_cf with some modifications
by me.  I'll take a closer look when I rework the rest of the I/O
mapping stuff.

> > +	cf->socket.owner = THIS_MODULE;
> > +	cf->socket.dev.parent = &ofdev->dev;
> > +	cf->socket.ops = &electra_cf_ops;
> > +	cf->socket.resource_ops = &pccard_static_ops;
> > +	cf->socket.features = SS_CAP_PCCARD | SS_CAP_STATIC_MAP |
> > +				SS_CAP_MEM_ALIGN;
> > +	cf->socket.map_size = 0x800;
> > +	cf->socket.io[0].res = &cf->iomem;
> 
> Not a good idea - PCMCIA manages this resources itself and will free it
> when the card is removed.  Use ss_cap_static_map and socket.io_offset.

Right, I'm going to rework those parts alltogether.

> > +static int __devexit electra_cf_remove(struct of_device *ofdev)
> > +{
> > +	struct device *device = &ofdev->dev;
> > +	struct electra_cf_socket *cf;
> > +
> > +	cf = dev_get_drvdata(device);
> > +
> > +	cf->active = 0;
> > +	pcmcia_unregister_socket(&cf->socket);
> > +	del_timer_sync(&cf->timer);
> > +	free_irq(cf->irq, cf);
> 
> What if an IRQ occurs after the timer has been deleted?  Doesn't the
> interrupt handler re-add the timer back?

Ah, yes, good point.


Thanks,

-Olof
