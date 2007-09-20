Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbXITPOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbXITPOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 11:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXITPOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 11:14:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34603 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbXITPOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 11:14:38 -0400
Date: Thu, 20 Sep 2007 16:14:35 +0100
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: 2.6.23-rc6-mm1: Build failure on ppc64 drivers/ata/pata_scc.c
Message-ID: <20070920151435.GA5081@skynet.ie>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070920131315.GE24105@skynet.ie> <20070920150925.0caf3aef@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070920150925.0caf3aef@the-village.bc.nu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (20/09/07 15:09), Alan Cox didst pronounce:
> On Thu, 20 Sep 2007 14:13:15 +0100
> mel@skynet.ie (Mel Gorman) wrote:
> 
> > PPC64 building allmodconfig fails to compile drivers/ata/pata_scc.c . It
> > doesn't show up on other arches because this driver is specific to the
> > architecture.
> > 
> > drivers/ata/pata_scc.c: In function `scc_bmdma_status'
> 
> Its not been updated to match the libata core changes. Try something like
> this. Whoever is maintaining it should also remove the prereset cable handling
> code and use the proper cable detect method.
> 

I can confirm it builds with the following messages

  CC [M]  drivers/ata/pata_scc.o
drivers/ata/pata_scc.c: In function `scc_error_handler':
drivers/ata/pata_scc.c:909: warning: passing arg 3 of `ata_bmdma_drive_eh' from incompatible pointer type

As for the rest, I cannot comment.

Thanks Alan

> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23rc6-mm1/drivers/ata/pata_scc.c linux-2.6.23rc6-mm1/drivers/ata/pata_scc.c
> --- linux.vanilla-2.6.23rc6-mm1/drivers/ata/pata_scc.c	2007-09-18 15:32:51.000000000 +0100
> +++ linux-2.6.23rc6-mm1/drivers/ata/pata_scc.c	2007-09-20 14:23:32.879807760 +0100
> @@ -731,7 +731,7 @@
>  	void __iomem *mmio = ap->ioaddr.bmdma_addr;
>  	u8 host_stat = in_be32(mmio + SCC_DMA_STATUS);
>  	u32 int_status = in_be32(mmio + SCC_DMA_INTST);
> -	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
> +	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
>  	static int retry = 0;
>  
>  	/* return if IOS_SS is cleared */
> @@ -860,10 +860,10 @@
>   *	@deadline: deadline jiffies for the operation
>   */
>  
> -static int scc_pata_prereset(struct ata_port *ap, unsigned long deadline)
> +static int scc_pata_prereset(struct ata_link *link, unsigned long deadline)
>  {
> -	ap->cbl = ATA_CBL_PATA80;
> -	return ata_std_prereset(ap, deadline);
> +	link->ap->cbl = ATA_CBL_PATA80;
> +	return ata_std_prereset(link, deadline);
>  }
>  
>  /**
> @@ -874,8 +874,9 @@
>   *	Note: Original code is ata_std_postreset().
>   */
>  
> -static void scc_std_postreset (struct ata_port *ap, unsigned int *classes)
> +static void scc_std_postreset (struct ata_link *link, unsigned int *classes)
>  {
> +	struct ata_port *ap = link->ap;
>  	DPRINTK("ENTER\n");
>  
>  	/* is double-select really necessary? */
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
