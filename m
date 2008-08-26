Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYHZQRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYHZQRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbYHZQRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:17:15 -0400
Received: from mga05.intel.com ([192.55.52.89]:36909 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753751AbYHZQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:17:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,271,1217833200"; 
   d="scan'208";a="373795960"
Date: Tue, 26 Aug 2008 09:18:02 -0700
From: mark gross <mgross@linux.intel.com>
To: John Kacur <jkacur@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, arjan <arjan@infradead.org>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Message-ID: <20080826161802.GB9862@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <1217970588.29415.36.camel@lappy.programming.kicks-ass.net> <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com> <20080812224926.GA20652@linux.intel.com> <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com> <20080814155241.GA31050@linux.intel.com> <1218736137.10800.234.camel@twins> <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com> <20080825163412.GA21910@linux.intel.com> <1219682129.8515.81.camel@twins> <520f0cf10808260148k47368b71he2737ea1a59bbe4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520f0cf10808260148k47368b71he2737ea1a59bbe4d@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 10:48:13AM +0200, John Kacur wrote:
> On Mon, Aug 25, 2008 at 6:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2008-08-25 at 09:34 -0700, mark gross wrote:
> >> On Fri, Aug 15, 2008 at 12:51:11AM +0200, John Kacur wrote:
> >> > On Thu, Aug 14, 2008 at 7:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > > On Thu, 2008-08-14 at 08:52 -0700, mark gross wrote:
> >> > >
> >> > >> Keeping a lock around the different "target_value"s may not be so
> >> > >> important.  Its just a 32bit scaler value, and perhaps we can make it an
> >> > >> atomic type?  That way we loose the raw_spinlock.
> >> > >
> >> > > My suggestion was to keep the locking for the write side - so as to
> >> > > avoid stuff stomping on one another, but drop the read side as:
> >> > >
> >> > >  spin_lock
> >> > >  foo = var;
> >> > >  spin_unlock
> >> > >  return foo;
> >> > >
> >> > > is kinda useless, it doesn't actually serialize against the usage of
> >> > > foo, that is, once it gets used, var might already have acquired a new
> >> > > value.
> >> > >
> >> > > The only thing it would protect is reading var, but since that is a
> >> > > machine sized read, its atomic anyway (assuming its naturally aligned).
> >> > >
> >> > > So no need for atomic_t (its read-side is just a read too), just drop
> >> > > the whole lock usage from pq_qos_requirement().
> >> > >
> >> >
> >> > Thanks Peter.
> >> >
> >> > Mark, is the following patch ok with you? This should be applied to
> >> > mainline, and then after that no special patches are necessary for
> >> > real-time.
> >>
> >> I've been thinking about this patch and I worry that the readability
> >> from making the use of this lock asymmetric WRT reads and writes to the
> >> storage address is bothersome.
> >>
> >> I would rather make the variable an atomic.  What do you think about
> >> that?
> >
> > It would make the write side more expensive, as we already have the two
> > atomic operations for the lock and unlock, this would add a third.
> >
> > Then again, I doubt that this is really a fast path.
> >
> > OTOH, a simple comment could clarify the situation for the reader.
> >
> > Up to you I guess ;-)
> >
> 
> Personally I agree with Peter, a simple comment would clarify the
> situation, it seems quite silly to me to add complexity in the name of
> symmetry. This is not my definition of readability. Never-the-less I
> offer up solution number 3 here if that would please everyone more.
> Attached is a patch that changes the target value to an atomic
> variable as suggested by Arjan. To summarize.
> 
> 3 Sol'ns - all of which solve the problem.
> 1. Add a raw spinlock around target value only. This makes the raw
> spinlock area very small, and is converted to a normal spinlock for
> non-preempt-rt.
> 2. Remove the spinlock altogether in pm_qos_requirement since the
> simple read is already atomic. Advantage - smallest patch and realtime
> doesn't require a special patch once this is included in mainline. I
> like this one the best.
> 3. make target_value atomic_t. Advantage - symmetry, some people find
> this more readable. The patch is larger than the above solution but as
> above, no special patch is required for realtime once this is included
> in mainline. Solution three is in the attached patch. Comments are
> appreciated as always.

