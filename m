Return-Path: <linux-kernel-owner+w=401wt.eu-S1945930AbXBPPeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945930AbXBPPeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945922AbXBPPeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:34:07 -0500
Received: from mail.screens.ru ([213.234.233.54]:41996 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945930AbXBPPeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:34:05 -0500
Date: Fri, 16 Feb 2007 18:33:21 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070216153321.GB83@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214200904.GB301@tv-sign.ru> <20070216052626.GB8373@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216052626.GB8373@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Srivatsa Vaddagiri wrote:
>
> On Wed, Feb 14, 2007 at 11:09:04PM +0300, Oleg Nesterov wrote:
> > What else you don't like? Why do you want to remove cwq_should_stop() and
> > restore an ugly (ugly for workqueue.c) kthread_stop/kthread_should_stop() ?
> 
> What is ugly abt kthread_stop in workqueue.c?

I take my words back. It is not "ugly" any longer because with this change
we don't do kthread_stop()->wakeup_process() while cwq->thread may sleep in
work->func(). Still I don't see (ok, I am biased and probably wrong, please
correct me) why kthread_stop+wait_to_die is better than cwq_should_stop(),
see below.

> I feel it is nice if the cleanup is synchronous i.e when cpu_down() is
> complete, all the dead cpu's worker threads would have terminated.
> Otherwise we expose races between CPU_UP_PREPARE/kthread_create and the
> (old) thread exiting.

Please look at 2.6.20-mm1, cleanup is synchronous. Probably we misunderstood
each other looking at different code.

> > > +			if (err)
> > > +				break;
> > 
> > No, we can't break. We are going to execute destroy_workqueue(), it will
> > iterate over all cwqs.
> 
> and try to kthread_stop() uninitialized cwq->thread?
> 
> How abt retaining the break above but setting cwq->thread = NULL in
> create_workqueue_thread in failure case?

Perhaps do it, but why? The failure should be rare, and it is a bit
dangerous to have workqueue_struct which was not properly initialized.
Suppose we change CPU_UP_PREPARE so it is called before freeze_processes()
stage, then we have a problem.

> > > +static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
> > 
> > I think this is unneeded complication, but ok, should work.
> 
> This is required if we want to stop per-cpu threads synchronously.

See above.

Srivatsa, don't get we wrong. I can't judge about using freezer for cpu hotplug,
but yes, we can improve workqueue.c in this case! But this changes should be
small and understandable. When cpu hotplug is converted, we don't need _any_
changes in workqueue.c, it should work (except s/CPU_DEAD/CPU_DEAD_KILL_THREADS
if you insist). Then,

	[PATCH] make all multithread workqueus freezable

	[PATCH] remove cpu_populated_map
		just remove, very easy. Good change!

	[PATCH] restore take_over_works()
		This is not strictly needed! But ok, this can speedup cpu_down,
		and now we can't have a race with flush_worqueue (freezer).
		Just do

			case CPU_XXX:	// all tasks are frozen

			+	take_over_work(wq, hotcpu);

		No more changes are required, cwq_should_stop() just works
		because it is more flexible than kthread_should_stop().

	[PATCH] don't take workqueue_mutex in ...

	[PATCH] ...

Probably I missed something, and we should fix/improve/drop cwq_should_stop(),
but please do this in a separate patch, with a proper changelog which explains
why we are doing so.

Currently I believe that workqueue.c will need very minimal and simple changes
if we use freezer.

Oleg.

