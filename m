Return-Path: <linux-kernel-owner+w=401wt.eu-S1751590AbXBFLgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbXBFLgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXBFLgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:36:09 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:33038 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbXBFLgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:36:08 -0500
Message-ID: <45C8683C.1070409@gmail.com>
Date: Tue, 06 Feb 2007 12:36:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
Cc: Sam Creasey <sammy@sammy.net>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUN3/3X Lance trivial fix
References: <20070205191321.GA12839@cvg>
In-Reply-To: <20070205191321.GA12839@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill V. Gorcunov napsal(a):
> This patch adds checking for allocated DVMA
> memory and granted IRQ line.
> 
> Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>
> 
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

But now, if it fails (and you return 0=OK state) these are not assigned and 
probably used later.

>  
>  	REGA(CSR0) = CSR0_STOP;
>  
> -	request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev);
> +	if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev) < 0) {
> +		printk(KERN_WARNING "SUN3 Lance unable to allocate IRQ\n");
> +		return 0;
> +	}
>  	dev->irq = (unsigned short)LANCE_IRQ;

Not even irq is grabbed.

Is this intended?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
