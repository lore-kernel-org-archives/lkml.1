Return-Path: <linux-kernel-owner+w=401wt.eu-S934713AbXHGRkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934713AbXHGRkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 13:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbXHGRkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 13:40:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:51013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954AbXHGRj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 13:39:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,230,1183359600"; 
   d="scan'208";a="114694571"
Date: Tue, 7 Aug 2007 10:33:36 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Paul E McKenney <paulmck@us.ibm.com>
Subject: Re: Cpu-Hotplug and Real-Time
Message-ID: <20070807173336.GA4472@linux-os.sc.intel.com>
References: <20070807131216.GA20424@in.ibm.com> <20070807151336.GA507@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070807151336.GA507@tv-sign.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 07:13:36PM +0400, Oleg Nesterov wrote:
> On 08/07, Gautham R Shenoy wrote:
> >
> > After some debugging, I saw that the hang occured because
> > the high prio process was stuck in a loop doing yield() inside
> > wait_task_inactive(). Description follows:
> > 
> > Say a high-prio task (A) does a kthread_create(B),
> > followed by a kthread_bind(B, cpu1). At this moment, 
> > only cpu0 is online.
> > 
> > Now, immediately after being created, B would
> > do a 
> > complete(&create->started) [kernel/kthread.c: kthread()], 
> > before scheduling itself out.
> > 
> > This complete() will wake up kthreadd, which had spawned B.
> > It is possible that during the wakeup, kthreadd might preempt B.
> > Thus, B is still on the runqueue, and not yet called schedule().
> > 
> > kthreadd, will inturn do a 
> > complete(&create->done); [kernel/kthread.c: create_kthread()]
> > which will wake up the thread which had called kthread_create().
> > In our case it's task A, which will run immediately, since its priority
> > is higher.
> > 
> > A will now call kthread_bind(B, cpu1).
> > kthread_bind(), calls wait_task_inactive(B), to ensures that 
> > B has scheduled itself out.
> > 
> > B is still on the runqueue, so A calls yield() in wait_task_inactive().
> > But since A is the task with the highest prio, scheduler schedules it
> > back again.
> > 
> > Thus B never gets to run to schedule itself out.
> > A loops waiting for B to schedule out leading  to system hang.
> 
> As for kthread_bind(), I think wait_task_inactive+set_task_cpu is just
> an optimization, and easy to "fix":
> 
> --- kernel/kthread.c	2007-07-28 16:58:17.000000000 +0400
> +++ /proc/self/fd/0	2007-08-07 18:56:54.248073547 +0400
> @@ -166,10 +166,7 @@ void kthread_bind(struct task_struct *k,
>  		WARN_ON(1);
>  		return;
>  	}
> -	/* Must have done schedule() in kthread() before we set_task_cpu */
> -	wait_task_inactive(k);
> -	set_task_cpu(k, cpu);
> -	k->cpus_allowed = cpumask_of_cpu(cpu);
> +	set_cpus_allowed(current, cpumask_of_cpu(cpu));
>  }
>  EXPORT_SYMBOL(kthread_bind);
> 

Not sure whether set_cpus_allowed() will work here. Looks like, it needs the
CPU to be online during the call and in kthread_bind() case CPU may be offline.

Thanks,
Venki
