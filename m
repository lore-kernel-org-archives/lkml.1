Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYLOIq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYLOIq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYLOIqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:46:50 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:51074 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYLOIqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:46:49 -0500
Date: Mon, 15 Dec 2008 14:16:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH v5 4/7] sched: bias task wakeups to preferred
	semi-idle packages
Message-ID: <20081215084642.GJ18403@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <peterz@infradead.org>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Suresh B Siddha <suresh.b.siddha@intel.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
	Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
	Andi Kleen <andi@firstfloor.org>,
	David Collier-Brown <davecb@sun.com>,
	Tim Connors <tconnors@astro.swin.edu.au>,
	Max Krasnyansky <maxk@qualcomm.com>,
	Gregory Haskins <gregory.haskins@gmail.com>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com> <20081211174304.2020.14746.stgit@drishya.in.ibm.com> <20081215070139.GE18403@balbir.in.ibm.com> <1229329521.14605.17.camel@twins> <1229329984.14605.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1229329984.14605.18.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2008-12-15 09:33:04]:

> On Mon, 2008-12-15 at 09:25 +0100, Peter Zijlstra wrote:
> > On Mon, 2008-12-15 at 12:31 +0530, Balbir Singh wrote:
> > 
> > > >  kernel/sched_fair.c |   17 +++++++++++++++++
> > > >  1 files changed, 17 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > > > index 98345e4..939f2a1 100644
> > > > --- a/kernel/sched_fair.c
> > > > +++ b/kernel/sched_fair.c
> > > > @@ -1027,6 +1027,23 @@ static int wake_idle(int cpu, struct task_struct *p)
> > > >  	cpumask_t tmp;
> > > >  	struct sched_domain *sd;
> > > >  	int i;
> > > > +	unsigned int chosen_wakeup_cpu;
> > > > +	int this_cpu;
> > > > +
> > > > +	/*
> > > > +	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
> > > > +	 * are idle and this is not a kernel thread and this task's affinity
> > > > +	 * allows it to be moved to preferred cpu, then just move!
> > > > +	 */
> > > > +
> > > > +	this_cpu = smp_processor_id();
> > > > +	chosen_wakeup_cpu =
> > > > +		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
> > > > +
> > > > +	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
> > > > +		idle_cpu(cpu) && idle_cpu(this_cpu) && p->mm &&
> > > 
> > > The p->mm check is racy, it needs to be done under task_lock(). The
> > > best way to check for a kernel thread is get_task_mm(), followed by
> > > put_task_mm() is the mm is not NULL. We also need to check to see if
> > > the task is _hot_ on cpu. We should negate this optimization in case
> > > chosen_wakeup_cpu is idle, so check for that as well.
> > 
> > Sure its racy, but so what?
> > 
> > The worst I can see it that we exclude a dying task from this logic,
> > which isn't a problem at all, since its dying anyway.
> 
> At which point I seriously doubt it'd still be on the rq anyway.
>

I forgot to mention that, the check should be (p->mm && !(p->flags & PF_KTHREAD))
-- 
	Balbir
