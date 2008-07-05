Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYGEP4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYGEP4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYGEP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:56:23 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:15287 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYGEP4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:56:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=uzocBrMeemjGD8mRQ+TKb9bPVpAsd+deBGd4ntVFZ35y6HxMqpQilM3qGvhyw+jTtu
         pYLSjF5h7s9wEUl96zrNHI0bJZ45ompMhCdE1x7OD85G3Ar4WR+KQsK7AbofLC3JFKbu
         h04Gy7qnWN+7NscR2LbafXKKkXn4oxBhnOIvU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/4] ide-pmac: media-bay support fixes
Date: Sat, 5 Jul 2008 17:56:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200806162124.43005.bzolnier@gmail.com> <1215067667.21182.98.camel@pasglop> <1215070435.21182.107.camel@pasglop>
In-Reply-To: <1215070435.21182.107.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807051756.26506.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 03 July 2008, Benjamin Herrenschmidt wrote:
> On Thu, 2008-07-03 at 16:47 +1000, Benjamin Herrenschmidt wrote:
> > > Took me a while, kid was sick.
> > > 
> > > They apply on 20080625 (with various offset/fuzz but they do apply) and
> > > the tree builds. The media bay however fails the same way as before with
> > > IDE register errors.
> > > 
> > > I'll see if I can find where they come from.
> > 
> > Found multiple issues related to the ide-pmac <-> mediabay & ide core
> > interaction changes. I've done some fixes but it's not quite there yet.
> > It looks like it's getting IRQ issues with the mediabay CD, for some
> > reasons looks like something unmasks the interrupt before there's a
> > handler or around those lines... I get an irq "nobody cared" error, it
> > gets disabled, and then hdc gets lost interrupts.
> > 
> > I'll dig a bit more and if I can't find what's up tonight, will send
> > you my current patches in case you have some other idea.
> 
> Ok, so the interrupt stuff is weird, I need to dig more. I get basically
> what looks like an interrupt storm in the enable_irq() after the probing
> of the drives. I know the media-bay IDE has some weird behaviours at
> probe time but that's not quite something I saw before. I'll have to
> debug more.

This may be generic ide problem uncovered by media-bay changes.

In init_irq() we unmask IRQs just before registering IRQ handler but we
we don't clear pending IRQs before the unmask (simply reading the Status
register should be enough).

[ Previously ide_port_wait_ready() would do it during ide_device_add()
  call and before the IRQ handler is registered but now it will be skipped
  because of ->noprobe being set. ]

> In the meantime, here's the hacks I applied to your patch series to get
> things mostly going (appart from that bug, which we -do- need to fix,
> but give me a bit more time to track it down). You'll probably want to
> integrate the fixes with your patches and remove the debug stuff :-)

Thanks!!

> You'll notice that I created a new state for when the media-bay is up
> but IDE hasn't registered in yet. This might disappear in the future
> when I do the libata bits but for now it fixes a few issues where
> noprobe was never set properly, or if set, it would try to probe the
> drives twice and blow up...
> 
> (The problem was either noprobe would stay set to 1 with your old code,
> despite the clearing in the mediabay case because pmac_ide_init_dev
> would set it back to 1. If you fix that you get into a case where
> the bay is "up" before IDE is ready, and when IDE gets ready, both
> the idea layer and the bay code race to trigger a probe).

Arrghhh, this was actually caused by a brain glitch on my side...

While preparing this patch I was under the impression that ->init_dev can
be called only by ide through ide_device_add(), which is of course untrue
since it can be called by mediabay through ide_port_scan()...

However when I think deeper about it I recall that I first implemented
it as ->init_hwif (for which the assumption was true) and later converted
the patch to ->init_dev because I noticed the assumption and realized
that it needs to be ->init_dev to make it work for warm-plug...

Scary... :)

> Ben.
> 
> Index: linux-work/drivers/ide/ide-probe.c
> ===================================================================
> --- linux-work.orig/drivers/ide/ide-probe.c	2008-07-03 15:50:24.000000000 +1000
> +++ linux-work/drivers/ide/ide-probe.c	2008-07-03 17:14:42.000000000 +1000
> @@ -770,11 +770,15 @@ static int ide_probe_port(ide_hwif_t *hw
>  	unsigned int irqd;
>  	int unit, rc = -ENODEV;
>  
> -	BUG_ON(hwif->present);
> -
> +	printk("ide_probe_port(%s) noprobe=%d,%d\n",
> +	       hwif->name, hwif->drives[0].noprobe, hwif->drives[1].noprobe);
>  	if (hwif->drives[0].noprobe && hwif->drives[1].noprobe)
>  		return -EACCES;
>  
> +	WARN_ON(hwif->present);
> +	if (hwif->present)
> +		return 0;
> +

This is a kind of tangential issue to pmac stuff.

Could you resend it as a separate patch with your S-o-b: line?

>  	/*
>  	 * We must always disable IRQ, as probe_for_drive will assert IRQ, but
>  	 * we'll install our IRQ driver much later...
> @@ -798,6 +802,7 @@ static int ide_probe_port(ide_hwif_t *hw
>  		(void) probe_for_drive(drive);
>  		if (drive->present)
>  			rc = 0;
> +		ide_busy_sleep(hwif);

I don't quite get this chunk.

Is it a workaround for interrupt storm problem?

[...]

I integrated the rest in a verbatim form with pmac patches
(two of them got 'take 4' as a result, the other two remain unchanged):

pmac-media-bay-support-fixes-take-4.patch
pmac-store-pmif-instead-of-hwif-in-driver_data-take-2.patch
pmac-add-init_dev-method-take-4.patch
pmac-move-ide_find_port-call-to-pmac_ide_setup_device-take-2.patch

[ in the usual place ]

Thanks,
Bart
