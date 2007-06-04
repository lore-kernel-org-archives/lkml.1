Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbXFDHrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbXFDHrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 03:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXFDHrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 03:47:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41742 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbXFDHrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 03:47:23 -0400
Date: Mon, 4 Jun 2007 08:47:19 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070604074719.GB15390@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Miller <davem@davemloft.net>, mroos@linux.ee,
	linux-kernel@vger.kernel.org
References: <Pine.SOC.4.64.0706032314590.20033@math> <20070603.174010.41894721.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070603.174010.41894721.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2007 at 05:40:10PM -0700, David Miller wrote:
> From: Meelis Roos <mroos@linux.ee>
> Date: Sun, 3 Jun 2007 23:23:33 +0300 (EEST)
> 
> > I accidentally enabled libata config options on my Sun Ultra 1 (sparc64, 
> > UP, no PCI, only SBUS):
> > 
> >   MODPOST 440 modules
> > ERROR: "dma_unmap_sg" [drivers/ata/libata.ko] undefined!
> > ERROR: "dma_map_sg" [drivers/ata/libata.ko] undefined!
> > ERROR: "dma_unmap_single" [drivers/ata/libata.ko] undefined!
> > ERROR: "dma_mapping_error" [drivers/ata/libata.ko] undefined!
> > ERROR: "dma_map_single" [drivers/ata/libata.ko] undefined!
> > 
> > CONFIG_PCI=n
> > CONFIG_ATA=m
> > 
> > This seems to be a valid configuration since libata can drive non-PCI 
> > devices too?
> 
> It really makes no sense to allow this on Sparc, there are no
> non-PCI Sparc ATA controllers.
> 
> Therefore I'll fix it like this:

The right fix is the depend on the new HAS_DMA (or whatever it's called)
symbol.  The proper long-term fix is to move calln to the dam mapping
functions from the core libata files into the drivers responsibility with
a default implementation for the typical cases.

> 
> commit 6274b5c63131c3110405db5d19e71af26cbbd375
> Author: David S. Miller <davem@sunset.davemloft.net>
> Date:   Sun Jun 3 17:39:56 2007 -0700
> 
>     [ATA]: Don't allow to enable this for SPARC64 without PCI.
>     
>     Based upon a report from Meelis Roos.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index b4a8d60..7d893a6 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -8,6 +8,7 @@ menuconfig ATA
>  	depends on BLOCK
>  	depends on !(M32R || M68K) || BROKEN
>  	depends on !SUN4 || BROKEN
> +	depends on !(SPARC64 && !PCI)
>  	select SCSI
>  	---help---
>  	  If you want to use a ATA hard disk, ATA tape drive, ATA CD-ROM or
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
