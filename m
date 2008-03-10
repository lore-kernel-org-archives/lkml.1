Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbYCJOVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbYCJOVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYCJOVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:21:21 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:39030 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYCJOVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:21:21 -0400
Date: Mon, 10 Mar 2008 19:51:17 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: suresh.b.siddha@intel.com, rjw@sisk.pl, akpm@linux-foundation.org,
       dmitry.adamushko@gmail.com, mingo@elte.hu, oleg@sign.ru,
       yi.y.yang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] keep rd->online and cpu_online_map in sync
Message-ID: <20080310142117.GG17646@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080310081425.GA11031@in.ibm.com> <20080310133755.4689.83217.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310133755.4689.83217.stgit@novell1.haskins.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 09:39:34AM -0400, Gregory Haskins wrote:
> >>> On Mon, Mar 10, 2008 at  4:14 AM, in message
> <20080310081425.GA11031@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > On Sat, Mar 08, 2008 at 12:10:15AM -0500, Gregory Haskins wrote:
> 
> [ snip ]
> 
> >> @@ -5813,6 +5813,13 @@ migration_call(struct notifier_block *nfb, unsigned 
> > long action, void *hcpu)
> >>  		/* Must be high prio: stop_machine expects to yield to it. */
> >>  		rq = task_rq_lock(p, &flags);
> >>  		__setscheduler(rq, p, SCHED_FIFO, MAX_RT_PRIO-1);
> >> +
> >> +		/* Update our root-domain */
> >> +		if (rq->rd) {
> >> +			BUG_ON(!cpu_isset(cpu, rq->rd->span));
> >> +			cpu_set(cpu, rq->rd->online);
> >> +		}
> > 
> > Hi Greg,
> > 
> > Suppose someone issues a wakeup at some point between CPU_UP_PREPARE
> > and CPU_ONLINE, then isn't there a possibility that the task could
> > be woken up on the cpu which has not yet come online ?
> > Because at this point in find_lowest_cpus()
> > 
> > cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
> > 
> > the cpu which has not yet come online is set in both rd->online map
> > and the task->cpus_allowed.
> 
> Hi Gautham,
>    This is a good point.  I think I got it backwards (or rather, I had the ordering more correct before the patch):  I really want to keep the set() on ONLINE as I had it originally.  Its the clear() that is misplaced, as DOWN_PREPARE is too early in the chain.  I probably should have used DYING to defer the clear out to the point right before the cpu_online_map is updated.  Thanks to Dmitry for highlighting the smpboot path which helped me to find the proper notifier symbol. 

I think CPU_DYING is a more apt point to clear the bit.
Vatsa had infact suggested that we do it in cpu_disable(), but since we
have an event, we might as well make use of it.
> 
> > 
> > I wonder if assigning a priority to the update_sched_domains() notifier
> > so that it's called immediately after migration_call() would solve the
> > problem.
> 
> Possibly (and I just saw your patch).  But note that migration_call was previously declared as "should run first" so I am not sure if moving update_sched_domain() above it will not have a ripple effect in some other area.  If that is "ok", then I agree your solution solves the ordering problem, albeit in a bit heavy handed manner.  Otherwise s/CPU_DOWN_PREPARE/CPU_DYING in migrate call will fix the issue as well, I believe.  This will push the update of rd->online to be much more tightly coupled with updates to cpu_online_map.

The reason why migration_call() was declared as "should run first" was
to ensure that all the migration happens before the other subsystems run
their CPU_DEAD events. This is important, else when the subsystems issue
a kthread_stop(subsystem_thread) in their CPU_DEAD case, the
subsystem_thread might still be affined to the offlined cpu, thus
resulting in a deadlock.

That requirement is taken care of in the patch I had sent since
migration_call() will be called immediately after update_sched_domains().

> 
> Ingo/Andrew: Please drop the earlier fix I submitted.  I don't think it is correct on several fronts.  Please try the one below.  As before, I have tested that I can offline/online CPUs, but I dont have s2ram capability here.
> 
> Regards,
> -Greg
> 
> ---------------------------------------------
> keep rd->online and cpu_online_map in sync
> 
> It is possible to allow the root-domain cache of online cpus to
> become out of sync with the global cpu_online_map.  This is because we
> currently trigger removal of cpus too early in the notifier chain.
> Other DOWN_PREPARE handlers may in fact run and reconfigure the
> root-domain topology, thereby stomping on our own offline handling.
> 
> The end result is that rd->online may become out of sync with
> cpu_online_map, which results in potential task misrouting.
> 
> So change the offline handling to be more tightly coupled with the
> global offline process by triggering on CPU_DYING intead of
> CPU_DOWN_PREPARE.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 52b9867..a616fa1 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5881,7 +5881,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		spin_unlock_irq(&rq->lock);
>  		break;
> 
> -	case CPU_DOWN_PREPARE:
> +	case CPU_DYING:
>  		/* Update our root-domain */
>  		rq = cpu_rq(cpu);
>  		spin_lock_irqsave(&rq->lock, flags);

-- 
Thanks and Regards
gautham
