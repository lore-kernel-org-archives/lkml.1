Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYDWIu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYDWIu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYDWIuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:50:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41219 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbYDWIut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:50:49 -0400
Date: Wed, 23 Apr 2008 10:50:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch] softlockup: fix false positives on nohz if CPU is 100%
	idle for more than 60 seconds
Message-ID: <20080423085030.GA22309@elte.hu>
References: <20080422.015931.70144614.davem@davemloft.net> <20080422091456.GC9939@elte.hu> <20080422.030519.259068348.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422.030519.259068348.davem@davemloft.net>
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> > +++ linux/kernel/time/tick-sched.c
> > @@ -393,6 +393,7 @@ void tick_nohz_restart_sched_tick(void)
> >  		sub_preempt_count(HARDIRQ_OFFSET);
> >  	}
> >  
> > +	touch_softlockup_watchdog();
> >  	/*
> >  	 * Cancel the scheduled timer and restore the tick
> >  	 */
> 
> The NOHZ lockup warnings are gone.  But this seems like a band-aid.  
> We made sure that cpus don't get into this state via commit:

but that commit:

> @@ -133,6 +133,8 @@ void tick_nohz_update_jiffies(void)
>  	if (!ts->tick_stopped)
>  		return;
>  
> +	touch_softlockup_watchdog();
> +
>  	cpu_clear(cpu, nohz_cpu_mask);
>  	now = ktime_get();

updates the softlockup watchdog before we update jiffies:

>       ts->idle_waketime = now;
>
>       local_irq_save(flags);
>       tick_do_update_jiffies64(now);
>       local_irq_restore(flags);

so the patch i gave you first should do the trick - the cleaner patch is 
attached below.

> While what the guilty patch we're discussing here does is change how 
> cpu_clock() is computed, that's it.  softlockup uses cpu_clock() to 
> calculate it's timestamp.  The guilty change modified nothing about 
> when touch_softlockup_watchdog() is called, nor any other aspect about 
> how the softlockup mechanism itself works.
> 
> So we need to figure out why in the world changing how cpu_clock() 
> gets calculated makes a difference.

the thing is that that change _fixed_ cpu_clock() - and exposed the 
latent softlockup/nohz interaction that was always there and which 
caused false positives if a CPU stayed idle for more than 60 seconds.

	Ingo

------------------>
Subject: softlockup: fix false positives on nohz if CPU is 100% idle for more than 60 seconds
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 23 10:01:08 CEST 2008

David Miller reported softlockup false positives on his 128-way Niagara2 
system. The special thing about that system is extremely long clockevent 
timeouts combined with extremly long idle times.

Fix rq->clock update bug that can trigger on such a system: in 
tick_nohz_update_jiffies() [which is called on all irq entry on all cpus 
where the irq entry hits an idle cpu] we call 
touch_softlockup_watchdog() before we update jiffies. That works fine 
most of the time when idle timeouts are within 60 seconds. But when an 
idle timeout is beyond 60 seconds, jiffies is updated with a jump of 
more than 60 seconds, which causes a jump in cpu-clock of more than 60 
seconds, triggering a false positive.

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -133,8 +133,6 @@ void tick_nohz_update_jiffies(void)
 	if (!ts->tick_stopped)
 		return;
 
-	touch_softlockup_watchdog();
-
 	cpu_clear(cpu, nohz_cpu_mask);
 	now = ktime_get();
 	ts->idle_waketime = now;
@@ -142,6 +140,8 @@ void tick_nohz_update_jiffies(void)
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
 	local_irq_restore(flags);
+
+	touch_softlockup_watchdog();
 }
 
 void tick_nohz_stop_idle(int cpu)
