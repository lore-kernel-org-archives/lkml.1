Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbYE3FKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbYE3FKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbYE3FKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:10:18 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:8899 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751819AbYE3FKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:10:16 -0400
X-Nifty-SrcIP: [202.219.140.221]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=DzpufhQ76b5Lydx/N8sCs1v5KxCkQnKKWHGlYbcninpGhGdyV4+27vF0QElQaexg3/AIVhFw6BKweiFXIDUwCQ==  ;
Date: Fri, 30 May 2008 14:01:40 +0900 (JST)
Message-Id: <20080530.140140.193692749.takada@mbf.nifty.com>
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
From: TAKADA Yoshihito <takada@mbf.nifty.com>
In-Reply-To: <200805150028.04625.bzolnier@gmail.com>
References: <20080509.215601.208967867.takada@mbf.nifty.com>
	<200805142244.48548.bzolnier@gmail.com>
	<200805150028.04625.bzolnier@gmail.com>
X-Mailer: Mew version 6.0.50 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
Date: Thu, 15 May 2008 00:28:04 +0200

Hi. sorry, I'm too late.
I tested the patch to re-enable DMA. But, this patch has no effect. It cannot boot.
printk() message disappeared.

> On Wednesday 14 May 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Friday 09 May 2008, TAKADA Yoshihito wrote:
> > > Hi.
> > > 
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
> > > Date: Fri, 9 May 2008 11:27:53 +0200
> > > 
> > > > On Friday 09 May 2008, TAKADA Yoshihito wrote:
> > > > > Thanks for quick reply.
> > > > > 
> > > > > I tried 2.6.26rc1. It hangs same as 2.6.25.
> > > > > kernel 2.6.26rc1 with cs5520 cannot boot. cs5520 scans ide0 and ide1.
> > > > > It seems 2nd port DMA base issue was solved.
> > > > 
> > > > [...]
> > > > 
> > > > Thanks.
> > > > 
> > > > The following patch for 2.6.26-rc1 disables VDMA, please give it a try
> > > > (I haven't time to fully audit VDMA support yet but lets see if it is
> > > > the main source of the problems).
> > > 
> > > I applied the patch. But kernel was hung.
> > > And I attempt to kill IDE_HFLAG_CS5520. It cannot boot, oo.
> > > 
> > >   kill IDE_HFLAG_VDMA  : hang  
> > >   kill IDE_HFLAG_CS5520: hang
> > >   kill both flags      : boot
> > 
> > Thanks for investigating this - I forgot that currently VDMA and CS5520
> > host flags use the same bit (so it also needs to be fixed).
> > 
> > I'm going to send the following patch to Linus (please verify it):
> > 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] cs5520: disable VDMA
> 
> [...]
> 
> Please also try 2.6.26-rc2 without the above patch but with the following
> patch applied instead - according to comments in OpenFirmware & pata_cs5520
> code 0x60 register contains bus-master enable bit, it could be that it was
> left disabled by BIOS and we need to explicitely enable it (if somebody has
> CX5510 or CX5520 datasheet please verify this + send me a copy if possible).
> 
> ---
>  drivers/ide/pci/cs5520.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: b/drivers/ide/pci/cs5520.c
> ===================================================================
> --- a/drivers/ide/pci/cs5520.c
> +++ b/drivers/ide/pci/cs5520.c
> @@ -147,6 +147,7 @@ static int __devinit cs5520_init_one(str
>  {
>  	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
>  	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
> +	u8 pcicfg;
>  
>  	ide_setup_pci_noise(dev, d);
>  
> @@ -163,6 +164,13 @@ static int __devinit cs5520_init_one(str
>  		return -ENODEV;
>  	}
>  
> +	pci_read_config_byte(dev, 0x60, &pcicfg);
> +
> +	if ((pcicfg & 0x40) == 0) {
> +		printk(KERN_WARNING "cs5520: DMA mode disabled. Enabling.\n");
> +		pci_write_config_byte(dev, 0x60, pcicfg | 0x40);
> +	}
> +
>  	/*
>  	 *	Now the chipset is configured we can let the core
>  	 *	do all the device setup for us
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
