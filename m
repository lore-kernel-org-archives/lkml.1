Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbYGRNwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbYGRNwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbYGRNwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:52:33 -0400
Received: from www.tglx.de ([62.245.132.106]:51352 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331AbYGRNwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:52:32 -0400
Date: Fri, 18 Jul 2008 15:52:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: eric miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jack Ren <jack.ren@marvell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH] sched: do not stop ticks when cpu is not idle
In-Reply-To: <20080718102446.GV6875@elte.hu>
Message-ID: <alpine.LFD.1.10.0807181548290.4316@apollo.tec.linutronix.de>
References: <f17812d70807172341u92270fdvc80e72cc5599c56f@mail.gmail.com> <20080718102446.GV6875@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Ingo Molnar wrote:
> 
> * eric miao <eric.y.miao@gmail.com> wrote:
> 
> > Issue: the sched tick would be stopped in some race conditions.
> 
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -4027,7 +4027,8 @@ need_resched_nonpreemptible:
> >  		rq->nr_switches++;
> >  		rq->curr = next;
> >  		++*switch_count;
> > -
> > +		if (rq->curr != rq->idle)
> > +			tick_nohz_restart_sched_tick();
> >  		context_switch(rq, prev, next); /* unlocks the rq */
> 
> applied to tip/sched/urgent, thanks Eric.
> 
> Thomas, Peter, Dmitry, do you concur with the analysis? (commit below) 

Yes. I did not understand the issue when Jack pointed it out to me,
but with Erics explanation it's really clear. Thanks for tracking that
down.

> It looks a bit ugly to me in the middle of schedule() - is there no wait 
> to solve this within kernel/time/*.c ?

Hmm, yes. I think the proper fix is to enable the tick stop mechanism
in the idle loop and disable it before we go to schedule. That takes
an additional parameter to tick_nohz_stop_sched_tick(), but we then
gain a very clear section where the nohz mimic can be active.

I'll whip up a patch.

Thanks,

	tglx
