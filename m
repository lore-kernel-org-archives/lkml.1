Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbYFBXuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbYFBXuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYFBXud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:50:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbYFBXuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:50:32 -0400
Date: Mon, 2 Jun 2008 16:49:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: torvalds@linux-foundation.org, avuton@gmail.com, rene.herman@keyaccess.nl,
       rene.herman@gmail.com, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my
 ALSA intel8x0 sound card regression
Message-Id: <20080602164954.2aff2d77.akpm@linux-foundation.org>
In-Reply-To: <200806021642.50491.bjorn.helgaas@hp.com>
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>
	<200806021605.14519.bjorn.helgaas@hp.com>
	<3aa654a40806021523k5b89cd0cjbcddf5810d05072b@mail.gmail.com>
	<200806021642.50491.bjorn.helgaas@hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 16:42:49 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> PNP: mark resources that conflict with PCI devices "disabled"
> 
> Both the PNP/PCI conflict detection quirk and the PNP system
> driver must use the same mechanism to mark resources as disabled.
> 
> I think it's best to keep the resource and to keep the type bit
> (IORESOURCE_MEM, etc), so that we match the list from firmware
> as closely as possible.
> 
> Fixes this regression from 2.6.25: http://lkml.org/lkml/2008/6/1/82
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Tested-by: Avuton Olrich <avuton@gmail.com>
> 
> Index: work11/drivers/pnp/quirks.c
> ===================================================================
> --- work11.orig/drivers/pnp/quirks.c	2008-06-02 14:59:03.000000000 -0600
> +++ work11/drivers/pnp/quirks.c	2008-06-02 15:42:35.000000000 -0600
> @@ -286,7 +286,7 @@ static void quirk_system_pci_resources(s
>  					pci_name(pdev), i,
>  					(unsigned long long) pci_start,
>  					(unsigned long long) pci_end);
> -				res->flags = 0;
> +				res->flags |= IORESOURCE_DISABLED;
>  			}
>  		}
>  	}
> Index: work11/drivers/pnp/system.c
> ===================================================================
> --- work11.orig/drivers/pnp/system.c	2008-06-02 14:58:56.000000000 -0600
> +++ work11/drivers/pnp/system.c	2008-06-02 15:44:36.000000000 -0600
> @@ -81,7 +81,7 @@ static void reserve_resources_of_dev(str
>  	}
>  
>  	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
> -		if (res->flags & IORESOURCE_UNSET)
> +		if (res->flags & IORESOURCE_DISABLED)
>  			continue;
>  
>  		reserve_range(dev, res->start, res->end, 0);

This broke
pnp-replace-pnp_resource_table-with-dynamically-allocated-resources.patch:

***************
*** 80,91 ****
  		reserve_range(dev, res->start, res->end, 1);
  	}
  
- 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++) {
- 		if (res->flags & IORESOURCE_UNSET)
- 			continue;
- 
  		reserve_range(dev, res->start, res->end, 0);
- 	}
  }
  
  static int system_pnp_probe(struct pnp_dev *dev,
--- 78,85 ----
  		reserve_range(dev, res->start, res->end, 1);
  	}
  
+ 	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++)
  		reserve_range(dev, res->start, res->end, 0);
  }
  
  static int system_pnp_probe(struct pnp_dev *dev,

Which I fixed thusly:

static void reserve_resources_of_dev(struct pnp_dev *dev)
{
	struct resource *res;
	int i;

	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_IO, i)); i++) {
		if (res->start == 0)
			continue;	/* disabled */
		if (res->start < 0x100)
			/*
			 * Below 0x100 is only standard PC hardware
			 * (pics, kbd, timer, dma, ...)
			 * We should not get resource conflicts there,
			 * and the kernel reserves these anyway
			 * (see arch/i386/kernel/setup.c).
			 * So, do nothing
			 */
			continue;
		if (res->end < res->start)
			continue;	/* invalid */

		reserve_range(dev, res->start, res->end, 1);
	}

	for (i = 0; (res = pnp_get_resource(dev, IORESOURCE_MEM, i)); i++)
		reserve_range(dev, res->start, res->end, 0);
}


Is it still correct?

Thanks.
