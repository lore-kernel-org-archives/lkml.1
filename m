Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYESXlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYESXlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYESXlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:41:10 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39925 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYESXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:41:08 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Adam M Belay <abelay@mit.edu>
Subject: Re: [patch 4/4] PNP: dont sort by type in /sys/.../resources
Date: Mon, 19 May 2008 17:41:09 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080515220726.029505668@ldl.fc.hp.com> <20080515220755.127620227@ldl.fc.hp.com> <20080519184228.2mbxt2meths8cg0c@webmail.mit.edu>
In-Reply-To: <20080519184228.2mbxt2meths8cg0c@webmail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191741.10562.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 04:42:28 pm Adam M Belay wrote:
> Does this fix a bug or is it just a more convenient representation?

Mostly just simpler code.

It is important to maintain the order of resources within each
type, of course, so we can encode them in the correct order when
we set device configuration.  But we could still sort them by
type if you think that's important.

There is some risk with changing the order, but there's also
some benefit in reducing the fiddling we do with the data from
the firmware.  It's been conceptually liberating for me to see
the data correlate more exactly with _CRS and friends.

> Perhaps, if
> we're going to change the interface we could switch to PCI style sysfs
> resources.

You mean like resource_show(), which looks like this?

  $ cat /sys/devices/pci0000:00/0000:00:00.0/resource 
  0x0000000000000000 0x0000000000000000 0x0000000000000000
  0x0000000000000000 0x0000000000000000 0x0000000000000000
  0x0000000000000000 0x0000000000000000 0x0000000000000000
  0x0000000000000000 0x0000000000000000 0x0000000000000000
  0x0000000000000000 0x0000000000000000 0x0000000000000000
  0x0000000000000000 0x0000000000000000 0x0000000000000000
  0x0000000000000000 0x0000000000000000 0x0000000000000000

I'm all in favor of converging with the PCI style of doing things,
but I'm not sure I understand your idea in this case.  We still do
quite a bit of manual poking in the PNP resource file, and the
labels make it nicer for human consumption.

Bjorn

> Quoting Bjorn Helgaas <bjorn.helgaas@hp.com>:
> 
> > Rather than stepping through all IO resources, then stepping through
> > all MMIO resources, etc., we can just iterate over the resource list
> > once directly.
> >
> > This can change the order in /sys, e.g.,
> >
> >    # cat /sys/devices/pnp0/00:07/resources     # OLD
> >    state = active
> >    io 0x3f8-0x3ff
> >    irq 4
> >
> >    # cat /sys/devices/pnp0/00:07/resources     # NEW
> >    state = active
> >    irq 4
> >    io 0x3f8-0x3ff
> >
> > The old code artificially sorted resources by type; the new code
> > just lists them in the order we read them from the ISAPNP hardware
> > or the BIOS.
> >
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> >
> > Index: work10/drivers/pnp/interface.c
> > ===================================================================
> > --- work10.orig/drivers/pnp/interface.c	2008-05-05 11:54:26.000000000 -0600
> > +++ work10/drivers/pnp/interface.c	2008-05-05 11:59:53.000000000 -0600
> > @@ -248,8 +248,9 @@ static ssize_t pnp_show_current_resource
> > 					  char *buf)
> > {
> > 	struct pnp_dev *dev = to_pnp_dev(dmdev);
> > +	struct pnp_resource *pnp_res;
> > 	struct resource *res;
> > -	int i, ret;
> > +	int ret;
> > 	pnp_info_buffer_t *buffer;
> >
> > 	if (!dev)
> > @@ -262,46 +263,33 @@ static ssize_t pnp_show_current_resource
> > 	buffer->buffer = buf;
> > 	buffer->curr = buffer->buffer;
> >
> > -	pnp_printf(buffer, "state = ");
> > -	if (dev->active)
> > -		pnp_printf(buffer, "active\n");
> > -	else
> > -		pnp_printf(buffer, "disabled\n");
> > -
> > -	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
> > -		pnp_printf(buffer, "io");
> > -		if (res->flags & IORESOURCE_DISABLED)
> > -			pnp_printf(buffer, " disabled\n");
> > -		else
> > -			pnp_printf(buffer, " 0x%llx-0x%llx\n",
> > -				   (unsigned long long) res->start,
> > -				   (unsigned long long) res->end);
> > -	}
> > -	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
> > -		pnp_printf(buffer, "mem");
> > -		if (res->flags & IORESOURCE_DISABLED)
> > +	pnp_printf(buffer, "state = %s\n", dev->active ? "active" : "disabled");
> > +
> > +	list_for_each_entry(pnp_res, &dev->resources, list) {
> > +		res = &pnp_res->res;
> > +
> > +		pnp_printf(buffer, pnp_resource_type_name(res));
> > +
> > +		if (res->flags & IORESOURCE_DISABLED) {
> > 			pnp_printf(buffer, " disabled\n");
> > -		else
> > -			pnp_printf(buffer, " 0x%llx-0x%llx\n",
> > +			continue;
> > +		}
> > +
> > +		switch (pnp_resource_type(res)) {
> > +		case IORESOURCE_IO:
> > +		case IORESOURCE_MEM:
> > +			pnp_printf(buffer, " %#llx-%#llx\n",
> > 				   (unsigned long long) res->start,
> > 				   (unsigned long long) res->end);
> > -	}
> > -	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IRQ, i)); i++) {
> > -		pnp_printf(buffer, "irq");
> > -		if (res->flags & IORESOURCE_DISABLED)
> > -			pnp_printf(buffer, " disabled\n");
> > -		else
> > -			pnp_printf(buffer, " %lld\n",
> > -				   (unsigned long long) res->start);
> > -	}
> > -	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_DMA, i)); i++) {
> > -		pnp_printf(buffer, "dma");
> > -		if (res->flags & IORESOURCE_DISABLED)
> > -			pnp_printf(buffer, " disabled\n");
> > -		else
> > +			break;
> > +		case IORESOURCE_IRQ:
> > +		case IORESOURCE_DMA:
> > 			pnp_printf(buffer, " %lld\n",
> > 				   (unsigned long long) res->start);
> > +			break;
> > +		}
> > 	}
> > +
> > 	ret = (buffer->curr - buf);
> > 	kfree(buffer);
> > 	return ret;
> >
> > --
> >
> 
> 
> 


