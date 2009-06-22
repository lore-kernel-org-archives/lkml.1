Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbZFVVac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbZFVVac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZFVVaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:30:22 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:53359 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbZFVVaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=LTHL7RiVMFmtCtphmc+svwucgCxhH78pQkq3+PFfAJEEL+YxjtwSy1HXfOePJbe5yT
         t+oDAYr3yhb1KehuCWW7mT9o6KXQ12nQ0Q44XhN2L0OPmwjPHibBsd8bYNcf1g0edU9D
         qZc2b/T6Y8xYY32xDqWQtU6bTe1a2YPhBhY/I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
Date: Mon, 22 Jun 2009 23:35:06 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200906211446.38598.elendil@planet.nl> <200906221938.27574.bzolnier@gmail.com> <200906222101.38586.elendil@planet.nl>
In-Reply-To: <200906222101.38586.elendil@planet.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906222335.06700.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009 21:01:37 Frans Pop wrote:
> On Monday 22 June 2009, Bartlomiej Zolnierkiewicz wrote:
> > On Monday 22 June 2009 17:16:04 Frans Pop wrote:
> > Thanks.  Please notice 0701 0701 words above -- it means that this
> > device reports both SWDMA0 and MWDMA0 enabled at once (which results
> > in IDE layer failing DMA tuning).
> >
> > The patch below should fix it
> 
> Yes, this gives back MWDMA2 for hdd.

Cool.

> > and it would be quite interesting to try 
> > it on vanilla kernel to see if it helps with unexpected IRQ problem.
> 
> Will do later.
> 
> > However this still doesn't explain the regression fully -- we had
> > ide_id_dma_bug() checks since Dec 2007 (and equivalent
> > ide_dma_verbose() ones since almost forever) while 2.6.26 (which works
> > fine) is much younger than that.  I suspect that there are some other
> > kernel changes coming into the picture (Power Management?).  Would it
> > be possible to try 2.6.2[78] and/or bisect this problem further?
> 
> I suspect commit 8d64fcd9 "ide: identify data word 53 bit 1 doesn't cover 
> words 62 and 63 (take 3)":
> @@ -396,15 +393,14 @@ int ide_id_dma_bug(ide_drive_t *drive)
>  
>  	if (id[ATA_ID_FIELD_VALID] & 4) {
>  		if ((id[ATA_ID_UDMA_MODES] >> 8) &&
>  		    (id[ATA_ID_MWDMA_MODES] >> 8))
>  			goto err_out;
> -	} else if (id[ATA_ID_FIELD_VALID] & 2) {
> -		if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
> -		    (id[ATA_ID_SWDMA_MODES] >> 8))
> -			goto err_out;
> -	}
> +	} else if ((id[ATA_ID_MWDMA_MODES] >> 8) &&
> +		   (id[ATA_ID_SWDMA_MODES] >> 8))
> +		goto err_out;
> 
> 
> The logs I posted were from 2.6.30. I also tried 2.6.29 and that did *not* 

This breaks my beautiful theory about the root cause of unexpected IRQs.. ;(

> yet have the DMA problem. The commit above is from the 2.6.30 development 
> cycle, so that fits. I expect you can verify it from the identify data.

I had the same idea initially, unfortunately bit 1 is set for word 53 so this
must be something else...

> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: relax DMA info validity checking
> >
> > There are some broken devices that report multiple DMA xfer modes
> > enabled at once (ATA spec doesn't allow it) but otherwise work fine
> > with DMA so just delete ide_id_dma_bug().
> 
> The question is maybe: are there other devices that currently have dma 
> disabled because of the (old) code and would stop working with 
> ide_id_dma_bug() completely removed? The conservative thing to do I guess 
> would be to reverse 8d64fcd9.

This is quite unlikely given that libata has never had such checks..

> There is one thing I should mention here. I have been seeing the following 
> error with this CD drive:
> ide-cd: hdd: weird block size 2352
> ide-cd: hdd: default to 2kb block size
> 
> This was present with 2.6.26 and also now with 2.6.31; not sure about 
> older kernels. I initially saw it with a self-burned Debian installation 
> CD. I also now see it with an audio CD. It does not seem to affect 
> reading the disks: installations go fine and the audio CD plays without 
> any problems.
> 
> Any risk this may be related to something we've been discussing so far, or 
> is this a separate issue?

This is just a harmless warning coming from enabling of the workaround for
weird ATAPI devices (the one you have in this sparc machine seems to score
really high on the weirdness scale ;) introduced by commit e8e7b9e.
