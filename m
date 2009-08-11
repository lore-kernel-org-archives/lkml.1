Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZHKQrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZHKQrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZHKQrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:47:42 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:42638 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZHKQrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:47:41 -0400
Date: Tue, 11 Aug 2009 18:47:40 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Message-ID: <20090811184740.49f52b57@scarran.roarinelk.net>
In-Reply-To: <alpine.LFD.2.01.0908071116520.3390@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl>
	<alpine.LFD.2.01.0908020927410.3352@localhost.localdomain>
	<20090803165909.GA12824@roarinelk.homelinux.net>
	<alpine.LFD.2.01.0908041555120.3270@localhost.localdomain>
	<20090805155102.GA31646@roarinelk.homelinux.net>
	<alpine.LFD.2.01.0908050902300.3390@localhost.localdomain>
	<alpine.LFD.2.01.0908050931390.3390@localhost.localdomain>
	<20090805170934.GA32274@roarinelk.homelinux.net>
	<alpine.LFD.2.01.0908071051300.3390@localhost.localdomain>
	<alpine.LFD.2.01.0908071116520.3390@localhost.localdomain>
Organization: Private
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009 11:40:19 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

[explanation snipped]

> So this patch is not something that I'm going to apply to my tree, but 
> it's worth testing out to just verify that yes, I finally understand 
> exactly what's going on. Because if I'm right, your warning will now go 
> away (and it could be replaced by _other_ issues, of course ;).


> ---
>  drivers/pci/pci.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index dbd0f94..89efbb5 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -367,8 +367,12 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
>  			continue;	/* Wrong type */
>  		if (!((res->flags ^ r->flags) & IORESOURCE_PREFETCH))
>  			return r;	/* Exact match */
> -		if ((res->flags & IORESOURCE_PREFETCH) && !(r->flags & IORESOURCE_PREFETCH))
> -			best = r;	/* Approximating prefetchable by non-prefetchable */
> +		/* We can't insert a non-prefetch resource inside a prefetchable parent .. */
> +		if (r->flags & IORESOURCE_PREFETCH)
> +			continue;
> +		/* .. but we can put a prefetchable resource inside a non-prefetchable one */
> +		if (!best)
> +			best = r;
>  	}
>  	return best;
>  }


The warning is gone, and /proc/iomem is identical to 2.6.30.
I'd say you've hit the nail on the head ;)

Thanks!
	Manuel Lauss
