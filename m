Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYJOTvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYJOTvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbYJOTuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:50:17 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:59673 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYJOTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:50:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=luIvCW3oGL4xCHHvvO7pllqanhhCxYfQPyOpRWnTNTplNEvS/FFoqoxqD5findOhAo
         1rGPH8Z6gLEPE0OXDVHzA8p3YZxE63HHg+TqepzoK+zqhAXXCQCC5TKuSGYszZGwe4aE
         fBK+tvtWuuUjglPKqIgksXGN6Q50/QasqhtZM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 09/18] ide: add ->set_irq method
Date: Wed, 15 Oct 2008 20:22:44 +0200
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <20080620213424.13202.16889.sendpatchset@localhost.localdomain> <48F5DFF7.9010908@ru.mvista.com>
In-Reply-To: <48F5DFF7.9010908@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810152022.44708.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2008, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Add ->set_irq method for setting nIEN bit of ATA Device Control
> > register and use it instead of ide_set_irq().
> >
> > While at it:
> >
> > * Use ->set_irq in init_irq() and do_reset1().
> >
> > * Don't use HWIF() macro in ide_check_pm_state().
> >
> > There should be no functional changes caused by this patch.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >   
> [...]
> > Index: b/drivers/ide/ide-iops.c
> > ===================================================================
> > --- a/drivers/ide/ide-iops.c
> > +++ b/drivers/ide/ide-iops.c
> > @@ -135,6 +135,23 @@ static u8 ide_read_sff_dma_status(ide_hw
> >  		return inb(hwif->dma_base + ATA_DMA_STATUS);
> >  }
> >  
> > +static void ide_set_irq(ide_hwif_t *hwif, int on)
> > +{
> > +	u8 ctl = ATA_DEVCTL_OBS;
> > +
> > +	if (on == 4) { /* hack for SRST */
> > +		ctl |= 4;
> > +		on &= ~4;
> > +	}
> > +
> > +	ctl |= on ? 0 : 2;
> > +
> > +	if (hwif->host_flags & IDE_HFLAG_MMIO)
> > +		writeb(ctl, (void __iomem *)hwif->io_ports.ctl_addr);
> > +	else
> > +		outb(ctl, hwif->io_ports.ctl_addr);
> > +}
> > +
> >  static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
> >  {
> >  	ide_hwif_t *hwif = drive->hwif;
> >   
> [...]
> > @@ -1162,16 +1180,15 @@ static ide_startstop_t do_reset1 (ide_dr
> >  	 * immediate interrupt due to the edge transition it produces.
> >  	 * This single interrupt gives us a "fast poll" for drives that
> >  	 * recover from reset very quickly, saving us the first 50ms wait time.
> > +	 *
> > +	 * TODO: add ->softreset method and stop abusing ->set_irq
> >  	 */
> >  	/* set SRST and nIEN */
> > -	hwif->OUTBSYNC(hwif, ATA_DEVCTL_OBS | 6, io_ports->ctl_addr);
> > +	hwif->set_irq(hwif, 4);
> >  	/* more than enough time */
> >  	udelay(10);
> 
>    It seems to me that the whole idea of having 2 separate methods for 
> writing the single device control register is a wrong idea.
> I'm suggesting to convert set_irq() method to write_devctrl() method and 
> pass the register value directly to it.

Makes sense.  Care to make a patch?
