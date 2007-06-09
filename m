Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXFIT55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXFIT55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbXFIT5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:57:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:56696 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800AbXFIT5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aM9oh8WRHDCVn/yd9qU23vYJNQWKIuiSrcBp5viqLAS6uQg/S37q/TofrTaUyK6ngL7Mgj2E1vSIeulVlVqtZEFIDJCSI/bZmloO8IbIivHyPIx/rGkSA5j/+GRUvU4sn3ZsIyqQwQczx8OdWJG+AqASy5m0d3o7Q6XIz4KnbF8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] pata_it821x: sync with IDE it821x driver
Date: Sat, 9 Jun 2007 22:09:10 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200706090223.20933.bzolnier@gmail.com> <466A417C.5090901@gmail.com>
In-Reply-To: <466A417C.5090901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706092209.10636.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

On Saturday 09 June 2007, Tejun Heo wrote:
> Hello,
> 
> Bartlomiej Zolnierkiewicz wrote:
> > * (partially) fix DMA in RAID mode
> > 
> >   Code intended to check DMA status was checking DMA command register.
> >   Moreover firmware seems to "forget" to set DMA capable bit for the
> >   slave device (at least in RAID mode but without ITE RAID volumes) so
> >   check device ID for DMA capable bit when deciding whether to use DMA
> >   and remove DMA status check completely.
> > 
> >   Thanks to Pavol ©imo for the bugreport and testing the initial fix.
> 
> Ah... This is the mysterious mwdma configuration in smart mode, right?

Yep.

> Thanks for fixing this.
> 
> >   This change unfortunately still doesn't fix DMA in RAID mode (which
> >   works fine with IDE it821x) but Alan is working on the missing pieces
> >   (pata_it821x vs libata EH issues).
> 
> This is the lbal/nsect SRST problem, right?

I think so, due to lack of time I'm not following libata discussions closely.

> > @@ -258,8 +259,14 @@ static void it821x_passthru_set_piomode(
> >  	static const u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
> >  
> >  	struct it821x_dev *itdev = ap->private_data;
> > +	struct ata_device *pair = ata_dev_pair(adev);
> >  	int unit = adev->devno;
> > -	int mode_wanted = adev->pio_mode - XFER_PIO_0;
> > +	int mode_wanted = adev->pio_mode;
> > +
> > +	if (pair && adev->pio_mode > pair->pio_mode)
> > +		mode_wanted = pair->pio_mode;
> > +
> > +	mode_wanted -= XFER_PIO_0;
> 
> I think this is better done by mode_filter callback which is guaranteed
> to be called before any actual mode configuration is performed and in
> device order (master then slave).

I was thinking about using ->mode_filter but since all other PATA host
drivers are doing PIO filtering in ->set_piomode methods and also since it
seemed that using ->mode_filter method would result in slightly more complex
code I opted for coherency / simplicity.  However if you (or somebody else)
want to make a follow-up change to this driver (and preferably other PATA
host drivers ie. pata_sil680) to use ->mode_filter I'm also fine with that.

Thanks,
Bart
