Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYHNPwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYHNPwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYHNPw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:52:27 -0400
Received: from mga10.intel.com ([192.55.52.92]:39508 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410AbYHNPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:52:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,210,1217833200"; 
   d="scan'208";a="370692185"
Date: Thu, 14 Aug 2008 08:52:41 -0700
From: mark gross <mgross@linux.intel.com>
To: John Kacur <jkacur@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, arjan <arjan@infradead.org>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Message-ID: <20080814155241.GA31050@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com> <1217921101.3589.98.camel@twins> <20080805204901.GA31132@linux.intel.com> <1217970588.29415.36.camel@lappy.programming.kicks-ass.net> <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com> <20080812224926.GA20652@linux.intel.com> <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2008 at 10:24:54AM +0200, John Kacur wrote:
> On Wed, Aug 13, 2008 at 12:49 AM, mark gross <mgross@linux.intel.com> wrote:
> > On Wed, Aug 06, 2008 at 12:18:08AM +0200, John Kacur wrote:
> >> On Tue, Aug 5, 2008 at 11:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Tue, 2008-08-05 at 13:49 -0700, mark gross wrote:
> >> >> On Tue, Aug 05, 2008 at 09:25:01AM +0200, Peter Zijlstra wrote:
> >> >> > On Mon, 2008-08-04 at 22:52 +0200, John Kacur wrote:
> >> >> > > Even after applying some fixes posted by Chirag and Peter Z, I'm still
> >> >> > > getting some messages in my log like this
> >> >> >
> >> >> > > BUG: sleeping function called from invalid context swapper(0) at
> >> >> > > kernel/rtmutex.c:743
> >> >> > > in_atomic():1 [00000001], irqs_disabled():1
> >> >> > > Pid: 0, comm: swapper Tainted: G        W 2.6.26.1-rt1.jk #2
> >> >> > >
> >> >> > > Call Trace:
> >> >> > >  [<ffffffff802305d3>] __might_sleep+0x12d/0x132
> >> >> > >  [<ffffffff8046cdbe>] __rt_spin_lock+0x34/0x7d
> >> >> > >  [<ffffffff8046ce15>] rt_spin_lock+0xe/0x10
> >> >> > >  [<ffffffff802532e5>] pm_qos_requirement+0x1f/0x3c
> >> >> > >  [<ffffffff803e1b7f>] menu_select+0x7b/0x9c
> >> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
> >> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
> >> >> > >  [<ffffffff803e0b4b>] cpuidle_idle_call+0x68/0xd8
> >> >> > >  [<ffffffff803e0ae3>] ? cpuidle_idle_call+0x0/0xd8
> >> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
> >> >> > >  [<ffffffff8020b333>] cpu_idle+0xb2/0x12d
> >> >> > >  [<ffffffff80466af0>] start_secondary+0x186/0x18b
> >> >> > >
> >> >> > > ---------------------------
> >> >> > > | preempt count: 00000001 ]

snip

> >> +     spin_unlock_irqrestore(&pm_qos_rawlock, flags);
> >>
> >>       return ret_val;
> >>  }
> >
> > As long as RAW_SPINLOCK compiles to a normal spinlock for non-RT premept
> > kernels I'm don't see a problem, as the change is almost a no-op for
> > non-RT kernels.
> 
> Correct, kernels with the rt patch that are configured to be non-rt
> change the raw_spinlock to a normal spinlock. This patch still applies
> to rt kernels only.
 
I was confused about this point, as I thought I saw raw_spinlock defined
in the mainline tree.


> >
> > Signed-off-by: mark gross <mgross@linux.intel.com>
> >
> > Should I send an updated patch that includes a change to the comment
> > block regarding the locking design after this patch or instead of it?
> >
> 
> I've updated my patch to include changes to the comment block about
> the locking design. I've also added your Signed-off-by line . (Maybe
> Acked-by: would be more appropriate?)

thanks, 

Ok, see below for Acked-by: line.

> 
> Now that I've separated locking of the target value from the other
> locks, Peter's question still remains. Could the lock protecting
> target be dropped from mainline which would allow us to drop this
> patch altogether from rt? For now the safe thing to do is keep it
> protected, but could you explain why it is needed? (it may very well
> be)
> 

This code is doing list deletions, insertions and walks / element
updates in a multi threaded environment where many processes on many
CPU's can be adding removing and updating PM_QOS request, a lot (tm).

So I think I still need to locking for the list walking and list element
updating code on face value.  I'm not supper good with lists, perhaps
there is a trick to protecting the lists better than the way I'm doing
it. 

Keeping a lock around the different "target_value"s may not be so
important.  Its just a 32bit scaler value, and perhaps we can make it an
atomic type?  That way we loose the raw_spinlock.

Acked-by: mark gross <mgross@linux.intel.com>

> Thank You.
> (updated patch attached)

> pm_qos_requirement-fix
> Add a raw_spinlock_t for target. target is modified in pm_qos_requirement
> called by idle so it cannot be allowed to sleep.
> 
> Signed-off-by: John Kacur <jkacur at gmail dot com>
> Signed-off-by: mark gross <mgross@linux.intel.com>
> 
> Index: linux-2.6.26.1-rt1.jk/kernel/pm_qos_params.c
> ===================================================================
> --- linux-2.6.26.1-rt1.jk.orig/kernel/pm_qos_params.c
> +++ linux-2.6.26.1-rt1.jk/kernel/pm_qos_params.c
> @@ -42,9 +42,10 @@
>  #include <linux/uaccess.h>
>  
>  /*
> - * locking rule: all changes to target_value or requirements or notifiers lists
> + * locking rule: all changes to requirements or notifiers lists
>   * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
> - * held, taken with _irqsave.  One lock to rule them all
> + * held, taken with _irqsave. target is locked by pm_qos_rawlock because it
> + * is modified in pm_qos_requirement called from idle and cannot sleep.

Actually, the target is only getting read by CPUIDLE from idle.  It
shouldn't get changed from the idle context.

--mgross

>   */
>  struct requirement_list {
>  	struct list_head list;
> @@ -111,6 +112,7 @@ static struct pm_qos_object *pm_qos_arra
>  };
>  
>  static DEFINE_SPINLOCK(pm_qos_lock);
> +static DEFINE_RAW_SPINLOCK(pm_qos_rawlock);
>  
>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  		size_t count, loff_t *f_pos);
> @@ -149,13 +151,15 @@ static void update_target(int target)
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
> @@ -195,9 +199,12 @@ int pm_qos_requirement(int pm_qos_class)
>  	int ret_val;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&pm_qos_lock, flags);
> +	/*
> +	 * pm_qos_requirement is called from idle, so it cannot sleep
> +	 */
> +	spin_lock_irqsave(&pm_qos_rawlock, flags);
>  	ret_val = pm_qos_array[pm_qos_class]->target_value;
> -	spin_unlock_irqrestore(&pm_qos_lock, flags);
> +	spin_unlock_irqrestore(&pm_qos_rawlock, flags);
>  
>  	return ret_val;
>  }

