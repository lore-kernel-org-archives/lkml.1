Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZKIPqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZKIPqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbZKIPqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:46:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51366 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180AbZKIPqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:46:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd
Date: Mon, 9 Nov 2009 16:47:54 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200911091250.31626.rjw@sisk.pl> <200911091527.12249.rjw@sisk.pl> <1257777040.6365.15.camel@marge.simson.net>
In-Reply-To: <1257777040.6365.15.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091647.54171.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 November 2009, Mike Galbraith wrote:
> On Mon, 2009-11-09 at 15:27 +0100, Rafael J. Wysocki wrote:
> > On Monday 09 November 2009, Mike Galbraith wrote:
> > > On Mon, 2009-11-09 at 15:02 +0100, Thomas Gleixner wrote:
> > > > On Mon, 9 Nov 2009, Ingo Molnar wrote:
> > > > > 
> > > 
> > > > > ok, then my observation should not apply.
> > > > 
> > > > I think it _IS_ releated because the worker_thread is CPU affine and
> > > > the debug_smp_processor_id() check does:
> > > > 
> > > >     if (cpumask_equal(&current->cpus_allowed, cpumask_of(this_cpu)))
> > > > 
> > > > which prevents that usage of smp_processor_id() in ksoftirqd and
> > > > keventd in preempt enabled regions is warned on.
> > > > 
> > > > We saw exaclty the same back trace with fd21073 (sched: Fix affinity
> > > > logic in select_task_rq_fair()).
> > > > 
> > > > Rafael, can you please add a printk to debug_smp_processor_id() so we
> > > > can see on which CPU we are running ? I suspect we are on the wrong
> > > > one.
> > > 
> > > I wonder if that's not intimately related to the problem I had, namely
> > > newidle balancing offline CPUs as they're coming up, making a mess of
> > > cpu enumeration.
> > 
> > Very likely.  What did you do to fix it?
> 
> You don't really wanna know.  In 31 with newidle enabled, the below
> fixed it.  It won't fix 32, though it might cure the resume problem.

OK, I'll give it a try.

> diff --git a/kernel/sched.c b/kernel/sched.c
> index 1b59e26..6e71932 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4032,7 +4049,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  	unsigned long flags;
>  	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
>  
> -	cpumask_setall(cpus);
> +	cpumask_copy(cpus, cpu_online_mask);
>  
>  	/*
>  	 * When power savings policy is enabled for the parent domain, idle
> @@ -4195,7 +4212,7 @@ load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
>  	int all_pinned = 0;
>  	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
>  
> -	cpumask_setall(cpus);
> +	cpumask_copy(cpus, cpu_online_mask);
>  
>  	/*
>  	 * When power savings policy is enabled for the parent domain, idle

Thanks,
Rafael
