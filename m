Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbYGRW2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbYGRW2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYGRW2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:28:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbYGRW2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:28:10 -0400
Date: Sat, 19 Jul 2008 00:27:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jack Ren <jack.ren@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
Message-ID: <20080718222754.GE31073@elte.hu>
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com> <20080718102446.GV6875@elte.hu> <20080718105424.GA22268@elte.hu> <1216379283.28405.19.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216379283.28405.19.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2008-07-18 at 12:54 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -4446,7 +4446,8 @@ need_resched_nonpreemptible:
> > >  		rq->nr_switches++;
> > >  		rq->curr = next;
> > >  		++*switch_count;
> > > -
> > > +		if (rq->curr != rq->idle)
> > > +			tick_nohz_restart_sched_tick();
> > >  		context_switch(rq, prev, next); /* unlocks the rq */
> > 
> > hm, one problem i can see is lock dependencies. This code is executed 
> > with the rq lock while tick_nohz_restart_sched_tick() takes hr locks => 
> > not good. So i havent applied this just yet - this needs to be solved 
> > differently.
> 
> Actually, that should work these days...
> 
> Also, I assume Eric actually tested this with lockdep enabled (right, 
> Eric?) and that'll shout - or rather, lockup hard in this case - if 
> you got it wrong.

nope:

[    0.188011] =================================
[    0.188011] [ INFO: inconsistent lock state ]
[    0.188011] 2.6.26-tip-03835-g9d964b9-dirty #20198
[    0.188011] ---------------------------------
[    0.188011] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[    0.188011] swapper/0 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    0.188011]  (&rq->rq_lock_key){+...}, at: [<ffffffff816a4b35>] schedule+0x191/0x900
[    0.188011] {in-hardirq-W} state was registered at:
[    0.188011]   [<ffffffffffffffff>] 0xffffffffffffffff

	Ingo
