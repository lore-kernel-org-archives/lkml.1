Return-Path: <linux-kernel-owner+w=401wt.eu-S1423261AbXBUX1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423261AbXBUX1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423270AbXBUX1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:27:52 -0500
Received: from raven.upol.cz ([158.194.120.4]:55680 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423261AbXBUX1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:27:51 -0500
To: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
In-Reply-To: <20070221144806.e6eed85c.akpm@linux-foundation.org>
References: <20070220172544.15678.patches@notabene> <1070220063516.16208@suse.de> <20070221144806.e6eed85c.akpm@linux-foundation.org>
Date: Thu, 22 Feb 2007 00:36:22 +0100
Message-Id: <E1HK10Y-0001MY-CB@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton
> Newsgroups: gmane.linux.raid,gmane.linux.kernel
> Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
> Date: Wed, 21 Feb 2007 14:48:06 -0800

Hallo.

> On Tue, 20 Feb 2007 17:35:16 +1100
> NeilBrown <neilb@suse.de> wrote:
>
>> +		for (i = conf->raid_disks ; i-- ;  ) {
>
> That statement should be dragged out, shot, stomped on then ceremonially
> incinerated.
>
> What's wrong with doing
>
> 	for (i = 0; i < conf->raid_disks; i++) {
>
> in a manner which can be understood without alcoholic fortification?
>
> ho hum.

In case someone likes to do job, GCC usually ought to do, i would
suggest something like this instead:

       if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
               /* Need to write out all blocks after computing P&Q */
-               sh->disks = conf->raid_disks;
+	       	i = conf->raid_disks;
+		sh->disks = i;
-               sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
-                                            conf->raid_disks);
+               sh->pd_idx = stripe_to_pdidx(sh->sector, conf, i);

               compute_parity6(sh, RECONSTRUCT_WRITE);
-               for (i = conf->raid_disks ; i-- ;  ) {
+		do {
                       set_bit(R5_LOCKED, &sh->dev[i].flags);
                       locked++;
                       set_bit(R5_Wantwrite, &sh->dev[i].flags);
-               }
+		} while (--i);

               clear_bit(STRIPE_EXPANDING, &sh->state);
       } else if (expanded) {

In any case this is subject of scripts/bloat-o-meter.
____
