Return-Path: <linux-kernel-owner+w=401wt.eu-S932160AbZD1Hje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbZD1Hje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760421AbZD1Hi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:38:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50576 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031AbZD1Hiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:38:55 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Subject: Re: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime count
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       seto.hidetoshi@jp.fujitsu.com
In-Reply-To: <20090428073151.GC3825@in.ibm.com>
References: <20090428153611.EBC6.A69D9226@jp.fujitsu.com> <20090428073151.GC3825@in.ibm.com>
Message-Id: <20090428163509.EBCF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 16:38:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 28, 2009 at 03:53:32PM +0900, KOSAKI Motohiro wrote:
> > 
> > I'm not cpuacct expert. please give me comment.
> > 
> > ====================
> > Subject: [PATCH] cpuacct: VIRT_CPU_ACCOUNTING don't prevent percpu cputime caching
> > 
> > impact: little performance improvement
> > 
> > cpuacct_update_stats() is called at every tick updating. and it use percpu_counter
> > for avoiding performance degression.
> > 
> > Unfortunately, it doesn't works on VIRT_CPU_ACCOUNTING=y environment properly.
> > if VIRT_CPU_ACCOUNTING=y, every tick update much than 1000 cputime.
> > Thus every percpu_counter_add() makes spinlock grabbing and update non-percpu-variable.
> > 
> > This patch change the batch rule. now, every cpu can store "percpu_counter_bach x jiffies"
> > cputime in percpu cache.
> > it mean this patch don't have behavior change if VIRT_CPU_ACCOUNTING=n, but
> > works well on VIRT_CPU_ACCOUNTING=y too.
> 
> Let me try to understand what you are saying...
> 
> For archs which define VIRT_CPU_ACCOUNTING, every tick would result
> in around 1000 units of cputime updates and since this is much much greater
> than percpu_batch_counter, we end up taking spinlock on every tick.

Correct.

> 
> If my above reading of the problem is correct, please look at my below comments.
> 
> > Index: b/kernel/sched.c
> > ===================================================================
> > --- a/kernel/sched.c	2009-04-28 14:18:36.000000000 +0900
> > +++ b/kernel/sched.c	2009-04-28 15:18:07.000000000 +0900
> > @@ -10117,6 +10117,7 @@ struct cpuacct {
> >  };
> > 
> >  struct cgroup_subsys cpuacct_subsys;
> > +static s32 cpuacct_batch;
> > 
> >  /* return cpu accounting group corresponding to this container */
> >  static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
> > @@ -10146,6 +10147,9 @@ static struct cgroup_subsys_state *cpuac
> >  	if (!ca->cpuusage)
> >  		goto out_free_ca;
> > 
> > +	if (!cpuacct_batch)
> > +		cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
> 
> You essentially end up increasing the batch value from the default value
> of max(32, nr_cpus*2). 
> 
> > +
> >  	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
> >  		if (percpu_counter_init(&ca->cpustat[i], 0))
> >  			goto out_free_counters;
> > @@ -10342,7 +10346,7 @@ static void cpuacct_update_stats(struct 
> >  	ca = task_ca(tsk);
> > 
> >  	do {
> > -		percpu_counter_add(&ca->cpustat[idx], val);
> > +		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
> 
> And you do this unconditionally which will affect all archs ? So you make
> this behaviour default for archs which have VIRT_CPU_ACCOUNTING=n.

if VIRT_CPU_ACCOUNTING=n, jiffies_to_cputime(n) return n. 
IOW, jiffies_to_cputime() don't change value.

and percpu_counter() use percpu_counter_batch as batch.

Then, if VIRT_CPU_ACCOUNTING=n, this patch don't change behavior.



> BTW, did you observe any real problem with the percpu counter spinlock ?

No.
I review percpu_counter() caller recently and it seems stragen usage.



