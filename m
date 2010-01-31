Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432Ab0AaAbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0AaAbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 19:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006Ab0AaAbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 19:31:17 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:37158 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab0AaAbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 19:31:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=R6udj/hm2ib3Kdmi7klgzSpBtb5VoRiMSxciGkbV4xHbEA2ljLJwlzC9vTuj5ZyiAk
         +/gHo9EkWFYq6o+BBFvFZbuKNQ3m01H/1hxMAp9FvHmFJw/4Xdgoj4RIWFfc9fRp5+re
         YP4YYvZHRRS1V4vJCDrPQoUu1CZtLk7h5UXuU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 7/9] cs5536: convert to ide2libata
Date: Sun, 31 Jan 2010 01:30:23 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100130194918.30779.25485.sendpatchset@localhost> <20100130195004.30779.89524.sendpatchset@localhost> <4B64AAE3.5040501@garzik.org>
In-Reply-To: <4B64AAE3.5040501@garzik.org>
MIME-Version: 1.0
Message-Id: <201001310130.23898.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 January 2010 10:55:47 pm Jeff Garzik wrote:
> On 01/30/2010 02:50 PM, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> > Subject: [PATCH] cs5536: convert to ide2libata
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> > ---
> >   drivers/ata/pata_cs5536.h |   22 +++++
> >   drivers/ide/cs5536.c      |  189 +---------------------------------------------
> >   2 files changed, 26 insertions(+), 185 deletions(-)
> >
> > Index: b/drivers/ata/pata_cs5536.h
> > ===================================================================
> > --- a/drivers/ata/pata_cs5536.h
> > +++ b/drivers/ata/pata_cs5536.h
> > @@ -64,7 +64,11 @@ static int cs5536_write(struct pci_dev *
> >
> >   static void cs5536_program_dtc(struct ata_device *adev, u8 tim)
> >   {
> > +#ifndef __IDE2LIBATA
> >   	struct pci_dev *pdev = to_pci_dev(adev->link->ap->host->dev);
> > +#else
> > +	struct pci_dev *pdev = to_pci_dev(adev->hwif->dev);
> > +#endif
> >   	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
> >   	u32 dtc;
> >
> > @@ -121,11 +125,19 @@ static void cs5536_set_piomode(struct at
> >   	int mode = adev->pio_mode - XFER_PIO_0;
> >   	int cmdmode = mode;
> >   	int cshift = adev->devno ? IDE_CAST_D1_SHIFT : IDE_CAST_D0_SHIFT;
> > +#ifdef __IDE2LIBATA
> > +	unsigned long timings = (unsigned long)ide_get_drivedata(adev);
> > +#endif
> >   	u32 cast;
> >
> >   	if (pair)
> >   		cmdmode = min(mode, pair->pio_mode - XFER_PIO_0);
> >
> > +#ifdef __IDE2LIBATA
> > +	timings&= (IDE_DRV_MASK<<  8);
> > +	timings |= drv_timings[mode];
> > +	ide_set_drivedata(adev, (void *)timings);
> > +#endif
> >   	cs5536_program_dtc(adev, drv_timings[mode]);
> >
> >   	cs5536_read(pdev, CAST,&cast);
> > @@ -160,7 +172,9 @@ static void cs5536_set_dmamode(struct at
> >   	u32 etc;
> >   	int mode = adev->dma_mode;
> >   	int dshift = adev->devno ? IDE_D1_SHIFT : IDE_D0_SHIFT;
> > -
> > +#ifdef __IDE2LIBATA
> > +	unsigned long timings = (unsigned long)ide_get_drivedata(adev);
> > +#endif
> >   	cs5536_read(pdev, ETC,&etc);
> >
> >   	if (mode>= XFER_UDMA_0) {
> > @@ -168,7 +182,13 @@ static void cs5536_set_dmamode(struct at
> >   		etc |= udma_timings[mode - XFER_UDMA_0]<<  dshift;
> >   	} else { /* MWDMA */
> >   		etc&= ~(IDE_ETC_UDMA_MASK<<  dshift);
> > +#ifndef __IDE2LIBATA
> >   		cs5536_program_dtc(adev, mwdma_timings[mode - XFER_MW_DMA_0]);
> > +#else
> > +		timings&= IDE_DRV_MASK;
> > +		timings |= mwdma_timings[mode - XFER_MW_DMA_0]<<  8;
> > +		ide_set_drivedata(adev, (void *)timings);
> > +#endif
> >   	}
> >
> >   	cs5536_write(pdev, ETC, etc);
> 
> Wow, that's really turning into a rat's nest of ifdefs, isn't it?

I'm sorry to say it but this is missing the point entirely.

With such ifdefs around I'm finally able to see some still remaining to
be fixed libata PATA issues (BTW work on ide2libata is what allowed me to
quickly do previous "PATA fixes" and "more PATA fixes" patchsets).

i.e. I can see that pata_cs5536 still needs to be fixed to handle non-matching
PIO/MWDMA timings (pata_ali.h patch is even better example of the concept).

[ As added bonus I'm cutting LOC and enabling possibility of sharing testing
  efforts for much of IDE/libata low-level code ('"leave it alone" stability
  promise of an old-IDE' is a wishful thinking anyway given that whole kernel
  evolves, not to even mention that it is completely unnecessary as we have
  much better stability promise in distributions that need it -- they are
  simply using much older kernel version (i.e. RHEL). ]

In reality I'm doing a long overdue work that should have been done four yours
ago before commit 669a5db got merged without any review or integration work
being done...

-- 
Bartlomiej Zolnierkiewicz
