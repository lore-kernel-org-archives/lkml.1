Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbXK0KhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbXK0KhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXK0Kgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:36:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59745 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbXK0Kgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:36:54 -0500
Date: Tue, 27 Nov 2007 11:36:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] softlockup: do the wakeup from a hrtimer
Message-ID: <20071127103642.GE6286@elte.hu>
References: <20071120084611.GA18721@elte.hu> <20071126152652.8db2793a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126152652.8db2793a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 20 Nov 2007 09:46:11 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Subject: softlockup: do the wakeup from a hrtimer
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > David Miller reported soft lockup false-positives that trigger on NOHZ 
> > due to CPUs idling for more than 10 seconds.
> > 
> > The solution is to drive the wakeup of the watchdog threads not from the 
> > timer tick (which has no guaranteed frequency), but from the watchdog 
> > tasks themselves.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9409
> > 
> > Reported-by: David Miller <davem@davemloft.net>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  kernel/softlockup.c |    6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > Index: linux/kernel/softlockup.c
> > ===================================================================
> > --- linux.orig/kernel/softlockup.c
> > +++ linux/kernel/softlockup.c
> > @@ -100,10 +100,6 @@ void softlockup_tick(void)
> >  
> >  	now = get_timestamp(this_cpu);
> >  
> > -	/* Wake up the high-prio watchdog task every second: */
> > -	if (now > (touch_timestamp + 1))
> > -		wake_up_process(per_cpu(watchdog_task, this_cpu));
> > -
> >  	/* Warn about unreasonable 10+ seconds delays: */
> >  	if (now <= (touch_timestamp + softlockup_thresh))
> >  		return;
> > @@ -141,7 +137,7 @@ static int watchdog(void *__bind_cpu)
> >  	while (!kthread_should_stop()) {
> >  		set_current_state(TASK_INTERRUPTIBLE);
> >  		touch_softlockup_watchdog();
> > -		schedule();
> > +		msleep(1000);
> >  	}
> >  
> >  	return 0;
> 
> I think you wanted msleep_interruptible() there to avoid contributing to
> load average?
> 
> The set_current_state() can go away.

these can be fixed, but:

> This will introduce an up-to-one-second delay in responding to 
> kthread_should_stop().  Is that bad?

grumble, it's bad. I guess David is right that this should be fixed the 
right way ;-) So the above patch cannot go in.

	Ingo
