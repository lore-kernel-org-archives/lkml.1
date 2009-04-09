Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbZDIBAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbZDIBAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 21:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZDIA7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:59:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33793 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbZDIA7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:59:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Anton Blanchard <anton@samba.org>
Subject: Re: + mm-align-vmstat_works-timer.patch added to -mm tree
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <20090407040404.GB9584@kryten>
References: <20090406120533.450B.A69D9226@jp.fujitsu.com> <20090407040404.GB9584@kryten>
Message-Id: <20090409095435.8D8D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Thu,  9 Apr 2009 09:59:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> 
> Hi,
> 
> > Do you have any mesurement data?
> 
> I was using a simple set of kprobes to look at when timers and
> workqueues fire.

ok. thanks.


> > The fact is, schedule_delayed_work(work, round_jiffies_relative()) is
> > a bit ill.
> > 
> > it mean
> >   - round_jiffies_relative() calculate rounded-time - jiffies
> >   - schedule_delayed_work() calculate argument + jiffies
> > 
> > it assume no jiffies change at above two place. IOW it assume
> > non preempt kernel.
> 
> I'm not sure we are any worse off here. Before the patch we could end up
> with all threads converging on the same jiffy, and once that happens
> they will continue to fire over the top of each other (at least until a
> difference in the time it takes vmstat_work to complete causes them to
> diverge again).
> 
> With the patch we always apply a per cpu offset, so should keep them
> separated even if jiffies sometimes changes between
> round_jiffies_relative() and schedule_delayed_work().

Well, ok I agree your patch don't have back step.

I mean I agree preempt kernel vs round_jiffies_relative() problem is
unrelated to your patch.


> > 2)
> > > -	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
> > > +	schedule_delayed_work_on(cpu, vmstat_work,
> > > +				 __round_jiffies_relative(HZ, cpu));
> > 
> > isn't same meaning.
> > 
> > vmstat_work mean to move per-cpu stastics to global stastics.
> > Then, (HZ + cpu) mean to avoid to touch the same global variable at the same time.
> 
> round_jiffies_common still provides per cpu skew doesn't it?
> 
>         /*
>          * We don't want all cpus firing their timers at once hitting the
>          * same lock or cachelines, so we skew each extra cpu with an extra
>          * 3 jiffies. This 3 jiffies came originally from the mm/ code which
>          * already did this.
>          * The skew is done by adding 3*cpunr, then round, then subtract this
>          * extra offset again.
>          */
> 
> In fact we are also skewing timer interrupts across half a timer tick in
> tick_setup_sched_timer:
> 
> 	/* Get the next period (per cpu) */
> 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
> 	offset = ktime_to_ns(tick_period) >> 1;
> 	do_div(offset, num_possible_cpus());
> 	offset *= smp_processor_id();
> 	hrtimer_add_expires_ns(&ts->sched_timer, offset);
> 
> I still need to see if I can measure a reduction in jitter by removing
> this half jiffy skew and aligning all timer interrupts. Assuming we skew
> per cpu work and timers, it seems like we shouldn't need to skew timer
> interrupts too.

Ah, you are perfectly right.
I missed it.


> > but I agree vmstat_work is one of most work queue heavy user.
> > For power consumption view, it isn't proper behavior.
> > 
> > I still think improving another way.
> 
> I definitely agree it would be nice to fix vmstat_work :)

Thank you for kindful explanation :)



