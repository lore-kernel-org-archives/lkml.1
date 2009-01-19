Return-Path: <linux-kernel-owner+w=401wt.eu-S1760663AbZASM6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663AbZASM6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 07:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZASM6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 07:58:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:62611 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759644AbZASM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 07:58:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=gk3ZtjacKt1Vw3XdOIohZJxdNNEDOPwcOfUtXhuNo4f2B/BDkB14Q7lBV9ckHZx/E4
         1fUF7q+B5Y3LlfebqPdx7EQeaU1w1IWsfIchPqQT9o7LNkoTAK0jNAaZbEovDKvU6Mty
         3A+D6C9wvczRFMCsHU1/q8Oi0rFH4Z+6HVj1Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH 3/6] ide: small ide_register_port() cleanup
Date: Mon, 19 Jan 2009 12:43:13 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-next-20090116; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200811122216.06257.bzolnier@gmail.com> <jeocy58l15.fsf@sykes.suse.de>
In-Reply-To: <jeocy58l15.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901191243.13939.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009, Andreas Schwab wrote:
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> writes:
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-probe.c |    9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
> >
> > Index: b/drivers/ide/ide-probe.c
> > ===================================================================
> > --- a/drivers/ide/ide-probe.c
> > +++ b/drivers/ide/ide-probe.c
> > @@ -640,14 +640,9 @@ static int ide_register_port(ide_hwif_t 
> >  	/* register with global device tree */
> >  	dev_set_name(&hwif->gendev, hwif->name);
> >  	hwif->gendev.driver_data = hwif;
> > -	if (hwif->gendev.parent == NULL) {
> > -		if (hwif->dev)
> > -			hwif->gendev.parent = hwif->dev;
> > -		else
> > -			/* Would like to do = &device_legacy */
> > -			hwif->gendev.parent = NULL;
> > -	}
> > +	hwif->gendev.parent = hwif->dev;
> 
> This breaks ide-pmac.  It overwrites the parent that
> pmac_ide_macio_attach has set.
> 
> Signed-off-by: Andreas Schwab <schwab@suse.de>
> 
> diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
> index 312127e..0db1ed9 100644
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -649,7 +649,8 @@ static int ide_register_port(ide_hwif_t *hwif)
>  	/* register with global device tree */
>  	dev_set_name(&hwif->gendev, hwif->name);
>  	hwif->gendev.driver_data = hwif;
> -	hwif->gendev.parent = hwif->dev;
> +	if (hwif->gendev.parent == NULL)
> +		hwif->gendev.parent = hwif->dev;
>  	hwif->gendev.release = hwif_release_dev;
>  
>  	ret = device_register(&hwif->gendev);

Applied, thanks for fixing it.

Since it is the second time this ->parent special case bited us in the *ss:

pmac_ide_macio_attach():
...
	hw.dev = &mdev->bus->pdev->dev;
	hw.parent = &mdev->ofdev.dev;
...

I again wonder what is the reason for having different struct device-s used
for DBDMA and for device tree on MACIO PMAC controllers.  Maybe there is no
real reason after all and we can use &mdev->ofdev.dev also for hwif->dev?

Thanks,
Bart
