Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbYBAXXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbYBAXXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbYBAXXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:23:04 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:49728 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583AbYBAXXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:23:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=AIGMlUd6HsCPLA1DsGVP55n4tDby19DVB4CdJdNuHs4XKq20D9NF5FvJ8+M/D/zft1IomqiuKe5JZla6wsH9KUSQWs3Nm0/+kpIpQHWwuYN/sKwAOTcwOTcgqGtwTjvnoHbBms50Vj01KgXo1OXDNo9Nyj8HXDD2s7PIKMQfHro=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 7/8] ide: add struct ide_port_info instances to legacy host drivers
Date: Sat, 2 Feb 2008 00:35:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain> <20080106170310.6861.14522.sendpatchset@localhost.localdomain> <479E3AEA.5090600@ru.mvista.com>
In-Reply-To: <479E3AEA.5090600@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802020035.30918.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 28 January 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Remove 'struct pci_dev *dev' argument from ide_hwif_setup_dma().
> 
> > * Un-static ide_hwif_setup_dma() and add CONFIG_BLK_DEV_IDEDMA_PCI=n version.
> 
> > * Add 'const struct ide_port_info *d' argument to ide_device_add[_all]().
> 
> > * Factor out generic ports init from ide_pci_setup_ports() to ide_init_port(),
> >   move it to ide-probe.c and call it in in ide_device_add_all() instead of
> >   ide_pci_setup_ports().
> 
> > * Move ->mate setup to ide_device_add_all() from ide_port_init().
> 
> > * Add IDE_HFLAG_NO_AUTOTUNE host flag for host drivers that don't enable
> >   ->autotune currently.
> 
> > * Setup hwif->chipset in ide_init_port() but iff pi->chipset is set
> >   (to not override setup done by ide_hwif_configure()).
> 
> > * Add ETRAX host handling to ide_device_add_all().
> 
> > * cmd640.c: set IDE_HFLAG_ABUSE_* also for CONFIG_BLK_DEV_CMD640_ENHANCED=n.
> 
> > * pmac.c: make pmac_ide_setup_dma() return an error value and move DMA masks
> >   setup to pmac_ide_setup_device().
> 
> > * Add 'struct ide_port_info' instances to legacy host drivers, pass them to
> >   ide_device_add() calls and then remove open-coded ports initialization.
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> > Index: b/drivers/ide/arm/icside.c
> > ===================================================================
> > --- a/drivers/ide/arm/icside.c
> > +++ b/drivers/ide/arm/icside.c
> > @@ -459,11 +456,19 @@ icside_register_v5(struct icside_state *
> >  
> >  	idx[0] = hwif->index;
> >  
> > -	ide_device_add(idx);
> > +	ide_device_add(idx, NULL);
> >  
> >  	return 0;
> >  }
> >  
> > +static const struct ide_port_info icside_v6_port_info __initdata = {
> > +	.host_flags		= IDE_HFLAG_SERIALIZE |
> > +				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
> > +				  IDE_HFLAG_NO_AUTOTUNE,
> > +	.mwdma_mask		= ATA_MWDMA2,
> > +	.swdma_mask		= ATA_SWDMA2,
> > +};
> > +
> 
>     Interesting... this driver's support for SWDMA0 is broken since the cycle 
> should be 960 ns long, not 480, and SWDMA2 is underclocked using the same 
> cycle as SWDMA1, 480 ns...

Added Russell to Cc:.

> > Index: b/drivers/ide/cris/ide-cris.c
> > ===================================================================
> > --- a/drivers/ide/cris/ide-cris.c
> > +++ b/drivers/ide/cris/ide-cris.c
> > @@ -753,6 +753,15 @@ static void cris_set_dma_mode(ide_drive_
> >  		cris_ide_set_speed(TYPE_DMA, 0, strobe, hold);
> >  }
> >  
> > +static const struct ide_port_info cris_port_info __initdata = {
> > +	.chipset		= ide_etrax100,
> > +	.host_flags		= IDE_HFLAG_NO_ATAPI_DMA |
> > +				  IDE_HFLAG_NO_DMA, /* no SFF-style DMA */
> > +	.pio_mask		= ATA_PIO4,
> > +	.udma_mask		= cris_ultra_mask,
> 
>     Hm, I wonder which value it will assume, 0x07 or 0?  Not sure even after 
> looking at the source... :-)

This is tricky since it depends on the CRIS version
(0x07 on CRIS V32 and 0x00 on CRIS V10).

> > +	.mwdma_mask		= ATA_MWDMA2,
> > +};
> > +
> >  static int __init init_e100_ide(void)
> >  {
> >  	hw_regs_t hw;
> > Index: b/drivers/ide/ide-probe.c
> > ===================================================================
> > --- a/drivers/ide/ide-probe.c
> > +++ b/drivers/ide/ide-probe.c
> > @@ -1289,12 +1289,86 @@ static void hwif_register_devices(ide_hw
> >  	}
> >  }
> >  
> > -int ide_device_add_all(u8 *idx)
> > +static void ide_init_port(ide_hwif_t *hwif, unsigned int port,
> > +			  const struct ide_port_info *d)
> >  {
> > -	ide_hwif_t *hwif;
> > +	if (d->chipset != ide_etrax100)
> > +		hwif->channel = port;
> 
>    Hm, what's so special about ide_etrax100?

The driver supports *4* channels and it didn't set ->channel at all.

Since in the meantime ide-cris got marked as BROKEN I guess that a patch
removing above code would be OK.

> > +int ide_device_add_all(u8 idx[MAX_HWIFS], const struct ide_port_info *d)
> 
>     Function prototype doesn't match with one from <linux/ide.h> which has the 
> first argument as a pointer...

I fixed it locally, thanks.

> > +{
> > +	ide_hwif_t *hwif, *mate = NULL;
> >  	int i, rc = 0;
> >  
> >  	for (i = 0; i < MAX_HWIFS; i++) {
> > +		if (d == NULL || idx[i] == 0xff) {
> 
>     Why check for (d == NULL) every time and not do it once and break from the 
> loop or even do it before the loop?

To save on some code lines and resulting code size
(ide_device_add_all is not performance critical).

Bart
