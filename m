Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYHLWtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYHLWtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYHLWtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:49:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:2235 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbYHLWtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:49:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,197,1217833200"; 
   d="scan'208";a="428677090"
Date: Tue, 12 Aug 2008 15:49:26 -0700
From: mark gross <mgross@linux.intel.com>
To: John Kacur <jkacur@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, arjan <arjan@infradead.org>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Message-ID: <20080812224926.GA20652@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com> <1217921101.3589.98.camel@twins> <20080805204901.GA31132@linux.intel.com> <1217970588.29415.36.camel@lappy.programming.kicks-ass.net> <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 12:18:08AM +0200, John Kacur wrote:
> On Tue, Aug 5, 2008 at 11:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2008-08-05 at 13:49 -0700, mark gross wrote:
> >> On Tue, Aug 05, 2008 at 09:25:01AM +0200, Peter Zijlstra wrote:
> >> > On Mon, 2008-08-04 at 22:52 +0200, John Kacur wrote:
> >> > > Even after applying some fixes posted by Chirag and Peter Z, I'm still
> >> > > getting some messages in my log like this
> >> >
> >> > > BUG: sleeping function called from invalid context swapper(0) at
> >> > > kernel/rtmutex.c:743
> >> > > in_atomic():1 [00000001], irqs_disabled():1
> >> > > Pid: 0, comm: swapper Tainted: G        W 2.6.26.1-rt1.jk #2
> >> > >
> >> > > Call Trace:
> >> > >  [<ffffffff802305d3>] __might_sleep+0x12d/0x132
> >> > >  [<ffffffff8046cdbe>] __rt_spin_lock+0x34/0x7d
> >> > >  [<ffffffff8046ce15>] rt_spin_lock+0xe/0x10
> >> > >  [<ffffffff802532e5>] pm_qos_requirement+0x1f/0x3c
> >> > >  [<ffffffff803e1b7f>] menu_select+0x7b/0x9c
> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
> >> > >  [<ffffffff803e0b4b>] cpuidle_idle_call+0x68/0xd8
> >> > >  [<ffffffff803e0ae3>] ? cpuidle_idle_call+0x0/0xd8
> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
> >> > >  [<ffffffff8020b333>] cpu_idle+0xb2/0x12d
> >> > >  [<ffffffff80466af0>] start_secondary+0x186/0x18b
> >> > >
> >> > > ---------------------------
> >> > > | preempt count: 00000001 ]
> >> > > | 1-level deep critical section nesting:
> >> > > ----------------------------------------
> >> > > ... [<ffffffff8020b39c>] .... cpu_idle+0x11b/0x12d
> >> > > ......[<ffffffff80466af0>] ..   ( <= start_secondary+0x186/0x18b)
> >> > >
> >> > > The following simple patch makes the messages disappear - however,
> >> > > there may be a better more fine grained solution, but the problem is
> >> > > also that all the functions are designed to use the same lock.
> >> >
> >> > Hmm, I think you're right - its called from the idle routine so we can't
> >> > go about sleeping there.
> >> >
> >> > The only trouble I have is with kernel/pm_qos_params.c:update_target()'s
> >> > use of this lock - that is decidedly not O(1).
> >> >
> >> > Mark, would it be possible to split that lock in two, one lock
> >> > protecting pm_qos_array[], and one lock protecting the
> >> > requirements.list ?
> >>
> >> very likely, but I'm not sure how it will help.
> >>
> >> the fine grain locking I had initially worked out on pm_qos was to have
> >> a lock per pm_qos_object, that would be used for accessing the
> >> requirement_list and the target_value.  But that isn't what you are
> >> asking about is it?
> >>
> >> Is what you want is a pm_qos_requirements_list_lock and a
> >> pm_qos_target_value_lock, for each pm_qos_object instance?
> >>
> >> I guess it wold work but besides giving the code spinlock diarrhea would
> >> it really help solve the issue you are seeing?
> >
> > The problem is that on -rt spinlocks turn into mutexes. And the above
> > BUG tells us that the idle loop might end up scheduling due to trying to
> > take this lock.
> >
> > Now, the way I read the code, pm_qos_lock protects multiple things:
> >
> >  - pm_qos_array[target]->target_value
> >
> >  - &pm_qos_array[pm_qos_class]->requirements.list
> >
> > Now, the thing is, we could turn the lock back into a real spinlock
> > (raw_spinlock_t), but the loops in eg update_target() are not O(1) and
> > could thus cause serious preempt-off latencies.
> >
> > My question was, and now having had a second look at the code I think it
> > is, would it be possible to guard the list using a sleeping lock,
> > protect the target_value using a (raw) spinlock.
> >
> > OTOH, just reading a (word aligned, word sized) value doesn't normally
> > require serialization, esp if the update site is already serialized by
> > other means.
> >
> > So could we perhaps remove the lock usage from pm_qos_requirement()? -
> > that too would solve the issue.
> >
> >
> >  - Peter
> >
> 
> How about this patch? Like Peter suggests, It adds a raw spinlock only
> for the target value. I'm currently running with it, but still
> testing, comments are appreciated.
> 
> Thanks

> pm_qos_requirement-fix
> Signed-off-by: John Kacur <jkacur at gmail dot com>
> 
> Add a raw spinlock for the target value.
> 
> 
> Index: linux-2.6.26.1-rt1.jk/kernel/pm_qos_params.c
> ===================================================================
> --- linux-2.6.26.1-rt1.jk.orig/kernel/pm_qos_params.c
> +++ linux-2.6.26.1-rt1.jk/kernel/pm_qos_params.c
> @@ -111,6 +111,7 @@ static struct pm_qos_object *pm_qos_arra
>  };
>  
>  static DEFINE_SPINLOCK(pm_qos_lock);
> +static DEFINE_RAW_SPINLOCK(pm_qos_rawlock);
>  
>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  		size_t count, loff_t *f_pos);
> @@ -149,13 +150,15 @@ static void update_target(int target)
>  		extreme_value = pm_qos_array[target]->comparitor(
>  				extreme_value, node->value);
>  	}
> +	spin_unlock_irqrestore(&pm_qos_lock, flags);
> +	spin_lock_irqsave(&pm_qos_rawlock, flags);
>  	if (pm_qos_array[target]->target_value != extreme_value) {
>  		call_notifier = 1;
>  		pm_qos_array[target]->target_value = extreme_value;
>  		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
>  			pm_qos_array[target]->target_value);
>  	}
> -	spin_unlock_irqrestore(&pm_qos_lock, flags);
> +	spin_unlock_irqrestore(&pm_qos_rawlock, flags);
>  
>  	if (call_notifier)
>  		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
> @@ -195,9 +198,9 @@ int pm_qos_requirement(int pm_qos_class)
>  	int ret_val;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&pm_qos_lock, flags);
> +	spin_lock_irqsave(&pm_qos_rawlock, flags);
>  	ret_val = pm_qos_array[pm_qos_class]->target_value;
> -	spin_unlock_irqrestore(&pm_qos_lock, flags);
> +	spin_unlock_irqrestore(&pm_qos_rawlock, flags);
>  
>  	return ret_val;
>  }

As long as RAW_SPINLOCK compiles to a normal spinlock for non-RT premept
kernels I'm don't see a problem, as the change is almost a no-op for
non-RT kernels.

Signed-off-by: mark gross <mgross@linux.intel.com>

Should I send an updated patch that includes a change to the comment
block regarding the locking design after this patch or instead of it?


--gmross


