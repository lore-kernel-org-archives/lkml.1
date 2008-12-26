Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbYLZJIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbYLZJIh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYLZJIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:08:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58281 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYLZJIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:08:20 -0500
Date: Fri, 26 Dec 2008 10:07:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-cpu-timers: clock_gettime(CLOCK_*_CPUTIME_ID)
	goes backward
Message-ID: <20081226090758.GB27747@elte.hu>
References: <49547320.9010302@jp.fujitsu.com> <20081226084320.GC755@elte.hu> <1230282171.9487.278.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230282171.9487.278.camel@twins>
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

> On Fri, 2008-12-26 at 09:43 +0100, Ingo Molnar wrote:
> > * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> > 
> > > @@ -321,7 +287,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
> > >  		cpu->cpu = cputime.utime;
> > >  		break;
> > >  	case CPUCLOCK_SCHED:
> > > -		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
> > > +		cpu->sched = cputime.sum_exec_runtime;
> > >  		break;
> > >  	}
> > 
> > hm, doesnt this regress precision?
> 
> No, he folds it into:
> 
> > +void thread_group_cputime(struct task_struct *p, struct task_cputime *times)
> > +{
> > +       unsigned long flags;
> > +       struct rq *rq;
> > +       u64 delta_exec = 0;
> > +       struct task_cputime *tot;
> > +       struct signal_struct *sig;
> > +       int i;
> > +
> > +       sig = p->signal;
> > +       if (unlikely(!sig) || !sig->cputime.totals) {
> > +               times->utime = p->utime;
> > +               times->stime = p->stime;
> > +               times->sum_exec_runtime = task_total_exec(p);
> > +               return;
> > +       }
> > +
> > +       times->stime = times->utime = cputime_zero;
> > +       times->sum_exec_runtime = 0;
> > +
> > +       rq = task_rq_lock(p, &flags);
> > +
> > +       if (task_current(rq, p)) {
> > +               update_rq_clock(rq);
> > +               delta_exec = rq->clock - p->se.exec_start;
> > +               if ((s64)delta_exec < 0)
> > +                       delta_exec = 0;
> > +       }
> > +
> > +       for_each_possible_cpu(i) {
> > +               tot = per_cpu_ptr(p->signal->cputime.totals, i);
> > +               times->utime = cputime_add(times->utime, tot->utime);
> > +               times->stime = cputime_add(times->stime, tot->stime);
> > +               times->sum_exec_runtime += tot->sum_exec_runtime;
> > +       }
> > +       times->sum_exec_runtime += delta_exec;
> > +
> > +       task_rq_unlock(rq, &flags);
> > +}
> 
> Which reminds me, why do we still have this crap in the kernel? I 
> thought we pretty much showed the per-cpu itimer thing was utter crap? 
> -- can we pretty please either revert that or apply 
> http://lkml.org/lkml/2008/11/24/183 ?

yes, i agree with that patch - could you please send it with a signoff?

> Also, I really don't like the above, we now do the per-cpu loop with the 
> RQ lock held...

yes.

	Ingo
