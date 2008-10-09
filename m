Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbYJIVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbYJIVWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753565AbYJIVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:22:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYJIVWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:22:37 -0400
Date: Thu, 9 Oct 2008 23:22:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched_clock: prevent scd->clock from moving backwards
Message-ID: <20081009212219.GA10675@elte.hu>
References: <48D959E8.4000303@goop.org> <1223470773.6336.13.camel@norville.austin.ibm.com> <1223470854.6336.15.camel@norville.austin.ibm.com> <1223507104.7382.6.camel@lappy.programming.kicks-ass.net> <20081009090605.GA21798@elte.hu> <20081009151703.GA8010@elte.hu> <1223574862.6407.16.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223574862.6407.16.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Thu, 2008-10-09 at 17:17 +0200, Ingo Molnar wrote:
> 
> > hm, -tip testing found a sporadic hard lockup during bootup, and i've 
> > bisected it back to this patch. They happened on 64-bit test-systems. 
> > I've attached the .config that produced the problem.
> > 
> > i reverted the patch and the lockups went away. But i cannot see what's 
> > wrong with it ...
> 
> I could have sworn I ran with the patch, but maybe I got my patch queue
> messed up and never tested it right.
> 
> I think I see the problem.
> 
> --- a/kernel/sched_clock.c
> +++ b/kernel/sched_clock.c
> @@ -118,13 +118,13 @@ static u64 __update_sched_clock(struct
> sched_clock_data *scd, u64 now)
>  
>         /*
>          * scd->clock = clamp(scd->tick_gtod + delta,
> -        *                    max(scd->tick_gtod, scd->clock),
> -        *                    scd->tick_gtod + TICK_NSEC);
> +        *                    max(scd->tick_gtod, scd->clock),
> +        *                    min(scd->clock, scd->tick_gtod +
> TICK_NSEC));
>          */
>  
>         clock = scd->tick_gtod + delta;
>         min_clock = wrap_max(scd->tick_gtod, scd->clock);
> -       max_clock = scd->tick_gtod + TICK_NSEC;
> +       max_clock = wrap_min(scd->clock, scd->tick_gtod + TICK_NSEC);
>  
>         clock = wrap_max(clock, min_clock);
>         clock = wrap_min(clock, max_clock);
> 
> We want wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC), not
> wrap_min(). [...]

ah, so the lockup bug was probably that sched_clock() was never going 
forwards properly so some task was scheduled forever and livelocked the 
system?

> [...] The problem I am trying to fix is that scd->tick_gtod + 
> TICK_NSEC may be too low.  The upper bound needs to be at LEAST 
> scd->clock.  Limiting it to scd->clock all the time is disastrous.
> :-)
> 
> I'll fix the patch and retest it before sending it again.
> 
> Sorry about my sloppiness.

no problem - and it's good that our bad-patch filters worked properly 
and efficiently :-)

	Ingo
