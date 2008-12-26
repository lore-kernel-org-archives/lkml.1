Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYLZJDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYLZJDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYLZJCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:02:52 -0500
Received: from viefep18-int.chello.at ([62.179.121.38]:11477 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753000AbYLZJCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:02:50 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] posix-cpu-timers: clock_gettime(CLOCK_*_CPUTIME_ID)
 goes backward
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20081226084320.GC755@elte.hu>
References: <49547320.9010302@jp.fujitsu.com> <20081226084320.GC755@elte.hu>
Content-Type: text/plain
Date: Fri, 26 Dec 2008 10:02:51 +0100
Message-Id: <1230282171.9487.278.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-26 at 09:43 +0100, Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> 
> > @@ -321,7 +287,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
> >  		cpu->cpu = cputime.utime;
> >  		break;
> >  	case CPUCLOCK_SCHED:
> > -		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
> > +		cpu->sched = cputime.sum_exec_runtime;
> >  		break;
> >  	}
> 
> hm, doesnt this regress precision?

No, he folds it into:

> +void thread_group_cputime(struct task_struct *p, struct task_cputime *times)
> +{
> +       unsigned long flags;
> +       struct rq *rq;
> +       u64 delta_exec = 0;
> +       struct task_cputime *tot;
> +       struct signal_struct *sig;
> +       int i;
> +
> +       sig = p->signal;
> +       if (unlikely(!sig) || !sig->cputime.totals) {
> +               times->utime = p->utime;
> +               times->stime = p->stime;
> +               times->sum_exec_runtime = task_total_exec(p);
> +               return;
> +       }
> +
> +       times->stime = times->utime = cputime_zero;
> +       times->sum_exec_runtime = 0;
> +
> +       rq = task_rq_lock(p, &flags);
> +
> +       if (task_current(rq, p)) {
> +               update_rq_clock(rq);
> +               delta_exec = rq->clock - p->se.exec_start;
> +               if ((s64)delta_exec < 0)
> +                       delta_exec = 0;
> +       }
> +
> +       for_each_possible_cpu(i) {
> +               tot = per_cpu_ptr(p->signal->cputime.totals, i);
> +               times->utime = cputime_add(times->utime, tot->utime);
> +               times->stime = cputime_add(times->stime, tot->stime);
> +               times->sum_exec_runtime += tot->sum_exec_runtime;
> +       }
> +       times->sum_exec_runtime += delta_exec;
> +
> +       task_rq_unlock(rq, &flags);
> +}

Which reminds me, why do we still have this crap in the kernel? I
thought we pretty much showed the per-cpu itimer thing was utter crap?
-- can we pretty please either revert that or apply
http://lkml.org/lkml/2008/11/24/183 ?

Also, I really don't like the above, we now do the per-cpu loop with the
RQ lock held...

