Return-Path: <linux-kernel-owner+w=401wt.eu-S1753594AbZG0Gp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbZG0Gp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 02:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZG0Gp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 02:45:27 -0400
Received: from usul.saidi.cx ([204.11.33.34]:56913 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753289AbZG0Gp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 02:45:26 -0400
X-Greylist: delayed 2285 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 02:45:25 EDT
Date: Sun, 26 Jul 2009 23:06:30 -0700
From: Philip Langdale <philipl@overt.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Fleming <matt@console-pimps.org>, ohad@bencohen.org,
       ian@mnementh.co.uk, pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-l@jasper.es
Subject: Re: New MMC maintainer needed
Message-ID: <20090726230630.7598fbe4@fido2.homeip.net>
In-Reply-To: <20090724152944.51402e87.akpm@linux-foundation.org>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<4A67A9E8.5080002@mnementh.co.uk>
	<20090723055447.GA12211@console-pimps.org>
	<20090722232259.d0ff3495.akpm@linux-foundation.org>
	<20090724152944.51402e87.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.4; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 15:29:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 23 Jul 2009 14:52:09 +0100
> Matt Fleming <matt@console-pimps.org> wrote:
> 
> > On Thu, Jul 23, 2009 at 09:50:03AM +0300, Ohad Ben-Cohen wrote:
> > > Hi Andrew,
> > > 
> > > On Thu, Jul 23, 2009 at 9:22 AM, Andrew
> > > Morton<akpm@linux-foundation.org> wrote:
> > > > I actually already have a little pile of MMC things queued:
> > > 
> > > Please also consider queuing up the attached patch as well.
> > > 
> > > The patch is removing the current SDIO cards 1.8V limit, which is
> > > needed for embedded
> > > SDIO devices like TI 127x WLAN devices (with 1.8V MMC controllers
> > > like we have on the ZOOM2 boards for example).
> > > 
> > > Thank you,
> > > Ohad.
> > 
> > > From f9ba45b537dd12fc09443ee29c48860665f8ac82 Mon Sep 17 00:00:00
> > > 2001 From: Ohad Ben-Cohen <ohad@bencohen.org>
> > > Date: Wed, 15 Jul 2009 09:21:41 +0300
> > > Subject: [PATCH] sdio: do not ignore MMC_VDD_165_195
> > > 
> > > This is needed for 1.8V embedded SDIO devices and supporting host
> > > controllers (e.g. TI 127x and ZOOM2 boards)
> > > 
> > > Signed-off-by: Ohad Ben-Cohen <ohad@bencohen.org>
> > > ---
> > >  drivers/mmc/core/sdio.c |    7 -------
> > >  1 files changed, 0 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> > > index fb99ccf..6f221dc 100644
> > > --- a/drivers/mmc/core/sdio.c
> > > +++ b/drivers/mmc/core/sdio.c
> > > @@ -275,13 +275,6 @@ int mmc_attach_sdio(struct mmc_host *host,
> > > u32 ocr) ocr &= ~0x7F;
> > >  	}
> > >  
> > > -	if (ocr & MMC_VDD_165_195) {
> > > -		printk(KERN_WARNING "%s: SDIO card claims to
> > > support the "
> > > -		       "incompletely defined 'low voltage
> > > range'. This "
> > > -		       "will be ignored.\n", mmc_hostname(host));
> > > -		ocr &= ~MMC_VDD_165_195;
> > > -	}
> > > -
> > >  	host->ocr = mmc_select_voltage(host, ocr);
> > >  
> > >  	/*
> > > -- 
> > > 1.5.4.3
> > > 
> > 
> > Looks OK to me, I'm unaware of a reason to not allow a card to use
> > MMC_VDD_165_195 if that's what it wants.
> > 
> 
> Yes, that code was there from day #1, via Pierre's original commit.
> There is no indication in either the code comments or the changelog
> why it was done this way.
> 
> Other ways of finding out why this code is there include:
> 
> a) search the mailing list for review discussion.  I can't find it
>    in my lkml archive.
> 
> b) ask Pierre :)

Both the (Simplified) SD and SDIO specifications do not formally define
the 'low voltage' range in the way the MMC spec does. ie: You won't
find anything in the SD specs that even tell you what the range is -
it just says that it exists.

So we (I wrote the first incarnation of this check for normal SD cards)
decided to bail if a card requested the low voltage range. Now, if
there's actually hardware out there that is SD/SDIO and operates at
1.8V, we should probably do something more appropriate. :-)

It's obviously an easy change but I'd feel a lot more comfortable if
someone can point us to a document that states that the SD/SDIO low
voltage range is defined to match the MMC one. Maybe one of the NDA
docs actually states this.

Andrew - I'm also willing to be cc'ed on MMC changes and I'll respond
to the best of my (limited) abilities.

--phil
