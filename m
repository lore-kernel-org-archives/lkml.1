Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbXBPF0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbXBPF0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932574AbXBPF0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:26:40 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:37734 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbXBPF0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:26:39 -0500
Date: Fri, 16 Feb 2007 10:56:26 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070216052626.GB8373@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214200904.GB301@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214200904.GB301@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:09:04PM +0300, Oleg Nesterov wrote:
> What else you don't like? Why do you want to remove cwq_should_stop() and
> restore an ugly (ugly for workqueue.c) kthread_stop/kthread_should_stop() ?

What is ugly abt kthread_stop in workqueue.c?

I feel it is nice if the cleanup is synchronous i.e when cpu_down() is
complete, all the dead cpu's worker threads would have terminated.
Otherwise we expose races between CPU_UP_PREPARE/kthread_create and the
(old) thread exiting.

> We can restore take_over_works(), although I don't see why this is needed.
> But cwq_should_stop() will just work regardless, why do you want to add
> this "wait_to_die" ... well, hack :)

wait_to_die is not a new "hack"! Its already used in several other
places ..

> > -static DEFINE_MUTEX(workqueue_mutex);
> > +static DEFINE_SPINLOCK(workqueue_lock);
> 
> No. We can't do this. see below.

Ok ..

> >  struct workqueue_struct *__create_workqueue(const char *name,
> >  					    int singlethread, int freezeable)
> >  {
> > @@ -798,17 +756,20 @@ struct workqueue_struct *__create_workqu
> >  		INIT_LIST_HEAD(&wq->list);
> >  		cwq = init_cpu_workqueue(wq, singlethread_cpu);
> >  		err = create_workqueue_thread(cwq, singlethread_cpu);
> > +		if (!err)
> > +			wake_up_process(cwq->thread);
> >  	} else {
> > -		mutex_lock(&workqueue_mutex);
> > +		spin_lock(&workqueue_lock);
> >  		list_add(&wq->list, &workqueues);
> > -
> > -		for_each_possible_cpu(cpu) {
> > +		spin_unlock(&workqueue_lock);
> > +		for_each_online_cpu(cpu) {
> >  			cwq = init_cpu_workqueue(wq, cpu);
> > -			if (err || !(cpu_online(cpu) || cpu == embryonic_cpu))
> > -				continue;
> >  			err = create_workqueue_thread(cwq, cpu);
> > +			if (err)
> > +				break;
> 
> No, we can't break. We are going to execute destroy_workqueue(), it will
> iterate over all cwqs.

and try to kthread_stop() uninitialized cwq->thread?

How abt retaining the break above but setting cwq->thread = NULL in
create_workqueue_thread in failure case?

> > +static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
> > +{

<snip>

> > +}
> 
> I think this is unneeded complication, but ok, should work.

This is required if we want to stop per-cpu threads synchronously.

> > +	case CPU_DEAD:
> > +		list_for_each_entry(wq, &workqueues, list)
> > +			take_over_work(wq, hotcpu);
> > +		break;
> > +
> > +	case CPU_DEAD_KILL_THREADS:
> > +		list_for_each_entry(wq, &workqueues, list)
> > +			cleanup_workqueue_thread(wq, hotcpu);
> >  	}
> 
> Both CPU_UP_CANCELED and CPU_DEAD_KILL_THREADS runs after thaw_processes(),
> this means that workqueue_cpu_callback() is racy wrt create/destroy workqueue,
> we should take the mutex, and it can't be spinlock_t.

Ok yes ..thanks for pointing out!

-- 
Regards,
vatsa
