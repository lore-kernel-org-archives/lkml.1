Return-Path: <linux-kernel-owner+w=401wt.eu-S1753222AbZCHQU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbZCHQU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZCHQUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:20:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:49847 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752532AbZCHQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:20:15 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/5g7c64Zj5M1bgKYhHqxhKeMa6dXprjTjafQrRau
	cx4KPMk9naH0De
Subject: Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090308153956.GB19658@elte.hu>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 17:20:00 +0100
Message-Id: <1236529200.7110.16.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 16:39 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > The problem with your particular testcase is that while one 
> > half has an avg_overlap (what we use as affinity hint for 
> > synchronous wakeups) which triggers the affinity hint, the 
> > other half has avg_overlap of zero, what it was born with, so 
> > despite significant execution overlap, the scheduler treats 
> > them as if they were truly synchronous tasks.
> 
> hm, why does it stay on zero?

Wakeup preemption.  Presuming here: heavy task wakes light task, is
preempted, light task stuffs data into pipe, heavy task doesn't block,
so no avg_overlap is ever computed.  The heavy task uses 100% CPU.

Running as SCHED_BATCH (virgin source), it becomes sane.

pipetest (6836, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        266073.001296
se.vruntime                        :        173620.953443
se.sum_exec_runtime                :         11324.486321
se.avg_overlap                     :             1.306762
nr_switches                        :                  381
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                  379
se.load.weight                     :                 1024
policy                             :                    3
prio                               :                  120
clock-delta                        :                  109

pipetest (6837, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        266066.098182
se.vruntime                        :         51893.050177
se.sum_exec_runtime                :          2367.077751
se.avg_overlap                     :             0.077492
nr_switches                        :                  897
nr_voluntary_switches              :                  828
nr_involuntary_switches            :                   69
se.load.weight                     :                 1024
policy                             :                    3
prio                               :                  120
clock-delta                        :                  109

> >  static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
> >  {
> > +	u64 limit = sysctl_sched_migration_cost;
> > +	u64 runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
> > +
> >  	if (sleep && p->se.last_wakeup) {
> >  		update_avg(&p->se.avg_overlap,
> >  			   p->se.sum_exec_runtime - p->se.last_wakeup);
> >  		p->se.last_wakeup = 0;
> > -	}
> > +	} else if (p->se.avg_overlap < limit && runtime >= limit)
> > +		update_avg(&p->se.avg_overlap, runtime);
> >  
> >  	sched_info_dequeued(p);
> >  	p->sched_class->dequeue_task(rq, p, sleep);
> 
> hm, that's weird. We want to limit avg_overlap maintenance to 
> true sleeps only.

Except that when we stop sleeping, we're left with a stale avg_overlap.

> And this patch only makes a difference in the !sleep case - 
> which shouldnt be that common in this workload.

Hack was only to kill the stale zero.  Let's forget hack ;-)

	-Mike

