Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbZAGSM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbZAGSM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759773AbZAGSMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:12:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54853 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbZAGSMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:12:45 -0500
Date: Wed, 7 Jan 2009 19:12:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] 2.6.28-git LOCKDEP: Possible recursive rq->lock
Message-ID: <20090107181233.GG24982@elte.hu>
References: <1231092523.29980.4.camel@twins> <20090105040635.GF4301@dirshya.in.ibm.com> <20090105130638.GB6014@elte.hu> <20090107114947.GJ4574@dirshya.in.ibm.com> <20090107122913.GL4574@dirshya.in.ibm.com> <1231333963.11687.288.camel@twins> <20090107142009.GM4574@dirshya.in.ibm.com> <1231338537.11687.295.camel@twins> <20090107163100.GO4574@dirshya.in.ibm.com> <20090107180937.GP4574@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107180937.GP4574@dirshya.in.ibm.com>
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


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2009-01-07 22:01:00]:
> 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-01-07 15:28:57]:
> > 
> > > On Wed, 2009-01-07 at 19:50 +0530, Vaidyanathan Srinivasan wrote:
> > > > * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-01-07 14:12:43]:
> > > > 
> > > > > On Wed, 2009-01-07 at 17:59 +0530, Vaidyanathan Srinivasan wrote:
> > > > > 
> > > > > > =============================================
> > > > > > [ INFO: possible recursive locking detected ]
> > > > > > 2.6.28-autotest-tip-sv #1
> > > > > > ---------------------------------------------
> > > > > > klogd/5062 is trying to acquire lock:
> > > > > >  (&rq->lock){++..}, at: [<ffffffff8022aca2>] task_rq_lock+0x45/0x7e
> > > > > > 
> > > > > > but task is already holding lock:
> > > > > >  (&rq->lock){++..}, at: [<ffffffff805f7354>] schedule+0x158/0xa31
> > > > > > 
> > > > > > other info that might help us debug this:
> > > > > > 1 lock held by klogd/5062:
> > > > > >  #0:  (&rq->lock){++..}, at: [<ffffffff805f7354>] schedule+0x158/0xa31
> > > > > > 
> > > > > > stack backtrace:
> > > > > > Pid: 5062, comm: klogd Not tainted 2.6.28-autotest-tip-sv #1
> > > > > > Call Trace:
> > > > > >  [<ffffffff80259ef1>] __lock_acquire+0xeb9/0x16a4
> > > > > >  [<ffffffff8025a6c0>] ? __lock_acquire+0x1688/0x16a4
> > > > > >  [<ffffffff8025a761>] lock_acquire+0x85/0xa9
> > > > > >  [<ffffffff8022aca2>] ? task_rq_lock+0x45/0x7e
> > > > > >  [<ffffffff805fa4d4>] _spin_lock+0x31/0x66
> > > > > >  [<ffffffff8022aca2>] ? task_rq_lock+0x45/0x7e
> > > > > >  [<ffffffff8022aca2>] task_rq_lock+0x45/0x7e
> > > > > >  [<ffffffff80233363>] try_to_wake_up+0x88/0x27a
> > > > > >  [<ffffffff80233581>] wake_up_process+0x10/0x12
> > > > > >  [<ffffffff805f775c>] schedule+0x560/0xa31
> > > > > 
> > > > > I'd be most curious to know where in schedule we are.
> > > > 
> > > > ok, we are in sched.c:3777
> > > > 
> > > >                 double_unlock_balance(this_rq, busiest);
> > > >                 if (active_balance)
> > > > >>>>>>>>>>>              wake_up_process(busiest->migration_thread);
> > > > 
> > > >         } else  
> > > > 
> > > > In active balance in newidle.  This implies sched_mc was 2 at that time.
> > > > let me trace this and debug further.
> > > 
> > > How about something like this? Strictly speaking we'll not deadlock,
> > > because ttwu will not be able to place the migration task on our rq, but
> > > since the code can deal with both rqs getting unlocked, this seems the
> > > easiest way out.
> > 
> > Hi Peter,
> > 
> > I agree.  Unlocking this_rq is an easy way out.  Thanks for the
> > suggestion.  I have moved the unlock and lock withing the if
> > condition.
> > 
> > --Vaidy
> > 
> >         sched: bug fix -- do not call ttwu while holding rq->lock
> >     
> >         When sched_mc=2 wake_up_process() is called on busiest_rq
> >         while holding this_rq lock in load_balance_newidle()
> >         Though this will not deadlock, this is a lockdep warning
> >         and the situation is easily solved by releasing the this_rq
> >         lock at this point in code
> >     
> >     Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 71a054f..703a669 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -3773,8 +3773,12 @@ redo:
> >                 }
> >  
> >                 double_unlock_balance(this_rq, busiest);
> > -               if (active_balance)
> > +               if (active_balance) {
> > +                       /*  Should not call ttwu while holding a rq->lock */
> > +                       spin_unlock(&this_rq->lock);
> >                         wake_up_process(busiest->migration_thread);
> > +                       spin_lock(&this_rq->lock);
> > +               }
> >  
> >         } else
> >                 sd->nr_balance_failed = 0;
> 
> 
> Hi Peter and Ingo,
> 
> The above fix seem to have fixed the lockdep warning.  Please include
> in sched-tip for further testing and later push to mainline.

already in tip/sched/urgent, thanks guys!

	Ingo
