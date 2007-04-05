Return-Path: <linux-kernel-owner+w=401wt.eu-S2992617AbXDEMP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992617AbXDEMP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992698AbXDEMP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:15:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46883 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992617AbXDEMP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:15:57 -0400
Date: Thu, 5 Apr 2007 17:44:23 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 3/8] Use process freezer for cpu-hotplug
Message-ID: <20070405121423.GC16173@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402053824.GC12962@in.ibm.com> <20070405105356.GA713@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405105356.GA713@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 02:53:56PM +0400, Oleg Nesterov wrote:
> On 04/02, Gautham R Shenoy wrote:
> >
> > +	if (freeze_processes(FE_HOTPLUG_CPU)) {
> > +		thaw_processes(FE_HOTPLUG_CPU);
> > +		return -EBUSY;
> > +	}
> 
> Off-topic. This is a common pattern. Perhaps it makes sense to
> introduce a try_to_freeze_or_thaw_and_return_an_error() helper.

Not a bad idea.
> 
> > @@ -161,10 +141,13 @@ static int _cpu_down(unsigned int cpu)
> >  					    hcpu) == NOTIFY_BAD)
> >  			BUG();
> >
> > -		if (IS_ERR(p)) {
> > +		set_cpus_allowed(current, old_allowed);
> > +
> > +		if (IS_ERR(p))
> >  			err = PTR_ERR(p);
> > -			goto out_allowed;
> > -		}
> > +		else
> > +			err = kthread_stop(p);
> > +
> >  		goto out_thread;
> >  	}
> 
> Why this change? We are doing kthread_stop() + set_cpus_allowed() on
> return. Imho,
> 
> 		if (IS_ERR(p))
> 			goto out_allowed;
> 		goto out_thread;
> 
> looks a bit better. Yes we need a couple of error labels at the end.

Yes, that looks feasible and nice. But I remember making this change for
some subtle reason which I cannot recollect now.

> 
> > --- linux-2.6.21-rc5.orig/kernel/softlockup.c
> > +++ linux-2.6.21-rc5/kernel/softlockup.c
> > @@ -147,6 +147,7 @@ cpu_callback(struct notifier_block *nfb,
> >  	case CPU_DEAD:
> >  		p = per_cpu(watchdog_task, hotcpu);
> >  		per_cpu(watchdog_task, hotcpu) = NULL;
> > +		thaw_process(p);
> >  		kthread_stop(p);
> 
> As it was already discussed, this is racy. As Srivatsa (imho rightly)
> suggested, kthread_stop(p) should thaw process itself. This also allows
> us to kill at least some of wait_for_die loops.
> 

Well, in this case this is not racy. Remember, we're doing a
thaw_process(p) in CPU_DEAD where p *is* frozen for cpu hotplug. So
the where we might call a freeze_process(p) after we do a thaw_process
doesn't seem to be feasible.

But I agree, we should definitely all thaw_process within kthread_stop.

> However, the change in kthread_stop(p) in not enough to close the race.
> We can check kthread_should_stop() in refrigerator(), this looks like
> a most simple approach for now.
> 

Why the check kthread_should_stop() refrigerator() ?
As vatsa mentioned, we would be doing 

task_lock(p);
freezer_exempt(p, FE_ALL); /* Doesn't exist as of now, but we can work
				it out */
thaw_process(p);
task_unlock(p);

wait_for_completion();

So we are serializing the whole thing with task_lock() right?

> Alternatively, Srivatsa suggests to introduce a new task_lock() protected
> task_struct->freezer_state (so we can reliably set FE_ALL). Surely this is
> more poweful, but needs more changes. I am not sure. Perhaps we can do
> this later.

This needs an extra field! We're supposed to be miserly when it comes to
adding new fields to task_struct, now aren't we :-)
> 
> In any case, imho "try3" should add thaw_process() to kthread_stop().
> Gautham, Srivatsa, do you agree?
> 

Completely. Working on it now.
> Oleg.
> 

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
