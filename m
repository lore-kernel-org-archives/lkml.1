Return-Path: <linux-kernel-owner+w=401wt.eu-S1946199AbXBPSpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946199AbXBPSpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946217AbXBPSpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:45:42 -0500
Received: from mail.screens.ru ([213.234.233.54]:35681 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946199AbXBPSpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:45:41 -0500
Date: Fri, 16 Feb 2007 21:45:17 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070216184517.GA192@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214200904.GB301@tv-sign.ru> <20070216052626.GB8373@in.ibm.com> <20070216153321.GB83@tv-sign.ru> <20070216164730.GD21457@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216164730.GD21457@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Srivatsa Vaddagiri wrote:
>
> 2.6.20-mm1 (cwq->should_stop)
> =============================
> 
> static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
> {
>         struct wq_barrier barr;
>         int alive = 0;
> 
>         spin_lock_irq(&cwq->lock);
>         if (cwq->thread != NULL) {
>                 insert_wq_barrier(cwq, &barr, 1);
>                 cwq->should_stop = 1;
>                 alive = 1;
>         }
>         spin_unlock_irq(&cwq->lock);
> 
>         if (alive) {
>                 wait_for_completion(&barr.done);
> 
>                 while (unlikely(cwq->thread != NULL))
>                         cpu_relax();
>                 /*
>                  * Wait until cwq->thread unlocks cwq->lock,
>                  * it won't touch *cwq after that.
>                  */
>                 smp_rmb();
>                 spin_unlock_wait(&cwq->lock);
>         }
> }
> 
> Patch (based on kthread_should_stop)
> ====================================
> 
> static void cleanup_workqueue_thread(struct workqueue_struct *wq, int cpu)
> {
>         struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
> 
>         if (cwq->thread != NULL) {
>                 kthread_stop(cwq->thread);
>                 cwq->thread = NULL;
>         }
> }
> 
> > 		No more changes are required, cwq_should_stop() just works
> > 		because it is more flexible than kthread_should_stop().
> 
> What is more flexible abt cwq_should_stop()?

	- it doesn't use a global semaphore

	- it works with or without freezer

	- it works with or without take_over_work()

	- it doesn't require that we have no pending works when
	  cleanup_workqueue_thread() is called.

	- worker_thread() doesn't need to have 2 different conditions
	  to exit in 2 different ways.

	- it allows us to do further improvements (don't take workqueue
	  mutex for the whole cpu-hotplug event), but this needs more work
	  and probably is not valid any longer if we use freezer.

Ok. This is a matter of taste. I will not argue if you send a patch
to convert the code to use kthread_stop() again (if it is correct :),
but let it be a separate change, please.

Oleg.

