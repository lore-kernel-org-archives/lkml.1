Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYICSQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYICSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYICSPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:15:53 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:41898 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbYICSPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=S5WrWFyyXTX9jiGpyBkJSuVi+LYfgqC13CvfJBoAdoPY6tvbYdLMOg+IzhJjgNFDRR
         yBkkZ3mCnzWWT9U2T1PeMLJWOI+dFxewZ2zEUw/r0zj8TwUTeb2VJiINgzxSDCWzuCTA
         qofJx0bdFzIP+AH23u1wRfjmxVJl+orPDYd2I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 01/18] ide: add ->read_sff_dma_status method
Date: Wed, 3 Sep 2008 20:13:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080620213323.13202.71450.sendpatchset@localhost.localdomain> <48BE8EFD.70103@ru.mvista.com>
In-Reply-To: <48BE8EFD.70103@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809032013.08489.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 03 September 2008, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Add ->read_sff_dma_status method for reading DMA Status register
> > and use it instead of ->INB.
> 
> > While at it:
> 
> > * Use inb() directly in ns87415.c::ns87415_dma_end().
> 
> > There should be no functional changes caused by this patch.
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> > Index: b/drivers/ide/ide-iops.c
> > ===================================================================
> > --- a/drivers/ide/ide-iops.c
> > +++ b/drivers/ide/ide-iops.c
> > @@ -103,6 +103,14 @@ void SELECT_MASK(ide_drive_t *drive, int
> >  		port_ops->maskproc(drive, mask);
> >  }
> >  
> > +static u8 ide_read_sff_dma_status(ide_hwif_t *hwif)
> > +{
> > +	if (hwif->host_flags & IDE_HFLAG_MMIO)
> > +		return readb((void __iomem *)hwif->dma_status);
> > +	else
> > +		return inb(hwif->dma_status);
> > +}
> > +
> 
>     It's probably too late to object now (and I've been busy before) but I 
> don't understand how reading DMA status ended up here ISO ide-dma.c...
> 
> >  static void ide_tf_load(ide_drive_t *drive, ide_task_t *task)
> >  {
> >  	ide_hwif_t *hwif = drive->hwif;
> > @@ -323,6 +331,8 @@ static void ata_output_data(ide_drive_t 
> >  
> >  void default_hwif_transport(ide_hwif_t *hwif)
> >  {
> > +	hwif->read_sff_dma_status = ide_read_sff_dma_status;
> > +
> >  	hwif->tf_load	  = ide_tf_load;
> >  	hwif->tf_read	  = ide_tf_read;
> 
>     I also didn't understand the motivation behind putting this method 
> together with the transport operations... IMO, DMA programming interface 
> hardly has anything to do with transporting the data over IDE bus.

The motivation was that hwif->dma_ops is not available yet when
->read_sff_dma_status is used in ide_pci_check_simplex().

However I agree that it should somehow find its way into ->dma_ops
(as usual patches are stongly preffered :).

Thanks,
Bart
