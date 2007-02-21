Return-Path: <linux-kernel-owner+w=401wt.eu-S1945925AbXBVACi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925AbXBVACi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945920AbXBVACi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:02:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945922AbXBVACh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:02:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Date: Thu, 22 Feb 2007 00:57:18 +0100
User-Agent: KMail/1.9.5
Cc: Oleg Verych <olecom@flower.upol.cz>, NeilBrown <neilb@suse.de>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070220172544.15678.patches@notabene> <E1HK10Y-0001MY-CB@flower> <20070221155820.de9f2f16.akpm@linux-foundation.org>
In-Reply-To: <20070221155820.de9f2f16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702220057.19167.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 February 2007 00:58, Andrew Morton wrote:
> On Thu, 22 Feb 2007 00:36:22 +0100
> Oleg Verych <olecom@flower.upol.cz> wrote:
> 
> > > From: Andrew Morton
> > > Newsgroups: gmane.linux.raid,gmane.linux.kernel
> > > Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
> > > Date: Wed, 21 Feb 2007 14:48:06 -0800
> > 
> > Hallo.
> > 
> > > On Tue, 20 Feb 2007 17:35:16 +1100
> > > NeilBrown <neilb@suse.de> wrote:
> > >
> > >> +		for (i = conf->raid_disks ; i-- ;  ) {
> > >
> > > That statement should be dragged out, shot, stomped on then ceremonially
> > > incinerated.
> > >
> > > What's wrong with doing
> > >
> > > 	for (i = 0; i < conf->raid_disks; i++) {
> > >
> > > in a manner which can be understood without alcoholic fortification?
> > >
> > > ho hum.
> > 
> > In case someone likes to do job, GCC usually ought to do, i would
> > suggest something like this instead:
> > 
> >        if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
> >                /* Need to write out all blocks after computing P&Q */
> > -               sh->disks = conf->raid_disks;
> > +	       	i = conf->raid_disks;
> > +		sh->disks = i;
> > -               sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
> > -                                            conf->raid_disks);
> > +               sh->pd_idx = stripe_to_pdidx(sh->sector, conf, i);
> > 
> >                compute_parity6(sh, RECONSTRUCT_WRITE);
> > -               for (i = conf->raid_disks ; i-- ;  ) {
> > +		do {
> >                        set_bit(R5_LOCKED, &sh->dev[i].flags);
> >                        locked++;
> >                        set_bit(R5_Wantwrite, &sh->dev[i].flags);
> > -               }
> > +		} while (--i);
> > 
> >                clear_bit(STRIPE_EXPANDING, &sh->state);
> >        } else if (expanded) {
> > 
> > In any case this is subject of scripts/bloat-o-meter.
> 
> This:
> 
> --- a/drivers/md/raid5.c~a
> +++ a/drivers/md/raid5.c
> @@ -2364,7 +2364,7 @@ static void handle_stripe6(struct stripe
>  		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
>  					     conf->raid_disks);
>  		compute_parity6(sh, RECONSTRUCT_WRITE);
> -		for (i = conf->raid_disks ; i-- ;  ) {
> +		for (i = 0; i < conf->raid_disks; ++) {

I guess it should be 

+		for (i = 0; i < conf->raid_disks; i++)

>  			set_bit(R5_LOCKED, &sh->dev[i].flags);
>  			locked++;
>  			set_bit(R5_Wantwrite, &sh->dev[i].flags);
> _
