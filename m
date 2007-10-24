Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbXJXIfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbXJXIfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 04:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbXJXIfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 04:35:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:42958 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXJXIfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 04:35:21 -0400
Date: Wed, 24 Oct 2007 14:05:14 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC PATCH 4/5] Remove CPU_DEAD/CPU_UP_CANCELLED handling from workqueue.c
Message-ID: <20071024083514.GA15451@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071024052931.GA22722@in.ibm.com> <20071024053716.GD27074@in.ibm.com> <200710241721.05163.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710241721.05163.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rusty, 
On Wed, Oct 24, 2007 at 05:21:04PM +1000, Rusty Russell wrote:
> On Wednesday 24 October 2007 15:37:16 Gautham R Shenoy wrote:
> > @@ -712,7 +712,7 @@ static void start_workqueue_thread(struc
> >
> >  	if (p != NULL) {
> >  		if (cpu >= 0)
> > -			kthread_bind(p, cpu);
> > +			set_cpus_allowed(p, cpumask_of_cpu(cpu));
> >  		wake_up_process(p);
> >  	}
> 
> Hi Gautham!
> 
> 	This works, although the change is unnecessary.  

This change was necessary because once a cpu goes offline, the worker
threads for that particular cpu, sleep with their state being
TASK_INTERRUPTIBLE. Thus, during CPU_ONLINE, when we call
start_workqueue_thread(), kthread_bind() yells since the worker thread
is not TASK_UNINTERRUPTIBLE.

Probably later on when Oleg plans to re-introduce the ->should_stop
flag, we can put the worker threads to uninterruptible sleep, and revert 
back to kthread_bind().

> If you're going to
> do this I'd prefer "if (set_cpus_allowed(p, cpumask_of_cpu(cpu)) != 0) 
> BUG();".

Not sure if this is required. set_cpus_allowed() returns a non-zero
value only if the cpumask passed doesn't intersect with the cpu-online
map. In our case, start_workqueue_thread() is called only when the cpu 
is online. i.e

a) __create_workqueue_key() calls start_workqueue_thread() with
get_online_cpus() protection only for those cpus which are online.

b) workqueue_cpu_callback() calls start_workqueue_thread() on event
of a CPU_ONLINE.

> 
> Cheers,
> Rusty.

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
