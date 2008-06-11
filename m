Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYFKU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYFKU33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbYFKU0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:26:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60994 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbYFKU0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=igcGwRqV5Jpyfr8vECfWrdp+TY/2e6+ukQv+o/2SZO+yCwFGTH+qByLIKuMHsuOVgz
         wPHzV/ywQSeuu6RsAaSJ9Ro7asyL+b5D35ezi2CDgPVZuEKj0ZqhrhyZClswBemUCCdb
         f+85ND5rE52fi1lD1sK2ONRTqXbef15aryAzo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
Date: Wed, 11 Jun 2008 22:27:23 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080509.215601.208967867.takada@mbf.nifty.com> <200805150028.04625.bzolnier@gmail.com> <20080530.140140.193692749.takada@mbf.nifty.com>
In-Reply-To: <20080530.140140.193692749.takada@mbf.nifty.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806112227.23556.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 30 May 2008, TAKADA Yoshihito wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
> Date: Thu, 15 May 2008 00:28:04 +0200
> 
> Hi. sorry, I'm too late.
> I tested the patch to re-enable DMA. But, this patch has no effect. It cannot boot.
> printk() message disappeared.

Now I'm late. ;-)

Thanks for info, I'll later prepare patch removing IDE_HFLAG_VDMA & co.

> > On Wednesday 14 May 2008, Bartlomiej Zolnierkiewicz wrote:
> > > On Friday 09 May 2008, TAKADA Yoshihito wrote:
> > > > Hi.
> > > > 
> > > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > Subject: Re: kernel 2.6.25 with ide driver cs5520 does not boot.
> > > > Date: Fri, 9 May 2008 11:27:53 +0200
> > > > 
> > > > > On Friday 09 May 2008, TAKADA Yoshihito wrote:
> > > > > > Thanks for quick reply.
> > > > > > 
> > > > > > I tried 2.6.26rc1. It hangs same as 2.6.25.
> > > > > > kernel 2.6.26rc1 with cs5520 cannot boot. cs5520 scans ide0 and ide1.
> > > > > > It seems 2nd port DMA base issue was solved.
> > > > > 
> > > > > [...]
> > > > > 
> > > > > Thanks.
> > > > > 
> > > > > The following patch for 2.6.26-rc1 disables VDMA, please give it a try
> > > > > (I haven't time to fully audit VDMA support yet but lets see if it is
> > > > > the main source of the problems).
> > > > 
> > > > I applied the patch. But kernel was hung.
> > > > And I attempt to kill IDE_HFLAG_CS5520. It cannot boot, oo.
> > > > 
> > > >   kill IDE_HFLAG_VDMA  : hang  
> > > >   kill IDE_HFLAG_CS5520: hang
> > > >   kill both flags      : boot
> > > 
> > > Thanks for investigating this - I forgot that currently VDMA and CS5520
> > > host flags use the same bit (so it also needs to be fixed).
> > > 
> > > I'm going to send the following patch to Linus (please verify it):
> > > 
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Subject: [PATCH] cs5520: disable VDMA
> > 
> > [...]
> > 
> > Please also try 2.6.26-rc2 without the above patch but with the following
> > patch applied instead - according to comments in OpenFirmware & pata_cs5520
> > code 0x60 register contains bus-master enable bit, it could be that it was
> > left disabled by BIOS and we need to explicitely enable it (if somebody has
> > CX5510 or CX5520 datasheet please verify this + send me a copy if possible).
> > 
> > ---
> >  drivers/ide/pci/cs5520.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > Index: b/drivers/ide/pci/cs5520.c
> > ===================================================================
> > --- a/drivers/ide/pci/cs5520.c
> > +++ b/drivers/ide/pci/cs5520.c
> > @@ -147,6 +147,7 @@ static int __devinit cs5520_init_one(str
> >  {
> >  	const struct ide_port_info *d = &cyrix_chipsets[id->driver_data];
> >  	u8 idx[4] = { 0xff, 0xff, 0xff, 0xff };
> > +	u8 pcicfg;
> >  
> >  	ide_setup_pci_noise(dev, d);
> >  
> > @@ -163,6 +164,13 @@ static int __devinit cs5520_init_one(str
> >  		return -ENODEV;
> >  	}
> >  
> > +	pci_read_config_byte(dev, 0x60, &pcicfg);
> > +
> > +	if ((pcicfg & 0x40) == 0) {
> > +		printk(KERN_WARNING "cs5520: DMA mode disabled. Enabling.\n");
> > +		pci_write_config_byte(dev, 0x60, pcicfg | 0x40);
> > +	}
> > +
> >  	/*
> >  	 *	Now the chipset is configured we can let the core
> >  	 *	do all the device setup for us
