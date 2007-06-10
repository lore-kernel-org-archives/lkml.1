Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbXFJQra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbXFJQra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXFJQrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:47:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:51861 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbXFJQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:47:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ho+r31AXTSNo+LI4pXSxHvMYq8MvCwR454ZmNDH3zMGaEmbXMnUazWdkgs+wBhXBY5krL819lSyfBml+/iJMyicrhHCNmeNOxe6RQNw/T0GxSKm3JHvQ2U7l5Qv65Msh39Y1u/y+vah8Ecc6Y3hzUoVnZ/Zuso8cgiQfNNLgGfg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_it821x: sync with IDE it821x driver
Date: Sun, 10 Jun 2007 18:40:40 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200706090223.20933.bzolnier@gmail.com> <20070610165638.2db56f04@the-village.bc.nu>
In-Reply-To: <20070610165638.2db56f04@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706101840.40460.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alan!

On Sunday 10 June 2007, Alan Cox wrote:
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
> NAK this too

OK, I'm able to understand the meaning of "NAK" [1] but "this too"?

[1] http://ozlabs.org/~rusty/index.cgi/2007/05/04

;)

> Please see it821x_program.
> 
> it821x_passthru_set_piomode computes the required mode and the preferred
> clock for the mode
> it821x_clock_strategy the computes the best clock to use
> it821x_program the programs the device
> 
> Whenever we issue a command it821x_passthru_dev_select then does a timing
> mode switch and loads the PIO timing before doing the dev_select. The
> same is also done when doing a qc_issue_prot so each qc_issue will have
> the right timings loaded for the device.
> 
> So if you've got a problem case your diagnosis isn't one that makes a lot
> of sense, and the fix is clearly wrong but I've not seen most of the
> discussion between you and whoever you worked with to judge why.
> 
> One obvious possibility is that we are not currently doing timing
> clipping for the address setup and merge for the 8bit timings. However
> the docs I have strongly imply that the IT821x PIO/MWDMA timing register
> is for data cycles only.
> 
> The other would be that there is some kind of pattern of interaction
> between the ATA midlayer and the driver causing the wrong timings to get
> loaded at some point.
> 
> Your "fix" would happen to work for both of these cases, but is wrong for
> both of them.
> 
> If the register is switching all the timings then the fix is to switch
> the PIO timing loaded to the lowest of the two initially (in _program)
> and flip it back to the correct value at the start of the data transfer
> sequence. We can then flip it back next qc_issue or indeed at the end of
> the data xfer
> 
> If we've got an interaction problem then we need proper traces with
> LIBATA debug turned right up so we can fix the actual case where the
> switching occurs wrongly.

PIO fix was directly ported from my it821x.c patch.  I now see that thanks
to it821x_passthru_dev_select() it is not really needeed in pata_it821x.c.

OTOH DMA fixes are pata_it821x.c unique, I will respin the patch.

Bart
