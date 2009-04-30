Return-Path: <linux-kernel-owner+w=401wt.eu-S1761641AbZD3I4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761641AbZD3I4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbZD3I4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:56:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbZD3I4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:56:02 -0400
Date: Thu, 30 Apr 2009 10:55:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu
	cputime count
Message-ID: <20090430085543.GA30495@elte.hu>
References: <20090430151008.D21C.A69D9226@jp.fujitsu.com> <20090430061806.GC4430@balbir.in.ibm.com> <1241081240.4756.38.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241081240.4756.38.camel@laptop>
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

> On Thu, 2009-04-30 at 11:48 +0530, Balbir Singh wrote:
> 
> > > Subject: [PATCH v2] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
> > > 
> > > cpuacct_update_stats() is called at every tick updating. and it use percpu_counter
> > > for avoiding performance degression.
> > > 
> > > For archs which define VIRT_CPU_ACCOUNTING, every tick would result
> > > in >1000 units of cputime updates and since this is much much greater
> > > than percpu_batch_counter, we end up taking spinlock on every tick.
> > > 
> > > This patch change batch rule. now, any cpu can store "percpu_counter_bach * jiffies"
> > > cputime in per-cpu cache.
> > > it mean this patch don't have behavior change if VIRT_CPU_ACCOUNTING=n.
> > > 
> > > Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > > Cc: Balaji Rao <balajirrao@gmail.com>
> > > Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > ---
> > >  kernel/sched.c |    8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > Index: b/kernel/sched.c
> > > ===================================================================
> > > --- a/kernel/sched.c	2009-04-30 11:37:47.000000000 +0900
> > > +++ b/kernel/sched.c	2009-04-30 14:17:00.000000000 +0900
> > > @@ -10221,6 +10221,7 @@ struct cpuacct {
> > >  };
> > > 
> > >  struct cgroup_subsys cpuacct_subsys;
> > > +static s32 cpuacct_batch;
> > > 
> > >  /* return cpu accounting group corresponding to this container */
> > >  static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
> > > @@ -10250,6 +10251,9 @@ static struct cgroup_subsys_state *cpuac
> > >  	if (!ca->cpuusage)
> > >  		goto out_free_ca;
> > > 
> > > +	if (!cpuacct_batch)
> > > +		cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> > > +
> > >  	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> > >  		if (percpu_counter_init(&ca->cpustat[i], 0))
> > >  			goto out_free_counters;
> > > @@ -10376,7 +10380,7 @@ static int cpuacct_stats_show(struct cgr
> > >  	int i;
> > > 
> > >  	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
> > > -		s64 val = percpu_counter_read(&ca->cpustat[i]);
> > > +		s64 val = percpu_counter_sum(&ca->cpustat[i]);
> > >  		val = cputime64_to_clock_t(val);
> > >  		cb->fill(cb, cpuacct_stat_desc[i], val);
> > >  	}
> > > @@ -10446,7 +10450,7 @@ static void cpuacct_update_stats(struct 
> > >  	ca = task_ca(tsk);
> > > 
> > >  	do {
> > > -		percpu_counter_add(&ca->cpustat[idx], val);
> > > +		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
> > >  		ca = ca->parent;
> > >  	} while (ca);
> > >  	rcu_read_unlock();
> > > 
> > >
> > 
> > What do the test results look like with this? I'll see if I can 
> > find some time to test this patch. On a patch read level this 
> > seems much better to me, Peter?
> 
> I don't really fancy percpu_counter_sum() usage. I'm thinking its 
> ok to degrate accuracy on larger machines and simply use 
> percpu_counter_read().

yes - and the values will converge anyway, right? So it's just a 
small delay, not even any genuine loss of accuracy.

	Ingo
