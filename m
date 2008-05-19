Return-Path: <linux-kernel-owner+w=401wt.eu-S1765552AbYESXXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765552AbYESXXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 19:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762163AbYESXVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 19:21:39 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56218 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761103AbYESXVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 19:21:23 -0400
Message-ID: <483209BF.3040208@keyaccess.nl>
Date: Tue, 20 May 2008 01:14:07 +0200
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
Subject: Re: [patch 2/4] PNP: replace pnp_resource_table with dynamically
 allocated resources
References: <20080515220726.029505668@ldl.fc.hp.com> <20080515220754.684738602@ldl.fc.hp.com>
In-Reply-To: <20080515220754.684738602@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-05-08 00:07, Bjorn Helgaas wrote:

> PNP used to have a fixed-size pnp_resource_table for tracking the
> resources used by a device.  This table often overflowed, so we've
> had to increase the table size, which wastes memory because most
> devices have very few resources.
> 
> This patch replaces the table with a linked list of resources where
> the entries are allocated on demand.

[ ... ]

>  static void pnp_clean_resource_table(struct pnp_dev *dev)
>  {
> -	struct resource *res;
> -	int idx;
> +	struct pnp_resource *pnp_res, *tmp;
>  
> -	for (idx = 0; idx < PNP_MAX_IRQ; idx++) {
> -		res = &dev->res->irq[idx].res;
> -		if (res->flags & IORESOURCE_AUTO) {
> -			res->flags = IORESOURCE_IRQ;
> -			pnp_init_resource(res);
> -		}
> -	}
> -	for (idx = 0; idx < PNP_MAX_DMA; idx++) {
> -		res = &dev->res->dma[idx].res;
> -		if (res->flags & IORESOURCE_AUTO) {
> -			res->flags = IORESOURCE_DMA;
> -			pnp_init_resource(res);
> -		}
> -	}
> -	for (idx = 0; idx < PNP_MAX_PORT; idx++) {
> -		res = &dev->res->port[idx].res;
> -		if (res->flags & IORESOURCE_AUTO) {
> -			res->flags = IORESOURCE_IO;
> -			pnp_init_resource(res);
> -		}
> -	}
> -	for (idx = 0; idx < PNP_MAX_MEM; idx++) {
> -		res = &dev->res->mem[idx].res;
> -		if (res->flags & IORESOURCE_AUTO) {
> -			res->flags = IORESOURCE_MEM;
> -			pnp_init_resource(res);
> -		}
> +	list_for_each_entry_safe(pnp_res, tmp, &dev->resources, list) {
> +		if (pnp_res->res.flags & IORESOURCE_AUTO)
> +			pnp_free_resource(pnp_res);
>  	}
>  }


Do correct me if I'm wrong but I don't believe this will do. The index 
for the resources is preserved simply due to the list position after the 
DISABLED thing but here the list is reshuffled.

So say I have an ISAPnP device with 2 port resources the second of which 
I force to manual setting through sysfs (ie, AUTO is cleared). This API 
would then delete the first port resource after which the second port 
resource is the first entry in the list which would make for example 
isapnp_set_resource() program it into hardware index 1, no?

This function would appear to be unimplementable now? It's called from 
pnp_assign_resources() and pnp_disable_dev().

(stopped review there, since it seems this needs to either change or you 
need to slap some sense into me first)

Rene.

