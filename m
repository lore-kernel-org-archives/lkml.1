Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbYDYHsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbYDYHsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758958AbYDYHsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:48:38 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:16371 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759303AbYDYHse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:48:34 -0400
Subject: Re: [git pull] scheduler/misc fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080424.204620.88617191.davem@davemloft.net>
References: <20080424225530.GA8717@elte.hu>
	 <20080424.204620.88617191.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Apr 2008 09:48:30 +0200
Message-Id: <1209109710.7115.400.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 20:46 -0700, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 25 Apr 2008 00:55:30 +0200
> 
> > 
> > Linus, please pull the latest scheduler/misc fixes git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-fixes.git for-linus
> > 
> > a scheduler fix, a (long-standing) seqlock fix and a softlockup+nohz 
> > fix.
> 
> Correction, the softlock+nohz patch here doesn't actually fix the
> reported regression.  It fixes some other theoretical bug you
> discovered while trying to fix the regression reports.


> ﻿diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d358d4e..b854a89 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -393,6 +393,7 @@ void tick_nohz_restart_sched_tick(void)
>                 sub_preempt_count(HARDIRQ_OFFSET);
>         }
>  
> +       touch_softlockup_watchdog();
>         /*
>          * Cancel the scheduled timer and restore the tick
>          */


That actually does solve the problem (I tested, as have you:
http://lkml.org/lkml/2008/4/22/98).

However, in that email referenced above you rightly point out that its
likely working around a bug rather than fixing it. I agree.

So it used to work; and these two commits:


commit 15934a37324f32e0fda633dc7984a671ea81cd75
Author: Guillaume Chazarain <guichaz@yahoo.fr>
Date:   Sat Apr 19 19:44:57 2008 +0200

    sched: fix rq->clock overflows detection with CONFIG_NO_HZ

    When using CONFIG_NO_HZ, rq->tick_timestamp is not updated every TICK_NSEC.
    We check that the number of skipped ticks matches the clock jump seen in
    __update_rq_clock().

    Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>


commit 27ec4407790d075c325e1f4da0a19c56953cce23
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Feb 28 21:00:21 2008 +0100

    sched: make cpu_clock() globally synchronous

    Alexey Zaytsev reported (and bisected) that the introduction of
    cpu_clock() in printk made the timestamps jump back and forth.

    Make cpu_clock() more reliable while still keeping it fast when it's
    called frequently.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>


break the thing - that is, they generate false softlockup msgs.

Reverting them does indeed make them go away.

You've said (http://lkml.org/lkml/2008/4/24/77 and in testing on your
machine I have indeed found that so) that sparc64's sched_clock() is
rock solid.

So what I've done is (-linus without the above two commits):

unsigned long long cpu_clock(int cpu)
{
        unsigned long long now;
        unsigned long flags;
        struct rq *rq;

        /*
         * Only call sched_clock() if the scheduler has already been
         * initialized (some code might call cpu_clock() very early):
         */
        if (unlikely(!scheduler_running))
                return 0;

#if 0
        local_irq_save(flags);
        rq = cpu_rq(cpu);
        update_rq_clock(rq);
        now = rq->clock;
        local_irq_restore(flags);
#else
        now = sched_clock();
#endif

        return now;
}

This cuts out all the rq->clock logic and should give a stable time on
your machine.

Lo and Behold, the softlockups are back!


Now things get a little hazy:

 a) 15934a37324f32e0fda633dc7984a671ea81cd75 does indeed fix a bug in
    rq->clock; without that patch it compresses nohz time to a single
    jiffie, so cpu_clock() which (without the above hack) is based on
    rq->clock will be short on nohz time. This can 'hide' the clock jump
    and thus hide false positives.


 b) there is commit:

---
commit d3938204468dccae16be0099a2abf53db4ed0505
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Nov 28 15:52:56 2007 +0100
    softlockup: fix false positives on CONFIG_NOHZ

    David Miller reported soft lockup false-positives that trigger
    on NOHZ due to CPUs idling for more than 10 seconds.

    The solution is touch the softlockup watchdog when we return from
    idle. (by definition we are not 'locked up' when we were idle)

     http://bugzilla.kernel.org/show_bug.cgi?id=9409

    Reported-by: David Miller <davem@davemloft.net>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 27a2338..cb89fa8 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -133,6 +133,8 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
+	touch_softlockup_watchdog();
+
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();

---

    which should 'fix' this problem.


 c) there are 'IPI' handlers on SPARC64 that look like they can wake
    the CPU from idle sleep but do not appear to call irq_enter() which
    has the above patch's touch_softlock_watchdog() in its callchain.

tl0_irq1:       TRAP_IRQ(smp_call_function_client, 1)
tl0_irq2:       TRAP_IRQ(smp_receive_signal_client, 2)
tl0_irq3:       TRAP_IRQ(smp_penguin_jailcell, 3)
tl0_irq4:       TRAP_IRQ(smp_new_mmu_context_version_client, 4)



So the current working thesis is that the bug in a) hides a real problem
not quite fixed by b) and exploited by c).

When I tried to build a state machine to validate this thesis the kernel
blew up on me, so I guess I need to go get my morning juice and try
again ;-)

Insight into the above is appreciated as I'm out on a limb on two
fronts: nohz and sparc64 :-)

/me goes onward testing..