Thank you!  FWIW I'm really on the fence between option 2 and 3.

> Remove the spinlock in pm_qos_requirement by making target_value an atomic type.
> This is necessary for real-time since pm_qos_requirement is called by idle and
> cannot be allowed to sleep.
> Signed-off-by: John Kacur <jkacur at gmail dot com>
> 
> Index: linux-2.6.26.3-rt3/kernel/pm_qos_params.c
> ===================================================================
> --- linux-2.6.26.3-rt3.orig/kernel/pm_qos_params.c
> +++ linux-2.6.26.3-rt3/kernel/pm_qos_params.c
> @@ -42,7 +42,7 @@
>  #include <linux/uaccess.h>
>  
>  /*
> - * locking rule: all changes to target_value or requirements or notifiers lists
> + * locking rule: all changes to requirements or notifiers lists
>   * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
>   * held, taken with _irqsave.  One lock to rule them all
>   */
> @@ -65,7 +65,7 @@ struct pm_qos_object {
>  	struct miscdevice pm_qos_power_miscdev;
>  	char *name;
>  	s32 default_value;
> -	s32 target_value;
> +	atomic_t target_value;
>  	s32 (*comparitor)(s32, s32);
>  };
>  
> @@ -76,7 +76,7 @@ static struct pm_qos_object cpu_dma_pm_q
>  	.notifiers = &cpu_dma_lat_notifier,
>  	.name = "cpu_dma_latency",
>  	.default_value = 2000 * USEC_PER_SEC,
> -	.target_value = 2000 * USEC_PER_SEC,
> +	.target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
>  	.comparitor = min_compare
>  };
>  
> @@ -86,7 +86,7 @@ static struct pm_qos_object network_lat_
>  	.notifiers = &network_lat_notifier,
>  	.name = "network_latency",
>  	.default_value = 2000 * USEC_PER_SEC,
> -	.target_value = 2000 * USEC_PER_SEC,
> +	.target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
>  	.comparitor = min_compare
>  };
>  
> @@ -98,7 +98,7 @@ static struct pm_qos_object network_thro
>  	.notifiers = &network_throughput_notifier,
>  	.name = "network_throughput",
>  	.default_value = 0,
> -	.target_value = 0,
> +	.target_value = ATOMIC_INIT(0),
>  	.comparitor = max_compare
>  };
>  
> @@ -149,13 +149,14 @@ static void update_target(int target)
>  		extreme_value = pm_qos_array[target]->comparitor(
>  				extreme_value, node->value);
>  	}
> -	if (pm_qos_array[target]->target_value != extreme_value) {
> +	spin_unlock_irqrestore(&pm_qos_lock, flags);
> +

do we want to move the unlock before the setting of the target_value?
This feels wrong to me, the option 2 patch didn't do this.

couldn't we have a race from 2 cpu's hitting update_target at the same
time with different values if we drop the lock before the target_value
is set?

--mgross

> +	if (atomic_read(&pm_qos_array[target]->target_value) != extreme_value) {
>  		call_notifier = 1;
> -		pm_qos_array[target]->target_value = extreme_value;
> +		atomic_set(&pm_qos_array[target]->target_value, extreme_value);
>  		pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
> -			pm_qos_array[target]->target_value);
> +			atomic_read(&pm_qos_array[target]->target_value));
>  	}
> -	spin_unlock_irqrestore(&pm_qos_lock, flags);
>  
>  	if (call_notifier)
>  		blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
> @@ -193,11 +194,8 @@ static int find_pm_qos_object_by_minor(i
>  int pm_qos_requirement(int pm_qos_class)
>  {
>  	int ret_val;
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&pm_qos_lock, flags);
> -	ret_val = pm_qos_array[pm_qos_class]->target_value;
> -	spin_unlock_irqrestore(&pm_qos_lock, flags);
> +	ret_val = atomic_read(&pm_qos_array[pm_qos_class]->target_value);
>  
>  	return ret_val;
>  }

