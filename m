Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbZHTJ6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbZHTJ6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 05:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZHTJ6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 05:58:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42646 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbZHTJ6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 05:58:36 -0400
Date: Thu, 20 Aug 2009 11:58:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [circular locking bug] Re: [patch 00/15] clocksource /
	timekeeping rework V4 (resend V3 + bug fix)
Message-ID: <20090820095821.GA29093@elte.hu>
References: <1250300765.8269.29.camel@localhost.localdomain> <alpine.LFD.2.00.0908151057500.1283@localhost.localdomain> <20090815095221.GA15831@elte.hu> <alpine.LFD.2.00.0908151207000.1283@localhost.localdomain> <20090817094042.03fe5d38@skybase> <alpine.LFD.2.00.0908171038420.2782@localhost.localdomain> <20090817092807.GA10460@elte.hu> <20090818170942.3ab80c91@skybase> <20090819202554.GA19482@elte.hu> <20090820112820.47d833c1@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820112820.47d833c1@skybase>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Wed, 19 Aug 2009 22:25:54 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > ok, with all the latest patches i re-added these bits to 
> > -tip, and it triggered this lockdep assert on a testbox:
> 
> Another one :-(
> 
> > stack backtrace:
> > Pid: 1, comm: swapper Not tainted 2.6.31-rc6-tip-01234-gcc9be0e-dirty #1054
> > Call Trace:
> >  [<c106f430>] print_usage_bug+0x130/0x180
> >  [<c106f5eb>] mark_lock_irq+0x16b/0x260
> >  [<c106f240>] ? check_usage_forwards+0x0/0xc0
> >  [<c106f7fe>] mark_lock+0x11e/0x3a0
> >  [<c106fbff>] mark_irqflags+0x17f/0x190
> >  [<c107177a>] __lock_acquire+0x29a/0x520
> >  [<c1071a6a>] lock_acquire+0x6a/0xc0
> >  [<c10664d7>] ? clocksource_unregister+0x17/0x50
> >  [<c175719b>] __mutex_lock_common+0x3b/0x340
> >  [<c10664d7>] ? clocksource_unregister+0x17/0x50
> >  [<c1757551>] mutex_lock_nested+0x31/0x40
> >  [<c10664d7>] ? clocksource_unregister+0x17/0x50
> >  [<c10664d7>] clocksource_unregister+0x17/0x50
> >  [<c1008b3a>] pit_disable_clocksource+0x2a/0x40
> >  [<c1008bb9>] init_pit_timer+0x29/0xb0
> >  [<c106825a>] clockevents_set_mode+0x1a/0x50
> >  [<c1069a96>] tick_switch_to_oneshot+0x96/0xc0
> >  [<c1069ad2>] tick_init_highres+0x12/0x20
> >  [<c105e32d>] hrtimer_switch_to_hres+0x4d/0x100
> >  [<c105ebbd>] hrtimer_run_pending+0x4d/0x50
> >  [<c104bb85>] run_timer_softirq+0x25/0x230
> 
> Ok, the cause is that the i8253 pit clocksource code 
> tries to unregister a clocksource from a timer 
> interrupt. Bad idea with the new code. Why does the pit 
> clocksource have to >unregister< the clock if the 
> set_mode callback is called with 
> CLOCK_EVT_MODE_SHUTODWN, CLOCK_EVT_MODE_UNUSED, or 
> CLOCK_EVT_MODE_ONESHOT? Very strange, I would argue 
> that the clocksource should never unregister in the 
> set_mode callback, the timekeeping code should not use 
> the clocksource if it is unsuitable for e.g. the one 
> shot mode.

i think this 'execute timer management functions right 
from the deep bowels of time events' concept is 
fundamentally flawed and one big layering violation. It 
caused numerous problems (lockups, etc.) in the past.

There should be a time management kernel thread instead 
(or workqueue), which does a proper state machine of all 
these properties - without having to call this stuff from 
within a timer handler.

	Ingo
