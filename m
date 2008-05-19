Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbYESXmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbYESXmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760582AbYESXld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:41:33 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25498 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbYESXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:41:14 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 2/4] PNP: replace pnp_resource_table with dynamically allocated resources
Date: Mon, 19 May 2008 17:41:15 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080515220726.029505668@ldl.fc.hp.com> <20080515220754.684738602@ldl.fc.hp.com> <483209BF.3040208@keyaccess.nl>
In-Reply-To: <483209BF.3040208@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191741.16488.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2008 05:14:07 pm Rene Herman wrote:
> On 16-05-08 00:07, Bjorn Helgaas wrote:
> 
> > PNP used to have a fixed-size pnp_resource_table for tracking the
> > resources used by a device.  This table often overflowed, so we've
> > had to increase the table size, which wastes memory because most
> > devices have very few resources.
> > 
> > This patch replaces the table with a linked list of resources where
> > the entries are allocated on demand.
> 
> [ ... ]
> 
> >  static void pnp_clean_resource_table(struct pnp_dev *dev)
> >  {
> > -	struct resource *res;
> > -	int idx;
> > +	struct pnp_resource *pnp_res, *tmp;
> >  
> > -	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
> > -		res = &dev->res->irq[idx].res;
> > -		if (res->flags & IORESOURCE_AUTO) {
> > -			res->flags = IORESOURCE_IRQ;
> > -			pnp_init_resource(res);
> > -		}
> > -	}
> > -	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
> > -		res = &dev->res->dma[idx].res;
> > -		if (res->flags & IORESOURCE_AUTO) {
> > -			res->flags = IORESOURCE_DMA;
> > -			pnp_init_resource(res);
> > -		}
> > -	}
> > -	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
> > -		res = &dev->res->port[idx].res;
> > -		if (res->flags & IORESOURCE_AUTO) {
> > -			res->flags = IORESOURCE_IO;
> > -			pnp_init_resource(res);
> > -		}
> > -	}
> > -	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
> > -		res = &dev->res->mem[idx].res;
> > -		if (res->flags & IORESOURCE_AUTO) {
> > -			res->flags = IORESOURCE_MEM;
> > -			pnp_init_resource(res);
> > -		}
> > +	list_for_each_entry_safe(pnp_res, tmp, &dev->resources, list) {
> > +		if (pnp_res->res.flags & IORESOURCE_AUTO)
> > +			pnp_free_resource(pnp_res);
> >  	}
> >  }
> 
> 
> Do correct me if I'm wrong but I don't believe this will do. The index 
> for the resources is preserved simply due to the list position after the 
> DISABLED thing but here the list is reshuffled.
> 
> So say I have an ISAPnP device with 2 port resources the second of which 
> I force to manual setting through sysfs (ie, AUTO is cleared). This API 
> would then delete the first port resource after which the second port 
> resource is the first entry in the list which would make for example 
> isapnp_set_resource() program it into hardware index 1, no?

My reasoning was that all AUTO entries should be at the end of the
list, so deleting them should not change the order of other entries.

I don't think there's a way to create a non-AUTO entry that follows
an AUTO one.  We add non-AUTO resources in:
  - isapnp_get_resources()
  - pnpbios_parse_allocated_resource_data()
  - pnpacpi_parse_allocated_resource()
  - pnp_set_current_resources() (sysfs interface)
and in all those cases, we use pnp_init_resources() first, which
clears out all existing resources.

We add AUTO resources in pnp_assign_{port,mem,etc}(), and those bail
out early if there's already a resource at the specified index.

All this is certainly not obvious from the code and it took me a
long time to convince myself of it, so I could easily be mistaken.

Bjorn

