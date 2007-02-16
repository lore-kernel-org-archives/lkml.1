Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbXBPQrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbXBPQrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbXBPQrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:47:41 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57869 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbXBPQrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:47:40 -0500
Date: Fri, 16 Feb 2007 22:17:30 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070216164730.GD21457@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214200904.GB301@tv-sign.ru> <20070216052626.GB8373@in.ibm.com> <20070216153321.GB83@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070216153321.GB83@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 06:33:21PM +0300, Oleg Nesterov wrote:
> I take my words back. It is not "ugly" any longer because with this change
> we don't do kthread_stop()->wakeup_process() while cwq->thread may sleep in
> work->func(). Still I don't see (ok, I am biased and probably wrong, please
> correct me) why kthread_stop+wait_to_die is better than cwq_should_stop(),
> see below.

I just like using existing code (kthread_stop) as much as possible and not add 
new code (->should_stop). Also the 'while (cwq->thread != NULL)' loop in
cleanup_workqueue_thread is not neat IMHO, compared to kthread_stop+wait_to_die.

Pls compare cleanup_workqueue_thread() in 2.6.20-mm1 and what is
proposed in the patch :-

2.6.20-mm1 (cwq->should_stop)
=============================

static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
{
        struct wq_barrier barr;
        int alive = 0;

        spin_lock_irq(&cwq->lock);
        if (cwq->thread != NULL) {
                insert_wq_barrier(cwq, &barr, 1);
                cwq->should_stop = 1;
                alive = 1;
        }
        spin_unlock_irq(&cwq->lock);

        if (alive) {
                wait_for_completion(&barr.done);

                while (unlikely(cwq->thread != NULL))
                        cpu_relax();
                /*
                 * Wait until cwq->thread unlocks cwq->lock,
                 * it won't touch *cwq after that.
                 */
                smp_rmb();
                spin_unlock_wait(&cwq->lock);
        }
}



Patch (based on kthread_should_stop)
====================================

static void cleanup_workqueue_thread(struct workqueue_struct *wq, int cpu)
{
        struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);

        if (cwq->thread != NULL) {
                kthread_stop(cwq->thread);
                cwq->thread = NULL;
        }
}


The version using kthread_should_stop() is more simple IMO.


> > I feel it is nice if the cleanup is synchronous i.e when cpu_down() is
> > complete, all the dead cpu's worker threads would have terminated.
> > Otherwise we expose races between CPU_UP_PREPARE/kthread_create and the
> > (old) thread exiting.
> 
> Please look at 2.6.20-mm1, cleanup is synchronous. Probably we misunderstood
> each other looking at different code.

Ok ..I hadnt looked at 2.6.20-mm1 (it wasnt out when we posted the
patch). Neverthless I think most of our intended changes would apply for
2.6.20-mm1 also. We will post a new version (breaking down workqueue changes
as you want) against 2.6.20-mm1.

> > How abt retaining the break above but setting cwq->thread = NULL in
> > create_workqueue_thread in failure case?
> 
> Perhaps do it, but why? The failure should be rare, and it is a bit
> dangerous to have workqueue_struct which was not properly initialized.
> Suppose we change CPU_UP_PREPARE so it is called before freeze_processes()
> stage, then we have a problem.

Ok ..no problem. Will not add the 'break' there!

> Srivatsa, don't get we wrong. I can't judge about using freezer for cpu hotplug,
> but yes, we can improve workqueue.c in this case! But this changes should be
> small and understandable. When cpu hotplug is converted, we don't need _any_
> changes in workqueue.c, it should work (except s/CPU_DEAD/CPU_DEAD_KILL_THREADS
> if you insist). 

Note with the change proposed in refrigerator, we can avoid
CPU_DEAD_KILL_THREADS and do all cleanup in CPU_DEAD itself.

> 		No more changes are required, cwq_should_stop() just works
> 		because it is more flexible than kthread_should_stop().

What is more flexible abt cwq_should_stop()?


-- 
Regards,
vatsa
