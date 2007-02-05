Return-Path: <linux-kernel-owner+w=401wt.eu-S933334AbXBEU3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334AbXBEU3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbXBEU3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:29:41 -0500
Received: from anhedonia.sammy.net ([72.5.28.211]:41223 "EHLO
	anhedonia.sammy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309AbXBEU3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:29:40 -0500
X-Greylist: delayed 1661 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 15:29:40 EST
Date: Mon, 5 Feb 2007 15:01:56 -0500
To: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] SUN3/3X Lance trivial fix
Message-ID: <20070205200155.GC28224@sammy.net>
References: <20070205191321.GA12839@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205191321.GA12839@cvg>
User-Agent: Mutt/1.5.9i
From: Sam Creasey <sammy@sammy.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 10:13:21PM +0300, Cyrill V. Gorcunov wrote:
> This patch adds checking for allocated DVMA
> memory and granted IRQ line.
> 
> Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>

Acked-by: Sam Creasey <sammy@sammy.net>

Included in my tree for rolling back into m68k.  I'm fine with it
going upstream as well.

-- Sam

> ---
> 
>  drivers/net/sun3lance.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/sun3lance.c b/drivers/net/sun3lance.c
> index c62e85d..e4c2c88 100644
> --- a/drivers/net/sun3lance.c
> +++ b/drivers/net/sun3lance.c
> @@ -336,13 +336,20 @@ static int __init lance_probe( struct net_device *dev)
>  
>  	/* XXX - leak? */
>  	MEM = dvma_malloc_align(sizeof(struct lance_memory), 0x10000);
> +	if (MEM == NULL) {
> +		printk(KERN_WARNING "SUN3 Lance couldn't allocate DVMA memory\n");
> +		return 0;
> +	}
>  
>  	lp->iobase = (volatile unsigned short *)ioaddr;
>  	dev->base_addr = (unsigned long)ioaddr; /* informational only */
>  
>  	REGA(CSR0) = CSR0_STOP;
>  
> -	request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev);
> +	if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev) < 0) {
> +		printk(KERN_WARNING "SUN3 Lance unable to allocate IRQ\n");
> +		return 0;
> +	}
>  	dev->irq = (unsigned short)LANCE_IRQ;
>  
>  
